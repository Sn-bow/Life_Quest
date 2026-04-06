// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get cancel => '취소';

  @override
  String get save => '저장';

  @override
  String get close => '닫기';

  @override
  String get confirm => '확인';

  @override
  String get delete => '삭제';

  @override
  String get apply => '적용';

  @override
  String get change => '변경';

  @override
  String get complete => '완료';

  @override
  String get acquire => '습득';

  @override
  String get tabStatus => '상태창';

  @override
  String get tabQuests => '퀘스트';

  @override
  String get tabHunt => '사냥';

  @override
  String get tabInventory => '인벤토리';

  @override
  String get tabShop => '상점';

  @override
  String get tabAchievement => '업적';

  @override
  String get tabSkill => '스킬';

  @override
  String get loginTitle => '오늘의 행동을 경험치로 바꾸세요';

  @override
  String get loginSubtitle => '작은 퀘스트를 쌓아 캐릭터와 하루를 함께 성장시키는 생산성 RPG';

  @override
  String get loginEmailLabel => '이메일';

  @override
  String get loginPasswordLabel => '비밀번호';

  @override
  String get loginButton => '로그인';

  @override
  String get loginRegisterButton => '새 모험가 등록';

  @override
  String get loginDivider => '간편 로그인';

  @override
  String get loginGoogleButton => 'Google 계정으로 시작하기';

  @override
  String get loginErrorEmpty => '이메일과 비밀번호를 모두 입력해주세요.';

  @override
  String get loginErrorFailed => '로그인에 실패했습니다.';

  @override
  String get loginErrorGoogleToken => 'Google 인증 토큰을 가져올 수 없습니다. 다시 시도해주세요.';

  @override
  String get loginErrorGoogle => '구글 로그인에 실패했습니다.';

  @override
  String loginErrorUnknown(String error) {
    return '오류가 발생했습니다: $error';
  }

  @override
  String get signupTitle => '새 모험가 등록';

  @override
  String get signupPickPhoto => '프로필 사진 선택';

  @override
  String get signupEmailLabel => '이메일';

  @override
  String get signupEmailRequired => '이메일을 입력해주세요.';

  @override
  String get signupEmailInvalid => '유효한 이메일 형식을 입력해주세요. (예: name@example.com)';

  @override
  String get signupNicknameLabel => '닉네임';

  @override
  String get signupNicknameRequired => '닉네임을 입력해주세요.';

  @override
  String get signupPasswordLabel => '비밀번호';

  @override
  String get signupPasswordTooShort => '비밀번호는 6자 이상이어야 합니다.';

  @override
  String get signupPasswordConfirmLabel => '비밀번호 확인';

  @override
  String get signupPasswordMismatch => '비밀번호가 일치하지 않습니다.';

  @override
  String get signupButton => '가입 완료';

  @override
  String get signupSuccess => '🎉 회원가입 성공! 환영합니다!';

  @override
  String get signupErrorFailed => '회원가입에 실패했습니다.';

  @override
  String signupErrorUnknown(String error) {
    return '알 수 없는 오류가 발생했습니다: $error';
  }

  @override
  String get signupErrorUserCreate => '사용자 생성에 실패했습니다.';

  @override
  String get statusScreenTitle => '상태창';

  @override
  String get statusTimerTooltip => '집중 타이머';

  @override
  String get statusSettingsTooltip => '설정';

  @override
  String get statusHpLabel => 'HP';

  @override
  String get statusHpRecoveryHint => '비전투 상태에서는 10분마다 HP가 조금씩 자연 회복됩니다.';

  @override
  String statusStreakLabel(int days) {
    return '연속 달성: $days일';
  }

  @override
  String statusStreakBonus(int percent) {
    return 'XP +$percent%';
  }

  @override
  String get statusStatHint =>
      '레벨업 시 3포인트는 최근 완료한 퀘스트 성향에 따라 자동 성장하고, 나머지 포인트만 직접 분배합니다.';

  @override
  String get statusGoldLabel => '골드';

  @override
  String get statusApLabel => '행동력';

  @override
  String get statusBaseStatTitle => '기본 스탯';

  @override
  String get statusDetailStatButton => '상세 스탯 보기';

  @override
  String get statusDetailStatTitle => '📊 상세 전투 스탯';

  @override
  String get statusAttackLabel => '공격력 (Attack)';

  @override
  String get statusDefenseLabel => '방어력 (Defense)';

  @override
  String get statusCritLabel => '치명타율 (Crit Chance)';

  @override
  String get statusDodgeLabel => '회피율 (Dodge Chance)';

  @override
  String get statusStatStrength => '힘';

  @override
  String get statusStatWisdom => '지혜';

  @override
  String get statusStatHealth => '건강';

  @override
  String get statusStatCharm => '매력';

  @override
  String get statusTitleChangeTitle => '칭호 변경';

  @override
  String get statusStatApplyTitle => '스탯 적용 확인';

  @override
  String statusStatApplyBody(String summary) {
    return '다음 스탯을 적용하시겠습니까?\n\n$summary\n\n적용 후에는 되돌릴 수 없습니다.';
  }

  @override
  String get questsScreenTitle => '퀘스트 목록';

  @override
  String get questsTabDaily => '일일 퀘스트';

  @override
  String get questsTabWeekly => '주간 퀘스트';

  @override
  String get questsTabMonthly => '월간 레이드';

  @override
  String get questsTabYearly => '연간 레이드';

  @override
  String get questsEmptyDaily => '아직 추가된 퀘스트가 없어요.\n오늘 처리할 일부터 가볍게 추가해 보세요.';

  @override
  String get questsEmptyWeekly => '이번 주 루틴 목표가 아직 없습니다.\n꾸준히 반복할 목표를 넣어보세요.';

  @override
  String get questsEmptyMonthly =>
      '이번 달 레이드가 아직 없습니다.\n장기 목표를 월간 레이드로 등록해 보세요.';

  @override
  String get questsEmptyYearly =>
      '올해의 대형 레이드가 아직 없습니다.\n인생 목표급 도전을 연간 레이드로 추가해 보세요.';

  @override
  String get questsCategoryStrength => '힘';

  @override
  String get questsCategoryWisdom => '지혜';

  @override
  String get questsCategoryHealth => '건강';

  @override
  String get questsCategoryCharm => '매력';

  @override
  String get questsDifficultyEasy => '쉬움';

  @override
  String get questsDifficultyNormal => '보통';

  @override
  String get questsDifficultyHard => '어려움';

  @override
  String get questsDifficultyVeryHard => '매우 어려움';

  @override
  String get questsTypeDaily => '일일';

  @override
  String get questsTypeWeekly => '주간';

  @override
  String get questsTypeMonthly => '월간 레이드';

  @override
  String get questsTypeYearly => '연간 레이드';

  @override
  String get questsCompleteTitle => '퀘스트 완료';

  @override
  String questsCompleteConfirm(String questName) {
    return '\'$questName\' 퀘스트를 완료하시겠습니까?';
  }

  @override
  String get questsBaseRewardLabel => '기본 보상';

  @override
  String questsDoubleAdButton(int remaining) {
    return '광고 보고 2배 받기 ($remaining회)';
  }

  @override
  String get questsAdUnavailable => '광고를 불러올 수 없습니다. 기본 보상이 지급됩니다.';

  @override
  String get questsEditTitle => '퀘스트 수정';

  @override
  String get questsAddTitle => '새 퀘스트 추가';

  @override
  String get questsNameLabel => '퀘스트 이름';

  @override
  String get questsTypeLabel => '종류';

  @override
  String get questsCategoryLabel => '카테고리';

  @override
  String get questsDifficultyLabel => '난이도';

  @override
  String questsRewardPreview(String type, int xp, int gold) {
    return '$type 보상: $xp XP · $gold 골드';
  }

  @override
  String get questsNameRequired => '퀘스트 이름을 입력해주세요.';

  @override
  String get questsDeleteTitle => '퀘스트 삭제';

  @override
  String questsDeleteBody(String questName) {
    return '\'$questName\' 퀘스트를 삭제하시겠습니까?\n\n삭제된 퀘스트는 복구할 수 없습니다.';
  }

  @override
  String questsRaidClear(int count) {
    return '레이드 클리어 $count회 달성';
  }

  @override
  String get questsRaidBonusMonthly =>
      '레이드 보너스\n추가 XP · 추가 골드\nAP +2 · SP +1\n진행 보상 해금';

  @override
  String get questsRaidBonusYearly =>
      '레이드 보너스\n대량 XP · 대량 골드\nAP +4 · SP +2\n희귀 보상 해금';

  @override
  String get huntScreenTitle => '사냥터';

  @override
  String get huntMyHpLabel => '나의 HP';

  @override
  String huntComboBadge(int count) {
    return '💥 콤보: $count';
  }

  @override
  String huntApBadge(int ap) {
    return '⚡ AP: $ap';
  }

  @override
  String get huntActionAttack => '공격 (1 AP)';

  @override
  String get huntActionDefend => '방어 (1 AP)';

  @override
  String get huntActionSkill => '스킬 (자유)';

  @override
  String get huntActionBag => '가방 (1 AP)';

  @override
  String get huntActionFlee => '도망 (1 AP)';

  @override
  String get huntBagTitle => '가방 (소비 아이템)';

  @override
  String get huntBagEmpty => '사용할 수 있는 아이템이 없습니다.';

  @override
  String get huntBagUse => '사용 (1 AP)';

  @override
  String get huntSkillSelectTitle => '사용할 스킬을 선택하세요:';

  @override
  String get huntSkillEmpty => '배운 전투 스킬이 없습니다.';

  @override
  String get huntApLowTitle => 'AP 부족';

  @override
  String huntApLowBody(int remaining) {
    return 'AP가 부족합니다. 광고를 보고 AP를 2 회복하시겠습니까?\n(오늘 남은 횟수: $remaining회)';
  }

  @override
  String get huntApRecoverButton => '광고 보고 회복';

  @override
  String get huntApExhausted => '⚡ AP 부족! 퀘스트를 완료하세요. (오늘 광고 회복 모두 소진)';

  @override
  String huntDoubleRewardButton(int remaining) {
    return '광고 보고 보상 2배로 받기 ($remaining회 남음)';
  }

  @override
  String get huntDoubleRewardSuccess => '🎉 광고 보상으로 2배의 전리품을 획득했습니다!';

  @override
  String get huntAdUnavailable => '광고를 불러올 수 없습니다. 다시 시도해주세요.';

  @override
  String get huntResultButton => '결과 확인 & 돌아가기';

  @override
  String huntReviveButton(int remaining) {
    return '광고 보고 부활하기 (오늘 $remaining회 남음)';
  }

  @override
  String get huntReviveSuccess => '❤️ 광고 보상으로 즉시 부활했습니다!';

  @override
  String get huntReviveAdUnavailable => '광고를 불러올 수 없습니다. 잠시 후 다시 시도해주세요.';

  @override
  String get huntRetreatButton => '포기하고 돌아가기';

  @override
  String get inventoryScreenTitle => '인벤토리';

  @override
  String get inventoryEquippedSection => '장착 장비';

  @override
  String get inventoryCombatStatSection => '전투 스탯';

  @override
  String inventoryItemsSection(int count) {
    return '보유 아이템 ($count)';
  }

  @override
  String get inventorySlotWeapon => '⚔️ 무기';

  @override
  String get inventorySlotArmor => '🛡️ 방어구';

  @override
  String get inventorySlotAccessory => '💍 장신구';

  @override
  String get inventorySlotEmpty => '비어있음';

  @override
  String get inventoryUnequip => '해제';

  @override
  String get inventoryUseEquip => '사용 / 장착';

  @override
  String get inventoryEmptyMessage => '아이템이 없습니다\n몬스터를 사냥하여 장비를 획득하세요!';

  @override
  String get inventoryAttackLabel => '공격력';

  @override
  String get inventoryDefenseLabel => '방어력';

  @override
  String get inventoryHpLabel => '체력';

  @override
  String get inventoryStatStrength => '힘';

  @override
  String get inventoryStatWisdom => '지혜';

  @override
  String get inventoryStatHealth => '건강';

  @override
  String get inventoryStatCharm => '매력';

  @override
  String get inventoryStatAttack => '공격력';

  @override
  String get inventoryStatDefense => '방어력';

  @override
  String inventoryUsedHp(String itemName) {
    return '$itemName을 사용했습니다. (HP 회복)';
  }

  @override
  String inventoryUsedAp(String itemName) {
    return '$itemName을 사용했습니다. (AP 회복)';
  }

  @override
  String get inventoryRarityCommon => '일반';

  @override
  String get inventoryRarityUncommon => '고급';

  @override
  String get inventoryRarityRare => '희귀';

  @override
  String get inventoryRarityEpic => '영웅';

  @override
  String get inventoryRarityLegendary => '전설';

  @override
  String get shopScreenTitle => '상점';

  @override
  String get shopTabGameItems => '게임 아이템';

  @override
  String get shopTabCustomRewards => '나만의 보상';

  @override
  String get shopThemeBannerTitle => '테마 쇼케이스';

  @override
  String get shopThemeBannerSubtitle => '준비 중인 테마와 이펙트를 미리 둘러보세요.';

  @override
  String get shopConsumableSection => '소비 아이템';

  @override
  String get shopEquipBoxSection => '장비 상자';

  @override
  String get shopPermanentSection => '영구 강화';

  @override
  String get shopHpPotionName => 'HP 회복 물약';

  @override
  String get shopHpPotionDesc => 'HP를 30 회복합니다.';

  @override
  String get shopHpFullPotionName => 'HP 완전 회복 물약';

  @override
  String get shopHpFullPotionDesc => 'HP를 최대치로 회복합니다.';

  @override
  String get shopApPotionName => 'AP 충전 물약';

  @override
  String get shopApPotionDesc => 'AP를 5 회복합니다.';

  @override
  String get shopNormalBoxName => '일반 장비 상자';

  @override
  String get shopNormalBoxDesc => '일반~희귀 등급 장비를 랜덤 획득합니다.';

  @override
  String get shopNormalBoxSuccess => '장비를 획득했습니다! 인벤토리를 확인하세요!';

  @override
  String get shopPremiumBoxName => '고급 장비 상자';

  @override
  String get shopPremiumBoxDesc => '희귀~전설 등급 장비를 랜덤 획득합니다.';

  @override
  String get shopPremiumBoxSuccess => '고급 장비를 획득했습니다! 인벤토리를 확인하세요!';

  @override
  String get shopMaxHpName => '최대 HP +10';

  @override
  String get shopMaxHpDesc => '최대 HP를 영구적으로 10 증가시킵니다.';

  @override
  String get shopMaxHpSuccess => '최대 HP가 10 증가했습니다!';

  @override
  String get shopMaxApName => '최대 AP +2';

  @override
  String get shopMaxApDesc => '최대 AP를 영구적으로 2 증가시킵니다.';

  @override
  String get shopMaxApSuccess => '최대 AP가 2 증가했습니다!';

  @override
  String get shopCustomRewardAddTitle => '나만의 보상 추가';

  @override
  String get shopCustomRewardNameLabel => '보상 이름 (예: 넷플릭스 1시간)';

  @override
  String get shopCustomRewardDescLabel => '설명';

  @override
  String get shopCustomRewardDescHint => '이 보상을 즐기세요!';

  @override
  String get shopCustomRewardCostLabel => '필요 골드';

  @override
  String get shopCustomRewardIconLabel => '아이콘 (이모지)';

  @override
  String get shopCustomRewardAddButton => '보상 추가';

  @override
  String shopCustomRewardDeleted(String name) {
    return '$name 삭제됨';
  }

  @override
  String get shopAdSupportTitle => '선택형 광고로 앱을 운영합니다';

  @override
  String get shopAdSupportDesc =>
      '광고는 퀘스트 보상 2배, AP 회복, 전투 부활처럼 추가 보상이 필요할 때만 표시됩니다.';

  @override
  String get shopAdModelTitle => '광고 후원형 운영';

  @override
  String get shopAdModelDesc =>
      '현재 버전은 인앱결제보다 광고 수익 중심으로 운영됩니다. 유료 상품은 추후 검토됩니다.';

  @override
  String get achievementScreenTitle => '업적';

  @override
  String get achievementTabInProgress => '진행 중';

  @override
  String get achievementTabCompleted => '완료';

  @override
  String get achievementEmptyInProgress => '모든 업적을 달성했거나, 새로운 도전을 기다리고 있습니다!';

  @override
  String get achievementEmptyCompleted => '아직 완료한 업적이 없습니다.';

  @override
  String achievementRewardXp(int xp) {
    return '보상: $xp XP';
  }

  @override
  String achievementRewardSp(int sp) {
    return '보상: $sp SP';
  }

  @override
  String get skillScreenTitle => '스킬';

  @override
  String skillRequiredLevel(int level) {
    return '요구 조건: Lv.$level';
  }

  @override
  String get settingsScreenTitle => '설정';

  @override
  String get settingsAccountSection => '계정';

  @override
  String get settingsNicknameLabel => '닉네임';

  @override
  String get settingsNicknameChangeTitle => '닉네임 변경';

  @override
  String get settingsNicknameNewLabel => '새 닉네임';

  @override
  String get settingsAppSection => '앱 설정';

  @override
  String get settingsDarkMode => '다크 모드';

  @override
  String get settingsDarkModeSubtitle => '앱의 전체 테마를 변경합니다.';

  @override
  String get settingsSfx => '사운드 효과음 (SFX)';

  @override
  String get settingsSfxSubtitle => '각종 게임 효과음을 켜거나 끕니다.';

  @override
  String get settingsNotification => '알림 설정';

  @override
  String get settingsNotificationSubtitle => '매일 아침 9시에 퀘스트 알림을 받습니다.';

  @override
  String get settingsNotificationEnabled => '매일 아침 9시, 저녁 8시에 알림이 예약되었습니다.';

  @override
  String get settingsNotificationDisabled => '모든 알림이 취소되었습니다.';

  @override
  String get settingsAdSupportSection => '광고 후원 안내';

  @override
  String get settingsAdSupportTitle => '선택형 광고로 앱을 운영합니다';

  @override
  String get settingsAdSupportDesc =>
      '광고는 퀘스트 보상 2배, AP 회복, 전투 부활처럼 추가 보상이 필요할 때만 표시됩니다.';

  @override
  String get settingsAdModelTitle => '광고 후원형 운영';

  @override
  String get settingsAdModelDesc =>
      '현재 버전은 인앱결제보다 광고 수익 중심으로 운영됩니다. 유료 상품은 추후 검토됩니다.';

  @override
  String get settingsLogout => '로그아웃';

  @override
  String get settingsWithdraw => '회원 탈퇴';

  @override
  String get settingsWithdrawTitle => '회원 탈퇴';

  @override
  String get settingsWithdrawBody =>
      '정말로 탈퇴하시겠습니까?\n모든 데이터가 영구적으로 삭제되며, 이 작업은 되돌릴 수 없습니다.';

  @override
  String get settingsWithdrawConfirm => '탈퇴 확인';

  @override
  String get loadingSync => '헌터 정보를 동기화하는 중';

  @override
  String get loadingSyncDesc => '오늘의 퀘스트와 성장 기록을 불러옵니다';

  @override
  String get loadingGate => '게이트를 여는 중';

  @override
  String get loadingGateDesc => '시스템을 초기화하고 있습니다';

  @override
  String get loadingTagline => 'ARISE YOUR QUEST';

  @override
  String get timerScreenFocus => '🍅 집중 타이머';

  @override
  String get timerScreenBreak => '☕ 휴식 타이머';

  @override
  String get timerFocusMode => '집중 모드';

  @override
  String get timerBreakMode => '휴식 모드';

  @override
  String timerSessionCount(int count) {
    return '세션 $count 완료';
  }

  @override
  String get timerFocusCompleteTitle => '🎉 집중 완료!';

  @override
  String timerFocusCompleteBody(int minutes) {
    return '$minutes분 집중 세션 완료!';
  }

  @override
  String get timerGoldRewardLabel => '골드 +';

  @override
  String timerTodaySessions(int count) {
    return '오늘 완료: $count 세션';
  }

  @override
  String get timerStartBreak => '휴식 시작';

  @override
  String get timerFocusRewardLabel => '집중 완료 보상:';

  @override
  String get cosmeticShopTitle => '테마 쇼케이스';

  @override
  String get cosmeticCategoryTheme => '앱 테마';

  @override
  String get cosmeticCategoryTitleEffect => '칭호 이펙트';

  @override
  String get cosmeticCategoryCombatEffect => '전투 이펙트';

  @override
  String get cosmeticComingSoonTitle => '프리미엄 꾸미기 기능은 준비 중입니다';

  @override
  String get cosmeticComingSoonDesc =>
      '현재는 광고 후원형 운영에 집중하고 있습니다. 테마와 이펙트 상품은 추후 정식 오픈 예정입니다.';

  @override
  String get cosmeticUnequip => '장착 해제';

  @override
  String get cosmeticEquip => '장착';

  @override
  String get cosmeticComingSoon => '준비 중';

  @override
  String get cosmeticComingSoonSnackbar =>
      '코스메틱 상품은 추후 오픈 예정입니다. 현재는 광고 후원형 운영에 집중하고 있습니다.';

  @override
  String get questTileEditTooltip => '퀘스트 수정';

  @override
  String get questTileDeleteTooltip => '퀘스트 삭제';

  @override
  String get notificationMorningTitle => '오늘의 퀘스트를 시작하세요!';

  @override
  String get notificationMorningBody => '새로운 하루가 시작되었습니다. 당신의 성장을 기록해 보세요.';

  @override
  String get notificationEveningTitle => '오늘 퀘스트를 모두 완료하셨나요?';

  @override
  String get notificationEveningBody => '아직 완료하지 못한 퀘스트가 있다면 HP가 감소할 수 있어요!';

  @override
  String get initialTitleRookie => '새싹 모험가';

  @override
  String get initialQuestMorning => '아침 7시 기상';

  @override
  String get initialQuestExercise => '운동 30분';

  @override
  String get initialQuestRead => '책 10페이지 읽기';

  @override
  String get initialQuestWeeklyExercise => '주 3회 이상 운동하기';

  @override
  String get initialQuestWeeklyLearn => '새로운 기술/지식 학습하기';

  @override
  String get initialQuestMonthlyExercise => '이번 달 운동 12회 달성';

  @override
  String get initialQuestMonthlyProject => '사이드 프로젝트 핵심 기능 완성';

  @override
  String get initialQuestYearly => '올해 대표 목표 하나 완수하기';

  @override
  String get reportScreenTitle => '상세 리포트';

  @override
  String get reportExpandedUnlocked => '확장 리포트를 오늘 하루 동안 열었습니다.';

  @override
  String get reportAdFailed => '광고를 불러오지 못했습니다. 잠시 후 다시 시도해주세요.';

  @override
  String get reportSummaryStreak => '현재 연속 기록';

  @override
  String reportSummaryStreakValue(int days) {
    return '$days일';
  }

  @override
  String get reportSummaryXp => '현재 XP';

  @override
  String get reportSummaryQuestCount => '완료한 퀘스트';

  @override
  String reportSummaryQuestCountValue(int count) {
    return '$count개';
  }

  @override
  String get reportSummaryTitle => '현재 칭호';

  @override
  String get reportWeeklyActivityTitle => '한주간의 활동 기록';

  @override
  String get reportWeeklyActivitySubtitle => '이번 주 루틴 유지 흐름을 먼저 확인할 수 있습니다.';

  @override
  String get reportWeekDayMon => '월';

  @override
  String get reportWeekDayTue => '화';

  @override
  String get reportWeekDayWed => '수';

  @override
  String get reportWeekDayThu => '목';

  @override
  String get reportWeekDayFri => '금';

  @override
  String get reportWeekDaySat => '토';

  @override
  String get reportWeekDaySun => '일';

  @override
  String get reportExpandedEntryTitle => '광고로 여는 확장 리포트';

  @override
  String get reportExpandedAlreadyUnlocked =>
      '오늘은 이미 확장 리포트가 해금되었습니다. 아래에서 심층 분석을 바로 볼 수 있습니다.';

  @override
  String get reportExpandedDescription =>
      '심층 분석을 열면 카테고리 비율, 이번 레벨 성장 성향, 자동 성장 기록을 확인할 수 있습니다.';

  @override
  String get reportFeatureCategoryRatio => '퀘스트 카테고리 비율';

  @override
  String get reportFeatureGrowthTrend => '다음 레벨 성장 성향 분석';

  @override
  String get reportFeatureAutoGrowth => '직전 레벨 자동 성장 기록';

  @override
  String get reportUnlockedToday => '오늘 확장 리포트 해금됨';

  @override
  String reportWatchAdButton(int count) {
    return '광고 보고 확장 리포트 열기 (오늘 $count회 남음)';
  }

  @override
  String get reportNoMoreViews => '오늘은 더 이상 열 수 없습니다';

  @override
  String get reportCategoryRatioTitle => '퀘스트 카테고리 비율';

  @override
  String get reportInsightGrowthTrendTitle => '이번 레벨 성장 성향';

  @override
  String get reportInsightGrowthTrendCaption => '완료한 퀘스트가 가장 많이 반영되는 방향입니다.';

  @override
  String get reportInsightGrowthTrendCaptionEmpty =>
      '퀘스트를 완료하면 자동 성장 경향이 쌓입니다.';

  @override
  String get reportInsightDataInsufficient => '데이터 부족';

  @override
  String get reportInsightAutoGrowthTitle => '직전 레벨 자동 성장';

  @override
  String get reportInsightAutoGrowthCaption =>
      '레벨업 시 3포인트는 행동 통계 기반으로 자동 배분됩니다.';

  @override
  String get reportInsightBestDayTitle => '이번 주 최고 몰입일';

  @override
  String reportInsightBestDayCaption(int count) {
    return '이번 주 완료한 퀘스트는 총 $count개입니다.';
  }

  @override
  String get reportInsightRecommendedStatTitle => '추천 집중 스탯';

  @override
  String get reportInsightBalanced => '균형 잡힘';

  @override
  String get reportNextLevelPredictionTitle => '다음 레벨 자동 성장 예측';

  @override
  String get reportLongTermTitle => '장기 목표 진행률';

  @override
  String get reportLongTermSubtitle => '월간과 연간 레이드 진행 상황을 한 번에 확인할 수 있습니다.';

  @override
  String get reportProgressMonthlyRaid => '월간 레이드';

  @override
  String get reportProgressYearlyRaid => '연간 레이드';

  @override
  String get reportLowestStat => '현재 최저 스탯';

  @override
  String get reportHighestStat => '최고 스탯';

  @override
  String get reportCalendarTitle => '퀘스트 달력';

  @override
  String get reportCalendarWeekdaySun => '일';

  @override
  String get reportCalendarWeekdayMon => '월';

  @override
  String get reportCalendarWeekdayTue => '화';

  @override
  String get reportCalendarWeekdayWed => '수';

  @override
  String get reportCalendarWeekdayThu => '목';

  @override
  String get reportCalendarWeekdayFri => '금';

  @override
  String get reportCalendarWeekdaySat => '토';

  @override
  String reportCalendarSelectedTitle(int month, int day) {
    return '$month월 $day일 완료 퀘스트';
  }

  @override
  String get reportCalendarSelectPrompt => '날짜를 선택하세요';

  @override
  String get reportCalendarNoQuests => '이 날짜에는 완료한 퀘스트가 없습니다.';

  @override
  String get reportNoRecord => '기록 없음';

  @override
  String get reportStatBalanced => '현재는 스탯 밸런스가 안정적입니다.';

  @override
  String reportAddQuestSuggestion(String category) {
    return '$category 계열 퀘스트를 추가해 보세요';
  }

  @override
  String reportRecommendedAction(String action) {
    return '추천 행동: $action';
  }

  @override
  String reportBestWeekday(String weekday, int count) {
    return '$weekday $count개';
  }

  @override
  String get reportWeekdayMonday => '월요일';

  @override
  String get reportWeekdayTuesday => '화요일';

  @override
  String get reportWeekdayWednesday => '수요일';

  @override
  String get reportWeekdayThursday => '목요일';

  @override
  String get reportWeekdayFriday => '금요일';

  @override
  String get reportWeekdaySaturday => '토요일';

  @override
  String get reportWeekdaySunday => '일요일';

  @override
  String reportStatValue(String stat, int value) {
    return '$stat $value';
  }

  @override
  String shopItemAcquired(String name) {
    return '$name을(를) 획득했습니다!';
  }

  @override
  String get shopCustomRewardFabLabel => '보상 추가';

  @override
  String get statusReportTooltip => '상세 리포트 보기';
}
