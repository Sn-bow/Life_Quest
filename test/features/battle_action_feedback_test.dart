import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/models/card_data.dart';
import 'package:life_quest_final_v2/models/monster.dart';
import 'package:life_quest_final_v2/state/card_combat_state.dart';
import 'package:life_quest_final_v2/screens/dungeon/card_battle_screen.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';

CardData card(String id, int cost) => CardData(
  id: id,
  name: id,
  category: CardCategory.attack,
  cost: cost,
  description: 'Synthetic card',
  effects: const [],
);

CardCombatState encounter() => CardCombatState()
  ..startCombat(
    [card('paid', 3), card('free', 0), card('curse', -1)],
    [
      EnemyBattleData(
        monster: Monster(
          id: 'dummy',
          name: 'Dummy',
          level: 1,
          maxHp: 100,
          attack: 0,
          defense: 0,
          xpReward: 0,
        ),
        maxHp: 100,
      ),
    ],
  );

void main() {
  test('zero-cost action remains playable after all energy is spent', () {
    final state = encounter();
    expect(state.playableCardCount, 2);
    state.playCard(state.hand.indexWhere((c) => c.id == 'paid'));
    expect(state.currentEnergy, 0);
    expect(state.playableCardCount, 1);
    final free = state.hand.indexWhere((c) => c.id == 'free');
    expect(state.canPlayCard(free), isTrue);
    state.playCard(free);
    expect(state.currentEnergy, 0);
    expect(state.hand.map((c) => c.id), ['curse']);
    expect(state.playableCardCount, 0);
    state.dispose();
  });

  test('curse and invalid indices cannot be advertised or consume energy', () {
    final state = encounter();
    final curse = state.hand.indexWhere((c) => c.id == 'curse');
    expect(state.canPlayCard(curse), isFalse);
    expect(state.canPlayCard(-1), isFalse);
    expect(state.canPlayCard(99), isFalse);
    state.playCard(curse);
    expect(state.currentEnergy, 3);
    expect(state.hand.length, 3);
    state.dispose();
  });

  for (final code in ['ko', 'en', 'ja', 'zh']) {
    testWidgets('badge prioritizes a real zero-cost action in $code', (
      tester,
    ) async {
      final state = encounter();
      state.playCard(state.hand.indexWhere((c) => c.id == 'paid'));
      await tester.pumpWidget(
        MaterialApp(
          locale: Locale(code),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: PlayableCardsBadge(
              playableCount: state.playableCardCount,
              currentEnergy: state.currentEnergy,
              isDark: true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final l = AppLocalizations.of(
        tester.element(find.byType(PlayableCardsBadge)),
      )!;
      expect(find.text(l.cardBattlePlayableCount(1)), findsOneWidget);
      expect(find.text(l.cardBattleEpEmpty), findsNothing);
      expect(tester.takeException(), isNull);
      state.dispose();
    });
  }
}
