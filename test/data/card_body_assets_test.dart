import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/data/card_body_assets.dart';
import 'package:life_quest_final_v2/models/card_data.dart';

void main() {
  // ── Path generation ─────────────────────────────────────────────────────────

  group('CardBodyAssets path generation', () {
    test('bodyPathFor returns correct path for every category/rarity combo',
        () {
      const expected = {
        (CardCategory.attack, CardRarity.common):
            'assets/images/game/cards/full_body/card_body_attack_common.png',
        (CardCategory.attack, CardRarity.uncommon):
            'assets/images/game/cards/full_body/card_body_attack_uncommon.png',
        (CardCategory.attack, CardRarity.rare):
            'assets/images/game/cards/full_body/card_body_attack_rare.png',
        (CardCategory.attack, CardRarity.legendary):
            'assets/images/game/cards/full_body/card_body_attack_legendary.png',
        (CardCategory.defense, CardRarity.common):
            'assets/images/game/cards/full_body/card_body_defense_common.png',
        (CardCategory.magic, CardRarity.common):
            'assets/images/game/cards/full_body/card_body_magic_common.png',
        (CardCategory.tactical, CardRarity.common):
            'assets/images/game/cards/full_body/card_body_tactical_common.png',
        (
          CardCategory.tactical,
          CardRarity.legendary
        ): 'assets/images/game/cards/full_body/card_body_tactical_legendary.png',
      };

      for (final entry in expected.entries) {
        final card = _card(entry.key.$1, entry.key.$2);
        expect(CardBodyAssets.bodyPathFor(card), entry.value,
            reason: '${entry.key.$1.name} ${entry.key.$2.name}');
      }
    });

    test('allExpectedPaths returns exactly 16 paths', () {
      final paths = CardBodyAssets.allExpectedPaths();
      expect(paths, hasLength(16));
    });

    test('allExpectedPaths contains all 4 categories × 4 rarities', () {
      final paths = CardBodyAssets.allExpectedPaths();
      for (final cat in CardCategory.values) {
        for (final rar in CardRarity.values) {
          final expected =
              'assets/images/game/cards/full_body/card_body_${cat.name}_${rar.name}.png';
          expect(paths, contains(expected),
              reason: 'Missing path for ${cat.name} ${rar.name}');
        }
      }
    });

    test('all generated paths start with the body directory constant', () {
      final paths = CardBodyAssets.allExpectedPaths();
      for (final path in paths) {
        expect(path, startsWith(CardBodyAssets.bodyDirectory),
            reason: 'Unexpected prefix: $path');
        expect(path, endsWith('.png'));
      }
    });
  });

  // ── Availability registry ───────────────────────────────────────────────────

  group('CardBodyAssets availability registry', () {
    test('hasBodyFor returns true for generated common bodies only', () {
      for (final cat in CardCategory.values) {
        for (final rar in CardRarity.values) {
          final card = _card(cat, rar);
          expect(CardBodyAssets.hasBodyFor(card), rar == CardRarity.common,
              reason: '${cat.name} ${rar.name} availability mismatch');
        }
      }
    });

    test('resolvedBodyPath uses common category fallback for every rarity', () {
      for (final cat in CardCategory.values) {
        for (final rar in CardRarity.values) {
          final card = _card(cat, rar);
          expect(
            CardBodyAssets.resolvedBodyPath(card),
            'assets/images/game/cards/full_body/card_body_${cat.name}_common.png',
            reason:
                '${cat.name} ${rar.name} should resolve to generated common body',
          );
        }
      }
    });
  });

  // ── Asset directory registration ────────────────────────────────────────────

  group('Asset directory registration', () {
    test('full_body directory is registered in pubspec.yaml', () {
      final pubspec = File('pubspec.yaml').readAsStringSync();
      expect(
        pubspec,
        contains('assets/images/game/cards/full_body/'),
        reason: 'pubspec.yaml must register the full_body asset directory',
      );
    });

    test('full_body directory exists on disk', () {
      final dir = Directory('assets/images/game/cards/full_body');
      expect(dir.existsSync(), isTrue,
          reason:
              'assets/images/game/cards/full_body/ must exist for Flutter to '
              'register the asset directory');
    });

    test('generated common body PNGs exist on disk', () {
      for (final cat in CardCategory.values) {
        final path =
            'assets/images/game/cards/full_body/card_body_${cat.name}_common.png';
        final file = File(path);
        expect(file.existsSync(), isTrue, reason: 'Missing generated $path');
        expect(file.lengthSync(), greaterThan(100000),
            reason: '$path should be a real generated PNG, not a placeholder');
      }
    });

    test('generated common body PNGs are normalized to 440x616', () {
      for (final cat in CardCategory.values) {
        final path =
            'assets/images/game/cards/full_body/card_body_${cat.name}_common.png';
        final size = _pngSize(File(path));
        expect(size, (440, 616), reason: '$path must match card body spec');
      }
    });
  });

  // ── Fallback safety ─────────────────────────────────────────────────────────

  group('Fallback safety', () {
    test('bodyPathFor never returns empty string regardless of category/rarity',
        () {
      for (final cat in CardCategory.values) {
        for (final rar in CardRarity.values) {
          final path = CardBodyAssets.bodyPathFor(_card(cat, rar));
          expect(path, isNotEmpty,
              reason: 'bodyPathFor must always return a non-empty path');
        }
      }
    });

    test('bodyDirectory constant matches paths produced by bodyPathFor', () {
      final card = _card(CardCategory.attack, CardRarity.common);
      final path = CardBodyAssets.bodyPathFor(card);
      expect(path, startsWith('${CardBodyAssets.bodyDirectory}/'));
    });
  });
}

// ── Helpers ──────────────────────────────────────────────────────────────────

CardData _card(CardCategory cat, CardRarity rar) => CardData(
      id: 'test_${cat.name}_${rar.name}',
      name: 'Test Card',
      category: cat,
      rarity: rar,
      cost: 1,
      description: 'Test description.',
      effects: const [],
    );

(int width, int height) _pngSize(File file) {
  final bytes = file.readAsBytesSync();
  expect(bytes.length, greaterThanOrEqualTo(24), reason: file.path);
  expect(bytes[0], 0x89, reason: file.path);
  expect(bytes[1], 0x50, reason: file.path);
  expect(bytes[2], 0x4E, reason: file.path);
  expect(bytes[3], 0x47, reason: file.path);

  int readUint32(int offset) =>
      (bytes[offset] << 24) |
      (bytes[offset + 1] << 16) |
      (bytes[offset + 2] << 8) |
      bytes[offset + 3];

  return (readUint32(16), readUint32(20));
}
