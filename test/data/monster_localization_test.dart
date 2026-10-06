import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/data/monster_database.dart';
import 'package:life_quest_final_v2/data/monster_localization.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/models/monster.dart';

void main() {
  final builtIns = [
    ...MonsterDatabase.getZone1Monsters(),
    ...MonsterDatabase.getZone2Monsters(),
    ...MonsterDatabase.getZone3Monsters(),
    ...MonsterDatabase.getZone4Monsters(),
    ...MonsterDatabase.getZone5Monsters(),
    ...MonsterDatabase.getBossMonsters(),
  ];

  test('all built-in and floor-scaled enemies use the four target locales', () {
    expect(builtIns, hasLength(31));
    for (final code in ['ko', 'en', 'ja', 'zh']) {
      final l10n = lookupAppLocalizations(Locale(code));
      for (final monster in builtIns) {
        expect(
          MonsterLocalization.displayName(monster, l10n),
          MonsterLocalization.localizedName(monster.id, l10n),
          reason: '$code: ${monster.id}',
        );
        final scaled = monster.copyWith(id: '${monster.id}_f12');
        expect(
          MonsterLocalization.displayName(scaled, l10n),
          MonsterLocalization.localizedName(monster.id, l10n),
          reason: '$code: ${scaled.id}',
        );
      }
    }
    final slime = builtIns.firstWhere((monster) => monster.id == 'slime_green');
    final rat = builtIns.firstWhere((monster) => monster.id == 'rat');
    expect(
      MonsterLocalization.displayName(
        slime,
        lookupAppLocalizations(const Locale('ja')),
      ),
      '緑スライム',
    );
    expect(
      MonsterLocalization.displayName(
        rat,
        lookupAppLocalizations(const Locale('ja')),
      ),
      '巨大ネズミ',
    );
  });

  test('a user-supplied or unknown enemy name remains literal', () {
    final l10n = lookupAppLocalizations(const Locale('ja'));
    final builtIn = MonsterDatabase.getZone1Monsters().first;
    expect(
      MonsterLocalization.displayName(
        builtIn.copyWith(name: 'My pet slime'),
        l10n,
      ),
      'My pet slime',
    );
    final custom = Monster(
      id: 'player_enemy',
      name: '私の敵',
      level: 1,
      maxHp: 10,
      attack: 1,
      defense: 0,
      xpReward: 0,
    );
    expect(MonsterLocalization.displayName(custom, l10n), '私の敵');
  });
}
