import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:life_quest_final_v2/models/card_data.dart';
import 'package:life_quest_final_v2/models/relic_data.dart';
import 'package:life_quest_final_v2/state/dungeon_state.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/data/card_localization.dart';
import 'package:life_quest_final_v2/widgets/relic_icon.dart';
import 'package:life_quest_final_v2/widgets/soul_deck_card_view.dart';

class DungeonShopScreen extends StatefulWidget {
  const DungeonShopScreen({super.key});

  @override
  State<DungeonShopScreen> createState() => _DungeonShopScreenState();
}

class _DungeonShopScreenState extends State<DungeonShopScreen> {
  final Set<int> _purchasedCardIndices = {};
  final Set<int> _purchasedRelicIndices = {};
  int _cardRemovalCount = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? const Color(0xFF00FFFF) : Colors.deepPurple;
    final dungeonState = context.watch<DungeonState>();
    final shopCards = dungeonState.shopCards;
    final shopRelics = dungeonState.shopRelics;
    final removalCost = 50 + (_cardRemovalCount * 25);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.storefront, color: accent, size: 22),
            const SizedBox(width: 8),
            Text(
              l10n.dungeonShopTitle,
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                color: accent,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          // Gold display
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.monetization_on,
                    size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  '${dungeonState.dungeonGold}',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Cards
            _sectionTitle(l10n.dungeonShopCardsSection, Icons.style, accent, isDark),
            const SizedBox(height: 8),
            if (shopCards.isEmpty)
              _emptySection(l10n.dungeonShopNoCards, isDark)
            else
              ...shopCards.asMap().entries.map((entry) {
                final index = entry.key;
                final card = entry.value;
                final price = _cardPrice(card.rarity);
                final purchased = _purchasedCardIndices.contains(index);

                return _CardShopItem(
                  card: card,
                  price: price,
                  isPurchased: purchased,
                  canAfford: dungeonState.dungeonGold >= price,
                  isDark: isDark,
                  onBuy: () => _buyCard(card, price, index, dungeonState),
                );
              }),

            const SizedBox(height: 24),

            // Section 2: Relics
            _sectionTitle(l10n.dungeonShopRelicsSection, Icons.diamond, accent, isDark),
            const SizedBox(height: 8),
            if (shopRelics.isEmpty)
              _emptySection(l10n.dungeonShopNoRelics, isDark)
            else
              ...shopRelics.asMap().entries.map((entry) {
                final index = entry.key;
                final relic = entry.value;
                final price = _relicPrice(relic.rarity);
                final purchased = _purchasedRelicIndices.contains(index);

                return _RelicShopItem(
                  relic: relic,
                  price: price,
                  isPurchased: purchased,
                  canAfford: dungeonState.dungeonGold >= price,
                  isDark: isDark,
                  onBuy: () => _buyRelic(relic, price, index, dungeonState),
                );
              }),

            const SizedBox(height: 24),

            // Section 3: Card removal
            _sectionTitle(l10n.dungeonShopCardRemovalSection, Icons.delete_sweep, accent, isDark),
            const SizedBox(height: 8),
            _CardRemovalItem(
              cost: removalCost,
              canAfford: dungeonState.dungeonGold >= removalCost,
              deckSize: dungeonState.currentDeck.length,
              isDark: isDark,
              onTap: () => _showCardRemovalDialog(
                  context, dungeonState, removalCost, isDark, accent),
            ),

            const SizedBox(height: 32),

            // Leave shop button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.exit_to_app),
                label: Text(
                  l10n.dungeonShopLeaveButton,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  int _cardPrice(CardRarity rarity) {
    switch (rarity) {
      case CardRarity.common:
        return 30;
      case CardRarity.uncommon:
        return 60;
      case CardRarity.rare:
        return 120;
      case CardRarity.legendary:
        return 200;
    }
  }

  int _relicPrice(RelicRarity rarity) {
    switch (rarity) {
      case RelicRarity.common:
        return 100;
      case RelicRarity.uncommon:
        return 150;
      case RelicRarity.rare:
        return 200;
      default:
        return 150;
    }
  }

  void _buyCard(
      CardData card, int price, int index, DungeonState dungeonState) {
    if (dungeonState.dungeonGold < price) return;
    dungeonState.spendGold(price);
    dungeonState.addCardToDeck(card);
    setState(() {
      _purchasedCardIndices.add(index);
    });
  }

  void _buyRelic(
      RelicData relic, int price, int index, DungeonState dungeonState) {
    if (dungeonState.dungeonGold < price) return;
    dungeonState.spendGold(price);
    dungeonState.addRelic(relic);
    setState(() {
      _purchasedRelicIndices.add(index);
    });
  }

  void _showCardRemovalDialog(BuildContext context, DungeonState dungeonState,
      int cost, bool isDark, Color accent) {
    if (dungeonState.dungeonGold < cost) return;
    if (dungeonState.currentDeck.isEmpty) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1D1E33) : Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx)!;
        final deck = dungeonState.currentDeck;
        return Container(
          padding: const EdgeInsets.all(16),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.dungeonShopSelectCardToRemove,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                l10n.dungeonShopRemovalCost(cost),
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  color: Colors.amber.shade600,
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: deck.length,
                  itemBuilder: (context, index) {
                    final card = deck[index];
                    return GestureDetector(
                      onTap: () {
                        dungeonState.spendGold(cost);
                        dungeonState.removeCardFromDeck(index);
                        setState(() {
                          _cardRemovalCount++;
                        });
                        Navigator.of(ctx).pop();
                      },
                      child: _MiniCardWidget(
                          card: card, isDark: isDark),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(
                  '취소',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: isDark ? Colors.white60 : Colors.black45,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionTitle(
      String title, IconData icon, Color accent, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 18, color: accent),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _emptySection(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            color: isDark ? Colors.white38 : Colors.black26,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Card shop item
// ============================================================================

class _CardShopItem extends StatelessWidget {
  final CardData card;
  final int price;
  final bool isPurchased;
  final bool canAfford;
  final bool isDark;
  final VoidCallback onBuy;

  const _CardShopItem({
    required this.card,
    required this.price,
    required this.isPurchased,
    required this.canAfford,
    required this.isDark,
    required this.onBuy,
  });

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

  Color get _categoryColor {
    switch (card.category) {
      case CardCategory.attack:
        return Colors.red;
      case CardCategory.magic:
        return Colors.purple;
      case CardCategory.defense:
        return Colors.blue;
      case CardCategory.tactical:
        return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Opacity(
      opacity: isPurchased ? 0.4 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark
              ? _categoryColor.withValues(alpha: 0.1)
              : _categoryColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _rarityColor.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Card frame mini preview
            SizedBox(
              width: 72,
              height: 108,
              child: SoulDeckCardView(
                card: card,
                size: SoulDeckCardSize.mini,
                enabled: !isPurchased,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CardLocalization.localizedName(card, l10n),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    CardLocalization.localizedDescription(card, l10n),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Price / buy button
            isPurchased
                ? Text(
                    l10n.dungeonShopPurchaseComplete,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: isDark ? Colors.white38 : Colors.black26,
                    ),
                  )
                : GestureDetector(
                    onTap: canAfford ? onBuy : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: canAfford
                            ? Colors.amber.withValues(alpha: 0.2)
                            : Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: canAfford
                              ? Colors.amber.withValues(alpha: 0.5)
                              : Colors.grey.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            size: 14,
                            color:
                                canAfford ? Colors.amber : Colors.grey,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '$price',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: canAfford
                                  ? Colors.amber
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Relic shop item
// ============================================================================

class _RelicShopItem extends StatelessWidget {
  final RelicData relic;
  final int price;
  final bool isPurchased;
  final bool canAfford;
  final bool isDark;
  final VoidCallback onBuy;

  const _RelicShopItem({
    required this.relic,
    required this.price,
    required this.isPurchased,
    required this.canAfford,
    required this.isDark,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Opacity(
      opacity: isPurchased ? 0.4 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.purple.withValues(alpha: 0.1)
              : Colors.purple.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.purple.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            RelicIcon(relic: relic, size: 44),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    relic.name,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    relic.description,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            isPurchased
                ? Text(
                    l10n.dungeonShopPurchaseComplete,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: isDark ? Colors.white38 : Colors.black26,
                    ),
                  )
                : GestureDetector(
                    onTap: canAfford ? onBuy : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: canAfford
                            ? Colors.amber.withValues(alpha: 0.2)
                            : Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: canAfford
                              ? Colors.amber.withValues(alpha: 0.5)
                              : Colors.grey.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            size: 14,
                            color: canAfford ? Colors.amber : Colors.grey,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '$price',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: canAfford ? Colors.amber : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Card removal item
// ============================================================================

class _CardRemovalItem extends StatelessWidget {
  final int cost;
  final bool canAfford;
  final int deckSize;
  final bool isDark;
  final VoidCallback onTap;

  const _CardRemovalItem({
    required this.cost,
    required this.canAfford,
    required this.deckSize,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: canAfford && deckSize > 0 ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.orange.withValues(alpha: 0.1)
              : Colors.orange.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.orange.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: isDark ? 0.3 : 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.delete_sweep,
                  color: Colors.orange, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.dungeonShopRemoveOneCard,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.dungeonShopRemovalDescription(deckSize),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: canAfford
                    ? Colors.amber.withValues(alpha: 0.2)
                    : Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: canAfford
                      ? Colors.amber.withValues(alpha: 0.5)
                      : Colors.grey.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.monetization_on,
                    size: 14,
                    color: canAfford ? Colors.amber : Colors.grey,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '$cost',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: canAfford ? Colors.amber : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Mini card widget (for card removal dialog)
// ============================================================================

class _MiniCardWidget extends StatelessWidget {
  final CardData card;
  final bool isDark;

  const _MiniCardWidget({required this.card, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: SoulDeckCardView(
        card: card,
        size: SoulDeckCardSize.mini,
      ),
    );
  }
}
