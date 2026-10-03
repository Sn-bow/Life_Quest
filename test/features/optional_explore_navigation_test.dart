import 'package:life_quest_final_v2/features/journeys/journey_catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/features/director/on_device_quest_model.dart';
import 'package:life_quest_final_v2/features/director/quest_director_state.dart';
import 'package:life_quest_final_v2/features/system/system_copy.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/screens/achievement_screen.dart';
import 'package:life_quest_final_v2/screens/dungeon/dungeon_home_screen.dart';
import 'package:life_quest_final_v2/screens/growth_hub_screen.dart';
import 'package:life_quest_final_v2/screens/inventory_screen.dart';
import 'package:life_quest_final_v2/screens/main_screen.dart';
import 'package:life_quest_final_v2/screens/today_screen.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/state/combat_state.dart';
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
    testWidgets(
      'unreleased exploration is absent from visible routes in $language',
      (tester) async {
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
        final copy = JourneyCopy(language);
        final growthLabel = copy.choose(['Growth', '성장', '成長', '成長']);
        expect(navLabels, [
          SystemCopy(context).get('status'),
          copy.choose(['Routes', '루트', 'ルート', '路線']),
          growthLabel,
        ]);

        final journalDestination = find.descendant(
          of: nav,
          matching: find.text(growthLabel),
        );
        await tester.tap(journalDestination);
        await tester.pumpAndSettle();
        expect(find.byType(GrowthHubScreen), findsOneWidget);
        expect(find.text(l10n.lqEnterDungeon), findsNothing);
        expect(find.byType(DungeonHomeScreen), findsNothing);
        expect(find.text(l10n.tabInventory), findsNothing);
        expect(find.text(l10n.tabSkill), findsNothing);
        expect(find.text(l10n.tabShop), findsNothing);
        expect(find.text(l10n.tabAchievement), findsNothing);

        final statusDestination = find.descendant(
          of: nav,
          matching: find.text(SystemCopy(context).get('status')),
        );
        await tester.tap(statusDestination);
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const ValueKey('quests-tab')));
        await tester.pumpAndSettle();
        expect(find.byType(TodayScreen), findsOneWidget);
        expect(find.text(l10n.lqEnterDungeon), findsNothing);
        expect(find.byType(DungeonHomeScreen), findsNothing);

        await tester.pumpWidget(const SizedBox());
        director.dispose();
        character.dispose();
        dungeon.dispose();
      },
    );
  }

  testWidgets('archived inventory view cannot launch exploration', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final character = CharacterState();
    final combat = CombatState();
    await character.initializeForLocalGuest(name: 'Tester');
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: character),
          ChangeNotifierProvider.value(value: combat),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: InventoryScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(
      tester.element(find.byType(InventoryScreen)),
    )!;
    expect(find.text(l10n.inventoryGoDungeon), findsNothing);
    expect(find.byType(DungeonHomeScreen), findsNothing);
    await tester.pumpWidget(const SizedBox());
    character.dispose();
    combat.dispose();
  });

  testWidgets(
    'unfinished monster goals stay hidden while earned history stays visible',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final character = CharacterState();
      await character.initializeForLocalGuest(name: 'Tester');
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: character,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: AchievementScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('첫 사냥'), findsNothing);

      await tester.pumpWidget(const SizedBox());
      character.achievementProgress['ac18']!
        ..currentValue = 1
        ..isCompleted = true;
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: character,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: AchievementScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final l10n = AppLocalizations.of(
        tester.element(find.byType(AchievementScreen)),
      )!;
      await tester.tap(find.text(l10n.achievementTabCompleted));
      await tester.pumpAndSettle();
      expect(find.text('첫 사냥'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      character.dispose();
    },
  );
}
