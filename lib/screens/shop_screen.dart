import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:life_quest_final_v2/models/character.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/state/combat_state.dart';
import 'package:life_quest_final_v2/models/item.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final charState = context.watch<CharacterState>();
    final combatState = context.watch<CombatState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!charState.isDataLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final character = charState.character;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text('🏪 ', style: TextStyle(fontSize: 20)),
              Text(
                l10n.shopScreenTitle,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  color:
                      isDark ? const Color(0xFF00FFFF) : Colors.orange.shade900,
                ),
              ),
            ],
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1D1E33) : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber, width: 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('💰', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    '${character.gold}',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.amber.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
          bottom: TabBar(
            labelColor:
                isDark ? const Color(0xFF00FFFF) : Colors.orange.shade900,
            unselectedLabelColor: Colors.grey,
            indicatorColor:
                isDark ? const Color(0xFF00FFFF) : Colors.orange.shade900,
            tabs: [
              Tab(text: l10n.shopTabGameItems),
              Tab(text: l10n.shopTabCustomRewards),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: 게임 아이템 (Original Content)
            _buildGameItemsTab(
                context, charState, combatState, character, isDark),
            // Tab 2: 나만의 보상
            _buildCustomRewardsTab(context, charState, isDark),
          ],
        ),
      ),
    );
  }

  /// 공통 구매 처리 헬퍼: CharacterState.purchaseItem()으로 원자적 처리
  void _handleItemPurchase({
    required BuildContext context,
    required CharacterState charState,
    required int price,
    required EquipmentItem item,
    required Color snackColor,
  }) {
    final success = charState.purchaseItem(item, price);
    if (!success) return; // 골드 부족 or _character null
    _showSnack(context, AppLocalizations.of(context)!.shopItemAcquired(item.name), snackColor);
  }

  Widget _buildGameItemsTab(BuildContext context, CharacterState charState,
      CombatState combatState, Character character, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          _buildSectionHeader(context, l10n.shopConsumableSection, isDark, Icons.science),
          const SizedBox(height: 8),
          _buildShopItem(
            context: context,
            icon: Icons.favorite,
            name: l10n.shopHpPotionName,
            description: l10n.shopHpPotionDesc,
            price: 50,
            gold: character.gold,
            isDark: isDark,
            onBuy: () => _handleItemPurchase(
              context: context,
              charState: charState,
              price: 50,
              item: EquipmentItem(
                id: 'hp_potion_${DateTime.now().millisecondsSinceEpoch}',
                name: l10n.shopHpPotionName,
                description: l10n.shopHpPotionDesc,
                type: ItemType.consumable,
                rarity: ItemRarity.common,
                bonusHealth: 30,
              ),
              snackColor: Colors.green,
            ),
          ),
          _buildShopItem(
            context: context,
            icon: Icons.favorite_border,
            name: l10n.shopHpFullPotionName,
            description: l10n.shopHpFullPotionDesc,
            price: 150,
            gold: character.gold,
            isDark: isDark,
            onBuy: () => _handleItemPurchase(
              context: context,
              charState: charState,
              price: 150,
              item: EquipmentItem(
                id: 'hp_potion_full_${DateTime.now().millisecondsSinceEpoch}',
                name: l10n.shopHpFullPotionName,
                description: l10n.shopHpFullPotionDesc,
                type: ItemType.consumable,
                rarity: ItemRarity.rare,
                bonusHealth: 9999,
              ),
              snackColor: Colors.green,
            ),
          ),
          _buildShopItem(
            context: context,
            icon: Icons.bolt,
            name: l10n.shopApPotionName,
            description: l10n.shopApPotionDesc,
            price: 80,
            gold: character.gold,
            isDark: isDark,
            onBuy: () => _handleItemPurchase(
              context: context,
              charState: charState,
              price: 80,
              item: EquipmentItem(
                id: 'ap_potion_${DateTime.now().millisecondsSinceEpoch}',
                name: l10n.shopApPotionName,
                description: l10n.shopApPotionDesc,
                type: ItemType.consumable,
                rarity: ItemRarity.uncommon,
                bonusWisdom: 5,
              ),
              snackColor: Colors.blue,
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
              context, l10n.shopEquipBoxSection, isDark, Icons.inventory_2_outlined),
          const SizedBox(height: 8),
          _buildShopItem(
            context: context,
            icon: Icons.inventory_2,
            name: l10n.shopNormalBoxName,
            description: l10n.shopNormalBoxDesc,
            price: 100,
            gold: character.gold,
            isDark: isDark,
            onBuy: () {
              if (!charState.spendGold(100)) return;
              combatState.openLootBox(character, 1);
              charState.forceSave();
              _showSnack(context, l10n.shopNormalBoxSuccess, Colors.purple);
            },
          ),
          _buildShopItem(
            context: context,
            icon: Icons.redeem,
            name: l10n.shopPremiumBoxName,
            description: l10n.shopPremiumBoxDesc,
            price: 300,
            gold: character.gold,
            isDark: isDark,
            onBuy: () {
              if (!charState.spendGold(300)) return;
              combatState.openLootBox(character, 2);
              charState.forceSave();
              _showSnack(context, l10n.shopPremiumBoxSuccess, Colors.orange);
            },
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, l10n.shopPermanentSection, isDark, Icons.upgrade),
          const SizedBox(height: 8),
          _buildShopItem(
            context: context,
            icon: Icons.favorite,
            name: l10n.shopMaxHpName,
            description: l10n.shopMaxHpDesc,
            price: 500,
            gold: character.gold,
            isDark: isDark,
            onBuy: () {
              final ok = charState.purchaseStat(500, (c) {
                c.characterMaxHp += 10;
                c.characterHp += 10;
              });
              if (ok) _showSnack(context, l10n.shopMaxHpSuccess, Colors.red);
            },
          ),
          _buildShopItem(
            context: context,
            icon: Icons.bolt,
            name: l10n.shopMaxApName,
            description: l10n.shopMaxApDesc,
            price: 500,
            gold: character.gold,
            isDark: isDark,
            onBuy: () {
              final ok = charState.purchaseStat(500, (c) {
                c.maxActionPoints += 2;
                c.actionPoints += 2;
              });
              if (ok) _showSnack(context, l10n.shopMaxApSuccess, Colors.blue);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCustomRewardsTab(
      BuildContext context, CharacterState charState, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    return Stack(
      children: [
        ListView.builder(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
          itemCount: charState.customRewards.length,
          itemBuilder: (context, index) {
            final reward = charState.customRewards[index];
            return Dismissible(
              key: Key(reward.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                color: Colors.red,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) {
                charState.removeCustomReward(reward.id);
                _showSnack(context, l10n.shopCustomRewardDeleted(reward.name), Colors.grey);
              },
              child: _buildShopItem(
                context: context,
                icon: Icons.star,
                iconText: reward.icon,
                name: reward.name,
                description: reward.description,
                price: reward.cost,
                gold: charState.character.gold,
                isDark: isDark,
                onBuy: () => charState.buyCustomReward(reward),
              ),
            );
          },
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.extended(
            onPressed: () => _showAddRewardDialog(context, charState),
            icon: const Icon(Icons.add),
            label: Text(l10n.shopCustomRewardFabLabel),
            backgroundColor:
                isDark ? const Color(0xFF00FFFF) : Colors.orange.shade700,
            foregroundColor: isDark ? Colors.black : Colors.white,
          ),
        ),
      ],
    );
  }

  void _showAddRewardDialog(BuildContext context, CharacterState charState) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final costCtrl = TextEditingController(text: '100');
    final iconCtrl = TextEditingController(text: '🎁');

    showDialog(
      context: context,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          title: Text(l10n.shopCustomRewardAddTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration:
                      InputDecoration(labelText: l10n.shopCustomRewardNameLabel),
                ),
                TextField(
                  controller: descCtrl,
                  decoration: InputDecoration(
                      labelText: l10n.shopCustomRewardDescLabel,
                      hintText: l10n.shopCustomRewardDescHint),
                ),
                TextField(
                  controller: costCtrl,
                  decoration: InputDecoration(labelText: l10n.shopCustomRewardCostLabel),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: iconCtrl,
                  decoration: InputDecoration(labelText: l10n.shopCustomRewardIconLabel),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                final cost = int.tryParse(costCtrl.text) ?? 100;
                if (nameCtrl.text.isNotEmpty && cost > 0 && cost <= 99999) {
                  final icon =
                      iconCtrl.text.trim().isEmpty ? '🎁' : iconCtrl.text.trim();
                  charState.addCustomReward(
                      nameCtrl.text, descCtrl.text, cost, icon);
                  Navigator.pop(ctx);
                }
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, bool isDark,
      [IconData? icon]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
            : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
              : Colors.orange.shade200,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon,
                size: 18,
                color:
                    isDark ? const Color(0xFF00FFFF) : Colors.orange.shade900),
            const SizedBox(width: 8),
          ],
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFF00FFFF) : Colors.orange.shade900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopItem({
    required BuildContext context,
    required IconData icon,
    String? iconText,
    required String name,
    required String description,
    required int price,
    required int gold,
    required bool isDark,
    required VoidCallback onBuy,
  }) {
    final bool canAfford = gold >= price;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: iconText != null && iconText.isNotEmpty
                  ? Text(iconText, style: const TextStyle(fontSize: 22))
                  : Icon(
                      icon,
                      color: isDark ? Colors.white70 : Colors.orange.shade700,
                      size: 24,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    )),
                const SizedBox(height: 2),
                Text(description,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: isDark ? Colors.white54 : Colors.black45,
                    )),
              ],
            ),
          ),
          GestureDetector(
            onTap: canAfford ? onBuy : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: canAfford
                    ? (isDark
                        ? Colors.amber.withValues(alpha: 0.15)
                        : Colors.amber.shade50)
                    : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: canAfford ? Colors.amber : Colors.grey.shade400,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.monetization_on,
                      size: 14, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    '$price',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: canAfford ? Colors.amber.shade700 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'monospace')),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}



