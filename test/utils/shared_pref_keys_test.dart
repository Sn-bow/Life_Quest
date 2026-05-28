import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/utils/shared_pref_keys.dart';

void main() {
  group('SharedPrefKeys', () {
    test('uses a stable key for the Soul Deck battle tutorial gate', () {
      expect(
        SharedPrefKeys.soulDeckBattleTutorialSeen,
        'soul_deck_battle_tutorial_seen',
      );
    });

    test('declares unique persisted setting keys', () {
      const keys = [
        SharedPrefKeys.soulDeckBattleTutorialSeen,
        SharedPrefKeys.adRemoved,
        SharedPrefKeys.adLastResetDate,
        SharedPrefKeys.adLastServerMs,
        SharedPrefKeys.adCountPrefix,
        SharedPrefKeys.soundMuted,
      ];

      expect(keys.toSet(), hasLength(keys.length));
    });
  });
}
