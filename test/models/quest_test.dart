import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/models/quest.dart';
import 'package:life_quest_final_v2/state/character_state.dart';

void main() {
  group('Quest Model Tests', () {
    test('Quest calculation applies multiplier based on difficulty and type',
        () {
      final dailyEasyXp =
          Quest.xpForDifficulty(QuestDifficulty.easy, QuestType.daily);
      expect(dailyEasyXp, 10);

      final dailyHardXp =
          Quest.xpForDifficulty(QuestDifficulty.hard, QuestType.daily);
      expect(dailyHardXp, 35);

      final weeklyNormalXp =
          Quest.xpForDifficulty(QuestDifficulty.normal, QuestType.weekly);
      expect(weeklyNormalXp, 60);

      final weeklyVeryHardXp =
          Quest.xpForDifficulty(QuestDifficulty.veryHard, QuestType.weekly);
      expect(weeklyVeryHardXp, 150);
    });

    test('Quest serialization and deserialization works correctly', () {
      final quest = Quest(
        id: 'q1',
        name: 'Morning Workout',
        xp: 20,
        type: QuestType.daily,
        category: StatType.strength,
        difficulty: QuestDifficulty.normal,
        isCompleted: true,
        completedDate: DateTime(2023, 10, 1),
      );

      final json = quest.toJson();
      final newQuest = Quest.fromJson(json);

      expect(newQuest.id, 'q1');
      expect(newQuest.name, 'Morning Workout');
      expect(newQuest.xp, 20);
      expect(newQuest.type, QuestType.daily);
      expect(newQuest.category, StatType.strength);
      expect(newQuest.difficulty, QuestDifficulty.normal);
      expect(newQuest.isCompleted, isTrue);
      expect(newQuest.completedDate, DateTime(2023, 10, 1));
    });

    // D-1: fromJson edge cases
    test('fromJson handles empty JSON with defaults', () {
      final json = <String, dynamic>{};
      final quest = Quest.fromJson(json);

      expect(quest.name, '퀘스트');
      expect(quest.xp, 10);
      expect(quest.type, QuestType.daily);
      expect(quest.category, StatType.strength);
      expect(quest.difficulty, QuestDifficulty.normal);
      expect(quest.isCompleted, false);
      expect(quest.completedDate, isNull);
    });

    test('fromJson handles null isCompleted', () {
      final json = <String, dynamic>{
        'id': 'q2',
        'name': 'Test',
        'xp': 15,
        'type': 0,
        'category': 1,
      };
      final quest = Quest.fromJson(json);

      expect(quest.isCompleted, false);
    });

    test('fromJson handles out-of-range type index', () {
      final json = <String, dynamic>{
        'id': 'q3',
        'name': 'Test',
        'xp': 10,
        'type': 99,
        'category': 0,
      };
      final quest = Quest.fromJson(json);

      expect(quest.type, QuestType.daily);
    });

    test('fromJson handles out-of-range category index', () {
      final json = <String, dynamic>{
        'id': 'q4',
        'name': 'Test',
        'xp': 10,
        'type': 0,
        'category': 99,
      };
      final quest = Quest.fromJson(json);

      expect(quest.category, StatType.strength);
    });

    test('fromJson handles out-of-range difficulty index', () {
      final json = <String, dynamic>{
        'id': 'q5',
        'name': 'Test',
        'xp': 10,
        'type': 0,
        'category': 0,
        'difficulty': 99,
      };
      final quest = Quest.fromJson(json);

      expect(quest.difficulty, QuestDifficulty.normal);
    });

    test('fromJson handles invalid completedDate gracefully', () {
      final json = <String, dynamic>{
        'id': 'q6',
        'name': 'Test',
        'xp': 10,
        'type': 0,
        'category': 0,
        'completedDate': 'not-a-date',
      };
      final quest = Quest.fromJson(json);

      expect(quest.completedDate, isNull);
    });

    test('toJson produces correct output', () {
      final quest = Quest(
        id: 'q7',
        name: 'Read Book',
        xp: 15,
        type: QuestType.weekly,
        category: StatType.wisdom,
        difficulty: QuestDifficulty.hard,
      );

      final json = quest.toJson();

      expect(json['id'], 'q7');
      expect(json['name'], 'Read Book');
      expect(json['type'], 1);
      expect(json['category'], 1);
      expect(json['difficulty'], 2);
      expect(json['isCompleted'], false);
      expect(json['completedDate'], isNull);
    });
  });
}
