import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/features/session/welcome_screen.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/screens/onboarding_screen.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/theme/quest_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SoundService.muteForTesting();
  const growthTerms = {
    'ko': '성장 기록',
    'en': 'Growth Record',
    'ja': '成長記録',
    'zh': '成長紀錄',
  };
  const retiredTerms = {
    'ko': ['탐험', '이야기'],
    'en': ['explor', 'stor'],
    'ja': ['探索', '物語'],
    'zh': ['探索', '故事'],
  };

  for (final lang in ['ko', 'en', 'ja', 'zh']) {
    testWidgets('welcome actions remain usable at 320px and 200% text: $lang', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 720);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var starts = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: QuestTheme.build(Brightness.dark),
          locale: Locale(lang),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(2)),
            child: child!,
          ),
          home: WelcomeScreen(
            onStart: () async {
              starts++;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      final l = AppLocalizations.of(
        tester.element(find.byType(WelcomeScreen)),
      )!;
      expect(find.text(l.lqWelcomeTitle), findsOneWidget);
      expect(find.text('CHAPTER 00'), findsNothing);
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('welcome-status-preview')),
        240,
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('welcome-status-preview')),
        findsOneWidget,
      );
      expect(find.text(l.lqGuestName), findsOneWidget);
      expect(find.text(l.statusStatStrength), findsOneWidget);
      expect(find.text(l.statusStatWisdom), findsOneWidget);
      expect(find.text(l.statusStatHealth), findsOneWidget);
      expect(find.text(l.statusStatCharm), findsOneWidget);
      await tester.scrollUntilVisible(find.text(l.statusStatCharm), 300);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.scrollUntilVisible(find.byType(FilledButton), 400);
      await tester.pumpAndSettle();
      await Scrollable.ensureVisible(
        tester.element(find.byType(FilledButton)),
        alignment: .5,
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text(l.lqWelcomeStepThree), findsOneWidget);
      expect(find.text(l.lqWelcomeStepThreeBody), findsOneWidget);
      final stepThreeCopy =
          '${l.lqWelcomeStepThree} ${l.lqWelcomeStepThreeBody}';
      expect(stepThreeCopy, contains(growthTerms[lang]));
      for (final term in retiredTerms[lang]!) {
        expect(stepThreeCopy, isNot(contains(term)));
      }
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      expect(starts, 1);
    });
  }

  testWidgets('status preview reflows a personalized name at 320px and 200%', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: QuestTheme.build(Brightness.dark),
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: const Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: HunterWelcomeStatusPreview(
                name: 'A much longer player name',
                level: 12,
                xp: 45,
                maxXp: 150,
                stats: [3, 4, 5, 6],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('A much longer player name'), findsOneWidget);
    expect(find.text('45 / 150 XP'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final lang in ['ko', 'en', 'ja', 'zh']) {
    testWidgets('account onboarding keeps status and action usable: $lang', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final state = CharacterState();
      await state.initializeForLocalGuest(name: 'A much longer player name');
      tester.view.physicalSize = const Size(320, 720);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: state,
          child: MaterialApp(
            theme: QuestTheme.build(Brightness.dark),
            locale: Locale(lang),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(2)),
              child: child!,
            ),
            home: const OnboardingScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('welcome-status-preview')),
        240,
      );
      expect(find.text('A much longer player name'), findsOneWidget);
      await tester.scrollUntilVisible(find.byType(FilledButton), 400);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final l = AppLocalizations.of(
        tester.element(find.byType(OnboardingScreen)),
      )!;
      expect(find.text(l.onboardingPage3Title), findsOneWidget);
      expect(find.text(l.onboardingPage3Body), findsOneWidget);
      final stepThreeCopy =
          '${l.onboardingPage3Title} ${l.onboardingPage3Body}';
      expect(stepThreeCopy, contains(growthTerms[lang]));
      for (final term in retiredTerms[lang]!) {
        expect(stepThreeCopy, isNot(contains(term)));
      }
      await tester.pumpWidget(const SizedBox.shrink());
      state.dispose();
    });
  }
}
