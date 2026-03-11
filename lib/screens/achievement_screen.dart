import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/models/achievement.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/widgets/translucent_card.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              title: const Text('업적'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: '진행 중'),
                  Tab(text: '완료'),
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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (achievements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isInProgress ? PhosphorIcons.rocketLaunch : PhosphorIcons.medal, size: 80, color: isDarkMode ? Colors.white24 : Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(isInProgress ? '모든 업적을 달성했거나, 새로운 도전을 기다리고 있습니다!' : '아직 완료한 업적이 없습니다.', textAlign: TextAlign.center, style: TextStyle(color: isDarkMode ? Colors.white54 : Colors.grey.shade600)),
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
          rewardText = '보상: ${achievement.rewardValue} XP';
        } else {
          rewardText = '보상: ${achievement.rewardValue} SP';
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TranslucentCard(
            child: ListTile(
              leading: Icon(
                isCompleted ? PhosphorIcons.trophyFill : PhosphorIcons.trophy,
                color: isCompleted ? Colors.amber.shade600 : (isDarkMode ? Colors.white : Colors.grey.shade800),
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
                      value: currentValue / targetValue,
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
}
