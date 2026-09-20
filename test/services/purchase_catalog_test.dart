import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:life_quest_final_v2/config/cloud_config.dart';
import 'package:life_quest_final_v2/config/monetization_config.dart';
import 'package:life_quest_final_v2/features/billing/purchase_verifier.dart';
import 'package:life_quest_final_v2/services/purchase_service.dart';

class CatalogPlatform extends InAppPurchasePlatform {
  bool failAvailability = true;
  bool queryError = false;
  int queries = 0;
  Completer<void>? pause;
  final updates = StreamController<List<PurchaseDetails>>.broadcast();
  @override
  Stream<List<PurchaseDetails>> get purchaseStream => updates.stream;
  @override
  Future<bool> isAvailable() async {
    if (failAvailability) throw StateError('Synthetic Play outage');
    return true;
  }

  @override
  Future<ProductDetailsResponse> queryProductDetails(
    Set<String> identifiers,
  ) async {
    queries++;
    expect(identifiers, {tideProductId});
    await pause?.future;
    return ProductDetailsResponse(
      productDetails: [
        for (final id in [tideProductId, 'cosmetic_theme_neon'])
          ProductDetails(
            id: id,
            title: 'Synthetic $id',
            description: 'Test catalog only',
            price: '₩6,900',
            rawPrice: 6900,
            currencyCode: 'KRW',
          ),
      ],
      notFoundIDs: [],
      error: queryError
          ? IAPError(source: 'test', code: 'unavailable', message: 'Synthetic')
          : null,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'Play catalog outage, retry, unexpected SKU and concurrent refresh',
    () async {
      // This file is run separately with the real feature gates enabled. Only the
      // platform boundary is fake; no production purchase/ownership bypass exists.
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      InAppPurchase.instance; // Initialize before installing the fake platform.
      final platform = CatalogPlatform();
      InAppPurchasePlatform.instance = platform;
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final service = PurchaseService();
      try {
        await service.init();
        expect(service.products, isEmpty);
        expect(service.checkingStore, false);
        platform.failAvailability = false;
        platform.queryError = true;
        await service.refreshCatalog();
        expect(
          service.products,
          isEmpty,
        ); // Never offer a partial error response.
        platform.queryError = false;
        await service.refreshCatalog();
        expect(service.products.map((p) => p.id), [tideProductId]);
        expect(service.products.single.price, '₩6,900');
        final before = platform.queries;
        platform.pause = Completer<void>();
        final first = service.refreshCatalog();
        final second = service.refreshCatalog();
        await Future<void>.delayed(Duration.zero);
        expect(service.checkingStore, true);
        expect(platform.queries, before + 1);
        platform.pause!.complete();
        await Future.wait([first, second]);
        expect(service.checkingStore, false);
        expect(service.entitlements, isEmpty);
        expect(
          service.isAvailable,
          false,
        ); // A catalog does not create an account.
      } finally {
        service.dispose();
        await platform.updates.close();
        debugDefaultTargetPlatformOverride = null;
      }
    },
    skip: kLifeQuestCloudEnabled && kLifeQuestMonetizationEnabled
        ? false
        : 'Requires the separate Cloud/Billing-enabled catalog test command.',
  );
}
