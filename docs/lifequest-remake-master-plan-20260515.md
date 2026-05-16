# Life Quest Remake Master Plan - 2026-05-15

## 목적

Life Quest를 현재 작업물에 끌려가지 않고 다시 기획한다. 목표는 피드백 중 실현 가능성과 수익 가능성이 있는 부분만 받아 앱을 재구축하고, 바로 출시 가능한 크기까지 줄이며, 디자인과 게임 기능을 비판적으로 재판단하는 것이다.

이 문서는 자료를 따로 수집해 쌓는 문서가 아니다. 최신 자료를 확인한 즉시 제품 이슈로 변환해 기록한다.

## 현재 결론

현재 앱은 기능이 적어서 약한 것이 아니라, 기능들이 하나의 이유로 묶이지 않아 약하다.

가져갈 핵심:
- 현실 퀘스트
- 성장/스탯
- 소울 덱 던전
- 칭호
- 현실 보상
- 집중 타이머

그대로 가져가면 안 되는 것:
- 기능 탭이 병렬로 흩어진 구조
- 현실 퀘스트와 던전이 약하게 연결된 구조
- 칭호가 장식처럼 보이는 구조
- 카드/던전이 별도 미니게임처럼 보이는 구조
- AI 디자인 결과물을 그대로 믿고 붙이는 방식

리메이크 기준:

```text
현실 행동
-> 성장 수치와 성향 변화
-> 오늘의 던전 보정
-> 카드/이벤트/칭호 해금
-> 현실 행동으로 다시 돌아가는 동기
```

이 연결을 강화하지 못하는 기능은 출시 버전에서 숨기거나 제거한다.

---

## 조사 기반 이슈 기록

### LQ-RM-001. 앱의 첫 30초 목적 이해가 약하다

근거:
- Threads 피드백에서 "게임 목적의식이 없다", "아키텍처가 명확해야 한다"는 지적이 나왔다.
- Habit/health 앱 시장은 기능만으로 차별화하기 어렵고, 기본 habit tracking은 OS/경쟁 앱에 의해 빠르게 상품화되고 있다.
- Habitica, Finch, Duolingo 계열은 모두 첫 사용자가 즉시 이해할 수 있는 한 문장 루프를 가진다.

판정:
- 심각도: P0
- 실현 가능성: 높음
- 수익 가능성: 높음
- 이유: 온보딩/첫 화면/오늘 요약은 서버나 외부 API 없이도 만들 수 있고, 유지율에 직접 영향을 준다.

결정:
- 출시 버전의 첫 화면은 기능 목록이 아니라 `오늘의 모험`이어야 한다.

필수 산출물:
- 오늘 완료할 퀘스트
- 완료 시 얻는 XP/골드/스탯
- 오늘 던전에서 받을 보정
- 다음 칭호/이벤트까지 남은 조건
- 추천 행동 1개

---

### LQ-RM-002. 게임 기능은 유지하되 역할을 바꿔야 한다

근거:
- 현재 소울 덱은 차별점이지만, 현실 행동의 결과로 보이지 않으면 별도 미니게임이다.
- Habitica는 현실 할 일이 RPG 자원과 직접 연결된다.
- Duolingo식 퀘스트/스테이크/리그 구조는 행동을 반복하게 만들지만, 목적과 보상이 명확할 때만 작동한다.

판정:
- 심각도: P0
- 실현 가능성: 중간
- 수익 가능성: 중간~높음
- 이유: 게임은 차별점이지만 복잡도가 높다. 단, 현실 행동과 연결되면 프리미엄 동기와 장기 유지의 근거가 된다.

결정:
- 소울 덱/던전은 유지한다.
- 하지만 `게임 모드`가 아니라 `현실 행동의 성장 체감 장치`로 재설계한다.

가져갈 것:
- 카드 전투
- 카드 보상
- 던전 맵
- 이벤트
- 상점/휴식/보스 구조

줄일 것:
- 초반부터 많은 카드/유물/상점 기능 노출
- 현실 퀘스트와 무관한 랜덤 보상
- 의미 없는 캐릭터/아바타 복귀

새 규칙:
- 건강 퀘스트 -> 전투 HP/방어/회복 보정
- 지혜 퀘스트 -> 카드 드로우/마법/선택지 보정
- 힘 퀘스트 -> 공격 피해/시작 EP 보정
- 매력 퀘스트 -> 이벤트 선택지/상점 할인 보정
- 루틴 연속 달성 -> 칭호/전용 이벤트 해금

---

### LQ-RM-003. 현실 데이터 자동 연동은 강력하지만 출시 1차 범위가 아니다

