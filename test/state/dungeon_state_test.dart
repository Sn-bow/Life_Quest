import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/data/core_loop_rules.dart';
import 'package:life_quest_final_v2/models/card_data.dart';
import 'package:life_quest_final_v2/state/dungeon_state.dart';

void main() {
  group('DungeonState reward calculation', () {
    late DungeonState dungeonState;

    setUp(() {
      dungeonState = DungeonState();
      dungeonState.startRun(
        zone: 1,
        startingDeck: const <CardData>[],
        playerMaxHp: 80,
      );
    });

    test('failed run without progress grants no rewards', () {
      dungeonState.endRun(victory: false);

      final rewards = dungeonState.calculateRunRewards();

      expect(rewards['xp'], 0);
      expect(rewards['gold'], 0);
      expect(rewards['isVictory'], false);
    });

    test('failed run only rewards earned combat progress', () {
      dungeonState.incrementMonstersKilled();
      dungeonState.endRun(victory: false);

      final rewards = dungeonState.calculateRunRewards();

      expect(rewards['xp'], 10);
      expect(rewards['gold'], 8);
      expect(rewards['isVictory'], false);
    });

    test('victory keeps zone completion bonus rewards', () {
      dungeonState.endRun(victory: true);

      final rewards = dungeonState.calculateRunRewards();

      expect(rewards['xp'], 175);
      expect(rewards['gold'], 45);
      expect(rewards['isVictory'], true);
    });

    test('daily modifier applies starting HP and gold to the run snapshot', () {
      final modified = DungeonState()
        ..startRun(
          zone: 1,
          startingDeck: const <CardData>[],
          playerMaxHp: 80,
          startingGold: 50,
          dailyModifier: const DailyModifier(
            combatHpBonus: 12,
            startingGoldBonus: 7,
          ),
        );

      expect(modified.playerMaxHp, 92);
      expect(modified.playerHp, 92);
      expect(modified.dungeonGold, 57);
      expect(modified.dailyModifier.combatHpBonus, 12);
    });

    test('daily modifier is fixed for a run and changes on next start', () {
      final state = DungeonState()
        ..startRun(
          zone: 1,
          startingDeck: const <CardData>[],
          playerMaxHp: 80,
          dailyModifier: const DailyModifier(combatHpBonus: 5),
        );

      expect(state.playerMaxHp, 85);
      expect(state.dailyModifier.combatHpBonus, 5);

      const nextModifier = DailyModifier(combatHpBonus: 14);
      expect(nextModifier.combatHpBonus, 14);
      expect(state.playerMaxHp, 85);
      expect(state.dailyModifier.combatHpBonus, 5);

      state.startRun(
        zone: 1,
        startingDeck: const <CardData>[],
        playerMaxHp: 80,
        dailyModifier: nextModifier,
      );

      expect(state.playerMaxHp, 94);
      expect(state.dailyModifier.combatHpBonus, 14);
    });
  });
}
