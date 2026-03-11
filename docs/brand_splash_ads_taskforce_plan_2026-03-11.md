# Brand, Splash, and Ad Monetization Taskforce Plan - 2026-03-11

## Mission

이 계획은 아래 3개 축을 하나의 실행 묶음으로 다룬다.

1. 앱 아이콘을 앱 성격에 맞는 수준으로 재설계
2. 앱 시작 화면을 트렌드에 맞는 인상적인 경험으로 재구성
3. 수익화 초점을 `광고 수익 전용`으로 재정렬

목표는 단순한 시각 교체가 아니라, `앱의 첫인상`, `앱의 상품성`, `초기 수익화 구조`를 함께 정리하는 것이다.

## Product Direction

현재 앱의 핵심 포지션:

- 일상 행동을 퀘스트로 바꾸는 생산성 RPG
- 캐릭터 성장, 퀘스트, 전투, 보상, 스킬, 업적 구조를 갖춘 자기관리 게임

이 방향에 맞는 시각 원칙:

- 아이콘은 `생산성 + RPG`가 동시에 읽혀야 함
- 시작 화면은 `게임성`, `성장감`, `세련된 인상`을 함께 줘야 함
- 광고 수익화는 `진행 가속형 보상` 중심으로 배치해야 함

## Current State Summary

### Branding state

- 아이콘과 스플래시 자산은 존재하지만, 앱 내부 화면과의 일관성이 약함
- 로그인 화면은 기존 브랜드 자산보다 일반 아이콘 느낌이 강했음
- 로딩 화면은 단순 스피너 중심이라 첫인상이 약했음

### Startup experience state

- 앱 시작 직후 시선 고정 포인트가 부족함
- 앱의 핵심 메시지인 `일상 -> 퀘스트 -> 성장`이 시작 화면에서 충분히 전달되지 않음

### Monetization state

현재 수익화 요소:

- 보상형 광고 4종
- 광고 제거 구매 1종
- 코스메틱 인앱상품 5종

현재 판단:

- 초기 운영은 광고 수익 전용이 가장 현실적
- 인앱결제는 구조는 유지하되 운영/노출은 보류하는 것이 맞음

## Operating Rule

이번 작업의 공통 규칙:

- 브랜딩 개선은 `앱 실행 첫 10초`에 집중한다
- 광고 수익화는 `강제 광고`가 아니라 `보상형 광고` 중심으로 유지한다
- 앱 상품성을 해치는 결제 UI는 초기 릴리스에서 숨긴다
- 아이콘과 시작 화면은 `에뮬레이터 실기동 확인` 없이는 완료로 보지 않는다

## Agent Roster

### Agent 1. Brand Identity Lead

Mission:

- 앱 아이콘과 브랜드 핵심 시각 언어를 설계한다

Owns:

- 앱 아이콘 콘셉트
- 컬러 방향
- 엠블럼 구조
- 아이콘 안전 영역
- 런처 아이콘 리소스 반영

Definition of done:

- 아이콘이 Android 런처 기준으로 답답하지 않음
- 배경 처리와 중심 오브젝트가 명확함
- 작은 사이즈에서도 의미가 유지됨
- 네이티브 런처 아이콘 생성까지 완료됨
- 에뮬레이터 런처 화면에서 직접 시각 검증 완료

### Agent 2. First Impression Lead

Mission:

- 시작 화면과 로딩/로그인 첫인상을 재설계한다

Owns:

- 스플래시 로고
- 시작 메시지
- 로딩 화면 비주얼
- 로그인 첫 화면 브랜딩 일관성
- 앱 진입 감정선

Definition of done:

- 시작 화면이 현재 아이콘과 같은 시각 언어를 공유함
- 로딩 화면이 임시 화면처럼 보이지 않음
- 로그인 진입 시 브랜드 인상이 이어짐
- 에뮬레이터에서 앱 실행부터 로그인 진입까지 직접 확인 완료

### Agent 3. Ad Monetization Architect

Mission:

- 유료화 구조를 광고 수익 중심으로 재정렬한다

Owns:

- 보상형 광고 유지/정리 기준
- 광고 제거/IAP 보류 기준
- 광고가 핵심 루프를 망치지 않도록 재배치
- 광고 진입 UX 원칙

Definition of done:

- 초기 릴리스에서 수익화 메시지가 단순해짐
- 광고 전용 운영 모델이 문서화됨
- 결제 기능은 보류 또는 비노출 정책으로 정리됨

### Agent 4. UX Loop Reviewer

Mission:

- 브랜딩과 광고가 실제 사용자 경험을 해치지 않는지 점검한다

Owns:

- 첫 실행 인상
- 광고 보상 포인트 자연스러움
- 로그인 진입 심리적 부담
- 과한 기능 노출 여부

Definition of done:

- 시작 경험과 광고 흐름이 충돌하지 않음
- 앱이 싸보이거나 조급하게 수익화하는 인상을 주지 않음

### Agent 5. Implementation Lead

Mission:

