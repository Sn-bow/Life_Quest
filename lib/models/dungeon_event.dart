class EventOutcome {
  final String description;
  final int goldChange;
  final int hpChange;
  final double hpPercentChange;
  final bool cardReward;
  final bool relicReward;
  final bool curseAdded;
  final bool cardRemove;
  final bool cardUpgrade;

  const EventOutcome({
    required this.description,
    this.goldChange = 0,
    this.hpChange = 0,
    this.hpPercentChange = 0.0,
    this.cardReward = false,
    this.relicReward = false,
    this.curseAdded = false,
    this.cardRemove = false,
    this.cardUpgrade = false,
  });

  EventOutcome copyWith({
    String? description,
    int? goldChange,
    int? hpChange,
    double? hpPercentChange,
    bool? cardReward,
    bool? relicReward,
    bool? curseAdded,
    bool? cardRemove,
    bool? cardUpgrade,
  }) {
    return EventOutcome(
      description: description ?? this.description,
      goldChange: goldChange ?? this.goldChange,
      hpChange: hpChange ?? this.hpChange,
      hpPercentChange: hpPercentChange ?? this.hpPercentChange,
      cardReward: cardReward ?? this.cardReward,
      relicReward: relicReward ?? this.relicReward,
      curseAdded: curseAdded ?? this.curseAdded,
      cardRemove: cardRemove ?? this.cardRemove,
      cardUpgrade: cardUpgrade ?? this.cardUpgrade,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'goldChange': goldChange,
      'hpChange': hpChange,
      'hpPercentChange': hpPercentChange,
      'cardReward': cardReward,
      'relicReward': relicReward,
      'curseAdded': curseAdded,
      'cardRemove': cardRemove,
      'cardUpgrade': cardUpgrade,
    };
  }

  factory EventOutcome.fromJson(Map<String, dynamic> json) {
    return EventOutcome(
      description: json['description'] as String? ?? '',
      goldChange: json['goldChange'] as int? ?? 0,
      hpChange: json['hpChange'] as int? ?? 0,
      hpPercentChange: (json['hpPercentChange'] as num?)?.toDouble() ?? 0.0,
      cardReward: json['cardReward'] as bool? ?? false,
      relicReward: json['relicReward'] as bool? ?? false,
      curseAdded: json['curseAdded'] as bool? ?? false,
      cardRemove: json['cardRemove'] as bool? ?? false,
      cardUpgrade: json['cardUpgrade'] as bool? ?? false,
    );
  }
}

class EventChoice {
  final String text;
  final List<EventOutcome> outcomes;

  const EventChoice({
    required this.text,
    required this.outcomes,
  });

  EventChoice copyWith({
    String? text,
    List<EventOutcome>? outcomes,
  }) {
    return EventChoice(
      text: text ?? this.text,
      outcomes: outcomes ?? this.outcomes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'outcomes': outcomes.map((o) => o.toJson()).toList(),
    };
  }

  factory EventChoice.fromJson(Map<String, dynamic> json) {
    return EventChoice(
      text: json['text'] as String? ?? '',
      outcomes: (json['outcomes'] as List<dynamic>?)
              ?.map((e) => EventOutcome.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class DungeonEvent {
  final String id;
  final String name;
  final String description;
  final List<EventChoice> choices;
  final int? zoneRequirement;

  const DungeonEvent({
    required this.id,
    required this.name,
    required this.description,
    required this.choices,
    this.zoneRequirement,
  });

  DungeonEvent copyWith({
    String? id,
    String? name,
    String? description,
    List<EventChoice>? choices,
    int? zoneRequirement,
  }) {
    return DungeonEvent(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      choices: choices ?? this.choices,
      zoneRequirement: zoneRequirement ?? this.zoneRequirement,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'choices': choices.map((c) => c.toJson()).toList(),
      if (zoneRequirement != null) 'zoneRequirement': zoneRequirement,
    };
  }

  factory DungeonEvent.fromJson(Map<String, dynamic> json) {
    return DungeonEvent(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      choices: (json['choices'] as List<dynamic>?)
              ?.map((e) => EventChoice.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      zoneRequirement: json['zoneRequirement'] as int?,
    );
  }
}
