# Life Quest - 프로젝트 메모리

## 프로젝트 개요
- **앱 이름**: Life Quest - 일상을 RPG처럼 관리하는 라이프 게이미피케이션 앱
- **프레임워크**: Flutter (Dart) + Flame 엔진 (Soul Deck 전투)
- **백엔드**: Firebase (Auth, Firestore, Storage, App Check, Crashlytics)
- **상태 관리**: Provider
- **GitHub**: https://github.com/Sn-bow/Life_Quest.git (branch: main)
- **applicationId**: `com.lifequest.app` (2026-04-01 변경, 이전: com.example.life_quest_final_v2)
- **플랫폼**: Android 전용 (Google Play Store, iOS 미지원)

---

## 현재 상태 (2026-04-28 기준)

### 검증 결과 (최신)
- `flutter analyze` → **No issues found** ✅
- `flutter test` → **73개 전체 통과** ✅
- `flutter build appbundle --release` → 성공 (64MB) ✅
- **버전**: `1.0.1+2`

### 최신 커밋
```
cb38fa6  QA 3차 잔여 수정: 서버 시간 검증 + 인벤토리 무결성 + 코드 품질
99c83e5  QA 3차 수정: 비동기 안전성 + 경제 원자성 + 성능 캐싱
7764074  docs: 2026-04-26 세션 종료 문서 최신화
f72dd20  QA 2차 권장사항: SharedPrefKeys 중앙화 + 퀘스트 정렬 최적화
d1025a4  QA 2차 수정: 게임 경제 무결성 + 보안 + l10n
```

---

## 완료된 전체 작업 이력

### Phase A~E (버그수정/품질/테스트/배포)
- 소모 아이템 삭제 버그, 장비 중복, Firestore 역직렬화 등 CRITICAL 5건 수정
- Firebase 오프라인, 인증 라우트, Android 13+ 알림 등 HIGH 6건 수정
- Android 릴리스 빌드 완료 (applicationId: com.lifequest.app, compileSdk: 36)
- 릴리스 키스토어 생성 (`android/upload-keystore.jks`, alias: upload, pw: lifequest2024!)
- 테스트 67개 → 73개로 확장

### Soul Deck 시스템 (2026-04-06)
- Phase 1: 핵심 모델/데이터/상태/화면 7개
- Phase 2: 전투 이펙트 (파티클, 화면 흔들림, 상태이상 아이콘 등)
- Phase 3: 던전↔캐릭터 보상 연동 (XP/골드 계산, 카드 보상 UI)
- Phase 4: 카드 컬렉션 화면 + 무한 타워 화면

### Step 1~3: 다국어 + 애니메이션 (2026-04-12~15)
- Step 1: 던전 UI 9개 화면 로컬라이제이션
- Step 2: CardData(207장), RelicData(31), Monster(36), Achievement(25), Title(28), Skill(24) → ARB 헬퍼 클래스
- Step 3: 전투 애니메이션 4종 Canvas 구현 (에셋 없이)

### QA 1차: 배포 전 종합 수정 (2026-04-25) — 커밋 `268077e`
배포불가 → 배포 전 필수 → 권장 총 19개 이슈 수정:
- IAP 서버사이드 영수증 검증 Cloud Function (`functions/src/index.ts`)
- 개인정보처리방침·이용약관 GitHub Pages URL 적용
- Firestore Security Rules (`firestore.rules`) 신규 생성
- `firebase.json`에 firestore rules 섹션 추가
- `cosmetic_shop_screen.dart` StatefulWidget으로 재작성 (실제 IAP 로직)
- `shop_screen.dart`, `inventory_screen.dart` → `isDataLoaded` guard 추가
- `main.dart` → `PurchaseService().init()` 추가
- Home Widget App Group ID 수정 (`group.com.lifequest.app.widget`)
- 버전 `1.0.0+1` → `1.0.1+2`

