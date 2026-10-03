# Life Quest - 프로젝트 메모리

> **2026-10-03 후속 디자인 수정:** 소스 `12816fc`에서 상태창 테두리와 내부 정보의 여백을 넓히고 짧은 휴대폰의 루트 카드 간격을 조정했다. 관련53검사/analyze 통과. 아래 `54e2a7f`의 보존 AAB에는 이 변경이 없으므로 **Play 업로드 전 최신 AAB 재빌드·파일 검사 갱신이 필요**하다. 검토 APK는 `build/review/life-quest-2.1.0-2014-spacing-review.apk`.

> **2026-10-03 구현 체크포인트:** 소스 `54e2a7f`, `2.1.0+2014`. 4루트84미션·4언어·작은 행동·타이머·메모·Complete 일회 구매 구현. 전체Flutter569/서버정책50/보안규칙12/아티팩트40 통과. 실제 Play/Firebase 연결·구매/복원/환불·비공개 테스트는 미완료이며 전체 목표 달성 아님. [현 체크포인트](docs/rebirth/CONTINUE.md), [상품·검증 순서](docs/rebirth/store/COMPLETE_PRODUCT_2014.md), [크몽 준비](docs/rebirth/store/KMONG_HANDOFF_20261003.md)부터 재개한다.

> **현재 최우선 지시 · 2026-10-03:** 사용자는 완료 기준을 임의로 낮추지 말라고 재강조했다. 목표는 **사람들이 반복 사용하고 비용을 지불할 만한 완성 제품**이며, 특정 장르·기존 코드·28일 콘텐츠·광고 모델에 고정하지 않는다. 제품·콘텐츠·UI/UX·수익 구조를 비교 근거로 판단하고 실제 구현/검증한다. 내부 테스트나 경쟁 앱 매출을 우리 구매 수요로 바꾸어 말하지 않는다. 제품 완성 및 수익 판단 이후 **비공개 테스트 배포까지 이번 요청에서 승인**했다(아래 별도 “배포해” 대기 규칙은 과거 이력). Google Drive `앱배포-크몽`의 판매자 캡처를 읽고 전달 자료까지 준비한다. 판매자에게 메시지 전송/결제는 요청 범위에 포함되지 않는다. **사용량은 초기화되었고 전체 사용 승인**(과거 5%/20%/70% 하한 폐기). 기존 설정·작업은 보존한다. 멀티에이전트는 별도 명시적 요청 없이 신규 생성하지 않는다.

> **제품 우선순위 변경 · 2026-09-30:** 사용자는 기존의 출시 후보/Play 설정 진행이 목표를 앞질렀다고 지적했다. 최우선 목표는 **사람들이 반복해서 사용하고 돈을 낼 만한 앱 자체**를 만드는 것이다. 상태창·일정관리·기존 Plus 묶음은 보존해야 할 고정 콘셉트가 아니라 재검토 대상이다. UI/UX, 핵심 행동 루프, 콘텐츠, 개인화, 유료 가치와 품질을 먼저 검증하고 구현한다. 현재 Play/Firebase 설정과 빌드는 이력으로 보존하되 콘솔 설정·AAB 업로드·테스트 트랙·유료 상품 활성화를 제품 완성의 대체물로 삼거나 선행하지 않는다. 기존 `배포해` 게이트에 더해 제품 완성 판단도 필요하다. [제품 재검토](docs/rebirth/PRODUCT_RESET_20260930.md)를 우선 읽는다.

> **현재 Android 패키지 · 2026-09-29:** `com.logian.lifequest` (변경 소스 `d7fe395`). `com.lifequest.app`은 충돌이 확인된 과거 Play 초안·공개 APK의 ID다. 이전 ID의 AAB/QA 해시는 새 패키지 출시 후보의 증거가 아니다. 패키지 변경으로 기존 앱을 제자리 업데이트할 수 없고 **기기 로컬 데이터는 새 앱으로 자동 이전되지 않는다**. 계정 데이터 연속성은 실제 로그인·동기화 검증 전 미확인이다. [패키지 이전 기록](docs/rebirth/store/PACKAGE_MIGRATION_20260929.md)을 따른다.

