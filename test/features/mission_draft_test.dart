import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:life_quest_final_v2/features/journeys/mission_draft_store.dart';
import 'package:life_quest_final_v2/features/session/account_deletion_journal.dart';

class DraftFaultStore extends InMemorySharedPreferencesStore {
  DraftFaultStore() : super.empty();
  bool failWrite = false, failRemove = false;
  @override
  Future<bool> setValue(String type, String key, Object value) async {
    if (failWrite && key.contains('missionDraft')) return false;
    return super.setValue(type, key, value);
  }

  @override
  Future<bool> remove(String key) async {
    if (failRemove && key.contains('missionDraft')) return false;
    return super.remove(key);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'rapid edits retain the last text, including an intentional empty draft',
    () async {
      await Future.wait([
        MissionDraftStore.write('device', 'q1', 'first'),
        MissionDraftStore.write('device', 'q1', 'question\nanswer'),
        MissionDraftStore.write('device', 'q1', ''),
      ]);
      expect(await MissionDraftStore.read('device', 'q1'), '');
      expect(await MissionDraftStore.read('device', 'q2'), isNull);
      await MissionDraftStore.write('device', 'q1', '日本語 한글 🌱');
      expect(await MissionDraftStore.read('device', 'q1'), '日本語 한글 🌱');
    },
  );

  test(
    'write failure is reported, cannot masquerade as durable, and can retry',
    () async {
      final store = DraftFaultStore();
      SharedPreferencesStorePlatform.instance = store;
      await MissionDraftStore.write('device', 'q1', 'saved');
      store.failWrite = true;
      await expectLater(
        MissionDraftStore.write('device', 'q1', 'failed'),
        throwsStateError,
      );
      expect(await MissionDraftStore.read('device', 'q1'), 'saved');
      store.failWrite = false;
      await MissionDraftStore.write('device', 'q1', 'retried');
      expect(await MissionDraftStore.read('device', 'q1'), 'retried');
    },
  );

  test(
    'account cleanup waits for writes, isolates other profiles, retries deletion',
    () async {
      final store = DraftFaultStore();
      SharedPreferencesStorePlatform.instance = store;
      await MissionDraftStore.write('other', 'q1', 'other draft');
      final write = MissionDraftStore.write('alice', 'q1', 'private draft');
      final clear = MissionDraftStore.clear('alice');
      await Future.wait([write, clear]);
      expect(await MissionDraftStore.read('alice', 'q1'), isNull);
      expect(await MissionDraftStore.read('other', 'q1'), 'other draft');
      await MissionDraftStore.write('alice', 'q1', 'private draft');
      store.failRemove = true;
      var signedOut = false;
      await expectLater(
        AccountDeletionJournal.finishLocalCleanup(
          'alice',
          signOut: () async {
            signedOut = true;
          },
        ),
        throwsStateError,
      );
      expect(signedOut, false);
      store.failRemove = false;
      await AccountDeletionJournal.finishLocalCleanup(
        'alice',
        signOut: () async {
          signedOut = true;
        },
      );
      expect(signedOut, true);
      expect(await MissionDraftStore.read('alice', 'q1'), isNull);
      expect(await MissionDraftStore.read('other', 'q1'), 'other draft');
    },
  );
}
