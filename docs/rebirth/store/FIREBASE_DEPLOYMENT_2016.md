# 2016 운영 서버 연결 기록

2026-10-03, 프로젝트 `lifequest-crossing-2026`, Android `com.logian.lifequest`. 공식 Firebase CLI/MCP의 지정 소유자 로그인 성공을 확인한 뒤 실행했다. **서버 연결 성공이며 실제 구매·복원·환불 성공이나 제품 수요 증거가 아니다.**

## 배포 및 읽기 확인

- Node.js 22 함수 9개가 `us-central1`에서 ACTIVE. 함수별 설정은 [읽기 결과](../firebase-deployment-2016.json).
- 전부 최소 인스턴스 0, 256 MiB, 동시 요청 80. 최대 인스턴스는 구매 검증 3, 환불 보완 1, 나머지 2. 예약 인스턴스는 없다.
- Firestore는 기존 서울 `asia-northeast3`, 삭제 보호 활성 유지. 기존 규칙 일치 확인. `_private`, `accountDeletions`, `aiReports`의 `expiresAt` TTL 배포/재조회 확인. 기존 인덱스 삭제 없음.
- 기본 Storage 버킷 `lifequest-crossing-2026.firebasestorage.app`을 미국 중부 Standard로 생성하고 소스의 소유자 전용 규칙 배포/재조회. 사진은 소유자의 `users/{uid}/profile.jpg`만, 이미지 MIME/2 MiB 미만; 나머지 기본 거절. 실제 인증 사용자 업로드·삭제는 아직 미검증.
- Android Publisher API ENABLED 확인. 서비스 계정 키는 만들거나 내려받지 않았다.
- 함수 빌드 이미지 저장소 `gcf-artifacts`의 정리 정책 1일 설정. 다른 저장소는 변경하지 않았다.

## 구매 승인·환불 전달

- `acknowledgePlayPurchase` 큐: RUNNING, 초당 2건, 동시 2건, 최대 300회/48시간, 최소 60초/최대 600초 간격.
- 작업 함수는 공개 호출 불가. 함수의 `roles/run.invoker`, 큐의 `roles/cloudtasks.enqueuer`, 런타임 자신의 `roles/iam.serviceAccountUser`만 목적별 추가했다.
- 런타임은 기존 기본 compute 서비스 계정이다. 이 계정의 **기존 프로젝트 Editor 역할이 남아 있다**. 이번 작업에서 새 프로젝트 Editor를 주지 않았으나 전용 최소권한 계정으로 축소된 상태라고 표현하지 않는다.
- RTDN 토픽 `projects/lifequest-crossing-2026/topics/lifequest-play-billing-events`. Google 공식 게시 계정에 토픽 publisher 부여, Play Console에서 모든 일회성 제품/무효화된 구매 포함 알림 설정 저장.
- 환불 보완 스케줄러 ENABLED, 매일 `03:00 UTC`(한국 12시), OIDC 인증 POST, 300초 제한, 재시도 3회. 실제 구매를 대상으로 한 실행은 미검증.

## 실제 연결 검사와 한계

| 검사 | 관찰 결과 | 입증하지 않는 것 |
| --- | --- | --- |
| 인증/App Check 없이 5개 callable POST | 모두 HTTP 401, UNAUTHENTICATED | 정상 Play 기기에서 토큰 발급/구매 성공 |
| 작업 함수의 비인증 직접 호출 | HTTP 403 | 정상 구매 승인 |
| OIDC 인증된 빈 입력 큐 작업 1건 | 2026-10-03 12:45:08 UTC, HTTP 204 | UID·구매 토큰·영수증·유료 권한을 만들지 않은 연결 검사 |
| Play Console 시험 알림 | 2026-10-03 12:44:40 UTC, 수신 함수 HTTP 204 | 실제 환불 후 유료 권한 해제 |

관련 스크린샷은 로컬 `build/review/firebase-storage-created-2016.png`, `play-rtdn-connected-2016.png`. 원본 토큰·영수증·인증 코드는 기록하지 않았다.

## 다음 검증의 의존성

1. 서버 계정의 **이 앱만** Play 앱정보 읽기·재무 데이터 보기·주문 관리 권한은 초대 화면까지 준비했으며 사용자 승인 대기다. 앱 배포/계정 관리/다른 앱 권한은 선택하지 않았다. 승인 전에는 초대 제출하지 않는다.
2. 실제 Play 설치본에서 상품 조회 → 테스트 카드 결제 → 서버 확인·승인 → 복원 → 테스트 환불 → 기존 무료 기록 보존을 확인한다. App Check 우회/수동 유료 권한 삽입으로 대체하지 않는다.
3. 인증된 클라우드 사진/계정 삭제/선택 AI 신고도 앱을 통해 확인한다. 빈 입력 검사를 이 결과로 바꿔 기록하지 않는다.
4. 기존 함수 월 ₩5,000 상한 및 계정 ₩10,000 알림은 별도다. 이번 연결 검사로 실제 청구액·상한 집행을 확인했다고 표현하지 않는다.

공식 절차: [Firebase 작업 큐](https://firebase.google.com/docs/functions/task-functions), [Play RTDN 설정](https://developer.android.com/google/play/billing/getting-ready), [Android Publisher API 권한](https://developers.google.com/android-publisher/getting_started).
