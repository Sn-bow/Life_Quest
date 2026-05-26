import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';

void main() {
  test('SoundService references existing bundled assets', () {
    for (final assetPath in SoundService.referencedAssetPaths) {
      expect(
        File('assets/$assetPath').existsSync(),
        isTrue,
        reason: 'Missing sound asset: assets/$assetPath',
      );
    }
  });
}
