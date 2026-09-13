import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/cloud_config.dart';
import '../config/monetization_config.dart';
import '../features/billing/purchase_verifier.dart';

enum PurchasePhase {
  idle,
  launching,
  pending,
  verifying,
  granted,
  cancelled,
  retry,
  failed,
  restoring,
  restoreFinished,
}

class PurchaseService extends ChangeNotifier {
  static final PurchaseService _instance = PurchaseService._();
  factory PurchaseService() => _instance;
  PurchaseService._();
  InAppPurchase get _store => InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _purchases;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _grants;
  Future<void> _events = Future.value();
  Future<void> _cacheWrites = Future.value();
  bool _initialized = false;
  bool _available = false;
  String? _uid;
  int _revision = 0;
  Set<String> _entitlements = {};
  List<ProductDetails> _products = [];
  PurchasePhase _phase = PurchasePhase.idle;
  String? _activeProduct;
  static const removeAdsId = 'remove_ads_4900';

  bool get isAvailable => _available && _uid != null;
  List<ProductDetails> get products => List.unmodifiable(_products);
  Set<String> get entitlements => Set.unmodifiable(_entitlements);
  PurchasePhase get phase => _phase;
  String? get activeProduct => _activeProduct;
  bool get busy => {
    PurchasePhase.launching,
    PurchasePhase.verifying,
    PurchasePhase.restoring,
  }.contains(_phase);
  void Function(Set<String>)? onEntitlementsChanged;

  void _setPhase(PurchasePhase value, {String? product}) {
    _phase = value;
    _activeProduct = product;
    notifyListeners();
  }

  Future<void> init() async {
    if (!kLifeQuestMonetizationEnabled ||
        !kLifeQuestCloudEnabled ||
        kIsWeb ||
        defaultTargetPlatform != TargetPlatform.android ||
        _initialized) {
      return;
    }
    // Subscribe before querying so resumed pending purchases cannot be missed.
    _purchases ??= _store.purchaseStream.listen((events) {
      _events = _events.catchError((Object _) {}).then((_) => _handle(events));
    }, onError: (Object _) => _setPhase(PurchasePhase.retry));
    _available = await _store.isAvailable();
    if (_available) {
      // Only completed, reviewed content is listed for sale. A story draft must
      // not accidentally become buyable because its product exists in Console.
      final response = await _store.queryProductDetails({
        'cosmetic_theme_neon',
        'cosmetic_theme_gold',
      });
      _products = response.productDetails;
      _initialized = true;
    }
    notifyListeners();
  }

  Future<void> bindUser(String? uid) async {
    if (_uid == uid) return;
    final revision = ++_revision;
    final previous = _grants;
    _grants = null;
    _uid = uid;
    await previous?.cancel();
    if (revision != _revision) return;
    _entitlements = {};
    _phase = PurchasePhase.idle;
    _activeProduct = null;
    if (uid == null) onEntitlementsChanged?.call(entitlements);
    notifyListeners();
    if (uid == null || !kLifeQuestCloudEnabled) return;
    final prefs = await SharedPreferences.getInstance();
    if (revision != _revision) return;
    _entitlements = (prefs.getStringList('lifequest.purchases.v1.$uid') ?? [])
        .where(playEntitlements.containsValue)
        .toSet();
    if (_entitlements.isNotEmpty) onEntitlementsChanged?.call(entitlements);
    notifyListeners();
    _grants = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('entitlements')
        .snapshots(includeMetadataChanges: true)
        .listen(
          (snapshot) {
            if (revision != _revision) return;
            // An empty, offline Firestore cache must not erase our durable cache.
            if (snapshot.metadata.isFromCache && snapshot.docs.isEmpty) return;
            final owned = snapshot.docs
                .where((d) => d.data()['active'] == true)
                .map((d) => d.data()['entitlementId'])
                .whereType<String>()
                .where(playEntitlements.containsValue)
                .toSet();
            unawaited(_replaceEntitlements(uid, owned));
          },
          onError: (Object _) {
            // Keep previously verified offline ownership. Restore remains available.
          },
        );
    await init();
    if (revision == _revision && isAvailable) unawaited(restorePurchases());
  }

  Future<void> _replaceEntitlements(String uid, Set<String> owned) async {
    if (_uid != uid) return;
    _entitlements = Set.of(owned);
    onEntitlementsChanged?.call(entitlements);
    notifyListeners();
    final snapshot = owned.toList()..sort();
    final write = _cacheWrites.catchError((Object _) {}).then((_) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('lifequest.purchases.v1.$uid', snapshot);
    });
    _cacheWrites = write;
    await write;
  }

  Future<void> buyProduct(ProductDetails product) async {
    if (!isAvailable || busy || !_products.any((p) => p.id == product.id)) {
      return;
    }
    final uid = _uid!;
    _setPhase(PurchasePhase.launching, product: product.id);
    try {
      final launched = await _store.buyNonConsumable(
        purchaseParam: PurchaseParam(
          productDetails: product,
          applicationUserName: playAccountId(uid),
        ),
      );
      if (!launched && _uid == uid) _setPhase(PurchasePhase.failed);
    } catch (_) {
      if (_uid == uid) _setPhase(PurchasePhase.failed);
    }
  }

  Future<void> restorePurchases() async {
    if (!isAvailable || busy) return;
    _setPhase(PurchasePhase.restoring);
    try {
      await _store.restorePurchases(applicationUserName: playAccountId(_uid!));
      await _events;
      if (_phase == PurchasePhase.restoring) {
        _setPhase(PurchasePhase.restoreFinished);
      }
    } catch (_) {
      _setPhase(PurchasePhase.retry);
    }
  }

  Future<void> _handle(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (_uid == null) return;
      final revision = _revision;
      switch (purchase.status) {
        case PurchaseStatus.pending:
          _setPhase(PurchasePhase.pending, product: purchase.productID);
        case PurchaseStatus.canceled:
          _setPhase(PurchasePhase.cancelled);
        case PurchaseStatus.error:
          _setPhase(PurchasePhase.failed);
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _setPhase(PurchasePhase.verifying, product: purchase.productID);
          final verifier = PurchaseVerifier(
            currentUid: () {
              final user = FirebaseAuth.instance.currentUser;
              return user != null && !user.isAnonymous && user.uid == _uid
                  ? _uid
                  : null;
            },
            verify: (data) async {
              final callable = FirebaseFunctions.instance.httpsCallable(
                'verifyPurchase',
                options: HttpsCallableOptions(
                  timeout: const Duration(seconds: 25),
                ),
              );
              final result = await callable.call<Map<String, dynamic>>(data);
              return result.data;
            },
            deliver: (uid, entitlement) =>
                _replaceEntitlements(uid, {..._entitlements, entitlement}),
          );
          final valid = await verifier.process(
            productId: purchase.productID,
            token: purchase.verificationData.serverVerificationData,
          );
          if (revision != _revision) continue;
          _setPhase(valid ? PurchasePhase.granted : PurchasePhase.retry);
        // Android acknowledgement is performed by verifyPurchase AFTER its
        // Firestore transaction. Do not acknowledge failed verification here.
      }
    }
  }

  Future<void> endSession() async {
    await bindUser(null);
    await _events.catchError((Object _) {});
    await _cacheWrites.catchError((Object _) {});
  }

  @override
  void dispose() {
    _revision++;
    unawaited(_purchases?.cancel());
    unawaited(_grants?.cancel());
    super.dispose();
  }
}
