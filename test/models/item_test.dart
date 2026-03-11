import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/models/item.dart';

void main() {
  group('EquipmentItem Model Tests', () {
    test('EquipmentItem initializes with defaults', () {
      final item = EquipmentItem(
        id: 'i1',
        name: 'Basic Shield',
        description: 'A sturdy shield',
        type: ItemType.armor,
      );

      expect(item.id, 'i1');
      expect(item.rarity, ItemRarity.common);
      expect(item.bonusStrength, 0);
      expect(item.attackPower, 0);
      expect(item.defensePower, 0);
      expect(item.spritePath, '');
    });

    test('fromJson and toJson roundtrip works', () {
      final item = EquipmentItem(
        id: 'w1',
        name: 'Fire Sword',
        description: 'Burns enemies',
        type: ItemType.weapon,
        rarity: ItemRarity.epic,
        bonusStrength: 15,
        attackPower: 25,
      );

      final json = item.toJson();
      final restored = EquipmentItem.fromJson(json);

      expect(restored.id, 'w1');
      expect(restored.name, 'Fire Sword');
      expect(restored.type, ItemType.weapon);
      expect(restored.rarity, ItemRarity.epic);
      expect(restored.bonusStrength, 15);
      expect(restored.attackPower, 25);
    });

    test('fromJson handles null id and name with defaults', () {
      final json = <String, dynamic>{};
      final item = EquipmentItem.fromJson(json);

      expect(item.name, '알 수 없는 아이템');
      expect(item.id, startsWith('unknown_'));
      expect(item.description, '');
      expect(item.type, ItemType.consumable);
      expect(item.rarity, ItemRarity.common);
    });

    test('fromJson handles unknown type string', () {
      final json = <String, dynamic>{
        'id': 'i2',
        'name': 'Mystery',
        'type': 'nonexistent',
        'rarity': 'nonexistent',
      };
      final item = EquipmentItem.fromJson(json);

      expect(item.type, ItemType.consumable);
      expect(item.rarity, ItemRarity.common);
    });

    test('fromJson converts int stats to double', () {
      final json = <String, dynamic>{
        'id': 'i3',
        'name': 'Ring',
        'type': 'accessory',
        'rarity': 'legendary',
        'bonusStrength': 5,
        'bonusWisdom': 10,
        'attackPower': 0,
        'defensePower': 3,
      };
      final item = EquipmentItem.fromJson(json);

      expect(item.bonusStrength, 5.0);
      expect(item.bonusWisdom, 10.0);
      expect(item.defensePower, 3.0);
      expect(item.rarity, ItemRarity.legendary);
    });
  });
}
