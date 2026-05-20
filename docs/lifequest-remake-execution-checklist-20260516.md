# Life Quest Remake Execution Checklist - 2026-05-16

## 2026-05-17 우선순위 보정

추가 피드백에 따라 "던전 중심 리메이크"가 아니라 "현실 행동 상태판 중심 리메이크"로 실행 순서를 보정한다.

- [x] 추가 피드백을 별도 문서로 기록: `docs/threads-core-loop-feedback-20260517.md`
- [x] 마스터 플랜에 "던전은 선택형 보조 루프" 원칙 추가
- [x] 오늘의 모험 문구를 던전 중심에서 현실 행동 상태판 중심으로 수정
- [x] `오늘의 상태`를 첫 하단 탭으로 승격하고 기존 상태창은 상세 화면으로 재배치
- [x] DailyModifier를 던전 시작 스냅샷에 저장
- [x] 오늘 HP/골드 보정을 던전 시작 수치에 실제 적용
- [x] 오늘 공격/첫 턴 드로우 보정을 전투에 실제 적용
- [x] 칭호가 추천 행동/이벤트 조건으로 작동하는 1차 연결 구현
- [ ] 주간 기록 기반 챌린지/경쟁은 별도 P1 설계로 분리
- [ ] AR/Health Connect/모션 인식은 P2 보류 항목으로 유지

## 목적

Life Quest 리메이크를 실제 작업 단위로 쪼갠다. 이 문서는 방향성 문서가 아니라 실행 관리 문서다. Claude/Codex가 이어받을 때 이 체크리스트를 기준으로 조사, 구현, 검증, 문서화를 진행한다.

## 실행 원칙

- 기능 추가보다 핵심 루프 명확화가 우선이다.
- 기존 기능을 지우기 전에 숨김/재배치로 위험을 줄인다.
- 매 Phase마다 문서, 코드, 검증 산출물이 있어야 한다.
- AI 디자인/외부 연동/구독은 파일럿 성공 전까지 금지한다.
- QA Preview와 Android 앱이 너무 다른 경험이 되지 않게 한다.

---

## 전체 단계

```text
Phase 0. 기능 컷라인 확정
Phase 1. Core Loop 데이터/규칙 설계
Phase 2. 오늘의 모험 홈 파일럿
Phase 3. 퀘스트 -> 던전 보정 연결
Phase 4. 칭호 -> 이벤트/효과 연결
Phase 5. 게임 UI/디자인 기준작 파일럿
Phase 6. 출시 1차 기능 잠금
Phase 7. QA/보안/스토어 준비
```

---

## Phase 0. 기능 컷라인 확정

### 목표

현재 앱의 기능을 유지/재배치/숨김/삭제 후보/장기 보류로 확정한다.

### 선행 조사

- [ ] `lib/screens/main_screen.dart` 하단 탭 구조 확인
- [ ] `lib/screens/status_screen.dart` 성장/상태 기능 확인
- [ ] `lib/screens/quests_screen.dart` 퀘스트 구조 확인
- [ ] `lib/screens/dungeon/dungeon_home_screen.dart` 모험 진입 구조 확인
- [ ] `lib/screens/shop_screen.dart` 현실 보상 구조 확인
- [ ] `lib/screens/achievement_screen.dart` 업적 구조 확인
- [ ] `lib/state/character_state.dart` 저장 데이터 의존성 확인
- [ ] `lib/state/dungeon_state.dart` 던전 런 상태 의존성 확인

### 구현 없음

Phase 0에서는 코드 변경하지 않는다. 판단 문서만 확정한다.

### 산출물

- [x] `docs/lifequest-feature-cutline-20260516.md`
- [ ] 기능별 최종 판정 표 보강
- [ ] 사용자 확인 후 확정 표시

### 완료 조건

- [ ] 출시 1차 하단 탭이 4개 이하로 확정됨
- [ ] 전면 노출 금지 기능이 확정됨
- [ ] 삭제 후보 기능의 데이터 보존 방침이 있음

---

## Phase 1. Core Loop 데이터/규칙 설계

### 목표

현실 퀘스트가 성장/던전/칭호/이벤트로 변환되는 규칙을 확정한다.

### 선행 조사

