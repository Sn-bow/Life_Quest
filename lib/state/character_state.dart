import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
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

enum StatType { strength, wisdom, health, charisma }

class CharacterState extends ChangeNotifier {
  static double xpRequiredForLevel(int level) => 100.0 + (level * 50.0);

  static List<CustomReward> _buildDefaultCustomRewards() => [
        const CustomReward(
          id: 'cr_1',
          name: '맛있는 간식 먹기',
          description: '좋아하는 간식 1개 먹기',
          cost: 50,
          icon: '🍪',
        ),
        const CustomReward(
          id: 'cr_2',
          name: '게임 30분 하기',
          description: '죄책감 없이 30분 플레이하기',
          cost: 100,
          icon: '🎮',
        ),
        const CustomReward(
          id: 'cr_3',
          name: '보고싶던 영상/영화 시청',
          description: '유튜브나 넷플릭스 1시간 보기',
          cost: 150,
          icon: '🎬',
        ),
      ];
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

    final referenceTime = _character!.lastLoginDate ?? DateTime.now();
    final didChange = _resetQuestsIfNeeded(referenceTime);
    if (!didChange) return;

    await _performSaveData();
    notifyListeners();
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    super.dispose();
  }

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  VoidCallback? onLevelUp;

  Character? _character;
  bool _isLoading = true;
  bool _isDataLoaded = false;
  bool _isLoadingInProgress = false;
  ThemeMode _themeMode = ThemeMode.dark;
  bool _isNotificationEnabled = true;
  Timer? _saveTimer;

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
  List<CustomReward> _customRewards = _buildDefaultCustomRewards();

  Character get character => _character!;
  bool get isLoading => _isLoading;
  bool get isDataLoaded => _isDataLoaded;
  ThemeMode get themeMode => _themeMode;
  bool get isNotificationEnabled => _isNotificationEnabled;
  int get questCompletionCount =>
      _progressCountFor(AchievementCondition.questCompleted);

  List<Quest> get dailyQuests => _dailyQuests;
  List<Quest> get weeklyQuests => _weeklyQuests;
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

    final allQuests = [..._dailyQuests, ..._weeklyQuests];
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
    final allQuests = [..._dailyQuests, ..._weeklyQuests];
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

  void resetState() {
    _saveTimer?.cancel();
    _character = null;
    _isLoading = true;
    _isDataLoaded = false;
    _isLoadingInProgress = false;
    _themeMode = ThemeMode.dark;
    _isNotificationEnabled = true;
    _dailyQuests = [];
    _weeklyQuests = [];
    _unlockedTitleIds = {'t0'};
    _learnedSkillIds = {};
    _initializeAchievementProgress();
    _customRewards = _buildDefaultCustomRewards();
    unawaited(NotificationService().cancelAllNotifications());
  }

  Future<void> changeThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _saveData();
    notifyListeners();
  }

  Future<void> changeNotificationSetting(bool isEnabled) async {
    _isNotificationEnabled = isEnabled;
    await _syncNotificationSchedule();
    await _saveData();
    notifyListeners();
  }

  Future<void> _syncNotificationSchedule() async {
    if (_isNotificationEnabled) {
      await NotificationService().scheduleDailyNotification();
      await NotificationService().scheduleNightReminder();
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
      _saveData();
      notifyListeners();
    }
  }

  void completeQuest(Quest quest, {double xpMultiplier = 1.0}) {
    if (!quest.isCompleted) {
      quest.isCompleted = true;
      quest.completedDate = DateTime.now();
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
      final currentTitle =
          _allTitles.firstWhere((t) => t.name == _character!.title);
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

      while (_character!.xp >= _character!.maxXp) {
        _levelUp();
      }
      _checkTitleUnlock();
      _updateAchievement(AchievementCondition.questCompleted, 1);
      _saveData();
      notifyListeners();
    }
  }

  void deleteQuest(Quest quest) {
    _dailyQuests.removeWhere((q) => q.id == quest.id);
    _weeklyQuests.removeWhere((q) => q.id == quest.id);
    _saveData();
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
    if (type == QuestType.daily) {
      _dailyQuests.add(newQuest);
    } else {
      _weeklyQuests.add(newQuest);
    }
    _saveData();
    notifyListeners();
  }

  void editQuest(Quest quest, String newName, int newXp, StatType newCategory) {
    quest.name = newName;
    quest.xp = newXp;
    quest.category = newCategory;
    _saveData();
    notifyListeners();
  }

  /// Properly apply combat rewards (XP + loot) with full level-up pipeline.
  /// This replaces any inline level-up code in the UI layer.
  void addCombatReward(int xp, EquipmentItem? loot) {
    _character!.xp += xp;
    if (loot != null) {
      _character!.inventory.add(loot);
    }
    while (_character!.xp >= _character!.maxXp) {
      _levelUp();
    }
    _checkTitleUnlock();
    _updateAchievement(AchievementCondition.monstersKilled, 1);
    _saveData();
    notifyListeners();
  }

  void addTimerReward(int xp, int gold) {
    _character!.xp += xp;
    _character!.gold += gold;
    while (_character!.xp >= _character!.maxXp) {
      _levelUp();
    }
    _checkTitleUnlock();
    _saveData();
    notifyListeners();
  }

  void _levelUp() {
    _character!.xp -= _character!.maxXp;
    _character!.level++;
    // Linear-polynomial hybrid scaling to prevent exponential mid-game halt
    _character!.maxXp = xpRequiredForLevel(_character!.level);

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
    _character!.statPoints += (baseSP + bonusSP);
    if (_character!.level % 2 == 0) {
      _character!.skillPoints += 1;
    }
    SoundService().playLevelUp();
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
      _saveData();
      notifyListeners();
    }
  }

  void _checkTitleUnlock() {
    final questsCompleted = questCompletionCount;

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
      }
    }
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
        _saveData();
      }
    }
  }

  void learnSkill(Skill skill) {
    if (canLearnSkill(skill)) {
      _character!.skillPoints--;
      _learnedSkillIds.add(skill.id);
      _updateAchievement(AchievementCondition.skillsLearned, 1);
      _saveData();
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

  // Schedules _performSaveData() after a 3-second delay, cancelling any pending save.
  Future<void> _saveData() async {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 3), () {
      _performSaveData();
    });
  }

  // The actual database write operation, wrapped in try-catch
  Future<void> _performSaveData() async {
    if (_character == null) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final lastLoginDate = _character!.lastLoginDate;
      final docRef = _firestore.collection('users').doc(user.uid);
      final data = {
        'character': _character!.toJson(),
        'dailyQuests': _dailyQuests.map((q) => q.toJson()).toList(),
        'weeklyQuests': _weeklyQuests.map((q) => q.toJson()).toList(),
        'customRewards': _customRewards.map((reward) => reward.toJson()).toList(),
        'unlockedTitleIds': _unlockedTitleIds.toList(),
        'learnedSkillIds': _learnedSkillIds.toList(),
        'achievementProgress':
            _achievementProgress.map((k, v) => MapEntry(k, v.toJson())),
        'themeMode': _themeMode.index,
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
        final expectedMaxXp = xpRequiredForLevel(_character!.level);
        if (_character!.maxXp != expectedMaxXp) {
          _character!.maxXp = expectedMaxXp;
          needsSave = true;
        }

        _dailyQuests = (data['dailyQuests'] as List<dynamic>? ?? [])
            .map((q) => Quest.fromJson(Map<String, dynamic>.from(q as Map)))
            .toList();
        _weeklyQuests = (data['weeklyQuests'] as List<dynamic>? ?? [])
            .map((q) => Quest.fromJson(Map<String, dynamic>.from(q as Map)))
            .toList();
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

        if (data['customRewards'] is List) {
          _customRewards = (data['customRewards'] as List<dynamic>)
              .whereType<Map>()
              .map((reward) =>
                  CustomReward.fromJson(Map<String, dynamic>.from(reward)))
              .toList();
          if (_customRewards.isEmpty) {
            _customRewards = _buildDefaultCustomRewards();
            needsSave = true;
          }
        } else {
          _customRewards = _buildDefaultCustomRewards();
          needsSave = true;
        }

        _themeMode =
            ThemeMode.values[data['themeMode'] ?? ThemeMode.dark.index];
        _isNotificationEnabled = data['isNotificationEnabled'] ?? true;
        await _syncNotificationSchedule();

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

        if (needsSave) {
          await _performSaveData();
        }

        _isDataLoaded = true;
      } else {
        _initializeNewData(freshUser);
        await _syncNotificationSchedule();
        // Save initial data immediately instead of debouncing
        await _performSaveData();
        _isDataLoaded = true;
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
      }
    } finally {
      _isLoading = false;
      _isLoadingInProgress = false;
      notifyListeners();
    }
  }

  bool _resetQuestsIfNeeded(DateTime lastLogin) {
    bool didChange = false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
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
      _character!.lastLoginDate = now;
    }

    // Weekly reset check
    final daysSinceLastLogin = now.difference(lastLogin).inDays;
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
    _unlockedTitleIds = {'t0'};
    _learnedSkillIds = {};
    _initializeAchievementProgress();
    _isNotificationEnabled = true;
    _customRewards = _buildDefaultCustomRewards();
  }
  // --- Custom Rewards ---
  List<CustomReward> get customRewards => List.unmodifiable(_customRewards);
  void addCustomReward(String name, String description, int cost, String icon) {
    final newReward = CustomReward(
      id: 'cr_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      description: description,
      cost: cost,
      icon: icon,
    );
    _customRewards.add(newReward);
    _saveData();
    notifyListeners();
  }

  void removeCustomReward(String id) {
    _customRewards.removeWhere((r) => r.id == id);
    _saveData();
    notifyListeners();
  }

  bool canAffordCustomReward(CustomReward reward) {
    return _character != null && _character!.gold >= reward.cost;
  }

  void buyCustomReward(CustomReward reward) {
    if (canAffordCustomReward(reward)) {
      _character!.gold -= reward.cost;
      _saveData();
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
      _saveData();
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

      _saveData();
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
    _saveData();
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
    _saveData();
    notifyListeners();
  }
}












