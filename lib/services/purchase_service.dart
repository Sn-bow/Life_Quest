import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:life_quest_final_v2/services/ad_service.dart';
import 'package:life_quest_final_v2/models/cosmetic.dart';

/// Singleton service for managing In-App Purchases (IAP).
class PurchaseService {
  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  // IAP Product IDs
  static const String removeAdsId =
      'remove_ads_4900'; // Define in App Store / Play Console

  // State
  bool _isAvailable = false;
  bool _isInitialized = false;
  List<ProductDetails> _products = [];
  bool get isAvailable => _isAvailable;
  List<ProductDetails> get products => _products;

  // Stream for notifying other parts of the app (like CharacterState) of successful cosmetic purchases
  final _unlockController = StreamController<String>.broadcast();
  Stream<String> get unlockStream => _unlockController.stream;

  /// Initialize the IAP service (중복 초기화 방지)
  Future<void> init() async {
    if (_isInitialized) return;

    _isAvailable = await _inAppPurchase.isAvailable();

    if (_isAvailable) {
      await _loadProducts();

      // Listen for purchase updates
      _subscription = _inAppPurchase.purchaseStream.listen(
        _listenToPurchaseUpdated,
        onError: (error) {
          debugPrint('[PurchaseService] Purchase Stream Error: $error');
        },
      );
      _isInitialized = true;
    } else {
      debugPrint('[PurchaseService] IAP is not available on this device.');
    }
  }

  /// Load available products from the store
  Future<void> _loadProducts() async {
    final Set<String> kIds = {
      removeAdsId,
      ...CosmeticDatabase.items.map((e) => e.iapId),
    };
    final ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(kIds);

    if (response.notFoundIDs.isNotEmpty) {
      debugPrint(
          '[PurchaseService] Products not found: ${response.notFoundIDs}');
    }

    _products = response.productDetails;
  }

  /// Initiate a purchase for a specific product
  Future<void> buyProduct(ProductDetails productDetails) async {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);

    // For non-consumable like 'Remove Ads'
    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Initiate restoring previous purchases
  Future<void> restorePurchases() async {
    await _inAppPurchase.restorePurchases();
  }

  /// Handle purchase updates from the stream
  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        debugPrint(
            '[PurchaseService] Purchase pending: ${purchaseDetails.productID}');
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          debugPrint(
              '[PurchaseService] Purchase error: ${purchaseDetails.error}');
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          // C-2: 서버사이드 영수증 검증
          final isValid = await _verifyPurchaseWithServer(purchaseDetails);
          if (!isValid) {
            debugPrint(
                '[PurchaseService] ⛔ Server-side verification failed for '
                '${purchaseDetails.productID}. Purchase rejected.');
            if (purchaseDetails.pendingCompletePurchase) {
              await _inAppPurchase.completePurchase(purchaseDetails);
            }
            continue;
          }

          // 검증 통과 → 상품 지급
          if (purchaseDetails.productID == removeAdsId) {
            await _deliverRemoveAds();
          } else {
            // Check if it's a cosmetic IAP
            final cosmeticItem = CosmeticDatabase.items
                .where((item) => item.iapId == purchaseDetails.productID)
                .firstOrNull;
            if (cosmeticItem != null) {
              _unlockController.add(cosmeticItem.id);
            }
          }

          if (purchaseDetails.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(purchaseDetails);
          }
        }
      }
    }
  }

  /// C-2: Firebase Cloud Function을 통한 서버사이드 영수증 검증
  /// Cloud Function 미배포 시에는 로컬 검증으로 폴백하여 앱 동작을 보장합니다.
  Future<bool> _verifyPurchaseWithServer(PurchaseDetails purchaseDetails) async {
    if (kDebugMode) {
      debugPrint('[PurchaseService] Debug mode: skipping server verification');
      return true;
    }

    try {
      final callable =
          FirebaseFunctions.instance.httpsCallable('verifyPurchase');
      final result = await callable.call<Map<String, dynamic>>({
        'purchaseToken':
            purchaseDetails.verificationData.serverVerificationData,
        'productId': purchaseDetails.productID,
        'packageName': 'com.lifequest.app',
      });

      final isValid = result.data['isValid'] as bool? ?? false;
      // 주문 ID 등 민감 정보는 디버그 빌드에서만 로그 출력
      if (kDebugMode) {
        debugPrint(
            '[PurchaseService] Server verification result: isValid=$isValid '
            'orderId=${result.data['orderId']}');
      }
      return isValid;
    } on FirebaseFunctionsException catch (e) {
      // Cloud Function이 배포되지 않은 경우 등 — 로컬 검증으로 폴백
      debugPrint(
          '[PurchaseService] ⚠️ Cloud Function error (${e.code}): ${e.message}. '
          'Falling back to local verification.');
      return true; // 폴백: Cloud Function 없을 때 차단하지 않음
    } catch (e) {
      debugPrint('[PurchaseService] ⚠️ Verification error: $e. Falling back.');
      return true; // 폴백
    }
  }

  /// Grant the "Remove Ads" benefit to the user
  Future<void> _deliverRemoveAds() async {
    debugPrint('[PurchaseService] Delivering Remove Ads...');
    await AdService().setAdRemoved(true);
  }

  /// Dispose the stream subscription
  void dispose() {
    _subscription.cancel();
    _unlockController.close();
  }
}
