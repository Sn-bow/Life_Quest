import 'package:life_quest_final_v2/models/monster.dart';

/// Pre-defined monster templates organized by zone difficulty.
/// Monsters scale with player level.
class MonsterDatabase {
  // ============================================================
  // Zone 1: 초원 (Lv.1-4) — 초보 모험가의 시작점
  // ============================================================
  static List<Monster> getZone1Monsters() {
    return [
      Monster(
          id: 'slime_green',
          name: '초록 슬라임',
          level: 1,
          maxHp: 20,
          attack: 3,
          defense: 1,
          xpReward: 15,
          spritePath: 'assets/images/monsters/slime_green.png'),
      Monster(
          id: 'bat',
          name: '동굴 박쥐',
          level: 2,
          maxHp: 15,
          attack: 5,
          defense: 0,
          xpReward: 18,
          spritePath: 'assets/images/monsters/bat.png'),
      Monster(
          id: 'mushroom',
          name: '독버섯',
          level: 3,
          maxHp: 30,
          attack: 4,
          defense: 2,
          xpReward: 25,
          spritePath: 'assets/images/monsters/mushroom.png'),
      Monster(
          id: 'slime_blue',
          name: '파랑 슬라임',
          level: 2,
          maxHp: 25,
          attack: 4,
          defense: 2,
          xpReward: 20,
          spritePath: 'assets/images/monsters/slime_blue.png'),
      Monster(
          id: 'rat',
          name: '거대 쥐',
          level: 1,
          maxHp: 12,
          attack: 4,
          defense: 0,
          xpReward: 12,
          spritePath: 'assets/images/monsters/rat.png'),
    ];
  }

  // ============================================================
  // Zone 2: 어둠의 숲 (Lv.5-10) — 본격적인 모험
  // ============================================================
  static List<Monster> getZone2Monsters() {
    return [
      Monster(
          id: 'goblin',
          name: '고블린',
          level: 5,
          maxHp: 50,
          attack: 8,
          defense: 3,
          xpReward: 40,
          spritePath: 'assets/images/monsters/goblin.png'),
      Monster(
          id: 'skeleton',
          name: '해골 전사',
          level: 7,
          maxHp: 60,
          attack: 10,
          defense: 5,
          xpReward: 55,
          spritePath: 'assets/images/monsters/skeleton.png'),
      Monster(
          id: 'wolf',
          name: '그림자 늑대',
          level: 8,
          maxHp: 45,
          attack: 12,
          defense: 2,
          xpReward: 50,
          spritePath: 'assets/images/monsters/wolf.png'),
      Monster(
          id: 'spider_giant',
          name: '거대 독거미',
          level: 6,
          maxHp: 40,
          attack: 9,
          defense: 2,
          xpReward: 45,
          spritePath: 'assets/images/monsters/spider_giant.png'),
      Monster(
          id: 'treant',
          name: '움직이는 나무',
          level: 9,
          maxHp: 80,
          attack: 7,
          defense: 8,
          xpReward: 60,
          spritePath: 'assets/images/monsters/treant.png'),
    ];
  }

  // ============================================================
  // Zone 3: 폐허의 성 (Lv.12-20) — 중급 던전
  // ============================================================
  static List<Monster> getZone3Monsters() {
    return [
      Monster(
          id: 'orc',
          name: '오크 전사',
          level: 12,
          maxHp: 100,
          attack: 15,
          defense: 8,
          xpReward: 80,
          spritePath: 'assets/images/monsters/orc.png'),
      Monster(
          id: 'dark_mage',
          name: '다크 마법사',
          level: 15,
          maxHp: 70,
          attack: 20,
          defense: 4,
          xpReward: 100,
          spritePath: 'assets/images/monsters/dark_mage.png'),
      Monster(
          id: 'golem',
          name: '스톤 골렘',
          level: 18,
          maxHp: 150,
          attack: 12,
          defense: 15,
          xpReward: 120,
          spritePath: 'assets/images/monsters/golem.png'),
      Monster(
          id: 'harpy',
          name: '하피',
          level: 13,
          maxHp: 65,
          attack: 18,
          defense: 3,
          xpReward: 85,
          spritePath: 'assets/images/monsters/harpy.png'),
      Monster(
          id: 'mimic',
          name: '미믹',
          level: 16,
          maxHp: 90,
          attack: 16,
          defense: 10,
          xpReward: 110,
          spritePath: 'assets/images/monsters/mimic.png'),
    ];
  }

