import 'dart:math';
import 'package:life_quest_final_v2/models/item.dart';
import 'package:life_quest_final_v2/models/monster.dart';

/// Generates random loot drops based on monster level and rarity rolls.
class LootTable {
  static final _random = Random();

  /// All possible equipment items in the game
  static final List<EquipmentItem> _allItems = [
    // ==========================================
    // WEAPONS (14개)
    // ==========================================
    // Common
    EquipmentItem(
        id: 'w_wooden_sword',
        name: '나무 검',
        description: '초보자의 검',
        type: ItemType.weapon,
        rarity: ItemRarity.common,
        attackPower: 3),
    EquipmentItem(
        id: 'w_wooden_staff',
        name: '나무 지팡이',
        description: '초보 마법사의 지팡이',
        type: ItemType.weapon,
        rarity: ItemRarity.common,
        attackPower: 2,
        bonusWisdom: 2),
    EquipmentItem(
        id: 'w_short_bow',
        name: '단궁',
        description: '가벼운 활',
        type: ItemType.weapon,
        rarity: ItemRarity.common,
        attackPower: 3),

    // Uncommon
    EquipmentItem(
        id: 'w_iron_sword',
        name: '철 검',
        description: '단단한 철로 만든 검',
        type: ItemType.weapon,
        rarity: ItemRarity.uncommon,
        attackPower: 7),
    EquipmentItem(
        id: 'w_iron_mace',
        name: '철 메이스',
        description: '묵직한 한 방',
        type: ItemType.weapon,
        rarity: ItemRarity.uncommon,
        attackPower: 8,
        bonusStrength: 2),
    EquipmentItem(
        id: 'w_hunting_bow',
        name: '사냥꾼의 활',
        description: '정밀하게 제작된 활',
        type: ItemType.weapon,
        rarity: ItemRarity.uncommon,
        attackPower: 6,
        bonusWisdom: 3),

    // Rare
    EquipmentItem(
        id: 'w_fire_blade',
        name: '화염 검',
        description: '불꽃이 타오르는 검',
        type: ItemType.weapon,
        rarity: ItemRarity.rare,
        attackPower: 15,
        bonusStrength: 3),
    EquipmentItem(
        id: 'w_shadow_dagger',
        name: '그림자 단검',
        description: '어둠의 힘이 깃든 단검',
        type: ItemType.weapon,
        rarity: ItemRarity.rare,
        attackPower: 12,
        bonusWisdom: 5),
    EquipmentItem(
        id: 'w_frost_staff',
        name: '서리 지팡이',
        description: '차가운 냉기가 감도는 지팡이',
        type: ItemType.weapon,
        rarity: ItemRarity.rare,
        attackPower: 10,
        bonusWisdom: 8),
    EquipmentItem(
        id: 'w_poison_spear',
        name: '독의 창',
        description: '맹독이 스며든 창',
        type: ItemType.weapon,
        rarity: ItemRarity.rare,
        attackPower: 14,
        bonusHealth: 3),

    // Epic
    EquipmentItem(
        id: 'w_legendary_axe',
        name: '영웅의 도끼',
        description: '전설에 남을 무기',
        type: ItemType.weapon,
        rarity: ItemRarity.epic,
        attackPower: 25,
        bonusStrength: 8),
    EquipmentItem(
        id: 'w_arcane_wand',
        name: '비전 마법봉',
        description: '순수한 마력이 응축된 봉',
        type: ItemType.weapon,
        rarity: ItemRarity.epic,
        attackPower: 20,
        bonusWisdom: 12),
    EquipmentItem(
        id: 'w_thunder_hammer',
        name: '번개 해머',
        description: '천둥의 힘을 담은 해머',
        type: ItemType.weapon,
        rarity: ItemRarity.epic,
        attackPower: 28,
        bonusStrength: 5,
        bonusHealth: 5),

    // Legendary
    EquipmentItem(
        id: 'w_excalibur',
        name: '엑스칼리버',
        description: '왕 중의 왕만이 쥘 수 있는 검',
        type: ItemType.weapon,
        rarity: ItemRarity.legendary,
        attackPower: 50,
        bonusStrength: 15,
        bonusWisdom: 10),
    EquipmentItem(
        id: 'w_ragnarok',
        name: '라그나로크',
        description: '세계를 멸하는 대검',
        type: ItemType.weapon,
        rarity: ItemRarity.legendary,
        attackPower: 60,
        bonusStrength: 20),
    EquipmentItem(
        id: 'w_staff_eternity',
        name: '영겁의 지팡이',
        description: '시간의 끝에서 온 마법 지팡이',
        type: ItemType.weapon,
        rarity: ItemRarity.legendary,
        attackPower: 40,
        bonusWisdom: 25,
        bonusCharisma: 10),

    // ==========================================
    // ARMOR (10개)
    // ==========================================
    // Common
    EquipmentItem(
        id: 'a_leather',
        name: '가죽 갑옷',
        description: '기본적인 방호구',
        type: ItemType.armor,
        rarity: ItemRarity.common,
        defensePower: 3),
    EquipmentItem(
        id: 'a_cloth_robe',
        name: '천 로브',
        description: '가벼운 마법사 로브',
        type: ItemType.armor,
        rarity: ItemRarity.common,
        defensePower: 1,
        bonusWisdom: 3),

    // Uncommon
    EquipmentItem(
        id: 'a_chain_mail',
        name: '체인 메일',
        description: '쇠사슬로 엮은 갑옷',
        type: ItemType.armor,
        rarity: ItemRarity.uncommon,
        defensePower: 7,
        bonusHealth: 3),
    EquipmentItem(
        id: 'a_ranger_vest',
        name: '레인저 조끼',
        description: '민첩한 움직임을 위한 경장갑',
        type: ItemType.armor,
        rarity: ItemRarity.uncommon,
        defensePower: 5,
        bonusStrength: 2,
        bonusHealth: 2),

    // Rare
    EquipmentItem(
        id: 'a_plate_armor',
        name: '판금 갑옷',
        description: '무거운 만큼 튼튼한 갑옷',
        type: ItemType.armor,
        rarity: ItemRarity.rare,
        defensePower: 15,
        bonusHealth: 8),
    EquipmentItem(
        id: 'a_mithril_mail',
        name: '미스릴 메일',
        description: '가볍고 견고한 미스릴 갑옷',
        type: ItemType.armor,
        rarity: ItemRarity.rare,
        defensePower: 12,
        bonusStrength: 3,
        bonusHealth: 5),
    EquipmentItem(
        id: 'a_wizard_robe',
        name: '대마법사의 로브',
        description: '마력이 깃든 고급 로브',
        type: ItemType.armor,
        rarity: ItemRarity.rare,
        defensePower: 8,
        bonusWisdom: 10),

    // Epic
    EquipmentItem(
        id: 'a_dragon_scale',
        name: '용비늘 갑옷',
        description: '드래곤의 비늘로 만든 전설의 갑옷',
        type: ItemType.armor,
        rarity: ItemRarity.epic,
        defensePower: 25,
        bonusHealth: 15),
    EquipmentItem(
        id: 'a_demon_plate',
        name: '마족 판금',
        description: '마계의 금속으로 단조된 갑옷',
        type: ItemType.armor,
        rarity: ItemRarity.epic,
        defensePower: 22,
        bonusStrength: 8,
        bonusHealth: 10),

    // Legendary
    EquipmentItem(
        id: 'a_god_armor',
        name: '신의 갑옷',
        description: '신이 전사에게 내린 전설의 갑옷',
        type: ItemType.armor,
        rarity: ItemRarity.legendary,
        defensePower: 40,
        bonusHealth: 25,
        bonusStrength: 10),

    // ==========================================
    // ACCESSORIES (11개)
    // ==========================================
    // Uncommon
    EquipmentItem(
        id: 'acc_ring_str',
        name: '힘의 반지',
        description: '근력을 높여주는 마법 반지',
        type: ItemType.accessory,
        rarity: ItemRarity.uncommon,
        bonusStrength: 5),
    EquipmentItem(
        id: 'acc_ring_wis',
        name: '지혜의 반지',
        description: '지혜를 높여주는 마법 반지',
        type: ItemType.accessory,
        rarity: ItemRarity.uncommon,
        bonusWisdom: 5),
    EquipmentItem(
        id: 'acc_iron_bracelet',
        name: '강철 팔찌',
        description: '방어력을 올려주는 팔찌',
        type: ItemType.accessory,
        rarity: ItemRarity.uncommon,
        bonusHealth: 3,
        defensePower: 2),
    EquipmentItem(
        id: 'acc_lucky_charm',
        name: '행운의 부적',
        description: '약간의 행운을 불러오는 부적',
        type: ItemType.accessory,
        rarity: ItemRarity.uncommon,
        bonusCharisma: 4),

    // Rare
    EquipmentItem(
        id: 'acc_amulet_hp',
        name: '생명의 목걸이',
        description: '체력을 크게 높여주는 목걸이',
        type: ItemType.accessory,
        rarity: ItemRarity.rare,
        bonusHealth: 10),
    EquipmentItem(
        id: 'acc_warrior_earring',
        name: '전사의 귀걸이',
        description: '전투력을 올려주는 귀걸이',
        type: ItemType.accessory,
        rarity: ItemRarity.rare,
        bonusStrength: 7,
        attackPower: 3),
    EquipmentItem(
        id: 'acc_sage_pendant',
        name: '현자의 목걸이',
        description: '심오한 지혜를 부여하는 목걸이',
        type: ItemType.accessory,
        rarity: ItemRarity.rare,
        bonusWisdom: 8,
        bonusCharisma: 3),

    // Epic
    EquipmentItem(
        id: 'acc_crown',
        name: '매력의 왕관',
        description: '모두를 사로잡는 빛나는 왕관',
        type: ItemType.accessory,
        rarity: ItemRarity.epic,
        bonusCharisma: 15),
    EquipmentItem(
        id: 'acc_dragon_ring',
        name: '용의 반지',
        description: '드래곤의 힘이 깃든 고대의 반지',
        type: ItemType.accessory,
        rarity: ItemRarity.epic,
        bonusStrength: 10,
        bonusHealth: 8,
        attackPower: 5),

    // Legendary
    EquipmentItem(
        id: 'acc_god_necklace',
        name: '신의 목걸이',
        description: '만물의 힘을 품은 목걸이',
        type: ItemType.accessory,
        rarity: ItemRarity.legendary,
        bonusStrength: 10,
        bonusWisdom: 10,
        bonusHealth: 10,
        bonusCharisma: 10),
    EquipmentItem(
        id: 'acc_ring_domination',
        name: '지배의 반지',
        description: '절대적 권능의 반지',
        type: ItemType.accessory,
        rarity: ItemRarity.legendary,
        bonusStrength: 15,
        attackPower: 10,
        bonusCharisma: 8),
  ];

