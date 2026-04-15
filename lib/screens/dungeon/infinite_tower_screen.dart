import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/state/dungeon_state.dart';
import 'package:life_quest_final_v2/screens/dungeon/dungeon_map_screen.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';

/// Infinite Tower mode — an endless roguelike challenge that scales
/// difficulty every 5 floors and records the player's highest floor.
class InfiniteTowerScreen extends StatefulWidget {
  const InfiniteTowerScreen({super.key});

  @override
  State<InfiniteTowerScreen> createState() => _InfiniteTowerScreenState();
}

class _InfiniteTowerScreenState extends State<InfiniteTowerScreen> {
  /// The floor the player is about to attempt.
  late int _targetFloor;

  @override
  void initState() {
    super.initState();
    final charState = context.read<CharacterState>();
    _targetFloor = charState.infiniteTowerFloor;
  }

  /// Zone cycles through 1-5 based on the floor number.
  int _zoneForFloor(int floor) => ((floor - 1) ~/ 5) % 5 + 1;

  /// Each floor adds 5% extra HP/ATK scaling.
  double _towerMultForFloor(int floor) => 1.0 + ((floor - 1) * 0.05);

  void _startTowerRun(BuildContext context) {
    final charState = context.read<CharacterState>();
    final character = charState.character;
    final playerMaxHp = 80 + (character.health * 2).toInt();
    final zone = _zoneForFloor(_targetFloor);
    final mult = _towerMultForFloor(_targetFloor);

    context.read<DungeonState>().startRun(
          zone: zone,
          startingDeck: charState.starterDeck,
          playerMaxHp: playerMaxHp,
          towerStatMult: mult,
        );

    // Record attempted floor immediately so the result screen can compare.
    charState.updateInfiniteTowerFloor(_targetFloor);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DungeonMapScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final charState = context.watch<CharacterState>();
    final bestFloor = charState.infiniteTowerFloor;
    final zone = _zoneForFloor(_targetFloor);
    final mult = _towerMultForFloor(_targetFloor);
    final scalingPct = ((_towerMultForFloor(_targetFloor) - 1.0) * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.trending_up,
                color: isDark ? Colors.amber : Colors.deepOrange, size: 24),
            const SizedBox(width: 8),
            Text(
              l10n.infiniteTowerTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.amber : Colors.deepOrange,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Best floor banner
            _BestFloorBanner(bestFloor: bestFloor, isDark: isDark),
            const SizedBox(height: 20),

            // Floor selector
            _SectionTitle(
                title: l10n.infiniteTowerSelectFloor, icon: Icons.layers, isDark: isDark),
            const SizedBox(height: 12),
            _FloorSelector(
              targetFloor: _targetFloor,
              onDecrement: _targetFloor > 1
                  ? () => setState(() => _targetFloor--)
                  : null,
              onIncrement: () => setState(() => _targetFloor++),
              isDark: isDark,
            ),
            const SizedBox(height: 20),

            // Current floor info card
            _SectionTitle(
                title: l10n.infiniteTowerFloorInfo, icon: Icons.info_outline, isDark: isDark),
            const SizedBox(height: 12),
            _FloorInfoCard(
              floor: _targetFloor,
              zone: zone,
              mult: mult,
              scalingPct: scalingPct,
              isDark: isDark,
            ),
            const SizedBox(height: 32),

            // Enter button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _startTowerRun(context),
                icon: const Icon(Icons.arrow_upward),
                label: Text(
                  l10n.infiniteTowerChallengeFloor(_targetFloor),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDark ? Colors.amber.shade700 : Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 4,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Floor progression guide
            _SectionTitle(
                title: l10n.infiniteTowerFloorComposition, icon: Icons.map_outlined, isDark: isDark),
            const SizedBox(height: 8),
            _FloorGuide(isDark: isDark),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────

class _BestFloorBanner extends StatelessWidget {
  final int bestFloor;
  final bool isDark;

  const _BestFloorBanner({required this.bestFloor, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF2D1B00), const Color(0xFF1D1E33)]
              : [Colors.deepOrange.shade50, Colors.amber.shade50],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.amber.withValues(alpha: 0.4)
              : Colors.deepOrange.shade200,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.amber.withValues(alpha: 0.2),
              border: Border.all(
                  color: Colors.amber.withValues(alpha: 0.5), width: 2),
            ),
            child: const Icon(Icons.emoji_events, color: Colors.amber, size: 28),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.infiniteTowerBestFloorLabel,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
              Text(
                l10n.infiniteTowerFloorDisplay(bestFloor),
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.amber : Colors.deepOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isDark;

  const _SectionTitle(
      {required this.title, required this.icon, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,
            size: 18,
            color: isDark ? Colors.amber : Colors.deepOrange.shade700),
        const SizedBox(width: 6),
        Text(
          title,
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

class _FloorSelector extends StatelessWidget {
  final int targetFloor;
  final VoidCallback? onDecrement;
  final VoidCallback onIncrement;
  final bool isDark;

  const _FloorSelector({
    required this.targetFloor,
    required this.onDecrement,
    required this.onIncrement,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onDecrement,
            icon: const Icon(Icons.remove_circle_outline),
            color: onDecrement == null
                ? Colors.grey
                : (isDark ? Colors.amber : Colors.deepOrange),
            iconSize: 32,
          ),
          Text(
            l10n.infiniteTowerFloorDisplay(targetFloor),
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.amber : Colors.deepOrange,
            ),
          ),
          IconButton(
            onPressed: onIncrement,
            icon: const Icon(Icons.add_circle_outline),
            color: isDark ? Colors.amber : Colors.deepOrange,
            iconSize: 32,
          ),
        ],
      ),
    );
  }
}

class _FloorInfoCard extends StatelessWidget {
  final int floor;
  final int zone;
  final double mult;
  final int scalingPct;
  final bool isDark;

  const _FloorInfoCard({
    required this.floor,
    required this.zone,
    required this.mult,
    required this.scalingPct,
    required this.isDark,
  });

  static const _zoneColors = [
    Colors.green,
    Colors.teal,
    Colors.blueGrey,
    Colors.deepOrange,
    Colors.deepPurple,
  ];

  String _getZoneName(BuildContext context, int z) {
    final l10n = AppLocalizations.of(context)!;
    switch (z % 5) {
      case 1: return l10n.zone1Name;
      case 2: return l10n.zone2Name;
      case 3: return l10n.zone3Name;
      case 4: return l10n.zone4Name;
      case 0: return l10n.zone5Name;
      default: return l10n.zone1Name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final zoneColor = _zoneColors[(zone - 1).clamp(0, 4)];
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
        children: [
          _infoRow(
            Icons.terrain,
            l10n.infiniteTowerFloorInfo,
            'Zone $zone: ${_getZoneName(context, zone)}',
            zoneColor,
            isDark,
          ),
          const SizedBox(height: 10),
          _infoRow(
            Icons.favorite_border,
            l10n.infiniteTowerEnemyHp,
            scalingPct > 0 ? '+$scalingPct%' : l10n.infiniteTowerDefault,
            Colors.red,
            isDark,
          ),
          const SizedBox(height: 10),
          _infoRow(
            Icons.bolt,
            l10n.infiniteTowerEnemyAttack,
            scalingPct > 0 ? '+$scalingPct%' : l10n.infiniteTowerDefault,
            Colors.orange,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
      IconData icon, String label, String value, Color color, bool isDark) {
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
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _FloorGuide extends StatelessWidget {
  final bool isDark;

  const _FloorGuide({required this.isDark});

  String _getZoneName(BuildContext context, int zone) {
    final l10n = AppLocalizations.of(context)!;
    switch (zone % 5) {
      case 1: return l10n.zone1Name;
      case 2: return l10n.zone2Name;
      case 3: return l10n.zone3Name;
      case 4: return l10n.zone4Name;
      case 0: return l10n.zone5Name;
      default: return l10n.zone1Name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final entries = [
      (l10n.infiniteTowerFloor1To5, 'Zone 1: ${_getZoneName(context, 1)}', Colors.green),
      (l10n.infiniteTowerFloor6To10, 'Zone 2: ${_getZoneName(context, 2)}', Colors.teal),
      (l10n.infiniteTowerFloor11To15, 'Zone 3: ${_getZoneName(context, 3)}', Colors.blueGrey),
      (l10n.infiniteTowerFloor16To20, 'Zone 4: ${_getZoneName(context, 4)}', Colors.deepOrange),
      (l10n.infiniteTowerFloor21To25, 'Zone 5: ${_getZoneName(context, 5)}', Colors.deepPurple),
      (l10n.infiniteTowerFloor26Plus, l10n.infiniteTowerRepeatZones, Colors.amber),
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        children: entries.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration:
                      BoxDecoration(color: e.$3, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 56,
                  child: Text(
                    e.$1,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: e.$3,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    e.$2,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
