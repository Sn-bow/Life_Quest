import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/state/combat_state.dart';
import 'package:life_quest_final_v2/screens/cosmetic_shop_screen.dart';
import 'package:life_quest_final_v2/models/item.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final charState = context.watch<CharacterState>();
    final combatState = context.watch<CombatState>();
    final character = charState.character;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text('🏪 ', style: TextStyle(fontSize: 20)),
              Text(
                '상점',
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
            tabs: const [
              Tab(text: '게임 아이템'),
              Tab(text: '나만의 보상'),
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

  Widget _buildGameItemsTab(BuildContext context, CharacterState charState,
      CombatState combatState, dynamic character, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Theme Showcase Banner ---
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CosmeticShopScreen()),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade700, Colors.pink.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2))
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.auto_awesome, color: Colors.white, size: 32),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('테마 쇼케이스',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        Text('준비 중인 테마와 이펙트를 미리 둘러보세요.',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.white),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // ------------------------------------

          _buildSectionHeader(context, '소비 아이템', isDark, Icons.science),
          const SizedBox(height: 8),
          _buildShopItem(
            context: context,
            icon: Icons.favorite,
            name: 'HP 회복 물약',
            description: 'HP를 30 회복합니다.',
            price: 50,
            gold: character.gold,
            isDark: isDark,
            onBuy: () {
              if (character.gold >= 50) {
                character.gold -= 50;
                character.inventory.add(EquipmentItem(
                  id: 'hp_potion_${DateTime.now().millisecondsSinceEpoch}',
                  name: 'HP 회복 물약',
                  description: 'HP 30 회복',
                  type: ItemType.consumable,
                  rarity: ItemRarity.common,
                  bonusHealth: 30, // Using bonusHealth as heal amount
                ));
                charState.forceSave();
                _showSnack(context, 'HP 회복 물약을 획득했습니다!', Colors.green);
              }
            },
          ),
          _buildShopItem(
            context: context,
            icon: Icons.favorite_border,
            name: 'HP 완전 회복 물약',
            description: 'HP를 최대치로 회복합니다.',
            price: 150,
            gold: character.gold,
            isDark: isDark,
            onBuy: () {
              if (character.gold >= 150) {
                character.gold -= 150;
                character.inventory.add(EquipmentItem(
                  id: 'hp_potion_full_${DateTime.now().millisecondsSinceEpoch}',
                  name: 'HP 완전 회복 물약',
                  description: 'HP 100% 회복',
                  type: ItemType.consumable,
                  rarity: ItemRarity.rare,
                  bonusHealth: 9999,
                ));
                charState.forceSave();
                _showSnack(context, 'HP 완전 회복 물약을 획득했습니다!', Colors.green);
              }
            },
          ),
          _buildShopItem(
            context: context,
            icon: Icons.bolt,
            name: 'AP 충전 물약',
            description: 'AP를 5 회복합니다.',
            price: 80,
            gold: character.gold,
            isDark: isDark,
            onBuy: () {
              if (character.gold >= 80) {
                character.gold -= 80;
                character.inventory.add(EquipmentItem(
                  id: 'ap_potion_${DateTime.now().millisecondsSinceEpoch}',
                  name: 'AP 충전 물약',
                  description: 'AP 5 회복',
                  type: ItemType.consumable,
                  rarity: ItemRarity.uncommon,
                  bonusWisdom: 5, // We use bonusWisdom to store AP amount
                ));
                charState.forceSave();
                _showSnack(context, 'AP 충전 물약을 획득했습니다!', Colors.blue);
              }
            },
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
              context, '장비 상자', isDark, Icons.inventory_2_outlined),
          const SizedBox(height: 8),
          _buildShopItem(
            context: context,
            icon: Icons.inventory_2,
            name: '일반 장비 상자',
            description: '일반~희귀 등급 장비를 랜덤 획득합니다.',
            price: 100,
            gold: character.gold,
            isDark: isDark,
            onBuy: () {
              if (character.gold >= 100) {
                character.gold -= 100;
                combatState.openLootBox(character, 1);
                charState.forceSave();
                _showSnack(context, '장비를 획득했습니다! 인벤토리를 확인하세요!', Colors.purple);
              }
            },
          ),
          _buildShopItem(
            context: context,
            icon: Icons.redeem,
            name: '고급 장비 상자',
            description: '희귀~전설 등급 장비를 랜덤 획득합니다.',
            price: 300,
            gold: character.gold,
            isDark: isDark,
            onBuy: () {
              if (character.gold >= 300) {
                character.gold -= 300;
                combatState.openLootBox(character, 2);
                charState.forceSave();
                _showSnack(
                    context, '고급 장비를 획득했습니다! 인벤토리를 확인하세요!', Colors.orange);
              }
            },
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, '영구 강화', isDark, Icons.upgrade),
          const SizedBox(height: 8),
          _buildShopItem(
            context: context,
            icon: Icons.favorite,
            name: '최대 HP +10',
            description: '최대 HP를 영구적으로 10 증가시킵니다.',
            price: 500,
            gold: character.gold,
            isDark: isDark,
            onBuy: () {
              if (character.gold >= 500) {
                character.gold -= 500;
                character.characterMaxHp += 10;
                character.characterHp += 10;
                charState.forceSave();
                _showSnack(context, '최대 HP가 10 증가했습니다!', Colors.red);
              }
            },
          ),
          _buildShopItem(
            context: context,
            icon: Icons.bolt,
            name: '최대 AP +2',
            description: '최대 AP를 영구적으로 2 증가시킵니다.',
            price: 500,
            gold: character.gold,
            isDark: isDark,
            onBuy: () {
              if (character.gold >= 500) {
                character.gold -= 500;
                character.maxActionPoints += 2;
                character.actionPoints += 2;
                charState.forceSave();
                _showSnack(context, '최대 AP가 2 증가했습니다!', Colors.blue);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCustomRewardsTab(
      BuildContext context, CharacterState charState, bool isDark) {
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
                _showSnack(context, '${reward.name} 삭제됨', Colors.grey);
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
            label: const Text('보상 추가'),
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
      builder: (ctx) => AlertDialog(
        title: const Text('나만의 보상 추가'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration:
                    const InputDecoration(labelText: '보상 이름 (예: 넷플릭스 1시간)'),
              ),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(
                    labelText: '설명', hintText: '이 보상을 즐기세요!'),
              ),
              TextField(
                controller: costCtrl,
                decoration: const InputDecoration(labelText: '필요 골드'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: iconCtrl,
                decoration: const InputDecoration(labelText: '아이콘 (이모지)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소'),
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
            child: const Text('저장'),
          ),
        ],
      ),
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



