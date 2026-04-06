enum StatusType {
  vulnerable,
  weak,
  poison,
  burn,
  freeze,
  strength,
  dexterity,
  thorns,
  regen,
  focus,
  fortify,
}

class StatusEffect {
  final StatusType type;
  final int stacks;
  final int duration;

  const StatusEffect({
    required this.type,
    this.stacks = 1,
    this.duration = -1,
  });

  bool get isDebuff =>
      type == StatusType.vulnerable ||
      type == StatusType.weak ||
      type == StatusType.poison ||
      type == StatusType.burn ||
      type == StatusType.freeze;

  bool get isBuff =>
      type == StatusType.strength ||
      type == StatusType.dexterity ||
      type == StatusType.thorns ||
      type == StatusType.regen ||
      type == StatusType.focus ||
      type == StatusType.fortify;

  bool get isPermanent => duration == -1;

  StatusEffect copyWith({
    StatusType? type,
    int? stacks,
    int? duration,
  }) {
    return StatusEffect(
      type: type ?? this.type,
      stacks: stacks ?? this.stacks,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'stacks': stacks,
      'duration': duration,
    };
  }

  factory StatusEffect.fromJson(Map<String, dynamic> json) {
    return StatusEffect(
      type: StatusType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => StatusType.vulnerable,
      ),
      stacks: json['stacks'] as int? ?? 1,
      duration: json['duration'] as int? ?? -1,
    );
  }
}
