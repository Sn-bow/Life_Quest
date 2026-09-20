# AI 신고 접수와 삭제 · 2026-09-17

**현재 원격 접수 기능 미배포.** 2026-09-21 지정 계정에 새 Firebase 프로젝트를 만들었지만 Cloud는 기본 off다. 직접 배포하는 무료 APK는 추천 문구를 검토·복사하고 사용자가 문의 페이지에서 직접 이메일을 보낼 수 있다. 자동 접수나 접수번호를 주장하지 않는다. 아래의 서버 경로는 이후 Cloud-on 빌드에 해당한다. 수동 이메일 안내만으로 Play의 앱 내 신고 접수 요건을 충족했다고 주장하지 않는다.

## 접수

- 사용자가 추천의 제목·행동·이유를 읽고 전송을 누를 때만 인증과 `submitAiReport` callable이 실행된다. 로그인하지 않았다면 Firebase 익명 인증을 사용하며 기기 프로필은 업로드하지 않는다.
- 보내는 필드는 schema/model/title/instruction/reason/locale뿐. 서버가 허용 필드와 네 언어, Unicode 글자 수 25/80/60을 검증한다. 추가한 목표/이력 필드는 거부한다. App Check, 최대 인스턴스 2개, identity별 고유 신고 20개/24시간 제한을 둔다.
- UID와 정규화한 필드 순서의 SHA-256이 신고 ID다. 같은 계정의 동일 출력 재전송은 기존 접수번호를 반환하고 TTL/쿼터를 늘리지 않는다. 통신 시간 초과는 결과 불명이며 자동 업로드 예약을 약속하지 않는다.
- `users/{uid}/aiReports/{reportId}`에 검토한 문구와 서버 reportedAt/expiresAt만 저장한다. 루트의 기기/클라우드 프로필은 생성하지 않는다. `_private/aiReportQuota`는 서버만 접근할 수 있다. 클라이언트의 직접 create/update는 차단한다.
- 사용자에게 받은 출력에는 개인정보가 포함될 수 있다. Functions/CLI/오류 추적 로그에 본문, 전체 요청 또는 raw 인증 정보를 기록하지 않는다.

## 보관과 삭제

- 본문과 쿼터는 마지막 해당 기록 생성에서 90일 뒤 TTL 삭제 대상이다. 실제 삭제에는 플랫폼 지연이 있을 수 있다. 재시도는 보관 기간을 연장하지 않는다. 계정 삭제는 기존 job의 하위 문서 정리에 포함된다.
- 앱은 최근100개 접수 참조(`uid/reportId`)와 접수 시각만 기기에 보관한다. 본문은 별도로 복사하지 않고, 암호화 진행 백업에도 이 접수 로그를 넣지 않는다. 접수 결과를 복사하거나 설정 → AI 신고 내역에서 확인할 수 있다.
- 같은 인증 계정이면 각 신고를 서버에서 삭제한 뒤 접수 로그에서 제거한다. 실패 시 참조를 남기고 다시 시도한다. 계정 변경·재설치로 원래 인증에 접근할 수 없으면 접수 참조를 제시하여 공개 지원 이메일로 삭제 요청을 할 수 있다. 담당자는 참조의 문서 경로와 요청 범위를 확인한다.
- 익명 계정은 재인증할 영구 자격증명이 없으므로 전용 `requestReportIdentityDeletion` 경로를 둔다. App Check와 anonymous 토큰뿐 아니라 **현재 Admin Auth record에 영구 provider/email/phone이 없는지** 검사한다. Google로 연결된 계정의 오래된 익명 토큰으로 영구 계정을 삭제할 수 없다.
- 익명 삭제는 기존 durable 삭제 job을 접수한다. 기기의 진행은 유지하며, accepted 응답 이후의 로컬 로그 정리/로그아웃 실패를 서버 접수 실패로 바꾸지 않는다. 익명 Auth ID 자체는 전체 계정 삭제 전까지 남을 수 있다. 새로운 신고를 선택하면 새 익명 ID가 생성될 수 있다.

## 실제 배포 때 해야 할 일

1. 올바른 Firebase 프로젝트/Android 패키지 등록, Google 및 anonymous Auth, App Check/Play Integrity부터 검증한다.
2. 기존 원격 indexes/fieldOverrides를 먼저 내보내고 보존한다. 저장소의 빈 `indexes` 목록으로 기존 인덱스를 덮어쓰지 않는다. `aiReports.expiresAt`, `_private.expiresAt`, `accountDeletions.expiresAt` TTL을 활성화하고 실제 활성 상태를 확인한다.
3. 새 callable과 Firestore 규칙을 함께 배포한다. 기존 직접 Firestore write 방식 클라이언트는 새 규칙에서 실패하므로 해당 동작을 쓰는 공개 버전이 있는지 확인한 후 버전을 전환한다. 현재 확인된 2.0은 공개 출시 전이다.
4. 실제 기기에서 신고 → Firestore 해당 문서 접수 → 재시도 중복 방지 → 개별 삭제 → 익명 계정 삭제 job 및 Auth 정리를 끝까지 검증한다. App Check 실패/시간 초과/쿼터/계정 변경도 검사한다.
5. 운영자가 최소권한 Firebase Console에서 신고 컬렉션과 삭제 pending job을 검토할 실제 운영 절차를 확정한다. 이 작업에서 자동 알림 수신자를 추가하거나 타인에게 메시지를 보내지 않았다. 오래된 pending 삭제와 함수 오류를 감지할 운영 알림은 배포 시 설정해야 한다.
6. 실제 빌드의 개인정보/데이터 보안 선언에 선택적 신고·익명 ID·90일 본문 보관을 반영한 뒤 Cloud를 켠다. 결제/광고 스위치는 독립적이다.

근거: [Play AI-generated content](https://support.google.com/googleplay/android-developer/answer/13985936), [Firestore TTL](https://firebase.google.com/docs/firestore/ttl), [Callable](https://firebase.google.com/docs/functions/callable).
