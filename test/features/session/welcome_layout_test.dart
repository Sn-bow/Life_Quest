import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/features/session/welcome_screen.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/theme/quest_theme.dart';

void main() {
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
      await tester.scrollUntilVisible(find.byType(FilledButton), 400);
      await tester.pumpAndSettle();
      await Scrollable.ensureVisible(
        tester.element(find.byType(FilledButton)),
        alignment: .5,
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      expect(starts, 1);
    });
  }
}
