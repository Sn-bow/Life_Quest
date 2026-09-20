import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import '../../models/character.dart';
import '../../models/quest.dart';
import '../../models/achievement.dart';
import '../billing/purchase_verifier.dart';
import '../director/quest_director_engine.dart';

class InvalidBackup implements Exception {
  const InvalidBackup();
}

/// A validated copy of device progress. No Firebase identity, receipt, purchase
/// cache, photo URL, downloaded model, or notification permission is portable.
class DeviceSnapshot {
  static const format = 'lifequest-device-progress';
  final DateTime createdAt;
  final String _profileJson, _directorJson;
  DeviceSnapshot._(this.createdAt, this._profileJson, this._directorJson);
  Map<String, dynamic> get profile => jsonDecode(_profileJson);
  Map<String, dynamic> get director => jsonDecode(_directorJson);
  String get name => profile['character']['name'];
  int get level => profile['character']['level'];

  factory DeviceSnapshot.create({
    required Map<String, dynamic> profile,
    required Map<String, dynamic> director,
    required DateTime createdAt,
  }) => DeviceSnapshot.fromJson({
    'format': format,
    'version': 1,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'profile': profile,
    'director': director,
  });

  factory DeviceSnapshot.fromJson(Object? value) {
    try {
      _checkTree(value);
      if (value is! Map<String, dynamic> ||
          value['format'] != format ||
          value['version'] != 1 ||
          value['profile'] is! Map<String, dynamic> ||
          value['director'] is! Map<String, dynamic>) {
        throw const InvalidBackup();
      }
      final date = DateTime.tryParse(value['createdAt'] as String);
      if (date == null) throw const InvalidBackup();
      final source = value['profile'] as Map<String, dynamic>;
      if (source['character'] is! Map<String, dynamic>) {
        throw const InvalidBackup();
      }
      final rawCharacter = source['character'] as Map<String, dynamic>;
      if (!['name', 'level', 'xp', 'maxXp'].every(rawCharacter.containsKey)) {
        throw const InvalidBackup();
      }
      final character = Character.fromJson(rawCharacter);
      if (character.name.isEmpty ||
          character.name.runes.length > 120 ||
          character.level < 1 ||
          character.level > 100000 ||
          character.xp < 0 ||
          character.maxXp <= 0 ||
          character.xp > character.maxXp ||
          character.gold < 0 ||
          character.characterMaxHp < 1 ||
          character.currentDungeonChapter < 1 ||
          character.currentDungeonChapter > 5 ||
          character.highestDungeonFloor < 1 ||
          character.infiniteTowerFloor < 1) {
        throw const InvalidBackup();
      }
      character.photoUrl = null;
      final paid = {
        ...playEntitlements.values,
        ...bundledCosmeticProducts.keys,
      };
      character.unlockedCosmetics.removeWhere(paid.contains);
      if (paid.contains(character.equippedTheme)) {
        character.equippedTheme = null;
      }
      if (paid.contains(character.equippedTitleEffect)) {
        character.equippedTitleEffect = null;
      }
      if (paid.contains(character.equippedCombatEffect)) {
        character.equippedCombatEffect = null;
      }
      final theme = source['themeMode'] ?? 2;
      final morning = source['notificationMorningHour'] ?? 9;
      final night = source['notificationNightHour'] ?? 20;
      if (theme is! int ||
          theme < 0 ||
          theme > 2 ||
          morning is! int ||
          morning < 0 ||
          morning > 23 ||
          night is! int ||
          night < 0 ||
          night > 23) {
        throw const InvalidBackup();
      }
      final profile = <String, dynamic>{
        'character': character.toJson(),
        for (final type in [
          'dailyQuests',
          'weeklyQuests',
          'monthlyQuests',
          'yearlyQuests',
        ])
          type: _quests(source[type]),
        'unlockedTitleIds': _strings(source['unlockedTitleIds'] ?? ['t0']),
        'learnedSkillIds': _strings(source['learnedSkillIds'] ?? []),
        'achievementProgress': {
          for (final entry
              in (source['achievementProgress'] as Map<String, dynamic>? ?? {})
                  .entries)
            entry.key: AchievementProgress.fromJson(
              entry.value as Map<String, dynamic>,
            ).toJson(),
        },
        'themeMode': theme,
        'localeCode': ['ko', 'en', 'ja', 'zh'].contains(source['localeCode'])
            ? source['localeCode']
            : 'ko',
        'hasSeenOnboarding': true,
        'notificationMorningHour': morning, 'notificationNightHour': night,
        // Permissions and reminder schedules belong to the destination device.
        'isNotificationEnabled': false,
      };
      final sourceDirector = value['director'] as Map<String, dynamic>;
      final day = sourceDirector['day'];
      if (day != null &&
          (day is! String ||
              !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(day) ||
              DateTime.tryParse(day) == null)) {
        throw const InvalidBackup();
      }

      final accepted =
          sourceDirector['accepted'] as Map<String, dynamic>? ?? {};
      if (accepted.length > 3 ||
          accepted.entries.any(
            (e) =>
                !RegExp(
                  r'^director:\d{4}-\d{2}-\d{2}:[a-z_]+$',
                ).hasMatch(e.key) ||
                e.value is! int ||
                e.value < 1 ||
                e.value > 60,
          )) {
        throw const InvalidBackup();
      }
      final history = <Map<String, dynamic>>[];
      for (final signal in sourceDirector['history'] as List? ?? []) {
        final parsed = QuestSignal.fromJson(signal);
        if (parsed == null) throw const InvalidBackup();
        history.add(parsed.toJson());
      }
      if (history.length > 270) throw const InvalidBackup();
      final director = {
        'profile': HunterProfile.fromJson(
          sourceDirector['profile'] as Map<String, dynamic>? ?? {},
        ).toJson(),
        'history': history,
        'accepted': accepted,
        'day': sourceDirector['day'],
        // Fresh suggestions are regenerated for the destination time and locale.
      };
      return DeviceSnapshot._(
        date.toUtc(),
        jsonEncode(profile),
        jsonEncode(director),
      );
    } on InvalidBackup {
      rethrow;
    } catch (_) {
      throw const InvalidBackup();
    }
  }

