import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/data/card_database.dart';
import 'package:life_quest_final_v2/models/card_data.dart';
import 'package:life_quest_final_v2/models/status_effect.dart';
import 'package:life_quest_final_v2/state/card_combat_state.dart';
import 'package:life_quest_final_v2/state/dungeon_state.dart';
import 'package:life_quest_final_v2/game/battle_game.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/data/card_localization.dart';

// ============================================================================
// CardBattleScreen
// ============================================================================

class CardBattleScreen extends StatefulWidget {
  final List<CardData> deck;
  final List<EnemyBattleData> enemies;
  final int playerHp;
  final int playerMaxHp;
  final int zone;

  const CardBattleScreen({
    super.key,
    required this.deck,
    required this.enemies,
    this.playerHp = 80,
    this.playerMaxHp = 80,
    this.zone = 1,
  });

  @override
  State<CardBattleScreen> createState() => _CardBattleScreenState();
}

class _CardBattleScreenState extends State<CardBattleScreen>
    with TickerProviderStateMixin {
  late final BattleGame _game;

  // -- Turn transition overlay --
  late final AnimationController _turnOverlayController;
  late final Animation<double> _turnOverlayOpacity;
  String _turnOverlayText = '';
  bool _showTurnOverlay = false;

  // -- Screen shake --
  late final AnimationController _shakeController;
  double _shakeOffsetX = 0;
  double _shakeOffsetY = 0;

  // -- Track previous HP for big-hit detection --
  int _previousPlayerHp = 0;

  // -- Track previous phase for turn transitions --
  CombatPhase _previousPhase = CombatPhase.notStarted;

  // -- Enemy hit flash tracking --
  final Map<int, bool> _enemyFlashing = {};

  @override
  void initState() {
    super.initState();
    _game = BattleGame(
      currentZone: widget.zone,
      monsterId: widget.enemies.isNotEmpty ? widget.enemies.first.monster.id : null,
    );
    _previousPlayerHp = widget.playerHp;

    // Turn overlay animation (fade in -> hold -> fade out over 1s)
    _turnOverlayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _turnOverlayOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(_turnOverlayController);

    _turnOverlayController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _showTurnOverlay = false);
      }
    });

    // Screen shake animation
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeController.addListener(() {
      final progress = _shakeController.value;
      final decay = 1.0 - progress;
      final rng = Random();
      setState(() {
        _shakeOffsetX = (rng.nextDouble() * 2 - 1) * 8 * decay;
        _shakeOffsetY = (rng.nextDouble() * 2 - 1) * 6 * decay;
      });
    });
    _shakeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _shakeOffsetX = 0;
          _shakeOffsetY = 0;
        });
      }
    });

    // Start combat after first frame so Provider is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<CardCombatState>();
      state.startCombat(
        widget.deck,
        widget.enemies,
        maxHp: widget.playerMaxHp,
        hp: widget.playerHp,
        maxEnergy: 3,
      );
    });
  }

  @override
  void dispose() {
    _turnOverlayController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  /// Detect phase transitions and HP changes to trigger animations.
  void _onCombatStateChanged(CardCombatState combat) {
    // -- Turn transition overlay --
    if (combat.phase != _previousPhase) {
      if (combat.phase == CombatPhase.playerTurn &&
          _previousPhase == CombatPhase.enemyTurn) {
        final l10n = AppLocalizations.of(context)!;
        _showTurnTransition(l10n.cardBattleYourTurn);
      } else if (combat.phase == CombatPhase.enemyTurn &&
          _previousPhase == CombatPhase.playerTurn) {
        final l10n = AppLocalizations.of(context)!;
        _showTurnTransition(l10n.cardBattleEnemyTurn);
      }
      _previousPhase = combat.phase;
    }

    // -- Screen shake on big hit (>20% max HP) --
    if (combat.playerHp < _previousPlayerHp) {
      final damage = _previousPlayerHp - combat.playerHp;
      if (damage > combat.playerMaxHp * 0.2) {
        _triggerScreenShake();
      }
    }
    _previousPlayerHp = combat.playerHp;

    // -- Card draw detection for animation (unused: tracked via hand key) --
  }

  void _showTurnTransition(String text) {
    setState(() {
      _turnOverlayText = text;
      _showTurnOverlay = true;
    });
    SoundService().playTurnChange();
    _turnOverlayController.forward(from: 0.0);
  }

  void _triggerScreenShake() {
    _shakeController.forward(from: 0.0);
  }

  void _triggerEnemyFlash(int enemyIndex) {
    setState(() => _enemyFlashing[enemyIndex] = true);
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() => _enemyFlashing[enemyIndex] = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Transform.translate(
        offset: Offset(_shakeOffsetX, _shakeOffsetY),
        child: Stack(
          children: [
            // ---- Zone background image (Flutter layer) ----
            Positioned.fill(
              child: Image.asset(
                _zoneBgAsset(widget.zone),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: _zoneGradient(widget.zone),
                    ),
                  ),
                ),
              ),
            ),
            // ---- Flame game (animations & effects only) ----
            Positioned.fill(
              child: GameWidget(game: _game),
            ),

            // ---- UI overlay ----
            Positioned.fill(
              child: Consumer<CardCombatState>(
                builder: (context, combat, _) {
                  _onCombatStateChanged(combat);
                  return SafeArea(
                    child: Column(
                      children: [
                        // -- Top bar --
                        _TopBar(combat: combat, isDark: isDark),

                        const SizedBox(height: 8),

                        // -- Enemy area --
                        Expanded(
                          flex: 3,
                          child: _EnemyArea(
                            combat: combat,
                            isDark: isDark,
                            enemyFlashing: _enemyFlashing,
                          ),
                        ),

                        // -- Player info --
                        _PlayerInfoBar(combat: combat, isDark: isDark),

                        const SizedBox(height: 4),

                        // -- Card hand --
                        SizedBox(
                          height: 160,
                          child: _CardHand(
                            combat: combat,
                            isDark: isDark,
                            game: _game,
                            onCardPlayed: (cardIndex) {
                              final card = combat.hand[cardIndex];
                              final enemyIdx = combat.selectedEnemyIndex;

                              // Trigger enemy flash for attack cards
                              if (card.category == CardCategory.attack ||
                                  card.category == CardCategory.magic) {
                                _triggerEnemyFlash(enemyIdx);
                                _game.playHitParticle();
                                HapticFeedback.mediumImpact(); // 공격 햅틱
                              }
                              if (card.effects.any(
                                  (e) => e.effectType == CardEffectType.block)) {
                                _game.playBlockParticle();
                                HapticFeedback.lightImpact(); // 방어 햅틱
                              }
                              if (card.effects.any(
                                  (e) => e.effectType == CardEffectType.heal)) {
                                _game.playHealParticle();
                                HapticFeedback.lightImpact(); // 힐 햅틱
                              }

                              // 카드 카테고리별 사운드
                              switch (card.category) {
                                case CardCategory.attack:
                                  SoundService().playCardPlayAttack();
                                case CardCategory.magic:
                                  SoundService().playCardPlayMagic();
                                case CardCategory.defense:
                                  SoundService().playCardPlayDefense();
                                case CardCategory.tactical:
                                  SoundService().playCardPlayTactical();
                              }
                              combat.playCard(cardIndex,
                                  targetEnemyIndex: enemyIdx);
                            },
                          ),
                        ),

                        const SizedBox(height: 4),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ---- Turn transition overlay ----
            if (_showTurnOverlay)
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _turnOverlayOpacity,
                  builder: (context, child) {
                    return IgnorePointer(
                      child: Container(
                        color: Colors.black
                            .withValues(alpha: 0.4 * _turnOverlayOpacity.value),
                        child: Center(
                          child: Opacity(
                            opacity: _turnOverlayOpacity.value,
                            child: Transform.scale(
                              scale:
                                  0.8 + 0.2 * _turnOverlayOpacity.value,
                              child: Text(
                                _turnOverlayText,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: _turnOverlayText == AppLocalizations.of(context)!.cardBattleEnemyTurn
                                          ? Colors.red.withValues(alpha: 0.8)
                                          : Colors.blue.withValues(alpha: 0.8),
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            // ---- Victory / Defeat overlay ----
            Consumer<CardCombatState>(
              builder: (context, combat, _) {
                if (combat.phase == CombatPhase.victory) {
                  return _VictoryRewardOverlay(
                    gold: combat.goldReward,
                    zone: widget.zone,
                    isDark: isDark,
                    onComplete: () {
                      combat.resetCombat();
                      Navigator.of(context).pop(true);
                    },
                  );
                }
                if (combat.phase == CombatPhase.defeat) {
                  return _ResultOverlay(
                    isVictory: false,
                    gold: 0,
                    isDark: isDark,
                    onContinue: () {
                      combat.resetCombat();
                      Navigator.of(context).pop(false);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  static String _zoneBgAsset(int zone) {
    switch (zone) {
      case 1: return 'assets/images/backgrounds/bg_zone1_meadow.png';
      case 2: return 'assets/images/backgrounds/bg_zone2_dark_forest.png';
      case 3: return 'assets/images/backgrounds/bg_zone3_stone_castle.png';
      case 4: return 'assets/images/backgrounds/bg_zone4_lava_cavern.png';
      case 5: return 'assets/images/backgrounds/bg_zone5_abyss.png';
      default: return 'assets/images/backgrounds/bg_zone1_meadow.png';
    }
  }

  static List<Color> _zoneGradient(int zone) {
    switch (zone) {
      case 1: return [const Color(0xFF6FB5E8), const Color(0xFF50A050)];
      case 2: return [const Color(0xFF141428), const Color(0xFF1A2A1A)];
      case 3: return [const Color(0xFF1E1218), const Color(0xFF2D1F1A)];
      case 4: return [const Color(0xFF280A00), const Color(0xFF500A00)];
      case 5: return [const Color(0xFF050014), const Color(0xFF0F0328)];
      default: return [const Color(0xFF1A1A2E), const Color(0xFF0D0D1A)];
    }
  }
}

// ============================================================================
// Top bar: energy, turn, back button
// ============================================================================

class _TopBar extends StatelessWidget {
  final CardCombatState combat;
  final bool isDark;

  const _TopBar({required this.combat, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.6),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: Icon(Icons.arrow_back,
                color: isDark ? Colors.white : Colors.black87),
            onPressed: () => _showExitDialog(context),
            iconSize: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),

          // Energy
          _EnergyDisplay(
            current: combat.currentEnergy,
            max: combat.maxEnergy,
          ),
          const Spacer(),

          // Turn count
          Text(
            l10n.cardBattleTurnCount(combat.turnCount + 1),
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),

          // Draw / Discard counts
          _PileCount(
              icon: Icons.layers, count: combat.drawPile.length, isDark: isDark),
          const SizedBox(width: 8),
          _PileCount(
              icon: Icons.delete_outline,
              count: combat.discardPile.length,
              isDark: isDark),
        ],
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.cardBattleAbandonDialog),
        content: Text(l10n.cardBattleAbandonConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<CardCombatState>().resetCombat();
              Navigator.of(context).pop(false);
            },
            child: Text(l10n.cardBattleAbandonButton, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Energy display
// ============================================================================

class _EnergyDisplay extends StatelessWidget {
  final int current;
  final int max;

  const _EnergyDisplay({required this.current, required this.max});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.amber.shade600, Colors.orange.shade800],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.5),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$current/$max',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Pile count badge
// ============================================================================

class _PileCount extends StatelessWidget {
  final IconData icon;
  final int count;
  final bool isDark;

  const _PileCount(
      {required this.icon, required this.count, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: isDark ? Colors.white54 : Colors.black45),
        const SizedBox(width: 2),
        Text(
          '$count',
          style: TextStyle(
            color: isDark ? Colors.white54 : Colors.black45,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// Enemy area
// ============================================================================

class _EnemyArea extends StatelessWidget {
  final CardCombatState combat;
  final bool isDark;
  final Map<int, bool> enemyFlashing;

  const _EnemyArea({
    required this.combat,
    required this.isDark,
    required this.enemyFlashing,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (combat.enemies.isEmpty) {
      return Center(
        child: Text(
          l10n.cardBattleNoEnemies,
          style: const TextStyle(color: Colors.white54, fontSize: 16),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(combat.enemies.length, (i) {
          return Flexible(
            child: _EnemyCard(
              enemy: combat.enemies[i],
              isSelected: i == combat.selectedEnemyIndex,
              isFlashing: enemyFlashing[i] ?? false,
              onTap: () => combat.selectEnemy(i),
              isDark: isDark,
            ),
          );
        }),
      ),
    );
  }
}

class _EnemyCard extends StatelessWidget {
  final EnemyBattleData enemy;
  final bool isSelected;
  final bool isFlashing;
  final VoidCallback onTap;
  final bool isDark;

  const _EnemyCard({
    required this.enemy,
    required this.isSelected,
    required this.isFlashing,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isFlashing
              ? Colors.red.withValues(alpha: 0.6)
              : (isDark ? Colors.black87 : Colors.white)
                  .withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.redAccent : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Intent icon
            _IntentIcon(intent: enemy.currentIntent),
            const SizedBox(height: 6),

            // Monster sprite placeholder
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isFlashing
                    ? Colors.red.shade600
                    : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  enemy.monster.name.isNotEmpty
                      ? enemy.monster.name.characters.first
                      : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),

            // Name
            Text(
              enemy.monster.name,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),

            // HP bar
            _HpBar(
              current: enemy.currentHp,
              max: enemy.maxHp,
              height: 8,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 2),

            // Block indicator
            if (enemy.block > 0)
              _BlockIndicator(block: enemy.block),

            // Status effects
            if (enemy.statusEffects.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: _StatusRow(statusEffects: enemy.statusEffects),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Block indicator (shield icon with amount)
// ============================================================================

class _BlockIndicator extends StatelessWidget {
  final int block;

  const _BlockIndicator({required this.block});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.blue.shade800.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blueAccent, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shield, size: 14, color: Colors.blueAccent),
            const SizedBox(width: 2),
            Text(
              '$block',
              style: const TextStyle(
                color: Colors.blueAccent,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Intent icon
// ============================================================================

class _IntentIcon extends StatelessWidget {
  final EnemyIntent intent;

  const _IntentIcon({required this.intent});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    switch (intent.type) {
      case EnemyIntentType.attack:
        icon = Icons.flash_on;
        color = Colors.redAccent;
        break;
      case EnemyIntentType.multiAttack:
        icon = Icons.flash_on;
        color = Colors.deepOrange;
        break;
      case EnemyIntentType.defend:
        icon = Icons.shield;
        color = Colors.blueAccent;
        break;
      case EnemyIntentType.buff:
        icon = Icons.arrow_upward;
        color = Colors.greenAccent;
        break;
      case EnemyIntentType.debuff:
        icon = Icons.arrow_downward;
        color = Colors.purpleAccent;
        break;
      case EnemyIntentType.unknown:
        icon = Icons.help_outline;
        color = Colors.grey;
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 2),
        Text(
          intent.displayText,
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// ============================================================================
// Player info bar
// ============================================================================

class _PlayerInfoBar extends StatelessWidget {
  final CardCombatState combat;
  final bool isDark;

  const _PlayerInfoBar({required this.combat, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // HP bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite, size: 14, color: Colors.red),
                    const SizedBox(width: 4),
                    Text(
                      '${combat.playerHp} / ${combat.playerMaxHp}',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (combat.playerBlock > 0) ...[
                      const SizedBox(width: 8),
                      _BlockIndicator(block: combat.playerBlock),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                _HpBar(
                  current: combat.playerHp,
                  max: combat.playerMaxHp,
                  height: 10,
                  color: Colors.green,
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Status effects
          if (combat.playerStatus.isNotEmpty)
            _StatusRow(statusEffects: combat.playerStatus),

          const SizedBox(width: 8),

          // End turn button
          _EndTurnButton(combat: combat),
        ],
      ),
    );
  }
}

// ============================================================================
// End turn button
// ============================================================================

class _EndTurnButton extends StatelessWidget {
  final CardCombatState combat;

  const _EndTurnButton({required this.combat});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final enabled = combat.phase == CombatPhase.playerTurn;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? () {
          HapticFeedback.selectionClick();
          combat.endTurn();
        } : null,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: enabled
                ? const LinearGradient(
                    colors: [Color(0xFFE65100), Color(0xFFBF360C)],
                  )
                : null,
            color: enabled ? null : Colors.grey.shade700,
          ),
          child: Text(
            l10n.cardBattleEndTurnButton,
            style: TextStyle(
              color: enabled ? Colors.white : Colors.white38,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Card hand (with draw animation)
// ============================================================================

class _CardHand extends StatelessWidget {
  final CardCombatState combat;
  final bool isDark;
  final BattleGame game;
  final void Function(int cardIndex) onCardPlayed;

  const _CardHand({
    required this.combat,
    required this.isDark,
    required this.game,
    required this.onCardPlayed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hand = combat.hand;
    if (hand.isEmpty) {
      return Center(
        child: Text(
          combat.phase == CombatPhase.playerTurn ? l10n.cardBattleNoCardsInHand : '',
          style: const TextStyle(color: Colors.white38, fontSize: 14),
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: hand.length,
      itemBuilder: (context, index) {
        return _AnimatedHandCard(
          key: ValueKey('${hand[index].id}_$index'),
          card: hand[index],
          index: index,
          canPlay: combat.phase == CombatPhase.playerTurn &&
              hand[index].cost <= combat.currentEnergy,
          onTap: () {
            if (combat.phase == CombatPhase.playerTurn &&
                hand[index].cost <= combat.currentEnergy) {
              onCardPlayed(index);
            }
          },
          isDark: isDark,
        );
      },
    );
  }
}

// ============================================================================
// Animated hand card (slide in + play animation)
// ============================================================================

class _AnimatedHandCard extends StatefulWidget {
  final CardData card;
  final int index;
  final bool canPlay;
  final VoidCallback onTap;
  final bool isDark;

  const _AnimatedHandCard({
    super.key,
    required this.card,
    required this.index,
    required this.canPlay,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<_AnimatedHandCard> createState() => _AnimatedHandCardState();
}

class _AnimatedHandCardState extends State<_AnimatedHandCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _drawController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Card draw animation: slide up from bottom and fade in
    _drawController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300 + widget.index * 80),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _drawController,
      curve: Curves.easeOutBack,
    ));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _drawController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );
    _drawController.forward();
  }

  @override
  void dispose() {
    _drawController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: _PlayableCard(
          card: widget.card,
          canPlay: widget.canPlay,
          onTap: widget.onTap,
          isDark: widget.isDark,
        ),
      ),
    );
  }
}

// ============================================================================
// Playable card (with tap-to-play animation)
// ============================================================================

class _PlayableCard extends StatefulWidget {
  final CardData card;
  final bool canPlay;
  final VoidCallback onTap;
  final bool isDark;

  const _PlayableCard({
    required this.card,
    required this.canPlay,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<_PlayableCard> createState() => _PlayableCardState();
}

class _PlayableCardState extends State<_PlayableCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _playController;
  late final Animation<double> _playMoveUp;
  late final Animation<double> _playFade;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _playController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _playMoveUp = Tween<double>(begin: 0.0, end: -60.0).animate(
      CurvedAnimation(parent: _playController, curve: Curves.easeInBack),
    );
    _playFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _playController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );
    _playController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onTap();
      }
    });
  }

  @override
  void dispose() {
    _playController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.canPlay || _isPlaying) return;
    setState(() => _isPlaying = true);
    _playController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _playController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _playMoveUp.value),
          child: Opacity(
            opacity: _playFade.value,
            child: child,
          ),
        );
      },
      child: _HandCard(
        card: widget.card,
        canPlay: widget.canPlay,
        onTap: _handleTap,
        isDark: widget.isDark,
      ),
    );
  }
}

// ============================================================================
// Individual card widget
// ============================================================================

class _HandCard extends StatelessWidget {
  final CardData card;
  final bool canPlay;
  final VoidCallback onTap;
  final bool isDark;

  const _HandCard({
    required this.card,
    required this.canPlay,
    required this.onTap,
    required this.isDark,
  });

  Color get _borderColor {
    switch (card.category) {
      case CardCategory.attack:
        return Colors.red.shade400;
      case CardCategory.magic:
        return Colors.purple.shade400;
      case CardCategory.defense:
        return Colors.blue.shade400;
      case CardCategory.tactical:
        return Colors.amber.shade400;
    }
  }

  Color get _headerColor {
    switch (card.category) {
      case CardCategory.attack:
        return Colors.red.shade800;
      case CardCategory.magic:
        return Colors.purple.shade800;
      case CardCategory.defense:
        return Colors.blue.shade800;
      case CardCategory.tactical:
        return Colors.amber.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: canPlay ? 1.0 : 0.5,
        child: Container(
          width: 110,
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1E1E2E)
                : const Color(0xFFF5F5F0),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _borderColor, width: 2),
            boxShadow: canPlay
                ? [
                    BoxShadow(
                      color: _borderColor.withValues(alpha: 0.4),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header: cost + name
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: _headerColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: Row(
                  children: [
                    // Cost circle
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber.shade600,
                      ),
                      child: Center(
                        child: Text(
                          '${card.cost}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Builder(builder: (ctx) {
                        final l10n = AppLocalizations.of(ctx)!;
                        return Text(
                          CardLocalization.localizedName(card, l10n),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      }),
                    ),
                  ],
                ),
              ),

              // Description
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Builder(builder: (ctx) {
                    final l10n = AppLocalizations.of(ctx)!;
                    return Text(
                      CardLocalization.localizedDescription(card, l10n),
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black87,
                        fontSize: 10,
                        height: 1.3,
                      ),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    );
                  }),
                ),
              ),

              // Rarity indicator
              if (card.rarity != CardRarity.common)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Center(
                    child: Text(
                      _rarityLabel(context, card.rarity),
                      style: TextStyle(
                        color: _rarityColor(card.rarity),
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _rarityLabel(BuildContext context, CardRarity rarity) {
    final l10n = AppLocalizations.of(context)!;
    switch (rarity) {
      case CardRarity.common:
        return '';
      case CardRarity.uncommon:
        return l10n.cardRarityUncommon;
      case CardRarity.rare:
        return l10n.cardRarityRare;
      case CardRarity.legendary:
        return l10n.cardRarityLegendary;
    }
  }

  Color _rarityColor(CardRarity rarity) {
    switch (rarity) {
      case CardRarity.common:
        return Colors.grey;
      case CardRarity.uncommon:
        return Colors.green;
      case CardRarity.rare:
        return Colors.blue;
      case CardRarity.legendary:
        return Colors.amber;
    }
  }
}

// ============================================================================
// Shared widgets
// ============================================================================

class _HpBar extends StatelessWidget {
  final int current;
  final int max;
  final double height;
  final Color color;

  const _HpBar({
    required this.current,
    required this.max,
    this.height = 8,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = max > 0 ? (current / max).clamp(0.0, 1.0) : 0.0;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: ratio,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: ratio > 0.5
                ? color
                : ratio > 0.25
                    ? Colors.orange
                    : Colors.red,
            borderRadius: BorderRadius.circular(height / 2),
          ),
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final Map<StatusType, StatusEffect> statusEffects;

  const _StatusRow({required this.statusEffects});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 3,
      runSpacing: 2,
      children: statusEffects.entries.map((entry) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: entry.value.isDebuff
                ? Colors.red.shade900.withValues(alpha: 0.7)
                : Colors.green.shade900.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _statusIcon(entry.key),
                size: 10,
                color: entry.value.isDebuff
                    ? Colors.redAccent
                    : Colors.greenAccent,
              ),
              const SizedBox(width: 2),
              Text(
                '${entry.value.stacks}',
                style: TextStyle(
                  color: entry.value.isDebuff
                      ? Colors.redAccent
                      : Colors.greenAccent,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  IconData _statusIcon(StatusType type) {
    switch (type) {
      case StatusType.vulnerable:
        return Icons.broken_image;
      case StatusType.weak:
        return Icons.trending_down;
      case StatusType.poison:
        return Icons.science;
      case StatusType.burn:
        return Icons.local_fire_department;
      case StatusType.freeze:
        return Icons.ac_unit;
      case StatusType.strength:
        return Icons.fitness_center;
      case StatusType.dexterity:
        return Icons.speed;
      case StatusType.thorns:
        return Icons.park;
      case StatusType.regen:
        return Icons.healing;
      case StatusType.focus:
        return Icons.center_focus_strong;
      case StatusType.fortify:
        return Icons.security;
    }
  }
}

// ============================================================================
// Victory reward overlay with card selection
// ============================================================================

class _VictoryRewardOverlay extends StatefulWidget {
  final int gold;
  final int zone;
  final bool isDark;
  final VoidCallback onComplete;

  const _VictoryRewardOverlay({
    required this.gold,
    required this.zone,
    required this.isDark,
    required this.onComplete,
  });

  @override
  State<_VictoryRewardOverlay> createState() => _VictoryRewardOverlayState();
}

class _VictoryRewardOverlayState extends State<_VictoryRewardOverlay> {
  late final List<CardData> _cardChoices;
  bool _cardSelected = false;
  bool _goldAwarded = false;

  @override
  void initState() {
    super.initState();
    _generateCardChoices();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _awardGold();
  }

  void _awardGold() {
    if (_goldAwarded) return;
    _goldAwarded = true;

    // Award combat gold to dungeon run
    try {
      final dungeonState = context.read<DungeonState>();
      dungeonState.addGold(widget.gold);
    } catch (_) {
      // DungeonState may not be available in some contexts
    }
  }

  void _generateCardChoices() {
    final rng = Random();
    // Filter out starter/base cards and curse cards; pick non-upgraded cards
    final pool = CardDatabase.allCards
        .where((c) =>
            !c.id.startsWith('base_') &&
            !c.id.startsWith('curse_') &&
            !c.isUpgraded)
        .toList();
    pool.shuffle(rng);
    _cardChoices = pool.take(3).toList();
  }

  void _selectCard(CardData card) {
    if (_cardSelected) return;
    setState(() => _cardSelected = true);

    try {
      final dungeonState = context.read<DungeonState>();
      dungeonState.addCardToDeck(card);
    } catch (_) {
      // DungeonState may not be available
    }

    // Brief delay to show selection, then continue
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) widget.onComplete();
    });
  }

  void _skipCardReward() {
    if (_cardSelected) return;
    setState(() => _cardSelected = true);
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = widget.isDark;

    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 500),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: child,
              ),
            );
          },
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.emoji_events, size: 48, color: Colors.amber),
                const SizedBox(height: 12),
                Text(
                  l10n.cardBattleVictory,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Gold reward
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.monetization_on,
                        color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      l10n.cardBattleGoldReward(widget.gold),
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Card selection header
                Text(
                  l10n.cardBattleSelectCard,
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontSize: 13,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 12),

                // Card choices
                if (_cardChoices.isNotEmpty)
                  SizedBox(
                    height: 160,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _cardChoices.map((card) {
                        return _CardRewardChoice(
                          card: card,
                          isDark: isDark,
                          enabled: !_cardSelected,
                          onTap: () => _selectCard(card),
                        );
                      }).toList(),
                    ),
                  ),

                const SizedBox(height: 12),

                // Skip button
                TextButton(
                  onPressed: _cardSelected ? null : _skipCardReward,
                  child: Text(
                    l10n.cardBattleSkipButton,
                    style: TextStyle(
                      color: _cardSelected
                          ? Colors.grey
                          : (isDark ? Colors.white38 : Colors.black38),
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Card reward choice widget
// ============================================================================

class _CardRewardChoice extends StatelessWidget {
  final CardData card;
  final bool isDark;
  final bool enabled;
  final VoidCallback onTap;

  const _CardRewardChoice({
    required this.card,
    required this.isDark,
    required this.enabled,
    required this.onTap,
  });

  Color get _rarityColor {
    switch (card.rarity) {
      case CardRarity.common:
        return Colors.grey;
      case CardRarity.uncommon:
        return Colors.green;
      case CardRarity.rare:
        return Colors.blue;
      case CardRarity.legendary:
        return Colors.orange;
    }
  }

  String get _categoryIcon {
    switch (card.category) {
      case CardCategory.attack:
        return '⚔️';
      case CardCategory.magic:
        return '✨';
      case CardCategory.defense:
        return '🛡️';
      case CardCategory.tactical:
        return '🎯';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _rarityColor;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.5,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: 90,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isDark
                ? color.withValues(alpha: 0.15)
                : color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: color.withValues(alpha: 0.6),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cost
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _categoryIcon,
                    style: const TextStyle(fontSize: 12),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${card.cost}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Name
              Builder(builder: (ctx) {
                final l10n = AppLocalizations.of(ctx)!;
                return Text(
                  CardLocalization.localizedName(card, l10n),
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                );
              }),
              const SizedBox(height: 4),

              // Description
              Expanded(
                child: Builder(builder: (ctx) {
                  final l10n = AppLocalizations.of(ctx)!;
                  return Text(
                    CardLocalization.localizedDescription(card, l10n),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 9,
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  );
                }),
              ),

              // Rarity label
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  card.rarity.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Result overlay (victory / defeat)
// ============================================================================

class _ResultOverlay extends StatelessWidget {
  final bool isVictory;
  final int gold;
  final bool isDark;
  final VoidCallback onContinue;

  const _ResultOverlay({
    required this.isVictory,
    required this.gold,
    required this.isDark,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 500),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: child,
              ),
            );
          },
          child: Container(
            width: 280,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isVictory ? Colors.amber : Colors.red.shade400,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isVictory ? Colors.amber : Colors.red)
                      .withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isVictory ? Icons.emoji_events : Icons.heart_broken,
                  size: 56,
                  color: isVictory ? Colors.amber : Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  isVictory ? l10n.cardBattleVictory : l10n.dungeonResultDefeatTitle,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isVictory) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.monetization_on,
                          color: Colors.amber, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        l10n.cardBattleGoldReward(gold),
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isVictory ? Colors.amber.shade700 : Colors.grey.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      l10n.dungeonRestContinueButton,
                      style:
                          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
