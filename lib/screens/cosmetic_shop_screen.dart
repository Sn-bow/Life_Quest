import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/models/cosmetic.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/widgets/translucent_card.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CosmeticShopScreen extends StatelessWidget {
  const CosmeticShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cosmeticShopTitle),
      ),
      body: Consumer<CharacterState>(builder: (context, characterState, child) {
        if (!characterState.isDataLoaded) {
          return const Center(child: CircularProgressIndicator());
        }
        final character = characterState.character;

        final categories = {
          CosmeticCategory.theme: l10n.cosmeticCategoryTheme,
          CosmeticCategory.titleEffect: l10n.cosmeticCategoryTitleEffect,
          CosmeticCategory.combatEffect: l10n.cosmeticCategoryCombatEffect,
        };

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TranslucentCard(
              child: ListTile(
                leading: const Icon(Icons.auto_awesome, color: Colors.amber),
                title: Text(l10n.cosmeticComingSoonTitle),
                subtitle: Text(l10n.cosmeticComingSoonDesc),
              ),
            ),
            const SizedBox(height: 16),
            ...categories.entries.map((entry) {
              final category = entry.key;
              final title = entry.value;
              final items = CosmeticDatabase.items
                  .where((e) => e.category == category)
                  .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...items.map((item) => _buildCosmeticCard(
                      context, item, character, characterState)),
                  const SizedBox(height: 16),
                ],
              );
            }),
          ],
        );
      }),
    );
  }

  Widget _buildCosmeticCard(BuildContext context, CosmeticItem item,
      dynamic character, CharacterState state) {
    final theme = Theme.of(context);
    final bool isUnlocked = character.unlockedCosmetics.contains(item.id);

    bool isEquipped = false;
    switch (item.category) {
      case CosmeticCategory.theme:
        isEquipped = character.equippedTheme == item.id;
        break;
      case CosmeticCategory.titleEffect:
        isEquipped = character.equippedTitleEffect == item.id;
        break;
      case CosmeticCategory.combatEffect:
        isEquipped = character.equippedCombatEffect == item.id;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TranslucentCard(
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(item.icon, color: item.color),
          ),
          title: Text(item.name,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(item.description, style: const TextStyle(fontSize: 12)),
          ),
          trailing: _buildActionBtn(
              context, item, isUnlocked, isEquipped, state, theme),
        ),
      ),
    );
  }

  Widget _buildActionBtn(BuildContext context, CosmeticItem item,
      bool isUnlocked, bool isEquipped, CharacterState state, ThemeData theme) {
    if (isEquipped) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade700,
          foregroundColor: Colors.white,
        ),
        onPressed: () => state.unequipCosmetic(item.category),
        child: Text(AppLocalizations.of(context)!.cosmeticUnequip),
      );
    } else if (isUnlocked) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        onPressed: () => state.equipCosmetic(item),
        child: Text(AppLocalizations.of(context)!.cosmeticEquip),
      );
    } else {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.grey.shade700,
          side: BorderSide(color: Colors.grey.shade400),
        ),
        onPressed: () => _showComingSoon(context),
        child: Text(AppLocalizations.of(context)!.cosmeticComingSoon),
      );
    }
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.cosmeticComingSoonSnackbar),
      ),
    );
  }
}