  // ============================================================
  // Zone 4: 용암 동굴 (Lv.22-30) — 상급 던전
  // ============================================================
  static List<Monster> getZone4Monsters() {
    return [
      Monster(
          id: 'lava_golem',
          name: '용암 골렘',
          level: 22,
          maxHp: 200,
          attack: 22,
          defense: 18,
          xpReward: 160,
          spritePath: 'assets/images/monsters/lava_golem.png'),
      Monster(
          id: 'fire_spirit',
          name: '화염 정령',
          level: 24,
          maxHp: 120,
          attack: 30,
          defense: 5,
          xpReward: 180,
          spritePath: 'assets/images/monsters/fire_spirit.png'),
      Monster(
          id: 'demon_warrior',
          name: '마족 전사',
          level: 26,
          maxHp: 250,
          attack: 25,
          defense: 15,
          xpReward: 200,
          spritePath: 'assets/images/monsters/demon_warrior.png'),
      Monster(
          id: 'salamander',
          name: '살라만더',
          level: 23,
          maxHp: 180,
          attack: 24,
          defense: 10,
          xpReward: 170,
          spritePath: 'assets/images/monsters/salamander.png'),
      Monster(
          id: 'cerberus',
          name: '케르베로스',
          level: 28,
          maxHp: 300,
          attack: 28,
          defense: 12,
          xpReward: 220,
          spritePath: 'assets/images/monsters/cerberus.png'),
    ];
  }

  // ============================================================
  // Zone 5: 심연의 차원 (Lv.32-45) — 최고급 던전
  // ============================================================
  static List<Monster> getZone5Monsters() {
    return [
      Monster(
          id: 'shadow_knight',
          name: '그림자 기사',
          level: 32,
          maxHp: 350,
          attack: 32,
          defense: 20,
          xpReward: 280,
          spritePath: 'assets/images/monsters/shadow_knight.png'),
      Monster(
          id: 'lich',
          name: '리치',
          level: 35,
          maxHp: 280,
          attack: 40,
          defense: 10,
          xpReward: 350,
          spritePath: 'assets/images/monsters/lich.png'),
      Monster(
          id: 'behemoth',
          name: '베히모스',
          level: 38,
          maxHp: 500,
          attack: 35,
          defense: 25,
          xpReward: 400,
          spritePath: 'assets/images/monsters/behemoth.png'),
      Monster(
          id: 'dark_phoenix',
          name: '어둠의 불사조',
          level: 40,
          maxHp: 400,
          attack: 45,
          defense: 15,
          xpReward: 450,
          spritePath: 'assets/images/monsters/dark_phoenix.png'),
      Monster(
          id: 'void_worm',
          name: '차원 벌레',
          level: 42,
          maxHp: 600,
          attack: 30,
          defense: 30,
          xpReward: 500,
          spritePath: 'assets/images/monsters/void_worm.png'),
    ];
  }

  // ============================================================
  // Boss Monsters (주간 레이드)
  // ============================================================
  static List<Monster> getBossMonsters() {
    return [
      Monster(
          id: 'boss_troll',
          name: '트롤 대장',
          level: 10,
          maxHp: 300,
          attack: 18,
          defense: 10,
          xpReward: 250,
          spritePath: 'assets/images/monsters/boss_troll.png'),
      Monster(
          id: 'boss_dragon',
          name: '화염 드래곤',
          level: 25,
          maxHp: 800,
          attack: 35,
          defense: 20,
          xpReward: 600,
          spritePath: 'assets/images/monsters/boss_dragon.png'),
      Monster(
          id: 'boss_demon_lord',
          name: '마왕',
          level: 35,
          maxHp: 1200,
          attack: 45,
          defense: 25,
          xpReward: 1000,
          spritePath: 'assets/images/monsters/boss_demon_lord.png'),
      Monster(
          id: 'boss_hydra',
          name: '히드라',
          level: 20,
          maxHp: 600,
          attack: 28,
          defense: 15,
          xpReward: 400,
          spritePath: 'assets/images/monsters/boss_hydra.png'),
      Monster(
          id: 'boss_fallen_angel',
          name: '타락 천사',
          level: 45,
          maxHp: 2000,
          attack: 60,
          defense: 35,
          xpReward: 1500,
          spritePath: 'assets/images/monsters/boss_fallen_angel.png'),
      Monster(
          id: 'boss_death_knight',
          name: '죽음의 기사',
          level: 30,
          maxHp: 1000,
          attack: 40,
          defense: 22,
          xpReward: 800,
          spritePath: 'assets/images/monsters/boss_death_knight.png'),
    ];
  }

