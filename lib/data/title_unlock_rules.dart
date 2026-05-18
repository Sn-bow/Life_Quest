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
