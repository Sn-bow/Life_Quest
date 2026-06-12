import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/data/core_loop_rules.dart';
import 'package:life_quest_final_v2/data/title_database.dart';
import 'package:life_quest_final_v2/models/card_data.dart';
import 'package:life_quest_final_v2/models/dungeon_event.dart';
import 'package:life_quest_final_v2/models/quest.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'dart:math' as math;

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
        shopDiscountRate: 0.08,
        restHealPercentBonus: 0.06,
      );

      expect(
        modifier.labels(),
        containsAll([
          '던전 HP +5',
          '공격 피해 +1',
          '첫 턴 카드 +1',
          '시작 골드 +3',
          '상점 할인 -8%',
          '휴식 회복 +6%',
        ]),
      );
    });

    test('card reward category weights reflect daily defense and magic bonuses',
        () {
      const modifier = DailyModifier(
        defenseCardWeightBonus: 0.10,
        magicCardWeightBonus: 0.05,
      );

      final weights = CoreLoopRules.cardRewardCategoryWeightsFor(modifier);

      expect(weights[CardCategory.defense],
          greaterThan(weights[CardCategory.attack]!));
      expect(weights[CardCategory.magic],
          greaterThan(weights[CardCategory.tactical]!));
      expect(weights[CardCategory.defense],
          greaterThan(weights[CardCategory.magic]!));
    });

    test('card reward category picker only returns available categories', () {
      final picked = CoreLoopRules.pickCardRewardCategory(
        rng: math.Random(7),
        modifier: const DailyModifier(
          defenseCardWeightBonus: 0.10,
          magicCardWeightBonus: 0.10,
        ),
        availableCategories: const [
          CardCategory.attack,
          CardCategory.magic,
        ],
      );

      expect({CardCategory.attack, CardCategory.magic}, contains(picked));
    });

    test('shop discount and rest heal helpers apply capped daily modifiers',
        () {
      const modifier = DailyModifier(
        shopDiscountRate: 0.12,
        restHealPercentBonus: 0.12,
      );

      expect(CoreLoopRules.discountedDungeonPrice(100, modifier), 88);
      expect(CoreLoopRules.restHealPercentFor(modifier), closeTo(0.42, 0.001));
    });

    test('daily modifier serialization keeps shop and rest bonuses', () {
      const modifier = DailyModifier(
        shopDiscountRate: 0.08,
        restHealPercentBonus: 0.06,
      );

      final restored = DailyModifier.fromJson(modifier.toJson());

      expect(restored.shopDiscountRate, closeTo(0.08, 0.001));
      expect(restored.restHealPercentBonus, closeTo(0.06, 0.001));
      expect(restored.hasAnyBonus, isTrue);
    });

    test('event outcome score ranks rewards above penalties', () {
      const good = EventOutcome(
        description: 'good',
        goldChange: 20,
        hpChange: 5,
        cardUpgrade: true,
      );
      const bad = EventOutcome(
        description: 'bad',
        goldChange: -20,
        hpChange: -8,
        curseAdded: true,
      );

      expect(
        CoreLoopRules.eventOutcomeScore(good),
        greaterThan(CoreLoopRules.eventOutcomeScore(bad)),
      );
    });

    test('event modifier can force the best outcome inside a choice', () {
      const bad = EventOutcome(description: 'bad', goldChange: -50);
      const good = EventOutcome(description: 'good', relicReward: true);
      const choice = EventChoice(text: 'choose', outcomes: [bad, good]);

      final picked = CoreLoopRules.pickEventOutcome(
        rng: math.Random(1),
        choice: choice,
        modifier: const DailyModifier(eventOptionBonusChance: 1),
      );

      expect(picked.description, 'good');
    });
  });
}
