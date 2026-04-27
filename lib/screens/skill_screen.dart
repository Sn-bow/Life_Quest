import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/widgets/translucent_card.dart';
import 'package:provider/provider.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SkillScreen extends StatelessWidget {
  const SkillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final characterState = context.watch<CharacterState>();
    if (!characterState.isDataLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final character = characterState.character;
    final skills = characterState.allSkills;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.skillScreenTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'SKP: ${character.skillPoints}',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: skills.length,
        itemBuilder: (context, index) {
          final skill = skills[index];
          final isLearned = characterState.learnedSkillIds.contains(skill.id);
          final canLearn = characterState.canLearnSkill(skill);

          String? localizedStatName;
          if (skill.requiredStatType != null &&
              skill.requiredStatValue != null) {
            switch (skill.requiredStatType!) {
              case StatType.strength:
                localizedStatName = l10n.questsCategoryStrength;
                break;
              case StatType.wisdom:
                localizedStatName = l10n.questsCategoryWisdom;
                break;
              case StatType.health:
                localizedStatName = l10n.questsCategoryHealth;
                break;
              case StatType.charisma:
                localizedStatName = l10n.questsCategoryCharm;
                break;
            }
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TranslucentCard(
              child: ListTile(
                leading: Icon(
                  isLearned ? PhosphorIcons.starFill : PhosphorIcons.lock,
                  color: isLearned
                      ? Colors.amber
                      : (canLearn
                          ? theme.colorScheme.onSurface
                          : Colors.grey.shade600),
                  size: 40,
                ),
                title: Text(
                  skill.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isLearned
                        ? Colors.amber
                        : (canLearn
                            ? theme.textTheme.bodyLarge?.color
                            : Colors.grey.shade600),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(skill.description,
                        style: TextStyle(
                            color: canLearn || isLearned
                                ? theme.textTheme.bodyMedium?.color
                                : Colors.grey.shade600)),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      children: [
                        Text(
                          l10n.skillRequiredLevel(skill.requiredLevel),
                          style: TextStyle(
                              fontSize: 12,
                              color: canLearn || isLearned
                                  ? theme.colorScheme.secondary
                                  : Colors.grey.shade600),
                        ),
                        if (localizedStatName != null)
                          Text(
                            '$localizedStatName ${skill.requiredStatValue}',
                            style: TextStyle(
                                fontSize: 12,
                                color: canLearn || isLearned
                                    ? theme.colorScheme.secondary
                                    : Colors.grey.shade600),
                          ),
                      ],
                    ),
                  ],
                ),
                trailing: isLearned
                    ? null
                    : ElevatedButton(
                        onPressed: canLearn
                            ? () => characterState.learnSkill(skill)
                            : null,
                        child: Text(l10n.acquire),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
