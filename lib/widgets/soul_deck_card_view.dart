import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/data/card_art_assets.dart';
import 'package:life_quest_final_v2/data/card_body_assets.dart';
import 'package:life_quest_final_v2/data/card_localization.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/models/card_data.dart';

enum SoulDeckCardSize {
  hand,
  reward,
  mini,
}

/// Unified card widget used across all Soul Deck screens.
///
/// ## Rendering modes
///
/// ### Full-body mode (preferred)
/// Used when [CardBodyAssets.resolvedBodyPath] returns a non-null path.
/// A single 440×616 card body image fills the entire card background.
/// Flutter overlays gradient scrims and text (cost, name, description, rarity)
/// on top with [Positioned] widgets.
///
/// ### Legacy mode (fallback)
/// Used until full-body images are generated.
/// Renders the existing frame PNG + center art/icon assembly via a [Column].
/// Behaviour is identical to the original implementation.
///
/// Switching between modes: [CardBodyAssets._availableBodies] controls which
/// body images are considered available. Add the '{category}_{rarity}' key
/// there after placing the PNG in the asset directory.
class SoulDeckCardView extends StatelessWidget {
  final CardData card;
  final SoulDeckCardSize size;
  final bool enabled;
  final bool showRarity;
  final VoidCallback? onTap;

  const SoulDeckCardView({
    super.key,
    required this.card,
    this.size = SoulDeckCardSize.hand,
    this.enabled = true,
    this.showRarity = true,
    this.onTap,
  });

  // ── Dimensions ─────────────────────────────────────────────────────────────

  double get _width {
    switch (size) {
      case SoulDeckCardSize.hand:
        return 110;
      case SoulDeckCardSize.reward:
        return 94;
      case SoulDeckCardSize.mini:
        return 72;
    }
  }

  double get _height {
    switch (size) {
      case SoulDeckCardSize.hand:
        return 154;
      case SoulDeckCardSize.reward:
        return 142;
      case SoulDeckCardSize.mini:
        return 108;
    }
  }

  // ── Layout helpers ──────────────────────────────────────────────────────────

  /// Horizontal padding inside the card (left / right).
  double get _hPad {
    switch (size) {
      case SoulDeckCardSize.hand:
        return 8;
      case SoulDeckCardSize.reward:
        return 7;
      case SoulDeckCardSize.mini:
        return 5;
    }
  }

  /// Vertical padding inside the card (top / bottom).
  double get _vPad => 5.0;

  /// Height of the cost-gem + card-name row.
  double get _headerHeight {
    switch (size) {
      case SoulDeckCardSize.hand:
        return 22;
      case SoulDeckCardSize.reward:
        return 20;
      case SoulDeckCardSize.mini:
        return 17;
    }
  }

  // ── Typography ──────────────────────────────────────────────────────────────

  /// Legacy center-art square dimension.
  double get _iconSize {
    switch (size) {
      case SoulDeckCardSize.hand:
        return 64;
      case SoulDeckCardSize.reward:
        return 48;
      case SoulDeckCardSize.mini:
        return 32;
    }
  }

  double get _nameFontSize {
    switch (size) {
      case SoulDeckCardSize.hand:
        return 10;
      case SoulDeckCardSize.reward:
        return 9.5;
      case SoulDeckCardSize.mini:
        return 8.5;
    }
  }

  double get _descriptionFontSize {
    switch (size) {
      case SoulDeckCardSize.hand:
        return 9;
      case SoulDeckCardSize.reward:
        return 8.2;
      case SoulDeckCardSize.mini:
        return 7.5;
    }
  }

  /// Max description lines in legacy mode.
  int get _descriptionLines {
    switch (size) {
      case SoulDeckCardSize.hand:
        return 5;
      case SoulDeckCardSize.reward:
        return 4;
      case SoulDeckCardSize.mini:
        return 3;
    }
  }

  /// Max description lines in full-body mode.
  /// One extra line versus legacy because the center-art slot is freed.
  int get _fullBodyDescriptionLines {
    switch (size) {
      case SoulDeckCardSize.hand:
        return 6;
      case SoulDeckCardSize.reward:
        return 5;
      case SoulDeckCardSize.mini:
        return 4;
    }
  }

  // ── Asset helpers ───────────────────────────────────────────────────────────

