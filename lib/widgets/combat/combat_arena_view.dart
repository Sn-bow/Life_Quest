import 'dart:math';
import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/models/item.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/state/combat_state.dart';
import 'package:life_quest_final_v2/widgets/combat/monster_battle_sprite.dart';

class CombatArenaView extends StatelessWidget {
  final CombatState combatState;
  final CharacterState charState;
  final bool isDark;
  final Animation<double> shakeAnimation;
  final AnimationController shakeController;
  final Animation<double> flashAnimation;

  const CombatArenaView({
    super.key,
    required this.combatState,
    required this.charState,
    required this.isDark,
    required this.shakeAnimation,
    required this.shakeController,
    required this.flashAnimation,
  });

  @override
  Widget build(BuildContext context) {
    if (combatState.currentMonster == null) return const SizedBox();
    final monster = combatState.currentMonster!;
    double hpPercent = monster.currentHp / monster.maxHp;

    return AnimatedBuilder(
      animation: shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            shakeAnimation.value * sin(shakeController.value * pi * 4),
            0,
          ),
          child: child,
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Flash effect
          AnimatedBuilder(
            animation: flashAnimation,
            builder: (context, child) {
              return Container(
                color:
                    Colors.white.withValues(alpha: flashAnimation.value * 0.3),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '나의 전투 상태',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.cyanAccent : Colors.indigo,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _HpBar(
                        current: charState.character.characterHp.toDouble(),
                        max: charState.character.characterMaxHp.toDouble(),
                        color: Colors.cyan,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '퀘스트 성장 Lv.${charState.character.level}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${monster.name} Lv.${monster.level}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 180,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(
                            color: isDark ? Colors.white24 : Colors.black26,
                            width: 2,
                          ),
                        ),
                        child: Stack(
                          children: [
                            FractionallySizedBox(
                              widthFactor: hpPercent.clamp(0, 1),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: hpPercent > 0.5
                                      ? Colors.green
                                      : (hpPercent > 0.25
                                          ? Colors.orange
                                          : Colors.red),
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                '${monster.currentHp.toInt()} / ${monster.maxHp.toInt()}',
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(blurRadius: 2, color: Colors.black)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 136,
                        height: 136,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.black26 : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF00FFFF).withValues(alpha: 0.3)
                                : Colors.orange.shade200,
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: MonsterBattleSprite(
                            monster: monster,
                            size: 118,
                            hitProgress: flashAnimation.value,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Victory/Defeat overlay
          if (combatState.status == CombatStatus.victory ||
              combatState.status == CombatStatus.defeat)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      combatState.status == CombatStatus.victory
                          ? '🎉 승리!'
                          : '💀 패배...',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: combatState.status == CombatStatus.victory
                            ? const Color(0xFF00FFFF)
                            : Colors.red,
                      ),
                    ),
                    if (combatState.lastResult != null &&
                        combatState.status == CombatStatus.victory) ...[
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_awesome,
                              size: 16, color: Colors.yellow.shade600),
                          const SizedBox(width: 4),
                          Text('XP +${combatState.lastResult!.xpGained}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.yellow,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(width: 16),
                          const Icon(Icons.monetization_on,
                              size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text('골드 +${combatState.lastResult!.goldGained}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      if (combatState.lastResult!.loot != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.redeem,
                                size: 16,
                                color: getRarityColor(
                                    combatState.lastResult!.loot!.rarity)),
                            const SizedBox(width: 4),
                            Text('${combatState.lastResult!.loot!.name} 획득!',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: getRarityColor(
                                        combatState.lastResult!.loot!.rarity),
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  static Color getRarityColor(ItemRarity rarity) {
    switch (rarity) {
      case ItemRarity.common:
        return Colors.grey;
      case ItemRarity.uncommon:
        return Colors.green;
      case ItemRarity.rare:
        return Colors.blue;
      case ItemRarity.epic:
        return Colors.purple;
      case ItemRarity.legendary:
        return Colors.orange;
    }
  }
}

class _HpBar extends StatelessWidget {
  final double current;
  final double max;
  final Color color;
  final bool isDark;

  const _HpBar({
    required this.current,
    required this.max,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
          color: isDark ? Colors.white24 : Colors.black26,
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: (current / max).clamp(0, 1),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
          Center(
            child: Text(
              '${current.toInt()} / ${max.toInt()}',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 2, color: Colors.black)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
