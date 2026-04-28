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
  String get loginForgotPassword => 'パスワードをお忘れですか?';

  @override
  String get loginForgotPasswordEmailRequired => '先にメールアドレスを入力してください。';

  @override
  String loginForgotPasswordSent(String email) {
    return '$emailにパスワードリセットメールを送信しました。';
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
  String get inventoryGoDungeon => 'ダンジョンへ移動';

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
  String get settingsNotificationMorning => '朝の通知時間';

  @override
  String get settingsNotificationNight => '夜の通知時間';

  @override
  String settingsNotificationTimeValue(int hour) {
    return '毎日$hour時';
  }

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsLanguageSubtitle => 'アプリの表示言語を選択します。';

  @override
  String get settingsLanguageSystem => 'システムの既定';

  @override
  String get settingsLanguageKorean => '한국어';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageJapanese => '日本語';

  @override
  String get settingsLanguageChinese => '中文';

  @override
  String get onboardingPage1Title => '日常をクエストに';

  @override
  String get onboardingPage1Body =>
      'やることをクエストとして登録しましょう。\n完了するたびにXPとゴールドを獲得し\nキャラクターが成長します。';

  @override
  String get onboardingPage2Title => 'ダンジョンを探索せよ';

  @override
  String get onboardingPage2Body =>
      'Soul Deckダンジョンに入り\nカードバトルでモンスターと戦いましょう。\nクエストで積んだ力が実力になります。';

  @override
  String get onboardingPage3Title => '冒険を始めよう';

  @override
  String get onboardingPage3Body =>
      'クエストをこなし、ダンジョンをクリアして\n実績や称号を集めましょう。\nあなたの日常がRPGになります。';

  @override
  String get onboardingNext => '次へ';

  @override
  String get onboardingStart => '始める';

  @override
  String get onboardingSkip => 'スキップ';

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
  String get settingsPrivacyPolicy => 'プライバシーポリシー';

  @override
  String get settingsTerms => '利用規約';

  @override
  String get settingsLegalSection => '規約とポリシー';

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
  String dungeonHomeLockedHint(int requiredLevel) {
    return 'Lv.$requiredLevel達成で解放 — クエストを完了してレベルアップしよう';
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

  @override
  String get cardNameDefC01 => '守備';

  @override
  String get cardDescDefC01 => '防御5を得る。';

  @override
  String get cardNameDefC01Up => '守備+';

  @override
  String get cardDescDefC01Up => '防御8を得る。';

  @override
  String get cardNameDefC02 => '鉄壁';

  @override
  String get cardDescDefC02 => '防御12を得る。';

  @override
  String get cardNameDefC02Up => '鉄壁+';

  @override
  String get cardDescDefC02Up => '防御16を得る。';

  @override
  String get cardNameDefC03 => '反撃';

  @override
  String get cardDescDefC03 => '防御4を得て、棘2を得る。';

  @override
  String get cardNameDefC03Up => '反撃+';

  @override
  String get cardDescDefC03Up => '防御6を得て、棘3を得る。';

  @override
  String get cardNameDefC04 => '回復の祈り';

  @override
  String get cardDescDefC04 => 'HP4を回復する。';

  @override
  String get cardNameDefC04Up => '回復の祈り+';

  @override
  String get cardDescDefC04Up => 'HP7を回復する。';

  @override
  String get cardNameDefC05 => '戦闘態勢';

  @override
  String get cardDescDefC05 => '防御6を得て、カードを1枚引く。';

  @override
  String get cardNameDefC05Up => '戦闘態勢+';

  @override
  String get cardDescDefC05Up => '防御8を得て、カードを1枚引く。';

  @override
  String get cardNameDefC06 => '回転';

  @override
  String get cardDescDefC06 => '防御3を得る。次のターン防御6を得る。';

  @override
  String get cardNameDefC06Up => '回転+';

  @override
  String get cardDescDefC06Up => '防御5を得る。次のターン防御8を得る。';

  @override
  String get cardNameDefC07 => '応急処置';

  @override
  String get cardDescDefC07 => 'HP3を回復する。';

  @override
  String get cardNameDefC07Up => '応急処置+';

  @override
  String get cardDescDefC07Up => 'HP5を回復する。';

  @override
  String get cardNameDefC08 => '忍耐';

  @override
  String get cardDescDefC08 => '防御5を得て、不屈1ターンを得る。';

  @override
  String get cardNameDefC08Up => '忍耐+';

  @override
  String get cardDescDefC08Up => '防御7を得て、不屈2ターンを得る。';

  @override
  String get cardNameDefC09 => '生命力';

  @override
  String get cardDescDefC09 => '再生3を得る（3ターン）。';

  @override
  String get cardNameDefC09Up => '生命力+';

  @override
  String get cardDescDefC09Up => '再生4を得る（4ターン）。';

  @override
  String get cardNameDefC10 => '挑発の盾';

  @override
  String get cardDescDefC10 => '防御6を得て、敵1体を挑発する。';

  @override
  String get cardNameDefC10Up => '挑発の盾+';

  @override
  String get cardDescDefC10Up => '防御9を得て、敵1体を挑発する。';

  @override
  String get cardNameDefU01 => 'バリケード';

  @override
  String get cardDescDefU01 => '防御12を得て、不屈2ターンを得る。';

  @override
  String get cardNameDefU01Up => 'バリケード+';

  @override
  String get cardDescDefU01Up => '防御16を得て、不屈3ターンを得る。';

  @override
  String get cardNameDefU02 => '反射の盾';

  @override
  String get cardDescDefU02 => '防御8を得て、このターン棘5を得る。';

  @override
  String get cardNameDefU02Up => '反射の盾+';

  @override
  String get cardDescDefU02Up => '防御12を得て、このターン棘7を得る。';

  @override
  String get cardNameDefU03 => '癒しの祈り';

  @override
  String get cardDescDefU03 => 'HP10を回復し、3ターン再生2を得る。';

  @override
  String get cardNameDefU03Up => '癒しの祈り+';

  @override
  String get cardDescDefU03Up => 'HP15を回復し、3ターン再生3を得る。';

  @override
  String get cardNameDefU04 => '不屈の意志';

  @override
  String get cardDescDefU04 => '敏捷性+2（永続）。';

  @override
  String get cardNameDefU04Up => '不屈の意志+';

  @override
  String get cardDescDefU04Up => '敏捷性+3（永続）。';

  @override
  String get cardNameDefU05 => '守護の壁';

  @override
  String get cardDescDefU05 => '不足HPの25%分の防御を得る。';

  @override
  String get cardNameDefU05Up => '守護の壁+';

  @override
  String get cardDescDefU05Up => '不足HPの30%分の防御を得る。';

  @override
  String get cardNameDefU06 => '生存本能';

  @override
  String get cardDescDefU06 => 'HP≤50%なら防御15、そうでなければ防御5を得る。';

  @override
  String get cardNameDefU06Up => '生存本能+';

  @override
  String get cardDescDefU06Up => 'HP≤50%なら防御20、そうでなければ防御8を得る。';

  @override
  String get cardNameDefU07 => '吸血の棘';

  @override
  String get cardDescDefU07 => '棘3を得る（永続）。被撃時HP1を回復する。';

  @override
  String get cardNameDefU07Up => '吸血の棘+';

  @override
  String get cardDescDefU07Up => '棘4を得る（永続）。被撃時HP2を回復する。';

  @override
  String get cardNameDefU08 => '強化アーマー';

  @override
  String get cardDescDefU08 => '防御20を得る。次のターン防御10を得る。';

  @override
  String get cardNameDefU08Up => '強化アーマー+';

  @override
  String get cardDescDefU08Up => '防御25を得る。次のターン防御15を得る。';

  @override
  String get cardNameDefR01 => '無敵';

  @override
  String get cardDescDefR01 => 'このターン全ダメージを0にする。消滅。';

  @override
  String get cardNameDefR01Up => '無敵+';

  @override
  String get cardDescDefR01Up => 'このターンと次のターン全ダメージを0にする。消滅。';

  @override
  String get cardNameDefR02 => '生命の木';

  @override
  String get cardDescDefR02 => '最大HPの30%を回復する。';

  @override
  String get cardNameDefR02Up => '生命の木+';

  @override
  String get cardDescDefR02Up => '最大HPの40%を回復する。';

  @override
  String get cardNameDefR03 => '聖なる盾';

  @override
  String get cardDescDefR03 => '防御20を得て、全デバフを除去する。';

  @override
  String get cardNameDefR03Up => '聖なる盾+';

  @override
  String get cardDescDefR03Up => '防御28を得て、全デバフを除去する。';

  @override
  String get cardNameDefR04 => '鉄の体';

  @override
  String get cardDescDefR04 => '毎ターン自動で防御8を得る（戦闘中）。';

  @override
  String get cardNameDefR04Up => '鉄の体+';

  @override
  String get cardDescDefR04Up => '毎ターン自動で防御12を得る（戦闘中）。';

  @override
  String get cardNameDefR05 => '再生の霊薬';

  @override
  String get cardDescDefR05 => 'この戦闘で死亡時、HP30%で復活する。消滅。';

  @override
  String get cardNameDefR05Up => '再生の霊薬+';

  @override
  String get cardDescDefR05Up => 'この戦闘で死亡時、HP50%で復活する。消滅。';

  @override
  String get cardNameDefL01 => '永遠の盾';

  @override
  String get cardDescDefL01 => '防御30を得て、毎ターン自動で防御5を得る（戦闘中）。消滅。';

  @override
  String get cardNameDefL01Up => '永遠の盾+';

  @override
  String get cardDescDefL01Up => '防御40を得て、毎ターン自動で防御8を得る（戦闘中）。消滅。';

  @override
  String get cardNameDefL02 => '生命の泉';

  @override
  String get cardDescDefL02 => 'HPを全回復し、最大HP+10（永続）。消滅。';

  @override
  String get cardNameDefL02Up => '生命の泉+';

  @override
  String get cardDescDefL02Up => 'HPを全回復し、最大HP+20（永続）。消滅。';

  @override
  String get cardNameTacC01 => '観察';

  @override
  String get cardDescTacC01 => '敵の意図を確認し、カードを1枚引く。';

  @override
  String get cardNameTacC01Up => '観察+';

  @override
  String get cardDescTacC01Up => '敵の意図を確認し、カードを2枚引く。';

  @override
  String get cardNameTacC02 => '宝探し';

  @override
  String get cardDescTacC02 => '戦闘ゴールド+15。';

  @override
  String get cardNameTacC02Up => '宝探し+';

  @override
  String get cardDescTacC02Up => '戦闘ゴールド+25。';

  @override
  String get cardNameTacC03 => '弱点看破';

  @override
  String get cardDescTacC03 => '脆弱2ターン、衰弱1ターンを付与する。';

  @override
  String get cardNameTacC03Up => '弱点看破+';

  @override
  String get cardDescTacC03Up => '脆弱2ターン、衰弱2ターンを付与する。';

  @override
  String get cardNameTacC04 => 'すばやい手';

  @override
  String get cardDescTacC04 => 'カードを2枚引く。';

  @override
  String get cardNameTacC04Up => 'すばやい手+';

  @override
  String get cardDescTacC04Up => 'カードを3枚引く。';

  @override
  String get cardNameTacC05 => '罠設置';

  @override
  String get cardDescTacC05 => '次の敵攻撃時に10ダメージを反射する。';

  @override
  String get cardNameTacC05Up => '罠設置+';

  @override
  String get cardDescTacC05Up => '次の敵攻撃時に15ダメージを反射する。';

  @override
  String get cardNameTacC06 => '撹乱';

  @override
  String get cardDescTacC06 => '敵の意図を変更する（ランダム）。';

  @override
  String get cardNameTacC06Up => '撹乱+';

  @override
  String get cardDescTacC06Up => '敵の意図を変更し、衰弱1ターンを付与する。';

  @override
  String get cardNameTacC07 => 'スリ';

  @override
  String get cardDescTacC07 => '3ダメージを与え、ゴールド5~15を獲得する。';

  @override
  String get cardNameTacC07Up => 'スリ+';

  @override
  String get cardDescTacC07Up => '6ダメージを与え、ゴールド10~25を獲得する。';

  @override
  String get cardNameTacC08 => '煙幕弾';

  @override
  String get cardDescTacC08 => '防御4を得て、全敵に衰弱1ターンを付与する。';

  @override
  String get cardNameTacC08Up => '煙幕弾+';

  @override
  String get cardDescTacC08Up => '防御6を得て、全敵に衰弱2ターンを付与する。';

  @override
  String get cardNameTacC09 => '激励';

  @override
  String get cardDescTacC09 => 'この戦闘中にランダムなカード1枚をアップグレードする。';

  @override
  String get cardNameTacC09Up => '激励+';

  @override
  String get cardDescTacC09Up => 'この戦闘中にランダムなカード2枚をアップグレードする。';

  @override
  String get cardNameTacC10 => 'ラッキーコイン';

  @override
  String get cardDescTacC10 => '50%の確率でカードを2枚引く。';

  @override
  String get cardNameTacC10Up => 'ラッキーコイン+';

  @override
  String get cardDescTacC10Up => '70%の確率でカードを2枚引く。';

  @override
  String get cardNameTacU01 => '戦場分析';

  @override
  String get cardDescTacU01 => 'カードを3枚引き、最もコストの高いカードのこのターンのコストを0にする。';

  @override
  String get cardNameTacU01Up => '戦場分析+';

  @override
  String get cardDescTacU01Up => 'カードを4枚引き、最もコストの高いカードのこのターンのコストを0にする。';

  @override
  String get cardNameTacU02 => 'シャドーステップ';

  @override
  String get cardDescTacU02 => '次のターンまで受けるダメージが50%減少する。';

  @override
  String get cardNameTacU02Up => 'シャドーステップ+';

  @override
  String get cardDescTacU02Up => '次のターンまで受けるダメージが50%減少し、カードを1枚引く。';

  @override
  String get cardNameTacU03 => '宝箱';

  @override
  String get cardDescTacU03 => 'ランダムなレリック効果を1回発動する。使用後消滅。';

  @override
  String get cardNameTacU03Up => '宝箱+';

  @override
  String get cardDescTacU03Up => 'ランダムなレリック効果を2回発動する。使用後消滅。';

  @override
  String get cardNameTacU04 => 'カード操作';

  @override
  String get cardDescTacU04 => 'ドローパイルの上位3枚を任意の順序に並べる。';

  @override
  String get cardNameTacU04Up => 'カード操作+';

  @override
  String get cardDescTacU04Up => 'ドローパイルの上位5枚を任意の順序に並べる。';

  @override
  String get cardNameTacU05 => '二重スパイ';

  @override
  String get cardDescTacU05 => '敵のバフをコピーし、敵のバフを除去する。';

  @override
  String get cardNameTacU05Up => '二重スパイ+';

  @override
  String get cardDescTacU05Up => '敵のバフをコピーし、敵のバフを除去し、5ダメージを与える。';

  @override
  String get cardNameTacU06 => '戦略的撤退';

  @override
  String get cardDescTacU06 => '手札をシャッフルし、新たに5枚引く。';

  @override
  String get cardNameTacU06Up => '戦略的撤退+';

  @override
  String get cardDescTacU06Up => '手札をシャッフルし、新たに6枚引く。';

  @override
  String get cardNameTacU07 => '物々交換';

  @override
  String get cardDescTacU07 => '手札から1枚消滅させ、ランダムカード2枚を生成する。';

  @override
  String get cardNameTacU07Up => '物々交換+';

  @override
  String get cardDescTacU07Up => '手札から1枚消滅させ、ランダムカード3枚を生成する。';

  @override
  String get cardNameTacU08 => '連鎖罠';

  @override
  String get cardDescTacU08 => '棘3を得る（永続）。被撃時に衰弱1ターンを付与する。';

  @override
  String get cardNameTacU08Up => '連鎖罠+';

  @override
  String get cardDescTacU08Up => '棘5を得る（永続）。被撃時に衰弱1ターンを付与する。';

  @override
  String get cardNameTacR01 => '完璧な計画';

  @override
  String get cardDescTacR01 => 'エネルギー+3、カードを3枚引く。次のターンドロー0。';

  @override
  String get cardNameTacR01Up => '完璧な計画+';

  @override
  String get cardDescTacR01Up => 'エネルギー+3、カードを3枚引く。次のターンドロー2。';

  @override
  String get cardNameTacR02 => '運命の輪';

  @override
  String get cardDescTacR02 => 'ランダム効果1回: ダメージ15、防御15、回復15、エネルギー+2のいずれか。';

  @override
  String get cardNameTacR02Up => '運命の輪+';

  @override
  String get cardDescTacR02Up => 'ランダム効果2回: ダメージ15、防御15、回復15、エネルギー+2のいずれか。';

  @override
  String get cardNameTacR03 => 'ドッペルゲンガー';

  @override
  String get cardDescTacR03 => 'このターン使用したカード全てを手札に戻す。';

  @override
  String get cardNameTacR03Up => 'ドッペルゲンガー+';

  @override
  String get cardDescTacR03Up => 'このターン使用したカード全てを手札に戻し、エネルギー+2を得る。';

  @override
  String get cardNameTacR04 => '強欲の手';

  @override
  String get cardDescTacR04 => '6ダメージを与える。キル時にカード報酬1枚を追加で得る。';

  @override
  String get cardNameTacR04Up => '強欲の手+';

  @override
  String get cardDescTacR04Up => '10ダメージを与える。キル時にカード報酬1枚を追加で得る。';

  @override
  String get cardNameTacR05 => '大混乱';

  @override
  String get cardDescTacR05 => '全敵に脆弱+衰弱2ターン、毒3を付与する。';

  @override
  String get cardNameTacR05Up => '大混乱+';

  @override
  String get cardDescTacR05Up => '全敵に脆弱+衰弱3ターン、毒3を付与する。';

  @override
  String get cardNameTacL01 => '時の支配者';

  @override
  String get cardDescTacL01 => '追加ターン2回を得る（エネルギー2ずつ）。使用後消滅。';

  @override
  String get cardNameTacL01Up => '時の支配者+';

  @override
  String get cardDescTacL01Up => '追加ターン2回を得る（エネルギー3ずつ）。使用後消滅。';

  @override
  String get cardNameTacL02 => '運命変換';

  @override
  String get cardDescTacL02 => 'デッキ全カードをこの戦闘中アップグレードする。使用後消滅。';

  @override
  String get cardNameTacL02Up => '運命変換+';

  @override
  String get cardDescTacL02Up => 'デッキ全カードをこの戦闘中アップグレードし、エネルギー+2を得る。使用後消滅。';

  @override
  String get relicNameStart01 => '冒険者のバッグ';

  @override
  String get relicDescStart01 => '戦闘報酬カード選択肢+1枚(3→4)';

  @override
  String get relicNameStart02 => '古びたお守り';

  @override
  String get relicDescStart02 => '開始時HP+15';

  @override
  String get relicNameStart03 => '幸運のコイン';

  @override
  String get relicDescStart03 => '戦闘ゴールド+30%';

  @override
  String get relicNameC01 => '錨';

  @override
  String get relicDescC01 => 'ターン開始時に防御4を自動取得';

  @override
  String get relicNameC02 => '赤いポーション';

  @override
  String get relicDescC02 => '戦闘開始時にHP5回復';

  @override
  String get relicNameC03 => 'マナオーブ';

  @override
  String get relicDescC03 => '3ターンごとにエネルギー+1';

  @override
  String get relicNameC04 => '鋭い砥石';

  @override
  String get relicDescC04 => '最初の攻撃カードのダメージ+3';

  @override
  String get relicNameC05 => '盗賊の手袋';

  @override
  String get relicDescC05 => '戦闘報酬ゴールド+15';

  @override
  String get relicNameC06 => '軽い靴';

  @override
  String get relicDescC06 => '初ターンのカードドロー+2';

  @override
  String get relicNameC07 => '毒袋';

  @override
  String get relicDescC07 => '戦闘開始時に全敵に毒2';

  @override
  String get relicNameC08 => 'トゲの盾';

  @override
  String get relicDescC08 => 'トゲ1(永続)';

  @override
  String get relicNameC09 => '集中の指輪';

  @override
  String get relicDescC09 => 'コスト0カード使用時に防御2';

  @override
  String get relicNameC10 => '戦士の腕輪';

  @override
  String get relicDescC10 => '手札が攻撃カードのみの場合エネルギー+1';

  @override
  String get relicNameU01 => '霜の心臓';

  @override
  String get relicDescU01 => '攻撃カード使用時20%確率で弱体化1ターン';

  @override
  String get relicNameU02 => '賢者の石';

  @override
  String get relicDescU02 => '魔法カードダメージ+25%';

  @override
  String get relicNameU03 => '不死鳥の羽';

  @override
  String get relicDescU03 => '死亡時に1回HP30%で復活';

  @override
  String get relicNameU04 => '時の砂';

  @override
  String get relicDescU04 => '最初の3ターンエネルギー+1';

  @override
  String get relicNameU05 => '魂の収穫者';

  @override
  String get relicDescU05 => '敵撃破時にHP5回復';

  @override
  String get relicNameU06 => '魔法の鏡';

  @override
  String get relicDescU06 => '最初のデバフを反射(1回)';

  @override
  String get relicNameU07 => '探検家の地図';

  @override
  String get relicDescU07 => 'マップで次の階全体を公開';

  @override
  String get relicNameU08 => '錬金術師のバッグ';

  @override
  String get relicDescU08 => 'ショップで無料カード除去1回';

  @override
  String get relicNameR01 => '竜の鱗';

  @override
  String get relicDescR01 => '受けるダメージ-1(全攻撃)';

  @override
  String get relicNameR02 => '第三の目';

  @override
  String get relicDescR02 => '敵の意図を正確な数値で表示';

  @override
  String get relicNameR03 => '無限の袋';

  @override
  String get relicDescR03 => 'カード最大所持数+1(手札6枚)';

  @override
  String get relicNameR04 => '覚醒のオーブ';

  @override
  String get relicDescR04 => 'エネルギー最大+1(3→4)';

  @override
  String get relicNameR05 => '運命の糸';

  @override
  String get relicDescR05 => 'カード報酬でレア以上の確率2倍';

  @override
  String get relicNameB01 => '王冠';

  @override
  String get relicDescB01 => 'エネルギー最大+1、開始時に呪い1枚';

  @override
  String get relicNameB02 => '魔王の心臓';

  @override
  String get relicDescB02 => '全カードダメージ+5、受けるダメージ+5';

  @override
  String get relicNameB03 => '復活の聖杯';

  @override
  String get relicDescB03 => '休憩ノードでHPを完全回復';

  @override
  String get relicNameB04 => '混沌の球体';

  @override
  String get relicDescB04 => '毎ターンランダムカード1枚を手札に生成';

  @override
  String get relicNameB05 => '時の王冠';

  @override
  String get relicDescB05 => '初ターンに追加ターン1回';

  @override
  String get achievementNameAc1 => '最初の一歩';

  @override
  String get achievementDescAc1 => 'クエスト1回完了';

  @override
  String get achievementNameAc2 => '誠実の証';

  @override
  String get achievementDescAc2 => 'クエスト10回完了';

  @override
  String get achievementNameAc3 => 'レベル5達成';

  @override
  String get achievementDescAc3 => '初心者冒険者脱出';

  @override
  String get achievementNameAc4 => '力の覚醒';

  @override
  String get achievementDescAc4 => '力ステータス10達成';

  @override
  String get achievementNameAc5 => '知恵の始まり';

  @override
  String get achievementDescAc5 => '知恵ステータス10達成';

  @override
  String get achievementNameAc6 => '頂上を目指して';

  @override
  String get achievementDescAc6 => 'レベル20達成';

  @override
  String get achievementNameAc7 => 'スキルの探求者';

  @override
  String get achievementDescAc7 => 'スキル5個習得';

  @override
  String get achievementNameAc8 => '健康の達人';

  @override
  String get achievementDescAc8 => '健康ステータス50達成';

  @override
  String get achievementNameAc9 => '知恵の大家';

  @override
  String get achievementDescAc9 => '知恵ステータス50達成';

  @override
  String get achievementNameAc10 => 'クエスト中毒者';

  @override
  String get achievementDescAc10 => 'クエスト500回完了';

  @override
  String get achievementNameAc11 => '継続の実践者';

  @override
  String get achievementDescAc11 => 'クエスト50回完了';

  @override
  String get achievementNameAc12 => '習慣の達人';

  @override
  String get achievementDescAc12 => 'クエスト100回完了';

  @override
  String get achievementNameAc13 => 'ベテラン冒険者';

  @override
  String get achievementDescAc13 => 'レベル30達成';

  @override
  String get achievementNameAc14 => '伝説の英雄';

  @override
  String get achievementDescAc14 => 'レベル50達成';

  @override
  String get achievementNameAc15 => '筋肉の王';

  @override
  String get achievementDescAc15 => '力ステータス100達成';

  @override
  String get achievementNameAc16 => 'スキルマスター';

  @override
  String get achievementDescAc16 => 'スキル12個習得';

  @override
  String get achievementNameAc17 => '万能の専門家';

  @override
  String get achievementDescAc17 => 'スキル20個習得';

  @override
  String get achievementNameAc18 => '初めての狩り';

  @override
  String get achievementDescAc18 => 'モンスター1体撃破';

  @override
  String get achievementNameAc19 => '新米ハンター';

  @override
  String get achievementDescAc19 => 'モンスター10体撃破';

  @override
  String get achievementNameAc20 => '熟練の戦士';

  @override
  String get achievementDescAc20 => 'モンスター50体撃破';

  @override
  String get achievementNameAc21 => '虐殺者';

  @override
  String get achievementDescAc21 => 'モンスター200体撃破';

  @override
  String get achievementNameAc22 => '伝説の探検家';

  @override
  String get achievementDescAc22 => 'クエスト1000回完了';

  @override
  String get achievementNameAc23 => 'レベル10達成';

  @override
  String get achievementDescAc23 => '初心者卒業！';

  @override
  String get achievementNameAc24 => '魅力スター';

  @override
  String get achievementDescAc24 => '魅力ステータス30達成';

  @override
  String get achievementNameAc25 => 'カリスマの王';

  @override
  String get achievementDescAc25 => '魅力ステータス80達成';

  @override
  String get titleNameT0 => '新芽の冒険者';

  @override
  String get titleDescT0 => '全てが新しい始まり';

  @override
  String get titleNameT1 => '誠実な冒険者';

  @override
  String get titleDescT1 => '継続は力なり';

  @override
  String get titleNameT2 => '熟練の開拓者';

  @override
  String get titleDescT2 => '自分だけの道を歩む者';

  @override
  String get titleNameT3 => '筋力マニア';

  @override
  String get titleDescT3 => '力クエストXP+5%';

  @override
  String get titleNameT4 => '賢者志望';

  @override
  String get titleDescT4 => '知恵クエストXP+5%';

  @override
  String get titleNameT5 => '鋼の体力';

  @override
  String get titleDescT5 => '健康クエストXP+5%';

  @override
  String get titleNameT6 => '万人に愛される者';

  @override
  String get titleDescT6 => '魅力クエストXP+5%';

  @override
  String get titleNameT7 => '誠実の化身';

  @override
  String get titleDescT7 => 'クエスト100回完了';

  @override
  String get titleNameT8 => '万能の才';

  @override
  String get titleDescT8 => '全ステータス20達成';

  @override
  String get titleNameT9 => 'クエスト職人';

  @override
  String get titleDescT9 => 'クエスト250回完了';

  @override
  String get titleNameT10 => '頂上へ向けて';

  @override
  String get titleDescT10 => 'レベル30達成';

  @override
  String get titleNameT11 => '伝説の勇者';

  @override
  String get titleDescT11 => 'レベル40達成';

  @override
  String get titleNameT12 => '世界の英雄';

  @override
  String get titleDescT12 => 'レベル50達成';

  @override
  String get titleNameT13 => '破壊の化身';

  @override
  String get titleDescT13 => '力クエストXP+10%';

  @override
  String get titleNameT14 => '大賢者';

  @override
  String get titleDescT14 => '知恵クエストXP+10%';

  @override
  String get titleNameT15 => '不死の戦士';

  @override
  String get titleDescT15 => '健康クエストXP+10%';

  @override
  String get titleNameT16 => '絶対カリスマ';

  @override
  String get titleDescT16 => '魅力クエストXP+10%';

  @override
  String get titleNameT17 => 'クエスト伝説';

  @override
  String get titleDescT17 => 'クエスト500回完了';

  @override
  String get titleNameT18 => 'クエストの神';

  @override
  String get titleDescT18 => 'クエスト1000回完了';

  @override
  String get titleNameT19 => 'マスターオブオール';

  @override
  String get titleDescT19 => '全ステータス50達成';

  @override
  String get titleNameT20 => '初心者キャンパー';

  @override
  String get titleDescT20 => 'レベル3達成';

  @override
  String get titleNameT21 => '経験豊かな旅人';

  @override
  String get titleDescT21 => 'レベル20達成';

  @override
  String get titleNameT22 => '力の極致';

  @override
  String get titleDescT22 => '力100達成！';

  @override
  String get titleNameT23 => '知恵の極致';

  @override
  String get titleDescT23 => '知恵100達成！';

  @override
  String get titleNameT24 => '月間レイド突破者';

  @override
  String get titleDescT24 => '月間レイド1回クリア';

  @override
  String get titleNameT25 => '月間レイド征服者';

  @override
  String get titleDescT25 => '月間レイド5回クリア';

  @override
  String get titleNameT26 => '年間レイド生存者';

  @override
  String get titleDescT26 => '年間レイド1回クリア';

  @override
  String get titleNameT27 => '年間レイド君主';

  @override
  String get titleDescT27 => '年間レイド3回クリア';

  @override
  String get skillNameSk1 => '筋力強化';

  @override
  String get skillDescSk1 => '力クエストXP+10%';

  @override
  String get skillNameSk2 => '知恵の光';

  @override
  String get skillDescSk2 => '知恵クエストXP+10%';

  @override
  String get skillNameSk3 => '健康な身体';

  @override
  String get skillDescSk3 => '健康クエストXP+10%';

  @override
  String get skillNameSk4 => '魅力発散';

  @override
  String get skillDescSk4 => '魅力クエストXP+10%';

  @override
  String get skillNameSk5 => 'クエスト専門家';

  @override
  String get skillDescSk5 => '全クエストXP+5%';

  @override
  String get skillNameSk6 => '成長の喜び';

  @override
  String get skillDescSk6 => 'レベルアップ時SP+1';

  @override
  String get skillNameSk7 => '集中訓練';

  @override
  String get skillDescSk7 => 'SP1消費時スタット2増加';

  @override
  String get skillNameSk8 => '学習加速';

  @override
  String get skillDescSk8 => '全クエストXP+10%';

  @override
  String get skillNameSk9 => '超越的な成長';

  @override
  String get skillDescSk9 => 'レベルアップ時基本SP5→7';

  @override
  String get skillNameSk10 => '炎の剣撃';

  @override
  String get skillDescSk10 => '戦闘使用: 追加ダメージ25';

  @override
  String get skillNameSk11 => '癒しの光';

  @override
  String get skillDescSk11 => '戦闘使用: HP20回復';

  @override
  String get skillNameSk12 => '雷撃';

  @override
  String get skillDescSk12 => '戦闘使用: ダメージ50';

  @override
  String get skillNameSk13 => '氷結魔法';

  @override
  String get skillDescSk13 => '戦闘使用: ダメージ35';

  @override
  String get skillNameSk14 => '毒霧';

  @override
  String get skillDescSk14 => '戦闘使用: ダメージ30';

  @override
  String get skillNameSk15 => 'シールド';

  @override
  String get skillDescSk15 => '戦闘使用: HP40回復';

  @override
  String get skillNameSk16 => '大地震';

  @override
  String get skillDescSk16 => '戦闘使用: ダメージ70';

  @override
  String get skillNameSk17 => '聖なる祈り';

  @override
  String get skillDescSk17 => '戦闘使用: HP60回復';

  @override
  String get skillNameSk18 => '戦闘本能';

  @override
  String get skillDescSk18 => '力クエストXP+15%';

  @override
  String get skillNameSk19 => '瞑想の境地';

  @override
  String get skillDescSk19 => '知恵クエストXP+15%';

  @override
  String get skillNameSk20 => '闇の剣';

  @override
  String get skillDescSk20 => '戦闘使用: ダメージ100';

  @override
  String get skillNameSk21 => '完全なる再生';

  @override
  String get skillDescSk21 => '戦闘使用: HP80回復';

  @override
  String get skillNameSk22 => '極限効率';

  @override
  String get skillDescSk22 => 'SP1消費時スタット3増加';

  @override
  String get skillNameSk23 => '超越加速';

  @override
  String get skillDescSk23 => '全クエストXP+20%';

  @override
  String get skillNameSk24 => '神の祝福';

  @override
  String get skillDescSk24 => 'レベルアップ時SP+3';

  @override
  String get monsterSlimeGreen => '緑スライム';

  @override
  String get monsterBat => '洞窟コウモリ';

  @override
  String get monsterMushroom => '毒キノコ';

  @override
  String get monsterSlimeBlue => '青スライム';

  @override
  String get monsterRat => '巨大ネズミ';

  @override
  String get monsterGoblin => 'ゴブリン';

  @override
  String get monsterSkeleton => '骸骨戦士';

  @override
  String get monsterWolf => '影狼';

  @override
  String get monsterSpiderGiant => '巨大毒蜘蛛';

  @override
  String get monsterTreant => '動く木';

  @override
  String get monsterOrc => 'オーク戦士';

  @override
  String get monsterDarkMage => 'ダーク魔法使い';

  @override
  String get monsterGolem => 'ストーンゴーレム';

  @override
  String get monsterHarpy => 'ハーピー';

  @override
  String get monsterMimic => 'ミミック';

  @override
  String get monsterLavaGolem => '溶岩ゴーレム';

  @override
  String get monsterFireSpirit => '炎の精霊';

  @override
  String get monsterDemonWarrior => '魔族戦士';

  @override
  String get monsterSalamander => 'サラマンダー';

  @override
  String get monsterCerberus => 'ケルベロス';

  @override
  String get monsterShadowKnight => '影の騎士';

  @override
  String get monsterLich => 'リッチ';

  @override
  String get monsterBehemoth => 'ベヒモス';

  @override
  String get monsterDarkPhoenix => '闇の不死鳥';

  @override
  String get monsterVoidWorm => '虚空の虫';

  @override
  String get monsterBossTroll => 'トロール大将';

  @override
  String get monsterBossDragon => '炎のドラゴン';

  @override
  String get monsterBossDemonLord => '魔王';

  @override
  String get monsterBossHydra => 'ヒドラ';

  @override
  String get monsterBossFallenAngel => '堕天使';

  @override
  String get monsterBossDeathKnight => '死の騎士';

  @override
  String get chapterName1 => '草原の防衛線';

  @override
  String get chapterName2 => '闇の森';

  @override
  String get chapterName3 => '廃墟の城';

  @override
  String get chapterName4 => '溶岩ダンジョン';

  @override
  String get chapterName5 => '深淵の次元';

  @override
  String get timerDuration15 => '15分';

  @override
  String get timerDuration25 => '25分';

  @override
  String get timerDuration45 => '45分';

  @override
  String get timerDuration60 => '60分';

  @override
  String get huntApRecovered => '⚡ APが2回復しました！';

  @override
  String huntSkillCooldownTurns(int turns) => '${turns}ターン';

  @override
  String settingsReauthFailed(String error) => '再認証に失敗しました: $error';

  @override
  String get settingsReauthWrongPassword => 'パスワードが正しくありません。';
}
