import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/data/core_loop_rules.dart';
import 'package:life_quest_final_v2/data/title_database.dart';
import 'package:life_quest_final_v2/models/quest.dart';
import 'package:life_quest_final_v2/state/character_state.dart';

void main() {
  group('CoreLoopRules', () {
    test('strength quest creates strength growth and attack modifier', () {
      final quest = Quest(
        id: 'q1',
        name: '운동 30분',
        xp: 20,
        type: QuestType.daily,
        category: StatType.strength,
        difficulty: QuestDifficulty.normal,
      );

      final growth = CoreLoopRules.growthForQuest(quest);
      final modifier = CoreLoopRules.dailyModifierFor(growth);

      expect(growth.strength, closeTo(0.4, 0.001));
      expect(growth.health, closeTo(0.12, 0.001));
      expect(growth.xp, 20);
      expect(growth.gold, 10);
      expect(modifier.attackDamageBonus, 0);
      expect(modifier.combatHpBonus, 1);
    });

    test('wisdom quest opens first-turn draw and magic weight preview', () {
      final quest = Quest(
        id: 'q2',
        name: '책 읽기',
        xp: 20,
        type: QuestType.daily,
        category: StatType.wisdom,
        difficulty: QuestDifficulty.normal,
      );

      final growth = CoreLoopRules.growthForQuest(quest);
      final modifier = CoreLoopRules.dailyModifierFor(growth);

      expect(growth.wisdom, closeTo(0.4, 0.001));
      expect(modifier.firstTurnDrawBonus, 1);
      expect(modifier.magicCardWeightBonus, greaterThan(0));
    });

    test('daily modifiers are capped to keep dungeon balance stable', () {
      final growth = CoreLoopRules.growthForQuests([
        Quest(
          id: 'h1',
          name: '긴 운동',
          xp: 50,
          type: QuestType.yearly,
          category: StatType.health,
          difficulty: QuestDifficulty.veryHard,
        ),
        Quest(
          id: 'h2',
          name: '추가 운동',
          xp: 50,
          type: QuestType.yearly,
          category: StatType.health,
          difficulty: QuestDifficulty.veryHard,
        ),
      ]);

      final modifier = CoreLoopRules.dailyModifierFor(growth);

      expect(modifier.combatHpBonus, 15);
      expect(modifier.defenseCardWeightBonus, 0.10);
    });

    test('recommendation targets a category with missing daily growth', () {
      final growth = CoreLoopRules.growthForQuest(
        Quest(
          id: 'done',
          name: '운동',
          xp: 20,
          type: QuestType.daily,
          category: StatType.strength,
        ),
      );
      final recommendation = CoreLoopRules.recommendAction(
        todayGrowth: growth,
        quests: [
          Quest(
            id: 'w',
            name: '독서',
            xp: 20,
            type: QuestType.daily,
            category: StatType.wisdom,
          ),
          Quest(
            id: 's',
            name: '운동',
            xp: 20,
            type: QuestType.daily,
            category: StatType.strength,
          ),
        ],
      );

      expect(recommendation.quest?.id, 'w');
      expect(recommendation.reason, contains('학습/분석'));
    });

    test('recommendation prioritizes a quest that advances the next title', () {
      final wisdomTitle =
          TitleDatabase.all.firstWhere((title) => title.id == 't4');
      final recommendation = CoreLoopRules.recommendAction(
        todayGrowth: const GrowthDelta(),
        nextTitleProgress: TitleProgressSnapshot(
          title: wisdomTitle,
          current: 10,
          required: wisdomTitle.conditionValue,
        ),
        quests: [
          Quest(
            id: 's',
            name: '운동',
            xp: 20,
            type: QuestType.daily,
            category: StatType.strength,
          ),
          Quest(
            id: 'w',
            name: '독서',
            xp: 20,
            type: QuestType.daily,
            category: StatType.wisdom,
          ),
        ],
      );

      expect(recommendation.quest?.id, 'w');
      expect(recommendation.reason, contains('현자 지망생'));
    });

    test('labels use readable Korean status-board copy', () {
      const modifier = DailyModifier(
        combatHpBonus: 5,
        attackDamageBonus: 1,
        firstTurnDrawBonus: 1,
        startingGoldBonus: 3,
      );

      expect(
        modifier.labels(),
        containsAll(['던전 HP +5', '공격 피해 +1', '첫 턴 카드 +1', '시작 골드 +3']),
      );
    });
  });
}
