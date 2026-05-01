import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:life_quest_final_v2/models/dungeon_map.dart';
import 'package:life_quest_final_v2/state/dungeon_state.dart';
import 'package:life_quest_final_v2/screens/dungeon/card_battle_screen.dart';
import 'package:life_quest_final_v2/screens/dungeon/dungeon_event_screen.dart';
import 'package:life_quest_final_v2/screens/dungeon/dungeon_shop_screen.dart';
import 'package:life_quest_final_v2/screens/dungeon/dungeon_rest_screen.dart';
import 'package:life_quest_final_v2/screens/dungeon/dungeon_result_screen.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';

class DungeonMapScreen extends StatefulWidget {
  const DungeonMapScreen({super.key});

  @override
  State<DungeonMapScreen> createState() => _DungeonMapScreenState();
}

class _DungeonMapScreenState extends State<DungeonMapScreen> {
  @override
  void initState() {
    super.initState();
    // 던전 맵 진입 시 BGM 시작
    SoundService().playDungeonBgm();
  }

  @override
  void dispose() {
    // 던전 완전히 나갈 때 BGM 정지
    SoundService().stopDungeonBgm();
    super.dispose();
  }

  String _getZoneName(BuildContext context, int zone) {
    final l10n = AppLocalizations.of(context)!;
    switch (zone) {
      case 1:
        return l10n.zone1Name;
      case 2:
        return l10n.zone2Name;
      case 3:
        return l10n.zone3Name;
      case 4:
        return l10n.zone4Name;
      case 5:
        return l10n.zone5Name;
      default:
        return 'Zone $zone';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? const Color(0xFF00FFFF) : Colors.deepPurple;
    final dungeonState = context.watch<DungeonState>();
    final map = dungeonState.currentMap;

    if (map == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.dungeonMapTitle, style: TextStyle(color: accent))),
        body: Center(child: Text(l10n.dungeonMapNoData)),
      );
    }

    final maxRow = map.nodes.fold<int>(0, (m, n) => n.row > m ? n.row : m);
    final zoneName = _getZoneName(context, map.zone);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.map, color: accent, size: 22),
            const SizedBox(width: 8),
            Text(
              zoneName,
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                color: accent,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Progress bar
          _ProgressHeader(
            zoneName: zoneName,
            completedCount:
                map.nodes.where((n) => n.isCompleted).length,
            totalCount: map.nodes.length,
            isDark: isDark,
            accent: accent,
          ),

          // Map area
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  reverse: true, // row 0 at bottom, boss at top
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: ConstrainedBox(
                    // Ensure content fills the viewport so nodes spread vertically
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 32,
                    ),
                    child: _buildMap(
                        context, map, maxRow, isDark, accent, dungeonState),
                  ),
                );
              },
            ),
          ),

          // Player stats bar
          _PlayerStatsBar(dungeonState: dungeonState, isDark: isDark, accent: accent),
        ],
      ),
    );
  }

  Widget _buildMap(
    BuildContext context,
    DungeonMap map,
    int maxRow,
    bool isDark,
    Color accent,
    DungeonState dungeonState,
  ) {
    final List<Widget> rowWidgets = [];

    for (int row = maxRow; row >= 0; row--) {
      final rowNodes = map.nodes.where((n) => n.row == row).toList()
        ..sort((a, b) => a.column.compareTo(b.column));

      // Draw connection lines to next row
      if (row < maxRow) {
        rowWidgets.add(
          SizedBox(
            height: 32,
            child: CustomPaint(
              size: const Size(double.infinity, 32),
              painter: _ConnectionPainter(
                fromNodes: map.nodes.where((n) => n.row == row).toList(),
                toNodes: map.nodes.where((n) => n.row == row + 1).toList(),
                allNodes: map.nodes,
                isDark: isDark,
              ),
            ),
          ),
        );
      }

      // Draw nodes in this row
      rowWidgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: rowNodes.map((node) {
            return _NodeWidget(
              node: node,
              isDark: isDark,
              accent: accent,
              onTap: () => _onNodeTap(context, node, dungeonState),
            );
          }).toList(),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: rowWidgets,
    );
  }

  void _onNodeTap(BuildContext context, DungeonNode node, DungeonState dungeonState) {
    if (!node.isAccessible || node.isCompleted) return;

    dungeonState.selectNode(node.id);
    final nav = Navigator.of(context);

    switch (node.type) {
      case NodeType.combat:
      case NodeType.elite:
        nav.push(
          MaterialPageRoute(
            builder: (_) => CardBattleScreen(
              deck: dungeonState.currentDeck,
              enemies: dungeonState.getEnemiesForNode(node),
              playerHp: dungeonState.playerHp,
              playerMaxHp: dungeonState.playerMaxHp,
              zone: dungeonState.currentZone,
            ),
          ),
        ).then((result) {
          // result = {'won': true, 'hp': finalHp} or false
          if (result is Map && result['won'] == true) {
            // M-4: 처치한 몬스터 수 기록 (combat=1, elite=2)
            dungeonState.incrementMonstersKilled(
              node.type == NodeType.elite ? 2 : 1,
            );
            // 배틀 후 최종 HP를 dungeon state에 동기화
            if (result['hp'] is int) {
              dungeonState.setPlayerHp(result['hp'] as int);
            }
            dungeonState.completeCurrentNode();
          } else if (result == false || (result is Map && result['won'] == false)) {
            // Player died or forfeited combat
            dungeonState.endRun(victory: false);
            nav.push(MaterialPageRoute(
              builder: (_) => const DungeonResultScreen(isVictory: false),
            ));
          }
        });
        break;

      case NodeType.boss:
        nav.push(
          MaterialPageRoute(
            builder: (_) => CardBattleScreen(
              deck: dungeonState.currentDeck,
              enemies: dungeonState.getEnemiesForNode(node),
              playerHp: dungeonState.playerHp,
              playerMaxHp: dungeonState.playerMaxHp,
              zone: dungeonState.currentZone,
            ),
          ),
        ).then((result) {
          if (result is Map && result['won'] == true) {
            // M-4: 보스 처치 카운트
            dungeonState.incrementMonstersKilled(1);
            if (result['hp'] is int) {
              dungeonState.setPlayerHp(result['hp'] as int);
            }
            dungeonState.completeCurrentNode();
            nav.push(MaterialPageRoute(
              builder: (_) => const DungeonResultScreen(isVictory: true),
            ));
          } else if (result == false || (result is Map && result['won'] == false)) {
            dungeonState.endRun(victory: false);
            nav.push(MaterialPageRoute(
              builder: (_) => const DungeonResultScreen(isVictory: false),
            ));
          }
        });
        break;

      case NodeType.event:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const DungeonEventScreen()),
        ).then((_) {
          dungeonState.completeCurrentNode();
        });
        break;

      case NodeType.shop:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const DungeonShopScreen()),
        ).then((_) {
          dungeonState.completeCurrentNode();
        });
        break;

      case NodeType.rest:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const DungeonRestScreen()),
        ).then((_) {
          dungeonState.completeCurrentNode();
        });
        break;
    }
  }

}