  /// Roll for loot after defeating a monster.
  /// Returns null if no drop, or an EquipmentItem if loot drops.
  static EquipmentItem? rollLoot(Monster monster) {
    // Base drop chance: 40% for any item
    double dropChance = 0.40;
    int roll = _random.nextInt(100);
    if (roll >= (dropChance * 100).toInt()) return null;

    // Determine rarity based on monster level
    ItemRarity rarity = _rollRarity(monster.level);
    return _pickRandomItemByRarity(rarity);
  }

  static EquipmentItem rollLootBoxReward(int tier) {
    final allowedRarities = tier >= 2
        ? [ItemRarity.rare, ItemRarity.epic, ItemRarity.legendary]
        : [ItemRarity.common, ItemRarity.uncommon, ItemRarity.rare];

    return _pickRandomItemByRarity(
      _rollLootBoxRarity(tier),
      fallbackRarities: allowedRarities,
    );
  }

  static EquipmentItem _pickRandomItemByRarity(
    ItemRarity rarity, {
    List<ItemRarity>? fallbackRarities,
  }) {
    List<EquipmentItem> candidates =
        _allItems.where((item) => item.rarity == rarity).toList();

    if (candidates.isEmpty && fallbackRarities != null) {
      candidates = _allItems
          .where((item) => fallbackRarities.contains(item.rarity))
          .toList();
    }

    if (candidates.isEmpty) {
      candidates =
          _allItems.where((item) => item.rarity == ItemRarity.common).toList();
    }

    return candidates[_random.nextInt(candidates.length)];
  }

