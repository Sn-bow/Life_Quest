import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/features/director/quest_director_engine.dart';
import 'package:life_quest_final_v2/features/director/quest_generation.dart';

// Opt-in local model evaluation. All data below is synthetic; no app storage
// or real goals/history are read. Export uses the actual shipping Dart prompt.
const exportFixtures = bool.fromEnvironment('LIFEQUEST_EXPORT_MODEL_FIXTURES');
const validateOutputs = bool.fromEnvironment(
  'LIFEQUEST_VALIDATE_MODEL_OUTPUTS',
);

void main() {
  final now = DateTime(2026, 9, 15, 23);
  const goals = {
    'ko': '퇴근 후 영어 공부를 다시 시작하고 싶다. 조용한 방에서 부담 없이 작은 일을 끝내고 싶다. ',
    'en':
        'I want to start studying English again after work, with small quiet actions in my room. ',
    'ja': '仕事の後に英語の勉強を再開したい。静かな部屋で無理のない小さな行動を終えたい。',
    'zh': '我想在下班后重新开始学习英语，在安静的房间里轻松完成一些小任务。',
  };
  final fixtures = <Map<String, dynamic>>[];
  for (final entry in goals.entries) {
    for (final fullHistory in [false, true]) {
      final profile = const HunterProfile().copyWith(
        focuses: {GrowthFocus.learning, GrowthFocus.order},
        energy: 1,
        minutes: 3,
        goal: fullHistory ? entry.value * 5 : entry.value,
      );
      final history = <QuestSignal>[
        if (fullHistory)
          for (var i = 0; i < 42; i++)
            QuestSignal(
              questId: 'synthetic-$i',
              templateId: QuestDirectorEngine
                  .catalog[i % QuestDirectorEngine.catalog.length]
                  .id,
              feedback: QuestFeedback.values[i % QuestFeedback.values.length],
              at: now.subtract(Duration(hours: 42 - i)),
              title: String.fromCharCodes((entry.value * 2).runes.take(60)),
              minutes: 3,
            ),
      ];
      final plan = const QuestDirectorEngine().plan(
        profile: profile,
        history: history,
        now: now,
      );
      final id = '${entry.key}_${fullHistory ? 'history' : 'new'}';
      final prompt = QuestGeneration.prompt(plan, profile, history, now);
      fixtures.add({
        'id': id,
        'locale': entry.key,
        'system': QuestGeneration.system(entry.key, plan.length),
        'prompt': prompt,
      });
      test('$id preserves the app time budget with bounded model context', () {
        final data = jsonDecode(prompt) as Map;
        expect(data['total_minutes'], lessThanOrEqualTo(profile.minutes));
        expect((data['slots'] as List).length, plan.length);
        expect(prompt.length, lessThanOrEqualTo(5000));
      });
      if (validateOutputs) {
        test(
          '$id actual local model response passes the production parser',
          () {
            final rows =
                (jsonDecode(
                          File(
                            'qa_artifacts/rebirth/production-model-probe.json',
                          ).readAsStringSync(),
                        )
                        as Map)['cases']
                    as List;
            final row = rows.singleWhere((e) => e['id'] == id) as Map;
            expect(row['error'], isNull);
            expect(row['input_tokens'] + 550 + 64, lessThanOrEqualTo(2048));
            final generated = QuestGeneration.parse(
              row['output'] as String,
              plan,
              entry.key,
              silenceRequired: QuestGeneration.quietHours(now),
            );
            expect(
              generated,
              isNotNull,
              reason: 'Inspect the synthetic model response and its semantics.',
            );
            expect(generated!.map((q) => q.id), plan.map((q) => q.id));
            expect(generated.map((q) => q.minutes), plan.map((q) => q.minutes));
          },
        );
      }
    }
  }
  if (exportFixtures) {
    test('export synthetic production prompt fixtures', () {
      final file = File('qa_artifacts/rebirth/production-model-inputs.json');
      file.parent.createSync(recursive: true);
      file.writeAsStringSync(
        const JsonEncoder.withIndent('  ').convert(fixtures),
      );
    });
  }
}
