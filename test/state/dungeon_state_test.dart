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

    test('finishing a branch closes siblings and opens only its next row', () {
      final first = dungeonState.accessibleNodes.first;
      final siblings = dungeonState.accessibleNodes
          .where((n) => n.id != first.id)
          .map((n) => n.id)
          .toSet();
      expect(siblings, isNotEmpty);
      dungeonState.selectNode(first.id);
      dungeonState.completeCurrentNode();
      final open = dungeonState.accessibleNodes;
      expect(open.map((n) => n.id).toSet(), first.connectedNodeIds.toSet());
      expect(open.every((n) => n.row == first.row + 1), isTrue);
      expect(open.any((n) => siblings.contains(n.id)), isFalse);
      // A repeated completion or stale sibling tap must not advance the run.
      dungeonState.completeCurrentNode();
      dungeonState.selectNode(siblings.first);
      expect(dungeonState.currentNode, isNull);
      expect(dungeonState.nodesCompleted, 1);
    });

    test('an unfinished visit cannot jump to a different branch', () {
      final choices = dungeonState.accessibleNodes;
      final first = choices.first;
      final sibling = choices.last;
      expect(dungeonState.selectNode(first.id), isTrue);
      expect(dungeonState.selectNode(sibling.id), isFalse);
      expect(dungeonState.currentNode?.id, first.id);
      expect(dungeonState.selectNode(first.id), isTrue);
      dungeonState.endRun(victory: false);
      expect(dungeonState.selectNode(first.id), isFalse);
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

      state.resetRun();
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