근거:
- Android Health Connect는 Android 9(API 28)+에서 건강/피트니스 데이터를 읽고 쓸 수 있고, 데이터 타입/권한별 설계가 필요하다.
- 2026년 Health Connect Jetpack 릴리스 문서는 읽기/쓰기 권한 선언과 Health apps declaration form 필요성을 명시한다.
- 자동 건강 데이터 연동은 가치가 크지만 권한, 개인정보, 테스트, 정책 검토 비용이 커진다.

판정:
- 심각도: P1
- 실현 가능성: 중간
- 수익 가능성: 중간
- 출시 1차 포함 여부: 제외

결정:
- 1차 리메이크에서는 Health Connect/인바디/AR 자동 연동을 하지 않는다.
- 대신 수동 퀘스트 카테고리와 간단한 체크인으로 현실 행동을 변환한다.

장기 후보:
- Health Connect 걸음 수/운동/수면
- 영양/칼로리 수동 기록 또는 외부 앱 연동
- 글 발행/업로드/작업 로그 수동 입력
- GitHub/Notion/블로그 활동 연동

차단 조건:
- 개인정보 처리방침 정비 전까지 민감 건강 데이터 연동 금지
- 사용자가 왜 권한을 줘야 하는지 앱 내 가치가 명확해지기 전까지 금지

---

### LQ-RM-004. AI 기능을 수익화 전면에 내세우면 위험하다

근거:
- RevenueCat 2026 자료는 AI 앱이 초기 매출은 강할 수 있지만 장기 retention은 비AI 앱보다 낮은 경향을 보인다고 보고한다.
- AI 기능은 환불/기대 불일치 리스크가 크다.
- Life Quest의 핵심 가치는 AI 채팅이 아니라 현실 행동을 게임 성장으로 바꾸는 구조다.

판정:
- 심각도: P1
- 실현 가능성: 높음
- 수익 가능성: 조건부

결정:
- AI를 전면 상품명으로 팔지 않는다.
- AI는 `추천`, `요약`, `퀘스트 분류`, `칭호/이벤트 생성 보조`로 뒤에 숨긴다.
- 무료/초기 버전에서는 AI 의존도를 낮춘다.

수익 후보:
- 광고 제거
- 고급 통계/회고
- 시즌 패스형 코스메틱
- 고급 던전/칭호/테마
- 장기적으로 AI 개인 코치

금지:
- "AI가 인생을 관리해준다" 식 과장
- 검증 안 된 건강/영양 조언 자동 제공
- 민감 데이터 기반 조언을 정책 없이 출시

---

### LQ-RM-005. 구독 수익은 가능하지만 초반 정답이 아니다

근거:
- Google Play Billing은 구독 lifecycle, grace period, account hold, backend entitlement 등 운영 복잡도가 있다.
- RevenueCat 2026 자료는 연간 구독이 주간/월간보다 장기 retention이 높지만, 앱이 실제 반복 가치를 증명해야 한다고 해석된다.
- Life Quest는 아직 반복 가치와 핵심 루프 검증 전이다.

판정:
- 심각도: P2
- 실현 가능성: 중간
- 수익 가능성: 장기적으로 있음

결정:
- 출시 1차는 구독보다 무료 + 광고 제거/후원/일회성 테마가 현실적이다.
- 구독은 리텐션 데이터가 나온 뒤 도입한다.

1차 수익 실험:
- 광고 제거 일회성 결제
- 시즌 테마/카드 스킨
- 후원형 프리미엄 배지

구독 도입 조건:
- D7/D30 retention 확인
- 사용자가 매주 돌아오는 이유 확인
- 프리미엄 기능이 명확함
- Play Billing backend/entitlement 운영 가능

---

### LQ-RM-006. 디자인은 현재 스타일을 고집하지 않는다

근거:
- 테스터 피드백은 기능보다 목적/구조를 먼저 지적했다.
- 디자인 문제는 툴 부족이 아니라 기준 부재에 가깝다.
- Figma/Canva/Hyperframes는 산출물 역할이 다르며, 도구를 쓴다고 품질이 보장되지 않는다.

판정:
- 심각도: P0
- 실현 가능성: 높음
- 수익 가능성: 간접적으로 높음

결정:
- 전체 리디자인을 바로 시작하지 않는다.
- 먼저 `전투 화면 1개` 또는 `오늘의 모험 화면 1개`를 기준작으로 만든다.
- 기준작이 현재보다 확실히 낫지 않으면 폐기한다.