  String get _frameAsset {
    switch (card.category) {
      case CardCategory.attack:
        return 'assets/images/cards/card_frame_attack.png';
      case CardCategory.defense:
        return 'assets/images/cards/card_frame_defense.png';
      case CardCategory.magic:
        return 'assets/images/cards/card_frame_magic.png';
      case CardCategory.tactical:
        return 'assets/images/cards/card_frame_tactical.png';
    }
  }

  String get _iconAsset {
    switch (card.category) {
      case CardCategory.attack:
        return 'assets/images/game/cards/icons/icon_attack.png';
      case CardCategory.defense:
        return 'assets/images/game/cards/icons/icon_defense.png';
      case CardCategory.magic:
        return 'assets/images/game/cards/icons/icon_magic.png';
      case CardCategory.tactical:
        return 'assets/images/game/cards/icons/icon_tactical.png';
    }
  }

  // ── Colors ──────────────────────────────────────────────────────────────────

  Color get _accentColor {
    switch (card.category) {
      case CardCategory.attack:
        return const Color(0xFFE53935);
      case CardCategory.magic:
        return const Color(0xFFAB47BC);
      case CardCategory.defense:
        return const Color(0xFF1E88E5);
      case CardCategory.tactical:
        return const Color(0xFF43A047);
    }
  }

