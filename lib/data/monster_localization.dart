import 'package:life_quest_final_v2/l10n/app_localizations.dart';

class MonsterLocalization {
  /// Returns the localized monster name.
  /// Strips the floor suffix (e.g. "_f1", "_f12") before looking up the base ID.
  static String localizedName(String monsterId, AppLocalizations l10n) {
    final baseId = monsterId.replaceAll(RegExp(r'_f\d+$'), '');
    switch (baseId) {
      case 'slime_green': return l10n.monsterSlimeGreen;
      case 'bat': return l10n.monsterBat;
      case 'mushroom': return l10n.monsterMushroom;
      case 'slime_blue': return l10n.monsterSlimeBlue;
      case 'rat': return l10n.monsterRat;
      case 'goblin': return l10n.monsterGoblin;
      case 'skeleton': return l10n.monsterSkeleton;
      case 'wolf': return l10n.monsterWolf;
      case 'spider_giant': return l10n.monsterSpiderGiant;
      case 'treant': return l10n.monsterTreant;
      case 'orc': return l10n.monsterOrc;
      case 'dark_mage': return l10n.monsterDarkMage;
      case 'golem': return l10n.monsterGolem;
      case 'harpy': return l10n.monsterHarpy;
      case 'mimic': return l10n.monsterMimic;
      case 'lava_golem': return l10n.monsterLavaGolem;
      case 'fire_spirit': return l10n.monsterFireSpirit;
      case 'demon_warrior': return l10n.monsterDemonWarrior;
      case 'salamander': return l10n.monsterSalamander;
      case 'cerberus': return l10n.monsterCerberus;
      case 'shadow_knight': return l10n.monsterShadowKnight;
      case 'lich': return l10n.monsterLich;
      case 'behemoth': return l10n.monsterBehemoth;
      case 'dark_phoenix': return l10n.monsterDarkPhoenix;
      case 'void_worm': return l10n.monsterVoidWorm;
      case 'boss_troll': return l10n.monsterBossTroll;
      case 'boss_dragon': return l10n.monsterBossDragon;
      case 'boss_demon_lord': return l10n.monsterBossDemonLord;
      case 'boss_hydra': return l10n.monsterBossHydra;
      case 'boss_fallen_angel': return l10n.monsterBossFallenAngel;
      case 'boss_death_knight': return l10n.monsterBossDeathKnight;
      default: return monsterId;
    }
  }

  /// Returns the localized chapter/zone name.
  static String localizedChapterName(int chapter, AppLocalizations l10n) {
    switch (chapter) {
      case 1: return l10n.chapterName1;
      case 2: return l10n.chapterName2;
      case 3: return l10n.chapterName3;
      case 4: return l10n.chapterName4;
      case 5: return l10n.chapterName5;
      default: return 'Zone $chapter';
    }
  }
}
