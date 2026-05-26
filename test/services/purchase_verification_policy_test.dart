import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/services/purchase_service.dart';

void main() {
  group('PurchaseService verification policy', () {
    test('accepts unverified purchases only for debug builds', () {
      expect(
        PurchaseService.shouldAcceptUnverifiedPurchase(isDebugBuild: true),
        isTrue,
      );
      expect(
        PurchaseService.shouldAcceptUnverifiedPurchase(isDebugBuild: false),
        isFalse,
      );
    });
  });
}