  // ============================================================
  // Dungeon Crawler Helpers
  // ============================================================
  static Monster getMonsterForDungeon(int chapter, int floor) {
    List<Monster> chapterMonsters;
    switch (chapter) {
      case 1:
        chapterMonsters = getZone1Monsters();
        break;
      case 2:
        chapterMonsters = getZone2Monsters();
        break;
      case 3:
        chapterMonsters = getZone3Monsters();
        break;
      case 4:
        chapterMonsters = getZone4Monsters();
        break;
      case 5:
      default:
        chapterMonsters = getZone5Monsters();
        break;
    }

    // Boss floor check (every 5 floors)
    if (floor % 5 == 0) {
      final bosses = getBossMonsters();
      // Chapters typically have 1 matching boss. Ch1 = Troll, Ch2 = Dragon, etc.
      int bossIndex = (chapter - 1).clamp(0, bosses.length - 1);
      final boss = bosses[bossIndex];
      // Clone it so we don't accidentally mutate the static definition
      return Monster(
        id: '${boss.id}_f$floor',
        name: boss.name,
        level: boss.level + (floor ~/ 5),
        maxHp: boss.maxHp + (floor * 10),
        attack: boss.attack + (floor * 2),
        defense: boss.defense + floor,
        xpReward: boss.xpReward + (floor * 10),
        spritePath: boss.spritePath,
      );
    }

    // Regular floor: loop through the chapter monsters based on floor
    int index = (floor - 1) % chapterMonsters.length;
    final baseMonster = chapterMonsters[index];

    // Slight scaling based on floor
    return Monster(
      id: '${baseMonster.id}_f$floor',
      name: baseMonster.name,
      level: baseMonster.level + (floor ~/ 2),
      maxHp: baseMonster.maxHp + (floor * 5),
      attack: baseMonster.attack + (floor),
      defense: baseMonster.defense + (floor ~/ 2),
      xpReward: baseMonster.xpReward + (floor * 2),
      spritePath: baseMonster.spritePath,
    );
  }

  static String getChapterName(int chapter) {
    switch (chapter) {
      case 1:
        return '초원 방어선';
      case 2:
        return '어둠의 숲';
      case 3:
        return '폐허의 성';
      case 4:
        return '용암 던전';
      case 5:
        return '심연의 차원';
      default:
        return '미지의 영역';
    }
  }

  static int get maxChapters => 5;

  /// Returns monsters for a specific zone
  static List<Monster> getMonstersByZone(int zone) {
    switch (zone) {
      case 1: return getZone1Monsters();
      case 2: return getZone2Monsters();
      case 3: return getZone3Monsters();
      case 4: return getZone4Monsters();
      case 5: return getZone5Monsters();
      default: return getZone1Monsters();
    }
  }

  /// Returns monsters appropriate for the player's level
  static List<Monster> getMonstersForLevel(int playerLevel) {
    List<Monster> available = [];
    available.addAll(getZone1Monsters());
    if (playerLevel >= 5) available.addAll(getZone2Monsters());
    if (playerLevel >= 12) available.addAll(getZone3Monsters());
    if (playerLevel >= 22) available.addAll(getZone4Monsters());
    if (playerLevel >= 32) available.addAll(getZone5Monsters());
    return available;
  }
}
