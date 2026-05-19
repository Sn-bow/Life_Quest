import 'package:life_quest_final_v2/models/dungeon_event.dart';
import 'package:life_quest_final_v2/models/title.dart';

class TitleEventRule {
  final String titleId;
  final String eventId;
  final String unlockLabel;
  final EventChoice choice;

  const TitleEventRule({
    required this.titleId,
    required this.eventId,
    required this.unlockLabel,
    required this.choice,
  });
}

class TitleUnlockRules {
  static const List<TitleEventRule> eventRules = [
    TitleEventRule(
      titleId: 't3',
      eventId: 'E06',
      unlockLabel: '대장장이 이벤트에서 힘 기반 강화 선택지 해금',
      choice: EventChoice(
        text: '[근력 마니아] 무기 균형을 잡는다',
        outcomes: [
          EventOutcome(
            description: '훈련 감각으로 보강점을 찾아 카드 1장을 업그레이드했다.',
            cardUpgrade: true,
          ),
        ],
      ),
    ),
    TitleEventRule(
      titleId: 't4',
      eventId: 'E08',
      unlockLabel: '고대 도서관 이벤트에서 지혜 기반 해석 선택지 해금',
      choice: EventChoice(
        text: '[현자 지망생] 색인을 해석한다',
        outcomes: [
          EventOutcome(
            description: '색인을 해석해 레어 카드 선택 기회를 얻었다.',
            cardReward: true,
          ),
        ],
      ),
    ),
    TitleEventRule(
      titleId: 't5',
      eventId: 'E02',
      unlockLabel: '신비한 샘 이벤트에서 안전한 회복 선택지 해금',
      choice: EventChoice(
        text: '[강철 체력] 샘의 흐름을 조절한다',
        outcomes: [
          EventOutcome(
            description: '무리하지 않고 샘의 힘을 받아 HP가 40% 회복되었다.',
            hpPercentChange: 0.40,
          ),
        ],
      ),
    ),
    TitleEventRule(
      titleId: 't6',
      eventId: 'E01',
      unlockLabel: '수상한 상인 이벤트에서 매력 기반 협상 선택지 해금',
      choice: EventChoice(
        text: '[만인의 연인] 가격을 설득한다 (골드 15)',
        outcomes: [
          EventOutcome(
            description: '상인을 설득해 할인된 카드 선택 기회를 얻었다.',
            goldChange: -15,
            cardReward: true,
          ),
        ],
      ),
    ),
    TitleEventRule(
      titleId: 't20',
      eventId: 'E03',
      unlockLabel: '잠자는 모험가 이벤트에서 야영지 선택지 해금',
      choice: EventChoice(
        text: '[초보 캠퍼] 안전한 야영지를 만든다',
        outcomes: [
          EventOutcome(
            description: '야영지를 정비해 HP를 8 회복하고 모험가를 안전하게 보냈다.',
            hpChange: 8,
          ),
        ],
      ),
    ),
    TitleEventRule(
      titleId: 't1',
      eventId: 'E03',
      unlockLabel: '쓰러진 모험가 이벤트에 동행 구조 선택지 해금',
      choice: EventChoice(
        text: '[성실한 모험가] 함께 길을 살핀다',
        outcomes: [
          EventOutcome(
            description: '주변을 살핀 덕분에 위험 없이 카드 보상을 얻었다.',
            cardReward: true,
          ),
        ],
      ),
    ),
    TitleEventRule(
      titleId: 't2',
      eventId: 'E10',
      unlockLabel: '위험한 다리 이벤트에 안전 우회 선택지 해금',
      choice: EventChoice(
        text: '[숙련된 개척자] 안전한 우회로를 찾는다',
        outcomes: [
          EventOutcome(
            description: '무리하지 않고 돌아가며 숨겨진 보급품을 찾았다.',
            goldChange: 30,
          ),
        ],
      ),
    ),
    TitleEventRule(
      titleId: 't7',
      eventId: 'E05',
      unlockLabel: '카드 정리 이벤트에 정밀 정리 선택지 해금',
      choice: EventChoice(
        text: '[성실의 화신] 덱 정리 기준을 세운다',
        outcomes: [
          EventOutcome(
            description: '불필요한 카드를 제거하고 핵심 카드 하나를 강화했다.',
            cardRemove: true,
            cardUpgrade: true,
          ),
        ],
      ),
    ),
    TitleEventRule(
      titleId: 't8',
      eventId: 'E04',
      unlockLabel: '저주받은 제단 이벤트에 균형 정화 선택지 해금',
      choice: EventChoice(
        text: '[만능 사주꾼] 제단의 균형을 읽는다',
        outcomes: [
          EventOutcome(
            description: '저주를 흘려보내고 몸을 안정시켰다.',
            cardRemove: true,
            hpChange: 8,
          ),
        ],
      ),
    ),
    TitleEventRule(
      titleId: 't13',
      eventId: 'E06',
      unlockLabel: '대장장이 이벤트에 숙련 강화 선택지 해금',
      choice: EventChoice(
        text: '[숙련된 전사] 무기의 약점을 바로잡는다',
        outcomes: [
          EventOutcome(
            description: '전투 감각으로 강화 지점을 찾아 카드 하나를 강화했다.',
            cardUpgrade: true,
          ),
        ],
      ),
    ),
    TitleEventRule(
      titleId: 't14',
      eventId: 'E08',
      unlockLabel: '고대 도서관 이벤트에 고급 해석 선택지 해금',
      choice: EventChoice(
        text: '[대현자] 금서의 맥락을 연결한다',
        outcomes: [
          EventOutcome(
            description: '지식의 흐름을 읽어 카드 보상과 강화 기회를 함께 얻었다.',
            cardReward: true,
            cardUpgrade: true,
          ),
        ],
      ),
    ),
    TitleEventRule(
      titleId: 't15',
      eventId: 'E02',
      unlockLabel: '신비한 샘 이벤트에 안정 회복 선택지 해금',
      choice: EventChoice(
        text: '[불멸의 수호자] 샘의 흐름을 안정시킨다',
        outcomes: [
          EventOutcome(
            description: '몸의 부담을 줄이며 HP를 크게 회복했다.',
            hpPercentChange: 0.60,
          ),
        ],
      ),
    ),
    TitleEventRule(
      titleId: 't16',
      eventId: 'E01',
      unlockLabel: '수상한 상인 이벤트에 협상 선택지 해금',
      choice: EventChoice(
        text: '[빛나는 카리스마] 거래 조건을 다시 잡는다',
        outcomes: [
          EventOutcome(
            description: '상인의 경계를 풀어 낮은 비용으로 카드 보상을 얻었다.',
            goldChange: -10,
            cardReward: true,
          ),
        ],
      ),
    ),
    TitleEventRule(
      titleId: 't19',
      eventId: 'E04',
      unlockLabel: '저주받은 제단 이벤트에 완전 정화 선택지 해금',
      choice: EventChoice(
        text: '[마스터 오브 올] 제단 전체를 정렬한다',
        outcomes: [
          EventOutcome(
            description: '제단의 흐름을 완전히 정리해 저주 제거와 유물 보상을 얻었다.',
            cardRemove: true,
            relicReward: true,
          ),
        ],
      ),
    ),
    TitleEventRule(
      titleId: 't21',
      eventId: 'E09',
      unlockLabel: '늪의 정령 이벤트에 계약 선택지 해금',
      choice: EventChoice(
        text: '[경험 많은 여행자] 정령과 조건을 맞춘다',
        outcomes: [
          EventOutcome(
            description: '무리한 전투 없이 정령의 시험을 통과하고 유물을 얻었다.',
            relicReward: true,
          ),
        ],
      ),
    ),
    TitleEventRule(
      titleId: 't24',
      eventId: 'E07',
      unlockLabel: '악마의 도박 이벤트에 판 읽기 선택지 해금',
      choice: EventChoice(
        text: '[월간 레이드 돌파자] 판의 흐름을 읽는다',
        outcomes: [
          EventOutcome(
            description: '위험한 판을 피하고 안전한 수익만 챙겼다.',
            goldChange: 60,
          ),
        ],
      ),
    ),
    TitleEventRule(
      titleId: 't26',
      eventId: 'E10',
      unlockLabel: '위험한 다리 이벤트에 구조물 보강 선택지 해금',
      choice: EventChoice(
        text: '[연간 레이드 생존자] 임시 지지대를 세운다',
        outcomes: [
          EventOutcome(
            description: '다리를 안정시켜 피해 없이 건너고 보급 유물을 찾았다.',
            relicReward: true,
          ),
        ],
      ),
    ),
  ];

  static List<EventChoice> choicesFor(
    DungeonEvent event,
    Iterable<GameTitle> unlockedTitles,
  ) {
    final unlockedIds = unlockedTitles.map((title) => title.id).toSet();
    final titleChoices = eventRules
        .where((rule) =>
            rule.eventId == event.id && unlockedIds.contains(rule.titleId))
        .map((rule) => rule.choice);

    return [
      ...event.choices,
      ...titleChoices,
    ];
  }

  static String? unlockPreviewForTitle(GameTitle title) {
    for (final rule in eventRules) {
      if (rule.titleId == title.id) return rule.unlockLabel;
    }
    return null;
  }
}
