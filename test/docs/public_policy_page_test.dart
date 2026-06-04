import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('public policy page', () {
    test('matches the in-app legal URLs and required anchors', () {
      final settingsScreen =
          File('lib/screens/settings_screen.dart').readAsStringSync();
      final publicPage = File('docs/index.html').readAsStringSync();
      final runbook = File(
        'docs/lifequest-play-console-submission-runbook-20260525.md',
      ).readAsStringSync();

      expect(
        settingsScreen,
        contains('https://sn-bow.github.io/Life_Quest/#privacy'),
      );
      expect(
        settingsScreen,
        contains('https://sn-bow.github.io/Life_Quest/#terms'),
      );
      expect(publicPage, contains('id="privacy"'));
      expect(publicPage, contains('id="terms"'));
      expect(publicPage, contains('id="delete-account"'));
      expect(runbook, contains('Complete the privacy policy URL field'));
    });

    test('states the default Android data-safety scope clearly', () {
      final publicPage = File('docs/index.html').readAsStringSync();

      expect(publicPage, contains('default Android release'));
      expect(publicPage, contains('AdMob'));
      expect(publicPage, contains('Google Play Billing'));
      expect(publicPage, contains('disabled'));
      expect(publicPage, contains('Health Connect'));
      expect(publicPage, contains('account deletion'));
      expect(publicPage, contains('logian621@gmail.com'));
    });

    test('does not contain common mojibake markers from encoding drift', () {
      final publicPage = File('docs/index.html').readAsStringSync();

      const mojibakeMarkers = [
        '媛',
        '怨',
        '留',
        '�',
      ];
      for (final marker in mojibakeMarkers) {
        expect(
          publicPage.contains(marker),
          isFalse,
          reason: 'docs/index.html contains mojibake marker "$marker".',
        );
      }
    });
  });
}
