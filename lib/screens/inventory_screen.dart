import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/state/combat_state.dart';
import 'package:life_quest_final_v2/models/item.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final charState = context.watch<CharacterState>();
    final combatState = context.watch<CombatState>();
    final character = charState.character;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('🎒 ', style: TextStyle(fontSize: 20)),
            Text(
              '인벤토리',
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
                  '${charState.character.gold}',
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Equipment Slots
            _buildSectionHeader('장착 장비', isDark),
            const SizedBox(height: 8),
            _buildEquipmentSlots(character, combatState, isDark, context),
            const SizedBox(height: 24),

            // Stat summary with equipment
            _buildSectionHeader('전투 스탯', isDark),
            const SizedBox(height: 24),
            _buildCombatStats(character, isDark, context),
            const SizedBox(height: 24),

            // Inventory items
            _buildSectionHeader(
                '보유 아이템 (${character.inventory.length})', isDark),
            const SizedBox(height: 8),
            if (character.inventory.isEmpty)
              _buildEmptyInventory(isDark)
            else
              ...character.inventory.map(
                (item) => _buildInventoryItem(
                    item, character, combatState, charState, isDark, context),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1D1E33) : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isDark
              ? const Color(0xFF00FFFF).withValues(alpha: 0.3)
              : Colors.orange.shade200,
          width: 2,
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: isDark ? const Color(0xFF00FFFF) : Colors.orange.shade900,
        ),
      ),
    );
  }

  Widget _buildEquipmentSlots(dynamic character, CombatState combatState,
      bool isDark, BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: _buildSlot('⚔️ 무기', character.equippedWeapon,
                ItemType.weapon, character, combatState, isDark, context)),
        const SizedBox(width: 8),
        Expanded(
            child: _buildSlot('🛡️ 방어구', character.equippedArmor,
                ItemType.armor, character, combatState, isDark, context)),
        const SizedBox(width: 8),
        Expanded(
            child: _buildSlot('💍 장신구', character.equippedAccessory,
                ItemType.accessory, character, combatState, isDark, context)),
      ],
    );
  }

  Widget _buildSlot(
      String label,
      EquipmentItem? item,
      ItemType slot,
      dynamic character,
      CombatState combatState,
      bool isDark,
      BuildContext context) {
    return GestureDetector(
      onTap: item != null
          ? () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(item.name,
                      style: const TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.description,
                          style: const TextStyle(fontFamily: 'monospace')),
                      const SizedBox(height: 8),
                      _buildItemStats(item, isDark),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        combatState.unequipItem(character, slot);
                        context.read<CharacterState>().forceSave();
                        Navigator.of(ctx).pop();
                      },
                      child: Text('해제',
                          style: TextStyle(
                              fontFamily: 'monospace',
                              color: Colors.red.shade400)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('닫기',
                          style: TextStyle(fontFamily: 'monospace')),
                    ),
                  ],
                ),
              );
            }
          : null,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1D1E33) : Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: item != null
                ? _getRarityColor(item.rarity)
                : (isDark ? Colors.white24 : Colors.grey.shade300),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label,
                style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: isDark ? Colors.white54 : Colors.black45)),
            const SizedBox(height: 4),
            if (item != null) ...[
              Icon(_getItemIcon(item.type),
                  size: 24, color: _getRarityColor(item.rarity)),
              const SizedBox(height: 2),
              Text(
                item.name,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: _getRarityColor(item.rarity),
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ] else
              Text(
                '비어있음',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  color: isDark ? Colors.white24 : Colors.grey.shade400,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCombatStats(
      dynamic character, bool isDark, BuildContext context) {
    double totalAtk = character.strength + 5;
    double totalDef = character.health * 0.5;

    if (character.equippedWeapon != null) {
      totalAtk += character.equippedWeapon!.attackPower +
          character.equippedWeapon!.bonusStrength;
    }
    if (character.equippedArmor != null) {
      totalDef += character.equippedArmor!.defensePower;
    }
    if (character.equippedAccessory != null) {
      totalAtk += character.equippedAccessory!.bonusStrength;
      totalDef += character.equippedAccessory!.bonusHealth * 0.3;
    }

    return Container(
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatColumn(
              '공격력', Icons.sports_martial_arts, totalAtk.toInt(), isDark),
          Container(
              width: 1,
              height: 40,
              color: isDark ? Colors.white12 : Colors.grey.shade300),
          _buildStatColumn(
              '방어력', Icons.shield_outlined, totalDef.toInt(), isDark),
          Container(
              width: 1,
              height: 40,
              color: isDark ? Colors.white12 : Colors.grey.shade300),
          _buildStatColumn('체력', Icons.favorite_border,
              (50 + character.health * 5).toInt(), isDark),
        ],
      ),
    );
  }

  Widget _buildStatColumn(
      String label, IconData iconData, int value, bool isDark) {
    return Column(
      children: [
        Row(
          children: [
            Icon(iconData,
                size: 14, color: isDark ? Colors.white54 : Colors.black45),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.black45)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '$value',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? const Color(0xFF00FFFF) : Colors.orange.shade800,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyInventory(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1D1E33) : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 40, color: isDark ? Colors.white38 : Colors.grey.shade400),
          const SizedBox(height: 8),
          Text(
            '아이템이 없습니다\n몬스터를 사냥하여 장비를 획득하세요!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryItem(
      EquipmentItem item,
      dynamic character,
      CombatState combatState,
      CharacterState charState,
      bool isDark,
      BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1D1E33) : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: _getRarityColor(item.rarity).withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          // Item icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _getRarityColor(item.rarity).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: _getRarityColor(item.rarity), width: 1),
            ),
            child: Center(
              child: Icon(_getItemIcon(item.type),
                  size: 24, color: _getRarityColor(item.rarity)),
            ),
          ),
          const SizedBox(width: 12),
          // Item info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _getRarityColor(item.rarity),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color:
                            _getRarityColor(item.rarity).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        _getRarityName(item.rarity),
                        style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 9,
                            color: _getRarityColor(item.rarity)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item.description,
                  style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: isDark ? Colors.white54 : Colors.black45),
                ),
              ],
            ),
          ),
          // Equip button
          GestureDetector(
            onTap: () {
              combatState.equipItem(character, item);
              charState.forceSave();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF00FFFF).withValues(alpha: 0.15)
                    : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isDark ? const Color(0xFF00FFFF) : Colors.orange,
                  width: 1.5,
                ),
              ),
              child: Text(
                '장착',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color:
                      isDark ? const Color(0xFF00FFFF) : Colors.orange.shade800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemStats(EquipmentItem item, bool isDark) {
    List<Widget> statWidgets = [];
    void addStat(IconData icon, String label, int value, Color color) {
      if (value > 0) {
        statWidgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text('$label +$value',
                  style: TextStyle(fontSize: 13, color: color)),
            ],
          ),
        ));
      }
    }

    final textColor = isDark ? const Color(0xFF38BDF8) : Colors.indigo.shade600;

    addStat(
        Icons.sports_martial_arts, '공격력', item.attackPower.toInt(), textColor);
    addStat(Icons.shield_outlined, '방어력', item.defensePower.toInt(), textColor);
    addStat(Icons.fitness_center, '힘', item.bonusStrength.toInt(), textColor);
    addStat(Icons.menu_book, '지혜', item.bonusWisdom.toInt(), textColor);
    addStat(Icons.favorite_border, '건강', item.bonusHealth.toInt(), textColor);
    addStat(Icons.auto_awesome, '매력', item.bonusCharisma.toInt(), textColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: statWidgets,
    );
  }

  IconData _getItemIcon(ItemType type) {
    switch (type) {
      case ItemType.weapon:
        return Icons.colorize; // Represents weapon/sword
      case ItemType.armor:
        return Icons.shield;
      case ItemType.accessory:
        return Icons.auto_awesome;
      case ItemType.consumable:
        return Icons.science;
    }
  }

  Color _getRarityColor(ItemRarity rarity) {
    switch (rarity) {
      case ItemRarity.common:
        return Colors.grey;
      case ItemRarity.uncommon:
        return Colors.green;
      case ItemRarity.rare:
        return Colors.blue;
      case ItemRarity.epic:
        return Colors.purple;
      case ItemRarity.legendary:
        return Colors.orange;
    }
  }

  String _getRarityName(ItemRarity rarity) {
    switch (rarity) {
      case ItemRarity.common:
        return '일반';
      case ItemRarity.uncommon:
        return '고급';
      case ItemRarity.rare:
        return '희귀';
      case ItemRarity.epic:
        return '영웅';
      case ItemRarity.legendary:
        return '전설';
    }
  }
}
