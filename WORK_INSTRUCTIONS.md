# Life Quest - 세션별 작업 이력

> 각 세션에서 완료한 작업을 역순으로 기록합니다.
> 새 세션 시작 시 이 파일을 읽으면 현재 상태를 빠르게 파악할 수 있습니다.

---

## 세션 #12 — 2026-04-28 (QA 4차: 전/역방향 플로우 종합 QA + 수정)

### 완료 작업

#### 전방향 QA → 역방향 QA → 취합 보고 후 전체 수정 (커밋 `81c2dd9`)

**[C-1] CRITICAL — Firestore `_meta` 서브컬렉션 차단 해소**
- `firestore.rules`: `match /users/{userId}/_meta/{doc}` 규칙 추가
- 기존: 기본 deny 규칙이 `_meta/adServerTime` 쓰기 차단 → AdService 서버시간 앵커 무효화
- 수정 후: 광고 일일 리셋 조작 방지 기능 실제 동작

**[H-1] AP 원자적 관리 메서드 추가**
- `character_state.dart`: `spendActionPoints(int cost)` — 차감 성공 여부 반환, `unawaited(_saveData())`
- `character_state.dart`: `recoverActionPoints(int amount)` — maxAP 클램프 + `_performSaveData()` 즉시 저장
- `hunt_screen.dart`: `_applyApCost()`, `_buildSkillMenu()` AP 차감 → `spendActionPoints()` 위임
- `hunt_screen.dart`: `_showApWarning()` AP 회복 → `recoverActionPoints(2)` 위임 (직접 변이 완전 제거)

**[H-2] 보안 — 미지원 provider 재인증 우회 차단**
- `settings_screen.dart`: `_reauthenticateAndConfirm()` unknown provider fallback `return true` → `return false`
- 기존: 알 수 없는 인증 제공자일 때 재인증 없이 계정 삭제 허용 (보안 결함)

**[H-3] timer_screen duration 칩 l10n**
- `'15분'`, `'25분'`, `'45분'`, `'60분'` 하드코딩 → `l10n.timerDuration15/25/45/60`

**[M-1] hunt_screen l10n**
- AP 회복 SnackBar: `'⚡ AP가 2 회복되었습니다!'` → `l10n.huntApRecovered`
- 스킬 쿨다운: `'${cd}턴'` → `l10n.huntSkillCooldownTurns(cd)`

**[M-2] settings_screen 재인증 l10n**
- `l10n.settingsReauthFailed(e.toString())` / `l10n.settingsReauthWrongPassword`

**[M-3] shop_screen 타입 안전성**
- `_buildGameItemsTab` 4번째 파라미터 `dynamic` → `Character`

**[M-4] status_screen 진행바 오버플로우 방지**
- `value: (displayValue / 100.0).clamp(0.0, 1.0)` — 100 초과 스탯 시 RangeError 방지

**[M-6] main.dart 재방문 UX 개선**
- 이미 로그인된 사용자(`FirebaseAuth.instance.currentUser != null`): 1800ms 인트로 스킵
- 신규/비로그인 사용자: 기존 동작 유지

**[L-1] login_screen 예외 처리 완결**
- `FirebaseAuthException` 외 일반 `Exception` catch 추가 → `l10n.loginErrorUnknown(e.toString())`

**l10n (4개 언어 ko/en/ja/zh)**
- 신규 키: `timerDuration15/25/45/60`, `huntApRecovered`, `huntSkillCooldownTurns(int)`, `settingsReauthFailed(String)`, `settingsReauthWrongPassword`
- `app_localizations.dart` 추상 메서드 선언 + 4개 구현 파일 모두 수동 동기화

### 커밋
- `81c2dd9` — QA 4차 수정: Firestore 규칙 + AP 원자성 + 보안 + l10n + UI 안정성

---

## 세션 #11 — 2026-04-28 (QA 3차 완료)

### 완료 작업

#### QA 3차 즉시/필수 (커밋 `99c83e5`)
- **R-1**: `quests_screen` — `markQuestPending()` Navigator.pop 이전으로 이동
- **R-2**: hunt/skill/report/dungeon_home에 `isDataLoaded` guard
- **R-3**: `character_state` — user==null 분기 디버그 로그
- **R-4**: `quests_screen` — mounted 후 AppLocalizations null-safe 접근
- **R-5**: `shop_screen` — 골드 차감 CharacterState 위임 (purchaseItem/spendGold/purchaseStat)
- **R-6**: `hunt_screen` — didChangeDependencies 캐싱, dispose 안전화
- **O-1**: `character_state` — hasLoadError + retryLoad() + SnackBarAction
- **O-3**: `quests_screen` — 4개 static 헬퍼 메서드 추출
- **Y-1**: `character_state` — questCategoryDistribution 메모이제이션

