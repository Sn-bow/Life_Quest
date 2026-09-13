import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_quest_final_v2/features/backup/backup_screen.dart';
import 'package:life_quest_final_v2/features/backup/backup_files.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/theme/quest_theme.dart';

class CancelFiles implements BackupFiles {
  int opened = 0;
  @override
  Future<Uint8List?> open() async {
    opened++;
    return null;
  }

  @override
  Future<bool> save(Uint8List bytes, String filename) async => false;
}

void main() {
  for (final code in ['ko', 'en', 'ja', 'zh']) {
    testWidgets('backup dialog and cancel work at 320px/200% in $code', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.physicalSize = const Size(320, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final files = CancelFiles();
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
          home: BackupScreen(files: files),
        ),
      );
      await tester.pumpAndSettle();
      final l = AppLocalizations.of(tester.element(find.byType(BackupScreen)))!;
      await tester.scrollUntilVisible(find.text(l.lqBackupExport), 250);
      await tester.tap(find.text(l.lqBackupExport));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.enterText(find.byType(TextField).first, 'short');
      await tester.tap(
        find.widgetWithText(FilledButton, l.lqBackupExport).last,
      );
      await tester.pumpAndSettle();
      expect(find.text(l.lqBackupPasswordHint), findsNWidgets(2));
      expect(tester.takeException(), isNull);
      await tester.tap(find.text(l.cancel));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text(l.lqBackupImport), 250);
      await tester.tap(find.text(l.lqBackupImport));
      await tester.pumpAndSettle();
      expect(files.opened, 1);
      expect(tester.takeException(), isNull);
    });
  }
}
