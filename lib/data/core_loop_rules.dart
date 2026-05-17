import 'dart:math' as math;

import 'package:life_quest_final_v2/models/quest.dart';
import 'package:life_quest_final_v2/models/title.dart';
import 'package:life_quest_final_v2/state/character_state.dart';

class GrowthDelta {
  final double strength;
  final double wisdom;
  final double health;
  final double charisma;
  final int xp;
  final int gold;
  final int completedCount;

  const GrowthDelta({
    this.strength = 0,
    this.wisdom = 0,
    this.health = 0,
    this.charisma = 0,
    this.xp = 0,
    this.gold = 0,
    this.completedCount = 0,
  });

  bool get isEmpty =>
      completedCount == 0 &&
      strength == 0 &&
      wisdom == 0 &&
      health == 0 &&
      charisma == 0;

  StatType? get dominantStat {
    final values = <StatType, double>{
      StatType.strength: strength,
      StatType.wisdom: wisdom,
      StatType.health: health,
      StatType.charisma: charisma,
    };
    StatType? bestType;
    double bestValue = 0;
    for (final entry in values.entries) {
      if (entry.value > bestValue) {
        bestType = entry.key;
        bestValue = entry.value;
      }
    }
    return bestType;
  }

  GrowthDelta operator +(GrowthDelta other) {
    return GrowthDelta(
      strength: strength + other.strength,
      wisdom: wisdom + other.wisdom,
      health: health + other.health,
      charisma: charisma + other.charisma,
      xp: xp + other.xp,
      gold: gold + other.gold,
      completedCount: completedCount + other.completedCount,
    );
  }
}

class DailyModifier {
  final int combatHpBonus;
  final int attackDamageBonus;
  final int firstTurnDrawBonus;
  final int startingGoldBonus;
  final double defenseCardWeightBonus;
  final double magicCardWeightBonus;
  final double eventOptionBonusChance;

  const DailyModifier({
    this.combatHpBonus = 0,
    this.attackDamageBonus = 0,
    this.firstTurnDrawBonus = 0,
    this.startingGoldBonus = 0,
    this.defenseCardWeightBonus = 0,
    this.magicCardWeightBonus = 0,
    this.eventOptionBonusChance = 0,
  });