- [ ] `lib/models/quest.dart`의 QuestType/QuestCategory/QuestDifficulty 확인
- [ ] `lib/state/character_state.dart` 퀘스트 완료 로직 확인
- [ ] `lib/models/title.dart` 칭호 구조 확인
- [ ] `lib/data/title_database.dart` 칭호 DB 확인
- [ ] `lib/data/event_database.dart` 던전 이벤트 구조 확인
- [ ] `lib/state/dungeon_state.dart` 던전 시작/보상 흐름 확인
- [ ] `lib/state/card_combat_state.dart` 전투 수치 적용 지점 확인

### 설계 작업

- [x] `docs/lifequest-core-loop-ux-20260516.md` 초안 작성
- [ ] QuestCategory -> GrowthDelta 확정
- [ ] GrowthDelta -> DailyModifier 확정
- [ ] Title -> EventUnlock 확정
- [ ] 보정 상한/하한 확정
- [ ] QA Preview seed 데이터에서 확인 가능한 예시 작성

### 코드 작업 후보

- [ ] `lib/models/growth_delta.dart` 추가
- [ ] `lib/models/daily_modifier.dart` 추가
- [ ] `lib/data/core_loop_rules.dart` 추가
- [ ] `test/data/core_loop_rules_test.dart` 추가

### 완료 조건

- [ ] 퀘스트 1개 완료가 어떤 성장과 보정을 만드는지 테스트로 검증됨
- [ ] 오늘 완료한 여러 퀘스트의 보정 합산이 테스트됨
- [ ] 보정 최대값 제한이 테스트됨

---

## Phase 2. 오늘의 모험 홈 파일럿

### 목표

사용자가 첫 화면에서 앱의 목적을 이해하게 만든다.

### 대상 화면

1차 후보:
- `lib/screens/quests_screen.dart` 상단에 `오늘의 모험` 블록 추가

2차 후보:
- 새 `TodayScreen` 추가 후 `main_screen.dart` 첫 탭 교체

권장:
- 처음에는 `quests_screen.dart` 상단 파일럿으로 시작한다.
- 성공하면 `TodayScreen`으로 분리한다.

2026-05-17 진행:
- `lib/screens/today_screen.dart`를 추가해 `오늘의 상태`, XP/HP/골드/AP, 퀘스트 CTA, 던전 CTA, 상세 상태 진입을 한 화면에 묶었다.
- `lib/screens/main_screen.dart` 첫 하단 탭을 `오늘`으로 교체했다.
- 기존 `StatusScreen`은 삭제하지 않고 `상세 상태 보기`로 진입하게 유지했다.
- `flutter analyze --no-pub`와 `flutter test --no-pub` 전체 105개 통과로 기본 회귀 검증을 완료했다.

### UI 구성 체크리스트

- [x] 오늘의 모험 제목
- [x] 오늘 완료/남은 퀘스트 수
- [x] 오늘 획득 XP/골드
- [x] 오늘 성장한 스탯
- [x] 오늘 던전 보정
- [x] 다음 칭호까지 남은 조건
- [x] 추천 행동 1개
- [x] 집중 타이머 CTA
- [x] 던전 시작 CTA

### 디자인 체크리스트

- [ ] 휴대폰 390px 폭에서 텍스트 잘림 없음
- [ ] 카드 안에 카드 중첩 없음
- [ ] 1화면 내 정보 과밀하지 않음
- [ ] 숫자보다 다음 행동이 먼저 보임
- [ ] Web QA Preview에서도 모바일 프레임 안에 맞음

### 코드 작업 후보

- [x] `lib/widgets/today_adventure_summary.dart` 추가
- [x] `CharacterState.todayGrowthDelta` getter 추가
- [x] `CharacterState.todayDailyModifier` getter 추가
- [x] `CharacterState.nextTitleProgress` getter 추가
- [x] `quests_screen.dart`에 파일럿 위젯 삽입
- [x] `lib/screens/today_screen.dart` 추가
- [x] `main_screen.dart` 첫 탭을 TodayScreen으로 교체

### 테스트

- [ ] 오늘 퀘스트가 없을 때 empty state
- [ ] 완료 퀘스트 0개
- [ ] 완료 퀘스트 1개
- [ ] 여러 카테고리 완료
- [ ] 다음 칭호 없음
- [ ] QA Preview seed 데이터

