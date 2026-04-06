import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:life_quest_final_v2/models/card_data.dart';
import 'package:life_quest_final_v2/models/status_effect.dart';
import 'package:life_quest_final_v2/models/monster.dart';

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

enum CombatPhase { notStarted, playerTurn, enemyTurn, reward, victory, defeat }

enum EnemyIntentType { attack, multiAttack, defend, buff, debuff, unknown }

// ---------------------------------------------------------------------------
// Supporting data classes
// ---------------------------------------------------------------------------

class EnemyIntent {
  final EnemyIntentType type;
  final int value;
  final int hits;

  const EnemyIntent({
    required this.type,
    this.value = 0,
    this.hits = 1,
  });

  String get displayText {
    switch (type) {
      case EnemyIntentType.attack:
        return '$value';
      case EnemyIntentType.multiAttack:
        return '$value x$hits';
      case EnemyIntentType.defend:
        return '$value';
      case EnemyIntentType.buff:
        return '+$value';
      case EnemyIntentType.debuff:
        return '-$value';
      case EnemyIntentType.unknown:
        return '?';
    }
  }
}

class EnemyBattleData {
  final Monster monster;
  int currentHp;
  int maxHp;
  int block;
  Map<StatusType, StatusEffect> statusEffects;
  EnemyIntent currentIntent;
  int intentIndex;

  EnemyBattleData({
    required this.monster,
    required this.maxHp,
    int? currentHp,
    this.block = 0,
    Map<StatusType, StatusEffect>? statusEffects,
    EnemyIntent? currentIntent,
    this.intentIndex = 0,
  })  : currentHp = currentHp ?? maxHp,
        statusEffects = statusEffects ?? {},
        currentIntent =
            currentIntent ?? const EnemyIntent(type: EnemyIntentType.unknown);

  bool get isDead => currentHp <= 0;

  /// Factory from Monster model. Scales HP/attack by zone multiplier.
  factory EnemyBattleData.fromMonster(Monster monster, {int zone = 1}) {
    final hpScale = 1.0 + (zone - 1) * 0.25;
    final scaledHp = (monster.maxHp * hpScale).round();
    return EnemyBattleData(
      monster: monster,
      maxHp: scaledHp,
      currentHp: scaledHp,
    );
  }

  /// Roll a new intent based on the monster's base stats and pattern index.
  void rollIntent(Random rng) {
    // Simple AI pattern: cycle through a deterministic set based on index,
    // with some randomness mixed in.
    final baseAttack = monster.attack.round();
    final patterns = <EnemyIntent>[
      EnemyIntent(type: EnemyIntentType.attack, value: baseAttack),
      EnemyIntent(type: EnemyIntentType.attack, value: baseAttack + 2),
      EnemyIntent(
          type: EnemyIntentType.defend, value: (monster.defense * 1.5).round()),
      EnemyIntent(
          type: EnemyIntentType.multiAttack,
          value: (baseAttack * 0.6).round().clamp(1, 999),
          hits: 3),
      const EnemyIntent(type: EnemyIntentType.debuff, value: 1),
      const EnemyIntent(type: EnemyIntentType.buff, value: 2),
    ];

    // Weighted toward attack patterns
    final weights = [30, 25, 15, 15, 10, 5];
    final roll = rng.nextInt(100);
    int cumulative = 0;
    for (int i = 0; i < patterns.length; i++) {
      cumulative += weights[i];
      if (roll < cumulative) {
        currentIntent = patterns[i];
        intentIndex = i;
        return;
      }
    }
    currentIntent = patterns[0];
    intentIndex = 0;
  }
}

// ---------------------------------------------------------------------------
// CardCombatState (ChangeNotifier / Provider)
// ---------------------------------------------------------------------------

class CardCombatState extends ChangeNotifier {
  final Random _rng = Random();

  // ---- Combat phase ----
  CombatPhase _phase = CombatPhase.notStarted;

  // ---- Energy ----
  int _currentEnergy = 0;
  int _maxEnergy = 3;

  // ---- Turn ----
  int _turnCount = 0;

  // ---- Deck management ----
  List<CardData> _drawPile = [];
  List<CardData> _hand = [];
  List<CardData> _discardPile = [];
  List<CardData> _exhaustPile = [];

