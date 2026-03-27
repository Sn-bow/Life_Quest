# Life Quest

일상을 RPG처럼 관리하는 Flutter 기반 라이프 게이미피케이션 앱입니다.

## 주요 기능

- **퀘스트 시스템** — 일간/주간/월간/연간 퀘스트 설정 및 완료로 경험치 획득
- **캐릭터 성장** — 레벨업, 스탯 분배 (힘/지혜/건강/매력), 칭호 시스템
- **전투 (사냥)** — 던전 탐험, 몬스터와 턴제 전투, 전리품 획득
- **장비 & 인벤토리** — 무기/방어구/액세서리 장착, 아이템 관리
- **상점** — 골드로 장비 구매, 코스메틱 아이템 구매
- **스킬 트리** — 스킬 포인트로 스킬 해금
- **업적** — 다양한 조건 달성으로 업적 해금
- **리포트** — 성장 통계 및 활동 리포트
- **집중 타이머** — 포모도로 방식 타이머
- **홈 위젯** — iOS/Android 홈 화면 위젯
- **알림** — 퀘스트 리마인더 로컬 알림
- **광고 & 인앱결제** — Google AdMob, In-App Purchase 연동

## 기술 스택

- **Framework**: Flutter (Dart)
- **Backend**: Firebase (Auth, Firestore, Storage, App Check)
- **상태 관리**: Provider
- **인증**: Firebase Auth + Google Sign-In
- **광고**: Google Mobile Ads
- **결제**: In-App Purchase
- **알림**: flutter_local_notifications
- **사운드**: audioplayers

## 프로젝트 구조

```
lib/
├── main.dart                  # 앱 진입점
├── firebase_options.dart      # Firebase 설정
├── models/                    # 데이터 모델
│   ├── character.dart         # 캐릭터 모델
│   ├── quest.dart             # 퀘스트 모델
│   ├── item.dart              # 아이템/장비 모델
│   ├── monster.dart           # 몬스터 모델
│   ├── skill.dart             # 스킬 모델
│   ├── achievement.dart       # 업적 모델
│   ├── title.dart             # 칭호 모델
│   ├── cosmetic.dart          # 코스메틱 모델
│   └── custom_reward.dart     # 커스텀 보상 모델
├── screens/                   # 화면
│   ├── main_screen.dart       # 메인 네비게이션
│   ├── status_screen.dart     # 상태창 (스탯, HP, 레벨)
│   ├── quests_screen.dart     # 퀘스트 목록
│   ├── hunt_screen.dart       # 사냥 (전투)
│   ├── inventory_screen.dart  # 인벤토리
│   ├── shop_screen.dart       # 상점
│   ├── skill_screen.dart      # 스킬 트리
│   ├── achievement_screen.dart # 업적
│   ├── report_screen.dart     # 성장 리포트
│   ├── timer_screen.dart      # 집중 타이머
│   ├── settings_screen.dart   # 설정
│   ├── login_screen.dart      # 로그인
│   ├── signup_screen.dart     # 회원가입
│   └── loading_screen.dart    # 로딩
├── state/                     # 상태 관리
│   ├── character_state.dart   # 캐릭터 상태 (Provider)
│   └── combat_state.dart      # 전투 상태
├── services/                  # 서비스
│   ├── sound_service.dart     # 사운드
│   ├── notification_service.dart # 알림
│   ├── ad_service.dart        # 광고
│   └── purchase_service.dart  # 인앱결제
├── data/                      # 정적 데이터
│   ├── monster_database.dart  # 몬스터 DB
│   ├── achievement_database.dart # 업적 DB
│   ├── skill_database.dart    # 스킬 DB
│   ├── title_database.dart    # 칭호 DB
│   └── loot_table.dart        # 전리품 테이블
└── widgets/                   # 위젯
    ├── translucent_card.dart  # 반투명 카드
    ├── xp_bar.dart            # 경험치 바
    ├── quest_tile.dart        # 퀘스트 타일
    ├── stat_bar.dart          # 스탯 바
    └── combat/                # 전투 위젯
        ├── combat_arena_view.dart    # 전투 아레나
        ├── player_battle_sprite.dart # 플레이어 전투 스프라이트
        ├── player_profile_sprite.dart # 프로필 스프라이트
        ├── monster_battle_sprite.dart # 몬스터 전투 스프라이트
        └── dungeon_floor_selector.dart # 던전 층 선택
```

## 실행 방법

```bash
# 의존성 설치
flutter pub get

# 디버그 실행
flutter run

# 빌드
flutter build apk        # Android
flutter build ios         # iOS
```

## 요구 사항

- Flutter SDK >= 3.2.3
- Firebase 프로젝트 설정 필요
- Android: minSdk 21+
- iOS: 지원
