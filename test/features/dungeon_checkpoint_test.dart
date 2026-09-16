import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:life_quest_final_v2/data/card_database.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/state/dungeon_state.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';

class FaultStore extends InMemorySharedPreferencesStore {
  FaultStore() : super.empty();
  bool fail = false;
  final List<Map<String, dynamic>> profiles = [];
  @override
  Future<bool> setValue(String type, String key, Object value) async {
    if (key == 'flutter.${CharacterState.localProfileStorageKey}') {
      if (fail) throw StateError('Synthetic full disk');
      profiles.add(jsonDecode(value as String));
    }
    return super.setValue(type, key, value);
  }
}

Future<CharacterState> profile() async {
  final state = CharacterState();
  await state.initializeForLocalGuest(name: 'Checkpoint tester');
  return state;
}

DungeonState bind(CharacterState character) => DungeonState()
  ..bindCheckpoint(
    saved: character.dungeonCheckpoint,
    save: character.saveDungeonCheckpoint,
  );
void start(DungeonState dungeon, {int? towerFloor}) => dungeon.startRun(
  zone: 1,
  startingDeck: CardDatabase.starterDeck,
  playerMaxHp: 80,
  towerFloor: towerFloor,
  towerStatMult: towerFloor == null ? 1 : 2.25,
);
Future<CharacterState> restart(CharacterState previous) async {
  previous.dispose();
  await (await SharedPreferences.getInstance()).reload();
  return profile();
}

