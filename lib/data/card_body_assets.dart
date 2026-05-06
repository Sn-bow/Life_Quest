import 'package:life_quest_final_v2/models/card_data.dart';

/// Full card body image mapping.
///
/// Full body images (card_body_{category}_{rarity}.png) replace the legacy
/// frame-PNG + center-art-PNG assembly. Each image is a complete card
/// background (art + themed atmosphere) rendered at 440×616 px with NO text,
/// numbers, or UI elements. Flutter overlays cost, name, description, and
/// rarity labels on top at runtime.
///
/// ## Image spec
/// - Pixel size: 440 × 616 px (aspect ratio ≈ 0.714, matches card display)
/// - Top ~55 %: main illustration zone (dramatic, centered subject)
/// - Bottom ~45 %: naturally darker gradient zone (for text readability)
/// - Format: PNG (RGBA, transparent outer corners optional)
/// - Constraints: no text, no numbers, no cost gem, no rarity label,
///   no card frame border line, no logo, no watermark
///
/// ## Generation
/// Images are created with Codex's built-in image generation capability.
/// Add the '{category}_{rarity}' key to [_availableBodies] after placing the
/// PNG in [bodyDirectory].
class CardBodyAssets {
  CardBodyAssets._();

  /// Asset directory for full card body images.
  static const String bodyDirectory = 'assets/images/game/cards/full_body';

  // ---------------------------------------------------------------------------
  // Available bodies registry
  //
  // Add '{category}_{rarity}' here after the PNG is committed to bodyDirectory.
  // Codex generates images with the internal image generation tool; no
  // OPENAI_API_KEY is required.
  //
  // Examples:
  //   'attack_common',
  //   'defense_uncommon',
  //   'magic_rare',
  //   'tactical_legendary',
  // ---------------------------------------------------------------------------
  static const Set<String> _availableBodies = <String>{
    // Populated as images are generated.
  };

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Returns true if a full-body PNG is registered for [card]'s category +
  /// rarity.
  static bool hasBodyFor(CardData card) {
    return _availableBodies.contains(_key(card.category, card.rarity));
  }

  /// Returns the canonical asset path for [card]'s full-body image.
  ///
  /// The file may not exist on disk yet. Use [resolvedBodyPath] for a path
  /// that is guaranteed to be in [_availableBodies].
  static String bodyPathFor(CardData card) {
    return _buildPath(card.category, card.rarity);
  }

  /// Returns the body path to use at runtime, applying a common-rarity
  /// fallback when the exact rarity body is not yet available.
  ///
  /// Returns null when neither the exact rarity nor common is registered,
  /// signalling [SoulDeckCardView] to use the legacy frame + art layout.
  static String? resolvedBodyPath(CardData card) {
    if (hasBodyFor(card)) return bodyPathFor(card);

    // Common-rarity fallback: same category, common rarity body.
    final commonKey = _key(card.category, CardRarity.common);
    if (_availableBodies.contains(commonKey)) {
      return _buildPath(card.category, CardRarity.common);
    }

    return null;
  }

  /// All 16 expected body image paths (4 categories × 4 rarities).
  ///
  /// Used for generation planning and asset-existence tests. Not all need to
  /// exist initially; add entries to [_availableBodies] as images are created.
  static List<String> allExpectedPaths() {
    return [
      for (final cat in CardCategory.values)
        for (final rar in CardRarity.values) _buildPath(cat, rar),
    ];
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  static String _key(CardCategory c, CardRarity r) =>
      '${_categoryKey(c)}_${_rarityKey(r)}';

  static String _buildPath(CardCategory c, CardRarity r) =>
      '$bodyDirectory/card_body_${_categoryKey(c)}_${_rarityKey(r)}.png';

  static String _categoryKey(CardCategory c) {
    switch (c) {
      case CardCategory.attack:
        return 'attack';
      case CardCategory.defense:
        return 'defense';
      case CardCategory.magic:
        return 'magic';
      case CardCategory.tactical:
        return 'tactical';
    }
  }

  static String _rarityKey(CardRarity r) {
    switch (r) {
      case CardRarity.common:
        return 'common';
      case CardRarity.uncommon:
        return 'uncommon';
      case CardRarity.rare:
        return 'rare';
      case CardRarity.legendary:
        return 'legendary';
    }
  }
}