- 실제 코드/리소스 반영을 수행한다

Owns:

- 자산 생성 스크립트
- PNG 자산 반영
- launcher/splash 재생성
- 앱 화면 코드 적용
- 검증 빌드

Definition of done:

- 분석 통과
- 리소스 생성 성공
- Android debug 빌드 검증

### Agent 6. Documentation Controller

Mission:

- 결정사항과 보류사항을 문서로 고정한다

Owns:

- 광고 전용 수익화 계획 문서
- 현재 유료 기능 인벤토리
- 다음 단계 체크리스트

Definition of done:

- 다음 세션에서 재설계 의도를 다시 해석할 필요가 없음

## Workstream Map

### Stream A. Icon System

Owner:

- Agent 1
- Agent 5

Checklist:

- [ ] 앱 핵심 성격에 맞는 아이콘 모티프 정의
- [ ] 작은 해상도에서도 읽히는 중심 심볼 결정
- [ ] 앱 아이콘용 배경/포그라운드 대비 설계
- [ ] 1024x1024 마스터 자산 생성
- [ ] Android launcher icon 재생성
- [ ] 결과 시각 검증
- [ ] 에뮬레이터 홈 화면에서 런처 아이콘 직접 확인

Completion gate:

- 앱 아이콘이 런처에서 안정적이고 이질감 없이 보임

### Stream B. Startup Experience

Owner:

- Agent 2
- Agent 5

Checklist:

- [ ] 스플래시 로고 재설계
- [ ] 밝은 모드/어두운 모드 대응
- [ ] 로딩 화면 브랜드화
- [ ] 로그인 화면 상단 비주얼 교체
- [ ] 시작 메시지 문구 정리
- [ ] native splash 재생성
- [ ] 에뮬레이터에서 스플래시 전환 직접 확인
- [ ] 에뮬레이터에서 로그인 진입 화면 직접 확인

Completion gate:

- 앱 실행부터 로그인 진입까지 동일한 제품 인상을 유지함

### Stream C. Ad-Only Monetization

Owner:

- Agent 3
- Agent 4
- Agent 6

Checklist:

- [ ] 현재 수익화 요소 전체 인벤토리 정리
- [ ] 사업자 없이 가능한 범위와 보류 범위 구분
- [ ] 광고 전용 운영 원칙 수립
- [ ] 유지할 보상형 광고와 축소할 광고 구분
- [ ] 광고 제거 구매 UI 처리 정책 결정
- [ ] 코스메틱 결제 UI 처리 정책 결정
- [ ] 광고 수익 검증 지표 정의

Completion gate:

- 앱이 광고 수익 중심으로 설명 가능한 상태가 됨

## Dependency Order

1. Agent 1 and Agent 2 define the visual system
2. Agent 5 reflects the asset and UI changes
3. Agent 3 restructures monetization messaging and priorities
4. Agent 4 reviews UX impact
5. Agent 6 locks final decisions into docs

## Implementation Phases

## Phase A. Planning Lock

Owner:

- Agent 6

Tasks:

- 현재 브랜딩 상태 정리
- 현재 수익화 상태 정리
- 광고 전용 방향 확정

Exit criteria:

- 계획 문서 확정

## Phase B. Visual Rebuild

Owner:

- Agent 1
- Agent 2
- Agent 5

Tasks:

- 아이콘 자산 재생성
- 스플래시 로고 재생성
- 로딩/로그인 화면 반영
- native launcher/splash 재생성

Exit criteria:

- 새 브랜드 자산이 앱 실행 흐름에 반영됨

## Phase C. Monetization Reframe

Owner:

- Agent 3
- Agent 4
- Agent 6

Tasks:

- 광고 전용 수익화 정책 문서화
- 결제 UI 노출 전략 정리
- 사용자 반감이 큰 광고 포인트 식별

Exit criteria:

- 수익화 방향이 광고 전용 모델로 정렬됨

## Phase D. Verification

Owner:

- Agent 5

Tasks:

- `flutter analyze`
- Android debug build
- 시작 화면/로그인 비주얼 확인
- 광고 구조 변경 영향 점검
- 에뮬레이터 런처 아이콘 직접 확인
- 에뮬레이터 앱 시작 화면 직접 확인

Exit criteria:

- 구현이 깨지지 않고 현재 Android 흐름에 반영되며, 런처 아이콘과 시작 화면이 에뮬레이터에서 직접 검증됨

## Deliverables

이번 작업의 최종 산출물:

- 새 앱 아이콘 자산
- 새 스플래시/로그인/로딩 시각 구조
- 광고 전용 수익화 계획 문서
- 현재 유료 기능 인벤토리 정리
- 다음 단계 구현 체크리스트

## Immediate Execution Checklist

지금 바로 진행할 작업:

1. 아이콘 자산 품질 보정 및 검증
2. 스플래시/로그인/로딩 화면 시각 통일
3. 광고 전용 수익화 구조 문서 고정
4. 유료 기능 노출 정책 정리
5. Android 기준 검증