  // ---- Player state ----
  int _playerHp = 80;
  int _playerMaxHp = 80;
  int _playerBlock = 0;
  Map<StatusType, StatusEffect> _playerStatus = {};

  // ---- Enemies ----
  List<EnemyBattleData> _enemies = [];
  int _selectedEnemyIndex = 0;

  // ---- Combat log ----
  List<String> _combatLog = [];

  // ---- Rewards ----
  int _goldReward = 0;
  List<CardData> _cardRewards = [];

  // =========================================================================
  // Getters
  // =========================================================================

  CombatPhase get phase => _phase;
  int get currentEnergy => _currentEnergy;
  int get maxEnergy => _maxEnergy;
  int get turnCount => _turnCount;

  List<CardData> get drawPile => List.unmodifiable(_drawPile);
  List<CardData> get hand => List.unmodifiable(_hand);
  List<CardData> get discardPile => List.unmodifiable(_discardPile);
  List<CardData> get exhaustPile => List.unmodifiable(_exhaustPile);

  int get playerHp => _playerHp;
  int get playerMaxHp => _playerMaxHp;
  int get playerBlock => _playerBlock;
  Map<StatusType, StatusEffect> get playerStatus =>
      Map.unmodifiable(_playerStatus);

  List<EnemyBattleData> get enemies => List.unmodifiable(_enemies);
  int get selectedEnemyIndex => _selectedEnemyIndex;

  List<String> get combatLog => List.unmodifiable(_combatLog);

  int get goldReward => _goldReward;
  List<CardData> get cardRewards => List.unmodifiable(_cardRewards);

  bool get isCombatActive =>
      _phase == CombatPhase.playerTurn || _phase == CombatPhase.enemyTurn;

  // =========================================================================
  // Core public methods
  // =========================================================================

  /// Initialize and start a new combat encounter.
  void startCombat(
    List<CardData> deck,
    List<EnemyBattleData> enemies, {
    int maxHp = 80,
    int hp = 80,
    int maxEnergy = 3,
  }) {
    _phase = CombatPhase.notStarted;
    _playerMaxHp = maxHp;
    _playerHp = hp.clamp(1, maxHp);
    _maxEnergy = maxEnergy;
    _currentEnergy = maxEnergy;
    _turnCount = 0;
    _playerBlock = 0;
    _playerStatus = {};
    _selectedEnemyIndex = 0;

    // Deck setup
    _drawPile = List<CardData>.from(deck)..shuffle(_rng);
    _hand = [];
    _discardPile = [];
    _exhaustPile = [];

    // Enemies
    _enemies = List<EnemyBattleData>.from(enemies);
    for (final enemy in _enemies) {
      enemy.rollIntent(_rng);
    }

    // Log & rewards
    _combatLog = ['--- 전투 시작! ---'];
    _goldReward = 0;
    _cardRewards = [];

    // Begin first turn
    _beginPlayerTurn();
    notifyListeners();
  }

  /// Draw [count] cards from draw pile into hand.
  void drawCards(int count) {
    for (int i = 0; i < count; i++) {
      if (_drawPile.isEmpty) {
        if (_discardPile.isEmpty) break;
        _shuffleDiscardIntoDraw();
      }
      if (_drawPile.isNotEmpty) {
        _hand.add(_drawPile.removeLast());
      }
    }
  }

  /// Play a card from hand by index.
  void playCard(int cardIndex, {int targetEnemyIndex = 0}) {
    if (_phase != CombatPhase.playerTurn) return;
    if (cardIndex < 0 || cardIndex >= _hand.length) return;

    final card = _hand[cardIndex];
    if (card.cost > _currentEnergy) return;

    // Pay cost
    _currentEnergy -= card.cost;

    // Remove from hand
    _hand.removeAt(cardIndex);

    // Apply effects
    _applyCardEffects(card, targetEnemyIndex);

    // Determine pile destination
    final hasExhaust = card.effects
        .any((e) => e.effectType == CardEffectType.exhaust);
    if (hasExhaust) {
      _exhaustPile.add(card);
      _addLog('${card.name} 소멸됨');
    } else {
      _discardPile.add(card);
    }

    // Check combat end after every card
    _checkCombatEnd();
    notifyListeners();
  }

