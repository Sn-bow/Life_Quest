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

  @override
  String get dungeonHomeTitle => '소울 덱';

  @override
  String get dungeonHomeCardCollectionTooltip => '카드 컬렉션';

  @override
  String get dungeonHomeDungeonSelection => '던전 선택';

  @override
  String dungeonHomeRequiredLevel(int requiredLevel) {
    return '레벨 $requiredLevel 이상 필요합니다';
  }

  @override
  String get zone1Name => '푸른 초원';

  @override
  String get zone1Description => '초보 모험가를 위한 첫 번째 던전';

  @override
  String get zone2Name => '어둠의 숲';

  @override
  String get zone2Description => '독과 디버프를 사용하는 적들이 도사리는 곳';

  @override
  String get zone3Name => '폐허의 성';

  @override
  String get zone3Description => '방어 특화 적과 다중 전투가 기다린다';

  @override
  String get zone4Name => '용암 동굴';

  @override
  String get zone4Description => '화상과 고데미지의 지옥';

  @override
  String get zone5Name => '심연의 차원';

  @override
  String get zone5Description => '의도를 숨기는 적들, 저주가 내리는 최종 던전';

  @override
  String get seasonName => '시즌 1: 영혼의 각성';

  @override
  String get seasonEnded => '종료';

  @override
  String seasonCountdown(int days) {
    return 'D-$days';
  }

  @override
  String get ascensionModeTitle => '어센션 모드';

  @override
  String get ascensionInactive => '미활성';

  @override
  String get ascensionActiveModifiers => '적용 중인 페널티:';

  @override
  String get ascensionSliderHint => '슬라이더를 올려 난이도를 높이세요';

  @override
  String get ascensionLevel1Modifier => 'Lv 1: 적 HP +10%';

  @override
  String get ascensionLevel2Modifier => 'Lv 2: 적 공격력 +10%';

  @override
  String get ascensionLevel3Modifier => 'Lv 3: 시작 골드 -30';

  @override
  String get ascensionLevel4Modifier => 'Lv 4: 저주 카드 1장 추가';

  @override
  String get ascensionLevel5Modifier => 'Lv 5: 엘리트 처치 후 카드 선택 없음';

  @override
  String get ascensionLevel6Modifier => 'Lv 6: 상점 가격 +25%';

  @override
  String get ascensionLevel7Modifier => 'Lv 7: 시작 HP -10%';

  @override
  String get ascensionLevel8Modifier => 'Lv 8: 보스 HP +25%';

  @override
  String get ascensionLevel9Modifier => 'Lv 9: 이벤트 불이익 선택지 강화';

  @override
  String get ascensionLevel10Modifier => 'Lv 10: 모든 적 HP +20%';

  @override
  String get infiniteTowerTitle => '무한의 탑';

  @override
  String infiniteTowerBestFloorDesc(int bestFloor) {
    return '끝없는 도전 · 최고 기록: $bestFloor층';
  }

  @override
  String get infiniteTowerSelectFloor => '도전할 층 선택';

  @override
  String get infiniteTowerFloorInfo => '층 정보';

  @override
  String infiniteTowerChallengeFloor(int targetFloor) {
    return '$targetFloor층 도전하기';
  }

  @override
  String get infiniteTowerFloorComposition => '층 구성';

  @override
  String get infiniteTowerBestFloorLabel => '최고 기록';

  @override
  String infiniteTowerFloorDisplay(int floor) {
    return '$floor층';
  }

  @override
  String get infiniteTowerEnemyHp => '적 HP';

  @override
  String get infiniteTowerEnemyAttack => '적 공격력';

  @override
  String get infiniteTowerDefault => '기본';

  @override
  String get infiniteTowerFloor1To5 => '1-5층';

  @override
  String get infiniteTowerFloor6To10 => '6-10층';

  @override
  String get infiniteTowerFloor11To15 => '11-15층';

  @override
  String get infiniteTowerFloor16To20 => '16-20층';

  @override
  String get infiniteTowerFloor21To25 => '21-25층';

  @override
  String get infiniteTowerFloor26Plus => '26층+';

  @override
  String get infiniteTowerRepeatZones => '이후 Zone 1부터 반복 (난이도 계속 상승)';

  @override
  String get dungeonMapTitle => '던전 지도';

  @override
  String get dungeonMapNoData => '던전 데이터가 없습니다';

  @override
  String get dungeonRestTitle => '휴식처';

  @override
  String get dungeonRestDescription =>
      '조용한 휴식처를 발견했다. 따뜻한 모닥불이 타오르고 있다.\n무엇을 하겠는가?';

  @override
  String get dungeonRestRestTitle => '휴식';

  @override
  String get dungeonRestRestDescription => 'HP의 30%를 회복합니다';

  @override
  String dungeonRestHealResult(int healAmount) {
    return 'HP가 $healAmount 회복되었습니다!';
  }

  @override
  String get dungeonRestTrainTitle => '수련';

  @override
  String get dungeonRestTrainDescription => '카드 1장을 강화합니다';

  @override
  String get dungeonRestNoCardsToUpgrade => '강화할 카드가 없습니다';

  @override
  String get dungeonRestContinueButton => '계속';

  @override
  String get dungeonRestSelectCardToUpgrade => '강화할 카드를 선택하세요';

  @override
  String get dungeonRestCardUpgraded => '강화됨';

  @override
  String get dungeonShopTitle => '던전 상점';

  @override
  String get dungeonShopCardsSection => '카드';

  @override
  String get dungeonShopNoCards => '판매 중인 카드가 없습니다';

  @override
  String get dungeonShopRelicsSection => '유물';

  @override
  String get dungeonShopNoRelics => '판매 중인 유물이 없습니다';

  @override
  String get dungeonShopCardRemovalSection => '카드 제거';

  @override
  String get dungeonShopLeaveButton => '상점 나가기';

  @override
  String get dungeonShopSelectCardToRemove => '제거할 카드를 선택하세요';

  @override
  String dungeonShopRemovalCost(int cost) {
    return '비용: $cost 골드';
  }

  @override
  String get dungeonShopPurchaseComplete => '구매 완료';

  @override
  String get dungeonShopRemoveOneCard => '카드 1장 제거';

  @override
  String dungeonShopRemovalDescription(int deckSize) {
    return '덱에서 원하지 않는 카드를 제거합니다 (현재 덱: $deckSize장)';
  }

  @override
  String get dungeonEventTitle => '이벤트';

  @override
  String get dungeonEventNoData => '이벤트 데이터가 없습니다';

  @override
  String get dungeonEventChooseAction => '선택하세요';

  @override
  String get dungeonEventContinueButton => '계속';

  @override
  String get dungeonEventOutcomeTitle => '결과';

  @override
  String get dungeonEventEffectCardReward => '카드 획득';

  @override
  String get dungeonEventEffectRelicReward => '유물 획득';

  @override
  String get dungeonEventEffectCardRemove => '카드 제거';

  @override
  String get dungeonEventEffectCardUpgrade => '카드 강화';

  @override
  String get dungeonEventEffectCurseAdded => '저주 추가';

  @override
  String get dungeonResultVictoryTitle => '던전 클리어!';

  @override
  String get dungeonResultDefeatTitle => '모험 실패...';

  @override
  String get dungeonResultVictoryMessage => '축하합니다! 모든 적을 물리치고 던전을 정복했습니다.';

  @override
  String get dungeonResultDefeatMessage => '아쉽게도 이번 모험은 실패했습니다. 다시 도전해보세요.';

  @override
  String get dungeonResultStatsTitle => '모험 기록';

  @override
  String get dungeonResultStatsZone => '지역';

  @override
  String get dungeonResultStatsNodesCompleted => '노드 완료';

  @override
  String get dungeonResultStatsMonsterKilled => '몬스터 처치';

  @override
  String get dungeonResultRewardsTitle => '보상';

  @override
  String dungeonResultXpReward(int xpGained) {
    return '+$xpGained XP';
  }

  @override
  String dungeonResultGoldReward(int goldGained) {
    return '+$goldGained 골드';
  }

  @override
  String get dungeonResultVictoryBonus => '클리어 보너스 x1.5 + 보스 처치 보너스';

  @override
  String get dungeonResultDefeatPenalty => '패배 페널티: 보상 x0.5';

  @override
  String get dungeonResultReturnHomeButton => '홈으로 돌아가기';

  @override
  String get cardBattleYourTurn => '당신의 턴';

  @override
  String get cardBattleEnemyTurn => '적의 턴';

  @override
  String cardBattleTurnCount(int turnCount) {
    return '턴 $turnCount';
  }

  @override
  String get cardBattleAbandonDialog => '전투 포기';

  @override
  String get cardBattleAbandonConfirmation => '전투를 포기하시겠습니까? 진행 사항이 사라집니다.';

  @override
  String get cardBattleAbandonButton => '포기';

  @override
  String get cardBattleNoEnemies => '적이 없습니다';

  @override
  String get cardBattleEndTurnButton => '턴 종료';

  @override
  String get cardBattleNoCardsInHand => '손에 카드가 없습니다';

  @override
  String get cardBattleVictory => '승리!';

  @override
  String cardBattleGoldReward(int gold) {
    return '+$gold 골드';
  }

  @override
  String get cardBattleSelectCard => '카드를 선택하세요';

  @override
  String get cardBattleSkipButton => '건너뛰기';

  @override
  String get cardRarityCommon => '일반';

  @override
  String get cardRarityUncommon => '고급';

  @override
  String get cardRarityRare => '희귀';

  @override
  String get cardRarityLegendary => '전설';

  @override
  String get cardCategoryAttack => '공격';

  @override
  String get cardCategoryMagic => '마법';

  @override
  String get cardCategoryDefense => '방어';

  @override
  String get cardCategoryTactical => '전술';

  @override
  String get cardCollectionTitle => '카드 컬렉션';

  @override
  String get cardCollectionFilterAll => '전체';

  @override
  String get cardCollectionMyCollection => '내 컬렉션';

  @override
  String cardCollectionCardCount(int count) {
    return '($count장)';
  }

  @override
  String get cardCollectionNoCards =>
      '보유한 카드가 없습니다.\n퀘스트를 완료하면 카드를 획득할 수 있습니다!';

  @override
  String cardCollectionDeckInclusion(int copyCount) {
    return '덱에 $copyCount장 포함됨';
  }

  @override
  String get cardCollectionAddToDeck => '덱에 추가';

  @override
  String get cardCollectionDeckFull => '덱이 가득 참 (20장)';

  @override
  String get cardCollectionMaxCopies => '최대 3장까지 추가 가능';

  @override
  String cardCollectionAddedToDeck(String cardName) {
    return '$cardName 덱에 추가됨';
  }

  @override
  String get cardCollectionMyDeck => '내 덱';

  @override
  String cardCollectionDeckSize(int deckSize) {
    return '($deckSize/20장)';
  }

  @override
  String get cardCollectionResetDeckDialog => '덱 초기화';

  @override
  String get cardCollectionResetDeckConfirmation =>
      '커스텀 덱을 삭제하고 기본 스타터 덱으로 되돌리겠습니까?';

  @override
  String get cardCollectionResetButton => '초기화';

  @override
  String get cardCollectionDefaultDeckMessage =>
      '기본 스타터 덱 사용 중\n컬렉션에서 카드를 추가하세요';

  @override
  String get cardNameBaseStrike => '기본 공격';

  @override
  String get cardDescBaseStrike => '6 데미지를 준다.';

  @override
  String get cardNameBaseDefend => '기본 방어';

  @override
  String get cardDescBaseDefend => '방어도 5를 얻는다.';

  @override
  String get cardNameBaseFocus => '집중';

  @override
  String get cardDescBaseFocus => '카드 1장을 드로우한다.';

  @override
  String get cardNameCursePain => '고통';

  @override
  String get cardDescCursePain => '사용 불가. 패에 잡히면 HP 1을 잃는다.';

  @override
  String get cardNameCurseDoubt => '의심';

  @override
  String get cardDescCurseDoubt => '사용 불가. 패에 있으면 드로우 -1.';

  @override
  String get cardNameCurseBurden => '짐';

  @override
  String get cardDescCurseBurden => '사용 불가. 패에 있으면 에너지 -1.';

  @override
  String get cardNameCurseDecay => '부식';

  @override
  String get cardDescCurseDecay => '사용 불가. 매 턴 방어 -3.';

  @override
  String get cardNameAtkC01 => '강타';

  @override
  String get cardDescAtkC01 => '6 데미지를 준다.';

  @override
  String get cardNameAtkC01Up => '강타+';

  @override
  String get cardDescAtkC01Up => '9 데미지를 준다.';

  @override
  String get cardNameAtkC02 => '베기';

  @override
  String get cardDescAtkC02 => '4 데미지를 주고, 카드 1장을 드로우한다.';

  @override
  String get cardNameAtkC02Up => '베기+';

  @override
  String get cardDescAtkC02Up => '6 데미지를 주고, 카드 1장을 드로우한다.';

  @override
  String get cardNameAtkC03 => '연속 공격';

  @override
  String get cardDescAtkC03 => '3 데미지를 2회 준다.';

  @override
  String get cardNameAtkC03Up => '연속 공격+';

  @override
  String get cardDescAtkC03Up => '3 데미지를 3회 준다.';

  @override
  String get cardNameAtkC04 => '분노의 일격';

  @override
  String get cardDescAtkC04 => '3 데미지를 주고, 분노 카드 1장을 디스카드에 추가한다.';

  @override
  String get cardNameAtkC04Up => '분노의 일격+';

  @override
  String get cardDescAtkC04Up => '5 데미지를 준다.';

  @override
  String get cardNameAtkC05 => '돌진';

  @override
  String get cardDescAtkC05 => '12 데미지를 준다.';

  @override
  String get cardNameAtkC05Up => '돌진+';

  @override
  String get cardDescAtkC05Up => '16 데미지를 준다.';

  @override
  String get cardNameAtkC06 => '출혈 공격';

  @override
  String get cardDescAtkC06 => '4 데미지를 주고, 독 2를 부여한다.';

  @override
  String get cardNameAtkC06Up => '출혈 공격+';

  @override
  String get cardDescAtkC06Up => '4 데미지를 주고, 독 4를 부여한다.';

  @override
  String get cardNameAtkC07 => '빠른 찌르기';

  @override
  String get cardDescAtkC07 => '3 데미지를 준다.';

  @override
  String get cardNameAtkC07Up => '빠른 찌르기+';

  @override
  String get cardDescAtkC07Up => '5 데미지를 준다.';

  @override
  String get cardNameAtkC08 => '도발';

  @override
  String get cardDescAtkC08 => '5 데미지를 주고, 취약 1턴을 부여한다.';

  @override
  String get cardNameAtkC08Up => '도발+';

  @override
  String get cardDescAtkC08Up => '8 데미지를 주고, 취약 1턴을 부여한다.';

  @override
  String get cardNameAtkC09 => '기습';

  @override
  String get cardDescAtkC09 => '첫 턴이면 12 데미지, 아니면 6 데미지.';

  @override
  String get cardNameAtkC09Up => '기습+';

  @override
  String get cardDescAtkC09Up => '첫 턴이면 18 데미지, 아니면 9 데미지.';

  @override
  String get cardNameAtkC10 => '칼날 바람';

  @override
  String get cardDescAtkC10 => '적 전체에 3 데미지를 준다.';

  @override
  String get cardNameAtkC10Up => '칼날 바람+';

  @override
  String get cardDescAtkC10Up => '적 전체에 5 데미지를 준다.';

  @override
  String get cardNameAtkU01 => '파워 슬래시';

  @override
  String get cardDescAtkU01 => '14 데미지를 주고, 취약 2턴을 부여한다.';

  @override
  String get cardNameAtkU01Up => '파워 슬래시+';

  @override
  String get cardDescAtkU01Up => '18 데미지를 주고, 취약 2턴을 부여한다.';

  @override
  String get cardNameAtkU02 => '칼날 춤';

  @override
  String get cardDescAtkU02 => '3 데미지를 3회 주고, 방어도 3을 얻는다.';

  @override
  String get cardNameAtkU02Up => '칼날 춤+';

  @override
  String get cardDescAtkU02Up => '4 데미지를 3회 주고, 방어도 5를 얻는다.';

  @override
  String get cardNameAtkU03 => '처형';

  @override
  String get cardDescAtkU03 => '적 HP 50% 이하면 30 데미지, 아니면 10 데미지.';

  @override
  String get cardNameAtkU03Up => '처형+';

  @override
  String get cardDescAtkU03Up => '적 HP 50% 이하면 40 데미지, 아니면 14 데미지.';

  @override
  String get cardNameAtkU04 => '광폭화';

  @override
  String get cardDescAtkU04 => '힘 +2를 획득한다 (영구).';

  @override
  String get cardNameAtkU04Up => '광폭화+';

  @override
  String get cardDescAtkU04Up => '힘 +3을 획득한다 (영구).';

  @override
  String get cardNameAtkU05 => '피의 맹세';

  @override
  String get cardDescAtkU05 => 'HP 3을 잃고, 8 데미지를 주고, 힘 +1을 얻는다.';

  @override
  String get cardNameAtkU05Up => '피의 맹세+';

  @override
  String get cardDescAtkU05Up => 'HP 3을 잃고, 12 데미지를 주고, 힘 +1을 얻는다.';

  @override
  String get cardNameAtkU06 => '회전 베기';

  @override
  String get cardDescAtkU06 => '적 전체에 8 데미지를 준다.';

  @override
  String get cardNameAtkU06Up => '회전 베기+';

  @override
  String get cardDescAtkU06Up => '적 전체에 12 데미지를 준다.';

  @override
  String get cardNameAtkU07 => '분쇄';

  @override
  String get cardDescAtkU07 => '10 데미지를 주고, 약화 2턴을 부여한다.';

  @override
  String get cardNameAtkU07Up => '분쇄+';

  @override
  String get cardDescAtkU07Up => '14 데미지를 주고, 약화 2턴을 부여한다.';

  @override
  String get cardNameAtkU08 => '무자비';

  @override
  String get cardDescAtkU08 => '취약 상태 적에게 데미지 2배 (기본 6 데미지).';

  @override
  String get cardNameAtkU08Up => '무자비+';

  @override
  String get cardDescAtkU08Up => '취약 상태 적에게 데미지 2배 (기본 9 데미지).';

  @override
  String get cardNameAtkR01 => '용의 일격';

  @override
  String get cardDescAtkR01 => '30 데미지를 주고, 화상 3턴을 부여한다.';

  @override
  String get cardNameAtkR01Up => '용의 일격+';

  @override
  String get cardDescAtkR01Up => '40 데미지를 주고, 화상 4턴을 부여한다.';

  @override
  String get cardNameAtkR02 => '천 번의 베기';

  @override
  String get cardDescAtkR02 => '1 데미지를 패에 든 카드 수만큼 준다.';

  @override
  String get cardNameAtkR02Up => '천 번의 베기+';

  @override
  String get cardDescAtkR02Up => '2 데미지를 패에 든 카드 수만큼 준다.';

  @override
  String get cardNameAtkR03 => '폭풍의 검';

  @override
  String get cardDescAtkR03 => '5 데미지를 이번 턴 사용한 카드 수만큼 준다.';

  @override
  String get cardNameAtkR03Up => '폭풍의 검+';

  @override
  String get cardDescAtkR03Up => '7 데미지를 이번 턴 사용한 카드 수만큼 준다.';

  @override
  String get cardNameAtkR04 => '사신의 낫';

  @override
  String get cardDescAtkR04 => '15 데미지를 주고, 킬 시 HP 10을 회복한다.';

  @override
  String get cardNameAtkR04Up => '사신의 낫+';

  @override
  String get cardDescAtkR04Up => '20 데미지를 주고, 킬 시 HP 15를 회복한다.';

  @override
  String get cardNameAtkR05 => '버서크';

  @override
  String get cardDescAtkR05 => '힘 +5를 얻는다. 3턴 뒤 힘 -5.';

  @override
  String get cardNameAtkR05Up => '버서크+';

  @override
  String get cardDescAtkR05Up => '힘 +7을 얻는다. 3턴 뒤 힘 -5.';

  @override
  String get cardNameAtkL01 => '엑스칼리버';

  @override
  String get cardDescAtkL01 => '50 데미지를 주고, 취약+약화 3턴을 부여한다. 사용 후 소멸.';

  @override
  String get cardNameAtkL01Up => '엑스칼리버+';

  @override
  String get cardDescAtkL01Up => '60 데미지를 주고, 취약+약화 3턴을 부여한다. 사용 후 소멸.';

  @override
  String get cardNameAtkL02 => '무한의 칼날';

  @override
  String get cardDescAtkL02 => '8 데미지를 준다. 사용 시 이 카드 영구 +2 데미지.';

  @override
  String get cardNameAtkL02Up => '무한의 칼날+';

  @override
  String get cardDescAtkL02Up => '12 데미지를 준다. 사용 시 이 카드 영구 +2 데미지.';

  @override
  String get cardNameMagC01 => '화염탄';

  @override
  String get cardDescMagC01 => '4 데미지를 주고, 화상 2턴을 부여한다.';

  @override
  String get cardNameMagC01Up => '화염탄+';

  @override
  String get cardDescMagC01Up => '6 데미지를 주고, 화상 3턴을 부여한다.';

  @override
  String get cardNameMagC02 => '서리 화살';

  @override
  String get cardDescMagC02 => '5 데미지를 주고, 약화 1턴을 부여한다.';

  @override
  String get cardNameMagC02Up => '서리 화살+';

  @override
  String get cardDescMagC02Up => '8 데미지를 주고, 약화 1턴을 부여한다.';

  @override
  String get cardNameMagC03 => '마나 집중';

  @override
  String get cardDescMagC03 => '에너지 +1, 카드 1장을 드로우한다.';

  @override
  String get cardNameMagC03Up => '마나 집중+';

  @override
  String get cardDescMagC03Up => '에너지 +1, 카드 2장을 드로우한다.';

  @override
  String get cardNameMagC04 => '전기 충격';

  @override
  String get cardDescMagC04 => '7 데미지를 준다 (랜덤 적).';

  @override
  String get cardNameMagC04Up => '전기 충격+';

  @override
  String get cardDescMagC04Up => '10 데미지를 준다 (랜덤 적).';

  @override
  String get cardNameMagC05 => '마법 화살';

  @override
  String get cardDescMagC05 => '4 데미지를 2회 준다 (랜덤 대상).';

  @override
  String get cardNameMagC05Up => '마법 화살+';

  @override
  String get cardDescMagC05Up => '4 데미지를 3회 준다 (랜덤 대상).';

  @override
  String get cardNameMagC06 => '명상';

  @override
  String get cardDescMagC06 => '카드 2장을 드로우한다.';

  @override
  String get cardNameMagC06Up => '명상+';

  @override
  String get cardDescMagC06Up => '카드 3장을 드로우한다.';

  @override
  String get cardNameMagC07 => '지식의 빛';

  @override
  String get cardDescMagC07 => '드로우 파일 상위 3장을 확인하고, 1장을 패로 가져온다.';

  @override
  String get cardNameMagC07Up => '지식의 빛+';

  @override
  String get cardDescMagC07Up => '드로우 파일 상위 3장 중 2장을 패로 가져온다.';

  @override
  String get cardNameMagC08 => '독안개';

  @override
  String get cardDescMagC08 => '적 전체에 독 3을 부여한다.';

  @override
  String get cardNameMagC08Up => '독안개+';

  @override
  String get cardDescMagC08Up => '적 전체에 독 5를 부여한다.';

  @override
  String get cardNameMagC09 => '마력 폭발';

  @override
  String get cardDescMagC09 => '10 데미지를 주고, 집중 +1을 얻는다.';

  @override
  String get cardNameMagC09Up => '마력 폭발+';

  @override
  String get cardDescMagC09Up => '14 데미지를 주고, 집중 +1을 얻는다.';

  @override
  String get cardNameMagC10 => '원소 조화';

  @override
  String get cardDescMagC10 => '다음 카드 효과를 50% 증가시킨다.';

  @override
  String get cardNameMagC10Up => '원소 조화+';

  @override
  String get cardDescMagC10Up => '다음 카드 효과를 100% 증가시킨다.';

  @override
  String get cardNameMagU01 => '연쇄 번개';

  @override
  String get cardDescMagU01 => '8 데미지를 주고, 적 전체에 4 데미지를 준다.';

  @override
  String get cardNameMagU01Up => '연쇄 번개+';

  @override
  String get cardDescMagU01Up => '12 데미지를 주고, 적 전체에 6 데미지를 준다.';

  @override
  String get cardNameMagU02 => '빙결의 눈';

  @override
  String get cardDescMagU02 => '12 데미지를 주고, 빙결 1회를 부여한다.';

  @override
  String get cardNameMagU02Up => '빙결의 눈+';

  @override
  String get cardDescMagU02Up => '16 데미지를 주고, 빙결 1회를 부여한다.';

  @override
  String get cardNameMagU03 => '지혜의 책';

  @override
  String get cardDescMagU03 => '카드 3장을 드로우하고, 1장을 소멸시킨다.';

  @override
  String get cardNameMagU03Up => '지혜의 책+';

  @override
  String get cardDescMagU03Up => '카드 4장을 드로우한다.';

  @override
  String get cardNameMagU04 => '마나 과부하';

  @override
  String get cardDescMagU04 => '에너지 +2를 얻는다. 다음 턴 에너지 -1.';

  @override
  String get cardNameMagU04Up => '마나 과부하+';

  @override
  String get cardDescMagU04Up => '에너지 +3을 얻는다.';

  @override
  String get cardNameMagU05 => '원소 폭풍';

  @override
  String get cardDescMagU05 => '적 전체에 15 데미지를 준다.';

  @override
  String get cardNameMagU05Up => '원소 폭풍+';

  @override
  String get cardDescMagU05Up => '적 전체에 20 데미지를 준다.';

  @override
  String get cardNameMagU06 => '시간 왜곡';

  @override
  String get cardDescMagU06 => '추가 턴 1회를 얻는다 (에너지 0, 카드 유지).';

  @override
  String get cardNameMagU06Up => '시간 왜곡+';

  @override
  String get cardDescMagU06Up => '추가 턴 1회를 얻는다 (에너지 1로 시작).';

  @override
  String get cardNameMagU07 => '마법 증폭';

  @override
  String get cardDescMagU07 => '집중 +2를 얻는다 (영구).';

  @override
  String get cardNameMagU07Up => '마법 증폭+';

  @override
  String get cardDescMagU07Up => '집중 +3을 얻는다 (영구).';

  @override
  String get cardNameMagU08 => '복제술';

  @override
  String get cardDescMagU08 => '패의 카드 1장을 복사한다 (이번 턴만).';

  @override
  String get cardNameMagU08Up => '복제술+';

  @override
  String get cardDescMagU08Up => '패의 카드 1장을 비용 0으로 복사한다 (이번 턴만).';

  @override
  String get cardNameMagR01 => '메테오';

  @override
  String get cardDescMagR01 => '적 전체에 25 데미지를 주고, 화상 3턴을 부여한다.';

  @override
  String get cardNameMagR01Up => '메테오+';

  @override
  String get cardDescMagR01Up => '적 전체에 35 데미지를 주고, 화상 3턴을 부여한다.';

  @override
  String get cardNameMagR02 => '마나 폭주';

  @override
  String get cardDescMagR02 => '패의 모든 카드 비용이 이번 턴 0이 된다.';

  @override
  String get cardNameMagR02Up => '마나 폭주+';

  @override
  String get cardDescMagR02Up => '패의 모든 카드 비용이 다음 턴까지 0이 된다.';

  @override
  String get cardNameMagR03 => '차원의 균열';

  @override
  String get cardDescMagR03 => '디스카드 파일에서 3장을 패로 가져온다.';

  @override
  String get cardNameMagR03Up => '차원의 균열+';

  @override
  String get cardDescMagR03Up => '디스카드 파일에서 5장을 패로 가져온다.';

  @override
  String get cardNameMagR04 => '영혼 흡수';

  @override
  String get cardDescMagR04 => '12 데미지를 주고, 같은 양 HP를 회복한다.';

  @override
  String get cardNameMagR04Up => '영혼 흡수+';

  @override
  String get cardDescMagR04Up => '18 데미지를 주고, 같은 양 HP를 회복한다.';

  @override
  String get cardNameMagR05 => '절대영도';

  @override
  String get cardDescMagR05 => '적 전체를 빙결시키고, 10 데미지를 준다.';

  @override
  String get cardNameMagR05Up => '절대영도+';

  @override
  String get cardDescMagR05Up => '적 전체를 빙결시키고, 15 데미지를 준다.';

  @override
  String get cardNameMagL01 => '아마겟돈';

  @override
  String get cardDescMagL01 => '적 전체에 99 데미지를 준다. 자신도 30 데미지. 사용 후 소멸.';

  @override
  String get cardNameMagL01Up => '아마겟돈+';

  @override
  String get cardDescMagL01Up => '적 전체에 99 데미지를 준다. 자신 15 데미지. 사용 후 소멸.';

  @override
  String get cardNameMagL02 => '무한의 지혜';

  @override
  String get cardDescMagL02 => '카드 5장을 드로우하고, 에너지 +2를 얻는다. 사용 후 소멸.';

  @override
  String get cardNameMagL02Up => '무한의 지혜+';

  @override
  String get cardDescMagL02Up => '카드 7장을 드로우하고, 에너지 +3을 얻는다. 사용 후 소멸.';

  @override
  String get cardNameDefC01 => '방어';

  @override
  String get cardDescDefC01 => '방어도 5를 얻는다.';

  @override
  String get cardNameDefC01Up => '방어+';

  @override
  String get cardDescDefC01Up => '방어도 8을 얻는다.';

  @override
  String get cardNameDefC02 => '철벽';

  @override
  String get cardDescDefC02 => '방어도 12를 얻는다.';

  @override
  String get cardNameDefC02Up => '철벽+';

  @override
  String get cardDescDefC02Up => '방어도 16을 얻는다.';

  @override
  String get cardNameDefC03 => '반격';

  @override
  String get cardDescDefC03 => '방어도 4를 얻고, 가시 2를 얻는다.';

  @override
  String get cardNameDefC03Up => '반격+';

  @override
  String get cardDescDefC03Up => '방어도 6을 얻고, 가시 3을 얻는다.';

  @override
  String get cardNameDefC04 => '회복 기도';

  @override
  String get cardDescDefC04 => 'HP 4를 회복한다.';

  @override
  String get cardNameDefC04Up => '회복 기도+';

  @override
  String get cardDescDefC04Up => 'HP 7을 회복한다.';

  @override
  String get cardNameDefC05 => '전투 태세';

  @override
  String get cardDescDefC05 => '방어도 6을 얻고, 카드 1장을 드로우한다.';

  @override
  String get cardNameDefC05Up => '전투 태세+';

  @override
  String get cardDescDefC05Up => '방어도 8을 얻고, 카드 1장을 드로우한다.';

  @override
  String get cardNameDefC06 => '구르기';

  @override
  String get cardDescDefC06 => '방어도 3을 얻고, 다음 턴 방어도 6을 얻는다.';

  @override
  String get cardNameDefC06Up => '구르기+';

  @override
  String get cardDescDefC06Up => '방어도 5를 얻고, 다음 턴 방어도 8을 얻는다.';

  @override
  String get cardNameDefC07 => '응급 처치';

  @override
  String get cardDescDefC07 => 'HP 3을 회복한다.';

  @override
  String get cardNameDefC07Up => '응급 처치+';

  @override
  String get cardDescDefC07Up => 'HP 5를 회복한다.';

  @override
  String get cardNameDefC08 => '인내';

  @override
  String get cardDescDefC08 => '방어도 5를 얻고, 불굴 1턴을 얻는다.';

  @override
  String get cardNameDefC08Up => '인내+';

  @override
  String get cardDescDefC08Up => '방어도 7을 얻고, 불굴 2턴을 얻는다.';

  @override
  String get cardNameDefC09 => '생명력';

  @override
  String get cardDescDefC09 => '재생 3을 얻는다 (3턴).';

  @override
  String get cardNameDefC09Up => '생명력+';

  @override
  String get cardDescDefC09Up => '재생 4를 얻는다 (4턴).';

  @override
  String get cardNameDefC10 => '도발 방패';

  @override
  String get cardDescDefC10 => '방어도 6을 얻고, 적 1체를 도발한다.';

  @override
  String get cardNameDefC10Up => '도발 방패+';

  @override
  String get cardDescDefC10Up => '방어도 9를 얻고, 적 1체를 도발한다.';

  @override
  String get cardNameDefU01 => '바리케이드';

  @override
  String get cardDescDefU01 => '방어도 12를 얻고, 불굴 2턴을 얻는다.';

  @override
  String get cardNameDefU01Up => '바리케이드+';

  @override
  String get cardDescDefU01Up => '방어도 16을 얻고, 불굴 3턴을 얻는다.';

  @override
  String get cardNameDefU02 => '반사 방어막';

  @override
  String get cardDescDefU02 => '방어도 8을 얻고, 가시 5를 얻는다 (이번 턴).';

  @override
  String get cardNameDefU02Up => '반사 방어막+';

  @override
  String get cardDescDefU02Up => '방어도 12를 얻고, 가시 7을 얻는다 (이번 턴).';

  @override
  String get cardNameDefU03 => '재생의 기도';

  @override
  String get cardDescDefU03 => 'HP 10을 회복하고, 재생 2를 얻는다 (3턴).';

  @override
  String get cardNameDefU03Up => '재생의 기도+';

  @override
  String get cardDescDefU03Up => 'HP 15를 회복하고, 재생 3을 얻는다 (3턴).';

  @override
  String get cardNameDefU04 => '불굴의 의지';

  @override
  String get cardDescDefU04 => '민첩 +2를 얻는다 (영구).';

  @override
  String get cardNameDefU04Up => '불굴의 의지+';

  @override
  String get cardDescDefU04Up => '민첩 +3을 얻는다 (영구).';

  @override
  String get cardNameDefU05 => '보호막';

  @override
  String get cardDescDefU05 => '잃은 HP의 25%만큼 방어도를 얻는다.';

  @override
  String get cardNameDefU05Up => '보호막+';

  @override
  String get cardDescDefU05Up => '잃은 HP의 30%만큼 방어도를 얻는다.';

  @override
  String get cardNameDefU06 => '생존 본능';

  @override
  String get cardDescDefU06 => 'HP 50% 이하면 방어도 15, 아니면 5.';

  @override
  String get cardNameDefU06Up => '생존 본능+';

  @override
  String get cardDescDefU06Up => 'HP 50% 이하면 방어도 20, 아니면 8.';

  @override
  String get cardNameDefU07 => '흡혈 가시';

  @override
  String get cardDescDefU07 => '가시 3을 얻는다 (영구). 피격 시 HP 1을 회복한다.';

  @override
  String get cardNameDefU07Up => '흡혈 가시+';

  @override
  String get cardDescDefU07Up => '가시 4를 얻는다 (영구). 피격 시 HP 2를 회복한다.';

  @override
  String get cardNameDefU08 => '강화 갑옷';

  @override
  String get cardDescDefU08 => '방어도 20을 얻고, 다음 턴 방어도 10을 얻는다.';

  @override
  String get cardNameDefU08Up => '강화 갑옷+';

  @override
  String get cardDescDefU08Up => '방어도 25를 얻고, 다음 턴 방어도 15를 얻는다.';

  @override
  String get cardNameDefR01 => '무적';

  @override
  String get cardDescDefR01 => '이번 턴 모든 데미지를 0으로 만든다. 사용 후 소멸.';

  @override
  String get cardNameDefR01Up => '무적+';

  @override
  String get cardDescDefR01Up => '이번 턴과 다음 턴 모든 데미지를 0으로 만든다. 사용 후 소멸.';

  @override
  String get cardNameDefR02 => '생명의 나무';

  @override
  String get cardDescDefR02 => 'HP 전체의 30%를 회복한다.';

  @override
  String get cardNameDefR02Up => '생명의 나무+';

  @override
  String get cardDescDefR02Up => 'HP 전체의 40%를 회복한다.';

  @override
  String get cardNameDefR03 => '성스러운 방패';

  @override
  String get cardDescDefR03 => '방어도 20을 얻고, 디버프를 모두 해제한다.';

  @override
  String get cardNameDefR03Up => '성스러운 방패+';

  @override
  String get cardDescDefR03Up => '방어도 28을 얻고, 디버프를 모두 해제한다.';

  @override
  String get cardNameDefR04 => '철의 몸';

  @override
  String get cardDescDefR04 => '매 턴 방어도 8을 자동으로 얻는다 (전투 동안).';

  @override
  String get cardNameDefR04Up => '철의 몸+';

  @override
  String get cardDescDefR04Up => '매 턴 방어도 12를 자동으로 얻는다 (전투 동안).';

  @override
  String get cardNameDefR05 => '부활의 비약';

  @override
  String get cardDescDefR05 => '이번 전투에서 사망 시 HP 30%로 부활한다. 사용 후 소멸.';

  @override
  String get cardNameDefR05Up => '부활의 비약+';

  @override
  String get cardDescDefR05Up => '이번 전투에서 사망 시 HP 50%로 부활한다. 사용 후 소멸.';

  @override
  String get cardNameDefL01 => '영원의 방패';

  @override
  String get cardDescDefL01 =>
      '방어도 30을 얻고, 매 턴 방어도 5를 자동으로 얻는다 (전투 동안). 사용 후 소멸.';

  @override
  String get cardNameDefL01Up => '영원의 방패+';

  @override
  String get cardDescDefL01Up =>
      '방어도 40을 얻고, 매 턴 방어도 8을 자동으로 얻는다 (전투 동안). 사용 후 소멸.';

  @override
  String get cardNameDefL02 => '생명의 원천';

  @override
  String get cardDescDefL02 => 'HP를 완전 회복하고, 최대 HP +10 (영구). 사용 후 소멸.';

  @override
  String get cardNameDefL02Up => '생명의 원천+';

  @override
  String get cardDescDefL02Up => 'HP를 완전 회복하고, 최대 HP +20 (영구). 사용 후 소멸.';

  @override
  String get cardNameTacC01 => '관찰';

  @override
  String get cardDescTacC01 => '적 의도를 확인하고, 카드 1장을 드로우한다.';

  @override
  String get cardNameTacC01Up => '관찰+';

  @override
  String get cardDescTacC01Up => '적 의도를 확인하고, 카드 2장을 드로우한다.';

  @override
  String get cardNameTacC02 => '보물 사냥';

  @override
  String get cardDescTacC02 => '전투 골드 +15.';

  @override
  String get cardNameTacC02Up => '보물 사냥+';

  @override
  String get cardDescTacC02Up => '전투 골드 +25.';

  @override
  String get cardNameTacC03 => '약점 간파';

  @override
  String get cardDescTacC03 => '취약 2턴, 약화 1턴을 부여한다.';

  @override
  String get cardNameTacC03Up => '약점 간파+';

  @override
  String get cardDescTacC03Up => '취약 2턴, 약화 2턴을 부여한다.';

  @override
  String get cardNameTacC04 => '재빠른 손';

  @override
  String get cardDescTacC04 => '카드 2장을 드로우한다.';

  @override
  String get cardNameTacC04Up => '재빠른 손+';

  @override
  String get cardDescTacC04Up => '카드 3장을 드로우한다.';

  @override
  String get cardNameTacC05 => '덫 설치';

  @override
  String get cardDescTacC05 => '다음 적 공격 시 10 데미지를 반사한다.';

  @override
  String get cardNameTacC05Up => '덫 설치+';

  @override
  String get cardDescTacC05Up => '다음 적 공격 시 15 데미지를 반사한다.';

  @override
  String get cardNameTacC06 => '교란';

  @override
  String get cardDescTacC06 => '적 의도를 변경한다 (랜덤).';

  @override
  String get cardNameTacC06Up => '교란+';

  @override
  String get cardDescTacC06Up => '적 의도를 변경하고, 약화 1턴을 부여한다.';

  @override
  String get cardNameTacC07 => '도둑질';

  @override
  String get cardDescTacC07 => '3 데미지를 주고, 골드 5~15를 획득한다.';

  @override
  String get cardNameTacC07Up => '도둑질+';

  @override
  String get cardDescTacC07Up => '6 데미지를 주고, 골드 10~25를 획득한다.';

  @override
  String get cardNameTacC08 => '연막탄';

  @override
  String get cardDescTacC08 => '방어도 4를 얻고, 적 전체에 약화 1턴을 부여한다.';

  @override
  String get cardNameTacC08Up => '연막탄+';

  @override
  String get cardDescTacC08Up => '방어도 6을 얻고, 적 전체에 약화 2턴을 부여한다.';

  @override
  String get cardNameTacC09 => '격려';

  @override
  String get cardDescTacC09 => '임의 카드 1장을 이번 전투 동안 업그레이드한다.';

  @override
  String get cardNameTacC09Up => '격려+';

  @override
  String get cardDescTacC09Up => '임의 카드 2장을 이번 전투 동안 업그레이드한다.';

  @override
  String get cardNameTacC10 => '행운의 동전';

  @override
  String get cardDescTacC10 => '50% 확률로 카드 2장을 드로우한다.';

  @override
  String get cardNameTacC10Up => '행운의 동전+';

  @override
  String get cardDescTacC10Up => '70% 확률로 카드 2장을 드로우한다.';

  @override
  String get cardNameTacU01 => '전장 분석';

  @override
  String get cardDescTacU01 => '카드 3장을 드로우하고, 비용이 가장 높은 카드의 이번 턴 비용을 0으로 만든다.';

  @override
  String get cardNameTacU01Up => '전장 분석+';

  @override
  String get cardDescTacU01Up =>
      '카드 4장을 드로우하고, 비용이 가장 높은 카드의 이번 턴 비용을 0으로 만든다.';

  @override
  String get cardNameTacU02 => '그림자 이동';

  @override
  String get cardDescTacU02 => '다음 턴까지 받는 데미지가 50% 감소한다.';

  @override
  String get cardNameTacU02Up => '그림자 이동+';

  @override
  String get cardDescTacU02Up => '다음 턴까지 받는 데미지가 50% 감소하고, 카드 1장을 드로우한다.';

  @override
  String get cardNameTacU03 => '보물 상자';

  @override
  String get cardDescTacU03 => '랜덤 렐릭 효과를 1회 발동한다. 사용 후 소멸.';

  @override
  String get cardNameTacU03Up => '보물 상자+';

  @override
  String get cardDescTacU03Up => '랜덤 렐릭 효과를 2회 발동한다. 사용 후 소멸.';

  @override
  String get cardNameTacU04 => '카드 조작';

  @override
  String get cardDescTacU04 => '드로우 파일 상위 3장을 원하는 순서로 정렬한다.';

  @override
  String get cardNameTacU04Up => '카드 조작+';

  @override
  String get cardDescTacU04Up => '드로우 파일 상위 5장을 원하는 순서로 정렬한다.';

  @override
  String get cardNameTacU05 => '이중 스파이';

  @override
  String get cardDescTacU05 => '적의 버프를 복사하고, 적의 버프를 제거한다.';

  @override
  String get cardNameTacU05Up => '이중 스파이+';

  @override
  String get cardDescTacU05Up => '적의 버프를 복사하고, 적의 버프를 제거하고, 5 데미지를 준다.';

  @override
  String get cardNameTacU06 => '전략적 후퇴';

  @override
  String get cardDescTacU06 => '패 전부를 셔플하고, 새로 5장을 드로우한다.';

  @override
  String get cardNameTacU06Up => '전략적 후퇴+';

  @override
  String get cardDescTacU06Up => '패 전부를 셔플하고, 새로 6장을 드로우한다.';

  @override
  String get cardNameTacU07 => '물물교환';

  @override
  String get cardDescTacU07 => '패에서 1장을 소멸시키고, 랜덤 카드 2장을 생성한다.';

  @override
  String get cardNameTacU07Up => '물물교환+';

  @override
  String get cardDescTacU07Up => '패에서 1장을 소멸시키고, 랜덤 카드 3장을 생성한다.';

  @override
  String get cardNameTacU08 => '연쇄 함정';

  @override
  String get cardDescTacU08 => '가시 3을 얻는다 (영구). 적 공격 시 약화 1턴을 부여한다.';

  @override
  String get cardNameTacU08Up => '연쇄 함정+';

  @override
  String get cardDescTacU08Up => '가시 5를 얻는다 (영구). 적 공격 시 약화 1턴을 부여한다.';

  @override
  String get cardNameTacR01 => '완벽한 계획';

  @override
  String get cardDescTacR01 => '에너지 +3, 카드 3장을 드로우한다. 다음 턴 드로우 0.';

  @override
  String get cardNameTacR01Up => '완벽한 계획+';

  @override
  String get cardDescTacR01Up => '에너지 +3, 카드 3장을 드로우한다. 다음 턴 드로우 2.';

  @override
  String get cardNameTacR02 => '운명의 바퀴';

  @override
  String get cardDescTacR02 => '랜덤 효과 1회: 데미지 15, 방어 15, 회복 15, 에너지 +2 중 하나.';

  @override
  String get cardNameTacR02Up => '운명의 바퀴+';

  @override
  String get cardDescTacR02Up => '랜덤 효과 2회: 데미지 15, 방어 15, 회복 15, 에너지 +2 중 하나.';

  @override
  String get cardNameTacR03 => '도플갱어';

  @override
  String get cardDescTacR03 => '이번 턴 사용한 카드 전부를 다시 패로 가져온다.';

  @override
  String get cardNameTacR03Up => '도플갱어+';

  @override
  String get cardDescTacR03Up => '이번 턴 사용한 카드 전부를 다시 패로 가져오고, 에너지 +2를 얻는다.';

  @override
  String get cardNameTacR04 => '탐욕의 손';

  @override
  String get cardDescTacR04 => '6 데미지를 준다. 킬 시 카드 보상 1장을 추가로 받는다.';

  @override
  String get cardNameTacR04Up => '탐욕의 손+';

  @override
  String get cardDescTacR04Up => '10 데미지를 준다. 킬 시 카드 보상 1장을 추가로 받는다.';

  @override
  String get cardNameTacR05 => '대혼란';

  @override
  String get cardDescTacR05 => '적 전체에 취약+약화 2턴, 독 3을 부여한다.';

  @override
  String get cardNameTacR05Up => '대혼란+';

  @override
  String get cardDescTacR05Up => '적 전체에 취약+약화 3턴, 독 3을 부여한다.';

  @override
  String get cardNameTacL01 => '시간의 주인';

  @override
  String get cardDescTacL01 => '추가 턴 2회를 얻는다 (에너지 2씩). 사용 후 소멸.';

  @override
  String get cardNameTacL01Up => '시간의 주인+';

  @override
  String get cardDescTacL01Up => '추가 턴 2회를 얻는다 (에너지 3씩). 사용 후 소멸.';

  @override
  String get cardNameTacL02 => '운명 변환';

  @override
  String get cardDescTacL02 => '덱의 모든 카드를 이번 전투 동안 업그레이드한다. 사용 후 소멸.';

  @override
  String get cardNameTacL02Up => '운명 변환+';

  @override
  String get cardDescTacL02Up =>
      '덱의 모든 카드를 이번 전투 동안 업그레이드하고, 에너지 +2를 얻는다. 사용 후 소멸.';
}
