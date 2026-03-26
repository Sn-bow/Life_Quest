import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/state/combat_state.dart';

import 'package:life_quest_final_v2/models/skill.dart';
import 'package:life_quest_final_v2/services/ad_service.dart';
import 'package:life_quest_final_v2/widgets/combat/dungeon_floor_selector.dart';
import 'package:life_quest_final_v2/widgets/combat/combat_arena_view.dart';

class HuntScreen extends StatefulWidget {
  const HuntScreen({super.key});

  @override
  State<HuntScreen> createState() => _HuntScreenState();
}

class _HuntScreenState extends State<HuntScreen> with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late AnimationController _flashController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _flashAnimation;
  bool _showSkills = false;
  CombatStatus? _lastCombatStatus;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 8)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);

    _flashController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _flashAnimation = Tween<double>(begin: 0, end: 1).animate(_flashController);
  }

  @override
  void dispose() {
    if (mounted) {
      context.read<CharacterState>().setCombatActive(false);
    }
    _shakeController.dispose();
    _flashController.dispose();
    super.dispose();
  }

  void _triggerHitEffect() {
    _shakeController.forward().then((_) => _shakeController.reverse());
    _flashController.forward().then((_) => _flashController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    final charState = context.watch<CharacterState>();
    final combatState = context.watch<CombatState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_lastCombatStatus != combatState.status) {
      _lastCombatStatus = combatState.status;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context
            .read<CharacterState>()
            .setCombatActive(combatState.status == CombatStatus.fighting);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.sports_martial_arts,
                color: Colors.redAccent, size: 24),
            const SizedBox(width: 8),
            Text(
              '사냥터',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    isDark ? const Color(0xFF00FFFF) : Colors.orange.shade900,
              ),
            ),
          ],
        ),
        actions: [
          // AP indicator
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1D1E33) : Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color:
                    isDark ? const Color(0xFF00FFFF) : Colors.orange.shade300,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bolt, size: 16, color: Colors.blue),
                const SizedBox(width: 4),
                Text(
                  '${charState.character.actionPoints}/${charState.character.maxActionPoints}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isDark
                        ? const Color(0xFF00FFFF)
                        : Colors.orange.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: combatState.status == CombatStatus.idle
          ? DungeonFloorSelector(
              charState: charState,
              combatState: combatState,
              isDark: isDark,
              onCombatStarted: () => setState(() => _showSkills = false),
            )
          : _buildCombatUI(charState, combatState, isDark),
    );
  }

  Widget _buildCombatUI(
      CharacterState charState, CombatState combatState, bool isDark) {
    return Column(
      children: [
        const SizedBox(height: 8),
        // AP display
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '⚡ AP: ${charState.character.actionPoints}',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: charState.character.actionPoints > 0
                      ? (isDark
                          ? const Color(0xFF00FFFF)
                          : Colors.orange.shade800)
                      : Colors.red,
                ),
              ),
              Text(
                '💥 콤보: ${combatState.comboCount}',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFFF8A1D1) : Colors.deepOrange,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Monster display area
        Expanded(
          flex: 4,
          child: CombatArenaView(
            combatState: combatState,
            charState: charState,
            isDark: isDark,
            shakeAnimation: _shakeAnimation,
            shakeController: _shakeController,
            flashAnimation: _flashAnimation,
          ),
        ),

        // Player HP bar
        _buildPlayerHpBar(charState, isDark),

        // Combat log (Retro style)
        _buildCombatLog(combatState, isDark),

        // Action buttons
        _buildActionButtons(charState, combatState, isDark),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPlayerHpBar(CharacterState charState, bool isDark) {
    final character = charState.character;
    double hpPercent = character.characterHp / character.characterMaxHp;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '나의 HP',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            height: 20,
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
                      gradient: LinearGradient(
                        colors: hpPercent > 0.5
                            ? [Colors.green.shade400, Colors.green.shade700]
                            : (hpPercent > 0.25
                                ? [
                                    Colors.orange.shade400,
                                    Colors.orange.shade700
                                  ]
                                : [Colors.red.shade400, Colors.red.shade700]),
                      ),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '${character.characterHp.toInt()} / ${character.characterMaxHp.toInt()}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCombatLog(CombatState combatState, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 80),
      decoration: BoxDecoration(
        color: isDark ? Colors.black : Colors.black87,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isDark ? Colors.white54 : Colors.grey.shade600,
          width: 3,
        ),
      ),
      child: Text(
        combatState.combatLog,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          height: 1.5,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildActionButtons(
      CharacterState charState, CombatState combatState, bool isDark) {
    if (combatState.status == CombatStatus.victory) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: _secondaryButton(
                '보상 수령 & 돌아가기',
                Icons.emoji_events,
                isDark ? const Color(0xFF00FFFF) : Colors.orange,
                () {
                  final result = combatState.lastResult;
                  if (result != null) {
                    charState.addCombatReward(result.xpGained, result.loot);
                  }
                  charState.forceSave(); // Save dungeon progress and rewards
                  combatState.endCombat();
                },
                isDark,
              ),
            ),
          ],
        ),
      );
    } else if (combatState.status == CombatStatus.defeat) {
      final adService = AdService();
      final remainingRevives = adService.getRemainingViews('combat_revive');

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            if (remainingRevives > 0) ...[
              _secondaryButton(
                '광고 보고 부활하기 (오늘 $remainingRevives회 남음)',
                Icons.favorite,
                Colors.pinkAccent,
                () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final success =
                      await adService.showRewardedAd('combat_revive');
                  if (success) {
                    combatState.revive(charState.character);
                    await charState.forceSave();
                    if (context.mounted) {
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text('❤️ 광고 보상으로 즉시 부활했습니다!'),
                        ),
                      );
                    }
                  } else if (context.mounted) {
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('광고를 불러올 수 없습니다. 잠시 후 다시 시도해주세요.'),
                      ),
                    );
                  }
                },
                isDark,
              ),
              const SizedBox(height: 8),
            ],
            _secondaryButton(
              '포기하고 돌아가기',
              Icons.exit_to_app,
              Colors.red,
              () {
                charState.forceSave(); // Save HP damage
                combatState.endCombat();
              },
              isDark,
            ),
          ],
        ),
      );
    } else {
      // 2x2 Combat Actions Menu
      bool hasAp = charState.character.actionPoints > 0;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            if (_showSkills) ...[
              // Skill Selection Menu
              _buildSkillMenu(charState, combatState, isDark),
            ] else ...[
              // 2x2 Grid
              Row(
                children: [
                  Expanded(
                    child: _actionButton('공격 (1 AP)', Icons.sports_martial_arts,
                        Colors.redAccent, () {
                      if (!hasAp) return _showApWarning();
                      int cost = combatState.playerAttack(charState.character);
                      _applyApCost(charState, cost);
                      _triggerHitEffect();
                    }, isDark),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _actionButton(
                        '방어 (1 AP)', Icons.shield, Colors.blueAccent, () {
                      if (!hasAp) return _showApWarning();
                      int cost = combatState.playerDefend(charState.character);
                      _applyApCost(charState, cost);
                    }, isDark),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _actionButton(
                        '스킬 (자유)', Icons.auto_awesome, Colors.green, () {
                      setState(() {
                        _showSkills = true;
                      });
                    }, isDark),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _actionButton(
                        '도망 (1 AP)', Icons.directions_run, Colors.grey, () {
                      if (!hasAp) return _showApWarning();
                      int cost = combatState.playerFlee(charState.character);
                      _applyApCost(charState, cost);
                    }, isDark),
                  ),
                ],
              ),
            ]
          ],
        ),
      );
    }
  }

  void _showApWarning() {
    final adService = AdService();
    final remaining = adService.getRemainingViews('ap_recovery');

    if (remaining > 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('AP 부족'),
          content: Text(
              'AP가 부족합니다. 광고를 보고 AP를 2 회복하시겠습니까?\n(오늘 남은 횟수: $remaining회)'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                final success = await adService.showRewardedAd('ap_recovery');
                if (!context.mounted) return;

                if (success) {
                  final charState =
                      Provider.of<CharacterState>(context, listen: false);
                  charState.character.actionPoints += 2;
                  charState.forceSave();
                  charState.refreshState();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('⚡ AP가 2 회복되었습니다!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('광고를 불러올 수 없습니다. 잠시 후 다시 시도해주세요.'),
                    ),
                  );
                }
              },
              child: const Text('광고 보고 회복'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('⚡ AP 부족! 퀘스트를 완료하세요. (오늘 광고 회복 모두 소진)',
              style: TextStyle(fontFamily: 'monospace')),
          backgroundColor: Colors.red.shade800,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _applyApCost(CharacterState charState, int cost) {
    if (cost > 0) {
      charState.character.actionPoints -= cost;
      charState.scheduleSave();
      charState.refreshState();
    }
  }

  Widget _buildSkillMenu(
      CharacterState charState, CombatState combatState, bool isDark) {
    final combatSkills = charState.allSkills
        .where((s) =>
            charState.learnedSkillIds.contains(s.id) &&
            (s.effectType == SkillEffectType.combatDamage ||
                s.effectType == SkillEffectType.combatHeal))
        .toList();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('사용할 스킬을 선택하세요:',
                style: TextStyle(
                    fontFamily: 'monospace',
                    color: isDark ? Colors.white70 : Colors.black87)),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() => _showSkills = false),
            )
          ],
        ),
        if (combatSkills.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('배운 전투 스킬이 없습니다.',
                style: TextStyle(fontFamily: 'monospace')),
          ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: combatSkills.map((skill) {
            final ready = combatState.isSkillReady(skill.id);
            final cd = combatState.getSkillCooldown(skill.id);
            final isHeal = skill.effectType == SkillEffectType.combatHeal;
            final color = isHeal ? Colors.green : Colors.deepOrange;

            return GestureDetector(
              onTap: ready && charState.character.actionPoints > 0
                  ? () {
                      final used =
                          combatState.useSkill(skill, charState.character);
                      if (used) {
                        charState.character.actionPoints -= 1;
                        charState.scheduleSave();
                        charState.refreshState();
                        setState(
                            () => _showSkills = false); // Hide skills after use
                      }
                    }
                  : () {
                      if (charState.character.actionPoints <= 0) {
                        _showApWarning();
                      }
                    },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: ready
                      ? color.withValues(alpha: isDark ? 0.3 : 0.15)
                      : Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: ready ? color : Colors.grey,
                    width: 2,
                  ),
                ),
                child: Text(
                  ready
                      ? '${isHeal ? "💚" : "🔥"} ${skill.name}'
                      : '${skill.name} ($cd턴)',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: ready
                        ? (isDark ? color : color.withValues(alpha: 0.9))
                        : Colors.grey,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _actionButton(String text, IconData icon, Color color,
      VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDark
              ? color.withValues(alpha: 0.15)
              : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _secondaryButton(String text, IconData icon, Color color,
      VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.2 : 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 16, color: isDark ? color : color.withValues(alpha: 0.9)),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? color : color.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

