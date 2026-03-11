import 'package:life_quest_final_v2/models/title.dart';
import 'package:life_quest_final_v2/state/character_state.dart';

class TitleDatabase {
  static const List<GameTitle> all = [
    // --- Level titles ---
    GameTitle(
        id: 't0',
        name: '새싹 모험가',
        description: '모든 것이 새로운 시작',
        conditionType: TitleConditionType.level,
        conditionValue: 1),
    GameTitle(
        id: 't1',
        name: '성실한 모험가',
        description: '꾸준함이 미덕',
        conditionType: TitleConditionType.level,
        conditionValue: 5),
    GameTitle(
        id: 't2',
        name: '숙련된 개척자',
        description: '자신만의 길을 걷는 자',
        conditionType: TitleConditionType.level,
        conditionValue: 10),
    GameTitle(
        id: 't10',
        name: '만렙을 향하여',
        description: '레벨 30 달성',
        conditionType: TitleConditionType.level,
        conditionValue: 30),
    GameTitle(
        id: 't11',
        name: '전설의 용사',
        description: '레벨 40 달성',
        conditionType: TitleConditionType.level,
        conditionValue: 40),
    GameTitle(
        id: 't12',
        name: '세계의 영웅',
        description: '레벨 50 달성',
        conditionType: TitleConditionType.level,
        conditionValue: 50),
    GameTitle(
        id: 't20',
        name: '초보 캠퍼',
        description: '레벨 3 달성',
        conditionType: TitleConditionType.level,
        conditionValue: 3),
    GameTitle(
        id: 't21',
        name: '경험 많은 여행자',
        description: '레벨 20 달성',
        conditionType: TitleConditionType.level,
        conditionValue: 20),

    // --- Stat titles (with XP bonus) ---
    GameTitle(
        id: 't3',
        name: '근력 마니아',
        description: '힘 퀘스트 XP +5%',
        conditionType: TitleConditionType.strength,
        conditionValue: 30,
        bonusType: StatType.strength,
        bonusValue: 0.05),
    GameTitle(
        id: 't4',
        name: '현자 지망생',
        description: '지혜 퀘스트 XP +5%',
        conditionType: TitleConditionType.wisdom,
        conditionValue: 30,
        bonusType: StatType.wisdom,
        bonusValue: 0.05),
    GameTitle(
        id: 't5',
        name: '강철 체력',
        description: '건강 퀘스트 XP +5%',
        conditionType: TitleConditionType.health,
        conditionValue: 30,
        bonusType: StatType.health,
        bonusValue: 0.05),
    GameTitle(
        id: 't6',
        name: '만인의 연인',
        description: '매력 퀘스트 XP +5%',
        conditionType: TitleConditionType.charisma,
        conditionValue: 30,
        bonusType: StatType.charisma,
        bonusValue: 0.05),
    GameTitle(
        id: 't13',
        name: '파괴의 화신',
        description: '힘 퀘스트 XP +10%',
        conditionType: TitleConditionType.strength,
        conditionValue: 60,
        bonusType: StatType.strength,
        bonusValue: 0.10),
    GameTitle(
        id: 't14',
        name: '대현자',
        description: '지혜 퀘스트 XP +10%',
        conditionType: TitleConditionType.wisdom,
        conditionValue: 60,
        bonusType: StatType.wisdom,
        bonusValue: 0.10),
    GameTitle(
        id: 't15',
        name: '불멸의 전사',
        description: '건강 퀘스트 XP +10%',
        conditionType: TitleConditionType.health,
        conditionValue: 60,
        bonusType: StatType.health,
        bonusValue: 0.10),
    GameTitle(
        id: 't16',
        name: '절대 카리스마',
        description: '매력 퀘스트 XP +10%',
        conditionType: TitleConditionType.charisma,
        conditionValue: 60,
        bonusType: StatType.charisma,
        bonusValue: 0.10),
    GameTitle(
        id: 't22',
        name: '힘의 정점',
        description: '힘 100 달성!',
        conditionType: TitleConditionType.strength,
        conditionValue: 100),
    GameTitle(
        id: 't23',
        name: '지혜의 정점',
        description: '지혜 100 달성!',
        conditionType: TitleConditionType.wisdom,
        conditionValue: 100),

    // --- Quest titles ---
    GameTitle(
        id: 't7',
        name: '성실의 화신',
        description: '퀘스트 100회 완료',
        conditionType: TitleConditionType.questsCompleted,
        conditionValue: 100),
    GameTitle(
        id: 't9',
        name: '퀘스트 장인',
        description: '퀘스트 250회 완료',
        conditionType: TitleConditionType.questsCompleted,
        conditionValue: 250),
    GameTitle(
        id: 't17',
        name: '퀘스트 전설',
        description: '퀘스트 500회 완료',
        conditionType: TitleConditionType.questsCompleted,
        conditionValue: 500),
    GameTitle(
        id: 't18',
        name: '퀘스트의 신',
        description: '퀘스트 1000회 완료',
        conditionType: TitleConditionType.questsCompleted,
        conditionValue: 1000),

    // --- All stat titles ---
    GameTitle(
        id: 't8',
        name: '만능 재주꾼',
        description: '모든 스탯 20 달성',
        conditionType: TitleConditionType.allStats,
        conditionValue: 20),
    GameTitle(
        id: 't19',
        name: '마스터 오브 올',
        description: '모든 스탯 50 달성',
        conditionType: TitleConditionType.allStats,
        conditionValue: 50),
  ];
}