디자인 방향 후보:
1. Dark RPG productivity
   - 현재 방향과 가장 가깝다.
   - 장점: 기존 던전/카드와 연결 쉽다.
   - 위험: 무거워 보이고 할 일 앱 접근성이 낮아질 수 있다.
2. Cozy fantasy productivity
   - Finch류의 부담 없는 감성.
   - 장점: 일상 관리와 잘 맞는다.
   - 위험: 소울 덱 전투와 충돌할 수 있다.
3. Tactical notebook RPG
   - 노트/계획표 + 던전 지도 감성.
   - 장점: 현실 행동과 전략 게임 연결이 자연스럽다.
   - 위험: 강한 아트 디렉션이 필요하다.

현재 판정:
- 3번 `Tactical notebook RPG`를 우선 검토한다.
- 이유: 현실 행동 기록, 계획, 던전 전략을 한 화면 언어로 묶을 가능성이 가장 높다.

---

### LQ-RM-007. AI 디자인 도구는 보조 도구일 뿐, 최종 판단자가 아니다

조사 대상:
- Figma MCP / Figma Code Connect / design token workflow
- Google Stitch류 AI UI 생성 도구
- Penpot, Inkscape, GIMP, Blender, Excalidraw
- ComfyUI, Fooocus류 오픈소스 이미지 생성 UI
- Figma2Code, UI-Bench 등 design-to-code 연구 흐름

판정:
- 심각도: P1
- 실현 가능성: 중간
- 수익 가능성: 간접

현실 판단:
- AI UI 생성은 빠른 시안 탐색에는 의미가 있다.
- 하지만 모바일 게임+생산성 혼합 앱의 최종 품질을 보장하지 않는다.
- AI 티가 나지 않으려면 프롬프트보다 art direction, 반복 검수, 실제 기기 QA가 더 중요하다.

쓸 수 있는 부분:
- 무드보드
- 색상/타이포/간격 토큰 초안
- 카드/패널 UI variation
- 화면별 빠른 대안 비교
- 이미지 생성용 구도/스타일 프롬프트 정리

믿으면 안 되는 부분:
- 전체 앱 IA 자동 생성
- 게임 UI 최종 아트
- Flutter 구현 1:1 변환
- "AI가 만든 멋진 화면"을 실제 출시 품질로 착각

판단:
- Figma + 이미지 생성 조합은 파일럿 1개 화면까지만 쓴다.
- 성공 기준을 통과하면 확장한다.
- 실패하면 현재 Flutter 기반에서 직접 디자인 시스템을 재구축한다.

---

### LQ-RM-008. 출시 가능 사이즈를 다시 줄여야 한다

근거:
- 현재 앱은 이미 기능이 많고, 재기획 없이 추가하면 유지보수와 QA 범위가 폭발한다.
- Play 출시를 목표로 하면 모든 기능을 다 보여주는 것보다 핵심 루프가 덜 깨지는 것이 중요하다.

판정:
- 심각도: P0
- 실현 가능성: 높음
- 수익 가능성: 높음

출시 1차에 남길 기능:
- 오늘의 모험 홈
- 퀘스트 생성/완료
- 스탯/성향 변화
- 던전 1챕터
- 카드 보상
- 칭호 10~20개
- 현실 보상
- 집중 타이머
- 기본 통계/회고

출시 1차에서 숨기거나 축소:
- 과도한 상점/유물/카드 컬렉션 전면 노출
- 복잡한 월간/연간 레이드
- AI 코치 전면 기능
- 외부 건강 데이터 연동
- 다국어 확장 고도화
- 실험적 카드 아트 대량 생성

---

## 리메이크 아키텍처

### 핵심 화면 구조

```text
오늘
- 오늘의 모험 요약
- 오늘 할 퀘스트
- 완료 시 성장 미리보기
- 던전 보정 미리보기

성장
- 나의 성장 프로필
- 스탯/성향
- 칭호
- 최근 행동 기록

모험
- 소울 덱
- 던전 맵
- 전투/이벤트/보상

보상
- 현실 보상
- 골드 사용
- 업적/컬렉션
```

### 핵심 데이터 흐름

```text
QuestCategory
-> GrowthDelta
-> DailyModifier
-> DungeonModifier
-> TitleProgress
-> EventUnlock
```

### 예시 변환

```text
운동 30분 완료
-> 건강 +0.4, 힘 +0.2, 골드 +15
-> 오늘 던전 전투 HP +5
-> 방어 카드 보상 확률 +5%
-> "꾸준한 전사" 칭호 진행 +1
```

---

## 실행 계획

### Phase 0. 냉정한 기능 분류

목표:
- 현재 기능을 `유지`, `재배치`, `숨김`, `삭제 후보`로 분류한다.

