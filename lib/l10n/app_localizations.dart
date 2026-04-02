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
