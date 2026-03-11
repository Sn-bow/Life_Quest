import 'package:flutter/material.dart';

enum CosmeticCategory {
  theme,
  titleEffect,
  combatEffect,
}

class CosmeticItem {
  final String id;
  final String iapId; // The product ID in App Store / Play Console
  final String name;
  final String description;
  final CosmeticCategory category;
  final IconData icon;
  final Color color;

  const CosmeticItem({
    required this.id,
    required this.iapId,
    required this.name,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
  });
}

class CosmeticDatabase {
  static const List<CosmeticItem> items = [
    CosmeticItem(
      id: 'theme_neon_cyberpunk',
      iapId: 'cosmetic_theme_neon',
      name: '사이버펑크 네온 테마',
      description: '앱 전체 테마를 미래지향적인 네온 스타일로 변경합니다.',
      category: CosmeticCategory.theme,
      icon: Icons.monitor_heart,
      color: Colors.pinkAccent,
    ),
    CosmeticItem(
      id: 'theme_royal_gold',
      iapId: 'cosmetic_theme_gold',
      name: '로열 골드 테마',
      description: '고급스러운 황금빛 테마로 상태창을 장식합니다.',
      category: CosmeticCategory.theme,
      icon: Icons.diamond,
      color: Colors.amber,
    ),
    CosmeticItem(
      id: 'title_effect_fire',
      iapId: 'cosmetic_title_fire',
      name: '불타는 칭호 이펙트',
      description: '상태창의 칭호에 불타오르는 이펙트를 부여합니다.',
      category: CosmeticCategory.titleEffect,
      icon: Icons.local_fire_department,
      color: Colors.deepOrange,
    ),
    CosmeticItem(
      id: 'title_effect_sparkle',
      iapId: 'cosmetic_title_sparkle',
      name: '빛나는 칭호 이펙트',
      description: '칭호 주변에 반짝이는 별빛 이펙트를 추가합니다.',
      category: CosmeticCategory.titleEffect,
      icon: Icons.star_border,
      color: Colors.yellowAccent,
    ),
    CosmeticItem(
      id: 'combat_effect_lightning',
      iapId: 'cosmetic_combat_lightning',
      name: '번개 공격 이펙트',
      description: '전투 중 공격 시 번개 임팩트가 출력됩니다.',
      category: CosmeticCategory.combatEffect,
      icon: Icons.bolt,
      color: Colors.blueAccent,
    ),
  ];

  static CosmeticItem? getById(String id) {
    return items.where((item) => item.id == id).firstOrNull;
  }
}
