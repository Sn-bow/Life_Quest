import '../features/system/system_widgets.dart' show xpText;
import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/models/quest.dart';
import 'package:life_quest_final_v2/widgets/translucent_card.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';

class QuestTile extends StatelessWidget {
  final Quest quest;
  final VoidCallback onChecked;
  final VoidCallback onDeleted;
  final VoidCallback? onEdited;

  const QuestTile({
    super.key,
    required this.quest,
    required this.onChecked,
    required this.onDeleted,
    this.onEdited,
  });

  Color _difficultyColor() {
    switch (quest.difficulty) {
      case QuestDifficulty.easy:
        return Colors.green;
      case QuestDifficulty.normal:
        return Colors.blue;
      case QuestDifficulty.hard:
        return Colors.orange;
      case QuestDifficulty.veryHard:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final diffColor = _difficultyColor();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TranslucentCard(
        child: Row(
          children: [
            // Difficulty color indicator bar
            Container(
              width: 4,
              height: 48,
              decoration: BoxDecoration(
                color: diffColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 8),
                leading: Checkbox(
                  value: quest.isCompleted,
                  onChanged: quest.isCompleted
                      ? null
                      : (bool? value) {
                          if (value == true) {
                            onChecked();
                          }
                        },
                  activeColor: theme.colorScheme.primary,
                  checkColor: isDarkMode ? Colors.black : Colors.white,
                ),
                title: Text(
                  quest.name,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.25,
                    decoration: quest.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: quest.isCompleted
                        ? Colors.grey
                        : theme.textTheme.bodyLarge?.color,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '+${xpText(quest.awardedXp ?? quest.lockedXp ?? quest.xp)} XP',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    if (!quest.isCompleted && onEdited != null)
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 20,
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.7,
                          ),
                        ),
                        onPressed: onEdited,
                        tooltip: l10n.questTileEditTooltip,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints.tightFor(
                          width: 32,
                          height: 32,
                        ),
                      ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        size: 20,
                        color: Colors.redAccent.withValues(alpha: 0.7),
                      ),
                      onPressed: onDeleted,
                      tooltip: l10n.questTileDeleteTooltip,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints.tightFor(
                        width: 32,
                        height: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