> **작업·사용량 기준 · 2026-09-29:** 사용자는 수익화 우선으로 **배포 직전까지** 준비하고, 다음 명시적 **“배포해”** 요청 전에는 AAB 업로드·테스트 트랙 게시를 하지 않도록 했다. 사용량 하한은 **잔여 5%**이며 작업 전 다시 조회한다. [재개 체크포인트](docs/rebirth/CONTINUE.md), [유료 후보](docs/rebirth/market/PAID_RELEASE_CANDIDATE_20260928.md), [게임 범위 결정](docs/rebirth/market/GAME_SCOPE_DECISION_20260928.md)을 참고하되, 이전 ID의 상태·해시를 새 앱 검증으로 읽지 않는다. Obsidian 요청이 없으면 개인 Vault를 읽지 않는다.

> **직전 패키지 후보 검증 (2026-09-28, 현행 아님):** Android `com.lifequest.app` **2.0.0+2013**의 당시 빌드 소스는 `d7ebb72`다. 출시 UI는 상태창·현실 퀘스트·성장 기록·선택형 `status_window_plus_01` 일회 구매에 집중한다. 기존 탐험·전투·상점·몬스터 업적 진입과 신규 게임 보상은 숨겼고 **당시 같은 패키지의 이전 저장 데이터는 보존**한다(새 ID로의 이전을 뜻하지 않음). 새 게임 콘텐츠는 보류한다. signed AAB `build/review/life-quest-2.0.0-2013-paid-candidate.aab`는 **156,055,514 bytes**, SHA-256 `8a7ec152f17fcbd80f83c4341b10f42d1dba24a46f390441f681e85266d9ccec`; [로컬 검사](docs/rebirth/paid-candidate-2013-inspection.json) **54/54 통과**, ARM64/API35/16KB 표본 다운로드 65,334,692 bytes다. signed QA APK는 163,188,472 bytes, SHA-256 `1919450e34f21fe324d9d8b832524e7a62f202e64d22ab70019873145a34735c`. `flutter analyze` clean, 전체 Flutter **518 통과/1 skip**, Cloud/Billing on 관련 **38 통과**, 영어·일본어 320/800dp 세로·800dp 가로 200% 글꼴 배율의 성장 보고서 Plus 진입 테스트 **6 통과**. 이전 47개 선택 테스트는 범위 변경 전 기록이다. 네 언어 스토어 문안과 이전 APK의 실제 화면 8장은 Console 초안에 저장했다. [이전 `bb33b4b` APK의 Android QA](docs/rebirth/design/status-system/qa/PAID_SCOPE_QUEST_SCREENSHOT_QA_20260928.md)에서 퀘스트 4장이 기존 스토어 이미지와 시각적으로 동일하며 Gold 표시가 없음을 확인했다. `d7ebb72`는 성장 보고서 배치만 바꿨으므로 이 자료는 퀘스트 화면의 근거로 유지하되 최신 APK에서 직접 촬영한 것으로 쓰지 않는다. [Console 상태](docs/rebirth/store/PLAY_CONSOLE_DRAFT_STATUS_20260928.md): AAB·트랙·판매자 계정·상품·심사 미제출. Firebase Blaze/운영 인프라와 실제 구매·복원·환불 검증도 미완료다. **로컬 빌드 검사는 판매 가능 판정이 아니다.**

## 이전 세션 기록 (아래의 당시 “현재/최신” 표시는 이력)

> **2026-09-27 최신 태블릿/수익화 검토:** 최신 요청은 휴대폰·태블릿 UI 수정과 실제 돈을 받을 수 있는 완성 앱의 배포 직전까지 작업이며, 무료 프리뷰/초안을 완료 단계로 계산하지 않는다. 잔여70% 하한 유지, 최종 조회 사용29%·잔여71%, 한도 확장 질문은 답변 대기/리셋 사용 없음. `docs/rebirth/design/status-system/TABLET_RELEASE_REVIEW_20260927.md`와 `docs/rebirth/MONETIZATION_READINESS_20260927.md`를 먼저 읽는다. 태블릿 raster 테두리의 글자 겹침, 상세 상태 큰 글자/배분/팝업, XpBar overflow 수정. 관련45·전체Flutter451통과/1skip·Cloud/Billing on 상품 테스트1통과·analyze clean. 서버의 앱 종료 후 구매 acknowledgment 복구를 private 작업 큐로 구현, 정책31통과(Node24 로컬, 원격Node22 미검증). 무료/유료 artifact 정책검사2통과, 실제 유료 AAB versionCode10의31검사 통과. 파일 `build/review/life-quest-2.0.0-10-paid-candidate.aab`는 Cloud/Billing on·Ads/QA off 후보이며 판매/출시 가능 판정이 아니다. 상태창 중심 새 유료 혜택의 구현/권한 연결, 가격/정산, Blaze/Auth/AppCheck/Play API/RTDN/private 큐 IAM, 실제 구매/복원/환불과 Android 실기, 제출 자료/Play 접근 검증이 남아 있다. 현재 Tide 단편과 핵심 상태창 구매 이유의 공백을 발견했고 확장팩은 권고/미구현이다. 수익성 불가능을 입증한 것은 아니며 우리 앱의 실제 매출/구매 전환은 없음. Play/Firebase 배포·상품 활성화·SNS·과금 계정 변경 없음. 완료 유료 출시라고 보고하지 않는다. 추가 작업 전 사용량과 사용자 하한 답변을 재확인한다.

