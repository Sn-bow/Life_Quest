import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/cloud_config.dart';
import '../../config/monetization_config.dart';
import '../../config/qa_preview_config.dart';

const kPurchaseAccountEnabled =
    kLifeQuestCloudEnabled &&
    kLifeQuestMonetizationEnabled &&
    !kLifeQuestQaPreview;

class PurchaseIdentity {
  final String uid;
  final String? email;
  const PurchaseIdentity(this.uid, {this.email});
}

abstract interface class PurchaseAccountGateway {
  PurchaseIdentity? get current;
  Stream<PurchaseIdentity?> get changes;
  Future<PurchaseIdentity?> signIn();
  Future<bool> ensureAccount();
  Future<void> signOut();
  Future<bool> requestDeletion();
}

enum PurchaseAccountStatus {
  idle,
  working,
  connected,
  failed,
  deleted,
  cleanupNeeded,
}

/// No CharacterState or director data enters this boundary. The only durable
/// local value is an authenticated UID whose server account was confirmed.
class PurchaseAccountState extends ChangeNotifier {
  static const readyUidKey = 'lifequest.purchaseIdentity.readyUid';
  final bool enabled;
  final bool Function() isPurchaseOnly;
  final Future<void> Function() markPurchaseOnly;
  final PurchaseAccountGateway Function() createGateway;
  PurchaseAccountGateway? _gateway;
  StreamSubscription<PurchaseIdentity?>? _auth;
  PurchaseIdentity? _identity;
  PurchaseAccountStatus _status = PurchaseAccountStatus.idle;
  Future<void>? _initializing;
  bool _disposed = false;
  PurchaseAccountState({
    required this.enabled,
    required this.isPurchaseOnly,
    required this.markPurchaseOnly,
    required this.createGateway,
  });

  PurchaseIdentity? get identity => _identity;
  PurchaseIdentity? get signedInIdentity => _gateway?.current;
  String? get uid => _identity?.uid;
  bool get busy => _status == PurchaseAccountStatus.working;
  PurchaseAccountStatus get status => _status;
  void _emit(PurchaseAccountStatus value) {
    _status = value;
    if (!_disposed) notifyListeners();
  }

  PurchaseAccountGateway _listen() {
    final gateway = _gateway ??= createGateway();
    _auth ??= gateway.changes.listen(
      (identity) {
        if (_identity != null && identity?.uid != _identity!.uid) {
          _identity = null;
          if (!busy) _status = PurchaseAccountStatus.idle;
        }
        if (!_disposed) notifyListeners();
      },
      onError: (Object _) {
        _identity = null;
        if (!busy) _status = PurchaseAccountStatus.failed;
        if (!_disposed) notifyListeners();
      },
    );
    return gateway;
  }

  Future<void> initialize() => _initializing ??= _initialize();
  Future<void> _initialize() async {
    if (!enabled || !isPurchaseOnly()) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final current = _listen().current;
      if (current != null && prefs.getString(readyUidKey) == current.uid) {
        _identity = current;
        _emit(PurchaseAccountStatus.connected);
      }
    } catch (_) {
      _emit(PurchaseAccountStatus.failed);
    }
  }

  Future<void> _forgetReady() async {
    _identity = null;
    if (!_disposed) notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    if (!await prefs.remove(readyUidKey)) {
      throw StateError('Could not revoke the local purchase session.');
    }
  }

  Future<void> connect() async {
    if (!enabled || busy) return;
    await initialize();
    if (busy || _disposed) return;
    _emit(PurchaseAccountStatus.working);
    try {
      // Both local writes must finish before authentication can change.
      await markPurchaseOnly();
      await _forgetReady();
      final gateway = _listen();
      final selected = await gateway.signIn();
      if (selected == null) {
        _emit(PurchaseAccountStatus.idle);
        return;
      }
      if (!await gateway.ensureAccount() ||
          gateway.current?.uid != selected.uid) {
        throw StateError('Purchase account was not confirmed.');
      }
      final prefs = await SharedPreferences.getInstance();
      if (!await prefs.setString(readyUidKey, selected.uid)) {
        throw StateError('Could not remember the purchase account.');
      }
      if (gateway.current?.uid != selected.uid) {
        await _forgetReady();
        throw StateError('Account changed during confirmation.');
      }
      _identity = selected;
      _emit(PurchaseAccountStatus.connected);
    } catch (_) {
      _identity = null;
      _emit(PurchaseAccountStatus.failed);
    }
  }

  Future<void> disconnect() async {
    if (!enabled || busy) return;
    final deletionAccepted = _status == PurchaseAccountStatus.cleanupNeeded;
    _emit(PurchaseAccountStatus.working);
    try {
      await _forgetReady();
      await _listen().signOut();
      _emit(
        deletionAccepted
            ? PurchaseAccountStatus.deleted
            : PurchaseAccountStatus.idle,
      );
    } catch (_) {
      _emit(
        deletionAccepted
            ? PurchaseAccountStatus.cleanupNeeded
            : PurchaseAccountStatus.failed,
      );
    }
  }

  Future<void> deleteAccount() async {
    if (!enabled || busy || signedInIdentity == null) return;
    _emit(PurchaseAccountStatus.working);
    var accepted = false;
    try {
      // Revoke restart eligibility BEFORE requesting deletion. Even failed
      // sign-out cannot revive paid access from the local readiness cache.
      await _forgetReady();
      accepted = await _listen().requestDeletion();
      if (!accepted) throw StateError('Deletion was not accepted.');
      await _listen().signOut();
      _emit(PurchaseAccountStatus.deleted);
    } catch (_) {
      _emit(
        accepted
            ? PurchaseAccountStatus.cleanupNeeded
            : PurchaseAccountStatus.failed,
      );
    }
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(_auth?.cancel());
    super.dispose();
  }
}
