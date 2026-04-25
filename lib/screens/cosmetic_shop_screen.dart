import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:life_quest_final_v2/models/cosmetic.dart';
import 'package:life_quest_final_v2/services/purchase_service.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/widgets/translucent_card.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CosmeticShopScreen extends StatefulWidget {
  const CosmeticShopScreen({super.key});

  @override
  State<CosmeticShopScreen> createState() => _CosmeticShopScreenState();
}

class _CosmeticShopScreenState extends State<CosmeticShopScreen> {
  final PurchaseService _purchaseService = PurchaseService();
  StreamSubscription<String>? _unlockSub;
  bool _isPurchasing = false;

  @override
  void initState() {
    super.initState();
    // 구매 완료 시 CharacterState에 해금 아이템 추가
    _unlockSub = _purchaseService.unlockStream.listen((cosmeticId) {
      if (!mounted) return;
      final charState = context.read<CharacterState>();
      charState.unlockCosmetic(cosmeticId);
      setState(() => _isPurchasing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.cosmeticUnlocked),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  @override
  void dispose() {
    _unlockSub?.cancel();
    super.dispose();
  }

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

        // IAP 이용 불가 시 안내 배너
        if (!_purchaseService.isAvailable) {
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
              ...categories.entries.map((entry) => _buildCategorySection(
                  context, entry.key, entry.value, character,
                  characterState, theme, l10n)),
            ],
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ...categories.entries.map((entry) => _buildCategorySection(
                context, entry.key, entry.value, character,
                characterState, theme, l10n)),
          ],
        );
      }),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    CosmeticCategory category,
    String title,
    dynamic character,
    CharacterState state,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    final items =
        CosmeticDatabase.items.where((e) => e.category == category).toList();

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
        ...items.map((item) =>
            _buildCosmeticCard(context, item, character, state, l10n)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCosmeticCard(
    BuildContext context,
    CosmeticItem item,
    dynamic character,
    CharacterState state,
    AppLocalizations l10n,
  ) {
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
            child:
                Text(item.description, style: const TextStyle(fontSize: 12)),
          ),
          trailing: _buildActionBtn(
              context, item, isUnlocked, isEquipped, state, theme, l10n),
        ),
      ),
    );
  }

  Widget _buildActionBtn(
    BuildContext context,
    CosmeticItem item,
    bool isUnlocked,
    bool isEquipped,
    CharacterState state,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    if (isEquipped) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade700,
          foregroundColor: Colors.white,
        ),
        onPressed: () => state.unequipCosmetic(item.category),
        child: Text(l10n.cosmeticUnequip),
      );
    } else if (isUnlocked) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        onPressed: () => state.equipCosmetic(item),
        child: Text(l10n.cosmeticEquip),
      );
    } else {
      // 미구매 아이템: IAP 상품 찾아서 가격 표시 후 구매 버튼
      final ProductDetails? product = _purchaseService.products
          .where((p) => p.id == item.iapId)
          .firstOrNull;

      if (_isPurchasing) {
        return const SizedBox(
          width: 80,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      }

      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        onPressed: product == null
            ? null // 상품 로딩 중이거나 미등록
            : () => _handlePurchase(product),
        child: Text(
          product != null ? product.price : l10n.cosmeticComingSoon,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }
  }

  Future<void> _handlePurchase(ProductDetails product) async {
    setState(() => _isPurchasing = true);
    try {
      await _purchaseService.buyProduct(product);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isPurchasing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppLocalizations.of(context)!.cosmeticPurchaseError}: $e')),
      );
    }
  }
}
