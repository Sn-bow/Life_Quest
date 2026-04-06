enum NodeType {
  combat,
  elite,
  event,
  shop,
  rest,
  boss,
}

class DungeonNode {
  final int id;
  final NodeType type;
  final int row;
  final int column;
  final List<int> connectedNodeIds;
  final bool isCompleted;
  final bool isAccessible;

  const DungeonNode({
    required this.id,
    required this.type,
    required this.row,
    required this.column,
    this.connectedNodeIds = const [],
    this.isCompleted = false,
    this.isAccessible = false,
  });

  DungeonNode copyWith({
    int? id,
    NodeType? type,
    int? row,
    int? column,
    List<int>? connectedNodeIds,
    bool? isCompleted,
    bool? isAccessible,
  }) {
    return DungeonNode(
      id: id ?? this.id,
      type: type ?? this.type,
      row: row ?? this.row,
      column: column ?? this.column,
      connectedNodeIds: connectedNodeIds ?? this.connectedNodeIds,
      isCompleted: isCompleted ?? this.isCompleted,
      isAccessible: isAccessible ?? this.isAccessible,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'row': row,
      'column': column,
      'connectedNodeIds': connectedNodeIds,
      'isCompleted': isCompleted,
      'isAccessible': isAccessible,
    };
  }

  factory DungeonNode.fromJson(Map<String, dynamic> json) {
    return DungeonNode(
      id: json['id'] as int? ?? 0,
      type: NodeType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NodeType.combat,
      ),
      row: json['row'] as int? ?? 0,
      column: json['column'] as int? ?? 0,
      connectedNodeIds: (json['connectedNodeIds'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      isCompleted: json['isCompleted'] as bool? ?? false,
      isAccessible: json['isAccessible'] as bool? ?? false,
    );
  }
}

class DungeonMap {
  final List<DungeonNode> nodes;
  final int zone;
  final int seed;
  final int? currentNodeId;

  const DungeonMap({
    required this.nodes,
    required this.zone,
    required this.seed,
    this.currentNodeId,
  });

  DungeonNode? get currentNode {
    if (currentNodeId == null) return null;
    try {
      return nodes.firstWhere((n) => n.id == currentNodeId);
    } catch (_) {
      return null;
    }
  }

  List<DungeonNode> get accessibleNodes =>
      nodes.where((n) => n.isAccessible && !n.isCompleted).toList();

  DungeonMap copyWith({
    List<DungeonNode>? nodes,
    int? zone,
    int? seed,
    int? currentNodeId,
  }) {
    return DungeonMap(
      nodes: nodes ?? this.nodes,
      zone: zone ?? this.zone,
      seed: seed ?? this.seed,
      currentNodeId: currentNodeId ?? this.currentNodeId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nodes': nodes.map((n) => n.toJson()).toList(),
      'zone': zone,
      'seed': seed,
      if (currentNodeId != null) 'currentNodeId': currentNodeId,
    };
  }

  factory DungeonMap.fromJson(Map<String, dynamic> json) {
    return DungeonMap(
      nodes: (json['nodes'] as List<dynamic>?)
              ?.map((e) => DungeonNode.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      zone: json['zone'] as int? ?? 1,
      seed: json['seed'] as int? ?? 0,
      currentNodeId: json['currentNodeId'] as int?,
    );
  }
}
