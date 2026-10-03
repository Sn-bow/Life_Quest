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
  String get save => '儲存';

  @override
  String get close => '關閉';

  @override
  String get confirm => '確認';

  @override
  String get delete => '刪除';

  @override
  String get apply => '套用';

  @override
  String get change => '修改';

  @override
  String get complete => '完成';

  @override
  String get acquire => '習得';

  @override
  String get tabStatus => '狀態';

  @override
  String get tabQuests => '任務';

  @override
  String get tabHunt => '狩獵';

  @override
  String get tabInventory => '背包';

  @override
  String get tabShop => '商店';

  @override
  String get tabAchievement => '成就';

  @override
  String get tabSkill => '技能';

  @override
  String get loginTitle => '將日常行動轉化為經驗值';

  @override
  String get loginSubtitle => '積累小任務，讓自己每天成長的生產力RPG';

  @override
  String get loginEmailLabel => '電子郵件';

  @override
  String get loginPasswordLabel => '密碼';

  @override
  String get loginButton => '登入';

  @override
  String get loginRegisterButton => '註冊新冒險者';

  @override
  String get loginDivider => '或';

  @override
  String get loginGoogleButton => '使用 Google 帳號開始';

  @override
  String get loginErrorEmpty => '請輸入電子郵件和密碼。';

  @override
  String get loginErrorFailed => '登入失敗。';

  @override
  String get loginErrorGoogleToken => '無法取得 Google 驗證資訊，請重試。';

  @override
  String get loginErrorGoogle => 'Google登入失敗。';

  @override
  String loginErrorUnknown(String error) {
    return '發生錯誤: $error';
  }

  @override
  String get loginForgotPassword => '忘記密碼了嗎?';

  @override
  String get loginForgotPasswordEmailRequired => '請先輸入電子郵件地址。';

  @override
  String loginForgotPasswordSent(String email) {
    return '密碼重置郵件已傳送至 $email。';
  }

  @override
  String get signupTitle => '註冊新冒險者';

  @override
  String get signupPickPhoto => '選擇頭像';

  @override
  String get signupEmailLabel => '電子郵件';

  @override
  String get signupEmailRequired => '請輸入電子郵件。';

  @override
  String get signupEmailInvalid => '請輸入有效的電子郵件地址（例如：name@example.com）。';

  @override
  String get signupNicknameLabel => '暱稱';

  @override
  String get signupNicknameRequired => '請輸入暱稱。';

  @override
  String get signupPasswordLabel => '密碼';

  @override
  String get signupPasswordTooShort => '密碼至少需要6個字元。';

  @override
  String get signupPasswordConfirmLabel => '確認密碼';

  @override
  String get signupPasswordMismatch => '密碼不匹配。';

  @override
  String get signupButton => '完成註冊';

  @override
  String get signupSuccess => '🎉 註冊成功！歡迎加入！';

  @override
  String get signupErrorFailed => '註冊失敗。';

  @override
  String signupErrorUnknown(String error) {
    return '發生未知錯誤: $error';
  }

  @override
  String get signupErrorUserCreate => '建立使用者失敗。';

  @override
  String get statusScreenTitle => '狀態';

  @override
  String get statusTimerTooltip => '專注計時器';

  @override
  String get statusSettingsTooltip => '設定';

  @override
  String get statusHpLabel => '生活HP';

  @override
  String get statusHpRecoveryHint => '生活HP表示日常任務狀態。非戰鬥狀態下，每10分鐘會自然緩慢恢復。';

  @override
  String statusStreakLabel(int days) {
    return '連續達成: $days天';
  }

  @override
  String statusStreakBonus(int percent) {
    return 'XP +$percent%';
  }

  @override
  String get statusStatHint => '升級時，3點根據最近完成任務的傾向自動成長，其餘點數可自行分配。';

  @override
  String get statusGoldLabel => '金幣';

  @override
  String get statusApLabel => '行動力';

  @override
  String get statusBaseStatTitle => '基礎屬性';

  @override
  String get statusDetailStatButton => '檢視詳細屬性';

  @override
  String get statusDetailStatTitle => '📊 詳細戰鬥屬性';

  @override
  String get statusAttackLabel => '攻擊力';

  @override
  String get statusDefenseLabel => '防禦力';

  @override
  String get statusCritLabel => '暴擊率';

  @override
  String get statusDodgeLabel => '閃避率';

  @override
  String get statusStatStrength => '力量';

  @override
  String get statusStatWisdom => '智慧';

  @override
  String get statusStatHealth => '健康';

  @override
  String get statusStatCharm => '魅力';

  @override
  String get todayAdventureHeading => '今日狀態';

  @override
  String todayAdventureCompletedCount(int count) {
    return '已完成 $count 項';
  }

  @override
  String get todayAdventureDescription =>
      '現實中完成的行動會帶來成長、獎勵與下一步建議。地下城則是體驗這些成長的選擇性玩法。';

  @override
  String todayAdventureGoldGain(int amount) {
    return '金幣 +$amount';
  }

  @override
  String get todayAdventureGrowthWaiting => '等待成長';

  @override
  String todayAdventureStatGrowth(String stat) {
    return '$stat成長';
  }

  @override
  String get todayAdventureStatStrength => '執行力';

  @override
  String get todayAdventureStatWisdom => '智慧';

  @override
  String get todayAdventureStatHealth => '健康';

  @override
  String get todayAdventureStatCharisma => '魅力';

  @override
  String get todayAdventureEffectsHeading => '今日的行動效果';

  @override
  String get todayAdventureNoEffects => '今天尚未記錄行動效果。完成一項任務即可獲得成長與加成。';

  @override
  String get todayAdventureRecommendationHeading => '下一步建議行動';

  @override
  String get todayAdventureAllDoneTitle => '今天計畫的行動已全部完成';

  @override
  String get todayAdventureAllDoneReason =>
      '今天的行動已轉化為成長與加成。你可以到地下城體驗，也可以用現實獎勵為今天收尾。';

  @override
  String todayAdventureTitleProgressReason(String title) {
    return '這會直接推進「$title」稱號的進度。完成後就更接近解鎖條件。';
  }

  @override
  String get todayAdventureStrengthReason => '執行力尚無紀錄。完成後將更接近攻擊加成與健康成長。';

  @override
  String get todayAdventureWisdomReason => '學習與分析尚無紀錄。完成後可提升首回合抽牌與魔法卡出現率。';

  @override
  String get todayAdventureHealthReason => '恢復與生活節奏尚無紀錄。完成後可提升 HP 與防禦卡出現率。';

  @override
  String get todayAdventureCharismaReason => '人際與表達尚無紀錄。完成後可增加事件選項與起始金幣。';

  @override
  String todayAdventureNextTitle(String title) {
    return '下一個稱號：$title';
  }

  @override
  String todayAdventureDungeonHp(int amount) {
    return '地下城 HP +$amount';
  }

  @override
  String todayAdventureAttackDamage(int amount) {
    return '攻擊傷害 +$amount';
  }

  @override
  String todayAdventureFirstTurnDraw(int amount) {
    return '首回合卡牌 +$amount';
  }

  @override
  String todayAdventureStartingGold(int amount) {
    return '起始金幣 +$amount';
  }

  @override
  String todayAdventureDefenseFlow(int percent) {
    return '防禦卡出現率 +$percent%';
  }

  @override
  String todayAdventureMagicFlow(int percent) {
    return '魔法卡出現率 +$percent%';
  }

  @override
  String todayAdventureEventChoice(int percent) {
    return '事件選項 +$percent%';
  }

  @override
  String todayAdventureShopDiscount(int percent) {
    return '商店折扣 -$percent%';
  }

  @override
  String todayAdventureRestHealing(int percent) {
    return '休息恢復 +$percent%';
  }

  @override
  String get titleUnlockT1 => '解鎖救助倒下冒險者的選項';

  @override
  String get titleUnlockT2 => '解鎖危險橋樑的安全繞道選項';

  @override
  String get titleUnlockT3 => '解鎖鐵匠事件中的力量強化選項';

  @override
  String get titleUnlockT4 => '解鎖古代圖書館中的智慧解讀選項';

  @override
  String get titleUnlockT5 => '解鎖神祕泉水中的安全恢復選項';

  @override
  String get titleUnlockT6 => '解鎖與可疑商人交涉的魅力選項';

  @override
  String get titleUnlockT7 => '解鎖卡牌整理事件中的精細整理選項';

  @override
  String get titleUnlockT8 => '解鎖詛咒祭壇中的平衡淨化選項';

  @override
  String get titleUnlockT13 => '解鎖鐵匠事件中的熟練強化選項';

  @override
  String get titleUnlockT14 => '解鎖古代圖書館中的進階解讀選項';

  @override
  String get titleUnlockT15 => '解鎖神祕泉水中的穩定恢復選項';

  @override
  String get titleUnlockT16 => '解鎖與可疑商人的交涉選項';

  @override
  String get titleUnlockT19 => '解鎖詛咒祭壇中的完全淨化選項';

  @override
  String get titleUnlockT20 => '解鎖沉睡冒險者事件中的營地選項';

  @override
  String get titleUnlockT21 => '解鎖與沼澤精靈締約的選項';

  @override
  String get titleUnlockT24 => '解鎖惡魔賭局中的判讀局勢選項';

  @override
  String get titleUnlockT26 => '解鎖危險橋樑的結構加固選項';

  @override
  String get statusTitleChangeTitle => '更換稱號';

  @override
  String get statusStatApplyTitle => '確認屬性分配';

  @override
  String statusStatApplyBody(String summary) {
    return '要套用以下屬性分配嗎？\n\n$summary\n\n套用後無法復原。';
  }

  @override
  String get questsScreenTitle => '任務列表';

  @override
  String get questsTabDaily => '每日任務';

  @override
  String get questsTabWeekly => '每週任務';

  @override
  String get questsTabMonthly => '月度副本';

  @override
  String get questsTabYearly => '年度副本';

  @override
  String get questsEmptyDaily => '還沒有新增任務。\n從今天要做的小事開始吧。';

  @override
  String get questsEmptyWeekly => '還沒有每週常規目標。\n新增想要持續堅持的目標吧。';

  @override
  String get questsEmptyMonthly => '本月還沒有副本。\n將長期目標新增為月度副本吧。';

  @override
  String get questsEmptyYearly => '今年還沒有大型副本。\n將人生目標級的挑戰新增為年度副本吧。';

  @override
  String get questsCategoryStrength => '力量';

  @override
  String get questsCategoryWisdom => '智慧';

  @override
  String get questsCategoryHealth => '健康';

  @override
  String get questsCategoryCharm => '魅力';

  @override
  String get questsDifficultyEasy => '簡單';

  @override
  String get questsDifficultyNormal => '普通';

  @override
  String get questsDifficultyHard => '困難';

  @override
  String get questsDifficultyVeryHard => '非常困難';

  @override
  String get questsTypeDaily => '每日';

  @override
  String get questsTypeWeekly => '每週';

  @override
  String get questsTypeMonthly => '月度副本';

  @override
  String get questsTypeYearly => '年度副本';

  @override
  String get questsCompleteTitle => '完成任務';

  @override
  String questsCompleteConfirm(String questName) {
    return '確認完成任務「$questName」？';
  }

  @override
  String get questsBaseRewardLabel => '基礎獎勵';

  @override
  String get questsGoldUnit => '金幣';

  @override
  String get questsAdRewardApplied => '🎉 已套用廣告獎勵';

  @override
  String questsDoubleAdButton(int remaining) {
    return '看廣告獲得2倍獎勵 (剩餘$remaining次)';
  }

  @override
  String get questsAdUnavailable => '廣告載入失敗，已發放基礎獎勵。';

  @override
  String get questsEditTitle => '編輯任務';

  @override
  String get questsAddTitle => '新增新任務';

  @override
  String get questsNameLabel => '任務名稱';

  @override
  String get questsTypeLabel => '類型';

  @override
  String get questsCategoryLabel => '分類';

  @override
  String get questsDifficultyLabel => '難度';

  @override
  String questsRewardPreview(String type, int xp, int gold) {
    return '$type獎勵: $xp XP · $gold 金幣';
  }

  @override
  String get questsNameRequired => '請輸入任務名稱。';

  @override
  String get questsDeleteTitle => '刪除任務';

  @override
  String questsDeleteBody(String questName) {
    return '確認刪除任務「$questName」？\n\n刪除後無法恢復。';
  }

  @override
  String questsRaidClear(int count) {
    return '副本通關 $count 次';
  }

  @override
  String questsRewardSummary(int xp, int gold, int ap) {
    return '總獎勵: $xp XP · $gold 金幣 · AP +$ap';
  }

  @override
  String questsRewardStatPoints(int sp) {
    return '額外屬性點 +$sp';
  }

  @override
  String questsRewardUnlockedTitles(String titles) {
    return '解鎖稱號: $titles';
  }

  @override
  String questsRewardUnlockedCosmetics(String cosmetics) {
    return '解鎖獎勵: $cosmetics';
  }

  @override
  String get questsRaidBonusMonthly => '副本獎勵\n額外XP·額外金幣\nAP +2·SP +1\n解鎖進度獎勵';

  @override
  String get questsRaidBonusYearly => '副本獎勵\n大量XP·大量金幣\nAP +4·SP +2\n解鎖稀有獎勵';

  @override
  String get huntScreenTitle => '狩獵場';

  @override
  String get huntMyHpLabel => '戰鬥HP';

  @override
  String huntComboBadge(int count) {
    return '💥 連擊: $count';
  }

  @override
  String huntApBadge(int ap) {
    return '⚡ AP: $ap';
  }

  @override
  String get huntActionAttack => '攻擊 (1 AP)';

  @override
  String get huntActionDefend => '防禦 (1 AP)';

  @override
  String get huntActionSkill => '技能 (自由)';

  @override
  String get huntActionBag => '揹包 (1 AP)';

  @override
  String get huntActionFlee => '逃跑 (1 AP)';

  @override
  String get huntBagTitle => '揹包 (消耗品)';

  @override
  String get huntBagEmpty => '沒有可用的道具。';

  @override
  String get huntBagUse => '使用 (1 AP)';

  @override
  String get huntSkillSelectTitle => '選擇要使用的技能:';

  @override
  String get huntSkillEmpty => '還沒有學習戰鬥技能。';

  @override
  String get huntApLowTitle => 'AP不足';

  @override
  String huntApLowBody(int remaining) {
    return 'AP不足。看廣告恢復2 AP嗎？\n(今日剩餘: $remaining次)';
  }

  @override
  String get huntApRecoverButton => '看廣告恢復';

  @override
  String get huntApExhausted => '⚡ AP不足！請完成任務。(今日廣告恢復已全部用完)';

  @override
  String huntDoubleRewardButton(int remaining) {
    return '看廣告獲得2倍戰利品 (剩餘$remaining次)';
  }

  @override
  String get huntDoubleRewardSuccess => '🎉 透過廣告獎勵獲得了2倍戰利品！';

  @override
  String get huntAdUnavailable => '廣告載入失敗，請重試。';

  @override
  String get huntResultButton => '檢視結果並返回';

  @override
  String huntReviveButton(int remaining) {
    return '看廣告復活 (今日剩餘$remaining次)';
  }

  @override
  String get huntReviveSuccess => '❤️ 透過廣告獎勵立即復活！';

  @override
  String get huntReviveAdUnavailable => '廣告載入失敗，請稍後重試。';

  @override
  String get huntRetreatButton => '放棄並返回';

  @override
  String get inventoryScreenTitle => '揹包';

  @override
  String get inventoryEquippedSection => '已裝備';

  @override
  String get inventoryCombatStatSection => '戰鬥屬性';

  @override
  String inventoryItemsSection(int count) {
    return '持有道具 ($count)';
  }

  @override
  String get inventorySlotWeapon => '⚔️ 武器';

  @override
  String get inventorySlotArmor => '🛡️ 防具';

  @override
  String get inventorySlotAccessory => '💍 飾品';

  @override
  String get inventorySlotEmpty => '空';

  @override
  String get inventoryUnequip => '卸下';

  @override
  String get inventoryUseEquip => '使用 / 裝備';

  @override
  String get inventoryEmptyMessage => '目前沒有道具\n擊敗怪物即可取得裝備！';

  @override
  String get inventoryGoDungeon => '前往地下城';

  @override
  String get inventoryAttackLabel => '攻擊力';

  @override
  String get inventoryDefenseLabel => '防禦力';

  @override
  String get inventoryHpLabel => '健康加成';

  @override
  String get inventoryStatStrength => '力量';

  @override
  String get inventoryStatWisdom => '智慧';

  @override
  String get inventoryStatHealth => '健康';

  @override
  String get inventoryStatCharm => '魅力';

  @override
  String get inventoryStatAttack => '攻擊力';

  @override
  String get inventoryStatDefense => '防禦力';

  @override
  String inventoryUsedHp(String itemName) {
    return '使用了$itemName。(HP恢復)';
  }

  @override
  String inventoryUsedAp(String itemName) {
    return '使用了$itemName。(AP恢復)';
  }

  @override
  String get inventoryRarityCommon => '普通';

  @override
  String get inventoryRarityUncommon => '優質';

  @override
  String get inventoryRarityRare => '稀有';

  @override
  String get inventoryRarityEpic => '史詩';

  @override
  String get inventoryRarityLegendary => '傳說';

  @override
  String get shopScreenTitle => '商店';

  @override
  String get defaultReward1Name => '吃好吃的零食';

  @override
  String get defaultReward1Desc => '享用一份喜歡的零食';

  @override
  String get defaultReward2Name => '玩30分鐘遊戲';

  @override
  String get defaultReward2Desc => '無愧疚地玩30分鐘';

  @override
  String get defaultReward3Name => '看想看的影片/電影';

  @override
  String get defaultReward3Desc => '看YouTube或Netflix一小時';

  @override
  String get shopTabGameItems => '遊戲道具';

  @override
  String get shopTabCustomRewards => '我的獎勵';

  @override
  String get shopThemeBannerTitle => '主題展示';

  @override
  String get shopThemeBannerSubtitle => '預覽即將推出的主題和特效。';

  @override
  String get shopConsumableSection => '消耗品';

  @override
  String get shopEquipBoxSection => '裝備箱';

  @override
  String get shopPermanentSection => '永久強化';

  @override
  String get shopHpPotionName => 'HP恢復藥水';

  @override
  String get shopHpPotionDesc => '恢復30 HP。';

  @override
  String get shopHpFullPotionName => 'HP完全恢復藥水';

  @override
  String get shopHpFullPotionDesc => '將HP恢復至最大值。';

  @override
  String get shopApPotionName => 'AP充能藥水';

  @override
  String get shopApPotionDesc => '恢復5 AP。';

  @override
  String get shopNormalBoxName => '普通裝備箱';

  @override
  String get shopNormalBoxDesc => '隨機獲得普通~稀有裝備。';

  @override
  String get shopNormalBoxSuccess => '獲得裝備！請檢視揹包！';

  @override
  String get shopPremiumBoxName => '高階裝備箱';

  @override
  String get shopPremiumBoxDesc => '隨機獲得稀有~傳說裝備。';

  @override
  String get shopPremiumBoxSuccess => '獲得高階裝備！請檢視揹包！';

  @override
  String get shopMaxHpName => '最大HP +10';

  @override
  String get shopMaxHpDesc => '永久增加最大HP 10點。';

  @override
  String get shopMaxHpSuccess => '最大HP增加了10點！';

  @override
  String get shopMaxApName => '最大AP +2';

  @override
  String get shopMaxApDesc => '永久增加最大AP 2點。';

  @override
  String get shopMaxApSuccess => '最大AP增加了2點！';

  @override
  String get shopCustomRewardAddTitle => '新增自訂獎勵';

  @override
  String get shopCustomRewardNameLabel => '獎勵名稱 (例: 1小時Netflix)';

  @override
  String get shopCustomRewardDescLabel => '說明';

  @override
  String get shopCustomRewardDescHint => '享受這個獎勵吧！';

  @override
  String get shopCustomRewardCostLabel => '所需金幣';

  @override
  String get shopCustomRewardIconLabel => '圖示 (表情符號)';

  @override
  String get shopCustomRewardAddButton => '新增獎勵';

  @override
  String shopCustomRewardDeleted(String name) {
    return '$name已刪除';
  }

  @override
  String get shopAdSupportTitle => '可選獎勵廣告已停用';

  @override
  String get shopAdSupportDesc => '目前預設 Android 版本不提供廣告獎勵功能。';

  @override
  String get shopAdModelTitle => '變現功能準備中';

  @override
  String get shopAdModelDesc => '目前預設 Android 版本已停用廣告和應用內購買。未來的高階功能會在明確說明後提供。';

  @override
  String get achievementScreenTitle => '成就';

  @override
  String get achievementTabInProgress => '進行中';

  @override
  String get achievementTabCompleted => '已完成';

  @override
  String get achievementEmptyInProgress => '所有成就已達成，或等待新挑戰！';

  @override
  String get achievementEmptyCompleted => '還沒有完成的成就。';

  @override
  String achievementRewardXp(int xp) {
    return '獎勵: $xp XP';
  }

  @override
  String achievementRewardSp(int sp) {
    return '獎勵: $sp SP';
  }

  @override
  String get skillScreenTitle => '技能';

  @override
  String skillRequiredLevel(int level) {
    return '需求條件: Lv.$level';
  }

  @override
  String get settingsScreenTitle => '設定';

  @override
  String get settingsAccountSection => '帳號';

  @override
  String get settingsNicknameLabel => '暱稱';

  @override
  String get settingsNicknameChangeTitle => '修改暱稱';

  @override
  String get settingsNicknameNewLabel => '新暱稱';

  @override
  String get settingsAppSection => 'App 設定';

  @override
  String get settingsDarkMode => '深色模式';

  @override
  String get settingsDarkModeSubtitle => '切換 App 主題。';

  @override
  String get settingsSfx => '音效 (SFX)';

  @override
  String get settingsSfxSubtitle => '開啟或關閉遊戲音效。';

  @override
  String get settingsNotification => '通知設定';

  @override
  String get settingsNotificationSubtitle => '每天早上9點接收任務提醒。';

  @override
  String get settingsNotificationEnabled => '已為每天早上9點和晚上8點設定通知。';

  @override
  String get settingsNotificationDisabled => '所有通知已取消。';

  @override
  String get settingsNotificationMorning => '早晨通知時間';

  @override
  String get settingsNotificationNight => '晚間通知時間';

  @override
  String settingsNotificationTimeValue(int hour) {
    return '每天$hour時';
  }

  @override
  String get settingsLanguage => '語言';

  @override
  String get settingsLanguageSubtitle => '選擇 App 的顯示語言。';

  @override
  String get settingsLanguageSystem => '系統預設';

  @override
  String get settingsLanguageKorean => '한국어';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageJapanese => '日本語';

  @override
  String get settingsLanguageChinese => '繁體中文（台灣）';

  @override
  String get onboardingPage1Title => '你的狀態視窗已開啟';

  @override
  String get onboardingPage1Body => '下方的名字、等級、XP 和四項能力值是目前個人檔案的實際紀錄，並非示意進度。';

  @override
  String get onboardingPage2Title => '任務與選用 AI';

  @override
  String get onboardingPage2Body => '把小行動記為任務。支援的裝置可另外安裝 AI 模型。';

  @override
  String get onboardingPage3Title => '查看成長紀錄';

  @override
  String get onboardingPage3Body => '在成長紀錄查看已完成的任務與獲得的 XP。';

  @override
  String get onboardingNext => '下一步';

  @override
  String get onboardingStart => '開啟我的狀態視窗';

  @override
  String get onboardingSkip => '跳過';

  @override
  String get settingsAdSupportSection => '變現說明';

  @override
  String get settingsAdSupportTitle => '廣告和購買已停用';

  @override
  String get settingsAdSupportDesc => '目前預設 Android 版本不提供廣告獎勵或應用內購買。';

  @override
  String get settingsAdModelTitle => '高階功能準備中';

  @override
  String get settingsAdModelDesc => '如果未來提供付費功能，將清楚說明價格、權益和取消方式。';

  @override
  String get settingsLogout => '登出';

  @override
  String get settingsWithdraw => '刪除帳號';

  @override
  String get settingsWithdrawTitle => '刪除帳號';

  @override
  String get settingsWithdrawBody =>
      '將刪除帳號、雲端紀錄、檢舉內容與購買關聯。送出申請後會登出；即使關閉 App，刪除作業仍會繼續。此帳號將無法還原已購買內容。刪除後無法復原，且不等於退款。';

  @override
  String get settingsWithdrawConfirm => '確認刪除帳號';

  @override
  String get settingsReauthPasswordTitle => '確認密碼';

  @override
  String get settingsPrivacyPolicy => '隱私政策';

  @override
  String get settingsTerms => '服務條款';

  @override
  String get settingsLegalSection => '條款與政策';

  @override
  String get loadingSync => '正在同步獵人資訊';

  @override
  String get loadingSyncDesc => '正在載入今日任務和成長記錄';

  @override
  String get loadingGate => '正在開啟傳送門';

  @override
  String get loadingGateDesc => '正在初始化系統';

  @override
  String get loadingTagline => 'ARISE YOUR QUEST';

  @override
  String get timerScreenFocus => '🍅 專注計時器';

  @override
  String get timerScreenBreak => '☕ 休息計時器';

  @override
  String get timerFocusMode => '專注模式';

  @override
  String get timerBreakMode => '休息模式';

  @override
  String timerSessionCount(int count) {
    return '第$count次專注完成';
  }

  @override
  String get timerFocusCompleteTitle => '🎉 專注完成！';

  @override
  String timerFocusCompleteBody(int minutes) {
    return '$minutes分鐘專注會話完成！';
  }

  @override
  String get timerGoldRewardLabel => '金幣 +';

  @override
  String timerTodaySessions(int count) {
    return '今日完成: $count 次';
  }

  @override
  String get timerStartBreak => '開始休息';

  @override
  String get timerFocusRewardLabel => '專注完成獎勵:';

  @override
  String get cosmeticShopTitle => '主題展示';

  @override
  String get cosmeticCategoryTheme => 'App 主題';

  @override
  String get cosmeticCategoryTitleEffect => '稱號特效';

  @override
  String get cosmeticCategoryCombatEffect => '戰鬥特效';

  @override
  String get cosmeticComingSoonTitle => '高階自訂功能即將推出';

  @override
  String get cosmeticComingSoonDesc =>
      '目前預設 Android 版本不提供裝飾商品購買。主題和特效功能將在明確說明後開放。';

  @override
  String get cosmeticUnequip => '卸下';

  @override
  String get cosmeticEquip => '裝備';

  @override
  String get cosmeticComingSoon => '即將推出';

  @override
  String get cosmeticComingSoonSnackbar => '裝飾商品將在明確說明後開放。';

  @override
  String get cosmeticUnlocked => '物品已解鎖！';

  @override
  String get cosmeticPurchaseError => '購買失敗';

  @override
  String get questTileEditTooltip => '編輯任務';

  @override
  String get questTileDeleteTooltip => '刪除任務';

  @override
  String get notificationMorningTitle => '開始今日任務！';

  @override
  String get notificationMorningBody => '新的一天開始了。記錄你的成長吧。';

  @override
  String get notificationEveningTitle => '今天的任務都完成了嗎？';

  @override
  String get notificationEveningBody => '還有未完成的任務，可能會減少HP！';

  @override
  String get initialTitleRookie => '新手冒險者';

  @override
  String get initialQuestMorning => '早上7點起床';

  @override
  String get initialQuestExercise => '運動30分鐘';

  @override
  String get initialQuestRead => '閱讀10頁書';

  @override
  String get initialQuestWeeklyExercise => '每週運動3次以上';

  @override
  String get initialQuestWeeklyLearn => '學習新技能/知識';

  @override
  String get initialQuestMonthlyExercise => '本月達成12次運動';

  @override
  String get initialQuestMonthlyProject => '完成副業專案核心功能';

  @override
  String get initialQuestYearly => '完成今年最重要的目標';

  @override
  String get reportScreenTitle => '詳細報告';

  @override
  String get reportExpandedUnlocked => '今日擴充套件報告已解鎖。';

  @override
  String get reportAdFailed => '廣告載入失敗，請稍後再試。';

  @override
  String get reportSummaryStreak => '目前連續記錄';

  @override
  String reportSummaryStreakValue(int days) {
    return '$days天';
  }

  @override
  String get reportSummaryXp => '目前XP';

  @override
  String get reportSummaryQuestCount => '完成的任務';

  @override
  String reportSummaryQuestCountValue(int count) {
    return '$count個';
  }

  @override
  String get reportSummaryTitle => '目前稱號';

  @override
  String get reportWeeklyActivityTitle => '本週活動記錄';

  @override
  String get reportWeeklyActivitySubtitle => '檢視本週的日常維持情況。';

  @override
  String get reportWeeklyActivityEmpty => '本週尚未完成任務。';

  @override
  String get reportWeeklyActivityOpenQuests => '查看任務';

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
  String get reportExpandedEntryTitle => '廣告解鎖擴充套件報告';

  @override
  String get reportExpandedAlreadyUnlocked => '今日擴充套件報告已解鎖，可在下方檢視深度分析。';

  @override
  String get reportExpandedDescription => '解鎖後可檢視類別比例、成長傾向和自動成長記錄。';

  @override
  String get reportFeatureCategoryRatio => '任務類別比例';

  @override
  String get reportFeatureGrowthTrend => '下一等級成長傾向分析';

  @override
  String get reportFeatureAutoGrowth => '上一等級自動成長記錄';

  @override
  String get reportUnlockedToday => '今日擴充套件報告已解鎖';

  @override
  String reportWatchAdButton(int count) {
    return '觀看廣告解鎖擴充套件報告（今日剩餘$count次）';
  }

  @override
  String get reportNoMoreViews => '今日已無法再次解鎖';

  @override
  String get reportCategoryRatioTitle => '任務類別比例';

  @override
  String get reportInsightGrowthTrendTitle => '本等級成長傾向';

  @override
  String get reportInsightGrowthTrendCaption => '這是完成任務最多反映的方向。';

  @override
  String get reportInsightGrowthTrendCaptionEmpty => '完成任務後，自動成長傾向將逐漸積累。';

  @override
  String get reportInsightDataInsufficient => '資料不足';

  @override
  String get reportInsightAutoGrowthTitle => '上一等級自動成長';

  @override
  String get reportInsightAutoGrowthCaption => '升級時3點將根據行動統計自動分配。';

  @override
  String get reportInsightBestDayTitle => '本週最佳專注日';

  @override
  String reportInsightBestDayCaption(int count) {
    return '本週共完成了$count個任務。';
  }

  @override
  String get reportInsightRecommendedStatTitle => '推薦專注屬性';

  @override
  String get reportInsightBalanced => '均衡';

  @override
  String get reportNextLevelPredictionTitle => '下一等級自動成長預測';

  @override
  String get reportLongTermTitle => '長期目標進度';

  @override
  String get reportLongTermSubtitle => '一次檢視月間和年間副本進度。';

  @override
  String get reportProgressMonthlyRaid => '月間副本';

  @override
  String get reportProgressYearlyRaid => '年間副本';

  @override
  String get reportLowestStat => '目前最低屬性';

  @override
  String get reportHighestStat => '最高屬性';

  @override
  String get reportCalendarTitle => '任務日曆';

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
    return '$month月$day日 已完成任務';
  }

  @override
  String get reportCalendarSelectPrompt => '請選擇日期';

  @override
  String get reportCalendarNoQuests => '該日期沒有已完成的任務。';

  @override
  String get reportNoRecord => '無記錄';

  @override
  String get reportStatBalanced => '目前屬性均衡，狀態穩定。';

  @override
  String reportAddQuestSuggestion(String category) {
    return '嘗試新增$category系任務';
  }

  @override
  String reportRecommendedAction(String action) {
    return '推薦行動: $action';
  }

  @override
  String reportBestWeekday(String weekday, int count) {
    return '$weekday ($count個)';
  }

  @override
  String get reportWeekdayMonday => '週一';

  @override
  String get reportWeekdayTuesday => '週二';

  @override
  String get reportWeekdayWednesday => '週三';

  @override
  String get reportWeekdayThursday => '週四';

  @override
  String get reportWeekdayFriday => '週五';

  @override
  String get reportWeekdaySaturday => '週六';

  @override
  String get reportWeekdaySunday => '週日';

  @override
  String reportStatValue(String stat, int value) {
    return '$stat $value';
  }

  @override
  String shopItemAcquired(String name) {
    return '獲得了$name！';
  }

  @override
  String get shopCustomRewardFabLabel => '新增獎勵';

  @override
  String get statusReportTooltip => '檢視詳細報告';

  @override
  String get dungeonHomeTitle => '卡牌探索';

  @override
  String get dungeonHomeCardCollectionTooltip => '卡牌收藏';

  @override
  String get dungeonHomeDungeonSelection => '選擇地下城';

  @override
  String dungeonHomeRequiredLevel(int requiredLevel) {
    return '需要$requiredLevel級或以上';
  }

  @override
  String dungeonHomeLockedHint(int requiredLevel) {
    return '達到Lv.$requiredLevel即可解鎖 — 完成任務提升等級';
  }

  @override
  String get zone1Name => '青色草原';

  @override
  String get zone1Description => '適合新手冒險者的第一個地下城';

  @override
  String get zone2Name => '黑暗森林';

  @override
  String get zone2Description => '潛伏著使用毒素和減益效果的敵人';

  @override
  String get zone3Name => '廢墟城堡';

  @override
  String get zone3Description => '等待著防禦專精的敵人和多重戰鬥';

  @override
  String get zone4Name => '熔岩洞穴';

  @override
  String get zone4Description => '灼傷和高傷害的地獄';

  @override
  String get zone5Name => '深淵次元';

  @override
  String get zone5Description => '隱藏意圖的敵人，降下詛咒的最終地下城';

  @override
  String get seasonName => '賽季1：靈魂覺醒';

  @override
  String get seasonEnded => '已結束';

  @override
  String seasonCountdown(int days) {
    return 'D-$days';
  }

  @override
  String get ascensionModeTitle => '飛昇模式';

  @override
  String get ascensionInactive => '未啟用';

  @override
  String get ascensionActiveModifiers => '目前懲罰：';

  @override
  String get ascensionSliderHint => '上滑以增加難度';

  @override
  String get ascensionLevel1Modifier => 'Lv 1: 敵人HP +10%';

  @override
  String get ascensionLevel2Modifier => 'Lv 2: 敵人攻擊 +10%';

  @override
  String get ascensionLevel3Modifier => 'Lv 3: 起始金幣 -30';

  @override
  String get ascensionLevel4Modifier => 'Lv 4: 增加1張詛咒卡';

  @override
  String get ascensionLevel5Modifier => 'Lv 5: 消滅精英後無卡牌選擇';

  @override
  String get ascensionLevel6Modifier => 'Lv 6: 商店價格 +25%';

  @override
  String get ascensionLevel7Modifier => 'Lv 7: 起始HP -10%';

  @override
  String get ascensionLevel8Modifier => 'Lv 8: Boss HP +25%';

  @override
  String get ascensionLevel9Modifier => 'Lv 9: 強化事件不利選項';

  @override
  String get ascensionLevel10Modifier => 'Lv 10: 所有敵人HP +20%';

  @override
  String get infiniteTowerTitle => '無限之塔';

  @override
  String infiniteTowerBestFloorDesc(int bestFloor) {
    return '無盡挑戰 · 最高記錄: $bestFloor層';
  }

  @override
  String get infiniteTowerSelectFloor => '選擇挑戰樓層';

  @override
  String get infiniteTowerFloorInfo => '樓層資訊';

  @override
  String infiniteTowerChallengeFloor(int targetFloor) {
    return '挑戰$targetFloor層';
  }

  @override
  String get infiniteTowerFloorComposition => '樓層構成';

  @override
  String get infiniteTowerBestFloorLabel => '最高記錄';

  @override
  String infiniteTowerFloorDisplay(int floor) {
    return '$floor層';
  }

  @override
  String get infiniteTowerEnemyHp => '敵人HP';

  @override
  String get infiniteTowerEnemyAttack => '敵人攻擊';

  @override
  String get infiniteTowerDefault => '基礎';

  @override
  String get infiniteTowerFloor1To5 => '1-5層';

  @override
  String get infiniteTowerFloor6To10 => '6-10層';

  @override
  String get infiniteTowerFloor11To15 => '11-15層';

  @override
  String get infiniteTowerFloor16To20 => '16-20層';

  @override
  String get infiniteTowerFloor21To25 => '21-25層';

  @override
  String get infiniteTowerFloor26Plus => '26層以上';

  @override
  String get infiniteTowerRepeatZones => '從區域1重複（難度持續上升）';

  @override
  String get dungeonMapTitle => '地下城地圖';

  @override
  String get dungeonMapNoData => '沒有地下城資料';

  @override
  String get dungeonRestTitle => '休息點';

  @override
  String get dungeonRestDescription => '發現了一個安靜的休息點。溫暖的篝火在燃燒。\n你要做什麼？';

  @override
  String get dungeonRestRestTitle => '休息';

  @override
  String get dungeonRestRestDescription => '恢復30%的HP';

  @override
  String dungeonRestHealResult(int healAmount) {
    return 'HP恢復了$healAmount！';
  }

  @override
  String get dungeonRestTrainTitle => '修煉';

  @override
  String get dungeonRestTrainDescription => '強化1張卡牌';

  @override
  String get dungeonRestNoCardsToUpgrade => '沒有可強化的卡牌';

  @override
  String get dungeonRestContinueButton => '繼續';

  @override
  String get dungeonRestSelectCardToUpgrade => '選擇要強化的卡牌';

  @override
  String get dungeonRestCardUpgraded => '已強化';

  @override
  String dungeonRestCardUpgradeResult(String name) {
    return '「$name」卡牌已強化！';
  }

  @override
  String get dungeonEventCardRewardTitle => '請選擇一張卡牌';

  @override
  String get dungeonShopTitle => '地下城商店';

  @override
  String get dungeonShopCardsSection => '卡牌';

  @override
  String get dungeonShopNoCards => '沒有在售的卡牌';

  @override
  String get dungeonShopRelicsSection => '遺物';

  @override
  String get dungeonShopNoRelics => '沒有在售的遺物';

  @override
  String get dungeonShopCardRemovalSection => '移除卡牌';

  @override
  String get dungeonShopLeaveButton => '離開商店';

  @override
  String get dungeonShopSelectCardToRemove => '選擇要移除的卡牌';

  @override
  String dungeonShopRemovalCost(int cost) {
    return '費用: $cost金幣';
  }

  @override
  String get dungeonShopPurchaseComplete => '購買完成';

  @override
  String get dungeonShopRemoveOneCard => '移除1張卡牌';

  @override
  String dungeonShopRemovalDescription(int deckSize) {
    return '從牌組中移除不需要的卡牌（目前牌組: $deckSize張）';
  }

  @override
  String get dungeonEventTitle => '事件';

  @override
  String get dungeonEventNoData => '沒有事件資料';

  @override
  String get dungeonEventChooseAction => '請選擇';

  @override
  String get dungeonEventContinueButton => '繼續';

  @override
  String get dungeonEventOutcomeTitle => '結果';

  @override
  String get dungeonEventEffectCardReward => '獲得卡牌';

  @override
  String get dungeonEventEffectRelicReward => '獲得遺物';

  @override
  String get dungeonEventEffectCardRemove => '移除卡牌';

  @override
  String get dungeonEventEffectCardUpgrade => '強化卡牌';

  @override
  String get dungeonEventEffectCurseAdded => '新增詛咒';

  @override
  String get dungeonResultVictoryTitle => '地下城通關！';

  @override
  String get dungeonResultDefeatTitle => '探索結束';

  @override
  String get dungeonResultVictoryMessage => '恭喜！你擊敗了所有敵人，征服了地下城。';

  @override
  String get dungeonResultDefeatMessage => '已完成房間的成果會保留。準備好後再來探索吧。';

  @override
  String get dungeonResultStatsTitle => '冒險記錄';

  @override
  String get dungeonResultStatsZone => '區域';

  @override
  String get dungeonResultStatsNodesCompleted => '已完成房間';

  @override
  String get dungeonResultStatsMonsterKilled => '擊殺怪物';

  @override
  String get dungeonResultRewardsTitle => '獎勵';

  @override
  String dungeonResultXpReward(int xpGained) {
    return '+$xpGained XP';
  }

  @override
  String dungeonResultGoldReward(int goldGained) {
    return '+$goldGained金幣';
  }

  @override
  String get dungeonResultVictoryBonus => '通關獎勵 x1.5 + Boss擊殺獎勵';

  @override
  String get dungeonResultDefeatPenalty => '失敗懲罰: 獎勵 x0.5';

  @override
  String get dungeonResultReturnHomeButton => '返回主頁';

  @override
  String get cardBattleYourTurn => '你的回合';

  @override
  String get cardBattleEnemyTurn => '敵人回合';

  @override
  String cardBattleTurnCount(int turnCount) {
    return '第$turnCount回合';
  }

  @override
  String get cardBattleAbandonDialog => '放棄戰鬥';

  @override
  String get cardBattleAbandonConfirmation =>
      '結束本次探索嗎？你會獲得已完成房間的獎勵，日常等級和經驗值保持不變。';

  @override
  String get cardBattleAbandonButton => '放棄';

  @override
  String get cardBattleNoEnemies => '沒有敵人';

  @override
  String get cardBattleEndTurnButton => '結束回合';

  @override
  String get cardBattleNoCardsInHand => '手牌中沒有卡牌';

  @override
  String get cardBattleVictory => '勝利！';

  @override
  String cardBattleGoldReward(int gold) {
    return '+$gold金幣';
  }

  @override
  String get cardBattleSelectCard => '請選擇一張卡牌';

  @override
  String get cardBattleSkipButton => '跳過';

  @override
  String get cardBattleEpEmpty => 'EP不足';

  @override
  String cardBattlePlayableCount(int count) {
    return '可出$count張';
  }

  @override
  String get cardBattleDrawPile => '摸牌';

  @override
  String get cardBattleDiscardPile => '棄牌';

  @override
  String get cardBattleIntentAttack => '攻擊';

  @override
  String get cardBattleIntentMultiAttack => '連續攻擊';

  @override
  String get cardBattleIntentDefend => '防禦';

  @override
  String get cardBattleIntentBuff => '強化';

  @override
  String get cardBattleIntentDebuff => '弱化';

  @override
  String get cardBattleIntentUnknown => '?';

  @override
  String get cardRarityCommon => '普通';

  @override
  String get cardRarityUncommon => '罕見';

  @override
  String get cardRarityRare => '稀有';

  @override
  String get cardRarityLegendary => '傳說';

  @override
  String get cardCategoryAttack => '攻擊';

  @override
  String get cardCategoryMagic => '魔法';

  @override
  String get cardCategoryDefense => '防禦';

  @override
  String get cardCategoryTactical => '戰術';

  @override
  String get cardCollectionTitle => '卡牌收藏';

  @override
  String get cardCollectionFilterAll => '全部';

  @override
  String get cardCollectionMyCollection => '我的收藏';

  @override
  String cardCollectionCardCount(int count) {
    return '($count張)';
  }

  @override
  String get cardCollectionNoCards => '你沒有卡牌。\n完成任務可以獲得卡牌！';

  @override
  String cardCollectionDeckInclusion(int copyCount) {
    return '牌組中有$copyCount張';
  }

  @override
  String get cardCollectionAddToDeck => '新增到牌組';

  @override
  String get cardCollectionDeckFull => '牌組已滿 (20張)';

  @override
  String get cardCollectionMaxCopies => '最多可新增3張';

  @override
  String cardCollectionAddedToDeck(String cardName) {
    return '$cardName已新增到牌組';
  }

  @override
  String get cardCollectionMyDeck => '我的牌組';

  @override
  String cardCollectionDeckSize(int deckSize) {
    return '($deckSize/20張)';
  }

  @override
  String get cardCollectionResetDeckDialog => '重置牌組';

  @override
  String get cardCollectionResetDeckConfirmation => '刪除自訂牌組並恢復為預設初始牌組？';

  @override
  String get cardCollectionResetButton => '重置';

  @override
  String get cardCollectionDefaultDeckMessage => '目前使用預設初始牌組\n從收藏中新增卡牌';

  @override
  String get cardNameBaseStrike => '基礎攻擊';

  @override
  String get cardDescBaseStrike => '造成6點傷害。';

  @override
  String get cardNameBaseDefend => '基礎格擋';

  @override
  String get cardDescBaseDefend => '獲得5點格擋。';

  @override
  String get cardNameBaseFocus => '集中';

  @override
  String get cardDescBaseFocus => '抽1張牌。';

  @override
  String get cardNameCursePain => '痛苦';

  @override
  String get cardDescCursePain => '無法使用。每次抽到時失去1HP。';

  @override
  String get cardNameCurseDoubt => '疑慮';

  @override
  String get cardDescCurseDoubt => '無法使用。每回合少抽1張牌。';

  @override
  String get cardNameCurseBurden => '負擔';

  @override
  String get cardDescCurseBurden => '無法使用。每回合開始時失去1能量。';

  @override
  String get cardNameCurseDecay => '腐蝕';

  @override
  String get cardDescCurseDecay => '無法使用。每回合失去3點格擋。';

  @override
  String get cardNameAtkC01 => '重擊';

  @override
  String get cardDescAtkC01 => '造成6點傷害。';

  @override
  String get cardNameAtkC01Up => '重擊+';

  @override
  String get cardDescAtkC01Up => '造成9點傷害。';

  @override
  String get cardNameAtkC02 => '斬擊';

  @override
  String get cardDescAtkC02 => '造成4點傷害，抽1張牌。';

  @override
  String get cardNameAtkC02Up => '斬擊+';

  @override
  String get cardDescAtkC02Up => '造成6點傷害，抽1張牌。';

  @override
  String get cardNameAtkC03 => '連擊';

  @override
  String get cardDescAtkC03 => '造成3點傷害，共2次。';

  @override
  String get cardNameAtkC03Up => '連擊+';

  @override
  String get cardDescAtkC03Up => '造成3點傷害，共3次。';

  @override
  String get cardNameAtkC04 => '怒擊';

  @override
  String get cardDescAtkC04 => '造成3點傷害，將1張憤怒牌加入棄牌堆。';

  @override
  String get cardNameAtkC04Up => '怒擊+';

  @override
  String get cardDescAtkC04Up => '造成5點傷害。';

  @override
  String get cardNameAtkC05 => '衝鋒';

  @override
  String get cardDescAtkC05 => '造成12點傷害。';

  @override
  String get cardNameAtkC05Up => '衝鋒+';

  @override
  String get cardDescAtkC05Up => '造成16點傷害。';

  @override
  String get cardNameAtkC06 => '流血攻擊';

  @override
  String get cardDescAtkC06 => '造成4點傷害，施加2層中毒。';

  @override
  String get cardNameAtkC06Up => '流血攻擊+';

  @override
  String get cardDescAtkC06Up => '造成4點傷害，施加4層中毒。';

  @override
  String get cardNameAtkC07 => '快刺';

  @override
  String get cardDescAtkC07 => '造成3點傷害。';

  @override
  String get cardNameAtkC07Up => '快刺+';

  @override
  String get cardDescAtkC07Up => '造成5點傷害。';

  @override
  String get cardNameAtkC08 => '挑釁';

  @override
  String get cardDescAtkC08 => '造成5點傷害，施加1回合易傷。';

  @override
  String get cardNameAtkC08Up => '挑釁+';

  @override
  String get cardDescAtkC08Up => '造成8點傷害，施加1回合易傷。';

  @override
  String get cardNameAtkC09 => '突襲';

  @override
  String get cardDescAtkC09 => '第1回合造成12點傷害，否則造成6點傷害。';

  @override
  String get cardNameAtkC09Up => '突襲+';

  @override
  String get cardDescAtkC09Up => '第1回合造成18點傷害，否則造成9點傷害。';

  @override
  String get cardNameAtkC10 => '刀刃風暴';

  @override
  String get cardDescAtkC10 => '對所有敵人造成3點傷害。';

  @override
  String get cardNameAtkC10Up => '刀刃風暴+';

  @override
  String get cardDescAtkC10Up => '對所有敵人造成5點傷害。';

  @override
  String get cardNameAtkU01 => '強力斬擊';

  @override
  String get cardDescAtkU01 => '造成14點傷害，施加脆弱2回合。';

  @override
  String get cardNameAtkU01Up => '強力斬擊+';

  @override
  String get cardDescAtkU01Up => '造成18點傷害，施加脆弱2回合。';

  @override
  String get cardNameAtkU02 => '刀刃之舞';

  @override
  String get cardDescAtkU02 => '造成3次3點傷害，獲得3格擋。';

  @override
  String get cardNameAtkU02Up => '刀刃之舞+';

  @override
  String get cardDescAtkU02Up => '造成3次4點傷害，獲得5格擋。';

  @override
  String get cardNameAtkU03 => '處決';

  @override
  String get cardDescAtkU03 => '敵人HP低於50%時造成30點傷害，否則10點傷害。';

  @override
  String get cardNameAtkU03Up => '處決+';

  @override
  String get cardDescAtkU03Up => '敵人HP低於50%時造成40點傷害，否則14點傷害。';

  @override
  String get cardNameAtkU04 => '狂暴';

  @override
  String get cardDescAtkU04 => '獲得力量+2（永久）。';

  @override
  String get cardNameAtkU04Up => '狂暴+';

  @override
  String get cardDescAtkU04Up => '獲得力量+3（永久）。';

  @override
  String get cardNameAtkU05 => '血誓';

  @override
  String get cardDescAtkU05 => '失去3HP，造成8點傷害，獲得力量+1。';

  @override
  String get cardNameAtkU05Up => '血誓+';

  @override
  String get cardDescAtkU05Up => '失去3HP，造成12點傷害，獲得力量+1。';

  @override
  String get cardNameAtkU06 => '旋風斬';

  @override
  String get cardDescAtkU06 => '對所有敵人造成8點傷害。';

  @override
  String get cardNameAtkU06Up => '旋風斬+';

  @override
  String get cardDescAtkU06Up => '對所有敵人造成12點傷害。';

  @override
  String get cardNameAtkU07 => '粉碎';

  @override
  String get cardDescAtkU07 => '造成10點傷害，施加虛弱2回合。';

  @override
  String get cardNameAtkU07Up => '粉碎+';

  @override
  String get cardDescAtkU07Up => '造成14點傷害，施加虛弱2回合。';

  @override
  String get cardNameAtkU08 => '無情';

  @override
  String get cardDescAtkU08 => '對脆弱狀態敵人造成雙倍傷害（基礎6點傷害）。';

  @override
  String get cardNameAtkU08Up => '無情+';

  @override
  String get cardDescAtkU08Up => '對脆弱狀態敵人造成雙倍傷害（基礎9點傷害）。';

  @override
  String get cardNameAtkR01 => '龍之一擊';

  @override
  String get cardDescAtkR01 => '造成30點傷害，施加燃燒3回合。';

  @override
  String get cardNameAtkR01Up => '龍之一擊+';

  @override
  String get cardDescAtkR01Up => '造成40點傷害，施加燃燒4回合。';

  @override
  String get cardNameAtkR02 => '千刀萬剮';

  @override
  String get cardDescAtkR02 => '對手牌中每張牌造成1點傷害。';

  @override
  String get cardNameAtkR02Up => '千刀萬剮+';

  @override
  String get cardDescAtkR02Up => '對手牌中每張牌造成2點傷害。';

  @override
  String get cardNameAtkR03 => '風暴之劍';

  @override
  String get cardDescAtkR03 => '對本回合已使用的每張牌造成5點傷害。';

  @override
  String get cardNameAtkR03Up => '風暴之劍+';

  @override
  String get cardDescAtkR03Up => '對本回合已使用的每張牌造成7點傷害。';

  @override
  String get cardNameAtkR04 => '死神鐮刀';

  @override
  String get cardDescAtkR04 => '造成15點傷害。擊殺時恢復10HP。';

  @override
  String get cardNameAtkR04Up => '死神鐮刀+';

  @override
  String get cardDescAtkR04Up => '造成20點傷害。擊殺時恢復15HP。';

  @override
  String get cardNameAtkR05 => '狂戰士';

  @override
  String get cardDescAtkR05 => '獲得力量+5，3回合後力量-5。';

  @override
  String get cardNameAtkR05Up => '狂戰士+';

  @override
  String get cardDescAtkR05Up => '獲得力量+7，3回合後力量-5。';

  @override
  String get cardNameAtkL01 => '王者之劍';

  @override
  String get cardDescAtkL01 => '造成50點傷害，施加脆弱+虛弱3回合。使用後消耗。';

  @override
  String get cardNameAtkL01Up => '王者之劍+';

  @override
  String get cardDescAtkL01Up => '造成60點傷害，施加脆弱+虛弱3回合。使用後消耗。';

  @override
  String get cardNameAtkL02 => '無限之刃';

  @override
  String get cardDescAtkL02 => '造成8點傷害。每次使用永久+2傷害。';

  @override
  String get cardNameAtkL02Up => '無限之刃+';

  @override
  String get cardDescAtkL02Up => '造成12點傷害。每次使用永久+2傷害。';

  @override
  String get cardNameMagC01 => '火球';

  @override
  String get cardDescMagC01 => '造成4點傷害，施加燃燒2回合。';

  @override
  String get cardNameMagC01Up => '火球+';

  @override
  String get cardDescMagC01Up => '造成6點傷害，施加燃燒3回合。';

  @override
  String get cardNameMagC02 => '霜矢';

  @override
  String get cardDescMagC02 => '造成5點傷害，施加虛弱1回合。';

  @override
  String get cardNameMagC02Up => '霜矢+';

  @override
  String get cardDescMagC02Up => '造成8點傷害，施加虛弱1回合。';

  @override
  String get cardNameMagC03 => '法力集中';

  @override
  String get cardDescMagC03 => '獲得能量+1，抽1張牌。';

  @override
  String get cardNameMagC03Up => '法力集中+';

  @override
  String get cardDescMagC03Up => '獲得能量+1，抽2張牌。';

  @override
  String get cardNameMagC04 => '電擊';

  @override
  String get cardDescMagC04 => '對隨機敵人造成7點傷害。';

  @override
  String get cardNameMagC04Up => '電擊+';

  @override
  String get cardDescMagC04Up => '對隨機敵人造成10點傷害。';

  @override
  String get cardNameMagC05 => '魔法飛彈';

  @override
  String get cardDescMagC05 => '對隨機目標造成2次4點傷害。';

  @override
  String get cardNameMagC05Up => '魔法飛彈+';

  @override
  String get cardDescMagC05Up => '對隨機目標造成3次4點傷害。';

  @override
  String get cardNameMagC06 => '冥想';

  @override
  String get cardDescMagC06 => '抽2張牌。';

  @override
  String get cardNameMagC06Up => '冥想+';

  @override
  String get cardDescMagC06Up => '抽3張牌。';

  @override
  String get cardNameMagC07 => '知識之光';

  @override
  String get cardDescMagC07 => '檢視牌庫頂3張牌，將1張加入手牌。';

  @override
  String get cardNameMagC07Up => '知識之光+';

  @override
  String get cardDescMagC07Up => '檢視牌庫頂3張牌，將2張加入手牌。';

  @override
  String get cardNameMagC08 => '毒霧';

  @override
  String get cardDescMagC08 => '對所有敵人施加毒3。';

  @override
  String get cardNameMagC08Up => '毒霧+';

  @override
  String get cardDescMagC08Up => '對所有敵人施加毒5。';

  @override
  String get cardNameMagC09 => '魔力爆發';

  @override
  String get cardDescMagC09 => '造成10點傷害，獲得專注+1。';

  @override
  String get cardNameMagC09Up => '魔力爆發+';

  @override
  String get cardDescMagC09Up => '造成14點傷害，獲得專注+1。';

  @override
  String get cardNameMagC10 => '元素和諧';

  @override
  String get cardDescMagC10 => '使下一張牌的效果提高50%。';

  @override
  String get cardNameMagC10Up => '元素和諧+';

  @override
  String get cardDescMagC10Up => '使下一張牌的效果提高100%。';

  @override
  String get cardNameMagU01 => '連鎖閃電';

  @override
  String get cardDescMagU01 => '造成8點傷害，對所有敵人造成4點傷害。';

  @override
  String get cardNameMagU01Up => '連鎖閃電+';

  @override
  String get cardDescMagU01Up => '造成12點傷害，對所有敵人造成6點傷害。';

  @override
  String get cardNameMagU02 => '冰晶之眼';

  @override
  String get cardDescMagU02 => '造成12點傷害，施加冰結1次。';

  @override
  String get cardNameMagU02Up => '冰晶之眼+';

  @override
  String get cardDescMagU02Up => '造成16點傷害，施加冰結1次。';

  @override
  String get cardNameMagU03 => '智慧之書';

  @override
  String get cardDescMagU03 => '抽3張牌，消耗1張。';

  @override
  String get cardNameMagU03Up => '智慧之書+';

  @override
  String get cardDescMagU03Up => '抽4張牌。';

  @override
  String get cardNameMagU04 => '法力過載';

  @override
  String get cardDescMagU04 => '獲得能量+2。下回合能量-1。';

  @override
  String get cardNameMagU04Up => '法力過載+';

  @override
  String get cardDescMagU04Up => '獲得能量+3。';

  @override
  String get cardNameMagU05 => '元素風暴';

  @override
  String get cardDescMagU05 => '對所有敵人造成15點傷害。';

  @override
  String get cardNameMagU05Up => '元素風暴+';

  @override
  String get cardDescMagU05Up => '對所有敵人造成20點傷害。';

  @override
  String get cardNameMagU06 => '時間扭曲';

  @override
  String get cardDescMagU06 => '獲得額外回合1次（能量0，保留手牌）。';

  @override
  String get cardNameMagU06Up => '時間扭曲+';

  @override
  String get cardDescMagU06Up => '獲得額外回合1次（以1能量開始）。';

  @override
  String get cardNameMagU07 => '魔法增幅';

  @override
  String get cardDescMagU07 => '獲得專注+2（永久）。';

  @override
  String get cardNameMagU07Up => '魔法增幅+';

  @override
  String get cardDescMagU07Up => '獲得專注+3（永久）。';

  @override
  String get cardNameMagU08 => '複製術';

  @override
  String get cardDescMagU08 => '複製手牌中1張牌（僅本回合）。';

  @override
  String get cardNameMagU08Up => '複製術+';

  @override
  String get cardDescMagU08Up => '以費用0複製手牌中1張牌（僅本回合）。';

  @override
  String get cardNameMagR01 => '隕石';

  @override
  String get cardDescMagR01 => '對所有敵人造成25點傷害，施加燃燒3回合。';

  @override
  String get cardNameMagR01Up => '隕石+';

  @override
  String get cardDescMagR01Up => '對所有敵人造成35點傷害，施加燃燒3回合。';

  @override
  String get cardNameMagR02 => '法力暴走';

  @override
  String get cardDescMagR02 => '手牌中所有牌本回合費用變為0。';

  @override
  String get cardNameMagR02Up => '法力暴走+';

  @override
  String get cardDescMagR02Up => '手牌中所有牌的費用下回合前變為0。';

  @override
  String get cardNameMagR03 => '次元裂隙';

  @override
  String get cardDescMagR03 => '從棄牌堆取回3張牌。';

  @override
  String get cardNameMagR03Up => '次元裂隙+';

  @override
  String get cardDescMagR03Up => '從棄牌堆取回5張牌。';

  @override
  String get cardNameMagR04 => '靈魂吸收';

  @override
  String get cardDescMagR04 => '造成12點傷害，恢復等量HP。';

  @override
  String get cardNameMagR04Up => '靈魂吸收+';

  @override
  String get cardDescMagR04Up => '造成18點傷害，恢復等量HP。';

  @override
  String get cardNameMagR05 => '絕對零度';

  @override
  String get cardDescMagR05 => '使所有敵人冰結，造成10點傷害。';

  @override
  String get cardNameMagR05Up => '絕對零度+';

  @override
  String get cardDescMagR05Up => '使所有敵人冰結，造成15點傷害。';

  @override
  String get cardNameMagL01 => '末日審判';

  @override
  String get cardDescMagL01 => '對所有敵人造成99點傷害。自身受到30點傷害。使用後消耗。';

  @override
  String get cardNameMagL01Up => '末日審判+';

  @override
  String get cardDescMagL01Up => '對所有敵人造成99點傷害。自身受到15點傷害。使用後消耗。';

  @override
  String get cardNameMagL02 => '無限智慧';

  @override
  String get cardDescMagL02 => '抽5張牌，獲得能量+2。使用後消耗。';

  @override
  String get cardNameMagL02Up => '無限智慧+';

  @override
  String get cardDescMagL02Up => '抽7張牌，獲得能量+3。使用後消耗。';

  @override
  String get cardNameDefC01 => '防禦';

  @override
  String get cardDescDefC01 => '獲得5格擋。';

  @override
  String get cardNameDefC01Up => '防禦+';

  @override
  String get cardDescDefC01Up => '獲得8格擋。';

  @override
  String get cardNameDefC02 => '鐵壁';

  @override
  String get cardDescDefC02 => '獲得12格擋。';

  @override
  String get cardNameDefC02Up => '鐵壁+';

  @override
  String get cardDescDefC02Up => '獲得16格擋。';

  @override
  String get cardNameDefC03 => '反擊';

  @override
  String get cardDescDefC03 => '獲得4格擋和2荊棘。';

  @override
  String get cardNameDefC03Up => '反擊+';

  @override
  String get cardDescDefC03Up => '獲得6格擋和3荊棘。';

  @override
  String get cardNameDefC04 => '恢復祈禱';

  @override
  String get cardDescDefC04 => '恢復4HP。';

  @override
  String get cardNameDefC04Up => '恢復祈禱+';

  @override
  String get cardDescDefC04Up => '恢復7HP。';

  @override
  String get cardNameDefC05 => '戰鬥姿態';

  @override
  String get cardDescDefC05 => '獲得6格擋並抽1張牌。';

  @override
  String get cardNameDefC05Up => '戰鬥姿態+';

  @override
  String get cardDescDefC05Up => '獲得8格擋並抽1張牌。';

  @override
  String get cardNameDefC06 => '滾動';

  @override
  String get cardDescDefC06 => '獲得3格擋。下回合獲得6格擋。';

  @override
  String get cardNameDefC06Up => '滾動+';

  @override
  String get cardDescDefC06Up => '獲得5格擋。下回合獲得8格擋。';

  @override
  String get cardNameDefC07 => '急救';

  @override
  String get cardDescDefC07 => '恢復3HP。';

  @override
  String get cardNameDefC07Up => '急救+';

  @override
  String get cardDescDefC07Up => '恢復5HP。';

  @override
  String get cardNameDefC08 => '忍耐';

  @override
  String get cardDescDefC08 => '獲得5格擋和1回合堅定。';

  @override
  String get cardNameDefC08Up => '忍耐+';

  @override
  String get cardDescDefC08Up => '獲得7格擋和2回合堅定。';

  @override
  String get cardNameDefC09 => '生命力';

  @override
  String get cardDescDefC09 => '獲得再生3（3回合）。';

  @override
  String get cardNameDefC09Up => '生命力+';

  @override
  String get cardDescDefC09Up => '獲得再生4（4回合）。';

  @override
  String get cardNameDefC10 => '嘲諷盾';

  @override
  String get cardDescDefC10 => '獲得6格擋並嘲諷1個敵人。';

  @override
  String get cardNameDefC10Up => '嘲諷盾+';

  @override
  String get cardDescDefC10Up => '獲得9格擋並嘲諷1個敵人。';

  @override
  String get cardNameDefU01 => '路障';

  @override
  String get cardDescDefU01 => '獲得12格擋和2回合堅定。';

  @override
  String get cardNameDefU01Up => '路障+';

  @override
  String get cardDescDefU01Up => '獲得16格擋和3回合堅定。';

  @override
  String get cardNameDefU02 => '反射盾';

  @override
  String get cardDescDefU02 => '獲得8格擋和本回合5荊棘。';

  @override
  String get cardNameDefU02Up => '反射盾+';

  @override
  String get cardDescDefU02Up => '獲得12格擋和本回合7荊棘。';

  @override
  String get cardNameDefU03 => '治癒祈禱';

  @override
  String get cardDescDefU03 => '恢復10HP並獲得3回合再生2。';

  @override
  String get cardNameDefU03Up => '治癒祈禱+';

  @override
  String get cardDescDefU03Up => '恢復15HP並獲得3回合再生3。';

  @override
  String get cardNameDefU04 => '不屈意志';

  @override
  String get cardDescDefU04 => '獲得敏捷性+2（永久）。';

  @override
  String get cardNameDefU04Up => '不屈意志+';

  @override
  String get cardDescDefU04Up => '獲得敏捷性+3（永久）。';

  @override
  String get cardNameDefU05 => '守護屏障';

  @override
  String get cardDescDefU05 => '獲得等於缺失HP25%的格擋。';

  @override
  String get cardNameDefU05Up => '守護屏障+';

  @override
  String get cardDescDefU05Up => '獲得等於缺失HP30%的格擋。';

  @override
  String get cardNameDefU06 => '求生本能';

  @override
  String get cardDescDefU06 => 'HP≤50%時獲得15格擋，否則獲得5格擋。';

  @override
  String get cardNameDefU06Up => '求生本能+';

  @override
  String get cardDescDefU06Up => 'HP≤50%時獲得20格擋，否則獲得8格擋。';

  @override
  String get cardNameDefU07 => '吸血荊棘';

  @override
  String get cardDescDefU07 => '獲得3荊棘（永久）。被擊中時恢復1HP。';

  @override
  String get cardNameDefU07Up => '吸血荊棘+';

  @override
  String get cardDescDefU07Up => '獲得4荊棘（永久）。被擊中時恢復2HP。';

  @override
  String get cardNameDefU08 => '強化盔甲';

  @override
  String get cardDescDefU08 => '獲得20格擋。下回合獲得10格擋。';

  @override
  String get cardNameDefU08Up => '強化盔甲+';

  @override
  String get cardDescDefU08Up => '獲得25格擋。下回合獲得15格擋。';

  @override
  String get cardNameDefR01 => '無敵';

  @override
  String get cardDescDefR01 => '本回合所有傷害降為0。消耗。';

  @override
  String get cardNameDefR01Up => '無敵+';

  @override
  String get cardDescDefR01Up => '本回合和下回合所有傷害降為0。消耗。';

  @override
  String get cardNameDefR02 => '生命之樹';

  @override
  String get cardDescDefR02 => '恢復最大HP的30%。';

  @override
  String get cardNameDefR02Up => '生命之樹+';

  @override
  String get cardDescDefR02Up => '恢復最大HP的40%。';

  @override
  String get cardNameDefR03 => '神聖盾';

  @override
  String get cardDescDefR03 => '獲得20格擋並移除所有減益。';

  @override
  String get cardNameDefR03Up => '神聖盾+';

  @override
  String get cardDescDefR03Up => '獲得28格擋並移除所有減益。';

  @override
  String get cardNameDefR04 => '鐵甲身';

  @override
  String get cardDescDefR04 => '每回合自動獲得8格擋（戰鬥中）。';

  @override
  String get cardNameDefR04Up => '鐵甲身+';

  @override
  String get cardDescDefR04Up => '每回合自動獲得12格擋（戰鬥中）。';

  @override
  String get cardNameDefR05 => '重生藥水';

  @override
  String get cardDescDefR05 => '本次戰鬥死亡時以30%HP復活。消耗。';

  @override
  String get cardNameDefR05Up => '重生藥水+';

  @override
  String get cardDescDefR05Up => '本次戰鬥死亡時以50%HP復活。消耗。';

  @override
  String get cardNameDefL01 => '永恆盾';

  @override
  String get cardDescDefL01 => '獲得30格擋並每回合自動獲得5格擋（戰鬥中）。消耗。';

  @override
  String get cardNameDefL01Up => '永恆盾+';

  @override
  String get cardDescDefL01Up => '獲得40格擋並每回合自動獲得8格擋（戰鬥中）。消耗。';

  @override
  String get cardNameDefL02 => '生命之泉';

  @override
  String get cardDescDefL02 => '完全恢復HP並獲得最大HP+10（永久）。消耗。';

  @override
  String get cardNameDefL02Up => '生命之泉+';

  @override
  String get cardDescDefL02Up => '完全恢復HP並獲得最大HP+20（永久）。消耗。';

  @override
  String get cardNameTacC01 => '觀察';

  @override
  String get cardDescTacC01 => '檢視敵人意圖並抽1張牌。';

  @override
  String get cardNameTacC01Up => '觀察+';

  @override
  String get cardDescTacC01Up => '檢視敵人意圖並抽2張牌。';

  @override
  String get cardNameTacC02 => '尋寶';

  @override
  String get cardDescTacC02 => '戰鬥金幣+15。';

  @override
  String get cardNameTacC02Up => '尋寶+';

  @override
  String get cardDescTacC02Up => '戰鬥金幣+25。';

  @override
  String get cardNameTacC03 => '看破弱點';

  @override
  String get cardDescTacC03 => '施加易傷2回合和虛弱1回合。';

  @override
  String get cardNameTacC03Up => '看破弱點+';

  @override
  String get cardDescTacC03Up => '施加易傷2回合和虛弱2回合。';

  @override
  String get cardNameTacC04 => '靈巧之手';

  @override
  String get cardDescTacC04 => '抽2張牌。';

  @override
  String get cardNameTacC04Up => '靈巧之手+';

  @override
  String get cardDescTacC04Up => '抽3張牌。';

  @override
  String get cardNameTacC05 => '設陷阱';

  @override
  String get cardDescTacC05 => '下次敵人攻擊時反射10點傷害。';

  @override
  String get cardNameTacC05Up => '設陷阱+';

  @override
  String get cardDescTacC05Up => '下次敵人攻擊時反射15點傷害。';

  @override
  String get cardNameTacC06 => '擾亂';

  @override
  String get cardDescTacC06 => '隨機改變敵人意圖。';

  @override
  String get cardNameTacC06Up => '擾亂+';

  @override
  String get cardDescTacC06Up => '改變敵人意圖並施加虛弱1回合。';

  @override
  String get cardNameTacC07 => '扒竊';

  @override
  String get cardDescTacC07 => '造成3點傷害，獲得5~15金幣。';

  @override
  String get cardNameTacC07Up => '扒竊+';

  @override
  String get cardDescTacC07Up => '造成6點傷害，獲得10~25金幣。';

  @override
  String get cardNameTacC08 => '煙霧彈';

  @override
  String get cardDescTacC08 => '獲得4格擋，對所有敵人施加虛弱1回合。';

  @override
  String get cardNameTacC08Up => '煙霧彈+';

  @override
  String get cardDescTacC08Up => '獲得6格擋，對所有敵人施加虛弱2回合。';

  @override
  String get cardNameTacC09 => '鼓勵';

  @override
  String get cardDescTacC09 => '本次戰鬥隨機升級1張牌。';

  @override
  String get cardNameTacC09Up => '鼓勵+';

  @override
  String get cardDescTacC09Up => '本次戰鬥隨機升級2張牌。';

  @override
  String get cardNameTacC10 => '幸運硬幣';

  @override
  String get cardDescTacC10 => '50%機率抽2張牌。';

  @override
  String get cardNameTacC10Up => '幸運硬幣+';

  @override
  String get cardDescTacC10Up => '70%機率抽2張牌。';

  @override
  String get cardNameTacU01 => '戰場分析';

  @override
  String get cardDescTacU01 => '抽3張牌，將最高費用牌本回合費用降為0。';

  @override
  String get cardNameTacU01Up => '戰場分析+';

  @override
  String get cardDescTacU01Up => '抽4張牌，將最高費用牌本回合費用降為0。';

  @override
  String get cardNameTacU02 => '影步';

  @override
  String get cardDescTacU02 => '下回合前受到的傷害減少50%。';

  @override
  String get cardNameTacU02Up => '影步+';

  @override
  String get cardDescTacU02Up => '下回合前受到的傷害減少50%並抽1張牌。';

  @override
  String get cardNameTacU03 => '寶箱';

  @override
  String get cardDescTacU03 => '啟用一次隨機聖物效果。消耗。';

  @override
  String get cardNameTacU03Up => '寶箱+';

  @override
  String get cardDescTacU03Up => '啟用兩次隨機聖物效果。消耗。';

  @override
  String get cardNameTacU04 => '操縱牌庫';

  @override
  String get cardDescTacU04 => '將牌庫頂部3張牌按任意順序排列。';

  @override
  String get cardNameTacU04Up => '操縱牌庫+';

  @override
  String get cardDescTacU04Up => '將牌庫頂部5張牌按任意順序排列。';

  @override
  String get cardNameTacU05 => '雙面間諜';

  @override
  String get cardDescTacU05 => '複製並移除敵人的增益。';

  @override
  String get cardNameTacU05Up => '雙面間諜+';

  @override
  String get cardDescTacU05Up => '複製並移除敵人的增益，還造成5點傷害。';

  @override
  String get cardNameTacU06 => '戰略撤退';

  @override
  String get cardDescTacU06 => '洗回手牌並抽5張新牌。';

  @override
  String get cardNameTacU06Up => '戰略撤退+';

  @override
  String get cardDescTacU06Up => '洗回手牌並抽6張新牌。';

  @override
  String get cardNameTacU07 => '以物換物';

  @override
  String get cardDescTacU07 => '消耗手中1張牌，生成2張隨機牌。';

  @override
  String get cardNameTacU07Up => '以物換物+';

  @override
  String get cardDescTacU07Up => '消耗手中1張牌，生成3張隨機牌。';

  @override
  String get cardNameTacU08 => '連環陷阱';

  @override
  String get cardDescTacU08 => '獲得3荊棘（永久）。被擊中時施加虛弱1回合。';

  @override
  String get cardNameTacU08Up => '連環陷阱+';

  @override
  String get cardDescTacU08Up => '獲得5荊棘（永久）。被擊中時施加虛弱1回合。';

  @override
  String get cardNameTacR01 => '完美計劃';

  @override
  String get cardDescTacR01 => '獲得能量+3並抽3張牌。下回合抽牌數為0。';

  @override
  String get cardNameTacR01Up => '完美計劃+';

  @override
  String get cardDescTacR01Up => '獲得能量+3並抽3張牌。下回合抽2張牌。';

  @override
  String get cardNameTacR02 => '命運之輪';

  @override
  String get cardDescTacR02 => '隨機效果1次：15傷害、15格擋、恢復15HP或能量+2之一。';

  @override
  String get cardNameTacR02Up => '命運之輪+';

  @override
  String get cardDescTacR02Up => '隨機效果2次：15傷害、15格擋、恢復15HP或能量+2之一。';

  @override
  String get cardNameTacR03 => '替身';

  @override
  String get cardDescTacR03 => '將本回合使用的所有牌放回手中。';

  @override
  String get cardNameTacR03Up => '替身+';

  @override
  String get cardDescTacR03Up => '將本回合使用的所有牌放回手中並獲得能量+2。';

  @override
  String get cardNameTacR04 => '貪婪之手';

  @override
  String get cardDescTacR04 => '造成6點傷害。擊殺時額外獲得1張牌獎勵。';

  @override
  String get cardNameTacR04Up => '貪婪之手+';

  @override
  String get cardDescTacR04Up => '造成10點傷害。擊殺時額外獲得1張牌獎勵。';

  @override
  String get cardNameTacR05 => '大混亂';

  @override
  String get cardDescTacR05 => '對所有敵人施加易傷+虛弱2回合和毒3。';

  @override
  String get cardNameTacR05Up => '大混亂+';

  @override
  String get cardDescTacR05Up => '對所有敵人施加易傷+虛弱3回合和毒3。';

  @override
  String get cardNameTacL01 => '時間主宰';

  @override
  String get cardDescTacL01 => '獲得2個額外回合（每回合能量2）。消耗。';

  @override
  String get cardNameTacL01Up => '時間主宰+';

  @override
  String get cardDescTacL01Up => '獲得2個額外回合（每回合能量3）。消耗。';

  @override
  String get cardNameTacL02 => '命運轉化';

  @override
  String get cardDescTacL02 => '本次戰鬥升級所有牌。消耗。';

  @override
  String get cardNameTacL02Up => '命運轉化+';

  @override
  String get cardDescTacL02Up => '本次戰鬥升級所有牌並獲得能量+2。消耗。';

  @override
  String get relicNameStart01 => '冒險者揹包';

  @override
  String get relicDescStart01 => '戰鬥獎勵卡牌選項+1張(3→4)';

  @override
  String get relicNameStart02 => '舊護符';

  @override
  String get relicDescStart02 => '開始時HP+15';

  @override
  String get relicNameStart03 => '幸運硬幣';

  @override
  String get relicDescStart03 => '戰鬥金幣+30%';

  @override
  String get relicNameC01 => '錨';

  @override
  String get relicDescC01 => '每回合開始時自動獲得防禦4';

  @override
  String get relicNameC02 => '紅色藥水';

  @override
  String get relicDescC02 => '戰鬥開始時恢復HP5';

  @override
  String get relicNameC03 => '魔法球';

  @override
  String get relicDescC03 => '每3回合能量+1';

  @override
  String get relicNameC04 => '鋒利磨刀石';

  @override
  String get relicDescC04 => '第一張攻擊卡傷害+3';

  @override
  String get relicNameC05 => '盜賊手套';

  @override
  String get relicDescC05 => '戰鬥獎勵金幣+15';

  @override
  String get relicNameC06 => '輕便鞋';

  @override
  String get relicDescC06 => '第一回合抽牌+2';

  @override
  String get relicNameC07 => '毒素袋';

  @override
  String get relicDescC07 => '戰鬥開始時對所有敵人施加毒素2';

  @override
  String get relicNameC08 => '荊棘盾';

  @override
  String get relicDescC08 => '荊棘1(永久)';

  @override
  String get relicNameC09 => '專注戒指';

  @override
  String get relicDescC09 => '使用費用為0的卡牌時獲得防禦2';

  @override
  String get relicNameC10 => '戰士手環';

  @override
  String get relicDescC10 => '手牌全為攻擊卡時能量+1';

  @override
  String get relicNameU01 => '霜之心臟';

  @override
  String get relicDescU01 => '使用攻擊卡時有20%機率施加虛弱1回合';

  @override
  String get relicNameU02 => '賢者之石';

  @override
  String get relicDescU02 => '魔法卡傷害+25%';

  @override
  String get relicNameU03 => '不死鳥羽毛';

  @override
  String get relicDescU03 => '死亡時以30%HP復活一次';

  @override
  String get relicNameU04 => '時之沙';

  @override
  String get relicDescU04 => '前3回合能量+1';

  @override
  String get relicNameU05 => '靈魂收割者';

  @override
  String get relicDescU05 => '擊殺敵人時恢復HP5';

  @override
  String get relicNameU06 => '魔法鏡';

  @override
  String get relicDescU06 => '反射第一個減益效果(一次)';

  @override
  String get relicNameU07 => '探險家地圖';

  @override
  String get relicDescU07 => '在地圖上顯示下一層全部節點';

  @override
  String get relicNameU08 => '鍊金術士揹包';

  @override
  String get relicDescU08 => '在商店免費移除一張卡牌';

  @override
  String get relicNameR01 => '龍鱗';

  @override
  String get relicDescR01 => '所有攻擊受到的傷害-1';

  @override
  String get relicNameR02 => '第三隻眼';

  @override
  String get relicDescR02 => '以精確數值顯示敵人意圖';

  @override
  String get relicNameR03 => '無限袋';

  @override
  String get relicDescR03 => '最大持牌數+1(手牌6張)';

  @override
  String get relicNameR04 => '覺醒法球';

  @override
  String get relicDescR04 => '能量上限+1(3→4)';

  @override
  String get relicNameR05 => '命運之線';

  @override
  String get relicDescR05 => '卡牌獎勵中稀有以上機率翻倍';

  @override
  String get relicNameB01 => '王冠';

  @override
  String get relicDescB01 => '能量上限+1，開始時獲得1張詛咒';

  @override
  String get relicNameB02 => '魔王之心';

  @override
  String get relicDescB02 => '所有卡牌傷害+5，受到傷害+5';

  @override
  String get relicNameB03 => '復活聖盃';

  @override
  String get relicDescB03 => '在休息節點完全恢復HP';

  @override
  String get relicNameB04 => '混沌球體';

  @override
  String get relicDescB04 => '每回合在手牌中生成1張隨機卡牌';

  @override
  String get relicNameB05 => '時間王冠';

  @override
  String get relicDescB05 => '第一回合額外再來一回合';

  @override
  String get achievementNameAc1 => '第一步';

  @override
  String get achievementDescAc1 => '完成1次任務';

  @override
  String get achievementNameAc2 => '勤勉證明';

  @override
  String get achievementDescAc2 => '完成10次任務';

  @override
  String get achievementNameAc3 => '達到5級';

  @override
  String get achievementDescAc3 => '脫離新手冒險者';

  @override
  String get achievementNameAc4 => '力量覺醒';

  @override
  String get achievementDescAc4 => '力量屬性達到10';

  @override
  String get achievementNameAc5 => '智慧之始';

  @override
  String get achievementDescAc5 => '智慧屬性達到10';

  @override
  String get achievementNameAc6 => '向頂峰進發';

  @override
  String get achievementDescAc6 => '達到20級';

  @override
  String get achievementNameAc7 => '技能探索者';

  @override
  String get achievementDescAc7 => '學習5個技能';

  @override
  String get achievementNameAc8 => '健康達人';

  @override
  String get achievementDescAc8 => '健康屬性達到50';

  @override
  String get achievementNameAc9 => '智慧大師';

  @override
  String get achievementDescAc9 => '智慧屬性達到50';

  @override
  String get achievementNameAc10 => '任務狂熱者';

  @override
  String get achievementDescAc10 => '完成500次任務';

  @override
  String get achievementNameAc11 => '持續實踐者';

  @override
  String get achievementDescAc11 => '完成50次任務';

  @override
  String get achievementNameAc12 => '習慣大師';

  @override
  String get achievementDescAc12 => '完成100次任務';

  @override
  String get achievementNameAc13 => '老練冒險者';

  @override
  String get achievementDescAc13 => '達到30級';

  @override
  String get achievementNameAc14 => '傳奇英雄';

  @override
  String get achievementDescAc14 => '達到50級';

  @override
  String get achievementNameAc15 => '肌肉之王';

  @override
  String get achievementDescAc15 => '力量屬性達到100';

  @override
  String get achievementNameAc16 => '技能大師';

  @override
  String get achievementDescAc16 => '學習12個技能';

  @override
  String get achievementNameAc17 => '全能專家';

  @override
  String get achievementDescAc17 => '學習20個技能';

  @override
  String get achievementNameAc18 => '初次狩獵';

  @override
  String get achievementDescAc18 => '擊殺1只怪物';

  @override
  String get achievementNameAc19 => '新手獵人';

  @override
  String get achievementDescAc19 => '擊殺10只怪物';

  @override
  String get achievementNameAc20 => '熟練戰士';

  @override
  String get achievementDescAc20 => '擊殺50只怪物';

  @override
  String get achievementNameAc21 => '屠殺者';

  @override
  String get achievementDescAc21 => '擊殺200只怪物';

  @override
  String get achievementNameAc22 => '傳奇探險家';

  @override
  String get achievementDescAc22 => '完成1000次任務';

  @override
  String get achievementNameAc23 => '達到10級';

  @override
  String get achievementDescAc23 => '擺脫新手標籤！';

  @override
  String get achievementNameAc24 => '魅力之星';

  @override
  String get achievementDescAc24 => '魅力屬性達到30';

  @override
  String get achievementNameAc25 => '魅力之王';

  @override
  String get achievementDescAc25 => '魅力屬性達到80';

  @override
  String get titleNameT0 => '嫩芽冒險者';

  @override
  String get titleDescT0 => '一切都是新的開始';

  @override
  String get titleNameT1 => '勤勉冒險者';

  @override
  String get titleDescT1 => '堅持不懈是美德';

  @override
  String get titleNameT2 => '熟練開拓者';

  @override
  String get titleDescT2 => '走自己道路的人';

  @override
  String get titleNameT3 => '力量狂熱者';

  @override
  String get titleDescT3 => '力量任務XP+5%';

  @override
  String get titleNameT4 => '志向賢者';

  @override
  String get titleDescT4 => '智慧任務XP+5%';

  @override
  String get titleNameT5 => '鋼鐵體力';

  @override
  String get titleDescT5 => '健康任務XP+5%';

  @override
  String get titleNameT6 => '萬人迷';

  @override
  String get titleDescT6 => '魅力任務XP+5%';

  @override
  String get titleNameT7 => '勤勉化身';

  @override
  String get titleDescT7 => '完成100次任務';

  @override
  String get titleNameT8 => '全能才子';

  @override
  String get titleDescT8 => '所有屬性達到20';

  @override
  String get titleNameT9 => '任務工匠';

  @override
  String get titleDescT9 => '完成250次任務';

  @override
  String get titleNameT10 => '向頂峰邁進';

  @override
  String get titleDescT10 => '達到30級';

  @override
  String get titleNameT11 => '傳奇勇士';

  @override
  String get titleDescT11 => '達到40級';

  @override
  String get titleNameT12 => '世界英雄';

  @override
  String get titleDescT12 => '達到50級';

  @override
  String get titleNameT13 => '破壞化身';

  @override
  String get titleDescT13 => '力量任務XP+10%';

  @override
  String get titleNameT14 => '大賢者';

  @override
  String get titleDescT14 => '智慧任務XP+10%';

  @override
  String get titleNameT15 => '不死戰士';

  @override
  String get titleDescT15 => '健康任務XP+10%';

  @override
  String get titleNameT16 => '絕對魅力';

  @override
  String get titleDescT16 => '魅力任務XP+10%';

  @override
  String get titleNameT17 => '任務傳奇';

  @override
  String get titleDescT17 => '完成500次任務';

  @override
  String get titleNameT18 => '任務之神';

  @override
  String get titleDescT18 => '完成1000次任務';

  @override
  String get titleNameT19 => '全能掌控者';

  @override
  String get titleDescT19 => '所有屬性達到50';

  @override
  String get titleNameT20 => '新手營員';

  @override
  String get titleDescT20 => '達到3級';

  @override
  String get titleNameT21 => '經驗豐富的旅者';

  @override
  String get titleDescT21 => '達到20級';

  @override
  String get titleNameT22 => '力量之巔';

  @override
  String get titleDescT22 => '力量達到100！';

  @override
  String get titleNameT23 => '智慧之巔';

  @override
  String get titleDescT23 => '智慧達到100！';

  @override
  String get titleNameT24 => '月間突襲突破者';

  @override
  String get titleDescT24 => '月間突襲通關1次';

  @override
  String get titleNameT25 => '月間突襲征服者';

  @override
  String get titleDescT25 => '月間突襲通關5次';

  @override
  String get titleNameT26 => '年間突襲生存者';

  @override
  String get titleDescT26 => '年間突襲通關1次';

  @override
  String get titleNameT27 => '年間突襲君主';

  @override
  String get titleDescT27 => '年間突襲通關3次';

  @override
  String get skillNameSk1 => '力量強化';

  @override
  String get skillDescSk1 => '力量任務XP+10%';

  @override
  String get skillNameSk2 => '智慧之光';

  @override
  String get skillDescSk2 => '智慧任務XP+10%';

  @override
  String get skillNameSk3 => '健康體魄';

  @override
  String get skillDescSk3 => '健康任務XP+10%';

  @override
  String get skillNameSk4 => '魅力散發';

  @override
  String get skillDescSk4 => '魅力任務XP+10%';

  @override
  String get skillNameSk5 => '任務專家';

  @override
  String get skillDescSk5 => '所有任務XP+5%';

  @override
  String get skillNameSk6 => '成長的喜悅';

  @override
  String get skillDescSk6 => '升級時額外獲得SP1';

  @override
  String get skillNameSk7 => '專注訓練';

  @override
  String get skillDescSk7 => '消耗SP1時屬性增加2';

  @override
  String get skillNameSk8 => '學習加速';

  @override
  String get skillDescSk8 => '所有任務XP+10%';

  @override
  String get skillNameSk9 => '超越成長';

  @override
  String get skillDescSk9 => '升級時基礎SP5→7';

  @override
  String get skillNameSk10 => '火焰劍擊';

  @override
  String get skillDescSk10 => '戰鬥使用：造成額外25傷害';

  @override
  String get skillNameSk11 => '治癒之光';

  @override
  String get skillDescSk11 => '戰鬥使用：恢復HP20';

  @override
  String get skillNameSk12 => '雷電一擊';

  @override
  String get skillDescSk12 => '戰鬥使用：造成50傷害';

  @override
  String get skillNameSk13 => '冰結魔法';

  @override
  String get skillDescSk13 => '戰鬥使用：造成35傷害';

  @override
  String get skillNameSk14 => '毒霧';

  @override
  String get skillDescSk14 => '戰鬥使用：造成30傷害';

  @override
  String get skillNameSk15 => '護盾';

  @override
  String get skillDescSk15 => '戰鬥使用：恢復HP40';

  @override
  String get skillNameSk16 => '大地震';

  @override
  String get skillDescSk16 => '戰鬥使用：造成70傷害';

  @override
  String get skillNameSk17 => '神聖祈禱';

  @override
  String get skillDescSk17 => '戰鬥使用：恢復HP60';

  @override
  String get skillNameSk18 => '戰鬥本能';

  @override
  String get skillDescSk18 => '力量任務XP+15%';

  @override
  String get skillNameSk19 => '冥想境界';

  @override
  String get skillDescSk19 => '智慧任務XP+15%';

  @override
  String get skillNameSk20 => '黑暗之劍';

  @override
  String get skillDescSk20 => '戰鬥使用：造成100傷害';

  @override
  String get skillNameSk21 => '完全再生';

  @override
  String get skillDescSk21 => '戰鬥使用：恢復HP80';

  @override
  String get skillNameSk22 => '極限效率';

  @override
  String get skillDescSk22 => '消耗SP1時屬性增加3';

  @override
  String get skillNameSk23 => '超越加速';

  @override
  String get skillDescSk23 => '所有任務XP+20%';

  @override
  String get skillNameSk24 => '神的祝福';

  @override
  String get skillDescSk24 => '升級時額外獲得SP3';

  @override
  String get monsterSlimeGreen => '綠色史萊姆';

  @override
  String get monsterBat => '洞穴蝙蝠';

  @override
  String get monsterMushroom => '毒蘑菇';

  @override
  String get monsterSlimeBlue => '藍色史萊姆';

  @override
  String get monsterRat => '巨鼠';

  @override
  String get monsterGoblin => '哥布林';

  @override
  String get monsterSkeleton => '骷髏戰士';

  @override
  String get monsterWolf => '暗影之狼';

  @override
  String get monsterSpiderGiant => '巨毒蜘蛛';

  @override
  String get monsterTreant => '行走之樹';

  @override
  String get monsterOrc => '獸人戰士';

  @override
  String get monsterDarkMage => '暗黑法師';

  @override
  String get monsterGolem => '石頭魔像';

  @override
  String get monsterHarpy => '鳥妖';

  @override
  String get monsterMimic => '擬態怪';

  @override
  String get monsterLavaGolem => '熔岩魔像';

  @override
  String get monsterFireSpirit => '火焰精靈';

  @override
  String get monsterDemonWarrior => '魔族戰士';

  @override
  String get monsterSalamander => '蠑螈';

  @override
  String get monsterCerberus => '地獄犬';

  @override
  String get monsterShadowKnight => '暗影騎士';

  @override
  String get monsterLich => '巫妖';

  @override
  String get monsterBehemoth => '龐然大物';

  @override
  String get monsterDarkPhoenix => '黑暗不死鳥';

  @override
  String get monsterVoidWorm => '虛空蠕蟲';

  @override
  String get monsterBossTroll => '山怪首領';

  @override
  String get monsterBossDragon => '火焰龍';

  @override
  String get monsterBossDemonLord => '魔王';

  @override
  String get monsterBossHydra => '九頭蛇';

  @override
  String get monsterBossFallenAngel => '墮天使';

  @override
  String get monsterBossDeathKnight => '死亡騎士';

  @override
  String get chapterName1 => '草原防線';

  @override
  String get chapterName2 => '黑暗森林';

  @override
  String get chapterName3 => '廢墟城堡';

  @override
  String get chapterName4 => '熔岩地牢';

  @override
  String get chapterName5 => '深淵次元';

  @override
  String get timerDuration15 => '15分鐘';

  @override
  String get timerDuration25 => '25分鐘';

  @override
  String get timerDuration45 => '45分鐘';

  @override
  String get timerDuration60 => '60分鐘';

  @override
  String get huntApRecovered => '⚡ AP恢復2點！';

  @override
  String huntSkillCooldownTurns(int turns) {
    return '$turns回合';
  }

  @override
  String settingsReauthFailed(String error) {
    return '重新驗證失敗: $error';
  }

  @override
  String get settingsReauthWrongPassword => '密碼不正確。';

  @override
  String get lqToday => '今天';

  @override
  String get lqGrowth => '成長';

  @override
  String get lqDungeon => '地下城';

  @override
  String get lqHeadline => '今天，再寫一頁。';

  @override
  String get lqSubtitle => '現實中的小小行動，開啟下一段故事。';

  @override
  String get lqSystem => '個人任務系統';

  @override
  String get lqDailyMissions => '今日推薦';

  @override
  String get lqActiveQuests => '進行中的任務';

  @override
  String get lqAllQuests => '檢視全部';

  @override
  String get lqCheckIn => '調整今日狀態';

  @override
  String get lqCheckInHint => '從現在能做到的開始。';

  @override
  String get lqEnergy => '今日精力';

  @override
  String get lqEnergyLow => '輕鬆一點';

  @override
  String get lqEnergyMedium => '適中';

  @override
  String get lqEnergyHigh => '很充足';

  @override
  String get lqTimeBudget => '今天留給自己的時間';

  @override
  String get lqMinutes => '分鐘';

  @override
  String get lqFocus => '想成長的領域';

  @override
  String get lqVitality => '活力';

  @override
  String get lqLearning => '學習';

  @override
  String get lqOrder => '整理';

  @override
  String get lqConnection => '關係';

  @override
  String get lqGoal => '最近想實現的事（可選）';

  @override
  String get lqGoalHint => '例如：下班後重新開始學英語';

  @override
  String get lqGoalPrivacy => '此筆記和個性化記錄儲存在本裝置。';

  @override
  String get lqApply => '調整今日任務';

  @override
  String get lqAccept => '接受';

  @override
  String get lqDone => '完成了';

  @override
  String get lqCompleted => '完成';

  @override
  String get lqTooHard => '今天太難了';

  @override
  String get lqSkip => '換一個';

  @override
  String get lqWhy => '推薦此任務的理由';

  @override
  String get lqDefaultReason => '已匹配你的興趣和可用時間。';

  @override
  String get lqRecoveryReason => '減少負擔，更容易重新開始。';

  @override
  String get lqAllSet => '今日計劃已定。';

  @override
  String get lqAllSetBody => '按自己的節奏完成已接受的任務。明天會有新推薦。';

  @override
  String get lqDirector => '你的任務AI';

  @override
  String get lqBasicMode => '基礎推薦';

  @override
  String get lqLocalAi => '裝置端AI';

  @override
  String get lqGenerate => 'AI個性化生成';

  @override
  String get lqGenerating => '正在生成你的任務…';

  @override
  String get lqModelName => 'Gemma 4 E2B · 免費開放模型';

  @override
  String get lqModelIntro => '安裝後可離線在本裝置生成任務。無需AI費用或訂閱。';

  @override
  String get lqModelDownloadInfo =>
      '模型大小 2.59 GB · 建議使用 Wi-Fi · 至少需有 3 GB 可用空間\n下載時請保持 App 開啟。支援續傳，使用行動網路可能產生電信費用。';

  @override
  String get lqDownload => '下載免費模型';

  @override
  String get lqCancel => '取消';

  @override
  String get lqRemoveModel => '刪除模型檔案';

  @override
  String get lqModelUnavailable => '此環境使用基礎推薦。AI需要記憶體充足的相容Android裝置。';

  @override
  String get lqModelRejected => '此次生成未透過驗證。保留現有推薦。';

  @override
  String get lqModelError => '未能完成。請檢查網路和儲存後重試。';

  @override
  String get lqLearningHistory => '個性化記錄';

  @override
  String get lqLearningHistoryBody =>
      '參考完成、跳過、難度和近期重複來調整後續任務內容與分量。裝置僅保留最近90天記錄。';

  @override
  String get lqClearLearning => '重置學習記錄';

  @override
  String get lqResetConfirm => '重置個性化記錄嗎？等級和已完成任務將保留。';

  @override
  String get lqStorageError => '儲存未完成。關閉應用前請檢查儲存空間。';

  @override
  String get lqEarnedToday => '今日任務經驗';

  @override
  String get lqStatusWindow => '我的狀態視窗';

  @override
  String get lqGrowthHint => '休息日也不會失去已積累的成長。';

  @override
  String get lqOpenGate => '檢驗成長的時刻';

  @override
  String get lqGateHint => '用現實行動積累的力量挑戰短暫的卡牌戰鬥。';

  @override
  String get lqEnterDungeon => '進入地下城';

  @override
  String get lqOptional => '可選冒險';

  @override
  String get lqSaved => '已儲存';

  @override
  String get lqReportSuggestion => '舉報不當推薦';

  @override
  String get lqReportBody => '將這項推薦的標題、行動、理由及目前的帳號識別碼傳送給開發者。不會附上目標筆記或學習紀錄。';

  @override
  String get lqSendReport => '傳送舉報';

  @override
  String get lqReportSent => '舉報已傳送。已隱藏此推薦。';

  @override
  String get lqReportPreview => 'QA舉報已儲存到本機，未傳送給開發者。';

  @override
  String get lqReportFailed => '無法確認舉報操作的結果。請檢查網路連線後重試。';

  @override
  String get lqCloudQuestNotice => '已接受的任務會透過帳號儲存到 Firebase。AI 生成僅在此裝置執行。';

  @override
  String get lqOpenSourceLicenses => '開源許可';

  @override
  String get lqWelcomeTitle => '開啟 App，\n看見自己的狀態視窗。';

  @override
  String get lqWelcomeBody => '選擇狀態視窗中的名字，以及最想成長的一個領域。接著看看今天就能開始的小任務。';

  @override
  String get lqWelcomePreviewNote => '這是初始狀態預覽。實際完成任務後，才會累積 XP 和成長紀錄。';

  @override
  String get lqWelcomeName => '狀態視窗顯示名稱';

  @override
  String get lqWelcomeNameHint => '輸入你的名字';

  @override
  String get lqWelcomeNamePlaceholder => '你的名字';

  @override
  String get lqWelcomeFocus => '先選一個成長領域';

  @override
  String get lqWelcomeGoal => '目前想達成的具體目標';

  @override
  String get lqWelcomeGoalHint => '例如：下班後閱讀 10 分鐘';

  @override
  String get lqWelcomeGoalQuickHint => '選擇領域後會自動填入起步目標，也可以自行修改。';

  @override
  String get lqWelcomeExampleVitality => '在日常留出舒服的休息';

  @override
  String get lqWelcomeExampleLearning => '理解並運用感興趣的主題';

  @override
  String get lqWelcomeExampleOrder => '讓書桌更好用';

  @override
  String get lqWelcomeExampleConnection => '以舒服的步調維持聯繫';

  @override
  String get lqWelcomeMinutes => '每天可用的時間';

  @override
  String get lqWelcomeSetupPrivacy =>
      '目標筆記與推薦紀錄會保留在此裝置。AI 模型可自由選擇是否安裝；只有完成任務才會獲得 XP。';

  @override
  String get lqFirstQuest => '第一個任務';

  @override
  String get lqFirstQuestAccept => '接受並開始任務';

  @override
  String get lqFirstQuestOpen => '查看進行中的任務';

  @override
  String get lqFirstQuestNote => '這是根據所選領域與時間提出的今日建議。';

  @override
  String get lqFirstQuestDefaultNote => '這是起步建議。設定目標後，就能獲得更適合的任務。';

  @override
  String get lqFirstQuestUnavailable => '正在準備今天的任務…';

  @override
  String get lqFirstContract => '狀態視窗已就緒';

  @override
  String get lqWelcomeStepOne => '接著才是任務';

  @override
  String get lqWelcomeStepOneBody => '完成小行動，累積 XP。';

  @override
  String get lqWelcomeStepTwo => 'AI 可自由選用';

  @override
  String get lqWelcomeStepTwoBody => '支援的裝置可另外安裝模型，在裝置內取得任務建議。';

  @override
  String get lqWelcomeStepThree => '查看成長紀錄';

  @override
  String get lqWelcomeStepThreeBody => '在成長紀錄查看已完成的任務與獲得的 XP。';

  @override
  String get lqStartOnDevice => '開啟我的狀態視窗';

  @override
  String get lqStarting => '正在開啟狀態視窗…';

  @override
  String get lqExistingAccount => '使用現有帳號繼續';

  @override
  String get lqDeviceStorageNotice => '不用註冊即可免費開始。紀錄只儲存在此裝置，解除安裝 App 後將會遺失。';

  @override
  String get lqGuestName => '記錄者';

  @override
  String get lqProfileLoadFailed => '無法載入記錄。已儲存的資料仍被保留，請重試。';

  @override
  String get lqRetry => '重試';

  @override
  String get lqBackToStart => '返回開始頁';

  @override
  String get lqLocalProfile => '裝置專屬檔案';

  @override
  String get lqDeleteLocal => '刪除裝置記錄';

  @override
  String get lqDeleteLocalBody => '刪除此裝置上的任務、成長和個性化歷史。此操作無法撤銷。';

  @override
  String get lqPurchasePending => '交易待確認；確認後將自動驗證購買權益。';

  @override
  String get lqPurchasePendingShort => '待確認';

  @override
  String get lqPurchaseVerifying => '正在驗證購買…';

  @override
  String get lqPurchaseGranted => '購買已驗證，內容現已可用。';

  @override
  String get lqPurchaseCancelled => '購買已取消。';

  @override
  String get lqPurchaseRetry => '購買驗證暫時延遲，請使用同一帳號重試「還原購買」。';

  @override
  String get lqPurchaseFailed => '無法開始購買，請稍後重試。';

  @override
  String get lqPurchaseRestoring => '正在恢復購買…';

  @override
  String get lqPurchaseRestoreFinished =>
      '已檢查 Google Play 購買紀錄，請確認使用的是購買時的 App 帳號。';

  @override
  String get lqRestorePurchases => '恢復購買';

  @override
  String get lqStoryLibrary => '交界書閣';

  @override
  String get lqStoryFreePrologue => '免費序章';

  @override
  String get lqStoryBannerTitle => '來自零號出口的訊號';

  @override
  String get lqStoryBannerBody => '今天的小小行動，開啟下一段故事。';

  @override
  String get lqStoryLibraryHeadline => '同樣的一天，\n不同世界的故事。';

  @override
  String get lqStoryLibraryHint => '選一本書放在“今天”。換書後，成長與選擇都會保留。';

  @override
  String get lqStoryProgress => '已完成的記錄';

  @override
  String get lqStoryLoadFailed => '無法載入故事，請退出此頁面後重試。';

  @override
  String get lqStoryFiction => '透過日常任務推進的虛構故事。';

  @override
  String get lqStoryNoDeadline => '沒有期限，也不要求連續登入。完成任務即可開啟下一份記錄。';

  @override
  String get lqStoryActionCount => '累計完成的任務：';

  @override
  String get lqStoryReadAgain => '重讀';

  @override
  String get lqStoryReadNow => '現在可以閱讀';

  @override
  String get lqStoryUnlockAfter => '還需完成：';

  @override
  String get lqStoryQuestUnit => '個任務';

  @override
  String get lqStoryReadPrevious => '請先完成前一份記錄。';

  @override
  String get lqStoryRecord => '記錄';

  @override
  String get lqStoryChoose => '你會如何回應？';

  @override
  String get lqStoryNext => '閱讀下一份記錄';

  @override
  String get lqStoryChapterComplete => '本章記錄已全部完成。你隨時可以重讀，嘗試不同的選擇。';

  @override
  String get lqStoryReturnLater => '再完成一些日常任務，即可開啟下一份記錄。已有的故事進度會一直保留。';

  @override
  String get lqStoryBackToChapter => '檢視本章記錄';

  @override
  String get lqStoryChooseAgain => '嘗試其他選擇';

  @override
  String get lqStorySaveFailed => '無法儲存選擇，請重試。';

  @override
  String get lqDeletionQueued => '已受理刪除請求。即使關閉應用，伺服器也會繼續處理。';

  @override
  String get lqBackupTitle => '備份與還原';

  @override
  String get lqBackupHeadline => '換一台裝置，繼續你的旅程。';

  @override
  String get lqBackupBody => '用自己設定的密碼加密記錄，儲存為檔案。備份免費，儲存位置由你選擇。';

  @override
  String get lqBackupExport => '建立備份檔案';

  @override
  String get lqBackupImport => '開啟備份檔案';

  @override
  String get lqBackupUndo => '回到還原前的紀錄';

  @override
  String get lqBackupIncluded => '備份內容';

  @override
  String get lqBackupIncludesBody =>
      '包含任務、成長、已通關地下城、故事選擇和個性化歷史。不包含進行中的探索、登入資訊、購買許可權或AI模型檔案。恢復後通知預設為關閉。';

  @override
  String get lqBackupPasswordNotice =>
      '如果忘記密碼，開發者也無法開啟備份。解除安裝應用不會刪除你儲存的備份，請在儲存位置自行刪除不再需要的檔案。';

  @override
  String get lqBackupSetPassword => '設定備份密碼';

  @override
  String get lqBackupEnterPassword => '輸入備份密碼';

  @override
  String get lqBackupPasswordHint =>
      '請使用 12–128 個字元。建議使用容易記住的長句。空格和字母大小寫都是密碼的一部分。';

  @override
  String get lqBackupPassword => '密碼';

  @override
  String get lqBackupRepeatPassword => '再次輸入密碼';

  @override
  String get lqBackupShowPassword => '顯示密碼';

  @override
  String get lqBackupHidePassword => '隱藏密碼';

  @override
  String get lqBackupPasswordMismatch => '兩次輸入的密碼不一致。';

  @override
  String get lqBackupUnlock => '檢視備份內容';

  @override
  String get lqBackupReview => '恢復這些記錄？';

  @override
  String get lqBackupReplaceBody =>
      '這將替換此裝置上的記錄。原記錄會保留在裝置中，方便撤回。登入與購買權益仍屬於原帳號。需要提醒時請重新開啟。';

  @override
  String get lqBackupRestore => '還原紀錄';

  @override
  String get lqBackupWorking => '正在處理記錄…';

  @override
  String get lqBackupSaved => '已儲存加密備份檔案。';

  @override
  String get lqBackupSaveFailed => '無法儲存備份，請檢查可用空間和儲存位置。';

  @override
  String get lqBackupInvalid => '無法開啟備份，請檢查檔案和密碼。記錄未被更改。';

  @override
  String get lqBackupRestored => '紀錄已還原，可在設定中重新開啟提醒。';

  @override
  String get lqBackupRestoreInterrupted => '還原尚未完成，請重新開啟 App 或重試。';

  @override
  String get lqDungeonIntro => '帶著日常積累的力量，開始冒險。';

  @override
  String get lqDungeonIntroBody => '使用卡牌，選擇路線。戰鬥失敗不會扣除日常等級和經驗值。';

  @override
  String get lqDungeonStart => '開始探索';

  @override
  String get lqDungeonResume => '繼續目前探索';

  @override
  String get lqDungeonBonus => '日常積累的加成';

  @override
  String get lqDungeonBonusBody => '完成的任務與裝備會為下次探索提供加成。沒有加成也能立即開始。';

  @override
  String get lqDungeonPacks => '卡包';

  @override
  String get lqDungeonPathHint => '選擇下方發光的地點開始。';

  @override
  String get lqDungeonNextHint => '選擇相連的下一地點繼續。';

  @override
  String get lqDungeonCurrent => '目前位置';

  @override
  String get lqDungeonAvailable => '可選擇';

  @override
  String get lqDungeonLocked => '未解鎖';

  @override
  String get lqDungeonDone => '已完成';

  @override
  String get lqDungeonEntering => '正在進入…';

  @override
  String get lqDungeonCombat => '戰鬥';

  @override
  String get lqDungeonElite => '精英戰';

  @override
  String get lqDungeonEvent => '事件';

  @override
  String get lqDungeonShop => '商店';

  @override
  String get lqDungeonRest => '休息';

  @override
  String get lqDungeonBoss => '首領';

  @override
  String get lqBattleGuideTitle => '首次戰鬥指引';

  @override
  String get lqBattleGuideEnergy => 'EP是每回合的能量。使用卡牌會消耗其左上角所示的點數。';

  @override
  String get lqBattleGuideCards => '敵人不止一個時，先選目標再用卡。攻擊造成傷害，防禦抵擋敵方傷害。';

  @override
  String get lqBattleGuideTurn => '行動結束後點選“結束回合”。敵方行動後會補充能量和手牌。';

  @override
  String get lqBattleBegin => '開始戰鬥';

  @override
  String get lqBattleExit => '離開戰鬥';

  @override
  String lqDungeonNode(String type, int step, int path, String state) {
    return '$type，第$step層，路線$path，$state';
  }

  @override
  String get lqDungeonCheckpointHint => '進入或離開房間時儲存。關閉應用後，未完成的房間會從入口重新開始。';

  @override
  String get lqDungeonSaveFailed => '無法儲存進度。請檢查裝置儲存空間後重試。';

  @override
  String get lqDungeonCollectResult => '領取探索結果';

  @override
  String get lqPurchaseAccount => '購買用帳號';

  @override
  String get lqPurchaseAccountOptional => '需要時再連結帳號';

  @override
  String get lqPurchaseAccountPrivacy =>
      'Google 帳號只用於驗證與還原購買。任務、成長紀錄及 AI 個人化紀錄仍儲存在此裝置。登入不會購買商品或扣款。';

  @override
  String get lqPurchaseAccountRestoreHint =>
      '在其他裝置還原購買時，請使用購買時的 Google Play 帳號及 App 購買帳號。成長紀錄可另外透過加密備份轉移。';

  @override
  String get lqPurchaseAccountConnected => '已連結購買帳號';

  @override
  String get lqPurchaseAccountConnect => '連結 Google 帳號';

  @override
  String get lqPurchaseCloudLinkIntro =>
      '購買前，請將 Google 帳號連結至目前的個人檔案。任務與成長紀錄會保留在同一份檔案中。僅連結帳號不會收費。';

  @override
  String get lqPurchaseCloudLinkFailed =>
      '無法連結這個 Google 帳號。它可能已連結至其他 Life Quest 帳號。請改用另一個 Google 帳號重試；目前的電子郵件個人檔案不會受到影響。';

  @override
  String get lqPurchaseCloudLinked => 'Google 帳號已連結至目前的個人檔案。可使用這份檔案購買及還原商品。';

  @override
  String get lqPurchaseAccountDisconnect => '解除此裝置的帳號連結';

  @override
  String get lqPurchaseAccountDelete => '刪除購買帳號';

  @override
  String get lqPurchaseAccountDeleteBody =>
      '將刪除此帳號的購買權益、檢舉及現有的雲端個人資料。刪除後無法還原購買，也不會自動退款。此裝置上的任務與成長紀錄會保留。請再次驗證 Google 帳號以申請刪除。';

  @override
  String get lqPurchaseAccountFailed => '無法完成操作。請檢查網路連線及帳號後重試。';

  @override
  String get lqPurchaseAccountDeleted => '已收到刪除申請。伺服器會繼續刪除帳號資料，此裝置上的成長紀錄會保留。';

  @override
  String get lqPurchaseAccountCleanup =>
      '刪除申請已受理。請再次點選斷開連線，完成此裝置上的退出操作。伺服器端刪除將繼續。';

  @override
  String get lqReportCopyReceipt => '複製回執編號';

  @override
  String get lqReportRetention =>
      '舉報內容在提交90天后進入自動刪除流程。實際刪除可能需要額外處理時間。也可在設定中的 AI 舉報回執頁面刪除。';

  @override
  String get lqReportReceipts => 'AI 舉報回執';

  @override
  String get lqReportReceiptHelp =>
      '此裝置最多儲存最近100個回執編號。連線同一舉報帳號時，可在此刪除。若帳號已更換或無法開啟應用，請複製回執編號並向 logian621@gmail.com 申請刪除。';

  @override
  String get lqReportReceiptsEmpty => '此裝置沒有儲存回執編號。';

  @override
  String get lqReportDelete => '刪除舉報';

  @override
  String get lqReportDeleteBody => '刪除伺服器上的舉報及本地回執。此裝置上的日常任務和成長記錄將保留。';

  @override
  String get lqReportDeleted => '舉報已刪除。';

  @override
  String get lqReportDeleteIdentity => '刪除匿名檢舉帳號';

  @override
  String get lqReportDeleteIdentityBody =>
      '申請刪除此裝置目前的匿名舉報帳號及其提交的所有舉報。裝置上的成長記錄將保留。之後再次舉報時會建立新的匿名帳號。';

  @override
  String get lqReportIdentityDeleted => '刪除申請已受理。即使關閉應用，伺服器仍會繼續處理。';

  @override
  String get lqWorldCurrent => '今天的故事';

  @override
  String get lqWorldChoose => '今天想走進哪個世界？';

  @override
  String get lqWorldChooseHint => '城市·修習·探索，三篇免費故事。';

  @override
  String get lqWorldChange => '換一本書';

  @override
  String get lqWorldSelect => '從這本書開始';

  @override
  String get lqWorldContinue => '繼續今天的書';

  @override
  String get lqWorldSaving => '正在儲存書籤…';

  @override
  String get lqWorldFreeCollection => '三篇故事均免費·沒有期限';

  @override
  String get lqWorldCollectionPromise => '基礎任務、AI和記錄免費。本書閣的三篇故事無需購買。';

  @override
  String lqActionsRecorded(int count) {
    return '已完成 $count 個現實任務';
  }

  @override
  String lqStoryActionsRemaining(int count) {
    return '再完成 $count 個任務即可開啟下一幕';
  }

  @override
  String get lqDeletionUncertain =>
      '無法確認刪除請求是否已受理。此帳號的同步已停止。請完成裝置斷開連線後，重新登入確認。';

  @override
  String get lqDeletionCheckFailed => '無法讀取本機帳號狀態。為保護記錄，尚未開始同步。';

  @override
  String get lqDeletionLocalFinished => '此裝置已斷開連線。';

  @override
  String get lqDeletionLocalHint => '僅清除此帳號在本機剩餘的快取和登入連線。獨立的本機檔案及其他帳號記錄會保留。';

  @override
  String get lqDeletionFinishLocal => '完成斷開本機連線';

  @override
  String get lqDeletionLocalRetry => '本機清理未完成，請重試。此帳號的同步仍處於停止狀態。';

  @override
  String get lqPackCollection => '完整故事包';

  @override
  String get lqPackContents => '12個場景、隨選擇變化的兩種結局、海色主題和紙船印記。一次購買，無使用期限。';

  @override
  String get lqPackPreview => '前兩個場景免費體驗';

  @override
  String get lqPackLocked => '購買故事包後可解鎖此場景。';

  @override
  String get lqPackUnavailable => '此版本暫不銷售。您仍可閱讀免費體驗內容。';

  @override
  String lqPackBuy(String price) {
    return '購買完整故事包 · $price';
  }

  @override
  String get lqPackOwned => '已購買的故事包';

  @override
  String get lqPackThemeApply => '套用海色主題';

  @override
  String get lqPackThemeRemove => '恢復預設主題';

  @override
  String get lqPackThemeHint => '主題和印記不會改變經驗、屬性或任務推薦。';

  @override
  String get lqPackMark => '潮汐郵局 · 紙船印記';

  @override
  String get lqPackMarkHint => '完成最後一個場景後，印記將顯示在成長頁面。';

  @override
  String get lqPackEndingHint => '前十一次選擇中更常採用的方式決定結局。您可以重讀並更改選擇。';

  @override
  String get lqPackPacing => '從第三個場景起，每完成兩次現實行動即可繼續，累計20次解鎖最終場景。購買不會跳過行動條件。';

  @override
  String get lqPackPreviewEnd => '免費體驗到此結束。返回章節可檢視故事包內容與銷售狀態。';

  @override
  String get lqPackStoreUnavailable => '請連線Google Play以檢視商品資訊。';

  @override
  String get lqDeviceQuestNotice => '已接受的任務和個性化記錄儲存在本裝置。連線Google購買帳號也不會上傳進度。';

  @override
  String get lqStudyTitle => '14天使用體驗測試';

  @override
  String get lqStudyIntro => '自願參與 · 僅儲存在本裝置';

  @override
  String get lqStudyConsent =>
      '參與後，14天內記錄每日訪問、任務完成數量、故事體驗完成情況及自選評價，並生成隨機參與碼。不包含姓名、目標、任務內容或Google帳號。不會自動傳送；只有您主動分享檔案，開發者才會收到。可隨時刪除測試記錄，不影響應用使用。每天按參與時刻起的24小時計算。';

  @override
  String get lqStudyStart => '我已瞭解並自願參與';

  @override
  String get lqStudySummary => '記錄天數 / 完成數量';

  @override
  String get lqStudyValue => '讀完免費體驗後的吸引力（1–5）';

  @override
  String get lqStudyPrice => '願意為此故事包支付的最高金額';

  @override
  String get lqStudyPriceNote => '這是價格調查，並非購買或預訂。目前尚未銷售，可以修改答案。';

  @override
  String get lqStudyUndecided => '還不確定';

  @override
  String get lqStudyNoPurchase => '我不會購買';

  @override
  String get lqStudyPreviewFirst => '讀完《潮汐郵局》的兩個免費場景並完成選擇後即可評價。';

  @override
  String get lqStudySave => '儲存評價';

  @override
  String get lqStudyExport => '儲存結果檔案';

  @override
  String get lqStudyExportNote =>
      '檔案包含下方參與碼、每日完成數量、體驗狀態、評價及記錄異常標記，不證明現實行為或實際購買。儲存後僅在自願時自行分享。';

  @override
  String get lqStudyWithdraw => '退出並刪除測試記錄';

  @override
  String get lqStudyWithdrawNote => '只刪除本裝置的測試記錄，任務與故事進度保留。已分享的檔案不會被刪除。';

  @override
  String get lqStudySaved => '已儲存。';

  @override
  String get lqStudyError => '無法讀取或儲存記錄，已有記錄已保留。可重試或刪除測試記錄。';

  @override
  String get lqStudyFlagged => '檢測到記錄變化或儲存問題，此報告將不計入留存分析。不影響繼續使用應用。';

  @override
  String get lqStudyWebPreview => '網頁預覽資料不會列入真實使用者驗證。';

  @override
  String get lqFeedbackTitle => '意見回饋與協助';

  @override
  String get lqFeedbackDescription => '告訴我們遇到的問題或期待的功能。不會自動附加你的記錄。';

  @override
  String get lqReportManualDescription =>
      '此預覽版不會在應用內傳送舉報。請檢查下面的建議，需要時複製並透過支援頁面的電子郵件傳送。傳送前請刪除個人資訊。開啟支援頁面不會傳送這些內容。';

  @override
  String get lqReportCopySuggestion => '複製建議';

  @override
  String get lqReportManualCopied => '建議已複製，尚未傳送。';
}
