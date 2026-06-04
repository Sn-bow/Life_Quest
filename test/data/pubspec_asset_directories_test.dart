import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('pubspec asset directories', () {
    test('all declared directory assets exist on disk', () {
      final pubspec = File('pubspec.yaml').readAsStringSync();
      final declaredDirectories = _declaredAssetDirectories(pubspec);

      expect(declaredDirectories, isNotEmpty);
      for (final path in declaredDirectories) {
        expect(
          Directory(path).existsSync(),
          isTrue,
          reason: '$path is declared in pubspec.yaml but missing on disk.',
        );
      }
    });

    test('game asset directory skeleton is tracked for release builds', () {
      const requiredDirectories = [
        'assets/images/game/',
        'assets/images/game/player/',
        'assets/images/game/monsters/',
        'assets/images/game/backgrounds/',
        'assets/images/game/effects/',
        'assets/images/game/cards/frames/',
        'assets/images/game/cards/icons/',
        'assets/images/game/cards/art/',
        'assets/images/game/cards/full_body/',
        'assets/images/game/relics/',
        'assets/images/game/ui/',
        'assets/images/game/map/',
      ];

      final pubspec = File('pubspec.yaml').readAsStringSync();
      for (final path in requiredDirectories) {
        expect(pubspec, contains('- $path'));
        expect(
          Directory(path).existsSync(),
          isTrue,
          reason: '$path must exist for the Android release asset bundle.',
        );
      }
    });
  });
}

List<String> _declaredAssetDirectories(String pubspec) {
  return pubspec
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.startsWith('- assets/') && line.endsWith('/'))
      .map((line) => line.substring(2).trim())
      .toList(growable: false);
}
