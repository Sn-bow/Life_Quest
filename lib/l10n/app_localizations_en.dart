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
}
