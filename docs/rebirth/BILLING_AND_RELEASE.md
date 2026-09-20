# 구매 권한과 출시 스위치

2026-09-17. 구현 기반 검증 기록이며 실제 상품 판매/배포 완료 기록이 아니다.

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
- 계정 삭제는 최근 5분 이내 재인증 + App Check가 검증된 Callable이 `accountDeletions/{uid}`에 요청을 저장한다. 생성 이벤트가 Storage → 사용자 문서 전체/신고/권한 → 구매 토큰 소유 연결 → Auth 순서로 정리한다. 중간 실패는 재시도하며 앱 종료와 무관하다. Firestore/Storage 규칙은 삭제 중 재생성과 예전 토큰의 접근을 차단한다.
- 완료 후 내용 없는 삭제 표지만 7일 뒤 TTL로 정리한다. 미완료 요청은 자동 만료시키지 않는다. 실제 배포에서는 실패 알림/오래된 pending 요청 점검과 TTL 활성화, Storage의 Firestore 조회 권한을 검증해야 한다. 새 indexes 파일 배포 전 기존 원격 인덱스를 조회해 보존한다.
- 구매 토큰 원문은 저장/로그에 남기지 않는다. 계정 삭제 시 토큰 해시와 UID 연결도 삭제한다. 다른 앱 계정은 Google 영수증의 obfuscated account ID 검사 때문에 해당 구매를 가져갈 수 없다. 계정 삭제 후 구매 복원이 불가하고 삭제가 환불을 뜻하지 않음을 확인 화면에 표시한다.
- **선택적 Google 구매 계정 연결 화면과 서버 최소 계정 생성은 구현·로컬 검증 완료**. 기기 진행은 업로드하지 않으며 목적 플래그와 서버 쓰기 차단을 둔다. `PURCHASE_ACCOUNT.md` 참조. 실제 Google/Play 검증 전 결제는 계속 꺼져 있다.
- AI 신고는 사용자 검토 후 Callable 접수번호를 받아야 성공이며, 동일 출력 재시도는 중복 생성하지 않는다. 90일 본문 TTL/개별 신고 및 익명 계정 삭제를 구현했다. `AI_REPORTING.md` 참조. 기본 Cloud off 및 Firebase 미배포 상태다. **실제 신고 전송 검증 전 AI 활성 빌드를 Google Play에 출시하지 않는다.** 직접 배포하는 무료 공개 프리뷰의 수동 피드백 경로는 `PUBLIC_PREVIEW.md`를 따른다.

## SDK 검증

- Node 22 배포 설정, firebase-admin 14.4.0(모듈별 import), firebase-functions 7.3.2, googleapis 180.0.0.
- `npm audit` 0건. gaxios 6.x의 uuid v4 호출은 유지하면서 uuid 11.1.1로 고정했다. upstream 취약점은 v3/v5/v6 버퍼 경계 검증이며, v4 문자열 API 호환성을 확인했다.
- Node 22 서버 정책 테스트26개 통과. Firestore/Storage 실제 로컬 에뮬레이터9개 검사 통과(비소유자 접근, 권한 위조, 삭제 중 재생성, 파일 재업로드 차단 포함). Flutter는 서버 실패/잘못된 응답/계정 전환/중복 권한/환불 후 게임 획득 장식 보존을 검사한다. 실제 금융 거래를 수행한 것은 아니다.