  Map<String, dynamic> toJson() => {
    'format': format,
    'version': 1,
    'createdAt': createdAt.toIso8601String(),
    'profile': profile,
    'director': director,
  };

  static List<Map<String, dynamic>> _quests(Object? raw) {
    if (raw == null) return [];
    if (raw is! List || raw.length > 2000) throw const InvalidBackup();
    if (raw.any(
      (e) =>
          e is! Map<String, dynamic> ||
          !['id', 'name', 'xp', 'type', 'category'].every(e.containsKey),
    )) {
      throw const InvalidBackup();
    }
    final quests = raw
        .map((e) => Quest.fromJson(e as Map<String, dynamic>))
        .toList();
    if (quests.map((e) => e.id).toSet().length != quests.length ||
        quests.any(
          (q) => q.id.isEmpty || q.name.isEmpty || q.xp < 0 || q.xp > 100000,
        )) {
      throw const InvalidBackup();
    }
    return quests.map((q) => q.toJson()).toList();
  }

  static List<String> _strings(Object? raw) {
    if (raw is! List || raw.any((v) => v is! String)) {
      throw const InvalidBackup();
    }
    return raw.cast<String>().toList();
  }

  static void _checkTree(Object? value, [int depth = 0]) {
    if (depth > 14) throw const InvalidBackup();
    if (value == null || value is bool) return;
    if (value is num) {
      if (!value.isFinite || value.abs() > 1000000000) {
        throw const InvalidBackup();
      }
    } else if (value is String) {
      if (value.length > 8192) throw const InvalidBackup();
    } else if (value is List) {
      if (value.length > 2000) throw const InvalidBackup();
      for (final item in value) {
        _checkTree(item, depth + 1);
      }
    } else if (value is Map<String, dynamic>) {
      if (value.length > 2000) throw const InvalidBackup();
      for (final entry in value.entries) {
        if (entry.key.length > 256) throw const InvalidBackup();
        _checkTree(entry.value, depth + 1);
      }
    } else {
      throw const InvalidBackup();
    }
  }
}

