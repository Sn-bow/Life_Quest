import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('public policy page', () {
    test('matches the in-app legal URLs and required anchors', () {
      final settingsScreen = File(
        'lib/screens/settings_screen.dart',
      ).readAsStringSync();
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

    test('separates the public APK from the unreleased paid candidate', () {
      final publicPage = File('docs/index.html').readAsStringSync();

      expect(publicPage, contains('2.0.0-preview.1'));
      expect(publicPage, contains('2.0.0+2013'));
      expect(publicPage, contains('AdMob'));
      expect(publicPage, contains('Google Play Billing'));
      expect(publicPage, contains('disabled'));
      expect(publicPage, contains('Health Connect'));
      expect(publicPage, contains('account deletion'));
      expect(publicPage, contains('id="privacy-ja"'));
      expect(publicPage, contains('id="delete-account-ja"'));
      expect(publicPage, contains('logian621@gmail.com'));
    });

    test(
      'preserves earlier expedition disclosures without advertising it in the candidate',
      () {
        final publicPage = File('docs/index.html').readAsStringSync();

        expect(publicPage, contains('공개 무료 APK의 기본 퀘스트·성장·이야기·카드 탐험'));
        expect(publicPage, contains('카드 탐험 화면과 신규 카드 보상은 출시 범위에서 제외했습니다'));
        expect(publicPage, contains('現在ダウンロードできる無料APKにはカード探索があります'));
        expect(
          publicPage,
          contains(
            'The unreleased candidate does not expose card expeditions or grant new card rewards',
          ),
        );
        expect(publicPage, contains('進行中の探索記録は、下記のとおり手動バックアップの対象外'));
        expect(publicPage, contains('기기 프로필에 남을 수 있습니다'));
        expect(publicPage, contains('older expedition records'));
        expect(publicPage, contains('이전 던전 기록'));
      },
    );

    test('does not contain common mojibake markers from encoding drift', () {
      final publicPage = File('docs/index.html').readAsStringSync();

      const mojibakeMarkers = ['媛', '怨', '留', '�'];
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
