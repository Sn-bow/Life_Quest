import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/state/dungeon_state.dart';
import 'package:life_quest_final_v2/screens/dungeon/dungeon_home_screen.dart';
import 'package:life_quest_final_v2/screens/dungeon/dungeon_map_screen.dart';
import 'package:life_quest_final_v2/screens/dungeon/card_battle_screen.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/theme/quest_theme.dart';
import 'package:life_quest_final_v2/widgets/dungeon_modal.dart';
import 'package:life_quest_final_v2/data/card_database.dart';

void main() {
  SoundService.muteForTesting();
  for (final code in ['ko', 'en', 'ja', 'zh']) {
    testWidgets(
      'first expedition and named map paths fit 320px / 200% in $code',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        tester.view.physicalSize = const Size(320, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final semantics = tester.ensureSemantics();
        final character = CharacterState();
        final dungeon = DungeonState();
        await character.initializeForLocalGuest(name: 'Synthetic tester');
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: character),
              ChangeNotifierProvider.value(value: dungeon),
            ],
            child: MaterialApp(
              theme: QuestTheme.build(Brightness.dark),
              locale: Locale(code),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(2)),
                child: child!,
              ),
              home: const DungeonHomeScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final l = AppLocalizations.of(
          tester.element(find.byType(DungeonHomeScreen)),
        )!;
        expect(tester.takeException(), isNull);
        await tester.scrollUntilVisible(
          find.text(l.lqDungeonStart).hitTestable(),
          250,
        );
        await tester.tap(find.text(l.lqDungeonStart));
        await tester.pumpAndSettle();
        expect(dungeon.isRunActive, isTrue);
        expect(find.byType(DungeonMapScreen), findsOneWidget);
        expect(find.text('0 / 6'), findsOneWidget);
        expect(tester.takeException(), isNull);
        final accessible = dungeon.accessibleNodes.first;
        final label = l.lqDungeonNode(
          l.lqDungeonCombat,
          accessible.row + 1,
          accessible.column + 1,
          l.lqDungeonAvailable,
        );
        await tester.scrollUntilVisible(
          find.bySemanticsLabel(label),
          180,
          scrollable: find
              .descendant(
                of: find.byType(DungeonMapScreen),
                matching: find.byType(Scrollable),
              )
              .first,
        );
        expect(find.bySemanticsLabel(label), findsOneWidget);
        expect(
          tester
              .getSemantics(find.bySemanticsLabel(label))
              .getSemanticsData()
              .hasAction(SemanticsAction.tap),
          isTrue,
        );
        await tester.tap(
          find.byTooltip(
            MaterialLocalizations.of(
              tester.element(find.byType(DungeonMapScreen)),
            ).backButtonTooltip,
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text(l.lqDungeonResume), findsOneWidget);
        await tester.pumpWidget(const SizedBox());
        character.dispose();
        dungeon.dispose();
        semantics.dispose();
      },
    );
    testWidgets(
      'reward text fits and overlay blocks background semantics in $code',
      (tester) async {
        tester.view.physicalSize = const Size(320, 700);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final semantics = tester.ensureSemantics();
        var selected = 0;
        await tester.pumpWidget(
          MaterialApp(
            theme: QuestTheme.build(Brightness.dark),
            locale: Locale(code),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(2)),
              child: child!,
            ),
            home: Scaffold(
              body: Stack(
                fit: StackFit.expand,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('Background battle action'),
                  ),
                  DungeonModal(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final card in CardDatabase.allCards.take(3))
                          CardRewardChoice(
                            card: card,
                            onSelected: () => selected++,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.bySemanticsLabel('Background battle action'), findsNothing);
        expect(tester.takeException(), isNull);
        await tester.tap(find.byType(OutlinedButton).first);
        expect(selected, 1);
        await tester.pumpWidget(const SizedBox());
        semantics.dispose();
      },
    );
  }
}
