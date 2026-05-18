import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/screens/report_screen.dart';
import 'package:life_quest_final_v2/screens/settings_screen.dart';
import 'package:life_quest_final_v2/screens/status_screen.dart';
import 'package:life_quest_final_v2/screens/timer_screen.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/widgets/today_adventure_summary.dart';
import 'package:life_quest_final_v2/widgets/translucent_card.dart';
import 'package:life_quest_final_v2/widgets/xp_bar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class TodayScreen extends StatelessWidget {
  final VoidCallback onOpenQuests;
  final VoidCallback onOpenDungeon;

  const TodayScreen({
    super.key,
    required this.onOpenQuests,
    required this.onOpenDungeon,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CharacterState>(
      builder: (context, characterState, child) {
        if (characterState.isLoading || !characterState.isDataLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final character = characterState.character;
        final theme = Theme.of(context);
        final colors = theme.colorScheme;

        return Scaffold(
          appBar: AppBar(
            title: const Text('오늘'),
            actions: [
              IconButton(
                icon: const Icon(PhosphorIcons.timer),
                tooltip: '집중 타이머',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TimerScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(PhosphorIcons.chartBar),
                tooltip: '성장 리포트',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReportScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(PhosphorIcons.gear),
                tooltip: '설정',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TodayAdventureSummary(state: characterState),
                TranslucentCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor:
                                colors.primary.withValues(alpha: 0.15),
                            backgroundImage: character.photoUrl != null
                                ? NetworkImage(character.photoUrl!)
                                : null,
                            child: character.photoUrl == null
                                ? Icon(
                                    PhosphorIcons.userCircle,
                                    color: colors.primary,
                                    size: 28,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  character.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Lv. ${character.level} | ${character.title}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      XpBar(
                        currentXp: character.xp,
                        maxXp: character.maxXp,
                        color: colors.primary,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _ResourceTile(
                              icon: PhosphorIcons.heart,
                              label: 'HP',
                              value:
                                  '${character.characterHp}/${character.characterMaxHp}',
                              color: Colors.redAccent,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _ResourceTile(
                              icon: PhosphorIcons.coins,
                              label: '골드',
                              value: '${character.gold}',
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _ResourceTile(
                              icon: PhosphorIcons.lightning,
                              label: 'AP',
                              value:
                                  '${character.actionPoints}/${character.maxActionPoints}',
                              color: colors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                TranslucentCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '오늘 할 일',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '퀘스트를 완료하면 XP, 골드, 스탯 흐름이 쌓이고 던전에서 체감할 수 있는 보정으로 이어집니다.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              icon: const Icon(PhosphorIcons.checkSquare),
                              label: const Text('퀘스트 관리'),
                              onPressed: onOpenQuests,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(PhosphorIcons.gameController),
                              label: const Text('성장 체감'),
                              onPressed: onOpenDungeon,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          icon: const Icon(PhosphorIcons.userCircle),
                          label: const Text('상세 상태 보기'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const StatusScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ResourceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ResourceTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
