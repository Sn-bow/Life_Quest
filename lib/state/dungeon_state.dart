import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:life_quest_final_v2/data/card_database.dart';
import 'package:life_quest_final_v2/data/core_loop_rules.dart';
import 'package:life_quest_final_v2/data/dungeon_generator.dart';
import 'package:life_quest_final_v2/data/event_database.dart';
import 'package:life_quest_final_v2/data/monster_database.dart';
import 'package:life_quest_final_v2/data/relic_database.dart';
import 'package:life_quest_final_v2/models/dungeon_event.dart';
import 'package:life_quest_final_v2/models/dungeon_map.dart';
import 'package:life_quest_final_v2/models/card_data.dart';
import 'package:life_quest_final_v2/models/monster.dart';
import 'package:life_quest_final_v2/models/relic_data.dart';
import 'package:life_quest_final_v2/state/card_combat_state.dart';

/// Phases of a dungeon run.
enum RunPhase {
  notStarted,
  exploring,
  inCombat,
  inEvent,
  inShop,
  inRest,
  completed,
  failed,
}

/// Manages state for a single dungeon run, including the map, deck,
/// relics, gold, HP, and node progression.
class DungeonState extends ChangeNotifier {
  String? _runId;
  int? _towerFloor;
  Map<String, dynamic>? _checkpointData;
  Future<void> Function(Map<String, dynamic>?)? _saveCheckpoint;
  Future<void> _pendingSave = Future.value();
  int _binding = 0, _saveRevision = 0;
  bool _saveFailed = false;
  String? get runId => _runId;
  int? get towerFloor => _towerFloor;
  bool get saveFailed => _saveFailed;
  bool get hasRun => _runPhase != RunPhase.notStarted;
  bool get hasResult =>
      _runPhase == RunPhase.completed || _runPhase == RunPhase.failed;

  /// Checkpoints are room boundaries, never a half-applied combat/shop reward.
  /// A killed process resumes the same room with its original resources.
  void bindCheckpoint({
    required Map<String, dynamic>? saved,
    required Future<void> Function(Map<String, dynamic>?) save,
  }) {
    _binding++;
    _saveCheckpoint = null;
    _clearRun();
    _saveFailed = false;
    _pendingSave = Future.value();
    if (saved != null) fromJson(saved, notify: false);
    _checkpointData = saved == null ? null : _clone(saved);
    _saveCheckpoint = save;
  }

  void unbindCheckpoint() {
    _binding++;
    _saveCheckpoint = null;
  }

  static Map<String, dynamic> _clone(Map<String, dynamic> value) =>
      jsonDecode(jsonEncode(value)) as Map<String, dynamic>;

  void _checkpoint() {
    _checkpointData = hasRun ? _clone(toJson()) : null;
    _writeCheckpoint();
  }

  void _writeCheckpoint() {
    final save = _saveCheckpoint;
    if (save == null) return;
    final binding = _binding;
    final revision = ++_saveRevision;
    // The profile writer captures the snapshot synchronously, then serializes
    // disk writes. This also prevents unrelated profile saves from losing it.
    _pendingSave = Future.sync(() => save(_checkpointData)).then(
      (_) {
        if (binding == _binding && revision == _saveRevision && _saveFailed) {
          _saveFailed = false;
          notifyListeners();
        }
      },
      onError: (Object error, StackTrace stack) {
        if (binding == _binding && revision == _saveRevision) {
          _saveFailed = true;
          notifyListeners();
        }
      },
    );
  }

  Future<bool> flushCheckpoint() async {
    if (_saveFailed) _writeCheckpoint();
    await _pendingSave;
    return !_saveFailed;
  }

  // ---- Run phase ----
  RunPhase _runPhase = RunPhase.notStarted;

  // ---- Map ----
  DungeonMap? _currentMap;
  int _currentZone = 1;
  int _ascensionLevel = 0;

  // ---- Player state during run ----
  List<CardData> _currentDeck = [];
  List<RelicData> _currentRelics = [];
  int _dungeonGold = 0;
  int _playerHp = 80;
  int _playerMaxHp = 80;
  int _maxEnergy = 3;
  DailyModifier _dailyModifier = const DailyModifier();

  // ---- Node-specific state ----
  DungeonEvent? _currentEvent;
  List<CardData> _shopCards = [];
  List<RelicData> _shopRelics = [];

