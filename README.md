# Life Quest

> 일상을 RPG처럼 관리하는 Flutter 기반 라이프 게이미피케이션 앱

퀘스트를 완료하고, 캐릭터를 성장시키고, Soul Deck 던전에서 덱빌딩 전투를 즐기세요.  
실제 생활 습관이 게임 캐릭터의 스탯과 덱에 직접 영향을 줍니다.

---

## 현재 상태 (2026-04-25 기준)

| 항목 | 결과 |
|------|------|
| `flutter analyze` | **No issues found** ✅ |
| `flutter test` | **76개 전체 통과** ✅ |
| `flutter build appbundle --release` | 성공 (64MB) ✅ |

---

## 주요 기능

| 기능 | 설명 |
|------|------|
| **퀘스트 시스템** | 일간 / 주간 / 월간 / 연간 퀘스트로 XP · 골드 · 스탯포인트 획득 |
| **캐릭터 성장** | 레벨업, 스탯 분배 (힘/지혜/건강/매력), 칭호 · 스킬 트리 |
| **Soul Deck 던전** | Slay the Spire 스타일 덱빌딩 로그라이크 전투 (5존 + 보스 + 어센션 10단계) |
| **카드 컬렉션** | 퀘스트 완료로 카드 잠금 해제, 스타터 덱 커스터마이징 (최대 20장) |
| **무한 타워** | Zone 5 클리어 후 해금되는 무한 난이도 챌린지 |
| **장비 & 인벤토리** | 무기 / 방어구 / 액세서리 장착, 소모 아이템 관리 |
| **상점** | 골드로 장비 · 코스메틱 구매, IAP 지원 |
| **업적 & 칭호** | 다양한 조건의 업적 달성 시 칭호 해금 |
| **성장 리포트** | 스탯 변화 · 퀘스트 통계 시각화 (fl_chart) |
| **집중 타이머** | 포모도로 방식 타이머, 완료 시 보너스 XP |
| **홈 위젯** | Android 홈 화면 위젯 (캐릭터 상태 표시) |
| **온보딩** | 최초 실행 시 3페이지 온보딩 (퀘스트 → 던전 → 시작하기) |
| **알림** | 퀘스트 리마인더 로컬 알림 (아침/저녁 시간 앱 내 직접 설정 가능) |
| **다국어 지원** | 한국어 / 영어 / 일본어 / 중국어 (ARB 기반 완전 로컬라이제이션, 앱 내 언어 전환 지원) |

---

## 기술 스택

### 핵심 프레임워크

| 라이브러리 | 버전 | 용도 |
|-----------|------|------|
| **Flutter** | SDK ≥ 3.2.3 | 크로스플랫폼 UI |
| **Dart** | ≥ 3.2.3 | 언어 |
| **Flame** | ^1.21.0 | Soul Deck 전투 씬 (게임 엔진) |
| **flame_audio** | ^2.10.4 | 인게임 사운드 |

### 상태 관리

| 라이브러리 | 용도 |
|-----------|------|
| **Provider** | 전역 상태 관리 (CharacterState, CombatState, DungeonState, CardCombatState) |

### 백엔드 & 인증

| 라이브러리 | 용도 |
|-----------|------|
| **Firebase Core** | Firebase 초기화 |
| **Firebase Auth** | 이메일/Google 로그인 |
| **Cloud Firestore** | 캐릭터 데이터 영속성 |
| **Firebase Storage** | 프로필 사진 저장 |
| **Firebase App Check** | API 보안 |
| **Firebase Crashlytics** | 크래시 모니터링 |
| **Google Sign-In** | Google OAuth |

### UI & 데이터 시각화

| 라이브러리 | 용도 |
|-----------|------|
| **fl_chart** | 성장 리포트 차트 |
| **confetti** | 레벨업 / 업적 이펙트 |
| **phosphor_flutter** | 아이콘 |

### 서비스

| 라이브러리 | 용도 |
|-----------|------|
| **google_mobile_ads** | 광고 (AdMob 보상형) |
| **in_app_purchase** | 인앱결제 |
| **flutter_local_notifications** | 로컬 알림 |
| **home_widget** | Android 홈 위젯 |
| **audioplayers** | 효과음 풀 (SFX Pool) |

### 로컬라이제이션

| 도구 | 용도 |
|------|------|
| **flutter_localizations** | ARB 기반 l10n |
| **intl** | 날짜 / 숫자 포맷 |
| `flutter gen-l10n` | 코드 자동 생성 (`lib/l10n/`) |

