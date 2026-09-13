import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Remembers a routing choice, never authentication credentials or profile data.
class SessionState extends ChangeNotifier {
  static const preferenceKey = 'lifequest.session.deviceProfile';
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
}
