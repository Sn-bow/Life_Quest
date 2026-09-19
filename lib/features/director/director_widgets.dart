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
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: value),
            const SizedBox(width: 5),
          ],
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressStatusSummary extends StatelessWidget {
  final CharacterState state;
  final bool compact;
  const ProgressStatusSummary({
    required this.state,
    this.compact = false,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final character = state.character;
    final t = Theme.of(context);
    final c = t.colorScheme;
    final l = AppLocalizations.of(context)!;
    final progress = (character.xp / character.maxXp).clamp(0.0, 1.0);
    return Semantics(
      container: true,
      label: l.lqStatusWindow,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(compact ? 16 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 14,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Lv. ${character.level.toString().padLeft(2, '0')}',
                    style: t.textTheme.titleLarge?.copyWith(
                      color: c.primary,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  Text(character.name, style: t.textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 16,
                runSpacing: 5,
                children: [
                  Text(
                    '${character.xp.round()} / ${character.maxXp.round()} XP',
                    style: t.textTheme.bodySmall,
                  ),
                  Text(
                    '${l.lqEarnedToday} +${state.todayGrowthDelta.xp}',
                    style: t.textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 5,
                  semanticsLabel: 'XP',
                  semanticsValue: '${(progress * 100).round()}%',
                ),
              ),
              if (!compact) ...[
                const SizedBox(height: 14),
                Text(
                  l.lqActionsRecorded(state.questCompletionCount),
                  style: t.textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