  /// End the player's turn and process enemy actions.
  void endTurn() {
    if (_phase != CombatPhase.playerTurn) return;

    _processEndOfTurnEffects();

    // Discard remaining hand
    _discardPile.addAll(_hand);
    _hand.clear();

    _phase = CombatPhase.enemyTurn;
    notifyListeners();

    // Process enemies (done synchronously; UI can animate via listener)
    _processEnemyActions();
    _checkCombatEnd();

    if (_phase == CombatPhase.enemyTurn) {
      // Still alive -> next player turn
      _turnCount++;
      _beginPlayerTurn();
    }
    notifyListeners();
  }

  /// Select an enemy target.
  void selectEnemy(int index) {
    if (index >= 0 && index < _enemies.length) {
      _selectedEnemyIndex = index;
      notifyListeners();
    }
  }

  /// Fully reset state.
  void resetCombat() {
    _phase = CombatPhase.notStarted;
    _currentEnergy = 0;
    _turnCount = 0;
    _drawPile = [];
    _hand = [];
    _discardPile = [];
    _exhaustPile = [];
    _playerHp = 80;
    _playerMaxHp = 80;
    _playerBlock = 0;
    _playerStatus = {};
    _enemies = [];
    _selectedEnemyIndex = 0;
    _combatLog = [];
    _goldReward = 0;
    _cardRewards = [];
    notifyListeners();
  }

  // =========================================================================
  // Private: turn flow
  // =========================================================================

  void _beginPlayerTurn() {
    _phase = CombatPhase.playerTurn;
    _currentEnergy = _maxEnergy;

    // Block resets unless fortified
    if (!_playerStatus.containsKey(StatusType.fortify)) {
      _playerBlock = 0;
    }

    _processStartOfTurnEffects();
    drawCards(5);
  }

  // =========================================================================
  // Private: card effect application
  // =========================================================================

  void _applyCardEffects(CardData card, int targetIndex) {
    for (final effect in card.effects) {
      switch (effect.effectType) {
        case CardEffectType.damage:
          if (effect.targetType == TargetType.allEnemies) {
            for (int i = _enemies.length - 1; i >= 0; i--) {
              _applyDamageToEnemy(_calculateDamage(effect.value), i);
            }
          } else {
            _applyDamageToEnemy(
                _calculateDamage(effect.value), targetIndex);
          }
          _addLog('${card.name}: ${effect.value} 피해');
          break;

        case CardEffectType.block:
          _applyBlockToPlayer(_calculateBlock(effect.value));
          _addLog('${card.name}: ${effect.value} 방어');
          break;

        case CardEffectType.heal:
          final heal = effect.value;
          _playerHp = (_playerHp + heal).clamp(0, _playerMaxHp);
          _addLog('${card.name}: $heal 회복');
          break;

        case CardEffectType.drawCard:
          drawCards(effect.value);
          _addLog('${card.name}: ${effect.value}장 드로우');
          break;

        case CardEffectType.gainEnergy:
          _currentEnergy += effect.value;
          _addLog('${card.name}: ${effect.value} 에너지 획득');
          break;

        case CardEffectType.applyBuff:
          if (effect.statusType != null) {
            _applyStatusToPlayer(effect.statusType!, effect.value);
            _addLog(
                '${card.name}: ${effect.statusType!.name} ${effect.value} 부여');
          }
          break;

        case CardEffectType.applyDebuff:
          if (effect.statusType != null) {
            if (effect.targetType == TargetType.allEnemies) {
              for (int i = 0; i < _enemies.length; i++) {
                _applyStatusToEnemy(effect.statusType!, effect.value, i);
              }
            } else {
              _applyStatusToEnemy(
                  effect.statusType!, effect.value, targetIndex);
            }
            _addLog(
                '${card.name}: ${effect.statusType!.name} ${effect.value} 부여');
          }
          break;

        case CardEffectType.aoe:
          for (int i = _enemies.length - 1; i >= 0; i--) {
            _applyDamageToEnemy(_calculateDamage(effect.value), i);
          }
          _addLog('${card.name}: 전체 ${effect.value} 피해');
          break;

        case CardEffectType.exhaust:
          // Handled by caller (card goes to exhaust pile)
          break;

        case CardEffectType.retain:
          // Retain means the card stays in hand at end of turn.
          // Handled in endTurn logic if we add retained flag.
          break;

        case CardEffectType.innate:
          // Innate cards are drawn at the start. Handled in deck setup.
          break;
      }
    }
  }