### QA 2차: 게임 경제 무결성 + 보안 + l10n (2026-04-25~26) — 커밋 `d1025a4`, `f72dd20`
- **퀘스트 중복 완료 방지**: `_pendingQuestIds` Set (CharacterState) + `isQuestPending/markQuestPending/clearQuestPending`
- **골드 원자적 저장**: `addCombatReward(gold:)` 파라미터 추가 — `hunt_screen.dart`에서 직접 수정 제거
- **코스메틱 샵 개별 아이템 추적**: `String? _purchasingIapId` (단일 bool 대체)
- **AdService 서버 시간 앵커**: `_syncServerTime()` → Firestore 서버 타임스탬프 기반 일일 리셋, 로컬 시간 조작 방지
- **SharedPrefKeys 중앙화**: `lib/utils/shared_pref_keys.dart` 신규, AdService/SoundService 전부 교체
- **퀘스트 정렬 최적화**: CharacterState에 `sortedDailyQuests` 등 4개 게터, QuestsScreen 인라인 정렬 제거
- **하드코딩 문자열 ARB 처리**: `questsGoldUnit`, `questsAdRewardApplied`, `questsRewardSummary` 등 4개 언어 추가

### QA 3차: 비동기 안전성 + 경제 원자성 + 성능 캐싱 (2026-04-28) — 커밋 `99c83e5`
- **R-1**: `quests_screen` — `markQuestPending()`을 `Navigator.pop()` 이전으로 이동 (비동기 갭 이중완료 방지)
- **R-2**: `hunt/skill/report/dungeon_home_screen` — `isDataLoaded` guard 추가 (NPE 방지)
- **R-3**: `character_state` — `loadDataForUser` user==null 분기 디버그 로그 추가
- **R-4**: `quests_screen` — mounted 체크 후 `AppLocalizations` null-safe 접근
- **R-5**: `shop_screen` — 골드 차감을 `CharacterState.purchaseItem/spendGold/purchaseStat`에 위임 (원자성 보장)
- **R-6**: `hunt_screen` — `didChangeDependencies()`에서 `CharacterState` 캐싱, `dispose()` context 접근 제거
- **O-1**: `character_state` — `hasLoadError` 게터 + `retryLoad()` + SnackBarAction 재시도 버튼
- **O-3**: `quests_screen` — 4개 static 헬퍼 메서드 추출 (`_categoryName`, `_difficultyName`, `_questTypeName`, `_difficultyColor`)
- **Y-1**: `character_state` — `questCategoryDistribution` 메모이제이션 (`_cachedCategoryDistribution`)

### QA 3차 잔여: 서버 시간 검증 + 인벤토리 무결성 + 코드 품질 (2026-04-28) — 커밋 `cb38fa6`
- **O-2**: `character_state` — `lastLoginDate` → `FieldValue.serverTimestamp()` 저장, `_parseLastLoginDate`에 `Timestamp` 타입 처리 추가 (클라이언트 시간 조작으로 퀘스트 이중 초기화 차단)
- **O-4**: `character_state` — 로드 시 장착 장비↔인벤토리 중복 제거 (equippedIds 기준 inventory 정제, 데이터 손상 자동 복구)
- **Y-2**: `character_state` — SnackBar 하드코딩 → `_localizedCardUnlock/AchievementUnlock/DeleteAccountError` 4개 언어 헬퍼
- **Y-3**: `inventory_screen` — `_buildCombatStats` 인라인 전투 공식 → `CombatState.effectiveAttack/Defense` static 메서드 재사용
- **Y-4**: `character_state` — `_tryUnlockRandomCard()` 매번 `Random()` 신규 생성 → 클래스 레벨 `_random` 재사용
- **Y-6**: `character_state` — `addCombatReward/addTimerReward/addDungeonReward` null guard 추가

---

## 주요 설계 결정 사항

### 캐릭터 스탯이 double인 이유
`strength`, `wisdom`, `health`, `charisma`는 `int`가 아닌 `double`:
- 레벨업 시 퀘스트 카테고리 누적 가중치(`levelGrowthWeights`)를 비율로 배분할 때 소수점 연산 필수
- 예: weight [str:0.6, wis:0.4] × 자동포인트 3 = str 1.8 → 2, wis 1.2 → 1 (소수점 반올림)
- 정수로 하면 레벨업마다 반올림 오차 누적
- UI 표시 시 `.toInt()` 또는 `.toStringAsFixed(0)` 사용 (정수처럼 보임)