지원 언어: `ko` (한국어) · `en` (English) · `ja` (日本語) · `zh` (中文)

### 개발 도구

| 라이브러리 | 용도 |
|-----------|------|
| **flutter_lints** | 정적 분석 |
| **mockito** | 단위 테스트 Mocking |
| **fake_cloud_firestore** | Firestore 테스트 대역 |
| **firebase_auth_mocks** | Auth 테스트 대역 |
| **flutter_launcher_icons** | 앱 아이콘 생성 |
| **flutter_native_splash** | 스플래시 스크린 |

---

## Soul Deck 시스템

Slay the Spire에서 영감을 받은 덱빌딩 로그라이크 전투 시스템입니다.

### 카드 구성 (총 207장)

| 카테고리 | Common | Uncommon | Rare | Legendary | 합계 |
|---------|--------|----------|------|-----------|------|
| Attack | 10 | 8 | 5 | 2 | 25 |
| Magic | 10 | 8 | 5 | 2 | 25 |
| Defense | 10 | 8 | 5 | 2 | 25 |
| Tactical | 10 | 8 | 5 | 2 | 25 |
| Starter | — | — | — | — | 10 |
| Curse | — | — | — | — | 4 |
| **합계** | | | | | **207** (업그레이드 포함) |

> 모든 카드는 업그레이드 버전(+) 포함, 4개 언어 번역 완료

### 주요 시스템

- **에너지 시스템**: 턴당 에너지 3 (기본)
- **상태이상 11종**: Thorns, Poison, Burn, Freeze, Weak, Vulnerable, Strength, Dexterity, Stalwart, Regeneration, Stun
- **렐릭 31개**: 전투 전반에 영향을 주는 패시브 아이템
- **이벤트 10개**: 선택지 기반 랜덤 이벤트 (골드 부족 시 선택지 비활성화)
- **5존 구조**: 존마다 배경 / 몬스터 / 보스 차별화
- **어센션 10단계**: Zone 5 클리어 후 해금, 단계별 패널티 부여
- **무한 타워**: 층수가 올라갈수록 적 스탯 상승 (5층마다 존 순환)

### 에셋 현황

| 에셋 | 수량 | 위치 | 상태 |
|------|------|------|------|
| 몬스터 스프라이트 | 31종 PNG | `assets/images/monsters/` | ✅ 인게임 표시 |
| 배경 이미지 | 5존 PNG | `assets/images/backgrounds/` | ✅ 로드 실패 시 그라디언트 fallback |
| 전투 SFX | 9개 WAV | `assets/sounds/sfx/` | ✅ 카드 사용·턴 전환 시 재생 |
| 전투 애니메이션 | 4종 | `battle_game.dart` (Canvas) | ✅ 에셋 없이 Canvas 드로잉 구현 |

### 전투 화면 구조 (Impeller 호환)

Android Impeller(OpenGL) 백엔드에서는 `Stack + Positioned.fill` 패턴에서 Flame의 `GameWidget`과 Flutter 위젯이 올바르게 합성되지 않습니다.  
**반드시 아래 구조를 유지해야 합니다:**

```
Container(decoration: 배경 이미지 + 그라디언트)
  └── Scaffold(backgroundColor: transparent)
       └── GameWidget(
             game: BattleGame,               ← backgroundColor() = Color(0x00000000)
             overlayBuilderMap: {
               'battleUI': 손패/HP바/턴버튼  ← Flame 오버레이 API로 UI 렌더링
             },
             initialActiveOverlays: ['battleUI'],
           )
```

> ⚠️ `BattleGame.backgroundColor()`는 반드시 `Color(0x00000000)` (완전 투명)을 반환해야 합니다.  
> `Scaffold` 내부 `Stack`에 `GameWidget`과 Flutter 위젯을 함께 배치하면 **UI가 보이지 않는 버그**가 발생합니다.

---

## 캐릭터 스탯 설계 — double을 사용하는 이유

캐릭터의 4대 스탯 (`strength`, `wisdom`, `health`, `charisma`)은 `int`가 아닌 **`double`** 타입으로 선언되어 있습니다.

```dart
double strength;
double wisdom;
double health;
double charisma;
```

### 이유: 가중치 기반 자동 성장 시스템