### 완료 조건

- [ ] 첫 화면에서 현실 행동 -> 성장 -> 던전 보정 연결이 보임
- [ ] 테스터에게 다시 공유 가능한 화면 캡처가 나옴
- [x] `flutter analyze` 통과
- [x] 관련 단위 테스트 통과

---

## Phase 3. 퀘스트 -> 던전 보정 연결

### 목표

퀘스트 완료 결과가 실제 던전 플레이에 적용되게 한다.

2026-05-18 진행:
- 던전 홈에 `오늘 현실 행동 보정` 카드를 추가했다.
- 오늘 완료한 퀘스트 이름을 보정 출처로 표시하고, 이번 런 시작 시 고정 적용된다는 설명을 추가했다.
- 적용 예정 보정이 없을 때는 현실 퀘스트 완료 후 보정이 열린다는 empty state를 표시한다.

### 적용 후보

- [x] 전투 HP 보정
- [x] 공격 피해 보정
- [x] 첫 턴 드로우 보정
- [x] 카드 보상 확률 보정
- [x] 이벤트 선택지 보정
- [x] 상점 할인 보정
- [x] 휴식 회복량 보정

### 구현 순서

1. [x] DailyModifier 계산만 구현
2. [x] 던전 시작 시 modifier snapshot 저장
3. [x] 던전 홈에 modifier 표시
4. [x] 전투 HP 보정 하나만 실제 적용
5. [x] 첫 턴 드로우 또는 카드 보상 확률 적용
6. [x] 이벤트 선택지 적용
7. [x] 상점/휴식 적용 여부 판단

### 관련 파일

- [x] `lib/state/character_state.dart`
- [x] `lib/state/dungeon_state.dart`
- [x] `lib/state/card_combat_state.dart`
- [x] `lib/screens/dungeon/dungeon_home_screen.dart`
- [x] `lib/screens/dungeon/card_battle_screen.dart`
- [x] `lib/screens/dungeon/dungeon_event_screen.dart`

### 테스트

- [ ] 퀘스트 완료 전 modifier 0
- [x] health 퀘스트 완료 후 HP 보정 생성
- [x] wisdom 퀘스트 완료 후 draw/card 보정 생성
- [x] 던전 시작 시 snapshot 고정
- [x] 던전 중 퀘스트 완료해도 현재 런에는 반영되지 않음
- [x] 다음 런에는 새 modifier 반영

### 완료 조건

- [x] 퀘스트 완료가 던전 수치에 실제 영향을 줌
- [x] UI에서 보정 출처를 설명함
- [x] 던전 밸런스가 과도하게 깨지지 않음

---

## Phase 4. 칭호 -> 이벤트/효과 연결

### 목표

칭호를 장식이 아니라 앱을 계속 쓰게 하는 해금 장치로 만든다.

2026-05-18 진행:
- `lib/data/title_unlock_rules.dart`를 추가해 칭호 ID별 이벤트 선택지 규칙을 별도 레이어로 분리했다.
- 다음 칭호가 요구하는 스탯과 맞는 미완료 퀘스트가 있으면 오늘 추천 행동이 해당 퀘스트를 우선 추천한다.
- 던전 이벤트 화면에서 해금한 칭호에 맞는 선택지를 기존 이벤트 선택지 뒤에 합성한다.
- 오늘 상태의 다음 칭호 진행도에 이벤트 선택지 해금 미리보기를 표시한다.
- 1차 연결 칭호: `근력 마니아`, `현자 지망생`, `강철 체력`, `만인의 연인`, `초보 캠퍼`.

### 출시 1차 범위

- [x] 칭호 10~20개 선정
- [x] 각 칭호에 조건 1개
- [x] 각 칭호에 효과 1개
- [x] 각 칭호에 연결 이벤트 또는 선택지 1개

### 관련 파일

- [x] `lib/data/title_database.dart`
- [ ] `lib/models/title.dart`
- [x] `lib/data/event_database.dart`
- [x] `lib/models/dungeon_event.dart`
- [ ] `lib/screens/status_screen.dart`
- [x] `lib/screens/dungeon/dungeon_event_screen.dart`

### 구현 순서

