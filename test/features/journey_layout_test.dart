import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:life_quest_final_v2/features/journeys/journey_catalog.dart';
import 'package:life_quest_final_v2/features/journeys/journey_progress.dart';
import 'package:life_quest_final_v2/features/journeys/journey_screen.dart';
import 'package:life_quest_final_v2/features/journeys/journey_purchase_screen.dart';
import 'package:life_quest_final_v2/features/journeys/mission_focus_screen.dart';
import 'package:life_quest_final_v2/features/journeys/mission_draft_store.dart';
import 'package:life_quest_final_v2/features/journeys/journey_samples.dart';
import 'package:life_quest_final_v2/features/director/quest_director_state.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/screens/today_screen.dart';
import 'director_layout_test.dart' show LayoutModel;
import 'mission_draft_test.dart' show DraftFaultStore;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SoundService.muteForTesting();
  late JourneyCatalog catalog;
  setUpAll(() async => catalog = await JourneyCatalog.load());
  for (final locale in ['en', 'ko', 'ja', 'zh']) {
    testWidgets(
      'purchase samples use shipped content without an account / $locale',
      (tester) async {
        tester.view.physicalSize = const Size(320, 740);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(locale),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(2)),
              child: child!,
            ),
            home: const Scaffold(
              body: SingleChildScrollView(child: JourneySamples()),
            ),
          ),
        );
        await tester.tap(find.byType(ExpansionTile));
        await tester.pump();
        await tester.runAsync(() async {});
        await tester.pumpAndSettle();
        for (final kind in JourneyKind.values) {
          final chip = find.byKey(ValueKey('journey-sample-${kind.name}'));
          await tester.ensureVisible(chip);
          await tester.tap(chip);
          await tester.pumpAndSettle();
          final mission = catalog.mission(kind, journeyFreeStages);
          expect(find.text(mission.title(locale)), findsOneWidget);
          expect(find.text(mission.steps(locale).last), findsOneWidget);
          expect(
            find.text(mission.steps(locale, shortVersion: true).single),
            findsOneWidget,
          );
          await tester.ensureVisible(find.text(mission.steps(locale).last));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
      },
    );
  }
  testWidgets(
    'accept small mission, note result, show real reward, advance once',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final draftStore = DraftFaultStore();
      SharedPreferencesStorePlatform.instance = draftStore;
      final state = CharacterState();
      await state.initializeForLocalGuest(name: 'Synthetic flow QA');
      final director = QuestDirectorState(model: LayoutModel());
      await director.bind('device');
      final run = await state.startJourney(
        JourneyKind.learning,
        'How does a plant grow?',
      );
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
            home: JourneyRouteScreen(kind: run.kind, runId: run.id),
          ),
        ),
      );
      await tester.runAsync(() async {});
      await tester.pumpAndSettle();
      final next = find.byKey(const ValueKey('journey-next'));
      await tester.ensureVisible(next);
      await tester.tap(next);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('journey-small')));
      await tester.pumpAndSettle();
      final accept = find.byKey(const ValueKey('journey-accept'));
      await tester.ensureVisible(accept);
      await tester.tap(accept);
      await tester.runAsync(() async {});
      await tester.pumpAndSettle();
      expect(state.dailyQuests.single.journeyShortVersion, true);
      final field = find.byKey(const ValueKey('journey-note'));
      await tester.ensureVisible(field);
      draftStore.failWrite = true;
      await tester.enterText(field, 'I chose the question about roots.');
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('journey-draft-retry')), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(JourneyMissionScreen), findsOneWidget);
      expect(find.text('I chose the question about roots.'), findsOneWidget);
      draftStore.failWrite = false;
      final questionField = find.byKey(const ValueKey('journey-tool-field-0'));
      final answerField = find.byKey(const ValueKey('journey-tool-field-1'));
      await tester.ensureVisible(questionField);
      await tester.enterText(questionField, 'What do roots absorb?');
      await tester.ensureVisible(answerField);
      await tester.enterText(answerField, 'Water and minerals.');
      await tester.pumpAndSettle();
      draftStore.failWrite = true;
      await tester.enterText(answerField, 'Water and minerals from soil.');
      await tester.pumpAndSettle();
      draftStore.failWrite = false;
      final retry = find.byKey(const ValueKey('journey-draft-retry'));
      await tester.ensureVisible(retry);
      await tester.tap(retry);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('journey-draft-retry')), findsNothing);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.ensureVisible(next);
      await tester.tap(next);
      await tester.pumpAndSettle();
      expect(find.text('I chose the question about roots.'), findsOneWidget);
      expect(find.text('What do roots absorb?'), findsOneWidget);
      expect(find.text('Water and minerals from soil.'), findsOneWidget);
      expect(state.journeys.active!.stage, 0);
      expect(state.systemJournal.receipts, isEmpty);
      final finish = find.byKey(const ValueKey('journey-finish'));
      await tester.ensureVisible(finish);
      await tester.tap(finish);
      await tester.runAsync(() async {});
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('system-reward-xp-change')),
        findsOneWidget,
      );
      final close = find.byKey(const ValueKey('system-reward-return'));
      await tester.ensureVisible(close);
      await tester.tap(close);
      await tester.pumpAndSettle();
      expect(state.journeys.active!.stage, 1);
      expect(
        state.journeys.active!.entries.single.tool!.field(1),
        'Water and minerals from soil.',
      );
      expect(
        state.journeys.active!.entries.single.note,
        'I chose the question about roots.',
      );
      expect(state.systemJournal.receipts, hasLength(1));
      expect(
        await MissionDraftStore.read('device', 'journey:${run.id}:0'),
        isNull,
      );
      expect(find.byType(JourneyRouteScreen), findsOneWidget);
      final completed = find.text(
        '1. ${catalog.mission(run.kind, 0).title('en')}',
      );
      await tester.ensureVisible(completed);
      await tester.tap(completed);
      await tester.pumpAndSettle();
      expect(find.text('Recorded actions · 1'), findsOneWidget);
      expect(
        find.text(
          catalog.mission(run.kind, 0).steps('en', shortVersion: true).single,
        ),
        findsOneWidget,
      );
      expect(
        find.text(catalog.mission(run.kind, 0).steps('en').first),
        findsNothing,
      );
      await tester.tap(find.text('Back to route'));
      await tester.pumpAndSettle();
      final record = find.byKey(const ValueKey('journey-record'));
      await tester.ensureVisible(record);
      await tester.tap(record);
      await tester.pumpAndSettle();
      expect(find.byType(JourneyRecordScreen), findsOneWidget);
      expect(find.text('I chose the question about roots.'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.ensureVisible(next);
      await tester.tap(next);
      await tester.pumpAndSettle();
      expect(find.text('Your earlier notes'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      director.dispose();
      state.dispose();
    },
  );
  testWidgets('paid previews show a sample and preserve the locked boundary', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final state = CharacterState();
    await state.initializeForLocalGuest(name: 'Synthetic preview QA');
    final director = QuestDirectorState(model: LayoutModel());
    await director.bind('device');
    final run = await state.startJourney(JourneyKind.learning, 'Plants');
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
          home: JourneyRouteScreen(kind: run.kind, runId: run.id),
        ),
      ),
    );
    await tester.runAsync(() async {});
    await tester.pumpAndSettle();
    for (final stage in [8, 7]) {
      final mission = catalog.mission(run.kind, stage);
      final title = find.text('${stage + 1}. ${mission.title('en')}');
      await tester.ensureVisible(title);
      await tester.tap(title);
      await tester.pumpAndSettle();
      expect(
        find.text(mission.steps('en').first),
        stage == 7 ? findsOneWidget : findsNothing,
      );
      if (stage == 8) {
        expect(find.text('See Life Quest Complete'), findsOneWidget);
      }
      final back = find.text('Back to route');
      await tester.ensureVisible(back);
      await tester.tap(back);
      await tester.pumpAndSettle();
    }
    expect(state.journeys.active!.stage, 0);
    expect(state.dailyQuests, isEmpty);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    director.dispose();
    state.dispose();
  });
  for (final size in [
    const Size(320, 740),
    const Size(800, 1280),
    const Size(1280, 800),
  ]) {
    for (final locale in ['ko', 'en', 'ja', 'zh']) {
      testWidgets('all route surfaces fit $size / $locale / 200% text', (
        tester,
      ) async {
        SharedPreferences.setMockInitialValues({});
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final state = CharacterState();
        await state.initializeForLocalGuest(name: 'Synthetic layout QA');
        final director = QuestDirectorState(model: LayoutModel());
        await director.bind('device');
        final run = await state.startJourney(
          JourneyKind.learning,
          'A long personal goal 個人的な目標を少しずつ進める 나의 목표',
        );
        final quest = await state.acceptJourney(
          runId: run.id,
          title: catalog.mission(run.kind, 0).title(locale),
          instruction: 'Synthetic QA',
          minutes: 5,
          shortVersion: false,
          locale: locale,
        );
        for (final screen in <Widget>[
          TodayScreen(onOpenQuests: () {}),
          const JourneyLibraryScreen(),
          JourneyRouteScreen(kind: run.kind, runId: run.id),
          JourneyRecordScreen(runId: run.id, catalog: catalog),
          JourneyMissionScreen(runId: run.id, stage: 0, catalog: catalog),
          MissionFocusScreen(quest: quest, scope: 'device'),
          const JourneyPurchaseScreen(),
        ]) {
          await tester.pumpWidget(
            MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: state),
                ChangeNotifierProvider.value(value: director),
              ],
              child: MaterialApp(
                locale: Locale(locale),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(2)),
                  child: child!,
                ),
                home: screen,
              ),
            ),
          );
          // Cached asset futures originate in setUpAll's real async zone.
          await tester.runAsync(() async {});
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull, reason: '$screen initial');
          final scroll = find.byType(Scrollable).first;
          await tester.drag(scroll, const Offset(0, -1800));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull, reason: '$screen scrolled');
          await tester.pumpWidget(const SizedBox());
        }
        director.dispose();
        state.dispose();
      });
    }
  }
}
