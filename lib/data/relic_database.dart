import 'dart:math';

import 'package:life_quest_final_v2/models/relic_data.dart';

class RelicDatabase {
  static final Random _random = Random();

  static List<RelicData> get allRelics => [
        ...starterRelics,
        ..._commonRelics,
        ..._uncommonRelics,
        ..._rareRelics,
        ..._bossRelics,
      ];

  static List<RelicData> get starterRelics => const [
        RelicData(
          id: 'relic_start_01',
          name: '모험자의 가방',
          rarity: RelicRarity.starter,
          description: '전투 보상 카드 선택지 +1장 (3→4)',
          trigger: RelicTrigger.passive,
        ),
        RelicData(
          id: 'relic_start_02',
          name: '낡은 부적',
          rarity: RelicRarity.starter,
          description: '시작 HP +15',
          trigger: RelicTrigger.passive,
        ),
        RelicData(
          id: 'relic_start_03',
          name: '행운의 동전',
          rarity: RelicRarity.starter,
          description: '전투 골드 +30%',
          trigger: RelicTrigger.passive,
        ),
      ];

  static const List<RelicData> _commonRelics = [
    RelicData(
      id: 'relic_c01',
      name: '앵커',
      rarity: RelicRarity.common,
      description: '매 턴 시작 시 방어 4 자동 획득',
      trigger: RelicTrigger.onTurnStart,
    ),
    RelicData(
      id: 'relic_c02',
      name: '빨간 물약',
      rarity: RelicRarity.common,
      description: '전투 시작 시 HP 5 회복',
      trigger: RelicTrigger.onCombatStart,
    ),
    RelicData(
      id: 'relic_c03',
      name: '마나 구슬',
      rarity: RelicRarity.common,
      description: '3턴마다 에너지 +1',
      trigger: RelicTrigger.onTurnStart,
    ),
    RelicData(
      id: 'relic_c04',
      name: '날카로운 숫돌',
      rarity: RelicRarity.common,
      description: '첫 번째 공격 카드 데미지 +3',
      trigger: RelicTrigger.onAttack,
    ),
    RelicData(
      id: 'relic_c05',
      name: '도둑의 장갑',
      rarity: RelicRarity.common,
      description: '전투 보상 골드 +15',
      trigger: RelicTrigger.passive,
    ),
    RelicData(
      id: 'relic_c06',
      name: '가벼운 신발',
      rarity: RelicRarity.common,
      description: '첫 턴 카드 드로우 +2',
      trigger: RelicTrigger.onCombatStart,
    ),
    RelicData(
      id: 'relic_c07',
      name: '독 주머니',
      rarity: RelicRarity.common,
      description: '전투 시작 시 적 전체 독 2',
      trigger: RelicTrigger.onCombatStart,
    ),
    RelicData(
      id: 'relic_c08',
      name: '가시 방패',
      rarity: RelicRarity.common,
      description: '가시 1 (영구)',
      trigger: RelicTrigger.passive,
    ),
    RelicData(
      id: 'relic_c09',
      name: '집중의 반지',
      rarity: RelicRarity.common,
      description: '비용 0 카드 사용 시 방어 2',
      trigger: RelicTrigger.onCardPlay,
    ),
    RelicData(
      id: 'relic_c10',
      name: '전사의 팔찌',
      rarity: RelicRarity.common,
      description: '패에 공격 카드만 있으면 에너지 +1',
      trigger: RelicTrigger.onTurnStart,
    ),
  ];

