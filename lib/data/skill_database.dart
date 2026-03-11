import 'package:life_quest_final_v2/models/skill.dart';
import 'package:life_quest_final_v2/state/character_state.dart';

class SkillDatabase {
  static const List<Skill> all = [
    // ====== Tier 1: Passive XP Boosts (Lv.3, stat 10) ======
    Skill(
        id: 'sk1',
        name: '근력 강화',
        description: '힘 퀘스트 XP +10%',
        requiredLevel: 3,
        requiredStatType: StatType.strength,
        requiredStatValue: 10,
        effectType: SkillEffectType.xpBoost,
        effectValue: 0.10,
        effectTarget: StatType.strength),
    Skill(
        id: 'sk2',
        name: '지혜의 빛',
        description: '지혜 퀘스트 XP +10%',
        requiredLevel: 3,
        requiredStatType: StatType.wisdom,
        requiredStatValue: 10,
        effectType: SkillEffectType.xpBoost,
        effectValue: 0.10,
        effectTarget: StatType.wisdom),
    Skill(
        id: 'sk3',
        name: '건강한 신체',
        description: '건강 퀘스트 XP +10%',
        requiredLevel: 3,
        requiredStatType: StatType.health,
        requiredStatValue: 10,
        effectType: SkillEffectType.xpBoost,
        effectValue: 0.10,
        effectTarget: StatType.health),
    Skill(
        id: 'sk4',
        name: '매력 발산',
        description: '매력 퀘스트 XP +10%',
        requiredLevel: 3,
        requiredStatType: StatType.charisma,
        requiredStatValue: 10,
        effectType: SkillEffectType.xpBoost,
        effectValue: 0.10,
        effectTarget: StatType.charisma),

    // ====== Tier 2: Combat Skills (early) ======
    Skill(
        id: 'sk10',
        name: '화염 검격',
        description: '전투 사용: 25 추가 대미지',
        requiredLevel: 5,
        requiredStatType: StatType.strength,
        requiredStatValue: 15,
        effectType: SkillEffectType.combatDamage,
        effectValue: 25),
    Skill(
        id: 'sk11',
        name: '치유의 빛',
        description: '전투 사용: HP 20 회복',
        requiredLevel: 7,
        requiredStatType: StatType.health,
        requiredStatValue: 15,
        effectType: SkillEffectType.combatHeal,
        effectValue: 20),

    // ====== Tier 3: Mid-level passives ======
    Skill(
        id: 'sk5',
        name: '퀘스트 전문가',
        description: '모든 퀘스트 XP +5%',
        requiredLevel: 10,
        effectType: SkillEffectType.xpBoost,
        effectValue: 0.05),
    Skill(
        id: 'sk13',
        name: '빙결 마법',
        description: '전투 사용: 35 대미지',
        requiredLevel: 10,
        requiredStatType: StatType.wisdom,
        requiredStatValue: 20,
        effectType: SkillEffectType.combatDamage,
        effectValue: 35),
    Skill(
        id: 'sk14',
        name: '독안개',
        description: '전투 사용: 30 대미지',
        requiredLevel: 12,
        requiredStatType: StatType.wisdom,
        requiredStatValue: 25,
        effectType: SkillEffectType.combatDamage,
        effectValue: 30),

    // ====== Tier 4: Leveling passives ======
    Skill(
        id: 'sk6',
        name: '성장의 기쁨',
        description: '레벨업 시 추가 SP 1',
        requiredLevel: 15,
        effectType: SkillEffectType.spBonusOnLevelUp,
        effectValue: 1),
    Skill(
        id: 'sk12',
        name: '번개 일격',
        description: '전투 사용: 50 대미지',
        requiredLevel: 15,
        requiredStatType: StatType.strength,
        requiredStatValue: 30,
        effectType: SkillEffectType.combatDamage,
        effectValue: 50),
    Skill(
        id: 'sk15',
        name: '보호막',
        description: '전투 사용: HP 40 회복',
        requiredLevel: 18,
        requiredStatType: StatType.health,
        requiredStatValue: 35,
        effectType: SkillEffectType.combatHeal,
        effectValue: 40),

    // ====== Tier 5: Advanced passives (Lv.20+) ======
    Skill(
        id: 'sk7',
        name: '집중 훈련',
        description: 'SP 1 소모 시 스탯 2 증가',
        requiredLevel: 20,
        effectType: SkillEffectType.statBoostEfficiency,
        effectValue: 2),
    Skill(
        id: 'sk16',
        name: '대지진',
        description: '전투 사용: 70 대미지',
        requiredLevel: 22,
        requiredStatType: StatType.strength,
        requiredStatValue: 45,
        effectType: SkillEffectType.combatDamage,
        effectValue: 70),
    Skill(
        id: 'sk17',
        name: '성스러운 기도',
        description: '전투 사용: HP 60 회복',
        requiredLevel: 25,
        requiredStatType: StatType.health,
        requiredStatValue: 50,
        effectType: SkillEffectType.combatHeal,
        effectValue: 60),

    // ====== Tier 6: High-level passives ======
    Skill(
        id: 'sk8',
        name: '학습 가속',
        description: '모든 퀘스트 XP +10%',
        requiredLevel: 25,
        effectType: SkillEffectType.xpBoost,
        effectValue: 0.10),
    Skill(
        id: 'sk18',
        name: '전투 본능',
        description: '힘 퀘스트 XP +15%',
        requiredLevel: 28,
        requiredStatType: StatType.strength,
        requiredStatValue: 50,
        effectType: SkillEffectType.xpBoost,
        effectValue: 0.15,
        effectTarget: StatType.strength),
    Skill(
        id: 'sk19',
        name: '명상의 경지',
        description: '지혜 퀘스트 XP +15%',
        requiredLevel: 28,
        requiredStatType: StatType.wisdom,
        requiredStatValue: 50,
        effectType: SkillEffectType.xpBoost,
        effectValue: 0.15,
        effectTarget: StatType.wisdom),

    // ====== Tier 7: Endgame skills (Lv.30+) ======
    Skill(
        id: 'sk9',
        name: '초월적인 성장',
        description: '레벨업 시 기본 SP 5 → 7',
        requiredLevel: 30,
        effectType: SkillEffectType.spBonusOnLevelUp,
        effectValue: 2),
    Skill(
        id: 'sk20',
        name: '어둠의 검',
        description: '전투 사용: 100 대미지',
        requiredLevel: 32,
        requiredStatType: StatType.strength,
        requiredStatValue: 65,
        effectType: SkillEffectType.combatDamage,
        effectValue: 100),
    Skill(
        id: 'sk21',
        name: '완전한 재생',
        description: '전투 사용: HP 80 회복',
        requiredLevel: 35,
        requiredStatType: StatType.health,
        requiredStatValue: 70,
        effectType: SkillEffectType.combatHeal,
        effectValue: 80),

    // ====== Tier 8: Ultimate skills (Lv.40+) ======
    Skill(
        id: 'sk22',
        name: '극한 효율',
        description: 'SP 1 소모 시 스탯 3 증가',
        requiredLevel: 40,
        effectType: SkillEffectType.statBoostEfficiency,
        effectValue: 3),
    Skill(
        id: 'sk23',
        name: '초월 가속',
        description: '모든 퀘스트 XP +20%',
        requiredLevel: 45,
        effectType: SkillEffectType.xpBoost,
        effectValue: 0.20),
    Skill(
        id: 'sk24',
        name: '신의 축복',
        description: '레벨업 시 추가 SP 3',
        requiredLevel: 50,
        effectType: SkillEffectType.spBonusOnLevelUp,
        effectValue: 3),
  ];
}
