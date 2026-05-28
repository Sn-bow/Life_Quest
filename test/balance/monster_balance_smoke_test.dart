import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/data/monster_database.dart';
import 'package:life_quest_final_v2/models/card_data.dart';
import 'package:life_quest_final_v2/models/dungeon_map.dart';
import 'package:life_quest_final_v2/models/monster.dart';
import 'package:life_quest_final_v2/state/dungeon_state.dart';

void main() {
  group('Monster balance smoke', () {
    test('regular zone threat rises by chapter without extreme outliers', () {
      final zones = [
        MonsterDatabase.getZone1Monsters(),
        MonsterDatabase.getZone2Monsters(),
        MonsterDatabase.getZone3Monsters(),
        MonsterDatabase.getZone4Monsters(),
        MonsterDatabase.getZone5Monsters(),
      ];

      var previousAverage = 0.0;
      for (var zoneIndex = 0; zoneIndex < zones.length; zoneIndex++) {
        final zone = zones[zoneIndex];
        expect(zone, hasLength(5), reason: 'Zone ${zoneIndex + 1}');

        final averageThreat =
            zone.map(_threat).reduce((a, b) => a + b) / zone.length;
        expect(
          averageThreat,
          greaterThan(previousAverage),
          reason: 'Zone ${zoneIndex + 1} should be harder than the prior zone.',
        );

        for (final monster in zone) {
          final ratio = _threat(monster) / averageThreat;
          expect(
            ratio,
            inInclusiveRange(0.55, 1.45),
            reason:
                '${monster.id} is an outlier in Zone ${zoneIndex + 1}: threat=${_threat(monster)}, average=$averageThreat',
          );
        }

        previousAverage = averageThreat;
      }
    });

    test('dungeon boss progression does not drop in threat', () {
      const expectedBossOrder = [
        'boss_troll',
        'boss_hydra',
        'boss_dragon',
        'boss_demon_lord',
        'boss_fallen_angel',
      ];

      var previousThreat = 0.0;
      for (var zone = 1; zone <= MonsterDatabase.maxChapters; zone++) {
        final state = DungeonState()
          ..startRun(
            zone: zone,
            startingDeck: const <CardData>[],
            playerMaxHp: 80,
          );
        final boss = state
            .getEnemiesForNode(
              const DungeonNode(id: 1, type: NodeType.boss, row: 5, column: 0),
            )
            .single
            .monster;
        expect(
          boss.id,
          expectedBossOrder[zone - 1],
          reason: 'Zone $zone should use the intended boss curve.',
        );
        expect(
          _threat(boss),
          greaterThan(previousThreat),
          reason: 'Zone $zone boss should not be weaker than prior boss.',
        );
        previousThreat = _threat(boss);
      }
    });

    test('dungeon floor scaling keeps early chapter threat increasing', () {
      var previousThreat = 0.0;
      for (var floor = 1; floor <= 5; floor++) {
        final monster = MonsterDatabase.getMonsterForDungeon(1, floor);
        expect(
          _threat(monster),
          greaterThan(previousThreat),
          reason: 'Chapter 1 floor $floor should ramp from the prior floor.',
        );
        previousThreat = _threat(monster);
      }
    });
  });
}

double _threat(Monster monster) {
  return monster.maxHp + (monster.attack * 8) + (monster.defense * 4);
}
