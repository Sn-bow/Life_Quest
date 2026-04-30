import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:life_quest_final_v2/data/card_database.dart';
import 'package:life_quest_final_v2/data/card_localization.dart';
import 'package:life_quest_final_v2/data/relic_database.dart';
import 'package:life_quest_final_v2/models/card_data.dart';
import 'package:life_quest_final_v2/models/dungeon_event.dart';
import 'package:life_quest_final_v2/state/dungeon_state.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';

class DungeonEventScreen extends StatefulWidget {
  const DungeonEventScreen({super.key});

  @override
  State<DungeonEventScreen> createState() => _DungeonEventScreenState();
}

class _DungeonEventScreenState extends State<DungeonEventScreen> {
  EventOutcome? _selectedOutcome;
  bool _choiceMade = false;

  // Card reward pick phase (after choice)
  List<CardData> _cardRewardChoices = [];
  bool _cardPickRequired = false;
  bool _cardPicked = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? const Color(0xFF00FFFF) : Colors.deepPurple;
    final dungeonState = context.watch<DungeonState>();
    final event = dungeonState.currentEvent;

    if (event == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.dungeonEventTitle, style: TextStyle(color: accent))),
        body: Center(child: Text(l10n.dungeonEventNoData)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.auto_stories, color: accent, size: 22),
            const SizedBox(width: 8),
            Text(
              l10n.dungeonEventTitle,
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
            // Event title
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1D1E33)
                    : Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: accent.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    event.description,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      height: 1.6,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Choices or outcome
            if (!_choiceMade) ...[
              Text(
                l10n.dungeonEventChooseAction,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white60 : Colors.black45,
                ),
              ),
              const SizedBox(height: 12),
              ...event.choices.asMap().entries.map((entry) {
                final index = entry.key;
                final choice = entry.value;
                // Determine if player can afford the gold cost
                final goldCost = choice.outcomes
                    .where((o) => o.goldChange < 0)
                    .fold<int>(0, (max, o) => (-o.goldChange) > max ? (-o.goldChange) : max);
                final canAfford = goldCost == 0 || dungeonState.dungeonGold >= goldCost;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ChoiceButton(
                    choice: choice,
                    index: index,
                    isDark: isDark,
                    accent: accent,
                    canAfford: canAfford,
                    onTap: canAfford ? () => _makeChoice(choice, dungeonState) : null,
                  ),
                );
              }),
            ] else ...[
              // Outcome display
              _OutcomeCard(
                outcome: _selectedOutcome!,
                isDark: isDark,
                accent: accent,
              ),

              // Card reward pick UI (shown if outcome has cardReward)
              if (_cardPickRequired && !_cardPicked) ...[
                const SizedBox(height: 16),
                Text(
                  l10n.dungeonEventCardRewardTitle,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _cardRewardChoices.map((card) {
                    return GestureDetector(
                      onTap: () {
                        final dungeonState = context.read<DungeonState>();
                        dungeonState.addCardToDeck(card);
                        setState(() => _cardPicked = true);
                      },
                      child: Container(
                        width: 90,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark
                              ? accent.withValues(alpha: 0.1)
                              : accent.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: accent.withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${card.cost}',
                              style: TextStyle(
                                color: Colors.amber.shade400,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              CardLocalization.localizedName(card, l10n),
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              CardLocalization.localizedDescription(card, l10n),
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 9,
                                color: isDark ? Colors.white54 : Colors.black45,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],

            const Spacer(),

            // Continue button (only after choice, and after card pick if required)
            if (_choiceMade && (!_cardPickRequired || _cardPicked))
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
                    l10n.dungeonEventContinueButton,
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

  void _makeChoice(EventChoice choice, DungeonState dungeonState) {
    // Pick a random outcome from the choice
    final rng = Random();
    final outcome = choice.outcomes[rng.nextInt(choice.outcomes.length)];

    // ── Gold / HP ──
    if (outcome.goldChange != 0) {
      if (outcome.goldChange > 0) {
        dungeonState.addGold(outcome.goldChange);
      } else {
        dungeonState.spendGold(-outcome.goldChange);
      }
    }
    if (outcome.hpChange != 0) {
      if (outcome.hpChange > 0) {
        dungeonState.healPlayer(outcome.hpChange);
      } else {
        dungeonState.damagePlayer(-outcome.hpChange);
      }
    }
    if (outcome.hpPercentChange != 0) {
      if (outcome.hpPercentChange > 0) {
        dungeonState.healPlayerPercent(outcome.hpPercentChange);
      } else {
        final dmg = (dungeonState.playerMaxHp * (-outcome.hpPercentChange)).round();
        dungeonState.damagePlayer(dmg);
      }
    }

    // ── Relic reward: add a random relic the player doesn't already own ──
    if (outcome.relicReward) {
      final all = RelicDatabase.allRelics.toList()..shuffle(rng);
      final available = all.where(
        (r) => !dungeonState.currentRelics.any((cr) => cr.id == r.id),
      ).toList();
      if (available.isNotEmpty) {
        dungeonState.addRelic(available.first);
      }
    }

    // ── Card upgrade: upgrade a random non-upgraded card in the deck ──
    if (outcome.cardUpgrade) {
      final nonUpgraded = dungeonState.currentDeck
          .asMap()
          .entries
          .where((e) => !e.value.isUpgraded)
          .toList();
      if (nonUpgraded.isNotEmpty) {
        final entry = nonUpgraded[rng.nextInt(nonUpgraded.length)];
        dungeonState.upgradeCard(entry.key);
      }
    }

    // ── Card removal: remove a random card from the deck ──
    if (outcome.cardRemove) {
      if (dungeonState.currentDeck.isNotEmpty) {
        final idx = rng.nextInt(dungeonState.currentDeck.length);
        dungeonState.removeCardFromDeck(idx);
      }
    }

    // ── Curse added: add a random curse card to the deck ──
    if (outcome.curseAdded) {
      final curses = CardDatabase.curseCards.toList()..shuffle(rng);
      if (curses.isNotEmpty) {
        dungeonState.addCardToDeck(curses.first);
      }
    }

    // ── Card reward: prepare 3 card choices for player to pick from ──
    List<CardData> cardChoices = [];
    bool needsCardPick = false;
    if (outcome.cardReward) {
      final pool = CardDatabase.allCards
          .where((c) =>
              c.rarity != CardRarity.common &&
              !c.id.startsWith('curse_') &&
              !c.isUpgraded)
          .toList()
        ..shuffle(rng);
      cardChoices = pool.take(3).toList();
      needsCardPick = cardChoices.isNotEmpty;
    }

    setState(() {
      _selectedOutcome = outcome;
      _choiceMade = true;
      _cardRewardChoices = cardChoices;
      _cardPickRequired = needsCardPick;
      _cardPicked = false;
    });
  }
}

// ============================================================================
// Choice button
// ============================================================================

class _ChoiceButton extends StatelessWidget {
  final EventChoice choice;
  final int index;
  final bool isDark;
  final Color accent;
  final bool canAfford;
  final VoidCallback? onTap;

  const _ChoiceButton({
    required this.choice,
    required this.index,
    required this.isDark,
    required this.accent,
    required this.canAfford,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Check if any outcome has gold cost
    final hasGoldCost = choice.outcomes.any((o) => o.goldChange < 0);
    final goldCost = hasGoldCost
        ? choice.outcomes
            .where((o) => o.goldChange < 0)
            .map((o) => -o.goldChange)
            .first
        : 0;

    return Opacity(
      opacity: canAfford ? 1.0 : 0.45,
      child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: canAfford
              ? (isDark
                  ? accent.withValues(alpha: 0.1)
                  : accent.withValues(alpha: 0.05))
              : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: canAfford
                ? accent.withValues(alpha: 0.4)
                : Colors.grey.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: accent,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                choice.text,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            if (hasGoldCost)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.monetization_on,
                        size: 14, color: Colors.amber),
                    const SizedBox(width: 3),
                    Text(
                      '$goldCost',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      ), // closes Opacity
    );
  }
}

// ============================================================================
// Outcome card
// ============================================================================

class _OutcomeCard extends StatelessWidget {
  final EventOutcome outcome;
  final bool isDark;
  final Color accent;

  const _OutcomeCard({
    required this.outcome,
    required this.isDark,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.amber.withValues(alpha: 0.1)
            : Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, size: 20, color: Colors.amber),
              const SizedBox(width: 8),
              Text(
                l10n.dungeonEventOutcomeTitle,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.amber : Colors.amber.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            outcome.description,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
              height: 1.5,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 12),

          // Effect summary
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (outcome.goldChange != 0)
                _effectChip(
                  outcome.goldChange > 0 ? Icons.add : Icons.remove,
                  '${outcome.goldChange.abs()} 골드',
                  outcome.goldChange > 0 ? Colors.amber : Colors.red,
                ),
              if (outcome.hpChange != 0)
                _effectChip(
                  outcome.hpChange > 0 ? Icons.healing : Icons.heart_broken,
                  '${outcome.hpChange.abs()} HP',
                  outcome.hpChange > 0 ? Colors.green : Colors.red,
                ),
              if (outcome.hpPercentChange != 0)
                _effectChip(
                  outcome.hpPercentChange > 0
                      ? Icons.healing
                      : Icons.heart_broken,
                  '${(outcome.hpPercentChange * 100).toInt()}% HP',
                  outcome.hpPercentChange > 0 ? Colors.green : Colors.red,
                ),
              if (outcome.cardReward)
                _effectChip(Icons.style, l10n.dungeonEventEffectCardReward, Colors.blue),
              if (outcome.relicReward)
                _effectChip(Icons.diamond, l10n.dungeonEventEffectRelicReward, Colors.purple),
              if (outcome.cardRemove)
                _effectChip(Icons.delete_outline, l10n.dungeonEventEffectCardRemove, Colors.orange),
              if (outcome.cardUpgrade)
                _effectChip(Icons.upgrade, l10n.dungeonEventEffectCardUpgrade, Colors.teal),
              if (outcome.curseAdded)
                _effectChip(Icons.warning, l10n.dungeonEventEffectCurseAdded, Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _effectChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
