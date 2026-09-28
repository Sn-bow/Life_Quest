import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/models/quest.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/state/dungeon_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SoundService.muteForTesting();

  test('new profiles no longer grant a card pack', () async {
    SharedPreferences.setMockInitialValues({});
    final character = CharacterState();
    await character.initializeForLocalGuest(name: 'New player');
    expect(character.cardPoints, 0);
    expect(character.cardPackCount, 0);
    character.dispose();
  });

  test(
    'quest rewards stop granting cards and packs without erasing saved game data',
    () async {
      SharedPreferences.setMockInitialValues({});
      var character = CharacterState();
      await character.initializeForLocalGuest(name: 'Returning player');
      character.character.cardPoints = 9;
      character.character.cardPackCount = 2;
      character.character.unlockedCardIds.add('atk_c02');
      character.character.unlockedCosmetics.add('combat_effect_lightning');
      character.achievementProgress['ac18']!
        ..currentValue = 1
        ..isCompleted = true;

      final dungeon = DungeonState();
      dungeon.startRun(zone: 1, startingDeck: [], playerMaxHp: 80);
      final savedRunId = dungeon.runId;
      await character.saveDungeonCheckpoint(dungeon.toJson());
      dungeon.dispose();

      character.addQuest(
        'One real action',
        20,
        QuestType.daily,
        StatType.wisdom,
      );
      final cardsBefore = List<String>.of(character.character.unlockedCardIds);
      final result = character.completeQuest(character.dailyQuests.last);
      expect(result, isNotNull);
      expect(result!.totalXpAwarded, greaterThan(0));
      expect(character.cardPoints, 9);
      expect(character.cardPackCount, 2);
      expect(character.character.unlockedCardIds, cardsBefore);
      expect(
        character.character.unlockedCosmetics,
        contains('combat_effect_lightning'),
      );
      expect(character.dungeonCheckpoint?['runId'], savedRunId);
      expect(character.achievementProgress['ac18']!.isCompleted, isTrue);
      expect(await character.forceSave(), isTrue);
      character.dispose();

      character = CharacterState();
      await character.initializeForLocalGuest(name: 'Ignored');
      expect(character.cardPoints, 9);
      expect(character.cardPackCount, 2);
      expect(character.character.unlockedCardIds, cardsBefore);
      expect(
        character.character.unlockedCosmetics,
        contains('combat_effect_lightning'),
      );
      expect(character.dungeonCheckpoint?['runId'], savedRunId);
      expect(character.achievementProgress['ac18']!.isCompleted, isTrue);
      character.dispose();
    },
  );

  test(
    'yearly real-world milestone no longer grants an unusable combat effect',
    () async {
      SharedPreferences.setMockInitialValues({});
      final character = CharacterState();
      await character.initializeForLocalGuest(name: 'Yearly player');
      character.addQuest(
        'Yearly milestone',
        100,
        QuestType.yearly,
        StatType.wisdom,
      );
      final result = character.completeQuest(character.yearlyQuests.last);
      expect(result, isNotNull);
      expect(character.yearlyRaidClears, 1);
      expect(
        character.character.unlockedCosmetics,
        isNot(contains('combat_effect_lightning')),
      );
      expect(result!.unlockedCosmetics, isEmpty);
      character.dispose();
    },
  );
}
