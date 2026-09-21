# Life Quest - 프로젝트 메모리

> **현재 범위 — 전체 구조만, 구현 보류:** 최신 사용자 요청은 기존에 발견한 문제 전체(상태창 중심 첫 화면, 완료 피드백, 일별 변화, XP/주간 집계)를 **돌발 퀘스트와 함께 설계**하는 것이다. `docs/rebirth/STATUS_WINDOW_PRODUCT_STRUCTURE.md`가 전체 기준이고 `SYSTEM_QUEST_STRUCTURE.md`는 돌발 상세다. 횟수/기한/보상은 제안값이며 구현 완료가 아니다. 사용자가 구현을 지시하기 전 앱 코드·AI 프롬프트·알림·배포는 변경하지 않는다. 기존 전권 위임보다 이 최신 범위를 우선한다.

> **최신 타깃 수정 (2026-09-21):** 일반 RPG 사용자가 아니라 상태창·퀘스트·레벨업이 등장하는 현대 판타지 웹툰/웹소설 독자가 핵심. 대만 고정 우선안 폐기. 실행 추천은 일본어 장르 독자 소개(JA-01) + 영어권 비교(EN-01), 프랑스 후속 후보. 국가별 수익성 확정 아님. `docs/rebirth/marketing/TARGET_MARKETS.md` 근거/한계 우선. 첫 메시지 “내 일상에도 상태창이 생긴다면?”. 기존6개국 유지, 계정/게시/광고 없음.

> **최신 출시 전략 (2026-09-21):** Google Play 중심 글로벌 배포 + KO/EN/JA/대만 번체 현지화 + Threads 시장별 유입. `docs/rebirth/PLAY_GLOBAL_LAUNCH.md`, `marketing/THREADS_STARTER_KIT.md` 우선. 사용자가 계정을 직접 만들며 이름/소개/자연스러운 게시물 원고를 요청했다. Uptodown/Galaxy 등 추가 입점은 후순위로 변경. 6개국 설정 유지. 이번 재확인 Alpha3/4·비활성, 릴리스 검토700F193F. 파일URL 권한 상태 질문 대기. SNS 계정/게시/DM/광고비 지출 없음.

> **해외 배포 후속 (2026-09-21):** 사용자 요청으로 Alpha 대상 국가를 한국·대만·일본·미국·캐나다·프랑스 6개로 저장하고 재진입 확인했다. 테스트 활성화/정식 출시 아님. `docs/rebirth/INTERNATIONAL_DISTRIBUTION.md`에 대체 스토어 공식 조건과 우선순위 기록. Uptodown/Galaxy Store 후보, 대만 ONE store는 생활 앱 결제 제한 확인 필요. 타 스토어 제출/가입/과금 없음. 프랑스어·번체 중국어 미지원.

> **최신 요청/체크포인트:** 사용자가 비공개 테스트 선등록을 요청했으며, 실제12명 이상 모집/비용은 직접 진행할 예정이다. `docs/rebirth/CLOSED_TEST.md` 우선 확인. Alpha 국가/전용 목록/릴리스1 초안을 저장했으나 파일 업로드 권한 확인과 Play Console 오류 때문에 AAB 업로드·심사·배포 미완료다. 참여 링크/14일 시작을 완료로 보고하지 않는다.

