import 'dart:math';

import 'package:life_quest_final_v2/models/dungeon_event.dart';

class EventDatabase {
  static final Random _random = Random();

  static List<DungeonEvent> get allEvents => [
        ..._commonEvents,
        ..._zoneEvents,
      ];

  static const List<DungeonEvent> _commonEvents = [
    // E01: 수상한 상인
    DungeonEvent(
      id: 'E01',
      name: '수상한 상인',
      description: '길을 걷다 수상한 상인을 만났다. 뭔가 좋은 물건이 있을 것 같은데...',
      choices: [
        EventChoice(
          text: '물건을 산다 (골드 50)',
          outcomes: [
            EventOutcome(
              description: '랜덤 렐릭 1개를 획득했다!',
              goldChange: -50,
              relicReward: true,
            ),
          ],
        ),
        EventChoice(
          text: '카드를 산다 (골드 30)',
          outcomes: [
            EventOutcome(
              description: '레어 카드 1장을 선택할 수 있다.',
              goldChange: -30,
              cardReward: true,
            ),
          ],
        ),
        EventChoice(
          text: '무시한다',
          outcomes: [
            EventOutcome(
              description: '상인을 지나쳤다.',
            ),
          ],
        ),
      ],
    ),

    // E02: 신비한 샘
    DungeonEvent(
      id: 'E02',
      name: '신비한 샘',
      description: '빛나는 샘을 발견했다. 묘한 힘이 느껴진다.',
      choices: [
        EventChoice(
          text: '물을 마신다',
          outcomes: [
            EventOutcome(
              description: 'HP가 25% 회복되었다.',
              hpPercentChange: 0.25,
            ),
          ],
        ),
        EventChoice(
          text: '카드를 담근다',
          outcomes: [
            EventOutcome(
              description: '랜덤 카드 1장이 업그레이드되었다!',
              cardUpgrade: true,
            ),
          ],
        ),
        EventChoice(
          text: '동전을 던진다 (골드 20)',
          outcomes: [
            // 50% HP 완전 회복
            EventOutcome(
              description: 'HP가 완전히 회복되었다!',
              goldChange: -20,
              hpPercentChange: 1.0,
            ),
            // 50% 저주 1장
            EventOutcome(
              description: '저주가 덱에 추가되었다...',
              goldChange: -20,
              curseAdded: true,
            ),
          ],
        ),
      ],
    ),

    // E03: 잠자는 모험가
    DungeonEvent(
      id: 'E03',
      name: '잠자는 모험가',
      description: '쓰러진 모험가를 발견했다. 도와줄 수 있을 것 같다.',
      choices: [
        EventChoice(
          text: '도와준다 (HP 10 소모)',
          outcomes: [
            EventOutcome(
              description: '모험가가 고마워하며 카드를 선물했다. (언커먼+)',
              hpChange: -10,
              cardReward: true,
            ),
          ],
        ),
        EventChoice(
          text: '가방을 뒤진다',
          outcomes: [
            // 50% 골드만
            EventOutcome(
              description: '골드를 발견했다!',
              goldChange: 45,
            ),
            // 50% 골드 + 저주
            EventOutcome(
              description: '골드를 찾았지만... 저주가 걸렸다.',
              goldChange: 45,
              curseAdded: true,
            ),
          ],
        ),
        EventChoice(
          text: '지나친다',
          outcomes: [
            EventOutcome(
              description: '모험가를 지나쳤다.',
            ),
          ],
        ),
      ],
    ),

    // E04: 저주받은 제단
    DungeonEvent(
      id: 'E04',
      name: '저주받은 제단',
      description: '어두운 제단 위에 빛나는 카드가 놓여있다.',
      choices: [
        EventChoice(
          text: '카드를 가져간다',
          outcomes: [
            EventOutcome(
              description: '레어 카드를 얻었지만 저주도 함께...',
              cardReward: true,
              curseAdded: true,
            ),
          ],
        ),
        EventChoice(
          text: '기도한다',
          outcomes: [
            // 저주 제거 또는 HP 회복
            EventOutcome(
              description: '저주가 정화되었다.',
              cardRemove: true,
            ),
            EventOutcome(
              description: '제단의 빛으로 HP가 회복되었다.',
              hpChange: 10,
            ),
          ],
        ),
        EventChoice(
          text: '파괴한다',
          outcomes: [
            EventOutcome(
              description: '제단을 부수고 골드를 얻었다.',
              goldChange: 25,
            ),
          ],
        ),
      ],
    ),

    // E05: 카드 제거 기회
    DungeonEvent(
      id: 'E05',
      name: '카드 제거 기회',
      description: '방랑하는 현자가 덱을 정리해주겠다고 한다.',
      choices: [
        EventChoice(
          text: '카드 1장 제거',
          outcomes: [
            EventOutcome(
              description: '덱에서 카드 1장을 제거했다.',
              cardRemove: true,
            ),
          ],
        ),
        EventChoice(
          text: '카드 1장 업그레이드',
          outcomes: [
            EventOutcome(
              description: '카드 1장을 업그레이드했다.',
              cardUpgrade: true,
            ),
          ],
        ),
        EventChoice(
          text: '카드 변환',
          outcomes: [
            EventOutcome(
              description: '카드 1장을 제거하고 같은 비용의 랜덤 카드를 얻었다.',
              cardRemove: true,
              cardReward: true,
            ),
          ],
        ),
      ],
    ),

    // E06: 대장장이
    DungeonEvent(
      id: 'E06',
      name: '대장장이',
      description: '실력 좋은 대장장이를 만났다.',
      choices: [
        EventChoice(
          text: '카드 업그레이드 (골드 40)',
          outcomes: [
            EventOutcome(
              description: '카드 2장을 업그레이드했다!',
              goldChange: -40,
              cardUpgrade: true,
            ),
          ],
        ),
        EventChoice(
          text: '장비 강화',
          outcomes: [
            EventOutcome(
              description: '이번 런 동안 공격 +2 또는 방어 +2!',
              relicReward: true,
            ),
          ],
        ),
        EventChoice(
          text: '그냥 간다',
          outcomes: [
            EventOutcome(
              description: '대장장이에게 인사하고 떠났다.',
            ),
          ],
        ),
      ],
    ),

    // E07: 도박꾼의 텐트
    DungeonEvent(
      id: 'E07',
      name: '도박꾼의 텐트',
      description: '도박꾼이 게임을 제안한다.',
      choices: [
        EventChoice(
          text: '받아들인다 (골드 30)',
          outcomes: [
            // 50% 골드 2배 반환
            EventOutcome(
              description: '이겼다! 골드 60을 받았다!',
              goldChange: 30,
            ),
            // 50% 잃음
            EventOutcome(
              description: '졌다... 골드 30을 잃었다.',
              goldChange: -30,
            ),
          ],
        ),
        EventChoice(
          text: '큰 판 (골드 80)',
          outcomes: [
            // 40% 골드 3배
            EventOutcome(
              description: '대박! 골드 240을 받았다!',
              goldChange: 160,
            ),
            // 60% 잃음
            EventOutcome(
              description: '크게 졌다... 골드 80을 잃었다.',
              goldChange: -80,
            ),
          ],
        ),
        EventChoice(
          text: '거절한다',
          outcomes: [
            EventOutcome(
              description: '도박꾼의 제안을 거절했다.',
            ),
          ],
        ),
      ],
    ),

    // E08: 고대의 도서관
    DungeonEvent(
      id: 'E08',
      name: '고대의 도서관',
      description: '먼지 쌓인 도서관에서 세 권의 책을 발견했다.',
      choices: [
        EventChoice(
          text: '공격의 서',
          outcomes: [
            EventOutcome(
              description: '공격 카드 3장 중 1장을 선택할 수 있다. (레어 보장)',
              cardReward: true,
            ),
          ],
        ),
        EventChoice(
          text: '방어의 서',
          outcomes: [
            EventOutcome(
              description: '방어 카드 3장 중 1장을 선택할 수 있다. (레어 보장)',
              cardReward: true,
            ),
          ],
        ),
        EventChoice(
          text: '마법의 서',
          outcomes: [
            EventOutcome(
              description: '마법 카드 3장 중 1장을 선택할 수 있다. (레어 보장)',
              cardReward: true,
            ),
          ],
        ),
      ],
    ),
  ];

