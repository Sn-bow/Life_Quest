import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/data/core_loop_rules.dart';
import 'package:life_quest_final_v2/models/card_data.dart';
import 'package:life_quest_final_v2/models/monster.dart';
import 'package:life_quest_final_v2/state/card_combat_state.dart';

void main() {
  group('CardCombatState daily modifiers', () {
    CardData attackCard() => const CardData(
          id: 'test_attack',
          name: 'Test Attack',
          category: CardCategory.attack,
          cost: 1,
          description: 'Deal damage.',
          effects: [
            CardEffect(
              effectType: CardEffectType.damage,
              value: 1,
            ),
          ],
        );

    EnemyBattleData enemy() => EnemyBattleData(
          monster: Monster(
            id: 'dummy',
            name: 'Dummy',
            level: 1,
            maxHp: 20,
            attack: 0,
            defense: 0,
            xpReward: 1,
          ),
          maxHp: 20,
        );

    test('first-turn draw bonus increases opening hand size', () {
      final state = CardCombatState();
      final deck = List<CardData>.generate(8, (_) => attackCard());

      state.startCombat(
        deck,
        [enemy()],
        dailyModifier: const DailyModifier(firstTurnDrawBonus: 1),
      );

      expect(state.hand.length, 6);
    });

    test('attack damage bonus is applied to card damage', () {
      final state = CardCombatState();

      state.startCombat(
        [attackCard()],
        [enemy()],
        dailyModifier: const DailyModifier(attackDamageBonus: 2),
      );

      state.playCard(0);

      expect(state.enemies.first.currentHp, 17);
    });
  });
}