  Color get _rarityColor {
    switch (card.rarity) {
      case CardRarity.common:
        return Colors.grey;
      case CardRarity.uncommon:
        return Colors.green;
      case CardRarity.rare:
        return Colors.blue;
      case CardRarity.legendary:
        return Colors.amber;
    }
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cardName = CardLocalization.localizedName(card, l10n);
    final description = CardLocalization.localizedDescription(card, l10n);

    // Full-body mode when a body PNG is registered; legacy otherwise.
    final bodyPath = CardBodyAssets.resolvedBodyPath(card);

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.48,
        duration: const Duration(milliseconds: 160),
        child: SizedBox(
          width: _width,
          height: _height,
          child: bodyPath != null
              ? _buildFullBody(cardName, description, bodyPath, l10n)
              : _buildLegacy(cardName, description, l10n),
        ),
      ),
    );
  }

  // ── Full-body layout ────────────────────────────────────────────────────────
  //
  // Stack layers:
  //   1. Card body image (fills entire card)
  //   2. Top gradient scrim  (behind cost gem + card name)
  //   3. Bottom gradient scrim (behind description + rarity)
  //   4. Positioned top: cost gem + card name
  //   5. Positioned bottom: description + rarity
  //   6. Disabled overlay (conditional)

  Widget _buildFullBody(
    String cardName,
    String description,
    String bodyPath,
    AppLocalizations l10n,
  ) {
    final topScrimH = _headerHeight + _vPad + 12;
    final bottomScrimH = _height * 0.46;

    return Stack(
      children: [
        // ── 1. Card body image ───────────────────────────────────────────────
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              bodyPath,
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) => DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2E),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _accentColor, width: 2),
                ),
              ),
            ),
          ),
        ),

        // ── 2. Top gradient scrim ────────────────────────────────────────────
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: topScrimH,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.72),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // ── 3. Bottom gradient scrim ─────────────────────────────────────────
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: bottomScrimH,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.80),
                ],
              ),
            ),
          ),
        ),

        // ── 4. Top content: cost gem + card name ─────────────────────────────
        Positioned(
          top: _vPad,
          left: _hPad,
          right: _hPad,
          height: _headerHeight,
          child: Row(
            children: [
              _CostGem(
                value: card.cost,
                color: _accentColor,
                dimension: size == SoulDeckCardSize.mini ? 15.0 : 20.0,
                fontSize: size == SoulDeckCardSize.mini ? 9.0 : 11.0,
              ),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  cardName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _nameFontSize,
                    fontWeight: FontWeight.bold,
                    shadows: const [
                      Shadow(color: Colors.black, blurRadius: 4),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        // ── 5. Bottom content: description + rarity ──────────────────────────
        Positioned(
          bottom: _vPad,
          left: _hPad,
          right: _hPad,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.92),
                  fontSize: _descriptionFontSize,
                  height: 1.25,
                  shadows: const [
                    Shadow(color: Colors.black, blurRadius: 3),
                  ],
                ),
                textAlign: TextAlign.center,
                maxLines: _fullBodyDescriptionLines,
                overflow: TextOverflow.ellipsis,
              ),
              if (showRarity && card.rarity != CardRarity.common)
                Text(
                  _rarityLabel(l10n),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _rarityColor,
                    fontSize: size == SoulDeckCardSize.hand ? 9 : 8,
                    fontWeight: FontWeight.w700,
                    shadows: const [
                      Shadow(color: Colors.black, blurRadius: 3),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),

        // ── 6. Disabled overlay ──────────────────────────────────────────────
        if (!enabled)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.36),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
      ],
    );
  }

  // ── Legacy layout (unchanged fallback) ──────────────────────────────────────
  //
  // Stack layers:
  //   1. Frame PNG background
  //   2. Tactical dark overlay (conditional)
  //   3. Column: cost+name / center art (or icon) / description / rarity
  //   4. Disabled overlay (conditional)

  Widget _buildLegacy(
    String cardName,
    String description,
    AppLocalizations l10n,
  ) {
    final artPath = CardArtAssets.artPathFor(card);

    return Stack(
      children: [
        // ── 1. Frame PNG background ──────────────────────────────────────────
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              _frameAsset,
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) => DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2E),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _accentColor, width: 2),
                ),
              ),
            ),
          ),
        ),

        // ── 2. Tactical category overlay ─────────────────────────────────────
        if (card.category == CardCategory.tactical)
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(13),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFF0A1A0E).withValues(alpha: 0.82),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

        // ── 3. Content column ────────────────────────────────────────────────
        Padding(
          padding: EdgeInsets.fromLTRB(_hPad, _vPad, _hPad, _vPad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header row: cost gem + card name
              SizedBox(
                height: _headerHeight,
                child: Row(
                  children: [
                    _CostGem(
                      value: card.cost,
                      color: _accentColor,
                      dimension: size == SoulDeckCardSize.mini ? 15.0 : 20.0,
                      fontSize: size == SoulDeckCardSize.mini ? 9.0 : 11.0,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        cardName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: _nameFontSize,
                          fontWeight: FontWeight.bold,
                          shadows: const [
                            Shadow(color: Colors.black, blurRadius: 3),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size == SoulDeckCardSize.hand ? 4 : 3),

              // Center art: sample art PNG or category icon fallback
              Center(
                child: SizedBox.square(
                  dimension: _iconSize,
                  child: _CardVisual(
                    artPath: artPath,
                    iconAsset: _iconAsset,
                  ),
                ),
              ),
              SizedBox(height: size == SoulDeckCardSize.hand ? 4 : 3),

              // Description
              Expanded(
                child: Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.86),
                    fontSize: _descriptionFontSize,
                    height: 1.25,
                    shadows: const [
                      Shadow(color: Colors.black, blurRadius: 2),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: _descriptionLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Rarity label (common cards omitted)
              if (showRarity && card.rarity != CardRarity.common)
                Text(
                  _rarityLabel(l10n),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _rarityColor,
                    fontSize: size == SoulDeckCardSize.hand ? 9 : 8,
                    fontWeight: FontWeight.w700,
                    shadows: const [
                      Shadow(color: Colors.black, blurRadius: 2),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),

        // ── 4. Disabled overlay ──────────────────────────────────────────────
        if (!enabled)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.36),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
      ],
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  String _rarityLabel(AppLocalizations l10n) {
    switch (card.rarity) {
      case CardRarity.common:
        return '';
      case CardRarity.uncommon:
        return l10n.cardRarityUncommon;
      case CardRarity.rare:
        return l10n.cardRarityRare;
      case CardRarity.legendary:
        return l10n.cardRarityLegendary;
    }
  }
}

// ── Private sub-widgets ──────────────────────────────────────────────────────

/// Renders center art PNG when available, or falls back to the category icon.
/// Used by the legacy layout only; full-body mode embeds art in the background.
class _CardVisual extends StatelessWidget {
  final String? artPath;
  final String iconAsset;

  const _CardVisual({
    required this.artPath,
    required this.iconAsset,
  });

  @override
  Widget build(BuildContext context) {
    final path = artPath;
    if (path == null || path.isEmpty) {
      return _CategoryIcon(iconAsset: iconAsset);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _CategoryIcon(iconAsset: iconAsset),
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  final String iconAsset;

  const _CategoryIcon({required this.iconAsset});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      iconAsset,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
    );
  }
}

/// Circular cost gem displayed in the top-left of every card.
class _CostGem extends StatelessWidget {
  final int value;
  final Color color;
  final double dimension;
  final double fontSize;

  const _CostGem({
    required this.value,
    required this.color,
    this.dimension = 20,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dimension,
      height: dimension,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.56),
            blurRadius: 4,
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$value',
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
