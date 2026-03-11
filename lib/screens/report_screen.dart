import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/widgets/translucent_card.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  // --- 추가된 부분: 카테고리 이름과 색상을 가져오는 헬퍼 ---
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
  // --- 여기까지 ---

  @override
  Widget build(BuildContext context) {
    final characterState = context.watch<CharacterState>(); // --- 수정된 부분 ---
    final weeklyData = characterState.weeklyCompletedQuests;
    final categoryData =
        characterState.questCategoryDistribution; // --- 추가된 부분 ---
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

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
            // --- Summary Cards ---
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
                    value:
                        '${characterState.questCompletionCount}개',
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
                  Text(
                    '한주간의 활동 기록',
                    style: theme.textTheme.titleLarge,
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
                                    fontWeight: FontWeight.bold),
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
                                String text;
                                switch (value.toInt()) {
                                  case 0:
                                    text = '월';
                                    break;
                                  case 1:
                                    text = '화';
                                    break;
                                  case 2:
                                    text = '수';
                                    break;
                                  case 3:
                                    text = '목';
                                    break;
                                  case 4:
                                    text = '금';
                                    break;
                                  case 5:
                                    text = '토';
                                    break;
                                  case 6:
                                    text = '일';
                                    break;
                                  default:
                                    text = '';
                                    break;
                                }
                                return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    space: 16.0,
                                    child: Text(text, style: style));
                              },
                              reservedSize: 42,
                            ),
                          ),
                          leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
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
                              )
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
            const SizedBox(height: 24), // --- 간격 추가 ---

            // --- 추가된 부분: 원형 차트 카드 ---
            TranslucentCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '퀘스트 카테고리 비율',
                    style: theme.textTheme.titleLarge,
                  ),
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
                            value: value,
                            title: '${value.toStringAsFixed(0)}%',
                            radius: 80,
                            titleStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(color: Colors.black, blurRadius: 2)
                              ],
                            ),
                          );
                        }),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // 범례
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
                  )
                ],
              ),
            ),
            // --- 여기까지 ---

            const SizedBox(height: 30),
            TranslucentCard(
              child: ListTile(
                leading:
                    Icon(Icons.insights_outlined, color: Colors.amber.shade600),
                title: Text('확장 리포트 예고',
                    style: TextStyle(
                        color: Colors.amber.shade600,
                        fontWeight: FontWeight.bold)),
                subtitle: const Text(
                    '월간 리포트와 성장 추이 분석은 추후 업데이트 예정입니다. 현재는 핵심 일일 리포트에 집중하고 있습니다.'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context,
      {required String title,
      required String value,
      required IconData icon,
      required Color color}) {
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