  static const List<RelicData> _uncommonRelics = [
    RelicData(
      id: 'relic_u01',
      name: '서리의 심장',
      rarity: RelicRarity.uncommon,
      description: '공격 카드 사용 시 20% 확률 약화 1턴',
      trigger: RelicTrigger.onAttack,
    ),
    RelicData(
      id: 'relic_u02',
      name: '현자의 돌',
      rarity: RelicRarity.uncommon,
      description: '마법 카드 데미지 +25%',
      trigger: RelicTrigger.onCardPlay,
    ),
    RelicData(
      id: 'relic_u03',
      name: '불사조의 깃털',
      rarity: RelicRarity.uncommon,
      description: '사망 시 1회 HP 30%로 부활',
      trigger: RelicTrigger.passive,
    ),
    RelicData(
      id: 'relic_u04',
      name: '시간의 모래',
      rarity: RelicRarity.uncommon,
      description: '첫 3턴 에너지 +1',
      trigger: RelicTrigger.onTurnStart,
    ),
    RelicData(
      id: 'relic_u05',
      name: '영혼 수확자',
      rarity: RelicRarity.uncommon,
      description: '적 처치 시 HP 5 회복',
      trigger: RelicTrigger.onEnemyKill,
    ),
    RelicData(
      id: 'relic_u06',
      name: '마법 거울',
      rarity: RelicRarity.uncommon,
      description: '첫 번째 디버프 반사 (1회)',
      trigger: RelicTrigger.passive,
    ),
    RelicData(
      id: 'relic_u07',
      name: '탐험가의 지도',
      rarity: RelicRarity.uncommon,
      description: '맵에서 다음 층 전체 공개',
      trigger: RelicTrigger.passive,
    ),
    RelicData(
      id: 'relic_u08',
      name: '연금술사의 가방',
      rarity: RelicRarity.uncommon,
      description: '상점에서 무료 카드 제거 1회',
      trigger: RelicTrigger.passive,
    ),
  ];

  static const List<RelicData> _rareRelics = [
    RelicData(
      id: 'relic_r01',
      name: '드래곤의 비늘',
      rarity: RelicRarity.rare,
      description: '받는 데미지 -1 (모든 공격)',
      trigger: RelicTrigger.passive,
    ),
    RelicData(
      id: 'relic_r02',
      name: '제3의 눈',
      rarity: RelicRarity.rare,
      description: '적 의도를 정확한 숫자로 표시',
      trigger: RelicTrigger.passive,
    ),
    RelicData(
      id: 'relic_r03',
      name: '무한 주머니',
      rarity: RelicRarity.rare,
      description: '카드 최대 보유 +1 (패에 6장)',
      trigger: RelicTrigger.passive,
    ),
    RelicData(
      id: 'relic_r04',
      name: '각성의 오브',
      rarity: RelicRarity.rare,
      description: '에너지 최대 +1 (3→4)',
      trigger: RelicTrigger.passive,
    ),
    RelicData(
      id: 'relic_r05',
      name: '운명의 실',
      rarity: RelicRarity.rare,
      description: '카드 보상에서 레어 이상 확률 2배',
      trigger: RelicTrigger.passive,
    ),
  ];

  static const List<RelicData> _bossRelics = [
    RelicData(
      id: 'relic_b01',
      name: '왕관',
      rarity: RelicRarity.boss,
      description: '에너지 최대 +1, 시작 시 저주 1장',
      trigger: RelicTrigger.onCombatStart,
    ),
    RelicData(
      id: 'relic_b02',
      name: '마왕의 심장',
      rarity: RelicRarity.boss,
      description: '모든 카드 데미지 +5, 받는 데미지 +5',
      trigger: RelicTrigger.passive,
    ),
    RelicData(
      id: 'relic_b03',
      name: '부활의 성배',
      rarity: RelicRarity.boss,
      description: '휴식 노드에서 HP 완전 회복',
      trigger: RelicTrigger.passive,
    ),
    RelicData(
      id: 'relic_b04',
      name: '혼돈의 구체',
      rarity: RelicRarity.boss,
      description: '매 턴 랜덤 카드 1장 패에 생성',
      trigger: RelicTrigger.onTurnStart,
    ),
    RelicData(
      id: 'relic_b05',
      name: '시간의 왕관',
      rarity: RelicRarity.boss,
      description: '첫 턴 추가 턴 1회',
      trigger: RelicTrigger.onCombatStart,
    ),
  ];

  /// Returns the relic with the given [id], or null if not found.
  static RelicData? getRelic(String id) {
    final relics = allRelics;
    for (final relic in relics) {
      if (relic.id == id) return relic;
    }
    return null;
  }

  /// Returns all relics matching the given [rarity].
  static List<RelicData> getRelicsByRarity(RelicRarity rarity) {
    return allRelics.where((r) => r.rarity == rarity).toList();
  }

  /// Returns [count] random relics, optionally filtered by [rarity].
  ///
  /// If [count] exceeds available relics, returns all matching relics shuffled.
  static List<RelicData> getRandomRelics(int count, {RelicRarity? rarity}) {
    final pool =
        rarity != null ? getRelicsByRarity(rarity) : List.of(allRelics);
    pool.shuffle(_random);
    return pool.take(count).toList();
  }
}
