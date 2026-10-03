import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:life_quest_final_v2/features/journeys/journey_catalog.dart';
import 'package:life_quest_final_v2/features/journeys/journey_progress.dart';
import 'package:life_quest_final_v2/features/journeys/journey_record.dart';
import 'package:life_quest_final_v2/features/journeys/journey_screen.dart';
import 'package:life_quest_final_v2/features/director/quest_director_state.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'director_layout_test.dart' show LayoutModel;
import 'system_journal_test.dart' show JournalFaultStore;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SoundService.muteForTesting();
  late JourneyCatalog catalog;
  setUpAll(() async => catalog = await JourneyCatalog.load());
  setUp(() => SharedPreferences.setMockInitialValues({}));

  JourneyRun fixture(int count) => JourneyRun(
    id: 'synthetic_record',
    kind: JourneyKind.learning,
    goal: 'Synthetic QA · A question I can answer',
    startedAt: DateTime(2026, 9, 1),
    entries: List.generate(
      count,
      (i) => JourneyEntry(
        at: DateTime(2026, 9, i + 1),
        shortVersion: i.isEven,
        minutes: i.isEven ? 2 : 5,
        note: i == 1 ? '' : 'Synthetic result ${i + 1}\nNext action ${i + 1}',
      ),
    ),
  );

  test(
    'record includes only completed work, saved version and exact multiline notes',
    () {
      final run = fixture(7);
      for (final lang in ['en', 'ko', 'ja', 'zh']) {
        final text = journeyRecordText(run, catalog, JourneyCopy(lang));
        expect(text, contains(run.goal));
        expect(text, contains(run.entries.last.note));
        expect(text, contains(journeyRecordEmpty(JourneyCopy(lang))));
        expect(
          text,
          contains(
            catalog.mission(run.kind, 0).steps(lang, shortVersion: true).single,
          ),
        );
        expect(
          text,
          isNot(contains(catalog.mission(run.kind, 0).steps(lang).first)),
        );
        expect(text, isNot(contains(catalog.mission(run.kind, 7).title(lang))));
      }
    },
  );

  for (final lang in ['en', 'ko', 'ja', 'zh']) {
    for (final size in [const Size(320, 740), const Size(1280, 800)]) {
      testWidgets(
        'completed record is readable without ownership, clipboard failure retries / $lang / $size',
        (tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          final state = CharacterState();
          await state.initializeForLocalGuest(name: 'Synthetic record QA');
          final run = fixture(21);
          state.journeys = JourneyBook(activeId: run.id, runs: [run]);
          final before = state.journeys.toJson().toString();
          expect(state.ownsJourneys, false);
          final copy = JourneyCopy(lang);
          String? copied;
          var fail = true;
          tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
            SystemChannels.platform,
            (call) async {
              if (call.method == 'Clipboard.setData') {
                if (fail) {
                  throw PlatformException(code: 'synthetic clipboard failure');
                }
                copied = (call.arguments as Map)['text'] as String;
              }
              return null;
            },
          );
          addTearDown(
            () => tester.binding.defaultBinaryMessenger
                .setMockMethodCallHandler(SystemChannels.platform, null),
          );
          await tester.pumpWidget(
            ChangeNotifierProvider.value(
              value: state,
              child: MaterialApp(
                locale: Locale(lang),
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(2)),
                  child: child!,
                ),
                home: JourneyRecordScreen(runId: run.id, catalog: catalog),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final button = find.byKey(const ValueKey('journey-record-copy'));
          await tester.tap(button);
          await tester.pumpAndSettle();
          expect(copied, isNull);
          fail = false;
          await tester.tap(button);
          await tester.pumpAndSettle();
          expect(copied, journeyRecordText(run, catalog, copy));
          final last = find.text(run.entries.last.note).last;
          await tester.ensureVisible(last);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(state.questCompletionCount, 0);
          expect(state.journeys.toJson().toString(), before);
          if (lang == 'en' && size.width == 320) {
            // One real deletion is sufficient; repeat layout checks without
            // carrying the research singleton across widget fake zones.
            await state.deleteLocalProfile();
            await tester.pumpAndSettle();
            expect(
              find.byKey(const ValueKey('journey-record-copy')),
              findsNothing,
            );
            expect(find.text(run.entries.last.note), findsNothing);
          }
          await tester.pumpWidget(const SizedBox());
          state.dispose();
        },
      );
    }
  }

  testWidgets(
    'resuming an accepted route saves its selection before opening, retrying disk failure',
    (tester) async {
      final store = JournalFaultStore();
      SharedPreferencesStorePlatform.instance = store;
      final state = CharacterState();
      await state.initializeForLocalGuest(name: 'Synthetic switch QA');
      final director = QuestDirectorState(model: LayoutModel());
      await director.bind('device');
      final learning = await state.startJourney(
        JourneyKind.learning,
        'Question',
      );
      await state.acceptJourney(
        runId: learning.id,
        title: 'QA',
        instruction: 'QA',
        minutes: 2,
        shortVersion: true,
        locale: 'en',
      );
      final order = await state.startJourney(JourneyKind.order, 'Desk');
      expect(state.journeys.activeId, order.id);
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: state),
            ChangeNotifierProvider.value(value: director),
          ],
          child: MaterialApp(
            locale: const Locale('en'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: JourneyRouteScreen(kind: learning.kind, runId: learning.id),
          ),
        ),
      );
      await tester.runAsync(() async {});
      await tester.pumpAndSettle();
      final next = find.byKey(const ValueKey('journey-next'));
      await tester.ensureVisible(next);
      store.fail = true;
      await tester.tap(next);
      await tester.pumpAndSettle();
      expect(find.byType(JourneyMissionScreen), findsNothing);
      store.fail = false;
      await tester.ensureVisible(next);
      await tester.tap(next);
      await tester.pumpAndSettle();
      expect(find.byType(JourneyMissionScreen), findsOneWidget);
      expect(
        JourneyBook.fromJson(store.saved!['journeys']).activeId,
        learning.id,
      );
      expect(state.dailyQuests, hasLength(1));
      expect(state.journeys.active!.stage, 0);
      await tester.pumpWidget(const SizedBox());
      director.dispose();
      state.dispose();
    },
  );
}
