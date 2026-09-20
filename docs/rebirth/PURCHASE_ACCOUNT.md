# 선택적 구매 계정 · 2026-09-17

현재 Cloud/Monetization/Ads는 모두 기본 off다. 아래 구현은 로컬 검증 단계이며 실제 Firebase/Play 로그인·결제 성공을 뜻하지 않는다.

## 기기 기록과 구매 계정의 경계

- 설정 및 장식 상점에서만 연결 화면을 제공한다. Android에서 Cloud와 Monetization을 모두 명시적으로 켠 빌드에 한한다. 비활성 빌드는 Auth gateway를 만들지 않는다.
- 연결 전에 `SessionState.purchaseOnlyAuth`를 먼저 영속화한다. Google 인증 후 앱이 종료되어도 SessionGate가 legacy cloud-profile loader로 전환하거나 기기 기록을 업로드하지 않는다. 연결 해제 후에도 이 목적 표지는 유지한다.
- Firebase Authentication은 Google ID·기본 프로필을 인증에 사용한다. 새 Firestore 루트에는 서버가 `accountKind: purchaseOnly`, `createdAt`만 기록한다. 퀘스트, 이름, 이메일, 개인화 통계를 callable에 보내지 않는다. 기존 legacy 계정 문서는 덮어쓰지 않는다.
- App Check가 강제된 `ensurePurchaseAccount`가 삭제 요청/삭제 중 상태를 검사한다. 신규 구매 전용 문서는 클라이언트가 생성·수정할 수 없으므로 실수로 root profile을 업로드하는 것도 차단한다. 구매 권한·사용자 검토 신고는 별도 경로다.
- 서버 준비 응답과 현재 Auth UID가 모두 일치한 뒤에만 기기에 ready UID를 저장하고 PurchaseService에 연결한다. 오프라인 재시작은 이전에 확인된 동일 UID만 사용한다. 지갑/목표 데이터를 넘기는 API가 없다.
- 계정이 바뀌면 PurchaseService가 이전 권한을 먼저 비우고 새 계정의 캐시를 읽는다. 최초 복원에서는 캐시를 확인한 뒤 장착 테마를 검증해, 이미 소유한 테마가 재시작 때 해제되지 않게 한다. 기기에서 직접 획득한 장식은 보존한다. Google Play 계정과 앱의 구매 계정은 별개이며, 복원할 때 두 계정이 모두 구매 당시와 같아야 한다.

## 연결 해제와 삭제

- 연결 해제는 ready UID를 먼저 지우고 Firebase/Google 로그아웃을 수행한다. 로그아웃이 실패해도 재시작 시 자동 구매 세션을 만들지 않는다. 단순 연결 해제는 서버 데이터 삭제나 환불이 아니다.
- 계정 삭제는 Google 재인증 후 기존 서버 삭제 job을 요청한다. 요청 전에 로컬 ready UID를 없애므로 삭제 접수 후 로컬 정리가 실패해도 캐시가 권한을 복원하지 않는다.
- 서버가 요청을 접수하면 성공 사실을 유지하고, 기기 로그아웃 실패는 별도 안내와 재시도 버튼으로 처리한다. 서버의 Storage → Firestore 하위 기록/신고/권한 → 구매 토큰 연결 → Auth 삭제는 앱 종료와 무관하게 계속된다.
- 구매 전용 화면에서 삭제해도 **기기의 퀘스트·성장·AI 개인화 기록은 유지**한다. 기존 클라우드 계정으로 연결한 경우 해당 서버 기록도 함께 삭제되며, 구매 복원이 불가능해지고 자동 환불되지 않음을 확인 창에서 설명한다.

## 검증

- Flutter 전체283개 통과, 추가한 계정/화면15개와 권한 캐시 복원2개 포함. 320px/200%/4언어의 계정 안내와 삭제 확인 창을 검사했다.
- 서버19개 및 Firestore/Storage emulator9개 통과. 최소 필드 생성, 기존 프로필 보존, 익명/다른 제공자 거부, 삭제 중 재생성 거부, 구매 전용 프로필 쓰기 차단 포함.
- Firebase 프로젝트 삭제 상태이므로 실제 Google UI/계정 전환/App Check/상품 구매/복원/환불/서버 삭제는 아직 검증하지 못했다. Play 라이선스 테스트와 실기기 검증 전 출시 스위치를 켜지 않는다.

근거: [Firebase Google 인증](https://firebase.google.com/docs/auth/flutter/federated-auth), [Callable 인증 및 App Check](https://firebase.google.com/docs/functions/callable), [Firestore 트랜잭션](https://firebase.google.com/docs/firestore/manage-data/transactions).
