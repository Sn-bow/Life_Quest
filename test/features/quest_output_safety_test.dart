import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/features/director/quest_director_engine.dart';
import 'package:life_quest_final_v2/features/director/quest_generation.dart';

void main() {
  final plan = const QuestDirectorEngine().plan(
    profile: const HunterProfile(),
    history: [],
    now: DateTime(2026, 9, 21, 12),
  );
  const unsafe = {
    'ko': [
      '창밖의 나무를 30초 동안 바라보기',
      '숨을 오래 참으세요.',
      '통증을 참고 계속하세요.',
      '비밀\u200b번호를 적어 보내세요.',
      '카드 번호를 적으세요.',
    ],
    'en': [
      'Look at a tree for 30 seconds.',
      'Hold your breath as long as possible.',
      'Push through pain.',
      'Write your credit card number.',
      'Copy your pass\u200bword.',
    ],
    'ja': ['窓の外を30秒見てください。', '息を止めてください。', '痛みを我慢してください。'],
    'zh': ['看窗外30秒。', '屏息直到无法坚持。', '忍住疼痛继续。', '现在汇款。'],
  };
  for (final entry in unsafe.entries) {
    for (final instruction in entry.value) {
      test('reject ${entry.key}: $instruction', () {
        final raw = jsonEncode({
          'quests': [
            for (var i = 0; i < plan.length; i++)
              {
                'id': plan[i].template.id,
                'title':
                    '${['작은 행동', 'Small step', '小さな行動', '小行动'][['ko', 'en', 'ja', 'zh'].indexOf(entry.key)]}$i',
                'instruction': instruction,
                'reason': {
                  'ko': '부담 없는 시작',
                  'en': 'A small start',
                  'ja': '小さな始まり',
                  'zh': '轻松开始',
                }[entry.key],
              },
          ],
        });
        expect(QuestGeneration.parse(raw, plan, entry.key), isNull);
      });
    }
  }
  test(
    'night-time speaking and weight-loss framing fall back to the safe plan',
    () {
      for (final (locale, title, instruction, reason, quiet) in [
        ('zh', '对自己温柔', '对自己说一句友善的话。', '培养自我关怀意识。', true),
        ('ja', '単語練習', '目標に関連する単語を一つ発音する。', '学習のため。', true),
        (
          'en',
          'Kind word',
          'Say one kind sentence to yourself.',
          'A small start.',
          true,
        ),
        ('ko', '응원 한마디', '나에게 응원의 말을 말해보세요.', '작은 시작', true),
        ('zh', '感恩一事', '写下一件今天让你感到感激的事情。', '建立积极心态，支持减肥目标。', false),
      ]) {
        final raw = jsonEncode({
          'quests': [
            for (var i = 0; i < plan.length; i++)
              {
                'id': plan[i].template.id,
                'title': '$title$i',
                'instruction': instruction,
                'reason': reason,
              },
          ],
        });
        expect(
          QuestGeneration.parse(raw, plan, locale, silenceRequired: quiet),
          isNull,
        );
      }
    },
  );
}