#### QA 3차 잔여 (커밋 `cb38fa6`)
- **O-2**: `character_state` — `lastLoginDate` → `FieldValue.serverTimestamp()` 저장
  - `_parseLastLoginDate`: Firestore `Timestamp` 타입 처리 추가, 레거시 String 호환 유지
  - 효과: 클라이언트 기기 시계 조작으로 퀘스트 이중 초기화 불가
- **O-4**: `character_state` — 로드 시 장착 장비↔인벤토리 중복 제거
  - equippedWeapon/Armor/Accessory id와 일치하는 inventory 항목 제거
  - 데이터 손상 시 자동 복구 + needsSave=true 즉시 재저장
- **Y-2**: `character_state` — SnackBar 하드코딩 → locale 기반 다국어 헬퍼 3개
  - `_localizedCardUnlock`, `_localizedAchievementUnlock`, `_localizedDeleteAccountError`
- **Y-3**: `inventory_screen` — `_buildCombatStats` 전투 공식 중복 제거
  - `CombatState.effectiveAttack/Defense` static 메서드 재사용
- **Y-4**: `character_state` — `_random` 클래스 레벨 단일 인스턴스 재사용
- **Y-6**: `character_state` — addCombatReward/addTimerReward/addDungeonReward null guard

### 커밋
- `99c83e5` — QA 3차 수정: 비동기 안전성 + 경제 원자성 + 성능 캐싱
- `db905e4` — docs: QA 3차 CLAUDE.md 반영
- `cb38fa6` — QA 3차 잔여 수정: 서버 시간 검증 + 인벤토리 무결성 + 코드 품질

---

## 세션 #10 — 2026-04-26 (QA 2차 권장사항 완료 + 문서화)

### 완료 작업
- **`lib/utils/shared_pref_keys.dart`** 신규: SharedPreferences 키 상수 중앙 관리
- **`lib/services/ad_service.dart`**: 모든 하드코딩 키 → SharedPrefKeys 상수로 교체
- **`lib/services/sound_service.dart`**: `'sound_muted'` → `SharedPrefKeys.soundMuted`
- **`lib/state/character_state.dart`**: `sortedDailyQuests`, `sortedWeeklyQuests`, `sortedMonthlyQuests`, `sortedYearlyQuests` 게터 추가
- **`lib/screens/quests_screen.dart`**: 인라인 정렬 코드 제거 → CharacterState 정렬 게터 사용
- **문서 전면 최신화**: `CLAUDE.md`, `WORK_INSTRUCTIONS.md`, `RELEASE_CHECKLIST.md`

### 커밋
- `f72dd20` — QA 2차 권장사항: SharedPrefKeys 중앙화 + 퀘스트 정렬 최적화
- `docs` 커밋 (이 세션)

---

## 세션 #9 — 2026-04-25~26 (QA 2차: 게임 경제 무결성 + 보안)

### 완료 작업
1. **퀘스트 중복 완료 방지** (`_pendingQuestIds` Set)
   - `character_state.dart`: `isQuestPending()`, `markQuestPending()`, `clearQuestPending()`
   - `quests_screen.dart`: 광고 시청 비동기 갭 동안 pending 마킹, `barrierDismissible: false`

2. **골드 원자적 저장**
   - `character_state.dart`: `addCombatReward(int xp, EquipmentItem? loot, {int gold = 0})`
   - `hunt_screen.dart`: 직접 `character.gold +=` 제거 → `addCombatReward(gold:)` 파라미터 사용

3. **코스메틱 샵 개별 아이템 추적**
   - `cosmetic_shop_screen.dart`: `bool _isPurchasing` → `String? _purchasingIapId` (어느 아이템이 구매 중인지 추적)

4. **AdService 서버 시간 앵커** (시간 조작 방지)
   - `_syncServerTime()`: Firestore 서버 타임스탬프로 앵커 확보
   - `_serverNow()`: 앵커 + Stopwatch(단조증가) 기반 현재 시각
   - `SharedPrefKeys.adLastServerMs` 영속 저장 (앱 재시작 간 롤백 방지)