  // =========================================================================
  // Private: damage & block
  // =========================================================================

  void _applyDamageToEnemy(int damage, int targetIndex) {
    if (targetIndex < 0 || targetIndex >= _enemies.length) return;
    final enemy = _enemies[targetIndex];

    // Vulnerable: +50% damage taken
    if (enemy.statusEffects.containsKey(StatusType.vulnerable)) {
      damage = (damage * 1.5).floor();
    }

    // Apply to block first
    int remaining = damage;
    if (enemy.block > 0) {
      if (enemy.block >= remaining) {
        enemy.block -= remaining;
        remaining = 0;
      } else {
        remaining -= enemy.block;
        enemy.block = 0;
      }
    }

    // Apply to HP
    enemy.currentHp = (enemy.currentHp - remaining).clamp(0, enemy.maxHp);

    if (enemy.isDead) {
      _addLog('${enemy.monster.name} 처치!');
      _goldReward += enemy.monster.xpReward ~/ 2 + 5;
      _enemies.removeAt(targetIndex);
      // Fix selected index
      if (_selectedEnemyIndex >= _enemies.length && _enemies.isNotEmpty) {
        _selectedEnemyIndex = _enemies.length - 1;
      }
    }
  }

  void _applyDamageToPlayer(int damage) {
    // Weak check on enemy is handled by enemy action method
    int remaining = damage;
    if (_playerBlock > 0) {
      if (_playerBlock >= remaining) {
        _playerBlock -= remaining;
        remaining = 0;
      } else {
        remaining -= _playerBlock;
        _playerBlock = 0;
      }
    }
    _playerHp = (_playerHp - remaining).clamp(0, _playerMaxHp);
  }

  void _applyBlockToPlayer(int block) {
    _playerBlock += block;
  }

  // =========================================================================
  // Private: status effects
  // =========================================================================

  void _applyStatusToEnemy(StatusType type, int stacks, int targetIndex) {
    if (targetIndex < 0 || targetIndex >= _enemies.length) return;
    final enemy = _enemies[targetIndex];
    final existing = enemy.statusEffects[type];
    if (existing != null) {
      enemy.statusEffects[type] = existing.copyWith(
        stacks: existing.stacks + stacks,
      );
    } else {
      enemy.statusEffects[type] = StatusEffect(type: type, stacks: stacks);
    }
  }

  void _applyStatusToPlayer(StatusType type, int stacks) {
    final existing = _playerStatus[type];
    if (existing != null) {
      _playerStatus[type] = existing.copyWith(
        stacks: existing.stacks + stacks,
      );
    } else {
      _playerStatus[type] = StatusEffect(type: type, stacks: stacks);
    }
  }

  // =========================================================================
  // Private: start/end of turn effects
  // =========================================================================

