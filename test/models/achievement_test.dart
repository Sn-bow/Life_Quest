import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/models/achievement.dart';

void main() {
  group('AchievementProgress Model Tests', () {
    test('AchievementProgress initializes with defaults', () {
      final progress = AchievementProgress(achievementId: 'ac1');

      expect(progress.achievementId, 'ac1');
      expect(progress.currentValue, 0);
      expect(progress.isCompleted, false);
    });

    test('fromJson and toJson roundtrip works', () {
      final progress = AchievementProgress(
        achievementId: 'ac5',
        currentValue: 45,
        isCompleted: true,
      );

      final json = progress.toJson();
      final restored = AchievementProgress.fromJson(json);

      expect(restored.achievementId, 'ac5');
      expect(restored.currentValue, 45);
      expect(restored.isCompleted, true);
    });

    test('fromJson handles null fields with defaults', () {
      final json = <String, dynamic>{};
      final progress = AchievementProgress.fromJson(json);

      expect(progress.achievementId, '');
      expect(progress.currentValue, 0);
      expect(progress.isCompleted, false);
    });

    test('fromJson handles partial data', () {
      final json = <String, dynamic>{
        'achievementId': 'ac10',
        'currentValue': 100,
      };
      final progress = AchievementProgress.fromJson(json);

      expect(progress.achievementId, 'ac10');
      expect(progress.currentValue, 100);
      expect(progress.isCompleted, false);
    });
  });
}
