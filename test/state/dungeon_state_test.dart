import 'package:flutter_test/flutter_test.dart';
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
  });
}
