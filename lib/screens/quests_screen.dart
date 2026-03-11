import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/models/quest.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/widgets/quest_tile.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:life_quest_final_v2/services/ad_service.dart';

class QuestsScreen extends StatelessWidget {
  const QuestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final characterState = context.watch<CharacterState>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('퀘스트 목록'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '일일 퀘스트'),
              Tab(text: '주간 퀘스트'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildQuestList(
                context, characterState.dailyQuests, characterState),
            _buildQuestList(
                context, characterState.weeklyQuests, characterState),
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
      BuildContext context, List<Quest> quests, CharacterState state) {
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
              '아직 추가된 퀘스트가 없어요.\n오른쪽 아래 + 버튼으로 새 퀘스트를 추가해 보세요!',
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

  void _showEditQuestDialog(
      BuildContext context, Quest quest, CharacterState state) {
    final nameController = TextEditingController(text: quest.name);
    StatType selectedCategory = quest.category;
    QuestDifficulty selectedDifficulty = quest.difficulty;

    String getCategoryName(StatType category) {
      switch (category) {
        case StatType.strength:
          return '힘';
        case StatType.wisdom:
          return '지혜';
        case StatType.health:
          return '건강';
        case StatType.charisma:
          return '매력';
      }
    }

    String getDifficultyName(QuestDifficulty d) {
      switch (d) {
        case QuestDifficulty.easy:
          return '쉬움';
        case QuestDifficulty.normal:
          return '보통';
        case QuestDifficulty.hard:
          return '어려움';
        case QuestDifficulty.veryHard:
          return '매우 어려움';
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
        return AlertDialog(
          title: const Text('퀘스트 수정'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              final previewXp =
                  Quest.xpForDifficulty(selectedDifficulty, quest.type);
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: '퀘스트 이름'),
                    ),
                    const SizedBox(height: 20),
                    const Text('카테고리',
                        style: TextStyle(fontWeight: FontWeight.bold)),
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
                    const Text('난이도',
                        style: TextStyle(fontWeight: FontWeight.bold)),
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
                      '보상: $previewXp XP · ${(previewXp * 0.5).round()} 골드',
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
              child: const Text('취소'),
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
              child: const Text('저장'),
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
        return AlertDialog(
          title: const Text('퀘스트 완료'),
          content: Text(
              "'${quest.name}' 퀘스트를 완료하시겠습니까?\n기본 보상: ${quest.xp} XP, ${(quest.xp * 0.5).round()} 골드"),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            if (remainingDouble > 0)
              ElevatedButton.icon(
                icon: const Icon(Icons.ondemand_video, size: 18),
                label: Text('광고 보고 2倍 받기 ($remainingDouble회)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  final success =
                      await adService.showRewardedAd('quest_double');
                  if (success) {
                    state.completeQuest(quest, xpMultiplier: 2.0);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('🎉 광고 보상! 경험치와 골드를 2배로 획득했습니다!')),
                      );
                    }
                  } else {
                    state.completeQuest(quest);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('광고를 불러올 수 없습니다. 기본 보상이 지급됩니다.')),
                      );
                    }
                  }
                },
              ),
            TextButton(
              child: const Text('완료'),
              onPressed: () {
                state.completeQuest(quest);
                Navigator.of(dialogContext).pop();
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
        return AlertDialog(
          title: const Text('퀘스트 삭제'),
          content:
              Text("'${quest.name}' 퀘스트를 삭제하시겠습니까?\n\n삭제된 퀘스트는 복구할 수 없습니다."),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('삭제', style: TextStyle(color: Colors.red)),
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

    String getCategoryName(StatType category) {
      switch (category) {
        case StatType.strength:
          return '힘';
        case StatType.wisdom:
          return '지혜';
        case StatType.health:
          return '건강';
        case StatType.charisma:
          return '매력';
      }
    }

    String getDifficultyName(QuestDifficulty d) {
      switch (d) {
        case QuestDifficulty.easy:
          return '쉬움';
        case QuestDifficulty.normal:
          return '보통';
        case QuestDifficulty.hard:
          return '어려움';
        case QuestDifficulty.veryHard:
          return '매우 어려움';
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
        return AlertDialog(
          title: const Text('새 퀘스트 추가'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              final previewXp =
                  Quest.xpForDifficulty(selectedDifficulty, selectedType);
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: '퀘스트 이름'),
                    ),
                    const SizedBox(height: 20),
                    const Text('종류',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SegmentedButton<QuestType>(
                      segments: const <ButtonSegment<QuestType>>[
                        ButtonSegment(
                            value: QuestType.daily, label: Text('일일')),
                        ButtonSegment(
                            value: QuestType.weekly, label: Text('주간')),
                      ],
                      selected: {selectedType},
                      onSelectionChanged: (Set<QuestType> newSelection) {
                        setState(() {
                          selectedType = newSelection.first;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('카테고리',
                        style: TextStyle(fontWeight: FontWeight.bold)),
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
                    const Text('난이도',
                        style: TextStyle(fontWeight: FontWeight.bold)),
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
                      '보상: $previewXp XP · ${(previewXp * 0.5).round()} 골드',
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
              child: const Text('취소'),
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
                    const SnackBar(
                      content: Text('퀘스트 이름을 입력해주세요.'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              child: const Text('추가'),
            ),
          ],
        );
      },
    );
  }
}
