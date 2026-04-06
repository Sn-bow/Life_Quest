import 'package:life_quest_final_v2/models/item.dart';
import 'package:life_quest_final_v2/models/custom_reward.dart';

class Character {
  String name;
  String? photoUrl;
  int level;
  String title;
  double xp;
  double maxXp;
  double strength;
  double wisdom;
  double health;
  double charisma;
  int statPoints;
  int skillPoints;

  // Combat & RPG Elements
  int actionPoints;
  int maxActionPoints;
  List<EquipmentItem> inventory;
  EquipmentItem? equippedWeapon;
  EquipmentItem? equippedArmor;
  EquipmentItem? equippedAccessory;

  // Penalty & Streak
  int characterHp;
  int characterMaxHp;
  int streak;
  DateTime? lastLoginDate;
  DateTime? lastHpRegenAt;

  // Economy & Cosmetics
  int gold;
  List<String> unlockedCosmetics;
  List<CustomReward> customRewards;
  String? equippedTheme;
  String? equippedTitleEffect;
  String? equippedCombatEffect;

  // Dungeon Progression
  int highestDungeonFloor;
  int currentDungeonChapter;

  // Card Collection
  List<String> unlockedCardIds;
  List<String> starterDeckCardIds;

  // Growth & report progression
  Map<String, double> levelGrowthWeights;
  Map<String, int> lastLevelAutoGrowth;
  String? expandedReportUnlockedOn;
  int monthlyRaidClears;
  int yearlyRaidClears;

  Character({
    required this.name,
    this.photoUrl,
    required this.level,
    required this.title,
    required this.xp,
    required this.maxXp,
    required this.strength,
    required this.wisdom,
    required this.health,
    required this.charisma,
    required this.statPoints,
    required this.skillPoints,
    this.actionPoints = 10,
    this.maxActionPoints = 10,
    List<EquipmentItem>? inventory,
    this.equippedWeapon,
    this.equippedArmor,
    this.equippedAccessory,
    this.characterHp = 100,
    this.characterMaxHp = 100,
    this.streak = 0,
    this.lastLoginDate,
    this.lastHpRegenAt,
    this.gold = 0,
    List<String>? unlockedCosmetics,
    List<CustomReward>? customRewards,
    this.equippedTheme,
    this.equippedTitleEffect,
    this.equippedCombatEffect,
    this.highestDungeonFloor = 1,
    this.currentDungeonChapter = 1,
    List<String>? unlockedCardIds,
    List<String>? starterDeckCardIds,
    Map<String, double>? levelGrowthWeights,
    Map<String, int>? lastLevelAutoGrowth,
    this.expandedReportUnlockedOn,
    this.monthlyRaidClears = 0,
    this.yearlyRaidClears = 0,
  }) : inventory = inventory ?? [],
        unlockedCosmetics = unlockedCosmetics ?? [],
        customRewards = customRewards ?? [],
        unlockedCardIds = unlockedCardIds ?? [],
        starterDeckCardIds = starterDeckCardIds ?? [],
        levelGrowthWeights = levelGrowthWeights ?? {},
        lastLevelAutoGrowth = lastLevelAutoGrowth ?? {};

