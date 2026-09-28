import '../../system/system_journal.dart';

/// One calendar day in a growth window. A day before the first persisted
/// receipt is unknown, not a zero-activity day.
class StatusGrowthDay {
  const StatusGrowthDay({
    required this.day,
    required this.observed,
    required this.questCount,
    required this.xp,
    required this.gold,
  });

  final String day;
  final bool observed;
  final int questCount;
  final double xp;
  final int gold;
}

/// An analysis of persisted completion receipts, without reconstructed history.
///
/// Quest lists are rotated and legacy progress has no receipts. This therefore
/// describes *recorded* completions only. It must not be presented as a
/// completion rate against scheduled tasks or as a complete pre-receipt history.
class StatusGrowthInsights {
  const StatusGrowthInsights._({
    required this.days,
    required this.startDay,
    required this.endDay,
    required this.coverageStart,
    required this.partialHistory,
    required this.observedDays,
    required this.questCount,
    required this.totalXp,
    required this.totalGold,
    required this.levelGain,
    required this.activeDays,
    required this.longestStreak,
    required this.topCategory,
    required this.categoryCounts,
    required this.categoryXp,
    required this.byDay,
  });

  final int days;
  final String startDay;
  final String endDay;

  /// The date of the earliest persisted receipt, including one outside the
  /// selected window. Null means there is no recorded completion yet.
  final String? coverageStart;
  final bool partialHistory;
  final int observedDays;
  final int questCount;
  final double totalXp;
  final int totalGold;
  final int levelGain;
  final int activeDays;
  final int longestStreak;
  final int? topCategory;
  final Map<int, int> categoryCounts;
  final Map<int, double> categoryXp;
  final Map<String, StatusGrowthDay> byDay;

  static final _dayPattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');

  /// Uses receipt.day, the local day at completion, so a later time-zone
  /// change does not silently move a completed quest into a different day.
  factory StatusGrowthInsights.fromReceipts(
    List<GrowthReceipt> receipts, {
    required DateTime now,
    required int days,
  }) {
    if (days < 1 || days > 366) {
      throw ArgumentError.value(days, 'days', 'Expected 1–366 calendar days');
    }
    final endDate = DateTime(now.year, now.month, now.day);
    final startDate = DateTime(now.year, now.month, now.day - days + 1);
    final endDay = systemDay(endDate);
    final startDay = systemDay(startDate);
    final seenIds = <String>{};
    final valid = <GrowthReceipt>[];
    for (final receipt in receipts) {
      // A corrupt or future record cannot backdate coverage or inflate a
      // report. SystemJournal's normal deserializer applies stricter checks.
      final parsedDay = DateTime.tryParse(receipt.day);
      if (receipt.at.isAfter(now) ||
          !_dayPattern.hasMatch(receipt.day) ||
          parsedDay == null ||
          systemDay(parsedDay) != receipt.day ||
          receipt.day.compareTo(endDay) > 0 ||
          !seenIds.add(receipt.id)) {
        continue;
      }
      valid.add(receipt);
    }
    valid.sort((a, b) {
      final dayOrder = a.day.compareTo(b.day);
      return dayOrder != 0 ? dayOrder : a.at.compareTo(b.at);
    });
    final coverageStart = valid.isEmpty ? null : valid.first.day;
    final inWindow = valid
        .where((receipt) => receipt.day.compareTo(startDay) >= 0)
        .toList(growable: false);

    final counts = <int, int>{for (var i = 0; i < 4; i++) i: 0};
    final xpByCategory = <int, double>{for (var i = 0; i < 4; i++) i: 0};
    final perDay = <String, List<GrowthReceipt>>{};
    var totalXp = 0.0;
    var totalGold = 0;
    var levelGain = 0;
    for (final receipt in inWindow) {
      perDay.putIfAbsent(receipt.day, () => []).add(receipt);
      totalXp += receipt.xp;
      totalGold += receipt.gold;
      levelGain += receipt.levelAfter - receipt.levelBefore;
      if (receipt.category >= 0 && receipt.category < 4) {
        counts[receipt.category] = counts[receipt.category]! + 1;
        xpByCategory[receipt.category] =
            xpByCategory[receipt.category]! + receipt.xp;
      }
    }

    final dayRows = <String, StatusGrowthDay>{};
    var observedDays = 0;
    var streak = 0;
    var longestStreak = 0;
    for (var offset = 0; offset < days; offset++) {
      // Calendar arithmetic remains correct across DST transitions.
      final day = systemDay(
        DateTime(startDate.year, startDate.month, startDate.day + offset),
      );
      final observed =
          coverageStart != null && day.compareTo(coverageStart) >= 0;
      if (observed) observedDays++;
      final dayReceipts = perDay[day] ?? const <GrowthReceipt>[];
      if (dayReceipts.isNotEmpty) {
        streak++;
        if (streak > longestStreak) longestStreak = streak;
      } else {
        streak = 0;
      }
      dayRows[day] = StatusGrowthDay(
        day: day,
        observed: observed,
        questCount: dayReceipts.length,
        xp: dayReceipts.fold(0.0, (sum, receipt) => sum + receipt.xp),
        gold: dayReceipts.fold(0, (sum, receipt) => sum + receipt.gold),
      );
    }
    final topCategory =
        inWindow.isEmpty || counts.values.every((count) => count == 0)
        ? null
        : counts.entries
              .where((entry) => entry.value > 0)
              .reduce((best, entry) => entry.value > best.value ? entry : best)
              .key;
    return StatusGrowthInsights._(
      days: days,
      startDay: startDay,
      endDay: endDay,
      coverageStart: coverageStart,
      partialHistory:
          coverageStart == null || coverageStart.compareTo(startDay) > 0,
      observedDays: observedDays,
      questCount: inWindow.length,
      totalXp: totalXp,
      totalGold: totalGold,
      levelGain: levelGain,
      activeDays: perDay.length,
      longestStreak: longestStreak,
      topCategory: topCategory,
      categoryCounts: Map.unmodifiable(counts),
      categoryXp: Map.unmodifiable(xpByCategory),
      byDay: Map.unmodifiable(dayRows),
    );
  }

