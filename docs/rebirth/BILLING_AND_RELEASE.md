# 구매 권한과 출시 스위치

2026-09-14. 구현 기반 검증 기록이며 실제 상품 판매/배포 완료 기록이 아니다.

## 현재 동작

- 기본 앱은 가입 없이 기기에 저장된다. `LIFEQUEST_CLOUD_ENABLED=false`가 기본값이다. 삭제된 Firebase 프로젝트 복원 또는 신규 프로젝트 결정 이후 올바른 Android 앱 등록과 규칙 검증을 거쳐 켠다.
- `LIFEQUEST_MONETIZATION_ENABLED=false`가 기본값이다. Google Play 라이선스 테스터의 구매/취소/보류/복원/환불 테스트 전 활성화하지 않는다.
- 광고는 별도의 `LIFEQUEST_ADS_ENABLED=false`다. 결제를 활성화해도 광고는 켜지지 않는다. 리포트 열람은 광고 없이 가능하다.
- 자동 Crashlytics/Analytics 수집은 Android manifest에서 꺼져 있다. 모델 입력/개인화 이력은 로그에 기록하지 않는다.

## Google Play Billing 8 구현

`in_app_purchase 3.3.0`, Android 구현 0.5.3. applicationUserName으로 SHA-256(uid)를 전달해 Play의 obfuscated account ID에 묶는다. 원문 UID를 Play에 보내지 않는다.

1. Flutter는 구매 토큰을 인증된 Callable에 전달한다. 패키지/상품은 고정 allowlist를 쓴다.
2. 서버는 Google Play Developer API로 실제 결제 상태, 계정 해시, 미소비/수량 1을 확인한다.
3. Firestore transaction이 구매 토큰 해시를 해당 계정에 결속하고 `users/{uid}/entitlements/{productId}`에 권한을 저장한다. 계정이 삭제 중이거나 없으면 거부한다.
4. 그 다음에 서버가 acknowledge한다. 실패한 영수증은 클라이언트에서 acknowledge하지 않는다. debug 예외도 없다.
5. 화면이 닫혀 있어도 전역 스트림에서 구매 결과를 처리한다. 계정 전환 중 도착한 응답은 새 계정에 지급되지 않는다. 구매 권한은 게임에서 획득한 장식과 분리한다.
6. RTDN 주제 `lifequest-play-billing-events`에서 환불/취소를 재조회해 권한을 해제한다. 옛 토큰의 환불은 새로운 대체 구매를 취소하지 않는다. 서버에서 확인된 권한을 계정별로 캐시해 오프라인 이용을 지원한다.

스토리 상품 ID는 검증 allowlist에만 있다. 판매 가능한 실제 챕터를 완성하기 전 스토어 상품 조회 목록에 넣지 않는다. 현재 실제 Play 상품 설정/구매/환불 테스트는 하지 않았다.

## 배포 전에 필요한 실제 설정

- Firebase 프로젝트 복원/선택, com.lifequest.app 등록, 앱 서명 SHA, Auth와 App Check/Play Integrity.
- 함수 실행 서비스 계정에 필요한 Google Play 구매 확인/관리 권한. 다운로드한 서비스 계정 JSON 키는 사용하지 않는다.
- Cloud Functions 배포에 필요한 결제 플랜 및 비용 검토. **무료 온디바이스 모델과 별개로**, 결제 검증 서버/스토리지에는 플랫폼 요금이 생길 수 있다. 결제 계정을 임의로 연결하지 않았다.
- RTDN Pub/Sub 송신자 설정, 실제 샌드박스 환불과 복원 검증, 스토어 소유 계정과 앱 계정이 다른 경우 UX 확인.
- 실제 Firebase에서 계정 탈퇴가 실패/중단되는 시나리오 검증. 현재 클라이언트 정리 순서는 데이터 → Auth이므로, Auth 삭제가 실패한 경우의 재시도와 부분 삭제 복구는 출시 전 반드시 보완해야 한다. 삭제 요청 중 진행 데이터가 다시 저장되지 않도록 서버에서 일관된 삭제 상태를 관리하는 구조가 다음 작업이다.
- 구매 토큰 원문은 저장/로그에 남기지 않는다. 구매 토큰 해시/UID 연결 기록의 보존·익명화 정책은 개인정보 문서와 맞춰 확정해야 한다. 해당 기록은 현재 사용자 프로필과 별개 컬렉션에 남는다.
- 익명 프로필의 AI 신고는 사용자가 검토·전송 버튼을 눌렀을 때만 익명 인증을 만든다. Firebase가 꺼진 빌드에서는 전송 실패를 표시한다. **신고 전송 검증 전 AI 활성 빌드를 공개 출시하지 않는다.**

## SDK 검증

- Node 22 배포 설정, firebase-admin 14.4.0(모듈별 import), firebase-functions 7.3.2, googleapis 180.0.0.
- `npm audit` 0건. gaxios 6.x의 uuid v4 호출은 유지하면서 uuid 11.1.1로 고정했다. upstream 취약점은 v3/v5/v6 버퍼 경계 검증이며, v4 문자열 API 호환성을 확인했다.
- 서버 정책 테스트 10개 통과. Flutter는 서버 실패/잘못된 응답/계정 전환/중복 권한/환불 후 게임 획득 장식 보존을 검사한다. 실제 금융 거래를 수행한 것은 아니다.

근거: [Billing security](https://developer.android.com/google/play/billing/security), [Flutter Android Billing changelog](https://pub.dev/packages/in_app_purchase_android/changelog), [Firebase Admin release notes](https://firebase.google.com/support/release-notes/admin/node), [uuid 보안 공지](https://github.com/uuidjs/uuid/security/advisories/GHSA-w5hq-g745-h8pq).

## Android 빌드

- Flutter 3.47.4, target SDK 36, min 26, ARM64 LiteRT-LM 0.17.0.
- AGP 8.13.2 + Gradle 8.14.3를 유지하고 R8 9.1.43을 공식 방식으로 override. LiteRT-LM의 Kotlin 2.4 메타데이터를 처리하지 못하던 이전 R8 경고가 없어졌고 release AAB 215.9 MB가 만들어졌다.
- R8 변경 후 모델 JNI의 release 실행도 확인해야 한다. 이전의 실제 모델 20.087초 결과는 debug instrumentation에서 측정했다.
- AAB 파일 크기는 기기별 Play 다운로드 용량이 아니다. bundletool 기기별 분할 용량 확인이 남아 있다.

근거: [Kotlin/R8 지원표](https://developer.android.com/build/kotlin-support), [R8 공식 override](https://r8.googlesource.com/r8/+/refs/heads/main/README.md), [bundletool](https://developer.android.com/tools/bundletool).
