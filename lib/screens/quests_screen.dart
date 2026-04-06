import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/models/quest.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/widgets/quest_tile.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:life_quest_final_v2/services/ad_service.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';

class QuestsScreen extends StatelessWidget {
  const QuestsScreen({super.key});

  String _raidRewardPreview(Quest quest, AppLocalizations l10n) {
    switch (quest.type) {
      case QuestType.monthly:
        return l10n.questsRaidBonusMonthly;
      case QuestType.yearly:
        return l10n.questsRaidBonusYearly;
      case QuestType.daily:
      case QuestType.weekly:
        return '';
    }
  }

  String _completionSummary(QuestCompletionResult? result, Quest quest, AppLocalizations l10n) {
    if (result == null) {
      return l10n.questsCompleteConfirm(quest.name);
    }

    final lines = <String>[
      if (result.wasRaid)
        l10n.questsRaidClear(result.raidClearCount),
      '총 보상: ${result.totalXpAwarded.round()} XP · ${result.totalGoldAwarded} 골드 · AP +${result.actionPointsAwarded}',
      if (result.statPointsAwarded > 0) '추가 스탯 포인트 +${result.statPointsAwarded}',
      if (result.unlockedTitles.isNotEmpty)
        '해금 칭호: ${result.unlockedTitles.join(', ')}',
      if (result.unlockedCosmetics.isNotEmpty)
        '해금 보상: ${result.unlockedCosmetics.join(', ')}',
    ];
    return lines.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final characterState = context.watch<CharacterState>();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.questsScreenTitle),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: l10n.questsTabDaily),
              Tab(text: l10n.questsTabWeekly),
              Tab(text: l10n.questsTabMonthly),
              Tab(text: l10n.questsTabYearly),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildQuestList(
                context, characterState.dailyQuests, characterState, QuestType.daily, l10n),
            _buildQuestList(
                context, characterState.weeklyQuests, characterState, QuestType.weekly, l10n),
            _buildQuestList(
                context, characterState.monthlyQuests, characterState, QuestType.monthly, l10n),
            _buildQuestList(
                context, characterState.yearlyQuests, characterState, QuestType.yearly, l10n),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddQuestDialog(context),
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(PhosphorIcons.plus,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white),
        ),
      ),
    );
  }

  Widget _buildQuestList(
      BuildContext context, List<Quest> quests, CharacterState state, QuestType type, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (quests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(PhosphorIcons.ghost,
                size: 80,
                color: isDarkMode ? Colors.white24 : Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              _emptyMessageFor(type, l10n),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: isDarkMode ? Colors.white54 : Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    // Sort: Uncompleted first, then completed
    final sortedQuests = List<Quest>.from(quests)
      ..sort((a, b) {
        if (!a.isCompleted && b.isCompleted) return -1;
        if (a.isCompleted && !b.isCompleted) return 1;
        return 0; // Keep original order otherwise
      });

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedQuests.length,
      itemBuilder: (context, index) {
        final quest = sortedQuests[index];
        return QuestTile(
          quest: quest,
          rewardPreview:
              quest.type == QuestType.monthly || quest.type == QuestType.yearly
                  ? _raidRewardPreview(quest, l10n)
                  : null,
          onChecked: () {
            _showCompleteConfirmationDialog(context, quest, state);
          },
          onDeleted: () {
            _showDeleteConfirmDialog(context, quest, state);
          },
          onEdited: () {
            _showEditQuestDialog(context, quest, state);
          },
        );
      },
    );
  }

  String _emptyMessageFor(QuestType type, AppLocalizations l10n) {
    switch (type) {
      case QuestType.daily:
        return l10n.questsEmptyDaily;
      case QuestType.weekly:
        return l10n.questsEmptyWeekly;
      case QuestType.monthly:
        return l10n.questsEmptyMonthly;
      case QuestType.yearly:
        return l10n.questsEmptyYearly;
    }
  }

  void _showEditQuestDialog(
      BuildContext context, Quest quest, CharacterState state) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController(text: quest.name);
    StatType selectedCategory = quest.category;
    QuestDifficulty selectedDifficulty = quest.difficulty;

    String getCategoryName(StatType category) {
      switch (category) {
        case StatType.strength:
          return l10n.questsCategoryStrength;
        case StatType.wisdom:
          return l10n.questsCategoryWisdom;
        case StatType.health:
          return l10n.questsCategoryHealth;
        case StatType.charisma:
          return l10n.questsCategoryCharm;
      }
    }

    String getDifficultyName(QuestDifficulty d) {
      switch (d) {
        case QuestDifficulty.easy:
          return l10n.questsDifficultyEasy;
        case QuestDifficulty.normal:
          return l10n.questsDifficultyNormal;
        case QuestDifficulty.hard:
          return l10n.questsDifficultyHard;
        case QuestDifficulty.veryHard:
          return l10n.questsDifficultyVeryHard;
      }
    }

    String getQuestTypeName(QuestType type) {
      switch (type) {
        case QuestType.daily:
          return l10n.questsTypeDaily;
        case QuestType.weekly:
          return l10n.questsTypeWeekly;
        case QuestType.monthly:
          return l10n.questsTypeMonthly;
        case QuestType.yearly:
          return l10n.questsTypeYearly;
      }
    }

    Color getDifficultyColor(QuestDifficulty d) {
      switch (d) {
        case QuestDifficulty.easy:
          return Colors.green;
        case QuestDifficulty.normal:
          return Colors.blue;
        case QuestDifficulty.hard:
          return Colors.orange;
        case QuestDifficulty.veryHard:
          return Colors.red;
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        final dialogL10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(dialogL10n.questsEditTitle),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              final previewXp =
                  Quest.xpForDifficulty(selectedDifficulty, quest.type);
              final previewGold = (previewXp * 0.5).round();
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: dialogL10n.questsNameLabel, counterText: ''),
                      maxLength: 50,
                    ),
                    const SizedBox(height: 20),
                    Text(dialogL10n.questsCategoryLabel,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8.0,
                      children: StatType.values.map((category) {
                        return ChoiceChip(
                          label: Text(getCategoryName(category)),
                          selected: selectedCategory == category,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) selectedCategory = category;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Text(dialogL10n.questsDifficultyLabel,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8.0,
                      children: QuestDifficulty.values.map((d) {
                        return ChoiceChip(
                          label: Text(getDifficultyName(d)),
                          selected: selectedDifficulty == d,
                          selectedColor:
                              getDifficultyColor(d).withValues(alpha: 0.3),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) selectedDifficulty = d;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dialogL10n.questsRewardPreview(
                        getQuestTypeName(quest.type),
                        previewXp,
                        previewGold,
                      ),
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(dialogL10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                if (name.isNotEmpty) {
                  final newXp =
                      Quest.xpForDifficulty(selectedDifficulty, quest.type);
                  quest.difficulty = selectedDifficulty;
                  state.editQuest(quest, name, newXp, selectedCategory);
                  Navigator.pop(context);
                }
              },
              child: Text(dialogL10n.save),
            ),
          ],
        );
      },
    );
  }

  void _showCompleteConfirmationDialog(
      BuildContext context, Quest quest, CharacterState state) {
    if (quest.isCompleted) return; // Prevent double completion

    final adService = AdService();
    final remainingDouble = adService.getRemainingViews('quest_double');

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final l10n = AppLocalizations.of(dialogContext)!;
        return AlertDialog(
          title: Text(l10n.questsCompleteTitle),
          content: Text(
            [
              l10n.questsCompleteConfirm(quest.name),
              l10n.questsBaseRewardLabel,
              '- ${quest.xp} XP',
              '- ${(quest.xp * 0.5).round()} 골드',
              if (quest.type == QuestType.monthly || quest.type == QuestType.yearly)
                _raidRewardPreview(quest, l10n),
            ].join('\n'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.cancel),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            if (remainingDouble > 0)
              ElevatedButton.icon(
                icon: const Icon(Icons.ondemand_video, size: 18),
                label: Text(l10n.questsDoubleAdButton(remainingDouble)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  final success =
                      await adService.showRewardedAd('quest_double');
                  if (success) {
                    final result =
                        state.completeQuest(quest, xpMultiplier: 2.0);
                    if (context.mounted) {
                      final mountedL10n = AppLocalizations.of(context)!;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '🎉 광고 보상 적용\n${_completionSummary(result, quest, mountedL10n)}',
                          ),
                          duration: const Duration(seconds: 5),
                        ),
                      );
                    }
                  } else {
                    final result = state.completeQuest(quest);
                    if (context.mounted) {
                      final mountedL10n = AppLocalizations.of(context)!;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${mountedL10n.questsAdUnavailable}\n${_completionSummary(result, quest, mountedL10n)}',
                          ),
                          duration: const Duration(seconds: 5),
                        ),
                      );
                    }
                  }
                },
              ),
            TextButton(
              child: Text(l10n.complete),
              onPressed: () {
                final result = state.completeQuest(quest);
                Navigator.of(dialogContext).pop();
                if (context.mounted) {
                  final mountedL10n = AppLocalizations.of(context)!;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_completionSummary(result, quest, mountedL10n)),
                      duration: const Duration(seconds: 5),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmDialog(
      BuildContext context, Quest quest, CharacterState state) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final l10n = AppLocalizations.of(dialogContext)!;
        return AlertDialog(
          title: Text(l10n.questsDeleteTitle),
          content: Text(l10n.questsDeleteBody(quest.name)),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.cancel),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
              onPressed: () {
                state.deleteQuest(quest);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddQuestDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    QuestType selectedType = QuestType.daily;
    StatType selectedCategory = StatType.strength;
    QuestDifficulty selectedDifficulty = QuestDifficulty.normal;

    String getCategoryName(StatType category) {
      switch (category) {
        case StatType.strength:
          return l10n.questsCategoryStrength;
        case StatType.wisdom:
          return l10n.questsCategoryWisdom;
        case StatType.health:
          return l10n.questsCategoryHealth;
        case StatType.charisma:
          return l10n.questsCategoryCharm;
      }
    }

    String getDifficultyName(QuestDifficulty d) {
      switch (d) {
        case QuestDifficulty.easy:
          return l10n.questsDifficultyEasy;
        case QuestDifficulty.normal:
          return l10n.questsDifficultyNormal;
        case QuestDifficulty.hard:
          return l10n.questsDifficultyHard;
        case QuestDifficulty.veryHard:
          return l10n.questsDifficultyVeryHard;
      }
    }

    String getQuestTypeName(QuestType type) {
      switch (type) {
        case QuestType.daily:
          return l10n.questsTypeDaily;
        case QuestType.weekly:
          return l10n.questsTypeWeekly;
        case QuestType.monthly:
          return l10n.questsTypeMonthly;
        case QuestType.yearly:
          return l10n.questsTypeYearly;
      }
    }

    Color getDifficultyColor(QuestDifficulty d) {
      switch (d) {
        case QuestDifficulty.easy:
          return Colors.green;
        case QuestDifficulty.normal:
          return Colors.blue;
        case QuestDifficulty.hard:
          return Colors.orange;
        case QuestDifficulty.veryHard:
          return Colors.red;
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        final dialogL10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(dialogL10n.questsAddTitle),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              final previewXp =
                  Quest.xpForDifficulty(selectedDifficulty, selectedType);
              final previewGold = (previewXp * 0.5).round();
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: dialogL10n.questsNameLabel, counterText: ''),
                      maxLength: 50,
                    ),
                    const SizedBox(height: 20),
                    Text(dialogL10n.questsTypeLabel,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: QuestType.values.map((type) {
                        return ChoiceChip(
                          label: Text(getQuestTypeName(type)),
                          selected: selectedType == type,
                          onSelected: (selected) {
                            if (!selected) return;
                            setState(() {
                              selectedType = type;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Text(dialogL10n.questsCategoryLabel,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8.0,
                      children: StatType.values.map((category) {
                        return ChoiceChip(
                          label: Text(getCategoryName(category)),
                          selected: selectedCategory == category,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) selectedCategory = category;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Text(dialogL10n.questsDifficultyLabel,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8.0,
                      children: QuestDifficulty.values.map((d) {
                        return ChoiceChip(
                          label: Text(getDifficultyName(d)),
                          selected: selectedDifficulty == d,
                          selectedColor:
                              getDifficultyColor(d).withValues(alpha: 0.3),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) selectedDifficulty = d;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dialogL10n.questsRewardPreview(
                        getQuestTypeName(selectedType),
                        previewXp,
                        previewGold,
                      ),
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(dialogL10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                if (name.isNotEmpty) {
                  final xp =
                      Quest.xpForDifficulty(selectedDifficulty, selectedType);
                  Provider.of<CharacterState>(context, listen: false).addQuest(
                      name, xp, selectedType, selectedCategory,
                      difficulty: selectedDifficulty);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(dialogL10n.questsNameRequired),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              child: Text(dialogL10n.complete),
            ),
          ],
        );
      },
    );
  }
}
