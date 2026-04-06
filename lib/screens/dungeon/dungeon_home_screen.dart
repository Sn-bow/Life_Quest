import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/state/dungeon_state.dart';
import 'package:life_quest_final_v2/screens/dungeon/dungeon_map_screen.dart';
import 'package:life_quest_final_v2/screens/dungeon/card_collection_screen.dart';
import 'package:life_quest_final_v2/screens/dungeon/infinite_tower_screen.dart';

class DungeonHomeScreen extends StatefulWidget {
  const DungeonHomeScreen({super.key});

  @override
  State<DungeonHomeScreen> createState() => _DungeonHomeScreenState();
}

class _DungeonHomeScreenState extends State<DungeonHomeScreen> {
  int _ascensionLevel = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final charState = context.watch<CharacterState>();
    final character = charState.character;
    final hasCompletedZone5 = charState.hasCompletedZone5;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.style,
                color: isDark ? const Color(0xFF00FFFF) : Colors.deepPurple,
                size: 24),
            const SizedBox(width: 8),
            Text(
              '소울 덱',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xFF00FFFF) : Colors.deepPurple,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.collections_bookmark,
              color: isDark ? const Color(0xFF00FFFF) : Colors.deepPurple,
            ),
            tooltip: '카드 컬렉션',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CardCollectionScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Season banner ──
            _SeasonBanner(isDark: isDark),
            const SizedBox(height: 16),

            // ── Player info card ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1D1E33), const Color(0xFF0A0E21)]
                      : [Colors.deepPurple.shade50, Colors.white],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF00FFFF).withValues(alpha: 0.3)
                      : Colors.deepPurple.shade200,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${character.name} Lv.${character.level}',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _statChip('STR ${character.strength}', Colors.red, isDark),
                      const SizedBox(width: 8),
                      _statChip('WIS ${character.wisdom}', Colors.purple, isDark),
                      const SizedBox(width: 8),
                      _statChip('HP ${character.health}', Colors.blue, isDark),
                      const SizedBox(width: 8),
                      _statChip('CHA ${character.charisma}', Colors.amber, isDark),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Ascension section (only if Zone 5 cleared) ──
            if (hasCompletedZone5) ...[
              _AscensionSection(
                ascensionLevel: _ascensionLevel,
                onChanged: (level) => setState(() => _ascensionLevel = level),
                isDark: isDark,
              ),
              const SizedBox(height: 24),
            ],

            // ── Zone selection ──
            Text(
              '던전 선택',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            _zoneCard(
              context: context,
              zone: 1,
              name: '푸른 초원',
              description: '초보 모험가를 위한 첫 번째 던전',
              icon: Icons.grass,
              color: Colors.green,
              isLocked: false,
              requiredLevel: 1,
              isDark: isDark,
              isCompleted: charState.completedZones.contains(1),
            ),
            const SizedBox(height: 8),

            _zoneCard(
              context: context,
              zone: 2,
              name: '어둠의 숲',
              description: '독과 디버프를 사용하는 적들이 도사리는 곳',
              icon: Icons.forest,
              color: Colors.teal,
              isLocked: character.level < 5,
              requiredLevel: 5,
              isDark: isDark,
              isCompleted: charState.completedZones.contains(2),
            ),
            const SizedBox(height: 8),

            _zoneCard(
              context: context,
              zone: 3,
              name: '폐허의 성',
              description: '방어 특화 적과 다중 전투가 기다린다',
              icon: Icons.castle,
              color: Colors.blueGrey,
              isLocked: character.level < 10,
              requiredLevel: 10,
              isDark: isDark,
              isCompleted: charState.completedZones.contains(3),
            ),
            const SizedBox(height: 8),

            _zoneCard(
              context: context,
              zone: 4,
              name: '용암 동굴',
              description: '화상과 고데미지의 지옥',
              icon: Icons.whatshot,
              color: Colors.deepOrange,
              isLocked: character.level < 20,
              requiredLevel: 20,
              isDark: isDark,
              isCompleted: charState.completedZones.contains(4),
            ),
            const SizedBox(height: 8),

            _zoneCard(
              context: context,
              zone: 5,
              name: '심연의 차원',
              description: '의도를 숨기는 적들, 저주가 내리는 최종 던전',
              icon: Icons.blur_on,
              color: Colors.deepPurple,
              isLocked: character.level < 30,
              requiredLevel: 30,
              isDark: isDark,
              isCompleted: charState.completedZones.contains(5),
            ),

            // ── Infinite Tower (only if Zone 5 cleared) ──
            if (hasCompletedZone5) ...[
              const SizedBox(height: 16),
              _InfiniteTowerButton(isDark: isDark),
            ],

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _statChip(String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isDark ? color : color.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _zoneCard({
    required BuildContext context,
    required int zone,
    required String name,
    required String description,
    required IconData icon,
    required Color color,
    required bool isLocked,
    required int requiredLevel,
    required bool isDark,
    bool isCompleted = false,
  }) {
    return GestureDetector(
      onTap: isLocked
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('레벨 $requiredLevel 이상 필요합니다',
                      style: const TextStyle(fontFamily: 'monospace')),
                  backgroundColor: Colors.red.shade700,
                ),
              );
            }
          : () => _startBattle(context, zone),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isLocked
              ? (isDark ? Colors.grey.shade900 : Colors.grey.shade200)
              : (isDark
                  ? color.withValues(alpha: 0.15)
                  : color.withValues(alpha: 0.08)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isLocked
                ? Colors.grey.withValues(alpha: 0.3)
                : color.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isLocked
                    ? Colors.grey.withValues(alpha: 0.2)
                    : color.withValues(alpha: isDark ? 0.3 : 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isLocked ? Icons.lock : icon,
                color: isLocked ? Colors.grey : color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Zone $zone: $name',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isLocked
                              ? Colors.grey
                              : (isDark ? Colors.white : Colors.black87),
                        ),
                      ),
                      if (isLocked) ...[
                        const SizedBox(width: 8),
                        Text(
                          'Lv.$requiredLevel',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                      if (!isLocked && isCompleted) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.check_circle,
                            size: 14, color: Colors.green),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: isLocked
                          ? Colors.grey.shade500
                          : (isDark ? Colors.white60 : Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
            if (!isLocked)
              Icon(
                Icons.chevron_right,
                color: isDark ? color : color.withValues(alpha: 0.7),
              ),
          ],
        ),
      ),
    );
  }

  void _startBattle(BuildContext context, int zone) {
    final charState = context.read<CharacterState>();
    final character = charState.character;

    // Calculate player HP based on health stat
    final playerMaxHp = 80 + (character.health * 2).toInt();

    context.read<DungeonState>().startRun(
          zone: zone,
          startingDeck: charState.starterDeck,
          playerMaxHp: playerMaxHp,
          ascension: _ascensionLevel,
        );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DungeonMapScreen(),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Season Banner
// ─────────────────────────────────────────────

class _SeasonBanner extends StatelessWidget {
  final bool isDark;

  const _SeasonBanner({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE65100), Color(0xFF6A1B9A)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Text('🔥', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text(
                '시즌 1: 영혼의 각성',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          // TODO: Replace hardcoded D-25 with real countdown from season end date
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'D-25',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Ascension Section
// ─────────────────────────────────────────────

class _AscensionSection extends StatelessWidget {
  final int ascensionLevel;
  final ValueChanged<int> onChanged;
  final bool isDark;

  static const List<String> _modifiers = [
    'Lv 1: 적 HP +10%',
    'Lv 2: 적 공격력 +10%',
    'Lv 3: 시작 골드 -30',
    'Lv 4: 저주 카드 1장 추가',
    'Lv 5: 엘리트 처치 후 카드 선택 없음',
    'Lv 6: 상점 가격 +25%',
    'Lv 7: 시작 HP -10%',
    'Lv 8: 보스 HP +25%',
    'Lv 9: 이벤트 불이익 선택지 강화',
    'Lv 10: 모든 적 HP +20%',
  ];

  const _AscensionSection({
    required this.ascensionLevel,
    required this.onChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1A0033), const Color(0xFF0A0E21)]
              : [Colors.purple.shade50, Colors.white],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.purple.withValues(alpha: 0.5)
              : Colors.purple.shade200,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.whatshot, color: Colors.deepPurple, size: 20),
              const SizedBox(width: 8),
              Text(
                '어센션 모드',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: ascensionLevel > 0
                      ? Colors.deepPurple.withValues(alpha: 0.3)
                      : Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  ascensionLevel > 0 ? 'A$ascensionLevel' : '미활성',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: ascensionLevel > 0
                        ? Colors.purple.shade300
                        : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Slider
          Row(
            children: [
              Text(
                '0',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
              Expanded(
                child: Slider(
                  value: ascensionLevel.toDouble(),
                  min: 0,
                  max: 10,
                  divisions: 10,
                  activeColor: Colors.deepPurple,
                  inactiveColor: Colors.grey.withValues(alpha: 0.3),
                  label: 'A$ascensionLevel',
                  onChanged: (v) => onChanged(v.round()),
                ),
              ),
              Text(
                '10',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
            ],
          ),

          // Active modifiers list
          if (ascensionLevel > 0) ...[
            const SizedBox(height: 8),
            Text(
              '적용 중인 페널티:',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
            const SizedBox(height: 6),
            ...List.generate(ascensionLevel, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        size: 13, color: Colors.orange.shade400),
                    const SizedBox(width: 6),
                    Text(
                      _modifiers[i],
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: isDark ? Colors.orange.shade200 : Colors.orange.shade900,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ] else ...[
            Text(
              '슬라이더를 올려 난이도를 높이세요',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Infinite Tower Button
// ─────────────────────────────────────────────

class _InfiniteTowerButton extends StatelessWidget {
  final bool isDark;

  const _InfiniteTowerButton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final charState = context.watch<CharacterState>();
    final bestFloor = charState.infiniteTowerFloor;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const InfiniteTowerScreen(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF1A1A2E), const Color(0xFF2D1B00)]
                : [Colors.amber.shade50, Colors.deepOrange.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? Colors.amber.withValues(alpha: 0.5)
                : Colors.deepOrange.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.trending_up,
                  color: Colors.amber, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '무한의 탑',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '끝없는 도전 · 최고 기록: $bestFloor층',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.amber),
          ],
        ),
      ),
    );
  }
}