> **현재 작업 (2026-09-21):** `codex/rebirth-2026-09`에서 Life Quest: 경계의 서가 무료 Android 공개 프리뷰 배포 완료. 아래 4월 이력의 완료를 현재 출시 상태로 해석하지 않는다.
> **최신 사용자 결정:** 사전 테스터 모집을 전제로 멈추지 말고 무료 공개판을 먼저 배포해 반응을 본다. 이전 12명 자체 연구·독자 사전 검수를 직접 APK 배포의 필수 조건으로 되살리지 않는다. Google Play의 계정별 의무 테스트는 별개이며 생략할 수 없다. 사용량은 잔여20%를 하한으로 필요한 작업만 한다.
> 기준 문서: `docs/rebirth/CONTINUE.md`, `PUBLIC_PREVIEW.md`, `CONCEPT_AND_REVENUE.md`. 이미지 아트는 image_gen 또는 라이선스 확인된 무료 자산. 직접 그린 SVG/HTML/Canvas 아트 금지.
> Firebase460 계정에 `lifequest-crossing-2026` 생성, Android 등록/업로드 인증서 등록, Spark 무료·서울 Firestore·deny-all 규칙 배포. Auth/Functions/결제는 미배포. 앱 Cloud/Billing/Ads/Research 기본off.
> Play 프로덕션 화면9/21 ‘아직 프로덕션에 액세스할 수 없습니다’ 확인. 내부 테스트 릴리스 초안만 저장. Chrome 확장 파일URL 권한 문제로 AAB 업로드 차단. APK 직접 공개를 Play 출시나 수익 발생으로 표현하지 않는다.
> 무료3권·선택 AI·백업·카드 탐험. 조수 우체국은2장면 체험, 판매off. 가격·수익은 미검증. 공개판2.0.0+7, 태그 `v2.0.0-preview.1`, 앱 소스 `d69aafb`. Flutter414개 통과·analyze clean·APK/AAB 서명/정렬 검사 통과. 실제 파일/URL은 `PUBLIC_PREVIEW.md`와 `public-distribution.json` 확인.
> Flutter 도구 명령은 직렬 실행한다. 실제 사용자·테스터·거래 기록을 만들지 않는다.


## 프로젝트 개요
- **앱 이름**: Life Quest - 현대 판타지 독자를 위한 현실 상태창·퀘스트 앱
- **프레임워크**: Flutter (Dart) + Flame 엔진 (Soul Deck 전투)
- **백엔드**: Firebase (Auth, Firestore, Storage, App Check, Crashlytics)
- **상태 관리**: Provider
- **GitHub**: https://github.com/Sn-bow/Life_Quest.git (branch: main)
- **applicationId**: `com.lifequest.app` (2026-04-01 변경, 이전: com.example.life_quest_final_v2)
- **플랫폼**: Android 전용 (Google Play Store, iOS 미지원)

---

## 현재 상태 (2026-04-15 기준)

### 검증 결과 (최신)
- `flutter analyze` → **No issues found** ✅
- `flutter test` → **73개 전체 통과** ✅
- `flutter build appbundle --release` → 성공 (64MB) ✅

---

## 3단계 계획 진행 현황 (전체 완료)

### Step 1: 던전 UI 로컬라이제이션 ✅ 완료
- 9개 던전 화면의 하드코딩 문자열 → ARB 키 추가
- app_en/ko/ja/zh.arb 각각 업데이트
- 각 화면에 AppLocalizations.of(context)! 적용
- 커밋: `014affe` (Step 1-A), `fa22e98` (Step 1-B)

### Step 2: 데이터 모델 다국어 리팩토링 ✅ 완료

- **CardData (207장)** → ARB + CardLocalization 헬퍼 방식으로 완료
  - 커밋: `5e155f2`(2-A) → `c1d3497`(2-B) → `6c1458a`(2-C) → `adbbe20`(2-D) → `d0b1145`(2-E) → `7a0bb67`(2-F) → `afc3759`(2-G)
- **RelicData (31개), Monster (31+5챕터), Achievement (25개), Title (28개), Skill (24개)** → ARB + 헬퍼 클래스 완료
  - `lib/data/relic_localization.dart` — RelicLocalization.localizedName/Description()
  - `lib/data/achievement_localization.dart` — AchievementLocalization
  - `lib/data/title_localization.dart` — TitleLocalization
  - `lib/data/skill_localization.dart` — SkillLocalization
  - `lib/data/monster_localization.dart` — MonsterLocalization (name + chapterName)
  - app_en/ko/ja/zh.arb에 총 252 키 × 4언어 = 1,008 entries 추가
  - 커밋: `026ab30` (Step 2-H)

### Step 3: Soul Deck 전투 애니메이션 ✅ 완료 (코드 전용, 에셋 불필요)

구현 위치: `lib/game/battle_game.dart`

| 메서드 | 구현 내용 | 컴포넌트 클래스 |
|--------|-----------|-----------------|
| `playAttackAnimation()` | 3중 슬래시 라인 (흰/노란 대각선) | `_SlashEffect` |
| `playDefendAnimation()` | 오각형 방패 윤곽선 + 위로 부상 | `_ShieldRaiseEffect` |
| `playMagicAnimation()` | 보라색 마법 구슬 + 꼬리 → 도착 시 히트 파티클 | `_MagicProjectile` |
| `onEnemyDefeated()` | 흰 섬광 + 12개 파편 폭발 + 중력 낙하 | `_EnemyDeathEffect` + `_Shard` |

