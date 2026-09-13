import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/features/billing/purchase_verifier.dart';
import 'package:life_quest_final_v2/models/cosmetic.dart';
import 'package:life_quest_final_v2/state/character_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const product = 'cosmetic_theme_neon';
  const token = 'synthetic-purchase-token-for-unit-test';
  const valid = {'isValid': true, 'entitlementId': 'theme_neon_cyberpunk'};

  test(
    'missing account, unsupported product and malformed token never reach verification',
    () async {
      var requests = 0;
      String? uid;
      final v = PurchaseVerifier(
        currentUid: () => uid,
        verify: (_) async {
          requests++;
          return valid;
        },
        deliver: (_, _) async => fail('Unexpected delivery'),
      );
      expect(await v.process(productId: product, token: token), false);
      uid = 'account-a';
      expect(
        await v.process(productId: 'arbitrary-product', token: token),
        false,
      );
      expect(await v.process(productId: product, token: 'short'), false);
      expect(requests, 0);
    },
  );

  test(
    'invalid, mismatched, and failed verification never grant in any build',
    () async {
      for (final result in [
        {},
        {'isValid': false},
        {'isValid': true, 'entitlementId': 'wrong'},
      ]) {
        final v = PurchaseVerifier(
          currentUid: () => 'account-a',
          verify: (_) async => Map<String, dynamic>.from(result),
          deliver: (_, _) async => fail('Unexpected delivery'),
        );
        expect(await v.process(productId: product, token: token), false);
      }
      final v = PurchaseVerifier(
        currentUid: () => 'account-a',
        verify: (_) async => throw StateError('Server unavailable'),
        deliver: (_, _) async => fail('Unexpected delivery'),
      );
      expect(await v.process(productId: product, token: token), false);
    },
  );

  test(
    'an account switch during verification does not deliver to the new account',
    () async {
      var uid = 'account-a';
      final response = Completer<Map<String, dynamic>>();
      final v = PurchaseVerifier(
        currentUid: () => uid,
        verify: (_) => response.future,
        deliver: (_, _) async => fail('Unexpected delivery'),
      );
      final pending = v.process(productId: product, token: token);
      uid = 'account-b';
      response.complete(valid);
      expect(await pending, false);
    },
  );

  test(
    'a verified response delivers a scoped, idempotent entitlement',
    () async {
      final owned = <String>{};
      final v = PurchaseVerifier(
        currentUid: () => 'account-a',
        verify: (request) async {
          expect(request, {
            'packageName': 'com.lifequest.app',
            'productId': product,
            'purchaseToken': token,
          });
          return valid;
        },
        deliver: (uid, entitlement) async {
          expect(uid, 'account-a');
          owned.add(entitlement);
        },
      );
      expect(await v.process(productId: product, token: token), true);
      expect(await v.process(productId: product, token: token), true);
      expect(owned, {'theme_neon_cyberpunk'});
      expect(playAccountId('account-a'), hasLength(64));
      expect(playAccountId('account-a'), isNot(playAccountId('account-b')));
    },
  );

  test('refund removes paid access but keeps cosmetics earned in the game', () {
    final state = CharacterState()..initializeForTesting();
    state.character.unlockedCosmetics.add('title_effect_sparkle');
    final beforeXp = state.character.xp;
    state.setPurchasedEntitlements({'theme_neon_cyberpunk'});
    state.equipCosmetic(CosmeticDatabase.getById('theme_neon_cyberpunk')!);
    expect(state.character.equippedTheme, 'theme_neon_cyberpunk');
    expect(
      state.character.unlockedCosmetics,
      isNot(contains('theme_neon_cyberpunk')),
    );
    state.setPurchasedEntitlements({});
    expect(state.ownsCosmetic('theme_neon_cyberpunk'), false);
    expect(state.character.equippedTheme, isNull);
    expect(state.ownsCosmetic('title_effect_sparkle'), true);
    expect(state.character.xp, beforeXp);
    state.dispose();
  });
}
