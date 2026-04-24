import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/models/achievement.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/widgets/translucent_card.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<CharacterState>(
      builder: (context, characterState, child) {
        final allAchievements = characterState.allAchievements;
        final progressMap = characterState.achievementProgress;

        final inProgressAchievements = allAchievements.where((ach) => !(progressMap[ach.id]?.isCompleted ?? false)).toList();
        final completedAchievements = allAchievements.where((ach) => progressMap[ach.id]?.isCompleted ?? false).toList();

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text(l10n.achievementScreenTitle),
              bottom: TabBar(
                tabs: [
                  Tab(text: l10n.achievementTabInProgress),
                  Tab(text: l10n.achievementTabCompleted),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _buildAchievementList(context, inProgressAchievements, progressMap, isInProgress: true),
                _buildAchievementList(context, completedAchievements, progressMap, isInProgress: false),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAchievementList(BuildContext context, List<Achievement> achievements, Map<String, AchievementProgress> progressMap, {required bool isInProgress}) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (achievements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isInProgress ? PhosphorIcons.rocketLaunch : PhosphorIcons.medal, size: 80, color: isDarkMode ? Colors.white24 : Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(isInProgress ? l10n.achievementEmptyInProgress : l10n.achievementEmptyCompleted, textAlign: TextAlign.center, style: TextStyle(color: isDarkMode ? Colors.white54 : Colors.grey.shade600)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        final progress = progressMap[achievement.id];
        final currentValue = progress?.currentValue ?? 0;
        final targetValue = achievement.targetValue;
        final isCompleted = progress?.isCompleted ?? false;

        String rewardText = '';
        if (achievement.rewardType == RewardType.xp) {
          rewardText = l10n.achievementRewardXp(achievement.rewardValue);
        } else {
          rewardText = l10n.achievementRewardSp(achievement.rewardValue);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TranslucentCard(
            child: ListTile(
              leading: Icon(
                _achievementIcon(achievement.condition, isCompleted),
                color: isCompleted
                    ? _achievementColor(achievement.condition)
                    : (isDarkMode ? Colors.white38 : Colors.grey.shade400),
                size: 40,
              ),
              title: Text(
                achievement.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isCompleted ? Colors.amber.shade600 : theme.textTheme.bodyLarge?.color,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    achievement.description,
                    style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    rewardText,
                    style: TextStyle(color: theme.colorScheme.primary, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  if (!isCompleted)
                    LinearProgressIndicator(
                      value: targetValue > 0
                          ? (currentValue / targetValue).clamp(0.0, 1.0)
                          : 0.0,
                      backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                    ),
                ],
              ),
              trailing: isCompleted
                  ? null
                  : Text(
                      '$currentValue / $targetValue',
                      style: TextStyle(fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color),
                    ),
            ),
          ),
        );
      },
    );
  }

  IconData _achievementIcon(AchievementCondition condition, bool isCompleted) {
    switch (condition) {
      case AchievementCondition.questCompleted:
        return isCompleted ? PhosphorIcons.checkCircleFill : PhosphorIcons.checkCircle;
      case AchievementCondition.levelReached:
        return isCompleted ? PhosphorIcons.arrowFatLinesUpFill : PhosphorIcons.arrowFatLinesUp;
      case AchievementCondition.strengthReached:
        return isCompleted ? PhosphorIcons.swordFill : PhosphorIcons.sword;
      case AchievementCondition.wisdomReached:
        return isCompleted ? PhosphorIcons.bookOpenFill : PhosphorIcons.bookOpen;
      case AchievementCondition.healthReached:
        return isCompleted ? PhosphorIcons.heartFill : PhosphorIcons.heart;
      case AchievementCondition.charismaReached:
        return isCompleted ? PhosphorIcons.starFill : PhosphorIcons.star;
      case AchievementCondition.skillsLearned:
        return isCompleted ? PhosphorIcons.lightningFill : PhosphorIcons.lightning;
      case AchievementCondition.monstersKilled:
        return isCompleted ? PhosphorIcons.skullFill : PhosphorIcons.skull;
      case AchievementCondition.goldEarned:
        return isCompleted ? PhosphorIcons.coinsFill : PhosphorIcons.coins;
      case AchievementCondition.streakReached:
        return isCompleted ? PhosphorIcons.flameFill : PhosphorIcons.flame;
    }
  }

  Color _achievementColor(AchievementCondition condition) {
    switch (condition) {
      case AchievementCondition.questCompleted:
        return Colors.green.shade400;
      case AchievementCondition.levelReached:
        return Colors.amber.shade500;
      case AchievementCondition.strengthReached:
        return Colors.red.shade400;
      case AchievementCondition.wisdomReached:
        return Colors.blue.shade400;
      case AchievementCondition.healthReached:
        return Colors.pink.shade400;
      case AchievementCondition.charismaReached:
        return Colors.purple.shade400;
      case AchievementCondition.skillsLearned:
        return Colors.cyan.shade400;
      case AchievementCondition.monstersKilled:
        return Colors.deepOrange.shade400;
      case AchievementCondition.goldEarned:
        return Colors.yellow.shade600;
      case AchievementCondition.streakReached:
        return Colors.orange.shade500;
    }
  }
}
