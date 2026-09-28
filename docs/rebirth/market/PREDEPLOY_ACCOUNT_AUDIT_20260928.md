# 출시 전 계정 상태 감사 — 2026-09-28

읽기 전용 점검이다. Firebase/Play 설정 변경, 상품 생성, 비용 계정 연결, AAB 업로드, 함수 배포, 테스트 시작은 하지 않았다. **오늘 CLI로 확인한 사실**과 **이전 콘솔 관찰·현재 미확인 항목**을 구분한다.

| 항목 | 확인된 상태와 근거 | 판정 |
|---|---|---|
| 작업 계정 | `firebase login:list`의 로그인 계정은 `hyeonseok460`이다. `gcloud auth list`에는 다른 `hyeonseok45` 계정만 있다. 후자의 프로젝트 조회 결과를 이 앱 계정의 증거로 쓰지 않는다. | 9/28 확인 |
| Firebase 프로젝트·Android 앱 | `firebase projects:list`에 `lifequest-crossing-2026`가 `ACTIVE`; `firebase apps:list --project lifequest-crossing-2026`에 `com.lifequest.app`, 앱 ID `1:61563760091:android:4f449ea668e5a19120cbfe`가 `ACTIVE`로 나온다. 로컬 `.firebaserc`와 `firebase.json`도 같은 프로젝트를 가리킨다. | 9/28 확인 |
| Firestore | `firebase firestore:databases:list`에 기본 DB, `asia-northeast3`, Native/Standard, 삭제 보호, `freeTier: true`가 나온다. `freeTier` 필드만으로 프로젝트의 **현재 Blaze/Spark 요금제**를 확정하지 않는다. | 9/28 확인 |
| Firebase 요금제·Functions | 9/21 콘솔 기록은 Spark·Blaze 미연결·Functions 미배포다(`../CONTINUE.md`). 오늘 `firebase functions:list --project lifequest-crossing-2026`는 `Failed to list functions` 오류를 반환했다. 따라서 현재 요금제와 함수 배포 여부는 콘솔 재확인이 필요하다. | 9/21 마지막 직접 관찰; 9/28 미확인 |
| Auth/App Check·구매 검증·RTDN·작업 큐 | 9/21에는 운영 설정/배포 전이었다. 서버 소스에 RTDN 토픽 `lifequest-play-billing-events`와 비공개 구매 확인 작업 큐가 정의되어 있으나, 소스 정의는 클라우드 자원이나 Play 연결의 증거가 아니다. 현재 API, IAM, 토픽, Play Publisher 권한, 테스트 메시지 수신, 큐 실행은 확인하지 못했다. | 현재 미확인 |
| Google Play 앱 | 9/21 직접 관찰: 개발자 `Log_Ian`/앱 `Life Quest` (`com.lifequest.app`), Alpha 비공개 트랙 **비활성**·릴리스 초안, 한국·대만·일본·미국·캐나다·프랑스 6개국 저장, AAB 미업로드, 참여 링크 미생성. 테스터용 이메일 목록의 개발자 본인 1명은 실제 참여자가 아니다(`../CLOSED_TEST.md`). 오늘 Play Console을 다시 열지 않았다. | 9/21 마지막 직접 관찰 |
| 프로덕션 접근 | 9/21 콘솔에는 “아직 프로덕션에 액세스할 수 없습니다”가 표시됐다(`../CONTINUE.md`). 이후 계정 상태 변경은 확인하지 못했다. 해당 새 개인 계정 제한이 여전히 적용되면 **12명 이상 연속 14일 실제 opt-in** 후 접근 신청·Google 심사가 필요하다. APK 다운로드나 이메일 목록 등록은 이 기간을 시작하지 않는다. | 9/21 마지막 직접 관찰 |
| 판매자 결제·정산 | Google Payments Center 프로필 연결 여부, 세금/지급 정보, 상품 생성 권한, 현지 가격, 상품 활성 상태를 오늘 확인하지 못했다. 유료 AAB가 로컬에 있다는 사실로 판매 자격을 추정하지 않는다. | 현재 미확인 |
| Play API 권한 | 앱 검증 서버의 서비스 계정에 Google Play Developer API 사용과 Play Console의 결제 관련 권한이 부여됐는지 확인하지 못했다. 개인키 파일은 점검에 필요하지 않으며 읽거나 만들지 않았다. | 현재 미확인 |
| 빌드 정책 | 현재 `android/app/build.gradle.kts`의 `targetSdk = 36`, 패키지 `com.lifequest.app`. API 36은 2026-08-31부터 일반 신규 앱/업데이트 제출 요건에 맞는다. 실제 제출 후보의 최종 manifest는 재빌드 후 검사해야 한다. | 소스 9/28 확인 |