  // ---- Run tracking ----
  int _nodesCompleted = 0;
  int _monstersKilled = 0;

  // ---- Infinite Tower ----
  /// Additional HP/ATK scaling applied by the Infinite Tower (stacks on ascension).
  double _towerStatMult = 1.0;

  // ===========================================================================
  // Getters
  // ===========================================================================

  RunPhase get runPhase => _runPhase;
  DungeonMap? get currentMap => _currentMap;
  int get currentZone => _currentZone;
  int get ascensionLevel => _ascensionLevel;

  List<CardData> get currentDeck => List.unmodifiable(_currentDeck);
  List<RelicData> get currentRelics => List.unmodifiable(_currentRelics);
  int get dungeonGold => _dungeonGold;
  int get playerHp => _playerHp;
  int get playerMaxHp => _playerMaxHp;
  int get maxEnergy => _maxEnergy;
  DailyModifier get dailyModifier => _dailyModifier;

  int get nodesCompleted => _nodesCompleted;
  int get monstersKilled => _monstersKilled;
  double get towerStatMult => _towerStatMult;

  DungeonEvent? get currentEvent => _currentEvent;
  List<CardData> get shopCards => List.unmodifiable(_shopCards);
  List<RelicData> get shopRelics => List.unmodifiable(_shopRelics);

  bool get isRunActive =>
      _runPhase != RunPhase.notStarted &&
      _runPhase != RunPhase.completed &&
      _runPhase != RunPhase.failed;

  DungeonNode? get currentNode => _currentMap?.currentNode;

  List<DungeonNode> get accessibleNodes => _currentMap?.accessibleNodes ?? [];

  // ===========================================================================
  // Core methods
  // ===========================================================================

  /// Start a new dungeon run. Generates a map and initializes player state.
  bool startRun({
    required int zone,
    required List<CardData> startingDeck,
    required int playerMaxHp,
    int ascension = 0,
    RelicData? starterRelic,
    int startingGold = 50,
    double towerStatMult = 1.0,
    int? towerFloor,
    DailyModifier dailyModifier = const DailyModifier(),
  }) {
    if (hasRun) return false;
    _runId =
        '${DateTime.now().microsecondsSinceEpoch}-'
        '${Random.secure().nextInt(0x100000000).toRadixString(16)}';
    _towerFloor = towerFloor;
    _currentZone = zone;
    _ascensionLevel = ascension;
    _towerStatMult = towerStatMult;
    _dailyModifier = dailyModifier;

    // Generate map
    _currentMap = DungeonGenerator.generate(zone: zone);

    // Player state
    _currentDeck = List<CardData>.from(startingDeck);
    _currentRelics = [];
    if (starterRelic != null) {
      _currentRelics.add(starterRelic);
    }
    // Ascension 3: starting gold penalty
    int adjustedGold = startingGold;
    if (_ascensionLevel >= 3) {
      adjustedGold = (adjustedGold - 30).clamp(0, 9999);
    }
    _dungeonGold = adjustedGold + _dailyModifier.startingGoldBonus;

    _playerMaxHp = playerMaxHp + _dailyModifier.combatHpBonus;
    _playerHp = _playerMaxHp;
    _maxEnergy = _computeMaxEnergy();

    // Ascension 7: start HP -10%
    if (_ascensionLevel >= 7) {
      _playerHp = (_playerMaxHp * 0.9).round();
    }

    // Ascension 4: add one curse card to starting deck
    if (_ascensionLevel >= 4) {
      final curseCards = CardDatabase.curseCards;
      if (curseCards.isNotEmpty) {
        _currentDeck.add(curseCards.first);
      }
    }

    // Run tracking
    _nodesCompleted = 0;
    _monstersKilled = 0;

    _runPhase = RunPhase.exploring;
    _checkpoint();
    notifyListeners();
    return true;
  }

