import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'device_backup.dart';

/// The journal is written before either profile key. An interrupted restore
/// rolls forward on the next launch. The previous pair is retained for one undo.
/// All content is in app-private storage, alongside the existing device profile.
class DeviceBackupStore {
  static const profileKey = 'lifequest.local.state.v1';
  static const directorKey = 'lifequest.director.v1.device';
  static const journalKey = 'lifequest.local.restore.v1';
  static const undoKey = 'lifequest.local.restore.previous.v1';
  final String? Function(String key) read;
  final Future<bool> Function(String key, String value) write;
  final Future<bool> Function(String key) remove;
  const DeviceBackupStore({
    required this.read,
    required this.write,
    required this.remove,
  });
  factory DeviceBackupStore.preferences(SharedPreferences prefs) =>
      DeviceBackupStore(
        read: prefs.getString,
        write: prefs.setString,
        remove: prefs.remove,
      );

  Future<void> _set(String key, String value) async {
    if (!await write(key, value)) {
      throw StateError('Device restore write failed.');
    }
  }

  Future<void> restore(DeviceSnapshot snapshot) async {
    try {
      await recover();
    } on InvalidBackup {
      // A user-confirmed, validated import can replace a broken journal.
      // Current profile keys remain available as the previous-state snapshot.
    }
    final previousProfile = read(profileKey);
    final previousDirector = read(directorKey);
    final previous = previousProfile == null
        ? null
        : {'profile': previousProfile, 'director': previousDirector};
    await _set(
      journalKey,
      jsonEncode({
        'version': 1,
        'snapshot': snapshot.toJson(),
        'previous': previous,
      }),
    );
    await recover();
  }

  Future<void> recover() async {
    final raw = read(journalKey);
    if (raw == null) return;
    if (raw.length > DeviceBackupCodec.maxFileBytes * 2) {
      throw const InvalidBackup();
    }
    final Object? journal;
    try {
      journal = jsonDecode(raw);
    } on FormatException {
      throw const InvalidBackup();
    }
    if (journal is! Map<String, dynamic> || journal['version'] != 1) {
      throw const InvalidBackup();
    }
    // Revalidate the journal; corruption is surfaced instead of erasing it.
    final snapshot = DeviceSnapshot.fromJson(journal['snapshot']);
    final previous = journal['previous'];
    if (previous != null) {
      if (previous is! Map<String, dynamic> ||
          previous['profile'] is! String ||
          (previous['director'] != null && previous['director'] is! String)) {
        throw const InvalidBackup();
      }
      await _set(undoKey, jsonEncode(previous));
    }
    await _set(profileKey, jsonEncode(snapshot.profile));
    await _set(directorKey, jsonEncode(snapshot.director));
    if (!await remove(journalKey)) {
      throw StateError('Device restore commit failed.');
    }
  }

  DeviceSnapshot? previousSnapshot() {
    final raw = read(undoKey);
    if (raw == null || raw.length > DeviceBackupCodec.maxFileBytes * 2) {
      return null;
    }
    try {
      final previous = jsonDecode(raw) as Map<String, dynamic>;
      return DeviceSnapshot.create(
        profile: jsonDecode(previous['profile']),
        director: previous['director'] == null
            ? {}
            : jsonDecode(previous['director']),
        createdAt: DateTime.now(),
      );
    } catch (_) {
      return null;
    }
  }
}
