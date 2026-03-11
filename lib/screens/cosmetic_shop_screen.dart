import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/models/cosmetic.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/widgets/translucent_card.dart';
import 'package:provider/provider.dart';

class CosmeticShopScreen extends StatelessWidget {
  const CosmeticShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('테마 쇼케이스'),
      ),
      body: Consumer<CharacterState>(builder: (context, characterState, child) {
        if (!characterState.isDataLoaded) {
          return const Center(child: CircularProgressIndicator());
        }
        final character = characterState.character;

        final categories = {
          CosmeticCategory.theme: '앱 테마',
          CosmeticCategory.titleEffect: '칭호 이펙트',
          CosmeticCategory.combatEffect: '전투 이펙트',
        };

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const TranslucentCard(
              child: ListTile(
                leading: Icon(Icons.auto_awesome, color: Colors.amber),
                title: Text('프리미엄 꾸미기 기능은 준비 중입니다'),
                subtitle: Text(
                  '현재는 광고 후원형 운영에 집중하고 있습니다. 테마와 이펙트 상품은 추후 정식 오픈 예정입니다.',
                ),
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
        child: const Text('장착 해제'),
      );
    } else if (isUnlocked) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        onPressed: () => state.equipCosmetic(item),
        child: const Text('장착'),
      );
    } else {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.grey.shade700,
          side: BorderSide(color: Colors.grey.shade400),
        ),
        onPressed: () => _showComingSoon(context),
        child: const Text('준비 중'),
      );
    }
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('코스메틱 상품은 추후 오픈 예정입니다. 현재는 광고 후원형 운영에 집중하고 있습니다.'),
      ),
    );
  }
}
