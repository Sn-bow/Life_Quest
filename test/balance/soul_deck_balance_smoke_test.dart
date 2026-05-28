import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/data/card_database.dart';
import 'package:life_quest_final_v2/data/monster_database.dart';
import 'package:life_quest_final_v2/models/card_data.dart';
import 'package:life_quest_final_v2/state/card_combat_state.dart';

void main() {
  group('Soul Deck balance smoke', () {
    test('starter deck has a playable early-combat mix', () {
      final deck = CardDatabase.starterDeck;

      expect(deck, hasLength(10));
      expect(
        deck.where((card) => card.category == CardCategory.attack),
        hasLength(5),
      );
      expect(
        deck.where((card) => card.category == CardCategory.defense),
        hasLength(4),
      );
      expect(
        deck.where((card) => card.effects.any(
              (effect) => effect.effectType == CardEffectType.drawCard,
            )),
        hasLength(1),
      );
      expect(deck.every((card) => card.cost >= 0 && card.cost <= 1), isTrue);
      expect(_totalDamage(deck), greaterThanOrEqualTo(30));
      expect(_totalBlock(deck), greaterThanOrEqualTo(20));
    });

    test('starter deck clears every Zone 1 monster under basic play', () {
      for (final monster in MonsterDatabase.getZone1Monsters()) {
        final combat = CardCombatState();
        combat.startCombat(
          CardDatabase.starterDeck,
          [EnemyBattleData.fromMonster(monster, zone: 1)],
        );

        final result = _autoPlayUntilResolved(combat, maxTurns: 10);

        expect(
          result,
          CombatPhase.victory,
          reason:
              'Starter deck should clear ${monster.id} before turn 10; log: ${combat.combatLog.join(' | ')}',
        );
        expect(
          combat.playerHp,
          greaterThan(0),
          reason: 'Starter deck should survive ${monster.id}.',
        );
      }
    });

    test('non-curse cards stay within playable cost bounds', () {
      final nonCurseCards =
          CardDatabase.allCards.where((card) => !card.id.startsWith('curse_'));

      expect(nonCurseCards, isNotEmpty);
      for (final card in nonCurseCards) {
        expect(
          card.cost,
          inInclusiveRange(0, 5),
          reason: '${card.id} has an out-of-band combat cost.',
        );
        expect(
          card.effects,
          isNotEmpty,
          reason: '${card.id} must have at least one gameplay effect.',
        );
      }
    });
  });
}

CombatPhase _autoPlayUntilResolved(
  CardCombatState combat, {
  required int maxTurns,
}) {
  for (var turn = 0; turn < maxTurns; turn++) {
    if (combat.phase != CombatPhase.playerTurn) return combat.phase;
    _forceBasicAttackIntent(combat);

    while (combat.phase == CombatPhase.playerTurn) {
      final cardIndex = _choosePlayableCard(combat);
      if (cardIndex == null) break;
      combat.playCard(cardIndex);
    }

    if (combat.phase != CombatPhase.playerTurn) return combat.phase;
    combat.endTurn();
  }
  return combat.phase;
}

int? _choosePlayableCard(CardCombatState combat) {
  final hand = combat.hand;
  final energy = combat.currentEnergy;
  final enemyAttack = _currentIncomingDamage(combat);

  final attackIndex = hand.indexWhere(
    (card) =>
        card.cost <= energy &&
        (card.category == CardCategory.attack ||
            card.effects.any((effect) =>
                effect.effectType == CardEffectType.damage ||
                effect.effectType == CardEffectType.aoe)),
  );
  if (attackIndex != -1) return attackIndex;

  if (combat.playerBlock < enemyAttack) {
    final defenseIndex = hand.indexWhere(
      (card) =>
          card.cost <= energy &&
          card.effects.any(
            (effect) => effect.effectType == CardEffectType.block,
          ),
    );
    if (defenseIndex != -1) return defenseIndex;
  }

  final drawIndex = hand.indexWhere(
    (card) =>
        card.cost <= energy &&
        card.effects.any(
          (effect) => effect.effectType == CardEffectType.drawCard,
        ),
  );
  if (drawIndex != -1) return drawIndex;

  final fallbackIndex = hand.indexWhere((card) => card.cost <= energy);
  return fallbackIndex == -1 ? null : fallbackIndex;
}

void _forceBasicAttackIntent(CardCombatState combat) {
  if (combat.enemies.isEmpty) return;
  final enemy = combat.enemies.first;
  enemy.currentIntent = EnemyIntent(
    type: EnemyIntentType.attack,
    value: enemy.monster.attack.round(),
  );
}

int _currentIncomingDamage(CardCombatState combat) {
  if (combat.enemies.isEmpty) return 0;
  final intent = combat.enemies.first.currentIntent;
  return switch (intent.type) {
    EnemyIntentType.attack => intent.value,
    EnemyIntentType.multiAttack => intent.value * intent.hits,
    _ => 0,
  };
}

int _totalDamage(List<CardData> deck) {
  return deck.fold(0, (total, card) {
    return total +
        card.effects
            .where((effect) =>
                effect.effectType == CardEffectType.damage ||
                effect.effectType == CardEffectType.aoe)
            .fold(0, (sum, effect) => sum + effect.value);
  });
}

int _totalBlock(List<CardData> deck) {
  return deck.fold(0, (total, card) {
    return total +
        card.effects
            .where((effect) => effect.effectType == CardEffectType.block)
            .fold(0, (sum, effect) => sum + effect.value);
  });
}