1. [x] title metadata 확장 가능성 조사
2. [x] 별도 `title_unlock_rules.dart`로 시작할지 결정
3. [x] 다음 칭호 진행도 계산
4. [x] 오늘의 모험 블록에 다음 칭호 표시
5. [x] 던전 이벤트 조건 선택지 1개 파일럿
6. [x] 칭호 효과 설명 UI 추가

### 테스트

- [x] 칭호 조건 진행 계산
- [x] 이미 해금한 칭호 제외
- [x] 다음 칭호 추천 우선순위
- [x] 조건 충족 시 이벤트 선택지 표시
- [x] 조건 미충족 시 선택지 숨김

### 완료 조건

- [x] 사용자가 칭호를 얻어야 하는 이유가 생김
- [x] 칭호가 최소 1개 이상 실제 이벤트 선택지에 영향을 줌

---

## Phase 5. 게임 UI/디자인 기준작 파일럿

### 목표

전체 리디자인 전에 1개 화면만 기준작으로 만든다.

### 후보

1. 오늘의 모험 홈
2. 전투 화면

권장:
- 먼저 `오늘의 모험 홈`
- 이유: 제품 목적을 설명하는 화면이 먼저다. 전투 화면만 예뻐져도 앱 목적이 약하면 개선 효과가 작다.

### 디자인 탐색 체크리스트

- [ ] Tactical notebook RPG 방향 1안
- [ ] Dark RPG productivity 방향 1안
- [ ] Cozy fantasy productivity 방향 1안
- [ ] 실제 390x844 모바일 기준 비교
- [ ] 텍스트 밀도 비교
- [ ] Flutter 구현 난이도 비교
- [ ] AI 티/스톡 이미지 티 여부 판단

### 도구 사용 원칙

- Figma: UI 구조/토큰/컴포넌트 기준작
- 이미지 생성: 배경/카드/아이콘 후보
- Canva: 홍보물/테스터 모집 이미지
- Hyperframes/영상 도구: 데모 영상
- Flutter: 최종 판단 기준

### 금지

- Figma 예쁘다고 바로 전체 반영
- 이미지 생성 결과를 검수 없이 앱에 삽입
- 실제 폰 QA 전 디자인 확정
- 카드/배경/몬스터 대량 생성

### 성공 기준

- [ ] 현재 화면보다 목적이 명확함
- [ ] 첫 화면에서 다음 행동이 보임
- [ ] 390px 폭에서 읽힘
- [ ] 카드/패널/버튼의 디자인 언어가 통일됨
- [ ] 구현 난이도가 1~2일 파일럿 범위

---

## Phase 6. 출시 1차 기능 잠금

### 목표

계속 기능을 추가하지 않고 출시 가능한 크기로 잠근다.

### 포함 기능

- [ ] 오늘의 모험 홈
- [ ] 일일/주간 퀘스트
- [ ] 성장 프로필
- [ ] 칭호 10~20개
- [ ] 던전 1챕터
- [ ] 카드 전투
- [ ] 카드 보상
- [ ] 던전 이벤트
- [ ] 현실 보상
- [ ] 집중 타이머
- [ ] 기본 리포트

### 제외 기능

- [ ] Health Connect
- [ ] 인바디/AR 연동
- [ ] AI 개인 코치
- [x] 구독
- [ ] 무한 타워
- [ ] 승천 모드
- [ ] 월간/연간 레이드 전면 노출
- [ ] 전체 카드별 아트 207장

### 완료 조건

- [ ] 하단 탭 4개 이하
- [ ] 튜토리얼 없이 핵심 루프 이해 가능
- [ ] 기능 진입점이 1차 목표와 충돌하지 않음
- [ ] QA 범위가 문서화됨

---

## Phase 7. QA/보안/스토어 준비

### 코드 검증

- [x] `flutter analyze`
- [x] `flutter test`
- [x] `flutter build apk --debug`
- [x] `flutter build appbundle --release`

### Android 실기기 QA

- [ ] 첫 실행
- [ ] 온보딩
- [ ] 퀘스트 생성
- [ ] 퀘스트 완료
- [ ] 오늘의 모험 요약 변화
- [ ] 던전 시작
- [ ] 전투 완료
- [ ] 카드 보상
- [ ] 이벤트
- [ ] 현실 보상 구매
- [ ] 타이머 완료

### Web QA Preview

