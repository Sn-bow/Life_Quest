import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/state/character_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SoundService.muteForTesting();

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
  });
}
