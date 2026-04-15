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

## 현재 상태 (2026-04-15 기준)

### 검증 결과 (최신)
- `flutter analyze` → **No issues found** ✅
- `flutter test` → **73개 전체 통과** ✅
- `flutter build appbundle --release` → 성공 (64MB) ✅

---

## 3단계 로컬라이제이션 계획 진행 현황

### Step 1: 던전 UI 로컬라이제이션 ✅ 완료
- 9개 던전 화면의 하드코딩 문자열 → ARB 키 추가
- app_en/ko/ja/zh.arb 각각 업데이트
- 각 화면에 AppLocalizations.of(context)! 적용
- 커밋: `014affe` (Step 1-A), `fa22e98` (Step 1-B)

### Step 2: 데이터 모델 다국어 리팩토링 🔄 절반 완료

#### 완료
- **CardData (207장)** → ARB + CardLocalization 헬퍼 방식으로 완료
  - `lib/data/card_localization.dart` — CardLocalization.localizedName/Description()
  - `lib/l10n/app_en/ko/ja/zh.arb` — 모든 카드 키 추가됨
  - 커밋: `5e155f2`(2-A) → `c1d3497`(2-B) → `6c1458a`(2-C) → `adbbe20`(2-D) → `d0b1145`(2-E) → `7a0bb67`(2-F) → `afc3759`(2-G)

#### 미완료 (다음 세션에서 진행)
- **RelicData (31개)** → ❌ 번역 없음
  - 파일: `lib/data/relic_database.dart`, `lib/models/relic_data.dart`
  - 방식: CardLocalization과 동일하게 ARB + RelicLocalization 헬퍼 생성
- **Monster** → ❌ 번역 없음
  - 파일: `lib/data/monster_database.dart`, `lib/models/monster.dart`
- **Achievement (업적)** → ❌ 번역 없음
  - 파일: `lib/data/achievement_database.dart`, `lib/models/achievement.dart`
- **Title (칭호)** → ❌ 번역 없음
  - 파일: `lib/data/title_database.dart`, `lib/models/title.dart`
- **Skill (스킬)** → ❌ 번역 없음
  - 파일: `lib/data/skill_database.dart`, `lib/models/skill.dart`

#### Step 2 구현 전략 (다음 세션 참고)
CardData와 동일한 패턴으로 진행:
1. 각 데이터 파일에서 name/description 한국어 원문 수집
2. app_en/ko/ja/zh.arb에 번역 키 추가 (`relicNameXxx`, `achievementNameXxx` 등)
3. `flutter gen-l10n` 실행
4. `lib/data/relic_localization.dart` 등 헬퍼 클래스 생성
5. 해당 UI 화면에서 헬퍼 클래스 적용

### Step 3: Soul Deck 미구현 부분 완성 ❌ 미착수
- **전투 애니메이션 스텁 4개 구현** (에셋 불필요, 코드만)
- **스프라이트/사운드** — 에셋 필요, Claude 단독 작업 불가

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
