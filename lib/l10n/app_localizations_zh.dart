// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get close => '关闭';

  @override
  String get confirm => '确认';

  @override
  String get delete => '删除';

  @override
  String get apply => '应用';

  @override
  String get change => '修改';

  @override
  String get complete => '完成';

  @override
  String get acquire => '习得';

  @override
  String get tabStatus => '状态';

  @override
  String get tabQuests => '任务';

  @override
  String get tabHunt => '狩猎';

  @override
  String get tabInventory => '背包';

  @override
  String get tabShop => '商店';

  @override
  String get tabAchievement => '成就';

  @override
  String get tabSkill => '技能';

  @override
  String get loginTitle => '将日常行动转化为经验值';

  @override
  String get loginSubtitle => '积累小任务，与角色共同成长的生产力RPG';

  @override
  String get loginEmailLabel => '邮箱';

  @override
  String get loginPasswordLabel => '密码';

  @override
  String get loginButton => '登录';

  @override
  String get loginRegisterButton => '注册新冒险者';

  @override
  String get loginDivider => '或';

  @override
  String get loginGoogleButton => '使用Google账号开始';

  @override
  String get loginErrorEmpty => '请输入邮箱和密码。';

  @override
  String get loginErrorFailed => '登录失败。';

  @override
  String get loginErrorGoogleToken => '无法获取Google认证令牌，请重试。';

  @override
  String get loginErrorGoogle => 'Google登录失败。';

  @override
  String loginErrorUnknown(String error) {
    return '发生错误: $error';
  }

  @override
  String get signupTitle => '注册新冒险者';

  @override
  String get signupPickPhoto => '选择头像';

  @override
  String get signupEmailLabel => '邮箱';

  @override
  String get signupEmailRequired => '请输入邮箱。';

  @override
  String get signupEmailInvalid => '请输入有效的邮箱格式。(例: name@example.com)';

  @override
  String get signupNicknameLabel => '昵称';

  @override
  String get signupNicknameRequired => '请输入昵称。';

  @override
  String get signupPasswordLabel => '密码';

  @override
  String get signupPasswordTooShort => '密码至少需要6个字符。';

  @override
  String get signupPasswordConfirmLabel => '确认密码';

  @override
  String get signupPasswordMismatch => '密码不匹配。';

  @override
  String get signupButton => '完成注册';

  @override
  String get signupSuccess => '🎉 注册成功！欢迎加入！';

  @override
  String get signupErrorFailed => '注册失败。';

  @override
  String signupErrorUnknown(String error) {
    return '发生未知错误: $error';
  }

  @override
  String get signupErrorUserCreate => '创建用户失败。';

  @override
  String get statusScreenTitle => '状态';

  @override
  String get statusTimerTooltip => '专注计时器';

  @override
  String get statusSettingsTooltip => '设置';

  @override
  String get statusHpLabel => 'HP';

  @override
  String get statusHpRecoveryHint => '非战斗状态下，每10分钟HP会自然缓慢恢复。';

  @override
  String statusStreakLabel(int days) {
    return '连续达成: $days天';
  }

  @override
  String statusStreakBonus(int percent) {
    return 'XP +$percent%';
  }

  @override
  String get statusStatHint => '升级时，3点根据最近完成任务的倾向自动成长，其余点数可自行分配。';

  @override
  String get statusGoldLabel => '金币';

  @override
  String get statusApLabel => '行动力';

  @override
  String get statusBaseStatTitle => '基础属性';

  @override
  String get statusDetailStatButton => '查看详细属性';

  @override
  String get statusDetailStatTitle => '📊 详细战斗属性';

  @override
  String get statusAttackLabel => '攻击力';

  @override
  String get statusDefenseLabel => '防御力';

  @override
  String get statusCritLabel => '暴击率';

  @override
  String get statusDodgeLabel => '闪避率';

  @override
  String get statusStatStrength => '力量';

  @override
  String get statusStatWisdom => '智慧';

  @override
  String get statusStatHealth => '健康';

  @override
  String get statusStatCharm => '魅力';

  @override
  String get statusTitleChangeTitle => '更换称号';

  @override
  String get statusStatApplyTitle => '确认属性分配';

  @override
  String statusStatApplyBody(String summary) {
    return '是否应用以下属性？\n\n$summary\n\n应用后无法撤销。';
  }

  @override
  String get questsScreenTitle => '任务列表';

  @override
  String get questsTabDaily => '每日任务';

  @override
  String get questsTabWeekly => '每周任务';

  @override
  String get questsTabMonthly => '月度副本';

  @override
  String get questsTabYearly => '年度副本';

  @override
  String get questsEmptyDaily => '还没有添加任务。\n从今天要做的小事开始吧。';

  @override
  String get questsEmptyWeekly => '还没有每周常规目标。\n添加想要持续坚持的目标吧。';

  @override
  String get questsEmptyMonthly => '本月还没有副本。\n将长期目标添加为月度副本吧。';

  @override
  String get questsEmptyYearly => '今年还没有大型副本。\n将人生目标级的挑战添加为年度副本吧。';

  @override
  String get questsCategoryStrength => '力量';

  @override
  String get questsCategoryWisdom => '智慧';

  @override
  String get questsCategoryHealth => '健康';

  @override
  String get questsCategoryCharm => '魅力';

  @override
  String get questsDifficultyEasy => '简单';

  @override
  String get questsDifficultyNormal => '普通';

  @override
  String get questsDifficultyHard => '困难';

  @override
  String get questsDifficultyVeryHard => '非常困难';

  @override
  String get questsTypeDaily => '每日';

  @override
  String get questsTypeWeekly => '每周';

  @override
  String get questsTypeMonthly => '月度副本';

  @override
  String get questsTypeYearly => '年度副本';

  @override
  String get questsCompleteTitle => '完成任务';

  @override
  String questsCompleteConfirm(String questName) {
    return '确认完成任务「$questName」？';
  }

  @override
  String get questsBaseRewardLabel => '基础奖励';

  @override
  String questsDoubleAdButton(int remaining) {
    return '看广告获得2倍奖励 (剩余$remaining次)';
  }

  @override
  String get questsAdUnavailable => '广告加载失败，已发放基础奖励。';

  @override
  String get questsEditTitle => '编辑任务';

  @override
  String get questsAddTitle => '添加新任务';

  @override
  String get questsNameLabel => '任务名称';

  @override
  String get questsTypeLabel => '类型';

  @override
  String get questsCategoryLabel => '分类';

  @override
  String get questsDifficultyLabel => '难度';

  @override
  String questsRewardPreview(String type, int xp, int gold) {
    return '$type奖励: $xp XP · $gold 金币';
  }

  @override
  String get questsNameRequired => '请输入任务名称。';

  @override
  String get questsDeleteTitle => '删除任务';

  @override
  String questsDeleteBody(String questName) {
    return '确认删除任务「$questName」？\n\n删除后无法恢复。';
  }

  @override
  String questsRaidClear(int count) {
    return '副本通关 $count 次';
  }

  @override
  String get questsRaidBonusMonthly => '副本奖励\n额外XP·额外金币\nAP +2·SP +1\n解锁进度奖励';

  @override
  String get questsRaidBonusYearly => '副本奖励\n大量XP·大量金币\nAP +4·SP +2\n解锁稀有奖励';

  @override
  String get huntScreenTitle => '狩猎场';

  @override
  String get huntMyHpLabel => '我的HP';

  @override
  String huntComboBadge(int count) {
    return '💥 连击: $count';
  }

  @override
  String huntApBadge(int ap) {
    return '⚡ AP: $ap';
  }

  @override
  String get huntActionAttack => '攻击 (1 AP)';

  @override
  String get huntActionDefend => '防御 (1 AP)';

  @override
  String get huntActionSkill => '技能 (自由)';

  @override
  String get huntActionBag => '背包 (1 AP)';

  @override
  String get huntActionFlee => '逃跑 (1 AP)';

  @override
  String get huntBagTitle => '背包 (消耗品)';

  @override
  String get huntBagEmpty => '没有可用的道具。';

  @override
  String get huntBagUse => '使用 (1 AP)';

  @override
  String get huntSkillSelectTitle => '选择要使用的技能:';

  @override
  String get huntSkillEmpty => '还没有学习战斗技能。';

  @override
  String get huntApLowTitle => 'AP不足';

  @override
  String huntApLowBody(int remaining) {
    return 'AP不足。看广告回复2 AP吗？\n(今日剩余: $remaining次)';
  }

  @override
  String get huntApRecoverButton => '看广告回复';

  @override
  String get huntApExhausted => '⚡ AP不足！请完成任务。(今日广告回复已全部用完)';

  @override
  String huntDoubleRewardButton(int remaining) {
    return '看广告获得2倍战利品 (剩余$remaining次)';
  }

  @override
  String get huntDoubleRewardSuccess => '🎉 通过广告奖励获得了2倍战利品！';

  @override
  String get huntAdUnavailable => '广告加载失败，请重试。';

  @override
  String get huntResultButton => '查看结果并返回';

  @override
  String huntReviveButton(int remaining) {
    return '看广告复活 (今日剩余$remaining次)';
  }

  @override
  String get huntReviveSuccess => '❤️ 通过广告奖励立即复活！';

  @override
  String get huntReviveAdUnavailable => '广告加载失败，请稍后重试。';

  @override
  String get huntRetreatButton => '放弃并返回';

  @override
  String get inventoryScreenTitle => '背包';

  @override
  String get inventoryEquippedSection => '已装备';

  @override
  String get inventoryCombatStatSection => '战斗属性';

  @override
  String inventoryItemsSection(int count) {
    return '持有道具 ($count)';
  }

  @override
  String get inventorySlotWeapon => '⚔️ 武器';

  @override
  String get inventorySlotArmor => '🛡️ 防具';

  @override
  String get inventorySlotAccessory => '💍 饰品';

  @override
  String get inventorySlotEmpty => '空';

  @override
  String get inventoryUnequip => '卸下';

  @override
  String get inventoryUseEquip => '使用 / 装备';

  @override
  String get inventoryEmptyMessage => '没有道具\n猎杀怪物来获取装备吧！';

  @override
  String get inventoryAttackLabel => '攻击力';

  @override
  String get inventoryDefenseLabel => '防御力';

  @override
  String get inventoryHpLabel => '体力';

  @override
  String get inventoryStatStrength => '力量';

  @override
  String get inventoryStatWisdom => '智慧';

  @override
  String get inventoryStatHealth => '健康';

  @override
  String get inventoryStatCharm => '魅力';

  @override
  String get inventoryStatAttack => '攻击力';

  @override
  String get inventoryStatDefense => '防御力';

  @override
  String inventoryUsedHp(String itemName) {
    return '使用了$itemName。(HP回复)';
  }

  @override
  String inventoryUsedAp(String itemName) {
    return '使用了$itemName。(AP回复)';
  }

  @override
  String get inventoryRarityCommon => '普通';

  @override
  String get inventoryRarityUncommon => '优质';

  @override
  String get inventoryRarityRare => '稀有';

  @override
  String get inventoryRarityEpic => '史诗';

  @override
  String get inventoryRarityLegendary => '传说';

  @override
  String get shopScreenTitle => '商店';

  @override
  String get shopTabGameItems => '游戏道具';

  @override
  String get shopTabCustomRewards => '我的奖励';

  @override
  String get shopThemeBannerTitle => '主题展示';

  @override
  String get shopThemeBannerSubtitle => '预览即将推出的主题和特效。';

  @override
  String get shopConsumableSection => '消耗品';

  @override
  String get shopEquipBoxSection => '装备箱';

  @override
  String get shopPermanentSection => '永久强化';

  @override
  String get shopHpPotionName => 'HP回复药水';

  @override
  String get shopHpPotionDesc => '回复30 HP。';

  @override
  String get shopHpFullPotionName => 'HP完全回复药水';

  @override
  String get shopHpFullPotionDesc => '将HP恢复至最大值。';

  @override
  String get shopApPotionName => 'AP充能药水';

  @override
  String get shopApPotionDesc => '回复5 AP。';

  @override
  String get shopNormalBoxName => '普通装备箱';

  @override
  String get shopNormalBoxDesc => '随机获得普通~稀有装备。';

  @override
  String get shopNormalBoxSuccess => '获得装备！请查看背包！';

  @override
  String get shopPremiumBoxName => '高级装备箱';

  @override
  String get shopPremiumBoxDesc => '随机获得稀有~传说装备。';

  @override
  String get shopPremiumBoxSuccess => '获得高级装备！请查看背包！';

  @override
  String get shopMaxHpName => '最大HP +10';

  @override
  String get shopMaxHpDesc => '永久增加最大HP 10点。';

  @override
  String get shopMaxHpSuccess => '最大HP增加了10点！';

  @override
  String get shopMaxApName => '最大AP +2';

  @override
  String get shopMaxApDesc => '永久增加最大AP 2点。';

  @override
  String get shopMaxApSuccess => '最大AP增加了2点！';

  @override
  String get shopCustomRewardAddTitle => '添加自定义奖励';

  @override
  String get shopCustomRewardNameLabel => '奖励名称 (例: 1小时Netflix)';

  @override
  String get shopCustomRewardDescLabel => '说明';

  @override
  String get shopCustomRewardDescHint => '享受这个奖励吧！';

  @override
  String get shopCustomRewardCostLabel => '所需金币';

  @override
  String get shopCustomRewardIconLabel => '图标 (表情符号)';

  @override
  String get shopCustomRewardAddButton => '添加奖励';

  @override
  String shopCustomRewardDeleted(String name) {
    return '$name已删除';
  }

  @override
  String get shopAdSupportTitle => '选择型广告运营';

  @override
  String get shopAdSupportDesc => '广告仅在需要额外奖励时显示，如任务奖励2倍、AP回复、战斗复活等。';

  @override
  String get shopAdModelTitle => '广告支持型运营';

  @override
  String get shopAdModelDesc => '当前版本以广告收益为主，优先于应用内购买。付费商品将在日后考虑。';

  @override
  String get achievementScreenTitle => '成就';

  @override
  String get achievementTabInProgress => '进行中';

  @override
  String get achievementTabCompleted => '已完成';

  @override
  String get achievementEmptyInProgress => '所有成就已达成，或等待新挑战！';

  @override
  String get achievementEmptyCompleted => '还没有完成的成就。';

  @override
  String achievementRewardXp(int xp) {
    return '奖励: $xp XP';
  }

  @override
  String achievementRewardSp(int sp) {
    return '奖励: $sp SP';
  }

  @override
  String get skillScreenTitle => '技能';

  @override
  String skillRequiredLevel(int level) {
    return '需求条件: Lv.$level';
  }

  @override
  String get settingsScreenTitle => '设置';

  @override
  String get settingsAccountSection => '账户';

  @override
  String get settingsNicknameLabel => '昵称';

  @override
  String get settingsNicknameChangeTitle => '修改昵称';

  @override
  String get settingsNicknameNewLabel => '新昵称';

  @override
  String get settingsAppSection => '应用设置';

  @override
  String get settingsDarkMode => '深色模式';

  @override
  String get settingsDarkModeSubtitle => '切换应用主题。';

  @override
  String get settingsSfx => '音效 (SFX)';

  @override
  String get settingsSfxSubtitle => '开关游戏音效。';

  @override
  String get settingsNotification => '通知设置';

  @override
  String get settingsNotificationSubtitle => '每天早上9点接收任务提醒。';

  @override
  String get settingsNotificationEnabled => '已为每天早上9点和晚上8点设置通知。';

  @override
  String get settingsNotificationDisabled => '所有通知已取消。';

  @override
  String get settingsAdSupportSection => '广告支持说明';

  @override
  String get settingsAdSupportTitle => '选择型广告运营';

  @override
  String get settingsAdSupportDesc => '广告仅在需要额外奖励时显示，如任务奖励2倍、AP回复、战斗复活等。';

  @override
  String get settingsAdModelTitle => '广告支持型运营';

  @override
  String get settingsAdModelDesc => '当前版本以广告收益为主，优先于应用内购买。';

  @override
  String get settingsLogout => '退出登录';

  @override
  String get settingsWithdraw => '注销账户';

  @override
  String get settingsWithdrawTitle => '注销账户';

  @override
  String get settingsWithdrawBody => '确定要注销账户吗？\n所有数据将被永久删除，此操作无法撤销。';

  @override
  String get settingsWithdrawConfirm => '确认注销';

  @override
  String get loadingSync => '正在同步猎人信息';

  @override
  String get loadingSyncDesc => '正在加载今日任务和成长记录';

  @override
  String get loadingGate => '正在打开传送门';

  @override
  String get loadingGateDesc => '正在初始化系统';

  @override
  String get loadingTagline => 'ARISE YOUR QUEST';

  @override
  String get timerScreenFocus => '🍅 专注计时器';

  @override
  String get timerScreenBreak => '☕ 休息计时器';

  @override
  String get timerFocusMode => '专注模式';

  @override
  String get timerBreakMode => '休息模式';

  @override
  String timerSessionCount(int count) {
    return '第$count次专注完成';
  }

  @override
  String get timerFocusCompleteTitle => '🎉 专注完成！';

  @override
  String timerFocusCompleteBody(int minutes) {
    return '$minutes分钟专注会话完成！';
  }

  @override
  String get timerGoldRewardLabel => '金币 +';

  @override
  String timerTodaySessions(int count) {
    return '今日完成: $count 次';
  }

  @override
  String get timerStartBreak => '开始休息';

  @override
  String get timerFocusRewardLabel => '专注完成奖励:';

  @override
  String get cosmeticShopTitle => '主题展示';

  @override
  String get cosmeticCategoryTheme => '应用主题';

  @override
  String get cosmeticCategoryTitleEffect => '称号特效';

  @override
  String get cosmeticCategoryCombatEffect => '战斗特效';

  @override
  String get cosmeticComingSoonTitle => '高级自定义功能即将推出';

  @override
  String get cosmeticComingSoonDesc => '目前专注于广告支持型运营。主题和特效商品将在日后正式开放。';

  @override
  String get cosmeticUnequip => '卸下';

  @override
  String get cosmeticEquip => '装备';

  @override
  String get cosmeticComingSoon => '即将推出';

  @override
  String get cosmeticComingSoonSnackbar => '装饰商品即将推出。目前专注于广告支持型运营。';

  @override
  String get questTileEditTooltip => '编辑任务';

  @override
  String get questTileDeleteTooltip => '删除任务';

  @override
  String get notificationMorningTitle => '开始今日任务！';

  @override
  String get notificationMorningBody => '新的一天开始了。记录你的成长吧。';

  @override
  String get notificationEveningTitle => '今天的任务都完成了吗？';

  @override
  String get notificationEveningBody => '还有未完成的任务，可能会减少HP！';

  @override
  String get initialTitleRookie => '新手冒险者';

  @override
  String get initialQuestMorning => '早上7点起床';

  @override
  String get initialQuestExercise => '运动30分钟';

  @override
  String get initialQuestRead => '阅读10页书';

  @override
  String get initialQuestWeeklyExercise => '每周运动3次以上';

  @override
  String get initialQuestWeeklyLearn => '学习新技能/知识';

  @override
  String get initialQuestMonthlyExercise => '本月达成12次运动';

  @override
  String get initialQuestMonthlyProject => '完成副业项目核心功能';

  @override
  String get initialQuestYearly => '完成今年最重要的目标';

  @override
  String get reportScreenTitle => '详细报告';

  @override
  String get reportExpandedUnlocked => '今日扩展报告已解锁。';

  @override
  String get reportAdFailed => '广告加载失败，请稍后再试。';

  @override
  String get reportSummaryStreak => '当前连续记录';

  @override
  String reportSummaryStreakValue(int days) {
    return '$days天';
  }

  @override
  String get reportSummaryXp => '当前XP';

  @override
  String get reportSummaryQuestCount => '完成的任务';

  @override
  String reportSummaryQuestCountValue(int count) {
    return '$count个';
  }

  @override
  String get reportSummaryTitle => '当前称号';

  @override
  String get reportWeeklyActivityTitle => '本周活动记录';

  @override
  String get reportWeeklyActivitySubtitle => '查看本周的日常维持情况。';

  @override
  String get reportWeekDayMon => '一';

  @override
  String get reportWeekDayTue => '二';

  @override
  String get reportWeekDayWed => '三';

  @override
  String get reportWeekDayThu => '四';

  @override
  String get reportWeekDayFri => '五';

  @override
  String get reportWeekDaySat => '六';

  @override
  String get reportWeekDaySun => '日';

  @override
  String get reportExpandedEntryTitle => '广告解锁扩展报告';

  @override
  String get reportExpandedAlreadyUnlocked => '今日扩展报告已解锁，可在下方查看深度分析。';

  @override
  String get reportExpandedDescription => '解锁后可查看类别比例、成长倾向和自动成长记录。';

  @override
  String get reportFeatureCategoryRatio => '任务类别比例';

  @override
  String get reportFeatureGrowthTrend => '下一等级成长倾向分析';

  @override
  String get reportFeatureAutoGrowth => '上一等级自动成长记录';

  @override
  String get reportUnlockedToday => '今日扩展报告已解锁';

  @override
  String reportWatchAdButton(int count) {
    return '观看广告解锁扩展报告（今日剩余$count次）';
  }

  @override
  String get reportNoMoreViews => '今日已无法再次解锁';

  @override
  String get reportCategoryRatioTitle => '任务类别比例';

  @override
  String get reportInsightGrowthTrendTitle => '本等级成长倾向';

  @override
  String get reportInsightGrowthTrendCaption => '这是完成任务最多反映的方向。';

  @override
  String get reportInsightGrowthTrendCaptionEmpty => '完成任务后，自动成长倾向将逐渐积累。';

  @override
  String get reportInsightDataInsufficient => '数据不足';

  @override
  String get reportInsightAutoGrowthTitle => '上一等级自动成长';

  @override
  String get reportInsightAutoGrowthCaption => '升级时3点将根据行动统计自动分配。';

  @override
  String get reportInsightBestDayTitle => '本周最佳专注日';

  @override
  String reportInsightBestDayCaption(int count) {
    return '本周共完成了$count个任务。';
  }

  @override
  String get reportInsightRecommendedStatTitle => '推荐专注属性';

  @override
  String get reportInsightBalanced => '均衡';

  @override
  String get reportNextLevelPredictionTitle => '下一等级自动成长预测';

  @override
  String get reportLongTermTitle => '长期目标进度';

  @override
  String get reportLongTermSubtitle => '一次查看月间和年间副本进度。';

  @override
  String get reportProgressMonthlyRaid => '月间副本';

  @override
  String get reportProgressYearlyRaid => '年间副本';

  @override
  String get reportLowestStat => '当前最低属性';

  @override
  String get reportHighestStat => '最高属性';

  @override
  String get reportCalendarTitle => '任务日历';

  @override
  String get reportCalendarWeekdaySun => '日';

  @override
  String get reportCalendarWeekdayMon => '一';

  @override
  String get reportCalendarWeekdayTue => '二';

  @override
  String get reportCalendarWeekdayWed => '三';

  @override
  String get reportCalendarWeekdayThu => '四';

  @override
  String get reportCalendarWeekdayFri => '五';

  @override
  String get reportCalendarWeekdaySat => '六';

  @override
  String reportCalendarSelectedTitle(int month, int day) {
    return '$month月$day日 已完成任务';
  }

  @override
  String get reportCalendarSelectPrompt => '请选择日期';

  @override
  String get reportCalendarNoQuests => '该日期没有已完成的任务。';

  @override
  String get reportNoRecord => '无记录';

  @override
  String get reportStatBalanced => '目前属性均衡，状态稳定。';

  @override
  String reportAddQuestSuggestion(String category) {
    return '尝试添加$category系任务';
  }

  @override
  String reportRecommendedAction(String action) {
    return '推荐行动: $action';
  }

  @override
  String reportBestWeekday(String weekday, int count) {
    return '$weekday ($count个)';
  }

  @override
  String get reportWeekdayMonday => '周一';

  @override
  String get reportWeekdayTuesday => '周二';

  @override
  String get reportWeekdayWednesday => '周三';

  @override
  String get reportWeekdayThursday => '周四';

  @override
  String get reportWeekdayFriday => '周五';

  @override
  String get reportWeekdaySaturday => '周六';

  @override
  String get reportWeekdaySunday => '周日';

  @override
  String reportStatValue(String stat, int value) {
    return '$stat $value';
  }

  @override
  String shopItemAcquired(String name) {
    return '获得了$name！';
  }

  @override
  String get shopCustomRewardFabLabel => '添加奖励';

  @override
  String get statusReportTooltip => '查看详细报告';
}
