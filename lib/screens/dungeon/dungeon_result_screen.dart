import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:life_quest_final_v2/state/dungeon_state.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';

class DungeonResultScreen extends StatefulWidget {
  final bool isVictory;

  const DungeonResultScreen({super.key, required this.isVictory});

  @override
  State<DungeonResultScreen> createState() => _DungeonResultScreenState();
}

class _DungeonResultScreenState extends State<DungeonResultScreen> {
  bool _rewardsApplied = false;
  Map<String, dynamic>? _rewards;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _rewards ??= context.read<DungeonState>().calculateRunRewards();
    _applyRewards();
  }

  void _applyRewards() {
    if (_rewardsApplied || _rewards == null) return;
    _rewardsApplied = true;

    final characterState = context.read<CharacterState>();
    final dungeonState = context.read<DungeonState>();
    final xp = _rewards!['xp'] as int;
    final gold = _rewards!['gold'] as int;
    characterState.addDungeonReward(xp, gold);

    if (widget.isVictory) {
      characterState.completeZone(dungeonState.currentZone);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryColor = widget.isVictory ? Colors.amber : Colors.red;
    final bgGradient = widget.isVictory
        ? (isDark
            ? [const Color(0xFF1D1E33), const Color(0xFF2D1B00)]
            : [Colors.amber.shade50, Colors.white])
        : (isDark
            ? [const Color(0xFF1D1E33), const Color(0xFF2D0000)]
            : [Colors.red.shade50, Colors.white]);

    final rewards = _rewards ?? {};
    final xpReward = rewards['xp'] as int? ?? 0;
    final goldReward = rewards['gold'] as int? ?? 0;
    final monstersKilled = rewards['monstersKilled'] as int? ?? 0;
    final nodesCompleted = rewards['nodesCompleted'] as int? ?? 0;
    final zone = rewards['zone'] as int? ?? 1;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: bgGradient,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(flex: 1),

                  // Icon
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor.withValues(alpha: isDark ? 0.2 : 0.1),
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.5),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.isVictory ? Icons.emoji_events : Icons.heart_broken,
                      size: 48,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    widget.isVictory ? l10n.dungeonResultVictoryTitle : l10n.dungeonResultDefeatTitle,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.isVictory
                        ? l10n.dungeonResultVictoryMessage
                        : l10n.dungeonResultDefeatMessage,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      height: 1.5,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // Run stats
                  _StatsCard(
                    monstersKilled: monstersKilled,
                    nodesCompleted: nodesCompleted,
                    zone: zone,
                    isDark: isDark,
                    isVictory: widget.isVictory,
                  ),

                  const SizedBox(height: 16),

                  // Rewards
                  _RewardsCard(
                    xpGained: xpReward,
                    goldGained: goldReward,
                    isDark: isDark,
                    isVictory: widget.isVictory,
                  ),

                  const Spacer(flex: 2),

                  // Return to home button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final dungeonState = context.read<DungeonState>();
                        dungeonState.resetRun();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        l10n.dungeonResultReturnHomeButton,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Stats card
// ============================================================================

class _StatsCard extends StatelessWidget {
  final int monstersKilled;
  final int nodesCompleted;
  final int zone;
  final bool isDark;
  final bool isVictory;

  const _StatsCard({
    required this.monstersKilled,
    required this.nodesCompleted,
    required this.zone,
    required this.isDark,
    required this.isVictory,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.dungeonResultStatsTitle,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _statRow(Icons.terrain, l10n.dungeonResultStatsZone,
              'Zone $zone', Colors.teal, isDark),
          const SizedBox(height: 8),
          _statRow(Icons.location_on, l10n.dungeonResultStatsNodesCompleted,
              '$nodesCompleted', Colors.blue, isDark),
          const SizedBox(height: 8),
          _statRow(Icons.sports_martial_arts, l10n.dungeonResultStatsMonsterKilled,
              '$monstersKilled', Colors.red, isDark),
        ],
      ),
    );
  }

  Widget _statRow(IconData icon, String label, String value, Color color,
      bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// Rewards card
// ============================================================================

class _RewardsCard extends StatelessWidget {
  final int xpGained;
  final int goldGained;
  final bool isDark;
  final bool isVictory;

  const _RewardsCard({
    required this.xpGained,
    required this.goldGained,
    required this.isDark,
    required this.isVictory,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isVictory
            ? Colors.amber.withValues(alpha: isDark ? 0.1 : 0.06)
            : Colors.grey.withValues(alpha: isDark ? 0.1 : 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isVictory
              ? Colors.amber.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.card_giftcard,
                size: 18,
                color: isVictory ? Colors.amber : Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                l10n.dungeonResultRewardsTitle,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // XP and Gold badges
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              // XP
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(
                      l10n.dungeonResultXpReward(xpGained),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),

              // Gold
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.monetization_on,
                        size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      l10n.dungeonResultGoldReward(goldGained),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (isVictory) ...[
            const SizedBox(height: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, size: 14, color: Colors.green),
                  const SizedBox(width: 4),
                  Text(
                    l10n.dungeonResultVictoryBonus,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            const SizedBox(height: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.info_outline, size: 14, color: Colors.red),
                  const SizedBox(width: 4),
                  Text(
                    l10n.dungeonResultDefeatPenalty,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
