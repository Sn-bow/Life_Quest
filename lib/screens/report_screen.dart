import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/models/quest.dart';
import 'package:life_quest_final_v2/services/ad_service.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/widgets/translucent_card.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  bool _unlockingExpandedReport = false;
  late DateTime _focusedMonth;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
    _selectedDay = _normalizeDate(DateTime.now());
  }

  String _getCategoryName(StatType category) {
    switch (category) {
      case StatType.strength:
        return '힘';
      case StatType.wisdom:
        return '지혜';
      case StatType.health:
        return '건강';
      case StatType.charisma:
        return '매력';
    }
  }

  Color _getCategoryColor(StatType category) {
    switch (category) {
      case StatType.strength:
        return Colors.red.shade400;
      case StatType.wisdom:
        return Colors.blue.shade400;
      case StatType.health:
        return Colors.green.shade400;
      case StatType.charisma:
        return Colors.purple.shade400;
    }
  }

  String _getQuestTypeName(QuestType type) {
    switch (type) {
      case QuestType.daily:
        return '일일';
      case QuestType.weekly:
        return '주간';
      case QuestType.monthly:
        return '월간 레이드';
      case QuestType.yearly:
        return '연간 레이드';
    }
  }

  Future<void> _unlockExpandedReport(BuildContext context) async {
    if (_unlockingExpandedReport) return;
    final characterState = context.read<CharacterState>();
    final messenger = ScaffoldMessenger.of(context);

    setState(() {
      _unlockingExpandedReport = true;
    });

    final success = await AdService().showRewardedAd('report_detail');
    if (!mounted) return;

    if (success) {
      await characterState.unlockExpandedReportForToday();
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(
          content: Text('확장 리포트를 오늘 하루 동안 열었습니다.'),
        ),
      );
    } else {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('광고를 불러오지 못했습니다. 잠시 후 다시 시도해주세요.'),
        ),
      );
    }

    if (mounted) {
      setState(() {
        _unlockingExpandedReport = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final characterState = context.watch<CharacterState>();
    final weeklyData = characterState.weeklyCompletedQuests;
    final categoryData = characterState.questCategoryDistribution;
    final growthData = characterState.currentLevelGrowthDistribution;
    final autoGrowthData = characterState.lastLevelAutoAllocation;
    final dominantCategory = characterState.dominantGrowthCategory;
    final character = characterState.character;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final isExpandedUnlocked = characterState.isExpandedReportUnlockedToday;
    final remainingViews = AdService().getRemainingViews('report_detail');
    final monthlyCompletionRate =
        _completionRate(characterState.monthlyQuests);
    final yearlyCompletionRate = _completionRate(characterState.yearlyQuests);
    final recommendedCategory = _recommendedCategory(characterState);
    final recommendedQuest = _recommendedQuestLabel(characterState, recommendedCategory);
    final bestWeekday = _bestWeekdayLabel(weeklyData);
    final weeklyTotal = weeklyData.values.fold<int>(0, (total, value) => total + value);
    final completedQuestMap = _buildCompletedQuestMap(characterState);
    final selectedDayQuests =
        completedQuestMap[_selectedDay ?? _normalizeDate(DateTime.now())] ?? [];

    double maxY = (weeklyData.values.isEmpty
            ? 0
            : weeklyData.values.reduce((a, b) => a > b ? a : b))
        .toDouble();
    if (maxY < 5) {
      maxY = 5;
    } else {
      maxY *= 1.2;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('상세 리포트'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    title: '현재 연속 기록',
                    value: '${characterState.character.streak}일',
                    icon: PhosphorIcons.fire,
                    color: Colors.orange.shade400,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    title: '현재 XP',
                    value: '${characterState.character.xp.toInt()}',
                    icon: PhosphorIcons.star,
                    color: Colors.yellow.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    title: '완료한 퀘스트',
                    value: '${characterState.questCompletionCount}개',
                    icon: PhosphorIcons.checkCircle,
                    color: Colors.green.shade400,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    title: '현재 칭호',
                    value: characterState.character.title,
                    icon: PhosphorIcons.medal,
                    color: Colors.blue.shade400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TranslucentCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('한주간의 활동 기록', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 10),
                  Text(
                    '이번 주 루틴 유지 흐름을 먼저 확인할 수 있습니다.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 300,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: maxY,
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipRoundedRadius: 8,
                            getTooltipColor: (_) => Colors.blueGrey,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '${rod.toY.toInt()}',
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                final style = TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                );
                                const labels = ['월', '화', '수', '목', '금', '토', '일'];
                                final index = value.toInt();
                                final text = index >= 0 && index < labels.length
                                    ? labels[index]
                                    : '';
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  space: 16,
                                  child: Text(text, style: style),
                                );
                              },
                              reservedSize: 42,
                            ),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: List.generate(7, (index) {
                          final count = weeklyData[index + 1]?.toDouble() ?? 0;
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: count,
                                color: theme.colorScheme.primary,
                                width: 22,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(6),
                                ),
                              ),
                            ],
                            showingTooltipIndicators: count > 0 ? [0] : [],
                          );
                        }),
                        gridData: const FlGridData(show: false),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildExpandedReportEntryCard(
              context,
              remainingViews,
              isExpandedUnlocked,
            ),
            if (isExpandedUnlocked) ...[
              const SizedBox(height: 24),
              _buildExpandedReport(
                context: context,
                categoryData: categoryData,
                growthData: growthData,
                autoGrowthData: autoGrowthData,
                dominantCategory: dominantCategory,
                monthlyCompletionRate: monthlyCompletionRate,
                yearlyCompletionRate: yearlyCompletionRate,
                recommendedCategory: recommendedCategory,
                recommendedQuest: recommendedQuest,
                bestWeekday: bestWeekday,
                weeklyTotal: weeklyTotal,
                character: character,
                completedQuestMap: completedQuestMap,
                selectedDayQuests: selectedDayQuests,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedReportEntryCard(
    BuildContext context,
    int remainingViews,
    bool isExpandedUnlocked,
  ) {
    final theme = Theme.of(context);
    return TranslucentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lock_open_rounded, color: Colors.amber.shade500),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '광고로 여는 확장 리포트',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isExpandedUnlocked
                ? '오늘은 이미 확장 리포트가 해금되었습니다. 아래에서 심층 분석을 바로 볼 수 있습니다.'
                : '심층 분석을 열면 카테고리 비율, 이번 레벨 성장 성향, 자동 성장 기록을 확인할 수 있습니다.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          _buildFeatureBullet('퀘스트 카테고리 비율'),
          _buildFeatureBullet('다음 레벨 성장 성향 분석'),
          _buildFeatureBullet('직전 레벨 자동 성장 기록'),
          const SizedBox(height: 18),
          if (isExpandedUnlocked)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.green.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.green),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '오늘 확장 리포트 해금됨',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _unlockingExpandedReport || remainingViews <= 0
                    ? null
                    : () => _unlockExpandedReport(context),
                icon: _unlockingExpandedReport
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.ondemand_video_rounded),
                label: Text(
                  remainingViews > 0
                      ? '광고 보고 확장 리포트 열기 (오늘 $remainingViews회 남음)'
                      : '오늘은 더 이상 열 수 없습니다',
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExpandedReport({
    required BuildContext context,
    required Map<StatType, double> categoryData,
    required Map<StatType, double> growthData,
    required Map<StatType, int> autoGrowthData,
    required StatType? dominantCategory,
    required double monthlyCompletionRate,
    required double yearlyCompletionRate,
    required StatType? recommendedCategory,
    required String recommendedQuest,
    required String bestWeekday,
    required int weeklyTotal,
    required dynamic character,
    required Map<DateTime, List<Quest>> completedQuestMap,
    required List<Quest> selectedDayQuests,
  }) {
    final theme = Theme.of(context);
    return Column(
      children: [
        _buildCalendarCard(
          context: context,
          completedQuestMap: completedQuestMap,
          selectedDayQuests: selectedDayQuests,
        ),
        const SizedBox(height: 24),
        TranslucentCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('퀘스트 카테고리 비율', style: theme.textTheme.titleLarge),
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: List.generate(StatType.values.length, (i) {
                      final category = StatType.values[i];
                      final value = categoryData[category] ?? 0;
                      return PieChartSectionData(
                        color: _getCategoryColor(category),
                        value: value <= 0 ? 0.1 : value,
                        title: value > 0 ? '${value.toStringAsFixed(0)}%' : '',
                        radius: 80,
                        titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                        ),
                      );
                    }),
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: StatType.values.map((category) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        color: _getCategoryColor(category),
                      ),
                      const SizedBox(width: 8),
                      Text(_getCategoryName(category)),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildInsightCard(
                title: '이번 레벨 성장 성향',
                value: dominantCategory != null
                    ? _getCategoryName(dominantCategory)
                    : '데이터 부족',
                caption: dominantCategory != null
                    ? '완료한 퀘스트가 가장 많이 반영되는 방향입니다.'
                    : '퀘스트를 완료하면 자동 성장 경향이 쌓입니다.',
                color: Colors.cyanAccent.shade400,
                icon: Icons.auto_graph_rounded,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInsightCard(
                title: '직전 레벨 자동 성장',
                value: _autoGrowthLabel(autoGrowthData),
                caption: '레벨업 시 3포인트는 행동 통계 기반으로 자동 배분됩니다.',
                color: Colors.amber.shade500,
                icon: Icons.auto_awesome_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildInsightCard(
                title: '이번 주 최고 몰입일',
                value: bestWeekday,
                caption: '이번 주 완료한 퀘스트는 총 $weeklyTotal개입니다.',
                color: Colors.lightBlue.shade400,
                icon: Icons.calendar_view_week_rounded,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInsightCard(
                title: '추천 집중 스탯',
                value: recommendedCategory != null
                    ? _getCategoryName(recommendedCategory)
                    : '균형 잡힘',
                caption: recommendedQuest,
                color: Colors.deepPurple.shade300,
                icon: Icons.tips_and_updates_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        TranslucentCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('다음 레벨 자동 성장 예측', style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
              ...StatType.values.map((stat) {
                final percent = growthData[stat] ?? 0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_getCategoryName(stat)),
                          Text('${percent.toStringAsFixed(0)}%'),
                        ],
                      ),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: (percent / 100).clamp(0, 1),
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(999),
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getCategoryColor(stat),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 24),
        TranslucentCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('장기 목표 진행률', style: theme.textTheme.titleLarge),
              const SizedBox(height: 10),
              Text(
                '월간과 연간 레이드 진행 상황을 한 번에 확인할 수 있습니다.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
              const SizedBox(height: 18),
              _buildProgressRow(
                label: '월간 레이드',
                percent: monthlyCompletionRate,
                color: Colors.amber.shade500,
              ),
              const SizedBox(height: 14),
              _buildProgressRow(
                label: '연간 레이드',
                percent: yearlyCompletionRate,
                color: Colors.redAccent.shade200,
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _buildMiniStat(
                      '현재 최저 스탯',
                      _lowestStatLabel(character),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMiniStat(
                      '최고 스탯',
                      _highestStatLabel(character),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarCard({
    required BuildContext context,
    required Map<DateTime, List<Quest>> completedQuestMap,
    required List<Quest> selectedDayQuests,
  }) {
    final theme = Theme.of(context);
    final monthStart = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final monthEnd = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final leadingEmptyDays = monthStart.weekday % 7;
    final totalCells = leadingEmptyDays + monthEnd.day;
    final trailingEmptyDays = (7 - (totalCells % 7)) % 7;
    final cellCount = totalCells + trailingEmptyDays;
    const weekdayLabels = ['일', '월', '화', '수', '목', '금', '토'];

    return TranslucentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('퀘스트 달력', style: theme.textTheme.titleLarge),
              const Spacer(),
              IconButton(
                onPressed: () {
                  setState(() {
                    _focusedMonth =
                        DateTime(_focusedMonth.year, _focusedMonth.month - 1);
                  });
                },
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Text(
                '${_focusedMonth.year}.${_focusedMonth.month.toString().padLeft(2, '0')}',
                style: theme.textTheme.titleMedium,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _focusedMonth =
                        DateTime(_focusedMonth.year, _focusedMonth.month + 1);
                  });
                },
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: weekdayLabels
                .map(
                  (label) => Expanded(
                    child: Center(
                      child: Text(
                        label,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cellCount,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.86,
            ),
            itemBuilder: (context, index) {
              if (index < leadingEmptyDays ||
                  index >= leadingEmptyDays + monthEnd.day) {
                return const SizedBox.shrink();
              }

              final dayNumber = index - leadingEmptyDays + 1;
              final day = DateTime(_focusedMonth.year, _focusedMonth.month, dayNumber);
              final key = _normalizeDate(day);
              final completed = completedQuestMap[key] ?? const [];
              final isSelected = _selectedDay == key;
              final isToday = _normalizeDate(DateTime.now()) == key;

              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  setState(() {
                    _selectedDay = key;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary.withValues(alpha: 0.18)
                        : Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : (isToday
                              ? Colors.cyanAccent.withValues(alpha: 0.7)
                              : Colors.white.withValues(alpha: 0.08)),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 8,
                        top: 8,
                        child: Text(
                          '$dayNumber',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : null,
                          ),
                        ),
                      ),
                      if (completed.isNotEmpty)
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withValues(alpha: 0.35),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            _selectedDay != null
                ? '${_selectedDay!.month}월 ${_selectedDay!.day}일 완료 퀘스트'
                : '날짜를 선택하세요',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          if (selectedDayQuests.isEmpty)
            Text(
              '이 날짜에는 완료한 퀘스트가 없습니다.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.68),
              ),
            )
          else
            ...selectedDayQuests.map((quest) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _getCategoryColor(quest.category),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quest.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_getQuestTypeName(quest.type)} · ${_getCategoryName(quest.category)} · ${quest.xp} XP',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.68),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildProgressRow({
    required String label,
    required double percent,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text('${percent.toStringAsFixed(0)}%'),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: (percent / 100).clamp(0, 1),
          minHeight: 10,
          borderRadius: BorderRadius.circular(999),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline_rounded, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildInsightCard({
    required String title,
    required String value,
    required String caption,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(caption, style: const TextStyle(height: 1.4)),
        ],
      ),
    );
  }

  String _autoGrowthLabel(Map<StatType, int> autoGrowthData) {
    final parts = autoGrowthData.entries
        .where((entry) => entry.value > 0)
        .map((entry) => '${_getCategoryName(entry.key)} +${entry.value}')
        .toList();
    return parts.isEmpty ? '기록 없음' : parts.join(' · ');
  }

  double _completionRate(List<Quest> quests) {
    if (quests.isEmpty) return 0;
    final completed = quests.where((quest) => quest.isCompleted).length;
    return (completed / quests.length) * 100;
  }

  Map<DateTime, List<Quest>> _buildCompletedQuestMap(CharacterState state) {
    final map = <DateTime, List<Quest>>{};
    final allQuests = [
      ...state.dailyQuests,
      ...state.weeklyQuests,
      ...state.monthlyQuests,
      ...state.yearlyQuests,
    ];

    for (final quest in allQuests) {
      if (!quest.isCompleted || quest.completedDate == null) continue;
      final key = _normalizeDate(quest.completedDate!);
      map.putIfAbsent(key, () => []).add(quest);
    }

    return map;
  }

  DateTime _normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  StatType? _recommendedCategory(CharacterState state) {
    final stats = <StatType, double>{
      StatType.strength: state.character.strength,
      StatType.wisdom: state.character.wisdom,
      StatType.health: state.character.health,
      StatType.charisma: state.character.charisma,
    };

    StatType? weakest;
    double? weakestValue;
    for (final entry in stats.entries) {
      if (weakestValue == null || entry.value < weakestValue) {
        weakest = entry.key;
        weakestValue = entry.value;
      }
    }
    return weakest;
  }

  String _recommendedQuestLabel(CharacterState state, StatType? category) {
    if (category == null) return '현재는 스탯 밸런스가 안정적입니다.';
    final allQuests = [
      ...state.dailyQuests,
      ...state.weeklyQuests,
      ...state.monthlyQuests,
      ...state.yearlyQuests,
    ];
    final targetQuest = allQuests.firstWhere(
      (quest) => !quest.isCompleted && quest.category == category,
      orElse: () => Quest(
        id: 'recommended-fallback',
        name: '${_getCategoryName(category)} 계열 퀘스트를 추가해 보세요',
        xp: 0,
        type: QuestType.daily,
        category: category,
      ),
    );
    return '추천 행동: ${targetQuest.name}';
  }

  String _bestWeekdayLabel(Map<int, int> weeklyData) {
    if (weeklyData.values.every((value) => value == 0)) {
      return '기록 없음';
    }
    const labels = {
      1: '월요일',
      2: '화요일',
      3: '수요일',
      4: '목요일',
      5: '금요일',
      6: '토요일',
      7: '일요일',
    };
    final best = weeklyData.entries.reduce(
      (a, b) => a.value >= b.value ? a : b,
    );
    return '${labels[best.key]} ${best.value}개';
  }

  String _lowestStatLabel(dynamic character) {
    final stats = <StatType, double>{
      StatType.strength: character.strength,
      StatType.wisdom: character.wisdom,
      StatType.health: character.health,
      StatType.charisma: character.charisma,
    };
    final weakest = stats.entries.reduce((a, b) => a.value <= b.value ? a : b);
    return '${_getCategoryName(weakest.key)} ${weakest.value.toInt()}';
  }

  String _highestStatLabel(dynamic character) {
    final stats = <StatType, double>{
      StatType.strength: character.strength,
      StatType.wisdom: character.wisdom,
      StatType.health: character.health,
      StatType.charisma: character.charisma,
    };
    final strongest =
        stats.entries.reduce((a, b) => a.value >= b.value ? a : b);
    return '${_getCategoryName(strongest.key)} ${strongest.value.toInt()}';
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