### 카드 번역 방식 (ARB + 헬퍼 클래스)
데이터 모델의 필드를 `Map<String, String>`으로 바꾸는 대신:
- ARB 파일에 번역 키 추가 (`cardNameAtkC01`, `cardDescAtkC01` 등)
- `lib/data/card_localization.dart`의 `CardLocalization` 헬퍼로 switch-case 라우팅
- 장점: 타입 안전, IDE 자동완성, Firestore 저장 구조 불변
- RelicData/Monster/Achievement/Title/Skill 동일 패턴 적용 완료

### IAP 서버사이드 검증 흐름
```
앱 → Google Play → purchase_service.dart → Cloud Function(verifyGooglePlayPurchase)
→ Google Play Developer API 검증 → Firestore 기록 → 앱에 결과 반환
```
- Cloud Function: `functions/src/index.ts`
- 서비스 계정 키: `firebase functions:secrets:set GOOGLE_PLAY_SERVICE_ACCOUNT` (수동 필요)

### 광고 일일 리셋 조작 방지
- 앱 시작 시 `_syncServerTime()` → Firestore 서버 타임스탬프를 앵커로 저장
- 세션 내: `_serverAnchor + _anchorElapsed(Stopwatch)` 로 단조증가 시간 계산
- 앱 재시작: SharedPreferences의 `ad_last_server_ms` vs 기기 시간 중 큰 값 사용 (롤백 방지)

---

## 남은 수동 작업 (코드 외)

### 🔴 배포 전 필수 (수동)
1. **Firebase 콘솔** → Android 패키지명 `com.lifequest.app` 등록 + `google-services.json` 재다운로드
2. **AdMob 콘솔** → 앱 ID & 광고 단위 ID 확인 (프로덕션 ID가 `ad_service.dart`에 맞는지)
3. **Google Play Console** 서비스 계정 생성 → `firebase functions:secrets:set GOOGLE_PLAY_SERVICE_ACCOUNT` 실행
4. **Firebase 배포**: `firebase deploy --only functions,firestore`
5. **Google Play Console** → AAB 업로드 (`build/app/outputs/bundle/release/app-release.aab`)
6. **Play Console** → IARC 콘텐츠 등급 설문, 데이터 안전 섹션 작성

### 🟡 권장 (수동)
7. **실제 기기 테스트** (물리 Android 기기, USB 디버깅)
8. **Play Store 스크린샷** 4~8장 캡처 + 디자인 프레임 작업
9. **카드/밸런스 플레이 테스트** (수동)

---

## 핵심 파일 위치

| 파일 | 역할 |
|------|------|
| `lib/main.dart` | 앱 진입점, 서비스 초기화 순서 |
| `lib/state/character_state.dart` | 캐릭터 상태 전체 (퀘스트, 골드, 스탯, 정렬 게터) |
| `lib/services/ad_service.dart` | AdMob 보상형 광고, 일일 제한, 서버 시간 앵커 |
| `lib/services/purchase_service.dart` | IAP, Cloud Function 검증 연동 |
| `lib/services/sound_service.dart` | BGM/SFX 관리 |
| `lib/utils/shared_pref_keys.dart` | SharedPreferences 키 상수 모음 |
| `lib/game/battle_game.dart` | Flame 전투 엔진, 4종 애니메이션 |
| `lib/data/card_localization.dart` | 카드 207장 다국어 헬퍼 |
| `functions/src/index.ts` | Cloud Function: IAP 서버검증 |
| `firestore.rules` | Firestore 보안 규칙 |
| `android/upload-keystore.jks` | 릴리스 서명 키 (gitignore) |

---

## 주의사항
- 아바타/캐릭터 커스터마이징 기능은 의도적으로 제거됨 (다시 만들지 말 것)
- `image_picker`, `firebase_storage`, `firebase_app_check`는 pubspec에 유지
- 릴리스 키스토어(`upload-keystore.jks`)와 `key.properties`는 `.gitignore`에 포함
- Dart 패키지명은 `life_quest_final_v2` 그대로 유지 (Android applicationId만 변경)
- iOS 미지원 확정 (비용 문제)
- `RELEASE_CHECKLIST.md`에 Phase A~G 전체 출시 준비 체크리스트 있음
- `WORK_INSTRUCTIONS.md`에 세션별 작업 이력 상세 기록
