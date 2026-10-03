import 'package:flutter/material.dart';
import 'journey_catalog.dart';
import 'journey_progress.dart';

String journeyRecordDate(DateTime at) {
  final local = at.toLocal();
  return '${local.year}-${local.month.toString().padLeft(2, '0')}-'
      '${local.day.toString().padLeft(2, '0')}';
}

String journeyRecordMode(JourneyEntry entry, JourneyCopy copy) => copy.choose([
  '${entry.shortVersion ? 'Small step' : 'Usual step'} · planned ${entry.minutes} min',
  '${entry.shortVersion ? '작게 하기' : '평소대로'} · 계획 ${entry.minutes}분',
  '${entry.shortVersion ? '小さく取り組む' : 'いつもどおり'}・予定${entry.minutes}分',
  '${entry.shortVersion ? '小步驟' : '一般步驟'}・預計${entry.minutes}分鐘',
]);

String journeyRecordTitle(JourneyCopy copy) =>
    copy.choose(['My route record', '나의 실행 기록', '自分の実行記録', '我的行動紀錄']);

String journeyRecordEmpty(JourneyCopy copy) =>
    copy.choose(['No note added.', '남긴 메모가 없습니다.', 'メモはありません。', '沒有留下筆記。']);

/// Only completed entries belong to the user's record. This never exposes
/// uncompleted paid instructions or treats planned minutes as measured time.
String journeyRecordText(
  JourneyRun run,
  JourneyCatalog catalog,
  JourneyCopy copy,
) {
  final lines = <String>[
    'Life Quest · ${journeyRecordTitle(copy)}',
    copy.title(run.kind),
    run.goal,
    '${run.stage}/$journeyStageCount · ${copy.t('saved')}',
  ];
  for (var i = 0; i < run.entries.length; i++) {
    final entry = run.entries[i];
    lines.addAll([
      '',
      '${i + 1}. ${catalog.mission(run.kind, i).title(copy.locale)}',
      '${journeyRecordDate(entry.at)} · ${journeyRecordMode(entry, copy)}',
      ...catalog
          .mission(run.kind, i)
          .steps(copy.locale, shortVersion: entry.shortVersion),
      entry.note.isEmpty ? journeyRecordEmpty(copy) : entry.note,
    ]);
  }
  return lines.join('\n');
}

/// A review of the user's actual completed work, not an AI-generated assessment.
class JourneyRecordBody extends StatelessWidget {
  final JourneyRun run;
  final JourneyCatalog catalog;
  const JourneyRecordBody({
    super.key,
    required this.run,
    required this.catalog,
  });

  @override
  Widget build(BuildContext context) {
    final copy = JourneyCopy(Localizations.localeOf(context).languageCode);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(run.goal, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Text('${run.stage}/$journeyStageCount · ${copy.t('saved')}'),
        const SizedBox(height: 12),
        Text(
          copy.choose([
            'Your steps and words, kept together. Planned minutes are not measured focus time. Your saved record stays readable without a purchase.',
            '실행한 행동과 직접 남긴 말을 모았습니다. 계획 시간은 실제 집중 시간과 다릅니다. 저장된 기록은 구매 없이 계속 볼 수 있습니다.',
            '実行したことと、自分の言葉をまとめました。予定時間は実際の集中時間ではありません。保存済みの記録は購入なしで読めます。',
            '把做過的行動與親手寫的話放在一起。預計時間不代表實際專注時間。已儲存的紀錄不需購買也能繼續閱讀。',
          ]),
          style: const TextStyle(height: 1.5),
        ),
        if (run.entries.isEmpty) ...[
          const SizedBox(height: 24),
          Text(
            copy.choose([
              'Complete your first mission to start this record.',
              '첫 미션을 완료하면 여기에 기록이 쌓입니다.',
              '最初のミッションを完了すると、ここに記録が残ります。',
              '完成第一個任務後，紀錄就會出現在這裡。',
            ]),
          ),
        ],
        if ([
          6,
          13,
          20,
        ].any((i) => i < run.stage && run.entries[i].note.isNotEmpty)) ...[
          const SizedBox(height: 28),
          Text(
            copy.choose([
              'What you chose to keep',
              '내가 남긴 방법',
              '残しておきたい自分の方法',
              '我想留下的方法',
            ]),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          for (final i in [6, 13, 20])
            if (i < run.stage && run.entries[i].note.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${i + 1}. ${catalog.mission(run.kind, i).title(copy.locale)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      SelectableText(run.entries[i].note),
                    ],
                  ),
                ),
              ),
        ],
        for (var i = 0; i < run.stage; i++) ...[
          if (i % 7 == 0) ...[
            const SizedBox(height: 28),
            Text(
              '${i ~/ 7 + 1}. ${copy.chapter(i)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
          ],
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${i + 1}. ${catalog.mission(run.kind, i).title(copy.locale)}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(journeyRecordDate(run.entries[i].at)),
                  Text(journeyRecordMode(run.entries[i], copy)),
                  const SizedBox(height: 12),
                  SelectableText(
                    run.entries[i].note.isEmpty
                        ? journeyRecordEmpty(copy)
                        : run.entries[i].note,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