플레이어가 퀘스트를 완료할 때마다 해당 카테고리의 가중치(`levelGrowthWeights`)가 누적됩니다.

```
퀘스트 완료 → 카테고리 기여도 누적
  예) strength 관련 퀘스트 완료 시 weight += 0.3 (일간) ~ 2.5 (연간)
```

레벨업 시 자동 성장 포인트 3개를 누적 가중치 **비율**로 4개 스탯에 배분합니다.

```dart
// 예시: weight = [str:0.6, wis:0.3, hp:0.1, cha:0.0], 자동 포인트 = 3
exact_str = (0.6 / 1.0) * 3 = 1.8  → 배분: 2
exact_wis = (0.3 / 1.0) * 3 = 0.9  → 배분: 1
exact_hp  = (0.1 / 1.0) * 3 = 0.3  → 배분: 0
exact_cha = (0.0 / 1.0) * 3 = 0.0  → 배분: 0
```

이 비례 배분 과정에서 **소수점 연산이 필수**입니다. 스탯이 `int`이면 반올림 오차가 레벨업마다 누적되어 플레이어의 퀘스트 패턴이 스탯에 정확히 반영되지 않습니다.

| 상황 | 소수점이 필요한 이유 |
|------|---------------------|
| 퀘스트 XP 보너스 계산 | `streakBonusRate = streak * 0.10` (연속 접속) |
| 스탯 보너스 배율 | `statBonusRate = (statValue / 10) * 0.05` |
| 장비 소수점 보너스 | 장비가 +0.5 strength 등을 부여할 수 있음 |
| 업적 체크 | `.toInt()`로 변환해 정수 값과 비교 |

> **요약**: 스탯은 내부에서 소수점 정밀도로 관리되고, UI 표시 시에는 `.toInt()` 또는 반올림하여 사용자에게는 정수로 보여줍니다.

---

## 프로젝트 구조

