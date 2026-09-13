import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/state/character_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SoundService.muteForTesting();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('account deletion result contract', () {
    test('returns false when data cleanup fails', () async {
      final state = CharacterState(
        firestore: FakeFirebaseFirestore(),
        deleteAccountUidOverride: 'test-user',
        deleteKnownAccountDataOverride: (_) async {
          throw Exception('storage cleanup failed');
        },
        deleteAuthAccountOverride: () async {},
      );

      final didDelete = await state.deleteAccount();

      expect(didDelete, isFalse);
    });

    test('returns true after data and auth cleanup', () async {
      final calls = <String>[];
      final state = CharacterState(
        firestore: FakeFirebaseFirestore(),
        deleteAccountUidOverride: 'test-user',
        deleteKnownAccountDataOverride: (uid) async {
          calls.add('data:$uid');
        },
        deleteAuthAccountOverride: () async {
          calls.add('auth');
        },
      );

      final didDelete = await state.deleteAccount();

      expect(didDelete, isTrue);
      expect(calls, ['data:test-user', 'auth']);
    });

    test('deletes known Firestore account data before auth account', () async {
      final firestore = FakeFirebaseFirestore();
      final calls = <String>[];

      await firestore.collection('users').doc('test-user').set({
        'character': {'name': 'Tester', 'level': 3, 'gold': 100},
      });
      await firestore
          .collection('users')
          .doc('test-user')
          .collection('_meta')
          .doc('adServerTime')
          .set({'t': DateTime(2026, 5, 21).toIso8601String()});

      final state = CharacterState(
        firestore: firestore,
        deleteAccountUidOverride: 'test-user',
        deleteOptionalProfileImageOverride: (uid) async {
          calls.add('storage:$uid');
        },
        deleteAuthAccountOverride: () async {
          calls.add('auth');
        },
      );

      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(
        'lifequest.director.v1.test-user',
        'private history',
      );
      await firestore
          .collection('users')
          .doc('test-user')
          .collection('aiReports')
          .add({'title': 'reported'});
      await preferences.setStringList('lifequest.purchases.v1.test-user', [
        'theme_neon_cyberpunk',
      ]);
      await firestore
          .collection('users')
          .doc('test-user')
          .collection('entitlements')
          .doc('cosmetic_theme_neon')
          .set({'active': true});
      final didDelete = await state.deleteAccount();

      expect(didDelete, isTrue);
      expect(
        preferences.containsKey('lifequest.purchases.v1.test-user'),
        isFalse,
      );
      expect(
        (await firestore
                .collection('users')
                .doc('test-user')
                .collection('entitlements')
                .get())
            .docs,
        isEmpty,
      );
      expect(
        preferences.containsKey('lifequest.director.v1.test-user'),
        isFalse,
      );
      expect(
        (await firestore
                .collection('users')
                .doc('test-user')
                .collection('aiReports')
                .get())
            .docs,
        isEmpty,
      );
      expect(calls, ['storage:test-user', 'auth']);
      expect(
        await firestore.collection('users').doc('test-user').get(),
        isA<DocumentSnapshot>().having((doc) => doc.exists, 'exists', false),
      );
      expect(
        await firestore
            .collection('users')
            .doc('test-user')
            .collection('_meta')
            .doc('adServerTime')
            .get(),
        isA<DocumentSnapshot>().having((doc) => doc.exists, 'exists', false),
      );
    });
  });
}
