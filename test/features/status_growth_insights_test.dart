import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/features/status_pack/insights/status_growth_insights.dart';
import 'package:life_quest_final_v2/features/system/system_journal.dart';

GrowthReceipt receipt(
  String id,
  DateTime at, {
  double xp = 10,
  int gold = 2,
  int category = 0,
  int levelBefore = 1,
  int levelAfter = 1,
}) => GrowthReceipt(
  id: id,
  questId: id,
  title: 'Private quest title: $id',
  day: systemDay(at),
  source: 'quest',
  at: at,
  category: category,
  baseXp: 10,
  gold: gold,
  levelBefore: levelBefore,
  levelAfter: levelAfter,
  xp: xp,
  xpBefore: 0,
  xpAfter: xp,
  maxXpAfter: 150,
  statChanges: const [0, 0, 0, 0],
);

void main() {
  final now = DateTime(2026, 9, 28, 20);

  test('30-day totals use durable receipts and inclusive calendar bounds', () {
    final result = StatusGrowthInsights.fromReceipts(
      [
        receipt('before', DateTime(2026, 8, 29, 9), xp: 500),
        receipt(
          'start',
          DateTime(2026, 8, 30, 9),
          xp: 10.5,
          gold: 3,
          category: 1,
        ),
        receipt(
          'yesterday',
          DateTime(2026, 9, 27, 9),
          xp: 20,
          gold: 4,
          category: 1,
          levelBefore: 1,
          levelAfter: 2,
        ),
        receipt(
          'today',
          DateTime(2026, 9, 28, 9),
          xp: 30.5,
          gold: 5,
          category: 2,
        ),
        receipt('today', DateTime(2026, 9, 28, 9), xp: 999),
        receipt('future', DateTime(2026, 9, 28, 21), xp: 999),
      ],
      now: now,
      days: 30,
    );

    expect(result.startDay, '2026-08-30');
    expect(result.endDay, '2026-09-28');
    expect(result.coverageStart, '2026-08-29');
    expect(result.partialHistory, isFalse);
    expect(result.observedDays, 30);
    expect(result.questCount, 3);
    expect(result.totalXp, 61);
    expect(result.totalGold, 12);
    expect(result.levelGain, 1);
    expect(result.activeDays, 3);
    expect(result.longestStreak, 2);
    expect(result.topCategory, 1);
    expect(result.categoryCounts, {0: 0, 1: 2, 2: 1, 3: 0});
    expect(result.categoryXp, {0: 0, 1: 30.5, 2: 30.5, 3: 0});
    expect(result.byDay['2026-09-26']!.questCount, 0);
    expect(result.byDay['2026-09-27']!.xp, 20);
    expect(result.byDay.length, 30);
  });

  test('partial history marks pre-receipt days unknown instead of zero', () {
    final result = StatusGrowthInsights.fromReceipts(
      [receipt('first', DateTime(2026, 9, 27, 9))],
      now: now,
      days: 30,
    );

    expect(result.coverageStart, '2026-09-27');
    expect(result.partialHistory, isTrue);
    expect(result.observedDays, 2);
    expect(result.byDay['2026-08-30']!.observed, isFalse);
    expect(result.byDay['2026-09-28']!.observed, isTrue);
    expect(result.byDay['2026-09-28']!.questCount, 0);
    expect(result.activeDays, 1);
    expect(result.toCsv(), contains('2026-08-30,0,,\r\n'));
    expect(result.toCsv(), contains('2026-09-28,1,0,0\r\n'));
    expect(result.toCsv(), isNot(contains('recorded_gold')));
  });

  test(
    '90-day window uses exact boundary and no pre-journal reconstruction',
    () {
      final result = StatusGrowthInsights.fromReceipts(
        [
          receipt('previous', DateTime(2026, 6, 30, 9)),
          receipt('first-window', DateTime(2026, 7, 1, 9), xp: 14),
          receipt('last-window', DateTime(2026, 9, 28, 9), xp: 16),
        ],
        now: now,
        days: 90,
      );

      expect(result.startDay, '2026-07-01');
      expect(result.byDay.length, 90);
      expect(result.questCount, 2);
      expect(result.totalXp, 30);
      expect(result.partialHistory, isFalse);
    },
  );

  test('empty journal is honest and cannot imply a 30-day zero streak', () {
    final result = StatusGrowthInsights.fromReceipts([], now: now, days: 30);
    expect(result.coverageStart, isNull);
    expect(result.partialHistory, isTrue);
    expect(result.observedDays, 0);
    expect(result.questCount, 0);
    expect(result.topCategory, isNull);
    expect(result.byDay.values.every((day) => !day.observed), isTrue);
    expect(result.toTextSummary('en'), contains('records start'));
  });

  test(
    'share text is localized and export never includes private quest titles',
    () {
      final result = StatusGrowthInsights.fromReceipts(
        [receipt('sensitive', DateTime(2026, 9, 28, 9))],
        now: now,
        days: 30,
      );
      expect(result.toTextSummary('ko'), contains('이전 활동은 포함되지 않습니다'));
      expect(result.toTextSummary('ja'), contains('それ以前の活動は含まれません'));
      expect(result.toTextSummary('zh-TW'), contains('不包含更早的活動'));
      expect(result.toTextSummary('en'), contains('Strength 1 / 10 XP'));
      expect(
        result.toTextSummary('en'),
        contains('Earlier activity is not included'),
      );
      expect(result.toCsv(), isNot(contains('Private quest title')));
      expect(
        result.toTextSummary('en'),
        isNot(contains('Private quest title')),
      );
    },
  );

  test('invalid duration is rejected', () {
    expect(
      () => StatusGrowthInsights.fromReceipts([], now: now, days: 0),
      throwsArgumentError,
    );
  });
}
