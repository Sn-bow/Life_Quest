import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Timers contain no goal or note text, and are isolated by profile.
class MissionFocusStore {
  static String prefix(String scope) =>
      'lifequest.focus.${sha256.convert(utf8.encode(scope))}.';
  static String key(String scope, String questId) =>
      '${prefix(scope)}${sha256.convert(utf8.encode(questId))}';

  static Future<void> clear(String scope) async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in prefs.getKeys().where(
      (k) => k.startsWith(prefix(scope)),
    )) {
      if (!await prefs.remove(key)) {
        throw StateError('Focus cache could not be cleared');
      }
    }
  }
}