5. **하드코딩 문자열 ARB 처리**
   - `'골드'` → `l10n.questsGoldUnit`
   - `'🎉 광고 보상 적용'` → `l10n.questsAdRewardApplied`
   - `questsRewardSummary`, `questsRewardStatPoints`, `questsRewardUnlockedTitles`, `questsRewardUnlockedCosmetics` 추가
   - `settingsReauthPasswordTitle`, `cosmeticUnlocked`, `cosmeticPurchaseError` 추가
   - `defaultReward1/2/3Name/Desc` 추가
   - 4개 언어 ARB 파일(ko/en/ja/zh) 모두 업데이트

### 커밋
- `d1025a4` — QA 2차 수정: 게임 경제 무결성 + 보안 + l10n

---

## 세션 #8 — 2026-04-25 (배포 전 종합 수정 19개)

### 완료 작업

#### 🔴 배포 불가 항목
- `firestore.rules` 신규: 사용자 인증 + gold/level 필드 검증
- `firebase.json` firestore rules 섹션 추가
- `purchase_service.dart`: `dart:async` import 추가 (`unawaited`)
- `ad_service.dart`: UMP Completer 이중 complete 방지 (`if (!completer.isCompleted)`)

#### 🟠 배포 전 필수 항목
- `cosmetic_shop_screen.dart`: StatelessWidget → StatefulWidget, 실제 IAP 로직 연결
  - `PurchaseService.unlockStream` 구독 → `charState.unlockCosmetic()` 호출
  - `ProductDetails.price` 버튼에 표시
  - `String? _purchasingIapId`로 개별 아이템 로딩 상태 관리
- `shop_screen.dart`: `isDataLoaded` guard 추가 (데이터 로딩 전 빈 화면 방지)
- `inventory_screen.dart`: `isDataLoaded` guard 추가
- `main.dart`: `PurchaseService().init()` 추가 (AdService 초기화 이후)
- Home Widget App Group ID 수정: `group.com.example.lifeQuestWidget` → `group.com.lifequest.app.widget`
- 버전: `1.0.0+1` → `1.0.1+2`

