class Monster {
  final String id;
  final String name;
  final int level;
  final double maxHp;
  double currentHp;
  final double attack;
  final double defense;
  final int xpReward;
  final String spritePath; // Path to pixel art asset

  Monster({
    required this.id,
    required this.name,
    required this.level,
    required this.maxHp,
    required this.attack,
    required this.defense,
    required this.xpReward,
    this.spritePath = '',
  }) : currentHp = maxHp;

  // For deep copying when spawning a new instance
  Monster copyWith({
    String? id,
    String? name,
    int? level,
    double? maxHp,
    double? currentHp,
    double? attack,
    double? defense,
    int? xpReward,
    String? spritePath,
  }) {
    return Monster(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      maxHp: maxHp ?? this.maxHp,
      attack: attack ?? this.attack,
      defense: defense ?? this.defense,
      xpReward: xpReward ?? this.xpReward,
      spritePath: spritePath ?? this.spritePath,
    )..currentHp = currentHp ?? this.currentHp;
  }
}
