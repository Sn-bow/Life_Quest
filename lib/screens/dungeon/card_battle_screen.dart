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
import 'package:life_quest_final_v2/widgets/relic_icon.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/models/relic_data.dart';

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
    _game = BattleGame(currentZone: widget.zone);
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
      final combatState = context.read<CardCombatState>();
      final dungeonState = context.read<DungeonState>();
      final charState = context.read<CharacterState>();
      combatState.startCombat(
        widget.deck,
        widget.enemies,
        maxHp: widget.playerMaxHp,
        hp: widget.playerHp,
        maxEnergy: dungeonState.maxEnergy,        // 렐릭 에너지 반영
        relics: dungeonState.currentRelics,        // C-1: 렐릭 전달
        playerStrength: charState.character.strength.toInt(), // H-2: STR 전달
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
    try { SoundService().playTurnChange(); } catch (_) {}
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

    // Container renders the zone background (image + gradient fallback).
    // Scaffold is transparent so the Container shows through.
    // GameWidget uses overlayBuilderMap so Flutter UI renders ABOVE Flame canvas —
    // this bypasses the Impeller/OpenGL compositing quirk on Android where
    // Positioned.fill widgets inside a Stack with GameWidget go invisible.
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(_zoneBgAsset(widget.zone)),
          fit: BoxFit.cover,
          onError: (_, __) {},
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _zoneGradient(widget.zone),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Transform.translate(
          offset: Offset(_shakeOffsetX, _shakeOffsetY),
          child: GameWidget(
            game: _game,
            overlayBuilderMap: {
              'battleUI': (context, game) {
                return Consumer<CardCombatState>(
                  builder: (context, combat, _) {
                    // build 완료 후 setState 호출 → "setState during build" 방지
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) _onCombatStateChanged(combat);
                    });
                    return Stack(
                      children: [
                        // ---- UI column ----
                        SafeArea(
                          child: Column(
                            children: [
                              _TopBar(combat: combat, isDark: isDark),
                              _RelicSlotBar(isDark: isDark),
                              const SizedBox(height: 4),
                              Expanded(
                                flex: 3,
                                child: _EnemyArea(
                                  combat: combat,
                                  isDark: isDark,
                                  enemyFlashing: _enemyFlashing,
                                ),
                              ),
                              _PlayerInfoBar(combat: combat, isDark: isDark),
                              const SizedBox(height: 4),
                              SizedBox(
                                height: 160,
                                child: _CardHand(
                                  combat: combat,
                                  isDark: isDark,
                                  game: _game,
                                  onCardPlayed: (cardIndex) {
                                    final card = combat.hand[cardIndex];
                                    final enemyIdx =
                                        combat.selectedEnemyIndex;

                                    // 카드 효과 먼저 적용 (핵심 로직)
                                    combat.playCard(cardIndex,
                                        targetEnemyIndex: enemyIdx);

                                    // ① 사운드 (Flame과 독립, 항상 실행)
                                    try {
                                      switch (card.category) {
                                        case CardCategory.attack:
                                          SoundService().playCardPlayAttack();
                                        case CardCategory.magic:
                                          SoundService().playCardPlayMagic();
                                        case CardCategory.defense:
                                          SoundService().playCardPlayDefense();
                                        case CardCategory.tactical:
                                          SoundService()
                                              .playCardPlayTactical();
                                      }
                                    } catch (_) {}

                                    // ② 햅틱 (독립)
                                    try {
                                      if (card.category ==
                                              CardCategory.attack ||
                                          card.category ==
                                              CardCategory.magic) {
                                        HapticFeedback.mediumImpact();
                                      } else {
                                        HapticFeedback.lightImpact();
                                      }
                                    } catch (_) {}

                                    // ③ Flame 파티클 + 적 플래시 (독립)
                                    try {
                                      if (card.category ==
                                              CardCategory.attack ||
                                          card.category ==
                                              CardCategory.magic) {
                                        _triggerEnemyFlash(enemyIdx);
                                        _game.playHitParticle();
                                      }
                                      if (card.effects.any((e) =>
                                          e.effectType ==
                                          CardEffectType.block)) {
                                        _game.playBlockParticle();
                                      }
                                      if (card.effects.any((e) =>
                                          e.effectType ==
                                          CardEffectType.heal)) {
                                        _game.playHealParticle();
                                      }
                                    } catch (_) {}
                                  },
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
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
                                    color: Colors.black.withValues(
                                        alpha:
                                            0.4 * _turnOverlayOpacity.value),
                                    child: Center(
                                      child: Opacity(
                                        opacity: _turnOverlayOpacity.value,
                                        child: Transform.scale(
                                          scale: 0.8 +
                                              0.2 *
                                                  _turnOverlayOpacity.value,
                                          child: Text(
                                            _turnOverlayText,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 36,
                                              fontWeight: FontWeight.bold,
                                              shadows: [
                                                Shadow(
                                                  color: _turnOverlayText ==
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .cardBattleEnemyTurn
                                                      ? Colors.red.withValues(
                                                          alpha: 0.8)
                                                      : Colors.blue.withValues(
                                                          alpha: 0.8),
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
                        if (combat.phase == CombatPhase.victory)
                          _VictoryRewardOverlay(
                            gold: combat.goldReward,
                            zone: widget.zone,
                            isDark: isDark,
                            onComplete: () {
                              // 최종 HP를 dungeon_map_screen으로 전달
                              final finalHp = combat.playerHp;
                              combat.resetCombat();
                              Navigator.of(context).pop({'won': true, 'hp': finalHp});
                            },
                          ),
                        if (combat.phase == CombatPhase.defeat)
                          _ResultOverlay(
                            isVictory: false,
                            gold: 0,
                            isDark: isDark,
                            onContinue: () {
                              combat.resetCombat();
                              Navigator.of(context).pop(false);
                            },
                          ),
                      ],
                    );
                  },
                );
              },
            },
            initialActiveOverlays: const ['battleUI'],
          ),
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
// Relic slot bar: shows active relics in current dungeon run
// ============================================================================

class _RelicSlotBar extends StatelessWidget {
  final bool isDark;

  const _RelicSlotBar({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final dungeon = context.watch<DungeonState>();
    final relics = dungeon.currentRelics;

    if (relics.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: relics.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, i) => RelicIconWithTooltip(
          relic: relics[i],
          size: 36,
        ),
      ),
    );
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

          // Energy orb
          _EnergyDisplay(
            current: combat.currentEnergy,
            max: combat.maxEnergy,
          ),
          const SizedBox(width: 10),

          // Playable cards count
          _PlayableCardsBadge(
            playableCount: combat.hand
                .where((c) => c.cost <= combat.currentEnergy)
                .length,
            totalInHand: combat.hand.length,
            currentEnergy: combat.currentEnergy,
            isDark: isDark,
          ),

          const Spacer(),

          // Turn count
          Text(
            l10n.cardBattleTurnCount(combat.turnCount + 1),
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10),

          // Draw pile
          _PileCount(
            icon: Icons.layers,
            count: combat.drawPile.length,
            isDark: isDark,
            label: l10n.cardBattleDrawPile,
          ),
          const SizedBox(width: 8),
          // Discard pile
          _PileCount(
            icon: Icons.delete_outline,
            count: combat.discardPile.length,
            isDark: isDark,
            label: l10n.cardBattleDiscardPile,
          ),
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
              // async gap 전에 참조 캡처 (use_build_context_synchronously 대응)
              final combatState = context.read<CardCombatState>();
              Navigator.of(ctx).pop();   // 다이얼로그 닫기
              Navigator.of(context).pop(false); // 배틀 화면 먼저 팝
              // resetCombat은 화면이 스택에서 제거된 뒤 실행
              // (빌드 중 notifyListeners 호출로 인한 에러 방지)
              Future.microtask(() {
                try { combatState.resetCombat(); } catch (_) {}
              });
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
    final isEmpty = current == 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 56,
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 오브 배경 이미지
              Image.asset(
                isEmpty
                    ? 'assets/images/ui/ui_energy_orb_empty.png'
                    : 'assets/images/ui/ui_energy_orb.png',
                width: 56,
                height: 56,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: isEmpty
                          ? [Colors.grey.shade700, Colors.grey.shade900]
                          : [Colors.amber.shade400, Colors.orange.shade800],
                    ),
                  ),
                ),
              ),
              // 숫자 오버레이
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$current',
                    style: TextStyle(
                      color: isEmpty ? Colors.grey.shade400 : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                      shadows: const [Shadow(color: Colors.black, blurRadius: 4)],
                    ),
                  ),
                  Text(
                    '/$max',
                    style: TextStyle(
                      color: isEmpty ? Colors.grey.shade600 : Colors.amber.shade200,
                      fontSize: 9,
                      height: 1.0,
                      shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'EP',
          style: TextStyle(
            color: isEmpty ? Colors.grey.shade600 : Colors.amber.shade300,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// Playable cards badge — shows how many cards in hand can be played now
// ============================================================================

class _PlayableCardsBadge extends StatelessWidget {
  final int playableCount;
  final int totalInHand;
  final int currentEnergy;
  final bool isDark;

  const _PlayableCardsBadge({
    required this.playableCount,
    required this.totalInHand,
    required this.currentEnergy,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final canPlay = playableCount > 0;
    final noEnergy = currentEnergy == 0;
    final l10n = AppLocalizations.of(context)!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: noEnergy
            ? Colors.red.shade900.withValues(alpha: 0.85)
            : canPlay
                ? Colors.green.shade800.withValues(alpha: 0.85)
                : Colors.orange.shade900.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: noEnergy
              ? Colors.red.shade400.withValues(alpha: 0.7)
              : canPlay
                  ? Colors.greenAccent.withValues(alpha: 0.6)
                  : Colors.orange.shade400.withValues(alpha: 0.6),
          width: 1,
        ),
        boxShadow: canPlay && !noEnergy
            ? [BoxShadow(color: Colors.greenAccent.withValues(alpha: 0.3), blurRadius: 6)]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            noEnergy ? Icons.block : Icons.style,
            size: 12,
            color: noEnergy
                ? Colors.red.shade300
                : canPlay
                    ? Colors.greenAccent
                    : Colors.orange.shade300,
          ),
          const SizedBox(width: 4),
          // 핵심: EP가 얼마고 카드가 몇 장 나오는지 명확하게 표시
          Text(
            noEnergy
                ? l10n.cardBattleEpEmpty
                : l10n.cardBattlePlayableCount(playableCount),
            style: TextStyle(
              color: noEnergy
                  ? Colors.red.shade200
                  : canPlay
                      ? Colors.white
                      : Colors.orange.shade200,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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
  final String label;

  const _PileCount({
    required this.icon,
    required this.count,
    required this.isDark,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDark ? Colors.white54 : Colors.black45;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 2),
            Text(
              '$count',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: TextStyle(color: color, fontSize: 8, letterSpacing: 0.5),
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

            // Monster sprite
            SizedBox(
              width: 160,
              height: 160,
              child: Stack(
                children: [
                  // Sprite image — falls back to letter tile on error
                  ColorFiltered(
                    colorFilter: isFlashing
                        ? const ColorFilter.mode(
                            Colors.red, BlendMode.srcATop)
                        : const ColorFilter.mode(
                            Colors.transparent, BlendMode.multiply),
                    child: Image.asset(
                      enemy.monster.spritePath,
                      width: 160,
                      height: 160,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.none, // 픽셀아트 선명도 유지
                      errorBuilder: (_, __, ___) => Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          color: isFlashing
                              ? Colors.red.shade600
                              : Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            enemy.monster.name.isNotEmpty
                                ? enemy.monster.name.characters.first
                                : '?',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // Name
            Text(
              enemy.monster.name,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                shadows: const [Shadow(color: Colors.black, blurRadius: 4)],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // HP text + bar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite, size: 12, color: Colors.redAccent),
                const SizedBox(width: 4),
                Text(
                  '${enemy.currentHp}/${enemy.maxHp}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
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
    final l10n = AppLocalizations.of(context)!;
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

    final typeLabel = switch (intent.type) {
      EnemyIntentType.attack => l10n.cardBattleIntentAttack,
      EnemyIntentType.multiAttack => l10n.cardBattleIntentMultiAttack,
      EnemyIntentType.defend => l10n.cardBattleIntentDefend,
      EnemyIntentType.buff => l10n.cardBattleIntentBuff,
      EnemyIntentType.debuff => l10n.cardBattleIntentDebuff,
      EnemyIntentType.unknown => l10n.cardBattleIntentUnknown,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 3),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                typeLabel,
                style: TextStyle(
                  color: color.withValues(alpha: 0.8),
                  fontSize: 8,
                  height: 1.0,
                ),
              ),
              if (intent.displayText.isNotEmpty)
                Text(
                  intent.displayText,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
            ],
          ),
        ],
      ),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // HP bar + 상태효과 (Expanded로 나머지 공간 전부 사용)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite, size: 14, color: Colors.red),
                    const SizedBox(width: 4),
                    Text(
                      '${combat.playerHp} / ${combat.playerMaxHp}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        shadows: [Shadow(color: Colors.black, blurRadius: 3)],
                      ),
                    ),
                    if (combat.playerBlock > 0) ...[
                      const SizedBox(width: 6),
                      _BlockIndicator(block: combat.playerBlock),
                    ],
                    const Spacer(),
                    // 상태효과를 HP 수치 오른쪽에 배치 (Row 안에서 overflow 방지)
                    if (combat.playerStatus.isNotEmpty)
                      _StatusRow(statusEffects: combat.playerStatus),
                  ],
                ),
                const SizedBox(height: 4),
                _PlayerHpBar(
                  current: combat.playerHp,
                  max: combat.playerMaxHp,
                ),
              ],
            ),
          ),

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
    final enabled = combat.phase == CombatPhase.playerTurn;
    return GestureDetector(
      onTap: enabled ? () {
        HapticFeedback.selectionClick();
        combat.endTurn();
      } : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.45,
        child: SizedBox(
          height: 44,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 버튼 배경 이미지
              Image.asset(
                'assets/images/ui/ui_turn_end_button.png',
                height: 44,
                fit: BoxFit.fitHeight,
                errorBuilder: (_, __, ___) => Container(
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
      duration: Duration(milliseconds: 200 + widget.index * 50),
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
        // Reset so the card can be re-used if it stays in hand
        if (mounted) {
          setState(() => _isPlaying = false);
          _playController.reset();
        }
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
    _playController.forward(from: 0.0); // 애니메이션 먼저 시작
    widget.onTap(); // 즉시 카드 효과 적용
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

  String get _frameAsset {
    switch (card.category) {
      case CardCategory.attack:
        return 'assets/images/cards/card_frame_attack.png';
      case CardCategory.defense:
        return 'assets/images/cards/card_frame_defense.png';
      case CardCategory.magic:
        return 'assets/images/cards/card_frame_magic.png';
      case CardCategory.tactical:
        return 'assets/images/cards/card_frame_tactical.png';
    }
  }

  String get _iconAsset {
    switch (card.category) {
      case CardCategory.attack:
        return 'assets/images/game/cards/icons/icon_attack.png';
      case CardCategory.defense:
        return 'assets/images/game/cards/icons/icon_defense.png';
      case CardCategory.magic:
        return 'assets/images/game/cards/icons/icon_magic.png';
      case CardCategory.tactical:
        return 'assets/images/game/cards/icons/icon_tactical.png';
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: canPlay ? 1.0 : 0.45,
        child: SizedBox(
          width: 110,
          child: Stack(
            children: [
              // ── 카드 프레임 배경 이미지 ──
              Positioned.fill(
                child: Image.asset(
                  _frameAsset,
                  fit: BoxFit.fill,
                  // 파일 없으면 색상 fallback
                  errorBuilder: (_, __, ___) => Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2E),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _borderColor, width: 2),
                    ),
                  ),
                ),
              ),

              // ── 카드 내용 오버레이 ──
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 코스트 + 이름
                    Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xCC000000),
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
                          child: Text(
                            CardLocalization.localizedName(card, l10n),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              shadows: [Shadow(color: Colors.black, blurRadius: 3)],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    // ── 카드 카테고리 아이콘 ──
                    Center(
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: Image.asset(
                          _iconAsset,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    // 설명
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          CardLocalization.localizedDescription(card, l10n),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            height: 1.3,
                            shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    // 레어도
                    if (card.rarity != CardRarity.common)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Center(
                          child: Text(
                            _rarityLabel(context, card.rarity),
                            style: TextStyle(
                              color: _rarityColor(card.rarity),
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // ── 사용 불가 시 어둡게 ──
              if (!canPlay)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
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

// ============================================================================
// Player HP bar — uses ui_hp_bar.png as frame
// ============================================================================

class _PlayerHpBar extends StatelessWidget {
  final int current;
  final int max;

  const _PlayerHpBar({required this.current, required this.max});

  @override
  Widget build(BuildContext context) {
    final ratio = max > 0 ? (current / max).clamp(0.0, 1.0) : 0.0;

    return SizedBox(
      height: 26,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ui_hp_bar.png — 이미 빨간 HP 바 디자인이 담긴 이미지 (꽉 찬 상태)
          Image.asset(
            'assets/images/ui/ui_hp_bar.png',
            fit: BoxFit.fill,
            filterQuality: FilterQuality.medium,
            errorBuilder: (_, __, ___) => Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          // 소진된 HP 부분 — 오른쪽에서부터 어두운 마스크로 덮어서
          // 이미지의 빨간 바가 HP 비율만큼만 보이도록 함
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 4, 6, 4),
            child: Align(
              alignment: Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: 1.0 - ratio,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.80),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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

    // 렐릭 확인
    List<RelicData> relics = [];
    try {
      relics = context.read<DungeonState>().currentRelics;
    } catch (_) {}
    final hasAdventurerBag = relics.any((r) => r.id == 'relic_start_01');
    final hasFateThread = relics.any((r) => r.id == 'relic_r05');

    // relic_r05: 운명의 실 — 레어+ 확률 2배
    // 기본: common 55%, uncommon 30%, rare 12%, legendary 3%
    // r05 적용: common 46%, uncommon 25%, rare 22%, legendary 7% (레어+ 비율 약 2배)
    CardData pickOneCard() {
      final roll = rng.nextDouble();
      CardRarity rarity;
      if (hasFateThread) {
        if (roll < 0.46) { rarity = CardRarity.common; }
        else if (roll < 0.71) { rarity = CardRarity.uncommon; }
        else if (roll < 0.93) { rarity = CardRarity.rare; }
        else { rarity = CardRarity.legendary; }
      } else {
        if (roll < 0.55) { rarity = CardRarity.common; }
        else if (roll < 0.85) { rarity = CardRarity.uncommon; }
        else if (roll < 0.97) { rarity = CardRarity.rare; }
        else { rarity = CardRarity.legendary; }
      }
      final rarityPool = CardDatabase.allCards
          .where((c) =>
              c.rarity == rarity &&
              !c.id.startsWith('base_') &&
              !c.id.startsWith('curse_') &&
              !c.isUpgraded)
          .toList();
      if (rarityPool.isEmpty) {
        // fallback to common
        final fallback = CardDatabase.getCardsByRarity(CardRarity.common)
            .where((c) => !c.id.startsWith('base_') && !c.isUpgraded)
            .toList();
        return fallback.isNotEmpty ? fallback[rng.nextInt(fallback.length)]
            : CardDatabase.allCards.first;
      }
      return rarityPool[rng.nextInt(rarityPool.length)];
    }

    // relic_start_01: 모험자의 가방 — 선택지 4장
    final choiceCount = hasAdventurerBag ? 4 : 3;
    final picked = <CardData>[];
    final usedIds = <String>{};
    for (int i = 0; i < choiceCount; i++) {
      CardData card = pickOneCard();
      int attempts = 0;
      while (usedIds.contains(card.id) && attempts < 10) {
        card = pickOneCard();
        attempts++;
      }
      usedIds.add(card.id);
      picked.add(card);
    }
    _cardChoices = picked;
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
