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
  String get loginForgotPassword => 'Forgot your password?';

  @override
  String get loginForgotPasswordEmailRequired =>
      'Please enter your email first.';

  @override
  String loginForgotPasswordSent(String email) {
    return 'Password reset email sent to $email.';
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
  String get inventoryGoDungeon => 'Go to Dungeon';

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
  String get settingsNotificationMorning => 'Morning notification time';

  @override
  String get settingsNotificationNight => 'Evening notification time';

  @override
  String settingsNotificationTimeValue(int hour) {
    return 'Daily at $hour:00';
  }

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSubtitle => 'Choose the app display language.';

  @override
  String get settingsLanguageSystem => 'System default';

  @override
  String get settingsLanguageKorean => '한국어';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageJapanese => '日本語';

  @override
  String get settingsLanguageChinese => '中文';

  @override
  String get onboardingPage1Title => 'Daily Life as Quests';

  @override
  String get onboardingPage1Body =>
      'Register your tasks as quests.\nEarn XP and gold each time you complete one\nand watch your character grow.';

  @override
  String get onboardingPage2Title => 'Explore the Dungeon';

  @override
  String get onboardingPage2Body =>
      'Enter the Soul Deck dungeon\nand battle monsters with card combat.\nThe strength you build from quests becomes real power.';

  @override
  String get onboardingPage3Title => 'Start Your Adventure';

  @override
  String get onboardingPage3Body =>
      'Complete quests, clear dungeons,\nand collect achievements and titles.\nYour everyday life becomes an RPG.';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Start';

  @override
  String get onboardingSkip => 'Skip';

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
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsTerms => 'Terms of Service';

  @override
  String get settingsLegalSection => 'Legal';

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
  String dungeonHomeLockedHint(int requiredLevel) {
    return 'Unlocks at Lv.$requiredLevel — complete quests to level up';
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

  @override
  String get cardNameDefC01 => 'Guard';

  @override
  String get cardDescDefC01 => 'Gain 5 Block.';

  @override
  String get cardNameDefC01Up => 'Guard+';

  @override
  String get cardDescDefC01Up => 'Gain 8 Block.';

  @override
  String get cardNameDefC02 => 'Iron Wall';

  @override
  String get cardDescDefC02 => 'Gain 12 Block.';

  @override
  String get cardNameDefC02Up => 'Iron Wall+';

  @override
  String get cardDescDefC02Up => 'Gain 16 Block.';

  @override
  String get cardNameDefC03 => 'Counter';

  @override
  String get cardDescDefC03 => 'Gain 4 Block and gain 2 Thorns.';

  @override
  String get cardNameDefC03Up => 'Counter+';

  @override
  String get cardDescDefC03Up => 'Gain 6 Block and gain 3 Thorns.';

  @override
  String get cardNameDefC04 => 'Prayer of Recovery';

  @override
  String get cardDescDefC04 => 'Restore 4 HP.';

  @override
  String get cardNameDefC04Up => 'Prayer of Recovery+';

  @override
  String get cardDescDefC04Up => 'Restore 7 HP.';

  @override
  String get cardNameDefC05 => 'Battle Stance';

  @override
  String get cardDescDefC05 => 'Gain 6 Block and draw 1 card.';

  @override
  String get cardNameDefC05Up => 'Battle Stance+';

  @override
  String get cardDescDefC05Up => 'Gain 8 Block and draw 1 card.';

  @override
  String get cardNameDefC06 => 'Roll';

  @override
  String get cardDescDefC06 => 'Gain 3 Block. Gain 6 Block next turn.';

  @override
  String get cardNameDefC06Up => 'Roll+';

  @override
  String get cardDescDefC06Up => 'Gain 5 Block. Gain 8 Block next turn.';

  @override
  String get cardNameDefC07 => 'First Aid';

  @override
  String get cardDescDefC07 => 'Restore 3 HP.';

  @override
  String get cardNameDefC07Up => 'First Aid+';

  @override
  String get cardDescDefC07Up => 'Restore 5 HP.';

  @override
  String get cardNameDefC08 => 'Endurance';

  @override
  String get cardDescDefC08 => 'Gain 5 Block and Stalwart for 1 turn.';

  @override
  String get cardNameDefC08Up => 'Endurance+';

  @override
  String get cardDescDefC08Up => 'Gain 7 Block and Stalwart for 2 turns.';

  @override
  String get cardNameDefC09 => 'Vitality';

  @override
  String get cardDescDefC09 => 'Gain Regeneration 3 for 3 turns.';

  @override
  String get cardNameDefC09Up => 'Vitality+';

  @override
  String get cardDescDefC09Up => 'Gain Regeneration 4 for 4 turns.';

  @override
  String get cardNameDefC10 => 'Taunt Shield';

  @override
  String get cardDescDefC10 => 'Gain 6 Block and taunt 1 enemy.';

  @override
  String get cardNameDefC10Up => 'Taunt Shield+';

  @override
  String get cardDescDefC10Up => 'Gain 9 Block and taunt 1 enemy.';

  @override
  String get cardNameDefU01 => 'Barricade';

  @override
  String get cardDescDefU01 => 'Gain 12 Block and Stalwart for 2 turns.';

  @override
  String get cardNameDefU01Up => 'Barricade+';

  @override
  String get cardDescDefU01Up => 'Gain 16 Block and Stalwart for 3 turns.';

  @override
  String get cardNameDefU02 => 'Reflective Shield';

  @override
  String get cardDescDefU02 => 'Gain 8 Block and 5 Thorns this turn.';

  @override
  String get cardNameDefU02Up => 'Reflective Shield+';

  @override
  String get cardDescDefU02Up => 'Gain 12 Block and 7 Thorns this turn.';

  @override
  String get cardNameDefU03 => 'Prayer of Healing';

  @override
  String get cardDescDefU03 =>
      'Restore 10 HP and gain Regeneration 2 for 3 turns.';

  @override
  String get cardNameDefU03Up => 'Prayer of Healing+';

  @override
  String get cardDescDefU03Up =>
      'Restore 15 HP and gain Regeneration 3 for 3 turns.';

  @override
  String get cardNameDefU04 => 'Indomitable Will';

  @override
  String get cardDescDefU04 => 'Gain Dexterity +2 (permanent).';

  @override
  String get cardNameDefU04Up => 'Indomitable Will+';

  @override
  String get cardDescDefU04Up => 'Gain Dexterity +3 (permanent).';

  @override
  String get cardNameDefU05 => 'Protective Barrier';

  @override
  String get cardDescDefU05 => 'Gain Block equal to 25% of missing HP.';

  @override
  String get cardNameDefU05Up => 'Protective Barrier+';

  @override
  String get cardDescDefU05Up => 'Gain Block equal to 30% of missing HP.';

  @override
  String get cardNameDefU06 => 'Survival Instinct';

  @override
  String get cardDescDefU06 => 'Gain 15 Block if HP ≤ 50%, otherwise 5.';

  @override
  String get cardNameDefU06Up => 'Survival Instinct+';

  @override
  String get cardDescDefU06Up => 'Gain 20 Block if HP ≤ 50%, otherwise 8.';

  @override
  String get cardNameDefU07 => 'Vampiric Thorns';

  @override
  String get cardDescDefU07 =>
      'Gain 3 Thorns (permanent). Restore 1 HP when struck.';

  @override
  String get cardNameDefU07Up => 'Vampiric Thorns+';

  @override
  String get cardDescDefU07Up =>
      'Gain 4 Thorns (permanent). Restore 2 HP when struck.';

  @override
  String get cardNameDefU08 => 'Reinforced Armor';

  @override
  String get cardDescDefU08 => 'Gain 20 Block. Gain 10 Block next turn.';

  @override
  String get cardNameDefU08Up => 'Reinforced Armor+';

  @override
  String get cardDescDefU08Up => 'Gain 25 Block. Gain 15 Block next turn.';

  @override
  String get cardNameDefR01 => 'Invincible';

  @override
  String get cardDescDefR01 => 'Reduce all damage to 0 this turn. Exhaust.';

  @override
  String get cardNameDefR01Up => 'Invincible+';

  @override
  String get cardDescDefR01Up =>
      'Reduce all damage to 0 this turn and next. Exhaust.';

  @override
  String get cardNameDefR02 => 'Tree of Life';

  @override
  String get cardDescDefR02 => 'Restore 30% of max HP.';

  @override
  String get cardNameDefR02Up => 'Tree of Life+';

  @override
  String get cardDescDefR02Up => 'Restore 40% of max HP.';

  @override
  String get cardNameDefR03 => 'Holy Shield';

  @override
  String get cardDescDefR03 => 'Gain 20 Block and remove all debuffs.';

  @override
  String get cardNameDefR03Up => 'Holy Shield+';

  @override
  String get cardDescDefR03Up => 'Gain 28 Block and remove all debuffs.';

  @override
  String get cardNameDefR04 => 'Iron Body';

  @override
  String get cardDescDefR04 =>
      'Automatically gain 8 Block each turn (during combat).';

  @override
  String get cardNameDefR04Up => 'Iron Body+';

  @override
  String get cardDescDefR04Up =>
      'Automatically gain 12 Block each turn (during combat).';

  @override
  String get cardNameDefR05 => 'Elixir of Rebirth';

  @override
  String get cardDescDefR05 =>
      'Revive with 30% HP on death this combat. Exhaust.';

  @override
  String get cardNameDefR05Up => 'Elixir of Rebirth+';

  @override
  String get cardDescDefR05Up =>
      'Revive with 50% HP on death this combat. Exhaust.';

  @override
  String get cardNameDefL01 => 'Eternal Shield';

  @override
  String get cardDescDefL01 =>
      'Gain 30 Block and automatically gain 5 Block each turn (during combat). Exhaust.';

  @override
  String get cardNameDefL01Up => 'Eternal Shield+';

  @override
  String get cardDescDefL01Up =>
      'Gain 40 Block and automatically gain 8 Block each turn (during combat). Exhaust.';

  @override
  String get cardNameDefL02 => 'Font of Life';

  @override
  String get cardDescDefL02 =>
      'Fully restore HP and gain max HP +10 (permanent). Exhaust.';

  @override
  String get cardNameDefL02Up => 'Font of Life+';

  @override
  String get cardDescDefL02Up =>
      'Fully restore HP and gain max HP +20 (permanent). Exhaust.';

  @override
  String get cardNameTacC01 => 'Observe';

  @override
  String get cardDescTacC01 => 'Check enemy intent and draw 1 card.';

  @override
  String get cardNameTacC01Up => 'Observe+';

  @override
  String get cardDescTacC01Up => 'Check enemy intent and draw 2 cards.';

  @override
  String get cardNameTacC02 => 'Treasure Hunt';

  @override
  String get cardDescTacC02 => 'Battle gold +15.';

  @override
  String get cardNameTacC02Up => 'Treasure Hunt+';

  @override
  String get cardDescTacC02Up => 'Battle gold +25.';

  @override
  String get cardNameTacC03 => 'Weak Point Scan';

  @override
  String get cardDescTacC03 => 'Apply Vulnerable 2 turns and Weak 1 turn.';

  @override
  String get cardNameTacC03Up => 'Weak Point Scan+';

  @override
  String get cardDescTacC03Up => 'Apply Vulnerable 2 turns and Weak 2 turns.';

  @override
  String get cardNameTacC04 => 'Quick Hands';

  @override
  String get cardDescTacC04 => 'Draw 2 cards.';

  @override
  String get cardNameTacC04Up => 'Quick Hands+';

  @override
  String get cardDescTacC04Up => 'Draw 3 cards.';

  @override
  String get cardNameTacC05 => 'Set Trap';

  @override
  String get cardDescTacC05 => 'Reflect 10 damage on the next enemy attack.';

  @override
  String get cardNameTacC05Up => 'Set Trap+';

  @override
  String get cardDescTacC05Up => 'Reflect 15 damage on the next enemy attack.';

  @override
  String get cardNameTacC06 => 'Disrupt';

  @override
  String get cardDescTacC06 => 'Change enemy intent (random).';

  @override
  String get cardNameTacC06Up => 'Disrupt+';

  @override
  String get cardDescTacC06Up => 'Change enemy intent and apply Weak 1 turn.';

  @override
  String get cardNameTacC07 => 'Pickpocket';

  @override
  String get cardDescTacC07 => 'Deal 3 damage and gain 5~15 gold.';

  @override
  String get cardNameTacC07Up => 'Pickpocket+';

  @override
  String get cardDescTacC07Up => 'Deal 6 damage and gain 10~25 gold.';

  @override
  String get cardNameTacC08 => 'Smoke Bomb';

  @override
  String get cardDescTacC08 =>
      'Gain 4 Block and apply Weak 1 turn to all enemies.';

  @override
  String get cardNameTacC08Up => 'Smoke Bomb+';

  @override
  String get cardDescTacC08Up =>
      'Gain 6 Block and apply Weak 2 turns to all enemies.';

  @override
  String get cardNameTacC09 => 'Encourage';

  @override
  String get cardDescTacC09 => 'Upgrade a random card for this combat.';

  @override
  String get cardNameTacC09Up => 'Encourage+';

  @override
  String get cardDescTacC09Up => 'Upgrade 2 random cards for this combat.';

  @override
  String get cardNameTacC10 => 'Lucky Coin';

  @override
  String get cardDescTacC10 => '50% chance to draw 2 cards.';

  @override
  String get cardNameTacC10Up => 'Lucky Coin+';

  @override
  String get cardDescTacC10Up => '70% chance to draw 2 cards.';

  @override
  String get cardNameTacU01 => 'Battlefield Analysis';

  @override
  String get cardDescTacU01 =>
      'Draw 3 cards and reduce the cost of the highest-cost card to 0 this turn.';

  @override
  String get cardNameTacU01Up => 'Battlefield Analysis+';

  @override
  String get cardDescTacU01Up =>
      'Draw 4 cards and reduce the cost of the highest-cost card to 0 this turn.';

  @override
  String get cardNameTacU02 => 'Shadow Step';

  @override
  String get cardDescTacU02 => 'Reduce incoming damage by 50% until next turn.';

  @override
  String get cardNameTacU02Up => 'Shadow Step+';

  @override
  String get cardDescTacU02Up =>
      'Reduce incoming damage by 50% until next turn and draw 1 card.';

  @override
  String get cardNameTacU03 => 'Treasure Chest';

  @override
  String get cardDescTacU03 => 'Activate a random relic effect once. Exhaust.';

  @override
  String get cardNameTacU03Up => 'Treasure Chest+';

  @override
  String get cardDescTacU03Up =>
      'Activate a random relic effect twice. Exhaust.';

  @override
  String get cardNameTacU04 => 'Card Manipulation';

  @override
  String get cardDescTacU04 =>
      'Arrange the top 3 cards of your draw pile in any order.';

  @override
  String get cardNameTacU04Up => 'Card Manipulation+';

  @override
  String get cardDescTacU04Up =>
      'Arrange the top 5 cards of your draw pile in any order.';

  @override
  String get cardNameTacU05 => 'Double Agent';

  @override
  String get cardDescTacU05 => 'Copy and remove an enemy buff.';

  @override
  String get cardNameTacU05Up => 'Double Agent+';

  @override
  String get cardDescTacU05Up =>
      'Copy and remove an enemy buff and deal 5 damage.';

  @override
  String get cardNameTacU06 => 'Strategic Retreat';

  @override
  String get cardDescTacU06 => 'Shuffle your hand and draw 5 new cards.';

  @override
  String get cardNameTacU06Up => 'Strategic Retreat+';

  @override
  String get cardDescTacU06Up => 'Shuffle your hand and draw 6 new cards.';

  @override
  String get cardNameTacU07 => 'Barter';

  @override
  String get cardDescTacU07 =>
      'Exhaust 1 card from hand and create 2 random cards.';

  @override
  String get cardNameTacU07Up => 'Barter+';

  @override
  String get cardDescTacU07Up =>
      'Exhaust 1 card from hand and create 3 random cards.';

  @override
  String get cardNameTacU08 => 'Chain Trap';

  @override
  String get cardDescTacU08 =>
      'Gain Thorns 3 (permanent). Apply Weak 1 turn when struck.';

  @override
  String get cardNameTacU08Up => 'Chain Trap+';

  @override
  String get cardDescTacU08Up =>
      'Gain Thorns 5 (permanent). Apply Weak 1 turn when struck.';

  @override
  String get cardNameTacR01 => 'Perfect Plan';

  @override
  String get cardDescTacR01 =>
      'Gain Energy +3 and draw 3 cards. Draw 0 next turn.';

  @override
  String get cardNameTacR01Up => 'Perfect Plan+';

  @override
  String get cardDescTacR01Up =>
      'Gain Energy +3 and draw 3 cards. Draw 2 next turn.';

  @override
  String get cardNameTacR02 => 'Wheel of Fate';

  @override
  String get cardDescTacR02 =>
      'Apply a random effect once: 15 damage, 15 Block, 15 HP, or Energy +2.';

  @override
  String get cardNameTacR02Up => 'Wheel of Fate+';

  @override
  String get cardDescTacR02Up =>
      'Apply a random effect twice: 15 damage, 15 Block, 15 HP, or Energy +2.';

  @override
  String get cardNameTacR03 => 'Doppelganger';

  @override
  String get cardDescTacR03 =>
      'Return all cards played this turn to your hand.';

  @override
  String get cardNameTacR03Up => 'Doppelganger+';

  @override
  String get cardDescTacR03Up =>
      'Return all cards played this turn to your hand and gain Energy +2.';

  @override
  String get cardNameTacR04 => 'Greedy Hand';

  @override
  String get cardDescTacR04 =>
      'Deal 6 damage. On kill, gain 1 additional card reward.';

  @override
  String get cardNameTacR04Up => 'Greedy Hand+';

  @override
  String get cardDescTacR04Up =>
      'Deal 10 damage. On kill, gain 1 additional card reward.';

  @override
  String get cardNameTacR05 => 'Total Chaos';

  @override
  String get cardDescTacR05 =>
      'Apply Vulnerable + Weak 2 turns and Poison 3 to all enemies.';

  @override
  String get cardNameTacR05Up => 'Total Chaos+';

  @override
  String get cardDescTacR05Up =>
      'Apply Vulnerable + Weak 3 turns and Poison 3 to all enemies.';

  @override
  String get cardNameTacL01 => 'Master of Time';

  @override
  String get cardDescTacL01 => 'Gain 2 extra turns (Energy 2 each). Exhaust.';

  @override
  String get cardNameTacL01Up => 'Master of Time+';

  @override
  String get cardDescTacL01Up => 'Gain 2 extra turns (Energy 3 each). Exhaust.';

  @override
  String get cardNameTacL02 => 'Fate Conversion';

  @override
  String get cardDescTacL02 =>
      'Upgrade all cards in your deck for this combat. Exhaust.';

  @override
  String get cardNameTacL02Up => 'Fate Conversion+';

  @override
  String get cardDescTacL02Up =>
      'Upgrade all cards in your deck for this combat and gain Energy +2. Exhaust.';

  @override
  String get relicNameStart01 => 'Adventurer\'s Bag';

  @override
  String get relicDescStart01 => 'Combat card reward choices +1 (3→4)';

  @override
  String get relicNameStart02 => 'Worn Amulet';

  @override
  String get relicDescStart02 => 'Start with +15 HP';

  @override
  String get relicNameStart03 => 'Lucky Coin';

  @override
  String get relicDescStart03 => 'Combat gold reward +30%';

  @override
  String get relicNameC01 => 'Anchor';

  @override
  String get relicDescC01 => 'Gain 4 Block at the start of each turn';

  @override
  String get relicNameC02 => 'Red Potion';

  @override
  String get relicDescC02 => 'Restore 5 HP at combat start';

  @override
  String get relicNameC03 => 'Mana Orb';

  @override
  String get relicDescC03 => 'Gain Energy +1 every 3 turns';

  @override
  String get relicNameC04 => 'Sharp Whetstone';

  @override
  String get relicDescC04 => 'First attack card deals +3 damage';

  @override
  String get relicNameC05 => 'Thief\'s Gloves';

  @override
  String get relicDescC05 => 'Gain +15 gold from combat rewards';

  @override
  String get relicNameC06 => 'Light Boots';

  @override
  String get relicDescC06 => 'Draw +2 cards on the first turn';

  @override
  String get relicNameC07 => 'Poison Sack';

  @override
  String get relicDescC07 => 'Apply Poison 2 to all enemies at combat start';

  @override
  String get relicNameC08 => 'Thorn Shield';

  @override
  String get relicDescC08 => 'Thorns 1 (permanent)';

  @override
  String get relicNameC09 => 'Focus Ring';

  @override
  String get relicDescC09 => 'Playing a 0-cost card grants 2 Block';

  @override
  String get relicNameC10 => 'Warrior\'s Bracelet';

  @override
  String get relicDescC10 =>
      'Gain Energy +1 if hand contains only attack cards';

  @override
  String get relicNameU01 => 'Frost Heart';

  @override
  String get relicDescU01 =>
      '20% chance to apply Weak 1 turn on attack card play';

  @override
  String get relicNameU02 => 'Philosopher\'s Stone';

  @override
  String get relicDescU02 => 'Magic card damage +25%';

  @override
  String get relicNameU03 => 'Phoenix Feather';

  @override
  String get relicDescU03 => 'Revive once with 30% HP on death';

  @override
  String get relicNameU04 => 'Sands of Time';

  @override
  String get relicDescU04 => 'Gain Energy +1 for the first 3 turns';

  @override
  String get relicNameU05 => 'Soul Harvester';

  @override
  String get relicDescU05 => 'Restore 5 HP on enemy kill';

  @override
  String get relicNameU06 => 'Magic Mirror';

  @override
  String get relicDescU06 => 'Reflect the first debuff (once)';

  @override
  String get relicNameU07 => 'Explorer\'s Map';

  @override
  String get relicDescU07 => 'Reveal all nodes on the next floor';

  @override
  String get relicNameU08 => 'Alchemist\'s Bag';

  @override
  String get relicDescU08 => 'Remove one card at the shop for free (once)';

  @override
  String get relicNameR01 => 'Dragon Scale';

  @override
  String get relicDescR01 => 'Reduce incoming damage by 1 (all attacks)';

  @override
  String get relicNameR02 => 'Third Eye';

  @override
  String get relicDescR02 => 'Show enemy intent as exact numbers';

  @override
  String get relicNameR03 => 'Infinite Pouch';

  @override
  String get relicDescR03 => 'Maximum hand size +1 (6 cards)';

  @override
  String get relicNameR04 => 'Awakening Orb';

  @override
  String get relicDescR04 => 'Maximum energy +1 (3→4)';

  @override
  String get relicNameR05 => 'Thread of Fate';

  @override
  String get relicDescR05 => 'Double the chance of Rare+ card rewards';

  @override
  String get relicNameB01 => 'Crown';

  @override
  String get relicDescB01 => 'Max energy +1, start with 1 curse';

  @override
  String get relicNameB02 => 'Demon King\'s Heart';

  @override
  String get relicDescB02 => 'All card damage +5, incoming damage +5';

  @override
  String get relicNameB03 => 'Holy Grail';

  @override
  String get relicDescB03 => 'Fully restore HP at rest nodes';

  @override
  String get relicNameB04 => 'Chaos Orb';

  @override
  String get relicDescB04 => 'Generate 1 random card in hand each turn';

  @override
  String get relicNameB05 => 'Crown of Time';

  @override
  String get relicDescB05 => 'Gain 1 extra turn on the first turn';

  @override
  String get achievementNameAc1 => 'First Step';

  @override
  String get achievementDescAc1 => 'Complete 1 quest';

  @override
  String get achievementNameAc2 => 'Diligence Emblem';

  @override
  String get achievementDescAc2 => 'Complete 10 quests';

  @override
  String get achievementNameAc3 => 'Level 5 Achieved';

  @override
  String get achievementDescAc3 => 'Escape novice adventurer status';

  @override
  String get achievementNameAc4 => 'Strength Awakening';

  @override
  String get achievementDescAc4 => 'Reach Strength stat 10';

  @override
  String get achievementNameAc5 => 'Wisdom Begins';

  @override
  String get achievementDescAc5 => 'Reach Wisdom stat 10';

  @override
  String get achievementNameAc6 => 'Reaching the Summit';

  @override
  String get achievementDescAc6 => 'Reach level 20';

  @override
  String get achievementNameAc7 => 'Skill Seeker';

  @override
  String get achievementDescAc7 => 'Learn 5 skills';

  @override
  String get achievementNameAc8 => 'Health Master';

  @override
  String get achievementDescAc8 => 'Reach Health stat 50';

  @override
  String get achievementNameAc9 => 'Grand Sage';

  @override
  String get achievementDescAc9 => 'Reach Wisdom stat 50';

  @override
  String get achievementNameAc10 => 'Quest Addict';

  @override
  String get achievementDescAc10 => 'Complete 500 quests';

  @override
  String get achievementNameAc11 => 'Consistent Practitioner';

  @override
  String get achievementDescAc11 => 'Complete 50 quests';

  @override
  String get achievementNameAc12 => 'Habit Master';

  @override
  String get achievementDescAc12 => 'Complete 100 quests';

  @override
  String get achievementNameAc13 => 'Veteran Adventurer';

  @override
  String get achievementDescAc13 => 'Reach level 30';

  @override
  String get achievementNameAc14 => 'Legendary Hero';

  @override
  String get achievementDescAc14 => 'Reach level 50';

  @override
  String get achievementNameAc15 => 'King of Muscles';

  @override
  String get achievementDescAc15 => 'Reach Strength stat 100';

  @override
  String get achievementNameAc16 => 'Skill Master';

  @override
  String get achievementDescAc16 => 'Learn 12 skills';

  @override
  String get achievementNameAc17 => 'Jack of All Trades';

  @override
  String get achievementDescAc17 => 'Learn 20 skills';

  @override
  String get achievementNameAc18 => 'First Hunt';

  @override
  String get achievementDescAc18 => 'Defeat 1 monster';

  @override
  String get achievementNameAc19 => 'Novice Hunter';

  @override
  String get achievementDescAc19 => 'Defeat 10 monsters';

  @override
  String get achievementNameAc20 => 'Veteran Warrior';

  @override
  String get achievementDescAc20 => 'Defeat 50 monsters';

  @override
  String get achievementNameAc21 => 'Slayer';

  @override
  String get achievementDescAc21 => 'Defeat 200 monsters';

  @override
  String get achievementNameAc22 => 'Legendary Explorer';

  @override
  String get achievementDescAc22 => 'Complete 1000 quests';

  @override
  String get achievementNameAc23 => 'Level 10 Achieved';

  @override
  String get achievementDescAc23 => 'Shed the beginner label!';

  @override
  String get achievementNameAc24 => 'Charm Star';

  @override
  String get achievementDescAc24 => 'Reach Charisma stat 30';

  @override
  String get achievementNameAc25 => 'King of Charisma';

  @override
  String get achievementDescAc25 => 'Reach Charisma stat 80';

  @override
  String get titleNameT0 => 'Sprout Adventurer';

  @override
  String get titleDescT0 => 'Everything is a new beginning';

  @override
  String get titleNameT1 => 'Diligent Adventurer';

  @override
  String get titleDescT1 => 'Perseverance is a virtue';

  @override
  String get titleNameT2 => 'Seasoned Pioneer';

  @override
  String get titleDescT2 => 'One who walks their own path';

  @override
  String get titleNameT3 => 'Strength Maniac';

  @override
  String get titleDescT3 => 'Strength quest XP +5%';

  @override
  String get titleNameT4 => 'Aspiring Sage';

  @override
  String get titleDescT4 => 'Wisdom quest XP +5%';

  @override
  String get titleNameT5 => 'Iron Stamina';

  @override
  String get titleDescT5 => 'Health quest XP +5%';

  @override
  String get titleNameT6 => 'Beloved by All';

  @override
  String get titleDescT6 => 'Charisma quest XP +5%';

  @override
  String get titleNameT7 => 'Incarnation of Diligence';

  @override
  String get titleDescT7 => 'Complete 100 quests';

  @override
  String get titleNameT8 => 'Jack of All Trades';

  @override
  String get titleDescT8 => 'Reach all stats 20';

  @override
  String get titleNameT9 => 'Quest Artisan';

  @override
  String get titleDescT9 => 'Complete 250 quests';

  @override
  String get titleNameT10 => 'Toward the Peak';

  @override
  String get titleDescT10 => 'Reach level 30';

  @override
  String get titleNameT11 => 'Legendary Warrior';

  @override
  String get titleDescT11 => 'Reach level 40';

  @override
  String get titleNameT12 => 'Hero of the World';

  @override
  String get titleDescT12 => 'Reach level 50';

  @override
  String get titleNameT13 => 'Avatar of Destruction';

  @override
  String get titleDescT13 => 'Strength quest XP +10%';

  @override
  String get titleNameT14 => 'Grand Sage';

  @override
  String get titleDescT14 => 'Wisdom quest XP +10%';

  @override
  String get titleNameT15 => 'Immortal Warrior';

  @override
  String get titleDescT15 => 'Health quest XP +10%';

  @override
  String get titleNameT16 => 'Absolute Charisma';

  @override
  String get titleDescT16 => 'Charisma quest XP +10%';

  @override
  String get titleNameT17 => 'Quest Legend';

  @override
  String get titleDescT17 => 'Complete 500 quests';

  @override
  String get titleNameT18 => 'God of Quests';

  @override
  String get titleDescT18 => 'Complete 1000 quests';

  @override
  String get titleNameT19 => 'Master of All';

  @override
  String get titleDescT19 => 'Reach all stats 50';

  @override
  String get titleNameT20 => 'Novice Camper';

  @override
  String get titleDescT20 => 'Reach level 3';

  @override
  String get titleNameT21 => 'Experienced Traveler';

  @override
  String get titleDescT21 => 'Reach level 20';

  @override
  String get titleNameT22 => 'Pinnacle of Strength';

  @override
  String get titleDescT22 => 'Reach Strength 100!';

  @override
  String get titleNameT23 => 'Pinnacle of Wisdom';

  @override
  String get titleDescT23 => 'Reach Wisdom 100!';

  @override
  String get titleNameT24 => 'Monthly Raid Breaker';

  @override
  String get titleDescT24 => 'Clear Monthly Raid 1 time';

  @override
  String get titleNameT25 => 'Monthly Raid Conqueror';

  @override
  String get titleDescT25 => 'Clear Monthly Raid 5 times';

  @override
  String get titleNameT26 => 'Yearly Raid Survivor';

  @override
  String get titleDescT26 => 'Clear Yearly Raid 1 time';

  @override
  String get titleNameT27 => 'Yearly Raid Lord';

  @override
  String get titleDescT27 => 'Clear Yearly Raid 3 times';

  @override
  String get skillNameSk1 => 'Strength Training';

  @override
  String get skillDescSk1 => 'Strength quest XP +10%';

  @override
  String get skillNameSk2 => 'Light of Wisdom';

  @override
  String get skillDescSk2 => 'Wisdom quest XP +10%';

  @override
  String get skillNameSk3 => 'Healthy Body';

  @override
  String get skillDescSk3 => 'Health quest XP +10%';

  @override
  String get skillNameSk4 => 'Charm Release';

  @override
  String get skillDescSk4 => 'Charisma quest XP +10%';

  @override
  String get skillNameSk5 => 'Quest Expert';

  @override
  String get skillDescSk5 => 'All quest XP +5%';

  @override
  String get skillNameSk6 => 'Joy of Growth';

  @override
  String get skillDescSk6 => 'Gain +1 SP on level up';

  @override
  String get skillNameSk7 => 'Focused Training';

  @override
  String get skillDescSk7 => 'Gain +2 stats per SP spent';

  @override
  String get skillNameSk8 => 'Accelerated Learning';

  @override
  String get skillDescSk8 => 'All quest XP +10%';

  @override
  String get skillNameSk9 => 'Transcendent Growth';

  @override
  String get skillDescSk9 => 'Base SP on level up: 5 → 7';

  @override
  String get skillNameSk10 => 'Flame Slash';

  @override
  String get skillDescSk10 => 'Combat: Deal 25 bonus damage';

  @override
  String get skillNameSk11 => 'Healing Light';

  @override
  String get skillDescSk11 => 'Combat: Restore 20 HP';

  @override
  String get skillNameSk12 => 'Lightning Strike';

  @override
  String get skillDescSk12 => 'Combat: Deal 50 damage';

  @override
  String get skillNameSk13 => 'Blizzard Magic';

  @override
  String get skillDescSk13 => 'Combat: Deal 35 damage';

  @override
  String get skillNameSk14 => 'Poison Mist';

  @override
  String get skillDescSk14 => 'Combat: Deal 30 damage';

  @override
  String get skillNameSk15 => 'Shield';

  @override
  String get skillDescSk15 => 'Combat: Restore 40 HP';

  @override
  String get skillNameSk16 => 'Earthquake';

  @override
  String get skillDescSk16 => 'Combat: Deal 70 damage';

  @override
  String get skillNameSk17 => 'Holy Prayer';

  @override
  String get skillDescSk17 => 'Combat: Restore 60 HP';

  @override
  String get skillNameSk18 => 'Combat Instinct';

  @override
  String get skillDescSk18 => 'Strength quest XP +15%';

  @override
  String get skillNameSk19 => 'Meditative State';

  @override
  String get skillDescSk19 => 'Wisdom quest XP +15%';

  @override
  String get skillNameSk20 => 'Sword of Darkness';

  @override
  String get skillDescSk20 => 'Combat: Deal 100 damage';

  @override
  String get skillNameSk21 => 'Perfect Regeneration';

  @override
  String get skillDescSk21 => 'Combat: Restore 80 HP';

  @override
  String get skillNameSk22 => 'Extreme Efficiency';

  @override
  String get skillDescSk22 => 'Gain +3 stats per SP spent';

  @override
  String get skillNameSk23 => 'Transcendence Boost';

  @override
  String get skillDescSk23 => 'All quest XP +20%';

  @override
  String get skillNameSk24 => 'God\'s Blessing';

  @override
  String get skillDescSk24 => 'Gain +3 SP on level up';

  @override
  String get monsterSlimeGreen => 'Green Slime';

  @override
  String get monsterBat => 'Cave Bat';

  @override
  String get monsterMushroom => 'Poison Mushroom';

  @override
  String get monsterSlimeBlue => 'Blue Slime';

  @override
  String get monsterRat => 'Giant Rat';

  @override
  String get monsterGoblin => 'Goblin';

  @override
  String get monsterSkeleton => 'Skeleton Warrior';

  @override
  String get monsterWolf => 'Shadow Wolf';

  @override
  String get monsterSpiderGiant => 'Giant Tarantula';

  @override
  String get monsterTreant => 'Walking Tree';

  @override
  String get monsterOrc => 'Orc Warrior';

  @override
  String get monsterDarkMage => 'Dark Mage';

  @override
  String get monsterGolem => 'Stone Golem';

  @override
  String get monsterHarpy => 'Harpy';

  @override
  String get monsterMimic => 'Mimic';

  @override
  String get monsterLavaGolem => 'Lava Golem';

  @override
  String get monsterFireSpirit => 'Fire Spirit';

  @override
  String get monsterDemonWarrior => 'Demon Warrior';

  @override
  String get monsterSalamander => 'Salamander';

  @override
  String get monsterCerberus => 'Cerberus';

  @override
  String get monsterShadowKnight => 'Shadow Knight';

  @override
  String get monsterLich => 'Lich';

  @override
  String get monsterBehemoth => 'Behemoth';

  @override
  String get monsterDarkPhoenix => 'Dark Phoenix';

  @override
  String get monsterVoidWorm => 'Void Worm';

  @override
  String get monsterBossTroll => 'Troll Chief';

  @override
  String get monsterBossDragon => 'Fire Dragon';

  @override
  String get monsterBossDemonLord => 'Demon Lord';

  @override
  String get monsterBossHydra => 'Hydra';

  @override
  String get monsterBossFallenAngel => 'Fallen Angel';

  @override
  String get monsterBossDeathKnight => 'Death Knight';

  @override
  String get chapterName1 => 'Meadow Defense Line';

  @override
  String get chapterName2 => 'Dark Forest';

  @override
  String get chapterName3 => 'Ruined Castle';

  @override
  String get chapterName4 => 'Lava Dungeon';

  @override
  String get chapterName5 => 'Abyssal Dimension';
}
