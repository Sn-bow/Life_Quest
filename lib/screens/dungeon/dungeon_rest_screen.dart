import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:life_quest_final_v2/models/card_data.dart';
import 'package:life_quest_final_v2/state/dungeon_state.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/data/card_localization.dart';

class DungeonRestScreen extends StatefulWidget {
  const DungeonRestScreen({super.key});

  @override
  State<DungeonRestScreen> createState() => _DungeonRestScreenState();
}

class _DungeonRestScreenState extends State<DungeonRestScreen> {
  bool _choiceMade = false;
  String _choiceResult = '';
  bool _showCardSelection = false;
  CardData? _upgradedCard; // stores the original card before upgrade for l10n display

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? const Color(0xFF00FFFF) : Colors.deepPurple;
    final dungeonState = context.watch<DungeonState>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.local_fire_department, color: accent, size: 22),
            const SizedBox(width: 8),
            Text(
              l10n.dungeonRestTitle,
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                color: accent,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Atmospheric description
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1D1E33)
                    : Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: accent.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.nights_stay,
                    size: 48,
                    color: isDark
                        ? Colors.amber.shade300
                        : Colors.deepPurple.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.dungeonRestDescription,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      height: 1.6,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // HP display
            _HpDisplay(dungeonState: dungeonState, isDark: isDark),

            const SizedBox(height: 24),

            if (_showCardSelection) ...[
              // Card upgrade selection
              _CardSelectionGrid(
                deck: dungeonState.currentDeck,
                isDark: isDark,
                accent: accent,
                onCardSelected: (index, card) {
                  dungeonState.upgradeCard(index);
                  setState(() {
                    _showCardSelection = false;
                    _choiceMade = true;
                    _upgradedCard = card; // original card before upgrade
                  });
                },
                onCancel: () {
                  setState(() {
                    _showCardSelection = false;
                  });
                },
              ),
            ] else if (!_choiceMade) ...[
              // Choice buttons
              _RestChoiceButton(
                icon: Icons.hotel,
                title: l10n.dungeonRestRestTitle,
                description: l10n.dungeonRestRestDescription,
                color: Colors.green,
                isDark: isDark,
                onTap: () {
                  // relic_b03: 부활의 성배 — 휴식 노드 HP 완전 회복
                  final hasGrail = dungeonState.currentRelics
                      .any((r) => r.id == 'relic_b03');
                  final int healAmount;
                  if (hasGrail) {
                    healAmount = dungeonState.playerMaxHp - dungeonState.playerHp;
                    dungeonState.healPlayer(healAmount);
                  } else {
                    healAmount = (dungeonState.playerMaxHp * 0.3).round();
                    dungeonState.healPlayerPercent(0.3);
                  }
                  setState(() {
                    _choiceMade = true;
                    _choiceResult = l10n.dungeonRestHealResult(healAmount);
                  });
                },
              ),
              const SizedBox(height: 12),
              _RestChoiceButton(
                icon: Icons.fitness_center,
                title: l10n.dungeonRestTrainTitle,
                description: l10n.dungeonRestTrainDescription,
                color: Colors.orange,
                isDark: isDark,
                onTap: () {
                  if (dungeonState.currentDeck.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.dungeonRestNoCardsToUpgrade,
                            style: const TextStyle(fontFamily: 'monospace')),
                      ),
                    );
                    return;
                  }
                  setState(() {
                    _showCardSelection = true;
                  });
                },
              ),
            ] else ...[
              // Result display
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.green.withValues(alpha: 0.15)
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _upgradedCard != null
                            ? l10n.dungeonRestCardUpgradeResult(
                                CardLocalization.localizedName(_upgradedCard!, l10n))
                            : _choiceResult,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const Spacer(),

            // Continue button
            if (_choiceMade)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n.dungeonRestContinueButton,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
// HP display
// ============================================================================

class _HpDisplay extends StatelessWidget {
  final DungeonState dungeonState;
  final bool isDark;

  const _HpDisplay({required this.dungeonState, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final ratio = dungeonState.playerMaxHp > 0
        ? (dungeonState.playerHp / dungeonState.playerMaxHp).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.black26 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.favorite, size: 18, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${dungeonState.playerHp} / ${dungeonState.playerMaxHp}',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: ratio,
                    minHeight: 8,
                    backgroundColor:
                        isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation(
                      ratio > 0.5
                          ? Colors.green
                          : ratio > 0.25
                              ? Colors.orange
                              : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Rest choice button
// ============================================================================

class _RestChoiceButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _RestChoiceButton({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark
              ? color.withValues(alpha: 0.12)
              : color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withValues(alpha: 0.4),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? 0.3 : 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color, size: 24),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Card selection grid (for upgrade)
// ============================================================================

class _CardSelectionGrid extends StatelessWidget {
  final List<CardData> deck;
  final bool isDark;
  final Color accent;
  final Function(int, CardData) onCardSelected;
  final VoidCallback onCancel;

  const _CardSelectionGrid({
    required this.deck,
    required this.isDark,
    required this.accent,
    required this.onCardSelected,
    required this.onCancel,
  });


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.dungeonRestSelectCardToUpgrade,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              TextButton(
                onPressed: onCancel,
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
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: deck.length,
              itemBuilder: (context, index) {
                final card = deck[index];
                return _UpgradeCardWidget(
                  card: card,
                  isDark: isDark,
                  onTap: () => onCardSelected(index, card),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Upgrade card widget
// ============================================================================

class _UpgradeCardWidget extends StatelessWidget {
  final CardData card;
  final bool isDark;
  final VoidCallback onTap;

  const _UpgradeCardWidget({
    required this.card,
    required this.isDark,
    required this.onTap,
  });

  Color get _borderColor {
    switch (card.category) {
      case CardCategory.attack:
        return Colors.red.shade400;
      case CardCategory.magic:
        return Colors.purple.shade400;
      case CardCategory.defense:
        return Colors.blue.shade400;
      case CardCategory.tactical:
        return Colors.amber.shade400;
    }
  }

  Color get _headerColor {
    switch (card.category) {
      case CardCategory.attack:
        return Colors.red.shade800;
      case CardCategory.magic:
        return Colors.purple.shade800;
      case CardCategory.defense:
        return Colors.blue.shade800;
      case CardCategory.tactical:
        return Colors.amber.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E2E) : const Color(0xFFF5F5F0),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _borderColor, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: _headerColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(6)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amber.shade600,
                    ),
                    child: Center(
                      child: Text(
                        '${card.cost}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      CardLocalization.localizedName(card, l10n),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            // Description
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  CardLocalization.localizedDescription(card, l10n),
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                    fontSize: 12,
                    height: 1.4,
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            // Upgrade indicator
            if (card.isUpgraded)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                color: Colors.green.withValues(alpha: 0.2),
                child: Center(
                  child: Text(
                    l10n.dungeonRestCardUpgraded,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
