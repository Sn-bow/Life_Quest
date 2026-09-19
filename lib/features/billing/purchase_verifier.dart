import 'dart:convert';
import 'package:crypto/crypto.dart';

const tideProductId = 'story_tide_postoffice_01';
const saleProductIds = {tideProductId};
const bundledCosmeticProducts = {'theme_tide_postoffice': tideProductId};

const playPackageName = 'com.lifequest.app';
const playEntitlements = <String, String>{
  'remove_ads_4900': 'remove_ads',
  'cosmetic_theme_neon': 'theme_neon_cyberpunk',
  'cosmetic_theme_gold': 'theme_royal_gold',
  'cosmetic_title_fire': 'title_effect_fire',
  'cosmetic_title_sparkle': 'title_effect_sparkle',
  'cosmetic_combat_lightning': 'combat_effect_lightning',
  'story_neon_archive_01': 'story_neon_archive_01',
  tideProductId: tideProductId,
};
String playAccountId(String uid) => sha256.convert(utf8.encode(uid)).toString();

/// UI delivery follows a durable, acknowledged server grant. No debug bypass,
/// raw-token persistence or client-side acknowledgement is used on Android.
class PurchaseVerifier {
  final String? Function() currentUid;
  final Future<Map<String, dynamic>> Function(Map<String, String>) verify;
  final Future<void> Function(String uid, String entitlement) deliver;
  const PurchaseVerifier({
    required this.currentUid,
    required this.verify,
    required this.deliver,
  });

  Future<bool> process({
    required String productId,
    required String token,
  }) async {
    final uid = currentUid();
    final expected = playEntitlements[productId];
    if (uid == null ||
        expected == null ||
        token.length < 16 ||
        token.length > 4096) {
      return false;
    }
    try {
      final result = await verify({
        'packageName': playPackageName,
        'productId': productId,
        'purchaseToken': token,
      });
      if (currentUid() != uid ||
          result['isValid'] != true ||
          result['entitlementId'] != expected) {
        return false;
      }
      await deliver(uid, expected);
      return currentUid() == uid;
    } catch (_) {
      // Google/Functions errors can contain the token. Never log raw errors.
      return false;
    }
  }
}
