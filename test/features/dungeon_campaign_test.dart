import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_quest_final_v2/data/card_database.dart';
import 'package:life_quest_final_v2/data/dungeon_generator.dart';
import 'package:life_quest_final_v2/models/dungeon_map.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/state/dungeon_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SoundService.muteForTesting();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    '1000 generated maps have reachable supplies and no dead-end branches',
    () {
      for (var zone = 1; zone <= 5; zone++) {
        for (var seed = 0; seed < 200; seed++) {
          final map = DungeonGenerator.generate(zone: zone, seed: seed);
          final byId = {for (final node in map.nodes) node.id: node};
          expect(byId.length, map.nodes.length);
          final reached = map.accessibleNodes.map((n) => n.id).toSet();
          final queue = reached.toList();
          while (queue.isNotEmpty) {
            final node = byId[queue.removeLast()]!;
            if (node.type == NodeType.boss) {
              expect(node.connectedNodeIds, isEmpty);
            } else {
              expect(node.connectedNodeIds, isNotEmpty);
              for (final next in node.connectedNodeIds) {
                expect(byId, contains(next));
                expect(byId[next]!.row, node.row + 1);
                if (reached.add(next)) queue.add(next);
              }
            }
          }
          expect(reached, byId.keys.toSet(), reason: 'zone $zone seed $seed');
          final reachableTypes = reached.map((id) => byId[id]!.type).toSet();
          expect(
            reachableTypes,
            containsAll([NodeType.boss, NodeType.shop, NodeType.rest]),
          );
          expect(map.nodes.where((n) => n.type == NodeType.boss), hasLength(1));
        }
      }
    },
  );

  const bosses = [
    'boss_troll',
    'boss_hydra',
    'boss_dragon',
    'boss_demon_lord',
    'boss_fallen_angel',
  ];
  for (var zone = 1; zone <= 5; zone++) {
    test(
      'zone $zone resumes every room and settles the final result once',
      () async {
        var character = CharacterState();
        await character.initializeForLocalGuest(name: 'Campaign boundary test');
        DungeonState bind() => DungeonState()
          ..bindCheckpoint(
            saved: character.dungeonCheckpoint,
            save: character.saveDungeonCheckpoint,
          );
        var dungeon = bind();
        dungeon.startRun(
          zone: zone,
          startingDeck: CardDatabase.starterDeck,
          playerMaxHp: 100,
        );
        // Fix the generated route, not its rules or rewards. These are persistence
        // and navigation checks; combat outcomes are supplied, not balance proof.
        final fixture = dungeon.toJson();
        fixture['currentMap'] = DungeonGenerator.generate(
          zone: zone,
          seed: 20260920 + zone,
        ).toJson();
        dungeon.fromJson(fixture);
        for (var row = 0; row < 6; row++) {
          final node = dungeon.accessibleNodes.last;
          expect(node.row, row);
          expect(dungeon.selectNode(node.id), true);
          expect(await dungeon.flushCheckpoint(), true);
          final entrance = jsonEncode(dungeon.toJson());
          final enemyIds = dungeon
              .getEnemiesForNode(node)
              .map((e) => e.monster.id)
              .toList();
          if (node.type == NodeType.boss) expect(enemyIds, [bosses[zone - 1]]);
          // Simulate process restart from actual local profile bytes.
          dungeon.dispose();
          character.dispose();
          await (await SharedPreferences.getInstance()).reload();
          character = CharacterState();
          await character.initializeForLocalGuest(name: 'Ignored');
          dungeon = bind();
          expect(jsonEncode(dungeon.toJson()), entrance);
          expect(
            dungeon
                .getEnemiesForNode(dungeon.currentNode!)
                .map((e) => e.monster.id)
                .toList(),
            enemyIds,
          );
          dungeon.incrementMonstersKilled(enemyIds.length);
          dungeon.completeCurrentNode();
          expect(await dungeon.flushCheckpoint(), true);
          expect(dungeon.nodesCompleted, row + 1);
          expect(dungeon.currentMap!.stepCount, 6);
          expect(dungeon.currentMap!.completedStepCount, row + 1);
        }
        expect(dungeon.runPhase, RunPhase.completed);
        expect(dungeon.accessibleNodes, isEmpty);
        final run = dungeon.runId;
        await character.settleDungeonRun(dungeon);
        final awarded = jsonEncode(character.character.toJson());
        expect(character.completedZones, contains(zone));
        await character.settleDungeonRun(dungeon);
        expect(jsonEncode(character.character.toJson()), awarded);
        dungeon.dispose();
        character.dispose();
        character = CharacterState();
        await character.initializeForLocalGuest(name: 'Ignored');
        dungeon = bind();
        expect(dungeon.runId, run);
        final restored = jsonEncode(character.character.toJson());
        await character.settleDungeonRun(dungeon);
        expect(jsonEncode(character.character.toJson()), restored);
        dungeon.dispose();
        character.dispose();
      },
    );
  }
}
