import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/data/core_loop_rules.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TodayAdventureSummary extends StatelessWidget {
  final CharacterState state;

  const TodayAdventureSummary({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final growth = state.todayGrowthDelta;
    final modifier = state.todayDailyModifier;
    final recommendation = state.todayRecommendedAction;
    final nextTitle = state.nextTitleProgress;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.primary.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(PhosphorIcons.compass, color: colors.primary, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '오늘의 모험',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _Pill(
                label: '${growth.completedCount}개 완료',
                color: colors.primary,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '현실 퀘스트를 완료하면 오늘 던전에서 힘으로 바뀝니다.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MetricChip(icon: PhosphorIcons.star, label: 'XP +${growth.xp}'),
              _MetricChip(
                  icon: PhosphorIcons.coins, label: '골드 +${growth.gold}'),
              _MetricChip(
                icon: _statIcon(growth.dominantStat),
                label: growth.dominantStat == null
                    ? '성향 대기'
                    : '${_statLabel(growth.dominantStat!)} 성장',
              ),
            ],
          ),
          const SizedBox(height: 14),
          const _SectionHeader(
            icon: PhosphorIcons.sparkle,
            title: '오늘 던전 보정',
          ),
          const SizedBox(height: 8),
          if (modifier.hasAnyBonus)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: modifier
                  .labels()
                  .take(4)
                  .map((label) => _Pill(label: label, color: colors.tertiary))
                  .toList(),
            )
          else
            Text(
              '아직 적용 중인 보정이 없습니다. 퀘스트를 하나 완료하면 보정이 열립니다.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: colors.onSurfaceVariant),
            ),
          const SizedBox(height: 14),
          const _SectionHeader(
            icon: Icons.flag_outlined,
            title: '다음 행동',
          ),
          const SizedBox(height: 8),
          Text(
            recommendation.title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            recommendation.reason,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
              height: 1.35,
            ),
          ),
          if (nextTitle != null) ...[
            const SizedBox(height: 14),
            _TitleProgress(progress: nextTitle),
          ],
        ],
      ),
    );
  }

  static String _statLabel(StatType stat) {
    return switch (stat) {
      StatType.strength => '힘',
      StatType.wisdom => '지혜',
      StatType.health => '건강',
      StatType.charisma => '매력',
    };
  }

  static IconData _statIcon(StatType? stat) {
    return switch (stat) {
      StatType.strength => PhosphorIcons.sword,
      StatType.wisdom => PhosphorIcons.brain,
      StatType.health => PhosphorIcons.heart,
      StatType.charisma => PhosphorIcons.chatsCircle,
      null => PhosphorIcons.sparkle,
    };
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 16, color: colors.primary),
        const SizedBox(width: 6),
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    );
  }
}

class _MetricChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetricChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: colors.primary),
          const SizedBox(width: 5),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color color;

  const _Pill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.38)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}

class _TitleProgress extends StatelessWidget {
  final TitleProgressSnapshot progress;

  const _TitleProgress({required this.progress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(PhosphorIcons.medal, size: 16, color: colors.secondary),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                '다음 칭호: ${progress.title.name}',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              '${progress.current}/${progress.required}',
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress.ratio,
            minHeight: 6,
            backgroundColor: colors.surface,
            valueColor: AlwaysStoppedAnimation<Color>(colors.secondary),
          ),
        ),
      ],
    );
  }
}