  /// Select a node to visit. The node must be accessible and not completed.
  bool selectNode(int nodeId) {
    if (_currentMap == null || !isRunActive) return false;
    if (_runPhase != RunPhase.exploring) {
      // Re-enter an unfinished visit without rerolling its shop/event state.
      return _currentMap!.currentNodeId == nodeId;
    }

    final nodes = _currentMap!.nodes;
    final nodeIndex = nodes.indexWhere((n) => n.id == nodeId);
    if (nodeIndex < 0) return false;

    final node = nodes[nodeIndex];
    if (!node.isAccessible || node.isCompleted) return false;

    // Set current node
    _currentMap = _currentMap!.copyWith(currentNodeId: nodeId);

    // Transition run phase based on node type
    switch (node.type) {
      case NodeType.combat:
        _runPhase = RunPhase.inCombat;
        break;
      case NodeType.elite:
        _runPhase = RunPhase.inCombat;
        break;
      case NodeType.boss:
        _runPhase = RunPhase.inCombat;
        break;
      case NodeType.event:
        _currentEvent = EventDatabase.getRandomEvent(zone: _currentZone);
        _runPhase = RunPhase.inEvent;
        break;
      case NodeType.shop:
        _generateShopInventory();
        _runPhase = RunPhase.inShop;
        break;
      case NodeType.rest:
        _runPhase = RunPhase.inRest;
        break;
    }

    _checkpoint();
    notifyListeners();
    return true;
  }

  /// Build a list of [EnemyBattleData] appropriate for the given [node].
  List<EnemyBattleData> getEnemiesForNode(DungeonNode node) {
    final rng = Random((_currentMap?.seed ?? 0) + node.id * 7919);
    final monsters = MonsterDatabase.getMonstersByZone(_currentZone);
    if (monsters.isEmpty) return [];

    // Ascension HP/ATK multipliers
    // Lv1: +10% HP, Lv2: +10% ATK, Lv8: boss +25% HP, Lv10: +20% HP all
    // _towerStatMult adds extra scaling per Infinite Tower floor
    final hpMult =
        (1.0 +
            (_ascensionLevel >= 1 ? 0.1 : 0.0) +
            (_ascensionLevel >= 10 ? 0.2 : 0.0)) *
        _towerStatMult;
    final atkMult = (1.0 + (_ascensionLevel >= 2 ? 0.1 : 0.0)) * _towerStatMult;
    final bossHpMult = hpMult + (_ascensionLevel >= 8 ? 0.25 : 0.0);

    switch (node.type) {
      case NodeType.combat:
        final monster = monsters[rng.nextInt(monsters.length)];
        return [
          EnemyBattleData.fromMonster(
            monster.copyWith(
              maxHp: (monster.maxHp * hpMult).roundToDouble(),
              attack: (monster.attack * atkMult).roundToDouble(),
            ),
          ),
        ];

      case NodeType.elite:
        // 엘리트: 강한 적 1마리 + 일반 졸개 1마리 (AoE 카드 활용 유도)
        final eliteBase = List.of(monsters)
          ..sort((a, b) => b.level.compareTo(a.level));
        final elite = eliteBase.first;
        final minion = monsters[rng.nextInt(monsters.length)];
        return [
          EnemyBattleData.fromMonster(
            elite.copyWith(
              maxHp: (elite.maxHp * 1.5 * hpMult).roundToDouble(),
              attack: (elite.attack * 1.3 * atkMult).roundToDouble(),
              defense: (elite.defense * 1.2).roundToDouble(),
              xpReward: (elite.xpReward * 1.5).round(),
            ),
          ),
          EnemyBattleData.fromMonster(
            minion.copyWith(
              maxHp: (minion.maxHp * 0.7 * hpMult).roundToDouble(),
              attack: (minion.attack * atkMult).roundToDouble(),
              xpReward: (minion.xpReward * 0.5).round(),
            ),
          ),
        ];

      case NodeType.boss:
        // Pick the zone boss, apply boss HP multiplier (Lv8: +25%)
        final boss = _bossForZone(_currentZone);
        return [
          EnemyBattleData.fromMonster(
            boss.copyWith(
              maxHp: (boss.maxHp * bossHpMult).roundToDouble(),
              attack: (boss.attack * atkMult).roundToDouble(),
            ),
          ),
        ];

      default:
        return [];
    }
  }

  Monster _bossForZone(int zone) {
    final bossesById = {
      for (final boss in MonsterDatabase.getBossMonsters()) boss.id: boss,
    };
    const bossProgression = [
      'boss_troll',
      'boss_hydra',
      'boss_dragon',
      'boss_demon_lord',
      'boss_fallen_angel',
    ];
    final index = (zone - 1).clamp(0, bossProgression.length - 1);
    return bossesById[bossProgression[index]] ??
        MonsterDatabase.getBossMonsters().first;
  }

