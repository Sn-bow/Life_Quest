import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Play Console IARC draft', () {
    late String draft;
    late String combatState;
    late String shopScreen;
    late String englishCopy;
    late String monetizationConfig;

    setUpAll(() {
      draft = File(
        'docs/lifequest-play-console-iarc-draft-20260605.md',
      ).readAsStringSync();
      combatState = File('lib/state/card_combat_state.dart').readAsStringSync();
      shopScreen = File('lib/screens/shop_screen.dart').readAsStringSync();
      englishCopy = File('lib/l10n/app_en.arb').readAsStringSync();
      monetizationConfig = File(
        'lib/config/monetization_config.dart',
      ).readAsStringSync();
    });

    test('discloses shipped fantasy combat instead of claiming no violence',
        () {
      expect(combatState, contains('CardEffectType.damage'));
      expect(combatState, contains('CombatPhase.defeat'));
      expect(draft, contains('Fantasy/card-battle violence'));
      expect(draft, contains('poison/burn status effects'));
      expect(draft, contains('not as no violence'));
      expect(draft, contains('No blood, gore, dismemberment'));
    });

    test('discloses randomized equipment boxes bought with game gold', () {
      expect(shopScreen, contains('shopNormalBoxName'));
      expect(shopScreen, contains('shopPremiumBoxName'));
      expect(shopScreen, contains('spendGold(100)'));
      expect(shopScreen, contains('spendGold(300)'));
      expect(englishCopy, contains('Randomly obtain Common~Rare equipment'));
      expect(englishCopy, contains('Randomly obtain Rare~Legendary equipment'));
      expect(draft, contains('Normal and Premium Equipment Boxes'));
      expect(draft, contains('spend earned in-game gold'));
      expect(draft, contains('random virtual equipment'));
      expect(draft, contains('Do not describe'));
      expect(draft, contains('no randomized rewards'));
    });

    test('keeps real-money gambling and default monetization scope accurate',
        () {
      expect(monetizationConfig, contains('LIFEQUEST_MONETIZATION_ENABLED'));
      expect(draft, contains('No real-money gambling'));
      expect(draft, contains('No active in-app purchase'));
      expect(draft, contains('cannot be bought with real money'));
      expect(draft, contains('AdMob startup and rewarded-ad UI are disabled'));
      expect(draft, contains('Google Play Billing startup'));
    });

    test('keeps private user text separate from public UGC', () {
      expect(draft, contains('private quest names'));
      expect(draft, contains('no public UGC feed'));
      expect(draft, contains('public chat'));
      expect(draft, contains('Private quest text is not published'));
      expect(draft, contains('answer "No"'));
      expect(draft, contains('default build'));
    });

    test('does not contain mojibake or inaccurate blanket claims', () {
      const forbiddenMarkers = [
        '媛',
        '怨',
        '留',
        '�',
        'The app contains no violence',
        'The app contains no random rewards',
        'The app contains paid loot boxes',
        'The app contains public user-generated content',
      ];

      for (final marker in forbiddenMarkers) {
        expect(
          draft.contains(marker),
          isFalse,
          reason: 'IARC draft contains a forbidden marker or claim: $marker',
        );
      }
    });
  });
}