근거: [Billing security](https://developer.android.com/google/play/billing/security), [Flutter Android Billing changelog](https://pub.dev/packages/in_app_purchase_android/changelog), [Firebase Admin release notes](https://firebase.google.com/support/release-notes/admin/node), [uuid 보안 공지](https://github.com/uuidjs/uuid/security/advisories/GHSA-w5hq-g745-h8pq).

## Android 빌드

- Flutter 3.47.4, target SDK 36, min 26, ARM64 LiteRT-LM 0.17.0.
- AGP 8.13.2 + Gradle 8.14.3를 유지하고 R8 9.1.43을 공식 방식으로 override. LiteRT-LM의 Kotlin 2.4 메타데이터를 처리하지 못하던 이전 R8 경고가 없어졌고 release AAB 215.9 MB가 만들어졌다.
- 실제 AOT/R8 release QA APK에서 `SamplerConfig`/`ThinkingConfig` getter 제거로 JNI `CallIntMethodV mid == null` 종료를 재현했다. 0.17.0 JNI가 이름으로 찾는 SDK 멤버를 보존하는 ProGuard 규칙을 추가했고 같은 16KB 에뮬레이터에서 신규/긴 기록 두 조건의 생성 성공을 확인했다(21,364ms / 11,748ms). 이전 20.087초 결과는 debug instrumentation이다. QA 진입점 `integration_test/native_release_probe.dart`로 만든 APK는 Play 업로드 금지.
- 2026-09-17 최종 AAB 225,181,387 bytes, 표본 API35/ARM64 기기 다운로드 132,105,680 bytes. 실제 서명·manifest·11개 native ELF 및 split ZIP16KiB 정렬 검사를 통과했다. `artifact-inspection.json` 참조. AAB 용량은 기기별 Play 다운로드 용량과 다르다.

근거: [Kotlin/R8 지원표](https://developer.android.com/build/kotlin-support), [R8 공식 override](https://r8.googlesource.com/r8/+/refs/heads/main/README.md), [bundletool](https://developer.android.com/tools/bundletool).

계정 삭제/비용 근거: [이벤트 재시도](https://firebase.google.com/docs/functions/retries), [Firestore TTL 배포 형식](https://firebase.google.com/docs/reference/firestore/indexes), [Functions 플랜/한도](https://firebase.google.com/docs/functions/quotas). 무료 모델은 API 호출 요금이 없지만, Firebase Functions는 Blaze 연결이 필요하고 무조건 무료인 인프라가 아니다. 아직 비용 계정 연결/배포 없음.

## Android 권한 스위치 검증 · 2026-09-17

Gradle이 Flutter의 Base64 `dart-defines`에서 Cloud/Billing/Ads를 읽어 네 가지 manifest를 선택한다. 결제만 켜면 BILLING은 있고 광고 권한·초기화 provider는 없다. AdMob App ID가 남아 있어도 Ads 플래그가 false이면 광고를 켜지 않는다. 결제/광고는 Cloud 없이 빌드할 수 없고 광고에는 유효한 App ID가 필요하다.

`scripts/check_android_feature_manifests.py`로 실제 Gradle manifest merger 7가지 조합을 검사했고 전부 통과했다. 광고 검사에는 Google의 공개 테스트 ID만 사용했고 해당 APK를 설치·배포하지 않았다. `feature-manifests.json` 참조. 기존 `scripts/apply_release_values.sh`는 과거 iOS·광고 통합 설정용이므로 2.0 출시 절차에 사용하지 않는다.


## 현재 콘셉트 빌드 · 2026-09-20

소스489ccff, signed main AAB2.0.0+5: **221,628,319bytes**, 표본 ARM64/API35 다운로드130,430,117bytes. 서명/manifest/11개 ELF 및 기기 split ZIP16KB 검사 통과. 삭제 복구·조수 팩·cloud 저장 수정을 포함한다. 최신 SHA와 실제 검사 목록은 `artifact-inspection.json`, 직접 설치 ARM64 APK는 `apk-inspection.json`을 따른다. 기본 Cloud/Billing/Ads는 계속 꺼져 있다.

수익 방향은 `CONCEPT_AND_REVENUE.md`의 완결 세계관 팩 하나로 변경됐다. 세 무료 단편은 판매하지 않는다. 「조수 우체국」본편/두 장면 체험/상품 조회 목록·서버 allowlist는 story_tide_postoffice_01로 연결했다. 실제 Play SKU 생성·가격·거래 검증은 남았다. 특히 legacy cloud 삭제 경로와 운영 전제조건은 `RELEASE_GATES.md`에 남겨 두었다. 빌드 통과를 판매 활성화 승인으로 해석하지 않는다.
