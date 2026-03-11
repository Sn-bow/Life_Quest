# Ad-Only Monetization Plan - 2026-03-11

## Goal

사업자 없이도 먼저 운영 가능한 범위에서 Android 앱 수익화를 시작한다.

핵심 방향:

- 초기 수익화는 `AdMob 광고 수익`만 사용
- `광고 제거`, `유료 코스메틱`, `구독`, `프리미엄 기능 판매`는 보류
- 먼저 무료 앱의 유지율과 광고 수익성을 검증

## Current Monetization Inventory

현재 코드 기준 수익화 요소는 아래와 같다.

### 1. 보상형 광고

구현 위치: `lib/services/ad_service.dart`

현재 보상형 광고 트리거:

- `ap_recovery`: AP 회복
- `quest_double`: 퀘스트 보상 2배
- `combat_revive`: 전투 부활

현재 상태:

- 구조는 있음
- 개발용 테스트 광고 ID가 기본값
- 광고 제거 구매와 함께 동작하도록 설계됨
- `stat_detail`은 무료 공개로 전환하는 것이 맞음

### 2. 인앱결제 - 광고 제거

구현 위치: `lib/services/purchase_service.dart`

- 상품 ID: `remove_ads_4900`
- 성격: 비소모성 구매
- 기능: 광고 제거 후 광고 보상 즉시 획득

현재 상태:

- 코드 구현 있음
- Play Console 상품 운영 전제
- 지금 전략에서는 출시 보류 대상

### 3. 인앱결제 - 코스메틱

구현 위치: `lib/models/cosmetic.dart`, `lib/screens/cosmetic_shop_screen.dart`

현재 상품:

- `cosmetic_theme_neon`
- `cosmetic_theme_gold`
- `cosmetic_title_fire`
- `cosmetic_title_sparkle`
- `cosmetic_combat_lightning`

현재 상태:

- 구매 구조 있음
- 실제 운영 상품 등록 전제
- 지금 전략에서는 출시 보류 대상

## Recommended Business-Free Scope

사업자 없이 먼저 운영할 범위:

- 무료 앱 배포
- AdMob 광고 수익
- 보상형 광고 기반 보상 제공

초기 제외 범위:

- 광고 제거 구매
- 코스메틱 유료 판매
- 구독
- 외부 결제 유도
- PayPal 기반 디지털 상품 판매

이유:

- Google Play 정책상 앱 내 디지털 상품 결제는 원칙적으로 Google Play 결제 체계를 따라야 함
- 현재 단계에서는 광고 수익만으로도 운영 검증 가능
- 유료 기능 판매는 사업/세금/상품 설계까지 같이 커지므로 후순위가 맞음

## Strategy

### Phase 1. Ad-Only Release

목표:

- 무료 앱으로 먼저 출시
- 수익화는 보상형 광고만 사용
- 사용자 반감 없이 잔존율을 유지

실행 항목:

- AdMob 실운영 App ID 입력
- 보상형 광고 실운영 Ad Unit ID 입력
- `광고 제거` 메뉴는 숨기거나 `출시 예정` 처리
- `코스메틱 유료 구매` 버튼은 숨기거나 `준비 중` 처리
- 광고가 앱 진행을 막는 방식이 아니라 `선택형 보상`으로만 작동하도록 유지

완료 조건:

- 앱 내 결제 버튼이 실제 결제 흐름으로 가지 않음
- 광고 보상 루프만 정상 동작
- Play 심사 시 결제 관련 설명이 단순해짐

### Phase 2. Retention Validation

목표:

- 광고를 넣었을 때도 앱이 계속 쓰이는지 확인

핵심 지표:

- D1 retention
- D7 retention
- 1인당 일평균 광고 시청 수
- 광고 보상 기능별 사용률
- 로그인 사용자 대비 퀘스트 완료율

우선 관찰 대상 광고:

1. 퀘스트 완료 2배 보상
2. AP 회복
3. 전투 부활

판단 기준:

- `quest_double`, `ap_recovery`가 가장 수익성과 거부감 균형이 좋을 가능성이 높음
- 기본 정보 접근은 무료로 두는 편이 UX에 유리함

### Phase 3. Monetization Tuning

목표:

- 광고가 너무 많아 보이지 않게 정리
- 수익이 나는 광고만 남김

권장 유지:

- 퀘스트 완료 2배
- AP 회복
- 전투 부활

권장 축소 또는 제거 후보:

- 상세 스탯 보기 광고

이유:

- 핵심 성장 루프와 직접 연결된 광고만 남기는 편이 자연스럽다
- 정보 접근 자체를 광고로 잠그면 앱 호감도가 떨어질 수 있다

### Phase 4. Paid Features Later

광고 수익과 유지율이 어느 정도 나온 후 검토:

- 광고 제거
- 프리미엄 리포트
- 프리미엄 위젯 스킨
- 월간 성장 분석
- 코스메틱 번들

이 단계는 사업자/정산 구조를 같이 검토할 시점에 여는 것이 맞다.

## Product Recommendations

### Keep Now

- 보상형 광고
- 무료 코어 루프
- 무료 장비/성장/업적 시스템

### Hide or Disable for Initial Android Release

- `광고 제거` 구매 진입
- 코스메틱 구매 진입
- `구매 복원`

권장 처리 방식:

- 메뉴 숨김
- 또는 `출시 예정` 배지 표시 후 클릭 비활성화

## UX Rules for Ad-Only Model

초기 광고 운영 원칙:

- 전면 광고보다 보상형 광고 우선
- 퀘스트 등록/기본 진행/기본 성장에는 광고 강제 금지
- 광고는 `더 빨리`, `더 많이`, `추가 보상`에만 연결
- 하루 제한을 둬 과한 시청 루프를 막음

현재 구조는 이 원칙과 대체로 맞다.

## Recommended App-Side Changes

우선순위 높은 변경:

1. 설정 화면의 `광고 제거 (프리미엄) 구매` 숨김
2. 설정 화면의 `구매 복원` 숨김
3. 코스메틱 샵 구매 버튼 비활성화 또는 `준비 중` 처리
4. 상세 스탯 광고는 무료 공개
5. 광고 보상 기능별 사용 로그 남기기

## Risks

### Risk 1. 수익은 나지만 사용자 피로가 클 수 있음

대응:

- 강제 광고 금지
- 핵심 루프는 무료 유지

### Risk 2. 광고 수익이 매우 낮을 수 있음

대응:

- 리텐션 먼저 확보
- 광고 위치를 적게 두되 전환 높은 지점만 남김

### Risk 3. 아직 유료 기능이 코드에 남아 있어 앱 메시지가 혼란스러움

대응:

- 초기 출시에서는 광고 전용 앱처럼 정리

## Decision

현재 프로젝트의 가장 현실적인 수익화 계획은 아래와 같다.

1. Android 무료 출시
2. 수익화는 AdMob 보상형 광고만 운영
3. 광고 제거/IAP 코스메틱은 UI와 운영에서 보류
4. 사용자 유지율과 광고 수익을 먼저 검증
5. 수익이 의미 있게 나오면 그때 유료 기능 확장 검토

## Sources

- Google Play Payments policy:
  https://support.google.com/googleplay/android-developer/answer/9858738
- Developer Program Policy:
  https://support.google.com/googleplay/android-developer/answer/16313518
- Alternative billing in South Korea and eligible regions:
  https://developer.android.com/google/play/billing/alternative
- AdMob individual identity verification:
  https://support.google.com/admob/answer/13030080
- AdMob tax information:
  https://support.google.com/admob/answer/14135099