  /// Generate random shop inventory (cards + relics).
  void _generateShopInventory() {
    // 3 random cards from uncommon+ pool
    final allCards = CardDatabase.allCards
        .where(
          (c) =>
              c.rarity != CardRarity.common && c.rarity != CardRarity.legendary,
        )
        .toList();
    allCards.shuffle();
    _shopCards = allCards.take(3).toList();

    // Also sometimes include a rare/legendary
    final rarePool = CardDatabase.allCards
        .where(
          (c) =>
              c.rarity == CardRarity.rare || c.rarity == CardRarity.legendary,
        )
        .toList();
    if (rarePool.isNotEmpty) {
      rarePool.shuffle();
      _shopCards.add(rarePool.first);
    }

    // 2 random relics
    _shopRelics = RelicDatabase.getRandomRelics(2);
  }

  /// Mark the current node as completed and unlock connected nodes.
  void completeCurrentNode() {
    if (!isRunActive) return;
    if (_currentMap == null) return;
    final currentNodeId = _currentMap!.currentNodeId;
    if (currentNodeId == null) return;

    final nodes = List<DungeonNode>.from(_currentMap!.nodes);
    final nodeIndex = nodes.indexWhere((n) => n.id == currentNodeId);
    if (nodeIndex < 0) return;

    final completedNode = nodes[nodeIndex];
    if (completedNode.isCompleted) return;

    // Mark current node as completed
    nodes[nodeIndex] = completedNode.copyWith(
      isCompleted: true,
      isAccessible: false,
    );

    // A branch is a choice: only this node's successors remain available.
    // Leaving old siblings open lets a run revisit alternate paths for rewards.
    for (var i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      nodes[i] = node.copyWith(
        isAccessible:
            !node.isCompleted &&
            node.row == completedNode.row + 1 &&
            completedNode.connectedNodeIds.contains(node.id),
      );
    }

    // Reconstruct DungeonMap without currentNodeId (copyWith can't set null)
    _currentMap = DungeonMap(
      nodes: nodes,
      zone: _currentMap!.zone,
      seed: _currentMap!.seed,
      currentNodeId: null,
    );

    _nodesCompleted++;

    // Clear node-specific state
    _currentEvent = null;
    _shopCards = [];
    _shopRelics = [];

    // Check if the boss was defeated (row 5 node completed)
    if (completedNode.type == NodeType.boss) {
      endRun(victory: true);
      return;
    }

    _runPhase = RunPhase.exploring;
    _checkpoint();
    notifyListeners();
  }

  // ===========================================================================
  // Deck management
  // ===========================================================================

  /// Add a card to the current run deck.
  void addCardToDeck(CardData card) {
    _currentDeck.add(card);
    notifyListeners();
  }

  /// Remove a card from the deck by index.
  void removeCardFromDeck(int index) {
    if (index < 0 || index >= _currentDeck.length) return;
    _currentDeck.removeAt(index);
    notifyListeners();
  }

  /// Upgrade a card at the given index. If the card has an [upgradeId],
  /// marks it as upgraded and appends "+" to the name.
  void upgradeCard(int index) {
    if (index < 0 || index >= _currentDeck.length) return;
    final card = _currentDeck[index];
    if (card.isUpgraded) return; // Already upgraded

    _currentDeck[index] = card.copyWith(
      isUpgraded: true,
      name: '${card.name}+',
      // Upgrade all effects: +25% value (minimum +1)
      effects: card.effects.map((e) {
        final bonus = (e.value * 0.25).ceil().clamp(1, 999);
        return e.copyWith(value: e.value + bonus);
      }).toList(),
    );
    notifyListeners();
  }

  // ===========================================================================
  // Relic management
  // ===========================================================================

  /// Add a relic to the current run.
  void addRelic(RelicData relic) {
    _currentRelics.add(relic);
    // 에너지 관련 렐릭이면 즉시 반영
    _maxEnergy = _computeMaxEnergy();
    notifyListeners();
  }