## 다음 배포 요청 때의 확인 순서

1. **계정 상태를 먼저 읽는다.** Play Console에서 동일 개발자·앱·Alpha 초안/프로덕션 제한·앱 콘텐츠 오류·AAB 업로드 가능 여부를 재확인한다. Firebase Console에서 실제 요금제, Functions, Auth, App Check와 Cloud Tasks/Pub/Sub 상태를 확인한다. 9/21의 Chrome 파일 선택 제한과 Play Console 오류가 해결됐다고 추정하지 않는다.
2. **판매 운영을 구성한다.** Play의 Payments Center 연결·정산 상태를 확인하고, 최종 SKU/지역 가격을 설정한다. [Play Billing 준비 문서](https://developer.android.com/google/play/billing/getting-ready)에 따르면 판매에 연결된 결제 프로필이 필요하며, Play Billing Library를 포함한 앱 버전을 게시해야 인앱 상품 설정 기능을 사용할 수 있다. 이 순서가 해당 계정에 적용되는지 Console에서 확인한다.
3. **결제 백엔드를 실제 연결한다.** [Firebase Functions 배포는 Blaze가 필요](https://firebase.google.com/docs/functions/get-started)하므로 요금제와 예산을 확인한 뒤 Auth/App Check, 운영 Firestore 규칙, Functions·비공개 작업 큐를 배포하고 오류/재시도 경로를 확인한다. [Play Developer API 안내](https://developers.google.com/android-publisher/getting_started)에 따라 서버 실행 계정의 API 및 Play 권한을 구성한다. 비밀 서비스 계정 키 다운로드 대신 관리형 실행 자격을 우선한다.
4. **환불 알림 경로를 검증한다.** [Play RTDN 설정](https://developer.android.com/google/play/billing/getting-ready)의 토픽, Play 송신자 Publisher 권한, 앱별 RTDN 연결과 **일회성 상품 포함** 알림 유형을 확인하고 테스트 메시지를 실제 함수가 받는지 확인한다. 알림만으로 권한을 바꾸지 말고 Play Developer API 재조회까지 검증한다.
5. **정확한 출시 후보로 라이선스 테스트한다.** 구매/보류/취소/재설치 복원/환불·권한 회수, 서버 장애·작업 큐 재시도, 계정 삭제를 Play 설치본에서 확인한다. 테스트 거래는 매출이나 유료 수요의 증거가 아니다.
6. **비공개 트랙을 실제 게시한 뒤 테스터를 모집한다.** [Google의 비공개 테스트 안내](https://support.google.com/googleplay/android-developer/answer/9845334?hl=en)에 따르면 초안에는 참여 링크가 나타나지 않는다. 실제 opt-in 12명/14일 조건은 [개인 계정 요구사항](https://support.google.com/googleplay/android-developer/answer/14151465?hl=en)에 따라 집계한다. 계정의 프로덕션 접근 승인 전에는 정식 출시를 완료했다고 표시하지 않는다.

이번 점검에서 **현재 Play 상품·결제 프로필·Blaze 상태와 실거래가 확인되지 않았으므로 유료 판매 준비 완료 판정은 내릴 수 없다.** 콘솔 확인과 실제 라이선스 거래 검증이 다음 증거다.
