import 'dart:async';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:life_quest_final_v2/models/character.dart';
import 'package:life_quest_final_v2/models/item.dart';
import 'package:life_quest_final_v2/models/quest.dart';
import 'package:life_quest_final_v2/models/title.dart';
import 'package:life_quest_final_v2/models/achievement.dart';
import 'package:life_quest_final_v2/models/skill.dart';
import 'package:life_quest_final_v2/models/custom_reward.dart';
import 'package:life_quest_final_v2/models/cosmetic.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/services/notification_service.dart';
import 'package:life_quest_final_v2/data/achievement_database.dart';
import 'package:life_quest_final_v2/data/title_database.dart';
import 'package:life_quest_final_v2/data/skill_database.dart';
import 'package:life_quest_final_v2/data/card_database.dart';
import 'package:life_quest_final_v2/models/card_data.dart';

enum StatType { strength, wisdom, health, charisma }

class QuestCompletionResult {
  final double totalXpAwarded;
  final int totalGoldAwarded;
  final int actionPointsAwarded;
  final int statPointsAwarded;
  final bool wasRaid;
  final int raidClearCount;
  final List<String> unlockedTitles;
  final List<String> unlockedCosmetics;

  const QuestCompletionResult({
    required this.totalXpAwarded,
    required this.totalGoldAwarded,
    required this.actionPointsAwarded,
    required this.statPointsAwarded,
    required this.wasRaid,
    required this.raidClearCount,
    this.unlockedTitles = const [],
    this.unlockedCosmetics = const [],
  });
}

class _RaidRewardOutcome {
  final double bonusXp;
  final int bonusGold;
  final int bonusActionPoints;
  final int bonusStatPoints;
  final int raidClearCount;
  final List<String> unlockedTitles;
  final List<String> unlockedCosmetics;

  const _RaidRewardOutcome({
    required this.bonusXp,
    required this.bonusGold,
    required this.bonusActionPoints,
    required this.bonusStatPoints,
    required this.raidClearCount,
    this.unlockedTitles = const [],
    this.unlockedCosmetics = const [],
  });
}

class CharacterState extends ChangeNotifier {
  static double xpRequiredForLevel(int level) => 100.0 + (level * 50.0);

  static List<CustomReward> _buildDefaultCustomRewards({String langCode = 'ko'}) {
    final Map<String, List<List<String>>> _strings = {
      'en': [
        ['Eat a tasty snack', 'Enjoy your favorite snack'],
        ['30 minutes of gaming', 'Play guilt-free for 30 minutes'],
        ['Watch a video or movie', 'Watch YouTube or Netflix for 1 hour'],
      ],
      'ja': [
        ['美味しいおやつを食べる', 'お気に入りのおやつを1つ楽しむ'],
        ['30分ゲームをする', '罪悪感なしで30分プレイする'],
        ['動画・映画を観る', 'YouTubeやNetflixを1時間見る'],
      ],
      'zh': [
        ['吃好吃的零食', '享用一份喜欢的零食'],
        ['玩30分钟游戏', '无愧疚地玩30分钟'],
        ['看想看的视频/电影', '看YouTube或Netflix一小时'],
      ],
      'ko': [
        ['맛있는 간식 먹기', '좋아하는 간식 1개 먹기'],
        ['게임 30분 하기', '죄책감 없이 30분 플레이하기'],
        ['보고싶던 영상/영화 시청', '유튜브나 넷플릭스 1시간 보기'],
      ],
    };
    final s = _strings[langCode] ?? _strings['ko']!;
    return [
      CustomReward(id: 'cr_1', name: s[0][0], description: s[0][1], cost: 50, icon: '🍪'),
      CustomReward(id: 'cr_2', name: s[1][0], description: s[1][1], cost: 100, icon: '🎮'),
      CustomReward(id: 'cr_3', name: s[2][0], description: s[2][1], cost: 150, icon: '🎬'),
    ];
  }
  /// For testing only: initialises a default Character without Firebase.
  @visibleForTesting
  void initializeForTesting() {
    _character = Character(
      name: 'Test',
      level: 1,
      title: '새싹 모험가',
      xp: 0,
      maxXp: 150,
      strength: 0,
      wisdom: 0,
      health: 0,
      charisma: 0,
      statPoints: 0,
      skillPoints: 0,
      customRewards: _buildDefaultCustomRewards(langCode: _locale?.languageCode ?? 'ko'),
    );
    _isDataLoaded = true;
    _isLoading = false;
  }

  /// Public method for external callers to trigger a UI rebuild.
  /// Use this instead of calling notifyListeners() from outside the class.
  void refreshState() {
    notifyListeners();
  }

  /// Forces saving current character data to Firebase and rebuilds UI
  Future<void> forceSave() async {
    await _performSaveData();
    notifyListeners();
  }

  /// Schedules a debounced save for direct character mutations initiated by UI.
  Future<void> scheduleSave() async {
    await _saveData();
  }

  Future<void> refreshTimeSensitiveState() async {
    if (_character == null || !_isDataLoaded || _isLoadingInProgress) return;

    final now = DateTime.now();
    final referenceTime = _character!.lastLoginDate ?? now;
    bool didChange = _resetQuestsIfNeeded(referenceTime, now: now);
    didChange = _applyHpRecovery(notify: false, now: now) || didChange;
    if (!didChange) return;

    await _performSaveData();
    notifyListeners();
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    _hpRegenTimer?.cancel();
    super.dispose();
  }

  /// Soul Deck 클리어 메시지 (BuildContext 없이 locale 기반 다국어)
  String _localizedSoulDeckClear() {
    switch (_locale?.languageCode) {
      case 'en':
        return 'Soul Deck Clear!';
      case 'ja':
        return 'ソウルデッククリア！';
      case 'zh':
        return '灵魂牌组通关！';
      default: // ko
        return 'Soul Deck 클리어!';
    }
  }

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  VoidCallback? onLevelUp;

  Character? _character;
  bool _isLoading = true;
  bool _isDataLoaded = false;
  bool _isLoadingInProgress = false;
  ThemeMode _themeMode = ThemeMode.dark;
  Locale? _locale;
  bool _hasSeenOnboarding = false;
  int _notificationMorningHour = 9;
  int _notificationNightHour = 20;
  bool _isNotificationEnabled = true;
  Timer? _saveTimer;
  Timer? _hpRegenTimer;
  bool _isCombatActive = false;
  bool _isSaving = false;
  bool _pendingSave = false;

  // 퀘스트 중복 완료 방지: 광고 시청 중 비동기 갭에서의 재진입 차단
  final Set<String> _pendingQuestIds = {};

  final FirebaseFirestore _firestore;