  void _processStartOfTurnEffects() {
    // Poison damage to player
    final poison = _playerStatus[StatusType.poison];
    if (poison != null && poison.stacks > 0) {
      _playerHp = (_playerHp - poison.stacks).clamp(0, _playerMaxHp);
      _addLog('독: ${poison.stacks} 피해');
      final newStacks = poison.stacks - 1;
      if (newStacks <= 0) {
        _playerStatus.remove(StatusType.poison);
      } else {
        _playerStatus[StatusType.poison] = poison.copyWith(stacks: newStacks);
      }
    }

    // Burn damage to player
    final burn = _playerStatus[StatusType.burn];
    if (burn != null && burn.stacks > 0) {
      _playerHp = (_playerHp - burn.stacks).clamp(0, _playerMaxHp);
      _addLog('화상: ${burn.stacks} 피해');
    }

    // Regen
    final regen = _playerStatus[StatusType.regen];
    if (regen != null && regen.stacks > 0) {
      _playerHp = (_playerHp + regen.stacks).clamp(0, _playerMaxHp);
      _addLog('재생: ${regen.stacks} 회복');
      final newStacks = regen.stacks - 1;
      if (newStacks <= 0) {
        _playerStatus.remove(StatusType.regen);
      } else {
        _playerStatus[StatusType.regen] = regen.copyWith(stacks: newStacks);
      }
    }

    // Poison on enemies
    for (int i = _enemies.length - 1; i >= 0; i--) {
      final enemy = _enemies[i];
      final ePoison = enemy.statusEffects[StatusType.poison];
      if (ePoison != null && ePoison.stacks > 0) {
        enemy.currentHp =
            (enemy.currentHp - ePoison.stacks).clamp(0, enemy.maxHp);
        _addLog('${enemy.monster.name} 독: ${ePoison.stacks} 피해');
        final ns = ePoison.stacks - 1;
        if (ns <= 0) {
          enemy.statusEffects.remove(StatusType.poison);
        } else {
          enemy.statusEffects[StatusType.poison] =
              ePoison.copyWith(stacks: ns);
        }
        if (enemy.isDead) {
          _addLog('${enemy.monster.name} 처치!');
          _goldReward += enemy.monster.xpReward ~/ 2 + 5;
          _enemies.removeAt(i);
          if (_selectedEnemyIndex >= _enemies.length && _enemies.isNotEmpty) {
            _selectedEnemyIndex = _enemies.length - 1;
          }
        }
      }

      // Burn on enemies
      if (i < _enemies.length) {
        final eBurn = _enemies[i].statusEffects[StatusType.burn];
        if (eBurn != null && eBurn.stacks > 0) {
          _enemies[i].currentHp =
              (_enemies[i].currentHp - eBurn.stacks).clamp(0, _enemies[i].maxHp);
          _addLog('${_enemies[i].monster.name} 화상: ${eBurn.stacks} 피해');
          if (_enemies[i].isDead) {
            _addLog('${_enemies[i].monster.name} 처치!');
            _goldReward += _enemies[i].monster.xpReward ~/ 2 + 5;
            _enemies.removeAt(i);
            if (_selectedEnemyIndex >= _enemies.length && _enemies.isNotEmpty) {
              _selectedEnemyIndex = _enemies.length - 1;
            }
          }
        }
      }
    }

    // Check after poison/burn
    _checkCombatEnd();
  }

  void _processEndOfTurnEffects() {
    // Decrement duration-based status effects on player
    _tickStatusMap(_playerStatus);

    // Decrement on living enemies
    for (final enemy in _enemies) {
      _tickStatusMap(enemy.statusEffects);
      // Enemy block resets each turn
      enemy.block = 0;
    }
  }

  void _tickStatusMap(Map<StatusType, StatusEffect> map) {
    final keysToRemove = <StatusType>[];
    for (final entry in map.entries) {
      // Vulnerable & Weak decrement by 1 each turn
      if (entry.key == StatusType.vulnerable ||
          entry.key == StatusType.weak) {
        final ns = entry.value.stacks - 1;
        if (ns <= 0) {
          keysToRemove.add(entry.key);
        } else {
          map[entry.key] = entry.value.copyWith(stacks: ns);
        }
      }
      // Strength, Dexterity, Thorns, Focus, Fortify are permanent (no tick)
      // Poison & Burn are handled in start-of-turn
    }
    for (final k in keysToRemove) {
      map.remove(k);
    }
  }

  // =========================================================================
  // Private: enemy actions
  // =========================================================================

