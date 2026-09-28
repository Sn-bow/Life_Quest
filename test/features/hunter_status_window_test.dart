import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_quest_final_v2/features/director/quest_director_state.dart';
import 'package:life_quest_final_v2/features/system/system_copy.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/screens/today_screen.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/theme/quest_theme.dart';
import 'director_layout_test.dart' show LayoutModel;

void main() {
  SoundService.muteForTesting();
  for (final locale in ['ko', 'en', 'ja', 'zh']) {
    testWidgets(
      'complete status frame is visible above navigation at 360x640 $locale',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1;
        tester.view.padding = const FakeViewPadding(top: 24, bottom: 24);
        tester.view.viewPadding = const FakeViewPadding(top: 24, bottom: 24);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPadding);
        addTearDown(tester.view.resetViewPadding);
        final character = CharacterState()..initializeForTesting();
        character.character
          ..name = 'HYEONSEOK / Long hunter name'
          ..xp = 70
          ..statPoints = 3;
        final director = QuestDirectorState(model: LayoutModel());
        await director.bind('compact-hunter-window-test');
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: character),
              ChangeNotifierProvider.value(value: director),
            ],
            child: MaterialApp(
              theme: QuestTheme.build(Brightness.light),
              locale: Locale(locale),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(disableAnimations: true),
                child: child!,
              ),
              home: Scaffold(
                body: TodayScreen(onOpenQuests: () {}, onOpenDungeon: () {}),
                bottomNavigationBar: NavigationBar(
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home),
                      label: 'Status',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.check),
                      label: 'Quests',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.explore),
                      label: 'Explore',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.bar_chart),
                      label: 'Journal',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final frame = find.byKey(const ValueKey('hunter-status-window'));
        final points = find.byKey(const ValueKey('hunter-stat-points'));
        final navTop = tester.getTopLeft(find.byType(NavigationBar)).dy;
        expect(find.byKey(const ValueKey('hunter-name')), findsOneWidget);
        expect(find.byKey(const ValueKey('hunter-level')), findsOneWidget);
        expect(
          tester.widget<Text>(find.byKey(const ValueKey('hunter-xp'))).data,
          startsWith('70 / '),
        );
        for (var i = 0; i < 4; i++) {
          final stat = find.byKey(ValueKey('status-stat-$i'));
          expect(stat, findsOneWidget);
          expect(tester.getBottomLeft(stat).dy, lessThan(navTop));
        }
        expect(
          find.descendant(of: points, matching: find.text('3')),
          findsOneWidget,
        );
        expect(tester.getBottomLeft(points).dy, lessThan(navTop));
        expect(tester.getBottomLeft(frame).dy, lessThanOrEqualTo(navTop - 4));
        expect(find.byKey(const ValueKey('status-plus-open')), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        director.dispose();
        character.dispose();
      },
    );
  }
  for (final size in [
    const Size(320, 900),
    const Size(360, 640),
    const Size(800, 1280),
    const Size(1280, 800),
  ]) {
    for (final locale in ['ko', 'en', 'ja', 'zh']) {
      testWidgets(
        'personal window, real XP and menus at ${size.width}x${size.height}/200% $locale',
        (tester) async {
          SharedPreferences.setMockInitialValues({});
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          final character = CharacterState()..initializeForTesting();
          character.character.name = 'HYUNSEOK / 아주 긴 이름';
          final director = QuestDirectorState(model: LayoutModel());
          await director.bind('hunter-window-test');
          Widget app() => MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: character),
              ChangeNotifierProvider.value(value: director),
            ],
            child: MaterialApp(
              theme: QuestTheme.build(Brightness.light),
              locale: Locale(locale),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(2),
                  disableAnimations: true,
                ),
                child: child!,
              ),
              home: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: TodayScreen(onOpenQuests: () {}, onOpenDungeon: () {}),
                ),
              ),
            ),
          );
          await tester.pumpWidget(app());
          await tester.pumpAndSettle();
          final screen = tester.element(find.byType(TodayScreen));
          final l = AppLocalizations.of(screen)!;
          expect(
            find.byKey(const ValueKey('hunter-status-window')),
            findsOneWidget,
          );
          expect(find.text(character.character.name), findsOneWidget);
          expect(find.text(l.titleNameT0), findsOneWidget);
          expect(find.text(l.lqDailyMissions), findsNothing);
          for (var i = 0; i < 4; i++) {
            expect(find.byKey(ValueKey('status-stat-$i')), findsOneWidget);
          }
          final xp = find.byKey(const ValueKey('hunter-xp'));
          expect(tester.widget<Text>(xp).data, startsWith('0 / '));
          expect(tester.takeException(), isNull);
          final frame = find.byKey(const ValueKey('hunter-status-window'));
          expect(tester.getSize(frame).width, lessThanOrEqualTo(680));
          final nameLeft = tester
              .getTopLeft(find.byKey(const ValueKey('hunter-name')))
              .dx;
          expect(
            nameLeft - tester.getTopLeft(frame).dx,
            greaterThanOrEqualTo(tester.getSize(frame).width * .085 - .001),
          );
          await tester.tap(find.byKey(const ValueKey('quests-tab')));
          await tester.pumpAndSettle();
          expect(find.text(l.lqDailyMissions), findsOneWidget);
          expect(tester.takeException(), isNull);
          expect(character.character.xp, 0);
          await tester.tap(find.byKey(const ValueKey('journal-tab')));
          await tester.pumpAndSettle();
          expect(
            find.text(SystemCopy(screen).get('emptyJournal')),
            findsOneWidget,
          );
          expect(tester.takeException(), isNull);
          await tester.tap(find.byKey(const ValueKey('status-tab')));
          await tester.pumpAndSettle();
          expect(tester.widget<Text>(xp).data, startsWith('0 / '));
          expect(tester.takeException(), isNull);
          // Reopening reads the saved value; the entrance must never award XP.
          character.character.xp = 37.5;
          await tester.pumpWidget(app());
          await tester.pumpAndSettle();
          expect(tester.widget<Text>(xp).data, startsWith('37.5 / '));
          expect(character.character.xp, 37.5);
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox());
          director.dispose();
          character.dispose();
        },
      );
    }
  }
}
