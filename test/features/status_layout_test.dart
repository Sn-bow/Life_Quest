import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/screens/status_screen.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/theme/quest_theme.dart';

void main() {
  SoundService.muteForTesting();
  for (final locale in ['ko', 'en', 'ja', 'zh']) {
    for (final size in const [
      Size(320, 900),
      Size(800, 1280),
      Size(1280, 800),
    ]) {
      testWidgets(
        'status allocation and details work at $size / 200%: $locale',
        (tester) async {
          SharedPreferences.setMockInitialValues({});
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          final state = CharacterState()..initializeForTesting();
          state.character
            ..name = '긴 사용자 이름 / Long profile name'
            ..statPoints = 3
            ..streak = 12
            ..gold = 123456;
          final originalStrength = state.character.strength;
          await tester.pumpWidget(
            ChangeNotifierProvider.value(
              value: state,
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
                home: const StatusScreen(),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final l = AppLocalizations.of(
            tester.element(find.byType(StatusScreen)),
          )!;
          expect(tester.takeException(), isNull);
          expect(find.text('123456'), findsNothing);

          final plus = find.byKey(const ValueKey('status-stat-add-strength'));
          await tester.ensureVisible(plus);
          await tester.tap(plus);
          await tester.pumpAndSettle();
          expect(find.text('SP: 2 / 3'), findsOneWidget);
          expect(state.character.strength, originalStrength);
          expect(tester.takeException(), isNull);

          final minus = find.byKey(
            const ValueKey('status-stat-remove-strength'),
          );
          await tester.ensureVisible(minus);
          await tester.tap(minus);
          await tester.pumpAndSettle();
          expect(find.text('SP: 3 / 3'), findsOneWidget);
          await tester.tap(plus);
          await tester.pumpAndSettle();

          final apply = find.widgetWithText(ElevatedButton, l.apply);
          await tester.ensureVisible(apply);
          await tester.tap(apply);
          await tester.pumpAndSettle();
          expect(find.text(l.statusStatApplyTitle), findsOneWidget);
          expect(tester.takeException(), isNull);
          await tester.tap(find.widgetWithText(ElevatedButton, l.apply).last);
          await tester.pumpAndSettle();
          expect(state.character.strength, originalStrength + 1);
          expect(state.character.statPoints, 2);
          expect(tester.takeException(), isNull);

          final details = find.widgetWithText(
            TextButton,
            l.statusDetailStatButton,
          );
          await tester.ensureVisible(details);
          await tester.tap(details);
          await tester.pumpAndSettle();
          expect(find.text(l.statusDetailStatTitle), findsOneWidget);
          expect(tester.takeException(), isNull);
          await tester.ensureVisible(find.text(l.statusDodgeLabel));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          await tester.tap(find.widgetWithText(TextButton, l.close));
          await tester.pumpAndSettle();
          expect(find.text(l.statusDetailStatTitle), findsNothing);
          await tester.pumpWidget(const SizedBox());
          state.dispose();
        },
      );
    }
  }
}
