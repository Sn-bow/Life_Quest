import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh')
  ];

  /// No description provided for @cancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get save;

  /// No description provided for @close.
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get close;

  /// No description provided for @confirm.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get delete;

  /// No description provided for @apply.
  ///
  /// In ko, this message translates to:
  /// **'적용'**
  String get apply;

  /// No description provided for @change.
  ///
  /// In ko, this message translates to:
  /// **'변경'**
  String get change;

  /// No description provided for @complete.
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get complete;

  /// No description provided for @acquire.
  ///
  /// In ko, this message translates to:
  /// **'습득'**
  String get acquire;

  /// No description provided for @tabStatus.
  ///
  /// In ko, this message translates to:
  /// **'상태창'**
  String get tabStatus;

  /// No description provided for @tabQuests.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트'**
  String get tabQuests;

  /// No description provided for @tabHunt.
  ///
  /// In ko, this message translates to:
  /// **'사냥'**
  String get tabHunt;

  /// No description provided for @tabInventory.
  ///
  /// In ko, this message translates to:
  /// **'인벤토리'**
  String get tabInventory;

  /// No description provided for @tabShop.
  ///
  /// In ko, this message translates to:
  /// **'상점'**
  String get tabShop;

  /// No description provided for @tabAchievement.
  ///
  /// In ko, this message translates to:
  /// **'업적'**
  String get tabAchievement;

  /// No description provided for @tabSkill.
  ///
  /// In ko, this message translates to:
  /// **'스킬'**
  String get tabSkill;

  /// No description provided for @loginTitle.
  ///
  /// In ko, this message translates to:
  /// **'오늘의 행동을 경험치로 바꾸세요'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'작은 퀘스트를 쌓아 캐릭터와 하루를 함께 성장시키는 생산성 RPG'**
  String get loginSubtitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In ko, this message translates to:
  /// **'이메일'**
  String get loginEmailLabel;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호'**
  String get loginPasswordLabel;

  /// No description provided for @loginButton.
  ///
  /// In ko, this message translates to:
  /// **'로그인'**
  String get loginButton;

  /// No description provided for @loginRegisterButton.
  ///
  /// In ko, this message translates to:
  /// **'새 모험가 등록'**
  String get loginRegisterButton;

  /// No description provided for @loginDivider.
  ///
  /// In ko, this message translates to:
  /// **'간편 로그인'**
  String get loginDivider;

  /// No description provided for @loginGoogleButton.
  ///
  /// In ko, this message translates to:
  /// **'Google 계정으로 시작하기'**
  String get loginGoogleButton;

  /// No description provided for @loginErrorEmpty.
  ///
  /// In ko, this message translates to:
  /// **'이메일과 비밀번호를 모두 입력해주세요.'**
  String get loginErrorEmpty;

  /// No description provided for @loginErrorFailed.
  ///
  /// In ko, this message translates to:
  /// **'로그인에 실패했습니다.'**
  String get loginErrorFailed;

  /// No description provided for @loginErrorGoogleToken.
  ///
  /// In ko, this message translates to:
  /// **'Google 인증 토큰을 가져올 수 없습니다. 다시 시도해주세요.'**
  String get loginErrorGoogleToken;

  /// No description provided for @loginErrorGoogle.
  ///
  /// In ko, this message translates to:
  /// **'구글 로그인에 실패했습니다.'**
  String get loginErrorGoogle;

  /// No description provided for @loginErrorUnknown.
  ///
  /// In ko, this message translates to:
  /// **'오류가 발생했습니다: {error}'**
  String loginErrorUnknown(String error);

  /// No description provided for @signupTitle.
  ///
  /// In ko, this message translates to:
  /// **'새 모험가 등록'**
  String get signupTitle;

  /// No description provided for @signupPickPhoto.
  ///
  /// In ko, this message translates to:
  /// **'프로필 사진 선택'**
  String get signupPickPhoto;

  /// No description provided for @signupEmailLabel.
  ///
  /// In ko, this message translates to:
  /// **'이메일'**
  String get signupEmailLabel;

  /// No description provided for @signupEmailRequired.
  ///
  /// In ko, this message translates to:
  /// **'이메일을 입력해주세요.'**
  String get signupEmailRequired;

  /// No description provided for @signupEmailInvalid.
  ///
  /// In ko, this message translates to:
  /// **'유효한 이메일 형식을 입력해주세요. (예: name@example.com)'**
  String get signupEmailInvalid;

  /// No description provided for @signupNicknameLabel.
  ///
  /// In ko, this message translates to:
  /// **'닉네임'**
  String get signupNicknameLabel;

  /// No description provided for @signupNicknameRequired.
  ///
  /// In ko, this message translates to:
  /// **'닉네임을 입력해주세요.'**
  String get signupNicknameRequired;

  /// No description provided for @signupPasswordLabel.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호'**
  String get signupPasswordLabel;

  /// No description provided for @signupPasswordTooShort.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호는 6자 이상이어야 합니다.'**
  String get signupPasswordTooShort;

  /// No description provided for @signupPasswordConfirmLabel.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 확인'**
  String get signupPasswordConfirmLabel;

  /// No description provided for @signupPasswordMismatch.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호가 일치하지 않습니다.'**
  String get signupPasswordMismatch;

  /// No description provided for @signupButton.
  ///
  /// In ko, this message translates to:
  /// **'가입 완료'**
  String get signupButton;

  /// No description provided for @signupSuccess.
  ///
  /// In ko, this message translates to:
  /// **'🎉 회원가입 성공! 환영합니다!'**
  String get signupSuccess;

  /// No description provided for @signupErrorFailed.
  ///
  /// In ko, this message translates to:
  /// **'회원가입에 실패했습니다.'**
  String get signupErrorFailed;

  /// No description provided for @signupErrorUnknown.
  ///
  /// In ko, this message translates to:
  /// **'알 수 없는 오류가 발생했습니다: {error}'**
  String signupErrorUnknown(String error);

  /// No description provided for @signupErrorUserCreate.
  ///
  /// In ko, this message translates to:
  /// **'사용자 생성에 실패했습니다.'**
  String get signupErrorUserCreate;

  /// No description provided for @statusScreenTitle.
  ///
  /// In ko, this message translates to:
  /// **'상태창'**
  String get statusScreenTitle;

  /// No description provided for @statusTimerTooltip.
  ///
  /// In ko, this message translates to:
  /// **'집중 타이머'**
  String get statusTimerTooltip;

  /// No description provided for @statusSettingsTooltip.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get statusSettingsTooltip;

  /// No description provided for @statusHpLabel.
  ///
  /// In ko, this message translates to:
  /// **'HP'**
  String get statusHpLabel;

  /// No description provided for @statusHpRecoveryHint.
  ///
  /// In ko, this message translates to:
  /// **'비전투 상태에서는 10분마다 HP가 조금씩 자연 회복됩니다.'**
  String get statusHpRecoveryHint;

  /// No description provided for @statusStreakLabel.
  ///
  /// In ko, this message translates to:
  /// **'연속 달성: {days}일'**
  String statusStreakLabel(int days);

  /// No description provided for @statusStreakBonus.
  ///
  /// In ko, this message translates to:
  /// **'XP +{percent}%'**
  String statusStreakBonus(int percent);

  /// No description provided for @statusStatHint.
  ///
  /// In ko, this message translates to:
  /// **'레벨업 시 3포인트는 최근 완료한 퀘스트 성향에 따라 자동 성장하고, 나머지 포인트만 직접 분배합니다.'**
  String get statusStatHint;

  /// No description provided for @statusGoldLabel.
  ///
  /// In ko, this message translates to:
  /// **'골드'**
  String get statusGoldLabel;

  /// No description provided for @statusApLabel.
  ///
  /// In ko, this message translates to:
  /// **'행동력'**
  String get statusApLabel;

  /// No description provided for @statusBaseStatTitle.
  ///
  /// In ko, this message translates to:
  /// **'기본 스탯'**
  String get statusBaseStatTitle;

  /// No description provided for @statusDetailStatButton.
  ///
  /// In ko, this message translates to:
  /// **'상세 스탯 보기'**
  String get statusDetailStatButton;

  /// No description provided for @statusDetailStatTitle.
  ///
  /// In ko, this message translates to:
  /// **'📊 상세 전투 스탯'**
  String get statusDetailStatTitle;

  /// No description provided for @statusAttackLabel.
  ///
  /// In ko, this message translates to:
  /// **'공격력 (Attack)'**
  String get statusAttackLabel;

  /// No description provided for @statusDefenseLabel.
  ///
  /// In ko, this message translates to:
  /// **'방어력 (Defense)'**
  String get statusDefenseLabel;

  /// No description provided for @statusCritLabel.
  ///
  /// In ko, this message translates to:
  /// **'치명타율 (Crit Chance)'**
  String get statusCritLabel;

  /// No description provided for @statusDodgeLabel.
  ///
  /// In ko, this message translates to:
  /// **'회피율 (Dodge Chance)'**
  String get statusDodgeLabel;

  /// No description provided for @statusStatStrength.
  ///
  /// In ko, this message translates to:
  /// **'힘'**
  String get statusStatStrength;

  /// No description provided for @statusStatWisdom.
  ///
  /// In ko, this message translates to:
  /// **'지혜'**
  String get statusStatWisdom;

  /// No description provided for @statusStatHealth.
  ///
  /// In ko, this message translates to:
  /// **'건강'**
  String get statusStatHealth;

  /// No description provided for @statusStatCharm.
  ///
  /// In ko, this message translates to:
  /// **'매력'**
  String get statusStatCharm;

  /// No description provided for @statusTitleChangeTitle.
  ///
  /// In ko, this message translates to:
  /// **'칭호 변경'**
  String get statusTitleChangeTitle;

  /// No description provided for @statusStatApplyTitle.
  ///
  /// In ko, this message translates to:
  /// **'스탯 적용 확인'**
  String get statusStatApplyTitle;

  /// No description provided for @statusStatApplyBody.
  ///
  /// In ko, this message translates to:
  /// **'다음 스탯을 적용하시겠습니까?\n\n{summary}\n\n적용 후에는 되돌릴 수 없습니다.'**
  String statusStatApplyBody(String summary);

  /// No description provided for @questsScreenTitle.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 목록'**
  String get questsScreenTitle;

  /// No description provided for @questsTabDaily.
  ///
  /// In ko, this message translates to:
  /// **'일일 퀘스트'**
  String get questsTabDaily;

  /// No description provided for @questsTabWeekly.
  ///
  /// In ko, this message translates to:
  /// **'주간 퀘스트'**
  String get questsTabWeekly;

  /// No description provided for @questsTabMonthly.
  ///
  /// In ko, this message translates to:
  /// **'월간 레이드'**
  String get questsTabMonthly;

  /// No description provided for @questsTabYearly.
  ///
  /// In ko, this message translates to:
  /// **'연간 레이드'**
  String get questsTabYearly;

  /// No description provided for @questsEmptyDaily.
  ///
  /// In ko, this message translates to:
  /// **'아직 추가된 퀘스트가 없어요.\n오늘 처리할 일부터 가볍게 추가해 보세요.'**
  String get questsEmptyDaily;

  /// No description provided for @questsEmptyWeekly.
  ///
  /// In ko, this message translates to:
  /// **'이번 주 루틴 목표가 아직 없습니다.\n꾸준히 반복할 목표를 넣어보세요.'**
  String get questsEmptyWeekly;

  /// No description provided for @questsEmptyMonthly.
  ///
  /// In ko, this message translates to:
  /// **'이번 달 레이드가 아직 없습니다.\n장기 목표를 월간 레이드로 등록해 보세요.'**
  String get questsEmptyMonthly;

  /// No description provided for @questsEmptyYearly.
  ///
  /// In ko, this message translates to:
  /// **'올해의 대형 레이드가 아직 없습니다.\n인생 목표급 도전을 연간 레이드로 추가해 보세요.'**
  String get questsEmptyYearly;

  /// No description provided for @questsCategoryStrength.
  ///
  /// In ko, this message translates to:
  /// **'힘'**
  String get questsCategoryStrength;

  /// No description provided for @questsCategoryWisdom.
  ///
  /// In ko, this message translates to:
  /// **'지혜'**
  String get questsCategoryWisdom;

  /// No description provided for @questsCategoryHealth.
  ///
  /// In ko, this message translates to:
  /// **'건강'**
  String get questsCategoryHealth;

  /// No description provided for @questsCategoryCharm.
  ///
  /// In ko, this message translates to:
  /// **'매력'**
  String get questsCategoryCharm;

  /// No description provided for @questsDifficultyEasy.
  ///
  /// In ko, this message translates to:
  /// **'쉬움'**
  String get questsDifficultyEasy;

  /// No description provided for @questsDifficultyNormal.
  ///
  /// In ko, this message translates to:
  /// **'보통'**
  String get questsDifficultyNormal;

  /// No description provided for @questsDifficultyHard.
  ///
  /// In ko, this message translates to:
  /// **'어려움'**
  String get questsDifficultyHard;

  /// No description provided for @questsDifficultyVeryHard.
  ///
  /// In ko, this message translates to:
  /// **'매우 어려움'**
  String get questsDifficultyVeryHard;

  /// No description provided for @questsTypeDaily.
  ///
  /// In ko, this message translates to:
  /// **'일일'**
  String get questsTypeDaily;

  /// No description provided for @questsTypeWeekly.
  ///
  /// In ko, this message translates to:
  /// **'주간'**
  String get questsTypeWeekly;

  /// No description provided for @questsTypeMonthly.
  ///
  /// In ko, this message translates to:
  /// **'월간 레이드'**
  String get questsTypeMonthly;

  /// No description provided for @questsTypeYearly.
  ///
  /// In ko, this message translates to:
  /// **'연간 레이드'**
  String get questsTypeYearly;

  /// No description provided for @questsCompleteTitle.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 완료'**
  String get questsCompleteTitle;

  /// No description provided for @questsCompleteConfirm.
  ///
  /// In ko, this message translates to:
  /// **'\'{questName}\' 퀘스트를 완료하시겠습니까?'**
  String questsCompleteConfirm(String questName);

  /// No description provided for @questsBaseRewardLabel.
  ///
  /// In ko, this message translates to:
  /// **'기본 보상'**
  String get questsBaseRewardLabel;

  /// No description provided for @questsDoubleAdButton.
  ///
  /// In ko, this message translates to:
  /// **'광고 보고 2배 받기 ({remaining}회)'**
  String questsDoubleAdButton(int remaining);

  /// No description provided for @questsAdUnavailable.
  ///
  /// In ko, this message translates to:
  /// **'광고를 불러올 수 없습니다. 기본 보상이 지급됩니다.'**
  String get questsAdUnavailable;

  /// No description provided for @questsEditTitle.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 수정'**
  String get questsEditTitle;

  /// No description provided for @questsAddTitle.
  ///
  /// In ko, this message translates to:
  /// **'새 퀘스트 추가'**
  String get questsAddTitle;

  /// No description provided for @questsNameLabel.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 이름'**
  String get questsNameLabel;

  /// No description provided for @questsTypeLabel.
  ///
  /// In ko, this message translates to:
  /// **'종류'**
  String get questsTypeLabel;

  /// No description provided for @questsCategoryLabel.
  ///
  /// In ko, this message translates to:
  /// **'카테고리'**
  String get questsCategoryLabel;

  /// No description provided for @questsDifficultyLabel.
  ///
  /// In ko, this message translates to:
  /// **'난이도'**
  String get questsDifficultyLabel;

  /// No description provided for @questsRewardPreview.
  ///
  /// In ko, this message translates to:
  /// **'{type} 보상: {xp} XP · {gold} 골드'**
  String questsRewardPreview(String type, int xp, int gold);

  /// No description provided for @questsNameRequired.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 이름을 입력해주세요.'**
  String get questsNameRequired;

  /// No description provided for @questsDeleteTitle.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 삭제'**
  String get questsDeleteTitle;

  /// No description provided for @questsDeleteBody.
  ///
  /// In ko, this message translates to:
  /// **'\'{questName}\' 퀘스트를 삭제하시겠습니까?\n\n삭제된 퀘스트는 복구할 수 없습니다.'**
  String questsDeleteBody(String questName);

  /// No description provided for @questsRaidClear.
  ///
  /// In ko, this message translates to:
  /// **'레이드 클리어 {count}회 달성'**
  String questsRaidClear(int count);

  /// No description provided for @questsRaidBonusMonthly.
  ///
  /// In ko, this message translates to:
  /// **'레이드 보너스\n추가 XP · 추가 골드\nAP +2 · SP +1\n진행 보상 해금'**
  String get questsRaidBonusMonthly;

  /// No description provided for @questsRaidBonusYearly.
  ///
  /// In ko, this message translates to:
  /// **'레이드 보너스\n대량 XP · 대량 골드\nAP +4 · SP +2\n희귀 보상 해금'**
  String get questsRaidBonusYearly;

  /// No description provided for @huntScreenTitle.
  ///
  /// In ko, this message translates to:
  /// **'사냥터'**
  String get huntScreenTitle;

  /// No description provided for @huntMyHpLabel.
  ///
  /// In ko, this message translates to:
  /// **'나의 HP'**
  String get huntMyHpLabel;

  /// No description provided for @huntComboBadge.
  ///
  /// In ko, this message translates to:
  /// **'💥 콤보: {count}'**
  String huntComboBadge(int count);

  /// No description provided for @huntApBadge.
  ///
  /// In ko, this message translates to:
  /// **'⚡ AP: {ap}'**
  String huntApBadge(int ap);

  /// No description provided for @huntActionAttack.
  ///
  /// In ko, this message translates to:
  /// **'공격 (1 AP)'**
  String get huntActionAttack;

  /// No description provided for @huntActionDefend.
  ///
  /// In ko, this message translates to:
  /// **'방어 (1 AP)'**
  String get huntActionDefend;

  /// No description provided for @huntActionSkill.
  ///
  /// In ko, this message translates to:
  /// **'스킬 (자유)'**
  String get huntActionSkill;

  /// No description provided for @huntActionBag.
  ///
  /// In ko, this message translates to:
  /// **'가방 (1 AP)'**
  String get huntActionBag;

  /// No description provided for @huntActionFlee.
  ///
  /// In ko, this message translates to:
  /// **'도망 (1 AP)'**
  String get huntActionFlee;

  /// No description provided for @huntBagTitle.
  ///
  /// In ko, this message translates to:
  /// **'가방 (소비 아이템)'**
  String get huntBagTitle;

  /// No description provided for @huntBagEmpty.
  ///
  /// In ko, this message translates to:
  /// **'사용할 수 있는 아이템이 없습니다.'**
  String get huntBagEmpty;

  /// No description provided for @huntBagUse.
  ///
  /// In ko, this message translates to:
  /// **'사용 (1 AP)'**
  String get huntBagUse;

  /// No description provided for @huntSkillSelectTitle.
  ///
  /// In ko, this message translates to:
  /// **'사용할 스킬을 선택하세요:'**
  String get huntSkillSelectTitle;

  /// No description provided for @huntSkillEmpty.
  ///
  /// In ko, this message translates to:
  /// **'배운 전투 스킬이 없습니다.'**
  String get huntSkillEmpty;

  /// No description provided for @huntApLowTitle.
  ///
  /// In ko, this message translates to:
  /// **'AP 부족'**
  String get huntApLowTitle;

  /// No description provided for @huntApLowBody.
  ///
  /// In ko, this message translates to:
  /// **'AP가 부족합니다. 광고를 보고 AP를 2 회복하시겠습니까?\n(오늘 남은 횟수: {remaining}회)'**
  String huntApLowBody(int remaining);

  /// No description provided for @huntApRecoverButton.
  ///
  /// In ko, this message translates to:
  /// **'광고 보고 회복'**
  String get huntApRecoverButton;

  /// No description provided for @huntApExhausted.
  ///
  /// In ko, this message translates to:
  /// **'⚡ AP 부족! 퀘스트를 완료하세요. (오늘 광고 회복 모두 소진)'**
  String get huntApExhausted;

  /// No description provided for @huntDoubleRewardButton.
  ///
  /// In ko, this message translates to:
  /// **'광고 보고 보상 2배로 받기 ({remaining}회 남음)'**
  String huntDoubleRewardButton(int remaining);

  /// No description provided for @huntDoubleRewardSuccess.
  ///
  /// In ko, this message translates to:
  /// **'🎉 광고 보상으로 2배의 전리품을 획득했습니다!'**
  String get huntDoubleRewardSuccess;

  /// No description provided for @huntAdUnavailable.
  ///
  /// In ko, this message translates to:
  /// **'광고를 불러올 수 없습니다. 다시 시도해주세요.'**
  String get huntAdUnavailable;

  /// No description provided for @huntResultButton.
  ///
  /// In ko, this message translates to:
  /// **'결과 확인 & 돌아가기'**
  String get huntResultButton;

  /// No description provided for @huntReviveButton.
  ///
  /// In ko, this message translates to:
  /// **'광고 보고 부활하기 (오늘 {remaining}회 남음)'**
  String huntReviveButton(int remaining);

  /// No description provided for @huntReviveSuccess.
  ///
  /// In ko, this message translates to:
  /// **'❤️ 광고 보상으로 즉시 부활했습니다!'**
  String get huntReviveSuccess;

  /// No description provided for @huntReviveAdUnavailable.
  ///
  /// In ko, this message translates to:
  /// **'광고를 불러올 수 없습니다. 잠시 후 다시 시도해주세요.'**
  String get huntReviveAdUnavailable;

  /// No description provided for @huntRetreatButton.
  ///
  /// In ko, this message translates to:
  /// **'포기하고 돌아가기'**
  String get huntRetreatButton;

  /// No description provided for @inventoryScreenTitle.
  ///
  /// In ko, this message translates to:
  /// **'인벤토리'**
  String get inventoryScreenTitle;

  /// No description provided for @inventoryEquippedSection.
  ///
  /// In ko, this message translates to:
  /// **'장착 장비'**
  String get inventoryEquippedSection;

  /// No description provided for @inventoryCombatStatSection.
  ///
  /// In ko, this message translates to:
  /// **'전투 스탯'**
  String get inventoryCombatStatSection;

  /// No description provided for @inventoryItemsSection.
  ///
  /// In ko, this message translates to:
  /// **'보유 아이템 ({count})'**
  String inventoryItemsSection(int count);

  /// No description provided for @inventorySlotWeapon.
  ///
  /// In ko, this message translates to:
  /// **'⚔️ 무기'**
  String get inventorySlotWeapon;

  /// No description provided for @inventorySlotArmor.
  ///
  /// In ko, this message translates to:
  /// **'🛡️ 방어구'**
  String get inventorySlotArmor;

  /// No description provided for @inventorySlotAccessory.
  ///
  /// In ko, this message translates to:
  /// **'💍 장신구'**
  String get inventorySlotAccessory;

  /// No description provided for @inventorySlotEmpty.
  ///
  /// In ko, this message translates to:
  /// **'비어있음'**
  String get inventorySlotEmpty;

  /// No description provided for @inventoryUnequip.
  ///
  /// In ko, this message translates to:
  /// **'해제'**
  String get inventoryUnequip;

  /// No description provided for @inventoryUseEquip.
  ///
  /// In ko, this message translates to:
  /// **'사용 / 장착'**
  String get inventoryUseEquip;

  /// No description provided for @inventoryEmptyMessage.
  ///
  /// In ko, this message translates to:
  /// **'아이템이 없습니다\n몬스터를 사냥하여 장비를 획득하세요!'**
  String get inventoryEmptyMessage;

  /// No description provided for @inventoryAttackLabel.
  ///
  /// In ko, this message translates to:
  /// **'공격력'**
  String get inventoryAttackLabel;

  /// No description provided for @inventoryDefenseLabel.
  ///
  /// In ko, this message translates to:
  /// **'방어력'**
  String get inventoryDefenseLabel;

  /// No description provided for @inventoryHpLabel.
  ///
  /// In ko, this message translates to:
  /// **'체력'**
  String get inventoryHpLabel;

  /// No description provided for @inventoryStatStrength.
  ///
  /// In ko, this message translates to:
  /// **'힘'**
  String get inventoryStatStrength;

  /// No description provided for @inventoryStatWisdom.
  ///
  /// In ko, this message translates to:
  /// **'지혜'**
  String get inventoryStatWisdom;

  /// No description provided for @inventoryStatHealth.
  ///
  /// In ko, this message translates to:
  /// **'건강'**
  String get inventoryStatHealth;

  /// No description provided for @inventoryStatCharm.
  ///
  /// In ko, this message translates to:
  /// **'매력'**
  String get inventoryStatCharm;

  /// No description provided for @inventoryStatAttack.
  ///
  /// In ko, this message translates to:
  /// **'공격력'**
  String get inventoryStatAttack;

  /// No description provided for @inventoryStatDefense.
  ///
  /// In ko, this message translates to:
  /// **'방어력'**
  String get inventoryStatDefense;

  /// No description provided for @inventoryUsedHp.
  ///
  /// In ko, this message translates to:
  /// **'{itemName}을 사용했습니다. (HP 회복)'**
  String inventoryUsedHp(String itemName);

  /// No description provided for @inventoryUsedAp.
  ///
  /// In ko, this message translates to:
  /// **'{itemName}을 사용했습니다. (AP 회복)'**
  String inventoryUsedAp(String itemName);

  /// No description provided for @inventoryRarityCommon.
  ///
  /// In ko, this message translates to:
  /// **'일반'**
  String get inventoryRarityCommon;

  /// No description provided for @inventoryRarityUncommon.
  ///
  /// In ko, this message translates to:
  /// **'고급'**
  String get inventoryRarityUncommon;

  /// No description provided for @inventoryRarityRare.
  ///
  /// In ko, this message translates to:
  /// **'희귀'**
  String get inventoryRarityRare;

  /// No description provided for @inventoryRarityEpic.
  ///
  /// In ko, this message translates to:
  /// **'영웅'**
  String get inventoryRarityEpic;

  /// No description provided for @inventoryRarityLegendary.
  ///
  /// In ko, this message translates to:
  /// **'전설'**
  String get inventoryRarityLegendary;

  /// No description provided for @shopScreenTitle.
  ///
  /// In ko, this message translates to:
  /// **'상점'**
  String get shopScreenTitle;

  /// No description provided for @shopTabGameItems.
  ///
  /// In ko, this message translates to:
  /// **'게임 아이템'**
  String get shopTabGameItems;

  /// No description provided for @shopTabCustomRewards.
  ///
  /// In ko, this message translates to:
  /// **'나만의 보상'**
  String get shopTabCustomRewards;

  /// No description provided for @shopThemeBannerTitle.
  ///
  /// In ko, this message translates to:
  /// **'테마 쇼케이스'**
  String get shopThemeBannerTitle;

  /// No description provided for @shopThemeBannerSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'준비 중인 테마와 이펙트를 미리 둘러보세요.'**
  String get shopThemeBannerSubtitle;

  /// No description provided for @shopConsumableSection.
  ///
  /// In ko, this message translates to:
  /// **'소비 아이템'**
  String get shopConsumableSection;

  /// No description provided for @shopEquipBoxSection.
  ///
  /// In ko, this message translates to:
  /// **'장비 상자'**
  String get shopEquipBoxSection;

  /// No description provided for @shopPermanentSection.
  ///
  /// In ko, this message translates to:
  /// **'영구 강화'**
  String get shopPermanentSection;

  /// No description provided for @shopHpPotionName.
  ///
  /// In ko, this message translates to:
  /// **'HP 회복 물약'**
  String get shopHpPotionName;

  /// No description provided for @shopHpPotionDesc.
  ///
  /// In ko, this message translates to:
  /// **'HP를 30 회복합니다.'**
  String get shopHpPotionDesc;

  /// No description provided for @shopHpFullPotionName.
  ///
  /// In ko, this message translates to:
  /// **'HP 완전 회복 물약'**
  String get shopHpFullPotionName;

  /// No description provided for @shopHpFullPotionDesc.
  ///
  /// In ko, this message translates to:
  /// **'HP를 최대치로 회복합니다.'**
  String get shopHpFullPotionDesc;

  /// No description provided for @shopApPotionName.
  ///
  /// In ko, this message translates to:
  /// **'AP 충전 물약'**
  String get shopApPotionName;

  /// No description provided for @shopApPotionDesc.
  ///
  /// In ko, this message translates to:
  /// **'AP를 5 회복합니다.'**
  String get shopApPotionDesc;

  /// No description provided for @shopNormalBoxName.
  ///
  /// In ko, this message translates to:
  /// **'일반 장비 상자'**
  String get shopNormalBoxName;

  /// No description provided for @shopNormalBoxDesc.
  ///
  /// In ko, this message translates to:
  /// **'일반~희귀 등급 장비를 랜덤 획득합니다.'**
  String get shopNormalBoxDesc;

  /// No description provided for @shopNormalBoxSuccess.
  ///
  /// In ko, this message translates to:
  /// **'장비를 획득했습니다! 인벤토리를 확인하세요!'**
  String get shopNormalBoxSuccess;

  /// No description provided for @shopPremiumBoxName.
  ///
  /// In ko, this message translates to:
  /// **'고급 장비 상자'**
  String get shopPremiumBoxName;

  /// No description provided for @shopPremiumBoxDesc.
  ///
  /// In ko, this message translates to:
  /// **'희귀~전설 등급 장비를 랜덤 획득합니다.'**
  String get shopPremiumBoxDesc;

  /// No description provided for @shopPremiumBoxSuccess.
  ///
  /// In ko, this message translates to:
  /// **'고급 장비를 획득했습니다! 인벤토리를 확인하세요!'**
  String get shopPremiumBoxSuccess;

  /// No description provided for @shopMaxHpName.
  ///
  /// In ko, this message translates to:
  /// **'최대 HP +10'**
  String get shopMaxHpName;

  /// No description provided for @shopMaxHpDesc.
  ///
  /// In ko, this message translates to:
  /// **'최대 HP를 영구적으로 10 증가시킵니다.'**
  String get shopMaxHpDesc;

  /// No description provided for @shopMaxHpSuccess.
  ///
  /// In ko, this message translates to:
  /// **'최대 HP가 10 증가했습니다!'**
  String get shopMaxHpSuccess;

  /// No description provided for @shopMaxApName.
  ///
  /// In ko, this message translates to:
  /// **'최대 AP +2'**
  String get shopMaxApName;

  /// No description provided for @shopMaxApDesc.
  ///
  /// In ko, this message translates to:
  /// **'최대 AP를 영구적으로 2 증가시킵니다.'**
  String get shopMaxApDesc;

  /// No description provided for @shopMaxApSuccess.
  ///
  /// In ko, this message translates to:
  /// **'최대 AP가 2 증가했습니다!'**
  String get shopMaxApSuccess;

  /// No description provided for @shopCustomRewardAddTitle.
  ///
  /// In ko, this message translates to:
  /// **'나만의 보상 추가'**
  String get shopCustomRewardAddTitle;

  /// No description provided for @shopCustomRewardNameLabel.
  ///
  /// In ko, this message translates to:
  /// **'보상 이름 (예: 넷플릭스 1시간)'**
  String get shopCustomRewardNameLabel;

  /// No description provided for @shopCustomRewardDescLabel.
  ///
  /// In ko, this message translates to:
  /// **'설명'**
  String get shopCustomRewardDescLabel;

  /// No description provided for @shopCustomRewardDescHint.
  ///
  /// In ko, this message translates to:
  /// **'이 보상을 즐기세요!'**
  String get shopCustomRewardDescHint;

  /// No description provided for @shopCustomRewardCostLabel.
  ///
  /// In ko, this message translates to:
  /// **'필요 골드'**
  String get shopCustomRewardCostLabel;

  /// No description provided for @shopCustomRewardIconLabel.
  ///
  /// In ko, this message translates to:
  /// **'아이콘 (이모지)'**
  String get shopCustomRewardIconLabel;

  /// No description provided for @shopCustomRewardAddButton.
  ///
  /// In ko, this message translates to:
  /// **'보상 추가'**
  String get shopCustomRewardAddButton;

  /// No description provided for @shopCustomRewardDeleted.
  ///
  /// In ko, this message translates to:
  /// **'{name} 삭제됨'**
  String shopCustomRewardDeleted(String name);

  /// No description provided for @shopAdSupportTitle.
  ///
  /// In ko, this message translates to:
  /// **'선택형 광고로 앱을 운영합니다'**
  String get shopAdSupportTitle;

  /// No description provided for @shopAdSupportDesc.
  ///
  /// In ko, this message translates to:
  /// **'광고는 퀘스트 보상 2배, AP 회복, 전투 부활처럼 추가 보상이 필요할 때만 표시됩니다.'**
  String get shopAdSupportDesc;

  /// No description provided for @shopAdModelTitle.
  ///
  /// In ko, this message translates to:
  /// **'광고 후원형 운영'**
  String get shopAdModelTitle;

  /// No description provided for @shopAdModelDesc.
  ///
  /// In ko, this message translates to:
  /// **'현재 버전은 인앱결제보다 광고 수익 중심으로 운영됩니다. 유료 상품은 추후 검토됩니다.'**
  String get shopAdModelDesc;

  /// No description provided for @achievementScreenTitle.
  ///
  /// In ko, this message translates to:
  /// **'업적'**
  String get achievementScreenTitle;

  /// No description provided for @achievementTabInProgress.
  ///
  /// In ko, this message translates to:
  /// **'진행 중'**
  String get achievementTabInProgress;

  /// No description provided for @achievementTabCompleted.
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get achievementTabCompleted;

  /// No description provided for @achievementEmptyInProgress.
  ///
  /// In ko, this message translates to:
  /// **'모든 업적을 달성했거나, 새로운 도전을 기다리고 있습니다!'**
  String get achievementEmptyInProgress;

  /// No description provided for @achievementEmptyCompleted.
  ///
  /// In ko, this message translates to:
  /// **'아직 완료한 업적이 없습니다.'**
  String get achievementEmptyCompleted;

  /// No description provided for @achievementRewardXp.
  ///
  /// In ko, this message translates to:
  /// **'보상: {xp} XP'**
  String achievementRewardXp(int xp);

  /// No description provided for @achievementRewardSp.
  ///
  /// In ko, this message translates to:
  /// **'보상: {sp} SP'**
  String achievementRewardSp(int sp);

  /// No description provided for @skillScreenTitle.
  ///
  /// In ko, this message translates to:
  /// **'스킬'**
  String get skillScreenTitle;

  /// No description provided for @skillRequiredLevel.
  ///
  /// In ko, this message translates to:
  /// **'요구 조건: Lv.{level}'**
  String skillRequiredLevel(int level);

  /// No description provided for @settingsScreenTitle.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settingsScreenTitle;

  /// No description provided for @settingsAccountSection.
  ///
  /// In ko, this message translates to:
  /// **'계정'**
  String get settingsAccountSection;

  /// No description provided for @settingsNicknameLabel.
  ///
  /// In ko, this message translates to:
  /// **'닉네임'**
  String get settingsNicknameLabel;

  /// No description provided for @settingsNicknameChangeTitle.
  ///
  /// In ko, this message translates to:
  /// **'닉네임 변경'**
  String get settingsNicknameChangeTitle;

  /// No description provided for @settingsNicknameNewLabel.
  ///
  /// In ko, this message translates to:
  /// **'새 닉네임'**
  String get settingsNicknameNewLabel;

  /// No description provided for @settingsAppSection.
  ///
  /// In ko, this message translates to:
  /// **'앱 설정'**
  String get settingsAppSection;

  /// No description provided for @settingsDarkMode.
  ///
  /// In ko, this message translates to:
  /// **'다크 모드'**
  String get settingsDarkMode;

  /// No description provided for @settingsDarkModeSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'앱의 전체 테마를 변경합니다.'**
  String get settingsDarkModeSubtitle;

  /// No description provided for @settingsSfx.
  ///
  /// In ko, this message translates to:
  /// **'사운드 효과음 (SFX)'**
  String get settingsSfx;

  /// No description provided for @settingsSfxSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'각종 게임 효과음을 켜거나 끕니다.'**
  String get settingsSfxSubtitle;

  /// No description provided for @settingsNotification.
  ///
  /// In ko, this message translates to:
  /// **'알림 설정'**
  String get settingsNotification;

  /// No description provided for @settingsNotificationSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'매일 아침 9시에 퀘스트 알림을 받습니다.'**
  String get settingsNotificationSubtitle;

  /// No description provided for @settingsNotificationEnabled.
  ///
  /// In ko, this message translates to:
  /// **'매일 아침 9시, 저녁 8시에 알림이 예약되었습니다.'**
  String get settingsNotificationEnabled;

  /// No description provided for @settingsNotificationDisabled.
  ///
  /// In ko, this message translates to:
  /// **'모든 알림이 취소되었습니다.'**
  String get settingsNotificationDisabled;

  /// No description provided for @settingsAdSupportSection.
  ///
  /// In ko, this message translates to:
  /// **'광고 후원 안내'**
  String get settingsAdSupportSection;

  /// No description provided for @settingsAdSupportTitle.
  ///
  /// In ko, this message translates to:
  /// **'선택형 광고로 앱을 운영합니다'**
  String get settingsAdSupportTitle;

  /// No description provided for @settingsAdSupportDesc.
  ///
  /// In ko, this message translates to:
  /// **'광고는 퀘스트 보상 2배, AP 회복, 전투 부활처럼 추가 보상이 필요할 때만 표시됩니다.'**
  String get settingsAdSupportDesc;

  /// No description provided for @settingsAdModelTitle.
  ///
  /// In ko, this message translates to:
  /// **'광고 후원형 운영'**
  String get settingsAdModelTitle;

  /// No description provided for @settingsAdModelDesc.
  ///
  /// In ko, this message translates to:
  /// **'현재 버전은 인앱결제보다 광고 수익 중심으로 운영됩니다. 유료 상품은 추후 검토됩니다.'**
  String get settingsAdModelDesc;

  /// No description provided for @settingsLogout.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get settingsLogout;

  /// No description provided for @settingsWithdraw.
  ///
  /// In ko, this message translates to:
  /// **'회원 탈퇴'**
  String get settingsWithdraw;

  /// No description provided for @settingsWithdrawTitle.
  ///
  /// In ko, this message translates to:
  /// **'회원 탈퇴'**
  String get settingsWithdrawTitle;

  /// No description provided for @settingsWithdrawBody.
  ///
  /// In ko, this message translates to:
  /// **'정말로 탈퇴하시겠습니까?\n모든 데이터가 영구적으로 삭제되며, 이 작업은 되돌릴 수 없습니다.'**
  String get settingsWithdrawBody;

  /// No description provided for @settingsWithdrawConfirm.
  ///
  /// In ko, this message translates to:
  /// **'탈퇴 확인'**
  String get settingsWithdrawConfirm;

  /// No description provided for @loadingSync.
  ///
  /// In ko, this message translates to:
  /// **'헌터 정보를 동기화하는 중'**
  String get loadingSync;

  /// No description provided for @loadingSyncDesc.
  ///
  /// In ko, this message translates to:
  /// **'오늘의 퀘스트와 성장 기록을 불러옵니다'**
  String get loadingSyncDesc;

  /// No description provided for @loadingGate.
  ///
  /// In ko, this message translates to:
  /// **'게이트를 여는 중'**
  String get loadingGate;

  /// No description provided for @loadingGateDesc.
  ///
  /// In ko, this message translates to:
  /// **'시스템을 초기화하고 있습니다'**
  String get loadingGateDesc;

  /// No description provided for @loadingTagline.
  ///
  /// In ko, this message translates to:
  /// **'ARISE YOUR QUEST'**
  String get loadingTagline;

  /// No description provided for @timerScreenFocus.
  ///
  /// In ko, this message translates to:
  /// **'🍅 집중 타이머'**
  String get timerScreenFocus;

  /// No description provided for @timerScreenBreak.
  ///
  /// In ko, this message translates to:
  /// **'☕ 휴식 타이머'**
  String get timerScreenBreak;

  /// No description provided for @timerFocusMode.
  ///
  /// In ko, this message translates to:
  /// **'집중 모드'**
  String get timerFocusMode;

  /// No description provided for @timerBreakMode.
  ///
  /// In ko, this message translates to:
  /// **'휴식 모드'**
  String get timerBreakMode;

  /// No description provided for @timerSessionCount.
  ///
  /// In ko, this message translates to:
  /// **'세션 {count} 완료'**
  String timerSessionCount(int count);

  /// No description provided for @timerFocusCompleteTitle.
  ///
  /// In ko, this message translates to:
  /// **'🎉 집중 완료!'**
  String get timerFocusCompleteTitle;

  /// No description provided for @timerFocusCompleteBody.
  ///
  /// In ko, this message translates to:
  /// **'{minutes}분 집중 세션 완료!'**
  String timerFocusCompleteBody(int minutes);

  /// No description provided for @timerGoldRewardLabel.
  ///
  /// In ko, this message translates to:
  /// **'골드 +'**
  String get timerGoldRewardLabel;

  /// No description provided for @timerTodaySessions.
  ///
  /// In ko, this message translates to:
  /// **'오늘 완료: {count} 세션'**
  String timerTodaySessions(int count);

  /// No description provided for @timerStartBreak.
  ///
  /// In ko, this message translates to:
  /// **'휴식 시작'**
  String get timerStartBreak;

  /// No description provided for @timerFocusRewardLabel.
  ///
  /// In ko, this message translates to:
  /// **'집중 완료 보상:'**
  String get timerFocusRewardLabel;

  /// No description provided for @cosmeticShopTitle.
  ///
  /// In ko, this message translates to:
  /// **'테마 쇼케이스'**
  String get cosmeticShopTitle;

  /// No description provided for @cosmeticCategoryTheme.
  ///
  /// In ko, this message translates to:
  /// **'앱 테마'**
  String get cosmeticCategoryTheme;

  /// No description provided for @cosmeticCategoryTitleEffect.
  ///
  /// In ko, this message translates to:
  /// **'칭호 이펙트'**
  String get cosmeticCategoryTitleEffect;

  /// No description provided for @cosmeticCategoryCombatEffect.
  ///
  /// In ko, this message translates to:
  /// **'전투 이펙트'**
  String get cosmeticCategoryCombatEffect;

  /// No description provided for @cosmeticComingSoonTitle.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 꾸미기 기능은 준비 중입니다'**
  String get cosmeticComingSoonTitle;

  /// No description provided for @cosmeticComingSoonDesc.
  ///
  /// In ko, this message translates to:
  /// **'현재는 광고 후원형 운영에 집중하고 있습니다. 테마와 이펙트 상품은 추후 정식 오픈 예정입니다.'**
  String get cosmeticComingSoonDesc;

  /// No description provided for @cosmeticUnequip.
  ///
  /// In ko, this message translates to:
  /// **'장착 해제'**
  String get cosmeticUnequip;

  /// No description provided for @cosmeticEquip.
  ///
  /// In ko, this message translates to:
  /// **'장착'**
  String get cosmeticEquip;

  /// No description provided for @cosmeticComingSoon.
  ///
  /// In ko, this message translates to:
  /// **'준비 중'**
  String get cosmeticComingSoon;

  /// No description provided for @cosmeticComingSoonSnackbar.
  ///
  /// In ko, this message translates to:
  /// **'코스메틱 상품은 추후 오픈 예정입니다. 현재는 광고 후원형 운영에 집중하고 있습니다.'**
  String get cosmeticComingSoonSnackbar;

  /// No description provided for @questTileEditTooltip.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 수정'**
  String get questTileEditTooltip;

  /// No description provided for @questTileDeleteTooltip.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 삭제'**
  String get questTileDeleteTooltip;

  /// No description provided for @notificationMorningTitle.
  ///
  /// In ko, this message translates to:
  /// **'오늘의 퀘스트를 시작하세요!'**
  String get notificationMorningTitle;

  /// No description provided for @notificationMorningBody.
  ///
  /// In ko, this message translates to:
  /// **'새로운 하루가 시작되었습니다. 당신의 성장을 기록해 보세요.'**
  String get notificationMorningBody;

  /// No description provided for @notificationEveningTitle.
  ///
  /// In ko, this message translates to:
  /// **'오늘 퀘스트를 모두 완료하셨나요?'**
  String get notificationEveningTitle;

  /// No description provided for @notificationEveningBody.
  ///
  /// In ko, this message translates to:
  /// **'아직 완료하지 못한 퀘스트가 있다면 HP가 감소할 수 있어요!'**
  String get notificationEveningBody;

  /// No description provided for @initialTitleRookie.
  ///
  /// In ko, this message translates to:
  /// **'새싹 모험가'**
  String get initialTitleRookie;

  /// No description provided for @initialQuestMorning.
  ///
  /// In ko, this message translates to:
  /// **'아침 7시 기상'**
  String get initialQuestMorning;

  /// No description provided for @initialQuestExercise.
  ///
  /// In ko, this message translates to:
  /// **'운동 30분'**
  String get initialQuestExercise;

  /// No description provided for @initialQuestRead.
  ///
  /// In ko, this message translates to:
  /// **'책 10페이지 읽기'**
  String get initialQuestRead;

  /// No description provided for @initialQuestWeeklyExercise.
  ///
  /// In ko, this message translates to:
  /// **'주 3회 이상 운동하기'**
  String get initialQuestWeeklyExercise;

  /// No description provided for @initialQuestWeeklyLearn.
  ///
  /// In ko, this message translates to:
  /// **'새로운 기술/지식 학습하기'**
  String get initialQuestWeeklyLearn;

  /// No description provided for @initialQuestMonthlyExercise.
  ///
  /// In ko, this message translates to:
  /// **'이번 달 운동 12회 달성'**
  String get initialQuestMonthlyExercise;

  /// No description provided for @initialQuestMonthlyProject.
  ///
  /// In ko, this message translates to:
  /// **'사이드 프로젝트 핵심 기능 완성'**
  String get initialQuestMonthlyProject;

  /// No description provided for @initialQuestYearly.
  ///
  /// In ko, this message translates to:
  /// **'올해 대표 목표 하나 완수하기'**
  String get initialQuestYearly;

  /// No description provided for @reportScreenTitle.
  ///
  /// In ko, this message translates to:
  /// **'상세 리포트'**
  String get reportScreenTitle;

  /// No description provided for @reportExpandedUnlocked.
  ///
  /// In ko, this message translates to:
  /// **'확장 리포트를 오늘 하루 동안 열었습니다.'**
  String get reportExpandedUnlocked;

  /// No description provided for @reportAdFailed.
  ///
  /// In ko, this message translates to:
  /// **'광고를 불러오지 못했습니다. 잠시 후 다시 시도해주세요.'**
  String get reportAdFailed;

  /// No description provided for @reportSummaryStreak.
  ///
  /// In ko, this message translates to:
  /// **'현재 연속 기록'**
  String get reportSummaryStreak;

  /// No description provided for @reportSummaryStreakValue.
  ///
  /// In ko, this message translates to:
  /// **'{days}일'**
  String reportSummaryStreakValue(int days);

  /// No description provided for @reportSummaryXp.
  ///
  /// In ko, this message translates to:
  /// **'현재 XP'**
  String get reportSummaryXp;

  /// No description provided for @reportSummaryQuestCount.
  ///
  /// In ko, this message translates to:
  /// **'완료한 퀘스트'**
  String get reportSummaryQuestCount;

  /// No description provided for @reportSummaryQuestCountValue.
  ///
  /// In ko, this message translates to:
  /// **'{count}개'**
  String reportSummaryQuestCountValue(int count);

  /// No description provided for @reportSummaryTitle.
  ///
  /// In ko, this message translates to:
  /// **'현재 칭호'**
  String get reportSummaryTitle;

  /// No description provided for @reportWeeklyActivityTitle.
  ///
  /// In ko, this message translates to:
  /// **'한주간의 활동 기록'**
  String get reportWeeklyActivityTitle;

  /// No description provided for @reportWeeklyActivitySubtitle.
  ///
  /// In ko, this message translates to:
  /// **'이번 주 루틴 유지 흐름을 먼저 확인할 수 있습니다.'**
  String get reportWeeklyActivitySubtitle;

  /// No description provided for @reportWeekDayMon.
  ///
  /// In ko, this message translates to:
  /// **'월'**
  String get reportWeekDayMon;

  /// No description provided for @reportWeekDayTue.
  ///
  /// In ko, this message translates to:
  /// **'화'**
  String get reportWeekDayTue;

  /// No description provided for @reportWeekDayWed.
  ///
  /// In ko, this message translates to:
  /// **'수'**
  String get reportWeekDayWed;

  /// No description provided for @reportWeekDayThu.
  ///
  /// In ko, this message translates to:
  /// **'목'**
  String get reportWeekDayThu;

  /// No description provided for @reportWeekDayFri.
  ///
  /// In ko, this message translates to:
  /// **'금'**
  String get reportWeekDayFri;

  /// No description provided for @reportWeekDaySat.
  ///
  /// In ko, this message translates to:
  /// **'토'**
  String get reportWeekDaySat;

  /// No description provided for @reportWeekDaySun.
  ///
  /// In ko, this message translates to:
  /// **'일'**
  String get reportWeekDaySun;

  /// No description provided for @reportExpandedEntryTitle.
  ///
  /// In ko, this message translates to:
  /// **'광고로 여는 확장 리포트'**
  String get reportExpandedEntryTitle;

  /// No description provided for @reportExpandedAlreadyUnlocked.
  ///
  /// In ko, this message translates to:
  /// **'오늘은 이미 확장 리포트가 해금되었습니다. 아래에서 심층 분석을 바로 볼 수 있습니다.'**
  String get reportExpandedAlreadyUnlocked;

  /// No description provided for @reportExpandedDescription.
  ///
  /// In ko, this message translates to:
  /// **'심층 분석을 열면 카테고리 비율, 이번 레벨 성장 성향, 자동 성장 기록을 확인할 수 있습니다.'**
  String get reportExpandedDescription;

  /// No description provided for @reportFeatureCategoryRatio.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 카테고리 비율'**
  String get reportFeatureCategoryRatio;

  /// No description provided for @reportFeatureGrowthTrend.
  ///
  /// In ko, this message translates to:
  /// **'다음 레벨 성장 성향 분석'**
  String get reportFeatureGrowthTrend;

  /// No description provided for @reportFeatureAutoGrowth.
  ///
  /// In ko, this message translates to:
  /// **'직전 레벨 자동 성장 기록'**
  String get reportFeatureAutoGrowth;

  /// No description provided for @reportUnlockedToday.
  ///
  /// In ko, this message translates to:
  /// **'오늘 확장 리포트 해금됨'**
  String get reportUnlockedToday;

  /// No description provided for @reportWatchAdButton.
  ///
  /// In ko, this message translates to:
  /// **'광고 보고 확장 리포트 열기 (오늘 {count}회 남음)'**
  String reportWatchAdButton(int count);

  /// No description provided for @reportNoMoreViews.
  ///
  /// In ko, this message translates to:
  /// **'오늘은 더 이상 열 수 없습니다'**
  String get reportNoMoreViews;

  /// No description provided for @reportCategoryRatioTitle.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 카테고리 비율'**
  String get reportCategoryRatioTitle;

  /// No description provided for @reportInsightGrowthTrendTitle.
  ///
  /// In ko, this message translates to:
  /// **'이번 레벨 성장 성향'**
  String get reportInsightGrowthTrendTitle;

  /// No description provided for @reportInsightGrowthTrendCaption.
  ///
  /// In ko, this message translates to:
  /// **'완료한 퀘스트가 가장 많이 반영되는 방향입니다.'**
  String get reportInsightGrowthTrendCaption;

  /// No description provided for @reportInsightGrowthTrendCaptionEmpty.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트를 완료하면 자동 성장 경향이 쌓입니다.'**
  String get reportInsightGrowthTrendCaptionEmpty;

  /// No description provided for @reportInsightDataInsufficient.
  ///
  /// In ko, this message translates to:
  /// **'데이터 부족'**
  String get reportInsightDataInsufficient;

  /// No description provided for @reportInsightAutoGrowthTitle.
  ///
  /// In ko, this message translates to:
  /// **'직전 레벨 자동 성장'**
  String get reportInsightAutoGrowthTitle;

  /// No description provided for @reportInsightAutoGrowthCaption.
  ///
  /// In ko, this message translates to:
  /// **'레벨업 시 3포인트는 행동 통계 기반으로 자동 배분됩니다.'**
  String get reportInsightAutoGrowthCaption;

  /// No description provided for @reportInsightBestDayTitle.
  ///
  /// In ko, this message translates to:
  /// **'이번 주 최고 몰입일'**
  String get reportInsightBestDayTitle;

  /// No description provided for @reportInsightBestDayCaption.
  ///
  /// In ko, this message translates to:
  /// **'이번 주 완료한 퀘스트는 총 {count}개입니다.'**
  String reportInsightBestDayCaption(int count);

  /// No description provided for @reportInsightRecommendedStatTitle.
  ///
  /// In ko, this message translates to:
  /// **'추천 집중 스탯'**
  String get reportInsightRecommendedStatTitle;

  /// No description provided for @reportInsightBalanced.
  ///
  /// In ko, this message translates to:
  /// **'균형 잡힘'**
  String get reportInsightBalanced;

  /// No description provided for @reportNextLevelPredictionTitle.
  ///
  /// In ko, this message translates to:
  /// **'다음 레벨 자동 성장 예측'**
  String get reportNextLevelPredictionTitle;

  /// No description provided for @reportLongTermTitle.
  ///
  /// In ko, this message translates to:
  /// **'장기 목표 진행률'**
  String get reportLongTermTitle;

  /// No description provided for @reportLongTermSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'월간과 연간 레이드 진행 상황을 한 번에 확인할 수 있습니다.'**
  String get reportLongTermSubtitle;

  /// No description provided for @reportProgressMonthlyRaid.
  ///
  /// In ko, this message translates to:
  /// **'월간 레이드'**
  String get reportProgressMonthlyRaid;

  /// No description provided for @reportProgressYearlyRaid.
  ///
  /// In ko, this message translates to:
  /// **'연간 레이드'**
  String get reportProgressYearlyRaid;

  /// No description provided for @reportLowestStat.
  ///
  /// In ko, this message translates to:
  /// **'현재 최저 스탯'**
  String get reportLowestStat;

  /// No description provided for @reportHighestStat.
  ///
  /// In ko, this message translates to:
  /// **'최고 스탯'**
  String get reportHighestStat;

  /// No description provided for @reportCalendarTitle.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 달력'**
  String get reportCalendarTitle;

  /// No description provided for @reportCalendarWeekdaySun.
  ///
  /// In ko, this message translates to:
  /// **'일'**
  String get reportCalendarWeekdaySun;

  /// No description provided for @reportCalendarWeekdayMon.
  ///
  /// In ko, this message translates to:
  /// **'월'**
  String get reportCalendarWeekdayMon;

  /// No description provided for @reportCalendarWeekdayTue.
  ///
  /// In ko, this message translates to:
  /// **'화'**
  String get reportCalendarWeekdayTue;

  /// No description provided for @reportCalendarWeekdayWed.
  ///
  /// In ko, this message translates to:
  /// **'수'**
  String get reportCalendarWeekdayWed;

  /// No description provided for @reportCalendarWeekdayThu.
  ///
  /// In ko, this message translates to:
  /// **'목'**
  String get reportCalendarWeekdayThu;

  /// No description provided for @reportCalendarWeekdayFri.
  ///
  /// In ko, this message translates to:
  /// **'금'**
  String get reportCalendarWeekdayFri;

  /// No description provided for @reportCalendarWeekdaySat.
  ///
  /// In ko, this message translates to:
  /// **'토'**
  String get reportCalendarWeekdaySat;

  /// No description provided for @reportCalendarSelectedTitle.
  ///
  /// In ko, this message translates to:
  /// **'{month}월 {day}일 완료 퀘스트'**
  String reportCalendarSelectedTitle(int month, int day);

  /// No description provided for @reportCalendarSelectPrompt.
  ///
  /// In ko, this message translates to:
  /// **'날짜를 선택하세요'**
  String get reportCalendarSelectPrompt;

  /// No description provided for @reportCalendarNoQuests.
  ///
  /// In ko, this message translates to:
  /// **'이 날짜에는 완료한 퀘스트가 없습니다.'**
  String get reportCalendarNoQuests;

  /// No description provided for @reportNoRecord.
  ///
  /// In ko, this message translates to:
  /// **'기록 없음'**
  String get reportNoRecord;

  /// No description provided for @reportStatBalanced.
  ///
  /// In ko, this message translates to:
  /// **'현재는 스탯 밸런스가 안정적입니다.'**
  String get reportStatBalanced;

  /// No description provided for @reportAddQuestSuggestion.
  ///
  /// In ko, this message translates to:
  /// **'{category} 계열 퀘스트를 추가해 보세요'**
  String reportAddQuestSuggestion(String category);

  /// No description provided for @reportRecommendedAction.
  ///
  /// In ko, this message translates to:
  /// **'추천 행동: {action}'**
  String reportRecommendedAction(String action);

  /// No description provided for @reportBestWeekday.
  ///
  /// In ko, this message translates to:
  /// **'{weekday} {count}개'**
  String reportBestWeekday(String weekday, int count);

  /// No description provided for @reportWeekdayMonday.
  ///
  /// In ko, this message translates to:
  /// **'월요일'**
  String get reportWeekdayMonday;

  /// No description provided for @reportWeekdayTuesday.
  ///
  /// In ko, this message translates to:
  /// **'화요일'**
  String get reportWeekdayTuesday;

  /// No description provided for @reportWeekdayWednesday.
  ///
  /// In ko, this message translates to:
  /// **'수요일'**
  String get reportWeekdayWednesday;

  /// No description provided for @reportWeekdayThursday.
  ///
  /// In ko, this message translates to:
  /// **'목요일'**
  String get reportWeekdayThursday;

  /// No description provided for @reportWeekdayFriday.
  ///
  /// In ko, this message translates to:
  /// **'금요일'**
  String get reportWeekdayFriday;

  /// No description provided for @reportWeekdaySaturday.
  ///
  /// In ko, this message translates to:
  /// **'토요일'**
  String get reportWeekdaySaturday;

  /// No description provided for @reportWeekdaySunday.
  ///
  /// In ko, this message translates to:
  /// **'일요일'**
  String get reportWeekdaySunday;

  /// No description provided for @reportStatValue.
  ///
  /// In ko, this message translates to:
  /// **'{stat} {value}'**
  String reportStatValue(String stat, int value);

  /// No description provided for @shopItemAcquired.
  ///
  /// In ko, this message translates to:
  /// **'{name}을(를) 획득했습니다!'**
  String shopItemAcquired(String name);

  /// No description provided for @shopCustomRewardFabLabel.
  ///
  /// In ko, this message translates to:
  /// **'보상 추가'**
  String get shopCustomRewardFabLabel;

  /// No description provided for @statusReportTooltip.
  ///
  /// In ko, this message translates to:
  /// **'상세 리포트 보기'**
  String get statusReportTooltip;

  /// No description provided for @dungeonHomeTitle.
  ///
  /// In ko, this message translates to:
  /// **'소울 덱'**
  String get dungeonHomeTitle;

  /// No description provided for @dungeonHomeCardCollectionTooltip.
  ///
  /// In ko, this message translates to:
  /// **'카드 컬렉션'**
  String get dungeonHomeCardCollectionTooltip;

  /// No description provided for @dungeonHomeDungeonSelection.
  ///
  /// In ko, this message translates to:
  /// **'던전 선택'**
  String get dungeonHomeDungeonSelection;

  /// No description provided for @dungeonHomeRequiredLevel.
  ///
  /// In ko, this message translates to:
  /// **'레벨 {requiredLevel} 이상 필요합니다'**
  String dungeonHomeRequiredLevel(int requiredLevel);

  /// No description provided for @zone1Name.
  ///
  /// In ko, this message translates to:
  /// **'푸른 초원'**
  String get zone1Name;

  /// No description provided for @zone1Description.
  ///
  /// In ko, this message translates to:
  /// **'초보 모험가를 위한 첫 번째 던전'**
  String get zone1Description;

  /// No description provided for @zone2Name.
  ///
  /// In ko, this message translates to:
  /// **'어둠의 숲'**
  String get zone2Name;

  /// No description provided for @zone2Description.
  ///
  /// In ko, this message translates to:
  /// **'독과 디버프를 사용하는 적들이 도사리는 곳'**
  String get zone2Description;

  /// No description provided for @zone3Name.
  ///
  /// In ko, this message translates to:
  /// **'폐허의 성'**
  String get zone3Name;

  /// No description provided for @zone3Description.
  ///
  /// In ko, this message translates to:
  /// **'방어 특화 적과 다중 전투가 기다린다'**
  String get zone3Description;

  /// No description provided for @zone4Name.
  ///
  /// In ko, this message translates to:
  /// **'용암 동굴'**
  String get zone4Name;

  /// No description provided for @zone4Description.
  ///
  /// In ko, this message translates to:
  /// **'화상과 고데미지의 지옥'**
  String get zone4Description;

  /// No description provided for @zone5Name.
  ///
  /// In ko, this message translates to:
  /// **'심연의 차원'**
  String get zone5Name;

  /// No description provided for @zone5Description.
  ///
  /// In ko, this message translates to:
  /// **'의도를 숨기는 적들, 저주가 내리는 최종 던전'**
  String get zone5Description;

  /// No description provided for @seasonName.
  ///
  /// In ko, this message translates to:
  /// **'시즌 1: 영혼의 각성'**
  String get seasonName;

  /// No description provided for @seasonEnded.
  ///
  /// In ko, this message translates to:
  /// **'종료'**
  String get seasonEnded;

  /// No description provided for @seasonCountdown.
  ///
  /// In ko, this message translates to:
  /// **'D-{days}'**
  String seasonCountdown(int days);

  /// No description provided for @ascensionModeTitle.
  ///
  /// In ko, this message translates to:
  /// **'어센션 모드'**
  String get ascensionModeTitle;

  /// No description provided for @ascensionInactive.
  ///
  /// In ko, this message translates to:
  /// **'미활성'**
  String get ascensionInactive;

  /// No description provided for @ascensionActiveModifiers.
  ///
  /// In ko, this message translates to:
  /// **'적용 중인 페널티:'**
  String get ascensionActiveModifiers;

  /// No description provided for @ascensionSliderHint.
  ///
  /// In ko, this message translates to:
  /// **'슬라이더를 올려 난이도를 높이세요'**
  String get ascensionSliderHint;

  /// No description provided for @ascensionLevel1Modifier.
  ///
  /// In ko, this message translates to:
  /// **'Lv 1: 적 HP +10%'**
  String get ascensionLevel1Modifier;

  /// No description provided for @ascensionLevel2Modifier.
  ///
  /// In ko, this message translates to:
  /// **'Lv 2: 적 공격력 +10%'**
  String get ascensionLevel2Modifier;

  /// No description provided for @ascensionLevel3Modifier.
  ///
  /// In ko, this message translates to:
  /// **'Lv 3: 시작 골드 -30'**
  String get ascensionLevel3Modifier;

  /// No description provided for @ascensionLevel4Modifier.
  ///
  /// In ko, this message translates to:
  /// **'Lv 4: 저주 카드 1장 추가'**
  String get ascensionLevel4Modifier;

  /// No description provided for @ascensionLevel5Modifier.
  ///
  /// In ko, this message translates to:
  /// **'Lv 5: 엘리트 처치 후 카드 선택 없음'**
  String get ascensionLevel5Modifier;

  /// No description provided for @ascensionLevel6Modifier.
  ///
  /// In ko, this message translates to:
  /// **'Lv 6: 상점 가격 +25%'**
  String get ascensionLevel6Modifier;

  /// No description provided for @ascensionLevel7Modifier.
  ///
  /// In ko, this message translates to:
  /// **'Lv 7: 시작 HP -10%'**
  String get ascensionLevel7Modifier;

  /// No description provided for @ascensionLevel8Modifier.
  ///
  /// In ko, this message translates to:
  /// **'Lv 8: 보스 HP +25%'**
  String get ascensionLevel8Modifier;

  /// No description provided for @ascensionLevel9Modifier.
  ///
  /// In ko, this message translates to:
  /// **'Lv 9: 이벤트 불이익 선택지 강화'**
  String get ascensionLevel9Modifier;

  /// No description provided for @ascensionLevel10Modifier.
  ///
  /// In ko, this message translates to:
  /// **'Lv 10: 모든 적 HP +20%'**
  String get ascensionLevel10Modifier;

  /// No description provided for @infiniteTowerTitle.
  ///
  /// In ko, this message translates to:
  /// **'무한의 탑'**
  String get infiniteTowerTitle;

  /// No description provided for @infiniteTowerBestFloorDesc.
  ///
  /// In ko, this message translates to:
  /// **'끝없는 도전 · 최고 기록: {bestFloor}층'**
  String infiniteTowerBestFloorDesc(int bestFloor);

  /// No description provided for @infiniteTowerSelectFloor.
  ///
  /// In ko, this message translates to:
  /// **'도전할 층 선택'**
  String get infiniteTowerSelectFloor;

  /// No description provided for @infiniteTowerFloorInfo.
  ///
  /// In ko, this message translates to:
  /// **'층 정보'**
  String get infiniteTowerFloorInfo;

  /// No description provided for @infiniteTowerChallengeFloor.
  ///
  /// In ko, this message translates to:
  /// **'{targetFloor}층 도전하기'**
  String infiniteTowerChallengeFloor(int targetFloor);

  /// No description provided for @infiniteTowerFloorComposition.
  ///
  /// In ko, this message translates to:
  /// **'층 구성'**
  String get infiniteTowerFloorComposition;

  /// No description provided for @infiniteTowerBestFloorLabel.
  ///
  /// In ko, this message translates to:
  /// **'최고 기록'**
  String get infiniteTowerBestFloorLabel;

  /// No description provided for @infiniteTowerFloorDisplay.
  ///
  /// In ko, this message translates to:
  /// **'{floor}층'**
  String infiniteTowerFloorDisplay(int floor);

  /// No description provided for @infiniteTowerEnemyHp.
  ///
  /// In ko, this message translates to:
  /// **'적 HP'**
  String get infiniteTowerEnemyHp;

  /// No description provided for @infiniteTowerEnemyAttack.
  ///
  /// In ko, this message translates to:
  /// **'적 공격력'**
  String get infiniteTowerEnemyAttack;

  /// No description provided for @infiniteTowerDefault.
  ///
  /// In ko, this message translates to:
  /// **'기본'**
  String get infiniteTowerDefault;

  /// No description provided for @infiniteTowerFloor1To5.
  ///
  /// In ko, this message translates to:
  /// **'1-5층'**
  String get infiniteTowerFloor1To5;

  /// No description provided for @infiniteTowerFloor6To10.
  ///
  /// In ko, this message translates to:
  /// **'6-10층'**
  String get infiniteTowerFloor6To10;

  /// No description provided for @infiniteTowerFloor11To15.
  ///
  /// In ko, this message translates to:
  /// **'11-15층'**
  String get infiniteTowerFloor11To15;

  /// No description provided for @infiniteTowerFloor16To20.
  ///
  /// In ko, this message translates to:
  /// **'16-20층'**
  String get infiniteTowerFloor16To20;

  /// No description provided for @infiniteTowerFloor21To25.
  ///
  /// In ko, this message translates to:
  /// **'21-25층'**
  String get infiniteTowerFloor21To25;

  /// No description provided for @infiniteTowerFloor26Plus.
  ///
  /// In ko, this message translates to:
  /// **'26층+'**
  String get infiniteTowerFloor26Plus;

  /// No description provided for @infiniteTowerRepeatZones.
  ///
  /// In ko, this message translates to:
  /// **'이후 Zone 1부터 반복 (난이도 계속 상승)'**
  String get infiniteTowerRepeatZones;

  /// No description provided for @dungeonMapTitle.
  ///
  /// In ko, this message translates to:
  /// **'던전 지도'**
  String get dungeonMapTitle;

  /// No description provided for @dungeonMapNoData.
  ///
  /// In ko, this message translates to:
  /// **'던전 데이터가 없습니다'**
  String get dungeonMapNoData;

  /// No description provided for @dungeonRestTitle.
  ///
  /// In ko, this message translates to:
  /// **'휴식처'**
  String get dungeonRestTitle;

  /// No description provided for @dungeonRestDescription.
  ///
  /// In ko, this message translates to:
  /// **'조용한 휴식처를 발견했다. 따뜻한 모닥불이 타오르고 있다.\n무엇을 하겠는가?'**
  String get dungeonRestDescription;

  /// No description provided for @dungeonRestRestTitle.
  ///
  /// In ko, this message translates to:
  /// **'휴식'**
  String get dungeonRestRestTitle;

  /// No description provided for @dungeonRestRestDescription.
  ///
  /// In ko, this message translates to:
  /// **'HP의 30%를 회복합니다'**
  String get dungeonRestRestDescription;

  /// No description provided for @dungeonRestHealResult.
  ///
  /// In ko, this message translates to:
  /// **'HP가 {healAmount} 회복되었습니다!'**
  String dungeonRestHealResult(int healAmount);

  /// No description provided for @dungeonRestTrainTitle.
  ///
  /// In ko, this message translates to:
  /// **'수련'**
  String get dungeonRestTrainTitle;

  /// No description provided for @dungeonRestTrainDescription.
  ///
  /// In ko, this message translates to:
  /// **'카드 1장을 강화합니다'**
  String get dungeonRestTrainDescription;

  /// No description provided for @dungeonRestNoCardsToUpgrade.
  ///
  /// In ko, this message translates to:
  /// **'강화할 카드가 없습니다'**
  String get dungeonRestNoCardsToUpgrade;

  /// No description provided for @dungeonRestContinueButton.
  ///
  /// In ko, this message translates to:
  /// **'계속'**
  String get dungeonRestContinueButton;

  /// No description provided for @dungeonRestSelectCardToUpgrade.
  ///
  /// In ko, this message translates to:
  /// **'강화할 카드를 선택하세요'**
  String get dungeonRestSelectCardToUpgrade;

  /// No description provided for @dungeonRestCardUpgraded.
  ///
  /// In ko, this message translates to:
  /// **'강화됨'**
  String get dungeonRestCardUpgraded;

  /// No description provided for @dungeonShopTitle.
  ///
  /// In ko, this message translates to:
  /// **'던전 상점'**
  String get dungeonShopTitle;

  /// No description provided for @dungeonShopCardsSection.
  ///
  /// In ko, this message translates to:
  /// **'카드'**
  String get dungeonShopCardsSection;

  /// No description provided for @dungeonShopNoCards.
  ///
  /// In ko, this message translates to:
  /// **'판매 중인 카드가 없습니다'**
  String get dungeonShopNoCards;

  /// No description provided for @dungeonShopRelicsSection.
  ///
  /// In ko, this message translates to:
  /// **'유물'**
  String get dungeonShopRelicsSection;

  /// No description provided for @dungeonShopNoRelics.
  ///
  /// In ko, this message translates to:
  /// **'판매 중인 유물이 없습니다'**
  String get dungeonShopNoRelics;

  /// No description provided for @dungeonShopCardRemovalSection.
  ///
  /// In ko, this message translates to:
  /// **'카드 제거'**
  String get dungeonShopCardRemovalSection;

  /// No description provided for @dungeonShopLeaveButton.
  ///
  /// In ko, this message translates to:
  /// **'상점 나가기'**
  String get dungeonShopLeaveButton;

  /// No description provided for @dungeonShopSelectCardToRemove.
  ///
  /// In ko, this message translates to:
  /// **'제거할 카드를 선택하세요'**
  String get dungeonShopSelectCardToRemove;

  /// No description provided for @dungeonShopRemovalCost.
  ///
  /// In ko, this message translates to:
  /// **'비용: {cost} 골드'**
  String dungeonShopRemovalCost(int cost);

  /// No description provided for @dungeonShopPurchaseComplete.
  ///
  /// In ko, this message translates to:
  /// **'구매 완료'**
  String get dungeonShopPurchaseComplete;

  /// No description provided for @dungeonShopRemoveOneCard.
  ///
  /// In ko, this message translates to:
  /// **'카드 1장 제거'**
  String get dungeonShopRemoveOneCard;

  /// No description provided for @dungeonShopRemovalDescription.
  ///
  /// In ko, this message translates to:
  /// **'덱에서 원하지 않는 카드를 제거합니다 (현재 덱: {deckSize}장)'**
  String dungeonShopRemovalDescription(int deckSize);

  /// No description provided for @dungeonEventTitle.
  ///
  /// In ko, this message translates to:
  /// **'이벤트'**
  String get dungeonEventTitle;

  /// No description provided for @dungeonEventNoData.
  ///
  /// In ko, this message translates to:
  /// **'이벤트 데이터가 없습니다'**
  String get dungeonEventNoData;

  /// No description provided for @dungeonEventChooseAction.
  ///
  /// In ko, this message translates to:
  /// **'선택하세요'**
  String get dungeonEventChooseAction;

  /// No description provided for @dungeonEventContinueButton.
  ///
  /// In ko, this message translates to:
  /// **'계속'**
  String get dungeonEventContinueButton;

  /// No description provided for @dungeonEventOutcomeTitle.
  ///
  /// In ko, this message translates to:
  /// **'결과'**
  String get dungeonEventOutcomeTitle;

  /// No description provided for @dungeonEventEffectCardReward.
  ///
  /// In ko, this message translates to:
  /// **'카드 획득'**
  String get dungeonEventEffectCardReward;

  /// No description provided for @dungeonEventEffectRelicReward.
  ///
  /// In ko, this message translates to:
  /// **'유물 획득'**
  String get dungeonEventEffectRelicReward;

  /// No description provided for @dungeonEventEffectCardRemove.
  ///
  /// In ko, this message translates to:
  /// **'카드 제거'**
  String get dungeonEventEffectCardRemove;

  /// No description provided for @dungeonEventEffectCardUpgrade.
  ///
  /// In ko, this message translates to:
  /// **'카드 강화'**
  String get dungeonEventEffectCardUpgrade;

  /// No description provided for @dungeonEventEffectCurseAdded.
  ///
  /// In ko, this message translates to:
  /// **'저주 추가'**
  String get dungeonEventEffectCurseAdded;

  /// No description provided for @dungeonResultVictoryTitle.
  ///
  /// In ko, this message translates to:
  /// **'던전 클리어!'**
  String get dungeonResultVictoryTitle;

  /// No description provided for @dungeonResultDefeatTitle.
  ///
  /// In ko, this message translates to:
  /// **'모험 실패...'**
  String get dungeonResultDefeatTitle;

  /// No description provided for @dungeonResultVictoryMessage.
  ///
  /// In ko, this message translates to:
  /// **'축하합니다! 모든 적을 물리치고 던전을 정복했습니다.'**
  String get dungeonResultVictoryMessage;

  /// No description provided for @dungeonResultDefeatMessage.
  ///
  /// In ko, this message translates to:
  /// **'아쉽게도 이번 모험은 실패했습니다. 다시 도전해보세요.'**
  String get dungeonResultDefeatMessage;

  /// No description provided for @dungeonResultStatsTitle.
  ///
  /// In ko, this message translates to:
  /// **'모험 기록'**
  String get dungeonResultStatsTitle;

  /// No description provided for @dungeonResultStatsZone.
  ///
  /// In ko, this message translates to:
  /// **'지역'**
  String get dungeonResultStatsZone;

  /// No description provided for @dungeonResultStatsNodesCompleted.
  ///
  /// In ko, this message translates to:
  /// **'노드 완료'**
  String get dungeonResultStatsNodesCompleted;

  /// No description provided for @dungeonResultStatsMonsterKilled.
  ///
  /// In ko, this message translates to:
  /// **'몬스터 처치'**
  String get dungeonResultStatsMonsterKilled;

  /// No description provided for @dungeonResultRewardsTitle.
  ///
  /// In ko, this message translates to:
  /// **'보상'**
  String get dungeonResultRewardsTitle;

  /// No description provided for @dungeonResultXpReward.
  ///
  /// In ko, this message translates to:
  /// **'+{xpGained} XP'**
  String dungeonResultXpReward(int xpGained);

  /// No description provided for @dungeonResultGoldReward.
  ///
  /// In ko, this message translates to:
  /// **'+{goldGained} 골드'**
  String dungeonResultGoldReward(int goldGained);

  /// No description provided for @dungeonResultVictoryBonus.
  ///
  /// In ko, this message translates to:
  /// **'클리어 보너스 x1.5 + 보스 처치 보너스'**
  String get dungeonResultVictoryBonus;

  /// No description provided for @dungeonResultDefeatPenalty.
  ///
  /// In ko, this message translates to:
  /// **'패배 페널티: 보상 x0.5'**
  String get dungeonResultDefeatPenalty;

  /// No description provided for @dungeonResultReturnHomeButton.
  ///
  /// In ko, this message translates to:
  /// **'홈으로 돌아가기'**
  String get dungeonResultReturnHomeButton;

  /// No description provided for @cardBattleYourTurn.
  ///
  /// In ko, this message translates to:
  /// **'당신의 턴'**
  String get cardBattleYourTurn;

  /// No description provided for @cardBattleEnemyTurn.
  ///
  /// In ko, this message translates to:
  /// **'적의 턴'**
  String get cardBattleEnemyTurn;

  /// No description provided for @cardBattleTurnCount.
  ///
  /// In ko, this message translates to:
  /// **'턴 {turnCount}'**
  String cardBattleTurnCount(int turnCount);

  /// No description provided for @cardBattleAbandonDialog.
  ///
  /// In ko, this message translates to:
  /// **'전투 포기'**
  String get cardBattleAbandonDialog;

  /// No description provided for @cardBattleAbandonConfirmation.
  ///
  /// In ko, this message translates to:
  /// **'전투를 포기하시겠습니까? 진행 사항이 사라집니다.'**
  String get cardBattleAbandonConfirmation;

  /// No description provided for @cardBattleAbandonButton.
  ///
  /// In ko, this message translates to:
  /// **'포기'**
  String get cardBattleAbandonButton;

  /// No description provided for @cardBattleNoEnemies.
  ///
  /// In ko, this message translates to:
  /// **'적이 없습니다'**
  String get cardBattleNoEnemies;

  /// No description provided for @cardBattleEndTurnButton.
  ///
  /// In ko, this message translates to:
  /// **'턴 종료'**
  String get cardBattleEndTurnButton;

  /// No description provided for @cardBattleNoCardsInHand.
  ///
  /// In ko, this message translates to:
  /// **'손에 카드가 없습니다'**
  String get cardBattleNoCardsInHand;

  /// No description provided for @cardBattleVictory.
  ///
  /// In ko, this message translates to:
  /// **'승리!'**
  String get cardBattleVictory;

  /// No description provided for @cardBattleGoldReward.
  ///
  /// In ko, this message translates to:
  /// **'+{gold} 골드'**
  String cardBattleGoldReward(int gold);

  /// No description provided for @cardBattleSelectCard.
  ///
  /// In ko, this message translates to:
  /// **'카드를 선택하세요'**
  String get cardBattleSelectCard;

  /// No description provided for @cardBattleSkipButton.
  ///
  /// In ko, this message translates to:
  /// **'건너뛰기'**
  String get cardBattleSkipButton;

  /// No description provided for @cardRarityCommon.
  ///
  /// In ko, this message translates to:
  /// **'일반'**
  String get cardRarityCommon;

  /// No description provided for @cardRarityUncommon.
  ///
  /// In ko, this message translates to:
  /// **'고급'**
  String get cardRarityUncommon;

  /// No description provided for @cardRarityRare.
  ///
  /// In ko, this message translates to:
  /// **'희귀'**
  String get cardRarityRare;

  /// No description provided for @cardRarityLegendary.
  ///
  /// In ko, this message translates to:
  /// **'전설'**
  String get cardRarityLegendary;

  /// No description provided for @cardCategoryAttack.
  ///
  /// In ko, this message translates to:
  /// **'공격'**
  String get cardCategoryAttack;

  /// No description provided for @cardCategoryMagic.
  ///
  /// In ko, this message translates to:
  /// **'마법'**
  String get cardCategoryMagic;

  /// No description provided for @cardCategoryDefense.
  ///
  /// In ko, this message translates to:
  /// **'방어'**
  String get cardCategoryDefense;

  /// No description provided for @cardCategoryTactical.
  ///
  /// In ko, this message translates to:
  /// **'전술'**
  String get cardCategoryTactical;

  /// No description provided for @cardCollectionTitle.
  ///
  /// In ko, this message translates to:
  /// **'카드 컬렉션'**
  String get cardCollectionTitle;

  /// No description provided for @cardCollectionFilterAll.
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get cardCollectionFilterAll;

  /// No description provided for @cardCollectionMyCollection.
  ///
  /// In ko, this message translates to:
  /// **'내 컬렉션'**
  String get cardCollectionMyCollection;

  /// No description provided for @cardCollectionCardCount.
  ///
  /// In ko, this message translates to:
  /// **'({count}장)'**
  String cardCollectionCardCount(int count);

  /// No description provided for @cardCollectionNoCards.
  ///
  /// In ko, this message translates to:
  /// **'보유한 카드가 없습니다.\n퀘스트를 완료하면 카드를 획득할 수 있습니다!'**
  String get cardCollectionNoCards;

  /// No description provided for @cardCollectionDeckInclusion.
  ///
  /// In ko, this message translates to:
  /// **'덱에 {copyCount}장 포함됨'**
  String cardCollectionDeckInclusion(int copyCount);

  /// No description provided for @cardCollectionAddToDeck.
  ///
  /// In ko, this message translates to:
  /// **'덱에 추가'**
  String get cardCollectionAddToDeck;

  /// No description provided for @cardCollectionDeckFull.
  ///
  /// In ko, this message translates to:
  /// **'덱이 가득 참 (20장)'**
  String get cardCollectionDeckFull;

  /// No description provided for @cardCollectionMaxCopies.
  ///
  /// In ko, this message translates to:
  /// **'최대 3장까지 추가 가능'**
  String get cardCollectionMaxCopies;

  /// No description provided for @cardCollectionAddedToDeck.
  ///
  /// In ko, this message translates to:
  /// **'{cardName} 덱에 추가됨'**
  String cardCollectionAddedToDeck(String cardName);

  /// No description provided for @cardCollectionMyDeck.
  ///
  /// In ko, this message translates to:
  /// **'내 덱'**
  String get cardCollectionMyDeck;

  /// No description provided for @cardCollectionDeckSize.
  ///
  /// In ko, this message translates to:
  /// **'({deckSize}/20장)'**
  String cardCollectionDeckSize(int deckSize);

  /// No description provided for @cardCollectionResetDeckDialog.
  ///
  /// In ko, this message translates to:
  /// **'덱 초기화'**
  String get cardCollectionResetDeckDialog;

  /// No description provided for @cardCollectionResetDeckConfirmation.
  ///
  /// In ko, this message translates to:
  /// **'커스텀 덱을 삭제하고 기본 스타터 덱으로 되돌리겠습니까?'**
  String get cardCollectionResetDeckConfirmation;

  /// No description provided for @cardCollectionResetButton.
  ///
  /// In ko, this message translates to:
  /// **'초기화'**
  String get cardCollectionResetButton;

  /// No description provided for @cardCollectionDefaultDeckMessage.
  ///
  /// In ko, this message translates to:
  /// **'기본 스타터 덱 사용 중\n컬렉션에서 카드를 추가하세요'**
  String get cardCollectionDefaultDeckMessage;

  /// No description provided for @cardNameBaseStrike.
  ///
  /// In ko, this message translates to:
  /// **'기본 공격'**
  String get cardNameBaseStrike;

  /// No description provided for @cardDescBaseStrike.
  ///
  /// In ko, this message translates to:
  /// **'6 데미지를 준다.'**
  String get cardDescBaseStrike;

  /// No description provided for @cardNameBaseDefend.
  ///
  /// In ko, this message translates to:
  /// **'기본 방어'**
  String get cardNameBaseDefend;

  /// No description provided for @cardDescBaseDefend.
  ///
  /// In ko, this message translates to:
  /// **'방어도 5를 얻는다.'**
  String get cardDescBaseDefend;

  /// No description provided for @cardNameBaseFocus.
  ///
  /// In ko, this message translates to:
  /// **'집중'**
  String get cardNameBaseFocus;

  /// No description provided for @cardDescBaseFocus.
  ///
  /// In ko, this message translates to:
  /// **'카드 1장을 드로우한다.'**
  String get cardDescBaseFocus;

  /// No description provided for @cardNameCursePain.
  ///
  /// In ko, this message translates to:
  /// **'고통'**
  String get cardNameCursePain;

  /// No description provided for @cardDescCursePain.
  ///
  /// In ko, this message translates to:
  /// **'사용 불가. 패에 잡히면 HP 1을 잃는다.'**
  String get cardDescCursePain;

  /// No description provided for @cardNameCurseDoubt.
  ///
  /// In ko, this message translates to:
  /// **'의심'**
  String get cardNameCurseDoubt;

  /// No description provided for @cardDescCurseDoubt.
  ///
  /// In ko, this message translates to:
  /// **'사용 불가. 패에 있으면 드로우 -1.'**
  String get cardDescCurseDoubt;

  /// No description provided for @cardNameCurseBurden.
  ///
  /// In ko, this message translates to:
  /// **'짐'**
  String get cardNameCurseBurden;

  /// No description provided for @cardDescCurseBurden.
  ///
  /// In ko, this message translates to:
  /// **'사용 불가. 패에 있으면 에너지 -1.'**
  String get cardDescCurseBurden;

  /// No description provided for @cardNameCurseDecay.
  ///
  /// In ko, this message translates to:
  /// **'부식'**
  String get cardNameCurseDecay;

  /// No description provided for @cardDescCurseDecay.
  ///
  /// In ko, this message translates to:
  /// **'사용 불가. 매 턴 방어 -3.'**
  String get cardDescCurseDecay;

  /// No description provided for @cardNameAtkC01.
  ///
  /// In ko, this message translates to:
  /// **'강타'**
  String get cardNameAtkC01;

  /// No description provided for @cardDescAtkC01.
  ///
  /// In ko, this message translates to:
  /// **'6 데미지를 준다.'**
  String get cardDescAtkC01;

  /// No description provided for @cardNameAtkC01Up.
  ///
  /// In ko, this message translates to:
  /// **'강타+'**
  String get cardNameAtkC01Up;

  /// No description provided for @cardDescAtkC01Up.
  ///
  /// In ko, this message translates to:
  /// **'9 데미지를 준다.'**
  String get cardDescAtkC01Up;

  /// No description provided for @cardNameAtkC02.
  ///
  /// In ko, this message translates to:
  /// **'베기'**
  String get cardNameAtkC02;

  /// No description provided for @cardDescAtkC02.
  ///
  /// In ko, this message translates to:
  /// **'4 데미지를 주고, 카드 1장을 드로우한다.'**
  String get cardDescAtkC02;

  /// No description provided for @cardNameAtkC02Up.
  ///
  /// In ko, this message translates to:
  /// **'베기+'**
  String get cardNameAtkC02Up;

  /// No description provided for @cardDescAtkC02Up.
  ///
  /// In ko, this message translates to:
  /// **'6 데미지를 주고, 카드 1장을 드로우한다.'**
  String get cardDescAtkC02Up;

  /// No description provided for @cardNameAtkC03.
  ///
  /// In ko, this message translates to:
  /// **'연속 공격'**
  String get cardNameAtkC03;

  /// No description provided for @cardDescAtkC03.
  ///
  /// In ko, this message translates to:
  /// **'3 데미지를 2회 준다.'**
  String get cardDescAtkC03;

  /// No description provided for @cardNameAtkC03Up.
  ///
  /// In ko, this message translates to:
  /// **'연속 공격+'**
  String get cardNameAtkC03Up;

  /// No description provided for @cardDescAtkC03Up.
  ///
  /// In ko, this message translates to:
  /// **'3 데미지를 3회 준다.'**
  String get cardDescAtkC03Up;

  /// No description provided for @cardNameAtkC04.
  ///
  /// In ko, this message translates to:
  /// **'분노의 일격'**
  String get cardNameAtkC04;

  /// No description provided for @cardDescAtkC04.
  ///
  /// In ko, this message translates to:
  /// **'3 데미지를 주고, 분노 카드 1장을 디스카드에 추가한다.'**
  String get cardDescAtkC04;

  /// No description provided for @cardNameAtkC04Up.
  ///
  /// In ko, this message translates to:
  /// **'분노의 일격+'**
  String get cardNameAtkC04Up;

  /// No description provided for @cardDescAtkC04Up.
  ///
  /// In ko, this message translates to:
  /// **'5 데미지를 준다.'**
  String get cardDescAtkC04Up;

  /// No description provided for @cardNameAtkC05.
  ///
  /// In ko, this message translates to:
  /// **'돌진'**
  String get cardNameAtkC05;

  /// No description provided for @cardDescAtkC05.
  ///
  /// In ko, this message translates to:
  /// **'12 데미지를 준다.'**
  String get cardDescAtkC05;

  /// No description provided for @cardNameAtkC05Up.
  ///
  /// In ko, this message translates to:
  /// **'돌진+'**
  String get cardNameAtkC05Up;

  /// No description provided for @cardDescAtkC05Up.
  ///
  /// In ko, this message translates to:
  /// **'16 데미지를 준다.'**
  String get cardDescAtkC05Up;

  /// No description provided for @cardNameAtkC06.
  ///
  /// In ko, this message translates to:
  /// **'출혈 공격'**
  String get cardNameAtkC06;

  /// No description provided for @cardDescAtkC06.
  ///
  /// In ko, this message translates to:
  /// **'4 데미지를 주고, 독 2를 부여한다.'**
  String get cardDescAtkC06;

  /// No description provided for @cardNameAtkC06Up.
  ///
  /// In ko, this message translates to:
  /// **'출혈 공격+'**
  String get cardNameAtkC06Up;

  /// No description provided for @cardDescAtkC06Up.
  ///
  /// In ko, this message translates to:
  /// **'4 데미지를 주고, 독 4를 부여한다.'**
  String get cardDescAtkC06Up;

  /// No description provided for @cardNameAtkC07.
  ///
  /// In ko, this message translates to:
  /// **'빠른 찌르기'**
  String get cardNameAtkC07;

  /// No description provided for @cardDescAtkC07.
  ///
  /// In ko, this message translates to:
  /// **'3 데미지를 준다.'**
  String get cardDescAtkC07;

  /// No description provided for @cardNameAtkC07Up.
  ///
  /// In ko, this message translates to:
  /// **'빠른 찌르기+'**
  String get cardNameAtkC07Up;

  /// No description provided for @cardDescAtkC07Up.
  ///
  /// In ko, this message translates to:
  /// **'5 데미지를 준다.'**
  String get cardDescAtkC07Up;

  /// No description provided for @cardNameAtkC08.
  ///
  /// In ko, this message translates to:
  /// **'도발'**
  String get cardNameAtkC08;

  /// No description provided for @cardDescAtkC08.
  ///
  /// In ko, this message translates to:
  /// **'5 데미지를 주고, 취약 1턴을 부여한다.'**
  String get cardDescAtkC08;

  /// No description provided for @cardNameAtkC08Up.
  ///
  /// In ko, this message translates to:
  /// **'도발+'**
  String get cardNameAtkC08Up;

  /// No description provided for @cardDescAtkC08Up.
  ///
  /// In ko, this message translates to:
  /// **'8 데미지를 주고, 취약 1턴을 부여한다.'**
  String get cardDescAtkC08Up;

  /// No description provided for @cardNameAtkC09.
  ///
  /// In ko, this message translates to:
  /// **'기습'**
  String get cardNameAtkC09;

  /// No description provided for @cardDescAtkC09.
  ///
  /// In ko, this message translates to:
  /// **'첫 턴이면 12 데미지, 아니면 6 데미지.'**
  String get cardDescAtkC09;

  /// No description provided for @cardNameAtkC09Up.
  ///
  /// In ko, this message translates to:
  /// **'기습+'**
  String get cardNameAtkC09Up;

  /// No description provided for @cardDescAtkC09Up.
  ///
  /// In ko, this message translates to:
  /// **'첫 턴이면 18 데미지, 아니면 9 데미지.'**
  String get cardDescAtkC09Up;

  /// No description provided for @cardNameAtkC10.
  ///
  /// In ko, this message translates to:
  /// **'칼날 바람'**
  String get cardNameAtkC10;

  /// No description provided for @cardDescAtkC10.
  ///
  /// In ko, this message translates to:
  /// **'적 전체에 3 데미지를 준다.'**
  String get cardDescAtkC10;

  /// No description provided for @cardNameAtkC10Up.
  ///
  /// In ko, this message translates to:
  /// **'칼날 바람+'**
  String get cardNameAtkC10Up;

  /// No description provided for @cardDescAtkC10Up.
  ///
  /// In ko, this message translates to:
  /// **'적 전체에 5 데미지를 준다.'**
  String get cardDescAtkC10Up;

  /// No description provided for @cardNameAtkU01.
  ///
  /// In ko, this message translates to:
  /// **'파워 슬래시'**
  String get cardNameAtkU01;

  /// No description provided for @cardDescAtkU01.
  ///
  /// In ko, this message translates to:
  /// **'14 데미지를 주고, 취약 2턴을 부여한다.'**
  String get cardDescAtkU01;

  /// No description provided for @cardNameAtkU01Up.
  ///
  /// In ko, this message translates to:
  /// **'파워 슬래시+'**
  String get cardNameAtkU01Up;

  /// No description provided for @cardDescAtkU01Up.
  ///
  /// In ko, this message translates to:
  /// **'18 데미지를 주고, 취약 2턴을 부여한다.'**
  String get cardDescAtkU01Up;

  /// No description provided for @cardNameAtkU02.
  ///
  /// In ko, this message translates to:
  /// **'칼날 춤'**
  String get cardNameAtkU02;

  /// No description provided for @cardDescAtkU02.
  ///
  /// In ko, this message translates to:
  /// **'3 데미지를 3회 주고, 방어도 3을 얻는다.'**
  String get cardDescAtkU02;

  /// No description provided for @cardNameAtkU02Up.
  ///
  /// In ko, this message translates to:
  /// **'칼날 춤+'**
  String get cardNameAtkU02Up;

  /// No description provided for @cardDescAtkU02Up.
  ///
  /// In ko, this message translates to:
  /// **'4 데미지를 3회 주고, 방어도 5를 얻는다.'**
  String get cardDescAtkU02Up;

  /// No description provided for @cardNameAtkU03.
  ///
  /// In ko, this message translates to:
  /// **'처형'**
  String get cardNameAtkU03;

  /// No description provided for @cardDescAtkU03.
  ///
  /// In ko, this message translates to:
  /// **'적 HP 50% 이하면 30 데미지, 아니면 10 데미지.'**
  String get cardDescAtkU03;

  /// No description provided for @cardNameAtkU03Up.
  ///
  /// In ko, this message translates to:
  /// **'처형+'**
  String get cardNameAtkU03Up;

  /// No description provided for @cardDescAtkU03Up.
  ///
  /// In ko, this message translates to:
  /// **'적 HP 50% 이하면 40 데미지, 아니면 14 데미지.'**
  String get cardDescAtkU03Up;

  /// No description provided for @cardNameAtkU04.
  ///
  /// In ko, this message translates to:
  /// **'광폭화'**
  String get cardNameAtkU04;

  /// No description provided for @cardDescAtkU04.
  ///
  /// In ko, this message translates to:
  /// **'힘 +2를 획득한다 (영구).'**
  String get cardDescAtkU04;

  /// No description provided for @cardNameAtkU04Up.
  ///
  /// In ko, this message translates to:
  /// **'광폭화+'**
  String get cardNameAtkU04Up;

  /// No description provided for @cardDescAtkU04Up.
  ///
  /// In ko, this message translates to:
  /// **'힘 +3을 획득한다 (영구).'**
  String get cardDescAtkU04Up;

  /// No description provided for @cardNameAtkU05.
  ///
  /// In ko, this message translates to:
  /// **'피의 맹세'**
  String get cardNameAtkU05;

  /// No description provided for @cardDescAtkU05.
  ///
  /// In ko, this message translates to:
  /// **'HP 3을 잃고, 8 데미지를 주고, 힘 +1을 얻는다.'**
  String get cardDescAtkU05;

  /// No description provided for @cardNameAtkU05Up.
  ///
  /// In ko, this message translates to:
  /// **'피의 맹세+'**
  String get cardNameAtkU05Up;

  /// No description provided for @cardDescAtkU05Up.
  ///
  /// In ko, this message translates to:
  /// **'HP 3을 잃고, 12 데미지를 주고, 힘 +1을 얻는다.'**
  String get cardDescAtkU05Up;

  /// No description provided for @cardNameAtkU06.
  ///
  /// In ko, this message translates to:
  /// **'회전 베기'**
  String get cardNameAtkU06;

  /// No description provided for @cardDescAtkU06.
  ///
  /// In ko, this message translates to:
  /// **'적 전체에 8 데미지를 준다.'**
  String get cardDescAtkU06;

  /// No description provided for @cardNameAtkU06Up.
  ///
  /// In ko, this message translates to:
  /// **'회전 베기+'**
  String get cardNameAtkU06Up;

  /// No description provided for @cardDescAtkU06Up.
  ///
  /// In ko, this message translates to:
  /// **'적 전체에 12 데미지를 준다.'**
  String get cardDescAtkU06Up;

  /// No description provided for @cardNameAtkU07.
  ///
  /// In ko, this message translates to:
  /// **'분쇄'**
  String get cardNameAtkU07;

  /// No description provided for @cardDescAtkU07.
  ///
  /// In ko, this message translates to:
  /// **'10 데미지를 주고, 약화 2턴을 부여한다.'**
  String get cardDescAtkU07;

  /// No description provided for @cardNameAtkU07Up.
  ///
  /// In ko, this message translates to:
  /// **'분쇄+'**
  String get cardNameAtkU07Up;

  /// No description provided for @cardDescAtkU07Up.
  ///
  /// In ko, this message translates to:
  /// **'14 데미지를 주고, 약화 2턴을 부여한다.'**
  String get cardDescAtkU07Up;

  /// No description provided for @cardNameAtkU08.
  ///
  /// In ko, this message translates to:
  /// **'무자비'**
  String get cardNameAtkU08;

  /// No description provided for @cardDescAtkU08.
  ///
  /// In ko, this message translates to:
  /// **'취약 상태 적에게 데미지 2배 (기본 6 데미지).'**
  String get cardDescAtkU08;

  /// No description provided for @cardNameAtkU08Up.
  ///
  /// In ko, this message translates to:
  /// **'무자비+'**
  String get cardNameAtkU08Up;

  /// No description provided for @cardDescAtkU08Up.
  ///
  /// In ko, this message translates to:
  /// **'취약 상태 적에게 데미지 2배 (기본 9 데미지).'**
  String get cardDescAtkU08Up;

  /// No description provided for @cardNameAtkR01.
  ///
  /// In ko, this message translates to:
  /// **'용의 일격'**
  String get cardNameAtkR01;

  /// No description provided for @cardDescAtkR01.
  ///
  /// In ko, this message translates to:
  /// **'30 데미지를 주고, 화상 3턴을 부여한다.'**
  String get cardDescAtkR01;

  /// No description provided for @cardNameAtkR01Up.
  ///
  /// In ko, this message translates to:
  /// **'용의 일격+'**
  String get cardNameAtkR01Up;

  /// No description provided for @cardDescAtkR01Up.
  ///
  /// In ko, this message translates to:
  /// **'40 데미지를 주고, 화상 4턴을 부여한다.'**
  String get cardDescAtkR01Up;

  /// No description provided for @cardNameAtkR02.
  ///
  /// In ko, this message translates to:
  /// **'천 번의 베기'**
  String get cardNameAtkR02;

  /// No description provided for @cardDescAtkR02.
  ///
  /// In ko, this message translates to:
  /// **'1 데미지를 패에 든 카드 수만큼 준다.'**
  String get cardDescAtkR02;

  /// No description provided for @cardNameAtkR02Up.
  ///
  /// In ko, this message translates to:
  /// **'천 번의 베기+'**
  String get cardNameAtkR02Up;

  /// No description provided for @cardDescAtkR02Up.
  ///
  /// In ko, this message translates to:
  /// **'2 데미지를 패에 든 카드 수만큼 준다.'**
  String get cardDescAtkR02Up;

  /// No description provided for @cardNameAtkR03.
  ///
  /// In ko, this message translates to:
  /// **'폭풍의 검'**
  String get cardNameAtkR03;

  /// No description provided for @cardDescAtkR03.
  ///
  /// In ko, this message translates to:
  /// **'5 데미지를 이번 턴 사용한 카드 수만큼 준다.'**
  String get cardDescAtkR03;

  /// No description provided for @cardNameAtkR03Up.
  ///
  /// In ko, this message translates to:
  /// **'폭풍의 검+'**
  String get cardNameAtkR03Up;

  /// No description provided for @cardDescAtkR03Up.
  ///
  /// In ko, this message translates to:
  /// **'7 데미지를 이번 턴 사용한 카드 수만큼 준다.'**
  String get cardDescAtkR03Up;

  /// No description provided for @cardNameAtkR04.
  ///
  /// In ko, this message translates to:
  /// **'사신의 낫'**
  String get cardNameAtkR04;

  /// No description provided for @cardDescAtkR04.
  ///
  /// In ko, this message translates to:
  /// **'15 데미지를 주고, 킬 시 HP 10을 회복한다.'**
  String get cardDescAtkR04;

  /// No description provided for @cardNameAtkR04Up.
  ///
  /// In ko, this message translates to:
  /// **'사신의 낫+'**
  String get cardNameAtkR04Up;

  /// No description provided for @cardDescAtkR04Up.
  ///
  /// In ko, this message translates to:
  /// **'20 데미지를 주고, 킬 시 HP 15를 회복한다.'**
  String get cardDescAtkR04Up;

  /// No description provided for @cardNameAtkR05.
  ///
  /// In ko, this message translates to:
  /// **'버서크'**
  String get cardNameAtkR05;

  /// No description provided for @cardDescAtkR05.
  ///
  /// In ko, this message translates to:
  /// **'힘 +5를 얻는다. 3턴 뒤 힘 -5.'**
  String get cardDescAtkR05;

  /// No description provided for @cardNameAtkR05Up.
  ///
  /// In ko, this message translates to:
  /// **'버서크+'**
  String get cardNameAtkR05Up;

  /// No description provided for @cardDescAtkR05Up.
  ///
  /// In ko, this message translates to:
  /// **'힘 +7을 얻는다. 3턴 뒤 힘 -5.'**
  String get cardDescAtkR05Up;

  /// No description provided for @cardNameAtkL01.
  ///
  /// In ko, this message translates to:
  /// **'엑스칼리버'**
  String get cardNameAtkL01;

  /// No description provided for @cardDescAtkL01.
  ///
  /// In ko, this message translates to:
  /// **'50 데미지를 주고, 취약+약화 3턴을 부여한다. 사용 후 소멸.'**
  String get cardDescAtkL01;

  /// No description provided for @cardNameAtkL01Up.
  ///
  /// In ko, this message translates to:
  /// **'엑스칼리버+'**
  String get cardNameAtkL01Up;

  /// No description provided for @cardDescAtkL01Up.
  ///
  /// In ko, this message translates to:
  /// **'60 데미지를 주고, 취약+약화 3턴을 부여한다. 사용 후 소멸.'**
  String get cardDescAtkL01Up;

  /// No description provided for @cardNameAtkL02.
  ///
  /// In ko, this message translates to:
  /// **'무한의 칼날'**
  String get cardNameAtkL02;

  /// No description provided for @cardDescAtkL02.
  ///
  /// In ko, this message translates to:
  /// **'8 데미지를 준다. 사용 시 이 카드 영구 +2 데미지.'**
  String get cardDescAtkL02;

  /// No description provided for @cardNameAtkL02Up.
  ///
  /// In ko, this message translates to:
  /// **'무한의 칼날+'**
  String get cardNameAtkL02Up;

  /// No description provided for @cardDescAtkL02Up.
  ///
  /// In ko, this message translates to:
  /// **'12 데미지를 준다. 사용 시 이 카드 영구 +2 데미지.'**
  String get cardDescAtkL02Up;

  /// No description provided for @cardNameMagC01.
  ///
  /// In ko, this message translates to:
  /// **'화염탄'**
  String get cardNameMagC01;

  /// No description provided for @cardDescMagC01.
  ///
  /// In ko, this message translates to:
  /// **'4 데미지를 주고, 화상 2턴을 부여한다.'**
  String get cardDescMagC01;

  /// No description provided for @cardNameMagC01Up.
  ///
  /// In ko, this message translates to:
  /// **'화염탄+'**
  String get cardNameMagC01Up;

  /// No description provided for @cardDescMagC01Up.
  ///
  /// In ko, this message translates to:
  /// **'6 데미지를 주고, 화상 3턴을 부여한다.'**
  String get cardDescMagC01Up;

  /// No description provided for @cardNameMagC02.
  ///
  /// In ko, this message translates to:
  /// **'서리 화살'**
  String get cardNameMagC02;

  /// No description provided for @cardDescMagC02.
  ///
  /// In ko, this message translates to:
  /// **'5 데미지를 주고, 약화 1턴을 부여한다.'**
  String get cardDescMagC02;

  /// No description provided for @cardNameMagC02Up.
  ///
  /// In ko, this message translates to:
  /// **'서리 화살+'**
  String get cardNameMagC02Up;

  /// No description provided for @cardDescMagC02Up.
  ///
  /// In ko, this message translates to:
  /// **'8 데미지를 주고, 약화 1턴을 부여한다.'**
  String get cardDescMagC02Up;

  /// No description provided for @cardNameMagC03.
  ///
  /// In ko, this message translates to:
  /// **'마나 집중'**
  String get cardNameMagC03;

  /// No description provided for @cardDescMagC03.
  ///
  /// In ko, this message translates to:
  /// **'에너지 +1, 카드 1장을 드로우한다.'**
  String get cardDescMagC03;

  /// No description provided for @cardNameMagC03Up.
  ///
  /// In ko, this message translates to:
  /// **'마나 집중+'**
  String get cardNameMagC03Up;

  /// No description provided for @cardDescMagC03Up.
  ///
  /// In ko, this message translates to:
  /// **'에너지 +1, 카드 2장을 드로우한다.'**
  String get cardDescMagC03Up;

  /// No description provided for @cardNameMagC04.
  ///
  /// In ko, this message translates to:
  /// **'전기 충격'**
  String get cardNameMagC04;

  /// No description provided for @cardDescMagC04.
  ///
  /// In ko, this message translates to:
  /// **'7 데미지를 준다 (랜덤 적).'**
  String get cardDescMagC04;

  /// No description provided for @cardNameMagC04Up.
  ///
  /// In ko, this message translates to:
  /// **'전기 충격+'**
  String get cardNameMagC04Up;

  /// No description provided for @cardDescMagC04Up.
  ///
  /// In ko, this message translates to:
  /// **'10 데미지를 준다 (랜덤 적).'**
  String get cardDescMagC04Up;

  /// No description provided for @cardNameMagC05.
  ///
  /// In ko, this message translates to:
  /// **'마법 화살'**
  String get cardNameMagC05;

  /// No description provided for @cardDescMagC05.
  ///
  /// In ko, this message translates to:
  /// **'4 데미지를 2회 준다 (랜덤 대상).'**
  String get cardDescMagC05;

  /// No description provided for @cardNameMagC05Up.
  ///
  /// In ko, this message translates to:
  /// **'마법 화살+'**
  String get cardNameMagC05Up;

  /// No description provided for @cardDescMagC05Up.
  ///
  /// In ko, this message translates to:
  /// **'4 데미지를 3회 준다 (랜덤 대상).'**
  String get cardDescMagC05Up;

  /// No description provided for @cardNameMagC06.
  ///
  /// In ko, this message translates to:
  /// **'명상'**
  String get cardNameMagC06;

  /// No description provided for @cardDescMagC06.
  ///
  /// In ko, this message translates to:
  /// **'카드 2장을 드로우한다.'**
  String get cardDescMagC06;

  /// No description provided for @cardNameMagC06Up.
  ///
  /// In ko, this message translates to:
  /// **'명상+'**
  String get cardNameMagC06Up;

  /// No description provided for @cardDescMagC06Up.
  ///
  /// In ko, this message translates to:
  /// **'카드 3장을 드로우한다.'**
  String get cardDescMagC06Up;

  /// No description provided for @cardNameMagC07.
  ///
  /// In ko, this message translates to:
  /// **'지식의 빛'**
  String get cardNameMagC07;

  /// No description provided for @cardDescMagC07.
  ///
  /// In ko, this message translates to:
  /// **'드로우 파일 상위 3장을 확인하고, 1장을 패로 가져온다.'**
  String get cardDescMagC07;

  /// No description provided for @cardNameMagC07Up.
  ///
  /// In ko, this message translates to:
  /// **'지식의 빛+'**
  String get cardNameMagC07Up;

  /// No description provided for @cardDescMagC07Up.
  ///
  /// In ko, this message translates to:
  /// **'드로우 파일 상위 3장 중 2장을 패로 가져온다.'**
  String get cardDescMagC07Up;

  /// No description provided for @cardNameMagC08.
  ///
  /// In ko, this message translates to:
  /// **'독안개'**
  String get cardNameMagC08;

  /// No description provided for @cardDescMagC08.
  ///
  /// In ko, this message translates to:
  /// **'적 전체에 독 3을 부여한다.'**
  String get cardDescMagC08;

  /// No description provided for @cardNameMagC08Up.
  ///
  /// In ko, this message translates to:
  /// **'독안개+'**
  String get cardNameMagC08Up;

  /// No description provided for @cardDescMagC08Up.
  ///
  /// In ko, this message translates to:
  /// **'적 전체에 독 5를 부여한다.'**
  String get cardDescMagC08Up;

  /// No description provided for @cardNameMagC09.
  ///
  /// In ko, this message translates to:
  /// **'마력 폭발'**
  String get cardNameMagC09;

  /// No description provided for @cardDescMagC09.
  ///
  /// In ko, this message translates to:
  /// **'10 데미지를 주고, 집중 +1을 얻는다.'**
  String get cardDescMagC09;

  /// No description provided for @cardNameMagC09Up.
  ///
  /// In ko, this message translates to:
  /// **'마력 폭발+'**
  String get cardNameMagC09Up;

  /// No description provided for @cardDescMagC09Up.
  ///
  /// In ko, this message translates to:
  /// **'14 데미지를 주고, 집중 +1을 얻는다.'**
  String get cardDescMagC09Up;

  /// No description provided for @cardNameMagC10.
  ///
  /// In ko, this message translates to:
  /// **'원소 조화'**
  String get cardNameMagC10;

  /// No description provided for @cardDescMagC10.
  ///
  /// In ko, this message translates to:
  /// **'다음 카드 효과를 50% 증가시킨다.'**
  String get cardDescMagC10;

  /// No description provided for @cardNameMagC10Up.
  ///
  /// In ko, this message translates to:
  /// **'원소 조화+'**
  String get cardNameMagC10Up;

  /// No description provided for @cardDescMagC10Up.
  ///
  /// In ko, this message translates to:
  /// **'다음 카드 효과를 100% 증가시킨다.'**
  String get cardDescMagC10Up;

  /// No description provided for @cardNameMagU01.
  ///
  /// In ko, this message translates to:
  /// **'연쇄 번개'**
  String get cardNameMagU01;

  /// No description provided for @cardDescMagU01.
  ///
  /// In ko, this message translates to:
  /// **'8 데미지를 주고, 적 전체에 4 데미지를 준다.'**
  String get cardDescMagU01;

  /// No description provided for @cardNameMagU01Up.
  ///
  /// In ko, this message translates to:
  /// **'연쇄 번개+'**
  String get cardNameMagU01Up;

  /// No description provided for @cardDescMagU01Up.
  ///
  /// In ko, this message translates to:
  /// **'12 데미지를 주고, 적 전체에 6 데미지를 준다.'**
  String get cardDescMagU01Up;

  /// No description provided for @cardNameMagU02.
  ///
  /// In ko, this message translates to:
  /// **'빙결의 눈'**
  String get cardNameMagU02;

  /// No description provided for @cardDescMagU02.
  ///
  /// In ko, this message translates to:
  /// **'12 데미지를 주고, 빙결 1회를 부여한다.'**
  String get cardDescMagU02;

  /// No description provided for @cardNameMagU02Up.
  ///
  /// In ko, this message translates to:
  /// **'빙결의 눈+'**
  String get cardNameMagU02Up;

  /// No description provided for @cardDescMagU02Up.
  ///
  /// In ko, this message translates to:
  /// **'16 데미지를 주고, 빙결 1회를 부여한다.'**
  String get cardDescMagU02Up;

  /// No description provided for @cardNameMagU03.
  ///
  /// In ko, this message translates to:
  /// **'지혜의 책'**
  String get cardNameMagU03;

  /// No description provided for @cardDescMagU03.
  ///
  /// In ko, this message translates to:
  /// **'카드 3장을 드로우하고, 1장을 소멸시킨다.'**
  String get cardDescMagU03;

  /// No description provided for @cardNameMagU03Up.
  ///
  /// In ko, this message translates to:
  /// **'지혜의 책+'**
  String get cardNameMagU03Up;

  /// No description provided for @cardDescMagU03Up.
  ///
  /// In ko, this message translates to:
  /// **'카드 4장을 드로우한다.'**
  String get cardDescMagU03Up;

  /// No description provided for @cardNameMagU04.
  ///
  /// In ko, this message translates to:
  /// **'마나 과부하'**
  String get cardNameMagU04;

  /// No description provided for @cardDescMagU04.
  ///
  /// In ko, this message translates to:
  /// **'에너지 +2를 얻는다. 다음 턴 에너지 -1.'**
  String get cardDescMagU04;

  /// No description provided for @cardNameMagU04Up.
  ///
  /// In ko, this message translates to:
  /// **'마나 과부하+'**
  String get cardNameMagU04Up;

  /// No description provided for @cardDescMagU04Up.
  ///
  /// In ko, this message translates to:
  /// **'에너지 +3을 얻는다.'**
  String get cardDescMagU04Up;

  /// No description provided for @cardNameMagU05.
  ///
  /// In ko, this message translates to:
  /// **'원소 폭풍'**
  String get cardNameMagU05;

  /// No description provided for @cardDescMagU05.
  ///
  /// In ko, this message translates to:
  /// **'적 전체에 15 데미지를 준다.'**
  String get cardDescMagU05;

  /// No description provided for @cardNameMagU05Up.
  ///
  /// In ko, this message translates to:
  /// **'원소 폭풍+'**
  String get cardNameMagU05Up;

  /// No description provided for @cardDescMagU05Up.
  ///
  /// In ko, this message translates to:
  /// **'적 전체에 20 데미지를 준다.'**
  String get cardDescMagU05Up;

  /// No description provided for @cardNameMagU06.
  ///
  /// In ko, this message translates to:
  /// **'시간 왜곡'**
  String get cardNameMagU06;

  /// No description provided for @cardDescMagU06.
  ///
  /// In ko, this message translates to:
  /// **'추가 턴 1회를 얻는다 (에너지 0, 카드 유지).'**
  String get cardDescMagU06;

  /// No description provided for @cardNameMagU06Up.
  ///
  /// In ko, this message translates to:
  /// **'시간 왜곡+'**
  String get cardNameMagU06Up;

  /// No description provided for @cardDescMagU06Up.
  ///
  /// In ko, this message translates to:
  /// **'추가 턴 1회를 얻는다 (에너지 1로 시작).'**
  String get cardDescMagU06Up;

  /// No description provided for @cardNameMagU07.
  ///
  /// In ko, this message translates to:
  /// **'마법 증폭'**
  String get cardNameMagU07;

  /// No description provided for @cardDescMagU07.
  ///
  /// In ko, this message translates to:
  /// **'집중 +2를 얻는다 (영구).'**
  String get cardDescMagU07;

  /// No description provided for @cardNameMagU07Up.
  ///
  /// In ko, this message translates to:
  /// **'마법 증폭+'**
  String get cardNameMagU07Up;

  /// No description provided for @cardDescMagU07Up.
  ///
  /// In ko, this message translates to:
  /// **'집중 +3을 얻는다 (영구).'**
  String get cardDescMagU07Up;

  /// No description provided for @cardNameMagU08.
  ///
  /// In ko, this message translates to:
  /// **'복제술'**
  String get cardNameMagU08;

  /// No description provided for @cardDescMagU08.
  ///
  /// In ko, this message translates to:
  /// **'패의 카드 1장을 복사한다 (이번 턴만).'**
  String get cardDescMagU08;

  /// No description provided for @cardNameMagU08Up.
  ///
  /// In ko, this message translates to:
  /// **'복제술+'**
  String get cardNameMagU08Up;

  /// No description provided for @cardDescMagU08Up.
  ///
  /// In ko, this message translates to:
  /// **'패의 카드 1장을 비용 0으로 복사한다 (이번 턴만).'**
  String get cardDescMagU08Up;

  /// No description provided for @cardNameMagR01.
  ///
  /// In ko, this message translates to:
  /// **'메테오'**
  String get cardNameMagR01;

  /// No description provided for @cardDescMagR01.
  ///
  /// In ko, this message translates to:
  /// **'적 전체에 25 데미지를 주고, 화상 3턴을 부여한다.'**
  String get cardDescMagR01;

  /// No description provided for @cardNameMagR01Up.
  ///
  /// In ko, this message translates to:
  /// **'메테오+'**
  String get cardNameMagR01Up;

  /// No description provided for @cardDescMagR01Up.
  ///
  /// In ko, this message translates to:
  /// **'적 전체에 35 데미지를 주고, 화상 3턴을 부여한다.'**
  String get cardDescMagR01Up;

  /// No description provided for @cardNameMagR02.
  ///
  /// In ko, this message translates to:
  /// **'마나 폭주'**
  String get cardNameMagR02;

  /// No description provided for @cardDescMagR02.
  ///
  /// In ko, this message translates to:
  /// **'패의 모든 카드 비용이 이번 턴 0이 된다.'**
  String get cardDescMagR02;

  /// No description provided for @cardNameMagR02Up.
  ///
  /// In ko, this message translates to:
  /// **'마나 폭주+'**
  String get cardNameMagR02Up;

  /// No description provided for @cardDescMagR02Up.
  ///
  /// In ko, this message translates to:
  /// **'패의 모든 카드 비용이 다음 턴까지 0이 된다.'**
  String get cardDescMagR02Up;

  /// No description provided for @cardNameMagR03.
  ///
  /// In ko, this message translates to:
  /// **'차원의 균열'**
  String get cardNameMagR03;

  /// No description provided for @cardDescMagR03.
  ///
  /// In ko, this message translates to:
  /// **'디스카드 파일에서 3장을 패로 가져온다.'**
  String get cardDescMagR03;

  /// No description provided for @cardNameMagR03Up.
  ///
  /// In ko, this message translates to:
  /// **'차원의 균열+'**
  String get cardNameMagR03Up;

  /// No description provided for @cardDescMagR03Up.
  ///
  /// In ko, this message translates to:
  /// **'디스카드 파일에서 5장을 패로 가져온다.'**
  String get cardDescMagR03Up;

  /// No description provided for @cardNameMagR04.
  ///
  /// In ko, this message translates to:
  /// **'영혼 흡수'**
  String get cardNameMagR04;

  /// No description provided for @cardDescMagR04.
  ///
  /// In ko, this message translates to:
  /// **'12 데미지를 주고, 같은 양 HP를 회복한다.'**
  String get cardDescMagR04;

  /// No description provided for @cardNameMagR04Up.
  ///
  /// In ko, this message translates to:
  /// **'영혼 흡수+'**
  String get cardNameMagR04Up;

  /// No description provided for @cardDescMagR04Up.
  ///
  /// In ko, this message translates to:
  /// **'18 데미지를 주고, 같은 양 HP를 회복한다.'**
  String get cardDescMagR04Up;

  /// No description provided for @cardNameMagR05.
  ///
  /// In ko, this message translates to:
  /// **'절대영도'**
  String get cardNameMagR05;

  /// No description provided for @cardDescMagR05.
  ///
  /// In ko, this message translates to:
  /// **'적 전체를 빙결시키고, 10 데미지를 준다.'**
  String get cardDescMagR05;

  /// No description provided for @cardNameMagR05Up.
  ///
  /// In ko, this message translates to:
  /// **'절대영도+'**
  String get cardNameMagR05Up;

  /// No description provided for @cardDescMagR05Up.
  ///
  /// In ko, this message translates to:
  /// **'적 전체를 빙결시키고, 15 데미지를 준다.'**
  String get cardDescMagR05Up;

  /// No description provided for @cardNameMagL01.
  ///
  /// In ko, this message translates to:
  /// **'아마겟돈'**
  String get cardNameMagL01;

  /// No description provided for @cardDescMagL01.
  ///
  /// In ko, this message translates to:
  /// **'적 전체에 99 데미지를 준다. 자신도 30 데미지. 사용 후 소멸.'**
  String get cardDescMagL01;

  /// No description provided for @cardNameMagL01Up.
  ///
  /// In ko, this message translates to:
  /// **'아마겟돈+'**
  String get cardNameMagL01Up;

  /// No description provided for @cardDescMagL01Up.
  ///
  /// In ko, this message translates to:
  /// **'적 전체에 99 데미지를 준다. 자신 15 데미지. 사용 후 소멸.'**
  String get cardDescMagL01Up;

  /// No description provided for @cardNameMagL02.
  ///
  /// In ko, this message translates to:
  /// **'무한의 지혜'**
  String get cardNameMagL02;

  /// No description provided for @cardDescMagL02.
  ///
  /// In ko, this message translates to:
  /// **'카드 5장을 드로우하고, 에너지 +2를 얻는다. 사용 후 소멸.'**
  String get cardDescMagL02;

  /// No description provided for @cardNameMagL02Up.
  ///
  /// In ko, this message translates to:
  /// **'무한의 지혜+'**
  String get cardNameMagL02Up;

  /// No description provided for @cardDescMagL02Up.
  ///
  /// In ko, this message translates to:
  /// **'카드 7장을 드로우하고, 에너지 +3을 얻는다. 사용 후 소멸.'**
  String get cardDescMagL02Up;

  /// No description provided for @cardNameDefC01.
  ///
  /// In ko, this message translates to:
  /// **'방어'**
  String get cardNameDefC01;

  /// No description provided for @cardDescDefC01.
  ///
  /// In ko, this message translates to:
  /// **'방어도 5를 얻는다.'**
  String get cardDescDefC01;

  /// No description provided for @cardNameDefC01Up.
  ///
  /// In ko, this message translates to:
  /// **'방어+'**
  String get cardNameDefC01Up;

  /// No description provided for @cardDescDefC01Up.
  ///
  /// In ko, this message translates to:
  /// **'방어도 8을 얻는다.'**
  String get cardDescDefC01Up;

  /// No description provided for @cardNameDefC02.
  ///
  /// In ko, this message translates to:
  /// **'철벽'**
  String get cardNameDefC02;

  /// No description provided for @cardDescDefC02.
  ///
  /// In ko, this message translates to:
  /// **'방어도 12를 얻는다.'**
  String get cardDescDefC02;

  /// No description provided for @cardNameDefC02Up.
  ///
  /// In ko, this message translates to:
  /// **'철벽+'**
  String get cardNameDefC02Up;

  /// No description provided for @cardDescDefC02Up.
  ///
  /// In ko, this message translates to:
  /// **'방어도 16을 얻는다.'**
  String get cardDescDefC02Up;

  /// No description provided for @cardNameDefC03.
  ///
  /// In ko, this message translates to:
  /// **'반격'**
  String get cardNameDefC03;

  /// No description provided for @cardDescDefC03.
  ///
  /// In ko, this message translates to:
  /// **'방어도 4를 얻고, 가시 2를 얻는다.'**
  String get cardDescDefC03;

  /// No description provided for @cardNameDefC03Up.
  ///
  /// In ko, this message translates to:
  /// **'반격+'**
  String get cardNameDefC03Up;

  /// No description provided for @cardDescDefC03Up.
  ///
  /// In ko, this message translates to:
  /// **'방어도 6을 얻고, 가시 3을 얻는다.'**
  String get cardDescDefC03Up;

  /// No description provided for @cardNameDefC04.
  ///
  /// In ko, this message translates to:
  /// **'회복 기도'**
  String get cardNameDefC04;

  /// No description provided for @cardDescDefC04.
  ///
  /// In ko, this message translates to:
  /// **'HP 4를 회복한다.'**
  String get cardDescDefC04;

  /// No description provided for @cardNameDefC04Up.
  ///
  /// In ko, this message translates to:
  /// **'회복 기도+'**
  String get cardNameDefC04Up;

  /// No description provided for @cardDescDefC04Up.
  ///
  /// In ko, this message translates to:
  /// **'HP 7을 회복한다.'**
  String get cardDescDefC04Up;

  /// No description provided for @cardNameDefC05.
  ///
  /// In ko, this message translates to:
  /// **'전투 태세'**
  String get cardNameDefC05;

  /// No description provided for @cardDescDefC05.
  ///
  /// In ko, this message translates to:
  /// **'방어도 6을 얻고, 카드 1장을 드로우한다.'**
  String get cardDescDefC05;

  /// No description provided for @cardNameDefC05Up.
  ///
  /// In ko, this message translates to:
  /// **'전투 태세+'**
  String get cardNameDefC05Up;

  /// No description provided for @cardDescDefC05Up.
  ///
  /// In ko, this message translates to:
  /// **'방어도 8을 얻고, 카드 1장을 드로우한다.'**
  String get cardDescDefC05Up;

  /// No description provided for @cardNameDefC06.
  ///
  /// In ko, this message translates to:
  /// **'구르기'**
  String get cardNameDefC06;

  /// No description provided for @cardDescDefC06.
  ///
  /// In ko, this message translates to:
  /// **'방어도 3을 얻고, 다음 턴 방어도 6을 얻는다.'**
  String get cardDescDefC06;

  /// No description provided for @cardNameDefC06Up.
  ///
  /// In ko, this message translates to:
  /// **'구르기+'**
  String get cardNameDefC06Up;

  /// No description provided for @cardDescDefC06Up.
  ///
  /// In ko, this message translates to:
  /// **'방어도 5를 얻고, 다음 턴 방어도 8을 얻는다.'**
  String get cardDescDefC06Up;

  /// No description provided for @cardNameDefC07.
  ///
  /// In ko, this message translates to:
  /// **'응급 처치'**
  String get cardNameDefC07;

  /// No description provided for @cardDescDefC07.
  ///
  /// In ko, this message translates to:
  /// **'HP 3을 회복한다.'**
  String get cardDescDefC07;

  /// No description provided for @cardNameDefC07Up.
  ///
  /// In ko, this message translates to:
  /// **'응급 처치+'**
  String get cardNameDefC07Up;

  /// No description provided for @cardDescDefC07Up.
  ///
  /// In ko, this message translates to:
  /// **'HP 5를 회복한다.'**
  String get cardDescDefC07Up;

  /// No description provided for @cardNameDefC08.
  ///
  /// In ko, this message translates to:
  /// **'인내'**
  String get cardNameDefC08;

  /// No description provided for @cardDescDefC08.
  ///
  /// In ko, this message translates to:
  /// **'방어도 5를 얻고, 불굴 1턴을 얻는다.'**
  String get cardDescDefC08;

  /// No description provided for @cardNameDefC08Up.
  ///
  /// In ko, this message translates to:
  /// **'인내+'**
  String get cardNameDefC08Up;

  /// No description provided for @cardDescDefC08Up.
  ///
  /// In ko, this message translates to:
  /// **'방어도 7을 얻고, 불굴 2턴을 얻는다.'**
  String get cardDescDefC08Up;

  /// No description provided for @cardNameDefC09.
  ///
  /// In ko, this message translates to:
  /// **'생명력'**
  String get cardNameDefC09;

  /// No description provided for @cardDescDefC09.
  ///
  /// In ko, this message translates to:
  /// **'재생 3을 얻는다 (3턴).'**
  String get cardDescDefC09;

  /// No description provided for @cardNameDefC09Up.
  ///
  /// In ko, this message translates to:
  /// **'생명력+'**
  String get cardNameDefC09Up;

  /// No description provided for @cardDescDefC09Up.
  ///
  /// In ko, this message translates to:
  /// **'재생 4를 얻는다 (4턴).'**
  String get cardDescDefC09Up;

  /// No description provided for @cardNameDefC10.
  ///
  /// In ko, this message translates to:
  /// **'도발 방패'**
  String get cardNameDefC10;

  /// No description provided for @cardDescDefC10.
  ///
  /// In ko, this message translates to:
  /// **'방어도 6을 얻고, 적 1체를 도발한다.'**
  String get cardDescDefC10;

  /// No description provided for @cardNameDefC10Up.
  ///
  /// In ko, this message translates to:
  /// **'도발 방패+'**
  String get cardNameDefC10Up;

  /// No description provided for @cardDescDefC10Up.
  ///
  /// In ko, this message translates to:
  /// **'방어도 9를 얻고, 적 1체를 도발한다.'**
  String get cardDescDefC10Up;

  /// No description provided for @cardNameDefU01.
  ///
  /// In ko, this message translates to:
  /// **'바리케이드'**
  String get cardNameDefU01;

  /// No description provided for @cardDescDefU01.
  ///
  /// In ko, this message translates to:
  /// **'방어도 12를 얻고, 불굴 2턴을 얻는다.'**
  String get cardDescDefU01;

  /// No description provided for @cardNameDefU01Up.
  ///
  /// In ko, this message translates to:
  /// **'바리케이드+'**
  String get cardNameDefU01Up;

  /// No description provided for @cardDescDefU01Up.
  ///
  /// In ko, this message translates to:
  /// **'방어도 16을 얻고, 불굴 3턴을 얻는다.'**
  String get cardDescDefU01Up;

  /// No description provided for @cardNameDefU02.
  ///
  /// In ko, this message translates to:
  /// **'반사 방어막'**
  String get cardNameDefU02;

  /// No description provided for @cardDescDefU02.
  ///
  /// In ko, this message translates to:
  /// **'방어도 8을 얻고, 가시 5를 얻는다 (이번 턴).'**
  String get cardDescDefU02;

  /// No description provided for @cardNameDefU02Up.
  ///
  /// In ko, this message translates to:
  /// **'반사 방어막+'**
  String get cardNameDefU02Up;

  /// No description provided for @cardDescDefU02Up.
  ///
  /// In ko, this message translates to:
  /// **'방어도 12를 얻고, 가시 7을 얻는다 (이번 턴).'**
  String get cardDescDefU02Up;

  /// No description provided for @cardNameDefU03.
  ///
  /// In ko, this message translates to:
  /// **'재생의 기도'**
  String get cardNameDefU03;

  /// No description provided for @cardDescDefU03.
  ///
  /// In ko, this message translates to:
  /// **'HP 10을 회복하고, 재생 2를 얻는다 (3턴).'**
  String get cardDescDefU03;

  /// No description provided for @cardNameDefU03Up.
  ///
  /// In ko, this message translates to:
  /// **'재생의 기도+'**
  String get cardNameDefU03Up;

  /// No description provided for @cardDescDefU03Up.
  ///
  /// In ko, this message translates to:
  /// **'HP 15를 회복하고, 재생 3을 얻는다 (3턴).'**
  String get cardDescDefU03Up;

  /// No description provided for @cardNameDefU04.
  ///
  /// In ko, this message translates to:
  /// **'불굴의 의지'**
  String get cardNameDefU04;

  /// No description provided for @cardDescDefU04.
  ///
  /// In ko, this message translates to:
  /// **'민첩 +2를 얻는다 (영구).'**
  String get cardDescDefU04;

  /// No description provided for @cardNameDefU04Up.
  ///
  /// In ko, this message translates to:
  /// **'불굴의 의지+'**
  String get cardNameDefU04Up;

  /// No description provided for @cardDescDefU04Up.
  ///
  /// In ko, this message translates to:
  /// **'민첩 +3을 얻는다 (영구).'**
  String get cardDescDefU04Up;

  /// No description provided for @cardNameDefU05.
  ///
  /// In ko, this message translates to:
  /// **'보호막'**
  String get cardNameDefU05;

  /// No description provided for @cardDescDefU05.
  ///
  /// In ko, this message translates to:
  /// **'잃은 HP의 25%만큼 방어도를 얻는다.'**
  String get cardDescDefU05;

  /// No description provided for @cardNameDefU05Up.
  ///
  /// In ko, this message translates to:
  /// **'보호막+'**
  String get cardNameDefU05Up;

  /// No description provided for @cardDescDefU05Up.
  ///
  /// In ko, this message translates to:
  /// **'잃은 HP의 30%만큼 방어도를 얻는다.'**
  String get cardDescDefU05Up;

  /// No description provided for @cardNameDefU06.
  ///
  /// In ko, this message translates to:
  /// **'생존 본능'**
  String get cardNameDefU06;

  /// No description provided for @cardDescDefU06.
  ///
  /// In ko, this message translates to:
  /// **'HP 50% 이하면 방어도 15, 아니면 5.'**
  String get cardDescDefU06;

  /// No description provided for @cardNameDefU06Up.
  ///
  /// In ko, this message translates to:
  /// **'생존 본능+'**
  String get cardNameDefU06Up;

  /// No description provided for @cardDescDefU06Up.
  ///
  /// In ko, this message translates to:
  /// **'HP 50% 이하면 방어도 20, 아니면 8.'**
  String get cardDescDefU06Up;

  /// No description provided for @cardNameDefU07.
  ///
  /// In ko, this message translates to:
  /// **'흡혈 가시'**
  String get cardNameDefU07;

  /// No description provided for @cardDescDefU07.
  ///
  /// In ko, this message translates to:
  /// **'가시 3을 얻는다 (영구). 피격 시 HP 1을 회복한다.'**
  String get cardDescDefU07;

  /// No description provided for @cardNameDefU07Up.
  ///
  /// In ko, this message translates to:
  /// **'흡혈 가시+'**
  String get cardNameDefU07Up;

  /// No description provided for @cardDescDefU07Up.
  ///
  /// In ko, this message translates to:
  /// **'가시 4를 얻는다 (영구). 피격 시 HP 2를 회복한다.'**
  String get cardDescDefU07Up;

  /// No description provided for @cardNameDefU08.
  ///
  /// In ko, this message translates to:
  /// **'강화 갑옷'**
  String get cardNameDefU08;

  /// No description provided for @cardDescDefU08.
  ///
  /// In ko, this message translates to:
  /// **'방어도 20을 얻고, 다음 턴 방어도 10을 얻는다.'**
  String get cardDescDefU08;

  /// No description provided for @cardNameDefU08Up.
  ///
  /// In ko, this message translates to:
  /// **'강화 갑옷+'**
  String get cardNameDefU08Up;

  /// No description provided for @cardDescDefU08Up.
  ///
  /// In ko, this message translates to:
  /// **'방어도 25를 얻고, 다음 턴 방어도 15를 얻는다.'**
  String get cardDescDefU08Up;

  /// No description provided for @cardNameDefR01.
  ///
  /// In ko, this message translates to:
  /// **'무적'**
  String get cardNameDefR01;

  /// No description provided for @cardDescDefR01.
  ///
  /// In ko, this message translates to:
  /// **'이번 턴 모든 데미지를 0으로 만든다. 사용 후 소멸.'**
  String get cardDescDefR01;

  /// No description provided for @cardNameDefR01Up.
  ///
  /// In ko, this message translates to:
  /// **'무적+'**
  String get cardNameDefR01Up;

  /// No description provided for @cardDescDefR01Up.
  ///
  /// In ko, this message translates to:
  /// **'이번 턴과 다음 턴 모든 데미지를 0으로 만든다. 사용 후 소멸.'**
  String get cardDescDefR01Up;

  /// No description provided for @cardNameDefR02.
  ///
  /// In ko, this message translates to:
  /// **'생명의 나무'**
  String get cardNameDefR02;

  /// No description provided for @cardDescDefR02.
  ///
  /// In ko, this message translates to:
  /// **'HP 전체의 30%를 회복한다.'**
  String get cardDescDefR02;

  /// No description provided for @cardNameDefR02Up.
  ///
  /// In ko, this message translates to:
  /// **'생명의 나무+'**
  String get cardNameDefR02Up;

  /// No description provided for @cardDescDefR02Up.
  ///
  /// In ko, this message translates to:
  /// **'HP 전체의 40%를 회복한다.'**
  String get cardDescDefR02Up;

  /// No description provided for @cardNameDefR03.
  ///
  /// In ko, this message translates to:
  /// **'성스러운 방패'**
  String get cardNameDefR03;

  /// No description provided for @cardDescDefR03.
  ///
  /// In ko, this message translates to:
  /// **'방어도 20을 얻고, 디버프를 모두 해제한다.'**
  String get cardDescDefR03;

  /// No description provided for @cardNameDefR03Up.
  ///
  /// In ko, this message translates to:
  /// **'성스러운 방패+'**
  String get cardNameDefR03Up;

  /// No description provided for @cardDescDefR03Up.
  ///
  /// In ko, this message translates to:
  /// **'방어도 28을 얻고, 디버프를 모두 해제한다.'**
  String get cardDescDefR03Up;

  /// No description provided for @cardNameDefR04.
  ///
  /// In ko, this message translates to:
  /// **'철의 몸'**
  String get cardNameDefR04;

  /// No description provided for @cardDescDefR04.
  ///
  /// In ko, this message translates to:
  /// **'매 턴 방어도 8을 자동으로 얻는다 (전투 동안).'**
  String get cardDescDefR04;

  /// No description provided for @cardNameDefR04Up.
  ///
  /// In ko, this message translates to:
  /// **'철의 몸+'**
  String get cardNameDefR04Up;

  /// No description provided for @cardDescDefR04Up.
  ///
  /// In ko, this message translates to:
  /// **'매 턴 방어도 12를 자동으로 얻는다 (전투 동안).'**
  String get cardDescDefR04Up;

  /// No description provided for @cardNameDefR05.
  ///
  /// In ko, this message translates to:
  /// **'부활의 비약'**
  String get cardNameDefR05;

  /// No description provided for @cardDescDefR05.
  ///
  /// In ko, this message translates to:
  /// **'이번 전투에서 사망 시 HP 30%로 부활한다. 사용 후 소멸.'**
  String get cardDescDefR05;

  /// No description provided for @cardNameDefR05Up.
  ///
  /// In ko, this message translates to:
  /// **'부활의 비약+'**
  String get cardNameDefR05Up;

  /// No description provided for @cardDescDefR05Up.
  ///
  /// In ko, this message translates to:
  /// **'이번 전투에서 사망 시 HP 50%로 부활한다. 사용 후 소멸.'**
  String get cardDescDefR05Up;

  /// No description provided for @cardNameDefL01.
  ///
  /// In ko, this message translates to:
  /// **'영원의 방패'**
  String get cardNameDefL01;

  /// No description provided for @cardDescDefL01.
  ///
  /// In ko, this message translates to:
  /// **'방어도 30을 얻고, 매 턴 방어도 5를 자동으로 얻는다 (전투 동안). 사용 후 소멸.'**
  String get cardDescDefL01;

  /// No description provided for @cardNameDefL01Up.
  ///
  /// In ko, this message translates to:
  /// **'영원의 방패+'**
  String get cardNameDefL01Up;

  /// No description provided for @cardDescDefL01Up.
  ///
  /// In ko, this message translates to:
  /// **'방어도 40을 얻고, 매 턴 방어도 8을 자동으로 얻는다 (전투 동안). 사용 후 소멸.'**
  String get cardDescDefL01Up;

  /// No description provided for @cardNameDefL02.
  ///
  /// In ko, this message translates to:
  /// **'생명의 원천'**
  String get cardNameDefL02;

  /// No description provided for @cardDescDefL02.
  ///
  /// In ko, this message translates to:
  /// **'HP를 완전 회복하고, 최대 HP +10 (영구). 사용 후 소멸.'**
  String get cardDescDefL02;

  /// No description provided for @cardNameDefL02Up.
  ///
  /// In ko, this message translates to:
  /// **'생명의 원천+'**
  String get cardNameDefL02Up;

  /// No description provided for @cardDescDefL02Up.
  ///
  /// In ko, this message translates to:
  /// **'HP를 완전 회복하고, 최대 HP +20 (영구). 사용 후 소멸.'**
  String get cardDescDefL02Up;

  /// No description provided for @cardNameTacC01.
  ///
  /// In ko, this message translates to:
  /// **'관찰'**
  String get cardNameTacC01;

  /// No description provided for @cardDescTacC01.
  ///
  /// In ko, this message translates to:
  /// **'적 의도를 확인하고, 카드 1장을 드로우한다.'**
  String get cardDescTacC01;

  /// No description provided for @cardNameTacC01Up.
  ///
  /// In ko, this message translates to:
  /// **'관찰+'**
  String get cardNameTacC01Up;

  /// No description provided for @cardDescTacC01Up.
  ///
  /// In ko, this message translates to:
  /// **'적 의도를 확인하고, 카드 2장을 드로우한다.'**
  String get cardDescTacC01Up;

  /// No description provided for @cardNameTacC02.
  ///
  /// In ko, this message translates to:
  /// **'보물 사냥'**
  String get cardNameTacC02;

  /// No description provided for @cardDescTacC02.
  ///
  /// In ko, this message translates to:
  /// **'전투 골드 +15.'**
  String get cardDescTacC02;

  /// No description provided for @cardNameTacC02Up.
  ///
  /// In ko, this message translates to:
  /// **'보물 사냥+'**
  String get cardNameTacC02Up;

  /// No description provided for @cardDescTacC02Up.
  ///
  /// In ko, this message translates to:
  /// **'전투 골드 +25.'**
  String get cardDescTacC02Up;

  /// No description provided for @cardNameTacC03.
  ///
  /// In ko, this message translates to:
  /// **'약점 간파'**
  String get cardNameTacC03;

  /// No description provided for @cardDescTacC03.
  ///
  /// In ko, this message translates to:
  /// **'취약 2턴, 약화 1턴을 부여한다.'**
  String get cardDescTacC03;

  /// No description provided for @cardNameTacC03Up.
  ///
  /// In ko, this message translates to:
  /// **'약점 간파+'**
  String get cardNameTacC03Up;

  /// No description provided for @cardDescTacC03Up.
  ///
  /// In ko, this message translates to:
  /// **'취약 2턴, 약화 2턴을 부여한다.'**
  String get cardDescTacC03Up;

  /// No description provided for @cardNameTacC04.
  ///
  /// In ko, this message translates to:
  /// **'재빠른 손'**
  String get cardNameTacC04;

  /// No description provided for @cardDescTacC04.
  ///
  /// In ko, this message translates to:
  /// **'카드 2장을 드로우한다.'**
  String get cardDescTacC04;

  /// No description provided for @cardNameTacC04Up.
  ///
  /// In ko, this message translates to:
  /// **'재빠른 손+'**
  String get cardNameTacC04Up;

  /// No description provided for @cardDescTacC04Up.
  ///
  /// In ko, this message translates to:
  /// **'카드 3장을 드로우한다.'**
  String get cardDescTacC04Up;

  /// No description provided for @cardNameTacC05.
  ///
  /// In ko, this message translates to:
  /// **'덫 설치'**
  String get cardNameTacC05;

  /// No description provided for @cardDescTacC05.
  ///
  /// In ko, this message translates to:
  /// **'다음 적 공격 시 10 데미지를 반사한다.'**
  String get cardDescTacC05;

  /// No description provided for @cardNameTacC05Up.
  ///
  /// In ko, this message translates to:
  /// **'덫 설치+'**
  String get cardNameTacC05Up;

  /// No description provided for @cardDescTacC05Up.
  ///
  /// In ko, this message translates to:
  /// **'다음 적 공격 시 15 데미지를 반사한다.'**
  String get cardDescTacC05Up;

  /// No description provided for @cardNameTacC06.
  ///
  /// In ko, this message translates to:
  /// **'교란'**
  String get cardNameTacC06;

  /// No description provided for @cardDescTacC06.
  ///
  /// In ko, this message translates to:
  /// **'적 의도를 변경한다 (랜덤).'**
  String get cardDescTacC06;

  /// No description provided for @cardNameTacC06Up.
  ///
  /// In ko, this message translates to:
  /// **'교란+'**
  String get cardNameTacC06Up;

  /// No description provided for @cardDescTacC06Up.
  ///
  /// In ko, this message translates to:
  /// **'적 의도를 변경하고, 약화 1턴을 부여한다.'**
  String get cardDescTacC06Up;

  /// No description provided for @cardNameTacC07.
  ///
  /// In ko, this message translates to:
  /// **'도둑질'**
  String get cardNameTacC07;

  /// No description provided for @cardDescTacC07.
  ///
  /// In ko, this message translates to:
  /// **'3 데미지를 주고, 골드 5~15를 획득한다.'**
  String get cardDescTacC07;

  /// No description provided for @cardNameTacC07Up.
  ///
  /// In ko, this message translates to:
  /// **'도둑질+'**
  String get cardNameTacC07Up;

  /// No description provided for @cardDescTacC07Up.
  ///
  /// In ko, this message translates to:
  /// **'6 데미지를 주고, 골드 10~25를 획득한다.'**
  String get cardDescTacC07Up;

  /// No description provided for @cardNameTacC08.
  ///
  /// In ko, this message translates to:
  /// **'연막탄'**
  String get cardNameTacC08;

  /// No description provided for @cardDescTacC08.
  ///
  /// In ko, this message translates to:
  /// **'방어도 4를 얻고, 적 전체에 약화 1턴을 부여한다.'**
  String get cardDescTacC08;

  /// No description provided for @cardNameTacC08Up.
  ///
  /// In ko, this message translates to:
  /// **'연막탄+'**
  String get cardNameTacC08Up;

  /// No description provided for @cardDescTacC08Up.
  ///
  /// In ko, this message translates to:
  /// **'방어도 6을 얻고, 적 전체에 약화 2턴을 부여한다.'**
  String get cardDescTacC08Up;

  /// No description provided for @cardNameTacC09.
  ///
  /// In ko, this message translates to:
  /// **'격려'**
  String get cardNameTacC09;

  /// No description provided for @cardDescTacC09.
  ///
  /// In ko, this message translates to:
  /// **'임의 카드 1장을 이번 전투 동안 업그레이드한다.'**
  String get cardDescTacC09;

  /// No description provided for @cardNameTacC09Up.
  ///
  /// In ko, this message translates to:
  /// **'격려+'**
  String get cardNameTacC09Up;

  /// No description provided for @cardDescTacC09Up.
  ///
  /// In ko, this message translates to:
  /// **'임의 카드 2장을 이번 전투 동안 업그레이드한다.'**
  String get cardDescTacC09Up;

  /// No description provided for @cardNameTacC10.
  ///
  /// In ko, this message translates to:
  /// **'행운의 동전'**
  String get cardNameTacC10;

  /// No description provided for @cardDescTacC10.
  ///
  /// In ko, this message translates to:
  /// **'50% 확률로 카드 2장을 드로우한다.'**
  String get cardDescTacC10;

  /// No description provided for @cardNameTacC10Up.
  ///
  /// In ko, this message translates to:
  /// **'행운의 동전+'**
  String get cardNameTacC10Up;

  /// No description provided for @cardDescTacC10Up.
  ///
  /// In ko, this message translates to:
  /// **'70% 확률로 카드 2장을 드로우한다.'**
  String get cardDescTacC10Up;

  /// No description provided for @cardNameTacU01.
  ///
  /// In ko, this message translates to:
  /// **'전장 분석'**
  String get cardNameTacU01;

  /// No description provided for @cardDescTacU01.
  ///
  /// In ko, this message translates to:
  /// **'카드 3장을 드로우하고, 비용이 가장 높은 카드의 이번 턴 비용을 0으로 만든다.'**
  String get cardDescTacU01;

  /// No description provided for @cardNameTacU01Up.
  ///
  /// In ko, this message translates to:
  /// **'전장 분석+'**
  String get cardNameTacU01Up;

  /// No description provided for @cardDescTacU01Up.
  ///
  /// In ko, this message translates to:
  /// **'카드 4장을 드로우하고, 비용이 가장 높은 카드의 이번 턴 비용을 0으로 만든다.'**
  String get cardDescTacU01Up;

  /// No description provided for @cardNameTacU02.
  ///
  /// In ko, this message translates to:
  /// **'그림자 이동'**
  String get cardNameTacU02;

  /// No description provided for @cardDescTacU02.
  ///
  /// In ko, this message translates to:
  /// **'다음 턴까지 받는 데미지가 50% 감소한다.'**
  String get cardDescTacU02;

  /// No description provided for @cardNameTacU02Up.
  ///
  /// In ko, this message translates to:
  /// **'그림자 이동+'**
  String get cardNameTacU02Up;

  /// No description provided for @cardDescTacU02Up.
  ///
  /// In ko, this message translates to:
  /// **'다음 턴까지 받는 데미지가 50% 감소하고, 카드 1장을 드로우한다.'**
  String get cardDescTacU02Up;

  /// No description provided for @cardNameTacU03.
  ///
  /// In ko, this message translates to:
  /// **'보물 상자'**
  String get cardNameTacU03;

  /// No description provided for @cardDescTacU03.
  ///
  /// In ko, this message translates to:
  /// **'랜덤 렐릭 효과를 1회 발동한다. 사용 후 소멸.'**
  String get cardDescTacU03;

  /// No description provided for @cardNameTacU03Up.
  ///
  /// In ko, this message translates to:
  /// **'보물 상자+'**
  String get cardNameTacU03Up;

  /// No description provided for @cardDescTacU03Up.
  ///
  /// In ko, this message translates to:
  /// **'랜덤 렐릭 효과를 2회 발동한다. 사용 후 소멸.'**
  String get cardDescTacU03Up;

  /// No description provided for @cardNameTacU04.
  ///
  /// In ko, this message translates to:
  /// **'카드 조작'**
  String get cardNameTacU04;

  /// No description provided for @cardDescTacU04.
  ///
  /// In ko, this message translates to:
  /// **'드로우 파일 상위 3장을 원하는 순서로 정렬한다.'**
  String get cardDescTacU04;

  /// No description provided for @cardNameTacU04Up.
  ///
  /// In ko, this message translates to:
  /// **'카드 조작+'**
  String get cardNameTacU04Up;

  /// No description provided for @cardDescTacU04Up.
  ///
  /// In ko, this message translates to:
  /// **'드로우 파일 상위 5장을 원하는 순서로 정렬한다.'**
  String get cardDescTacU04Up;

  /// No description provided for @cardNameTacU05.
  ///
  /// In ko, this message translates to:
  /// **'이중 스파이'**
  String get cardNameTacU05;

  /// No description provided for @cardDescTacU05.
  ///
  /// In ko, this message translates to:
  /// **'적의 버프를 복사하고, 적의 버프를 제거한다.'**
  String get cardDescTacU05;

  /// No description provided for @cardNameTacU05Up.
  ///
  /// In ko, this message translates to:
  /// **'이중 스파이+'**
  String get cardNameTacU05Up;

  /// No description provided for @cardDescTacU05Up.
  ///
  /// In ko, this message translates to:
  /// **'적의 버프를 복사하고, 적의 버프를 제거하고, 5 데미지를 준다.'**
  String get cardDescTacU05Up;

  /// No description provided for @cardNameTacU06.
  ///
  /// In ko, this message translates to:
  /// **'전략적 후퇴'**
  String get cardNameTacU06;

  /// No description provided for @cardDescTacU06.
  ///
  /// In ko, this message translates to:
  /// **'패 전부를 셔플하고, 새로 5장을 드로우한다.'**
  String get cardDescTacU06;

  /// No description provided for @cardNameTacU06Up.
  ///
  /// In ko, this message translates to:
  /// **'전략적 후퇴+'**
  String get cardNameTacU06Up;

  /// No description provided for @cardDescTacU06Up.
  ///
  /// In ko, this message translates to:
  /// **'패 전부를 셔플하고, 새로 6장을 드로우한다.'**
  String get cardDescTacU06Up;

  /// No description provided for @cardNameTacU07.
  ///
  /// In ko, this message translates to:
  /// **'물물교환'**
  String get cardNameTacU07;

  /// No description provided for @cardDescTacU07.
  ///
  /// In ko, this message translates to:
  /// **'패에서 1장을 소멸시키고, 랜덤 카드 2장을 생성한다.'**
  String get cardDescTacU07;

  /// No description provided for @cardNameTacU07Up.
  ///
  /// In ko, this message translates to:
  /// **'물물교환+'**
  String get cardNameTacU07Up;

  /// No description provided for @cardDescTacU07Up.
  ///
  /// In ko, this message translates to:
  /// **'패에서 1장을 소멸시키고, 랜덤 카드 3장을 생성한다.'**
  String get cardDescTacU07Up;

  /// No description provided for @cardNameTacU08.
  ///
  /// In ko, this message translates to:
  /// **'연쇄 함정'**
  String get cardNameTacU08;

  /// No description provided for @cardDescTacU08.
  ///
  /// In ko, this message translates to:
  /// **'가시 3을 얻는다 (영구). 적 공격 시 약화 1턴을 부여한다.'**
  String get cardDescTacU08;

  /// No description provided for @cardNameTacU08Up.
  ///
  /// In ko, this message translates to:
  /// **'연쇄 함정+'**
  String get cardNameTacU08Up;

  /// No description provided for @cardDescTacU08Up.
  ///
  /// In ko, this message translates to:
  /// **'가시 5를 얻는다 (영구). 적 공격 시 약화 1턴을 부여한다.'**
  String get cardDescTacU08Up;

  /// No description provided for @cardNameTacR01.
  ///
  /// In ko, this message translates to:
  /// **'완벽한 계획'**
  String get cardNameTacR01;

  /// No description provided for @cardDescTacR01.
  ///
  /// In ko, this message translates to:
  /// **'에너지 +3, 카드 3장을 드로우한다. 다음 턴 드로우 0.'**
  String get cardDescTacR01;

  /// No description provided for @cardNameTacR01Up.
  ///
  /// In ko, this message translates to:
  /// **'완벽한 계획+'**
  String get cardNameTacR01Up;

  /// No description provided for @cardDescTacR01Up.
  ///
  /// In ko, this message translates to:
  /// **'에너지 +3, 카드 3장을 드로우한다. 다음 턴 드로우 2.'**
  String get cardDescTacR01Up;

  /// No description provided for @cardNameTacR02.
  ///
  /// In ko, this message translates to:
  /// **'운명의 바퀴'**
  String get cardNameTacR02;

  /// No description provided for @cardDescTacR02.
  ///
  /// In ko, this message translates to:
  /// **'랜덤 효과 1회: 데미지 15, 방어 15, 회복 15, 에너지 +2 중 하나.'**
  String get cardDescTacR02;

  /// No description provided for @cardNameTacR02Up.
  ///
  /// In ko, this message translates to:
  /// **'운명의 바퀴+'**
  String get cardNameTacR02Up;

  /// No description provided for @cardDescTacR02Up.
  ///
  /// In ko, this message translates to:
  /// **'랜덤 효과 2회: 데미지 15, 방어 15, 회복 15, 에너지 +2 중 하나.'**
  String get cardDescTacR02Up;

  /// No description provided for @cardNameTacR03.
  ///
  /// In ko, this message translates to:
  /// **'도플갱어'**
  String get cardNameTacR03;

  /// No description provided for @cardDescTacR03.
  ///
  /// In ko, this message translates to:
  /// **'이번 턴 사용한 카드 전부를 다시 패로 가져온다.'**
  String get cardDescTacR03;

  /// No description provided for @cardNameTacR03Up.
  ///
  /// In ko, this message translates to:
  /// **'도플갱어+'**
  String get cardNameTacR03Up;

  /// No description provided for @cardDescTacR03Up.
  ///
  /// In ko, this message translates to:
  /// **'이번 턴 사용한 카드 전부를 다시 패로 가져오고, 에너지 +2를 얻는다.'**
  String get cardDescTacR03Up;

  /// No description provided for @cardNameTacR04.
  ///
  /// In ko, this message translates to:
  /// **'탐욕의 손'**
  String get cardNameTacR04;

  /// No description provided for @cardDescTacR04.
  ///
  /// In ko, this message translates to:
  /// **'6 데미지를 준다. 킬 시 카드 보상 1장을 추가로 받는다.'**
  String get cardDescTacR04;

  /// No description provided for @cardNameTacR04Up.
  ///
  /// In ko, this message translates to:
  /// **'탐욕의 손+'**
  String get cardNameTacR04Up;

  /// No description provided for @cardDescTacR04Up.
  ///
  /// In ko, this message translates to:
  /// **'10 데미지를 준다. 킬 시 카드 보상 1장을 추가로 받는다.'**
  String get cardDescTacR04Up;

  /// No description provided for @cardNameTacR05.
  ///
  /// In ko, this message translates to:
  /// **'대혼란'**
  String get cardNameTacR05;

  /// No description provided for @cardDescTacR05.
  ///
  /// In ko, this message translates to:
  /// **'적 전체에 취약+약화 2턴, 독 3을 부여한다.'**
  String get cardDescTacR05;

  /// No description provided for @cardNameTacR05Up.
  ///
  /// In ko, this message translates to:
  /// **'대혼란+'**
  String get cardNameTacR05Up;

  /// No description provided for @cardDescTacR05Up.
  ///
  /// In ko, this message translates to:
  /// **'적 전체에 취약+약화 3턴, 독 3을 부여한다.'**
  String get cardDescTacR05Up;

  /// No description provided for @cardNameTacL01.
  ///
  /// In ko, this message translates to:
  /// **'시간의 주인'**
  String get cardNameTacL01;

  /// No description provided for @cardDescTacL01.
  ///
  /// In ko, this message translates to:
  /// **'추가 턴 2회를 얻는다 (에너지 2씩). 사용 후 소멸.'**
  String get cardDescTacL01;

  /// No description provided for @cardNameTacL01Up.
  ///
  /// In ko, this message translates to:
  /// **'시간의 주인+'**
  String get cardNameTacL01Up;

  /// No description provided for @cardDescTacL01Up.
  ///
  /// In ko, this message translates to:
  /// **'추가 턴 2회를 얻는다 (에너지 3씩). 사용 후 소멸.'**
  String get cardDescTacL01Up;

  /// No description provided for @cardNameTacL02.
  ///
  /// In ko, this message translates to:
  /// **'운명 변환'**
  String get cardNameTacL02;

  /// No description provided for @cardDescTacL02.
  ///
  /// In ko, this message translates to:
  /// **'덱의 모든 카드를 이번 전투 동안 업그레이드한다. 사용 후 소멸.'**
  String get cardDescTacL02;

  /// No description provided for @cardNameTacL02Up.
  ///
  /// In ko, this message translates to:
  /// **'운명 변환+'**
  String get cardNameTacL02Up;

  /// No description provided for @cardDescTacL02Up.
  ///
  /// In ko, this message translates to:
  /// **'덱의 모든 카드를 이번 전투 동안 업그레이드하고, 에너지 +2를 얻는다. 사용 후 소멸.'**
  String get cardDescTacL02Up;

  /// No description provided for @relicNameStart01.
  ///
  /// In ko, this message translates to:
  /// **'모험자의 가방'**
  String get relicNameStart01;

  /// No description provided for @relicDescStart01.
  ///
  /// In ko, this message translates to:
  /// **'전투 보상 카드 선택지 +1장 (3→4)'**
  String get relicDescStart01;

  /// No description provided for @relicNameStart02.
  ///
  /// In ko, this message translates to:
  /// **'낡은 부적'**
  String get relicNameStart02;

  /// No description provided for @relicDescStart02.
  ///
  /// In ko, this message translates to:
  /// **'시작 HP +15'**
  String get relicDescStart02;

  /// No description provided for @relicNameStart03.
  ///
  /// In ko, this message translates to:
  /// **'행운의 동전'**
  String get relicNameStart03;

  /// No description provided for @relicDescStart03.
  ///
  /// In ko, this message translates to:
  /// **'전투 골드 +30%'**
  String get relicDescStart03;

  /// No description provided for @relicNameC01.
  ///
  /// In ko, this message translates to:
  /// **'앵커'**
  String get relicNameC01;

  /// No description provided for @relicDescC01.
  ///
  /// In ko, this message translates to:
  /// **'매 턴 시작 시 방어 4 자동 획득'**
  String get relicDescC01;

  /// No description provided for @relicNameC02.
  ///
  /// In ko, this message translates to:
  /// **'빨간 물약'**
  String get relicNameC02;

  /// No description provided for @relicDescC02.
  ///
  /// In ko, this message translates to:
  /// **'전투 시작 시 HP 5 회복'**
  String get relicDescC02;

  /// No description provided for @relicNameC03.
  ///
  /// In ko, this message translates to:
  /// **'마나 구슬'**
  String get relicNameC03;

  /// No description provided for @relicDescC03.
  ///
  /// In ko, this message translates to:
  /// **'3턴마다 에너지 +1'**
  String get relicDescC03;

  /// No description provided for @relicNameC04.
  ///
  /// In ko, this message translates to:
  /// **'날카로운 숫돌'**
  String get relicNameC04;

  /// No description provided for @relicDescC04.
  ///
  /// In ko, this message translates to:
  /// **'첫 번째 공격 카드 데미지 +3'**
  String get relicDescC04;

  /// No description provided for @relicNameC05.
  ///
  /// In ko, this message translates to:
  /// **'도둑의 장갑'**
  String get relicNameC05;

  /// No description provided for @relicDescC05.
  ///
  /// In ko, this message translates to:
  /// **'전투 보상 골드 +15'**
  String get relicDescC05;

  /// No description provided for @relicNameC06.
  ///
  /// In ko, this message translates to:
  /// **'가벼운 신발'**
  String get relicNameC06;

  /// No description provided for @relicDescC06.
  ///
  /// In ko, this message translates to:
  /// **'첫 턴 카드 드로우 +2'**
  String get relicDescC06;

  /// No description provided for @relicNameC07.
  ///
  /// In ko, this message translates to:
  /// **'독 주머니'**
  String get relicNameC07;

  /// No description provided for @relicDescC07.
  ///
  /// In ko, this message translates to:
  /// **'전투 시작 시 적 전체 독 2'**
  String get relicDescC07;

  /// No description provided for @relicNameC08.
  ///
  /// In ko, this message translates to:
  /// **'가시 방패'**
  String get relicNameC08;

  /// No description provided for @relicDescC08.
  ///
  /// In ko, this message translates to:
  /// **'가시 1 (영구)'**
  String get relicDescC08;

  /// No description provided for @relicNameC09.
  ///
  /// In ko, this message translates to:
  /// **'집중의 반지'**
  String get relicNameC09;

  /// No description provided for @relicDescC09.
  ///
  /// In ko, this message translates to:
  /// **'비용 0 카드 사용 시 방어 2'**
  String get relicDescC09;

  /// No description provided for @relicNameC10.
  ///
  /// In ko, this message translates to:
  /// **'전사의 팔찌'**
  String get relicNameC10;

  /// No description provided for @relicDescC10.
  ///
  /// In ko, this message translates to:
  /// **'패에 공격 카드만 있으면 에너지 +1'**
  String get relicDescC10;

  /// No description provided for @relicNameU01.
  ///
  /// In ko, this message translates to:
  /// **'서리의 심장'**
  String get relicNameU01;

  /// No description provided for @relicDescU01.
  ///
  /// In ko, this message translates to:
  /// **'공격 카드 사용 시 20% 확률 약화 1턴'**
  String get relicDescU01;

  /// No description provided for @relicNameU02.
  ///
  /// In ko, this message translates to:
  /// **'현자의 돌'**
  String get relicNameU02;

  /// No description provided for @relicDescU02.
  ///
  /// In ko, this message translates to:
  /// **'마법 카드 데미지 +25%'**
  String get relicDescU02;

  /// No description provided for @relicNameU03.
  ///
  /// In ko, this message translates to:
  /// **'불사조의 깃털'**
  String get relicNameU03;

  /// No description provided for @relicDescU03.
  ///
  /// In ko, this message translates to:
  /// **'사망 시 1회 HP 30%로 부활'**
  String get relicDescU03;

  /// No description provided for @relicNameU04.
  ///
  /// In ko, this message translates to:
  /// **'시간의 모래'**
  String get relicNameU04;

  /// No description provided for @relicDescU04.
  ///
  /// In ko, this message translates to:
  /// **'첫 3턴 에너지 +1'**
  String get relicDescU04;

  /// No description provided for @relicNameU05.
  ///
  /// In ko, this message translates to:
  /// **'영혼 수확자'**
  String get relicNameU05;

  /// No description provided for @relicDescU05.
  ///
  /// In ko, this message translates to:
  /// **'적 처치 시 HP 5 회복'**
  String get relicDescU05;

  /// No description provided for @relicNameU06.
  ///
  /// In ko, this message translates to:
  /// **'마법 거울'**
  String get relicNameU06;

  /// No description provided for @relicDescU06.
  ///
  /// In ko, this message translates to:
  /// **'첫 번째 디버프 반사 (1회)'**
  String get relicDescU06;

  /// No description provided for @relicNameU07.
  ///
  /// In ko, this message translates to:
  /// **'탐험가의 지도'**
  String get relicNameU07;

  /// No description provided for @relicDescU07.
  ///
  /// In ko, this message translates to:
  /// **'맵에서 다음 층 전체 공개'**
  String get relicDescU07;

  /// No description provided for @relicNameU08.
  ///
  /// In ko, this message translates to:
  /// **'연금술사의 가방'**
  String get relicNameU08;

  /// No description provided for @relicDescU08.
  ///
  /// In ko, this message translates to:
  /// **'상점에서 무료 카드 제거 1회'**
  String get relicDescU08;

  /// No description provided for @relicNameR01.
  ///
  /// In ko, this message translates to:
  /// **'드래곤의 비늘'**
  String get relicNameR01;

  /// No description provided for @relicDescR01.
  ///
  /// In ko, this message translates to:
  /// **'받는 데미지 -1 (모든 공격)'**
  String get relicDescR01;

  /// No description provided for @relicNameR02.
  ///
  /// In ko, this message translates to:
  /// **'제3의 눈'**
  String get relicNameR02;

  /// No description provided for @relicDescR02.
  ///
  /// In ko, this message translates to:
  /// **'적 의도를 정확한 숫자로 표시'**
  String get relicDescR02;

  /// No description provided for @relicNameR03.
  ///
  /// In ko, this message translates to:
  /// **'무한 주머니'**
  String get relicNameR03;

  /// No description provided for @relicDescR03.
  ///
  /// In ko, this message translates to:
  /// **'카드 최대 보유 +1 (패에 6장)'**
  String get relicDescR03;

  /// No description provided for @relicNameR04.
  ///
  /// In ko, this message translates to:
  /// **'각성의 오브'**
  String get relicNameR04;

  /// No description provided for @relicDescR04.
  ///
  /// In ko, this message translates to:
  /// **'에너지 최대 +1 (3→4)'**
  String get relicDescR04;

  /// No description provided for @relicNameR05.
  ///
  /// In ko, this message translates to:
  /// **'운명의 실'**
  String get relicNameR05;

  /// No description provided for @relicDescR05.
  ///
  /// In ko, this message translates to:
  /// **'카드 보상에서 레어 이상 확률 2배'**
  String get relicDescR05;

  /// No description provided for @relicNameB01.
  ///
  /// In ko, this message translates to:
  /// **'왕관'**
  String get relicNameB01;

  /// No description provided for @relicDescB01.
  ///
  /// In ko, this message translates to:
  /// **'에너지 최대 +1, 시작 시 저주 1장'**
  String get relicDescB01;

  /// No description provided for @relicNameB02.
  ///
  /// In ko, this message translates to:
  /// **'마왕의 심장'**
  String get relicNameB02;

  /// No description provided for @relicDescB02.
  ///
  /// In ko, this message translates to:
  /// **'모든 카드 데미지 +5, 받는 데미지 +5'**
  String get relicDescB02;

  /// No description provided for @relicNameB03.
  ///
  /// In ko, this message translates to:
  /// **'부활의 성배'**
  String get relicNameB03;

  /// No description provided for @relicDescB03.
  ///
  /// In ko, this message translates to:
  /// **'휴식 노드에서 HP 완전 회복'**
  String get relicDescB03;

  /// No description provided for @relicNameB04.
  ///
  /// In ko, this message translates to:
  /// **'혼돈의 구체'**
  String get relicNameB04;

  /// No description provided for @relicDescB04.
  ///
  /// In ko, this message translates to:
  /// **'매 턴 랜덤 카드 1장 패에 생성'**
  String get relicDescB04;

  /// No description provided for @relicNameB05.
  ///
  /// In ko, this message translates to:
  /// **'시간의 왕관'**
  String get relicNameB05;

  /// No description provided for @relicDescB05.
  ///
  /// In ko, this message translates to:
  /// **'첫 턴 추가 턴 1회'**
  String get relicDescB05;

  /// No description provided for @achievementNameAc1.
  ///
  /// In ko, this message translates to:
  /// **'첫 걸음'**
  String get achievementNameAc1;

  /// No description provided for @achievementDescAc1.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 1회 완료'**
  String get achievementDescAc1;

  /// No description provided for @achievementNameAc2.
  ///
  /// In ko, this message translates to:
  /// **'성실의 증표'**
  String get achievementNameAc2;

  /// No description provided for @achievementDescAc2.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 10회 완료'**
  String get achievementDescAc2;

  /// No description provided for @achievementNameAc3.
  ///
  /// In ko, this message translates to:
  /// **'레벨 5 달성'**
  String get achievementNameAc3;

  /// No description provided for @achievementDescAc3.
  ///
  /// In ko, this message translates to:
  /// **'초보 모험가 탈출'**
  String get achievementDescAc3;

  /// No description provided for @achievementNameAc4.
  ///
  /// In ko, this message translates to:
  /// **'힘의 각성'**
  String get achievementNameAc4;

  /// No description provided for @achievementDescAc4.
  ///
  /// In ko, this message translates to:
  /// **'힘 스탯 10 달성'**
  String get achievementDescAc4;

  /// No description provided for @achievementNameAc5.
  ///
  /// In ko, this message translates to:
  /// **'지혜의 시작'**
  String get achievementNameAc5;

  /// No description provided for @achievementDescAc5.
  ///
  /// In ko, this message translates to:
  /// **'지혜 스탯 10 달성'**
  String get achievementDescAc5;

  /// No description provided for @achievementNameAc6.
  ///
  /// In ko, this message translates to:
  /// **'고지를 향하여'**
  String get achievementNameAc6;

  /// No description provided for @achievementDescAc6.
  ///
  /// In ko, this message translates to:
  /// **'레벨 20 달성'**
  String get achievementDescAc6;

  /// No description provided for @achievementNameAc7.
  ///
  /// In ko, this message translates to:
  /// **'기술의 탐구자'**
  String get achievementNameAc7;

  /// No description provided for @achievementDescAc7.
  ///
  /// In ko, this message translates to:
  /// **'스킬 5개 습득'**
  String get achievementDescAc7;

  /// No description provided for @achievementNameAc8.
  ///
  /// In ko, this message translates to:
  /// **'건강의 달인'**
  String get achievementNameAc8;

  /// No description provided for @achievementDescAc8.
  ///
  /// In ko, this message translates to:
  /// **'건강 스탯 50 달성'**
  String get achievementDescAc8;

  /// No description provided for @achievementNameAc9.
  ///
  /// In ko, this message translates to:
  /// **'지혜의 대가'**
  String get achievementNameAc9;

  /// No description provided for @achievementDescAc9.
  ///
  /// In ko, this message translates to:
  /// **'지혜 스탯 50 달성'**
  String get achievementDescAc9;

  /// No description provided for @achievementNameAc10.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 중독자'**
  String get achievementNameAc10;

  /// No description provided for @achievementDescAc10.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 500회 완료'**
  String get achievementDescAc10;

  /// No description provided for @achievementNameAc11.
  ///
  /// In ko, this message translates to:
  /// **'꾸준한 실천가'**
  String get achievementNameAc11;

  /// No description provided for @achievementDescAc11.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 50회 완료'**
  String get achievementDescAc11;

  /// No description provided for @achievementNameAc12.
  ///
  /// In ko, this message translates to:
  /// **'습관의 달인'**
  String get achievementNameAc12;

  /// No description provided for @achievementDescAc12.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 100회 완료'**
  String get achievementDescAc12;

  /// No description provided for @achievementNameAc13.
  ///
  /// In ko, this message translates to:
  /// **'베테랑 모험가'**
  String get achievementNameAc13;

  /// No description provided for @achievementDescAc13.
  ///
  /// In ko, this message translates to:
  /// **'레벨 30 달성'**
  String get achievementDescAc13;

  /// No description provided for @achievementNameAc14.
  ///
  /// In ko, this message translates to:
  /// **'전설의 영웅'**
  String get achievementNameAc14;

  /// No description provided for @achievementDescAc14.
  ///
  /// In ko, this message translates to:
  /// **'레벨 50 달성'**
  String get achievementDescAc14;

  /// No description provided for @achievementNameAc15.
  ///
  /// In ko, this message translates to:
  /// **'근육의 제왕'**
  String get achievementNameAc15;

  /// No description provided for @achievementDescAc15.
  ///
  /// In ko, this message translates to:
  /// **'힘 스탯 100 달성'**
  String get achievementDescAc15;

  /// No description provided for @achievementNameAc16.
  ///
  /// In ko, this message translates to:
  /// **'스킬 마스터'**
  String get achievementNameAc16;

  /// No description provided for @achievementDescAc16.
  ///
  /// In ko, this message translates to:
  /// **'스킬 12개 습득'**
  String get achievementDescAc16;

  /// No description provided for @achievementNameAc17.
  ///
  /// In ko, this message translates to:
  /// **'만능 전문가'**
  String get achievementNameAc17;

  /// No description provided for @achievementDescAc17.
  ///
  /// In ko, this message translates to:
  /// **'스킬 20개 습득'**
  String get achievementDescAc17;

  /// No description provided for @achievementNameAc18.
  ///
  /// In ko, this message translates to:
  /// **'첫 사냥'**
  String get achievementNameAc18;

  /// No description provided for @achievementDescAc18.
  ///
  /// In ko, this message translates to:
  /// **'몬스터 1마리 처치'**
  String get achievementDescAc18;

  /// No description provided for @achievementNameAc19.
  ///
  /// In ko, this message translates to:
  /// **'초보 사냥꾼'**
  String get achievementNameAc19;

  /// No description provided for @achievementDescAc19.
  ///
  /// In ko, this message translates to:
  /// **'몬스터 10마리 처치'**
  String get achievementDescAc19;

  /// No description provided for @achievementNameAc20.
  ///
  /// In ko, this message translates to:
  /// **'숙련된 전사'**
  String get achievementNameAc20;

  /// No description provided for @achievementDescAc20.
  ///
  /// In ko, this message translates to:
  /// **'몬스터 50마리 처치'**
  String get achievementDescAc20;

  /// No description provided for @achievementNameAc21.
  ///
  /// In ko, this message translates to:
  /// **'학살자'**
  String get achievementNameAc21;

  /// No description provided for @achievementDescAc21.
  ///
  /// In ko, this message translates to:
  /// **'몬스터 200마리 처치'**
  String get achievementDescAc21;

  /// No description provided for @achievementNameAc22.
  ///
  /// In ko, this message translates to:
  /// **'전설의 탐험가'**
  String get achievementNameAc22;

  /// No description provided for @achievementDescAc22.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 1000회 완료'**
  String get achievementDescAc22;

  /// No description provided for @achievementNameAc23.
  ///
  /// In ko, this message translates to:
  /// **'레벨 10 달성'**
  String get achievementNameAc23;

  /// No description provided for @achievementDescAc23.
  ///
  /// In ko, this message translates to:
  /// **'초보딱지 탈출!'**
  String get achievementDescAc23;

  /// No description provided for @achievementNameAc24.
  ///
  /// In ko, this message translates to:
  /// **'매력 스타'**
  String get achievementNameAc24;

  /// No description provided for @achievementDescAc24.
  ///
  /// In ko, this message translates to:
  /// **'매력 스탯 30 달성'**
  String get achievementDescAc24;

  /// No description provided for @achievementNameAc25.
  ///
  /// In ko, this message translates to:
  /// **'카리스마의 왕'**
  String get achievementNameAc25;

  /// No description provided for @achievementDescAc25.
  ///
  /// In ko, this message translates to:
  /// **'매력 스탯 80 달성'**
  String get achievementDescAc25;

  /// No description provided for @titleNameT0.
  ///
  /// In ko, this message translates to:
  /// **'새싹 모험가'**
  String get titleNameT0;

  /// No description provided for @titleDescT0.
  ///
  /// In ko, this message translates to:
  /// **'모든 것이 새로운 시작'**
  String get titleDescT0;

  /// No description provided for @titleNameT1.
  ///
  /// In ko, this message translates to:
  /// **'성실한 모험가'**
  String get titleNameT1;

  /// No description provided for @titleDescT1.
  ///
  /// In ko, this message translates to:
  /// **'꾸준함이 미덕'**
  String get titleDescT1;

  /// No description provided for @titleNameT2.
  ///
  /// In ko, this message translates to:
  /// **'숙련된 개척자'**
  String get titleNameT2;

  /// No description provided for @titleDescT2.
  ///
  /// In ko, this message translates to:
  /// **'자신만의 길을 걷는 자'**
  String get titleDescT2;

  /// No description provided for @titleNameT3.
  ///
  /// In ko, this message translates to:
  /// **'근력 마니아'**
  String get titleNameT3;

  /// No description provided for @titleDescT3.
  ///
  /// In ko, this message translates to:
  /// **'힘 퀘스트 XP +5%'**
  String get titleDescT3;

  /// No description provided for @titleNameT4.
  ///
  /// In ko, this message translates to:
  /// **'현자 지망생'**
  String get titleNameT4;

  /// No description provided for @titleDescT4.
  ///
  /// In ko, this message translates to:
  /// **'지혜 퀘스트 XP +5%'**
  String get titleDescT4;

  /// No description provided for @titleNameT5.
  ///
  /// In ko, this message translates to:
  /// **'강철 체력'**
  String get titleNameT5;

  /// No description provided for @titleDescT5.
  ///
  /// In ko, this message translates to:
  /// **'건강 퀘스트 XP +5%'**
  String get titleDescT5;

  /// No description provided for @titleNameT6.
  ///
  /// In ko, this message translates to:
  /// **'만인의 연인'**
  String get titleNameT6;

  /// No description provided for @titleDescT6.
  ///
  /// In ko, this message translates to:
  /// **'매력 퀘스트 XP +5%'**
  String get titleDescT6;

  /// No description provided for @titleNameT7.
  ///
  /// In ko, this message translates to:
  /// **'성실의 화신'**
  String get titleNameT7;

  /// No description provided for @titleDescT7.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 100회 완료'**
  String get titleDescT7;

  /// No description provided for @titleNameT8.
  ///
  /// In ko, this message translates to:
  /// **'만능 재주꾼'**
  String get titleNameT8;

  /// No description provided for @titleDescT8.
  ///
  /// In ko, this message translates to:
  /// **'모든 스탯 20 달성'**
  String get titleDescT8;

  /// No description provided for @titleNameT9.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 장인'**
  String get titleNameT9;

  /// No description provided for @titleDescT9.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 250회 완료'**
  String get titleDescT9;

  /// No description provided for @titleNameT10.
  ///
  /// In ko, this message translates to:
  /// **'만렙을 향하여'**
  String get titleNameT10;

  /// No description provided for @titleDescT10.
  ///
  /// In ko, this message translates to:
  /// **'레벨 30 달성'**
  String get titleDescT10;

  /// No description provided for @titleNameT11.
  ///
  /// In ko, this message translates to:
  /// **'전설의 용사'**
  String get titleNameT11;

  /// No description provided for @titleDescT11.
  ///
  /// In ko, this message translates to:
  /// **'레벨 40 달성'**
  String get titleDescT11;

  /// No description provided for @titleNameT12.
  ///
  /// In ko, this message translates to:
  /// **'세계의 영웅'**
  String get titleNameT12;

  /// No description provided for @titleDescT12.
  ///
  /// In ko, this message translates to:
  /// **'레벨 50 달성'**
  String get titleDescT12;

  /// No description provided for @titleNameT13.
  ///
  /// In ko, this message translates to:
  /// **'파괴의 화신'**
  String get titleNameT13;

  /// No description provided for @titleDescT13.
  ///
  /// In ko, this message translates to:
  /// **'힘 퀘스트 XP +10%'**
  String get titleDescT13;

  /// No description provided for @titleNameT14.
  ///
  /// In ko, this message translates to:
  /// **'대현자'**
  String get titleNameT14;

  /// No description provided for @titleDescT14.
  ///
  /// In ko, this message translates to:
  /// **'지혜 퀘스트 XP +10%'**
  String get titleDescT14;

  /// No description provided for @titleNameT15.
  ///
  /// In ko, this message translates to:
  /// **'불멸의 전사'**
  String get titleNameT15;

  /// No description provided for @titleDescT15.
  ///
  /// In ko, this message translates to:
  /// **'건강 퀘스트 XP +10%'**
  String get titleDescT15;

  /// No description provided for @titleNameT16.
  ///
  /// In ko, this message translates to:
  /// **'절대 카리스마'**
  String get titleNameT16;

  /// No description provided for @titleDescT16.
  ///
  /// In ko, this message translates to:
  /// **'매력 퀘스트 XP +10%'**
  String get titleDescT16;

  /// No description provided for @titleNameT17.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 전설'**
  String get titleNameT17;

  /// No description provided for @titleDescT17.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 500회 완료'**
  String get titleDescT17;

  /// No description provided for @titleNameT18.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트의 신'**
  String get titleNameT18;

  /// No description provided for @titleDescT18.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 1000회 완료'**
  String get titleDescT18;

  /// No description provided for @titleNameT19.
  ///
  /// In ko, this message translates to:
  /// **'마스터 오브 올'**
  String get titleNameT19;

  /// No description provided for @titleDescT19.
  ///
  /// In ko, this message translates to:
  /// **'모든 스탯 50 달성'**
  String get titleDescT19;

  /// No description provided for @titleNameT20.
  ///
  /// In ko, this message translates to:
  /// **'초보 캠퍼'**
  String get titleNameT20;

  /// No description provided for @titleDescT20.
  ///
  /// In ko, this message translates to:
  /// **'레벨 3 달성'**
  String get titleDescT20;

  /// No description provided for @titleNameT21.
  ///
  /// In ko, this message translates to:
  /// **'경험 많은 여행자'**
  String get titleNameT21;

  /// No description provided for @titleDescT21.
  ///
  /// In ko, this message translates to:
  /// **'레벨 20 달성'**
  String get titleDescT21;

  /// No description provided for @titleNameT22.
  ///
  /// In ko, this message translates to:
  /// **'힘의 정점'**
  String get titleNameT22;

  /// No description provided for @titleDescT22.
  ///
  /// In ko, this message translates to:
  /// **'힘 100 달성!'**
  String get titleDescT22;

  /// No description provided for @titleNameT23.
  ///
  /// In ko, this message translates to:
  /// **'지혜의 정점'**
  String get titleNameT23;

  /// No description provided for @titleDescT23.
  ///
  /// In ko, this message translates to:
  /// **'지혜 100 달성!'**
  String get titleDescT23;

  /// No description provided for @titleNameT24.
  ///
  /// In ko, this message translates to:
  /// **'월간 레이드 돌파자'**
  String get titleNameT24;

  /// No description provided for @titleDescT24.
  ///
  /// In ko, this message translates to:
  /// **'월간 레이드 1회 클리어'**
  String get titleDescT24;

  /// No description provided for @titleNameT25.
  ///
  /// In ko, this message translates to:
  /// **'월간 레이드 정복자'**
  String get titleNameT25;

  /// No description provided for @titleDescT25.
  ///
  /// In ko, this message translates to:
  /// **'월간 레이드 5회 클리어'**
  String get titleDescT25;

  /// No description provided for @titleNameT26.
  ///
  /// In ko, this message translates to:
  /// **'연간 레이드 생존자'**
  String get titleNameT26;

  /// No description provided for @titleDescT26.
  ///
  /// In ko, this message translates to:
  /// **'연간 레이드 1회 클리어'**
  String get titleDescT26;

  /// No description provided for @titleNameT27.
  ///
  /// In ko, this message translates to:
  /// **'연간 레이드 군주'**
  String get titleNameT27;

  /// No description provided for @titleDescT27.
  ///
  /// In ko, this message translates to:
  /// **'연간 레이드 3회 클리어'**
  String get titleDescT27;

  /// No description provided for @skillNameSk1.
  ///
  /// In ko, this message translates to:
  /// **'근력 강화'**
  String get skillNameSk1;

  /// No description provided for @skillDescSk1.
  ///
  /// In ko, this message translates to:
  /// **'힘 퀘스트 XP +10%'**
  String get skillDescSk1;

  /// No description provided for @skillNameSk2.
  ///
  /// In ko, this message translates to:
  /// **'지혜의 빛'**
  String get skillNameSk2;

  /// No description provided for @skillDescSk2.
  ///
  /// In ko, this message translates to:
  /// **'지혜 퀘스트 XP +10%'**
  String get skillDescSk2;

  /// No description provided for @skillNameSk3.
  ///
  /// In ko, this message translates to:
  /// **'건강한 신체'**
  String get skillNameSk3;

  /// No description provided for @skillDescSk3.
  ///
  /// In ko, this message translates to:
  /// **'건강 퀘스트 XP +10%'**
  String get skillDescSk3;

  /// No description provided for @skillNameSk4.
  ///
  /// In ko, this message translates to:
  /// **'매력 발산'**
  String get skillNameSk4;

  /// No description provided for @skillDescSk4.
  ///
  /// In ko, this message translates to:
  /// **'매력 퀘스트 XP +10%'**
  String get skillDescSk4;

  /// No description provided for @skillNameSk5.
  ///
  /// In ko, this message translates to:
  /// **'퀘스트 전문가'**
  String get skillNameSk5;

  /// No description provided for @skillDescSk5.
  ///
  /// In ko, this message translates to:
  /// **'모든 퀘스트 XP +5%'**
  String get skillDescSk5;

  /// No description provided for @skillNameSk6.
  ///
  /// In ko, this message translates to:
  /// **'성장의 기쁨'**
  String get skillNameSk6;

  /// No description provided for @skillDescSk6.
  ///
  /// In ko, this message translates to:
  /// **'레벨업 시 추가 SP 1'**
  String get skillDescSk6;

  /// No description provided for @skillNameSk7.
  ///
  /// In ko, this message translates to:
  /// **'집중 훈련'**
  String get skillNameSk7;

  /// No description provided for @skillDescSk7.
  ///
  /// In ko, this message translates to:
  /// **'SP 1 소모 시 스탯 2 증가'**
  String get skillDescSk7;

  /// No description provided for @skillNameSk8.
  ///
  /// In ko, this message translates to:
  /// **'학습 가속'**
  String get skillNameSk8;

  /// No description provided for @skillDescSk8.
  ///
  /// In ko, this message translates to:
  /// **'모든 퀘스트 XP +10%'**
  String get skillDescSk8;

  /// No description provided for @skillNameSk9.
  ///
  /// In ko, this message translates to:
  /// **'초월적인 성장'**
  String get skillNameSk9;

  /// No description provided for @skillDescSk9.
  ///
  /// In ko, this message translates to:
  /// **'레벨업 시 기본 SP 5 → 7'**
  String get skillDescSk9;

  /// No description provided for @skillNameSk10.
  ///
  /// In ko, this message translates to:
  /// **'화염 검격'**
  String get skillNameSk10;

  /// No description provided for @skillDescSk10.
  ///
  /// In ko, this message translates to:
  /// **'전투 사용: 25 추가 대미지'**
  String get skillDescSk10;

  /// No description provided for @skillNameSk11.
  ///
  /// In ko, this message translates to:
  /// **'치유의 빛'**
  String get skillNameSk11;

  /// No description provided for @skillDescSk11.
  ///
  /// In ko, this message translates to:
  /// **'전투 사용: HP 20 회복'**
  String get skillDescSk11;

  /// No description provided for @skillNameSk12.
  ///
  /// In ko, this message translates to:
  /// **'번개 일격'**
  String get skillNameSk12;

  /// No description provided for @skillDescSk12.
  ///
  /// In ko, this message translates to:
  /// **'전투 사용: 50 대미지'**
  String get skillDescSk12;

  /// No description provided for @skillNameSk13.
  ///
  /// In ko, this message translates to:
  /// **'빙결 마법'**
  String get skillNameSk13;

  /// No description provided for @skillDescSk13.
  ///
  /// In ko, this message translates to:
  /// **'전투 사용: 35 대미지'**
  String get skillDescSk13;

  /// No description provided for @skillNameSk14.
  ///
  /// In ko, this message translates to:
  /// **'독안개'**
  String get skillNameSk14;

  /// No description provided for @skillDescSk14.
  ///
  /// In ko, this message translates to:
  /// **'전투 사용: 30 대미지'**
  String get skillDescSk14;

  /// No description provided for @skillNameSk15.
  ///
  /// In ko, this message translates to:
  /// **'보호막'**
  String get skillNameSk15;

  /// No description provided for @skillDescSk15.
  ///
  /// In ko, this message translates to:
  /// **'전투 사용: HP 40 회복'**
  String get skillDescSk15;

  /// No description provided for @skillNameSk16.
  ///
  /// In ko, this message translates to:
  /// **'대지진'**
  String get skillNameSk16;

  /// No description provided for @skillDescSk16.
  ///
  /// In ko, this message translates to:
  /// **'전투 사용: 70 대미지'**
  String get skillDescSk16;

  /// No description provided for @skillNameSk17.
  ///
  /// In ko, this message translates to:
  /// **'성스러운 기도'**
  String get skillNameSk17;

  /// No description provided for @skillDescSk17.
  ///
  /// In ko, this message translates to:
  /// **'전투 사용: HP 60 회복'**
  String get skillDescSk17;

  /// No description provided for @skillNameSk18.
  ///
  /// In ko, this message translates to:
  /// **'전투 본능'**
  String get skillNameSk18;

  /// No description provided for @skillDescSk18.
  ///
  /// In ko, this message translates to:
  /// **'힘 퀘스트 XP +15%'**
  String get skillDescSk18;

  /// No description provided for @skillNameSk19.
  ///
  /// In ko, this message translates to:
  /// **'명상의 경지'**
  String get skillNameSk19;

  /// No description provided for @skillDescSk19.
  ///
  /// In ko, this message translates to:
  /// **'지혜 퀘스트 XP +15%'**
  String get skillDescSk19;

  /// No description provided for @skillNameSk20.
  ///
  /// In ko, this message translates to:
  /// **'어둠의 검'**
  String get skillNameSk20;

  /// No description provided for @skillDescSk20.
  ///
  /// In ko, this message translates to:
  /// **'전투 사용: 100 대미지'**
  String get skillDescSk20;

  /// No description provided for @skillNameSk21.
  ///
  /// In ko, this message translates to:
  /// **'완전한 재생'**
  String get skillNameSk21;

  /// No description provided for @skillDescSk21.
  ///
  /// In ko, this message translates to:
  /// **'전투 사용: HP 80 회복'**
  String get skillDescSk21;

  /// No description provided for @skillNameSk22.
  ///
  /// In ko, this message translates to:
  /// **'극한 효율'**
  String get skillNameSk22;

  /// No description provided for @skillDescSk22.
  ///
  /// In ko, this message translates to:
  /// **'SP 1 소모 시 스탯 3 증가'**
  String get skillDescSk22;

  /// No description provided for @skillNameSk23.
  ///
  /// In ko, this message translates to:
  /// **'초월 가속'**
  String get skillNameSk23;

  /// No description provided for @skillDescSk23.
  ///
  /// In ko, this message translates to:
  /// **'모든 퀘스트 XP +20%'**
  String get skillDescSk23;

  /// No description provided for @skillNameSk24.
  ///
  /// In ko, this message translates to:
  /// **'신의 축복'**
  String get skillNameSk24;

  /// No description provided for @skillDescSk24.
  ///
  /// In ko, this message translates to:
  /// **'레벨업 시 추가 SP 3'**
  String get skillDescSk24;

  /// No description provided for @monsterSlimeGreen.
  ///
  /// In ko, this message translates to:
  /// **'초록 슬라임'**
  String get monsterSlimeGreen;

  /// No description provided for @monsterBat.
  ///
  /// In ko, this message translates to:
  /// **'동굴 박쥐'**
  String get monsterBat;

  /// No description provided for @monsterMushroom.
  ///
  /// In ko, this message translates to:
  /// **'독버섯'**
  String get monsterMushroom;

  /// No description provided for @monsterSlimeBlue.
  ///
  /// In ko, this message translates to:
  /// **'파랑 슬라임'**
  String get monsterSlimeBlue;

  /// No description provided for @monsterRat.
  ///
  /// In ko, this message translates to:
  /// **'거대 쥐'**
  String get monsterRat;

  /// No description provided for @monsterGoblin.
  ///
  /// In ko, this message translates to:
  /// **'고블린'**
  String get monsterGoblin;

  /// No description provided for @monsterSkeleton.
  ///
  /// In ko, this message translates to:
  /// **'해골 전사'**
  String get monsterSkeleton;

  /// No description provided for @monsterWolf.
  ///
  /// In ko, this message translates to:
  /// **'그림자 늑대'**
  String get monsterWolf;

  /// No description provided for @monsterSpiderGiant.
  ///
  /// In ko, this message translates to:
  /// **'거대 독거미'**
  String get monsterSpiderGiant;

  /// No description provided for @monsterTreant.
  ///
  /// In ko, this message translates to:
  /// **'움직이는 나무'**
  String get monsterTreant;

  /// No description provided for @monsterOrc.
  ///
  /// In ko, this message translates to:
  /// **'오크 전사'**
  String get monsterOrc;

  /// No description provided for @monsterDarkMage.
  ///
  /// In ko, this message translates to:
  /// **'다크 마법사'**
  String get monsterDarkMage;

  /// No description provided for @monsterGolem.
  ///
  /// In ko, this message translates to:
  /// **'스톤 골렘'**
  String get monsterGolem;

  /// No description provided for @monsterHarpy.
  ///
  /// In ko, this message translates to:
  /// **'하피'**
  String get monsterHarpy;

  /// No description provided for @monsterMimic.
  ///
  /// In ko, this message translates to:
  /// **'미믹'**
  String get monsterMimic;

  /// No description provided for @monsterLavaGolem.
  ///
  /// In ko, this message translates to:
  /// **'용암 골렘'**
  String get monsterLavaGolem;

  /// No description provided for @monsterFireSpirit.
  ///
  /// In ko, this message translates to:
  /// **'화염 정령'**
  String get monsterFireSpirit;

  /// No description provided for @monsterDemonWarrior.
  ///
  /// In ko, this message translates to:
  /// **'마족 전사'**
  String get monsterDemonWarrior;

  /// No description provided for @monsterSalamander.
  ///
  /// In ko, this message translates to:
  /// **'살라만더'**
  String get monsterSalamander;

  /// No description provided for @monsterCerberus.
  ///
  /// In ko, this message translates to:
  /// **'케르베로스'**
  String get monsterCerberus;

  /// No description provided for @monsterShadowKnight.
  ///
  /// In ko, this message translates to:
  /// **'그림자 기사'**
  String get monsterShadowKnight;

  /// No description provided for @monsterLich.
  ///
  /// In ko, this message translates to:
  /// **'리치'**
  String get monsterLich;

  /// No description provided for @monsterBehemoth.
  ///
  /// In ko, this message translates to:
  /// **'베히모스'**
  String get monsterBehemoth;

  /// No description provided for @monsterDarkPhoenix.
  ///
  /// In ko, this message translates to:
  /// **'어둠의 불사조'**
  String get monsterDarkPhoenix;

  /// No description provided for @monsterVoidWorm.
  ///
  /// In ko, this message translates to:
  /// **'차원 벌레'**
  String get monsterVoidWorm;

  /// No description provided for @monsterBossTroll.
  ///
  /// In ko, this message translates to:
  /// **'트롤 대장'**
  String get monsterBossTroll;

  /// No description provided for @monsterBossDragon.
  ///
  /// In ko, this message translates to:
  /// **'화염 드래곤'**
  String get monsterBossDragon;

  /// No description provided for @monsterBossDemonLord.
  ///
  /// In ko, this message translates to:
  /// **'마왕'**
  String get monsterBossDemonLord;

  /// No description provided for @monsterBossHydra.
  ///
  /// In ko, this message translates to:
  /// **'히드라'**
  String get monsterBossHydra;

  /// No description provided for @monsterBossFallenAngel.
  ///
  /// In ko, this message translates to:
  /// **'타락 천사'**
  String get monsterBossFallenAngel;

  /// No description provided for @monsterBossDeathKnight.
  ///
  /// In ko, this message translates to:
  /// **'죽음의 기사'**
  String get monsterBossDeathKnight;

  /// No description provided for @chapterName1.
  ///
  /// In ko, this message translates to:
  /// **'초원 방어선'**
  String get chapterName1;

  /// No description provided for @chapterName2.
  ///
  /// In ko, this message translates to:
  /// **'어둠의 숲'**
  String get chapterName2;

  /// No description provided for @chapterName3.
  ///
  /// In ko, this message translates to:
  /// **'폐허의 성'**
  String get chapterName3;

  /// No description provided for @chapterName4.
  ///
  /// In ko, this message translates to:
  /// **'용암 던전'**
  String get chapterName4;

  /// No description provided for @chapterName5.
  ///
  /// In ko, this message translates to:
  /// **'심연의 차원'**
  String get chapterName5;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
