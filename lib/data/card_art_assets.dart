import 'package:life_quest_final_v2/models/card_data.dart';

class CardArtAssets {
  CardArtAssets._();

  static const String artDirectory = 'assets/images/game/cards/art';

  static const Set<String> sampleCardIds = {
    'base_strike',
    'base_defend',
    'base_focus',
    'atk_c01',
    'atk_c02',
    'def_c01',
    'def_c02',
    'mag_c01',
    'mag_c02',
    'tac_c01',
    'tac_c02',
  };

  static String? artPathFor(CardData card) {
    final explicitPath = card.spritePath.trim();
    if (explicitPath.isNotEmpty) {
      return explicitPath;
    }

    if (!sampleCardIds.contains(card.id)) {
      return null;
    }

    return '$artDirectory/${card.id}.png';
  }
}
