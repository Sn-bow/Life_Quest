import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Remembers a routing choice, never authentication credentials or profile data.
class SessionState extends ChangeNotifier {
  static const preferenceKey = 'lifequest.session.deviceProfile';
  static const purchasePurposeKey = 'lifequest.session.purchaseOnlyAuth';
  bool _purchaseOnlyAuth = false;
  bool get purchaseOnlyAuth => _purchaseOnlyAuth;
  int _deviceRevision = 0;
  int get deviceRevision => _deviceRevision;
  void reloadDevice() {
    if (!_deviceSelected) throw StateError('No device profile is selected.');
    ++_deviceRevision;
    notifyListeners();
  }

  bool _ready = false;
  bool _deviceSelected = false;
  bool get ready => _ready;
  bool get deviceSelected => _deviceSelected;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _deviceSelected = prefs.getBool(preferenceKey) ?? false;
    _purchaseOnlyAuth = prefs.getBool(purchasePurposeKey) ?? false;
    _ready = true;
    notifyListeners();
  }

  Future<void> selectDevice(bool selected) async {
    final prefs = await SharedPreferences.getInstance();
    if (!await prefs.setBool(preferenceKey, selected)) {
      throw StateError('Session choice could not be saved.');
    }
    _deviceSelected = selected;
    notifyListeners();
  }

  /// Persist before Google sign-in so a restart cannot route this identity into
  /// the legacy cloud-profile loader. Disconnecting does not undo this choice.
  Future<void> markPurchaseOnlyAuth() async {
    final prefs = await SharedPreferences.getInstance();
    if (!await prefs.setBool(purchasePurposeKey, true)) {
      throw StateError('Purchase account purpose could not be saved.');
    }
    _purchaseOnlyAuth = true;
    notifyListeners();
  }
}