/// Version 1 has fixed KDF parameters. Reject arbitrary work factors before any
/// expensive operation. AEAD authenticates both ciphertext and the format label.
class DeviceBackupCodec {
  static const maxFileBytes = 8 * 1024 * 1024;
  static const maxPlaintextBytes = 4 * 1024 * 1024;
  static const iterations = 600000;
  static const algorithm = 'pbkdf2-sha256-600000-aes256gcm';
  static final _aad = utf8.encode(
    'LifeQuest encrypted device backup v1/$algorithm',
  );
  static bool validPassword(String password) =>
      password.runes.length >= 12 &&
      password.runes.length <= 128 &&
      password.trim().isNotEmpty;

  Future<Uint8List> encrypt(DeviceSnapshot snapshot, String password) async {
    if (!validPassword(password)) throw const InvalidBackup();
    final plain = utf8.encode(jsonEncode(snapshot.toJson()));
    if (plain.length > maxPlaintextBytes) throw const InvalidBackup();
    final random = Random.secure();
    final salt = List<int>.generate(16, (_) => random.nextInt(256));
    final nonce = List<int>.generate(12, (_) => random.nextInt(256));
    final key = await _derive(password, salt);
    try {
      final box = await AesGcm.with256bits().encrypt(
        plain,
        secretKey: key,
        nonce: nonce,
        aad: _aad,
      );
      return Uint8List.fromList(
        utf8.encode(
          jsonEncode({
            'format': 'lifequest-encrypted-backup',
            'version': 1,
            'algorithm': algorithm,
            'salt': base64Encode(salt),
            'nonce': base64Encode(nonce),
            'ciphertext': base64Encode(box.cipherText),
            'tag': base64Encode(box.mac.bytes),
          }),
        ),
      );
    } finally {
      key.destroy();
      plain.fillRange(0, plain.length, 0);
    }
  }

  Future<DeviceSnapshot> decrypt(List<int> bytes, String password) async {
    if (bytes.length > maxFileBytes || !validPassword(password)) {
      throw const InvalidBackup();
    }
    try {
      final envelope = jsonDecode(utf8.decode(bytes));
      if (envelope is! Map<String, dynamic> ||
          envelope.length != 7 ||
          envelope['format'] != 'lifequest-encrypted-backup' ||
          envelope['version'] != 1 ||
          envelope['algorithm'] != algorithm) {
        throw const InvalidBackup();
      }
      final salt = base64Decode(envelope['salt']);
      final nonce = base64Decode(envelope['nonce']);
      final cipher = base64Decode(envelope['ciphertext']);
      final tag = base64Decode(envelope['tag']);
      if (salt.length != 16 ||
          nonce.length != 12 ||
          tag.length != 16 ||
          cipher.isEmpty ||
          cipher.length > maxPlaintextBytes) {
        throw const InvalidBackup();
      }
      final key = await _derive(password, salt);
      try {
        final plain = await AesGcm.with256bits().decrypt(
          SecretBox(cipher, nonce: nonce, mac: Mac(tag)),
          secretKey: key,
          aad: _aad,
        );
        try {
          return DeviceSnapshot.fromJson(jsonDecode(utf8.decode(plain)));
        } finally {
          plain.fillRange(0, plain.length, 0);
        }
      } finally {
        key.destroy();
      }
    } catch (_) {
      // Wrong passwords, tampering and malformed content have the same result.
      // Never log passwords, raw contents, paths or provider errors.
      throw const InvalidBackup();
    }
  }

  Future<SecretKey> _derive(String password, List<int> salt) =>
      Pbkdf2.hmacSha256(
        iterations: iterations,
        bits: 256,
      ).deriveKeyFromPassword(password: password, nonce: salt);
}
