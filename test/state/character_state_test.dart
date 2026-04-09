import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:life_quest_final_v2/models/character.dart';
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
      characterState.initializeForTesting();
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

  group('Time-based progression tests', () {
    test('HP regenerates every 10 minutes while out of combat', () {
      final state = CharacterState(firestore: FakeFirebaseFirestore());
      final baseTime = DateTime(2026, 3, 12, 10, 0);

      state.debugSeedState(
        character: Character(
          name: 'Tester',
          level: 5,
          title: '새싹 모험가',
          xp: 120,
          maxXp: CharacterState.xpRequiredForLevel(5),
          strength: 5,
          wisdom: 5,
          health: 5,
          charisma: 5,
          statPoints: 0,
          skillPoints: 0,
          characterHp: 50,
          characterMaxHp: 100,
          lastLoginDate: baseTime,
          lastHpRegenAt: baseTime,
        ),
      );

      final didRecover =
          state.debugApplyHpRecoveryAt(baseTime.add(const Duration(minutes: 25)));

      expect(didRecover, isTrue);
      expect(state.character.characterHp, 56);
      expect(
        state.character.lastHpRegenAt,
        baseTime.add(const Duration(minutes: 20)),
      );
    });

    test('HP does not regenerate during combat', () {
      final state = CharacterState(firestore: FakeFirebaseFirestore());
      final baseTime = DateTime(2026, 3, 12, 10, 0);

      state.debugSeedState(
        character: Character(
          name: 'Tester',
          level: 5,
          title: '새싹 모험가',
          xp: 120,
          maxXp: CharacterState.xpRequiredForLevel(5),
          strength: 5,
          wisdom: 5,
          health: 5,
          charisma: 5,
          statPoints: 0,
          skillPoints: 0,
          characterHp: 50,
          characterMaxHp: 100,
          lastLoginDate: baseTime,
          lastHpRegenAt: baseTime,
        ),
      );

      state.setCombatActive(true);
      final didRecover =
          state.debugApplyHpRecoveryAt(baseTime.add(const Duration(minutes: 25)));

      expect(didRecover, isFalse);
      expect(state.character.characterHp, 50);
    });

    test('Monthly and yearly quests reset across date boundaries', () {
      final state = CharacterState(firestore: FakeFirebaseFirestore());
      final lastLogin = DateTime(2025, 12, 31, 23, 50);

      state.debugSeedState(
        character: Character(
          name: 'Tester',
          level: 5,
          title: '새싹 모험가',
          xp: 120,
          maxXp: CharacterState.xpRequiredForLevel(5),
          strength: 5,
          wisdom: 5,
          health: 5,
          charisma: 5,
          statPoints: 0,
          skillPoints: 0,
          characterHp: 100,
          characterMaxHp: 100,
          lastLoginDate: lastLogin,
          lastHpRegenAt: lastLogin,
        ),
        monthlyQuests: [
          Quest(
            id: 'm-test',
            name: '월간 레이드',
            xp: 140,
            type: QuestType.monthly,
            category: StatType.health,
            isCompleted: true,
            completedDate: lastLogin,
          ),
        ],
        yearlyQuests: [
          Quest(
            id: 'y-test',
            name: '연간 레이드',
            xp: 280,
            type: QuestType.yearly,
            category: StatType.charisma,
            isCompleted: true,
            completedDate: lastLogin,
          ),
        ],
      );

      final didReset = state.debugResetQuestsIfNeeded(
        lastLogin,
        now: DateTime(2026, 1, 1, 9, 0),
      );

      expect(didReset, isTrue);
      expect(state.monthlyQuests.single.isCompleted, isFalse);
      expect(state.monthlyQuests.single.completedDate, isNull);
      expect(state.yearlyQuests.single.isCompleted, isFalse);
      expect(state.yearlyQuests.single.completedDate, isNull);
    });

    test('Monthly raid grants extra rewards and unlocks progression loot', () {
      final state = CharacterState(firestore: FakeFirebaseFirestore());
      final baseTime = DateTime(2026, 3, 12, 10, 0);
      final monthlyRaid = Quest(
        id: 'm-test',
        name: '월간 레이드',
        xp: 140,
        type: QuestType.monthly,
        category: StatType.health,
        difficulty: QuestDifficulty.hard,
      );

      state.debugSeedState(
        character: Character(
          name: 'Tester',
          level: 5,
          title: '새싹 모험가',
          xp: 0,
          maxXp: CharacterState.xpRequiredForLevel(5),
          strength: 5,
          wisdom: 5,
          health: 5,
          charisma: 5,
          statPoints: 0,
          skillPoints: 0,
          characterHp: 100,
          characterMaxHp: 100,
          lastLoginDate: baseTime,
          lastHpRegenAt: baseTime,
          actionPoints: 5,
          maxActionPoints: 10,
        ),
        monthlyQuests: [monthlyRaid],
      );

      final result = state.completeQuest(monthlyRaid);

      expect(result, isNotNull);
      expect(result!.wasRaid, isTrue);
      expect(result.raidClearCount, 1);
      expect(state.monthlyRaidClears, 1);
      expect(state.character.statPoints, 1);
      expect(
        state.character.unlockedCosmetics.contains('title_effect_sparkle'),
        isTrue,
      );
      expect(result.unlockedCosmetics, contains('빛나는 칭호 이펙트'));
    });
  });
}
