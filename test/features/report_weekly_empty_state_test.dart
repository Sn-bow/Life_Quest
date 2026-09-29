import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/screens/quests_screen.dart';
import 'package:life_quest_final_v2/screens/report_screen.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  for (final language in ['en', 'ja', 'ko', 'zh']) {
    testWidgets(
      'weekly report explains an empty week in $language and shows activity later',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        tester.view.physicalSize = const Size(411, 731);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final locale = language == 'zh'
            ? const Locale('zh', 'TW')
            : Locale(language);
        final l10n = lookupAppLocalizations(locale);
        final character = CharacterState()..initializeForTesting();

        await tester.pumpWidget(
          ChangeNotifierProvider.value(
            value: character,
            child: MaterialApp(
              locale: locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              home: const ReportScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final empty = find.byKey(const ValueKey('report-weekly-empty'));
        expect(empty, findsOneWidget);
        expect(find.text(l10n.reportWeeklyActivityEmpty), findsOneWidget);
        expect(tester.getSize(empty).height, lessThanOrEqualTo(130));
        expect(find.byKey(const ValueKey('report-weekly-chart')), findsNothing);
        expect(find.byKey(const ValueKey('report-plus-open')), findsOneWidget);
        final openQuests = find.byKey(
          const ValueKey('report-weekly-open-quests'),
        );
        expect(find.text(l10n.reportWeeklyActivityOpenQuests), findsOneWidget);
        await tester.ensureVisible(openQuests);
        await tester.tap(openQuests);
        await tester.pumpAndSettle();
        expect(find.byType(QuestsScreen), findsOneWidget);
        Navigator.of(tester.element(find.byType(QuestsScreen))).pop();
        await tester.pumpAndSettle();

        final quest = character.dailyQuests.first;
        quest.isCompleted = true;
        quest.completedDate = DateTime.now();
        character.refreshState();
        await tester.pumpAndSettle();

        expect(empty, findsNothing);
        final chart = find.byKey(const ValueKey('report-weekly-chart'));
        expect(chart, findsOneWidget);
        expect(tester.getSize(chart).height, 300);
        expect(tester.takeException(), isNull);

        await tester.pumpWidget(const SizedBox());
        character.dispose();
      },
    );
  }
}
