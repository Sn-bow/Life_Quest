import 'package:life_quest_final_v2/models/card_data.dart';
import 'package:life_quest_final_v2/models/status_effect.dart';

/// Static database of all cards in the Soul Deck card game.
///
/// Cards are organized by category (attack, magic, defense, tactical),
/// rarity (common, uncommon, rare, legendary), and special types
/// (starter, curse). Each card has a base version and an upgraded version.
class CardDatabase {
  CardDatabase._();

  // ─────────────────────────────────────────────
  // Public API
  // ─────────────────────────────────────────────

  /// Returns the default 10-card starter deck:
  /// 5x basic_strike, 4x basic_defend, 1x basic_focus.
  static List<CardData> get starterDeck => [
        ...List.generate(5, (_) => _starterCards['base_strike']!),
        ...List.generate(4, (_) => _starterCards['base_defend']!),
        _starterCards['base_focus']!,
      ];

  /// Returns every card in the database (base + upgraded versions).
  static List<CardData> get allCards => _allCardsCache;

  /// Look up a single card by its ID. Returns null if not found.
  static CardData? getCard(String id) => _cardIndex[id];

  /// Returns the upgraded version of a card, or null if none exists.
  static CardData? getUpgrade(String cardId) {
    final card = _cardIndex[cardId];
    if (card == null || card.upgradeId == null) return null;
    return _cardIndex[card.upgradeId!];
  }

  /// All cards matching the given [category].
  static List<CardData> getCardsByCategory(CardCategory category) =>
      _allCardsCache.where((c) => c.category == category).toList();

  /// All cards matching the given [rarity].
  static List<CardData> getCardsByRarity(CardRarity rarity) =>
      _allCardsCache.where((c) => c.rarity == rarity).toList();

  /// All curse cards.
  static List<CardData> get curseCards =>
      _curseCardList.values.toList(growable: false);

  // ─────────────────────────────────────────────
  // Internal index / cache
  // ─────────────────────────────────────────────

  static final Map<String, CardData> _cardIndex = {
    ..._starterCards,
    ..._curseCardList,
    // Attack
    ..._attackCommon,
    ..._attackCommonUpgraded,
    ..._attackUncommon,
    ..._attackUncommonUpgraded,
    ..._attackRare,
    ..._attackRareUpgraded,
    ..._attackLegendary,
    ..._attackLegendaryUpgraded,
    // Magic
    ..._magicCommon,
    ..._magicCommonUpgraded,
    ..._magicUncommon,
    ..._magicUncommonUpgraded,
    ..._magicRare,
    ..._magicRareUpgraded,
    ..._magicLegendary,
    ..._magicLegendaryUpgraded,
    // Defense
    ..._defenseCommon,
    ..._defenseCommonUpgraded,
    ..._defenseUncommon,
    ..._defenseUncommonUpgraded,
    ..._defenseRare,
    ..._defenseRareUpgraded,
    ..._defenseLegendary,
    ..._defenseLegendaryUpgraded,
    // Tactical
    ..._tacticalCommon,
    ..._tacticalCommonUpgraded,
    ..._tacticalUncommon,
    ..._tacticalUncommonUpgraded,
    ..._tacticalRare,
    ..._tacticalRareUpgraded,
    ..._tacticalLegendary,
    ..._tacticalLegendaryUpgraded,
  };

  static final List<CardData> _allCardsCache =
      _cardIndex.values.toList(growable: false);

  // ═════════════════════════════════════════════
  //  STARTER / BASE CARDS
  // ═════════════════════════════════════════════

