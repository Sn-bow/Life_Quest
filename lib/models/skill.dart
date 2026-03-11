import 'package:life_quest_final_v2/state/character_state.dart';

enum SkillEffectType {
  xpBoost,
  spBonusOnLevelUp,
  statBoostEfficiency,
  combatDamage, // Active: deal extra damage in combat
  combatHeal, // Active: restore HP in combat
}

class Skill {
  final String id;
  final String name;
  final String description;
  final int requiredLevel;
  final StatType? requiredStatType;
  final int? requiredStatValue;
  final SkillEffectType effectType;
  final double effectValue;
  final StatType? effectTarget;

  const Skill({
    required this.id,
    required this.name,
    required this.description,
    this.requiredLevel = 1,
    this.requiredStatType,
    this.requiredStatValue,
    required this.effectType,
    required this.effectValue,
    this.effectTarget,
  });
}
