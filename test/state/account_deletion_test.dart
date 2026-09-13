import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/state/character_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SoundService.muteForTesting();
  setUp(
    () => SharedPreferences.setMockInitialValues({
      'lifequest.director.v1.test-user': 'synthetic private history',
      'lifequest.purchases.v1.test-user': ['theme_neon_cyberpunk'],
      'lifequest.director.v1.other-user': 'other account history',
      'lifequest.local.state.v1': 'device profile',
    }),
  );
  test(
    'unaccepted or failed request preserves sign-in and local records',
    () async {
      for (final fails in [false, true]) {
        var signedOut = false;
        final state = CharacterState(
          deleteAccountUidOverride: 'test-user',
          requestAccountDeletionOverride: (_) async {
            if (fails) throw StateError('Synthetic network failure');
            return false;
          },
          signOutAfterDeletionOverride: () async => signedOut = true,
        );
        expect(await state.deleteAccount(), false);
        expect(signedOut, false);
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.containsKey('lifequest.director.v1.test-user'), true);
        state.dispose();
      }
    },
  );
  test(
    'durable request clears only that account caches, then signs out',
    () async {
      final calls = <String>[];
      final state = CharacterState(
        deleteAccountUidOverride: 'test-user',
        requestAccountDeletionOverride: (uid) async {
          calls.add('request:$uid');
          return true;
        },
        signOutAfterDeletionOverride: () async {
          final prefs = await SharedPreferences.getInstance();
          expect(prefs.containsKey('lifequest.director.v1.test-user'), false);
          expect(prefs.containsKey('lifequest.purchases.v1.test-user'), false);
          calls.add('sign-out');
        },
      );
      expect(await state.deleteAccount(), true);
      expect(calls, ['request:test-user', 'sign-out']);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey('lifequest.director.v1.other-user'), true);
      expect(prefs.containsKey('lifequest.local.state.v1'), true);
      state.dispose();
    },
  );
}