// ============================================================================
// Progress header
// ============================================================================

class _ProgressHeader extends StatelessWidget {
  final String zoneName;
  final int completedCount;
  final int totalCount;
  final bool isDark;
  final Color accent;

  const _ProgressHeader({
    required this.zoneName,
    required this.completedCount,
    required this.totalCount,
    required this.isDark,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1D1E33)
            : Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: accent.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                zoneName,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                '$completedCount / $totalCount',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation(accent),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Node widget
// ============================================================================

class _NodeWidget extends StatelessWidget {
  final DungeonNode node;
  final bool isDark;
  final Color accent;
  final VoidCallback onTap;

  const _NodeWidget({
    required this.node,
    required this.isDark,
    required this.accent,
    required this.onTap,
  });

  IconData get _icon {
    switch (node.type) {
      case NodeType.combat:
        return Icons.sports_martial_arts;
      case NodeType.elite:
        return Icons.whatshot;
      case NodeType.event:
        return Icons.help_outline;
      case NodeType.shop:
        return Icons.shopping_cart;
      case NodeType.rest:
        return Icons.hotel;
      case NodeType.boss:
        return Icons.workspace_premium;
    }
  }

  Color get _nodeColor {
    if (node.isCompleted) return Colors.grey;
    if (!node.isAccessible) return Colors.grey.shade600;

    switch (node.type) {
      case NodeType.combat:
        return Colors.red;
      case NodeType.elite:
        return Colors.orange;
      case NodeType.event:
        return Colors.amber;
      case NodeType.shop:
        return Colors.green;
      case NodeType.rest:
        return Colors.blue;
      case NodeType.boss:
        return Colors.deepPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _nodeColor;
    final isAccessible = node.isAccessible && !node.isCompleted;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: node.isCompleted
              ? (isDark ? Colors.grey.shade800 : Colors.grey.shade300)
              : isAccessible
                  ? color.withValues(alpha: isDark ? 0.3 : 0.15)
                  : (isDark ? Colors.grey.shade900 : Colors.grey.shade200),
          shape: BoxShape.circle,
          border: Border.all(
            color: isAccessible ? color : Colors.grey.withValues(alpha: 0.4),
            width: isAccessible ? 3 : 1.5,
          ),
          boxShadow: isAccessible
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Icon(
          _icon,
          size: 24,
          color: node.isCompleted
              ? Colors.grey.shade500
              : isAccessible
                  ? color
                  : Colors.grey.shade500,
        ),
      ),
    );
  }
}

// ============================================================================
// Connection line painter
// ============================================================================

class _ConnectionPainter extends CustomPainter {
  final List<DungeonNode> fromNodes;
  final List<DungeonNode> toNodes;
  final List<DungeonNode> allNodes;
  final bool isDark;

