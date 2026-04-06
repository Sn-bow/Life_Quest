import 'dart:math';
import 'package:life_quest_final_v2/models/dungeon_map.dart';

/// Procedural dungeon map generator.
///
/// Generates a [DungeonMap] with 6 rows:
/// - Row 0 (start): 2 combat nodes
/// - Rows 1-4 (middle): 2-3 nodes each, random types with distribution
/// - Row 5 (boss): 1 boss node
class DungeonGenerator {
  /// Generate a dungeon map for a given [zone] and optional [seed].
  static DungeonMap generate({required int zone, int? seed}) {
    final actualSeed = seed ?? DateTime.now().millisecondsSinceEpoch;
    final random = Random(actualSeed);

    final List<List<DungeonNode>> rows = [];
    int nextId = 0;

    // --- Row 0: 2 combat nodes (start) ---
    rows.add([
      DungeonNode(
        id: nextId++,
        type: NodeType.combat,
        row: 0,
        column: 0,
        isAccessible: true,
      ),
      DungeonNode(
        id: nextId++,
        type: NodeType.combat,
        row: 0,
        column: 1,
        isAccessible: true,
      ),
    ]);

    // --- Rows 1-4: middle rows ---
    final middleRows = <List<DungeonNode>>[];
    int eliteCount = 0;
    bool hasShop = false;
    bool hasRest = false;

    for (int r = 1; r <= 4; r++) {
      final nodeCount = 2 + random.nextInt(2); // 2 or 3
      final rowNodes = <DungeonNode>[];

      for (int c = 0; c < nodeCount; c++) {
        final type = _rollNodeType(
          random,
          eliteCount: eliteCount,
          isLastMiddleRow: r == 4,
          needShop: !hasShop && r >= 3,
          needRest: !hasRest && r >= 3,
          forcedColumn: c,
          totalColumns: nodeCount,
        );

        if (type == NodeType.elite) eliteCount++;
        if (type == NodeType.shop) hasShop = true;
        if (type == NodeType.rest) hasRest = true;

        rowNodes.add(DungeonNode(
          id: nextId++,
          type: type,
          row: r,
          column: c,
        ));
      }

      middleRows.add(rowNodes);
    }

    // Guarantee at least 1 shop and 1 rest if not yet placed.
    if (!hasShop || !hasRest) {
      _guaranteeNodeTypes(middleRows, hasShop: hasShop, hasRest: hasRest);
    }

    rows.addAll(middleRows);

    // --- Row 5: boss ---
    rows.add([
      DungeonNode(
        id: nextId++,
        type: NodeType.boss,
        row: 5,
        column: 0,
      ),
    ]);

    // --- Build connections (row N -> row N+1, 1-2 connections each) ---
    final allNodes = <DungeonNode>[];
    for (int r = 0; r < rows.length - 1; r++) {
      final currentRow = rows[r];
      final nextRow = rows[r + 1];

      for (int i = 0; i < currentRow.length; i++) {
        final connections = <int>[];

        if (nextRow.length == 1) {
          // Boss row or single node: everyone connects to it
          connections.add(nextRow[0].id);
        } else {
          // Connect to the nearest node(s) in the next row.
          // Each node connects to 1-2 nodes in the next row.
          final primaryIndex = _mapColumnIndex(
            i,
            currentRow.length,
            nextRow.length,
          );
          connections.add(nextRow[primaryIndex].id);

          // Possibly add a second connection
          if (random.nextDouble() < 0.5) {
            final secondIndex = primaryIndex + (random.nextBool() ? 1 : -1);
            if (secondIndex >= 0 &&
                secondIndex < nextRow.length &&
                secondIndex != primaryIndex) {
              connections.add(nextRow[secondIndex].id);
            }
          }
        }

        // Replace the node with one that has connections
        rows[r][i] = currentRow[i].copyWith(connectedNodeIds: connections);
      }
    }

    // Ensure every node in rows 1-5 is reachable from at least one parent.
    // If a node in the next row is not targeted by any node in the current row,
    // connect it from the nearest current-row node.
    for (int r = 0; r < rows.length - 1; r++) {
      final nextRow = rows[r + 1];
      for (int j = 0; j < nextRow.length; j++) {
        final targetId = nextRow[j].id;
        final hasParent = rows[r].any(
          (n) => n.connectedNodeIds.contains(targetId),
        );
        if (!hasParent) {
          // Connect from the closest node in the current row
          final parentIndex = _mapColumnIndex(
            j,
            nextRow.length,
            rows[r].length,
          );
          final parent = rows[r][parentIndex];
          rows[r][parentIndex] = parent.copyWith(
            connectedNodeIds: [...parent.connectedNodeIds, targetId],
          );
        }
      }
    }

    // Flatten all rows into a single list
    for (final row in rows) {
      allNodes.addAll(row);
    }

    return DungeonMap(
      nodes: allNodes,
      zone: zone,
      seed: actualSeed,
    );
  }

  /// Roll a random node type with weighted distribution.
  /// Combat: 40%, Event: 20%, Shop: 15%, Elite: 10%, Rest: 15%
  static NodeType _rollNodeType(
    Random random, {
    required int eliteCount,
    required bool isLastMiddleRow,
    required bool needShop,
    required bool needRest,
    required int forcedColumn,
    required int totalColumns,
  }) {
    // Force shop or rest if we're running out of rows to guarantee them.
    if (needShop && isLastMiddleRow && forcedColumn == 0) {
      return NodeType.shop;
    }
    if (needRest && isLastMiddleRow && forcedColumn == totalColumns - 1) {
      return NodeType.rest;
    }

    final roll = random.nextInt(100);

    if (roll < 40) {
      return NodeType.combat;
    } else if (roll < 60) {
      return NodeType.event;
    } else if (roll < 75) {
      return NodeType.shop;
    } else if (roll < 85) {
      // Elite: max 2 total
      if (eliteCount >= 2) return NodeType.combat;
      return NodeType.elite;
    } else {
      return NodeType.rest;
    }
  }

  /// Ensure at least one shop and one rest exist in the middle rows.
  /// Replaces a combat node if needed.
  static void _guaranteeNodeTypes(
    List<List<DungeonNode>> middleRows, {
    required bool hasShop,
    required bool hasRest,
  }) {
    if (!hasShop) {
      _replaceFirstCombatWith(middleRows, NodeType.shop);
    }
    if (!hasRest) {
      _replaceFirstCombatWith(middleRows, NodeType.rest);
    }
  }

  /// Replace the first combat node found (searching from the end) with [type].
  static void _replaceFirstCombatWith(
    List<List<DungeonNode>> middleRows,
    NodeType type,
  ) {
    for (int r = middleRows.length - 1; r >= 0; r--) {
      for (int c = middleRows[r].length - 1; c >= 0; c--) {
        if (middleRows[r][c].type == NodeType.combat) {
          middleRows[r][c] = middleRows[r][c].copyWith(type: type);
          return;
        }
      }
    }
  }

  /// Map a column index from one row width to another.
  /// Ensures evenly distributed mapping between rows of different sizes.
  static int _mapColumnIndex(int index, int fromSize, int toSize) {
    if (fromSize == toSize) return index.clamp(0, toSize - 1);
    if (toSize == 1) return 0;
    if (fromSize <= 1) return 0;
    final ratio = index / (fromSize - 1);
    return (ratio * (toSize - 1)).round().clamp(0, toSize - 1);
  }
}
