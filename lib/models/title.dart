import 'package:life_quest_final_v2/state/character_state.dart';

enum TitleConditionType {
  level,
  strength,
  wisdom,
  health,
  charisma,
  questsCompleted,
  allStats,
}

class GameTitle {
  final String id;
  final String name;
  final String description;
  final TitleConditionType conditionType;
  final int conditionValue;
  final StatType? bonusType;
  final double? bonusValue;

  const GameTitle({
    required this.id,
    required this.name,
    required this.description,
    required this.conditionType,
    required this.conditionValue,
    this.bonusType,
    this.bonusValue,
  });
}