  CharacterState({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance {
    _initializeAchievementProgress();
  }

  final List<Achievement> _allAchievements = AchievementDatabase.all;
  late Map<String, AchievementProgress> _achievementProgress;
  final List<GameTitle> _allTitles = TitleDatabase.all;

  Set<String> _unlockedTitleIds = {'t0'};

  final List<Skill> _allSkills = SkillDatabase.all;

  Set<String> _learnedSkillIds = {};

  List<Quest> _dailyQuests = [];
  List<Quest> _weeklyQuests = [];
  List<Quest> _monthlyQuests = [];
  List<Quest> _yearlyQuests = [];
  // _customRewards moved to Character model

  Character get character => _character!;
  bool get isLoading => _isLoading;
  bool get isDataLoaded => _isDataLoaded;
  ThemeMode get themeMode => _themeMode;

  /// 퀘스트가 현재 처리 중(광고 시청 등 비동기)인지 확인
  bool isQuestPending(String questId) => _pendingQuestIds.contains(questId);

  /// 퀘스트를 처리 중 상태로 표시 (광고 시청 시작 시 호출)
  void markQuestPending(String questId) => _pendingQuestIds.add(questId);

  /// 퀘스트 처리 완료 후 상태 해제
  void clearQuestPending(String questId) => _pendingQuestIds.remove(questId);
  Locale? get locale => _locale;
  bool get hasSeenOnboarding => _hasSeenOnboarding;
  int get notificationMorningHour => _notificationMorningHour;
  int get notificationNightHour => _notificationNightHour;
  bool get isNotificationEnabled => _isNotificationEnabled;
  int get questCompletionCount =>
      _progressCountFor(AchievementCondition.questCompleted);
  bool get isExpandedReportUnlockedToday =>
      _character != null &&
      _character!.expandedReportUnlockedOn == _todayKey(DateTime.now());
  int get monthlyRaidClears => _character?.monthlyRaidClears ?? 0;
  int get yearlyRaidClears => _character?.yearlyRaidClears ?? 0;

  List<Quest> get dailyQuests => _dailyQuests;
  List<Quest> get weeklyQuests => _weeklyQuests;
  List<Quest> get monthlyQuests => _monthlyQuests;
  List<Quest> get yearlyQuests => _yearlyQuests;

  // build()에서 매번 정렬하지 않도록 정렬된 목록을 제공 (미완료 우선)
  static List<Quest> _sortedQuests(List<Quest> quests) => quests.isEmpty
      ? quests
      : (List<Quest>.from(quests)
        ..sort((a, b) {
          if (!a.isCompleted && b.isCompleted) return -1;
          if (a.isCompleted && !b.isCompleted) return 1;
          return 0;
        }));

  List<Quest> get sortedDailyQuests => _sortedQuests(_dailyQuests);
  List<Quest> get sortedWeeklyQuests => _sortedQuests(_weeklyQuests);
  List<Quest> get sortedMonthlyQuests => _sortedQuests(_monthlyQuests);
  List<Quest> get sortedYearlyQuests => _sortedQuests(_yearlyQuests);
  List<GameTitle> get unlockedTitles => _allTitles
      .where((title) => _unlockedTitleIds.contains(title.id))
      .toList();
  List<Achievement> get allAchievements => _allAchievements;
  Map<String, AchievementProgress> get achievementProgress =>
      _achievementProgress;
  List<Skill> get allSkills => _allSkills;
  Set<String> get learnedSkillIds => _learnedSkillIds;

  Map<StatType, double> get questCategoryDistribution {
    final Map<StatType, int> counts = {
      for (var type in StatType.values) type: 0
    };
    int totalCount = 0;

    final allQuests = [
      ..._dailyQuests,
      ..._weeklyQuests,
      ..._monthlyQuests,
      ..._yearlyQuests,
    ];
    for (final quest in allQuests) {
      if (quest.isCompleted) {
        counts[quest.category] = (counts[quest.category] ?? 0) + 1;
        totalCount++;
      }
    }

    if (totalCount == 0) {
      return {for (var type in StatType.values) type: 0.0};
    }

    return counts
        .map((key, value) => MapEntry(key, (value / totalCount) * 100));
  }

  Map<int, int> get weeklyCompletedQuests {
    final Map<int, int> weeklyData = {for (var i = 1; i <= 7; i++) i: 0};
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final allQuests = [
      ..._dailyQuests,
      ..._weeklyQuests,
      ..._monthlyQuests,
      ..._yearlyQuests,
    ];
    for (final quest in allQuests) {
      if (quest.isCompleted && quest.completedDate != null) {
        if (quest.completedDate!.isAfter(startOfWeek) ||
            quest.completedDate!.isAtSameMomentAs(startOfWeek)) {
          weeklyData[quest.completedDate!.weekday] =
              (weeklyData[quest.completedDate!.weekday] ?? 0) + 1;
        }
      }
    }
    return weeklyData;
  }

  Map<StatType, double> get currentLevelGrowthDistribution {
    if (_character == null) {
      return {for (var type in StatType.values) type: 0.0};
    }

    final weights = {
      for (final type in StatType.values)
        type: _character!.levelGrowthWeights[type.name] ?? 0.0,
    };
    final total =
        weights.values.fold<double>(0, (runningTotal, value) => runningTotal + value);

    if (total <= 0) {
      return {for (var type in StatType.values) type: 0.0};
    }

    return weights.map((key, value) => MapEntry(key, (value / total) * 100));
  }

  Map<StatType, int> get lastLevelAutoAllocation {
    if (_character == null) {
      return {for (var type in StatType.values) type: 0};
    }

    return {
      for (final type in StatType.values)
        type: _character!.lastLevelAutoGrowth[type.name] ?? 0,
    };
  }

  StatType? get dominantGrowthCategory {
    final distribution = currentLevelGrowthDistribution;
    StatType? bestType;
    double bestValue = 0;

    for (final entry in distribution.entries) {
      if (entry.value > bestValue) {
        bestValue = entry.value;
        bestType = entry.key;
      }
    }

    return bestValue > 0 ? bestType : null;
  }

  void resetState() {
    _saveTimer?.cancel();
    _hpRegenTimer?.cancel();
    _character = null;
    _isLoading = true;
    _isDataLoaded = false;
    _isLoadingInProgress = false;
    _themeMode = ThemeMode.dark;
    _locale = null;
    _hasSeenOnboarding = false;
    _notificationMorningHour = 9;
    _notificationNightHour = 20;
    _isNotificationEnabled = true;
    _isCombatActive = false;
    _dailyQuests = [];
    _weeklyQuests = [];
    _monthlyQuests = [];
    _yearlyQuests = [];
    _unlockedTitleIds = {'t0'};
    _learnedSkillIds = {};
    _initializeAchievementProgress();
    NotificationService().cancelAllNotifications().catchError((e) {
      debugPrint('Notification cancel error (non-fatal): $e');
    });
  }

  Future<void> changeThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _saveData();
    notifyListeners();
  }

  Future<void> changeLocale(Locale? newLocale) async {
    _locale = newLocale;
    await _saveData();
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _hasSeenOnboarding = true;
    await _saveData();
    notifyListeners();
  }

  Future<void> changeNotificationTime({
    required int morningHour,
    required int nightHour,
  }) async {
    _notificationMorningHour = morningHour;
    _notificationNightHour = nightHour;
    try {
      await _syncNotificationSchedule();
    } catch (e) {
      debugPrint('Notification reschedule error (non-fatal): $e');
    }
    await _saveData();
    notifyListeners();
  }

  Future<void> changeNotificationSetting(bool isEnabled) async {
    _isNotificationEnabled = isEnabled;
    try {
      await _syncNotificationSchedule();
    } catch (e) {
      debugPrint('Notification schedule error (non-fatal): $e');
    }
    await _saveData();
    notifyListeners();
  }

  Future<void> _syncNotificationSchedule() async {
    if (_isNotificationEnabled) {
      final langCode = _locale?.languageCode; // M-5: 앱 언어 설정 반영
      await NotificationService().scheduleDailyNotification(
        hour: _notificationMorningHour,
        languageCode: langCode,
      );
      await NotificationService().scheduleNightReminder(
        hour: _notificationNightHour,
        languageCode: langCode,
      );
    } else {
      await NotificationService().cancelAllNotifications();
    }
  }

  Future<void> deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _saveTimer?.cancel();

    try {
      await _firestore.collection('users').doc(user.uid).delete();
      await user.delete();
    } catch (e) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                  child: Text('회원 탈퇴 중 오류가 발생했습니다. 다시 로그인 후 시도해주세요.',
                      style: TextStyle(color: Colors.white))),
            ],
          ),
          backgroundColor: Colors.red.shade800,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
    }
  }

  Future<void> changeCharacterName(String newName) async {
    if (_character == null) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await user.updateDisplayName(newName);
    _character!.name = newName;
    await _saveData();
    notifyListeners();
  }

  void changeTitle(GameTitle newTitle) {
    if (_unlockedTitleIds.contains(newTitle.id)) {
      _character!.title = newTitle.name;
      unawaited(_saveData());
      notifyListeners();
    }
  }

  QuestCompletionResult? completeQuest(Quest quest, {double xpMultiplier = 1.0}) {
    if (!quest.isCompleted) {
      quest.isCompleted = true;
      quest.completedDate = DateTime.now();
      _recordGrowthContribution(quest);
      double statBonusRate = 0;
      double statValue = 0;
      switch (quest.category) {
        case StatType.strength:
          statValue = _character!.strength;
          break;
        case StatType.wisdom:
          statValue = _character!.wisdom;
          break;
        case StatType.health:
          statValue = _character!.health;
          break;
        case StatType.charisma:
          statValue = _character!.charisma;
          break;
      }
      statBonusRate = (statValue / 10) * 0.05;
      if (statBonusRate > 0.5) statBonusRate = 0.5;
      double titleBonusRate = 0;
      final currentTitle = _allTitles.firstWhere(
        (t) => t.name == _character!.title,
        orElse: () => _allTitles.first,
      );
      if (currentTitle.bonusType == quest.category) {
        titleBonusRate = currentTitle.bonusValue ?? 0;
      }
      double skillBonusRate = 0;
      for (var skillId in _learnedSkillIds) {
        final idx = _allSkills.indexWhere((s) => s.id == skillId);
        if (idx == -1) continue;
        final skill = _allSkills[idx];
        if (skill.effectType == SkillEffectType.xpBoost) {
          if (skill.effectTarget == null ||
              skill.effectTarget == quest.category) {
            skillBonusRate += skill.effectValue;
          }
        }
      }
      double totalBonusRate = statBonusRate + titleBonusRate + skillBonusRate;
      // Streak bonus: +10% XP per consecutive day (max 50%)
      double streakBonusRate = (_character!.streak * 0.10).clamp(0.0, 0.50);
      totalBonusRate += streakBonusRate;

      // Calculate XP with 2x ad multiplier applied to the base+bonus
      double bonusXp = quest.xp * totalBonusRate;
      double totalXp = (quest.xp + bonusXp) * xpMultiplier;
      _character!.xp += totalXp;

      // RPG Element: Gain Action Points (AP) based on Quest Base XP
      int gainedAp = (quest.xp / 10).round();
      if (gainedAp < 1) gainedAp = 1;
      _character!.actionPoints += gainedAp;
      if (_character!.actionPoints > _character!.maxActionPoints) {
        _character!.actionPoints = _character!.maxActionPoints;
      }
      SoundService().playQuestComplete();

      // Quest gold reward: 50% of base XP (min 1). Also affected by 2x ad.
      int goldReward = (quest.xp * 0.5 * xpMultiplier).round();
      if (goldReward < 1) goldReward = 1;
      _character!.gold += goldReward;

      int totalGoldReward = goldReward;
      int totalApReward = gainedAp;
      int totalStatPointReward = 0;
      int raidClearCount = 0;
      final unlockedTitleNames = <String>[];
      final unlockedCosmeticNames = <String>[];

      if (quest.type == QuestType.monthly || quest.type == QuestType.yearly) {
        final raidReward = _applyRaidRewards(quest, xpMultiplier);
        totalXp += raidReward.bonusXp;
        totalGoldReward += raidReward.bonusGold;
        totalApReward += raidReward.bonusActionPoints;
        totalStatPointReward += raidReward.bonusStatPoints;
        raidClearCount = raidReward.raidClearCount;
        unlockedTitleNames.addAll(raidReward.unlockedTitles);
        unlockedCosmeticNames.addAll(raidReward.unlockedCosmetics);
      }

      while (_character!.xp >= _character!.maxXp) {
        _levelUp();
      }
      unlockedTitleNames.addAll(_checkTitleUnlock());
      _updateAchievement(AchievementCondition.questCompleted, 1);
      final unlockedCardName = _tryUnlockRandomCard();
      if (unlockedCardName != null) {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(
              '카드 획득: $unlockedCardName!',
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF00FFFF),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.only(bottom: 70, left: 16, right: 16),
          ),
        );
      }
      unawaited(_saveData());
      notifyListeners();
      return QuestCompletionResult(
        totalXpAwarded: totalXp,
        totalGoldAwarded: totalGoldReward,
        actionPointsAwarded: totalApReward,
        statPointsAwarded: totalStatPointReward,
        wasRaid: quest.type == QuestType.monthly || quest.type == QuestType.yearly,
        raidClearCount: raidClearCount,
        unlockedTitles: unlockedTitleNames.toSet().toList(),
        unlockedCosmetics: unlockedCosmeticNames.toSet().toList(),
      );
    }
    return null;
  }

  void deleteQuest(Quest quest) {
    _dailyQuests.removeWhere((q) => q.id == quest.id);
    _weeklyQuests.removeWhere((q) => q.id == quest.id);
    _monthlyQuests.removeWhere((q) => q.id == quest.id);
    _yearlyQuests.removeWhere((q) => q.id == quest.id);
    unawaited(_saveData());
    notifyListeners();
  }

  void addQuest(String name, int xp, QuestType type, StatType category,
      {QuestDifficulty difficulty = QuestDifficulty.normal}) {
    final newQuest = Quest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      xp: xp,
      type: type,
      category: category,
      difficulty: difficulty,
    );
    switch (type) {
      case QuestType.daily:
        _dailyQuests.add(newQuest);
        break;
      case QuestType.weekly:
        _weeklyQuests.add(newQuest);
        break;
      case QuestType.monthly:
        _monthlyQuests.add(newQuest);
        break;
      case QuestType.yearly:
        _yearlyQuests.add(newQuest);
        break;
    }
    unawaited(_saveData());
    notifyListeners();
  }

  void editQuest(Quest quest, String newName, int newXp, StatType newCategory) {
    quest.name = newName;
    quest.xp = newXp;
    quest.category = newCategory;
    unawaited(_saveData());
    notifyListeners();
  }

  _RaidRewardOutcome _applyRaidRewards(Quest quest, double xpMultiplier) {
    final unlockedCosmeticNames = <String>[];
    final unlockedTitleNames = <String>[];
    double bonusXp = 0;
    int bonusGold = 0;
    int bonusActionPoints = 0;
    int bonusStatPoints = 0;
    int raidClearCount = 0;

    if (quest.type == QuestType.monthly) {
      _character!.monthlyRaidClears += 1;
      raidClearCount = _character!.monthlyRaidClears;
      bonusXp = (quest.xp * 0.35 * xpMultiplier).roundToDouble();
      bonusGold = (quest.xp * 0.75 * xpMultiplier).round().clamp(10, 999999);
      bonusActionPoints = 2;
      bonusStatPoints = 1;
      if (raidClearCount == 1) {
        final unlocked = _unlockCosmeticForReward('title_effect_sparkle');
        if (unlocked != null) unlockedCosmeticNames.add(unlocked);
      }
      if (raidClearCount == 3) {
        final unlocked = _unlockCosmeticForReward('theme_neon_cyberpunk');
        if (unlocked != null) unlockedCosmeticNames.add(unlocked);
      }
    } else if (quest.type == QuestType.yearly) {
      _character!.yearlyRaidClears += 1;
      raidClearCount = _character!.yearlyRaidClears;
      bonusXp = (quest.xp * 0.6 * xpMultiplier).roundToDouble();
      bonusGold = (quest.xp * 1.2 * xpMultiplier).round().clamp(20, 999999);
      bonusActionPoints = 4;
      bonusStatPoints = 2;
      if (raidClearCount == 1) {
        final unlocked = _unlockCosmeticForReward('combat_effect_lightning');
        if (unlocked != null) unlockedCosmeticNames.add(unlocked);
      }
      if (raidClearCount == 2) {
        final unlocked = _unlockCosmeticForReward('theme_royal_gold');
        if (unlocked != null) unlockedCosmeticNames.add(unlocked);
      }
    }

    _character!.xp += bonusXp;
    _character!.gold += bonusGold;
    _character!.actionPoints =
        (_character!.actionPoints + bonusActionPoints).clamp(0, _character!.maxActionPoints);
    _character!.statPoints += bonusStatPoints;
    unlockedTitleNames.addAll(_checkTitleUnlock());

    return _RaidRewardOutcome(
      bonusXp: bonusXp,
      bonusGold: bonusGold,
      bonusActionPoints: bonusActionPoints,
      bonusStatPoints: bonusStatPoints,
      raidClearCount: raidClearCount,
      unlockedTitles: unlockedTitleNames,
      unlockedCosmetics: unlockedCosmeticNames,
    );
  }

  String? _unlockCosmeticForReward(String id) {
    if (_character == null || _character!.unlockedCosmetics.contains(id)) {
      return null;
    }
    _character!.unlockedCosmetics.add(id);
    final item = CosmeticDatabase.getById(id);
    if (item != null) {
      if (item.category == CosmeticCategory.theme &&
          _character!.equippedTheme == null) {
        _character!.equippedTheme = id;
      } else if (item.category == CosmeticCategory.titleEffect &&
          _character!.equippedTitleEffect == null) {
        _character!.equippedTitleEffect = id;
      } else if (item.category == CosmeticCategory.combatEffect &&
          _character!.equippedCombatEffect == null) {
        _character!.equippedCombatEffect = id;
      }
      return item.name;
    }
    return id;
  }

  /// Properly apply combat rewards (XP + loot) with full level-up pipeline.
  /// This replaces any inline level-up code in the UI layer.
  void addCombatReward(int xp, EquipmentItem? loot, {int gold = 0}) {
    _character!.xp += xp;
    if (gold > 0) _character!.gold += gold;
    if (loot != null) {
      _character!.inventory.add(loot);
    }
    while (_character!.xp >= _character!.maxXp) {
      _levelUp();
    }
    _checkTitleUnlock();
    _updateAchievement(AchievementCondition.monstersKilled, 1);
    unawaited(_saveData());
    notifyListeners();
  }

  void addTimerReward(int xp, int gold) {
    _character!.xp += xp;
    _character!.gold += gold;
    while (_character!.xp >= _character!.maxXp) {
      _levelUp();
    }
    _checkTitleUnlock();
    unawaited(_saveData());
    notifyListeners();
  }

  /// Apply dungeon run rewards (XP + gold) with full level-up pipeline.
  void addDungeonReward(int xp, int gold) {
    _character!.xp += xp;
    _character!.gold += gold;
    while (_character!.xp >= _character!.maxXp) {
      _levelUp();
    }
    _checkTitleUnlock();
    unawaited(_saveData());
    notifyListeners();
  }

  void _levelUp() {
    _character!.xp -= _character!.maxXp;
    _character!.level++;
    // Linear-polynomial hybrid scaling to prevent exponential mid-game halt
    _character!.maxXp = xpRequiredForLevel(_character!.level);

    final autoGrowthAllocation = _applyAutomaticGrowthOnLevelUp();
    final autoGrowthPoints = autoGrowthAllocation.values
        .fold<int>(0, (runningTotal, value) => runningTotal + value);

    // Dynamically sum all learned spBonusOnLevelUp skills
    int baseSP = 5;
    int bonusSP = 0;
    for (final skillId in _learnedSkillIds) {
      final idx = _allSkills.indexWhere((s) => s.id == skillId);
      if (idx == -1) continue;
      final skill = _allSkills[idx];
      if (skill.effectType == SkillEffectType.spBonusOnLevelUp) {
        bonusSP += skill.effectValue.toInt();
      }
    }
    _character!.statPoints += (baseSP - autoGrowthPoints + bonusSP);
    if (_character!.level % 2 == 0) {
      _character!.skillPoints += 1;
    }
    SoundService().playLevelUp();
    HapticFeedback.heavyImpact(); // 레벨업 강한 진동
    onLevelUp?.call();
    _checkTitleUnlock();
    _updateAchievement(AchievementCondition.levelReached, _character!.level);
  }

  void spendStatPoint(StatType stat) {
    if (_character!.statPoints > 0) {
      // Dynamically find highest statBoostEfficiency skill
      int statIncrease = 1;
      for (final skillId in _learnedSkillIds) {
        final idx = _allSkills.indexWhere((s) => s.id == skillId);
        if (idx == -1) continue;
        final skill = _allSkills[idx];
        if (skill.effectType == SkillEffectType.statBoostEfficiency) {
          final v = skill.effectValue.toInt();
          if (v > statIncrease) statIncrease = v;
        }
      }
      switch (stat) {
        case StatType.strength:
          _character!.strength += statIncrease;
          _updateAchievement(AchievementCondition.strengthReached,
              _character!.strength.toInt());
          break;
        case StatType.wisdom:
          _character!.wisdom += statIncrease;
          _updateAchievement(
              AchievementCondition.wisdomReached, _character!.wisdom.toInt());
          break;
        case StatType.health:
          _character!.health += statIncrease;
          _updateAchievement(
              AchievementCondition.healthReached, _character!.health.toInt());
          break;
        case StatType.charisma:
          _character!.charisma += statIncrease;
          _updateAchievement(AchievementCondition.charismaReached,
              _character!.charisma.toInt());
          break;
      }
      _character!.statPoints--;
      _checkTitleUnlock();
      unawaited(_saveData());
      notifyListeners();
    }
  }

  List<String> _checkTitleUnlock() {
    final questsCompleted = questCompletionCount;
    final unlockedTitles = <String>[];

    for (final title in _allTitles) {
      if (_unlockedTitleIds.contains(title.id)) continue;
      bool unlocked = false;
      switch (title.conditionType) {
        case TitleConditionType.level:
          if (_character!.level >= title.conditionValue) unlocked = true;
          break;
        case TitleConditionType.strength:
          if (_character!.strength >= title.conditionValue) unlocked = true;
          break;
        case TitleConditionType.wisdom:
          if (_character!.wisdom >= title.conditionValue) unlocked = true;
          break;
        case TitleConditionType.health:
          if (_character!.health >= title.conditionValue) unlocked = true;
          break;
        case TitleConditionType.charisma:
          if (_character!.charisma >= title.conditionValue) unlocked = true;
          break;
        case TitleConditionType.questsCompleted:
          if (questsCompleted >= title.conditionValue) unlocked = true;
          break;
        case TitleConditionType.monthlyRaidClears:
          if (_character!.monthlyRaidClears >= title.conditionValue) {
            unlocked = true;
          }
          break;
        case TitleConditionType.yearlyRaidClears:
          if (_character!.yearlyRaidClears >= title.conditionValue) {
            unlocked = true;
          }
          break;
        case TitleConditionType.allStats:
          if (_character!.strength >= title.conditionValue &&
              _character!.wisdom >= title.conditionValue &&
              _character!.health >= title.conditionValue &&
              _character!.charisma >= title.conditionValue) {
            unlocked = true;
          }
          break;
      }
      if (unlocked) {
        _unlockedTitleIds.add(title.id);
        unlockedTitles.add(title.name);
      }
    }
    return unlockedTitles;
  }

  void _updateAchievement(AchievementCondition condition, int value) {
    final relevantAchievements =
        _allAchievements.where((ach) => ach.condition == condition);
    for (final achievement in relevantAchievements) {
      final progress = _achievementProgress[achievement.id];
      if (progress == null || progress.isCompleted) continue;
      if (condition == AchievementCondition.questCompleted ||
          condition == AchievementCondition.skillsLearned) {
        progress.currentValue += value;
      } else {
        progress.currentValue = value;
      }
      if (progress.currentValue >= achievement.targetValue) {
        progress.isCompleted = true;
        String rewardText = '';
        if (achievement.rewardType == RewardType.xp) {
          _character!.xp += achievement.rewardValue;
          rewardText = 'XP +${achievement.rewardValue}';
          while (_character!.xp >= _character!.maxXp) {
            _levelUp();
          }
          _checkTitleUnlock();
        } else if (achievement.rewardType == RewardType.statPoint) {
          _character!.statPoints += achievement.rewardValue;
          rewardText = 'SP +${achievement.rewardValue}';
        }
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(
              '🎉 업적 달성: ${achievement.name} (보상: $rewardText)',
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF00FFFF),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 70, left: 16, right: 16),
          ),
        );
        unawaited(_saveData());
      }
    }
  }

  void learnSkill(Skill skill) {
    if (canLearnSkill(skill)) {
      _character!.skillPoints--;
      _learnedSkillIds.add(skill.id);
      _updateAchievement(AchievementCondition.skillsLearned, 1);
      unawaited(_saveData());
      notifyListeners();
    }
  }

  bool canLearnSkill(Skill skill) {
    if (_character!.skillPoints < 1) return false;
    if (_learnedSkillIds.contains(skill.id)) return false;
    if (_character!.level < skill.requiredLevel) return false;
    if (skill.requiredStatType != null && skill.requiredStatValue != null) {
      double statValue = 0;
      switch (skill.requiredStatType!) {
        case StatType.strength:
          statValue = _character!.strength;
          break;
        case StatType.wisdom:
          statValue = _character!.wisdom;
          break;
        case StatType.health:
          statValue = _character!.health;
          break;
        case StatType.charisma:
          statValue = _character!.charisma;
          break;
      }
      if (statValue < skill.requiredStatValue!) return false;
    }
    return true;
  }

  // ─────────────────────────────────────────────
  // Ascension & Infinite Tower
  // ─────────────────────────────────────────────

  /// The set of zone numbers the player has cleared (1-5).
  Set<int> get completedZones => _character?.completedZones ?? {};

  /// Whether the player has cleared Zone 5 (unlocks Ascension & Infinite Tower).
  bool get hasCompletedZone5 => completedZones.contains(5);

  /// The player's highest Infinite Tower floor reached.
  int get infiniteTowerFloor => _character?.infiniteTowerFloor ?? 1;

  /// Record a zone completion. Shows a special banner if Zone 5 is newly cleared.
  Future<void> completeZone(int zone) async {
    if (_character == null) return;
    final isNew = !_character!.completedZones.contains(zone);
    _character!.completedZones.add(zone);

    if (isNew && zone == 5) {
      final clearMsg = _localizedSoulDeckClear();
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Text('🏆', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                clearMsg,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF6A1B9A),
          duration: const Duration(seconds: 4),
        ),
      );
    }

    unawaited(_saveData());
    notifyListeners();
  }

  /// Update the player's highest Infinite Tower floor if the new value is higher.
  Future<void> updateInfiniteTowerFloor(int floor) async {
    if (_character == null) return;
    if (floor > _character!.infiniteTowerFloor) {
      _character!.infiniteTowerFloor = floor;
      unawaited(_saveData());
      notifyListeners();
    }
  }

  // ─────────────────────────────────────────────
  // Card Collection
  // ─────────────────────────────────────────────

  /// All cards the player has unlocked, looked up from CardDatabase.
  List<CardData> get unlockedCards {
    if (_character == null) return [];
    return _character!.unlockedCardIds
        .map((id) => CardDatabase.getCard(id))
        .whereType<CardData>()
        .toList();
  }

  /// The custom starter deck built from saved card IDs.
  /// Falls back to CardDatabase.starterDeck when the player has no custom deck.
  List<CardData> get starterDeck {
    if (_character == null || _character!.starterDeckCardIds.isEmpty) {
      return CardDatabase.starterDeck;
    }
    return _character!.starterDeckCardIds
        .map((id) => CardDatabase.getCard(id))
        .whereType<CardData>()
        .toList();
  }

  /// Add a card to the player's collection (no-op if already owned).
  void unlockCard(String cardId) {
    if (_character == null) return;
    if (!_character!.unlockedCardIds.contains(cardId)) {
      _character!.unlockedCardIds.add(cardId);
      unawaited(_saveData());
      notifyListeners();
    }
  }

  /// Add a card to the custom starter deck.
  /// Max 20 total cards, max 3 copies of the same card.
  void addCardToStarterDeck(String cardId) {
    if (_character == null) return;
    final deck = _character!.starterDeckCardIds;
    if (deck.length >= 20) return;
    final copyCount = deck.where((id) => id == cardId).length;
    if (copyCount >= 3) return;
    deck.add(cardId);
    unawaited(_saveData());
    notifyListeners();
  }

  /// Remove a card from the custom starter deck by index.
  void removeCardFromStarterDeck(int index) {
    if (_character == null) return;
    final deck = _character!.starterDeckCardIds;
    if (index < 0 || index >= deck.length) return;
    deck.removeAt(index);
    unawaited(_saveData());
    notifyListeners();
  }

  /// Reset the custom starter deck to the default (empty = use CardDatabase.starterDeck).
  void resetStarterDeck() {
    if (_character == null) return;
    _character!.starterDeckCardIds.clear();
    unawaited(_saveData());
    notifyListeners();
  }

  /// Rolls for a random card unlock on quest completion.
  /// 30% Common, 10% Uncommon, 5% Rare. Returns the card name if a new card
  /// was unlocked, or null if no card was awarded or all matching cards are
  /// already owned.
  String? _tryUnlockRandomCard() {
    if (_character == null) return null;
    final roll = math.Random().nextDouble();
    CardRarity? rarity;
    if (roll < 0.05) {
      rarity = CardRarity.rare;
    } else if (roll < 0.15) {
      rarity = CardRarity.uncommon;
    } else if (roll < 0.45) {
      rarity = CardRarity.common;
    }
    if (rarity == null) return null;

    final pool = CardDatabase.getCardsByRarity(rarity)
        .where((c) => !_character!.unlockedCardIds.contains(c.id))
        .toList();
    if (pool.isEmpty) return null;

    final card = pool[math.Random().nextInt(pool.length)];
    _character!.unlockedCardIds.add(card.id);
    return card.name;
  }

  /// Called once for new players (or existing players with no unlocked cards)
  /// to give them the 10 default starter cards.
  void _initStarterCards() {
    if (_character == null) return;
    for (final card in CardDatabase.starterDeck) {
      if (!_character!.unlockedCardIds.contains(card.id)) {
        _character!.unlockedCardIds.add(card.id);
      }
    }
  }

  // Schedules _performSaveData() after a 3-second delay, cancelling any pending save.
  // Note: _saveData uses debounce timer - callers don't need to await
  Future<void> _saveData() async {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 3), () {
      _performSaveData();
    });
  }

  // The actual database write operation, wrapped in try-catch.
  // Uses _isSaving/_pendingSave to prevent concurrent writes while ensuring
  // the latest data is always saved (race condition prevention).
  Future<void> _performSaveData() async {
    if (_character == null) return;
    // m-2: gold 음수 방지 — 어떤 경로로든 음수가 됐을 때 저장 직전에 클램프
    if (_character!.gold < 0) _character!.gold = 0;
    if (_isSaving) {
      // 이미 저장 중이면 대기열에 추가하고 반환
      _pendingSave = true;
      return;
    }
    _isSaving = true;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final lastLoginDate = _character!.lastLoginDate;
      final docRef = _firestore.collection('users').doc(user.uid);
      final data = {
        'character': _character!.toJson(),
        'dailyQuests': _dailyQuests.map((q) => q.toJson()).toList(),
        'weeklyQuests': _weeklyQuests.map((q) => q.toJson()).toList(),
        'monthlyQuests': _monthlyQuests.map((q) => q.toJson()).toList(),
        'yearlyQuests': _yearlyQuests.map((q) => q.toJson()).toList(),
        'unlockedTitleIds': _unlockedTitleIds.toList(),
        'learnedSkillIds': _learnedSkillIds.toList(),
        'achievementProgress':
            _achievementProgress.map((k, v) => MapEntry(k, v.toJson())),
        'themeMode': _themeMode.index,
        'localeCode': _locale?.languageCode,
        'hasSeenOnboarding': _hasSeenOnboarding,
        'notificationMorningHour': _notificationMorningHour,
        'notificationNightHour': _notificationNightHour,
        'isNotificationEnabled': _isNotificationEnabled,
        'lastLoginDate': lastLoginDate?.toIso8601String(),
      };
      await docRef.set(data, SetOptions(merge: true));

      // Update Home Widget data for iOS/Android
      await HomeWidget.saveWidgetData<String>(
          'characterName', _character!.name);
      await HomeWidget.saveWidgetData<int>('characterLevel', _character!.level);
      await HomeWidget.saveWidgetData<int>(
          'characterHp', _character!.characterHp);
      await HomeWidget.saveWidgetData<int>(
          'characterMaxHp', _character!.characterMaxHp);
      await HomeWidget.updateWidget(
        iOSName: 'LifeQuestWidget',
        androidName: 'LifeQuestWidgetReceiver',
      );
    } catch (e) {
      debugPrint('Save data error: $e');
      scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('클라우드 서버 저장 실패. 네트워크 상태를 확인해주세요.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      _isSaving = false;
      // 저장 중에 새로운 변경이 있었으면 최신 데이터로 다시 저장
      if (_pendingSave) {
        _pendingSave = false;
        await _performSaveData();
      }
    }
  }

  Future<void> loadDataForUser(User user) async {
    if (_isLoadingInProgress) return;
    _isLoadingInProgress = true;
    _isLoading = true;
    _isDataLoaded = false;

    try {
      await user.reload();
      final freshUser = FirebaseAuth.instance.currentUser;
      if (freshUser == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      final docRef = _firestore.collection('users').doc(freshUser.uid);
      var doc = await docRef.get().timeout(const Duration(seconds: 10));

      int retries = 0;
      while (!doc.exists && retries < 5) {
        await Future.delayed(const Duration(milliseconds: 500));
        doc = await docRef.get().timeout(const Duration(seconds: 10));
        retries++;
      }

      if (doc.exists) {
        final data = doc.data()!;
        bool needsSave = false;

        _character = Character.fromJson(
          Map<String, dynamic>.from(data['character'] as Map),
        );
        _character!.lastHpRegenAt ??= DateTime.now();
        final expectedMaxXp = xpRequiredForLevel(_character!.level);
        if (_character!.maxXp != expectedMaxXp) {
          _character!.maxXp = expectedMaxXp;
          needsSave = true;
        }
        // Title name migration: if stored title doesn't exist in TitleDatabase
        // (e.g. was saved in a different locale), reset to the Korean name for t0.
        final titleExists =
            _allTitles.any((t) => t.name == _character!.title);
        if (!titleExists) {
          _character!.title = _allTitles.first.name; // '새싹 모험가'
          needsSave = true;
        }

        _dailyQuests = (data['dailyQuests'] as List<dynamic>? ?? [])
            .map((q) => Quest.fromJson(Map<String, dynamic>.from(q as Map)))
            .toList();
        _weeklyQuests = (data['weeklyQuests'] as List<dynamic>? ?? [])
            .map((q) => Quest.fromJson(Map<String, dynamic>.from(q as Map)))
            .toList();
        _monthlyQuests = (data['monthlyQuests'] as List<dynamic>? ?? [])
            .map((q) => Quest.fromJson(Map<String, dynamic>.from(q as Map)))
            .toList();
        _yearlyQuests = (data['yearlyQuests'] as List<dynamic>? ?? [])
            .map((q) => Quest.fromJson(Map<String, dynamic>.from(q as Map)))
            .toList();
        if (!data.containsKey('monthlyQuests')) {
          _monthlyQuests = [
            Quest(
              id: 'm1',
              name: '이번 달 운동 12회 달성',
              xp: 140,
              type: QuestType.monthly,
              category: StatType.health,
              difficulty: QuestDifficulty.hard,
            ),
            Quest(
              id: 'm2',
              name: '사이드 프로젝트 핵심 기능 완성',
              xp: 200,
              type: QuestType.monthly,
              category: StatType.wisdom,
              difficulty: QuestDifficulty.veryHard,
            ),
          ];
          needsSave = true;
        }
        if (!data.containsKey('yearlyQuests')) {
          _yearlyQuests = [
            Quest(
              id: 'y1',
              name: '올해 대표 목표 하나 완수하기',
              xp: 280,
              type: QuestType.yearly,
              category: StatType.charisma,
              difficulty: QuestDifficulty.veryHard,
            ),
          ];
          needsSave = true;
        }
        _unlockedTitleIds = (data['unlockedTitleIds'] as List<dynamic>? ?? ['t0'])
            .map((id) => id.toString())
            .toSet();
        _learnedSkillIds = (data['learnedSkillIds'] as List<dynamic>? ?? [])
            .map((id) => id.toString())
            .toSet();

        _hydrateAchievementProgress(data['achievementProgress']);
        if (data['achievementProgress'] is! Map ||
            (data['achievementProgress'] as Map).isEmpty) {
          needsSave = true;
        }

        // Give starter cards to players who have none yet (migration / new players)
        if (_character!.unlockedCardIds.isEmpty) {
          _initStarterCards();
          needsSave = true;
        }

        if (_character!.customRewards.isEmpty && data.containsKey('customRewards') && data['customRewards'] is List) {
          _character!.customRewards = (data['customRewards'] as List<dynamic>)
              .whereType<Map>()
              .map((reward) => CustomReward.fromJson(Map<String, dynamic>.from(reward)))
              .toList();
          needsSave = true;
        } else if (_character!.customRewards.isEmpty) {
          _character!.customRewards = _buildDefaultCustomRewards(langCode: _locale?.languageCode ?? 'ko');
          needsSave = true;
        }

        _themeMode =
            ThemeMode.values[data['themeMode'] ?? ThemeMode.dark.index];
        final savedLocaleCode = data['localeCode'] as String?;
        _locale = (savedLocaleCode != null &&
                const {'ko', 'en', 'ja', 'zh'}.contains(savedLocaleCode))
            ? Locale(savedLocaleCode)
            : null;
        _hasSeenOnboarding = data['hasSeenOnboarding'] ?? false;
        _notificationMorningHour = data['notificationMorningHour'] ?? 9;
        _notificationNightHour = data['notificationNightHour'] ?? 20;
        _isNotificationEnabled = data['isNotificationEnabled'] ?? true;
        try {
          await _syncNotificationSchedule();
        } catch (e) {
          debugPrint('Notification schedule error (non-fatal): $e');
        }

        final lastLogin = _parseLastLoginDate(data);
        if (lastLogin != null) {
          _character!.lastLoginDate = lastLogin;
          if (_resetQuestsIfNeeded(lastLogin)) {
            needsSave = true;
          }
        } else {
          _character!.lastLoginDate = DateTime.now();
          needsSave = true;
        }

        if (_applyHpRecovery(notify: false)) {
          needsSave = true;
        }

        if (needsSave) {
          await _performSaveData();
        }

        _isDataLoaded = true;
        _startHpRegenLoop();
      } else {
        _initializeNewData(freshUser);
        try {
          await _syncNotificationSchedule();
        } catch (e) {
          debugPrint('Notification schedule error (non-fatal): $e');
        }
        // Save initial data immediately instead of debouncing
        await _performSaveData();
        _isDataLoaded = true;
        _startHpRegenLoop();
      }
    } catch (e) {
      debugPrint('Load data error: $e');
      scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('클라우드 데이터 불러오기 실패. 네트워크를 잠시 후 다시 확인해주세요.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
      // In worst case, initialize dummy data but don't save to DB
      // so we don't overwrite user's actual progress in cloud with level 1.
      if (_character == null) {
        _initializeNewData(user);
        _isDataLoaded = true;
        _startHpRegenLoop();
      }
    } finally {
      _isLoading = false;
      _isLoadingInProgress = false;
      notifyListeners();
    }
  }

  bool _resetQuestsIfNeeded(DateTime lastLogin, {DateTime? now}) {
    bool didChange = false;
    final currentTime = now ?? DateTime.now();
    final today = DateTime(currentTime.year, currentTime.month, currentTime.day);
    final lastDay = DateTime(lastLogin.year, lastLogin.month, lastLogin.day);
    final isNewDay = today.isAfter(lastDay);

    if (isNewDay) {
      didChange = true;
      // --- Penalty: HP damage for incomplete daily quests ---
      int incompleteDailyCount = 0;
      bool allDailiesCompleted = _dailyQuests.isNotEmpty;
      for (var quest in _dailyQuests) {
        if (!quest.isCompleted) {
          incompleteDailyCount++;
          allDailiesCompleted = false;
        }
      }

      if (incompleteDailyCount > 0) {
        int damage = incompleteDailyCount * 10;
        _character!.characterHp -= damage;
        // Streak breaks if any daily was missed
        _character!.streak = 0;

        // Death penalty: if HP drops to 0 or below
        if (_character!.characterHp <= 0) {
          _character!.characterHp = _character!.characterMaxHp;
          if (_character!.level > 1) {
            _character!.level -= 1;
            _character!.maxXp = xpRequiredForLevel(_character!.level);
          }
          _character!.xp = 0;
        }
      }

      // --- Streak: increment if ALL daily quests were completed ---
      if (allDailiesCompleted && _dailyQuests.isNotEmpty) {
        _character!.streak += 1;
        // Streak bonus: extra AP for maintaining streak
        int streakBonusAp = (_character!.streak ~/ 3); // +1 AP per 3 days
        if (streakBonusAp > 0) {
          _character!.actionPoints += streakBonusAp;
          if (_character!.actionPoints > _character!.maxActionPoints) {
            _character!.actionPoints = _character!.maxActionPoints;
          }
        }
      }

      // Reset daily quests for the new day
      for (var quest in _dailyQuests) {
        quest.isCompleted = false;
        quest.completedDate = null;
      }

      // Update lastLoginDate
      _character!.lastLoginDate = currentTime;
    }

    // Weekly reset check
    final daysSinceLastLogin = currentTime.difference(lastLogin).inDays;
    bool newWeekStarted = false;
    for (int i = 1; i <= daysSinceLastLogin; i++) {
      if (lastLogin.add(Duration(days: i)).weekday == DateTime.monday) {
        newWeekStarted = true;
        break;
      }
    }
    if (newWeekStarted) {
      didChange = true;
      for (var quest in _weeklyQuests) {
        quest.isCompleted = false;
        quest.completedDate = null;
      }
    }

    final isNewMonth = currentTime.year != lastLogin.year ||
        currentTime.month != lastLogin.month;
    if (isNewMonth) {
      didChange = true;
      for (var quest in _monthlyQuests) {
        quest.isCompleted = false;
        quest.completedDate = null;
      }
    }

    final isNewYear = currentTime.year != lastLogin.year;
    if (isNewYear) {
      didChange = true;
      for (var quest in _yearlyQuests) {
        quest.isCompleted = false;
        quest.completedDate = null;
      }
    }

    return didChange;
  }

  void _initializeNewData(User user) {
    _character = Character(
      name: user.displayName ?? '모험가',
      photoUrl: user.photoURL,
      level: 1,
      title: '새싹 모험가',
      xp: 0,
      maxXp: xpRequiredForLevel(1),
      strength: 0,
      wisdom: 0,
      health: 0,
      charisma: 0,
      statPoints: 0,
      skillPoints: 0,
      lastLoginDate: DateTime.now(),
      lastHpRegenAt: DateTime.now(),
    );
    _dailyQuests = [
      Quest(
          id: 'd1',
          name: '아침 7시 기상',
          xp: 10,
          type: QuestType.daily,
          category: StatType.health),
      Quest(
          id: 'd2',
          name: '운동 30분',
          xp: 20,
          type: QuestType.daily,
          category: StatType.strength),
      Quest(
          id: 'd3',
          name: '책 10페이지 읽기',
          xp: 15,
          type: QuestType.daily,
          category: StatType.wisdom),
    ];
    _weeklyQuests = [
      Quest(
          id: 'w1',
          name: '주 3회 이상 운동하기',
          xp: 100,
          type: QuestType.weekly,
          category: StatType.strength),
      Quest(
          id: 'w2',
          name: '새로운 기술/지식 학습하기',
          xp: 120,
          type: QuestType.weekly,
          category: StatType.wisdom),
    ];
    _monthlyQuests = [
      Quest(
          id: 'm1',
          name: '이번 달 운동 12회 달성',
          xp: 140,
          type: QuestType.monthly,
          category: StatType.health,
          difficulty: QuestDifficulty.hard),
      Quest(
          id: 'm2',
          name: '사이드 프로젝트 핵심 기능 완성',
          xp: 200,
          type: QuestType.monthly,
          category: StatType.wisdom,
          difficulty: QuestDifficulty.veryHard),
    ];
    _yearlyQuests = [
      Quest(
          id: 'y1',
          name: '올해 대표 목표 하나 완수하기',
          xp: 280,
          type: QuestType.yearly,
          category: StatType.charisma,
          difficulty: QuestDifficulty.veryHard),
    ];
    _unlockedTitleIds = {'t0'};
    _learnedSkillIds = {};
    _initializeAchievementProgress();
    _isNotificationEnabled = true;
    if (_character != null) {
      _character!.customRewards = _buildDefaultCustomRewards(langCode: _locale?.languageCode ?? 'ko');
      _initStarterCards();
    }
  }

  Future<void> unlockExpandedReportForToday() async {
    if (_character == null) return;
    _character!.expandedReportUnlockedOn = _todayKey(DateTime.now());
    await _saveData();
    notifyListeners();
  }

  @visibleForTesting
  void debugSeedState({
    required Character character,
    List<Quest>? dailyQuests,
    List<Quest>? weeklyQuests,
    List<Quest>? monthlyQuests,
    List<Quest>? yearlyQuests,
  }) {
    _character = character;
    _dailyQuests = dailyQuests ?? [];
    _weeklyQuests = weeklyQuests ?? [];
    _monthlyQuests = monthlyQuests ?? [];
    _yearlyQuests = yearlyQuests ?? [];
    _isLoading = false;
    _isDataLoaded = true;
    _isLoadingInProgress = false;
  }

  @visibleForTesting
  bool debugApplyHpRecoveryAt(DateTime now) {
    return _applyHpRecovery(notify: false, now: now);
  }

  @visibleForTesting
  bool debugResetQuestsIfNeeded(DateTime lastLogin, {DateTime? now}) {
    return _resetQuestsIfNeeded(lastLogin, now: now);
  }

  void setCombatActive(bool active) {
    if (_character == null || _isCombatActive == active) return;
    _isCombatActive = active;
    _character!.lastHpRegenAt = DateTime.now();
    unawaited(_saveData());
    notifyListeners();
  }

  void _startHpRegenLoop() {
    _hpRegenTimer?.cancel();
    // HP 회복 주기는 10분이므로 타이머도 10분으로 설정 (매분 체크는 낭비)
    _hpRegenTimer = Timer.periodic(const Duration(minutes: 10), (_) {
      if (_applyHpRecovery()) {
        unawaited(_saveData());
      }
    });
  }

  bool _applyHpRecovery({bool notify = true, DateTime? now}) {
    if (_character == null || _isCombatActive) return false;

    if (_character!.characterHp >= _character!.characterMaxHp) {
      _character!.lastHpRegenAt = now ?? DateTime.now();
      return false;
    }

    final currentTime = now ?? DateTime.now();
    final lastTick = _character!.lastHpRegenAt ?? currentTime;
    const regenIntervalMinutes = 10;
    final ticks =
        currentTime.difference(lastTick).inMinutes ~/ regenIntervalMinutes;
    if (ticks <= 0) return false;

    final healPerTick =
        math.max(1, (_character!.characterMaxHp * 0.03).round());
    final recoveredHp = (_character!.characterHp + (healPerTick * ticks))
        .clamp(0, _character!.characterMaxHp);
    final changed = recoveredHp != _character!.characterHp;

    _character!.characterHp = recoveredHp;
    _character!.lastHpRegenAt = lastTick.add(
      Duration(minutes: ticks * regenIntervalMinutes),
    );

    if (changed && notify) {
      notifyListeners();
    }
    return changed;
  }

  void _recordGrowthContribution(Quest quest) {
    if (_character == null) return;

    double contribution = quest.xp.toDouble();
    switch (quest.type) {
      case QuestType.daily:
        contribution *= 1.0;
        break;
      case QuestType.weekly:
        contribution *= 1.25;
        break;
      case QuestType.monthly:
        contribution *= 1.75;
        break;
      case QuestType.yearly:
        contribution *= 2.5;
        break;
    }

    _character!.levelGrowthWeights[quest.category.name] =
        (_character!.levelGrowthWeights[quest.category.name] ?? 0) +
            contribution;
  }

  Map<StatType, int> _applyAutomaticGrowthOnLevelUp() {
    if (_character == null) {
      return {for (final type in StatType.values) type: 0};
    }

    const autoGrowthPoints = 3;
    final weights = {
      for (final type in StatType.values)
        type: _character!.levelGrowthWeights[type.name] ?? 0.0,
    };
    final total =
        weights.values.fold<double>(0, (runningTotal, value) => runningTotal + value);
    if (total <= 0) {
      _character!.lastLevelAutoGrowth = {
        for (final type in StatType.values) type.name: 0,
      };
      return {for (final type in StatType.values) type: 0};
    }

    final allocations = {for (final type in StatType.values) type: 0};
    final remainders = <StatType, double>{};
    int assigned = 0;

    for (final entry in weights.entries) {
      final exact = (entry.value / total) * autoGrowthPoints;
      final whole = exact.floor();
      allocations[entry.key] = whole;
      remainders[entry.key] = exact - whole;
      assigned += whole;
    }

    final sortedRemainders = remainders.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    var index = 0;
    while (assigned < autoGrowthPoints && index < sortedRemainders.length) {
      allocations[sortedRemainders[index].key] =
          (allocations[sortedRemainders[index].key] ?? 0) + 1;
      assigned++;
      index++;
    }

    for (final entry in allocations.entries) {
      if (entry.value > 0) {
        _increaseStat(entry.key, entry.value);
      }
    }

    _character!.lastLevelAutoGrowth = {
      for (final entry in allocations.entries) entry.key.name: entry.value,
    };
    _character!.levelGrowthWeights = {};
    return allocations;
  }

  void _increaseStat(StatType stat, int amount) {
    switch (stat) {
      case StatType.strength:
        _character!.strength += amount;
        _updateAchievement(
            AchievementCondition.strengthReached, _character!.strength.toInt());
        break;
      case StatType.wisdom:
        _character!.wisdom += amount;
        _updateAchievement(
            AchievementCondition.wisdomReached, _character!.wisdom.toInt());
        break;
      case StatType.health:
        _character!.health += amount;
        _updateAchievement(
            AchievementCondition.healthReached, _character!.health.toInt());
        break;
      case StatType.charisma:
        _character!.charisma += amount;
        _updateAchievement(
            AchievementCondition.charismaReached, _character!.charisma.toInt());
        break;
    }
  }

  String _todayKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  // --- Custom Rewards ---
  List<CustomReward> get customRewards => _character == null ? [] : List.unmodifiable(_character!.customRewards);
  void addCustomReward(String name, String description, int cost, String icon) {
    if (_character == null) return;
    final newReward = CustomReward(
      id: 'cr_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      description: description,
      cost: cost,
      icon: icon,
    );
    _character!.customRewards.add(newReward);
    unawaited(_saveData());
    notifyListeners();
  }

  void removeCustomReward(String id) {
    if (_character == null) return;
    _character!.customRewards.removeWhere((r) => r.id == id);
    unawaited(_saveData());
    notifyListeners();
  }

  bool canAffordCustomReward(CustomReward reward) {
    return _character != null && _character!.gold >= reward.cost;
  }

  void buyCustomReward(CustomReward reward) {
    if (canAffordCustomReward(reward)) {
      _character!.gold -= reward.cost;
      unawaited(_saveData());
      notifyListeners();

      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('${reward.name} 보상을 구매했습니다!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('골드가 부족합니다! (필요 골드: ${reward.cost})'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // --- Dungeon Progression ---
  int get highestDungeonFloor => _character?.highestDungeonFloor ?? 1;
  int get currentDungeonChapter => _character?.currentDungeonChapter ?? 1;

  void unlockNextFloor(int completedChapter, int completedFloor,
      {bool isBoss = false}) {
    if (_character == null) return;

    // Only advance if they are completing their highest unwon stage.
    if (completedChapter == currentDungeonChapter &&
        completedFloor == highestDungeonFloor) {
      if (isBoss) {
        _character!.currentDungeonChapter += 1;
        _character!.highestDungeonFloor = 1;
      } else {
        _character!.highestDungeonFloor += 1;
      }
      unawaited(_saveData());
      notifyListeners();
    }
  }

  void _initializeAchievementProgress() {
    _achievementProgress = {
      for (var ach in _allAchievements)
        ach.id: AchievementProgress(achievementId: ach.id)
    };
  }

  void _hydrateAchievementProgress(Object? rawProgress) {
    _initializeAchievementProgress();
    if (rawProgress is! Map) return;

    for (final entry in rawProgress.entries) {
      final key = entry.key.toString();
      if (!_achievementProgress.containsKey(key)) continue;
      if (entry.value is! Map) continue;
      _achievementProgress[key] = AchievementProgress.fromJson(
        Map<String, dynamic>.from(entry.value as Map),
      );
    }
  }

  DateTime? _parseLastLoginDate(Map<String, dynamic> data) {
    final rawLastLogin =
        data['lastLoginDate'] ?? (data['character'] as Map?)?['lastLoginDate'];
    if (rawLastLogin is! String || rawLastLogin.isEmpty) return null;

    try {
      return DateTime.parse(rawLastLogin);
    } catch (_) {
      return null;
    }
  }

  int _progressCountFor(AchievementCondition condition) {
    int highestValue = 0;
    for (final achievement in _allAchievements) {
      if (achievement.condition != condition) continue;
      final progress = _achievementProgress[achievement.id];
      if (progress == null) continue;
      if (progress.currentValue > highestValue) {
        highestValue = progress.currentValue;
      }
    }
    return highestValue;
  }

  // --- Cosmetics ---
  void unlockCosmetic(String id) {
    if (_character == null) return;
    if (!_character!.unlockedCosmetics.contains(id)) {
      _character!.unlockedCosmetics.add(id);

      // Auto-equip if it's the first cosmetic in that category
      final item = CosmeticDatabase.getById(id);
      if (item != null) {
        if (item.category == CosmeticCategory.theme &&
            _character!.equippedTheme == null) {
          _character!.equippedTheme = id;
        } else if (item.category == CosmeticCategory.titleEffect &&
            _character!.equippedTitleEffect == null) {
          _character!.equippedTitleEffect = id;
        } else if (item.category == CosmeticCategory.combatEffect &&
            _character!.equippedCombatEffect == null) {
          _character!.equippedCombatEffect = id;
        }
      }

      unawaited(_saveData());
      notifyListeners();
    }
  }

  void equipCosmetic(CosmeticItem item) {
    if (_character == null) return;
    if (!_character!.unlockedCosmetics.contains(item.id)) return;

    switch (item.category) {
      case CosmeticCategory.theme:
        _character!.equippedTheme = item.id;
        break;
      case CosmeticCategory.titleEffect:
        _character!.equippedTitleEffect = item.id;
        break;
      case CosmeticCategory.combatEffect:
        _character!.equippedCombatEffect = item.id;
        break;
    }
    unawaited(_saveData());
    notifyListeners();
  }

  void unequipCosmetic(CosmeticCategory category) {
    if (_character == null) return;
    switch (category) {
      case CosmeticCategory.theme:
        _character!.equippedTheme = null;
        break;
      case CosmeticCategory.titleEffect:
        _character!.equippedTitleEffect = null;
        break;
      case CosmeticCategory.combatEffect:
        _character!.equippedCombatEffect = null;
        break;
    }
    unawaited(_saveData());
    notifyListeners();
  }
}