  /// 현재 보유 렐릭에서 최대 EP를 계산한다.
  /// 기본값 3에서 에너지 증가 렐릭을 모두 합산한다.
  int _computeMaxEnergy() {
    int energy = 3;
    for (final relic in _currentRelics) {
      switch (relic.id) {
        case 'relic_r04': // 각성의 오브: 에너지 최대 +1
          energy += 1;
          break;
        case 'relic_b01': // 왕관: 에너지 최대 +1 (저주는 startCombat 시 처리)
          energy += 1;
          break;
      }
    }
    return energy;
  }

  // ===========================================================================
  // Economy & HP
  // ===========================================================================

  /// Spend gold. Returns false if insufficient funds.
  bool spendGold(int amount) {
    if (amount <= 0) return false;
    if (_dungeonGold < amount) return false;
    _dungeonGold -= amount;
    notifyListeners();
    return true;
  }

  /// Add gold to the dungeon run.
  void addGold(int amount) {
    if (amount <= 0) return;
    _dungeonGold += amount;
    notifyListeners();
  }

  /// Set the player's HP directly (used to sync HP after a battle).
  void setPlayerHp(int hp) {
    _playerHp = hp.clamp(0, _playerMaxHp);
    notifyListeners();
  }

  /// Heal the player by a flat amount. Capped at max HP.
  void healPlayer(int amount) {
    if (amount <= 0) return;
    _playerHp = (_playerHp + amount).clamp(0, _playerMaxHp);
    notifyListeners();
  }

  /// Heal the player by a percentage of max HP.
  void healPlayerPercent(double percent) {
    if (percent <= 0) return;
    final amount = (_playerMaxHp * percent).round();
    _playerHp = (_playerHp + amount).clamp(0, _playerMaxHp);
    notifyListeners();
  }

  /// Damage the player. If HP reaches 0, the run fails.
  void damagePlayer(int amount) {
    if (amount <= 0) return;
    _playerHp = (_playerHp - amount).clamp(0, _playerMaxHp);
    if (_playerHp <= 0) {
      endRun(victory: false);
      return;
    }
    notifyListeners();
  }

  /// Increment the monsters killed counter.
  void incrementMonstersKilled([int count = 1]) {
    _monstersKilled += count;
  }

  // ===========================================================================
  // Run lifecycle
  // ===========================================================================

  /// Calculate rewards for the completed/failed run.
  Map<String, dynamic> calculateRunRewards() {
    final isVictory = _runPhase == RunPhase.completed;
    final zoneXp = isVictory ? _currentZone * 50 : 0;
    final zoneGold = isVictory ? _currentZone * 30 : 0;
    final baseXp = zoneXp + (_monstersKilled * 20) + (_nodesCompleted * 10);
    final baseGold = zoneGold + (_monstersKilled * 15);
    final multiplier = isVictory ? 1.5 : 0.5;

    // Boss kill bonus
    final bossBonus = isVictory ? 100 : 0;

    return {
      'xp': (baseXp * multiplier).round() + bossBonus,
      'gold': (baseGold * multiplier).round(),
      'monstersKilled': _monstersKilled,
      'nodesCompleted': _nodesCompleted,
      'zone': _currentZone,
      'isVictory': isVictory,
    };
  }

  /// End the current run with a victory or defeat result.
  void endRun({required bool victory}) {
    if (!isRunActive) return;
    _runPhase = victory ? RunPhase.completed : RunPhase.failed;
    _checkpoint();
    notifyListeners();
  }

  /// Fully reset state for a new run.
  void resetRun() {
    _clearRun();
    _checkpoint();
    notifyListeners();
  }

  void _clearRun() {
    _runId = null;
    _towerFloor = null;
    _runPhase = RunPhase.notStarted;
    _currentMap = null;
    _currentZone = 1;
    _ascensionLevel = 0;
    _towerStatMult = 1.0;
    _currentDeck = [];
    _currentRelics = [];
    _dungeonGold = 0;
    _playerHp = 80;
    _playerMaxHp = 80;
    _maxEnergy = 3;
    _dailyModifier = const DailyModifier();
    _nodesCompleted = 0;
    _monstersKilled = 0;
    _currentEvent = null;
    _shopCards = [];
    _shopRelics = [];
  }

  // ===========================================================================
  // Persistence (save/load mid-run)
  // ===========================================================================

