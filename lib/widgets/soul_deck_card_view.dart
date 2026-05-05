import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/data/card_art_assets.dart';
import 'package:life_quest_final_v2/data/card_localization.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/models/card_data.dart';

enum SoulDeckCardSize {
  hand,
  reward,
  mini,
}

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cardName = CardLocalization.localizedName(card, l10n);
    final description = CardLocalization.localizedDescription(card, l10n);
    final artPath = CardArtAssets.artPathFor(card);

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.48,
        duration: const Duration(milliseconds: 160),
        child: SizedBox(
          width: _width,
          height: _height,
          child: Stack(
            children: [
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
              Padding(
                padding: EdgeInsets.fromLTRB(
                  size == SoulDeckCardSize.hand
                      ? 8
                      : (size == SoulDeckCardSize.reward ? 7 : 5),
                  5,
                  size == SoulDeckCardSize.hand
                      ? 8
                      : (size == SoulDeckCardSize.reward ? 7 : 5),
                  5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: size == SoulDeckCardSize.hand
                          ? 22
                          : (size == SoulDeckCardSize.reward ? 20 : 17),
                      child: Row(
                        children: [
                          _CostGem(
                            value: card.cost,
                            color: _accentColor,
                            dimension:
                                size == SoulDeckCardSize.mini ? 15.0 : 20.0,
                            fontSize:
                                size == SoulDeckCardSize.mini ? 9.0 : 11.0,
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
          ),
        ),
      ),
    );
  }

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
