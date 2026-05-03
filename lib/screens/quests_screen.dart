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
      l10n.questsRewardSummary(result.totalXpAwarded.round(), result.totalGoldAwarded, result.actionPointsAwarded),
      if (result.statPointsAwarded > 0)
        l10n.questsRewardStatPoints(result.statPointsAwarded),
      if (result.unlockedTitles.isNotEmpty)
        l10n.questsRewardUnlockedTitles(result.unlockedTitles.join(', ')),
      if (result.unlockedCosmetics.isNotEmpty)
        l10n.questsRewardUnlockedCosmetics(result.unlockedCosmetics.join(', ')),
      // CP + 카드 팩 보상 표시
      if (result.cardPointsAwarded > 0)
        '⭐ CP +${result.cardPointsAwarded}',
      if (result.newPacksAwarded > 0)
        '🎁 카드 팩 +${result.newPacksAwarded}개 획득! (던전 홈에서 열기)',
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
                context, characterState.sortedDailyQuests, characterState, QuestType.daily, l10n),
            _buildQuestList(
                context, characterState.sortedWeeklyQuests, characterState, QuestType.weekly, l10n),
            _buildQuestList(
                context, characterState.sortedMonthlyQuests, characterState, QuestType.monthly, l10n),
            _buildQuestList(
                context, characterState.sortedYearlyQuests, characterState, QuestType.yearly, l10n),
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

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: quests.length,
      itemBuilder: (context, index) {
        final quest = quests[index];
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

  // ── O-3: 다이얼로그 공통 헬퍼 (edit/add 양쪽에서 재사용) ─────────────────
  static String _categoryName(StatType category, AppLocalizations l10n) {
    switch (category) {
      case StatType.strength: return l10n.questsCategoryStrength;
      case StatType.wisdom:   return l10n.questsCategoryWisdom;
      case StatType.health:   return l10n.questsCategoryHealth;
      case StatType.charisma: return l10n.questsCategoryCharm;
    }
  }

  static String _difficultyName(QuestDifficulty d, AppLocalizations l10n) {
    switch (d) {
      case QuestDifficulty.easy:     return l10n.questsDifficultyEasy;
      case QuestDifficulty.normal:   return l10n.questsDifficultyNormal;
      case QuestDifficulty.hard:     return l10n.questsDifficultyHard;
      case QuestDifficulty.veryHard: return l10n.questsDifficultyVeryHard;
    }
  }

  static String _questTypeName(QuestType type, AppLocalizations l10n) {
    switch (type) {
      case QuestType.daily:   return l10n.questsTypeDaily;
      case QuestType.weekly:  return l10n.questsTypeWeekly;
      case QuestType.monthly: return l10n.questsTypeMonthly;
      case QuestType.yearly:  return l10n.questsTypeYearly;
    }
  }

  static Color _difficultyColor(QuestDifficulty d) {
    switch (d) {
      case QuestDifficulty.easy:     return Colors.green;
      case QuestDifficulty.normal:   return Colors.blue;
      case QuestDifficulty.hard:     return Colors.orange;
      case QuestDifficulty.veryHard: return Colors.red;
    }
  }
  // ─────────────────────────────────────────────────────────────────────────

  void _showEditQuestDialog(
      BuildContext context, Quest quest, CharacterState state) {
    final nameController = TextEditingController(text: quest.name);
    StatType selectedCategory = quest.category;
    QuestDifficulty selectedDifficulty = quest.difficulty;

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
                          label: Text(_categoryName(category, dialogL10n)),
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
                          label: Text(_difficultyName(d, dialogL10n)),
                          selected: selectedDifficulty == d,
                          selectedColor:
                              _difficultyColor(d).withValues(alpha: 0.3),
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
                        _questTypeName(quest.type, dialogL10n),
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
    // 이미 완료됐거나 광고 시청 중(비동기 갭)이면 차단
    if (quest.isCompleted) return;
    if (state.isQuestPending(quest.id)) return;

    final adService = AdService();
    final remainingDouble = adService.getRemainingViews('quest_double');

    showDialog(
      context: context,
      barrierDismissible: false, // 처리 중 배경 탭으로 닫기 방지
      builder: (BuildContext dialogContext) {
        final l10n = AppLocalizations.of(dialogContext)!;
        bool isProcessing = false;

        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: Text(l10n.questsCompleteTitle),
              content: Text(
                [
                  l10n.questsCompleteConfirm(quest.name),
                  l10n.questsBaseRewardLabel,
                  '- ${quest.xp} XP',
                  '- ${(quest.xp * 0.5).round()} ${l10n.questsGoldUnit}',
                  if (quest.type == QuestType.monthly || quest.type == QuestType.yearly)
                    _raidRewardPreview(quest, l10n),
                ].join('\n'),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: isProcessing ? null : () => Navigator.of(dialogContext).pop(),
                  child: Text(l10n.cancel),
                ),
                if (remainingDouble > 0)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.ondemand_video, size: 18),
                    label: Text(l10n.questsDoubleAdButton(remainingDouble)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: isProcessing ? null : () async {
                      setDialogState(() => isProcessing = true);
                      // R-1 fix: pending 마킹을 다이얼로그 닫기 전에 수행
                      // → 닫힌 직후 다른 tap이 들어와도 중복 완료 차단
                      state.markQuestPending(quest.id);
                      Navigator.of(dialogContext).pop();
                      try {
                        final success = await adService.showRewardedAd('quest_double');
                        // R-4 fix: mounted 체크 후 l10n을 안전하게 획득
                        if (!context.mounted) return;
                        final mountedL10n = AppLocalizations.of(context);
                        if (mountedL10n == null) return;
                        final result = state.completeQuest(
                          quest,
                          xpMultiplier: success ? 2.0 : 1.0,
                        );
                        final prefix = success
                            ? mountedL10n.questsAdRewardApplied
                            : mountedL10n.questsAdUnavailable;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$prefix\n${_completionSummary(result, quest, mountedL10n)}'),
                            duration: const Duration(seconds: 5),
                          ),
                        );
                      } finally {
                        state.clearQuestPending(quest.id);
                      }
                    },
                  ),
                TextButton(
                  onPressed: isProcessing ? null : () {
                    setDialogState(() => isProcessing = true);
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
                  child: Text(l10n.complete),
                ),
              ],
            );
          },
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
    final nameController = TextEditingController();
    QuestType selectedType = QuestType.daily;
    StatType selectedCategory = StatType.strength;
    QuestDifficulty selectedDifficulty = QuestDifficulty.normal;

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
                          label: Text(_questTypeName(type, dialogL10n)),
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
                          label: Text(_categoryName(category, dialogL10n)),
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
                          label: Text(_difficultyName(d, dialogL10n)),
                          selected: selectedDifficulty == d,
                          selectedColor:
                              _difficultyColor(d).withValues(alpha: 0.3),
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
                        _questTypeName(selectedType, dialogL10n),
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
