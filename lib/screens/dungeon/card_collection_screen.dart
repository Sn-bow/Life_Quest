import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/data/card_database.dart';
import 'package:life_quest_final_v2/models/card_data.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';

class CardCollectionScreen extends StatefulWidget {
  const CardCollectionScreen({super.key});

  @override
  State<CardCollectionScreen> createState() => _CardCollectionScreenState();
}

class _CardCollectionScreenState extends State<CardCollectionScreen> {
  CardCategory? _selectedFilter; // null = All
  bool _isDeckExpanded = true;

  static const Color _attackColor = Color(0xFFE53935);
  static const Color _magicColor = Color(0xFF8E24AA);
  static const Color _defenseColor = Color(0xFF1E88E5);
  static const Color _tacticalColor = Color(0xFF43A047);
  static const Color _commonColor = Color(0xFF9E9E9E);
  static const Color _uncommonColor = Color(0xFF4CAF50);
  static const Color _rareColor = Color(0xFF2196F3);
  static const Color _legendaryColor = Color(0xFFFF9800);

  Color _categoryColor(CardCategory cat) {
    switch (cat) {
      case CardCategory.attack:
        return _attackColor;
      case CardCategory.magic:
        return _magicColor;
      case CardCategory.defense:
        return _defenseColor;
      case CardCategory.tactical:
        return _tacticalColor;
    }
  }

  Color _rarityColor(CardRarity r) {
    switch (r) {
      case CardRarity.common:
        return _commonColor;
      case CardRarity.uncommon:
        return _uncommonColor;
      case CardRarity.rare:
        return _rareColor;
      case CardRarity.legendary:
        return _legendaryColor;
    }
  }

  String _rarityLabel(BuildContext context, CardRarity r) {
    final l10n = AppLocalizations.of(context)!;
    switch (r) {
      case CardRarity.common:
        return l10n.cardRarityCommon;
      case CardRarity.uncommon:
        return l10n.cardRarityUncommon;
      case CardRarity.rare:
        return l10n.cardRarityRare;
      case CardRarity.legendary:
        return l10n.cardRarityLegendary;
    }
  }

  String _categoryLabel(BuildContext context, CardCategory cat) {
    final l10n = AppLocalizations.of(context)!;
    switch (cat) {
      case CardCategory.attack:
        return l10n.cardCategoryAttack;
      case CardCategory.magic:
        return l10n.cardCategoryMagic;
      case CardCategory.defense:
        return l10n.cardCategoryDefense;
      case CardCategory.tactical:
        return l10n.cardCategoryTactical;
    }
  }

  List<CardData> _filteredCards(List<CardData> cards) {
    List<CardData> result =
        _selectedFilter == null ? cards : cards.where((c) => c.category == _selectedFilter).toList();

    // Sort: category order then rarity order (common → legendary)
    result.sort((a, b) {
      final catOrder = a.category.index.compareTo(b.category.index);
      if (catOrder != 0) return catOrder;
      return a.rarity.index.compareTo(b.rarity.index);
    });

    return result;
  }

