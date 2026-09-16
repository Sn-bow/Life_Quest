import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_quest_final_v2/features/director/ai_report_service.dart';
import 'package:life_quest_final_v2/features/director/ai_report_receipts_screen.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/theme/quest_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final id = 'a' * 64;
  const content = AiReportContent(
    title: '추천 제목',
    instruction: '추천 행동',
    reason: '추천 이유',
    locale: 'ko',
  );
  Map<String, dynamic> accepted() => {
    'accepted': true,
    'reportId': id,
    'ownerUid': 'reporter',
  };
  setUp(
    () => SharedPreferences.setMockInitialValues({
      'lifequest.local.state.v1': 'private',
    }),
  );
  test(
    'only reviewed text is submitted and only receipt metadata stays locally',
    () async {
      Map<String, dynamic>? sent;
      final service = AiReportService(
        submitRemote: (data) async {
          sent = data;
          return accepted();
        },
      );
      final result = await service.submit(content);
      expect(result.result, AiReportResult.sent);
      expect(sent!.keys.toSet(), {
        'schema',
        'model',
        'title',
        'instruction',
        'reason',
        'locale',
      });
      final saved = await service.receipts();
      expect(saved.single.id, id);
      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getString(AiReportService.receiptsKey),
        isNot(contains(content.title)),
      );
      expect(prefs.getString('lifequest.local.state.v1'), 'private');
      await service.submit(content);
      expect(await service.receipts(), hasLength(1));
    },
  );
  test(
    'timeout or invalid acknowledgement cannot claim queued or accepted delivery',
    () async {
      for (final send
          in <Future<Map<String, dynamic>> Function(Map<String, dynamic>)>[
            (_) async => throw TimeoutException('uncertain'),
            (_) async => {'accepted': false},
            (_) async => {
              'accepted': true,
              'reportId': '../invalid',
              'ownerUid': 'reporter',
            },
          ]) {
        final service = AiReportService(submitRemote: send);
        expect((await service.submit(content)).result, AiReportResult.failed);
        expect(await service.receipts(), isEmpty);
      }
    },
  );
  test(
    'invalid content and disabled default do not authenticate or send',
    () async {
      final service = AiReportService(
        submitRemote: (_) async => throw StateError('must not call'),
      );
      expect(
        (await service.submit(
          const AiReportContent(
            title: ' ',
            instruction: 'x',
            reason: 'x',
            locale: 'ko',
          ),
        )).result,
        AiReportResult.failed,
      );
      expect(
        (await const AiReportService().submit(content)).result,
        AiReportResult.failed,
      );
      expect(const AiReportService().currentUid, isNull);
      expect(const AiReportService().canDeleteAnonymousIdentity, false);
    },
  );
  test(
    'account switch blocks deletion; failed remote deletion retains the receipt',
    () async {
      var uid = 'other';
      var attempted = 0;
      var fail = true;
      final service = AiReportService(
        submitRemote: (_) async => accepted(),
        currentUidOverride: () => uid,
        deleteRemote: (_) async {
          ++attempted;
          if (fail) throw StateError('offline');
        },
      );
      final receipt = (await service.submit(content)).receipt!;
      expect(await service.delete(receipt), false);
      expect(attempted, 0);
      uid = 'reporter';
      expect(await service.delete(receipt), false);
      expect(await service.receipts(), hasLength(1));
      fail = false;
      expect(await service.delete(receipt), true);
      expect(await service.receipts(), isEmpty);
      expect(
        (await SharedPreferences.getInstance()).getString(
          'lifequest.local.state.v1',
        ),
        'private',
      );
    },
  );
  test(
    'a corrupted local receipt log does not undo confirmed server acceptance',
    () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AiReportService.receiptsKey, '{broken');
      final response = await AiReportService(
        submitRemote: (_) async => accepted(),
      ).submit(content);
      expect(response.result, AiReportResult.sent);
      expect(response.receipt!.id, id);
      expect(prefs.getString(AiReportService.receiptsKey), '{broken');
    },
  );
  for (final code in ['ko', 'en', 'ja', 'zh']) {
    testWidgets('report receipts stay readable at 320px / 200%: $code', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final service = AiReportService(
        currentUidOverride: () => 'reporter',
        deleteRemote: (_) async {},
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        AiReportService.receiptsKey,
        jsonEncode([
          AiReportReceipt(
            id: id,
            ownerUid: 'reporter',
            createdAt: 1800000000000,
          ).toJson(),
        ]),
      );
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
          home: AiReportReceiptsScreen(service: service),
        ),
      );
      await tester.pumpAndSettle();
      final l = await AppLocalizations.delegate.load(Locale(code));
      await tester.scrollUntilVisible(
        find.text(l.lqReportDelete),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text(l.lqReportDelete));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
