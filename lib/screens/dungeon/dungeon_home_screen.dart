import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/state/dungeon_state.dart';
import 'package:life_quest_final_v2/screens/dungeon/dungeon_map_screen.dart';
import 'package:life_quest_final_v2/screens/dungeon/card_collection_screen.dart';

class DungeonHomeScreen extends StatelessWidget {
  const DungeonHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final charState = context.watch<CharacterState>();
    final character = charState.character;

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
            // Player info card
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

            // Zone selection
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

            // Zone 1 - Always available
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
            ),
            const SizedBox(height: 8),

            // Zone 2
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
            ),
            const SizedBox(height: 8),

            // Zone 3
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
            ),
            const SizedBox(height: 8),

            // Zone 4
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
            ),
            const SizedBox(height: 8),

            // Zone 5
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
            ),
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
    final playerMaxHp = 80 + (character.health * 2);

    // Start a dungeon run via DungeonState, using the player's custom deck
    context.read<DungeonState>().startRun(
      zone: zone,
      startingDeck: charState.starterDeck,
      playerMaxHp: playerMaxHp,
    );

    // Navigate to dungeon map
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DungeonMapScreen(),
      ),
    );
  }
}