  static ItemRarity _rollLootBoxRarity(int tier) {
    final roll = _random.nextInt(100);

    if (tier >= 2) {
      if (roll < 5) return ItemRarity.legendary;
      if (roll < 30) return ItemRarity.epic;
      return ItemRarity.rare;
    }

    if (roll < 15) return ItemRarity.rare;
    if (roll < 55) return ItemRarity.uncommon;
    return ItemRarity.common;
  }

  static ItemRarity _rollRarity(int monsterLevel) {
    int roll = _random.nextInt(100);
    // Higher level monsters have better drop rates
    int legendaryThreshold = (monsterLevel >= 30) ? 3 : 0;
    int epicThreshold = legendaryThreshold + ((monsterLevel >= 15) ? 10 : 3);
    int rareThreshold = epicThreshold + ((monsterLevel >= 10) ? 20 : 8);
    int uncommonThreshold = rareThreshold + 25;

    if (roll < legendaryThreshold) {
      return ItemRarity.legendary;
    } else if (roll < epicThreshold) {
      return ItemRarity.epic;
    } else if (roll < rareThreshold) {
      return ItemRarity.rare;
    } else if (roll < uncommonThreshold) {
      return ItemRarity.uncommon;
    } else {
      return ItemRarity.common;
    }
  }
}



