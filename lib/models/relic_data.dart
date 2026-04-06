enum RelicRarity {
  common,
  uncommon,
  rare,
  boss,
  event,
  starter,
}

enum RelicTrigger {
  onTurnStart,
  onTurnEnd,
  onCardPlay,
  onAttack,
  onBlock,
  onEnemyKill,
  onCombatStart,
  passive,
}

class RelicData {
  final String id;
  final String name;
  final RelicRarity rarity;
  final String description;
  final RelicTrigger trigger;
  final String spritePath;

  const RelicData({
    required this.id,
    required this.name,
    required this.rarity,
    required this.description,
    required this.trigger,
    this.spritePath = '',
  });

  RelicData copyWith({
    String? id,
    String? name,
    RelicRarity? rarity,
    String? description,
    RelicTrigger? trigger,
    String? spritePath,
  }) {
    return RelicData(
      id: id ?? this.id,
      name: name ?? this.name,
      rarity: rarity ?? this.rarity,
      description: description ?? this.description,
      trigger: trigger ?? this.trigger,
      spritePath: spritePath ?? this.spritePath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rarity': rarity.name,
      'description': description,
      'trigger': trigger.name,
      'spritePath': spritePath,
    };
  }

  factory RelicData.fromJson(Map<String, dynamic> json) {
    return RelicData(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      rarity: RelicRarity.values.firstWhere(
        (e) => e.name == json['rarity'],
        orElse: () => RelicRarity.common,
      ),
      description: json['description'] as String? ?? '',
      trigger: RelicTrigger.values.firstWhere(
        (e) => e.name == json['trigger'],
        orElse: () => RelicTrigger.passive,
      ),
      spritePath: json['spritePath'] as String? ?? '',
    );
  }
}