```
lib/
├── main.dart                        # 앱 진입점, Provider 트리, 라우팅
├── firebase_options.dart            # Firebase 설정
├── l10n/                            # 다국어 리소스
│   ├── app_ko.arb                   # 한국어 (기준)
│   ├── app_en.arb                   # 영어
│   ├── app_ja.arb                   # 일본어
│   ├── app_zh.arb                   # 중국어
│   └── app_localizations*.dart      # 자동 생성 (flutter gen-l10n)
├── models/                          # 데이터 모델
│   ├── character.dart               # 캐릭터 (스탯, 인벤토리, 덱 등)
│   ├── quest.dart                   # 퀘스트
│   ├── item.dart                    # 아이템 / 장비
│   ├── monster.dart                 # 몬스터
│   ├── skill.dart                   # 스킬
│   ├── achievement.dart             # 업적
│   ├── title.dart                   # 칭호
│   ├── cosmetic.dart                # 코스메틱
│   ├── custom_reward.dart           # 커스텀 보상
│   ├── card_data.dart               # Soul Deck 카드
│   ├── status_effect.dart           # 전투 상태이상
│   ├── relic_data.dart              # 렐릭
│   ├── dungeon_map.dart             # 던전 맵 노드
│   └── dungeon_event.dart           # 이벤트
├── screens/                         # 화면
│   ├── main_screen.dart             # 메인 네비게이션
│   ├── status_screen.dart           # 상태창
│   ├── quests_screen.dart           # 퀘스트
│   ├── hunt_screen.dart             # 사냥 (구형 전투)
│   ├── inventory_screen.dart        # 인벤토리
│   ├── shop_screen.dart             # 상점
│   ├── skill_screen.dart            # 스킬 트리
│   ├── achievement_screen.dart      # 업적
│   ├── report_screen.dart           # 성장 리포트
│   ├── timer_screen.dart            # 집중 타이머
│   ├── settings_screen.dart         # 설정
│   ├── login_screen.dart            # 로그인
│   ├── signup_screen.dart           # 회원가입
│   ├── loading_screen.dart          # 로딩
│   ├── onboarding_screen.dart       # 최초 실행 온보딩 (3페이지)
│   └── dungeon/                     # Soul Deck 던전 화면
│       ├── dungeon_home_screen.dart  # 던전 홈 (존 선택, 어센션)
│       ├── dungeon_map_screen.dart   # 노드 맵
│       ├── card_battle_screen.dart   # 카드 전투
│       ├── dungeon_event_screen.dart # 이벤트
│       ├── dungeon_shop_screen.dart  # 던전 상점
│       ├── dungeon_rest_screen.dart  # 휴식 노드
│       ├── dungeon_result_screen.dart # 런 결과
│       ├── card_collection_screen.dart # 카드 컬렉션 & 덱 빌더
│       └── infinite_tower_screen.dart  # 무한 타워
├── state/                           # Provider 상태
│   ├── character_state.dart         # 캐릭터 (퀘스트, 레벨업, 카드 등)
│   ├── combat_state.dart            # 구형 전투 상태
│   ├── card_combat_state.dart       # Soul Deck 전투 로직
│   └── dungeon_state.dart           # 던전 런 관리, 저장/불러오기
├── game/                            # Flame 게임 엔진
│   ├── battle_game.dart             # BattleGame (FlameGame)
│   └── components/
│       ├── damage_text.dart         # 데미지 팝업 컴포넌트
│       ├── particle_effect.dart     # 파티클 이펙트
│       └── status_icon.dart         # 상태이상 아이콘
├── services/                        # 서비스 레이어
│   ├── sound_service.dart           # 효과음 (풀링, 뮤트)
│   ├── notification_service.dart    # 로컬 알림
│   ├── ad_service.dart              # AdMob 보상형 광고
│   └── purchase_service.dart        # 인앱결제
├── data/                            # 정적 데이터 / DB
│   ├── card_database.dart           # 카드 207장 정의
│   ├── card_localization.dart       # 카드 다국어 헬퍼 (CardLocalization)
│   ├── monster_localization.dart    # 몬스터 다국어 헬퍼
│   ├── relic_localization.dart      # 렐릭 다국어 헬퍼
│   ├── achievement_localization.dart
│   ├── title_localization.dart
│   ├── skill_localization.dart
│   ├── relic_database.dart          # 렐릭 31개
│   ├── event_database.dart          # 이벤트 10개
│   ├── dungeon_generator.dart       # 던전 맵 생성기
│   ├── monster_database.dart        # 몬스터 DB (31종, 5존)
│   ├── achievement_database.dart    # 업적 DB (25개)
│   ├── skill_database.dart          # 스킬 DB (24개)
│   ├── title_database.dart          # 칭호 DB (28개)
│   └── loot_table.dart              # 전리품 테이블
└── widgets/                         # 공통 위젯
    ├── translucent_card.dart
    ├── xp_bar.dart
    ├── quest_tile.dart
    ├── stat_bar.dart
    ├── player_profile_sprite.dart
    └── combat/
        ├── combat_arena_view.dart
        ├── player_battle_sprite.dart
        ├── monster_battle_sprite.dart
        └── dungeon_floor_selector.dart
```

---

## 실행 방법

```bash
# 의존성 설치
flutter pub get

# l10n 코드 생성 (ARB 수정 후 필요)
flutter gen-l10n

# 디버그 실행
flutter run

# 정적 분석
flutter analyze

# 테스트
flutter test

# 릴리스 빌드 (Android — Google Play)
flutter build appbundle --release
```

---

## 배포 정보

| 항목 | 값 |
|------|----|
| **Android applicationId** | `com.lifequest.app` |
| **Dart package name** | `life_quest_final_v2` (변경 없음) |
| **minSdk** | 21 (Android 5.0+) |
| **compileSdk** | 36 |
| **버전** | 1.0.0+1 |
| **플랫폼** | Android 전용 (Google Play Store) |

> iOS는 현재 미지원 (비용 문제로 제외)

---

## 테스트

```
test/
├── models/
│   ├── character_test.dart    (9개)
│   ├── quest_test.dart        (9개)
│   ├── item_test.dart         (5개)
│   ├── achievement_test.dart  (4개)
│   └── skill_test.dart        (1개)
└── state/
    ├── character_state_test.dart  (20개)
    ├── combat_state_test.dart     (25개)
    └── dungeon_state_test.dart    (3개)
```

`flutter test` → **76개 전체 통과**

---

## 수동 작업 (미완료)

- [ ] AdMob 프로덕션 ID 교체 (`ad_service.dart`, `AndroidManifest.xml`)
- [ ] Firebase 콘솔에서 Android 패키지명 `com.lifequest.app`으로 업데이트
- [ ] Google Play Console에 AAB 업로드 (`build/app/outputs/bundle/release/app-release.aab`)

---

## 라이선스

Private — All rights reserved.
