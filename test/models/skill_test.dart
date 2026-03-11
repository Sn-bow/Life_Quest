import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/models/skill.dart';
import 'package:life_quest_final_v2/state/character_state.dart';

void main() {
  group('Skill Model Tests', () {
    test('Skill initializes properly', () {
      const skill = Skill(
        id: 'sk1',
        name: 'Fireball',
        description: 'Deals 30 fire damage',
        requiredLevel: 5,
        requiredStatType: StatType.wisdom,
        requiredStatValue: 15,
        effectType: SkillEffectType.combatDamage,
        effectValue: 30.0,
      );

      expect(skill.id, 'sk1');
      expect(skill.name, 'Fireball');
      expect(skill.description, 'Deals 30 fire damage');
      expect(skill.requiredLevel, 5);
      expect(skill.requiredStatType, StatType.wisdom);
      expect(skill.requiredStatValue, 15);
      expect(skill.effectType, SkillEffectType.combatDamage);
      expect(skill.effectValue, 30.0);
      expect(skill.effectTarget, isNull);
    });
  });
}
