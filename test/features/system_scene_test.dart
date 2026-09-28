import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_quest_final_v2/features/director/quest_director_state.dart';
import 'package:life_quest_final_v2/features/system/system_journal.dart';
import 'package:life_quest_final_v2/features/system/system_widgets.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/theme/quest_theme.dart';
import 'director_layout_test.dart' show LayoutModel;

void main() {
  SoundService.muteForTesting();
  testWidgets(
    'reward return stays above Android navigation on a Japanese phone',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 2.625; // 411 x 731 logical pixels.
      tester.view.padding = const FakeViewPadding(top: 52, bottom: 24);
      tester.view.viewPadding = const FakeViewPadding(top: 52, bottom: 24);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPadding);
      addTearDown(tester.view.resetViewPadding);
      final receipt = GrowthReceipt(
        id: 'reward-phone',
        questId: 'rest',
        title: '無理せず5分体をほぐす',
        day: '2026-09-28',
        source: 'quest',
        at: DateTime(2026, 9, 28),
        category: 2,
        baseXp: 10,
        gold: 5,
        levelBefore: 1,
        levelAfter: 1,
        xp: 60,
        bonusXp: 50,
        xpBefore: 0,
        xpAfter: 60,
        maxXpAfter: 150,
        statChanges: const [0, 0, 0, 0],
      );
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ja'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: QuestTheme.build(Brightness.dark),
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: FilledButton(
                  onPressed: () => showSystemReward(context, receipt),
                  child: const Text('Open reward'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open reward'));
      await tester.pumpAndSettle();
      final returnButton = find.byKey(const ValueKey('system-reward-return'));
      expect(returnButton, findsOneWidget);
      expect(tester.getBottomLeft(returnButton).dy, lessThan(731 - 24));
      expect(find.text('+60 XP'), findsOneWidget);
      await tester.tap(returnButton);
      await tester.pumpAndSettle();
      expect(find.byType(SystemRewardScene), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  for (final locale in ['ko', 'en', 'ja', 'zh']) {
    testWidgets(
      'accept, complete and dismiss at 320px/200%, reduced motion $locale',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        tester.view.physicalSize = const Size(320, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final character = CharacterState();
        await character.initializeForLocalGuest(name: 'QA');
        character.character.totalQuestCompletions = 1;
        if (locale == 'ko') character.character.xp = 145;
        await character.maybeOfferSystemQuest(availableMinutes: 15);
        final director = QuestDirectorState(model: LayoutModel());
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: character),
              ChangeNotifierProvider.value(value: director),
            ],
            child: MaterialApp(
              theme: QuestTheme.build(Brightness.dark),
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
              home: const Scaffold(
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: SystemOfferCard(),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final primary = find.byKey(const ValueKey('system-primary'));
        await tester.ensureVisible(primary);
        await tester.tap(primary);
        await tester.pumpAndSettle();
        expect(
          character.systemJournal.current!.status,
          SystemOfferStatus.accepted,
        );
        expect(tester.takeException(), isNull);
        await tester.ensureVisible(primary);
        await tester.tap(primary);
        await tester.pumpAndSettle();
        expect(find.byType(SystemRewardScene), findsOneWidget);
        expect(find.text('+65 XP'), findsOneWidget);
        if (locale == 'ko') {
          expect(find.text('Lv.1  →  Lv.2'), findsOneWidget);
          expect(character.lastGrowthReceipt!.statChanges[1], 3);
        }
        expect(tester.takeException(), isNull);
        final close = find.descendant(
          of: find.byType(SystemRewardScene),
          matching: find.byType(IconButton),
        );
        await tester.tap(close);
        await tester.pumpAndSettle();
        expect(character.systemJournal.current, isNull);
        expect(character.systemJournal.receipts.length, 1);
        expect(find.byType(SystemRewardScene), findsNothing);
        await tester.pumpWidget(const SizedBox());
        director.dispose();
        character.dispose();
      },
    );
  }
}
