import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/features/director/ai_report_service.dart';

void main() {
  test('explicit report includes only reviewed text in the owner account',
      () async {
    final db = FakeFirebaseFirestore();
    final service = AiReportService(firestore: db, userId: 'reporter');
    final result = await service.submit(const AiReportContent(
        title: '추천 제목', instruction: '추천 행동', reason: '추천 이유', locale: 'ko'));
    expect(result, AiReportResult.sent);
    final reports = await db
        .collection('users')
        .doc('reporter')
        .collection('aiReports')
        .get();
    expect(reports.docs, hasLength(1));
    expect(reports.docs.single.data().keys.toSet(), {
      'schema',
      'model',
      'title',
      'instruction',
      'reason',
      'locale',
      'reportedAt'
    });
    expect(
        (await db
                .collection('users')
                .doc('someone-else')
                .collection('aiReports')
                .get())
            .docs,
        isEmpty);
    expect(
        await service.submit(const AiReportContent(
            title: '', instruction: 'x', reason: 'x', locale: 'invalid')),
        AiReportResult.failed);
    expect(
        (await db
                .collection('users')
                .doc('reporter')
                .collection('aiReports')
                .get())
            .docs
            .length,
        1);
  });
}
