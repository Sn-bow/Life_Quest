import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/features/director/ai_report_button.dart';
import 'package:life_quest_final_v2/features/director/ai_report_service.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';

void main() {
  for (final locale in ['ko', 'en', 'ja', 'zh']) {
    testWidgets('$locale public feedback never claims a submitted report', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 740);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var reported = 0;
      String? copied;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            copied = (call.arguments as Map)['text'] as String;
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      const content = AiReportContent(
        title: '검토할 추천',
        instruction: '물건 하나를 정리하세요.',
        reason: '작은 시작',
        locale: 'ko',
      );
      await tester.pumpWidget(
        MaterialApp(
          locale: Locale(locale),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(2)),
            child: child!,
          ),
          home: Scaffold(
            body: AiReportButton(
              content: content,
              onReported: () async {
                reported++;
              },
            ),
          ),
        ),
      );
      final s = AppLocalizations.of(
        tester.element(find.byType(AiReportButton)),
      )!;
      await tester.tap(find.text(s.lqReportSuggestion));
      await tester.pumpAndSettle();
      expect(find.text(s.lqReportManualDescription), findsOneWidget);
      expect(find.text(s.lqSendReport), findsNothing);
      expect(find.text(s.lqReportRetention), findsNothing);
      expect(copied, isNull);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text(s.lqReportCopySuggestion));
      await tester.pumpAndSettle();
      expect(
        copied,
        'Life Quest · Gemma 4 E2B · ko\n검토할 추천\n물건 하나를 정리하세요.\n작은 시작',
      );
      expect(find.text(s.lqReportManualCopied), findsOneWidget);
      expect(reported, 0);
      await tester.tap(find.text(s.close));
      await tester.pumpAndSettle();
      expect(reported, 0);
    });
  }
}