  void _processEnemyActions() {
    for (int i = 0; i < _enemies.length; i++) {
      if (_playerHp <= 0) break;
      final enemy = _enemies[i];
      final intent = enemy.currentIntent;

      switch (intent.type) {
        case EnemyIntentType.attack:
          int dmg = intent.value;
          // Strength buff
          final str = enemy.statusEffects[StatusType.strength];
          if (str != null) dmg += str.stacks;
          // Weak debuff on enemy -> 25% less damage
          if (enemy.statusEffects.containsKey(StatusType.weak)) {
            dmg = (dmg * 0.75).floor();
          }
          // Thorns on player
          final thorns = _playerStatus[StatusType.thorns];
          _applyDamageToPlayer(dmg.clamp(0, 9999));
          _addLog('${enemy.monster.name}: $dmg 공격');
          if (thorns != null && thorns.stacks > 0) {
            enemy.currentHp =
                (enemy.currentHp - thorns.stacks).clamp(0, enemy.maxHp);
            _addLog('가시: ${thorns.stacks} 반사 피해');
          }
          break;

        case EnemyIntentType.multiAttack:
          for (int h = 0; h < intent.hits; h++) {
            if (_playerHp <= 0) break;
            int dmg = intent.value;
            final str = enemy.statusEffects[StatusType.strength];
            if (str != null) dmg += str.stacks;
            if (enemy.statusEffects.containsKey(StatusType.weak)) {
              dmg = (dmg * 0.75).floor();
            }
            _applyDamageToPlayer(dmg.clamp(0, 9999));
          }
          _addLog(
              '${enemy.monster.name}: ${intent.value} x${intent.hits} 연속 공격');
          final thorns = _playerStatus[StatusType.thorns];
          if (thorns != null && thorns.stacks > 0) {
            final thornDmg = thorns.stacks * intent.hits;
            enemy.currentHp =
                (enemy.currentHp - thornDmg).clamp(0, enemy.maxHp);
            _addLog('가시: $thornDmg 반사 피해');
          }
          break;

        case EnemyIntentType.defend:
          enemy.block += intent.value;
          _addLog('${enemy.monster.name}: ${intent.value} 방어');
          break;

        case EnemyIntentType.buff:
          _applyStatusToEnemy(StatusType.strength, intent.value, i);
          _addLog('${enemy.monster.name}: 힘 +${intent.value}');
          break;

        case EnemyIntentType.debuff:
          _applyStatusToPlayer(StatusType.vulnerable, intent.value);
          _addLog('${enemy.monster.name}: 취약 ${intent.value} 부여');
          break;

        case EnemyIntentType.unknown:
          break;
      }

      // Check if enemy killed itself via thorns
      if (enemy.isDead) {
        _addLog('${enemy.monster.name} 처치!');
        _goldReward += enemy.monster.xpReward ~/ 2 + 5;
        _enemies.removeAt(i);
        i--;
        if (_selectedEnemyIndex >= _enemies.length && _enemies.isNotEmpty) {
          _selectedEnemyIndex = _enemies.length - 1;
        }
      }
    }

    // Roll new intents for surviving enemies
    for (final enemy in _enemies) {
      enemy.rollIntent(_rng);
    }
  }

  // =========================================================================
  // Private: combat end check
  // =========================================================================

  void _checkCombatEnd() {
    if (_enemies.isEmpty &&
        _phase != CombatPhase.victory &&
        _phase != CombatPhase.defeat) {
      _phase = CombatPhase.victory;
      _addLog('--- 승리! ---');
      return;
    }
    if (_playerHp <= 0 &&
        _phase != CombatPhase.defeat &&
        _phase != CombatPhase.victory) {
      _phase = CombatPhase.defeat;
      _playerHp = 0;
      _addLog('--- 패배... ---');
      return;
    }
  }

  // =========================================================================
  // Private: deck helpers
  // =========================================================================

  void _shuffleDiscardIntoDraw() {
    _drawPile.addAll(_discardPile);
    _discardPile.clear();
    _drawPile.shuffle(_rng);
    _addLog('버린 카드 더미를 다시 섞었습니다');
  }

  // =========================================================================
  // Private: damage calculation helpers
  // =========================================================================

  /// Calculate outgoing damage from the player, factoring in Strength and Weak.
  int _calculateDamage(int baseDamage) {
    int dmg = baseDamage;
    // Strength
    final str = _playerStatus[StatusType.strength];
    if (str != null) dmg += str.stacks;
    // Weak
    if (_playerStatus.containsKey(StatusType.weak)) {
      dmg = (dmg * 0.75).floor();
    }
    return dmg.clamp(0, 9999);
  }

  /// Calculate block gained, factoring in Dexterity.
  int _calculateBlock(int baseBlock) {
    int blk = baseBlock;
    final dex = _playerStatus[StatusType.dexterity];
    if (dex != null) blk += dex.stacks;
    return blk.clamp(0, 9999);
  }

  // =========================================================================
  // Private: logging
  // =========================================================================

  void _addLog(String message) {
    _combatLog.add(message);
    // Keep log from growing unbounded
    if (_combatLog.length > 200) {
      _combatLog.removeRange(0, _combatLog.length - 200);
    }
  }
}
