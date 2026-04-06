import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/state/dungeon_state.dart';
import 'package:life_quest_final_v2/screens/dungeon/dungeon_map_screen.dart';

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
              '무한의 탑',
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
                title: '도전할 층 선택', icon: Icons.layers, isDark: isDark),
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
                title: '층 정보', icon: Icons.info_outline, isDark: isDark),
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
                  '$_targetFloor층 도전하기',
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
                title: '층 구성', icon: Icons.map_outlined, isDark: isDark),
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
                '최고 기록',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
              Text(
                '$bestFloor층',
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
            '$targetFloor층',
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

  static const _zoneNames = [
    '푸른 초원',
    '어둠의 숲',
    '폐허의 성',
    '용암 동굴',
    '심연의 차원',
  ];

  static const _zoneColors = [
    Colors.green,
    Colors.teal,
    Colors.blueGrey,
    Colors.deepOrange,
    Colors.deepPurple,
  ];

  @override
  Widget build(BuildContext context) {
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
            '지역',
            'Zone $zone: ${_zoneNames[(zone - 1).clamp(0, 4)]}',
            zoneColor,
            isDark,
          ),
          const SizedBox(height: 10),
          _infoRow(
            Icons.favorite_border,
            '적 HP',
            scalingPct > 0 ? '+$scalingPct%' : '기본',
            Colors.red,
            isDark,
          ),
          const SizedBox(height: 10),
          _infoRow(
            Icons.bolt,
            '적 공격력',
            scalingPct > 0 ? '+$scalingPct%' : '기본',
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

  @override
  Widget build(BuildContext context) {
    final entries = [
      ('1-5층', 'Zone 1: 푸른 초원', Colors.green),
      ('6-10층', 'Zone 2: 어둠의 숲', Colors.teal),
      ('11-15층', 'Zone 3: 폐허의 성', Colors.blueGrey),
      ('16-20층', 'Zone 4: 용암 동굴', Colors.deepOrange),
      ('21-25층', 'Zone 5: 심연의 차원', Colors.deepPurple),
      ('26층+', '이후 Zone 1부터 반복 (난이도 계속 상승)', Colors.amber),
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