  /// Portable daily totals with no quest titles or other personal text.
  /// An unknown day has empty totals, not misleading zeros.
  String toCsv() {
    final rows = <String>[
      'date,recorded,recorded_quests,recorded_xp,recorded_gold',
      for (final row in byDay.values)
        '${row.day},${row.observed ? 1 : 0},'
            '${row.observed ? row.questCount : ''},'
            '${row.observed ? _number(row.xp) : ''},'
            '${row.observed ? row.gold : ''}',
    ];
    return '${rows.join('\r\n')}\r\n';
  }

  /// A plain-text share/export summary. All wording says "recorded" because
  /// receipts did not exist for the app's entire historical lifetime.
  String toTextSummary(String localeCode) {
    final locale = localeCode.toLowerCase().split(RegExp('[-_]')).first;
    final xp = _number(totalXp);
    final categoryLine = _categorySummary(locale);
    switch (locale) {
      case 'ko':
        return '$days일 성장 기록 ($startDay–$endDay)\n'
            '기록된 퀘스트 $questCount개 · XP $xp · 활동일 $activeDays일'
            '/기록 범위 $observedDays일\n'
            '기록된 레벨 상승 $levelGain · 최장 연속 활동 $longestStreak일\n'
            '$categoryLine'
            '${partialHistory ? '\n※ 기록은 ${coverageStart ?? '아직 없음'}부터입니다. 이전 활동은 포함되지 않습니다.' : ''}';
      case 'ja':
        return '$days日間の成長記録 ($startDay–$endDay)\n'
            '記録されたクエスト $questCount件 · XP $xp · 活動日 $activeDays日'
            '/記録対象 $observedDays日\n'
            '記録されたレベル上昇 $levelGain · 最長連続活動 $longestStreak日\n'
            '$categoryLine'
            '${partialHistory ? '\n※ 記録は${coverageStart ?? 'まだありません'}からです。それ以前の活動は含まれません。' : ''}';
      case 'zh':
        return '$days 天成長紀錄 ($startDay–$endDay)\n'
            '已記錄任務 $questCount 個 · XP $xp · 活躍 $activeDays 天'
            '/記錄範圍 $observedDays 天\n'
            '已記錄升級 $levelGain 級 · 最長連續活躍 $longestStreak 天\n'
            '$categoryLine'
            '${partialHistory ? '\n※ 紀錄從 ${coverageStart ?? '尚未開始'} 起算，不包含更早的活動。' : ''}';
      default:
        return '$days-day growth record ($startDay–$endDay)\n'
            'Recorded quests $questCount · XP $xp · Active days $activeDays'
            '/$observedDays observed days\n'
            'Recorded level gains $levelGain · Longest active streak $longestStreak days\n'
            '$categoryLine'
            '${partialHistory ? '\nNote: records start ${coverageStart ?? 'when you complete your first quest'}. Earlier activity is not included.' : ''}';
    }
  }

  String _categorySummary(String locale) {
    final labels = switch (locale) {
      'ko' => ['힘', '지혜', '건강', '매력'],
      'ja' => ['力', '知恵', '健康', '魅力'],
      'zh' => ['力量', '智慧', '健康', '魅力'],
      _ => ['Strength', 'Wisdom', 'Health', 'Charm'],
    };
    final prefix = switch (locale) {
      'ko' => '분류별 기록',
      'ja' => '分類別の記録',
      'zh' => '分類紀錄',
      _ => 'Recorded by category',
    };
    return '$prefix: ${List.generate(4, (i) => '${labels[i]} ${categoryCounts[i]} / ${_number(categoryXp[i] ?? 0)} XP').join(' · ')}';
  }

  static String _number(double value) {
    final rounded = value.toStringAsFixed(2);
    return rounded.replaceFirst(RegExp(r'\.?0+$'), '');
  }
}
