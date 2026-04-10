// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get close => 'Close';

  @override
  String get confirm => 'Confirm';

  @override
  String get delete => 'Delete';

  @override
  String get apply => 'Apply';

  @override
  String get change => 'Change';

  @override
  String get complete => 'Complete';

  @override
  String get acquire => 'Acquire';

  @override
  String get tabStatus => 'Status';

  @override
  String get tabQuests => 'Quests';

  @override
  String get tabHunt => 'Hunt';

  @override
  String get tabInventory => 'Inventory';

  @override
  String get tabShop => 'Shop';

  @override
  String get tabAchievement => 'Achievements';

  @override
  String get tabSkill => 'Skills';

  @override
  String get loginTitle => 'Turn your daily actions into experience';

  @override
  String get loginSubtitle =>
      'A productivity RPG where small quests grow your character and your day';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginButton => 'Login';

  @override
  String get loginRegisterButton => 'Register New Adventurer';

  @override
  String get loginDivider => 'Or sign in with';

  @override
  String get loginGoogleButton => 'Continue with Google';

  @override
  String get loginErrorEmpty => 'Please enter both email and password.';

  @override
  String get loginErrorFailed => 'Login failed.';

  @override
  String get loginErrorGoogleToken =>
      'Unable to get Google auth token. Please try again.';

  @override
  String get loginErrorGoogle => 'Google sign-in failed.';

  @override
  String loginErrorUnknown(String error) {
    return 'An error occurred: $error';
  }

  @override
  String get signupTitle => 'Register New Adventurer';

  @override
  String get signupPickPhoto => 'Pick Profile Photo';

  @override
  String get signupEmailLabel => 'Email';

  @override
  String get signupEmailRequired => 'Please enter your email.';

  @override
  String get signupEmailInvalid =>
      'Please enter a valid email. (e.g. name@example.com)';

  @override
  String get signupNicknameLabel => 'Nickname';

  @override
  String get signupNicknameRequired => 'Please enter a nickname.';

  @override
  String get signupPasswordLabel => 'Password';

  @override
  String get signupPasswordTooShort =>
      'Password must be at least 6 characters.';

  @override
  String get signupPasswordConfirmLabel => 'Confirm Password';

  @override
  String get signupPasswordMismatch => 'Passwords do not match.';

  @override
  String get signupButton => 'Complete Registration';

  @override
  String get signupSuccess => '🎉 Registration successful! Welcome!';

  @override
  String get signupErrorFailed => 'Registration failed.';

  @override
  String signupErrorUnknown(String error) {
    return 'An unknown error occurred: $error';
  }

  @override
  String get signupErrorUserCreate => 'Failed to create user.';

  @override
  String get statusScreenTitle => 'Status';

  @override
  String get statusTimerTooltip => 'Focus Timer';

  @override
  String get statusSettingsTooltip => 'Settings';

  @override
  String get statusHpLabel => 'HP';

  @override
  String get statusHpRecoveryHint =>
      'HP gradually recovers every 10 minutes when not in combat.';

  @override
  String statusStreakLabel(int days) {
    return 'Streak: $days days';
  }

  @override
  String statusStreakBonus(int percent) {
    return 'XP +$percent%';
  }

  @override
  String get statusStatHint =>
      'On level up, 3 points are auto-distributed based on recent quest tendencies; the rest are yours to allocate.';

  @override
  String get statusGoldLabel => 'Gold';

  @override
  String get statusApLabel => 'Action Points';

  @override
  String get statusBaseStatTitle => 'Base Stats';

  @override
  String get statusDetailStatButton => 'View Detailed Stats';

  @override
  String get statusDetailStatTitle => '📊 Detailed Combat Stats';

  @override
  String get statusAttackLabel => 'Attack';

  @override
  String get statusDefenseLabel => 'Defense';

  @override
  String get statusCritLabel => 'Crit Chance';

  @override
  String get statusDodgeLabel => 'Dodge Chance';

  @override
  String get statusStatStrength => 'Strength';

  @override
  String get statusStatWisdom => 'Wisdom';

  @override
  String get statusStatHealth => 'Health';

  @override
  String get statusStatCharm => 'Charm';

  @override
  String get statusTitleChangeTitle => 'Change Title';

  @override
  String get statusStatApplyTitle => 'Confirm Stat Allocation';

  @override
  String statusStatApplyBody(String summary) {
    return 'Apply the following stats?\n\n$summary\n\nThis cannot be undone.';
  }

  @override
  String get questsScreenTitle => 'Quest List';

  @override
  String get questsTabDaily => 'Daily Quests';

  @override
  String get questsTabWeekly => 'Weekly Quests';

  @override
  String get questsTabMonthly => 'Monthly Raid';

  @override
  String get questsTabYearly => 'Annual Raid';

  @override
  String get questsEmptyDaily =>
      'No quests added yet.\nStart with something small for today.';

  @override
  String get questsEmptyWeekly =>
      'No weekly routine goals yet.\nAdd goals you want to repeat consistently.';

  @override
  String get questsEmptyMonthly =>
      'No monthly raid yet.\nAdd long-term goals as monthly raids.';

  @override
  String get questsEmptyYearly =>
      'No annual raid yet.\nAdd life-goal level challenges as annual raids.';

  @override
  String get questsCategoryStrength => 'Strength';

  @override
  String get questsCategoryWisdom => 'Wisdom';

  @override
  String get questsCategoryHealth => 'Health';

  @override
  String get questsCategoryCharm => 'Charm';

  @override
  String get questsDifficultyEasy => 'Easy';

  @override
  String get questsDifficultyNormal => 'Normal';

  @override
  String get questsDifficultyHard => 'Hard';

  @override
  String get questsDifficultyVeryHard => 'Very Hard';

  @override
  String get questsTypeDaily => 'Daily';

  @override
  String get questsTypeWeekly => 'Weekly';

  @override
  String get questsTypeMonthly => 'Monthly Raid';

  @override
  String get questsTypeYearly => 'Annual Raid';

  @override
  String get questsCompleteTitle => 'Complete Quest';

  @override
  String questsCompleteConfirm(String questName) {
    return 'Complete quest \'$questName\'?';
  }

  @override
  String get questsBaseRewardLabel => 'Base Reward';

  @override
  String questsDoubleAdButton(int remaining) {
    return 'Watch Ad for 2x Reward ($remaining left)';
  }

  @override
  String get questsAdUnavailable => 'Ad unavailable. Base reward granted.';

  @override
  String get questsEditTitle => 'Edit Quest';

  @override
  String get questsAddTitle => 'Add New Quest';

  @override
  String get questsNameLabel => 'Quest Name';

  @override
  String get questsTypeLabel => 'Type';

  @override
  String get questsCategoryLabel => 'Category';

  @override
  String get questsDifficultyLabel => 'Difficulty';

  @override
  String questsRewardPreview(String type, int xp, int gold) {
    return '$type Reward: $xp XP · $gold Gold';
  }

  @override
  String get questsNameRequired => 'Please enter a quest name.';

  @override
  String get questsDeleteTitle => 'Delete Quest';

  @override
  String questsDeleteBody(String questName) {
    return 'Delete quest \'$questName\'?\n\nThis action cannot be undone.';
  }

  @override
  String questsRaidClear(int count) {
    return 'Raid cleared $count time(s)';
  }

  @override
  String get questsRaidBonusMonthly =>
      'Raid Bonus\nBonus XP · Bonus Gold\nAP +2 · SP +1\nUnlock Progress Rewards';

  @override
  String get questsRaidBonusYearly =>
      'Raid Bonus\nMassive XP · Massive Gold\nAP +4 · SP +2\nUnlock Rare Rewards';

  @override
  String get huntScreenTitle => 'Hunting Ground';

  @override
  String get huntMyHpLabel => 'My HP';

  @override
  String huntComboBadge(int count) {
    return '💥 Combo: $count';
  }

  @override
  String huntApBadge(int ap) {
    return '⚡ AP: $ap';
  }

  @override
  String get huntActionAttack => 'Attack (1 AP)';

  @override
  String get huntActionDefend => 'Defend (1 AP)';

  @override
  String get huntActionSkill => 'Skill (Free)';

  @override
  String get huntActionBag => 'Bag (1 AP)';

  @override
  String get huntActionFlee => 'Flee (1 AP)';

  @override
  String get huntBagTitle => 'Bag (Consumables)';

  @override
  String get huntBagEmpty => 'No usable items.';

  @override
  String get huntBagUse => 'Use (1 AP)';

  @override
  String get huntSkillSelectTitle => 'Select a skill:';

  @override
  String get huntSkillEmpty => 'No combat skills learned.';

  @override
  String get huntApLowTitle => 'Low AP';

  @override
  String huntApLowBody(int remaining) {
    return 'Not enough AP. Watch an ad to recover 2 AP?\n(Today remaining: $remaining)';
  }

  @override
  String get huntApRecoverButton => 'Watch Ad to Recover';

  @override
  String get huntApExhausted =>
      '⚡ Low AP! Complete quests. (Today\'s ad recovery exhausted)';

  @override
  String huntDoubleRewardButton(int remaining) {
    return 'Watch Ad for 2x Loot ($remaining left)';
  }

  @override
  String get huntDoubleRewardSuccess => '🎉 Got 2x loot from ad reward!';

  @override
  String get huntAdUnavailable => 'Ad unavailable. Please try again.';

  @override
  String get huntResultButton => 'View Results & Return';

  @override
  String huntReviveButton(int remaining) {
    return 'Watch Ad to Revive ($remaining left today)';
  }

  @override
  String get huntReviveSuccess => '❤️ Instantly revived via ad reward!';

  @override
  String get huntReviveAdUnavailable =>
      'Ad unavailable. Please try again later.';

  @override
  String get huntRetreatButton => 'Give Up & Return';

  @override
  String get inventoryScreenTitle => 'Inventory';

  @override
  String get inventoryEquippedSection => 'Equipped';

  @override
  String get inventoryCombatStatSection => 'Combat Stats';

  @override
  String inventoryItemsSection(int count) {
    return 'Items ($count)';
  }

  @override
  String get inventorySlotWeapon => '⚔️ Weapon';

  @override
  String get inventorySlotArmor => '🛡️ Armor';

  @override
  String get inventorySlotAccessory => '💍 Accessory';

  @override
  String get inventorySlotEmpty => 'Empty';

  @override
  String get inventoryUnequip => 'Unequip';

  @override
  String get inventoryUseEquip => 'Use / Equip';

  @override
  String get inventoryEmptyMessage =>
      'No items\nHunt monsters to obtain equipment!';

  @override
  String get inventoryAttackLabel => 'Attack';

  @override
  String get inventoryDefenseLabel => 'Defense';

  @override
  String get inventoryHpLabel => 'HP';

  @override
  String get inventoryStatStrength => 'Strength';

  @override
  String get inventoryStatWisdom => 'Wisdom';

  @override
  String get inventoryStatHealth => 'Health';

  @override
  String get inventoryStatCharm => 'Charm';

  @override
  String get inventoryStatAttack => 'Attack';

  @override
  String get inventoryStatDefense => 'Defense';

  @override
  String inventoryUsedHp(String itemName) {
    return 'Used $itemName. (HP recovered)';
  }

  @override
  String inventoryUsedAp(String itemName) {
    return 'Used $itemName. (AP recovered)';
  }

  @override
  String get inventoryRarityCommon => 'Common';

  @override
  String get inventoryRarityUncommon => 'Uncommon';

  @override
  String get inventoryRarityRare => 'Rare';

  @override
  String get inventoryRarityEpic => 'Epic';

  @override
  String get inventoryRarityLegendary => 'Legendary';

  @override
  String get shopScreenTitle => 'Shop';

  @override
  String get shopTabGameItems => 'Game Items';

  @override
  String get shopTabCustomRewards => 'My Rewards';

  @override
  String get shopThemeBannerTitle => 'Theme Showcase';

  @override
  String get shopThemeBannerSubtitle => 'Preview upcoming themes and effects.';

  @override
  String get shopConsumableSection => 'Consumables';

  @override
  String get shopEquipBoxSection => 'Equipment Boxes';

  @override
  String get shopPermanentSection => 'Permanent Upgrades';

  @override
  String get shopHpPotionName => 'HP Recovery Potion';

  @override
  String get shopHpPotionDesc => 'Recovers 30 HP.';

  @override
  String get shopHpFullPotionName => 'Full HP Recovery Potion';

  @override
  String get shopHpFullPotionDesc => 'Fully restores HP.';

  @override
  String get shopApPotionName => 'AP Charge Potion';

  @override
  String get shopApPotionDesc => 'Recovers 5 AP.';

  @override
  String get shopNormalBoxName => 'Normal Equipment Box';

  @override
  String get shopNormalBoxDesc => 'Randomly obtain Common~Rare equipment.';

  @override
  String get shopNormalBoxSuccess =>
      'Equipment obtained! Check your inventory!';

  @override
  String get shopPremiumBoxName => 'Premium Equipment Box';

  @override
  String get shopPremiumBoxDesc => 'Randomly obtain Rare~Legendary equipment.';

  @override
  String get shopPremiumBoxSuccess =>
      'Premium equipment obtained! Check your inventory!';

  @override
  String get shopMaxHpName => 'Max HP +10';

  @override
  String get shopMaxHpDesc => 'Permanently increases Max HP by 10.';

  @override
  String get shopMaxHpSuccess => 'Max HP increased by 10!';

  @override
  String get shopMaxApName => 'Max AP +2';

  @override
  String get shopMaxApDesc => 'Permanently increases Max AP by 2.';

  @override
  String get shopMaxApSuccess => 'Max AP increased by 2!';

  @override
  String get shopCustomRewardAddTitle => 'Add Custom Reward';

  @override
  String get shopCustomRewardNameLabel =>
      'Reward name (e.g. 1 hour of Netflix)';

  @override
  String get shopCustomRewardDescLabel => 'Description';

  @override
  String get shopCustomRewardDescHint => 'Enjoy this reward!';

  @override
  String get shopCustomRewardCostLabel => 'Gold Required';

  @override
  String get shopCustomRewardIconLabel => 'Icon (Emoji)';

  @override
  String get shopCustomRewardAddButton => 'Add Reward';

  @override
  String shopCustomRewardDeleted(String name) {
    return '$name deleted';
  }

  @override
  String get shopAdSupportTitle => 'Ad-supported app';

  @override
  String get shopAdSupportDesc =>
      'Ads only appear when you want extra rewards like 2x quest rewards, AP recovery, or combat revives.';

  @override
  String get shopAdModelTitle => 'Ad-funded model';

  @override
  String get shopAdModelDesc =>
      'This version focuses on ad revenue over in-app purchases. Paid items will be reconsidered in the future.';

  @override
  String get achievementScreenTitle => 'Achievements';

  @override
  String get achievementTabInProgress => 'In Progress';

  @override
  String get achievementTabCompleted => 'Completed';

  @override
  String get achievementEmptyInProgress =>
      'All achievements unlocked, or waiting for new challenges!';

  @override
  String get achievementEmptyCompleted => 'No achievements completed yet.';

  @override
  String achievementRewardXp(int xp) {
    return 'Reward: $xp XP';
  }

  @override
  String achievementRewardSp(int sp) {
    return 'Reward: $sp SP';
  }

  @override
  String get skillScreenTitle => 'Skills';

  @override
  String skillRequiredLevel(int level) {
    return 'Required: Lv.$level';
  }

  @override
  String get settingsScreenTitle => 'Settings';

  @override
  String get settingsAccountSection => 'Account';

  @override
  String get settingsNicknameLabel => 'Nickname';

  @override
  String get settingsNicknameChangeTitle => 'Change Nickname';

  @override
  String get settingsNicknameNewLabel => 'New Nickname';

  @override
  String get settingsAppSection => 'App Settings';

  @override
  String get settingsDarkMode => 'Dark Mode';

  @override
  String get settingsDarkModeSubtitle => 'Toggle the app theme.';

  @override
  String get settingsSfx => 'Sound Effects (SFX)';

  @override
  String get settingsSfxSubtitle => 'Toggle game sound effects.';

  @override
  String get settingsNotification => 'Notifications';

  @override
  String get settingsNotificationSubtitle =>
      'Receive daily quest reminders at 9 AM.';

  @override
  String get settingsNotificationEnabled =>
      'Notifications scheduled for 9 AM and 8 PM daily.';

  @override
  String get settingsNotificationDisabled => 'All notifications cancelled.';

  @override
  String get settingsAdSupportSection => 'Ad Support Info';

  @override
  String get settingsAdSupportTitle => 'Ad-supported app';

  @override
  String get settingsAdSupportDesc =>
      'Ads only appear when you want extra rewards like 2x quest rewards, AP recovery, or combat revives.';

  @override
  String get settingsAdModelTitle => 'Ad-funded model';

  @override
  String get settingsAdModelDesc =>
      'This version focuses on ad revenue over in-app purchases. Paid items will be reconsidered in the future.';

  @override
  String get settingsLogout => 'Logout';

  @override
  String get settingsWithdraw => 'Delete Account';

  @override
  String get settingsWithdrawTitle => 'Delete Account';

  @override
  String get settingsWithdrawBody =>
      'Are you sure you want to delete your account?\nAll data will be permanently deleted and cannot be recovered.';

  @override
  String get settingsWithdrawConfirm => 'Confirm Deletion';

  @override
  String get loadingSync => 'Syncing hunter data';

  @override
  String get loadingSyncDesc => 'Loading today\'s quests and growth records';

  @override
  String get loadingGate => 'Opening the gate';

  @override
  String get loadingGateDesc => 'Initializing systems';

  @override
  String get loadingTagline => 'ARISE YOUR QUEST';

  @override
  String get timerScreenFocus => '🍅 Focus Timer';

  @override
  String get timerScreenBreak => '☕ Break Timer';

  @override
  String get timerFocusMode => 'Focus Mode';

  @override
  String get timerBreakMode => 'Break Mode';

  @override
  String timerSessionCount(int count) {
    return 'Session $count complete';
  }

  @override
  String get timerFocusCompleteTitle => '🎉 Focus Complete!';

  @override
  String timerFocusCompleteBody(int minutes) {
    return '$minutes-minute focus session complete!';
  }

  @override
  String get timerGoldRewardLabel => 'Gold +';

  @override
  String timerTodaySessions(int count) {
    return 'Today: $count sessions';
  }

  @override
  String get timerStartBreak => 'Start Break';

  @override
  String get timerFocusRewardLabel => 'Focus Reward:';

  @override
  String get cosmeticShopTitle => 'Theme Showcase';

  @override
  String get cosmeticCategoryTheme => 'App Theme';

  @override
  String get cosmeticCategoryTitleEffect => 'Title Effect';

  @override
  String get cosmeticCategoryCombatEffect => 'Combat Effect';

  @override
  String get cosmeticComingSoonTitle => 'Premium customization coming soon';

  @override
  String get cosmeticComingSoonDesc =>
      'Currently focused on ad-supported model. Themes and effects will launch later.';

  @override
  String get cosmeticUnequip => 'Unequip';

  @override
  String get cosmeticEquip => 'Equip';

  @override
  String get cosmeticComingSoon => 'Coming Soon';

  @override
  String get cosmeticComingSoonSnackbar =>
      'Cosmetic items coming soon. Currently focused on ad-supported model.';

  @override
  String get questTileEditTooltip => 'Edit Quest';

  @override
  String get questTileDeleteTooltip => 'Delete Quest';

  @override
  String get notificationMorningTitle => 'Start today\'s quests!';

  @override
  String get notificationMorningBody =>
      'A new day has begun. Record your growth.';

  @override
  String get notificationEveningTitle => 'Did you complete today\'s quests?';

  @override
  String get notificationEveningBody => 'Incomplete quests may reduce your HP!';

  @override
  String get initialTitleRookie => 'Rookie Adventurer';

  @override
  String get initialQuestMorning => 'Wake up at 7 AM';

  @override
  String get initialQuestExercise => 'Exercise 30 minutes';

  @override
  String get initialQuestRead => 'Read 10 pages';

  @override
  String get initialQuestWeeklyExercise => 'Exercise 3+ times this week';

  @override
  String get initialQuestWeeklyLearn => 'Learn a new skill or knowledge';

  @override
  String get initialQuestMonthlyExercise => 'Exercise 12 times this month';

  @override
  String get initialQuestMonthlyProject =>
      'Complete core feature of side project';

  @override
  String get initialQuestYearly => 'Accomplish one major goal this year';

  @override
  String get reportScreenTitle => 'Detailed Report';

  @override
  String get reportExpandedUnlocked => 'Expanded report unlocked for today.';

  @override
  String get reportAdFailed => 'Failed to load ad. Please try again later.';

  @override
  String get reportSummaryStreak => 'Current Streak';

  @override
  String reportSummaryStreakValue(int days) {
    return '$days days';
  }

  @override
  String get reportSummaryXp => 'Current XP';

  @override
  String get reportSummaryQuestCount => 'Quests Completed';

  @override
  String reportSummaryQuestCountValue(int count) {
    return '$count';
  }

  @override
  String get reportSummaryTitle => 'Current Title';

  @override
  String get reportWeeklyActivityTitle => 'Weekly Activity';

  @override
  String get reportWeeklyActivitySubtitle =>
      'Check your routine flow for the week.';

  @override
  String get reportWeekDayMon => 'Mon';

  @override
  String get reportWeekDayTue => 'Tue';

  @override
  String get reportWeekDayWed => 'Wed';

  @override
  String get reportWeekDayThu => 'Thu';

  @override
  String get reportWeekDayFri => 'Fri';

  @override
  String get reportWeekDaySat => 'Sat';

  @override
  String get reportWeekDaySun => 'Sun';

  @override
  String get reportExpandedEntryTitle => 'Expanded Report (Ad-Unlock)';

  @override
  String get reportExpandedAlreadyUnlocked =>
      'Expanded report already unlocked today. View the deep analysis below.';

  @override
  String get reportExpandedDescription =>
      'Unlock deep analysis to see category ratios, growth trends, and auto-growth records.';

  @override
  String get reportFeatureCategoryRatio => 'Quest Category Ratio';

  @override
  String get reportFeatureGrowthTrend => 'Next Level Growth Trend Analysis';

  @override
  String get reportFeatureAutoGrowth => 'Previous Level Auto-Growth Record';

  @override
  String get reportUnlockedToday => 'Expanded report unlocked today';

  @override
  String reportWatchAdButton(int count) {
    return 'Watch Ad to Unlock ($count left today)';
  }

  @override
  String get reportNoMoreViews => 'No more unlocks available today';

  @override
  String get reportCategoryRatioTitle => 'Quest Category Ratio';

  @override
  String get reportInsightGrowthTrendTitle => 'This Level Growth Trend';

  @override
  String get reportInsightGrowthTrendCaption =>
      'This is the direction most reflected by completed quests.';

  @override
  String get reportInsightGrowthTrendCaptionEmpty =>
      'Complete quests to build up auto-growth tendencies.';

  @override
  String get reportInsightDataInsufficient => 'Insufficient Data';

  @override
  String get reportInsightAutoGrowthTitle => 'Previous Level Auto-Growth';

  @override
  String get reportInsightAutoGrowthCaption =>
      'On level up, 3 points are auto-distributed based on action stats.';

  @override
  String get reportInsightBestDayTitle => 'Best Focus Day This Week';

  @override
  String reportInsightBestDayCaption(int count) {
    return 'You completed $count quests this week.';
  }

  @override
  String get reportInsightRecommendedStatTitle => 'Recommended Focus Stat';

  @override
  String get reportInsightBalanced => 'Balanced';

  @override
  String get reportNextLevelPredictionTitle =>
      'Next Level Auto-Growth Prediction';

  @override
  String get reportLongTermTitle => 'Long-Term Goal Progress';

  @override
  String get reportLongTermSubtitle =>
      'Check your monthly and annual raid progress at a glance.';

  @override
  String get reportProgressMonthlyRaid => 'Monthly Raid';

  @override
  String get reportProgressYearlyRaid => 'Annual Raid';

  @override
  String get reportLowestStat => 'Current Lowest Stat';

  @override
  String get reportHighestStat => 'Highest Stat';

  @override
  String get reportCalendarTitle => 'Quest Calendar';

  @override
  String get reportCalendarWeekdaySun => 'Sun';

  @override
  String get reportCalendarWeekdayMon => 'Mon';

  @override
  String get reportCalendarWeekdayTue => 'Tue';

  @override
  String get reportCalendarWeekdayWed => 'Wed';

  @override
  String get reportCalendarWeekdayThu => 'Thu';

  @override
  String get reportCalendarWeekdayFri => 'Fri';

  @override
  String get reportCalendarWeekdaySat => 'Sat';

  @override
  String reportCalendarSelectedTitle(int month, int day) {
    return '$month/$day Completed Quests';
  }

  @override
  String get reportCalendarSelectPrompt => 'Select a date';

  @override
  String get reportCalendarNoQuests => 'No completed quests on this date.';

  @override
  String get reportNoRecord => 'No record';

  @override
  String get reportStatBalanced => 'Stat balance is currently stable.';

  @override
  String reportAddQuestSuggestion(String category) {
    return 'Try adding a $category quest';
  }

  @override
  String reportRecommendedAction(String action) {
    return 'Recommended: $action';
  }

  @override
  String reportBestWeekday(String weekday, int count) {
    return '$weekday ($count)';
  }

  @override
  String get reportWeekdayMonday => 'Monday';

  @override
  String get reportWeekdayTuesday => 'Tuesday';

  @override
  String get reportWeekdayWednesday => 'Wednesday';

  @override
  String get reportWeekdayThursday => 'Thursday';

  @override
  String get reportWeekdayFriday => 'Friday';

  @override
  String get reportWeekdaySaturday => 'Saturday';

  @override
  String get reportWeekdaySunday => 'Sunday';

  @override
  String reportStatValue(String stat, int value) {
    return '$stat $value';
  }

  @override
  String shopItemAcquired(String name) {
    return 'Acquired $name!';
  }

  @override
  String get shopCustomRewardFabLabel => 'Add Reward';

  @override
  String get statusReportTooltip => 'View Detailed Report';

  @override
  String get dungeonHomeTitle => 'Soul Deck';

  @override
  String get dungeonHomeCardCollectionTooltip => 'Card Collection';

  @override
  String get dungeonHomeDungeonSelection => 'Select Dungeon';

  @override
  String dungeonHomeRequiredLevel(int requiredLevel) {
    return 'Level $requiredLevel or higher required';
  }

  @override
  String get zone1Name => 'Blue Meadow';

  @override
  String get zone1Description => 'The first dungeon for novice adventurers';

  @override
  String get zone2Name => 'Dark Forest';

  @override
  String get zone2Description =>
      'A place teeming with enemies that use poison and debuffs';

  @override
  String get zone3Name => 'Ruined Castle';

  @override
  String get zone3Description =>
      'Defense-focused enemies and multi-battles await';

  @override
  String get zone4Name => 'Lava Cave';

  @override
  String get zone4Description => 'A hell of burns and high damage';

  @override
  String get zone5Name => 'Abyssal Dimension';

  @override
  String get zone5Description =>
      'Enemies that hide their intent; the cursed final dungeon';

  @override
  String get seasonName => 'Season 1: Soul Awakening';

  @override
  String get seasonEnded => 'Ended';

  @override
  String seasonCountdown(int days) {
    return 'D-$days';
  }

  @override
  String get ascensionModeTitle => 'Ascension Mode';

  @override
  String get ascensionInactive => 'Inactive';

  @override
  String get ascensionActiveModifiers => 'Active Penalties:';

  @override
  String get ascensionSliderHint => 'Drag slider to increase difficulty';

  @override
  String get ascensionLevel1Modifier => 'Lv 1: Enemy HP +10%';

  @override
  String get ascensionLevel2Modifier => 'Lv 2: Enemy ATK +10%';

  @override
  String get ascensionLevel3Modifier => 'Lv 3: Starting Gold -30';

  @override
  String get ascensionLevel4Modifier => 'Lv 4: Add 1 Curse Card';

  @override
  String get ascensionLevel5Modifier => 'Lv 5: No card choice after Elite';

  @override
  String get ascensionLevel6Modifier => 'Lv 6: Shop Prices +25%';

  @override
  String get ascensionLevel7Modifier => 'Lv 7: Starting HP -10%';

  @override
  String get ascensionLevel8Modifier => 'Lv 8: Boss HP +25%';

  @override
  String get ascensionLevel9Modifier => 'Lv 9: Stronger Event Penalties';

  @override
  String get ascensionLevel10Modifier => 'Lv 10: All Enemy HP +20%';

  @override
  String get infiniteTowerTitle => 'Infinite Tower';

  @override
  String infiniteTowerBestFloorDesc(int bestFloor) {
    return 'Endless challenge · Best: Floor $bestFloor';
  }

  @override
  String get infiniteTowerSelectFloor => 'Select Floor';

  @override
  String get infiniteTowerFloorInfo => 'Floor Info';

  @override
  String infiniteTowerChallengeFloor(int targetFloor) {
    return 'Challenge Floor $targetFloor';
  }

  @override
  String get infiniteTowerFloorComposition => 'Floor Composition';

  @override
  String get infiniteTowerBestFloorLabel => 'Best Floor';

  @override
  String infiniteTowerFloorDisplay(int floor) {
    return 'Floor $floor';
  }

  @override
  String get infiniteTowerEnemyHp => 'Enemy HP';

  @override
  String get infiniteTowerEnemyAttack => 'Enemy ATK';

  @override
  String get infiniteTowerDefault => 'Base';

  @override
  String get infiniteTowerFloor1To5 => 'Floors 1-5';

  @override
  String get infiniteTowerFloor6To10 => 'Floors 6-10';

  @override
  String get infiniteTowerFloor11To15 => 'Floors 11-15';

  @override
  String get infiniteTowerFloor16To20 => 'Floors 16-20';

  @override
  String get infiniteTowerFloor21To25 => 'Floors 21-25';

  @override
  String get infiniteTowerFloor26Plus => 'Floor 26+';

  @override
  String get infiniteTowerRepeatZones =>
      'Repeats from Zone 1 (difficulty keeps rising)';

  @override
  String get dungeonMapTitle => 'Dungeon Map';

  @override
  String get dungeonMapNoData => 'No dungeon data';

  @override
  String get dungeonRestTitle => 'Rest Site';

  @override
  String get dungeonRestDescription =>
      'A quiet rest site. A warm campfire burns.\nWhat will you do?';

  @override
  String get dungeonRestRestTitle => 'Rest';

  @override
  String get dungeonRestRestDescription => 'Recover 30% of HP';

  @override
  String dungeonRestHealResult(int healAmount) {
    return 'Recovered $healAmount HP!';
  }

  @override
  String get dungeonRestTrainTitle => 'Train';

  @override
  String get dungeonRestTrainDescription => 'Upgrade 1 card';

  @override
  String get dungeonRestNoCardsToUpgrade => 'No cards to upgrade';

  @override
  String get dungeonRestContinueButton => 'Continue';

  @override
  String get dungeonRestSelectCardToUpgrade => 'Select a card to upgrade';

  @override
  String get dungeonRestCardUpgraded => 'Upgraded';

  @override
  String get dungeonShopTitle => 'Dungeon Shop';

  @override
  String get dungeonShopCardsSection => 'Cards';

  @override
  String get dungeonShopNoCards => 'No cards for sale';

  @override
  String get dungeonShopRelicsSection => 'Relics';

  @override
  String get dungeonShopNoRelics => 'No relics for sale';

  @override
  String get dungeonShopCardRemovalSection => 'Card Removal';

  @override
  String get dungeonShopLeaveButton => 'Leave Shop';

  @override
  String get dungeonShopSelectCardToRemove => 'Select a card to remove';

  @override
  String dungeonShopRemovalCost(int cost) {
    return 'Cost: $cost Gold';
  }

  @override
  String get dungeonShopPurchaseComplete => 'Purchase complete';

  @override
  String get dungeonShopRemoveOneCard => 'Remove 1 Card';

  @override
  String dungeonShopRemovalDescription(int deckSize) {
    return 'Remove an unwanted card from your deck (deck: $deckSize cards)';
  }

  @override
  String get dungeonEventTitle => 'Event';

  @override
  String get dungeonEventNoData => 'No event data';

  @override
  String get dungeonEventChooseAction => 'Choose';

  @override
  String get dungeonEventContinueButton => 'Continue';

  @override
  String get dungeonEventOutcomeTitle => 'Result';

  @override
  String get dungeonEventEffectCardReward => 'Card Obtained';

  @override
  String get dungeonEventEffectRelicReward => 'Relic Obtained';

  @override
  String get dungeonEventEffectCardRemove => 'Card Removed';

  @override
  String get dungeonEventEffectCardUpgrade => 'Card Upgraded';

  @override
  String get dungeonEventEffectCurseAdded => 'Curse Added';

  @override
  String get dungeonResultVictoryTitle => 'Dungeon Cleared!';

  @override
  String get dungeonResultDefeatTitle => 'Adventure Failed...';

  @override
  String get dungeonResultVictoryMessage =>
      'Congratulations! You conquered the dungeon defeating all enemies.';

  @override
  String get dungeonResultDefeatMessage =>
      'Unfortunately this adventure failed. Try again!';

  @override
  String get dungeonResultStatsTitle => 'Adventure Log';

  @override
  String get dungeonResultStatsZone => 'Zone';

  @override
  String get dungeonResultStatsNodesCompleted => 'Nodes Completed';

  @override
  String get dungeonResultStatsMonsterKilled => 'Monsters Defeated';

  @override
  String get dungeonResultRewardsTitle => 'Rewards';

  @override
  String dungeonResultXpReward(int xpGained) {
    return '+$xpGained XP';
  }

  @override
  String dungeonResultGoldReward(int goldGained) {
    return '+$goldGained Gold';
  }

  @override
  String get dungeonResultVictoryBonus =>
      'Clear Bonus x1.5 + Boss Defeat Bonus';

  @override
  String get dungeonResultDefeatPenalty => 'Defeat Penalty: Rewards x0.5';

  @override
  String get dungeonResultReturnHomeButton => 'Return Home';

  @override
  String get cardBattleYourTurn => 'Your Turn';

  @override
  String get cardBattleEnemyTurn => 'Enemy Turn';

  @override
  String cardBattleTurnCount(int turnCount) {
    return 'Turn $turnCount';
  }

  @override
  String get cardBattleAbandonDialog => 'Forfeit Battle';

  @override
  String get cardBattleAbandonConfirmation =>
      'Forfeit this battle? Your progress will be lost.';

  @override
  String get cardBattleAbandonButton => 'Forfeit';

  @override
  String get cardBattleNoEnemies => 'No enemies';

  @override
  String get cardBattleEndTurnButton => 'End Turn';

  @override
  String get cardBattleNoCardsInHand => 'No cards in hand';

  @override
  String get cardBattleVictory => 'Victory!';

  @override
  String cardBattleGoldReward(int gold) {
    return '+$gold Gold';
  }

  @override
  String get cardBattleSelectCard => 'Select a card';

  @override
  String get cardBattleSkipButton => 'Skip';

  @override
  String get cardRarityCommon => 'Common';

  @override
  String get cardRarityUncommon => 'Uncommon';

  @override
  String get cardRarityRare => 'Rare';

  @override
  String get cardRarityLegendary => 'Legendary';

  @override
  String get cardCategoryAttack => 'Attack';

  @override
  String get cardCategoryMagic => 'Magic';

  @override
  String get cardCategoryDefense => 'Defense';

  @override
  String get cardCategoryTactical => 'Tactical';

  @override
  String get cardCollectionTitle => 'Card Collection';

  @override
  String get cardCollectionFilterAll => 'All';

  @override
  String get cardCollectionMyCollection => 'My Collection';

  @override
  String cardCollectionCardCount(int count) {
    return '($count cards)';
  }

  @override
  String get cardCollectionNoCards =>
      'You have no cards.\nComplete quests to obtain cards!';

  @override
  String cardCollectionDeckInclusion(int copyCount) {
    return '$copyCount in deck';
  }

  @override
  String get cardCollectionAddToDeck => 'Add to Deck';

  @override
  String get cardCollectionDeckFull => 'Deck full (20 cards)';

  @override
  String get cardCollectionMaxCopies => 'Max 3 copies allowed';

  @override
  String cardCollectionAddedToDeck(String cardName) {
    return '$cardName added to deck';
  }

  @override
  String get cardCollectionMyDeck => 'My Deck';

  @override
  String cardCollectionDeckSize(int deckSize) {
    return '($deckSize/20)';
  }

  @override
  String get cardCollectionResetDeckDialog => 'Reset Deck';

  @override
  String get cardCollectionResetDeckConfirmation =>
      'Delete custom deck and revert to default starter deck?';

  @override
  String get cardCollectionResetButton => 'Reset';

  @override
  String get cardCollectionDefaultDeckMessage =>
      'Using default starter deck\nAdd cards from your collection';

  @override
  String get cardNameBaseStrike => 'Basic Strike';

  @override
  String get cardDescBaseStrike => 'Deal 6 damage.';

  @override
  String get cardNameBaseDefend => 'Basic Block';

  @override
  String get cardDescBaseDefend => 'Gain 5 Block.';

  @override
  String get cardNameBaseFocus => 'Focus';

  @override
  String get cardDescBaseFocus => 'Draw 1 card.';

  @override
  String get cardNameCursePain => 'Pain';

  @override
  String get cardDescCursePain => 'Unplayable. Lose 1 HP whenever drawn.';

  @override
  String get cardNameCurseDoubt => 'Doubt';

  @override
  String get cardDescCurseDoubt => 'Unplayable. Draw 1 less card each turn.';

  @override
  String get cardNameCurseBurden => 'Burden';

  @override
  String get cardDescCurseBurden =>
      'Unplayable. Lose 1 Energy at the start of each turn.';

  @override
  String get cardNameCurseDecay => 'Decay';

  @override
  String get cardDescCurseDecay => 'Unplayable. Lose 3 Block each turn.';

  @override
  String get cardNameAtkC01 => 'Strike';

  @override
  String get cardDescAtkC01 => 'Deal 6 damage.';

  @override
  String get cardNameAtkC01Up => 'Strike+';

  @override
  String get cardDescAtkC01Up => 'Deal 9 damage.';

  @override
  String get cardNameAtkC02 => 'Slash';

  @override
  String get cardDescAtkC02 => 'Deal 4 damage. Draw 1 card.';

  @override
  String get cardNameAtkC02Up => 'Slash+';

  @override
  String get cardDescAtkC02Up => 'Deal 6 damage. Draw 1 card.';

  @override
  String get cardNameAtkC03 => 'Twin Strike';

  @override
  String get cardDescAtkC03 => 'Deal 3 damage twice.';

  @override
  String get cardNameAtkC03Up => 'Twin Strike+';

  @override
  String get cardDescAtkC03Up => 'Deal 3 damage three times.';

  @override
  String get cardNameAtkC04 => 'Rage Strike';

  @override
  String get cardDescAtkC04 => 'Deal 3 damage. Add 1 Rage card to discard.';

  @override
  String get cardNameAtkC04Up => 'Rage Strike+';

  @override
  String get cardDescAtkC04Up => 'Deal 5 damage.';

  @override
  String get cardNameAtkC05 => 'Charge';

  @override
  String get cardDescAtkC05 => 'Deal 12 damage.';

  @override
  String get cardNameAtkC05Up => 'Charge+';

  @override
  String get cardDescAtkC05Up => 'Deal 16 damage.';

  @override
  String get cardNameAtkC06 => 'Bleed';

  @override
  String get cardDescAtkC06 => 'Deal 4 damage. Apply 2 Poison.';

  @override
  String get cardNameAtkC06Up => 'Bleed+';

  @override
  String get cardDescAtkC06Up => 'Deal 4 damage. Apply 4 Poison.';

  @override
  String get cardNameAtkC07 => 'Quick Stab';

  @override
  String get cardDescAtkC07 => 'Deal 3 damage.';

  @override
  String get cardNameAtkC07Up => 'Quick Stab+';

  @override
  String get cardDescAtkC07Up => 'Deal 5 damage.';

  @override
  String get cardNameAtkC08 => 'Taunt';

  @override
  String get cardDescAtkC08 => 'Deal 5 damage. Apply 1 turn Vulnerable.';

  @override
  String get cardNameAtkC08Up => 'Taunt+';

  @override
  String get cardDescAtkC08Up => 'Deal 8 damage. Apply 1 turn Vulnerable.';

  @override
  String get cardNameAtkC09 => 'Ambush';

  @override
  String get cardDescAtkC09 => 'Deal 12 damage on the first turn, otherwise 6.';

  @override
  String get cardNameAtkC09Up => 'Ambush+';

  @override
  String get cardDescAtkC09Up =>
      'Deal 18 damage on the first turn, otherwise 9.';

  @override
  String get cardNameAtkC10 => 'Blade Storm';

  @override
  String get cardDescAtkC10 => 'Deal 3 damage to all enemies.';

  @override
  String get cardNameAtkC10Up => 'Blade Storm+';

  @override
  String get cardDescAtkC10Up => 'Deal 5 damage to all enemies.';

  @override
  String get cardNameAtkU01 => 'Power Slash';

  @override
  String get cardDescAtkU01 =>
      'Deal 14 damage and apply Vulnerable for 2 turns.';

  @override
  String get cardNameAtkU01Up => 'Power Slash+';

  @override
  String get cardDescAtkU01Up =>
      'Deal 18 damage and apply Vulnerable for 2 turns.';

  @override
  String get cardNameAtkU02 => 'Blade Dance';

  @override
  String get cardDescAtkU02 => 'Deal 3 damage 3 times and gain 3 Block.';

  @override
  String get cardNameAtkU02Up => 'Blade Dance+';

  @override
  String get cardDescAtkU02Up => 'Deal 4 damage 3 times and gain 5 Block.';

  @override
  String get cardNameAtkU03 => 'Execute';

  @override
  String get cardDescAtkU03 =>
      'Deal 30 damage if enemy HP ≤ 50%, otherwise 10 damage.';

  @override
  String get cardNameAtkU03Up => 'Execute+';

  @override
  String get cardDescAtkU03Up =>
      'Deal 40 damage if enemy HP ≤ 50%, otherwise 14 damage.';

  @override
  String get cardNameAtkU04 => 'Berserk';

  @override
  String get cardDescAtkU04 => 'Gain Strength +2 (permanent).';

  @override
  String get cardNameAtkU04Up => 'Berserk+';

  @override
  String get cardDescAtkU04Up => 'Gain Strength +3 (permanent).';

  @override
  String get cardNameAtkU05 => 'Blood Oath';

  @override
  String get cardDescAtkU05 =>
      'Lose 3 HP, deal 8 damage, and gain Strength +1.';

  @override
  String get cardNameAtkU05Up => 'Blood Oath+';

  @override
  String get cardDescAtkU05Up =>
      'Lose 3 HP, deal 12 damage, and gain Strength +1.';

  @override
  String get cardNameAtkU06 => 'Whirlwind';

  @override
  String get cardDescAtkU06 => 'Deal 8 damage to all enemies.';

  @override
  String get cardNameAtkU06Up => 'Whirlwind+';

  @override
  String get cardDescAtkU06Up => 'Deal 12 damage to all enemies.';

  @override
  String get cardNameAtkU07 => 'Crush';

  @override
  String get cardDescAtkU07 => 'Deal 10 damage and apply Weak for 2 turns.';

  @override
  String get cardNameAtkU07Up => 'Crush+';

  @override
  String get cardDescAtkU07Up => 'Deal 14 damage and apply Weak for 2 turns.';

  @override
  String get cardNameAtkU08 => 'Merciless';

  @override
  String get cardDescAtkU08 =>
      'Deal double damage to Vulnerable enemies (base 6 damage).';

  @override
  String get cardNameAtkU08Up => 'Merciless+';

  @override
  String get cardDescAtkU08Up =>
      'Deal double damage to Vulnerable enemies (base 9 damage).';

  @override
  String get cardNameAtkR01 => 'Dragon Strike';

  @override
  String get cardDescAtkR01 => 'Deal 30 damage and apply Burn for 3 turns.';

  @override
  String get cardNameAtkR01Up => 'Dragon Strike+';

  @override
  String get cardDescAtkR01Up => 'Deal 40 damage and apply Burn for 4 turns.';

  @override
  String get cardNameAtkR02 => 'Thousand Cuts';

  @override
  String get cardDescAtkR02 => 'Deal 1 damage for each card in hand.';

  @override
  String get cardNameAtkR02Up => 'Thousand Cuts+';

  @override
  String get cardDescAtkR02Up => 'Deal 2 damage for each card in hand.';

  @override
  String get cardNameAtkR03 => 'Storm Blade';

  @override
  String get cardDescAtkR03 => 'Deal 5 damage for each card played this turn.';

  @override
  String get cardNameAtkR03Up => 'Storm Blade+';

  @override
  String get cardDescAtkR03Up =>
      'Deal 7 damage for each card played this turn.';

  @override
  String get cardNameAtkR04 => 'Reaper\'s Scythe';

  @override
  String get cardDescAtkR04 => 'Deal 15 damage. Restore 10 HP on kill.';

  @override
  String get cardNameAtkR04Up => 'Reaper\'s Scythe+';

  @override
  String get cardDescAtkR04Up => 'Deal 20 damage. Restore 15 HP on kill.';

  @override
  String get cardNameAtkR05 => 'Berserk';

  @override
  String get cardDescAtkR05 =>
      'Gain Strength +5 for 3 turns, then lose Strength -5.';

  @override
  String get cardNameAtkR05Up => 'Berserk+';

  @override
  String get cardDescAtkR05Up =>
      'Gain Strength +7 for 3 turns, then lose Strength -5.';

  @override
  String get cardNameAtkL01 => 'Excalibur';

  @override
  String get cardDescAtkL01 =>
      'Deal 50 damage, apply Vulnerable+Weak for 3 turns. Exhaust.';

  @override
  String get cardNameAtkL01Up => 'Excalibur+';

  @override
  String get cardDescAtkL01Up =>
      'Deal 60 damage, apply Vulnerable+Weak for 3 turns. Exhaust.';

  @override
  String get cardNameAtkL02 => 'Infinite Blade';

  @override
  String get cardDescAtkL02 =>
      'Deal 8 damage. Permanently gains +2 damage on each use.';

  @override
  String get cardNameAtkL02Up => 'Infinite Blade+';

  @override
  String get cardDescAtkL02Up =>
      'Deal 12 damage. Permanently gains +2 damage on each use.';

  @override
  String get cardNameMagC01 => 'Fireball';

  @override
  String get cardDescMagC01 => 'Deal 4 damage and apply Burn for 2 turns.';

  @override
  String get cardNameMagC01Up => 'Fireball+';

  @override
  String get cardDescMagC01Up => 'Deal 6 damage and apply Burn for 3 turns.';

  @override
  String get cardNameMagC02 => 'Frost Arrow';

  @override
  String get cardDescMagC02 => 'Deal 5 damage and apply Weak for 1 turn.';

  @override
  String get cardNameMagC02Up => 'Frost Arrow+';

  @override
  String get cardDescMagC02Up => 'Deal 8 damage and apply Weak for 1 turn.';

  @override
  String get cardNameMagC03 => 'Mana Focus';

  @override
  String get cardDescMagC03 => 'Gain Energy +1 and draw 1 card.';

  @override
  String get cardNameMagC03Up => 'Mana Focus+';

  @override
  String get cardDescMagC03Up => 'Gain Energy +1 and draw 2 cards.';

  @override
  String get cardNameMagC04 => 'Shock';

  @override
  String get cardDescMagC04 => 'Deal 7 damage to a random enemy.';

  @override
  String get cardNameMagC04Up => 'Shock+';

  @override
  String get cardDescMagC04Up => 'Deal 10 damage to a random enemy.';

  @override
  String get cardNameMagC05 => 'Magic Missile';

  @override
  String get cardDescMagC05 => 'Deal 4 damage twice to random targets.';

  @override
  String get cardNameMagC05Up => 'Magic Missile+';

  @override
  String get cardDescMagC05Up => 'Deal 4 damage 3 times to random targets.';

  @override
  String get cardNameMagC06 => 'Meditate';

  @override
  String get cardDescMagC06 => 'Draw 2 cards.';

  @override
  String get cardNameMagC06Up => 'Meditate+';

  @override
  String get cardDescMagC06Up => 'Draw 3 cards.';

  @override
  String get cardNameMagC07 => 'Enlightenment';

  @override
  String get cardDescMagC07 =>
      'Look at the top 3 cards of your draw pile and take 1 into hand.';

  @override
  String get cardNameMagC07Up => 'Enlightenment+';

  @override
  String get cardDescMagC07Up =>
      'Look at the top 3 cards of your draw pile and take 2 into hand.';

  @override
  String get cardNameMagC08 => 'Toxic Mist';

  @override
  String get cardDescMagC08 => 'Apply 3 Poison to all enemies.';

  @override
  String get cardNameMagC08Up => 'Toxic Mist+';

  @override
  String get cardDescMagC08Up => 'Apply 5 Poison to all enemies.';

  @override
  String get cardNameMagC09 => 'Arcane Burst';

  @override
  String get cardDescMagC09 => 'Deal 10 damage and gain Focus +1.';

  @override
  String get cardNameMagC09Up => 'Arcane Burst+';

  @override
  String get cardDescMagC09Up => 'Deal 14 damage and gain Focus +1.';

  @override
  String get cardNameMagC10 => 'Elemental Harmony';

  @override
  String get cardDescMagC10 => 'Increase the next card\'s effect by 50%.';

  @override
  String get cardNameMagC10Up => 'Elemental Harmony+';

  @override
  String get cardDescMagC10Up => 'Increase the next card\'s effect by 100%.';

  @override
  String get cardNameMagU01 => 'Chain Lightning';

  @override
  String get cardDescMagU01 =>
      'Deal 8 damage and deal 4 damage to all enemies.';

  @override
  String get cardNameMagU01Up => 'Chain Lightning+';

  @override
  String get cardDescMagU01Up =>
      'Deal 12 damage and deal 6 damage to all enemies.';

  @override
  String get cardNameMagU02 => 'Glacial Eye';

  @override
  String get cardDescMagU02 => 'Deal 12 damage and apply Freeze.';

  @override
  String get cardNameMagU02Up => 'Glacial Eye+';

  @override
  String get cardDescMagU02Up => 'Deal 16 damage and apply Freeze.';

  @override
  String get cardNameMagU03 => 'Book of Wisdom';

  @override
  String get cardDescMagU03 => 'Draw 3 cards and exhaust 1.';

  @override
  String get cardNameMagU03Up => 'Book of Wisdom+';

  @override
  String get cardDescMagU03Up => 'Draw 4 cards.';

  @override
  String get cardNameMagU04 => 'Mana Overload';

  @override
  String get cardDescMagU04 => 'Gain Energy +2. Lose Energy -1 next turn.';

  @override
  String get cardNameMagU04Up => 'Mana Overload+';

  @override
  String get cardDescMagU04Up => 'Gain Energy +3.';

  @override
  String get cardNameMagU05 => 'Elemental Storm';

  @override
  String get cardDescMagU05 => 'Deal 15 damage to all enemies.';

  @override
  String get cardNameMagU05Up => 'Elemental Storm+';

  @override
  String get cardDescMagU05Up => 'Deal 20 damage to all enemies.';

  @override
  String get cardNameMagU06 => 'Time Warp';

  @override
  String get cardDescMagU06 => 'Gain an extra turn (0 Energy, keep hand).';

  @override
  String get cardNameMagU06Up => 'Time Warp+';

  @override
  String get cardDescMagU06Up => 'Gain an extra turn (start with 1 Energy).';

  @override
  String get cardNameMagU07 => 'Arcane Amplify';

  @override
  String get cardDescMagU07 => 'Gain Focus +2 (permanent).';

  @override
  String get cardNameMagU07Up => 'Arcane Amplify+';

  @override
  String get cardDescMagU07Up => 'Gain Focus +3 (permanent).';

  @override
  String get cardNameMagU08 => 'Replicate';

  @override
  String get cardDescMagU08 => 'Copy a card from your hand (this turn only).';

  @override
  String get cardNameMagU08Up => 'Replicate+';

  @override
  String get cardDescMagU08Up =>
      'Copy a card at cost 0 from your hand (this turn only).';

  @override
  String get cardNameMagR01 => 'Meteor';

  @override
  String get cardDescMagR01 =>
      'Deal 25 damage to all enemies and apply Burn for 3 turns.';

  @override
  String get cardNameMagR01Up => 'Meteor+';

  @override
  String get cardDescMagR01Up =>
      'Deal 35 damage to all enemies and apply Burn for 3 turns.';

  @override
  String get cardNameMagR02 => 'Mana Surge';

  @override
  String get cardDescMagR02 => 'All cards in hand cost 0 this turn.';

  @override
  String get cardNameMagR02Up => 'Mana Surge+';

  @override
  String get cardDescMagR02Up => 'All cards in hand cost 0 until next turn.';

  @override
  String get cardNameMagR03 => 'Rift';

  @override
  String get cardDescMagR03 => 'Retrieve 3 cards from your discard pile.';

  @override
  String get cardNameMagR03Up => 'Rift+';

  @override
  String get cardDescMagR03Up => 'Retrieve 5 cards from your discard pile.';

  @override
  String get cardNameMagR04 => 'Soul Drain';

  @override
  String get cardDescMagR04 =>
      'Deal 12 damage and restore the same amount as HP.';

  @override
  String get cardNameMagR04Up => 'Soul Drain+';

  @override
  String get cardDescMagR04Up =>
      'Deal 18 damage and restore the same amount as HP.';

  @override
  String get cardNameMagR05 => 'Absolute Zero';

  @override
  String get cardDescMagR05 => 'Freeze all enemies and deal 10 damage.';

  @override
  String get cardNameMagR05Up => 'Absolute Zero+';

  @override
  String get cardDescMagR05Up => 'Freeze all enemies and deal 15 damage.';

  @override
  String get cardNameMagL01 => 'Armageddon';

  @override
  String get cardDescMagL01 =>
      'Deal 99 damage to all enemies. Take 30 damage yourself. Exhaust.';

  @override
  String get cardNameMagL01Up => 'Armageddon+';

  @override
  String get cardDescMagL01Up =>
      'Deal 99 damage to all enemies. Take 15 damage yourself. Exhaust.';

  @override
  String get cardNameMagL02 => 'Infinite Wisdom';

  @override
  String get cardDescMagL02 => 'Draw 5 cards and gain Energy +2. Exhaust.';

  @override
  String get cardNameMagL02Up => 'Infinite Wisdom+';

  @override
  String get cardDescMagL02Up => 'Draw 7 cards and gain Energy +3. Exhaust.';
}
