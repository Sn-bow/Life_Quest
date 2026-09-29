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
  final bool _connectToCloud;
  final DateTime Function() _now;
  PurchaseService._() : _connectToCloud = true, _now = DateTime.now;
  @visibleForTesting
  PurchaseService.cacheOnlyForTesting({DateTime Function()? now})
    : _connectToCloud = false,
      _now = now ?? DateTime.now;
  InAppPurchase get _store => InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _purchases;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _grants;
  Future<void> _events = Future.value();
  Future<void> _cacheWrites = Future.value();
  bool _initialized = false;
  Future<void>? _catalogLoad;
  bool get checkingStore => _catalogLoad != null;
  bool _available = false;
  String? _uid;
  int _revision = 0;
  Set<String> _entitlements = {};
  int? _lastServerVerifiedAt;
  Timer? _cacheExpiryTimer;
  List<ProductDetails> _products = [];
  PurchasePhase _phase = PurchasePhase.idle;
  String? _activeProduct;
  static const removeAdsId = 'remove_ads_4900';
  static const offlineEntitlementLifetime = Duration(days: 7);
  static String _verifiedAtKey(String uid) =>
      'lifequest.purchases.serverVerifiedAt.v1.$uid';

  bool _freshAt(int? verifiedAt) {
    if (verifiedAt == null) return false;
    final age = _now().millisecondsSinceEpoch - verifiedAt;
    return age >= 0 && age < offlineEntitlementLifetime.inMilliseconds;
  }

  void _scheduleCacheExpiry() {
    _cacheExpiryTimer?.cancel();
    final uid = _uid;
    final verifiedAt = _lastServerVerifiedAt;
    if (uid == null || verifiedAt == null || _entitlements.isEmpty) return;
    final remaining =
        verifiedAt +
        offlineEntitlementLifetime.inMilliseconds -
        _now().millisecondsSinceEpoch;
    if (remaining <= 0) {
      scheduleMicrotask(recheckEntitlementCache);
      return;
    }
    _cacheExpiryTimer = Timer(Duration(milliseconds: remaining), () {
      recheckEntitlementCache();
      if (_uid == uid && _entitlements.isNotEmpty) {
        _scheduleCacheExpiry();
      }
    });
  }

  /// Stop local paid access after seven days without a server-confirmed grant.
  /// A Play restore can renew it; the free status window and quests remain.
  void recheckEntitlementCache() {
    final uid = _uid;
    if (uid == null ||
        _entitlements.isEmpty ||
        _freshAt(_lastServerVerifiedAt)) {
      return;
    }
    _cacheExpiryTimer?.cancel();
    _entitlements = {};
    onEntitlementsChanged?.call(entitlements);
    notifyListeners();
    final write = _cacheWrites.catchError((Object _) {}).then((_) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('lifequest.purchases.v1.$uid', const []);
    });
    _cacheWrites = write;
    if (isAvailable) unawaited(restorePurchases());
  }

  bool get isAvailable {
    if (!_available || _uid == null) return false;
    final user = FirebaseAuth.instance.currentUser;
    return user != null &&
        !user.isAnonymous &&
        user.uid == _uid &&
        user.providerData.any(
          (provider) => provider.providerId == 'google.com',
        );
  }

  List<ProductDetails> get products => List.unmodifiable(_products);
  Set<String> get entitlements => _freshAt(_lastServerVerifiedAt)
      ? Set.unmodifiable(_entitlements)
      : const <String>{};
  bool get ownsStatusWindowPlus =>
      entitlements.contains(statusWindowPlusProductId);
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
    if (_catalogLoad != null) return _catalogLoad;
    final load = _loadCatalog();
    _catalogLoad = load;
    notifyListeners();
    try {
      await load;
    } finally {
      _catalogLoad = null;
      notifyListeners();
    }
  }

  Future<void> refreshCatalog() async {
    if (busy || checkingStore) return;
    _initialized = false;
    await init();
  }

  Future<void> _loadCatalog() async {
    try {
      // Listen before the query so a resumed pending purchase is never missed.
      _purchases ??= _store.purchaseStream.listen((events) {
        _events = _events
            .catchError((Object _) {})
            .then((_) => _handle(events));
      }, onError: (Object _) => _setPhase(PurchasePhase.retry));
      _products = [];
      _available = await _store.isAvailable();
      if (!_available) return;
      // An empty sale catalog pauses new purchases without turning off the
      // purchase stream or restore path for already verified owners.
      if (saleProductIds.isEmpty) {
        _initialized = true;
        return;
      }
      final response = await _store.queryProductDetails(saleProductIds);
      if (response.error != null) return;
      final preferredIds = saleProductIds.toList();
      _products =
          response.productDetails
              .where((p) => saleProductIds.contains(p.id))
              .toList()
            ..sort(
              (a, b) => preferredIds
                  .indexOf(a.id)
                  .compareTo(preferredIds.indexOf(b.id)),
            );
      _initialized = true;
    } catch (_) {
      // A Store outage must leave the preview usable and the query retryable.
      // Do not log Store exceptions, which may contain account/receipt details.
      _available = false;
      _products = [];
      _initialized = false;
    }
  }

  Future<void> bindUser(String? uid) async {
    if (_uid == uid) return;
    final previousUid = _uid;
    final revision = ++_revision;
    final previous = _grants;
    _grants = null;
    _uid = uid;
    _cacheExpiryTimer?.cancel();
    _lastServerVerifiedAt = null;
    await previous?.cancel();
    if (revision != _revision) return;
    _entitlements = {};
    _phase = PurchasePhase.idle;
    _activeProduct = null;
    // An initial cache load must not unequip an owned, persisted theme before
    // reading its verified cache. Switching away from an identity revokes first.
    if (uid == null || previousUid != null) {
      onEntitlementsChanged?.call(entitlements);
    }
    notifyListeners();
    if (uid == null || (_connectToCloud && !kLifeQuestCloudEnabled)) return;
    final prefs = await SharedPreferences.getInstance();
    if (revision != _revision) return;
    final verifiedAt = prefs.getInt(_verifiedAtKey(uid));
    if (_freshAt(verifiedAt)) {
      _lastServerVerifiedAt = verifiedAt;
      _entitlements = (prefs.getStringList('lifequest.purchases.v1.$uid') ?? [])
          .where(playEntitlements.containsValue)
          .toSet();
      _scheduleCacheExpiry();
    }
    onEntitlementsChanged?.call(entitlements);
    notifyListeners();
    if (!_connectToCloud) return;
    _grants = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('entitlements')
        .snapshots(includeMetadataChanges: true)
        .listen(
          (snapshot) {
            if (revision != _revision) return;
            // Firestore's device cache cannot renew an expired entitlement.
            // The bounded local cache above is the only offline source.
            if (snapshot.metadata.isFromCache) return;
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
    _lastServerVerifiedAt = _now().millisecondsSinceEpoch;
    _scheduleCacheExpiry();
    onEntitlementsChanged?.call(entitlements);
    notifyListeners();
    final snapshot = owned.toList()..sort();
    final verifiedAt = _lastServerVerifiedAt!;
    final write = _cacheWrites.catchError((Object _) {}).then((_) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('lifequest.purchases.v1.$uid', snapshot);
      // Save the time last: an interrupted write cannot refresh old rights.
      await prefs.setInt(_verifiedAtKey(uid), verifiedAt);
    });
    _cacheWrites = write;
    await write;
  }

  Future<bool> _ensurePurchaseAccount(String uid) async {
    final signedIn = FirebaseAuth.instance.currentUser;
    if (signedIn == null ||
        signedIn.isAnonymous ||
        signedIn.uid != uid ||
        !signedIn.providerData.any(
          (provider) => provider.providerId == 'google.com',
        )) {
      return false;
    }
    try {
      // Also migrates existing purchase accounts to the server-only Play
      // account lookup needed to recover a transaction after app exit.
      final account = await FirebaseFunctions.instance
          .httpsCallable(
            'ensurePurchaseAccount',
            options: HttpsCallableOptions(timeout: const Duration(seconds: 25)),
          )
          .call<Map<String, dynamic>>();
      return _uid == uid &&
          FirebaseAuth.instance.currentUser?.uid == uid &&
          account.data['ready'] == true;
    } catch (_) {
      return false;
    }
  }

  Future<void> buyProduct(ProductDetails product) async {
    if (!isAvailable ||
        busy ||
        checkingStore ||
        !saleProductIds.contains(product.id) ||
        !_products.any((p) => p.id == product.id)) {
      return;
    }
    final uid = _uid!;
    _setPhase(PurchasePhase.launching, product: product.id);
    try {
      final ready = await _ensurePurchaseAccount(uid);
      if (_uid != uid) return;
      if (!ready) {
        _setPhase(PurchasePhase.failed);
        return;
      }
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
    final uid = _uid!;
    _setPhase(PurchasePhase.restoring);
    try {
      final ready = await _ensurePurchaseAccount(uid);
      if (_uid != uid) return;
      if (!ready) {
        _setPhase(PurchasePhase.retry);
        return;
      }
      await _store.restorePurchases(applicationUserName: playAccountId(uid));
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
    _cacheExpiryTimer?.cancel();
    unawaited(_purchases?.cancel());
    unawaited(_grants?.cancel());
    super.dispose();
  }
}
