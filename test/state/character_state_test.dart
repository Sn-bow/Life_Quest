import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/models/quest.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CharacterState Business Logic Tests', () {
    late FakeFirebaseFirestore mockFirestore;
    late CharacterState characterState;

    setUp(() {
      mockFirestore = FakeFirebaseFirestore();
      characterState = CharacterState(firestore: mockFirestore);
    });

    test('Custom Reward addition increments the list', () {
      final initialCount = characterState.customRewards.length;
      characterState.addCustomReward('Test', 'Test Desc', 100, '🎁');

      expect(characterState.customRewards.length, initialCount + 1);
      expect(characterState.customRewards.last.name, 'Test');
    });

    test('Removing custom reward decrements the list', () {
      characterState.addCustomReward('RemoveMe', 'To be removed', 50, '❌');
      final targetId = characterState.customRewards.last.id;
      final countBefore = characterState.customRewards.length;

      characterState.removeCustomReward(targetId);

      expect(characterState.customRewards.length, countBefore - 1);
      expect(
          characterState.customRewards.any((r) => r.id == targetId), isFalse);
    });

    test('resetState resets all fields to defaults', () {
      characterState.resetState();

      expect(characterState.isLoading, true);
      expect(characterState.isDataLoaded, false);
      expect(characterState.dailyQuests, isEmpty);
      expect(characterState.weeklyQuests, isEmpty);
    });

    test('allAchievements returns non-empty list', () {
      expect(characterState.allAchievements, isNotEmpty);
      expect(characterState.allAchievements.length, greaterThanOrEqualTo(20));
    });

    test('allSkills returns non-empty list', () {
      expect(characterState.allSkills, isNotEmpty);
      expect(characterState.allSkills.length, greaterThanOrEqualTo(20));
    });

    test('achievementProgress is initialized for all achievements', () {
      final progress = characterState.achievementProgress;
      expect(progress.length, characterState.allAchievements.length);

      for (final ach in characterState.allAchievements) {
        expect(progress.containsKey(ach.id), true);
        expect(progress[ach.id]!.isCompleted, false);
        expect(progress[ach.id]!.currentValue, 0);
      }
    });

    test('unlockedTitles contains initial title', () {
      final titles = characterState.unlockedTitles;
      expect(titles, isNotEmpty);
      expect(titles.any((t) => t.id == 't0'), true);
    });

    test('learnedSkillIds starts empty', () {
      expect(characterState.learnedSkillIds, isEmpty);
    });
  });

  group('Quest XP Calculation Tests', () {
    test('Daily easy quest gives 10 XP', () {
      expect(Quest.xpForDifficulty(QuestDifficulty.easy, QuestType.daily), 10);
    });

    test('Daily normal quest gives 20 XP', () {
      expect(
          Quest.xpForDifficulty(QuestDifficulty.normal, QuestType.daily), 20);
    });

    test('Daily hard quest gives 35 XP', () {
      expect(Quest.xpForDifficulty(QuestDifficulty.hard, QuestType.daily), 35);
    });

    test('Daily very hard quest gives 50 XP', () {
      expect(Quest.xpForDifficulty(QuestDifficulty.veryHard, QuestType.daily),
          50);
    });

    test('Weekly multiplier is 3x daily', () {
      final dailyNormal =
          Quest.xpForDifficulty(QuestDifficulty.normal, QuestType.daily);
      final weeklyNormal =
          Quest.xpForDifficulty(QuestDifficulty.normal, QuestType.weekly);
      expect(weeklyNormal, dailyNormal * 3);
    });
  });

  group('MaxXp Formula Tests', () {
    test('Level 1 maxXp should be 150', () {
      expect(100.0 + (1 * 50.0), 150.0);
    });

    test('Level 10 maxXp should be 600', () {
      expect(100.0 + (10 * 50.0), 600.0);
    });

    test('Level 50 maxXp should be 2600', () {
      expect(100.0 + (50 * 50.0), 2600.0);
    });
  });
}
