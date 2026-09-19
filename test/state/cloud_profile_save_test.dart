import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_quest_final_v2/features/story/story_chapter.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/state/character_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SoundService.muteForTesting();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'each queued save awaits its own deep snapshot, not another caller',
    () async {
      final firstEntered = Completer<void>(), secondEntered = Completer<void>();
      final firstRelease = Completer<void>(), secondRelease = Completer<void>();
      final snapshots = <Map<String, dynamic>>[];
      final state = CharacterState(
        currentCloudUidOverride: () => 'alice',
        cloudProfileWriterOverride: (uid, data) async {
          expect(uid, 'alice');
          snapshots.add(data);
          if (snapshots.length == 1) {
            firstEntered.complete();
            await firstRelease.future;
          } else {
            secondEntered.complete();
            await secondRelease.future;
          }
        },
      )..initializeCloudForTesting('alice');
      final first = state.forceSave();
      await firstEntered.future;
      state.character.name = 'Second snapshot';
      state.character.starterDeckCardIds.add('base_strike');
      var secondDone = false;
      final second = state.forceSave().then((saved) {
        secondDone = true;
        return saved;
      });
      state.character.starterDeckCardIds.add('base_defend');
      await Future<void>.delayed(Duration.zero);
      expect(secondDone, false);
      expect(snapshots, hasLength(1));
      firstRelease.complete();
      expect(await first, true);
      await secondEntered.future;
      expect(secondDone, false);
      expect(snapshots[0]['character']['name'], 'Cloud test');
      expect(snapshots[0]['character']['starterDeckCardIds'], isEmpty);
      expect(snapshots[1]['character']['name'], 'Second snapshot');
      expect(snapshots[1]['character']['starterDeckCardIds'], ['base_strike']);
      secondRelease.complete();
      expect(await second, true);
      state.dispose();
    },
  );

  test(
    'failed cloud choice rolls back and a later retry actually commits',
    () async {
      var fail = true;
      Map<String, dynamic>? persisted;
      final state = CharacterState(
        currentCloudUidOverride: () => 'alice',
        cloudProfileWriterOverride: (_, data) async {
          if (fail) throw StateError('Synthetic Firestore failure');
          persisted = data;
        },
      )..initializeCloudForTesting('alice');
      final book = StoryChapter.fromJson(
        jsonDecode(File('assets/story/courtyard_ko.json').readAsStringSync()),
      );
      expect(await state.selectStoryChapter('courtyard'), false);
      expect(state.activeStoryChapterId, isNull);
      expect(await state.chooseStory(book, 0, 'listen'), false);
      expect(state.storyChoices, isEmpty);
      expect(persisted, isNull);
      fail = false;
      expect(await state.selectStoryChapter('courtyard'), true);
      expect(await state.chooseStory(book, 0, 'listen'), true);
      expect(persisted!['character']['storyChoices'], {
        'courtyard/arrival': 'listen',
      });
      expect(state.storyChoices, {'courtyard/arrival': 'listen'});
      state.dispose();
    },
  );

  test(
    'a failed first write does not acknowledge or poison a queued next save',
    () async {
      final entered = Completer<void>(), release = Completer<void>();
      var calls = 0;
      final state = CharacterState(
        currentCloudUidOverride: () => 'alice',
        cloudProfileWriterOverride: (_, data) async {
          if (++calls == 1) {
            entered.complete();
            await release.future;
            throw StateError('Synthetic outage');
          }
          expect(data['character']['name'], 'Retry snapshot');
        },
      )..initializeCloudForTesting('alice');
      final first = state.forceSave();
      await entered.future;
      state.character.name = 'Retry snapshot';
      final second = state.forceSave();
      release.complete();
      expect(await first, false);
      expect(await second, true);
      expect(calls, 2);
      state.dispose();
    },
  );

  test(
    'account switch blocks queued writes and never redirects old data to the new UID',
    () async {
      String? uid = 'alice';
      final entered = Completer<void>(), release = Completer<void>();
      final owners = <String>[];
      final state = CharacterState(
        currentCloudUidOverride: () => uid,
        cloudProfileWriterOverride: (owner, _) async {
          owners.add(owner);
          if (owners.length == 1) {
            entered.complete();
            await release.future;
          }
        },
      )..initializeCloudForTesting('alice');
      final first = state.forceSave();
      await entered.future;
      final queued = state.forceSave();
      uid = 'bob';
      release.complete();
      expect(await first, false);
      expect(await queued, false);
      expect(owners, ['alice']);
      expect(
        await state.forceSave(),
        false,
      ); // Bob has not loaded a profile yet.
      state.initializeCloudForTesting('bob');
      expect(await state.forceSave(), true);
      expect(owners, ['alice', 'bob']);
      uid = null;
      expect(await state.forceSave(), false);
      state.dispose();
    },
  );

  test(
    'switching to a device profile invalidates old cloud writes without harming local data',
    () async {
      final entered = Completer<void>(), release = Completer<void>();
      var calls = 0;
      final state = CharacterState(
        currentCloudUidOverride: () => 'alice',
        cloudProfileWriterOverride: (_, __) async {
          calls++;
          entered.complete();
          await release.future;
        },
      )..initializeCloudForTesting('alice');
      final first = state.forceSave();
      await entered.future;
      final queued = state.forceSave();
      await state.initializeForLocalGuest(name: 'Independent device');
      release.complete();
      expect(await first, false);
      expect(await queued, false);
      expect(calls, 1);
      expect(state.isLocalGuest, true);
      expect(state.character.name, 'Independent device');
      expect(await state.forceSave(), true);
      state.dispose();
      final restored = CharacterState();
      await restored.initializeForLocalGuest(name: 'Unused');
      expect(restored.character.name, 'Independent device');
      restored.dispose();
    },
  );

  test(
    'deletion guard cancels queued cloud writes before the server request finishes',
    () async {
      final entered = Completer<void>(), release = Completer<void>();
      final deletionEntered = Completer<void>(),
          deletionReply = Completer<bool>();
      var writes = 0;
      final state = CharacterState(
        currentCloudUidOverride: () => 'alice',
        cloudProfileWriterOverride: (_, __) async {
          writes++;
          entered.complete();
          await release.future;
        },
        deleteAccountUidOverride: 'alice',
        requestAccountDeletionOverride: (_) {
          deletionEntered.complete();
          return deletionReply.future;
        },
        signOutAfterDeletionOverride: () async {},
      )..initializeCloudForTesting('alice');
      final first = state.forceSave();
      await entered.future;
      final queued = state.forceSave();
      final deletion = state.deleteAccount();
      await deletionEntered.future;
      release.complete();
      expect(await first, false);
      expect(await queued, false);
      expect(writes, 1);
      deletionReply.complete(true);
      expect(await deletion, true);
      expect(await state.forceSave(), false);
      state.dispose();
    },
  );

  test(
    'disposed or unbound cloud profiles cannot save through a current sign-in',
    () async {
      final entered = Completer<void>(), release = Completer<void>();
      var writes = 0;
      final state = CharacterState(
        currentCloudUidOverride: () => 'alice',
        cloudProfileWriterOverride: (_, __) async {
          writes++;
          entered.complete();
          await release.future;
        },
      );
      state.initializeForTesting();
      expect(await state.forceSave(), false);
      state.initializeCloudForTesting('alice');
      final first = state.forceSave();
      await entered.future;
      final queued = state.forceSave();
      state.dispose();
      release.complete();
      expect(await first, false);
      expect(await queued, false);
      expect(writes, 1);
    },
  );
}
