import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/state/combat_state.dart';
import 'package:life_quest_final_v2/data/monster_database.dart';

class DungeonFloorSelector extends StatelessWidget {
  final CharacterState charState;
  final CombatState combatState;
  final bool isDark;
  final VoidCallback onCombatStarted;

  const DungeonFloorSelector({
    super.key,
    required this.charState,
    required this.combatState,
    required this.isDark,
    required this.onCombatStarted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1D1E33) : Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isDark ? const Color(0xFF00FFFF) : Colors.orange.shade300,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Text(
                '🗝️ 던전 탐험',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      isDark ? const Color(0xFF00FFFF) : Colors.orange.shade900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '구역을 돌파하고 강력한 몬스터에 도전하세요!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
        // Dungeon Chapter List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: MonsterDatabase.maxChapters,
            itemBuilder: (context, index) {
              final chapter = index + 1;
              final currentUnlocked = charState.currentDungeonChapter;
              final isUnlocked = chapter <= currentUnlocked;
              final isCleared = chapter < currentUnlocked;

              final chapterName = MonsterDatabase.getChapterName(chapter);
              Color borderColor =
                  isDark ? Colors.white24 : Colors.grey.shade300;
              Color bgColor = isDark ? const Color(0xFF1D1E33) : Colors.white;

              if (isUnlocked && !isCleared) {
                borderColor =
                    isDark ? const Color(0xFF00FFFF) : Colors.orange.shade400;
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: borderColor, width: 2),
                  boxShadow: isUnlocked
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            offset: const Offset(0, 0),
                            spreadRadius: 2,
                            blurRadius: 4,
                          )
                        ],
                ),
                child: Opacity(
                  opacity: isUnlocked ? 1.0 : 0.5,
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isUnlocked
                              ? (isDark ? Colors.black54 : Colors.grey.shade100)
                              : Colors.black87,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: borderColor.withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            isUnlocked ? '🚪' : '🔒',
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '구역 $chapter: $chapterName',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isCleared
                                  ? '진행도: 모든 층 클리어'
                                  : (isUnlocked
                                      ? '진행도: ${charState.highestDungeonFloor}층 탐험 중'
                                      : '진행도: 미해금'),
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 13,
                                color: isCleared
                                    ? Colors.green
                                    : (isUnlocked
                                        ? (isDark
                                            ? const Color(0xFF00FFFF)
                                            : Colors.orange.shade800)
                                        : Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isUnlocked)
                        ElevatedButton(
                          onPressed: () {
                            if (charState.character.actionPoints <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('⚡ 행동력(AP)이 부족합니다!',
                                      style:
                                          TextStyle(fontFamily: 'monospace')),
                                  backgroundColor: Colors.red.shade800,
                                ),
                              );
                              return;
                            }

                            int targetFloor =
                                isCleared ? 5 : charState.highestDungeonFloor;
                            if (targetFloor > 5) targetFloor = 5;

                            final monster =
                                MonsterDatabase.getMonsterForDungeon(
                                    chapter, targetFloor);
                            combatState.startCombat(
                                monster, charState.character,
                                chapter: chapter, floor: targetFloor);

                            onCombatStarted();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark
                                ? const Color(0xFF00FFFF).withValues(alpha: 0.2)
                                : Colors.orange.shade100,
                            foregroundColor: isDark
                                ? const Color(0xFF00FFFF)
                                : Colors.orange.shade900,
                            side: BorderSide(
                                color: isDark
                                    ? const Color(0xFF00FFFF)
                                    : Colors.orange.shade400,
                                width: 2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          child: const Text('입장',
                              style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
