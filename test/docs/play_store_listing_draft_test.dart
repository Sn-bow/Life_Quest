import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Play Store listing draft', () {
    late String draft;

    setUpAll(() {
      draft = File(
        'docs/lifequest-play-store-listing-draft-20260520.md',
      ).readAsStringSync();
    });

    test('keeps Play Console text fields within documented limits', () {
      expect(_textBlockAfter(draft, 'App name:').length, lessThanOrEqualTo(30));
      expect(
        _allBlocksAfterHeading(draft, 'Short description:'),
        everyElement(hasLength(lessThanOrEqualTo(80))),
      );
      expect(
        _allBlocksAfterHeading(draft, 'Full description:'),
        everyElement(hasLength(lessThanOrEqualTo(4000))),
      );
    });

    test('does not contain mojibake or unsupported shipped-feature claims', () {
      const forbiddenMarkers = [
        '媛',
        '怨',
        '留',
        '�',
        'Health Connect sync',
        'Google Fit sync',
        'AI coach included',
        'AI coaching is available',
        'AI-powered coach',
        'chatbot included',
        'subscription plan',
        'ad rewards are available',
        'in-app purchases are available',
      ];

      for (final marker in forbiddenMarkers) {
        expect(
          draft.contains(marker),
          isFalse,
          reason: 'Listing draft contains forbidden marker or claim: $marker',
        );
      }
    });

    test('states default Android release monetization and health scope', () {
      expect(draft, contains('default real Android app'));
      expect(draft, contains('Health Connect'));
      expect(draft, contains('Google Fit'));
      expect(
          draft, contains('disabled in the current default Android release'));
      expect(draft, contains('광고와 인앱 결제가 비활성화'));
      expect(draft, contains('의료, 건강, 재정, 법률 조언을 제공하지 않습니다'));
    });
  });
}

String _textBlockAfter(String source, String label) {
  final labelIndex = source.indexOf(label);
  if (labelIndex == -1) return '';
  final afterLabel = source.substring(labelIndex + label.length);
  final match = RegExp(r'```text\s*([\s\S]*?)```').firstMatch(afterLabel);
  return match?.group(1)?.trim() ?? '';
}

List<String> _allBlocksAfterHeading(String source, String label) {
  final blocks = <String>[];
  var searchFrom = 0;
  while (true) {
    final labelIndex = source.indexOf(label, searchFrom);
    if (labelIndex == -1) break;
    final afterLabel = source.substring(labelIndex + label.length);
    final match = RegExp(r'```text\s*([\s\S]*?)```').firstMatch(afterLabel);
    if (match != null) {
      blocks.add(match.group(1)!.trim());
      searchFrom = labelIndex + label.length + match.end;
    } else {
      searchFrom = labelIndex + label.length;
    }
  }
  return blocks;
}
