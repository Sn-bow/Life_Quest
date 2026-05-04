import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('battle effect raster assets exist', () {
    const effectPaths = [
      'assets/images/game/effects/effect_attack_slash.png',
      'assets/images/game/effects/effect_defense_shield.png',
      'assets/images/game/effects/effect_magic_projectile.png',
      'assets/images/game/effects/effect_enemy_death_burst.png',
    ];

    for (final path in effectPaths) {
      final file = File(path);
      expect(file.existsSync(), isTrue, reason: '$path is missing');
      expect(file.lengthSync(), greaterThan(0), reason: '$path is empty');
    }
  });
}