#### 🟡 권장 항목
- `character_state.dart`: `_buildDefaultCustomRewards()` → 4개 언어 인라인 (langCode 파라미터)
- `character_state.dart`: `_localizedSoulDeckClear()` 헬퍼 추가
- `ad_service.dart`: SharedPrefKeys 상수 도입 (이 세션에서 시작, 세션 #9~10에서 완료)

### Cloud Function (C-2)
- `functions/src/index.ts`: `verifyGooglePlayPurchase` 함수
  - Google Play Developer API v3 검증
  - Firestore에 검증 결과 저장 (`purchases/{orderId}`)
  - GOOGLE_PLAY_SERVICE_ACCOUNT 시크릿 사용

### 커밋
- `268077e` — 배포 전 종합 수정: 배포불가→필수→권장 19개 이슈 해결
- `4a821fd` — C-2: IAP 서버사이드 영수증 검증 Cloud Function 추가
- `e461051` — C-4: 개인정보처리방침·이용약관 GitHub Pages URL 적용

---

## 세션 #7 — 2026-04-25 (QA 1차 감사 + Threads 홍보)

### 완료 작업
- QA 1차 감사 19개 이슈 발견 및 분류 (배포불가/필수/권장)
- Threads 홍보 게시물 작성:
  - 한국어 3부 연작 (개발일기 형식)
  - 일본어 단편 (ひらがな·카타카나 중심, 가볍고 친근한 톤)
- Threads 알고리즘 분석: 한국어 계정에서 일본어 테스트 포스트 전략 논의

---

## 세션 #6 — 2026-04-15 (Step 3 완료 + 버그수정 + README)

### 완료 작업
- **`lib/game/battle_game.dart`**: 전투 애니메이션 4종 Canvas 구현 (에셋 없이)
  - `_SlashEffect`: 3중 슬래시 라인
  - `_ShieldRaiseEffect`: 오각형 방패 윤곽선
  - `_MagicProjectile`: 마법 구슬 + 파티클
  - `_EnemyDeathEffect` + `_Shard`: 섬광 + 12파편 폭발
- `dungeon_home_screen.dart`: `character.strength` 등 `double → .toInt()` 버그 수정 (`STR 10.0` → `STR 10`)
- README.md 전면 재작성

### 커밋
- `58ac52e` — fix: 던전 홈 스탯 double 표시 버그
- `4b3c720` — docs: README 최신화

---

## 세션 #5 — 2026-04-12~14 (Step 2-H: 데이터 모델 다국어 완료)

### 완료 작업
- `lib/data/relic_localization.dart` — RelicLocalization (31개)
- `lib/data/achievement_localization.dart` — AchievementLocalization (25개)
- `lib/data/title_localization.dart` — TitleLocalization (28개)
- `lib/data/skill_localization.dart` — SkillLocalization (24개)
- `lib/data/monster_localization.dart` — MonsterLocalization (31몬스터 + 5챕터)
- app_en/ko/ja/zh.arb에 총 252 키 × 4언어 = 1,008 entries 추가

### 커밋
- `026ab30` — Step 2-H: RelicData/Monster/Achievement/Title/Skill 다국어 완료

---

## 세션 #4 — 2026-04-08~12 (Step 2-A~G: CardData 다국어)

### 완료 작업
- 카드 207장 전체 → ARB + `CardLocalization` 헬퍼 클래스 방식
- `lib/data/card_localization.dart` 신규

### 커밋
- `5e155f2`(2-A) → `c1d3497`(2-B) → `6c1458a`(2-C) → `adbbe20`(2-D) → `d0b1145`(2-E) → `7a0bb67`(2-F) → `afc3759`(2-G)

---

## 세션 #3 — 2026-04-06~08 (Step 1: 던전 UI 로컬라이제이션)

### 완료 작업
- 던전 화면 9개 하드코딩 문자열 → ARB 키
- app_en/ko/ja/zh.arb 업데이트

### 커밋
- `014affe` (Step 1-A), `fa22e98` (Step 1-B)

---

## 세션 #2 — 2026-04-06 (Soul Deck 시스템 Phase 1~4)

### 완료 작업
- Phase 1: 카드 모델, CardDatabase(207장), CombatState, 전투 화면 등 7개 파일
- Phase 2: 파티클, 화면 흔들림, 상태이상 아이콘
- Phase 3: 던전↔캐릭터 보상 연동 (XP/골드)
- Phase 4: 카드 컬렉션 화면, 무한 타워 화면

---

## 세션 #1 — 2026-03-03 (Phase A~E: 기반 정비)

### 완료 작업
- CRITICAL 버그 5건: 소모 아이템 삭제, 장비 중복, Firestore 역직렬화 등
- HIGH 버그 6건: Firebase 오프라인, 인증 라우트, Android 13+ 알림 등
- 릴리스 빌드 설정 (applicationId: com.lifequest.app, compileSdk: 36)
- 릴리스 키스토어 (`android/upload-keystore.jks`, alias: upload, pw: lifequest2024!)
- 테스트 확장: 67개 → (이후 73개)

---

## 다음 세션 우선순위 (2026-04-28 기준)

### QA 코드 수정 완료 상태
- QA 1차 (19건), 2차 (7건), 3차 전체 (15건) → **모두 완료** ✅
- 추가 코드 QA 이슈 없음 — 다음 단계는 기능 개선 또는 배포 준비

### 즉시 할 수 있는 것 (Claude 단독)
1. ProGuard/R8 설정 (`android/app/build.gradle.kts`) — AAB 크기 축소 + 코드 난독화
2. 햅틱 피드백 추가 (`card_battle_screen.dart`) — 카드 사용/전투 이벤트
3. 카드 툴팁 시스템 (롱프레스 시 키워드 설명 팝업)
4. 시즌 카운트다운 하드코딩 수정 (`dungeon_home_screen.dart` 내 hardcoded date)
5. Play Store 스토어 등록 텍스트 초안 작성

### 수동 작업 완료 후 진행
6. 실제 기기 테스트 결과 → 발생 버그 수정
7. 카드 밸런스 조정 (플레이테스트 결과 기반)

### 수동 작업 (사람이 직접) — 🔴 배포 전 필수
- Firebase 콘솔 패키지명 `com.lifequest.app` 등록 + `google-services.json` 재다운로드
- `firebase deploy --only functions,firestore`
- Google Play Console 서비스 계정 → `firebase functions:secrets:set GOOGLE_PLAY_SERVICE_ACCOUNT`
- AdMob 프로덕션 ID 최종 확인 (`ad_service.dart`)
- Google Play Console AAB 업로드 (`build/app/outputs/bundle/release/app-release.aab`)
- IARC 콘텐츠 등급, 데이터 안전 섹션 작성
