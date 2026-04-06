import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:life_quest_final_v2/data/card_database.dart';
import 'package:life_quest_final_v2/data/dungeon_generator.dart';
import 'package:life_quest_final_v2/data/event_database.dart';
import 'package:life_quest_final_v2/data/monster_database.dart';
import 'package:life_quest_final_v2/data/relic_database.dart';
import 'package:life_quest_final_v2/models/dungeon_event.dart';
import 'package:life_quest_final_v2/models/dungeon_map.dart';
import 'package:life_quest_final_v2/models/card_data.dart';
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
  void startRun({
    required int zone,
    required List<CardData> startingDeck,
    required int playerMaxHp,
    int ascension = 0,
    RelicData? starterRelic,
    int startingGold = 50,
    double towerStatMult = 1.0,
  }) {
    _currentZone = zone;
    _ascensionLevel = ascension;
    _towerStatMult = towerStatMult;

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
    _dungeonGold = adjustedGold;

    _playerMaxHp = playerMaxHp;
    _playerHp = playerMaxHp;
    _maxEnergy = 3;

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
    notifyListeners();
  }

  /// Select a node to visit. The node must be accessible and not completed.
  void selectNode(int nodeId) {
    if (_currentMap == null) return;
    if (_runPhase != RunPhase.exploring) return;

    final nodes = _currentMap!.nodes;
    final nodeIndex = nodes.indexWhere((n) => n.id == nodeId);
    if (nodeIndex < 0) return;

    final node = nodes[nodeIndex];
    if (!node.isAccessible || node.isCompleted) return;

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

    notifyListeners();
  }

  /// Build a list of [EnemyBattleData] appropriate for the given [node].
  List<EnemyBattleData> getEnemiesForNode(DungeonNode node) {
    final rng = Random();
    final monsters = MonsterDatabase.getMonstersByZone(_currentZone);
    if (monsters.isEmpty) return [];

    // Ascension HP/ATK multipliers
    // Lv1: +10% HP, Lv2: +10% ATK, Lv8: boss +25% HP, Lv10: +20% HP all
    // _towerStatMult adds extra scaling per Infinite Tower floor
    final hpMult = (1.0 +
            (_ascensionLevel >= 1 ? 0.1 : 0.0) +
            (_ascensionLevel >= 10 ? 0.2 : 0.0)) *
        _towerStatMult;
    final atkMult =
        (1.0 + (_ascensionLevel >= 2 ? 0.1 : 0.0)) * _towerStatMult;
    final bossHpMult = hpMult + (_ascensionLevel >= 8 ? 0.25 : 0.0);

    switch (node.type) {
      case NodeType.combat:
        final monster = monsters[rng.nextInt(monsters.length)];
        return [
          EnemyBattleData.fromMonster(
            monster.copyWith(
              maxHp: (monster.maxHp * hpMult).round(),
              attack: (monster.attack * atkMult).round(),
            ),
          ),
        ];

      case NodeType.elite:
        // 1 stronger enemy (pick highest-level in zone, buff stats)
        final eliteBase = List.of(monsters)
          ..sort((a, b) => b.level.compareTo(a.level));
        final elite = eliteBase.first;
        return [
          EnemyBattleData.fromMonster(
            elite.copyWith(
              maxHp: (elite.maxHp * 1.5 * hpMult).round(),
              attack: (elite.attack * 1.3 * atkMult).round(),
              defense: (elite.defense * 1.2).round(),
              xpReward: (elite.xpReward * 1.5).round(),
            ),
          ),
        ];

      case NodeType.boss:
        // Pick the zone boss, apply boss HP multiplier (Lv8: +25%)
        final bosses = MonsterDatabase.getBossMonsters();
        final bossIndex = (_currentZone - 1).clamp(0, bosses.length - 1);
        final boss = bosses[bossIndex];
        return [
          EnemyBattleData.fromMonster(
            boss.copyWith(
              maxHp: (boss.maxHp * bossHpMult).round(),
              attack: (boss.attack * atkMult).round(),
            ),
          ),
        ];

      default:
        return [];
    }
  }

  /// Generate random shop inventory (cards + relics).
  void _generateShopInventory() {
    // 3 random cards from uncommon+ pool
    final allCards = CardDatabase.allCards
        .where((c) =>
            c.rarity != CardRarity.common && c.rarity != CardRarity.legendary)
        .toList();
    allCards.shuffle();
    _shopCards = allCards.take(3).toList();

    // Also sometimes include a rare/legendary
    final rarePool = CardDatabase.allCards
        .where((c) => c.rarity == CardRarity.rare || c.rarity == CardRarity.legendary)
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
    if (_currentMap == null) return;
    final currentNodeId = _currentMap!.currentNodeId;
    if (currentNodeId == null) return;

    final nodes = List<DungeonNode>.from(_currentMap!.nodes);
    final nodeIndex = nodes.indexWhere((n) => n.id == currentNodeId);
    if (nodeIndex < 0) return;

    final completedNode = nodes[nodeIndex];

    // Mark current node as completed
    nodes[nodeIndex] = completedNode.copyWith(
      isCompleted: true,
      isAccessible: false,
    );

    // Make connected nodes in the next row accessible
    for (final connectedId in completedNode.connectedNodeIds) {
      final connectedIndex = nodes.indexWhere((n) => n.id == connectedId);
      if (connectedIndex >= 0 && !nodes[connectedIndex].isCompleted) {
        nodes[connectedIndex] = nodes[connectedIndex].copyWith(
          isAccessible: true,
        );
      }
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
    notifyListeners();
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
    final baseXp = (_currentZone * 50) + (_monstersKilled * 20) + (_nodesCompleted * 10);
    final baseGold = (_currentZone * 30) + (_monstersKilled * 15);
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
    _runPhase = victory ? RunPhase.completed : RunPhase.failed;
    notifyListeners();
  }

  /// Fully reset state for a new run.
  void resetRun() {
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
    _nodesCompleted = 0;
    _monstersKilled = 0;
    _currentEvent = null;
    _shopCards = [];
    _shopRelics = [];
    notifyListeners();
  }

  // ===========================================================================
  // Persistence (save/load mid-run)
  // ===========================================================================

  /// Serialize the entire dungeon run state to JSON.
  Map<String, dynamic> toJson() {
    return {
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
      'nodesCompleted': _nodesCompleted,
      'monstersKilled': _monstersKilled,
    };
  }

  /// Restore dungeon run state from JSON.
  void fromJson(Map<String, dynamic> json) {
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

    _currentDeck = (json['currentDeck'] as List<dynamic>?)
            ?.map((e) => CardData.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    _currentRelics = (json['currentRelics'] as List<dynamic>?)
            ?.map((e) => RelicData.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    _dungeonGold = json['dungeonGold'] as int? ?? 0;
    _playerHp = json['playerHp'] as int? ?? 80;
    _playerMaxHp = json['playerMaxHp'] as int? ?? 80;
    _maxEnergy = json['maxEnergy'] as int? ?? 3;
    _nodesCompleted = json['nodesCompleted'] as int? ?? 0;
    _monstersKilled = json['monstersKilled'] as int? ?? 0;

    notifyListeners();
  }
}