  /// Serialize the entire dungeon run state to JSON.
  Map<String, dynamic> toJson() {
    return {
      'version': 1,
      'runId': _runId,
      if (_towerFloor != null) 'towerFloor': _towerFloor,
      'towerStatMult': _towerStatMult,
      'runPhase': _runPhase.name,
      if (_currentMap != null) 'currentMap': _currentMap!.toJson(),
      'currentZone': _currentZone,
      'ascensionLevel': _ascensionLevel,
      'currentDeck': _currentDeck.map((c) => c.toJson()).toList(),
      'currentRelics': _currentRelics.map((r) => r.toJson()).toList(),
      'dungeonGold': _dungeonGold,
      'playerHp': _playerHp,
      'playerMaxHp': _playerMaxHp,
      'maxEnergy': _maxEnergy,
      'dailyModifier': _dailyModifier.toJson(),
      'nodesCompleted': _nodesCompleted,
      'monstersKilled': _monstersKilled,
      if (_currentEvent != null) 'currentEvent': _currentEvent!.toJson(),
      'shopCards': _shopCards.map((c) => c.toJson()).toList(),
      'shopRelics': _shopRelics.map((r) => r.toJson()).toList(),
    };
  }

  /// Restore dungeon run state from JSON.
  void fromJson(Map<String, dynamic> json, {bool notify = true}) {
    if (json['version'] != 1 ||
        json['runId'] is! String ||
        (json['runId'] as String).isEmpty ||
        !RunPhase.values.any((p) => p.name == json['runPhase'])) {
      throw const FormatException('Invalid expedition checkpoint.');
    }
    _runId = json['runId'] as String;
    _towerFloor = json['towerFloor'] as int?;
    _towerStatMult = (json['towerStatMult'] as num? ?? 1).toDouble();
    _runPhase = RunPhase.values.firstWhere(
      (e) => e.name == json['runPhase'],
      orElse: () => RunPhase.notStarted,
    );

    if (json['currentMap'] != null) {
      _currentMap = DungeonMap.fromJson(
        json['currentMap'] as Map<String, dynamic>,
      );
    } else {
      _currentMap = null;
    }

    _currentZone = json['currentZone'] as int? ?? 1;
    _ascensionLevel = json['ascensionLevel'] as int? ?? 0;

    _currentDeck =
        (json['currentDeck'] as List<dynamic>?)
            ?.map((e) => CardData.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    _currentRelics =
        (json['currentRelics'] as List<dynamic>?)
            ?.map((e) => RelicData.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    _dungeonGold = json['dungeonGold'] as int? ?? 0;
    _playerHp = json['playerHp'] as int? ?? 80;
    _playerMaxHp = json['playerMaxHp'] as int? ?? 80;
    _maxEnergy = json['maxEnergy'] as int? ?? 3;
    _dailyModifier = DailyModifier.fromJson(
      json['dailyModifier'] as Map<String, dynamic>?,
    );
    _nodesCompleted = json['nodesCompleted'] as int? ?? 0;
    _monstersKilled = json['monstersKilled'] as int? ?? 0;
    _currentEvent = json['currentEvent'] == null
        ? null
        : DungeonEvent.fromJson(json['currentEvent'] as Map<String, dynamic>);
    _shopCards = (json['shopCards'] as List? ?? [])
        .map((e) => CardData.fromJson(e as Map<String, dynamic>))
        .toList();
    _shopRelics = (json['shopRelics'] as List? ?? [])
        .map((e) => RelicData.fromJson(e as Map<String, dynamic>))
        .toList();
    if (!hasRun ||
        _currentMap == null ||
        _currentZone < 1 ||
        _currentZone > 5 ||
        _playerMaxHp < 1 ||
        _playerHp < 0 ||
        _playerHp > _playerMaxHp ||
        _dungeonGold < 0 ||
        _nodesCompleted < 0 ||
        _monstersKilled < 0 ||
        !_towerStatMult.isFinite ||
        _towerStatMult < 1 ||
        (_towerFloor != null && _towerFloor! < 1) ||
        (_runPhase != RunPhase.exploring &&
            !hasResult &&
            currentNode == null) ||
        (_runPhase == RunPhase.inEvent && _currentEvent == null)) {
      throw const FormatException('Invalid expedition state.');
    }

    if (notify) notifyListeners();
  }

  @override
  void dispose() {
    unbindCheckpoint();
    super.dispose();
  }
}
