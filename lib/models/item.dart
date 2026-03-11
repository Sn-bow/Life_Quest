enum ItemType {
  weapon,
  armor,
  accessory,
  consumable,
}

enum ItemRarity {
  common,
  uncommon,
  rare,
  epic,
  legendary,
}

class EquipmentItem {
  final String id;
  final String name;
  final String description;
  final ItemType type;
  final ItemRarity rarity;

  // Stat Boosts
  final double bonusStrength;
  final double bonusWisdom;
  final double bonusHealth;
  final double bonusCharisma;

  // Combat Specific
  final double attackPower;
  final double defensePower;

  final String spritePath;

  EquipmentItem({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.rarity = ItemRarity.common,
    this.bonusStrength = 0,
    this.bonusWisdom = 0,
    this.bonusHealth = 0,
    this.bonusCharisma = 0,
    this.attackPower = 0,
    this.defensePower = 0,
    this.spritePath = '',
  });

  factory EquipmentItem.fromJson(Map<String, dynamic> json) {
    return EquipmentItem(
      id: json['id'] ?? 'unknown_${DateTime.now().millisecondsSinceEpoch}',
      name: json['name'] ?? '알 수 없는 아이템',
      description: json['description'] ?? '',
      type: ItemType.values.firstWhere(
          (e) => e.toString() == 'ItemType.${json['type']}',
          orElse: () => ItemType.consumable),
      rarity: ItemRarity.values.firstWhere(
          (e) => e.toString() == 'ItemRarity.${json['rarity']}',
          orElse: () => ItemRarity.common),
      bonusStrength: (json['bonusStrength'] ?? 0).toDouble(),
      bonusWisdom: (json['bonusWisdom'] ?? 0).toDouble(),
      bonusHealth: (json['bonusHealth'] ?? 0).toDouble(),
      bonusCharisma: (json['bonusCharisma'] ?? 0).toDouble(),
      attackPower: (json['attackPower'] ?? 0).toDouble(),
      defensePower: (json['defensePower'] ?? 0).toDouble(),
      spritePath: json['spritePath'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.name,
      'rarity': rarity.name,
      'bonusStrength': bonusStrength,
      'bonusWisdom': bonusWisdom,
      'bonusHealth': bonusHealth,
      'bonusCharisma': bonusCharisma,
      'attackPower': attackPower,
      'defensePower': defensePower,
      'spritePath': spritePath,
    };
  }
}
