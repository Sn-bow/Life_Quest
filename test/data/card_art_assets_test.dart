import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/data/card_art_assets.dart';
import 'package:life_quest_final_v2/data/card_database.dart';

void main() {
  test('sample card art ids resolve to stable PNG paths', () {
    expect(CardArtAssets.sampleCardIds.length, 11);

    for (final cardId in CardArtAssets.sampleCardIds) {
      final card = CardDatabase.getCard(cardId);
      expect(card, isNotNull, reason: '$cardId is not in CardDatabase');

      final path = CardArtAssets.artPathFor(card!);
      expect(path, 'assets/images/game/cards/art/$cardId.png');
    }
  });

  test('sample card art PNG files exist as square 1024 assets', () {
    for (final cardId in CardArtAssets.sampleCardIds) {
      final file = File('assets/images/game/cards/art/$cardId.png');
      expect(file.existsSync(), isTrue, reason: '$cardId art is missing');
      expect(file.lengthSync(), greaterThan(0), reason: '$cardId art is empty');

      final size = _readPngSize(file.readAsBytesSync());
      expect(size, isNotNull, reason: '$cardId art is not a valid PNG');
      expect(size!.width, 1024, reason: '$cardId art width must be 1024');
      expect(size.height, 1024, reason: '$cardId art height must be 1024');
    }
  });

  test(
      'non-sample cards keep using category icon fallback unless explicit art is set',
      () {
    final card = CardDatabase.getCard('atk_c03');
    expect(card, isNotNull);
    expect(CardArtAssets.artPathFor(card!), isNull);
  });
}

({int width, int height})? _readPngSize(List<int> bytes) {
  const pngSignature = [137, 80, 78, 71, 13, 10, 26, 10];
  if (bytes.length < 24) {
    return null;
  }

  for (var i = 0; i < pngSignature.length; i++) {
    if (bytes[i] != pngSignature[i]) {
      return null;
    }
  }

  final data = ByteData.sublistView(Uint8List.fromList(bytes));
  return (
    width: data.getUint32(16, Endian.big),
    height: data.getUint32(20, Endian.big),
  );
}
