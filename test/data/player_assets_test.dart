import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Player assets', () {
    test('battle idle sprite exists', () {
      expect(File('assets/images/player/hero_idle.png').existsSync(), isTrue);
    });
  });
}