- **에셋 없이 Canvas 드로잉만으로 구현** (Paint, Path, drawLine, drawCircle, drawRect)
- `playAttackAnimation()`은 card_battle_screen.dart에서 공격 카드 사용 시 호출 가능
- `onEnemyDefeated()`는 card_combat_state.dart에서 적 사망 시 호출 가능
- 커밋: `(이번 세션)`

#### Step 3 남은 작업 (에셋 필요 — Codex 단독 불가)
- 캐릭터 스프라이트 / 몬스터 스프라이트 실제 PNG 에셋 추가
- 배틀 배경 일러스트 에셋
- 전투 효과음 (공격, 방어, 마법, 적 사망)

---

## 완료된 전체 작업 이력

### Phase A~E (버그수정/품질/테스트/배포)
- 소모 아이템 삭제 버그, 장비 중복, Firestore 역직렬화 등 CRITICAL 5건 수정
- Firebase 오프라인, 인증 라우트, Android 13+ 알림 등 HIGH 6건 수정
- Android 릴리스 빌드 완료 (applicationId: com.lifequest.app, compileSdk: 36)
- 릴리스 키스토어 생성 (`android/upload-keystore.jks`, alias: upload)
- 테스트 67개 → 73개로 확장

### Soul Deck 시스템 (2026-04-06)
- Phase 1: 핵심 모델/데이터/상태/화면 7개
- Phase 2: 전투 이펙트 (파티클, 화면 흔들림, 상태이상 아이콘 등)
- Phase 3: 던전↔캐릭터 보상 연동 (XP/골드 계산, 카드 보상 UI)
- Phase 4: 카드 컬렉션 화면 + 무한 타워 화면

### 버그 수정 (2026-04-15)
- `dungeon_home_screen.dart`: `character.strength` 등 double → `.toInt()` 누락 버그 수정
  - `STR 10.0` → `STR 10` 으로 정상 표시
  - 커밋: `58ac52e`

### 문서화 (2026-04-15)
- README.md 전면 재작성 (기술 스택, Soul Deck 시스템, double 스탯 설계 이유 등)
- 커밋: `4b3c720`

---

## 주요 설계 결정 사항

### 캐릭터 스탯이 double인 이유
`strength`, `wisdom`, `health`, `charisma`는 `int`가 아닌 `double`:
- 레벨업 시 퀘스트 카테고리 누적 가중치(`levelGrowthWeights`)를 비율로 배분할 때 소수점 연산 필수
- 예: weight [str:0.6, wis:0.4] × 자동포인트 3 = str 1.8 → 2, wis 1.2 → 1 (소수점 반올림)
- 정수로 하면 레벨업마다 반올림 오차 누적
- UI 표시 시 `.toInt()` 또는 `.toStringAsFixed(0)` 사용 (정수처럼 보임)

### 카드 번역 방식 (ARB + 헬퍼 클래스)
데이터 모델의 필드를 Map<String, String>으로 바꾸는 대신:
- ARB 파일에 번역 키 추가 (`cardNameAtkC01`, `cardDescAtkC01` 등)
- `lib/data/card_localization.dart`의 `CardLocalization` 헬퍼로 switch-case 라우팅
- 장점: 타입 안전, IDE 자동완성, Firestore 저장 구조 불변
- RelicData/Monster 등도 동일 패턴 적용 예정

---

## 남은 수동 작업 (코드 외)
1. **AdMob 프로덕션 ID 교체** (`ad_service.dart`, `AndroidManifest.xml`)
2. **Firebase 콘솔에서 Android 패키지명 `com.lifequest.app`으로 업데이트**
3. **Google Play Console에 AAB 업로드** (`build/app/outputs/bundle/release/app-release.aab`)

---

## 주의사항
- 아바타/캐릭터 커스터마이징 기능은 의도적으로 제거됨 (다시 만들지 말 것)
- image_picker, firebase_storage, firebase_app_check는 pubspec에 유지
- 릴리스 키스토어(`upload-keystore.jks`)와 `key.properties`는 `.gitignore`에 포함
- Dart 패키지명은 `life_quest_final_v2` 그대로 유지 (Android applicationId만 변경)
- iOS 미지원 확정 (비용 문제)
- WORK_INSTRUCTIONS.md에 Phase A~E 상세 내역 있음
