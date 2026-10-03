import 'dart:async';
import 'dart:convert';
import 'journey_tool.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Unfinished notes stay on this device. Only a completed note enters the
/// profile, its cloud sync (if enabled), and the portable progress backup.
class MissionDraftStore {
  static Future<void>? _pending;
  static String prefix(String scope) =>
      'lifequest.missionDraft.${sha256.convert(utf8.encode(scope))}.';
  static String key(String scope, String questId) =>
      '${prefix(scope)}${sha256.convert(utf8.encode(questId))}';

  // A late keystroke must never overtake a newer value or account deletion.
  static Future<T> _ordered<T>(Future<T> Function() operation) {
    final previous = _pending;
    final gate = Completer<void>();
    _pending = gate.future;
    return () async {
      if (previous != null) await previous;
      try {
        return await operation();
      } finally {
        if (identical(_pending, gate.future)) _pending = null;
        gate.complete();
      }
    }();
  }

  static Future<String?> read(String scope, String questId) =>
      _ordered(() async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.reload();
        return prefs.getString(key(scope, questId));
      });

  static Future<void> write(String scope, String questId, String text) =>
      _ordered(() async {
        final prefs = await SharedPreferences.getInstance();
        if (!await prefs.setString(key(scope, questId), text)) {
          throw StateError('Mission draft could not be saved');
        }
      });

  static Future<void> remove(String scope, String questId) =>
      _ordered(() async {
        final prefs = await SharedPreferences.getInstance();
        if (!await prefs.remove(key(scope, questId))) {
          throw StateError('Mission draft could not be removed');
        }
      });

  static Future<void> clear(String scope) => _ordered(() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    for (final item in prefs.getKeys().where(
      (k) => k.startsWith(prefix(scope)),
    )) {
      if (!await prefs.remove(item)) {
        throw StateError('Mission drafts could not be cleared');
      }
    }
  });
}

/// Versioned workspace drafts also read the plain-text notes saved by v2016.
/// The prefix avoids interpreting a user's ordinary JSON note as a workspace.
class MissionWorkspaceDraft {
  static const marker = 'lifequest-workspace-v1:';
  final String note;
  final JourneyTool? tool;
  const MissionWorkspaceDraft({this.note = '', this.tool});
  String encode() => tool == null
      ? note
      : '$marker${jsonEncode({'note': note, 'tool': tool!.toJson()})}';
  factory MissionWorkspaceDraft.decode(String value) {
    if (!value.startsWith(marker)) return MissionWorkspaceDraft(note: value);
    final json = jsonDecode(value.substring(marker.length));
    if (json is! Map ||
        json['note'] is! String ||
        JourneyTool.parse(json['tool']) == null) {
      throw const FormatException('Invalid workspace draft');
    }
    return MissionWorkspaceDraft(
      note: json['note'],
      tool: JourneyTool.parse(json['tool']),
    );
  }
}
