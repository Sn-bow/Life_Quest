import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../l10n/app_localizations.dart';
import '../../state/character_state.dart';
import 'quest_director_engine.dart';

String focusName(GrowthFocus focus, AppLocalizations s) => switch (focus) {
      GrowthFocus.vitality => s.lqVitality,
      GrowthFocus.learning => s.lqLearning,
      GrowthFocus.order => s.lqOrder,
      GrowthFocus.connection => s.lqConnection,
    };
IconData focusIcon(GrowthFocus focus) => switch (focus) {
      GrowthFocus.vitality => PhosphorIcons.heartbeat,
      GrowthFocus.learning => PhosphorIcons.bookOpen,
      GrowthFocus.order => PhosphorIcons.checkSquare,
      GrowthFocus.connection => PhosphorIcons.chatsCircle,
    };
Color focusColor(GrowthFocus focus, BuildContext context) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  return switch (focus) {
    GrowthFocus.vitality =>
      dark ? const Color(0xFFEDAE9D) : const Color(0xFF9F402A),
    GrowthFocus.learning => Theme.of(context).colorScheme.primary,
    GrowthFocus.order =>
      dark ? const Color(0xFFC2B4F7) : const Color(0xFF69509F),
    GrowthFocus.connection =>
      dark ? const Color(0xFFB8D89D) : const Color(0xFF49672B),
  };
}

class QuestTag extends StatelessWidget {
  final String label;
  final Color? color;
  final IconData? icon;
  const QuestTag(this.label, {this.color, this.icon, super.key});
  @override
  Widget build(BuildContext context) {
    final value = color ?? Theme.of(context).colorScheme.onSurfaceVariant;
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
            color: value.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(6)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: value),
            const SizedBox(width: 5)
          ],
          Flexible(
              child: Text(label,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: value))),
        ]));
  }
}

class HunterStatusSummary extends StatelessWidget {
  final CharacterState state;
  const HunterStatusSummary({required this.state, super.key});
  @override
  Widget build(BuildContext context) {
    final c = state.character;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;
    final s = AppLocalizations.of(context)!;
    final rank =
        ['E', 'D', 'C', 'B', 'A', 'S'][((c.level - 1) ~/ 10).clamp(0, 5)];
    final progress = (c.xp / c.maxXp).clamp(0.0, 1.0);
    final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
    return Semantics(
      container: true,
      label: s.lqStatusWindow,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.primary.withValues(alpha: .25)),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: dark
                    ? const [
                        Color(0xFF172C3D),
                        Color(0xFF111D30),
                        Color(0xFF191D35)
                      ]
                    : const [Color(0xFFE2F3F6), Color(0xFFF0F3FC)])),
        child: LayoutBuilder(builder: (context, box) {
          final compact = box.maxWidth < 300 || scale > 1.3;
          final badge = Container(
              width: 54 * scale.clamp(1, 2),
              padding: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border:
                      Border.all(color: colors.primary.withValues(alpha: .35)),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('RANK',
                    style: TextStyle(
                        fontSize: 8,
                        letterSpacing: 1.5,
                        color: colors.primary)),
                Text(rank,
                    style: TextStyle(
                        fontSize: 29,
                        height: 1.1,
                        fontWeight: FontWeight.w300,
                        color: colors.primary)),
              ]));
          final identity =
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(c.name,
                maxLines: compact ? 2 : 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 3),
            Text('Lv. ${c.level.toString().padLeft(2, '0')}',
                style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 25,
                    fontFeatures: const [FontFeature.tabularFigures()])),
          ]);
          final earned = Column(
              crossAxisAlignment:
                  compact ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Text(s.lqEarnedToday,
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 10)),
                const SizedBox(height: 5),
                Text('+${state.todayGrowthDelta.xp} XP',
                    style: TextStyle(
                        color: colors.primary,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        fontFeatures: const [FontFeature.tabularFigures()])),
              ]);
          final experience = Text('EXPERIENCE',
              style: TextStyle(
                  fontSize: 9,
                  letterSpacing: 1.4,
                  color: colors.onSurfaceVariant));
          final total = Text('${c.xp.round()} / ${c.maxXp.round()} XP',
              style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  fontFeatures: const [FontFeature.tabularFigures()]));
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  badge,
                  const SizedBox(width: 14),
                  Expanded(child: identity),
                  if (!compact) ...[const SizedBox(width: 10), earned]
                ]),
                if (compact) ...[const SizedBox(height: 16), earned],
                const SizedBox(height: 18),
                if (compact) ...[
                  experience,
                  const SizedBox(height: 5),
                  total
                ] else
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [experience, total]),
                const SizedBox(height: 7),
                ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        semanticsLabel: 'XP',
                        semanticsValue: '${(progress * 100).round()}%')),
              ]);
        }),
      ),
    );
  }
}
