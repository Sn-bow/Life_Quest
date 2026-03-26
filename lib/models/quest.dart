import 'package:life_quest_final_v2/state/character_state.dart';

enum QuestType { daily, weekly, monthly, yearly }

enum QuestDifficulty {
  easy, // 쉬움
  normal, // 보통
  hard, // 어려움
  veryHard // 매우 어려움
}

class Quest {
  final String id;
  String name;
  int xp;
  final QuestType type;
  StatType category;
  QuestDifficulty difficulty;
  bool isCompleted;
  DateTime? completedDate;

  Quest({
    required this.id,
    required this.name,
    required this.xp,
    required this.type,
    required this.category,
    this.difficulty = QuestDifficulty.normal,
    this.isCompleted = false,
    this.completedDate,
  });

  /// Auto-calculate XP based on difficulty and quest type
  static int xpForDifficulty(QuestDifficulty difficulty, QuestType type) {
    final base = switch (type) {
      QuestType.daily => 1,
      QuestType.weekly => 3,
      QuestType.monthly => 7,
      QuestType.yearly => 14,
    };
    switch (difficulty) {
      case QuestDifficulty.easy:
        return 10 * base;
      case QuestDifficulty.normal:
        return 20 * base;
      case QuestDifficulty.hard:
        return 35 * base;
      case QuestDifficulty.veryHard:
        return 50 * base;
    }
  }

  factory Quest.fromJson(Map<String, dynamic> json) {
    final typeIndex = json['type'] ?? 0;
    final categoryIndex = json['category'] ?? 0;
    final difficultyIndex = json['difficulty'];
    return Quest(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] ?? '퀘스트',
      xp: json['xp'] ?? 10,
      type: (typeIndex >= 0 && typeIndex < QuestType.values.length)
          ? QuestType.values[typeIndex]
          : QuestType.daily,
      category: (categoryIndex >= 0 && categoryIndex < StatType.values.length)
          ? StatType.values[categoryIndex]
          : StatType.strength,
      difficulty: (difficultyIndex != null &&
              difficultyIndex >= 0 &&
              difficultyIndex < QuestDifficulty.values.length)
          ? QuestDifficulty.values[difficultyIndex]
          : QuestDifficulty.normal,
      isCompleted: json['isCompleted'] ?? false,
      completedDate: json['completedDate'] != null
          ? DateTime.tryParse(json['completedDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'xp': xp,
      'type': type.index,
      'category': category.index,
      'difficulty': difficulty.index,
      'isCompleted': isCompleted,
      'completedDate': completedDate?.toIso8601String(),
    };
  }
}