Object progress(CharacterState character) => {
  'xp': character.character.xp,
  'level': character.character.level,
  'gold': character.character.gold,
  'stats': character.character.statPoints,
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SoundService.muteForTesting();
  late FaultStore store;
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    store = FaultStore();
    SharedPreferencesStorePlatform.instance = store;
  });

  test('room entrance survives restart without partial victory loot', () async {
    var character = await profile();
    var dungeon = bind(character);
    start(dungeon);
    final node = dungeon.accessibleNodes.first;
    dungeon.selectNode(node.id);
    await dungeon.flushCheckpoint();
    final id = dungeon.runId;
    final before = dungeon.toJson();
    final enemies = dungeon
        .getEnemiesForNode(node)
        .map((e) => e.monster.id)
        .toList();
    // These are in-room changes. Even an unrelated profile write must not save
    // half the reward and let the same enemy pay out again on restart.
    dungeon.addGold(77);
    dungeon.addCardToDeck(CardDatabase.allCards.last);
    dungeon.setPlayerHp(23);
    await character.changeCharacterName('Still the same expedition');
    dungeon.dispose();
    character = await restart(character);
    dungeon = bind(character);
    expect(dungeon.runId, id);
    expect(dungeon.toJson(), before);
    expect(
      dungeon
          .getEnemiesForNode(dungeon.currentNode!)
          .map((e) => e.monster.id)
          .toList(),
      enemies,
    );
    dungeon.addGold(12);
    dungeon.addCardToDeck(CardDatabase.allCards.last);
    dungeon.setPlayerHp(65);
    dungeon.incrementMonstersKilled();
    dungeon.completeCurrentNode();
    dungeon.completeCurrentNode();
    await dungeon.flushCheckpoint();
    final completed = dungeon.toJson();
    dungeon.dispose();
    character = await restart(character);
    dungeon = bind(character);
    expect(dungeon.toJson(), completed);
    expect(dungeon.nodesCompleted, 1);
    expect(dungeon.monstersKilled, 1);
    expect(dungeon.dungeonGold, 62);
    character.dispose();
    dungeon.dispose();
  });

  for (final kind in ['event', 'shop', 'rest']) {
    test(
      '$kind resumes its original entrance, inventory and resources',
      () async {
        var character = await profile();
        var dungeon = bind(character);
        start(dungeon);
        await dungeon.flushCheckpoint();
        final fixture = dungeon.toJson();
        final nodes = fixture['currentMap']['nodes'] as List;
        nodes.first['type'] = kind;
        dungeon.fromJson(fixture);
        dungeon.selectNode(nodes.first['id'] as int);
        await dungeon.flushCheckpoint();
        final entrance = dungeon.toJson();
        dungeon.spendGold(20);
        dungeon.addCardToDeck(CardDatabase.allCards.last);
        dungeon.dispose();
        character = await restart(character);
        dungeon = bind(character);
        expect(dungeon.toJson(), entrance);
        expect(dungeon.selectNode(dungeon.currentNode!.id), true);
        expect(dungeon.toJson(), entrance);
        character.dispose();
        dungeon.dispose();
      },
    );
  }

  test(
    'terminal reward and receipt persist once, including level-up achievements',
    () async {
      var character = await profile();
      var dungeon = bind(character);
      start(dungeon);
      dungeon.incrementMonstersKilled(30);
      dungeon.endRun(victory: true);
      await dungeon.flushCheckpoint();
      // Simulate death of the process before opening the result screen.
      dungeon.dispose();
      character = await restart(character);
      dungeon = bind(character);
      expect(dungeon.hasResult, true);
      store.profiles.clear();
      await character.settleDungeonRun(dungeon);
      expect(store.profiles.length, 1, reason: 'No intermediate level-up save');
      expect(store.profiles.single['settledDungeonRunId'], dungeon.runId);
      expect(store.profiles.single['character']['completedZones'], contains(1));
      final awarded = progress(character);
      await character.settleDungeonRun(dungeon);
      expect(progress(character), awarded);
      dungeon.dispose();
      character = await restart(character);
      dungeon = bind(character);
      await character.settleDungeonRun(dungeon);
      expect(progress(character), awarded);
      character.dispose();
      dungeon.dispose();
    },
  );

  test(
    'failed settlement retries without double XP or partial disk receipt',
    () async {
      final character = await profile();
      final dungeon = bind(character);
      start(dungeon);
      dungeon.incrementMonstersKilled(2);
      dungeon.endRun(victory: false);
      await dungeon.flushCheckpoint();
      final diskBefore = jsonEncode(store.profiles.last);
      store.fail = true;
      await expectLater(character.settleDungeonRun(dungeon), throwsStateError);
      final awarded = progress(character);
      expect(jsonEncode(store.profiles.last), diskBefore);
      store.fail = false;
      await character.settleDungeonRun(dungeon);
      expect(progress(character), awarded);
      expect(store.profiles.last['settledDungeonRunId'], dungeon.runId);
      character.dispose();
      dungeon.dispose();
    },
  );

  test(
    'checkpoint write failure is surfaced and retry restores the full record',
    () async {
      final character = await profile();
      final dungeon = bind(character);
      store.fail = true;
      start(dungeon);
      expect(await dungeon.flushCheckpoint(), false);
      expect(dungeon.saveFailed, true);
      store.fail = false;
      expect(await dungeon.flushCheckpoint(), true);
      expect(dungeon.saveFailed, false);
      expect(store.profiles.last['dungeonCheckpoint']['runId'], dungeon.runId);
      character.dispose();
      dungeon.dispose();
    },
  );

  test(
    'new profile cannot inherit or resurrect a previous pending write',
    () async {
      final pending = Completer<void>();
      final dungeon = DungeonState()
        ..bindCheckpoint(saved: null, save: (_) => pending.future);
      start(dungeon);
      dungeon.bindCheckpoint(saved: null, save: (_) async {});
      pending.completeError(StateError('Old profile write failed'));
      await Future<void>.delayed(Duration.zero);
      expect(dungeon.hasRun, false);
      expect(dungeon.saveFailed, false);
      dungeon.dispose();
    },
  );

  test(
    'active and unclaimed runs cannot be overwritten; tower clear advances once',
    () async {
      final character = await profile();
      final dungeon = bind(character);
      start(dungeon, towerFloor: 26);
      final id = dungeon.runId;
      expect(
        dungeon.startRun(zone: 3, startingDeck: [], playerMaxHp: 99),
        false,
      );
      expect(dungeon.runId, id);
      dungeon.endRun(victory: true);
      expect(
        dungeon.startRun(zone: 3, startingDeck: [], playerMaxHp: 99),
        false,
      );
      await dungeon.flushCheckpoint();
      await character.settleDungeonRun(dungeon);
      expect(character.infiniteTowerFloor, 27);
      expect(
        character.completedZones,
        isEmpty,
        reason: 'Tower does not clear campaign zones',
      );
      dungeon.resetRun();
      await dungeon.flushCheckpoint();
      expect(character.dungeonCheckpoint, null);
      start(dungeon);
      expect(dungeon.runId, isNot(id));
      await dungeon.flushCheckpoint();
      character.dispose();
      dungeon.dispose();
    },
  );

  test(
    'corrupt checkpoint preserves the profile for explicit recovery',
    () async {
      var character = await profile();
      final data = character.exportDeviceProfile();
      data['dungeonCheckpoint'] = {'version': 999, 'runId': 'bad'};
      final raw = jsonEncode(data);
      await (await SharedPreferences.getInstance()).setString(
        CharacterState.localProfileStorageKey,
        raw,
      );
      character.dispose();
      character = CharacterState();
      await expectLater(
        character.initializeForLocalGuest(name: 'Recovery'),
        throwsFormatException,
      );
      expect(
        (await SharedPreferences.getInstance()).getString(
          CharacterState.localProfileStorageKey,
        ),
        raw,
      );
      character.dispose();
    },
  );
}