  _ConnectionPainter({
    required this.fromNodes,
    required this.toNodes,
    required this.allNodes,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.white24 : Colors.grey.shade400)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    if (fromNodes.isEmpty || toNodes.isEmpty) return;

    // Approximate positions based on column distribution
    final fromCount = fromNodes.length;
    final toCount = toNodes.length;

    for (final fromNode in fromNodes) {
      for (final connId in fromNode.connectedNodeIds) {
        final toIndex = toNodes.indexWhere((n) => n.id == connId);
        if (toIndex < 0) continue;

        final fromIdx = fromNodes.indexOf(fromNode);
        final fromX = (fromIdx + 0.5) / fromCount * size.width;
        final toX = (toIndex + 0.5) / toCount * size.width;

        final path = Path()
          ..moveTo(fromX, size.height)
          ..cubicTo(fromX, size.height * 0.5, toX, size.height * 0.5, toX, 0);

        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================================
// Player stats bar
// ============================================================================

class _PlayerStatsBar extends StatelessWidget {
  final DungeonState dungeonState;
  final bool isDark;
  final Color accent;

  const _PlayerStatsBar({
    required this.dungeonState,
    required this.isDark,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final hpRatio = dungeonState.playerMaxHp > 0
        ? (dungeonState.playerHp / dungeonState.playerMaxHp).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1D1E33) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white12 : Colors.grey.shade300,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // HP
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.favorite, size: 14, color: Colors.red),
                      const SizedBox(width: 4),
                      Text(
                        '${dungeonState.playerHp} / ${dungeonState.playerMaxHp}',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: hpRatio,
                      minHeight: 8,
                      backgroundColor:
                          isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation(
                        hpRatio > 0.5
                            ? Colors.green
                            : hpRatio > 0.25
                                ? Colors.orange
                                : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Gold
            _StatBadge(
              icon: Icons.monetization_on,
              iconColor: Colors.amber,
              value: '${dungeonState.dungeonGold}',
              isDark: isDark,
            ),
            const SizedBox(width: 12),

            // Deck count
            _StatBadge(
              icon: Icons.style,
              iconColor: accent,
              value: '${dungeonState.currentDeck.length}',
              isDark: isDark,
            ),
            const SizedBox(width: 12),

            // Relic count
            _StatBadge(
              icon: Icons.diamond,
              iconColor: Colors.purple,
              value: '${dungeonState.currentRelics.length}',
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final bool isDark;

  const _StatBadge({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 3),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }
}
