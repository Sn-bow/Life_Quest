import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/models/character.dart';
import 'package:life_quest_final_v2/models/item.dart';

void main() {
  group('Character Model Tests', () {
    test('Character initialization sets default values correctly', () {
      final character = Character(
        name: 'TestHero',
        level: 1,
        title: 'Novice',
        xp: 0,
        maxXp: 100,
        strength: 10,
        wisdom: 10,
        health: 10,
        charisma: 10,
        statPoints: 5,
        skillPoints: 1,
      );

      expect(character.name, 'TestHero');
      expect(character.level, 1);
      expect(character.actionPoints, 10);
      expect(character.maxActionPoints, 10);
      expect(character.characterHp, 100);
      expect(character.characterMaxHp, 100);
      expect(character.streak, 0);
      expect(character.gold, 0);
      expect(character.inventory, isEmpty);
      expect(character.unlockedCosmetics, isEmpty);
      expect(character.equippedTheme, isNull);
      expect(character.highestDungeonFloor, 1);
      expect(character.currentDungeonChapter, 1);
    });

    test('fromJson and toJson methods work correctly', () {
      final item = EquipmentItem(
        id: 'wp1',
        name: 'Iron Sword',
        description: 'A basic sword',
        type: ItemType.weapon,
        bonusStrength: 5,
      );

      final character = Character(
        name: 'TestHero',
        level: 2,
        title: 'Apprentice',
        xp: 50,
        maxXp: 150,
        strength: 12,
        wisdom: 11,
        health: 10,
        charisma: 13,
        statPoints: 2,
        skillPoints: 0,
        actionPoints: 5,
        maxActionPoints: 15,
        characterHp: 80,
        characterMaxHp: 120,
        streak: 5,
        gold: 100,
        inventory: [item],
        equippedWeapon: item,
      );

      final json = character.toJson();
      final newCharacter = Character.fromJson(json);

      expect(newCharacter.name, 'TestHero');
      expect(newCharacter.level, 2);
      expect(newCharacter.title, 'Apprentice');
      expect(newCharacter.xp, 50);
      expect(newCharacter.maxXp, 150);
      expect(newCharacter.strength, 12);
      expect(newCharacter.actionPoints, 5);
      expect(newCharacter.characterHp, 80);
      expect(newCharacter.streak, 5);
      expect(newCharacter.gold, 100);
      expect(newCharacter.inventory.length, 1);
      expect(newCharacter.inventory.first.name, 'Iron Sword');
      expect(newCharacter.equippedWeapon?.name, 'Iron Sword');
      expect(newCharacter.equippedArmor, isNull);
    });

    // D-1: fromJson edge cases
    test('fromJson handles null fields with defaults', () {
      final json = <String, dynamic>{};
      final character = Character.fromJson(json);

      expect(character.name, '모험가');
      expect(character.level, 1);
      expect(character.title, '새싹 모험가');
      expect(character.xp, 0.0);
      expect(character.maxXp, 150.0);
      expect(character.strength, 0.0);
      expect(character.wisdom, 0.0);
      expect(character.health, 0.0);
      expect(character.charisma, 0.0);
      expect(character.statPoints, 0);
      expect(character.skillPoints, 0);
      expect(character.actionPoints, 10);
      expect(character.characterHp, 100);
      expect(character.gold, 0);
      expect(character.inventory, isEmpty);
      expect(character.highestDungeonFloor, 1);
    });

    test('fromJson handles partial fields', () {
      final json = <String, dynamic>{
        'name': 'PartialHero',
        'level': 5,
      };
      final character = Character.fromJson(json);

      expect(character.name, 'PartialHero');
      expect(character.level, 5);
      expect(character.title, '새싹 모험가');
      expect(character.xp, 0.0);
    });

    test('fromJson handles integer xp and stats correctly', () {
      final json = <String, dynamic>{
        'name': 'Hero',
        'level': 3,
        'title': 'Warrior',
        'xp': 50,
        'maxXp': 200,
        'strength': 15,
        'wisdom': 10,
        'health': 20,
        'charisma': 5,
        'statPoints': 3,
        'skillPoints': 1,
      };
      final character = Character.fromJson(json);

      expect(character.xp, 50.0);
      expect(character.maxXp, 200.0);
      expect(character.strength, 15.0);
    });

    test('fromJson handles lastLoginDate correctly', () {
      final json = <String, dynamic>{
        'lastLoginDate': '2024-01-15T10:30:00.000',
      };
      final character = Character.fromJson(json);

      expect(character.lastLoginDate, isNotNull);
      expect(character.lastLoginDate!.year, 2024);
      expect(character.lastLoginDate!.month, 1);
    });

    test('fromJson handles null lastLoginDate', () {
      final json = <String, dynamic>{};
      final character = Character.fromJson(json);

      expect(character.lastLoginDate, isNull);
    });

    test('toJson produces complete output', () {
      final character = Character(
        name: 'Hero',
        level: 10,
        title: 'Warrior',
        xp: 50,
        maxXp: 600,
        strength: 20,
        wisdom: 15,
        health: 25,
        charisma: 10,
        statPoints: 5,
        skillPoints: 2,
        gold: 500,
        equippedTheme: 'theme_neon_cyberpunk',
      );

      final json = character.toJson();

      expect(json['name'], 'Hero');
      expect(json['level'], 10);
      expect(json['gold'], 500);
      expect(json['equippedTheme'], 'theme_neon_cyberpunk');
      expect(json['inventory'], isA<List>());
    });

    test('fromJson handles equipped items', () {
      final weaponJson = {
        'id': 'w1',
        'name': 'Sword',
        'description': '',
        'type': 'weapon',
        'rarity': 'rare',
        'bonusStrength': 10.0,
        'bonusWisdom': 0.0,
        'bonusHealth': 0.0,
        'bonusCharisma': 0.0,
        'attackPower': 15.0,
        'defensePower': 0.0,
        'spritePath': '',
      };

      final json = <String, dynamic>{
        'equippedWeapon': weaponJson,
      };
      final character = Character.fromJson(json);

      expect(character.equippedWeapon, isNotNull);
      expect(character.equippedWeapon!.name, 'Sword');
      expect(character.equippedWeapon!.rarity, ItemRarity.rare);
    });
  });
}

