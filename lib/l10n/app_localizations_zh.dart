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

  @override
  String get dungeonHomeTitle => '灵魂牌组';

  @override
  String get dungeonHomeCardCollectionTooltip => '卡牌收藏';

  @override
  String get dungeonHomeDungeonSelection => '选择地下城';

  @override
  String dungeonHomeRequiredLevel(int requiredLevel) {
    return '需要$requiredLevel级或以上';
  }

  @override
  String get zone1Name => '青色草原';

  @override
  String get zone1Description => '适合新手冒险者的第一个地下城';

  @override
  String get zone2Name => '黑暗森林';

  @override
  String get zone2Description => '潜伏着使用毒素和减益效果的敌人';

  @override
  String get zone3Name => '废墟城堡';

  @override
  String get zone3Description => '等待着防御专精的敌人和多重战斗';

  @override
  String get zone4Name => '熔岩洞穴';

  @override
  String get zone4Description => '灼伤和高伤害的地狱';

  @override
  String get zone5Name => '深渊次元';

  @override
  String get zone5Description => '隐藏意图的敌人，降下诅咒的最终地下城';

  @override
  String get seasonName => '赛季1：灵魂觉醒';

  @override
  String get seasonEnded => '已结束';

  @override
  String seasonCountdown(int days) {
    return 'D-$days';
  }

  @override
  String get ascensionModeTitle => '飞升模式';

  @override
  String get ascensionInactive => '未激活';

  @override
  String get ascensionActiveModifiers => '当前惩罚：';

  @override
  String get ascensionSliderHint => '上滑以增加难度';

  @override
  String get ascensionLevel1Modifier => 'Lv 1: 敌人HP +10%';

  @override
  String get ascensionLevel2Modifier => 'Lv 2: 敌人攻击 +10%';

  @override
  String get ascensionLevel3Modifier => 'Lv 3: 起始金币 -30';

  @override
  String get ascensionLevel4Modifier => 'Lv 4: 增加1张诅咒卡';

  @override
  String get ascensionLevel5Modifier => 'Lv 5: 消灭精英后无卡牌选择';

  @override
  String get ascensionLevel6Modifier => 'Lv 6: 商店价格 +25%';

  @override
  String get ascensionLevel7Modifier => 'Lv 7: 起始HP -10%';

  @override
  String get ascensionLevel8Modifier => 'Lv 8: Boss HP +25%';

  @override
  String get ascensionLevel9Modifier => 'Lv 9: 强化事件不利选项';

  @override
  String get ascensionLevel10Modifier => 'Lv 10: 所有敌人HP +20%';

  @override
  String get infiniteTowerTitle => '无限之塔';

  @override
  String infiniteTowerBestFloorDesc(int bestFloor) {
    return '无尽挑战 · 最高记录: $bestFloor层';
  }

  @override
  String get infiniteTowerSelectFloor => '选择挑战楼层';

  @override
  String get infiniteTowerFloorInfo => '楼层信息';

  @override
  String infiniteTowerChallengeFloor(int targetFloor) {
    return '挑战$targetFloor层';
  }

  @override
  String get infiniteTowerFloorComposition => '楼层构成';

  @override
  String get infiniteTowerBestFloorLabel => '最高记录';

  @override
  String infiniteTowerFloorDisplay(int floor) {
    return '$floor层';
  }

  @override
  String get infiniteTowerEnemyHp => '敌人HP';

  @override
  String get infiniteTowerEnemyAttack => '敌人攻击';

  @override
  String get infiniteTowerDefault => '基础';

  @override
  String get infiniteTowerFloor1To5 => '1-5层';

  @override
  String get infiniteTowerFloor6To10 => '6-10层';

  @override
  String get infiniteTowerFloor11To15 => '11-15层';

  @override
  String get infiniteTowerFloor16To20 => '16-20层';

  @override
  String get infiniteTowerFloor21To25 => '21-25层';

  @override
  String get infiniteTowerFloor26Plus => '26层以上';

  @override
  String get infiniteTowerRepeatZones => '从区域1重复（难度持续上升）';

  @override
  String get dungeonMapTitle => '地下城地图';

  @override
  String get dungeonMapNoData => '没有地下城数据';

  @override
  String get dungeonRestTitle => '休息点';

  @override
  String get dungeonRestDescription => '发现了一个安静的休息点。温暖的篝火在燃烧。\n你要做什么？';

  @override
  String get dungeonRestRestTitle => '休息';

  @override
  String get dungeonRestRestDescription => '回复30%的HP';

  @override
  String dungeonRestHealResult(int healAmount) {
    return 'HP回复了$healAmount！';
  }

  @override
  String get dungeonRestTrainTitle => '修炼';

  @override
  String get dungeonRestTrainDescription => '强化1张卡牌';

  @override
  String get dungeonRestNoCardsToUpgrade => '没有可强化的卡牌';

  @override
  String get dungeonRestContinueButton => '继续';

  @override
  String get dungeonRestSelectCardToUpgrade => '选择要强化的卡牌';

  @override
  String get dungeonRestCardUpgraded => '已强化';

  @override
  String get dungeonShopTitle => '地下城商店';

  @override
  String get dungeonShopCardsSection => '卡牌';

  @override
  String get dungeonShopNoCards => '没有在售的卡牌';

  @override
  String get dungeonShopRelicsSection => '遗物';

  @override
  String get dungeonShopNoRelics => '没有在售的遗物';

  @override
  String get dungeonShopCardRemovalSection => '移除卡牌';

  @override
  String get dungeonShopLeaveButton => '离开商店';

  @override
  String get dungeonShopSelectCardToRemove => '选择要移除的卡牌';

  @override
  String dungeonShopRemovalCost(int cost) {
    return '费用: $cost金币';
  }

  @override
  String get dungeonShopPurchaseComplete => '购买完成';

  @override
  String get dungeonShopRemoveOneCard => '移除1张卡牌';

  @override
  String dungeonShopRemovalDescription(int deckSize) {
    return '从牌组中移除不需要的卡牌（当前牌组: $deckSize张）';
  }

  @override
  String get dungeonEventTitle => '事件';

  @override
  String get dungeonEventNoData => '没有事件数据';

  @override
  String get dungeonEventChooseAction => '请选择';

  @override
  String get dungeonEventContinueButton => '继续';

  @override
  String get dungeonEventOutcomeTitle => '结果';

  @override
  String get dungeonEventEffectCardReward => '获得卡牌';

  @override
  String get dungeonEventEffectRelicReward => '获得遗物';

  @override
  String get dungeonEventEffectCardRemove => '移除卡牌';

  @override
  String get dungeonEventEffectCardUpgrade => '强化卡牌';

  @override
  String get dungeonEventEffectCurseAdded => '添加诅咒';

  @override
  String get dungeonResultVictoryTitle => '地下城通关！';

  @override
  String get dungeonResultDefeatTitle => '冒险失败...';

  @override
  String get dungeonResultVictoryMessage => '恭喜！你击败了所有敌人，征服了地下城。';

  @override
  String get dungeonResultDefeatMessage => '很遗憾，本次冒险失败了。再次挑战吧！';

  @override
  String get dungeonResultStatsTitle => '冒险记录';

  @override
  String get dungeonResultStatsZone => '区域';

  @override
  String get dungeonResultStatsNodesCompleted => '完成节点';

  @override
  String get dungeonResultStatsMonsterKilled => '击杀怪物';

  @override
  String get dungeonResultRewardsTitle => '奖励';

  @override
  String dungeonResultXpReward(int xpGained) {
    return '+$xpGained XP';
  }

  @override
  String dungeonResultGoldReward(int goldGained) {
    return '+$goldGained金币';
  }

  @override
  String get dungeonResultVictoryBonus => '通关奖励 x1.5 + Boss击杀奖励';

  @override
  String get dungeonResultDefeatPenalty => '失败惩罚: 奖励 x0.5';

  @override
  String get dungeonResultReturnHomeButton => '返回主页';

  @override
  String get cardBattleYourTurn => '你的回合';

  @override
  String get cardBattleEnemyTurn => '敌人回合';

  @override
  String cardBattleTurnCount(int turnCount) {
    return '第$turnCount回合';
  }

  @override
  String get cardBattleAbandonDialog => '放弃战斗';

  @override
  String get cardBattleAbandonConfirmation => '要放弃本次战斗吗？进度将会丢失。';

  @override
  String get cardBattleAbandonButton => '放弃';

  @override
  String get cardBattleNoEnemies => '没有敌人';

  @override
  String get cardBattleEndTurnButton => '结束回合';

  @override
  String get cardBattleNoCardsInHand => '手牌中没有卡牌';

  @override
  String get cardBattleVictory => '胜利！';

  @override
  String cardBattleGoldReward(int gold) {
    return '+$gold金币';
  }

  @override
  String get cardBattleSelectCard => '请选择一张卡牌';

  @override
  String get cardBattleSkipButton => '跳过';

  @override
  String get cardRarityCommon => '普通';

  @override
  String get cardRarityUncommon => '罕见';

  @override
  String get cardRarityRare => '稀有';

  @override
  String get cardRarityLegendary => '传说';

  @override
  String get cardCategoryAttack => '攻击';

  @override
  String get cardCategoryMagic => '魔法';

  @override
  String get cardCategoryDefense => '防御';

  @override
  String get cardCategoryTactical => '战术';

  @override
  String get cardCollectionTitle => '卡牌收藏';

  @override
  String get cardCollectionFilterAll => '全部';

  @override
  String get cardCollectionMyCollection => '我的收藏';

  @override
  String cardCollectionCardCount(int count) {
    return '($count张)';
  }

  @override
  String get cardCollectionNoCards => '你没有卡牌。\n完成任务可以获得卡牌！';

  @override
  String cardCollectionDeckInclusion(int copyCount) {
    return '牌组中有$copyCount张';
  }

  @override
  String get cardCollectionAddToDeck => '添加到牌组';

  @override
  String get cardCollectionDeckFull => '牌组已满 (20张)';

  @override
  String get cardCollectionMaxCopies => '最多可添加3张';

  @override
  String cardCollectionAddedToDeck(String cardName) {
    return '$cardName已添加到牌组';
  }

  @override
  String get cardCollectionMyDeck => '我的牌组';

  @override
  String cardCollectionDeckSize(int deckSize) {
    return '($deckSize/20张)';
  }

  @override
  String get cardCollectionResetDeckDialog => '重置牌组';

  @override
  String get cardCollectionResetDeckConfirmation => '删除自定义牌组并恢复为默认初始牌组？';

  @override
  String get cardCollectionResetButton => '重置';

  @override
  String get cardCollectionDefaultDeckMessage => '当前使用默认初始牌组\n从收藏中添加卡牌';

  @override
  String get cardNameBaseStrike => '基础攻击';

  @override
  String get cardDescBaseStrike => '造成6点伤害。';

  @override
  String get cardNameBaseDefend => '基础格挡';

  @override
  String get cardDescBaseDefend => '获得5点格挡。';

  @override
  String get cardNameBaseFocus => '集中';

  @override
  String get cardDescBaseFocus => '抽1张牌。';

  @override
  String get cardNameCursePain => '痛苦';

  @override
  String get cardDescCursePain => '无法使用。每次抽到时失去1HP。';

  @override
  String get cardNameCurseDoubt => '疑虑';

  @override
  String get cardDescCurseDoubt => '无法使用。每回合少抽1张牌。';

  @override
  String get cardNameCurseBurden => '负担';

  @override
  String get cardDescCurseBurden => '无法使用。每回合开始时失去1能量。';

  @override
  String get cardNameCurseDecay => '腐蚀';

  @override
  String get cardDescCurseDecay => '无法使用。每回合失去3点格挡。';

  @override
  String get cardNameAtkC01 => '重击';

  @override
  String get cardDescAtkC01 => '造成6点伤害。';

  @override
  String get cardNameAtkC01Up => '重击+';

  @override
  String get cardDescAtkC01Up => '造成9点伤害。';

  @override
  String get cardNameAtkC02 => '斩击';

  @override
  String get cardDescAtkC02 => '造成4点伤害，抽1张牌。';

  @override
  String get cardNameAtkC02Up => '斩击+';

  @override
  String get cardDescAtkC02Up => '造成6点伤害，抽1张牌。';

  @override
  String get cardNameAtkC03 => '连击';

  @override
  String get cardDescAtkC03 => '造成3点伤害，共2次。';

  @override
  String get cardNameAtkC03Up => '连击+';

  @override
  String get cardDescAtkC03Up => '造成3点伤害，共3次。';

  @override
  String get cardNameAtkC04 => '怒击';

  @override
  String get cardDescAtkC04 => '造成3点伤害，将1张愤怒牌加入弃牌堆。';

  @override
  String get cardNameAtkC04Up => '怒击+';

  @override
  String get cardDescAtkC04Up => '造成5点伤害。';

  @override
  String get cardNameAtkC05 => '冲锋';

  @override
  String get cardDescAtkC05 => '造成12点伤害。';

  @override
  String get cardNameAtkC05Up => '冲锋+';

  @override
  String get cardDescAtkC05Up => '造成16点伤害。';

  @override
  String get cardNameAtkC06 => '流血攻击';

  @override
  String get cardDescAtkC06 => '造成4点伤害，施加2层中毒。';

  @override
  String get cardNameAtkC06Up => '流血攻击+';

  @override
  String get cardDescAtkC06Up => '造成4点伤害，施加4层中毒。';

  @override
  String get cardNameAtkC07 => '快刺';

  @override
  String get cardDescAtkC07 => '造成3点伤害。';

  @override
  String get cardNameAtkC07Up => '快刺+';

  @override
  String get cardDescAtkC07Up => '造成5点伤害。';

  @override
  String get cardNameAtkC08 => '挑衅';

  @override
  String get cardDescAtkC08 => '造成5点伤害，施加1回合易伤。';

  @override
  String get cardNameAtkC08Up => '挑衅+';

  @override
  String get cardDescAtkC08Up => '造成8点伤害，施加1回合易伤。';

  @override
  String get cardNameAtkC09 => '突袭';

  @override
  String get cardDescAtkC09 => '第1回合造成12点伤害，否则造成6点伤害。';

  @override
  String get cardNameAtkC09Up => '突袭+';

  @override
  String get cardDescAtkC09Up => '第1回合造成18点伤害，否则造成9点伤害。';

  @override
  String get cardNameAtkC10 => '刀刃风暴';

  @override
  String get cardDescAtkC10 => '对所有敌人造成3点伤害。';

  @override
  String get cardNameAtkC10Up => '刀刃风暴+';

  @override
  String get cardDescAtkC10Up => '对所有敌人造成5点伤害。';

  @override
  String get cardNameAtkU01 => '强力斩击';

  @override
  String get cardDescAtkU01 => '造成14点伤害，施加脆弱2回合。';

  @override
  String get cardNameAtkU01Up => '强力斩击+';

  @override
  String get cardDescAtkU01Up => '造成18点伤害，施加脆弱2回合。';

  @override
  String get cardNameAtkU02 => '刀刃之舞';

  @override
  String get cardDescAtkU02 => '造成3次3点伤害，获得3格挡。';

  @override
  String get cardNameAtkU02Up => '刀刃之舞+';

  @override
  String get cardDescAtkU02Up => '造成3次4点伤害，获得5格挡。';

  @override
  String get cardNameAtkU03 => '处决';

  @override
  String get cardDescAtkU03 => '敌人HP低于50%时造成30点伤害，否则10点伤害。';

  @override
  String get cardNameAtkU03Up => '处决+';

  @override
  String get cardDescAtkU03Up => '敌人HP低于50%时造成40点伤害，否则14点伤害。';

  @override
  String get cardNameAtkU04 => '狂暴';

  @override
  String get cardDescAtkU04 => '获得力量+2（永久）。';

  @override
  String get cardNameAtkU04Up => '狂暴+';

  @override
  String get cardDescAtkU04Up => '获得力量+3（永久）。';

  @override
  String get cardNameAtkU05 => '血誓';

  @override
  String get cardDescAtkU05 => '失去3HP，造成8点伤害，获得力量+1。';

  @override
  String get cardNameAtkU05Up => '血誓+';

  @override
  String get cardDescAtkU05Up => '失去3HP，造成12点伤害，获得力量+1。';

  @override
  String get cardNameAtkU06 => '旋风斩';

  @override
  String get cardDescAtkU06 => '对所有敌人造成8点伤害。';

  @override
  String get cardNameAtkU06Up => '旋风斩+';

  @override
  String get cardDescAtkU06Up => '对所有敌人造成12点伤害。';

  @override
  String get cardNameAtkU07 => '粉碎';

  @override
  String get cardDescAtkU07 => '造成10点伤害，施加虚弱2回合。';

  @override
  String get cardNameAtkU07Up => '粉碎+';

  @override
  String get cardDescAtkU07Up => '造成14点伤害，施加虚弱2回合。';

  @override
  String get cardNameAtkU08 => '无情';

  @override
  String get cardDescAtkU08 => '对脆弱状态敌人造成双倍伤害（基础6点伤害）。';

  @override
  String get cardNameAtkU08Up => '无情+';

  @override
  String get cardDescAtkU08Up => '对脆弱状态敌人造成双倍伤害（基础9点伤害）。';

  @override
  String get cardNameAtkR01 => '龙之一击';

  @override
  String get cardDescAtkR01 => '造成30点伤害，施加燃烧3回合。';

  @override
  String get cardNameAtkR01Up => '龙之一击+';

  @override
  String get cardDescAtkR01Up => '造成40点伤害，施加燃烧4回合。';

  @override
  String get cardNameAtkR02 => '千刀万剐';

  @override
  String get cardDescAtkR02 => '对手牌中每张牌造成1点伤害。';

  @override
  String get cardNameAtkR02Up => '千刀万剐+';

  @override
  String get cardDescAtkR02Up => '对手牌中每张牌造成2点伤害。';

  @override
  String get cardNameAtkR03 => '风暴之剑';

  @override
  String get cardDescAtkR03 => '对本回合已使用的每张牌造成5点伤害。';

  @override
  String get cardNameAtkR03Up => '风暴之剑+';

  @override
  String get cardDescAtkR03Up => '对本回合已使用的每张牌造成7点伤害。';

  @override
  String get cardNameAtkR04 => '死神镰刀';

  @override
  String get cardDescAtkR04 => '造成15点伤害。击杀时回复10HP。';

  @override
  String get cardNameAtkR04Up => '死神镰刀+';

  @override
  String get cardDescAtkR04Up => '造成20点伤害。击杀时回复15HP。';

  @override
  String get cardNameAtkR05 => '狂战士';

  @override
  String get cardDescAtkR05 => '获得力量+5，3回合后力量-5。';

  @override
  String get cardNameAtkR05Up => '狂战士+';

  @override
  String get cardDescAtkR05Up => '获得力量+7，3回合后力量-5。';

  @override
  String get cardNameAtkL01 => '王者之剑';

  @override
  String get cardDescAtkL01 => '造成50点伤害，施加脆弱+虚弱3回合。使用后消耗。';

  @override
  String get cardNameAtkL01Up => '王者之剑+';

  @override
  String get cardDescAtkL01Up => '造成60点伤害，施加脆弱+虚弱3回合。使用后消耗。';

  @override
  String get cardNameAtkL02 => '无限之刃';

  @override
  String get cardDescAtkL02 => '造成8点伤害。每次使用永久+2伤害。';

  @override
  String get cardNameAtkL02Up => '无限之刃+';

  @override
  String get cardDescAtkL02Up => '造成12点伤害。每次使用永久+2伤害。';

  @override
  String get cardNameMagC01 => '火球';

  @override
  String get cardDescMagC01 => '造成4点伤害，施加燃烧2回合。';

  @override
  String get cardNameMagC01Up => '火球+';

  @override
  String get cardDescMagC01Up => '造成6点伤害，施加燃烧3回合。';

  @override
  String get cardNameMagC02 => '霜矢';

  @override
  String get cardDescMagC02 => '造成5点伤害，施加虚弱1回合。';

  @override
  String get cardNameMagC02Up => '霜矢+';

  @override
  String get cardDescMagC02Up => '造成8点伤害，施加虚弱1回合。';

  @override
  String get cardNameMagC03 => '法力集中';

  @override
  String get cardDescMagC03 => '获得能量+1，抽1张牌。';

  @override
  String get cardNameMagC03Up => '法力集中+';

  @override
  String get cardDescMagC03Up => '获得能量+1，抽2张牌。';

  @override
  String get cardNameMagC04 => '电击';

  @override
  String get cardDescMagC04 => '对随机敌人造成7点伤害。';

  @override
  String get cardNameMagC04Up => '电击+';

  @override
  String get cardDescMagC04Up => '对随机敌人造成10点伤害。';

  @override
  String get cardNameMagC05 => '魔法飞弹';

  @override
  String get cardDescMagC05 => '对随机目标造成2次4点伤害。';

  @override
  String get cardNameMagC05Up => '魔法飞弹+';

  @override
  String get cardDescMagC05Up => '对随机目标造成3次4点伤害。';

  @override
  String get cardNameMagC06 => '冥想';

  @override
  String get cardDescMagC06 => '抽2张牌。';

  @override
  String get cardNameMagC06Up => '冥想+';

  @override
  String get cardDescMagC06Up => '抽3张牌。';

  @override
  String get cardNameMagC07 => '知识之光';

  @override
  String get cardDescMagC07 => '查看牌库顶3张牌，将1张加入手牌。';

  @override
  String get cardNameMagC07Up => '知识之光+';

  @override
  String get cardDescMagC07Up => '查看牌库顶3张牌，将2张加入手牌。';

  @override
  String get cardNameMagC08 => '毒雾';

  @override
  String get cardDescMagC08 => '对所有敌人施加毒3。';

  @override
  String get cardNameMagC08Up => '毒雾+';

  @override
  String get cardDescMagC08Up => '对所有敌人施加毒5。';

  @override
  String get cardNameMagC09 => '魔力爆发';

  @override
  String get cardDescMagC09 => '造成10点伤害，获得专注+1。';

  @override
  String get cardNameMagC09Up => '魔力爆发+';

  @override
  String get cardDescMagC09Up => '造成14点伤害，获得专注+1。';

  @override
  String get cardNameMagC10 => '元素和谐';

  @override
  String get cardDescMagC10 => '使下一张牌的效果提高50%。';

  @override
  String get cardNameMagC10Up => '元素和谐+';

  @override
  String get cardDescMagC10Up => '使下一张牌的效果提高100%。';

  @override
  String get cardNameMagU01 => '连锁闪电';

  @override
  String get cardDescMagU01 => '造成8点伤害，对所有敌人造成4点伤害。';

  @override
  String get cardNameMagU01Up => '连锁闪电+';

  @override
  String get cardDescMagU01Up => '造成12点伤害，对所有敌人造成6点伤害。';

  @override
  String get cardNameMagU02 => '冰晶之眼';

  @override
  String get cardDescMagU02 => '造成12点伤害，施加冰结1次。';

  @override
  String get cardNameMagU02Up => '冰晶之眼+';

  @override
  String get cardDescMagU02Up => '造成16点伤害，施加冰结1次。';

  @override
  String get cardNameMagU03 => '智慧之书';

  @override
  String get cardDescMagU03 => '抽3张牌，消耗1张。';

  @override
  String get cardNameMagU03Up => '智慧之书+';

  @override
  String get cardDescMagU03Up => '抽4张牌。';

  @override
  String get cardNameMagU04 => '法力过载';

  @override
  String get cardDescMagU04 => '获得能量+2。下回合能量-1。';

  @override
  String get cardNameMagU04Up => '法力过载+';

  @override
  String get cardDescMagU04Up => '获得能量+3。';

  @override
  String get cardNameMagU05 => '元素风暴';

  @override
  String get cardDescMagU05 => '对所有敌人造成15点伤害。';

  @override
  String get cardNameMagU05Up => '元素风暴+';

  @override
  String get cardDescMagU05Up => '对所有敌人造成20点伤害。';

  @override
  String get cardNameMagU06 => '时间扭曲';

  @override
  String get cardDescMagU06 => '获得额外回合1次（能量0，保留手牌）。';

  @override
  String get cardNameMagU06Up => '时间扭曲+';

  @override
  String get cardDescMagU06Up => '获得额外回合1次（以1能量开始）。';

  @override
  String get cardNameMagU07 => '魔法增幅';

  @override
  String get cardDescMagU07 => '获得专注+2（永久）。';

  @override
  String get cardNameMagU07Up => '魔法增幅+';

  @override
  String get cardDescMagU07Up => '获得专注+3（永久）。';

  @override
  String get cardNameMagU08 => '复制术';

  @override
  String get cardDescMagU08 => '复制手牌中1张牌（仅本回合）。';

  @override
  String get cardNameMagU08Up => '复制术+';

  @override
  String get cardDescMagU08Up => '以费用0复制手牌中1张牌（仅本回合）。';

  @override
  String get cardNameMagR01 => '陨石';

  @override
  String get cardDescMagR01 => '对所有敌人造成25点伤害，施加燃烧3回合。';

  @override
  String get cardNameMagR01Up => '陨石+';

  @override
  String get cardDescMagR01Up => '对所有敌人造成35点伤害，施加燃烧3回合。';

  @override
  String get cardNameMagR02 => '法力暴走';

  @override
  String get cardDescMagR02 => '手牌中所有牌本回合费用变为0。';

  @override
  String get cardNameMagR02Up => '法力暴走+';

  @override
  String get cardDescMagR02Up => '手牌中所有牌的费用下回合前变为0。';

  @override
  String get cardNameMagR03 => '次元裂隙';

  @override
  String get cardDescMagR03 => '从弃牌堆取回3张牌。';

  @override
  String get cardNameMagR03Up => '次元裂隙+';

  @override
  String get cardDescMagR03Up => '从弃牌堆取回5张牌。';

  @override
  String get cardNameMagR04 => '灵魂吸收';

  @override
  String get cardDescMagR04 => '造成12点伤害，回复等量HP。';

  @override
  String get cardNameMagR04Up => '灵魂吸收+';

  @override
  String get cardDescMagR04Up => '造成18点伤害，回复等量HP。';

  @override
  String get cardNameMagR05 => '绝对零度';

  @override
  String get cardDescMagR05 => '使所有敌人冰结，造成10点伤害。';

  @override
  String get cardNameMagR05Up => '绝对零度+';

  @override
  String get cardDescMagR05Up => '使所有敌人冰结，造成15点伤害。';

  @override
  String get cardNameMagL01 => '末日审判';

  @override
  String get cardDescMagL01 => '对所有敌人造成99点伤害。自身受到30点伤害。使用后消耗。';

  @override
  String get cardNameMagL01Up => '末日审判+';

  @override
  String get cardDescMagL01Up => '对所有敌人造成99点伤害。自身受到15点伤害。使用后消耗。';

  @override
  String get cardNameMagL02 => '无限智慧';

  @override
  String get cardDescMagL02 => '抽5张牌，获得能量+2。使用后消耗。';

  @override
  String get cardNameMagL02Up => '无限智慧+';

  @override
  String get cardDescMagL02Up => '抽7张牌，获得能量+3。使用后消耗。';

  @override
  String get cardNameDefC01 => '防御';

  @override
  String get cardDescDefC01 => '获得5格挡。';

  @override
  String get cardNameDefC01Up => '防御+';

  @override
  String get cardDescDefC01Up => '获得8格挡。';

  @override
  String get cardNameDefC02 => '铁壁';

  @override
  String get cardDescDefC02 => '获得12格挡。';

  @override
  String get cardNameDefC02Up => '铁壁+';

  @override
  String get cardDescDefC02Up => '获得16格挡。';

  @override
  String get cardNameDefC03 => '反击';

  @override
  String get cardDescDefC03 => '获得4格挡和2荆棘。';

  @override
  String get cardNameDefC03Up => '反击+';

  @override
  String get cardDescDefC03Up => '获得6格挡和3荆棘。';

  @override
  String get cardNameDefC04 => '回复祈祷';

  @override
  String get cardDescDefC04 => '回复4HP。';

  @override
  String get cardNameDefC04Up => '回复祈祷+';

  @override
  String get cardDescDefC04Up => '回复7HP。';

  @override
  String get cardNameDefC05 => '战斗姿态';

  @override
  String get cardDescDefC05 => '获得6格挡并抽1张牌。';

  @override
  String get cardNameDefC05Up => '战斗姿态+';

  @override
  String get cardDescDefC05Up => '获得8格挡并抽1张牌。';

  @override
  String get cardNameDefC06 => '滚动';

  @override
  String get cardDescDefC06 => '获得3格挡。下回合获得6格挡。';

  @override
  String get cardNameDefC06Up => '滚动+';

  @override
  String get cardDescDefC06Up => '获得5格挡。下回合获得8格挡。';

  @override
  String get cardNameDefC07 => '急救';

  @override
  String get cardDescDefC07 => '回复3HP。';

  @override
  String get cardNameDefC07Up => '急救+';

  @override
  String get cardDescDefC07Up => '回复5HP。';

  @override
  String get cardNameDefC08 => '忍耐';

  @override
  String get cardDescDefC08 => '获得5格挡和1回合坚定。';

  @override
  String get cardNameDefC08Up => '忍耐+';

  @override
  String get cardDescDefC08Up => '获得7格挡和2回合坚定。';

  @override
  String get cardNameDefC09 => '生命力';

  @override
  String get cardDescDefC09 => '获得再生3（3回合）。';

  @override
  String get cardNameDefC09Up => '生命力+';

  @override
  String get cardDescDefC09Up => '获得再生4（4回合）。';

  @override
  String get cardNameDefC10 => '嘲讽盾';

  @override
  String get cardDescDefC10 => '获得6格挡并嘲讽1个敌人。';

  @override
  String get cardNameDefC10Up => '嘲讽盾+';

  @override
  String get cardDescDefC10Up => '获得9格挡并嘲讽1个敌人。';

  @override
  String get cardNameDefU01 => '路障';

  @override
  String get cardDescDefU01 => '获得12格挡和2回合坚定。';

  @override
  String get cardNameDefU01Up => '路障+';

  @override
  String get cardDescDefU01Up => '获得16格挡和3回合坚定。';

  @override
  String get cardNameDefU02 => '反射盾';

  @override
  String get cardDescDefU02 => '获得8格挡和本回合5荆棘。';

  @override
  String get cardNameDefU02Up => '反射盾+';

  @override
  String get cardDescDefU02Up => '获得12格挡和本回合7荆棘。';

  @override
  String get cardNameDefU03 => '治愈祈祷';

  @override
  String get cardDescDefU03 => '回复10HP并获得3回合再生2。';

  @override
  String get cardNameDefU03Up => '治愈祈祷+';

  @override
  String get cardDescDefU03Up => '回复15HP并获得3回合再生3。';

  @override
  String get cardNameDefU04 => '不屈意志';

  @override
  String get cardDescDefU04 => '获得敏捷性+2（永久）。';

  @override
  String get cardNameDefU04Up => '不屈意志+';

  @override
  String get cardDescDefU04Up => '获得敏捷性+3（永久）。';

  @override
  String get cardNameDefU05 => '守护屏障';

  @override
  String get cardDescDefU05 => '获得等于缺失HP25%的格挡。';

  @override
  String get cardNameDefU05Up => '守护屏障+';

  @override
  String get cardDescDefU05Up => '获得等于缺失HP30%的格挡。';

  @override
  String get cardNameDefU06 => '求生本能';

  @override
  String get cardDescDefU06 => 'HP≤50%时获得15格挡，否则获得5格挡。';

  @override
  String get cardNameDefU06Up => '求生本能+';

  @override
  String get cardDescDefU06Up => 'HP≤50%时获得20格挡，否则获得8格挡。';

  @override
  String get cardNameDefU07 => '吸血荆棘';

  @override
  String get cardDescDefU07 => '获得3荆棘（永久）。被击中时回复1HP。';

  @override
  String get cardNameDefU07Up => '吸血荆棘+';

  @override
  String get cardDescDefU07Up => '获得4荆棘（永久）。被击中时回复2HP。';

  @override
  String get cardNameDefU08 => '强化盔甲';

  @override
  String get cardDescDefU08 => '获得20格挡。下回合获得10格挡。';

  @override
  String get cardNameDefU08Up => '强化盔甲+';

  @override
  String get cardDescDefU08Up => '获得25格挡。下回合获得15格挡。';

  @override
  String get cardNameDefR01 => '无敌';

  @override
  String get cardDescDefR01 => '本回合所有伤害降为0。消耗。';

  @override
  String get cardNameDefR01Up => '无敌+';

  @override
  String get cardDescDefR01Up => '本回合和下回合所有伤害降为0。消耗。';

  @override
  String get cardNameDefR02 => '生命之树';

  @override
  String get cardDescDefR02 => '回复最大HP的30%。';

  @override
  String get cardNameDefR02Up => '生命之树+';

  @override
  String get cardDescDefR02Up => '回复最大HP的40%。';

  @override
  String get cardNameDefR03 => '神圣盾';

  @override
  String get cardDescDefR03 => '获得20格挡并移除所有减益。';

  @override
  String get cardNameDefR03Up => '神圣盾+';

  @override
  String get cardDescDefR03Up => '获得28格挡并移除所有减益。';

  @override
  String get cardNameDefR04 => '铁甲身';

  @override
  String get cardDescDefR04 => '每回合自动获得8格挡（战斗中）。';

  @override
  String get cardNameDefR04Up => '铁甲身+';

  @override
  String get cardDescDefR04Up => '每回合自动获得12格挡（战斗中）。';

  @override
  String get cardNameDefR05 => '重生药水';

  @override
  String get cardDescDefR05 => '本次战斗死亡时以30%HP复活。消耗。';

  @override
  String get cardNameDefR05Up => '重生药水+';

  @override
  String get cardDescDefR05Up => '本次战斗死亡时以50%HP复活。消耗。';

  @override
  String get cardNameDefL01 => '永恒盾';

  @override
  String get cardDescDefL01 => '获得30格挡并每回合自动获得5格挡（战斗中）。消耗。';

  @override
  String get cardNameDefL01Up => '永恒盾+';

  @override
  String get cardDescDefL01Up => '获得40格挡并每回合自动获得8格挡（战斗中）。消耗。';

  @override
  String get cardNameDefL02 => '生命之泉';

  @override
  String get cardDescDefL02 => '完全回复HP并获得最大HP+10（永久）。消耗。';

  @override
  String get cardNameDefL02Up => '生命之泉+';

  @override
  String get cardDescDefL02Up => '完全回复HP并获得最大HP+20（永久）。消耗。';

  @override
  String get cardNameTacC01 => '观察';

  @override
  String get cardDescTacC01 => '查看敌人意图并抽1张牌。';

  @override
  String get cardNameTacC01Up => '观察+';

  @override
  String get cardDescTacC01Up => '查看敌人意图并抽2张牌。';

  @override
  String get cardNameTacC02 => '寻宝';

  @override
  String get cardDescTacC02 => '战斗金币+15。';

  @override
  String get cardNameTacC02Up => '寻宝+';

  @override
  String get cardDescTacC02Up => '战斗金币+25。';

  @override
  String get cardNameTacC03 => '看破弱点';

  @override
  String get cardDescTacC03 => '施加易伤2回合和虚弱1回合。';

  @override
  String get cardNameTacC03Up => '看破弱点+';

  @override
  String get cardDescTacC03Up => '施加易伤2回合和虚弱2回合。';

  @override
  String get cardNameTacC04 => '灵巧之手';

  @override
  String get cardDescTacC04 => '抽2张牌。';

  @override
  String get cardNameTacC04Up => '灵巧之手+';

  @override
  String get cardDescTacC04Up => '抽3张牌。';

  @override
  String get cardNameTacC05 => '设陷阱';

  @override
  String get cardDescTacC05 => '下次敌人攻击时反射10点伤害。';

  @override
  String get cardNameTacC05Up => '设陷阱+';

  @override
  String get cardDescTacC05Up => '下次敌人攻击时反射15点伤害。';

  @override
  String get cardNameTacC06 => '扰乱';

  @override
  String get cardDescTacC06 => '随机改变敌人意图。';

  @override
  String get cardNameTacC06Up => '扰乱+';

  @override
  String get cardDescTacC06Up => '改变敌人意图并施加虚弱1回合。';

  @override
  String get cardNameTacC07 => '扒窃';

  @override
  String get cardDescTacC07 => '造成3点伤害，获得5~15金币。';

  @override
  String get cardNameTacC07Up => '扒窃+';

  @override
  String get cardDescTacC07Up => '造成6点伤害，获得10~25金币。';

  @override
  String get cardNameTacC08 => '烟雾弹';

  @override
  String get cardDescTacC08 => '获得4格挡，对所有敌人施加虚弱1回合。';

  @override
  String get cardNameTacC08Up => '烟雾弹+';

  @override
  String get cardDescTacC08Up => '获得6格挡，对所有敌人施加虚弱2回合。';

  @override
  String get cardNameTacC09 => '鼓励';

  @override
  String get cardDescTacC09 => '本次战斗随机升级1张牌。';

  @override
  String get cardNameTacC09Up => '鼓励+';

  @override
  String get cardDescTacC09Up => '本次战斗随机升级2张牌。';

  @override
  String get cardNameTacC10 => '幸运硬币';

  @override
  String get cardDescTacC10 => '50%概率抽2张牌。';

  @override
  String get cardNameTacC10Up => '幸运硬币+';

  @override
  String get cardDescTacC10Up => '70%概率抽2张牌。';

  @override
  String get cardNameTacU01 => '战场分析';

  @override
  String get cardDescTacU01 => '抽3张牌，将最高费用牌本回合费用降为0。';

  @override
  String get cardNameTacU01Up => '战场分析+';

  @override
  String get cardDescTacU01Up => '抽4张牌，将最高费用牌本回合费用降为0。';

  @override
  String get cardNameTacU02 => '影步';

  @override
  String get cardDescTacU02 => '下回合前受到的伤害减少50%。';

  @override
  String get cardNameTacU02Up => '影步+';

  @override
  String get cardDescTacU02Up => '下回合前受到的伤害减少50%并抽1张牌。';

  @override
  String get cardNameTacU03 => '宝箱';

  @override
  String get cardDescTacU03 => '激活一次随机圣物效果。消耗。';

  @override
  String get cardNameTacU03Up => '宝箱+';

  @override
  String get cardDescTacU03Up => '激活两次随机圣物效果。消耗。';

  @override
  String get cardNameTacU04 => '操纵牌库';

  @override
  String get cardDescTacU04 => '将牌库顶部3张牌按任意顺序排列。';

  @override
  String get cardNameTacU04Up => '操纵牌库+';

  @override
  String get cardDescTacU04Up => '将牌库顶部5张牌按任意顺序排列。';

  @override
  String get cardNameTacU05 => '双面间谍';

  @override
  String get cardDescTacU05 => '复制并移除敌人的增益。';

  @override
  String get cardNameTacU05Up => '双面间谍+';

  @override
  String get cardDescTacU05Up => '复制并移除敌人的增益，还造成5点伤害。';

  @override
  String get cardNameTacU06 => '战略撤退';

  @override
  String get cardDescTacU06 => '洗回手牌并抽5张新牌。';

  @override
  String get cardNameTacU06Up => '战略撤退+';

  @override
  String get cardDescTacU06Up => '洗回手牌并抽6张新牌。';

  @override
  String get cardNameTacU07 => '以物换物';

  @override
  String get cardDescTacU07 => '消耗手中1张牌，生成2张随机牌。';

  @override
  String get cardNameTacU07Up => '以物换物+';

  @override
  String get cardDescTacU07Up => '消耗手中1张牌，生成3张随机牌。';

  @override
  String get cardNameTacU08 => '连环陷阱';

  @override
  String get cardDescTacU08 => '获得3荆棘（永久）。被击中时施加虚弱1回合。';

  @override
  String get cardNameTacU08Up => '连环陷阱+';

  @override
  String get cardDescTacU08Up => '获得5荆棘（永久）。被击中时施加虚弱1回合。';

  @override
  String get cardNameTacR01 => '完美计划';

  @override
  String get cardDescTacR01 => '获得能量+3并抽3张牌。下回合抽牌数为0。';

  @override
  String get cardNameTacR01Up => '完美计划+';

  @override
  String get cardDescTacR01Up => '获得能量+3并抽3张牌。下回合抽2张牌。';

  @override
  String get cardNameTacR02 => '命运之轮';

  @override
  String get cardDescTacR02 => '随机效果1次：15伤害、15格挡、回复15HP或能量+2之一。';

  @override
  String get cardNameTacR02Up => '命运之轮+';

  @override
  String get cardDescTacR02Up => '随机效果2次：15伤害、15格挡、回复15HP或能量+2之一。';

  @override
  String get cardNameTacR03 => '替身';

  @override
  String get cardDescTacR03 => '将本回合使用的所有牌放回手中。';

  @override
  String get cardNameTacR03Up => '替身+';

  @override
  String get cardDescTacR03Up => '将本回合使用的所有牌放回手中并获得能量+2。';

  @override
  String get cardNameTacR04 => '贪婪之手';

  @override
  String get cardDescTacR04 => '造成6点伤害。击杀时额外获得1张牌奖励。';

  @override
  String get cardNameTacR04Up => '贪婪之手+';

  @override
  String get cardDescTacR04Up => '造成10点伤害。击杀时额外获得1张牌奖励。';

  @override
  String get cardNameTacR05 => '大混乱';

  @override
  String get cardDescTacR05 => '对所有敌人施加易伤+虚弱2回合和毒3。';

  @override
  String get cardNameTacR05Up => '大混乱+';

  @override
  String get cardDescTacR05Up => '对所有敌人施加易伤+虚弱3回合和毒3。';

  @override
  String get cardNameTacL01 => '时间主宰';

  @override
  String get cardDescTacL01 => '获得2个额外回合（每回合能量2）。消耗。';

  @override
  String get cardNameTacL01Up => '时间主宰+';

  @override
  String get cardDescTacL01Up => '获得2个额外回合（每回合能量3）。消耗。';

  @override
  String get cardNameTacL02 => '命运转化';

  @override
  String get cardDescTacL02 => '本次战斗升级所有牌。消耗。';

  @override
  String get cardNameTacL02Up => '命运转化+';

  @override
  String get cardDescTacL02Up => '本次战斗升级所有牌并获得能量+2。消耗。';

  @override
  String get relicNameStart01 => '冒险者背包';

  @override
  String get relicDescStart01 => '战斗奖励卡牌选项+1张(3→4)';

  @override
  String get relicNameStart02 => '旧护符';

  @override
  String get relicDescStart02 => '开始时HP+15';

  @override
  String get relicNameStart03 => '幸运硬币';

  @override
  String get relicDescStart03 => '战斗金币+30%';

  @override
  String get relicNameC01 => '锚';

  @override
  String get relicDescC01 => '每回合开始时自动获得防御4';

  @override
  String get relicNameC02 => '红色药水';

  @override
  String get relicDescC02 => '战斗开始时恢复HP5';

  @override
  String get relicNameC03 => '魔法球';

  @override
  String get relicDescC03 => '每3回合能量+1';

  @override
  String get relicNameC04 => '锋利磨刀石';

  @override
  String get relicDescC04 => '第一张攻击卡伤害+3';

  @override
  String get relicNameC05 => '盗贼手套';

  @override
  String get relicDescC05 => '战斗奖励金币+15';

  @override
  String get relicNameC06 => '轻便鞋';

  @override
  String get relicDescC06 => '第一回合抽牌+2';

  @override
  String get relicNameC07 => '毒素袋';

  @override
  String get relicDescC07 => '战斗开始时对所有敌人施加毒素2';

  @override
  String get relicNameC08 => '荆棘盾';

  @override
  String get relicDescC08 => '荆棘1(永久)';

  @override
  String get relicNameC09 => '专注戒指';

  @override
  String get relicDescC09 => '使用费用为0的卡牌时获得防御2';

  @override
  String get relicNameC10 => '战士手环';

  @override
  String get relicDescC10 => '手牌全为攻击卡时能量+1';

  @override
  String get relicNameU01 => '霜之心脏';

  @override
  String get relicDescU01 => '使用攻击卡时有20%概率施加虚弱1回合';

  @override
  String get relicNameU02 => '贤者之石';

  @override
  String get relicDescU02 => '魔法卡伤害+25%';

  @override
  String get relicNameU03 => '不死鸟羽毛';

  @override
  String get relicDescU03 => '死亡时以30%HP复活一次';

  @override
  String get relicNameU04 => '时之沙';

  @override
  String get relicDescU04 => '前3回合能量+1';

  @override
  String get relicNameU05 => '灵魂收割者';

  @override
  String get relicDescU05 => '击杀敌人时恢复HP5';

  @override
  String get relicNameU06 => '魔法镜';

  @override
  String get relicDescU06 => '反射第一个减益效果(一次)';

  @override
  String get relicNameU07 => '探险家地图';

  @override
  String get relicDescU07 => '在地图上显示下一层全部节点';

  @override
  String get relicNameU08 => '炼金术士背包';

  @override
  String get relicDescU08 => '在商店免费移除一张卡牌';

  @override
  String get relicNameR01 => '龙鳞';

  @override
  String get relicDescR01 => '所有攻击受到的伤害-1';

  @override
  String get relicNameR02 => '第三只眼';

  @override
  String get relicDescR02 => '以精确数值显示敌人意图';

  @override
  String get relicNameR03 => '无限袋';

  @override
  String get relicDescR03 => '最大持牌数+1(手牌6张)';

  @override
  String get relicNameR04 => '觉醒法球';

  @override
  String get relicDescR04 => '能量上限+1(3→4)';

  @override
  String get relicNameR05 => '命运之线';

  @override
  String get relicDescR05 => '卡牌奖励中稀有以上概率翻倍';

  @override
  String get relicNameB01 => '王冠';

  @override
  String get relicDescB01 => '能量上限+1，开始时获得1张诅咒';

  @override
  String get relicNameB02 => '魔王之心';

  @override
  String get relicDescB02 => '所有卡牌伤害+5，受到伤害+5';

  @override
  String get relicNameB03 => '复活圣杯';

  @override
  String get relicDescB03 => '在休息节点完全恢复HP';

  @override
  String get relicNameB04 => '混沌球体';

  @override
  String get relicDescB04 => '每回合在手牌中生成1张随机卡牌';

  @override
  String get relicNameB05 => '时间王冠';

  @override
  String get relicDescB05 => '第一回合额外再来一回合';

  @override
  String get achievementNameAc1 => '第一步';

  @override
  String get achievementDescAc1 => '完成1次任务';

  @override
  String get achievementNameAc2 => '勤勉证明';

  @override
  String get achievementDescAc2 => '完成10次任务';

  @override
  String get achievementNameAc3 => '达到5级';

  @override
  String get achievementDescAc3 => '脱离新手冒险者';

  @override
  String get achievementNameAc4 => '力量觉醒';

  @override
  String get achievementDescAc4 => '力量属性达到10';

  @override
  String get achievementNameAc5 => '智慧之始';

  @override
  String get achievementDescAc5 => '智慧属性达到10';

  @override
  String get achievementNameAc6 => '向顶峰进发';

  @override
  String get achievementDescAc6 => '达到20级';

  @override
  String get achievementNameAc7 => '技能探索者';

  @override
  String get achievementDescAc7 => '学习5个技能';

  @override
  String get achievementNameAc8 => '健康达人';

  @override
  String get achievementDescAc8 => '健康属性达到50';

  @override
  String get achievementNameAc9 => '智慧大师';

  @override
  String get achievementDescAc9 => '智慧属性达到50';

  @override
  String get achievementNameAc10 => '任务狂热者';

  @override
  String get achievementDescAc10 => '完成500次任务';

  @override
  String get achievementNameAc11 => '持续实践者';

  @override
  String get achievementDescAc11 => '完成50次任务';

  @override
  String get achievementNameAc12 => '习惯大师';

  @override
  String get achievementDescAc12 => '完成100次任务';

  @override
  String get achievementNameAc13 => '老练冒险者';

  @override
  String get achievementDescAc13 => '达到30级';

  @override
  String get achievementNameAc14 => '传奇英雄';

  @override
  String get achievementDescAc14 => '达到50级';

  @override
  String get achievementNameAc15 => '肌肉之王';

  @override
  String get achievementDescAc15 => '力量属性达到100';

  @override
  String get achievementNameAc16 => '技能大师';

  @override
  String get achievementDescAc16 => '学习12个技能';

  @override
  String get achievementNameAc17 => '全能专家';

  @override
  String get achievementDescAc17 => '学习20个技能';

  @override
  String get achievementNameAc18 => '初次狩猎';

  @override
  String get achievementDescAc18 => '击杀1只怪物';

  @override
  String get achievementNameAc19 => '新手猎人';

  @override
  String get achievementDescAc19 => '击杀10只怪物';

  @override
  String get achievementNameAc20 => '熟练战士';

  @override
  String get achievementDescAc20 => '击杀50只怪物';

  @override
  String get achievementNameAc21 => '屠杀者';

  @override
  String get achievementDescAc21 => '击杀200只怪物';

  @override
  String get achievementNameAc22 => '传奇探险家';

  @override
  String get achievementDescAc22 => '完成1000次任务';

  @override
  String get achievementNameAc23 => '达到10级';

  @override
  String get achievementDescAc23 => '摆脱新手标签！';

  @override
  String get achievementNameAc24 => '魅力之星';

  @override
  String get achievementDescAc24 => '魅力属性达到30';

  @override
  String get achievementNameAc25 => '魅力之王';

  @override
  String get achievementDescAc25 => '魅力属性达到80';

  @override
  String get titleNameT0 => '嫩芽冒险者';

  @override
  String get titleDescT0 => '一切都是新的开始';

  @override
  String get titleNameT1 => '勤勉冒险者';

  @override
  String get titleDescT1 => '坚持不懈是美德';

  @override
  String get titleNameT2 => '熟练开拓者';

  @override
  String get titleDescT2 => '走自己道路的人';

  @override
  String get titleNameT3 => '力量狂热者';

  @override
  String get titleDescT3 => '力量任务XP+5%';

  @override
  String get titleNameT4 => '志向贤者';

  @override
  String get titleDescT4 => '智慧任务XP+5%';

  @override
  String get titleNameT5 => '钢铁体力';

  @override
  String get titleDescT5 => '健康任务XP+5%';

  @override
  String get titleNameT6 => '万人迷';

  @override
  String get titleDescT6 => '魅力任务XP+5%';

  @override
  String get titleNameT7 => '勤勉化身';

  @override
  String get titleDescT7 => '完成100次任务';

  @override
  String get titleNameT8 => '全能才子';

  @override
  String get titleDescT8 => '所有属性达到20';

  @override
  String get titleNameT9 => '任务工匠';

  @override
  String get titleDescT9 => '完成250次任务';

  @override
  String get titleNameT10 => '向顶峰迈进';

  @override
  String get titleDescT10 => '达到30级';

  @override
  String get titleNameT11 => '传奇勇士';

  @override
  String get titleDescT11 => '达到40级';

  @override
  String get titleNameT12 => '世界英雄';

  @override
  String get titleDescT12 => '达到50级';

  @override
  String get titleNameT13 => '破坏化身';

  @override
  String get titleDescT13 => '力量任务XP+10%';

  @override
  String get titleNameT14 => '大贤者';

  @override
  String get titleDescT14 => '智慧任务XP+10%';

  @override
  String get titleNameT15 => '不死战士';

  @override
  String get titleDescT15 => '健康任务XP+10%';

  @override
  String get titleNameT16 => '绝对魅力';

  @override
  String get titleDescT16 => '魅力任务XP+10%';

  @override
  String get titleNameT17 => '任务传奇';

  @override
  String get titleDescT17 => '完成500次任务';

  @override
  String get titleNameT18 => '任务之神';

  @override
  String get titleDescT18 => '完成1000次任务';

  @override
  String get titleNameT19 => '全能掌控者';

  @override
  String get titleDescT19 => '所有属性达到50';

  @override
  String get titleNameT20 => '新手营员';

  @override
  String get titleDescT20 => '达到3级';

  @override
  String get titleNameT21 => '经验丰富的旅者';

  @override
  String get titleDescT21 => '达到20级';

  @override
  String get titleNameT22 => '力量之巅';

  @override
  String get titleDescT22 => '力量达到100！';

  @override
  String get titleNameT23 => '智慧之巅';

  @override
  String get titleDescT23 => '智慧达到100！';

  @override
  String get titleNameT24 => '月间突袭突破者';

  @override
  String get titleDescT24 => '月间突袭通关1次';

  @override
  String get titleNameT25 => '月间突袭征服者';

  @override
  String get titleDescT25 => '月间突袭通关5次';

  @override
  String get titleNameT26 => '年间突袭生存者';

  @override
  String get titleDescT26 => '年间突袭通关1次';

  @override
  String get titleNameT27 => '年间突袭君主';

  @override
  String get titleDescT27 => '年间突袭通关3次';

  @override
  String get skillNameSk1 => '力量强化';

  @override
  String get skillDescSk1 => '力量任务XP+10%';

  @override
  String get skillNameSk2 => '智慧之光';

  @override
  String get skillDescSk2 => '智慧任务XP+10%';

  @override
  String get skillNameSk3 => '健康体魄';

  @override
  String get skillDescSk3 => '健康任务XP+10%';

  @override
  String get skillNameSk4 => '魅力散发';

  @override
  String get skillDescSk4 => '魅力任务XP+10%';

  @override
  String get skillNameSk5 => '任务专家';

  @override
  String get skillDescSk5 => '所有任务XP+5%';

  @override
  String get skillNameSk6 => '成长的喜悦';

  @override
  String get skillDescSk6 => '升级时额外获得SP1';

  @override
  String get skillNameSk7 => '专注训练';

  @override
  String get skillDescSk7 => '消耗SP1时属性增加2';

  @override
  String get skillNameSk8 => '学习加速';

  @override
  String get skillDescSk8 => '所有任务XP+10%';

  @override
  String get skillNameSk9 => '超越成长';

  @override
  String get skillDescSk9 => '升级时基础SP5→7';

  @override
  String get skillNameSk10 => '火焰剑击';

  @override
  String get skillDescSk10 => '战斗使用：造成额外25伤害';

  @override
  String get skillNameSk11 => '治愈之光';

  @override
  String get skillDescSk11 => '战斗使用：恢复HP20';

  @override
  String get skillNameSk12 => '雷电一击';

  @override
  String get skillDescSk12 => '战斗使用：造成50伤害';

  @override
  String get skillNameSk13 => '冰结魔法';

  @override
  String get skillDescSk13 => '战斗使用：造成35伤害';

  @override
  String get skillNameSk14 => '毒雾';

  @override
  String get skillDescSk14 => '战斗使用：造成30伤害';

  @override
  String get skillNameSk15 => '护盾';

  @override
  String get skillDescSk15 => '战斗使用：恢复HP40';

  @override
  String get skillNameSk16 => '大地震';

  @override
  String get skillDescSk16 => '战斗使用：造成70伤害';

  @override
  String get skillNameSk17 => '神圣祈祷';

  @override
  String get skillDescSk17 => '战斗使用：恢复HP60';

  @override
  String get skillNameSk18 => '战斗本能';

  @override
  String get skillDescSk18 => '力量任务XP+15%';

  @override
  String get skillNameSk19 => '冥想境界';

  @override
  String get skillDescSk19 => '智慧任务XP+15%';

  @override
  String get skillNameSk20 => '黑暗之剑';

  @override
  String get skillDescSk20 => '战斗使用：造成100伤害';

  @override
  String get skillNameSk21 => '完全再生';

  @override
  String get skillDescSk21 => '战斗使用：恢复HP80';

  @override
  String get skillNameSk22 => '极限效率';

  @override
  String get skillDescSk22 => '消耗SP1时属性增加3';

  @override
  String get skillNameSk23 => '超越加速';

  @override
  String get skillDescSk23 => '所有任务XP+20%';

  @override
  String get skillNameSk24 => '神的祝福';

  @override
  String get skillDescSk24 => '升级时额外获得SP3';

  @override
  String get monsterSlimeGreen => '绿色史莱姆';

  @override
  String get monsterBat => '洞穴蝙蝠';

  @override
  String get monsterMushroom => '毒蘑菇';

  @override
  String get monsterSlimeBlue => '蓝色史莱姆';

  @override
  String get monsterRat => '巨鼠';

  @override
  String get monsterGoblin => '哥布林';

  @override
  String get monsterSkeleton => '骷髅战士';

  @override
  String get monsterWolf => '暗影之狼';

  @override
  String get monsterSpiderGiant => '巨毒蜘蛛';

  @override
  String get monsterTreant => '行走之树';

  @override
  String get monsterOrc => '兽人战士';

  @override
  String get monsterDarkMage => '暗黑法师';

  @override
  String get monsterGolem => '石头魔像';

  @override
  String get monsterHarpy => '鸟妖';

  @override
  String get monsterMimic => '拟态怪';

  @override
  String get monsterLavaGolem => '熔岩魔像';

  @override
  String get monsterFireSpirit => '火焰精灵';

  @override
  String get monsterDemonWarrior => '魔族战士';

  @override
  String get monsterSalamander => '蝾螈';

  @override
  String get monsterCerberus => '地狱犬';

  @override
  String get monsterShadowKnight => '暗影骑士';

  @override
  String get monsterLich => '巫妖';

  @override
  String get monsterBehemoth => '庞然大物';

  @override
  String get monsterDarkPhoenix => '黑暗不死鸟';

  @override
  String get monsterVoidWorm => '虚空蠕虫';

  @override
  String get monsterBossTroll => '山怪首领';

  @override
  String get monsterBossDragon => '火焰龙';

  @override
  String get monsterBossDemonLord => '魔王';

  @override
  String get monsterBossHydra => '九头蛇';

  @override
  String get monsterBossFallenAngel => '堕天使';

  @override
  String get monsterBossDeathKnight => '死亡骑士';

  @override
  String get chapterName1 => '草原防线';

  @override
  String get chapterName2 => '黑暗森林';

  @override
  String get chapterName3 => '废墟城堡';

  @override
  String get chapterName4 => '熔岩地牢';

  @override
  String get chapterName5 => '深渊次元';
}