  factory DailyModifier.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const DailyModifier();
    return DailyModifier(
      combatHpBonus: json['combatHpBonus'] as int? ?? 0,
      attackDamageBonus: json['attackDamageBonus'] as int? ?? 0,
      firstTurnDrawBonus: json['firstTurnDrawBonus'] as int? ?? 0,
      startingGoldBonus: json['startingGoldBonus'] as int? ?? 0,
      defenseCardWeightBonus:
          (json['defenseCardWeightBonus'] as num?)?.toDouble() ?? 0,
      magicCardWeightBonus:
          (json['magicCardWeightBonus'] as num?)?.toDouble() ?? 0,
      eventOptionBonusChance:
          (json['eventOptionBonusChance'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'combatHpBonus': combatHpBonus,
        'attackDamageBonus': attackDamageBonus,
        'firstTurnDrawBonus': firstTurnDrawBonus,
        'startingGoldBonus': startingGoldBonus,
        'defenseCardWeightBonus': defenseCardWeightBonus,
        'magicCardWeightBonus': magicCardWeightBonus,
        'eventOptionBonusChance': eventOptionBonusChance,
      };

  bool get hasAnyBonus =>
      combatHpBonus > 0 ||
      attackDamageBonus > 0 ||
      firstTurnDrawBonus > 0 ||
      startingGoldBonus > 0 ||
      defenseCardWeightBonus > 0 ||
      magicCardWeightBonus > 0 ||
      eventOptionBonusChance > 0;

  List<String> labels() {
    return [
      if (combatHpBonus > 0) '전투 HP +$combatHpBonus',
      if (attackDamageBonus > 0) '공격 피해 +$attackDamageBonus',
      if (firstTurnDrawBonus > 0) '첫 턴 카드 +$firstTurnDrawBonus',
      if (startingGoldBonus > 0) '시작 골드 +$startingGoldBonus',
      if (defenseCardWeightBonus > 0)
        '방어 카드 확률 +${(defenseCardWeightBonus * 100).round()}%',
      if (magicCardWeightBonus > 0)
        '마법 카드 확률 +${(magicCardWeightBonus * 100).round()}%',
      if (eventOptionBonusChance > 0)
        '이벤트 선택지 확률 +${(eventOptionBonusChance * 100).round()}%',
    ];
  }
}

class RecommendedAction {
  final Quest? quest;
  final String title;
  final String reason;

  const RecommendedAction({
    required this.quest,
    required this.title,
    required this.reason,
  });
}

class TitleProgressSnapshot {
  final GameTitle title;
  final int current;
  final int required;

  const TitleProgressSnapshot({
    required this.title,
    required this.current,
    required this.required,
  });

  int get remaining => math.max(0, required - current);

  double get ratio {
    if (required <= 0) return 1;
    return (current / required).clamp(0.0, 1.0);
  }
}

class CoreLoopRules {
  static GrowthDelta growthForQuest(Quest quest) {
    final amount = _statAmountFor(quest.difficulty) * _typeScaleFor(quest.type);
    final xp = quest.xp;
    final gold = math.max(1, (quest.xp * 0.5).round());

    switch (quest.category) {
      case StatType.strength:
        return GrowthDelta(
          strength: amount,
          health: amount * 0.3,
          xp: xp,
          gold: gold,
          completedCount: 1,
        );
      case StatType.wisdom:
        return GrowthDelta(
          wisdom: amount,
          charisma: amount * 0.2,
          xp: xp,
          gold: gold,
          completedCount: 1,
        );
      case StatType.health:
        return GrowthDelta(
          health: amount,
          strength: amount * 0.2,
          xp: xp,
          gold: gold,
          completedCount: 1,
        );
      case StatType.charisma:
        return GrowthDelta(
          charisma: amount,
          wisdom: amount * 0.2,
          xp: xp,
          gold: gold,
          completedCount: 1,
        );
    }
  }

  static GrowthDelta growthForQuests(Iterable<Quest> quests) {
    return quests.fold<GrowthDelta>(
      const GrowthDelta(),
      (total, quest) => total + growthForQuest(quest),
    );
  }

  static DailyModifier dailyModifierFor(GrowthDelta growth) {
    return DailyModifier(
      combatHpBonus: (growth.health * 12).round().clamp(0, 15),
      attackDamageBonus: (growth.strength * 2).floor().clamp(0, 3),
      firstTurnDrawBonus: growth.wisdom >= 0.4 ? 1 : 0,
      startingGoldBonus: (growth.charisma * 6).round().clamp(0, 15),
      defenseCardWeightBonus: (growth.health * 0.05).clamp(0.0, 0.10),
      magicCardWeightBonus: (growth.wisdom * 0.05).clamp(0.0, 0.10),
      eventOptionBonusChance: (growth.charisma * 0.05).clamp(0.0, 0.10),
    );
  }

  static RecommendedAction recommendAction({
    required Iterable<Quest> quests,
    required GrowthDelta todayGrowth,
  }) {
    final available = quests.where((quest) => !quest.isCompleted).toList();
    if (available.isEmpty) {
      return const RecommendedAction(
        quest: null,
        title: '오늘 퀘스트를 모두 완료했습니다',
        reason: '이제 오늘의 보정을 들고 던전에 들어가 성장 체감을 확인해보세요.',
      );
    }

    final missingStat = _lowestTodayStat(todayGrowth);
    final matching = available.where((quest) => quest.category == missingStat);
    final target = matching.isNotEmpty ? matching.first : available.first;

    return RecommendedAction(
      quest: target,
      title: target.name,
      reason: _recommendReasonFor(target.category),
    );
  }

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static double _statAmountFor(QuestDifficulty difficulty) {
    return switch (difficulty) {
      QuestDifficulty.easy => 0.2,
      QuestDifficulty.normal => 0.4,
      QuestDifficulty.hard => 0.8,
      QuestDifficulty.veryHard => 1.2,
    };
  }

  static double _typeScaleFor(QuestType type) {
    return switch (type) {
      QuestType.daily => 1.0,
      QuestType.weekly => 1.5,
      QuestType.monthly => 2.0,
      QuestType.yearly => 3.0,
    };
  }

  static StatType _lowestTodayStat(GrowthDelta growth) {
    final values = <StatType, double>{
      StatType.strength: growth.strength,
      StatType.wisdom: growth.wisdom,
      StatType.health: growth.health,
      StatType.charisma: growth.charisma,
    };
    return values.entries.reduce((a, b) => a.value <= b.value ? a : b).key;
  }

  static String _recommendReasonFor(StatType category) {
    return switch (category) {
      StatType.strength => '힘 보정이 비어 있습니다. 완료하면 공격 피해 보정에 가까워집니다.',
      StatType.wisdom => '지혜 보정이 비어 있습니다. 완료하면 첫 턴 드로우와 마법 카드 보정에 가까워집니다.',
      StatType.health => '건강 보정이 비어 있습니다. 완료하면 전투 HP와 방어 카드 보정에 가까워집니다.',
      StatType.charisma => '매력 보정이 비어 있습니다. 완료하면 이벤트 선택지와 시작 골드 보정에 가까워집니다.',
    };
  }
}