- [ ] `flutter build web --dart-define=LIFEQUEST_QA_PREVIEW=true --pwa-strategy=none`
- [ ] Firebase Hosting 배포
- [ ] 공개 URL smoke QA
- [ ] localStorage 신규 사용자 상태 확인
- [x] 광고/결제/민감 기능 숨김 확인

### 보안/개인정보

- [ ] Firebase API key 노출 위험 재검토
- [x] Firestore rules 로컬 기준 확인 및 계정 삭제 허용 보완
- [x] Storage rules 로컬 기준 추가 및 프로필 이미지 경로 제한
- [x] Firebase 콘솔/프로젝트에 Firestore/Storage rules 배포 완료
- [x] 계정 삭제 실패 시 성공처럼 화면 이동하지 않도록 방지
- [x] 계정 삭제 성공/실패 반환 계약 단위 테스트 추가
- [ ] Android 인증 빌드에서 계정 삭제가 Auth/Firestore/Storage를 정리하는지 smoke test
- [ ] QA Preview localStorage 데이터 범위 확인
- [x] 개인정보처리방침 최신화
- [ ] Health/AI 관련 문구가 과장되지 않는지 확인
- [x] Android Data safety SDK/데이터 카테고리 인벤토리 작성 (`lifequest-data-safety-inventory-20260519.md`)

### Google Play 준비

- [x] Android vitals 기준 확인
- [x] Android vitals/focus timer wake-lock audit documented (`lifequest-android-vitals-timer-audit-20260520.md`)
- [x] targetSdk/compileSdk 확인
- [x] 앱 권한 최소화
- [x] 실제 Android 앱 기본 빌드에서 AdMob/Billing SDK 초기화와 광고 보상 UI 비활성화
- [x] 첫 유료 번들/구독 구조 문서화 (`lifequest-premium-bundle-plan-20260520.md`)
- [ ] 광고 ID/AdMob production 설정
- [ ] Data safety 작성
- [ ] Play Console에 공개 개인정보처리방침 URL과 Data safety 답변 일치 여부 최종 확인
- [ ] 스토어 스크린샷
- [ ] 짧은 설명/긴 설명
- [ ] 내부 테스트 트랙
- [ ] Closed testing 준비

---

## 문서 산출물 체크리스트

- [x] `docs/lifequest-remake-master-plan-20260515.md`
- [x] `docs/lifequest-feature-cutline-20260516.md`
- [x] `docs/lifequest-core-loop-ux-20260516.md`
- [x] `docs/lifequest-remake-execution-checklist-20260516.md`
- [ ] `docs/lifequest-design-pilot-plan-20260516.md`
- [x] `docs/lifequest-release-monetization-issues-20260519.md`
- [x] `docs/lifequest-premium-bundle-plan-20260520.md`

---

## 작업 진행 기록 규칙

모든 Phase 작업은 `docs/SHARED_WORK_LOG.md`에 아래 형식으로 기록한다.

```text
## YYYY-MM-DD KST - 작업명

### 목적
### 조사
### 변경
### 검증
### 남은 위험
```

---

## 즉시 다음 작업

우선순위:

1. `lifequest-feature-cutline-20260516.md`를 기준으로 사용자에게 유지/숨김/삭제 후보 확인받기
2. `lifequest-core-loop-ux-20260516.md`의 수치 규칙을 코드에 넣을 수 있는 최소 모델 조사
3. `오늘의 모험` 블록을 퀘스트 화면 상단에 파일럿 구현

첫 구현 권장 범위:

```text
코드 변경 최소화:
- 신규 위젯: TodayAdventureSummary
- CharacterState getter 몇 개 추가
- QuestsScreen 상단에 삽입
- 테스트 2~4개 추가
```

이 범위를 넘기면 리메이크가 다시 대형 리팩토링으로 번질 위험이 있다.

## 참고 출처

- Android vitals: https://developer.android.com/topic/performance/vitals
- Google Play target API level requirement: https://developer.android.com/google/play/requirements/target-sdk
- Google Play Billing subscriptions: https://developer.android.com/google/play/billing/subscriptions
- Health Connect data types: https://developer.android.com/health-and-fitness/health-connect/data-types
- RevenueCat State of Subscription Apps 2026: https://www.revenuecat.com/state-of-subscription-apps-2026-shopping/