> **2026-09-27 이전 v9 구현 기록:** 사용자가 조사 이후 앱 구현 변경을 명시적으로 지시했다. 사용량 하한은 **잔여70%**이며 아래5%/20%는 과거 이력이다. 최종 단계 조회 사용28%·잔여72%, 리셋 크레딧 사용 없음. `docs/rebirth/design/status-system/HUNTER_WINDOW_V9.md`를 먼저 읽는다. 첫 화면을 실제 이름·레벨·현지화 칭호·XP·4능력치·미배분 포인트의 개인 상태창으로 재구성했고, 퀘스트/성장 기록을 내부 메뉴로 옮겼다. 능력치 조회, 360ms 호출/모션 감소, 돌발 신호, 실제 보상 결과를 연결했다. 프레임은 생성 RGBA PNG이며 수제 SVG/HTML/Canvas 아트 없음. analyze 문제 없음·관련25테스트 통과·Web/ARM64 APK 최종 빌드 및 서명 확인. 검토 APK `build/review/life-quest-2.0.0-9-hunter-status-arm64.apk`(split ABI 실제versionCode2009). 신규 QA0XP→테스트 완료70XP→재진입70XP 유지 확인, 실제 사용자 반응 아님. 상세 배분 화면 전체의 시각 변경과 Android 실기 확인은 남아 있다. Play/SNS/수익화 변경 없음. v8 거절을 보존하고 v9 디자인 승인/출시 완료로 간주하지 않는다. 105개 IP 조사와 확인 수준은 `docs/rebirth/research/status-window-100/README.md`, `DESIGN_TRANSLATION.md`, `FOLLOWUP_20260927.md`에 유지했다. 코드가 포함된 최신 체크포인트를 아래 연구 전용 이력보다 우선한다. 추가 작업 전 사용량을 다시 확인한다.


> **최우선 디자인 수정 (2026-09-22, 사용자 거절 반영):** 사용자가 v8 디자인을 “배경만 꾸민 판타지 자기관리 앱”이라고 명확히 거절했다. 메인은 현대 판타지 헌터 세계관의 **상태창 자체**이며, 일정 관리는 기본 하위 기능이다. `docs/rebirth/design/status-system/STATUS_FIRST_CORRECTION.md`를 가장 먼저 읽는다. 기존 디자인 QA 통과는 제품 방향 승인으로 해석하지 않는다. 상태 패널의 인물 정보·능력치·칭호·스킬을 첫 화면의 중심으로 다시 설계한다. v8을 새 디자인 완료/승인으로 배포하지 않는다. 이번 수정 기록은 설계 기준이며 코드 구현은 아직 안 바뀌었다. 잔여5% 하한 유지.

> **현재 범위 갱신 (2026-09-22):** 사용자가 웹툰·소설 상태창 레퍼런스 조사 후 디자인과 미구현 연출의 **실제 구현**을 지시했다. 아래 구현 보류 메모는 이전 이력이다. 상태창 중심 화면, 돌발 의뢰 수락/거절/만료, 실제 보상 결과와 저장 검증을 진행한다. 사용량 잔여5% 하한. 작품 아트/로고를 제품에 복제하지 않고 생성 raster 자산 사용. 이번 구현을 Play 배포 완료로 표현하지 않는다.

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
- **applicationId**: `com.logian.lifequest` (2026-09-29 변경; `com.lifequest.app`은 2026-04-01~09-29 이력)
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
