import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Original ImageGen raster frames. The default window and all progress remain
/// available without a purchase; a revoked entitlement immediately uses core.
enum StatusWindowLook {
  core('assets/images/ui/hunter_status_frame_v1.png', Color(0xFF7FDEFF)),
  obsidian('assets/images/ui/status_plus_obsidian.png', Color(0xFFE2C17C)),
  eclipse('assets/images/ui/status_plus_eclipse.png', Color(0xFFB2A4FF)),
  verdant('assets/images/ui/status_plus_verdant.png', Color(0xFF9BDABD));

  const StatusWindowLook(this.assetPath, this.accent);
  final String assetPath;
  final Color accent;
}

class StatusSkinStore extends ChangeNotifier {
  StatusSkinStore._();
  static final StatusSkinStore instance = StatusSkinStore._();
  static const preferenceKey = 'lifequest.statusWindow.look.v1';

  StatusWindowLook _selected = StatusWindowLook.core;
  Future<void>? _loading;
  StatusWindowLook get selected => _selected;

  StatusWindowLook effective(bool ownsPlus) =>
      ownsPlus ? _selected : StatusWindowLook.core;

  Future<void> load() => _loading ??= _load();

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString(preferenceKey);
      _selected =
          StatusWindowLook.values
              .where((look) => look.name == value)
              .firstOrNull ??
          StatusWindowLook.core;
      notifyListeners();
    } catch (_) {
      // Offline/local storage failure only loses the optional appearance.
      _selected = StatusWindowLook.core;
      notifyListeners();
    }
  }

  Future<void> select(StatusWindowLook look) async {
    await load();
    final prefs = await SharedPreferences.getInstance();
    if (!await prefs.setString(preferenceKey, look.name)) {
      throw StateError('Status appearance was not saved');
    }
    _selected = look;
    notifyListeners();
  }

  @visibleForTesting
  void resetForTesting() {
    _selected = StatusWindowLook.core;
    _loading = null;
    notifyListeners();
  }
}
