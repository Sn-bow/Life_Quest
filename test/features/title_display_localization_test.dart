import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/data/title_localization.dart';
import 'package:life_quest_final_v2/data/title_unlock_rules.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/screens/report_screen.dart';
import 'package:life_quest_final_v2/screens/status_screen.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SoundService.muteForTesting();

  test(
    'stored canonical titles translate while unknown titles remain literal',
    () {
      final names = {
        'ko': '새싹 모험가',
        'en': 'Sprout Adventurer',
        'ja': '新芽の冒険者',
        'zh': '嫩芽冒險者',
      };

      for (final entry in names.entries) {
        final l10n = lookupAppLocalizations(Locale(entry.key));
        expect(
          TitleLocalization.localizedStoredName('새싹 모험가', l10n),
          entry.value,
        );
        expect(
          TitleLocalization.localizedStoredName('My custom title', l10n),
          'My custom title',
        );
        expect(
          TitleLocalization.localizedName(
            'custom-id',
            l10n,
            fallback: 'My custom title',
          ),
          'My custom title',
        );
        expect(
          TitleLocalization.localizedDescription(
            'custom-id',
            l10n,
            fallback: 'Custom description',
          ),
          'Custom description',
        );
        expect(
          TitleLocalization.localizedUnlockPreview(
            'custom-id',
            l10n,
            fallback: 'Custom unlock',
          ),
          'Custom unlock',
        );
        for (final rule in TitleUnlockRules.eventRules) {
          final preview = TitleLocalization.localizedUnlockPreview(
            rule.titleId,
            l10n,
          );
          expect(
            preview,
            isNot(rule.titleId),
            reason: '${entry.key}: ${rule.titleId}',
          );
          if (entry.key == 'ko') {
            expect(preview, rule.unlockLabel);
          } else {
            expect(preview, isNot(contains(RegExp(r'[가-힣]'))));
          }
        }
      }
    },
  );

  testWidgets('Japanese status, title dialog, and report use the title ID', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final state = CharacterState()..initializeForTesting();

    Widget app(Widget screen) => ChangeNotifierProvider.value(
      value: state,
      child: MaterialApp(
        locale: const Locale('ja'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: screen,
      ),
    );

    await tester.pumpWidget(app(const StatusScreen()));
    await tester.pumpAndSettle();
    final l10n = lookupAppLocalizations(const Locale('ja'));
    expect(find.text('Lv. 1 | ${l10n.titleNameT0}'), findsOneWidget);
    expect(state.character.title, '새싹 모험가');

    await tester.tap(find.text('Lv. 1 | ${l10n.titleNameT0}'));
    await tester.pumpAndSettle();
    expect(find.text(l10n.titleNameT0), findsOneWidget);
    expect(find.text(l10n.titleDescT0), findsOneWidget);

    await tester.tap(find.text(l10n.titleNameT0));
    await tester.pumpAndSettle();
    expect(state.character.title, '새싹 모험가');

    await tester.pumpWidget(app(const ReportScreen()));
    await tester.pumpAndSettle();
    expect(find.text(l10n.titleNameT0), findsOneWidget);
    expect(find.text('새싹 모험가'), findsNothing);
    expect(state.character.title, '새싹 모험가');

    expect(find.byKey(const ValueKey('report-plus-open')), findsNothing);

    await tester.pumpWidget(const SizedBox());
    state.dispose();
  });
}