  static final Map<String, CardData> _starterCards = {
    'base_strike': const CardData(
      id: 'base_strike',
      name: '기본 공격',
      category: CardCategory.attack,
      rarity: CardRarity.common,
      cost: 1,
      description: '6 데미지를 준다.',
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 6),
      ],
    ),
    'base_defend': const CardData(
      id: 'base_defend',
      name: '기본 방어',
      category: CardCategory.defense,
      rarity: CardRarity.common,
      cost: 1,
      description: '방어도 5를 얻는다.',
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 5,
          targetType: TargetType.self,
        ),
      ],
    ),
    'base_focus': const CardData(
      id: 'base_focus',
      name: '집중',
      category: CardCategory.tactical,
      rarity: CardRarity.common,
      cost: 0,
      description: '카드 1장을 드로우한다.',
      effects: [
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 1,
          targetType: TargetType.self,
        ),
      ],
    ),
  };

  // ═════════════════════════════════════════════
  //  CURSE CARDS
  // ═════════════════════════════════════════════

  static final Map<String, CardData> _curseCardList = {
    'curse_pain': const CardData(
      id: 'curse_pain',
      name: '고통',
      category: CardCategory.tactical,
      rarity: CardRarity.common,
      cost: -1, // unplayable
      description: '사용 불가. 패에 잡히면 HP 1을 잃는다.',
      effects: [
        CardEffect(
          effectType: CardEffectType.damage,
          value: 1,
          targetType: TargetType.self,
        ),
      ],
    ),
    'curse_doubt': const CardData(
      id: 'curse_doubt',
      name: '의심',
      category: CardCategory.tactical,
      rarity: CardRarity.common,
      cost: -1,
      description: '사용 불가. 패에 있으면 드로우 -1.',
      effects: [
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: -1,
          targetType: TargetType.self,
        ),
      ],
    ),
    'curse_burden': const CardData(
      id: 'curse_burden',
      name: '짐',
      category: CardCategory.tactical,
      rarity: CardRarity.common,
      cost: -1,
      description: '사용 불가. 패에 있으면 에너지 -1.',
      effects: [
        CardEffect(
          effectType: CardEffectType.gainEnergy,
          value: -1,
          targetType: TargetType.self,
        ),
      ],
    ),
    'curse_decay': const CardData(
      id: 'curse_decay',
      name: '부식',
      category: CardCategory.tactical,
      rarity: CardRarity.common,
      cost: -1,
      description: '사용 불가. 매 턴 방어 -3.',
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: -3,
          targetType: TargetType.self,
        ),
      ],
    ),
  };

  // ═════════════════════════════════════════════
  //  ATTACK COMMON (10 base + 10 upgraded)
  // ═════════════════════════════════════════════

  static final Map<String, CardData> _attackCommon = {
    'atk_c01': const CardData(
      id: 'atk_c01',
      name: '강타',
      category: CardCategory.attack,
      rarity: CardRarity.common,
      cost: 1,
      description: '6 데미지를 준다.',
      upgradeId: 'atk_c01_up',
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 6),
      ],
    ),
    'atk_c02': const CardData(
      id: 'atk_c02',
      name: '베기',
      category: CardCategory.attack,
      rarity: CardRarity.common,
      cost: 1,
      description: '4 데미지를 주고, 카드 1장을 드로우한다.',
      upgradeId: 'atk_c02_up',
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 4),
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 1,
          targetType: TargetType.self,
        ),
      ],
    ),
    'atk_c03': const CardData(
      id: 'atk_c03',
      name: '연속 공격',
      category: CardCategory.attack,
      rarity: CardRarity.common,
      cost: 1,
      description: '3 데미지를 2회 준다.',
      upgradeId: 'atk_c03_up',
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 3),
        CardEffect(effectType: CardEffectType.damage, value: 3),
      ],
    ),
    'atk_c04': const CardData(
      id: 'atk_c04',
      name: '분노의 일격',
      category: CardCategory.attack,
      rarity: CardRarity.common,
      cost: 0,
      description: '3 데미지를 주고, 분노 카드 1장을 디스카드에 추가한다.',
      upgradeId: 'atk_c04_up',
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 3),
      ],
    ),
    'atk_c05': const CardData(
      id: 'atk_c05',
      name: '돌진',
      category: CardCategory.attack,
      rarity: CardRarity.common,
      cost: 2,
      description: '12 데미지를 준다.',
      upgradeId: 'atk_c05_up',
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 12),
      ],
    ),
    'atk_c06': const CardData(
      id: 'atk_c06',
      name: '출혈 공격',
      category: CardCategory.attack,
      rarity: CardRarity.common,
      cost: 1,
      description: '4 데미지를 주고, 독 2를 부여한다.',
      upgradeId: 'atk_c06_up',
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 4),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 2,
          statusType: StatusType.poison,
        ),
      ],
    ),
    'atk_c07': const CardData(
      id: 'atk_c07',
      name: '빠른 찌르기',
      category: CardCategory.attack,
      rarity: CardRarity.common,
      cost: 0,
      description: '3 데미지를 준다.',
      upgradeId: 'atk_c07_up',
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 3),
      ],
    ),
    'atk_c08': const CardData(
      id: 'atk_c08',
      name: '도발',
      category: CardCategory.attack,
      rarity: CardRarity.common,
      cost: 1,
      description: '5 데미지를 주고, 취약 1턴을 부여한다.',
      upgradeId: 'atk_c08_up',
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 5),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 1,
          statusType: StatusType.vulnerable,
        ),
      ],
    ),
    'atk_c09': const CardData(
      id: 'atk_c09',
      name: '기습',
      category: CardCategory.attack,
      rarity: CardRarity.common,
      cost: 1,
      description: '첫 턴이면 12 데미지, 아니면 6 데미지.',
      upgradeId: 'atk_c09_up',
      effects: [
        // Base damage; combat logic handles conditional bonus
        CardEffect(effectType: CardEffectType.damage, value: 6),
      ],
    ),
    'atk_c10': const CardData(
      id: 'atk_c10',
      name: '칼날 바람',
      category: CardCategory.attack,
      rarity: CardRarity.common,
      cost: 1,
      description: '적 전체에 3 데미지를 준다.',
      upgradeId: 'atk_c10_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.aoe,
          value: 3,
          targetType: TargetType.allEnemies,
        ),
      ],
    ),
  };

  static final Map<String, CardData> _attackCommonUpgraded = {
    'atk_c01_up': const CardData(
      id: 'atk_c01_up',
      name: '강타+',
      category: CardCategory.attack,
      rarity: CardRarity.common,
      cost: 1,
      description: '9 데미지를 준다.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 9),
      ],
    ),
    'atk_c02_up': const CardData(
      id: 'atk_c02_up',
      name: '베기+',
      category: CardCategory.attack,
      rarity: CardRarity.common,
      cost: 1,
      description: '6 데미지를 주고, 카드 1장을 드로우한다.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 6),
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 1,
          targetType: TargetType.self,
        ),
      ],
    ),
    'atk_c03_up': const CardData(
      id: 'atk_c03_up',
      name: '연속 공격+',
      category: CardCategory.attack,
      rarity: CardRarity.common,
      cost: 1,
      description: '3 데미지를 3회 준다.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 3),
        CardEffect(effectType: CardEffectType.damage, value: 3),
        CardEffect(effectType: CardEffectType.damage, value: 3),
      ],
    ),
    'atk_c04_up': const CardData(
      id: 'atk_c04_up',
      name: '분노의 일격+',
      category: CardCategory.attack,
      rarity: CardRarity.common,
      cost: 0,
      description: '5 데미지를 준다.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 5),
      ],
    ),
    'atk_c05_up': const CardData(
      id: 'atk_c05_up',
      name: '돌진+',
      category: CardCategory.attack,
      rarity: CardRarity.common,
      cost: 2,
      description: '16 데미지를 준다.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 16),
      ],
    ),
    'atk_c06_up': const CardData(
      id: 'atk_c06_up',
      name: '출혈 공격+',
      category: CardCategory.attack,
      rarity: CardRarity.common,
      cost: 1,
      description: '4 데미지를 주고, 독 4를 부여한다.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 4),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 4,
          statusType: StatusType.poison,
        ),
      ],
    ),
    'atk_c07_up': const CardData(
      id: 'atk_c07_up',
      name: '빠른 찌르기+',
      category: CardCategory.attack,
      rarity: CardRarity.common,
      cost: 0,
      description: '5 데미지를 준다.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 5),
      ],
    ),
    'atk_c08_up': const CardData(
      id: 'atk_c08_up',
      name: '도발+',
      category: CardCategory.attack,
      rarity: CardRarity.common,
      cost: 1,
      description: '8 데미지를 주고, 취약 1턴을 부여한다.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 8),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 1,
          statusType: StatusType.vulnerable,
        ),
      ],
    ),
    'atk_c09_up': const CardData(
      id: 'atk_c09_up',
      name: '기습+',
      category: CardCategory.attack,
      rarity: CardRarity.common,
      cost: 1,
      description: '첫 턴이면 18 데미지, 아니면 9 데미지.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 9),
      ],
    ),
    'atk_c10_up': const CardData(
      id: 'atk_c10_up',
      name: '칼날 바람+',
      category: CardCategory.attack,
      rarity: CardRarity.common,
      cost: 1,
      description: '적 전체에 5 데미지를 준다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.aoe,
          value: 5,
          targetType: TargetType.allEnemies,
        ),
      ],
    ),
  };

  // ═════════════════════════════════════════════
  //  MAGIC COMMON (10 base + 10 upgraded)
  // ═════════════════════════════════════════════

  static final Map<String, CardData> _magicCommon = {
    'mag_c01': const CardData(
      id: 'mag_c01',
      name: '화염탄',
      category: CardCategory.magic,
      rarity: CardRarity.common,
      cost: 1,
      description: '4 데미지를 주고, 화상 2턴을 부여한다.',
      upgradeId: 'mag_c01_up',
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 4),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 2,
          statusType: StatusType.burn,
        ),
      ],
    ),
    'mag_c02': const CardData(
      id: 'mag_c02',
      name: '서리 화살',
      category: CardCategory.magic,
      rarity: CardRarity.common,
      cost: 1,
      description: '5 데미지를 주고, 약화 1턴을 부여한다.',
      upgradeId: 'mag_c02_up',
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 5),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 1,
          statusType: StatusType.weak,
        ),
      ],
    ),
    'mag_c03': const CardData(
      id: 'mag_c03',
      name: '마나 집중',
      category: CardCategory.magic,
      rarity: CardRarity.common,
      cost: 0,
      description: '에너지 +1, 카드 1장을 드로우한다.',
      upgradeId: 'mag_c03_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.gainEnergy,
          value: 1,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 1,
          targetType: TargetType.self,
        ),
      ],
    ),
    'mag_c04': const CardData(
      id: 'mag_c04',
      name: '전기 충격',
      category: CardCategory.magic,
      rarity: CardRarity.common,
      cost: 1,
      description: '7 데미지를 준다 (랜덤 적).',
      upgradeId: 'mag_c04_up',
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 7),
      ],
    ),
    'mag_c05': const CardData(
      id: 'mag_c05',
      name: '마법 화살',
      category: CardCategory.magic,
      rarity: CardRarity.common,
      cost: 1,
      description: '4 데미지를 2회 준다 (랜덤 대상).',
      upgradeId: 'mag_c05_up',
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 4),
        CardEffect(effectType: CardEffectType.damage, value: 4),
      ],
    ),
    'mag_c06': const CardData(
      id: 'mag_c06',
      name: '명상',
      category: CardCategory.magic,
      rarity: CardRarity.common,
      cost: 1,
      description: '카드 2장을 드로우한다.',
      upgradeId: 'mag_c06_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 2,
          targetType: TargetType.self,
        ),
      ],
    ),
    'mag_c07': const CardData(
      id: 'mag_c07',
      name: '지식의 빛',
      category: CardCategory.magic,
      rarity: CardRarity.common,
      cost: 0,
      description: '드로우 파일 상위 3장을 확인하고, 1장을 패로 가져온다.',
      upgradeId: 'mag_c07_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 1,
          targetType: TargetType.self,
        ),
      ],
    ),
    'mag_c08': const CardData(
      id: 'mag_c08',
      name: '독안개',
      category: CardCategory.magic,
      rarity: CardRarity.common,
      cost: 1,
      description: '적 전체에 독 3을 부여한다.',
      upgradeId: 'mag_c08_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 3,
          targetType: TargetType.allEnemies,
          statusType: StatusType.poison,
        ),
      ],
    ),
    'mag_c09': const CardData(
      id: 'mag_c09',
      name: '마력 폭발',
      category: CardCategory.magic,
      rarity: CardRarity.common,
      cost: 2,
      description: '10 데미지를 주고, 집중 +1을 얻는다.',
      upgradeId: 'mag_c09_up',
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 10),
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 1,
          targetType: TargetType.self,
          statusType: StatusType.focus,
        ),
      ],
    ),
    'mag_c10': const CardData(
      id: 'mag_c10',
      name: '원소 조화',
      category: CardCategory.magic,
      rarity: CardRarity.common,
      cost: 1,
      description: '다음 카드 효과를 50% 증가시킨다.',
      upgradeId: 'mag_c10_up',
      effects: [
        // Combat logic handles the "next card amplified" mechanic
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 50,
          targetType: TargetType.self,
        ),
      ],
    ),
  };

  static final Map<String, CardData> _magicCommonUpgraded = {
    'mag_c01_up': const CardData(
      id: 'mag_c01_up',
      name: '화염탄+',
      category: CardCategory.magic,
      rarity: CardRarity.common,
      cost: 1,
      description: '6 데미지를 주고, 화상 3턴을 부여한다.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 6),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 3,
          statusType: StatusType.burn,
        ),
      ],
    ),
    'mag_c02_up': const CardData(
      id: 'mag_c02_up',
      name: '서리 화살+',
      category: CardCategory.magic,
      rarity: CardRarity.common,
      cost: 1,
      description: '8 데미지를 주고, 약화 1턴을 부여한다.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 8),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 1,
          statusType: StatusType.weak,
        ),
      ],
    ),
    'mag_c03_up': const CardData(
      id: 'mag_c03_up',
      name: '마나 집중+',
      category: CardCategory.magic,
      rarity: CardRarity.common,
      cost: 0,
      description: '에너지 +1, 카드 2장을 드로우한다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.gainEnergy,
          value: 1,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 2,
          targetType: TargetType.self,
        ),
      ],
    ),
    'mag_c04_up': const CardData(
      id: 'mag_c04_up',
      name: '전기 충격+',
      category: CardCategory.magic,
      rarity: CardRarity.common,
      cost: 1,
      description: '10 데미지를 준다.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 10),
      ],
    ),
    'mag_c05_up': const CardData(
      id: 'mag_c05_up',
      name: '마법 화살+',
      category: CardCategory.magic,
      rarity: CardRarity.common,
      cost: 1,
      description: '4 데미지를 3회 준다 (랜덤 대상).',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 4),
        CardEffect(effectType: CardEffectType.damage, value: 4),
        CardEffect(effectType: CardEffectType.damage, value: 4),
      ],
    ),
    'mag_c06_up': const CardData(
      id: 'mag_c06_up',
      name: '명상+',
      category: CardCategory.magic,
      rarity: CardRarity.common,
      cost: 1,
      description: '카드 3장을 드로우한다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 3,
          targetType: TargetType.self,
        ),
      ],
    ),
    'mag_c07_up': const CardData(
      id: 'mag_c07_up',
      name: '지식의 빛+',
      category: CardCategory.magic,
      rarity: CardRarity.common,
      cost: 0,
      description: '드로우 파일 상위 3장 중 2장을 패로 가져온다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 2,
          targetType: TargetType.self,
        ),
      ],
    ),
    'mag_c08_up': const CardData(
      id: 'mag_c08_up',
      name: '독안개+',
      category: CardCategory.magic,
      rarity: CardRarity.common,
      cost: 1,
      description: '적 전체에 독 5를 부여한다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 5,
          targetType: TargetType.allEnemies,
          statusType: StatusType.poison,
        ),
      ],
    ),
    'mag_c09_up': const CardData(
      id: 'mag_c09_up',
      name: '마력 폭발+',
      category: CardCategory.magic,
      rarity: CardRarity.common,
      cost: 2,
      description: '14 데미지를 주고, 집중 +1을 얻는다.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 14),
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 1,
          targetType: TargetType.self,
          statusType: StatusType.focus,
        ),
      ],
    ),
    'mag_c10_up': const CardData(
      id: 'mag_c10_up',
      name: '원소 조화+',
      category: CardCategory.magic,
      rarity: CardRarity.common,
      cost: 1,
      description: '다음 카드 효과를 100% 증가시킨다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 100,
          targetType: TargetType.self,
        ),
      ],
    ),
  };

  // ═════════════════════════════════════════════
  //  DEFENSE COMMON (10 base + 10 upgraded)
  // ═════════════════════════════════════════════

  static final Map<String, CardData> _defenseCommon = {
    'def_c01': const CardData(
      id: 'def_c01',
      name: '방어',
      category: CardCategory.defense,
      rarity: CardRarity.common,
      cost: 1,
      description: '방어도 5를 얻는다.',
      upgradeId: 'def_c01_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 5,
          targetType: TargetType.self,
        ),
      ],
    ),
    'def_c02': const CardData(
      id: 'def_c02',
      name: '철벽',
      category: CardCategory.defense,
      rarity: CardRarity.common,
      cost: 2,
      description: '방어도 12를 얻는다.',
      upgradeId: 'def_c02_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 12,
          targetType: TargetType.self,
        ),
      ],
    ),
    'def_c03': const CardData(
      id: 'def_c03',
      name: '반격',
      category: CardCategory.defense,
      rarity: CardRarity.common,
      cost: 1,
      description: '방어도 4를 얻고, 가시 2를 얻는다.',
      upgradeId: 'def_c03_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 4,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 2,
          targetType: TargetType.self,
          statusType: StatusType.thorns,
        ),
      ],
    ),
    'def_c04': const CardData(
      id: 'def_c04',
      name: '회복 기도',
      category: CardCategory.defense,
      rarity: CardRarity.common,
      cost: 1,
      description: 'HP 4를 회복한다.',
      upgradeId: 'def_c04_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.heal,
          value: 4,
          targetType: TargetType.self,
        ),
      ],
    ),
    'def_c05': const CardData(
      id: 'def_c05',
      name: '전투 태세',
      category: CardCategory.defense,
      rarity: CardRarity.common,
      cost: 1,
      description: '방어도 6을 얻고, 카드 1장을 드로우한다.',
      upgradeId: 'def_c05_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 6,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 1,
          targetType: TargetType.self,
        ),
      ],
    ),
    'def_c06': const CardData(
      id: 'def_c06',
      name: '구르기',
      category: CardCategory.defense,
      rarity: CardRarity.common,
      cost: 1,
      description: '방어도 3을 얻고, 다음 턴 방어도 6을 얻는다.',
      upgradeId: 'def_c06_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 3,
          targetType: TargetType.self,
        ),
        // Delayed block is handled by combat logic
        CardEffect(
          effectType: CardEffectType.block,
          value: 6,
          targetType: TargetType.self,
          duration: 1, // next turn
        ),
      ],
    ),
    'def_c07': const CardData(
      id: 'def_c07',
      name: '응급 처치',
      category: CardCategory.defense,
      rarity: CardRarity.common,
      cost: 0,
      description: 'HP 3을 회복한다.',
      upgradeId: 'def_c07_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.heal,
          value: 3,
          targetType: TargetType.self,
        ),
      ],
    ),
    'def_c08': const CardData(
      id: 'def_c08',
      name: '인내',
      category: CardCategory.defense,
      rarity: CardRarity.common,
      cost: 1,
      description: '방어도 5를 얻고, 불굴 1턴을 얻는다.',
      upgradeId: 'def_c08_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 5,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 1,
          duration: 1,
          targetType: TargetType.self,
          statusType: StatusType.fortify,
        ),
      ],
    ),
    'def_c09': const CardData(
      id: 'def_c09',
      name: '생명력',
      category: CardCategory.defense,
      rarity: CardRarity.common,
      cost: 1,
      description: '재생 3을 얻는다 (3턴).',
      upgradeId: 'def_c09_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 3,
          duration: 3,
          targetType: TargetType.self,
          statusType: StatusType.regen,
        ),
      ],
    ),
    'def_c10': const CardData(
      id: 'def_c10',
      name: '도발 방패',
      category: CardCategory.defense,
      rarity: CardRarity.common,
      cost: 1,
      description: '방어도 6을 얻고, 적 1체를 도발한다.',
      upgradeId: 'def_c10_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 6,
          targetType: TargetType.self,
        ),
      ],
    ),
  };

  static final Map<String, CardData> _defenseCommonUpgraded = {
    'def_c01_up': const CardData(
      id: 'def_c01_up',
      name: '방어+',
      category: CardCategory.defense,
      rarity: CardRarity.common,
      cost: 1,
      description: '방어도 8을 얻는다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 8,
          targetType: TargetType.self,
        ),
      ],
    ),
    'def_c02_up': const CardData(
      id: 'def_c02_up',
      name: '철벽+',
      category: CardCategory.defense,
      rarity: CardRarity.common,
      cost: 2,
      description: '방어도 16을 얻는다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 16,
          targetType: TargetType.self,
        ),
      ],
    ),
    'def_c03_up': const CardData(
      id: 'def_c03_up',
      name: '반격+',
      category: CardCategory.defense,
      rarity: CardRarity.common,
      cost: 1,
      description: '방어도 6을 얻고, 가시 3을 얻는다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 6,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 3,
          targetType: TargetType.self,
          statusType: StatusType.thorns,
        ),
      ],
    ),
    'def_c04_up': const CardData(
      id: 'def_c04_up',
      name: '회복 기도+',
      category: CardCategory.defense,
      rarity: CardRarity.common,
      cost: 1,
      description: 'HP 7을 회복한다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.heal,
          value: 7,
          targetType: TargetType.self,
        ),
      ],
    ),
    'def_c05_up': const CardData(
      id: 'def_c05_up',
      name: '전투 태세+',
      category: CardCategory.defense,
      rarity: CardRarity.common,
      cost: 1,
      description: '방어도 8을 얻고, 카드 1장을 드로우한다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 8,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 1,
          targetType: TargetType.self,
        ),
      ],
    ),
    'def_c06_up': const CardData(
      id: 'def_c06_up',
      name: '구르기+',
      category: CardCategory.defense,
      rarity: CardRarity.common,
      cost: 1,
      description: '방어도 5를 얻고, 다음 턴 방어도 8을 얻는다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 5,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.block,
          value: 8,
          targetType: TargetType.self,
          duration: 1,
        ),
      ],
    ),
    'def_c07_up': const CardData(
      id: 'def_c07_up',
      name: '응급 처치+',
      category: CardCategory.defense,
      rarity: CardRarity.common,
      cost: 0,
      description: 'HP 5를 회복한다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.heal,
          value: 5,
          targetType: TargetType.self,
        ),
      ],
    ),
    'def_c08_up': const CardData(
      id: 'def_c08_up',
      name: '인내+',
      category: CardCategory.defense,
      rarity: CardRarity.common,
      cost: 1,
      description: '방어도 7을 얻고, 불굴 2턴을 얻는다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 7,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 1,
          duration: 2,
          targetType: TargetType.self,
          statusType: StatusType.fortify,
        ),
      ],
    ),
    'def_c09_up': const CardData(
      id: 'def_c09_up',
      name: '생명력+',
      category: CardCategory.defense,
      rarity: CardRarity.common,
      cost: 1,
      description: '재생 4를 얻는다 (4턴).',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 4,
          duration: 4,
          targetType: TargetType.self,
          statusType: StatusType.regen,
        ),
      ],
    ),
    'def_c10_up': const CardData(
      id: 'def_c10_up',
      name: '도발 방패+',
      category: CardCategory.defense,
      rarity: CardRarity.common,
      cost: 1,
      description: '방어도 9를 얻고, 적 1체를 도발한다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 9,
          targetType: TargetType.self,
        ),
      ],
    ),
  };

  // ═════════════════════════════════════════════
  //  TACTICAL COMMON (10 base + 10 upgraded)
  // ═════════════════════════════════════════════

  static final Map<String, CardData> _tacticalCommon = {
    'tac_c01': const CardData(
      id: 'tac_c01',
      name: '관찰',
      category: CardCategory.tactical,
      rarity: CardRarity.common,
      cost: 0,
      description: '적 의도를 확인하고, 카드 1장을 드로우한다.',
      upgradeId: 'tac_c01_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 1,
          targetType: TargetType.self,
        ),
      ],
    ),
    'tac_c02': const CardData(
      id: 'tac_c02',
      name: '보물 사냥',
      category: CardCategory.tactical,
      rarity: CardRarity.common,
      cost: 1,
      description: '전투 골드 +15.',
      upgradeId: 'tac_c02_up',
      effects: [
        // Gold gain is handled by combat logic
        CardEffect(
          effectType: CardEffectType.gainEnergy,
          value: 0,
          targetType: TargetType.self,
        ),
      ],
    ),
    'tac_c03': const CardData(
      id: 'tac_c03',
      name: '약점 간파',
      category: CardCategory.tactical,
      rarity: CardRarity.common,
      cost: 1,
      description: '취약 2턴, 약화 1턴을 부여한다.',
      upgradeId: 'tac_c03_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 2,
          statusType: StatusType.vulnerable,
        ),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 1,
          statusType: StatusType.weak,
        ),
      ],
    ),
    'tac_c04': const CardData(
      id: 'tac_c04',
      name: '재빠른 손',
      category: CardCategory.tactical,
      rarity: CardRarity.common,
      cost: 0,
      description: '카드 2장을 드로우한다.',
      upgradeId: 'tac_c04_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 2,
          targetType: TargetType.self,
        ),
      ],
    ),
    'tac_c05': const CardData(
      id: 'tac_c05',
      name: '덫 설치',
      category: CardCategory.tactical,
      rarity: CardRarity.common,
      cost: 1,
      description: '다음 적 공격 시 10 데미지를 반사한다.',
      upgradeId: 'tac_c05_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 10,
          targetType: TargetType.self,
          statusType: StatusType.thorns,
          duration: 1,
        ),
      ],
    ),
    'tac_c06': const CardData(
      id: 'tac_c06',
      name: '교란',
      category: CardCategory.tactical,
      rarity: CardRarity.common,
      cost: 1,
      description: '적 의도를 변경한다 (랜덤).',
      upgradeId: 'tac_c06_up',
      effects: [
        // Intent change is handled by combat logic
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 0,
        ),
      ],
    ),
    'tac_c07': const CardData(
      id: 'tac_c07',
      name: '도둑질',
      category: CardCategory.tactical,
      rarity: CardRarity.common,
      cost: 1,
      description: '3 데미지를 주고, 골드 5~15를 획득한다.',
      upgradeId: 'tac_c07_up',
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 3),
      ],
    ),
    'tac_c08': const CardData(
      id: 'tac_c08',
      name: '연막탄',
      category: CardCategory.tactical,
      rarity: CardRarity.common,
      cost: 1,
      description: '방어도 4를 얻고, 적 전체에 약화 1턴을 부여한다.',
      upgradeId: 'tac_c08_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 4,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 1,
          targetType: TargetType.allEnemies,
          statusType: StatusType.weak,
        ),
      ],
    ),
    'tac_c09': const CardData(
      id: 'tac_c09',
      name: '격려',
      category: CardCategory.tactical,
      rarity: CardRarity.common,
      cost: 1,
      description: '임의 카드 1장을 이번 전투 동안 업그레이드한다.',
      upgradeId: 'tac_c09_up',
      effects: [
        // Upgrade logic handled by combat engine
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 1,
          targetType: TargetType.self,
        ),
      ],
    ),
    'tac_c10': const CardData(
      id: 'tac_c10',
      name: '행운의 동전',
      category: CardCategory.tactical,
      rarity: CardRarity.common,
      cost: 0,
      description: '50% 확률로 카드 2장을 드로우한다.',
      upgradeId: 'tac_c10_up',
      effects: [
        // RNG draw handled by combat logic
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 2,
          targetType: TargetType.self,
        ),
      ],
    ),
  };

  static final Map<String, CardData> _tacticalCommonUpgraded = {
    'tac_c01_up': const CardData(
      id: 'tac_c01_up',
      name: '관찰+',
      category: CardCategory.tactical,
      rarity: CardRarity.common,
      cost: 0,
      description: '적 의도를 확인하고, 카드 2장을 드로우한다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 2,
          targetType: TargetType.self,
        ),
      ],
    ),
    'tac_c02_up': const CardData(
      id: 'tac_c02_up',
      name: '보물 사냥+',
      category: CardCategory.tactical,
      rarity: CardRarity.common,
      cost: 1,
      description: '전투 골드 +25.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.gainEnergy,
          value: 0,
          targetType: TargetType.self,
        ),
      ],
    ),
    'tac_c03_up': const CardData(
      id: 'tac_c03_up',
      name: '약점 간파+',
      category: CardCategory.tactical,
      rarity: CardRarity.common,
      cost: 1,
      description: '취약 2턴, 약화 2턴을 부여한다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 2,
          statusType: StatusType.vulnerable,
        ),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 2,
          statusType: StatusType.weak,
        ),
      ],
    ),
    'tac_c04_up': const CardData(
      id: 'tac_c04_up',
      name: '재빠른 손+',
      category: CardCategory.tactical,
      rarity: CardRarity.common,
      cost: 0,
      description: '카드 3장을 드로우한다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 3,
          targetType: TargetType.self,
        ),
      ],
    ),
    'tac_c05_up': const CardData(
      id: 'tac_c05_up',
      name: '덫 설치+',
      category: CardCategory.tactical,
      rarity: CardRarity.common,
      cost: 1,
      description: '다음 적 공격 시 15 데미지를 반사한다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 15,
          targetType: TargetType.self,
          statusType: StatusType.thorns,
          duration: 1,
        ),
      ],
    ),
    'tac_c06_up': const CardData(
      id: 'tac_c06_up',
      name: '교란+',
      category: CardCategory.tactical,
      rarity: CardRarity.common,
      cost: 1,
      description: '적 의도를 변경하고, 약화 1턴을 부여한다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 1,
          statusType: StatusType.weak,
        ),
      ],
    ),
    'tac_c07_up': const CardData(
      id: 'tac_c07_up',
      name: '도둑질+',
      category: CardCategory.tactical,
      rarity: CardRarity.common,
      cost: 1,
      description: '6 데미지를 주고, 골드 10~25를 획득한다.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 6),
      ],
    ),
    'tac_c08_up': const CardData(
      id: 'tac_c08_up',
      name: '연막탄+',
      category: CardCategory.tactical,
      rarity: CardRarity.common,
      cost: 1,
      description: '방어도 6을 얻고, 적 전체에 약화 2턴을 부여한다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 6,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 2,
          targetType: TargetType.allEnemies,
          statusType: StatusType.weak,
        ),
      ],
    ),
    'tac_c09_up': const CardData(
      id: 'tac_c09_up',
      name: '격려+',
      category: CardCategory.tactical,
      rarity: CardRarity.common,
      cost: 1,
      description: '임의 카드 2장을 이번 전투 동안 업그레이드한다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 2,
          targetType: TargetType.self,
        ),
      ],
    ),
    'tac_c10_up': const CardData(
      id: 'tac_c10_up',
      name: '행운의 동전+',
      category: CardCategory.tactical,
      rarity: CardRarity.common,
      cost: 0,
      description: '70% 확률로 카드 2장을 드로우한다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 2,
          targetType: TargetType.self,
        ),
      ],
    ),
  };

  // ═════════════════════════════════════════════
  //  ATTACK UNCOMMON (8 base + 8 upgraded)
  // ═════════════════════════════════════════════

  static final Map<String, CardData> _attackUncommon = {
    'atk_u01': const CardData(
      id: 'atk_u01',
      name: '파워 슬래시',
      category: CardCategory.attack,
      rarity: CardRarity.uncommon,
      cost: 2,
      description: '14 데미지를 주고, 취약 2턴을 부여한다.',
      upgradeId: 'atk_u01_up',
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 14),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 2,
          statusType: StatusType.vulnerable,
        ),
      ],
    ),
    'atk_u02': const CardData(
      id: 'atk_u02',
      name: '칼날 춤',
      category: CardCategory.attack,
      rarity: CardRarity.uncommon,
      cost: 1,
      description: '3 데미지를 3회 주고, 방어도 3을 얻는다.',
      upgradeId: 'atk_u02_up',
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 3),
        CardEffect(effectType: CardEffectType.damage, value: 3),
        CardEffect(effectType: CardEffectType.damage, value: 3),
        CardEffect(
          effectType: CardEffectType.block,
          value: 3,
          targetType: TargetType.self,
        ),
      ],
    ),
    'atk_u03': const CardData(
      id: 'atk_u03',
      name: '처형',
      category: CardCategory.attack,
      rarity: CardRarity.uncommon,
      cost: 2,
      description: '적 HP 50% 이하면 30 데미지, 아니면 10 데미지.',
      upgradeId: 'atk_u03_up',
      effects: [
        // Conditional logic handled by combat engine; uses higher value
        CardEffect(effectType: CardEffectType.damage, value: 30),
      ],
    ),
    'atk_u04': const CardData(
      id: 'atk_u04',
      name: '광폭화',
      category: CardCategory.attack,
      rarity: CardRarity.uncommon,
      cost: 1,
      description: '힘 +2를 획득한다 (영구).',
      upgradeId: 'atk_u04_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 2,
          targetType: TargetType.self,
          statusType: StatusType.strength,
        ),
      ],
    ),
    'atk_u05': const CardData(
      id: 'atk_u05',
      name: '피의 맹세',
      category: CardCategory.attack,
      rarity: CardRarity.uncommon,
      cost: 0,
      description: 'HP 3을 잃고, 8 데미지를 주고, 힘 +1을 얻는다.',
      upgradeId: 'atk_u05_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.damage,
          value: 3,
          targetType: TargetType.self,
        ),
        CardEffect(effectType: CardEffectType.damage, value: 8),
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 1,
          targetType: TargetType.self,
          statusType: StatusType.strength,
        ),
      ],
    ),
    'atk_u06': const CardData(
      id: 'atk_u06',
      name: '회전 베기',
      category: CardCategory.attack,
      rarity: CardRarity.uncommon,
      cost: 2,
      description: '적 전체에 8 데미지를 준다.',
      upgradeId: 'atk_u06_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.aoe,
          value: 8,
          targetType: TargetType.allEnemies,
        ),
      ],
    ),
    'atk_u07': const CardData(
      id: 'atk_u07',
      name: '분쇄',
      category: CardCategory.attack,
      rarity: CardRarity.uncommon,
      cost: 2,
      description: '10 데미지를 주고, 약화 2턴을 부여한다.',
      upgradeId: 'atk_u07_up',
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 10),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 2,
          statusType: StatusType.weak,
        ),
      ],
    ),
    'atk_u08': const CardData(
      id: 'atk_u08',
      name: '무자비',
      category: CardCategory.attack,
      rarity: CardRarity.uncommon,
      cost: 1,
      description: '취약 상태 적에게 데미지 2배 (기본 6 데미지).',
      upgradeId: 'atk_u08_up',
      effects: [
        // Double damage vs vulnerable handled by combat engine
        CardEffect(effectType: CardEffectType.damage, value: 6),
      ],
    ),
  };

  static final Map<String, CardData> _attackUncommonUpgraded = {
    'atk_u01_up': const CardData(
      id: 'atk_u01_up',
      name: '파워 슬래시+',
      category: CardCategory.attack,
      rarity: CardRarity.uncommon,
      cost: 2,
      description: '18 데미지를 주고, 취약 2턴을 부여한다.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 18),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 2,
          statusType: StatusType.vulnerable,
        ),
      ],
    ),
    'atk_u02_up': const CardData(
      id: 'atk_u02_up',
      name: '칼날 춤+',
      category: CardCategory.attack,
      rarity: CardRarity.uncommon,
      cost: 1,
      description: '4 데미지를 3회 주고, 방어도 5를 얻는다.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 4),
        CardEffect(effectType: CardEffectType.damage, value: 4),
        CardEffect(effectType: CardEffectType.damage, value: 4),
        CardEffect(
          effectType: CardEffectType.block,
          value: 5,
          targetType: TargetType.self,
        ),
      ],
    ),
    'atk_u03_up': const CardData(
      id: 'atk_u03_up',
      name: '처형+',
      category: CardCategory.attack,
      rarity: CardRarity.uncommon,
      cost: 2,
      description: '적 HP 50% 이하면 40 데미지, 아니면 14 데미지.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 40),
      ],
    ),
    'atk_u04_up': const CardData(
      id: 'atk_u04_up',
      name: '광폭화+',
      category: CardCategory.attack,
      rarity: CardRarity.uncommon,
      cost: 1,
      description: '힘 +3을 획득한다 (영구).',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 3,
          targetType: TargetType.self,
          statusType: StatusType.strength,
        ),
      ],
    ),
    'atk_u05_up': const CardData(
      id: 'atk_u05_up',
      name: '피의 맹세+',
      category: CardCategory.attack,
      rarity: CardRarity.uncommon,
      cost: 0,
      description: 'HP 3을 잃고, 12 데미지를 주고, 힘 +1을 얻는다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.damage,
          value: 3,
          targetType: TargetType.self,
        ),
        CardEffect(effectType: CardEffectType.damage, value: 12),
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 1,
          targetType: TargetType.self,
          statusType: StatusType.strength,
        ),
      ],
    ),
    'atk_u06_up': const CardData(
      id: 'atk_u06_up',
      name: '회전 베기+',
      category: CardCategory.attack,
      rarity: CardRarity.uncommon,
      cost: 2,
      description: '적 전체에 12 데미지를 준다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.aoe,
          value: 12,
          targetType: TargetType.allEnemies,
        ),
      ],
    ),
    'atk_u07_up': const CardData(
      id: 'atk_u07_up',
      name: '분쇄+',
      category: CardCategory.attack,
      rarity: CardRarity.uncommon,
      cost: 2,
      description: '14 데미지를 주고, 약화 2턴을 부여한다.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 14),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 2,
          statusType: StatusType.weak,
        ),
      ],
    ),
    'atk_u08_up': const CardData(
      id: 'atk_u08_up',
      name: '무자비+',
      category: CardCategory.attack,
      rarity: CardRarity.uncommon,
      cost: 1,
      description: '취약 상태 적에게 데미지 2배 (기본 9 데미지).',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 9),
      ],
    ),
  };

  // ═════════════════════════════════════════════
  //  ATTACK RARE (5 base + 5 upgraded)
  // ═════════════════════════════════════════════

  static final Map<String, CardData> _attackRare = {
    'atk_r01': const CardData(
      id: 'atk_r01',
      name: '용의 일격',
      category: CardCategory.attack,
      rarity: CardRarity.rare,
      cost: 3,
      description: '30 데미지를 주고, 화상 3턴을 부여한다.',
      upgradeId: 'atk_r01_up',
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 30),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 3,
          statusType: StatusType.burn,
        ),
      ],
    ),
    'atk_r02': const CardData(
      id: 'atk_r02',
      name: '천 번의 베기',
      category: CardCategory.attack,
      rarity: CardRarity.rare,
      cost: 2,
      description: '1 데미지를 패에 든 카드 수만큼 준다.',
      upgradeId: 'atk_r02_up',
      effects: [
        // Hits = hand size; combat logic handles scaling
        CardEffect(effectType: CardEffectType.damage, value: 1),
      ],
    ),
    'atk_r03': const CardData(
      id: 'atk_r03',
      name: '폭풍의 검',
      category: CardCategory.attack,
      rarity: CardRarity.rare,
      cost: 2,
      description: '5 데미지를 이번 턴 사용한 카드 수만큼 준다.',
      upgradeId: 'atk_r03_up',
      effects: [
        // Hits = cards played this turn; combat logic handles scaling
        CardEffect(effectType: CardEffectType.damage, value: 5),
      ],
    ),
    'atk_r04': const CardData(
      id: 'atk_r04',
      name: '사신의 낫',
      category: CardCategory.attack,
      rarity: CardRarity.rare,
      cost: 2,
      description: '15 데미지를 주고, 킬 시 HP 10을 회복한다.',
      upgradeId: 'atk_r04_up',
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 15),
        // Kill heal handled by combat engine
        CardEffect(
          effectType: CardEffectType.heal,
          value: 10,
          targetType: TargetType.self,
        ),
      ],
    ),
    'atk_r05': const CardData(
      id: 'atk_r05',
      name: '버서크',
      category: CardCategory.attack,
      rarity: CardRarity.rare,
      cost: 3,
      description: '힘 +5를 얻는다. 3턴 뒤 힘 -5.',
      upgradeId: 'atk_r05_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 5,
          duration: 3,
          targetType: TargetType.self,
          statusType: StatusType.strength,
        ),
      ],
    ),
  };

  static final Map<String, CardData> _attackRareUpgraded = {
    'atk_r01_up': const CardData(
      id: 'atk_r01_up',
      name: '용의 일격+',
      category: CardCategory.attack,
      rarity: CardRarity.rare,
      cost: 3,
      description: '40 데미지를 주고, 화상 4턴을 부여한다.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 40),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 4,
          statusType: StatusType.burn,
        ),
      ],
    ),
    'atk_r02_up': const CardData(
      id: 'atk_r02_up',
      name: '천 번의 베기+',
      category: CardCategory.attack,
      rarity: CardRarity.rare,
      cost: 2,
      description: '2 데미지를 패에 든 카드 수만큼 준다.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 2),
      ],
    ),
    'atk_r03_up': const CardData(
      id: 'atk_r03_up',
      name: '폭풍의 검+',
      category: CardCategory.attack,
      rarity: CardRarity.rare,
      cost: 2,
      description: '7 데미지를 이번 턴 사용한 카드 수만큼 준다.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 7),
      ],
    ),
    'atk_r04_up': const CardData(
      id: 'atk_r04_up',
      name: '사신의 낫+',
      category: CardCategory.attack,
      rarity: CardRarity.rare,
      cost: 2,
      description: '20 데미지를 주고, 킬 시 HP 15를 회복한다.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 20),
        CardEffect(
          effectType: CardEffectType.heal,
          value: 15,
          targetType: TargetType.self,
        ),
      ],
    ),
    'atk_r05_up': const CardData(
      id: 'atk_r05_up',
      name: '버서크+',
      category: CardCategory.attack,
      rarity: CardRarity.rare,
      cost: 3,
      description: '힘 +7을 얻는다. 3턴 뒤 힘 -5.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 7,
          duration: 3,
          targetType: TargetType.self,
          statusType: StatusType.strength,
        ),
      ],
    ),
  };

  // ═════════════════════════════════════════════
  //  ATTACK LEGENDARY (2 base + 2 upgraded)
  // ═════════════════════════════════════════════

  static final Map<String, CardData> _attackLegendary = {
    'atk_l01': const CardData(
      id: 'atk_l01',
      name: '엑스칼리버',
      category: CardCategory.attack,
      rarity: CardRarity.legendary,
      cost: 4,
      description: '50 데미지를 주고, 취약+약화 3턴을 부여한다. 사용 후 소멸.',
      upgradeId: 'atk_l01_up',
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 50),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 3,
          statusType: StatusType.vulnerable,
        ),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 3,
          statusType: StatusType.weak,
        ),
        CardEffect(effectType: CardEffectType.exhaust, value: 0),
      ],
    ),
    'atk_l02': const CardData(
      id: 'atk_l02',
      name: '무한의 칼날',
      category: CardCategory.attack,
      rarity: CardRarity.legendary,
      cost: 1,
      description: '8 데미지를 준다. 사용 시 이 카드 영구 +2 데미지.',
      upgradeId: 'atk_l02_up',
      effects: [
        // Permanent damage scaling handled by combat engine
        CardEffect(effectType: CardEffectType.damage, value: 8),
      ],
    ),
  };

  static final Map<String, CardData> _attackLegendaryUpgraded = {
    'atk_l01_up': const CardData(
      id: 'atk_l01_up',
      name: '엑스칼리버+',
      category: CardCategory.attack,
      rarity: CardRarity.legendary,
      cost: 4,
      description: '60 데미지를 주고, 취약+약화 3턴을 부여한다. 사용 후 소멸.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 60),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 3,
          statusType: StatusType.vulnerable,
        ),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 3,
          statusType: StatusType.weak,
        ),
        CardEffect(effectType: CardEffectType.exhaust, value: 0),
      ],
    ),
    'atk_l02_up': const CardData(
      id: 'atk_l02_up',
      name: '무한의 칼날+',
      category: CardCategory.attack,
      rarity: CardRarity.legendary,
      cost: 1,
      description: '12 데미지를 준다. 사용 시 이 카드 영구 +2 데미지.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 12),
      ],
    ),
  };

  // ═════════════════════════════════════════════
  //  MAGIC UNCOMMON (8 base + 8 upgraded)
  // ═════════════════════════════════════════════

  static final Map<String, CardData> _magicUncommon = {
    'mag_u01': const CardData(
      id: 'mag_u01',
      name: '연쇄 번개',
      category: CardCategory.magic,
      rarity: CardRarity.uncommon,
      cost: 2,
      description: '8 데미지를 주고, 적 전체에 4 데미지를 준다.',
      upgradeId: 'mag_u01_up',
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 8),
        CardEffect(
          effectType: CardEffectType.aoe,
          value: 4,
          targetType: TargetType.allEnemies,
        ),
      ],
    ),
    'mag_u02': const CardData(
      id: 'mag_u02',
      name: '빙결의 눈',
      category: CardCategory.magic,
      rarity: CardRarity.uncommon,
      cost: 2,
      description: '12 데미지를 주고, 빙결 1회를 부여한다.',
      upgradeId: 'mag_u02_up',
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 12),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 1,
          statusType: StatusType.freeze,
        ),
      ],
    ),
    'mag_u03': const CardData(
      id: 'mag_u03',
      name: '지혜의 책',
      category: CardCategory.magic,
      rarity: CardRarity.uncommon,
      cost: 1,
      description: '카드 3장을 드로우하고, 1장을 소멸시킨다.',
      upgradeId: 'mag_u03_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 3,
          targetType: TargetType.self,
        ),
        // Exhaust 1 card from hand handled by combat engine
      ],
    ),
    'mag_u04': const CardData(
      id: 'mag_u04',
      name: '마나 과부하',
      category: CardCategory.magic,
      rarity: CardRarity.uncommon,
      cost: 0,
      description: '에너지 +2를 얻는다. 다음 턴 에너지 -1.',
      upgradeId: 'mag_u04_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.gainEnergy,
          value: 2,
          targetType: TargetType.self,
        ),
      ],
    ),
    'mag_u05': const CardData(
      id: 'mag_u05',
      name: '원소 폭풍',
      category: CardCategory.magic,
      rarity: CardRarity.uncommon,
      cost: 3,
      description: '적 전체에 15 데미지를 준다.',
      upgradeId: 'mag_u05_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.aoe,
          value: 15,
          targetType: TargetType.allEnemies,
        ),
      ],
    ),
    'mag_u06': const CardData(
      id: 'mag_u06',
      name: '시간 왜곡',
      category: CardCategory.magic,
      rarity: CardRarity.uncommon,
      cost: 2,
      description: '추가 턴 1회를 얻는다 (에너지 0, 카드 유지).',
      upgradeId: 'mag_u06_up',
      effects: [
        // Extra turn handled by combat engine
        CardEffect(
          effectType: CardEffectType.gainEnergy,
          value: 0,
          targetType: TargetType.self,
        ),
      ],
    ),
    'mag_u07': const CardData(
      id: 'mag_u07',
      name: '마법 증폭',
      category: CardCategory.magic,
      rarity: CardRarity.uncommon,
      cost: 1,
      description: '집중 +2를 얻는다 (영구).',
      upgradeId: 'mag_u07_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 2,
          targetType: TargetType.self,
          statusType: StatusType.focus,
        ),
      ],
    ),
    'mag_u08': const CardData(
      id: 'mag_u08',
      name: '복제술',
      category: CardCategory.magic,
      rarity: CardRarity.uncommon,
      cost: 1,
      description: '패의 카드 1장을 복사한다 (이번 턴만).',
      upgradeId: 'mag_u08_up',
      effects: [
        // Card copy handled by combat engine
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 1,
          targetType: TargetType.self,
        ),
      ],
    ),
  };

  static final Map<String, CardData> _magicUncommonUpgraded = {
    'mag_u01_up': const CardData(
      id: 'mag_u01_up',
      name: '연쇄 번개+',
      category: CardCategory.magic,
      rarity: CardRarity.uncommon,
      cost: 2,
      description: '12 데미지를 주고, 적 전체에 6 데미지를 준다.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 12),
        CardEffect(
          effectType: CardEffectType.aoe,
          value: 6,
          targetType: TargetType.allEnemies,
        ),
      ],
    ),
    'mag_u02_up': const CardData(
      id: 'mag_u02_up',
      name: '빙결의 눈+',
      category: CardCategory.magic,
      rarity: CardRarity.uncommon,
      cost: 2,
      description: '16 데미지를 주고, 빙결 1회를 부여한다.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 16),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 1,
          statusType: StatusType.freeze,
        ),
      ],
    ),
    'mag_u03_up': const CardData(
      id: 'mag_u03_up',
      name: '지혜의 책+',
      category: CardCategory.magic,
      rarity: CardRarity.uncommon,
      cost: 1,
      description: '카드 4장을 드로우한다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 4,
          targetType: TargetType.self,
        ),
      ],
    ),
    'mag_u04_up': const CardData(
      id: 'mag_u04_up',
      name: '마나 과부하+',
      category: CardCategory.magic,
      rarity: CardRarity.uncommon,
      cost: 0,
      description: '에너지 +3을 얻는다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.gainEnergy,
          value: 3,
          targetType: TargetType.self,
        ),
      ],
    ),
    'mag_u05_up': const CardData(
      id: 'mag_u05_up',
      name: '원소 폭풍+',
      category: CardCategory.magic,
      rarity: CardRarity.uncommon,
      cost: 3,
      description: '적 전체에 20 데미지를 준다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.aoe,
          value: 20,
          targetType: TargetType.allEnemies,
        ),
      ],
    ),
    'mag_u06_up': const CardData(
      id: 'mag_u06_up',
      name: '시간 왜곡+',
      category: CardCategory.magic,
      rarity: CardRarity.uncommon,
      cost: 2,
      description: '추가 턴 1회를 얻는다 (에너지 1로 시작).',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.gainEnergy,
          value: 1,
          targetType: TargetType.self,
        ),
      ],
    ),
    'mag_u07_up': const CardData(
      id: 'mag_u07_up',
      name: '마법 증폭+',
      category: CardCategory.magic,
      rarity: CardRarity.uncommon,
      cost: 1,
      description: '집중 +3을 얻는다 (영구).',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 3,
          targetType: TargetType.self,
          statusType: StatusType.focus,
        ),
      ],
    ),
    'mag_u08_up': const CardData(
      id: 'mag_u08_up',
      name: '복제술+',
      category: CardCategory.magic,
      rarity: CardRarity.uncommon,
      cost: 0,
      description: '패의 카드 1장을 비용 0으로 복사한다 (이번 턴만).',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 1,
          targetType: TargetType.self,
        ),
      ],
    ),
  };

  // ═════════════════════════════════════════════
  //  MAGIC RARE (5 base + 5 upgraded)
  // ═════════════════════════════════════════════

  static final Map<String, CardData> _magicRare = {
    'mag_r01': const CardData(
      id: 'mag_r01',
      name: '메테오',
      category: CardCategory.magic,
      rarity: CardRarity.rare,
      cost: 4,
      description: '적 전체에 25 데미지를 주고, 화상 3턴을 부여한다.',
      upgradeId: 'mag_r01_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.aoe,
          value: 25,
          targetType: TargetType.allEnemies,
        ),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 3,
          targetType: TargetType.allEnemies,
          statusType: StatusType.burn,
        ),
      ],
    ),
    'mag_r02': const CardData(
      id: 'mag_r02',
      name: '마나 폭주',
      category: CardCategory.magic,
      rarity: CardRarity.rare,
      cost: 2,
      description: '패의 모든 카드 비용이 이번 턴 0이 된다.',
      upgradeId: 'mag_r02_up',
      effects: [
        // Cost reduction handled by combat engine
        CardEffect(
          effectType: CardEffectType.gainEnergy,
          value: 3,
          targetType: TargetType.self,
        ),
      ],
    ),
    'mag_r03': const CardData(
      id: 'mag_r03',
      name: '차원의 균열',
      category: CardCategory.magic,
      rarity: CardRarity.rare,
      cost: 3,
      description: '디스카드 파일에서 3장을 패로 가져온다.',
      upgradeId: 'mag_r03_up',
      effects: [
        // Discard pile retrieval handled by combat engine
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 3,
          targetType: TargetType.self,
        ),
      ],
    ),
    'mag_r04': const CardData(
      id: 'mag_r04',
      name: '영혼 흡수',
      category: CardCategory.magic,
      rarity: CardRarity.rare,
      cost: 2,
      description: '12 데미지를 주고, 같은 양 HP를 회복한다.',
      upgradeId: 'mag_r04_up',
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 12),
        CardEffect(
          effectType: CardEffectType.heal,
          value: 12,
          targetType: TargetType.self,
        ),
      ],
    ),
    'mag_r05': const CardData(
      id: 'mag_r05',
      name: '절대영도',
      category: CardCategory.magic,
      rarity: CardRarity.rare,
      cost: 3,
      description: '적 전체를 빙결시키고, 10 데미지를 준다.',
      upgradeId: 'mag_r05_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 1,
          targetType: TargetType.allEnemies,
          statusType: StatusType.freeze,
        ),
        CardEffect(
          effectType: CardEffectType.aoe,
          value: 10,
          targetType: TargetType.allEnemies,
        ),
      ],
    ),
  };

  static final Map<String, CardData> _magicRareUpgraded = {
    'mag_r01_up': const CardData(
      id: 'mag_r01_up',
      name: '메테오+',
      category: CardCategory.magic,
      rarity: CardRarity.rare,
      cost: 4,
      description: '적 전체에 35 데미지를 주고, 화상 3턴을 부여한다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.aoe,
          value: 35,
          targetType: TargetType.allEnemies,
        ),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 3,
          targetType: TargetType.allEnemies,
          statusType: StatusType.burn,
        ),
      ],
    ),
    'mag_r02_up': const CardData(
      id: 'mag_r02_up',
      name: '마나 폭주+',
      category: CardCategory.magic,
      rarity: CardRarity.rare,
      cost: 2,
      description: '패의 모든 카드 비용이 다음 턴까지 0이 된다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.gainEnergy,
          value: 3,
          targetType: TargetType.self,
        ),
      ],
    ),
    'mag_r03_up': const CardData(
      id: 'mag_r03_up',
      name: '차원의 균열+',
      category: CardCategory.magic,
      rarity: CardRarity.rare,
      cost: 3,
      description: '디스카드 파일에서 5장을 패로 가져온다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 5,
          targetType: TargetType.self,
        ),
      ],
    ),
    'mag_r04_up': const CardData(
      id: 'mag_r04_up',
      name: '영혼 흡수+',
      category: CardCategory.magic,
      rarity: CardRarity.rare,
      cost: 2,
      description: '18 데미지를 주고, 같은 양 HP를 회복한다.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 18),
        CardEffect(
          effectType: CardEffectType.heal,
          value: 18,
          targetType: TargetType.self,
        ),
      ],
    ),
    'mag_r05_up': const CardData(
      id: 'mag_r05_up',
      name: '절대영도+',
      category: CardCategory.magic,
      rarity: CardRarity.rare,
      cost: 3,
      description: '적 전체를 빙결시키고, 15 데미지를 준다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 1,
          targetType: TargetType.allEnemies,
          statusType: StatusType.freeze,
        ),
        CardEffect(
          effectType: CardEffectType.aoe,
          value: 15,
          targetType: TargetType.allEnemies,
        ),
      ],
    ),
  };

  // ═════════════════════════════════════════════
  //  MAGIC LEGENDARY (2 base + 2 upgraded)
  // ═════════════════════════════════════════════

  static final Map<String, CardData> _magicLegendary = {
    'mag_l01': const CardData(
      id: 'mag_l01',
      name: '아마겟돈',
      category: CardCategory.magic,
      rarity: CardRarity.legendary,
      cost: 5,
      description: '적 전체에 99 데미지를 준다. 자신도 30 데미지. 사용 후 소멸.',
      upgradeId: 'mag_l01_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.aoe,
          value: 99,
          targetType: TargetType.allEnemies,
        ),
        CardEffect(
          effectType: CardEffectType.damage,
          value: 30,
          targetType: TargetType.self,
        ),
        CardEffect(effectType: CardEffectType.exhaust, value: 0),
      ],
    ),
    'mag_l02': const CardData(
      id: 'mag_l02',
      name: '무한의 지혜',
      category: CardCategory.magic,
      rarity: CardRarity.legendary,
      cost: 2,
      description: '카드 5장을 드로우하고, 에너지 +2를 얻는다. 사용 후 소멸.',
      upgradeId: 'mag_l02_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 5,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.gainEnergy,
          value: 2,
          targetType: TargetType.self,
        ),
        CardEffect(effectType: CardEffectType.exhaust, value: 0),
      ],
    ),
  };

  static final Map<String, CardData> _magicLegendaryUpgraded = {
    'mag_l01_up': const CardData(
      id: 'mag_l01_up',
      name: '아마겟돈+',
      category: CardCategory.magic,
      rarity: CardRarity.legendary,
      cost: 5,
      description: '적 전체에 99 데미지를 준다. 자신 15 데미지. 사용 후 소멸.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.aoe,
          value: 99,
          targetType: TargetType.allEnemies,
        ),
        CardEffect(
          effectType: CardEffectType.damage,
          value: 15,
          targetType: TargetType.self,
        ),
        CardEffect(effectType: CardEffectType.exhaust, value: 0),
      ],
    ),
    'mag_l02_up': const CardData(
      id: 'mag_l02_up',
      name: '무한의 지혜+',
      category: CardCategory.magic,
      rarity: CardRarity.legendary,
      cost: 2,
      description: '카드 7장을 드로우하고, 에너지 +3을 얻는다. 사용 후 소멸.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 7,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.gainEnergy,
          value: 3,
          targetType: TargetType.self,
        ),
        CardEffect(effectType: CardEffectType.exhaust, value: 0),
      ],
    ),
  };

  // ═════════════════════════════════════════════
  //  DEFENSE UNCOMMON (8 base + 8 upgraded)
  // ═════════════════════════════════════════════

  static final Map<String, CardData> _defenseUncommon = {
    'def_u01': const CardData(
      id: 'def_u01',
      name: '바리케이드',
      category: CardCategory.defense,
      rarity: CardRarity.uncommon,
      cost: 2,
      description: '방어도 12를 얻고, 불굴 2턴을 얻는다.',
      upgradeId: 'def_u01_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 12,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 1,
          duration: 2,
          targetType: TargetType.self,
          statusType: StatusType.fortify,
        ),
      ],
    ),
    'def_u02': const CardData(
      id: 'def_u02',
      name: '반사 방어막',
      category: CardCategory.defense,
      rarity: CardRarity.uncommon,
      cost: 2,
      description: '방어도 8을 얻고, 가시 5를 얻는다 (이번 턴).',
      upgradeId: 'def_u02_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 8,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 5,
          duration: 1,
          targetType: TargetType.self,
          statusType: StatusType.thorns,
        ),
      ],
    ),
    'def_u03': const CardData(
      id: 'def_u03',
      name: '재생의 기도',
      category: CardCategory.defense,
      rarity: CardRarity.uncommon,
      cost: 2,
      description: 'HP 10을 회복하고, 재생 2를 얻는다 (3턴).',
      upgradeId: 'def_u03_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.heal,
          value: 10,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 2,
          duration: 3,
          targetType: TargetType.self,
          statusType: StatusType.regen,
        ),
      ],
    ),
    'def_u04': const CardData(
      id: 'def_u04',
      name: '불굴의 의지',
      category: CardCategory.defense,
      rarity: CardRarity.uncommon,
      cost: 1,
      description: '민첩 +2를 얻는다 (영구).',
      upgradeId: 'def_u04_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 2,
          targetType: TargetType.self,
          statusType: StatusType.dexterity,
        ),
      ],
    ),
    'def_u05': const CardData(
      id: 'def_u05',
      name: '보호막',
      category: CardCategory.defense,
      rarity: CardRarity.uncommon,
      cost: 1,
      description: '잃은 HP의 25%만큼 방어도를 얻는다.',
      upgradeId: 'def_u05_up',
      effects: [
        // Percentage-based block handled by combat engine; base value as estimate
        CardEffect(
          effectType: CardEffectType.block,
          value: 10,
          targetType: TargetType.self,
        ),
      ],
    ),
    'def_u06': const CardData(
      id: 'def_u06',
      name: '생존 본능',
      category: CardCategory.defense,
      rarity: CardRarity.uncommon,
      cost: 0,
      description: 'HP 50% 이하면 방어도 15, 아니면 5.',
      upgradeId: 'def_u06_up',
      effects: [
        // Conditional block handled by combat engine; uses higher value
        CardEffect(
          effectType: CardEffectType.block,
          value: 15,
          targetType: TargetType.self,
        ),
      ],
    ),
    'def_u07': const CardData(
      id: 'def_u07',
      name: '흡혈 가시',
      category: CardCategory.defense,
      rarity: CardRarity.uncommon,
      cost: 2,
      description: '가시 3을 얻는다 (영구). 피격 시 HP 1을 회복한다.',
      upgradeId: 'def_u07_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 3,
          targetType: TargetType.self,
          statusType: StatusType.thorns,
        ),
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 1,
          targetType: TargetType.self,
          statusType: StatusType.regen,
        ),
      ],
    ),
    'def_u08': const CardData(
      id: 'def_u08',
      name: '강화 갑옷',
      category: CardCategory.defense,
      rarity: CardRarity.uncommon,
      cost: 3,
      description: '방어도 20을 얻고, 다음 턴 방어도 10을 얻는다.',
      upgradeId: 'def_u08_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 20,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.block,
          value: 10,
          targetType: TargetType.self,
          duration: 1,
        ),
      ],
    ),
  };

  static final Map<String, CardData> _defenseUncommonUpgraded = {
    'def_u01_up': const CardData(
      id: 'def_u01_up',
      name: '바리케이드+',
      category: CardCategory.defense,
      rarity: CardRarity.uncommon,
      cost: 2,
      description: '방어도 16을 얻고, 불굴 3턴을 얻는다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 16,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 1,
          duration: 3,
          targetType: TargetType.self,
          statusType: StatusType.fortify,
        ),
      ],
    ),
    'def_u02_up': const CardData(
      id: 'def_u02_up',
      name: '반사 방어막+',
      category: CardCategory.defense,
      rarity: CardRarity.uncommon,
      cost: 2,
      description: '방어도 12를 얻고, 가시 7을 얻는다 (이번 턴).',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 12,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 7,
          duration: 1,
          targetType: TargetType.self,
          statusType: StatusType.thorns,
        ),
      ],
    ),
    'def_u03_up': const CardData(
      id: 'def_u03_up',
      name: '재생의 기도+',
      category: CardCategory.defense,
      rarity: CardRarity.uncommon,
      cost: 2,
      description: 'HP 15를 회복하고, 재생 3을 얻는다 (3턴).',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.heal,
          value: 15,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 3,
          duration: 3,
          targetType: TargetType.self,
          statusType: StatusType.regen,
        ),
      ],
    ),
    'def_u04_up': const CardData(
      id: 'def_u04_up',
      name: '불굴의 의지+',
      category: CardCategory.defense,
      rarity: CardRarity.uncommon,
      cost: 1,
      description: '민첩 +3을 얻는다 (영구).',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 3,
          targetType: TargetType.self,
          statusType: StatusType.dexterity,
        ),
      ],
    ),
    'def_u05_up': const CardData(
      id: 'def_u05_up',
      name: '보호막+',
      category: CardCategory.defense,
      rarity: CardRarity.uncommon,
      cost: 1,
      description: '잃은 HP의 30%만큼 방어도를 얻는다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 12,
          targetType: TargetType.self,
        ),
      ],
    ),
    'def_u06_up': const CardData(
      id: 'def_u06_up',
      name: '생존 본능+',
      category: CardCategory.defense,
      rarity: CardRarity.uncommon,
      cost: 0,
      description: 'HP 50% 이하면 방어도 20, 아니면 8.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 20,
          targetType: TargetType.self,
        ),
      ],
    ),
    'def_u07_up': const CardData(
      id: 'def_u07_up',
      name: '흡혈 가시+',
      category: CardCategory.defense,
      rarity: CardRarity.uncommon,
      cost: 2,
      description: '가시 4를 얻는다 (영구). 피격 시 HP 2를 회복한다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 4,
          targetType: TargetType.self,
          statusType: StatusType.thorns,
        ),
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 2,
          targetType: TargetType.self,
          statusType: StatusType.regen,
        ),
      ],
    ),
    'def_u08_up': const CardData(
      id: 'def_u08_up',
      name: '강화 갑옷+',
      category: CardCategory.defense,
      rarity: CardRarity.uncommon,
      cost: 3,
      description: '방어도 25를 얻고, 다음 턴 방어도 15를 얻는다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 25,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.block,
          value: 15,
          targetType: TargetType.self,
          duration: 1,
        ),
      ],
    ),
  };

  // ═════════════════════════════════════════════
  //  DEFENSE RARE (5 base + 5 upgraded)
  // ═════════════════════════════════════════════

  static final Map<String, CardData> _defenseRare = {
    'def_r01': const CardData(
      id: 'def_r01',
      name: '무적',
      category: CardCategory.defense,
      rarity: CardRarity.rare,
      cost: 3,
      description: '이번 턴 모든 데미지를 0으로 만든다. 사용 후 소멸.',
      upgradeId: 'def_r01_up',
      effects: [
        // Invulnerability handled by combat engine; large block as approximation
        CardEffect(
          effectType: CardEffectType.block,
          value: 999,
          targetType: TargetType.self,
        ),
        CardEffect(effectType: CardEffectType.exhaust, value: 0),
      ],
    ),
    'def_r02': const CardData(
      id: 'def_r02',
      name: '생명의 나무',
      category: CardCategory.defense,
      rarity: CardRarity.rare,
      cost: 2,
      description: 'HP 전체의 30%를 회복한다.',
      upgradeId: 'def_r02_up',
      effects: [
        // Percentage heal handled by combat engine
        CardEffect(
          effectType: CardEffectType.heal,
          value: 30,
          targetType: TargetType.self,
        ),
      ],
    ),
    'def_r03': const CardData(
      id: 'def_r03',
      name: '성스러운 방패',
      category: CardCategory.defense,
      rarity: CardRarity.rare,
      cost: 2,
      description: '방어도 20을 얻고, 디버프를 모두 해제한다.',
      upgradeId: 'def_r03_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 20,
          targetType: TargetType.self,
        ),
        // Debuff cleanse handled by combat engine
      ],
    ),
    'def_r04': const CardData(
      id: 'def_r04',
      name: '철의 몸',
      category: CardCategory.defense,
      rarity: CardRarity.rare,
      cost: 2,
      description: '매 턴 방어도 8을 자동으로 얻는다 (전투 동안).',
      upgradeId: 'def_r04_up',
      effects: [
        // Auto-block per turn handled by combat engine
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 8,
          targetType: TargetType.self,
          statusType: StatusType.dexterity,
        ),
      ],
    ),
    'def_r05': const CardData(
      id: 'def_r05',
      name: '부활의 비약',
      category: CardCategory.defense,
      rarity: CardRarity.rare,
      cost: 1,
      description: '이번 전투에서 사망 시 HP 30%로 부활한다. 사용 후 소멸.',
      upgradeId: 'def_r05_up',
      effects: [
        // Revive on death handled by combat engine
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 30,
          targetType: TargetType.self,
          statusType: StatusType.regen,
        ),
        CardEffect(effectType: CardEffectType.exhaust, value: 0),
      ],
    ),
  };

  static final Map<String, CardData> _defenseRareUpgraded = {
    'def_r01_up': const CardData(
      id: 'def_r01_up',
      name: '무적+',
      category: CardCategory.defense,
      rarity: CardRarity.rare,
      cost: 3,
      description: '이번 턴과 다음 턴 모든 데미지를 0으로 만든다. 사용 후 소멸.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 999,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.block,
          value: 999,
          targetType: TargetType.self,
          duration: 1,
        ),
        CardEffect(effectType: CardEffectType.exhaust, value: 0),
      ],
    ),
    'def_r02_up': const CardData(
      id: 'def_r02_up',
      name: '생명의 나무+',
      category: CardCategory.defense,
      rarity: CardRarity.rare,
      cost: 2,
      description: 'HP 전체의 40%를 회복한다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.heal,
          value: 40,
          targetType: TargetType.self,
        ),
      ],
    ),
    'def_r03_up': const CardData(
      id: 'def_r03_up',
      name: '성스러운 방패+',
      category: CardCategory.defense,
      rarity: CardRarity.rare,
      cost: 2,
      description: '방어도 28을 얻고, 디버프를 모두 해제한다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 28,
          targetType: TargetType.self,
        ),
      ],
    ),
    'def_r04_up': const CardData(
      id: 'def_r04_up',
      name: '철의 몸+',
      category: CardCategory.defense,
      rarity: CardRarity.rare,
      cost: 2,
      description: '매 턴 방어도 12를 자동으로 얻는다 (전투 동안).',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 12,
          targetType: TargetType.self,
          statusType: StatusType.dexterity,
        ),
      ],
    ),
    'def_r05_up': const CardData(
      id: 'def_r05_up',
      name: '부활의 비약+',
      category: CardCategory.defense,
      rarity: CardRarity.rare,
      cost: 1,
      description: '이번 전투에서 사망 시 HP 50%로 부활한다. 사용 후 소멸.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 50,
          targetType: TargetType.self,
          statusType: StatusType.regen,
        ),
        CardEffect(effectType: CardEffectType.exhaust, value: 0),
      ],
    ),
  };

  // ═════════════════════════════════════════════
  //  DEFENSE LEGENDARY (2 base + 2 upgraded)
  // ═════════════════════════════════════════════

  static final Map<String, CardData> _defenseLegendary = {
    'def_l01': const CardData(
      id: 'def_l01',
      name: '영원의 방패',
      category: CardCategory.defense,
      rarity: CardRarity.legendary,
      cost: 3,
      description: '방어도 30을 얻고, 매 턴 방어도 5를 자동으로 얻는다 (전투 동안). 사용 후 소멸.',
      upgradeId: 'def_l01_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 30,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 5,
          targetType: TargetType.self,
          statusType: StatusType.dexterity,
        ),
        CardEffect(effectType: CardEffectType.exhaust, value: 0),
      ],
    ),
    'def_l02': const CardData(
      id: 'def_l02',
      name: '생명의 원천',
      category: CardCategory.defense,
      rarity: CardRarity.legendary,
      cost: 4,
      description: 'HP를 완전 회복하고, 최대 HP +10 (영구). 사용 후 소멸.',
      upgradeId: 'def_l02_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.heal,
          value: 999,
          targetType: TargetType.self,
        ),
        CardEffect(effectType: CardEffectType.exhaust, value: 0),
      ],
    ),
  };

  static final Map<String, CardData> _defenseLegendaryUpgraded = {
    'def_l01_up': const CardData(
      id: 'def_l01_up',
      name: '영원의 방패+',
      category: CardCategory.defense,
      rarity: CardRarity.legendary,
      cost: 3,
      description: '방어도 40을 얻고, 매 턴 방어도 8을 자동으로 얻는다 (전투 동안). 사용 후 소멸.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 40,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 8,
          targetType: TargetType.self,
          statusType: StatusType.dexterity,
        ),
        CardEffect(effectType: CardEffectType.exhaust, value: 0),
      ],
    ),
    'def_l02_up': const CardData(
      id: 'def_l02_up',
      name: '생명의 원천+',
      category: CardCategory.defense,
      rarity: CardRarity.legendary,
      cost: 4,
      description: 'HP를 완전 회복하고, 최대 HP +20 (영구). 사용 후 소멸.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.heal,
          value: 999,
          targetType: TargetType.self,
        ),
        CardEffect(effectType: CardEffectType.exhaust, value: 0),
      ],
    ),
  };

  // ═════════════════════════════════════════════
  //  TACTICAL UNCOMMON (8 base + 8 upgraded)
  // ═════════════════════════════════════════════

  static final Map<String, CardData> _tacticalUncommon = {
    'tac_u01': const CardData(
      id: 'tac_u01',
      name: '전장 분석',
      category: CardCategory.tactical,
      rarity: CardRarity.uncommon,
      cost: 1,
      description: '카드 3장을 드로우하고, 비용이 가장 높은 카드의 이번 턴 비용을 0으로 만든다.',
      upgradeId: 'tac_u01_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 3,
          targetType: TargetType.self,
        ),
        // Cost reduction handled by combat engine
      ],
    ),
    'tac_u02': const CardData(
      id: 'tac_u02',
      name: '그림자 이동',
      category: CardCategory.tactical,
      rarity: CardRarity.uncommon,
      cost: 1,
      description: '다음 턴까지 받는 데미지가 50% 감소한다.',
      upgradeId: 'tac_u02_up',
      effects: [
        // Damage reduction handled by combat engine; approximate as block
        CardEffect(
          effectType: CardEffectType.block,
          value: 10,
          targetType: TargetType.self,
          duration: 1,
        ),
      ],
    ),
    'tac_u03': const CardData(
      id: 'tac_u03',
      name: '보물 상자',
      category: CardCategory.tactical,
      rarity: CardRarity.uncommon,
      cost: 2,
      description: '랜덤 렐릭 효과를 1회 발동한다. 사용 후 소멸.',
      upgradeId: 'tac_u03_up',
      effects: [
        // Random relic effect handled by combat engine
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 1,
          targetType: TargetType.self,
        ),
        CardEffect(effectType: CardEffectType.exhaust, value: 0),
      ],
    ),
    'tac_u04': const CardData(
      id: 'tac_u04',
      name: '카드 조작',
      category: CardCategory.tactical,
      rarity: CardRarity.uncommon,
      cost: 1,
      description: '드로우 파일 상위 3장을 원하는 순서로 정렬한다.',
      upgradeId: 'tac_u04_up',
      effects: [
        // Card ordering handled by combat engine
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 1,
          targetType: TargetType.self,
        ),
      ],
    ),
    'tac_u05': const CardData(
      id: 'tac_u05',
      name: '이중 스파이',
      category: CardCategory.tactical,
      rarity: CardRarity.uncommon,
      cost: 1,
      description: '적의 버프를 복사하고, 적의 버프를 제거한다.',
      upgradeId: 'tac_u05_up',
      effects: [
        // Buff steal handled by combat engine
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 1,
          targetType: TargetType.self,
        ),
      ],
    ),
    'tac_u06': const CardData(
      id: 'tac_u06',
      name: '전략적 후퇴',
      category: CardCategory.tactical,
      rarity: CardRarity.uncommon,
      cost: 0,
      description: '패 전부를 셔플하고, 새로 5장을 드로우한다.',
      upgradeId: 'tac_u06_up',
      effects: [
        // Hand shuffle + redraw handled by combat engine
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 5,
          targetType: TargetType.self,
        ),
      ],
    ),
    'tac_u07': const CardData(
      id: 'tac_u07',
      name: '물물교환',
      category: CardCategory.tactical,
      rarity: CardRarity.uncommon,
      cost: 0,
      description: '패에서 1장을 소멸시키고, 랜덤 카드 2장을 생성한다.',
      upgradeId: 'tac_u07_up',
      effects: [
        // Exhaust + generate handled by combat engine
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 2,
          targetType: TargetType.self,
        ),
      ],
    ),
    'tac_u08': const CardData(
      id: 'tac_u08',
      name: '연쇄 함정',
      category: CardCategory.tactical,
      rarity: CardRarity.uncommon,
      cost: 2,
      description: '가시 3을 얻는다 (영구). 적 공격 시 약화 1턴을 부여한다.',
      upgradeId: 'tac_u08_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 3,
          targetType: TargetType.self,
          statusType: StatusType.thorns,
        ),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 1,
          statusType: StatusType.weak,
        ),
      ],
    ),
  };

  static final Map<String, CardData> _tacticalUncommonUpgraded = {
    'tac_u01_up': const CardData(
      id: 'tac_u01_up',
      name: '전장 분석+',
      category: CardCategory.tactical,
      rarity: CardRarity.uncommon,
      cost: 1,
      description: '카드 4장을 드로우하고, 비용이 가장 높은 카드의 이번 턴 비용을 0으로 만든다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 4,
          targetType: TargetType.self,
        ),
      ],
    ),
    'tac_u02_up': const CardData(
      id: 'tac_u02_up',
      name: '그림자 이동+',
      category: CardCategory.tactical,
      rarity: CardRarity.uncommon,
      cost: 1,
      description: '다음 턴까지 받는 데미지가 50% 감소하고, 카드 1장을 드로우한다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.block,
          value: 10,
          targetType: TargetType.self,
          duration: 1,
        ),
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 1,
          targetType: TargetType.self,
        ),
      ],
    ),
    'tac_u03_up': const CardData(
      id: 'tac_u03_up',
      name: '보물 상자+',
      category: CardCategory.tactical,
      rarity: CardRarity.uncommon,
      cost: 2,
      description: '랜덤 렐릭 효과를 2회 발동한다. 사용 후 소멸.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 2,
          targetType: TargetType.self,
        ),
        CardEffect(effectType: CardEffectType.exhaust, value: 0),
      ],
    ),
    'tac_u04_up': const CardData(
      id: 'tac_u04_up',
      name: '카드 조작+',
      category: CardCategory.tactical,
      rarity: CardRarity.uncommon,
      cost: 1,
      description: '드로우 파일 상위 5장을 원하는 순서로 정렬한다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 2,
          targetType: TargetType.self,
        ),
      ],
    ),
    'tac_u05_up': const CardData(
      id: 'tac_u05_up',
      name: '이중 스파이+',
      category: CardCategory.tactical,
      rarity: CardRarity.uncommon,
      cost: 1,
      description: '적의 버프를 복사하고, 적의 버프를 제거하고, 5 데미지를 준다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 1,
          targetType: TargetType.self,
        ),
        CardEffect(effectType: CardEffectType.damage, value: 5),
      ],
    ),
    'tac_u06_up': const CardData(
      id: 'tac_u06_up',
      name: '전략적 후퇴+',
      category: CardCategory.tactical,
      rarity: CardRarity.uncommon,
      cost: 0,
      description: '패 전부를 셔플하고, 새로 6장을 드로우한다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 6,
          targetType: TargetType.self,
        ),
      ],
    ),
    'tac_u07_up': const CardData(
      id: 'tac_u07_up',
      name: '물물교환+',
      category: CardCategory.tactical,
      rarity: CardRarity.uncommon,
      cost: 0,
      description: '패에서 1장을 소멸시키고, 랜덤 카드 3장을 생성한다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 3,
          targetType: TargetType.self,
        ),
      ],
    ),
    'tac_u08_up': const CardData(
      id: 'tac_u08_up',
      name: '연쇄 함정+',
      category: CardCategory.tactical,
      rarity: CardRarity.uncommon,
      cost: 2,
      description: '가시 5를 얻는다 (영구). 적 공격 시 약화 1턴을 부여한다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 5,
          targetType: TargetType.self,
          statusType: StatusType.thorns,
        ),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 1,
          statusType: StatusType.weak,
        ),
      ],
    ),
  };

  // ═════════════════════════════════════════════
  //  TACTICAL RARE (5 base + 5 upgraded)
  // ═════════════════════════════════════════════

  static final Map<String, CardData> _tacticalRare = {
    'tac_r01': const CardData(
      id: 'tac_r01',
      name: '완벽한 계획',
      category: CardCategory.tactical,
      rarity: CardRarity.rare,
      cost: 2,
      description: '에너지 +3, 카드 3장을 드로우한다. 다음 턴 드로우 0.',
      upgradeId: 'tac_r01_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.gainEnergy,
          value: 3,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 3,
          targetType: TargetType.self,
        ),
        // Next turn draw 0 handled by combat engine
      ],
    ),
    'tac_r02': const CardData(
      id: 'tac_r02',
      name: '운명의 바퀴',
      category: CardCategory.tactical,
      rarity: CardRarity.rare,
      cost: 1,
      description: '랜덤 효과 1회: 데미지 15, 방어 15, 회복 15, 에너지 +2 중 하나.',
      upgradeId: 'tac_r02_up',
      effects: [
        // Random effect handled by combat engine; default to damage
        CardEffect(effectType: CardEffectType.damage, value: 15),
      ],
    ),
    'tac_r03': const CardData(
      id: 'tac_r03',
      name: '도플갱어',
      category: CardCategory.tactical,
      rarity: CardRarity.rare,
      cost: 3,
      description: '이번 턴 사용한 카드 전부를 다시 패로 가져온다.',
      upgradeId: 'tac_r03_up',
      effects: [
        // Card retrieval handled by combat engine
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 3,
          targetType: TargetType.self,
        ),
      ],
    ),
    'tac_r04': const CardData(
      id: 'tac_r04',
      name: '탐욕의 손',
      category: CardCategory.tactical,
      rarity: CardRarity.rare,
      cost: 1,
      description: '6 데미지를 준다. 킬 시 카드 보상 1장을 추가로 받는다.',
      upgradeId: 'tac_r04_up',
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 6),
        // Extra card reward on kill handled by combat engine
      ],
    ),
    'tac_r05': const CardData(
      id: 'tac_r05',
      name: '대혼란',
      category: CardCategory.tactical,
      rarity: CardRarity.rare,
      cost: 2,
      description: '적 전체에 취약+약화 2턴, 독 3을 부여한다.',
      upgradeId: 'tac_r05_up',
      effects: [
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 2,
          targetType: TargetType.allEnemies,
          statusType: StatusType.vulnerable,
        ),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 2,
          targetType: TargetType.allEnemies,
          statusType: StatusType.weak,
        ),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 3,
          targetType: TargetType.allEnemies,
          statusType: StatusType.poison,
        ),
      ],
    ),
  };

  static final Map<String, CardData> _tacticalRareUpgraded = {
    'tac_r01_up': const CardData(
      id: 'tac_r01_up',
      name: '완벽한 계획+',
      category: CardCategory.tactical,
      rarity: CardRarity.rare,
      cost: 2,
      description: '에너지 +3, 카드 3장을 드로우한다. 다음 턴 드로우 2.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.gainEnergy,
          value: 3,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 3,
          targetType: TargetType.self,
        ),
      ],
    ),
    'tac_r02_up': const CardData(
      id: 'tac_r02_up',
      name: '운명의 바퀴+',
      category: CardCategory.tactical,
      rarity: CardRarity.rare,
      cost: 1,
      description: '랜덤 효과 2회: 데미지 15, 방어 15, 회복 15, 에너지 +2 중 하나.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 15),
        CardEffect(effectType: CardEffectType.damage, value: 15),
      ],
    ),
    'tac_r03_up': const CardData(
      id: 'tac_r03_up',
      name: '도플갱어+',
      category: CardCategory.tactical,
      rarity: CardRarity.rare,
      cost: 3,
      description: '이번 턴 사용한 카드 전부를 다시 패로 가져오고, 에너지 +2를 얻는다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.drawCard,
          value: 3,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.gainEnergy,
          value: 2,
          targetType: TargetType.self,
        ),
      ],
    ),
    'tac_r04_up': const CardData(
      id: 'tac_r04_up',
      name: '탐욕의 손+',
      category: CardCategory.tactical,
      rarity: CardRarity.rare,
      cost: 1,
      description: '10 데미지를 준다. 킬 시 카드 보상 1장을 추가로 받는다.',
      isUpgraded: true,
      effects: [
        CardEffect(effectType: CardEffectType.damage, value: 10),
      ],
    ),
    'tac_r05_up': const CardData(
      id: 'tac_r05_up',
      name: '대혼란+',
      category: CardCategory.tactical,
      rarity: CardRarity.rare,
      cost: 2,
      description: '적 전체에 취약+약화 3턴, 독 3을 부여한다.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 3,
          targetType: TargetType.allEnemies,
          statusType: StatusType.vulnerable,
        ),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 1,
          duration: 3,
          targetType: TargetType.allEnemies,
          statusType: StatusType.weak,
        ),
        CardEffect(
          effectType: CardEffectType.applyDebuff,
          value: 3,
          targetType: TargetType.allEnemies,
          statusType: StatusType.poison,
        ),
      ],
    ),
  };

  // ═════════════════════════════════════════════
  //  TACTICAL LEGENDARY (2 base + 2 upgraded)
  // ═════════════════════════════════════════════

  static final Map<String, CardData> _tacticalLegendary = {
    'tac_l01': const CardData(
      id: 'tac_l01',
      name: '시간의 주인',
      category: CardCategory.tactical,
      rarity: CardRarity.legendary,
      cost: 3,
      description: '추가 턴 2회를 얻는다 (에너지 2씩). 사용 후 소멸.',
      upgradeId: 'tac_l01_up',
      effects: [
        // Extra turns handled by combat engine
        CardEffect(
          effectType: CardEffectType.gainEnergy,
          value: 2,
          targetType: TargetType.self,
        ),
        CardEffect(effectType: CardEffectType.exhaust, value: 0),
      ],
    ),
    'tac_l02': const CardData(
      id: 'tac_l02',
      name: '운명 변환',
      category: CardCategory.tactical,
      rarity: CardRarity.legendary,
      cost: 0,
      description: '덱의 모든 카드를 이번 전투 동안 업그레이드한다. 사용 후 소멸.',
      upgradeId: 'tac_l02_up',
      effects: [
        // Mass upgrade handled by combat engine
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 99,
          targetType: TargetType.self,
        ),
        CardEffect(effectType: CardEffectType.exhaust, value: 0),
      ],
    ),
  };

  static final Map<String, CardData> _tacticalLegendaryUpgraded = {
    'tac_l01_up': const CardData(
      id: 'tac_l01_up',
      name: '시간의 주인+',
      category: CardCategory.tactical,
      rarity: CardRarity.legendary,
      cost: 3,
      description: '추가 턴 2회를 얻는다 (에너지 3씩). 사용 후 소멸.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.gainEnergy,
          value: 3,
          targetType: TargetType.self,
        ),
        CardEffect(effectType: CardEffectType.exhaust, value: 0),
      ],
    ),
    'tac_l02_up': const CardData(
      id: 'tac_l02_up',
      name: '운명 변환+',
      category: CardCategory.tactical,
      rarity: CardRarity.legendary,
      cost: 0,
      description: '덱의 모든 카드를 이번 전투 동안 업그레이드하고, 에너지 +2를 얻는다. 사용 후 소멸.',
      isUpgraded: true,
      effects: [
        CardEffect(
          effectType: CardEffectType.applyBuff,
          value: 99,
          targetType: TargetType.self,
        ),
        CardEffect(
          effectType: CardEffectType.gainEnergy,
          value: 2,
          targetType: TargetType.self,
        ),
        CardEffect(effectType: CardEffectType.exhaust, value: 0),
      ],
    ),
  };
}
