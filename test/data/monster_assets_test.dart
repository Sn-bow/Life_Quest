import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/data/monster_database.dart';
import 'package:life_quest_final_v2/models/monster.dart';

void main() {
  group('Monster assets', () {
    test('all monster sprite paths point to existing PNG assets', () {
      final monsters = <Monster>[
        ...MonsterDatabase.getZone1Monsters(),
        ...MonsterDatabase.getZone2Monsters(),
        ...MonsterDatabase.getZone3Monsters(),
        ...MonsterDatabase.getZone4Monsters(),
        ...MonsterDatabase.getZone5Monsters(),
        ...MonsterDatabase.getBossMonsters(),
      ];

      final missing = <String>[];
      for (final monster in monsters) {
        final spritePath = monster.spritePath.trim();
        if (spritePath.isEmpty || !File(spritePath).existsSync()) {
          missing.add('${monster.id}: $spritePath');
        }
      }

      expect(missing, isEmpty, reason: missing.join('\n'));
    });
  });
}
