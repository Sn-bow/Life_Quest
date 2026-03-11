enum AchievementCondition {
  questCompleted,
  levelReached,
  strengthReached,
  wisdomReached,
  healthReached,
  charismaReached,
  skillsLearned,
  monstersKilled,
  goldEarned,
  streakReached,
}

enum RewardType { xp, statPoint }

class Achievement {
  final String id;
  final String name;
  final String description;
  final AchievementCondition condition;
  final int targetValue;
  final RewardType rewardType;
  final int rewardValue;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.condition,
    required this.targetValue,
    required this.rewardType,
    required this.rewardValue,
  });
}

class AchievementProgress {
  final String achievementId;
  int currentValue;
  bool isCompleted;

  AchievementProgress({
    required this.achievementId,
    this.currentValue = 0,
    this.isCompleted = false,
  });

  factory AchievementProgress.fromJson(Map<String, dynamic> json) {
    return AchievementProgress(
      achievementId: json['achievementId'] ?? '',
      currentValue: json['currentValue'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'achievementId': achievementId,
      'currentValue': currentValue,
      'isCompleted': isCompleted,
    };
  }
}
