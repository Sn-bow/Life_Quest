import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Soul Deck card frame and icon assets exist', () {
    const assetPaths = [
      'assets/images/cards/card_frame_attack.png',
      'assets/images/cards/card_frame_defense.png',
      'assets/images/cards/card_frame_magic.png',
      'assets/images/cards/card_frame_tactical.png',
      'assets/images/game/cards/icons/icon_attack.png',
      'assets/images/game/cards/icons/icon_defense.png',
      'assets/images/game/cards/icons/icon_magic.png',
      'assets/images/game/cards/icons/icon_tactical.png',
    ];

    for (final path in assetPaths) {
      final file = File(path);
      expect(file.existsSync(), isTrue, reason: '$path is missing');
      expect(file.lengthSync(), greaterThan(0), reason: '$path is empty');
    }
  });
}
