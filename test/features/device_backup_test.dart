import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/features/backup/device_backup.dart';
import 'backup_fixture.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const password = '서랍 속에 보관하는 긴 암호 🌿';
  final snapshot = backupFixture();
  final codec = DeviceBackupCodec();
  late Uint8List encrypted;
  setUpAll(() async {
    encrypted = await codec.encrypt(snapshot, password);
  });

  test(
    'Unicode password round trip retains progress, choices and history',
    () async {
      final result = await codec.decrypt(encrypted, password);
      expect(result.name, '검증용 각성자');
      expect(result.profile['character']['xp'], 60);
      expect(
        result.profile['character']['storyChoices']['prologue:signal'],
        'answer',
      );
      expect(result.profile['dailyQuests'].single['isCompleted'], true);
      expect(result.director['profile']['goal'], '퇴근 후 조용한 영어 공부');
      expect(result.director['accepted']['director:2026-09-14:read'], 5);
      expect(result.profile['isNotificationEnabled'], false);
      if (const bool.fromEnvironment('LIFEQUEST_EXPORT_BACKUP_FIXTURE')) {
        final file = File('qa_artifacts/rebirth/backup-fixture.lqbackup');
        await file.parent.create(recursive: true);
        await file.writeAsBytes(encrypted);
      }
    },
  );

  test(
    'encrypted file contains no readable name, goal, timestamp or password',
    () {
      final envelope = utf8.decode(encrypted);
      for (final text in [
        password,
        snapshot.name,
        '퇴근 후',
        '2026-09-14',
        'prologue',
      ]) {
        expect(envelope, isNot(contains(text)));
      }
    },
  );

  test(
    'same content and password produce fresh salt, nonce and ciphertext',
    () async {
      final a = jsonDecode(utf8.decode(encrypted));
      final b = jsonDecode(
        utf8.decode(await codec.encrypt(snapshot, password)),
      );
      expect(a['salt'], isNot(b['salt']));
      expect(a['nonce'], isNot(b['nonce']));
      expect(a['ciphertext'], isNot(b['ciphertext']));
    },
  );

  test('wrong password is rejected without returning any profile', () async {
    await expectLater(
      codec.decrypt(encrypted, 'a different long password'),
      throwsA(isA<InvalidBackup>()),
    );
  });

  test('ciphertext and authentication-tag tampering are rejected', () async {
    for (final field in ['ciphertext', 'tag']) {
      final envelope = jsonDecode(utf8.decode(encrypted));
      final bytes = base64Decode(envelope[field]);
      bytes[0] ^= 1;
      envelope[field] = base64Encode(bytes);
      await expectLater(
        codec.decrypt(utf8.encode(jsonEncode(envelope)), password),
        throwsA(isA<InvalidBackup>()),
      );
    }
  });

  test(
    'unknown format/version/work factor, truncation and oversized file fail closed',
    () async {
      final envelope = jsonDecode(utf8.decode(encrypted));
      for (final bad in [
        {...envelope, 'version': 2},
        {...envelope, 'algorithm': 'unbounded-kdf'},
        {...envelope, 'salt': 'AAAA'},
        {...envelope, 'unexpected': true},
      ]) {
        await expectLater(
          codec.decrypt(utf8.encode(jsonEncode(bad)), password),
          throwsA(isA<InvalidBackup>()),
        );
      }
      await expectLater(
        codec.decrypt(encrypted.sublist(0, 100), password),
        throwsA(isA<InvalidBackup>()),
      );
      await expectLater(
        codec.decrypt(Uint8List(DeviceBackupCodec.maxFileBytes + 1), password),
        throwsA(isA<InvalidBackup>()),
      );
    },
  );

  test(
    'portable profile never grants paid entitlements or carries account metadata',
    () {
      final raw = snapshot.toJson();
      raw['profile']['firebaseUid'] = 'do-not-export';
      raw['profile']['purchaseToken'] = 'do-not-export';
      raw['profile']['character']['photoUrl'] =
          'https://example.com/private-photo';
      raw['profile']['character']['unlockedCosmetics'] = [
        'theme_royal_gold',
        'earned_memento',
      ];
      raw['profile']['character']['equippedTheme'] = 'theme_royal_gold';
      raw['director']['purchases'] = ['story_neon_archive_01'];
      final portable = DeviceSnapshot.fromJson(raw);
      expect(portable.profile['character']['unlockedCosmetics'], [
        'earned_memento',
      ]);
      expect(portable.profile['character']['equippedTheme'], null);
      expect(portable.profile['character']['photoUrl'], null);
      expect(jsonEncode(portable.toJson()), isNot(contains('do-not-export')));
      expect(portable.director.containsKey('purchases'), false);
    },
  );

  test(
    'invalid progress and duplicated quests are rejected before restore',
    () {
      for (final mutate in <void Function(Map<String, dynamic>)>[
        (r) => r['profile']['character']['level'] = 0,
        (r) => r['profile']['character']['maxXp'] = 0,
        (r) => r['profile']['themeMode'] = 99,
        (r) => r['profile']['notificationMorningHour'] = 25,
        (r) =>
            r['profile']['dailyQuests'].add(r['profile']['dailyQuests'].first),
        (r) => r['profile']['character'] = {},
        (r) => r['director']['history'] = [null],
        (r) => r['director']['day'] = {'invalid': true},
      ]) {
        final raw = snapshot.toJson();
        mutate(raw);
        expect(
          () => DeviceSnapshot.fromJson(raw),
          throwsA(isA<InvalidBackup>()),
        );
      }
    },
  );
}