  void _showCardDetail(BuildContext context, CardData card, CharacterState state) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final catColor = _categoryColor(card.category);
    final rarityColor = _rarityColor(card.rarity);
    final deck = state.character.starterDeckCardIds;
    final copyCount = deck.where((id) => id == card.id).length;
    final canAdd = deck.length < 20 && copyCount < 3;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1D1E33) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _costBadge(card.cost, isDark),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: catColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: catColor.withValues(alpha: 0.5)),
                              ),
                              child: Text(
                                _categoryLabel(context, card.category),
                                style: TextStyle(fontSize: 11, color: catColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: rarityColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: rarityColor.withValues(alpha: 0.5)),
                              ),
                              child: Text(
                                _rarityLabel(context, card.rarity),
                                style: TextStyle(fontSize: 11, color: rarityColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                card.description,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              if (copyCount > 0)
                Text(
                  l10n.cardCollectionDeckInclusion(copyCount),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.black38,
                  ),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: canAdd
                      ? () {
                          state.addCardToStarterDeck(card.id);
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.cardCollectionAddedToDeck(card.name)),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.add),
                  label: Text(
                    canAdd
                        ? l10n.cardCollectionAddToDeck
                        : deck.length >= 20
                            ? l10n.cardCollectionDeckFull
                            : l10n.cardCollectionMaxCopies,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: catColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _costBadge(int cost, bool isDark) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF00FFFF).withValues(alpha: 0.2) : Colors.deepPurple.shade100,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF00FFFF) : Colors.deepPurple,
        ),
      ),
      child: Center(
        child: Text(
          '$cost',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDark ? const Color(0xFF00FFFF) : Colors.deepPurple,
          ),
        ),
      ),
    );
  }

  Widget _cardGridItem(BuildContext context, CardData card, CharacterState state, bool isDark) {
    final catColor = _categoryColor(card.category);
    final rarityColor = _rarityColor(card.rarity);

    return GestureDetector(
      onTap: () => _showCardDetail(context, card, state),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? catColor.withValues(alpha: 0.1) : catColor.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: catColor.withValues(alpha: 0.4), width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _costBadge(card.cost, isDark),
                  const Spacer(),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: rarityColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  card.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: catColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _categoryLabel(context, card.category),
                  style: TextStyle(fontSize: 9, color: catColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = context.watch<CharacterState>();
    final unlockedCards = _filteredCards(state.unlockedCards);
    final deckCardIds = state.character.starterDeckCardIds;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cardCollectionTitle),
        backgroundColor: isDark ? const Color(0xFF0A0E21) : null,
      ),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _filterChip(context, null, l10n.cardCollectionFilterAll, isDark),
                  const SizedBox(width: 8),
                  _filterChip(context, CardCategory.attack, l10n.cardCategoryAttack, isDark),
                  const SizedBox(width: 8),
                  _filterChip(context, CardCategory.magic, l10n.cardCategoryMagic, isDark),
                  const SizedBox(width: 8),
                  _filterChip(context, CardCategory.defense, l10n.cardCategoryDefense, isDark),
                  const SizedBox(width: 8),
                  _filterChip(context, CardCategory.tactical, l10n.cardCategoryTactical, isDark),
                ],
              ),
            ),
          ),

          // Section header: 내 컬렉션
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  l10n.cardCollectionMyCollection,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.cardCollectionCardCount(state.unlockedCards.length),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.black38,
                  ),
                ),
              ],
            ),
          ),

          // Card grid
          Expanded(
            child: unlockedCards.isEmpty
                ? Center(
                    child: Text(
                      l10n.cardCollectionNoCards,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDark ? Colors.white38 : Colors.grey.shade500,
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: unlockedCards.length,
                    itemBuilder: (context, index) {
                      return _cardGridItem(context, unlockedCards[index], state, isDark);
                    },
                  ),
          ),

          // Deck section (collapsible)
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1D1E33) : Colors.grey.shade100,
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.white12 : Colors.grey.shade300,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Deck header (tap to expand/collapse)
                InkWell(
                  onTap: () => setState(() => _isDeckExpanded = !_isDeckExpanded),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.style,
                          size: 18,
                          color: isDark ? const Color(0xFF00FFFF) : Colors.deepPurple,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.cardCollectionMyDeck,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.cardCollectionDeckSize(deckCardIds.length),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white54 : Colors.black38,
                          ),
                        ),
                        const Spacer(),
                        if (deckCardIds.isNotEmpty)
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) {
                                  final dl10n = AppLocalizations.of(context)!;
                                  return AlertDialog(
                                    title: Text(dl10n.cardCollectionResetDeckDialog),
                                    content: Text(dl10n.cardCollectionResetDeckConfirmation),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: Text(dl10n.cancel),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          state.resetStarterDeck();
                                          Navigator.pop(ctx);
                                        },
                                        child: Text(dl10n.cardCollectionResetButton, style: const TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(l10n.cardCollectionResetButton, style: const TextStyle(fontSize: 12)),
                          ),
                        const SizedBox(width: 4),
                        Icon(
                          _isDeckExpanded ? Icons.expand_more : Icons.expand_less,
                          color: isDark ? Colors.white54 : Colors.black38,
                        ),
                      ],
                    ),
                  ),
                ),

                // Deck list
                if (_isDeckExpanded)
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: deckCardIds.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              l10n.cardCollectionDefaultDeckMessage,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.white38 : Colors.grey.shade500,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(bottom: 8),
                            itemCount: deckCardIds.length,
                            itemBuilder: (context, index) {
                              final cardId = deckCardIds[index];
                              final card = CardDatabase.getCard(cardId);
                              if (card == null) return const SizedBox.shrink();
                              final catColor = _categoryColor(card.category);
                              return ListTile(
                                dense: true,
                                leading: _costBadge(card.cost, isDark),
                                title: Text(
                                  card.name,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  _categoryLabel(context, card.category),
                                  style: TextStyle(fontSize: 11, color: catColor),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, size: 20),
                                  color: Colors.red.shade400,
                                  onPressed: () => state.removeCardFromStarterDeck(index),
                                ),
                              );
                            },
                          ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(BuildContext context, CardCategory? category, String label, bool isDark) {
    final isSelected = _selectedFilter == category;
    final color = category == null
        ? (isDark ? const Color(0xFF00FFFF) : Colors.deepPurple)
        : _categoryColor(category);

    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : (isDark ? Colors.white24 : Colors.grey.shade400),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? color : (isDark ? Colors.white60 : Colors.black54),
          ),
        ),
      ),
    );
  }
}