산출물:
- `docs/lifequest-feature-cutline-20260515.md`

판단 기준:
- 현실 행동과 연결되는가
- 첫 3분 안에 이해되는가
- 출시 QA 범위 안에 들어오는가
- 수익 또는 유지율에 기여하는가

### Phase 1. Core Loop UX 설계

목표:
- "오늘의 모험" 화면과 성장 변환 규칙을 문서로 확정한다.

산출물:
- `docs/lifequest-core-loop-ux-20260515.md`

필수 결정:
- 퀘스트 카테고리 -> 스탯 변환표
- 스탯 -> 던전 보정표
- 칭호 -> 이벤트 해금표
- 첫 화면 정보 위계

### Phase 2. 작은 구현 파일럿

목표:
- 전체 리메이크 전에 오늘의 모험 블록 하나를 실제 앱에 넣는다.

범위:
- 퀘스트 홈 상단 또는 별도 홈
- 오늘 완료/남은 퀘스트
- 예상 성장/던전 보정
- 다음 칭호까지 남은 조건

성공 기준:
- 첫 사용자도 앱 목적을 설명 없이 이해한다.
- 기존 기능으로 이동이 쉬워진다.
- 정보가 과밀하지 않다.

### Phase 3. 소울 덱 연결 재설계

목표:
- 퀘스트 결과가 던전에 직접 반영되게 한다.

범위:
- DailyModifier 모델 추가
- 던전 시작 시 오늘의 보정 적용
- 전투/이벤트/보상 화면에 "왜 이 보정이 생겼는지" 표시

### Phase 4. 디자인 기준작 파일럿

목표:
- Figma/이미지 생성/Flutter 중 하나를 맹신하지 않고, 한 화면 기준작으로 검증한다.

후보 화면:
1. 오늘의 모험 홈
2. 전투 화면

성공 기준:
- 현재보다 목적이 선명하다.
- AI 티가 나지 않는다.
- 실제 폰 크기에서 텍스트가 읽힌다.
- 구현 난이도가 과하지 않다.

### Phase 5. 출시 후보 빌드

목표:
- 출시 가능한 크기로 기능을 잠그고 QA한다.

필수 게이트:
- Android 실기기 QA
- `flutter analyze`
- `flutter test`
- release AAB build
- 개인정보/권한/광고/결제 정책 점검
- 10명 이상 외부 피드백

---

## 버릴 것 / 보류할 것 / 가져갈 것

### 버릴 것

- 별도 플레이어 캐릭터/아바타 중심 구조
- 의미 없는 장식성 스탯
- 현실 행동과 연결되지 않는 랜덤 게임 보상
- AI 디자인 결과물 무비판 적용
- 출시 전 과도한 외부 데이터 연동

### 보류할 것

- Health Connect
- 인바디/AR 연동
- AI 개인 코치
- 전체 카드별 아트 207장 생성
- 구독 결제
- Figma 기반 전체 리디자인

### 가져갈 것

- 퀘스트
- 성장/스탯
- 던전/소울 덱
- 카드 보상
- 칭호
- 현실 보상
- 집중 타이머
- Web QA Preview 피드백 채널

---

## 참고 출처

- Android Developers, Health Connect overview: https://developer.android.com/health-and-fitness/health-connect
- Android Developers, Health Connect data types: https://developer.android.com/health-and-fitness/health-connect/data-types
- Android Developers, Health Connect Jetpack releases: https://developer.android.com/jetpack/androidx/releases/health-connect
- Android Developers, Google Play Billing subscription lifecycle: https://developer.android.com/google/play/billing/lifecycle/subscriptions
- RevenueCat, State of Subscription Apps 2026: https://www.revenuecat.com/state-of-subscription-apps-2026-shopping/
- RevenueCat, 2026 trends summary: https://www.revenuecat.com/blog/growth/subscription-app-trends-benchmarks-2026/
- Finch help, self-care approach: https://help.finchcare.com/hc/en-us/articles/37935669335309-Our-Approach-to-Self-Care
- Finch help, new user guide: https://help.finchcare.com/hc/en-us/articles/42149821015693-New-User-Guide
- Duolingo blog, leagues and leaderboards: https://blog.duolingo.com/duolingo-leagues-leaderboards/
- Figma2Code paper, 2026: https://arxiv.org/abs/2604.13648
- UI-Bench paper, 2025: https://arxiv.org/abs/2508.20410
- Penpot/open-source design tool comparison: https://ossalt.com/blog/best-open-source-design-tools-2026
- ComfyUI reference: https://en.wikipedia.org/wiki/ComfyUI
