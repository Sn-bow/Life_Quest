import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/models/character.dart';
import 'package:life_quest_final_v2/models/quest.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/state/character_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SoundService.muteForTesting();

  test('today adventure summary uses quests completed today only', () {
    final state = CharacterState(firestore: FakeFirebaseFirestore());
    final now = DateTime.now();

    state.debugSeedState(
      character: Character(
        name: 'Tester',
        level: 1,
        title: '새싹 모험가',
        xp: 0,
        maxXp: CharacterState.xpRequiredForLevel(1),
        strength: 1,
        wisdom: 1,
        health: 1,
        charisma: 1,
        statPoints: 0,
        skillPoints: 0,
        characterHp: 100,
        characterMaxHp: 100,
        lastLoginDate: now,
        lastHpRegenAt: now,
      ),
      dailyQuests: [
        Quest(
          id: 'today',
          name: 'today health',
          xp: 20,
          type: QuestType.daily,
          category: StatType.health,
          isCompleted: true,
          completedDate: now,
        ),
        Quest(
          id: 'old',
          name: 'old wisdom',
          xp: 20,
          type: QuestType.daily,
          category: StatType.wisdom,
          isCompleted: true,
          completedDate: now.subtract(const Duration(days: 1)),
        ),
      ],
    );

    expect(state.todayCompletedQuests.map((q) => q.id), ['today']);
    expect(state.todayGrowthDelta.completedCount, 1);
    expect(state.todayGrowthDelta.health, closeTo(0.4, 0.001));
    expect(state.todayDailyModifier.combatHpBonus, greaterThan(0));
  });
}
