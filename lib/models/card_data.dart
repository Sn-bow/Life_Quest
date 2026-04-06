import 'package:life_quest_final_v2/models/status_effect.dart';

enum CardCategory {
  attack,
  magic,
  defense,
  tactical,
}

enum CardRarity {
  common,
  uncommon,
  rare,
  legendary,
}

enum CardEffectType {
  damage,
  block,
  heal,
  drawCard,
  gainEnergy,
  applyBuff,
  applyDebuff,
  aoe,
  exhaust,
  retain,
  innate,
}

enum TargetType {
  self,
  enemy,
  allEnemies,
}

class CardEffect {
  final CardEffectType effectType;
  final int value;
  final int duration;
  final TargetType targetType;
  final StatusType? statusType;

  const CardEffect({
    required this.effectType,
    required this.value,
    this.duration = 0,
    this.targetType = TargetType.enemy,
    this.statusType,
  });

  CardEffect copyWith({
    CardEffectType? effectType,
    int? value,
    int? duration,
    TargetType? targetType,
    StatusType? statusType,
  }) {
    return CardEffect(
      effectType: effectType ?? this.effectType,
      value: value ?? this.value,
      duration: duration ?? this.duration,
      targetType: targetType ?? this.targetType,
      statusType: statusType ?? this.statusType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'effectType': effectType.name,
      'value': value,
      'duration': duration,
      'targetType': targetType.name,
      if (statusType != null) 'statusType': statusType!.name,
    };
  }

  factory CardEffect.fromJson(Map<String, dynamic> json) {
    return CardEffect(
      effectType: CardEffectType.values.firstWhere(
        (e) => e.name == json['effectType'],
        orElse: () => CardEffectType.damage,
      ),
      value: json['value'] as int? ?? 0,
      duration: json['duration'] as int? ?? 0,
      targetType: TargetType.values.firstWhere(
        (e) => e.name == json['targetType'],
        orElse: () => TargetType.enemy,
      ),
      statusType: json['statusType'] != null
          ? StatusType.values.firstWhere(
              (e) => e.name == json['statusType'],
              orElse: () => StatusType.vulnerable,
            )
          : null,
    );
  }
}

class CardData {
  final String id;
  final String name;
  final CardCategory category;
  final CardRarity rarity;
  final int cost;
  final String description;
  final List<CardEffect> effects;
  final String? upgradeId;
  final bool isUpgraded;
  final String spritePath;

  const CardData({
    required this.id,
    required this.name,
    required this.category,
    this.rarity = CardRarity.common,
    required this.cost,
    required this.description,
    required this.effects,
    this.upgradeId,
    this.isUpgraded = false,
    this.spritePath = '',
  });

  bool get isAttack => category == CardCategory.attack;
  bool get isMagic => category == CardCategory.magic;
  bool get isDefense => category == CardCategory.defense;
  bool get isTactical => category == CardCategory.tactical;

  CardData copyWith({
    String? id,
    String? name,
    CardCategory? category,
    CardRarity? rarity,
    int? cost,
    String? description,
    List<CardEffect>? effects,
    String? upgradeId,
    bool? isUpgraded,
    String? spritePath,
  }) {
    return CardData(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      rarity: rarity ?? this.rarity,
      cost: cost ?? this.cost,
      description: description ?? this.description,
      effects: effects ?? this.effects,
      upgradeId: upgradeId ?? this.upgradeId,
      isUpgraded: isUpgraded ?? this.isUpgraded,
      spritePath: spritePath ?? this.spritePath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.name,
      'rarity': rarity.name,
      'cost': cost,
      'description': description,
      'effects': effects.map((e) => e.toJson()).toList(),
      if (upgradeId != null) 'upgradeId': upgradeId,
      'isUpgraded': isUpgraded,
      'spritePath': spritePath,
    };
  }

  factory CardData.fromJson(Map<String, dynamic> json) {
    return CardData(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: CardCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => CardCategory.attack,
      ),
      rarity: CardRarity.values.firstWhere(
        (e) => e.name == json['rarity'],
        orElse: () => CardRarity.common,
      ),
      cost: json['cost'] as int? ?? 1,
      description: json['description'] as String? ?? '',
      effects: (json['effects'] as List<dynamic>?)
              ?.map((e) => CardEffect.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      upgradeId: json['upgradeId'] as String?,
      isUpgraded: json['isUpgraded'] as bool? ?? false,
      spritePath: json['spritePath'] as String? ?? '',
    );
  }
}
