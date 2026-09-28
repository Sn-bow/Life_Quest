import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/features/director/on_device_quest_model.dart';
import 'package:life_quest_final_v2/features/director/quest_director_state.dart';
import 'package:life_quest_final_v2/features/system/system_copy.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/screens/dungeon/dungeon_home_screen.dart';
import 'package:life_quest_final_v2/screens/growth_hub_screen.dart';
import 'package:life_quest_final_v2/screens/main_screen.dart';
import 'package:life_quest_final_v2/screens/today_screen.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/state/dungeon_state.dart';
import 'package:life_quest_final_v2/theme/quest_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _UnavailableModel extends OnDeviceQuestModel {
  @override
  Future<ModelSnapshot> status() async =>
      const ModelSnapshot(OnDeviceModelStatus.unavailable);

  @override
  Future<void> cancel() async {}
}

void main() {
  SoundService.muteForTesting();

  for (final language in ['ko', 'en', 'ja', 'zh']) {
    testWidgets('exploration is a secondary route in $language', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final character = CharacterState();
      await character.initializeForLocalGuest(
        name: 'Tester',
        languageCode: language,
      );
      final director = QuestDirectorState(model: _UnavailableModel());
      final dungeon = DungeonState();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: character),
            ChangeNotifierProvider.value(value: director),
            ChangeNotifierProvider.value(value: dungeon),
          ],
          child: MaterialApp(
            theme: QuestTheme.build(Brightness.dark),
            locale: Locale(language),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: const MainScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final nav = find.byType(NavigationBar);
      expect(tester.widget<NavigationBar>(nav).destinations, hasLength(3));
      final context = tester.element(nav);
      final l10n = AppLocalizations.of(context)!;
      final navLabels = tester
          .widget<NavigationBar>(nav)
          .destinations
          .cast<NavigationDestination>()
          .map((destination) => destination.label)
          .toList();
      expect(navLabels, [
        SystemCopy(context).get('status'),
        l10n.tabQuests,
        SystemCopy(context).get('journal'),
      ]);

      final journalDestination = find.descendant(
        of: nav,
        matching: find.text(SystemCopy(context).get('journal')),
      );
      await tester.tap(journalDestination);
      await tester.pumpAndSettle();
      expect(find.byType(GrowthHubScreen), findsOneWidget);
      final exploreLink = find.text(l10n.lqEnterDungeon);
      await tester.scrollUntilVisible(
        exploreLink,
        200,
        scrollable: find
            .descendant(
              of: find.byType(GrowthHubScreen),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.pumpAndSettle();
      expect(exploreLink.hitTestable(), findsOneWidget);
      await tester.tap(exploreLink);
      await tester.pumpAndSettle();
      expect(find.byType(DungeonHomeScreen), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(GrowthHubScreen), findsOneWidget);

      final statusDestination = find.descendant(
        of: nav,
        matching: find.text(SystemCopy(context).get('status')),
      );
      await tester.tap(statusDestination);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('quests-tab')));
      await tester.pumpAndSettle();
      final todayExplore = find.text(l10n.lqEnterDungeon);
      await tester.scrollUntilVisible(
        todayExplore,
        200,
        scrollable: find
            .descendant(
              of: find.byType(TodayScreen),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.pumpAndSettle();
      expect(todayExplore.hitTestable(), findsOneWidget);
      await tester.tap(todayExplore);
      await tester.pumpAndSettle();
      expect(find.byType(DungeonHomeScreen), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(TodayScreen), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      director.dispose();
      character.dispose();
      dungeon.dispose();
    });
  }
}
