import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:life_quest_final_v2/models/card_data.dart';
import 'package:life_quest_final_v2/models/status_effect.dart';
import 'package:life_quest_final_v2/models/monster.dart';
import 'package:life_quest_final_v2/models/relic_data.dart';
import 'package:life_quest_final_v2/data/card_database.dart';

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

  // ---- Relics (C-1) ----
  List<RelicData> _relics = [];

  // ---- Relic state flags ----
  bool _revivedOnce = false;           // relic_u03: 부활 1회
  bool _firstAttackBonusActive = false; // relic_c04: 첫 공격 카드 +3
  bool _firstDebuffReflected = false;  // relic_u06: 첫 디버프 반사 1회

  // ---- Player strength bonus (H-2) ----
  int _playerStrengthBonus = 0; // character.strength 기반 공격 보너스

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
  // Relic helper
  // =========================================================================

  /// 현재 전투에 특정 렐릭이 장착되어 있는지 확인.
  bool _hasRelic(String id) => _relics.any((r) => r.id == id);

  // =========================================================================
  // Core public methods
  // =========================================================================

  /// Initialize and start a new combat encounter.
  ///
  /// [relics]         : 현재 던전 런의 렐릭 목록 (C-1)
  /// [playerStrength] : 캐릭터 힘 스탯 (H-2 STR 보너스)
  void startCombat(
    List<CardData> deck,
    List<EnemyBattleData> enemies, {
    int maxHp = 80,
    int hp = 80,
    int maxEnergy = 3,
    List<RelicData>? relics,   // C-1
    int playerStrength = 0,    // H-2
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

    // ---- Relics (C-1) ----
    _relics = relics ?? [];
    _revivedOnce = false;
    _firstAttackBonusActive = true;
    _firstDebuffReflected = false;

    // ---- STR bonus (H-2): 힘 5당 공격 +1 ----
    _playerStrengthBonus = playerStrength ~/ 5;

    // ---- Deck setup ----
    // H-1: Innate 카드는 선드로우
    final innateCards = deck
        .where((c) => c.effects.any((e) => e.effectType == CardEffectType.innate))
        .toList();
    final normalCards = deck
        .where((c) => !c.effects.any((e) => e.effectType == CardEffectType.innate))
        .toList();
    _drawPile = List<CardData>.from(normalCards)..shuffle(_rng);
    _hand = [];
    _discardPile = [];
    _exhaustPile = [];

    // Innate 카드를 먼저 패에 추가
    _hand.addAll(innateCards);

    // ---- Enemies ----
    _enemies = List<EnemyBattleData>.from(enemies);
    for (final enemy in _enemies) {
      enemy.rollIntent(_rng);
    }

    // ---- Log & rewards ----
    _combatLog = ['--- 전투 시작! ---'];
    _goldReward = 0;
    _cardRewards = [];

    // ---- onCombatStart 렐릭 효과 적용 (C-1) ----
    _applyOnCombatStartRelics();

    // ---- Begin first turn ----
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

    // 저주 카드(cost < 0)는 사용 불가
    if (card.cost < 0) return;
    if (card.cost > _currentEnergy) return;

    final originalCost = card.cost;

    // Pay cost
    _currentEnergy -= card.cost;

    // Remove from hand
    _hand.removeAt(cardIndex);

    // Apply effects
    _applyCardEffects(card, targetEnemyIndex);

    // ---- onCardPlay 렐릭 효과 (C-1) ----
    // relic_c09: 비용 0 카드 사용 시 방어 2
    if (_hasRelic('relic_c09') && originalCost == 0) {
      _applyBlockToPlayer(2);
      _addLog('집중의 반지: 방어 +2');
    }
    // relic_u01: 공격 카드 사용 시 20% 확률 약화 1턴
    if (_hasRelic('relic_u01') && card.category == CardCategory.attack && _enemies.isNotEmpty) {
      if (_rng.nextDouble() < 0.2) {
        final tgt = targetEnemyIndex.clamp(0, _enemies.length - 1);
        _applyStatusToEnemy(StatusType.weak, 1, tgt);
        _addLog('서리의 심장: 약화 1턴 부여');
      }
    }

    // C-3: atk_c04/atk_c04_up - 분노 카드를 디스카드에 추가
    if (card.id == 'atk_c04' || card.id == 'atk_c04_up') {
      final curses = CardDatabase.curseCards.toList();
      if (curses.isNotEmpty) {
        _discardPile.add(curses[_rng.nextInt(curses.length)]);
        _addLog('분노의 일격: 저주 카드가 버린덱에 추가됨');
      }
    }

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

    // H-1: Retain 카드는 버리지 않고 패에 유지
    final retainedCards = _hand
        .where((c) => c.effects.any((e) => e.effectType == CardEffectType.retain))
        .toList();
    _discardPile.addAll(_hand
        .where((c) => !c.effects.any((e) => e.effectType == CardEffectType.retain)));
    _hand.clear();
    _hand.addAll(retainedCards);

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
    _relics = [];
    _revivedOnce = false;
    _firstAttackBonusActive = true;
    _firstDebuffReflected = false;
    _playerStrengthBonus = 0;
    notifyListeners();
  }

  // =========================================================================
  // Private: relic — onCombatStart
  // =========================================================================

  void _applyOnCombatStartRelics() {
    // relic_start_02: 시작 HP +15
    if (_hasRelic('relic_start_02')) {
      _playerMaxHp += 15;
      _playerHp = (_playerHp + 15).clamp(0, _playerMaxHp);
      _addLog('낡은 부적: 최대 HP +15');
    }

    // relic_c02: 전투 시작 시 HP 5 회복
    if (_hasRelic('relic_c02')) {
      _playerHp = (_playerHp + 5).clamp(0, _playerMaxHp);
      _addLog('빨간 물약: HP +5');
    }

    // relic_c07: 전투 시작 시 적 전체 독 2
    if (_hasRelic('relic_c07')) {
      for (int i = 0; i < _enemies.length; i++) {
        _applyStatusToEnemy(StatusType.poison, 2, i);
      }
      _addLog('독 주머니: 모든 적에게 독 2 부여');
    }

    // relic_c08: 가시 1 (영구) — 전투 시작 시 플레이어에게 가시 부여
    if (_hasRelic('relic_c08')) {
      _applyStatusToPlayer(StatusType.thorns, 1);
      _addLog('가시 방패: 가시 1 부여');
    }

    // relic_b01: 왕관 — 에너지는 DungeonState에서 처리, 저주 1장 추가
    if (_hasRelic('relic_b01')) {
      final curses = CardDatabase.curseCards.toList()..shuffle(_rng);
      if (curses.isNotEmpty) {
        _drawPile.add(curses.first);
        _addLog('왕관: 저주 카드 1장이 덱에 추가됨');
      }
    }
  }

  // =========================================================================
  // Private: turn flow
  // =========================================================================

  void _beginPlayerTurn() {
    _phase = CombatPhase.playerTurn;
    _currentEnergy = _maxEnergy;
    _firstAttackBonusActive = true; // relic_c04 초기화

    // Block resets unless fortified
    if (!_playerStatus.containsKey(StatusType.fortify)) {
      _playerBlock = 0;
    }

    // ---- onTurnStart 렐릭 효과 (C-1) ----

    // relic_c01: 매 턴 방어 4
    if (_hasRelic('relic_c01')) {
      _applyBlockToPlayer(4);
      _addLog('앵커: 방어 +4');
    }

    // relic_c03: 3턴마다 에너지 +1 (턴 3, 6, 9, ...)
    if (_hasRelic('relic_c03') && _turnCount > 0 && _turnCount % 3 == 0) {
      _currentEnergy++;
      _addLog('마나 구슬: 에너지 +1');
    }

    // relic_u04: 첫 3턴 에너지 +1
    if (_hasRelic('relic_u04') && _turnCount < 3) {
      _currentEnergy++;
      _addLog('시간의 모래: 에너지 +1');
    }

    // relic_b04: 매 턴 랜덤 카드 1장 패에 생성
    if (_hasRelic('relic_b04')) {
      final pool = CardDatabase.allCards
          .where((c) => c.cost >= 0 && !c.id.startsWith('curse_') && !c.isUpgraded)
          .toList();
      if (pool.isNotEmpty) {
        _hand.add(pool[_rng.nextInt(pool.length)]);
        _addLog('혼돈의 구체: 랜덤 카드 1장 패에 추가');
      }
    }

    _processStartOfTurnEffects();

    // H-4: 독/번 등으로 사망했으면 드로우하지 않음
    if (_phase != CombatPhase.playerTurn) return;

    // 드로우 수 계산
    int cardsToDraw = _hasRelic('relic_r03') ? 6 : 5; // relic_r03: 패 6장
    if (_hasRelic('relic_c06') && _turnCount == 0) cardsToDraw += 2; // relic_c06: 첫 턴 +2

    // Retain된 카드가 있으면 그만큼 덜 드로우 (패 총합 유지)
    final retainCount = _hand.length;
    final drawCount = (cardsToDraw - retainCount).clamp(0, cardsToDraw);
    drawCards(drawCount);

    // relic_c10: 패에 공격 카드만 있으면 에너지 +1 (드로우 후 체크)
    if (_hasRelic('relic_c10') && _hand.isNotEmpty &&
        _hand.every((c) => c.category == CardCategory.attack)) {
      _currentEnergy++;
      _addLog('전사의 팔찌: 에너지 +1');
    }

    // 저주 카드 in-hand 효과 처리
    _processCurseCardsInHand();
  }

  // =========================================================================
  // Private: curse card in-hand effects
  // =========================================================================

  void _processCurseCardsInHand() {
    for (final card in List.from(_hand)) {
      if (card.cost >= 0) continue; // 저주 카드가 아님
      for (final effect in card.effects) {
        switch (effect.effectType) {
          case CardEffectType.damage:
            if (effect.targetType == TargetType.self) {
              _playerHp = (_playerHp - effect.value).clamp(0, _playerMaxHp).toInt();
              _addLog('${card.name}: ${effect.value} 자해 피해');
            }
            break;
          case CardEffectType.gainEnergy:
            if (effect.value < 0) {
              _currentEnergy = (_currentEnergy + effect.value).clamp(0, _maxEnergy + 5).toInt();
              _addLog('${card.name}: 에너지 ${effect.value}');
            }
            break;
          case CardEffectType.block:
            if (effect.value < 0) {
              _playerBlock = (_playerBlock + effect.value).clamp(0, 9999).toInt();
              _addLog('${card.name}: 방어 ${effect.value}');
            }
            break;
          default:
            break;
        }
      }
    }
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
              _applyDamageToEnemy(_calculateDamage(effect.value, card: card), i);
            }
          } else {
            // C-3: atk_c09/atk_c09_up — 첫 턴이면 데미지 2배
            int rawValue = effect.value;
            if ((card.id == 'atk_c09' || card.id == 'atk_c09_up') && _turnCount == 0) {
              rawValue *= 2;
            }
            // relic_c04: 첫 번째 공격 카드 데미지 +3
            if (_hasRelic('relic_c04') && card.category == CardCategory.attack && _firstAttackBonusActive) {
              rawValue += 3;
              _firstAttackBonusActive = false;
              _addLog('날카로운 숫돌: 공격 +3');
            }
            int dmg = _calculateDamage(rawValue, card: card);
            // relic_u02: 마법 카드 데미지 +25%
            if (_hasRelic('relic_u02') && card.category == CardCategory.magic) {
              dmg = (dmg * 1.25).floor();
            }
            _applyDamageToEnemy(dmg, targetIndex);
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
            int dmg = _calculateDamage(effect.value, card: card);
            // relic_u02: 마법 카드 AOE도 포함
            if (_hasRelic('relic_u02') && card.category == CardCategory.magic) {
              dmg = (dmg * 1.25).floor();
            }
            _applyDamageToEnemy(dmg, i);
          }
          _addLog('${card.name}: 전체 ${effect.value} 피해');
          break;

        case CardEffectType.exhaust:
          // Handled by caller (card goes to exhaust pile)
          break;

        case CardEffectType.retain:
          // H-1: Retain — endTurn()에서 패 버리기 시 유지 처리됨
          break;

        case CardEffectType.innate:
          // H-1: Innate — startCombat()에서 선드로우 처리됨
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
      // relic_u05: 적 처치 시 HP 5 회복
      if (_hasRelic('relic_u05')) {
        _playerHp = (_playerHp + 5).clamp(0, _playerMaxHp);
        _addLog('영혼 수확자: HP +5');
      }
      _enemies.removeAt(targetIndex);
      if (_selectedEnemyIndex >= _enemies.length && _enemies.isNotEmpty) {
        _selectedEnemyIndex = _enemies.length - 1;
      }
    }
  }

  void _applyDamageToPlayer(int damage) {
    // relic_r01: 받는 데미지 -1
    if (_hasRelic('relic_r01')) {
      damage = (damage - 1).clamp(0, 9999);
    }
    // relic_b02: 받는 데미지 +5
    if (_hasRelic('relic_b02')) {
      damage += 5;
    }

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

    // Burn damage to player (C-2: 번도 매 턴 감소)
    final burn = _playerStatus[StatusType.burn];
    if (burn != null && burn.stacks > 0) {
      _playerHp = (_playerHp - burn.stacks).clamp(0, _playerMaxHp);
      _addLog('화상: ${burn.stacks} 피해');
      final newBurnStacks = burn.stacks - 1;
      if (newBurnStacks <= 0) {
        _playerStatus.remove(StatusType.burn);
      } else {
        _playerStatus[StatusType.burn] = burn.copyWith(stacks: newBurnStacks);
      }
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
          if (_hasRelic('relic_u05')) {
            _playerHp = (_playerHp + 5).clamp(0, _playerMaxHp);
            _addLog('영혼 수확자: HP +5');
          }
          _enemies.removeAt(i);
          if (_selectedEnemyIndex >= _enemies.length && _enemies.isNotEmpty) {
            _selectedEnemyIndex = _enemies.length - 1;
          }
          continue;
        }
      }

      // Burn on enemies (C-2: 번도 매 턴 감소)
      if (i < _enemies.length) {
        final eBurn = _enemies[i].statusEffects[StatusType.burn];
        if (eBurn != null && eBurn.stacks > 0) {
          _enemies[i].currentHp =
              (_enemies[i].currentHp - eBurn.stacks).clamp(0, _enemies[i].maxHp);
          _addLog('${_enemies[i].monster.name} 화상: ${eBurn.stacks} 피해');
          final newEBurnStacks = eBurn.stacks - 1;
          if (newEBurnStacks <= 0) {
            _enemies[i].statusEffects.remove(StatusType.burn);
          } else {
            _enemies[i].statusEffects[StatusType.burn] =
                eBurn.copyWith(stacks: newEBurnStacks);
          }
          if (_enemies[i].isDead) {
            _addLog('${_enemies[i].monster.name} 처치!');
            _goldReward += _enemies[i].monster.xpReward ~/ 2 + 5;
            if (_hasRelic('relic_u05')) {
              _playerHp = (_playerHp + 5).clamp(0, _playerMaxHp);
              _addLog('영혼 수확자: HP +5');
            }
            _enemies.removeAt(i);
            if (_selectedEnemyIndex >= _enemies.length && _enemies.isNotEmpty) {
              _selectedEnemyIndex = _enemies.length - 1;
            }
          }
        }
      }
    }

    // Check after poison/burn — H-4에서 이후 드로우 차단에 사용
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
      // C-2: Burn도 매 턴 감소 (processStartOfTurn에서 처리하므로 여기선 skip)
      // Vulnerable, Weak: 매 턴 1씩 감소
      if (entry.key == StatusType.vulnerable ||
          entry.key == StatusType.weak) {
        final ns = entry.value.stacks - 1;
        if (ns <= 0) {
          keysToRemove.add(entry.key);
        } else {
          map[entry.key] = entry.value.copyWith(stacks: ns);
        }
      }
      // Strength, Dexterity, Thorns, Focus, Fortify, Regen, Poison, Burn은
      // 각자의 처리 로직에서 관리 (영구 또는 start-of-turn 처리)
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
          final str = enemy.statusEffects[StatusType.strength];
          if (str != null) dmg += str.stacks;
          if (enemy.statusEffects.containsKey(StatusType.weak)) {
            dmg = (dmg * 0.75).floor();
          }
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
          // relic_u06: 첫 디버프 1회 반사
          if (_hasRelic('relic_u06') && !_firstDebuffReflected) {
            _firstDebuffReflected = true;
            _applyStatusToEnemy(StatusType.vulnerable, intent.value, i);
            _addLog('마법 거울: 디버프 반사! ${enemy.monster.name}에게 취약 ${intent.value}');
          } else {
            _applyStatusToPlayer(StatusType.vulnerable, intent.value);
            _addLog('${enemy.monster.name}: 취약 ${intent.value} 부여');
          }
          break;

        case EnemyIntentType.unknown:
          break;
      }

      // Check if enemy killed itself via thorns
      if (i < _enemies.length && _enemies[i].isDead) {
        _addLog('${_enemies[i].monster.name} 처치!');
        _goldReward += _enemies[i].monster.xpReward ~/ 2 + 5;
        if (_hasRelic('relic_u05')) {
          _playerHp = (_playerHp + 5).clamp(0, _playerMaxHp);
          _addLog('영혼 수확자: HP +5');
        }
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
      // 골드 보너스 렐릭 적용
      _applyVictoryRelicBonuses();
      return;
    }
    if (_playerHp <= 0 &&
        _phase != CombatPhase.defeat &&
        _phase != CombatPhase.victory) {
      // relic_u03: 사망 시 1회 HP 30%로 부활
      if (_hasRelic('relic_u03') && !_revivedOnce) {
        _revivedOnce = true;
        _playerHp = (_playerMaxHp * 0.3).round();
        _addLog('불사조의 깃털: 30% HP로 부활!');
        return; // 패배 처리 하지 않음
      }
      _phase = CombatPhase.defeat;
      _playerHp = 0;
      _addLog('--- 패배... ---');
    }
  }

  void _applyVictoryRelicBonuses() {
    // relic_c05: 전투 보상 골드 +15
    if (_hasRelic('relic_c05')) {
      _goldReward += 15;
      _addLog('도둑의 장갑: 골드 +15');
    }
    // relic_start_03: 전투 보상 골드 +30%
    if (_hasRelic('relic_start_03')) {
      _goldReward = (_goldReward * 1.3).round();
      _addLog('행운의 동전: 골드 +30%');
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

  /// 플레이어의 카드 공격 데미지 계산.
  /// - STR 스탯 보너스 (H-2)
  /// - strength 상태이상
  /// - weak 상태이상
  /// - relic_b02: 카드 데미지 +5
  int _calculateDamage(int baseDamage, {CardData? card}) {
    int dmg = baseDamage + _playerStrengthBonus; // H-2 STR 보너스
    // Strength 상태이상
    final str = _playerStatus[StatusType.strength];
    if (str != null) dmg += str.stacks;
    // Weak 상태이상
    if (_playerStatus.containsKey(StatusType.weak)) {
      dmg = (dmg * 0.75).floor();
    }
    // relic_b02: 모든 카드 데미지 +5
    if (card != null && _hasRelic('relic_b02')) {
      dmg += 5;
    }
    return dmg.clamp(0, 9999);
  }

  /// 방어도 계산 (Dexterity 반영).
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
    if (_combatLog.length > 200) {
      _combatLog.removeRange(0, _combatLog.length - 200);
    }
  }
}
