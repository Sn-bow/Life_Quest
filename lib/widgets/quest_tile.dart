import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/models/quest.dart';
import 'package:life_quest_final_v2/widgets/translucent_card.dart';

class QuestTile extends StatelessWidget {
  final Quest quest;
  final VoidCallback onChecked;
  final VoidCallback onDeleted;
  final VoidCallback? onEdited;
  final String? rewardPreview;

  const QuestTile({
    super.key,
    required this.quest,
    required this.onChecked,
    required this.onDeleted,
    this.onEdited,
    this.rewardPreview,
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    decoration: quest.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: quest.isCompleted
                        ? Colors.grey
                        : theme.textTheme.bodyLarge?.color,
                  ),
                ),
                subtitle: rewardPreview == null
                    ? null
                    : Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          rewardPreview!,
                          maxLines: 4,
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.4,
                            color: Colors.amber.shade300,
                          ),
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
                          '+${quest.xp} XP',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '+${(quest.xp * 0.5).round()} ',
                              style: TextStyle(
                                color: Colors.amber.shade400,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                            Icon(Icons.monetization_on,
                                size: 12, color: Colors.amber.shade400),
                          ],
                        ),
                      ],
                    ),
                    if (!quest.isCompleted && onEdited != null)
                      IconButton(
                        icon: Icon(Icons.edit,
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.7)),
                        onPressed: onEdited,
                        tooltip: '퀘스트 수정',
                      ),
                    IconButton(
                      icon: Icon(Icons.delete,
                          color: Colors.redAccent.withValues(alpha: 0.7)),
                      onPressed: onDeleted,
                      tooltip: '퀘스트 삭제',
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
