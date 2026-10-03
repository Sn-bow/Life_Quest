import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:life_quest_final_v2/features/journeys/mission_focus_store.dart';
import 'system_journal_test.dart' show JournalFaultStore;
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_quest_final_v2/features/journeys/journey_catalog.dart';
import 'package:life_quest_final_v2/features/journeys/journey_progress.dart';
import 'package:life_quest_final_v2/features/journeys/mission_focus_clock.dart';
import 'package:life_quest_final_v2/features/billing/purchase_verifier.dart';
import 'package:life_quest_final_v2/features/backup/device_backup.dart';
import 'package:life_quest_final_v2/models/quest.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SoundService.muteForTesting();
  setUp(() => SharedPreferences.setMockInitialValues({}));
  Future<CharacterState> local() async {
    final state = CharacterState();
    await state.initializeForLocalGuest(
      name: 'Synthetic QA',
      languageCode: 'en',
    );
    addTearDown(state.dispose);
    return state;
  }

  Future<Quest> accept(CharacterState state, String id, {bool short = false}) =>
      state.acceptJourney(
        runId: id,
        title: 'Synthetic mission',
        instruction: 'Synthetic instruction',
        minutes: short ? 2 : 5,
        shortVersion: short,
        locale: 'en',
      );

  test(
    'renaming a route saves its goal without losing accepted progress',
    () async {
      final store = JournalFaultStore();
      SharedPreferencesStorePlatform.instance = store;
      final state = await local();
      final run = await state.startJourney(JourneyKind.order, 'Desk');
      final quest = await accept(state, run.id);
      await state.renameJourneyGoal(run.id, '  Study desk  ');
      final saved = JourneyBook.fromJson(store.saved!['journeys']);
      expect(saved.active!.goal, 'Study desk');
      expect(saved.active!.id, run.id);
      expect(saved.active!.stage, 0);
      expect(state.dailyQuests.single.id, quest.id);
      await expectLater(
        state.renameJourneyGoal(run.id, '   '),
        throwsArgumentError,
      );
      expect(state.journeys.active!.goal, 'Study desk');
    },
  );
  test(
    'accepted mission survives midnight and is removed only after completion',
    () async {
      final state = await local();
      final run = await state.startJourney(JourneyKind.learning, 'Plants');
      final quest = await accept(state, run.id, short: true);
      final now = DateTime.now();
      state.debugResetQuestsIfNeeded(
        now.subtract(const Duration(days: 2)),
        now: now,
      );
      expect(state.dailyQuests.single, same(quest));
      expect(state.dailyQuests.single.journeyShortVersion, true);
      expect(state.journeys.active!.stage, 0);
      await state.completeQuestDurably(quest);
      state.debugResetQuestsIfNeeded(
        now,
        now: now.add(const Duration(days: 1)),
      );
      expect(state.dailyQuests, isEmpty);
      expect(state.journeys.active!.stage, 1);
      expect(state.journeys.active!.entries.single.shortVersion, true);
    },
  );
  test(
    'disk failure retries the same route, acceptance and completion once',
    () async {
      final store = JournalFaultStore();
      SharedPreferencesStorePlatform.instance = store;
      final state = await local();
      store.fail = true;
      await expectLater(
        state.startJourney(JourneyKind.order, 'Desk'),
        throwsStateError,
      );
      store.fail = false;
      final run = await state.startJourney(JourneyKind.order, 'Desk');
      expect(state.journeys.runs, hasLength(1));
      store.fail = true;
      await expectLater(accept(state, run.id), throwsStateError);
      store.fail = false;
      final quest = await accept(state, run.id);
      expect(state.dailyQuests.where((q) => q.id == quest.id), hasLength(1));
      expect((store.saved!['dailyQuests'] as List).length, 1);
      store.fail = true;
      quest.completionNote = 'Put things away';
      await expectLater(state.completeQuestDurably(quest), throwsStateError);
      final xp = state.character.xp;
      store.fail = false;
      await state.completeQuestDurably(quest);
      expect(state.character.xp, xp);
      expect(state.journeys.active!.entries, hasLength(1));
      expect(
        JourneyBook.fromJson(
          store.saved!['journeys'],
        ).active!.entries.single.note,
        'Put things away',
      );
    },
  );
  test(
    'deleting local profile removes its timer without touching another account',
    () async {
      final state = await local();
      final prefs = await SharedPreferences.getInstance();
      final device = MissionFocusStore.key('device', 'q1');
      final other = MissionFocusStore.key('other-account', 'q1');
      await prefs.setString(device, '{}');
      await prefs.setString(other, '{}');
      await state.deleteLocalProfile();
      expect(prefs.containsKey(device), false);
      expect(prefs.containsKey(other), true);
    },
  );
  test(
    'all 84 missions have complete distinct four-language instructions',
    () async {
      final catalog = await JourneyCatalog.load();
      for (final kind in JourneyKind.values) {
        expect(catalog.routes[kind], hasLength(21));
        for (final lang in ['en', 'ko', 'ja', 'zh']) {
          final missions = catalog.routes[kind]!;
          expect(missions.map((m) => m.title(lang)).toSet(), hasLength(21));
          expect(
            missions.map((m) => m.steps(lang).join()).toSet(),
            hasLength(21),
          );
          for (final mission in missions) {
            expect(mission.steps(lang), hasLength(2));
            final small = mission.steps(lang, shortVersion: true);
            expect(small, hasLength(1));
            expect(small.single.trim().length, greaterThanOrEqualTo(8));
            expect(small.single, isNot(mission.steps(lang).first));
            expect(mission.title(lang), isNotEmpty);
            // CJK instructions convey a complete action with fewer characters.
            expect(
              mission.steps(lang).every((s) => s.trim().length >= 8),
              true,
            );
          }
        }
      }
    },
  );
  test(
    'first seven missions finish, step eight requires verified ownership',
    () async {
      final state = await local();
      final run = await state.startJourney(
        JourneyKind.learning,
        'Learn one topic',
      );
      for (var i = 0; i < 7; i++) {
        final quest = await accept(state, run.id, short: i == 2);
        quest.completionNote = 'Result $i';
        final receipt = await state.completeQuestDurably(quest);
        final count = state.questCompletionCount;
        final same = await state.completeQuestDurably(quest);
        expect(same.id, receipt.id);
        expect(state.questCompletionCount, count);
        expect(state.journeys.active!.stage, i + 1);
      }
      expect(state.journeys.active!.entries[2].shortVersion, true);
      expect(state.journeys.active!.entries.last.note, 'Result 6');
      await expectLater(accept(state, run.id), throwsStateError);
      state.setPurchasedEntitlements({journeysCompleteProductId});
      final stepEight = await accept(state, run.id);
      await state.completeQuestDurably(stepEight);
      expect(state.journeys.active!.stage, 8);
      state.setPurchasedEntitlements({});
      expect(state.ownsJourneys, false);
      expect(state.journeys.active!.stage, 8);
      await expectLater(accept(state, run.id), throwsStateError);
    },
  );
  test(
    'complete route, return, archive and restart do not duplicate old rewards',
    () async {
      final state = await local();
      state.setPurchasedEntitlements({journeysCompleteProductId});
      final run = await state.startJourney(JourneyKind.order, 'Clear desk');
      Quest? first;
      for (var i = 0; i < 21; i++) {
        final quest = await accept(state, run.id);
        first ??= quest;
        await state.completeQuestDurably(quest);
      }
      expect(state.journeys.active!.completed, true);
      final before = state.questCompletionCount;
      final forgedDuplicate = Quest.fromJson(
        first!.toJson()..['isCompleted'] = false,
      );
      await expectLater(
        state.completeQuestDurably(forgedDuplicate),
        throwsStateError,
      );
      expect(state.questCompletionCount, before);
      await state.startJourney(JourneyKind.order, 'Clear shelf');
      expect(state.journeys.runs, hasLength(2));
      expect(state.journeys.active!.stage, 0);
      expect(state.journeys.runs.first.stage, 21);
      final reopened = await local();
      expect(reopened.journeys.runs, hasLength(2));
      expect(reopened.journeys.runs.first.stage, 21);
      expect(reopened.journeys.active!.goal, 'Clear shelf');
    },
  );
  test(
    'journey and its notes survive backup while paid access is not portable',
    () async {
      final state = await local();
      final run = await state.startJourney(
        JourneyKind.connection,
        'Listen better',
      );
      final quest = await accept(state, run.id);
      quest.completionNote = 'An open question';
      await state.completeQuestDurably(quest);
      final snapshot = DeviceSnapshot.create(
        profile: state.exportDeviceProfile(),
        director: {},
        createdAt: DateTime.now(),
      );
      final roundtrip = DeviceSnapshot.fromJson(
        jsonDecode(jsonEncode(snapshot.toJson())),
      );
      final book = JourneyBook.fromJson(roundtrip.profile['journeys']);
      expect(book.active!.entries.single.note, 'An open question');
      expect(book.active!.stage, 1);
      final broken = snapshot.toJson();
      (broken['profile'] as Map)['journeys'] = {
        'version': 1,
        'runs': [
          {'id': 'bad'},
        ],
      };
      expect(
        () => DeviceSnapshot.fromJson(broken),
        throwsA(isA<InvalidBackup>()),
      );
      expect(roundtrip.profile.containsKey('entitlements'), false);
    },
  );
  test(
    'legacy Plus owner gets routes; another entitlement cannot unlock them',
    () async {
      final state = await local();
      state.setPurchasedEntitlements({'remove_ads'});
      expect(state.ownsJourneys, false);
      state.setPurchasedEntitlements({statusWindowPlusProductId});
      expect(state.ownsJourneys, true);
      state.resetState();
      expect(state.journeys.runs, isEmpty);
      expect(state.ownsJourneys, false);
    },
  );
  test(
    'focus survives background, restart, pause and clock changes without reward',
    () {
      final now = DateTime(2026, 10, 3, 12);
      final clock = MissionFocusClock(300)..start(now);
      expect(clock.remaining(now.add(const Duration(seconds: 42))), 258);
      final restored = MissionFocusClock.fromJson(clock.toJson(), 300);
      expect(restored.remaining(now.add(const Duration(minutes: 10))), 0);
      expect(restored.remaining(now.subtract(const Duration(hours: 1))), 300);
      clock.pause(now.add(const Duration(seconds: 42)));
      expect(clock.remaining(now.add(const Duration(days: 1))), 258);
      clock.start(now.add(const Duration(days: 1)));
      expect(
        clock.remaining(now.add(const Duration(days: 1, seconds: 20))),
        238,
      );
      clock.reset();
      expect(clock.remaining(now), 300);
      expect(clock.running, false);
    },
  );
}
