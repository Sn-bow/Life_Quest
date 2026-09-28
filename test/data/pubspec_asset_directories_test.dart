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

    test('release bundle includes core visuals without dormant game artwork', () {
      final pubspec = File('pubspec.yaml').readAsStringSync();
      for (final path in [
        'assets/story/',
        'assets/images/',
        'assets/images/ui/',
        'assets/sounds/',
        'assets/sounds/sfx/',
      ]) {
        expect(pubspec, contains('- $path'));
      }
      expect(pubspec, contains('- assets/images/backgrounds/journal_worlds.jpg'));
      for (final path in [
        'assets/images/monsters/',
        'assets/images/cards/',
        'assets/images/game/',
        'assets/sounds/game/',
        'assets/sounds/bgm/',
      ]) {
        expect(pubspec, isNot(contains('- $path')));
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
