// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get close => '閉じる';

  @override
  String get confirm => '確認';

  @override
  String get delete => '削除';

  @override
  String get apply => '適用';

  @override
  String get change => '変更';

  @override
  String get complete => '完了';

  @override
  String get acquire => '習得';

  @override
  String get tabStatus => 'ステータス';

  @override
  String get tabQuests => 'クエスト';

  @override
  String get tabHunt => 'ハント';

  @override
  String get tabInventory => 'インベントリ';

  @override
  String get tabShop => 'ショップ';

  @override
  String get tabAchievement => '実績';

  @override
  String get tabSkill => 'スキル';

  @override
  String get loginTitle => '日々の行動を経験値に変えよう';

  @override
  String get loginSubtitle => '小さなクエストを積み重ね、キャラクターと一日を共に成長させる生産性RPG';

  @override
  String get loginEmailLabel => 'メール';

  @override
  String get loginPasswordLabel => 'パスワード';

  @override
  String get loginButton => 'ログイン';

  @override
  String get loginRegisterButton => '新しい冒険者登録';

  @override
  String get loginDivider => 'または';

  @override
  String get loginGoogleButton => 'Googleで始める';

  @override
  String get loginErrorEmpty => 'メールとパスワードを入力してください。';

  @override
  String get loginErrorFailed => 'ログインに失敗しました。';

  @override
  String get loginErrorGoogleToken => 'Google認証トークンを取得できません。再試行してください。';

  @override
  String get loginErrorGoogle => 'Googleサインインに失敗しました。';

  @override
  String loginErrorUnknown(String error) {
    return 'エラーが発生しました: $error';
  }

  @override
  String get signupTitle => '新しい冒険者登録';

  @override
  String get signupPickPhoto => 'プロフィール写真を選択';

  @override
  String get signupEmailLabel => 'メール';

  @override
  String get signupEmailRequired => 'メールを入力してください。';

  @override
  String get signupEmailInvalid => '有効なメール形式を入力してください。(例: name@example.com)';

  @override
  String get signupNicknameLabel => 'ニックネーム';

  @override
  String get signupNicknameRequired => 'ニックネームを入力してください。';

  @override
  String get signupPasswordLabel => 'パスワード';

  @override
  String get signupPasswordTooShort => 'パスワードは6文字以上にしてください。';

  @override
  String get signupPasswordConfirmLabel => 'パスワード確認';

  @override
  String get signupPasswordMismatch => 'パスワードが一致しません。';

  @override
  String get signupButton => '登録完了';

  @override
  String get signupSuccess => '🎉 登録成功！ようこそ！';

  @override
  String get signupErrorFailed => '登録に失敗しました。';

  @override
  String signupErrorUnknown(String error) {
    return '不明なエラーが発生しました: $error';
  }

  @override
  String get signupErrorUserCreate => 'ユーザーの作成に失敗しました。';

  @override
  String get statusScreenTitle => 'ステータス';

  @override
  String get statusTimerTooltip => '集中タイマー';

  @override
  String get statusSettingsTooltip => '設定';

  @override
  String get statusHpLabel => 'HP';

  @override
  String get statusHpRecoveryHint => '非戦闘中は10分ごとにHPが少しずつ自然回復します。';

  @override
  String statusStreakLabel(int days) {
    return '連続達成: $days日';
  }

  @override
  String statusStreakBonus(int percent) {
    return 'XP +$percent%';
  }

  @override
  String get statusStatHint =>
      'レベルアップ時、3ポイントは最近完了したクエストの傾向に応じて自動成長し、残りのポイントのみ自分で割り振れます。';

  @override
  String get statusGoldLabel => 'ゴールド';

  @override
  String get statusApLabel => '行動力';

  @override
  String get statusBaseStatTitle => '基本ステータス';

  @override
  String get statusDetailStatButton => '詳細ステータスを見る';

  @override
  String get statusDetailStatTitle => '📊 詳細戦闘ステータス';

  @override
  String get statusAttackLabel => '攻撃力';

  @override
  String get statusDefenseLabel => '防御力';

  @override
  String get statusCritLabel => 'クリティカル率';

  @override
  String get statusDodgeLabel => '回避率';

  @override
  String get statusStatStrength => '力';

  @override
  String get statusStatWisdom => '知恵';

  @override
  String get statusStatHealth => '健康';

  @override
  String get statusStatCharm => '魅力';

  @override
  String get statusTitleChangeTitle => '称号変更';

  @override
  String get statusStatApplyTitle => 'ステータス適用確認';

  @override
  String statusStatApplyBody(String summary) {
    return '以下のステータスを適用しますか？\n\n$summary\n\n適用後は元に戻せません。';
  }

  @override
  String get questsScreenTitle => 'クエスト一覧';

  @override
  String get questsTabDaily => 'デイリークエスト';

  @override
  String get questsTabWeekly => 'ウィークリークエスト';

  @override
  String get questsTabMonthly => 'マンスリーレイド';

  @override
  String get questsTabYearly => '年間レイド';

  @override
  String get questsEmptyDaily => 'クエストがまだありません。\n今日やることを気軽に追加してみましょう。';

  @override
  String get questsEmptyWeekly => '週間ルーティン目標がまだありません。\n継続したい目標を入れてみましょう。';

  @override
  String get questsEmptyMonthly => '今月のレイドがまだありません。\n長期目標を月間レイドとして登録しましょう。';

  @override
  String get questsEmptyYearly =>
      '今年の大型レイドがまだありません。\n人生目標レベルの挑戦を年間レイドとして追加しましょう。';

  @override
  String get questsCategoryStrength => '力';

  @override
  String get questsCategoryWisdom => '知恵';

  @override
  String get questsCategoryHealth => '健康';

  @override
  String get questsCategoryCharm => '魅力';

  @override
  String get questsDifficultyEasy => 'やさしい';

  @override
  String get questsDifficultyNormal => 'ふつう';

  @override
  String get questsDifficultyHard => 'むずかしい';

  @override
  String get questsDifficultyVeryHard => 'とても難しい';

  @override
  String get questsTypeDaily => 'デイリー';

  @override
  String get questsTypeWeekly => 'ウィークリー';

  @override
  String get questsTypeMonthly => 'マンスリーレイド';

  @override
  String get questsTypeYearly => '年間レイド';

  @override
  String get questsCompleteTitle => 'クエスト完了';

  @override
  String questsCompleteConfirm(String questName) {
    return '「$questName」を完了しますか？';
  }

  @override
  String get questsBaseRewardLabel => '基本報酬';

  @override
  String questsDoubleAdButton(int remaining) {
    return '広告を見て2倍報酬 (残り$remaining回)';
  }

  @override
  String get questsAdUnavailable => '広告を読み込めません。基本報酬が付与されます。';

  @override
  String get questsEditTitle => 'クエスト編集';

  @override
  String get questsAddTitle => '新しいクエスト追加';

  @override
  String get questsNameLabel => 'クエスト名';

  @override
  String get questsTypeLabel => '種類';

  @override
  String get questsCategoryLabel => 'カテゴリ';

  @override
  String get questsDifficultyLabel => '難易度';

  @override
  String questsRewardPreview(String type, int xp, int gold) {
    return '$type報酬: $xp XP · $gold ゴールド';
  }

  @override
  String get questsNameRequired => 'クエスト名を入力してください。';

  @override
  String get questsDeleteTitle => 'クエスト削除';

  @override
  String questsDeleteBody(String questName) {
    return '「$questName」を削除しますか？\n\n削除されたクエストは復元できません。';
  }

  @override
  String questsRaidClear(int count) {
    return 'レイドクリア $count回達成';
  }

  @override
  String get questsRaidBonusMonthly =>
      'レイドボーナス\n追加XP・追加ゴールド\nAP +2・SP +1\n進行報酬解放';

  @override
  String get questsRaidBonusYearly =>
      'レイドボーナス\n大量XP・大量ゴールド\nAP +4・SP +2\nレア報酬解放';

  @override
  String get huntScreenTitle => '狩猟場';

  @override
  String get huntMyHpLabel => '自分のHP';

  @override
  String huntComboBadge(int count) {
    return '💥 コンボ: $count';
  }

  @override
  String huntApBadge(int ap) {
    return '⚡ AP: $ap';
  }

  @override
  String get huntActionAttack => '攻撃 (1 AP)';

  @override
  String get huntActionDefend => '防御 (1 AP)';

  @override
  String get huntActionSkill => 'スキル (自由)';

  @override
  String get huntActionBag => 'バッグ (1 AP)';

  @override
  String get huntActionFlee => '逃げる (1 AP)';

  @override
  String get huntBagTitle => 'バッグ (消耗品)';

  @override
  String get huntBagEmpty => '使用できるアイテムがありません。';

  @override
  String get huntBagUse => '使用 (1 AP)';

  @override
  String get huntSkillSelectTitle => '使用するスキルを選択:';

  @override
  String get huntSkillEmpty => '覚えた戦闘スキルがありません。';

  @override
  String get huntApLowTitle => 'AP不足';

  @override
  String huntApLowBody(int remaining) {
    return 'APが不足しています。広告を見てAP 2を回復しますか？\n(今日の残り: $remaining回)';
  }

  @override
  String get huntApRecoverButton => '広告を見て回復';

  @override
  String get huntApExhausted => '⚡ AP不足！クエストを完了してください。(今日の広告回復はすべて消費済み)';

  @override
  String huntDoubleRewardButton(int remaining) {
    return '広告を見て報酬2倍 (残り$remaining回)';
  }

  @override
  String get huntDoubleRewardSuccess => '🎉 広告報酬で戦利品を2倍獲得しました！';

  @override
  String get huntAdUnavailable => '広告を読み込めません。再試行してください。';

  @override
  String get huntResultButton => '結果確認 & 戻る';

  @override
  String huntReviveButton(int remaining) {
    return '広告を見て復活 (今日残り$remaining回)';
  }

  @override
  String get huntReviveSuccess => '❤️ 広告報酬で即時復活しました！';

  @override
  String get huntReviveAdUnavailable => '広告を読み込めません。しばらくしてから再試行してください。';

  @override
  String get huntRetreatButton => 'あきらめて戻る';

  @override
  String get inventoryScreenTitle => 'インベントリ';

  @override
  String get inventoryEquippedSection => '装備中';

  @override
  String get inventoryCombatStatSection => '戦闘ステータス';

  @override
  String inventoryItemsSection(int count) {
    return '所持アイテム ($count)';
  }

  @override
  String get inventorySlotWeapon => '⚔️ 武器';

  @override
  String get inventorySlotArmor => '🛡️ 防具';

  @override
  String get inventorySlotAccessory => '💍 アクセサリー';

  @override
  String get inventorySlotEmpty => '空き';

  @override
  String get inventoryUnequip => '外す';

  @override
  String get inventoryUseEquip => '使用 / 装備';

  @override
  String get inventoryEmptyMessage => 'アイテムがありません\nモンスターを狩って装備を入手しましょう！';

  @override
  String get inventoryAttackLabel => '攻撃力';

  @override
  String get inventoryDefenseLabel => '防御力';

  @override
  String get inventoryHpLabel => '体力';

  @override
  String get inventoryStatStrength => '力';

  @override
  String get inventoryStatWisdom => '知恵';

  @override
  String get inventoryStatHealth => '健康';

  @override
  String get inventoryStatCharm => '魅力';

  @override
  String get inventoryStatAttack => '攻撃力';

  @override
  String get inventoryStatDefense => '防御力';

  @override
  String inventoryUsedHp(String itemName) {
    return '$itemNameを使用しました。(HP回復)';
  }

  @override
  String inventoryUsedAp(String itemName) {
    return '$itemNameを使用しました。(AP回復)';
  }

  @override
  String get inventoryRarityCommon => 'コモン';

  @override
  String get inventoryRarityUncommon => 'アンコモン';

  @override
  String get inventoryRarityRare => 'レア';

  @override
  String get inventoryRarityEpic => 'エピック';

  @override
  String get inventoryRarityLegendary => 'レジェンダリー';

  @override
  String get shopScreenTitle => 'ショップ';

  @override
  String get shopTabGameItems => 'ゲームアイテム';

  @override
  String get shopTabCustomRewards => 'マイ報酬';

  @override
  String get shopThemeBannerTitle => 'テーマショーケース';

  @override
  String get shopThemeBannerSubtitle => '準備中のテーマとエフェクトをプレビューしましょう。';

  @override
  String get shopConsumableSection => '消耗品';

  @override
  String get shopEquipBoxSection => '装備ボックス';

  @override
  String get shopPermanentSection => '永久強化';

  @override
  String get shopHpPotionName => 'HP回復ポーション';

  @override
  String get shopHpPotionDesc => 'HPを30回復します。';

  @override
  String get shopHpFullPotionName => 'HP完全回復ポーション';

  @override
  String get shopHpFullPotionDesc => 'HPを最大値まで回復します。';

  @override
  String get shopApPotionName => 'APチャージポーション';

  @override
  String get shopApPotionDesc => 'APを5回復します。';

  @override
  String get shopNormalBoxName => '通常装備ボックス';

  @override
  String get shopNormalBoxDesc => 'コモン～レア装備をランダム入手します。';

  @override
  String get shopNormalBoxSuccess => '装備を入手しました！インベントリを確認してください！';

  @override
  String get shopPremiumBoxName => 'プレミアム装備ボックス';

  @override
  String get shopPremiumBoxDesc => 'レア～レジェンダリー装備をランダム入手します。';

  @override
  String get shopPremiumBoxSuccess => 'プレミアム装備を入手しました！インベントリを確認してください！';

  @override
  String get shopMaxHpName => '最大HP +10';

  @override
  String get shopMaxHpDesc => '最大HPを永続的に10増加させます。';

  @override
  String get shopMaxHpSuccess => '最大HPが10増加しました！';

  @override
  String get shopMaxApName => '最大AP +2';

  @override
  String get shopMaxApDesc => '最大APを永続的に2増加させます。';

  @override
  String get shopMaxApSuccess => '最大APが2増加しました！';

  @override
  String get shopCustomRewardAddTitle => 'カスタム報酬追加';

  @override
  String get shopCustomRewardNameLabel => '報酬名 (例: Netflix 1時間)';

  @override
  String get shopCustomRewardDescLabel => '説明';

  @override
  String get shopCustomRewardDescHint => 'この報酬を楽しんでください！';

  @override
  String get shopCustomRewardCostLabel => '必要ゴールド';

  @override
  String get shopCustomRewardIconLabel => 'アイコン (絵文字)';

  @override
  String get shopCustomRewardAddButton => '報酬追加';

  @override
  String shopCustomRewardDeleted(String name) {
    return '$nameが削除されました';
  }

  @override
  String get shopAdSupportTitle => '選択型広告でアプリを運営しています';

  @override
  String get shopAdSupportDesc => '広告はクエスト報酬2倍、AP回復、戦闘復活など追加報酬が必要なときのみ表示されます。';

  @override
  String get shopAdModelTitle => '広告支援型運営';

  @override
  String get shopAdModelDesc => '現在のバージョンはアプリ内課金より広告収益を重視しています。有料商品は後で検討されます。';

  @override
  String get achievementScreenTitle => '実績';

  @override
  String get achievementTabInProgress => '進行中';

  @override
  String get achievementTabCompleted => '完了';

  @override
  String get achievementEmptyInProgress => 'すべての実績を達成したか、新しい挑戦を待っています！';

  @override
  String get achievementEmptyCompleted => 'まだ完了した実績がありません。';

  @override
  String achievementRewardXp(int xp) {
    return '報酬: $xp XP';
  }

  @override
  String achievementRewardSp(int sp) {
    return '報酬: $sp SP';
  }

  @override
  String get skillScreenTitle => 'スキル';

  @override
  String skillRequiredLevel(int level) {
    return '必要条件: Lv.$level';
  }

  @override
  String get settingsScreenTitle => '設定';

  @override
  String get settingsAccountSection => 'アカウント';

  @override
  String get settingsNicknameLabel => 'ニックネーム';

  @override
  String get settingsNicknameChangeTitle => 'ニックネーム変更';

  @override
  String get settingsNicknameNewLabel => '新しいニックネーム';

  @override
  String get settingsAppSection => 'アプリ設定';

  @override
  String get settingsDarkMode => 'ダークモード';

  @override
  String get settingsDarkModeSubtitle => 'アプリのテーマを変更します。';

  @override
  String get settingsSfx => 'サウンドエフェクト (SFX)';

  @override
  String get settingsSfxSubtitle => 'ゲームのサウンドエフェクトを切り替えます。';

  @override
  String get settingsNotification => '通知設定';

  @override
  String get settingsNotificationSubtitle => '毎朝9時にクエストリマインダーを受け取ります。';

  @override
  String get settingsNotificationEnabled => '毎日朝9時、夜8時に通知が予約されました。';

  @override
  String get settingsNotificationDisabled => 'すべての通知がキャンセルされました。';

  @override
  String get settingsAdSupportSection => '広告支援のご案内';

  @override
  String get settingsAdSupportTitle => '選択型広告でアプリを運営しています';

  @override
  String get settingsAdSupportDesc =>
      '広告はクエスト報酬2倍、AP回復、戦闘復活など追加報酬が必要なときのみ表示されます。';

  @override
  String get settingsAdModelTitle => '広告支援型運営';

  @override
  String get settingsAdModelDesc => '現在のバージョンはアプリ内課金より広告収益を重視しています。';

  @override
  String get settingsLogout => 'ログアウト';

  @override
  String get settingsWithdraw => 'アカウント削除';

  @override
  String get settingsWithdrawTitle => 'アカウント削除';

  @override
  String get settingsWithdrawBody =>
      '本当に退会しますか？\nすべてのデータが永久に削除され、この操作は元に戻せません。';

  @override
  String get settingsWithdrawConfirm => '削除確認';

  @override
  String get loadingSync => 'ハンター情報を同期中';

  @override
  String get loadingSyncDesc => '今日のクエストと成長記録を読み込んでいます';

  @override
  String get loadingGate => 'ゲートを開いています';

  @override
  String get loadingGateDesc => 'システムを初期化しています';

  @override
  String get loadingTagline => 'ARISE YOUR QUEST';

  @override
  String get timerScreenFocus => '🍅 集中タイマー';

  @override
  String get timerScreenBreak => '☕ 休憩タイマー';

  @override
  String get timerFocusMode => '集中モード';

  @override
  String get timerBreakMode => '休憩モード';

  @override
  String timerSessionCount(int count) {
    return 'セッション $count 完了';
  }

  @override
  String get timerFocusCompleteTitle => '🎉 集中完了！';

  @override
  String timerFocusCompleteBody(int minutes) {
    return '$minutes分集中セッション完了！';
  }

  @override
  String get timerGoldRewardLabel => 'ゴールド +';

  @override
  String timerTodaySessions(int count) {
    return '今日: $count セッション';
  }

  @override
  String get timerStartBreak => '休憩開始';

  @override
  String get timerFocusRewardLabel => '集中完了報酬:';

  @override
  String get cosmeticShopTitle => 'テーマショーケース';

  @override
  String get cosmeticCategoryTheme => 'アプリテーマ';

  @override
  String get cosmeticCategoryTitleEffect => '称号エフェクト';

  @override
  String get cosmeticCategoryCombatEffect => '戦闘エフェクト';

  @override
  String get cosmeticComingSoonTitle => 'プレミアムカスタマイズ機能は準備中です';

  @override
  String get cosmeticComingSoonDesc =>
      '現在は広告支援型運営に集中しています。テーマとエフェクト商品は後日正式オープン予定です。';

  @override
  String get cosmeticUnequip => '外す';

  @override
  String get cosmeticEquip => '装備';

  @override
  String get cosmeticComingSoon => '準備中';

  @override
  String get cosmeticComingSoonSnackbar =>
      'コスメティック商品は後日オープン予定です。現在は広告支援型運営に集中しています。';

  @override
  String get questTileEditTooltip => 'クエスト編集';

  @override
  String get questTileDeleteTooltip => 'クエスト削除';

  @override
  String get notificationMorningTitle => '今日のクエストを始めよう！';

  @override
  String get notificationMorningBody => '新しい一日が始まりました。あなたの成長を記録しましょう。';

  @override
  String get notificationEveningTitle => '今日のクエストをすべて完了しましたか？';

  @override
  String get notificationEveningBody => '未完了のクエストがあるとHPが減少することがあります！';

  @override
  String get initialTitleRookie => '新米冒険者';

  @override
  String get initialQuestMorning => '朝7時起床';

  @override
  String get initialQuestExercise => '運動30分';

  @override
  String get initialQuestRead => '本を10ページ読む';

  @override
  String get initialQuestWeeklyExercise => '週3回以上運動する';

  @override
  String get initialQuestWeeklyLearn => '新しいスキル・知識を学ぶ';

  @override
  String get initialQuestMonthlyExercise => '今月の運動12回達成';

  @override
  String get initialQuestMonthlyProject => 'サイドプロジェクトの核心機能を完成';

  @override
  String get initialQuestYearly => '今年の代表目標を一つ達成する';

  @override
  String get reportScreenTitle => '詳細レポート';

  @override
  String get reportExpandedUnlocked => '本日の拡張レポートが解放されました。';

  @override
  String get reportAdFailed => '広告を読み込めませんでした。しばらくしてからもう一度お試しください。';

  @override
  String get reportSummaryStreak => '現在の連続記録';

  @override
  String reportSummaryStreakValue(int days) {
    return '$days日';
  }

  @override
  String get reportSummaryXp => '現在のXP';

  @override
  String get reportSummaryQuestCount => '完了クエスト数';

  @override
  String reportSummaryQuestCountValue(int count) {
    return '$count個';
  }

  @override
  String get reportSummaryTitle => '現在の称号';

  @override
  String get reportWeeklyActivityTitle => '1週間の活動記録';

  @override
  String get reportWeeklyActivitySubtitle => '今週のルーティン維持の流れを確認できます。';

  @override
  String get reportWeekDayMon => '月';

  @override
  String get reportWeekDayTue => '火';

  @override
  String get reportWeekDayWed => '水';

  @override
  String get reportWeekDayThu => '木';

  @override
  String get reportWeekDayFri => '金';

  @override
  String get reportWeekDaySat => '土';

  @override
  String get reportWeekDaySun => '日';

  @override
  String get reportExpandedEntryTitle => '広告で解放する拡張レポート';

  @override
  String get reportExpandedAlreadyUnlocked =>
      '本日はすでに拡張レポートが解放されています。以下で詳細分析を確認できます。';

  @override
  String get reportExpandedDescription => '詳細分析を開くと、カテゴリ比率、成長傾向、自動成長記録を確認できます。';

  @override
  String get reportFeatureCategoryRatio => 'クエストカテゴリ比率';

  @override
  String get reportFeatureGrowthTrend => '次のレベル成長傾向分析';

  @override
  String get reportFeatureAutoGrowth => '前のレベル自動成長記録';

  @override
  String get reportUnlockedToday => '本日の拡張レポート解放済み';

  @override
  String reportWatchAdButton(int count) {
    return '広告を見て拡張レポートを解放（残り$count回）';
  }

  @override
  String get reportNoMoreViews => '本日はこれ以上解放できません';

  @override
  String get reportCategoryRatioTitle => 'クエストカテゴリ比率';

  @override
  String get reportInsightGrowthTrendTitle => '今レベルの成長傾向';

  @override
  String get reportInsightGrowthTrendCaption => '完了したクエストが最も多く反映される方向です。';

  @override
  String get reportInsightGrowthTrendCaptionEmpty =>
      'クエストを完了すると自動成長の傾向が蓄積されます。';

  @override
  String get reportInsightDataInsufficient => 'データ不足';

  @override
  String get reportInsightAutoGrowthTitle => '前のレベルの自動成長';

  @override
  String get reportInsightAutoGrowthCaption =>
      'レベルアップ時に3ポイントが行動統計に基づいて自動配分されます。';

  @override
  String get reportInsightBestDayTitle => '今週の最高集中日';

  @override
  String reportInsightBestDayCaption(int count) {
    return '今週完了したクエストは合計$count個です。';
  }

  @override
  String get reportInsightRecommendedStatTitle => '推奨集中ステータス';

  @override
  String get reportInsightBalanced => 'バランス良好';

  @override
  String get reportNextLevelPredictionTitle => '次のレベル自動成長予測';

  @override
  String get reportLongTermTitle => '長期目標進捗';

  @override
  String get reportLongTermSubtitle => '月間と年間レイドの進捗状況を一度に確認できます。';

  @override
  String get reportProgressMonthlyRaid => '月間レイド';

  @override
  String get reportProgressYearlyRaid => '年間レイド';

  @override
  String get reportLowestStat => '現在の最低ステータス';

  @override
  String get reportHighestStat => '最高ステータス';

  @override
  String get reportCalendarTitle => 'クエストカレンダー';

  @override
  String get reportCalendarWeekdaySun => '日';

  @override
  String get reportCalendarWeekdayMon => '月';

  @override
  String get reportCalendarWeekdayTue => '火';

  @override
  String get reportCalendarWeekdayWed => '水';

  @override
  String get reportCalendarWeekdayThu => '木';

  @override
  String get reportCalendarWeekdayFri => '金';

  @override
  String get reportCalendarWeekdaySat => '土';

  @override
  String reportCalendarSelectedTitle(int month, int day) {
    return '$month月$day日 完了クエスト';
  }

  @override
  String get reportCalendarSelectPrompt => '日付を選択してください';

  @override
  String get reportCalendarNoQuests => 'この日付に完了したクエストはありません。';

  @override
  String get reportNoRecord => '記録なし';

  @override
  String get reportStatBalanced => '現在ステータスバランスは安定しています。';

  @override
  String reportAddQuestSuggestion(String category) {
    return '$category系のクエストを追加してみましょう';
  }

  @override
  String reportRecommendedAction(String action) {
    return '推奨行動: $action';
  }

  @override
  String reportBestWeekday(String weekday, int count) {
    return '$weekday $count個';
  }

  @override
  String get reportWeekdayMonday => '月曜日';

  @override
  String get reportWeekdayTuesday => '火曜日';

  @override
  String get reportWeekdayWednesday => '水曜日';

  @override
  String get reportWeekdayThursday => '木曜日';

  @override
  String get reportWeekdayFriday => '金曜日';

  @override
  String get reportWeekdaySaturday => '土曜日';

  @override
  String get reportWeekdaySunday => '日曜日';

  @override
  String reportStatValue(String stat, int value) {
    return '$stat $value';
  }

  @override
  String shopItemAcquired(String name) {
    return '$nameを獲得しました！';
  }

  @override
  String get shopCustomRewardFabLabel => '報酬追加';

  @override
  String get statusReportTooltip => '詳細レポートを見る';

  @override
  String get dungeonHomeTitle => 'ソウルデッキ';

  @override
  String get dungeonHomeCardCollectionTooltip => 'カードコレクション';

  @override
  String get dungeonHomeDungeonSelection => 'ダンジョン選択';

  @override
  String dungeonHomeRequiredLevel(int requiredLevel) {
    return 'レベル$requiredLevel以上が必要です';
  }

  @override
  String get zone1Name => '青い草原';

  @override
  String get zone1Description => '初心者冒険者のための最初のダンジョン';

  @override
  String get zone2Name => '闇の森';

  @override
  String get zone2Description => '毒とデバフを使う敵が潜む場所';

  @override
  String get zone3Name => '廃墟の城';

  @override
  String get zone3Description => '防御特化の敵と複数戦闘が待っている';

  @override
  String get zone4Name => '溶岩の洞窟';

  @override
  String get zone4Description => '火傷と高ダメージの地獄';

  @override
  String get zone5Name => '深淵の次元';

  @override
  String get zone5Description => '意図を隠す敵と呪いが降る最終ダンジョン';

  @override
  String get seasonName => 'シーズン1: ソウルの覚醒';

  @override
  String get seasonEnded => '終了';

  @override
  String seasonCountdown(int days) {
    return 'D-$days';
  }

  @override
  String get ascensionModeTitle => 'アセンションモード';

  @override
  String get ascensionInactive => '非アクティブ';

  @override
  String get ascensionActiveModifiers => '適用中のペナルティ:';

  @override
  String get ascensionSliderHint => 'スライダーを上げて難易度を上げましょう';

  @override
  String get ascensionLevel1Modifier => 'Lv 1: 敵HP +10%';

  @override
  String get ascensionLevel2Modifier => 'Lv 2: 敵攻撃力 +10%';

  @override
  String get ascensionLevel3Modifier => 'Lv 3: 開始ゴールド -30';

  @override
  String get ascensionLevel4Modifier => 'Lv 4: 呪いカード1枚追加';

  @override
  String get ascensionLevel5Modifier => 'Lv 5: エリート撃破後カード選択なし';

  @override
  String get ascensionLevel6Modifier => 'Lv 6: ショップ価格 +25%';

  @override
  String get ascensionLevel7Modifier => 'Lv 7: 開始HP -10%';

  @override
  String get ascensionLevel8Modifier => 'Lv 8: ボスHP +25%';

  @override
  String get ascensionLevel9Modifier => 'Lv 9: イベント不利選択肢強化';

  @override
  String get ascensionLevel10Modifier => 'Lv 10: 全敵HP +20%';

  @override
  String get infiniteTowerTitle => '無限の塔';

  @override
  String infiniteTowerBestFloorDesc(int bestFloor) {
    return '終わりなき挑戦 · 最高記録: $bestFloor階';
  }

  @override
  String get infiniteTowerSelectFloor => '挑戦する階を選択';

  @override
  String get infiniteTowerFloorInfo => '階情報';

  @override
  String infiniteTowerChallengeFloor(int targetFloor) {
    return '$targetFloor階に挑戦する';
  }

  @override
  String get infiniteTowerFloorComposition => '階構成';

  @override
  String get infiniteTowerBestFloorLabel => '最高記録';

  @override
  String infiniteTowerFloorDisplay(int floor) {
    return '$floor階';
  }

  @override
  String get infiniteTowerEnemyHp => '敵HP';

  @override
  String get infiniteTowerEnemyAttack => '敵攻撃力';

  @override
  String get infiniteTowerDefault => '基本';

  @override
  String get infiniteTowerFloor1To5 => '1-5階';

  @override
  String get infiniteTowerFloor6To10 => '6-10階';

  @override
  String get infiniteTowerFloor11To15 => '11-15階';

  @override
  String get infiniteTowerFloor16To20 => '16-20階';

  @override
  String get infiniteTowerFloor21To25 => '21-25階';

  @override
  String get infiniteTowerFloor26Plus => '26階以上';

  @override
  String get infiniteTowerRepeatZones => 'Zone 1から繰り返し（難易度上昇続く）';

  @override
  String get dungeonMapTitle => 'ダンジョンマップ';

  @override
  String get dungeonMapNoData => 'ダンジョンデータがありません';

  @override
  String get dungeonRestTitle => '休憩所';

  @override
  String get dungeonRestDescription => '静かな休憩所を見つけた。温かいたき火が燃えている。\n何をしますか？';

  @override
  String get dungeonRestRestTitle => '休憩';

  @override
  String get dungeonRestRestDescription => 'HPの30%を回復します';

  @override
  String dungeonRestHealResult(int healAmount) {
    return 'HPが$healAmount回復しました！';
  }

  @override
  String get dungeonRestTrainTitle => '修練';

  @override
  String get dungeonRestTrainDescription => 'カード1枚を強化します';

  @override
  String get dungeonRestNoCardsToUpgrade => '強化できるカードがありません';

  @override
  String get dungeonRestContinueButton => '続ける';

  @override
  String get dungeonRestSelectCardToUpgrade => '強化するカードを選んでください';

  @override
  String get dungeonRestCardUpgraded => '強化済み';

  @override
  String get dungeonShopTitle => 'ダンジョンショップ';

  @override
  String get dungeonShopCardsSection => 'カード';

  @override
  String get dungeonShopNoCards => '販売中のカードがありません';

  @override
  String get dungeonShopRelicsSection => '遺物';

  @override
  String get dungeonShopNoRelics => '販売中の遺物がありません';

  @override
  String get dungeonShopCardRemovalSection => 'カード除去';

  @override
  String get dungeonShopLeaveButton => 'ショップを出る';

  @override
  String get dungeonShopSelectCardToRemove => '除去するカードを選んでください';

  @override
  String dungeonShopRemovalCost(int cost) {
    return '費用: $costゴールド';
  }

  @override
  String get dungeonShopPurchaseComplete => '購入完了';

  @override
  String get dungeonShopRemoveOneCard => 'カード1枚除去';

  @override
  String dungeonShopRemovalDescription(int deckSize) {
    return 'デッキから不要なカードを除去します（現在のデッキ: $deckSize枚）';
  }

  @override
  String get dungeonEventTitle => 'イベント';

  @override
  String get dungeonEventNoData => 'イベントデータがありません';

  @override
  String get dungeonEventChooseAction => '選んでください';

  @override
  String get dungeonEventContinueButton => '続ける';

  @override
  String get dungeonEventOutcomeTitle => '結果';

  @override
  String get dungeonEventEffectCardReward => 'カード獲得';

  @override
  String get dungeonEventEffectRelicReward => '遺物獲得';

  @override
  String get dungeonEventEffectCardRemove => 'カード除去';

  @override
  String get dungeonEventEffectCardUpgrade => 'カード強化';

  @override
  String get dungeonEventEffectCurseAdded => '呪い追加';

  @override
  String get dungeonResultVictoryTitle => 'ダンジョンクリア！';

  @override
  String get dungeonResultDefeatTitle => '冒険失敗...';

  @override
  String get dungeonResultVictoryMessage => 'おめでとうございます！全ての敵を倒してダンジョンを制覇しました。';

  @override
  String get dungeonResultDefeatMessage => '残念ながら今回の冒険は失敗しました。もう一度挑戦しましょう。';

  @override
  String get dungeonResultStatsTitle => '冒険記録';

  @override
  String get dungeonResultStatsZone => 'エリア';

  @override
  String get dungeonResultStatsNodesCompleted => 'ノード完了';

  @override
  String get dungeonResultStatsMonsterKilled => 'モンスター討伐';

  @override
  String get dungeonResultRewardsTitle => '報酬';

  @override
  String dungeonResultXpReward(int xpGained) {
    return '+$xpGained XP';
  }

  @override
  String dungeonResultGoldReward(int goldGained) {
    return '+$goldGainedゴールド';
  }

  @override
  String get dungeonResultVictoryBonus => 'クリアボーナス x1.5 + ボス討伐ボーナス';

  @override
  String get dungeonResultDefeatPenalty => '敗北ペナルティ: 報酬 x0.5';

  @override
  String get dungeonResultReturnHomeButton => 'ホームに戻る';

  @override
  String get cardBattleYourTurn => 'あなたのターン';

  @override
  String get cardBattleEnemyTurn => '敵のターン';

  @override
  String cardBattleTurnCount(int turnCount) {
    return 'ターン$turnCount';
  }

  @override
  String get cardBattleAbandonDialog => '戦闘放棄';

  @override
  String get cardBattleAbandonConfirmation => '戦闘を放棄しますか？進行状況が失われます。';

  @override
  String get cardBattleAbandonButton => '放棄';

  @override
  String get cardBattleNoEnemies => '敵がいません';

  @override
  String get cardBattleEndTurnButton => 'ターン終了';

  @override
  String get cardBattleNoCardsInHand => '手札にカードがありません';

  @override
  String get cardBattleVictory => '勝利！';

  @override
  String cardBattleGoldReward(int gold) {
    return '+$goldゴールド';
  }

  @override
  String get cardBattleSelectCard => 'カードを選んでください';

  @override
  String get cardBattleSkipButton => 'スキップ';

  @override
  String get cardRarityCommon => 'コモン';

  @override
  String get cardRarityUncommon => 'アンコモン';

  @override
  String get cardRarityRare => 'レア';

  @override
  String get cardRarityLegendary => 'レジェンダリー';

  @override
  String get cardCategoryAttack => '攻撃';

  @override
  String get cardCategoryMagic => '魔法';

  @override
  String get cardCategoryDefense => '防御';

  @override
  String get cardCategoryTactical => '戦術';

  @override
  String get cardCollectionTitle => 'カードコレクション';

  @override
  String get cardCollectionFilterAll => '全て';

  @override
  String get cardCollectionMyCollection => 'マイコレクション';

  @override
  String cardCollectionCardCount(int count) {
    return '($count枚)';
  }

  @override
  String get cardCollectionNoCards => 'カードを持っていません。\nクエストを完了するとカードを獲得できます！';

  @override
  String cardCollectionDeckInclusion(int copyCount) {
    return 'デッキに$copyCount枚含まれる';
  }

  @override
  String get cardCollectionAddToDeck => 'デッキに追加';

  @override
  String get cardCollectionDeckFull => 'デッキが満杯 (20枚)';

  @override
  String get cardCollectionMaxCopies => '最大3枚まで追加可能';

  @override
  String cardCollectionAddedToDeck(String cardName) {
    return '$cardNameをデッキに追加しました';
  }

  @override
  String get cardCollectionMyDeck => 'マイデッキ';

  @override
  String cardCollectionDeckSize(int deckSize) {
    return '($deckSize/20枚)';
  }

  @override
  String get cardCollectionResetDeckDialog => 'デッキリセット';

  @override
  String get cardCollectionResetDeckConfirmation =>
      'カスタムデッキを削除してデフォルトのスターターデッキに戻しますか？';

  @override
  String get cardCollectionResetButton => 'リセット';

  @override
  String get cardCollectionDefaultDeckMessage =>
      'デフォルトのスターターデッキを使用中\nコレクションからカードを追加しましょう';

  @override
  String get cardNameBaseStrike => 'ベーシックストライク';

  @override
  String get cardDescBaseStrike => '6ダメージを与える。';

  @override
  String get cardNameBaseDefend => 'ベーシックブロック';

  @override
  String get cardDescBaseDefend => 'ブロック5を得る。';

  @override
  String get cardNameBaseFocus => '集中';

  @override
  String get cardDescBaseFocus => 'カードを1枚引く。';

  @override
  String get cardNameCursePain => '苦痛';

  @override
  String get cardDescCursePain => '使用不可。引くたびにHP1を失う。';

  @override
  String get cardNameCurseDoubt => '疑念';

  @override
  String get cardDescCurseDoubt => '使用不可。毎ターンドロー-1。';

  @override
  String get cardNameCurseBurden => '重荷';

  @override
  String get cardDescCurseBurden => '使用不可。毎ターン開始時エナジー-1。';

  @override
  String get cardNameCurseDecay => '腐食';

  @override
  String get cardDescCurseDecay => '使用不可。毎ターンブロック-3。';

  @override
  String get cardNameAtkC01 => '強打';

  @override
  String get cardDescAtkC01 => '6ダメージを与える。';

  @override
  String get cardNameAtkC01Up => '強打+';

  @override
  String get cardDescAtkC01Up => '9ダメージを与える。';

  @override
  String get cardNameAtkC02 => '斬撃';

  @override
  String get cardDescAtkC02 => '4ダメージを与え、カードを1枚引く。';

  @override
  String get cardNameAtkC02Up => '斬撃+';

  @override
  String get cardDescAtkC02Up => '6ダメージを与え、カードを1枚引く。';

  @override
  String get cardNameAtkC03 => '連続攻撃';

  @override
  String get cardDescAtkC03 => '3ダメージを2回与える。';

  @override
  String get cardNameAtkC03Up => '連続攻撃+';

  @override
  String get cardDescAtkC03Up => '3ダメージを3回与える。';

  @override
  String get cardNameAtkC04 => '怒りの一撃';

  @override
  String get cardDescAtkC04 => '3ダメージを与え、怒りカード1枚をディスカードに追加する。';

  @override
  String get cardNameAtkC04Up => '怒りの一撃+';

  @override
  String get cardDescAtkC04Up => '5ダメージを与える。';

  @override
  String get cardNameAtkC05 => '突進';

  @override
  String get cardDescAtkC05 => '12ダメージを与える。';

  @override
  String get cardNameAtkC05Up => '突進+';

  @override
  String get cardDescAtkC05Up => '16ダメージを与える。';

  @override
  String get cardNameAtkC06 => '出血攻撃';

  @override
  String get cardDescAtkC06 => '4ダメージを与え、毒2を付与する。';

  @override
  String get cardNameAtkC06Up => '出血攻撃+';

  @override
  String get cardDescAtkC06Up => '4ダメージを与え、毒4を付与する。';

  @override
  String get cardNameAtkC07 => '素早い刺し';

  @override
  String get cardDescAtkC07 => '3ダメージを与える。';

  @override
  String get cardNameAtkC07Up => '素早い刺し+';

  @override
  String get cardDescAtkC07Up => '5ダメージを与える。';

  @override
  String get cardNameAtkC08 => '挑発';

  @override
  String get cardDescAtkC08 => '5ダメージを与え、脆弱1ターンを付与する。';

  @override
  String get cardNameAtkC08Up => '挑発+';

  @override
  String get cardDescAtkC08Up => '8ダメージを与え、脆弱1ターンを付与する。';

  @override
  String get cardNameAtkC09 => '奇襲';

  @override
  String get cardDescAtkC09 => '1ターン目なら12ダメージ、それ以外は6ダメージ。';

  @override
  String get cardNameAtkC09Up => '奇襲+';

  @override
  String get cardDescAtkC09Up => '1ターン目なら18ダメージ、それ以外は9ダメージ。';

  @override
  String get cardNameAtkC10 => '刃の嵐';

  @override
  String get cardDescAtkC10 => '全ての敵に3ダメージを与える。';

  @override
  String get cardNameAtkC10Up => '刃の嵐+';

  @override
  String get cardDescAtkC10Up => '全ての敵に5ダメージを与える。';

  @override
  String get cardNameAtkU01 => 'パワースラッシュ';

  @override
  String get cardDescAtkU01 => '14ダメージを与え、脆弱2ターンを付与する。';

  @override
  String get cardNameAtkU01Up => 'パワースラッシュ+';

  @override
  String get cardDescAtkU01Up => '18ダメージを与え、脆弱2ターンを付与する。';

  @override
  String get cardNameAtkU02 => '刃の舞';

  @override
  String get cardDescAtkU02 => '3ダメージを3回与え、防御3を得る。';

  @override
  String get cardNameAtkU02Up => '刃の舞+';

  @override
  String get cardDescAtkU02Up => '4ダメージを3回与え、防御5を得る。';

  @override
  String get cardNameAtkU03 => '処刑';

  @override
  String get cardDescAtkU03 => '敵HPが50%以下なら30ダメージ、そうでなければ10ダメージ。';

  @override
  String get cardNameAtkU03Up => '処刑+';

  @override
  String get cardDescAtkU03Up => '敵HPが50%以下なら40ダメージ、そうでなければ14ダメージ。';

  @override
  String get cardNameAtkU04 => '狂乱';

  @override
  String get cardDescAtkU04 => '力+2を得る（永続）。';

  @override
  String get cardNameAtkU04Up => '狂乱+';

  @override
  String get cardDescAtkU04Up => '力+3を得る（永続）。';

  @override
  String get cardNameAtkU05 => '血の誓い';

  @override
  String get cardDescAtkU05 => 'HP3を失い、8ダメージを与え、力+1を得る。';

  @override
  String get cardNameAtkU05Up => '血の誓い+';

  @override
  String get cardDescAtkU05Up => 'HP3を失い、12ダメージを与え、力+1を得る。';

  @override
  String get cardNameAtkU06 => '回転斬り';

  @override
  String get cardDescAtkU06 => '全ての敵に8ダメージを与える。';

  @override
  String get cardNameAtkU06Up => '回転斬り+';

  @override
  String get cardDescAtkU06Up => '全ての敵に12ダメージを与える。';

  @override
  String get cardNameAtkU07 => '粉砕';

  @override
  String get cardDescAtkU07 => '10ダメージを与え、脱力2ターンを付与する。';

  @override
  String get cardNameAtkU07Up => '粉砕+';

  @override
  String get cardDescAtkU07Up => '14ダメージを与え、脱力2ターンを付与する。';

  @override
  String get cardNameAtkU08 => '無慈悲';

  @override
  String get cardDescAtkU08 => '脆弱状態の敵に2倍ダメージ（基本6ダメージ）。';

  @override
  String get cardNameAtkU08Up => '無慈悲+';

  @override
  String get cardDescAtkU08Up => '脆弱状態の敵に2倍ダメージ（基本9ダメージ）。';

  @override
  String get cardNameAtkR01 => 'ドラゴンストライク';

  @override
  String get cardDescAtkR01 => '30ダメージを与え、炎上3ターンを付与する。';

  @override
  String get cardNameAtkR01Up => 'ドラゴンストライク+';

  @override
  String get cardDescAtkR01Up => '40ダメージを与え、炎上4ターンを付与する。';

  @override
  String get cardNameAtkR02 => '千の斬撃';

  @override
  String get cardDescAtkR02 => '手札のカード数分1ダメージを与える。';

  @override
  String get cardNameAtkR02Up => '千の斬撃+';

  @override
  String get cardDescAtkR02Up => '手札のカード数分2ダメージを与える。';

  @override
  String get cardNameAtkR03 => '嵐の剣';

  @override
  String get cardDescAtkR03 => 'このターンに使用したカード数分5ダメージを与える。';

  @override
  String get cardNameAtkR03Up => '嵐の剣+';

  @override
  String get cardDescAtkR03Up => 'このターンに使用したカード数分7ダメージを与える。';

  @override
  String get cardNameAtkR04 => '死神の大鎌';

  @override
  String get cardDescAtkR04 => '15ダメージを与える。キル時HP10を回復する。';

  @override
  String get cardNameAtkR04Up => '死神の大鎌+';

  @override
  String get cardDescAtkR04Up => '20ダメージを与える。キル時HP15を回復する。';

  @override
  String get cardNameAtkR05 => 'バーサーク';

  @override
  String get cardDescAtkR05 => '力+5を得る。3ターン後に力-5。';

  @override
  String get cardNameAtkR05Up => 'バーサーク+';

  @override
  String get cardDescAtkR05Up => '力+7を得る。3ターン後に力-5。';

  @override
  String get cardNameAtkL01 => 'エクスカリバー';

  @override
  String get cardDescAtkL01 => '50ダメージを与え、脆弱+脱力3ターンを付与する。使用後消滅。';

  @override
  String get cardNameAtkL01Up => 'エクスカリバー+';

  @override
  String get cardDescAtkL01Up => '60ダメージを与え、脆弱+脱力3ターンを付与する。使用後消滅。';

  @override
  String get cardNameAtkL02 => '無限の刃';

  @override
  String get cardDescAtkL02 => '8ダメージを与える。使用するたびに永久+2ダメージ。';

  @override
  String get cardNameAtkL02Up => '無限の刃+';

  @override
  String get cardDescAtkL02Up => '12ダメージを与える。使用するたびに永久+2ダメージ。';

  @override
  String get cardNameMagC01 => '火炎弾';

  @override
  String get cardDescMagC01 => '4ダメージを与え、炎上2ターンを付与する。';

  @override
  String get cardNameMagC01Up => '火炎弾+';

  @override
  String get cardDescMagC01Up => '6ダメージを与え、炎上3ターンを付与する。';

  @override
  String get cardNameMagC02 => '霜の矢';

  @override
  String get cardDescMagC02 => '5ダメージを与え、脱力1ターンを付与する。';

  @override
  String get cardNameMagC02Up => '霜の矢+';

  @override
  String get cardDescMagC02Up => '8ダメージを与え、脱力1ターンを付与する。';

  @override
  String get cardNameMagC03 => 'マナ集中';

  @override
  String get cardDescMagC03 => 'エネルギー+1を得て、カードを1枚引く。';

  @override
  String get cardNameMagC03Up => 'マナ集中+';

  @override
  String get cardDescMagC03Up => 'エネルギー+1を得て、カードを2枚引く。';

  @override
  String get cardNameMagC04 => '電撃';

  @override
  String get cardDescMagC04 => 'ランダムな敵に7ダメージを与える。';

  @override
  String get cardNameMagC04Up => '電撃+';

  @override
  String get cardDescMagC04Up => 'ランダムな敵に10ダメージを与える。';

  @override
  String get cardNameMagC05 => 'マジックミサイル';

  @override
  String get cardDescMagC05 => 'ランダムな対象に4ダメージを2回与える。';

  @override
  String get cardNameMagC05Up => 'マジックミサイル+';

  @override
  String get cardDescMagC05Up => 'ランダムな対象に4ダメージを3回与える。';

  @override
  String get cardNameMagC06 => '瞑想';

  @override
  String get cardDescMagC06 => 'カードを2枚引く。';

  @override
  String get cardNameMagC06Up => '瞑想+';

  @override
  String get cardDescMagC06Up => 'カードを3枚引く。';

  @override
  String get cardNameMagC07 => '知識の光';

  @override
  String get cardDescMagC07 => 'ドロー山の上3枚を確認し、1枚を手札に加える。';

  @override
  String get cardNameMagC07Up => '知識の光+';

  @override
  String get cardDescMagC07Up => 'ドロー山の上3枚から2枚を手札に加える。';

  @override
  String get cardNameMagC08 => '毒の霧';

  @override
  String get cardDescMagC08 => '全ての敵に毒3を付与する。';

  @override
  String get cardNameMagC08Up => '毒の霧+';

  @override
  String get cardDescMagC08Up => '全ての敵に毒5を付与する。';

  @override
  String get cardNameMagC09 => '魔力爆発';

  @override
  String get cardDescMagC09 => '10ダメージを与え、集中+1を得る。';

  @override
  String get cardNameMagC09Up => '魔力爆発+';

  @override
  String get cardDescMagC09Up => '14ダメージを与え、集中+1を得る。';

  @override
  String get cardNameMagC10 => '元素調和';

  @override
  String get cardDescMagC10 => '次のカードの効果を50%増加させる。';

  @override
  String get cardNameMagC10Up => '元素調和+';

  @override
  String get cardDescMagC10Up => '次のカードの効果を100%増加させる。';

  @override
  String get cardNameMagU01 => '連鎖雷';

  @override
  String get cardDescMagU01 => '8ダメージを与え、全ての敵に4ダメージを与える。';

  @override
  String get cardNameMagU01Up => '連鎖雷+';

  @override
  String get cardDescMagU01Up => '12ダメージを与え、全ての敵に6ダメージを与える。';

  @override
  String get cardNameMagU02 => '氷結の眼';

  @override
  String get cardDescMagU02 => '12ダメージを与え、氷結を1回付与する。';

  @override
  String get cardNameMagU02Up => '氷結の眼+';

  @override
  String get cardDescMagU02Up => '16ダメージを与え、氷結を1回付与する。';

  @override
  String get cardNameMagU03 => '知恵の書';

  @override
  String get cardDescMagU03 => 'カードを3枚引き、1枚を消滅させる。';

  @override
  String get cardNameMagU03Up => '知恵の書+';

  @override
  String get cardDescMagU03Up => 'カードを4枚引く。';

  @override
  String get cardNameMagU04 => 'マナ過負荷';

  @override
  String get cardDescMagU04 => 'エネルギー+2を得る。次のターンエネルギー-1。';

  @override
  String get cardNameMagU04Up => 'マナ過負荷+';

  @override
  String get cardDescMagU04Up => 'エネルギー+3を得る。';

  @override
  String get cardNameMagU05 => '元素嵐';

  @override
  String get cardDescMagU05 => '全ての敵に15ダメージを与える。';

  @override
  String get cardNameMagU05Up => '元素嵐+';

  @override
  String get cardDescMagU05Up => '全ての敵に20ダメージを与える。';

  @override
  String get cardNameMagU06 => '時間歪曲';

  @override
  String get cardDescMagU06 => '追加ターンを1回得る（エネルギー0、手札維持）。';

  @override
  String get cardNameMagU06Up => '時間歪曲+';

  @override
  String get cardDescMagU06Up => '追加ターンを1回得る（エネルギー1でスタート）。';

  @override
  String get cardNameMagU07 => '魔法増幅';

  @override
  String get cardDescMagU07 => '集中+2を得る（永続）。';

  @override
  String get cardNameMagU07Up => '魔法増幅+';

  @override
  String get cardDescMagU07Up => '集中+3を得る（永続）。';

  @override
  String get cardNameMagU08 => '複製術';

  @override
  String get cardDescMagU08 => '手札のカード1枚をコピーする（このターンのみ）。';

  @override
  String get cardNameMagU08Up => '複製術+';

  @override
  String get cardDescMagU08Up => '手札のカード1枚をコスト0でコピーする（このターンのみ）。';

  @override
  String get cardNameMagR01 => 'メテオ';

  @override
  String get cardDescMagR01 => '全ての敵に25ダメージを与え、炎上3ターンを付与する。';

  @override
  String get cardNameMagR01Up => 'メテオ+';

  @override
  String get cardDescMagR01Up => '全ての敵に35ダメージを与え、炎上3ターンを付与する。';

  @override
  String get cardNameMagR02 => 'マナ暴走';

  @override
  String get cardDescMagR02 => '手札の全カードのコストがこのターン0になる。';

  @override
  String get cardNameMagR02Up => 'マナ暴走+';

  @override
  String get cardDescMagR02Up => '手札の全カードのコストが次のターンまで0になる。';

  @override
  String get cardNameMagR03 => '次元の亀裂';

  @override
  String get cardDescMagR03 => '捨て山から3枚を手札に加える。';

  @override
  String get cardNameMagR03Up => '次元の亀裂+';

  @override
  String get cardDescMagR03Up => '捨て山から5枚を手札に加える。';

  @override
  String get cardNameMagR04 => '魂吸収';

  @override
  String get cardDescMagR04 => '12ダメージを与え、同量のHPを回復する。';

  @override
  String get cardNameMagR04Up => '魂吸収+';

  @override
  String get cardDescMagR04Up => '18ダメージを与え、同量のHPを回復する。';

  @override
  String get cardNameMagR05 => '絶対零度';

  @override
  String get cardDescMagR05 => '全ての敵を氷結させ、10ダメージを与える。';

  @override
  String get cardNameMagR05Up => '絶対零度+';

  @override
  String get cardDescMagR05Up => '全ての敵を氷結させ、15ダメージを与える。';

  @override
  String get cardNameMagL01 => 'アルマゲドン';

  @override
  String get cardDescMagL01 => '全ての敵に99ダメージを与える。自分も30ダメージ。使用後消滅。';

  @override
  String get cardNameMagL01Up => 'アルマゲドン+';

  @override
  String get cardDescMagL01Up => '全ての敵に99ダメージを与える。自分15ダメージ。使用後消滅。';

  @override
  String get cardNameMagL02 => '無限の知恵';

  @override
  String get cardDescMagL02 => 'カードを5枚引き、エネルギー+2を得る。使用後消滅。';

  @override
  String get cardNameMagL02Up => '無限の知恵+';

  @override
  String get cardDescMagL02Up => 'カードを7枚引き、エネルギー+3を得る。使用後消滅。';
}