  static const List<DungeonEvent> _zoneEvents = [
    // 존 2 전용: 숲의 정령
    DungeonEvent(
      id: 'E09',
      name: '숲의 정령',
      description: '정령이 시험을 제안한다.',
      zoneRequirement: 2,
      choices: [
        EventChoice(
          text: '싸운다',
          outcomes: [
            EventOutcome(
              description: '정령과의 특수 전투! 보상이 크다.',
              cardReward: true,
              relicReward: true,
            ),
          ],
        ),
        EventChoice(
          text: '교감한다',
          outcomes: [
            EventOutcome(
              description: '매 전투 시작 시 재생 2 (3턴) 영구 버프를 얻었다!',
              relicReward: true,
            ),
          ],
        ),
      ],
    ),

    // 존 4 전용: 용암 위의 다리
    DungeonEvent(
      id: 'E10',
      name: '용암 위의 다리',
      description: '무너지는 다리를 건너야 한다.',
      zoneRequirement: 4,
      choices: [
        EventChoice(
          text: '달린다',
          outcomes: [
            // 50% 성공
            EventOutcome(
              description: '무사히 건넜다!',
            ),
            // 50% HP 20% 손실
            EventOutcome(
              description: '다리가 무너지며 부상을 입었다.',
              hpPercentChange: -0.20,
            ),
          ],
        ),
        EventChoice(
          text: '신중히 건넌다',
          outcomes: [
            EventOutcome(
              description: '조심스럽게 건넜지만 열기에 데었다.',
              hpPercentChange: -0.10,
            ),
          ],
        ),
        EventChoice(
          text: '돌아간다',
          outcomes: [
            EventOutcome(
              description: '다른 경로를 선택했다.',
            ),
          ],
        ),
      ],
    ),
  ];

  /// Returns the event with the given [id], or null if not found.
  static DungeonEvent? getEvent(String id) {
    final events = allEvents;
    for (final event in events) {
      if (event.id == id) return event;
    }
    return null;
  }

  /// Returns all events available in the given [zone].
  ///
  /// Includes common events (no zone requirement) and zone-specific events.
  static List<DungeonEvent> getEventsForZone(int zone) {
    return allEvents
        .where((e) => e.zoneRequirement == null || e.zoneRequirement == zone)
        .toList();
  }

  /// Returns a random event, optionally filtered by [zone].
  ///
  /// If [zone] is provided, picks from common + zone-specific events.
  /// Otherwise, picks from all events.
  static DungeonEvent getRandomEvent({int? zone}) {
    final pool = zone != null ? getEventsForZone(zone) : allEvents;
    return pool[_random.nextInt(pool.length)];
  }
}