  factory Character.fromJson(Map<String, dynamic> json) {
    final level = json['level'] ?? 1;
    return Character(
      name: json['name'] ?? '모험가',
      photoUrl: json['photoUrl'],
      level: level,
      title: json['title'] ?? '새싹 모험가',
      xp: (json['xp'] ?? 0).toDouble(),
      maxXp: (json['maxXp'] ?? (100.0 + (level * 50.0))).toDouble(),
      strength: (json['strength'] ?? 0).toDouble(),
      wisdom: (json['wisdom'] ?? 0).toDouble(),
      health: (json['health'] ?? 0).toDouble(),
      charisma: (json['charisma'] ?? 0).toDouble(),
      statPoints: json['statPoints'] ?? 0,
      skillPoints: json['skillPoints'] ?? 0,
      actionPoints: json['actionPoints'] ?? 10,
      maxActionPoints: json['maxActionPoints'] ?? 10,
      inventory: (json['inventory'] as List<dynamic>?)
              ?.map((e) => EquipmentItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      equippedWeapon: json['equippedWeapon'] is Map
          ? EquipmentItem.fromJson(
              Map<String, dynamic>.from(json['equippedWeapon'] as Map))
          : null,
      equippedArmor: json['equippedArmor'] is Map
          ? EquipmentItem.fromJson(
              Map<String, dynamic>.from(json['equippedArmor'] as Map))
          : null,
      equippedAccessory: json['equippedAccessory'] is Map
          ? EquipmentItem.fromJson(
              Map<String, dynamic>.from(json['equippedAccessory'] as Map))
          : null,
      characterHp: json['characterHp'] ?? 100,
      characterMaxHp: json['characterMaxHp'] ?? 100,
      streak: json['streak'] ?? 0,
      lastLoginDate: json['lastLoginDate'] != null
          ? DateTime.parse(json['lastLoginDate'])
          : null,
      lastHpRegenAt: json['lastHpRegenAt'] != null
          ? DateTime.tryParse(json['lastHpRegenAt'])
          : null,
      gold: json['gold'] ?? 0,
      unlockedCosmetics: (json['unlockedCosmetics'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      customRewards: (json['customRewards'] as List<dynamic>?)
              ?.map((e) => CustomReward.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      equippedTheme: json['equippedTheme'],
      equippedTitleEffect: json['equippedTitleEffect'],
      equippedCombatEffect: json['equippedCombatEffect'],
      highestDungeonFloor: json['highestDungeonFloor'] ?? 1,
      currentDungeonChapter: json['currentDungeonChapter'] ?? 1,
      unlockedCardIds: (json['unlockedCardIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      starterDeckCardIds: (json['starterDeckCardIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      levelGrowthWeights: (json['levelGrowthWeights'] as Map<dynamic, dynamic>?)
              ?.map((key, value) => MapEntry(
                    key.toString(),
                    (value as num).toDouble(),
                  )) ??
          {},
      lastLevelAutoGrowth:
          (json['lastLevelAutoGrowth'] as Map<dynamic, dynamic>?)?.map(
                (key, value) => MapEntry(key.toString(), value as int),
              ) ??
              {},
      expandedReportUnlockedOn: json['expandedReportUnlockedOn'] as String?,
      monthlyRaidClears: json['monthlyRaidClears'] ?? 0,
      yearlyRaidClears: json['yearlyRaidClears'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'photoUrl': photoUrl,
      'level': level,
      'title': title,
      'xp': xp,
      'maxXp': maxXp,
      'strength': strength,
      'wisdom': wisdom,
      'health': health,
      'charisma': charisma,
      'statPoints': statPoints,
      'skillPoints': skillPoints,
      'actionPoints': actionPoints,
      'maxActionPoints': maxActionPoints,
      'inventory': inventory.map((e) => e.toJson()).toList(),
      'equippedWeapon': equippedWeapon?.toJson(),
      'equippedArmor': equippedArmor?.toJson(),
      'equippedAccessory': equippedAccessory?.toJson(),
      'characterHp': characterHp,
      'characterMaxHp': characterMaxHp,
      'streak': streak,
      'lastLoginDate': lastLoginDate?.toIso8601String(),
      'lastHpRegenAt': lastHpRegenAt?.toIso8601String(),
      'gold': gold,
      'unlockedCosmetics': unlockedCosmetics,
      'customRewards': customRewards.map((e) => e.toJson()).toList(),
      'equippedTheme': equippedTheme,
      'equippedTitleEffect': equippedTitleEffect,
      'equippedCombatEffect': equippedCombatEffect,
      'highestDungeonFloor': highestDungeonFloor,
      'currentDungeonChapter': currentDungeonChapter,
      'unlockedCardIds': unlockedCardIds,
      'starterDeckCardIds': starterDeckCardIds,
      'levelGrowthWeights': levelGrowthWeights,
      'lastLevelAutoGrowth': lastLevelAutoGrowth,
      'expandedReportUnlockedOn': expandedReportUnlockedOn,
      'monthlyRaidClears': monthlyRaidClears,
      'yearlyRaidClears': yearlyRaidClears,
    };
  }
}


