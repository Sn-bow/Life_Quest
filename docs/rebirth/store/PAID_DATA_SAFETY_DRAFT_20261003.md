# Life Quest 2.1.0+2016 — 데이터 보안 입력 초안

> 2026-10-06 후속: 현재 본인 내부 Play 빌드는2.2.0+2017이다. [최종 아티팩트](../product-2017-recovery-build.json), [구매·복원·환불](../qa/play-test-purchase-20261006.md), [네이티브 도구 QA](../qa/native-toolkit-20261006/README.md)를 우선한다. 아래2016의 ‘실제 구매 미완료’는 과거 이력이다. 2017은 복습 카드·체크리스트·루틴·문장 결과를 프로필/백업에 저장하며, 선택형 클라우드 프로필에서 이용하면 기존 실행 기록처럼 동기화 대상이다. 완료 전 초안은 기기에만 보관하고 백업/자동 업로드에 포함하지 않는다. 공개 정책 소스의4개 언어에 이 범위를 명시했다. 실제 구매·복원·환불 성공을 인증된 계정 삭제/신고 성공으로 확대하지 않으며, 외부 비공개 제출은 보류한다.

작성/갱신 2026-10-03. **제출본 아님.** 패키지 `com.logian.lifequest`. 최종 파일 해시/서명/manifest 검사는 [artifact 기록](../product-2016-inspection.json)을 단일 기준으로 사용한다. Cloud/Billing on, Ads/QA off. 새 미션·루트·Complete 구매 경로가 포함된 후보이며 Play 상품·실거래 검증은 아직 완료되지 않았다. 운영 함수 9개와 Storage/TTL/RTDN은 배포했고 연결 검사를 마쳤다. [실제 상태](FIREBASE_DEPLOYMENT_2016.md)를 따르며 인증된 앱의 삭제·구매 검증은 별도다. 이전 패키지/2013 문서를 그대로 제출하지 않는다.

## 이번 기능의 데이터 증분
- 미션 완료 전 메모 초안은 프로필별로 분리하여 기기에만 임시 저장한다. 클라우드 전송·진행 백업에는 포함하지 않는다. 완료하면 해당 프로필의 실행 기록에 포함하고 임시 사본을 정리한다. 프로필 삭제 시 남아 있는 초안도 삭제한다.
- `JourneyBook`의 루트 종류, 직접 입력한 목표(120자), 시작 시각, 최대21개 완료 시각·메모(240자)·짧은 버전 여부·선택 시간, 선택한 루트 ID. 기기 프로필이면 로컬 저장, 직접 만든 암호화 백업에도 포함된다. **클라우드 프로필**을 별도로 이용하면 기존 진행 데이터와 함께 Firestore에 동기화된다.
- 단계별 시간은 사용자가 고른 미션 시간이며 실제 운동/학습 시간 센서 측정값이 아니다. 이 구분을 설명 문구에도 적용한다.
- 집중 타이머: 프로필/퀘스트 해시 범위의 기기 저장. 시작/종료 예정 시각, 일시정지 잔여 시간. 클라우드/백업에 포함하지 않고 프로필 삭제 시 제거한다. 타이머가 끝났다는 이유로 자동으로 완료나 XP를 주지 않는다.
- `quest_journeys_complete_01`은 기존 구매 검증 경로를 쓰는 새 일회 구매 상품이다. 새 카드/은행 데이터 유형은 생기지 않는다. 기존 Plus 구매자의 서버 확인 권한도 유지한다.
- 루트의 ‘관계’ 미션은 연락처를 읽거나 메시지를 보내지 않는다. ‘가벼운 움직임’은 건강 센서를 읽거나 처방하지 않는다. 사용자가 클라우드에 적은 신체 활동 내용은 아래 운동 정보/사용자 콘텐츠 분류에 포함한다.
- `main.dart`의 중국어 UI는 번체(TW/Hant)로 해석하고 서버에 국가나 위치를 추가 수집하지 않는다.

## 운영 상태
10/3 지정 계정의 CLI/MCP 인증 성공 후 함수 9개, 소유자 전용 Storage 규칙, Firestore TTL을 배포하고 RTDN/비공개 큐 연결을 확인했다. [운영 기록](FIREBASE_DEPLOYMENT_2016.md). 실제 Play 설치본의 인증된 계정 삭제/사진 업로드/신고/구매·복원·환불과 전송 범주 검증은 미완료다. 함수 배포나 비인증 요청 거절만으로 삭제 기능의 실제 성공을 체크하지 않는다.

Play의 [데이터 보안 양식 안내](https://support.google.com/googleplay/android-developer/answer/10787469?hl=en)에 따르면 기기 밖으로 전송되는 앱·SDK 데이터, 가명 식별자, 사용자 선택 기능도 검토해야 한다. 각 패키지의 활성 Play 버전 전체를 반영해야 하며 비공개 테스트도 양식 대상이다. 아래의 `선택`은 **사용자가 계정/구매/신고/동기화를 거절해도 기기 기본 기능을 사용할 수 있다는 현재 제품 흐름**을 뜻한다. 사용자가 선택 기능을 켠 뒤 그 기능에 필요한 데이터가 필수라는 뜻과 혼동하지 않는다.

## 입력 전에 고정할 제품 경계

- 앱 첫 실행은 기기 프로필이다. 기본 퀘스트·상태창·경험치·온디바이스 Gemma 4 E2B 추론·30/90일 성장 계산은 기기에서 처리한다. 상태창 PNG/TXT/CSV와 암호화 백업은 사용자가 고른 파일 위치로 저장한다. 이것만으로 개발자 서버에 퀘스트/AI 프롬프트/보고서 파일이 업로드되지는 않는다 (`lib/features/session/session_gate.dart`, `lib/features/director/quest_generation.dart`, `lib/features/status_pack/ui/status_pack_screen.dart`, `lib/features/backup/backup_files.dart`).
- 모델을 사용자가 설치할 때 HTTPS로 Hugging Face와 파일 전달 제공자에서 약 2.59 GB를 내려받는다. 요청 IP/파일 URL 같은 연결 메타데이터는 해당 제공자에게 보일 수 있다. **목표, 퀘스트, 프롬프트를 모델 제공자에게 보내는 코드 경로는 없다** (`android/app/src/main/kotlin/com/logian/lifequest/QuestDirectorPlugin.kt`).
- 선택적 기존 클라우드 계정은 Firebase Auth의 이메일/Google 로그인과 Firestore의 캐릭터 이름, 퀘스트 제목·완료, 행동/성장 기록, 설정 등을 사용한다. 선택한 프로필 사진은 Firebase Storage에 업로드된다. 구매 전용 Google 연결은 계정·권한을 서버에 만들지만 기기 프로필이나 AI 개인화 기록을 자동 업로드하지 않는다 (`lib/screens/signup_screen.dart`, `lib/state/character_state.dart`, `functions/purchase_account.js`).
- 선택적 AI 제안 **신고**는 사용자가 화면에서 제목·행동·이유를 확인하고 전송을 누른 경우에만 모델명/언어/선택 텍스트/계정 UID(필요하면 익명 UID)를 Functions→Firestore로 보낸다. 전체 목표·학습 이력은 첨부하지 않는다. 신고와 할당량 문서는 90일 후 TTL 삭제 대상이며 즉시 삭제 보장은 아니다 (`lib/features/director/ai_report_button.dart`, `ai_report_service.dart`, `functions/ai_reports.js`).
- 유료 상품 구매/복원 때 Play 상품 ID와 구매 토큰을 검증 Function에 보내고, 서버가 Play Developer API에서 확인한다. 서버는 Firebase UID의 SHA-256 계정 해시, 구매 토큰 해시, 상품·권한·검증/환불 상태를 보관한다. 실제 카드·계좌 번호를 앱이 받거나 저장하지 않는다. 해시는 재연결 가능한 가명 식별자이므로 데이터 범위에서 제외하지 않는다 (`lib/services/purchase_service.dart`, `functions/purchase_account.js`, `functions/purchase_policy.js`).
- Firebase App Check는 Play Integrity를 사용한다. [Firebase SDK 공개 문서](https://firebase.google.com/docs/android/play-data-disclosure)와 [Play Integrity 데이터 안내](https://developer.android.com/google/play/integrity/terms#data-safety)에 따라 무결성 토큰/기기·앱 메타데이터를 처리한다. Auth/Functions 호출은 IP와 Firebase UID를 포함할 수 있다. 알림은 현재 로컬 일정이며 Firebase Messaging 원격 푸시 구현은 없다. 광고 SDK가 의존성에 남아 있어도 +2015 AAB의 실제 manifest 검사에서 광고 초기화/컴포넌트/광고 ID 권한이 없음을 확인했다.

## Play Console 입력값 제안

| 양식 질문 | +2016 AAB에 대한 입력 초안 | 조건/근거 |
| --- | --- | --- |
| 앱이 데이터를 수집하거나 공유하나? | **예** | 선택적 계정·신고·클라우드·구매, Firebase/App Check 식별자. 로컬 모드가 있어도 전체 앱 답은 예. |
| 수집되는 **모든** 사용자 데이터는 전송 중 암호화되나? | **예** | Firebase/Google Play 서비스의 HTTPS와 모델 다운로드 HTTPS, cleartext 금지. 다른 전송 경로가 없다는 최종 AAB/실기기 확인 전제. [Firebase 전송 암호화](https://firebase.google.com/docs/android/play-data-disclosure), [Play 안내](https://support.google.com/googleplay/android-developer/answer/10787469?hl=en). |
| 사용자 데이터 삭제 요청 수단이 있나? | **예 — 삭제 백엔드 운영 확인 후** | 앱의 기기 프로필 삭제, 계정/익명 신고 계정 삭제 요청 및 공개 [삭제 안내](https://sn-bow.github.io/Life_Quest/#delete-account). `functions/account_deletion.js`는 프로필·사진·신고·구매 연결을 제거하고 비내용 완료 표식을 7일 TTL 대상으로 둔다. Firebase/Play 자체 보존 데이터와 사용자 저장 파일은 별도. 함수가 미배포면 아직 **예**로 제출하면 안 된다. |
| 독립 보안 심사 인증? | **아니요** | 외부 MASA 등 인증 증거 없음. |
| 제3자와 데이터를 공유하나? | **현재 설계상 아니요 — 최종 사업자/SDK 검토 조건부** | Firebase는 개발자 지시대로 처리하는 서비스 제공자이고, Google Play 구매·Google 로그인·모델 파일 다운로드는 사용자가 직접 시작하는 작업에 해당한다는 [Play 예외 정의](https://support.google.com/googleplay/android-developer/answer/10787469?hl=en)를 적용한 해석. Firebase/Google Play/Hugging Face로 네트워크 요청 자체가 없다는 뜻이 아니다. 광고·데이터 판매 없음. 최종 SDK, 개인정보 처리자 관계와 모델 CDN 동작을 확인한 뒤 입력한다. |

각 데이터 유형에서 아래의 `수집`에 해당하면 `수집됨`, `공유`는 위 예외 판단이 유지될 때 `공유되지 않음`, `일시 처리`는 **아니요**를 기본으로 입력한다. 특히 Firestore·Storage·구매 권한·신고 기록은 서버에 남으므로 일시 처리라고 선언하면 안 된다. `목적`은 Play 양식의 정확한 선택지 이름이다.

| Play 데이터 유형 | 수집 | 필수/선택 | 목적 선택 | 실제 경로 및 주의 |
| --- | --- | --- | --- | --- |
| 개인정보 → **이름** | 예 | 선택 | 앱 기능, 계정 관리, 개인 맞춤 | 클라우드 캐릭터 닉네임/Google 기본 프로필. 기기 전용 이름은 전송하지 않는다. |
| 개인정보 → **이메일 주소** | 예 | 선택 | 계정 관리, 사기 방지·보안 | 이메일 계정 또는 구매용 Google 계정의 Firebase Auth. |
| 개인정보 → **사용자 ID** | 예 | 선택 | 앱 기능, 계정 관리, 사기 방지·보안 | Firebase UID/익명 신고 UID, Play 연동용 UID 해시. 해시도 가명 ID다. |
| 금융 정보 → **구매 내역** | 예 | 선택 | 앱 기능, 계정 관리, 사기 방지·보안 | Play 구매 상품·토큰/해시·권한/환불 상태. **사용자 결제 정보**(카드/계좌)는 선택하지 않는다. |
| 사진 및 동영상 → **사진** | 예 | 선택 | 앱 기능, 개인 맞춤 | 사용자가 클라우드 프로필에서 이미지를 고르면 Storage 업로드. 상태창 PNG를 로컬 파일로 저장하는 기능은 서버 수집이 아니다. |
| 앱 활동 → **기타 사용자 제작 콘텐츠** | 예 | 선택 | 앱 기능, 개인 맞춤 | 클라우드 퀘스트/목표/보상 제목·메모, 선택적으로 전송한 AI 신고 텍스트. |
| 앱 활동 → **기타 활동** | 예 | 선택 | 앱 기능, 개인 맞춤 | 클라우드 퀘스트 완료·성장 기록·선택 이벤트. 기존 사용자의 게임 진행 데이터가 동기화되어 남아 있을 수 있으나 현 출시 UI에서는 새 탐험을 시작할 수 없다. |
| 앱 활동 → **앱 상호작용** | 예, 보수적 | 선택 | 앱 기능, 개인 맞춤 | 클라우드에 저장되는 퀘스트 완료·선택 내역 범위. 일반 화면 클릭 분석이나 Firebase Analytics 수집을 주장하는 것은 아니다. 실제 저장 필드 확인 후 `기타 활동`만으로 충분하면 한 유형으로 줄일 수 있다. |
| 건강 및 피트니스 → **운동 정보** | 예, 보수적 | 선택 | 앱 기능, 개인 맞춤 | 사용자가 클라우드 계정에서 운동 퀘스트를 완료하면 운동 활동/완료 기록이 저장된다. [Play 정의](https://support.google.com/googleplay/android-developer/answer/10787469?hl=en)는 센서 수집에 한정되지 않는다. 기존 무료 초안의 `센서 없음 ⇒ 운동 정보 없음` 추론은 이 빌드에 맞지 않는다. |
| 기기 또는 기타 ID → **기기 또는 기타 ID** | 예 | 필수로 입력하는 보수적 초안 | 앱 기능, 사기 방지·보안 | Firebase 설치 ID, App Check/Play Integrity 토큰·기기 증명 및 구매 계정 연결. Firebase는 앱 시작에 초기화된다. 기기 모드에서 실제 네트워크 요청의 범위는 실기기 확인 필요. |
| 위치 → **대략적인 위치** | **조건부 예로 입력 권고** | 선택 | 앱 기능, 사기 방지·보안 | GPS/위치 권한은 없다. 그러나 Firebase Auth·Functions가 IP를 수신하고 모델 다운로드 제공자도 요청 IP를 본다. Play는 **IP에서 추론한 대략 위치도 해당 유형**이라고 한다. Firebase가 이 빌드의 IP로 위치를 실제 추론/사용하는지 최종 확인해 아니면 제외한다. 허위로 “GPS 수집”이라고 설명하지 않는다. |

**선택하지 않을 유형(현 코드 기준):** 정확한 위치, 전화번호/주소/기타 개인 속성, **결제 정보**(카드 등), 건강 정보(게임의 Health 능력치 자체는 진단/증상이 아님), 이메일 메시지·SMS·연락처·캘린더·마이크·오디오, 설치 앱 목록, 탐색 기록, 파일/문서, 광고 ID/광고 상호작용. 사용자가 파일 제공자를 직접 선택해 암호화 백업이나 요약을 저장하는 작업은 앱의 자동 업로드와 구분한다. 자유 입력 퀘스트에 개인 의료 내용이 들어가거나 기능이 확대되면 건강 정보 분류를 다시 판단해야 한다.

### Crashlytics·진단 정보 판정

+2015 AAB의 실제 manifest에는 `firebase_crashlytics_collection_enabled=false`와 `firebase_analytics_collection_enabled=false`가 확인됐다. `lib/main.dart`에서 `recordError`/`recordFlutterFatalError`를 호출하지만, 현재 코드의 수집 활성화 호출 여부 및 실제 기기 전송은 별도로 확인해야 한다. [Firebase의 Flutter 설명](https://firebase.google.com/docs/crashlytics/flutter/customize-crash-reports#enable_opt-in_reporting)에 따르면 수집이 비활성인 경우 보고서는 기기에만 저장되고, 나중에 수집을 활성화해야 전송된다. 따라서 **Crash logs 및 성능 Diagnostics를 오로지 Crashlytics가 존재한다는 이유로 예로 선택하지 않는다**. 기존 설치에 남은 SDK 수집 override, 다른 활성 Play 아티팩트, Firebase Sessions/App Check 하위 SDK의 실제 전송도 실기기·최종 의존성 점검이 필요하다. 그 과정에서 진단/충돌 데이터 전송이 확인되면 해당 유형을 예로 바꾸고 목적은 `분석`, 필요 시 `앱 기능`을 선택한다.

## 제출 직전 확인(이 항목이 미확인이면 양식을 제출하지 않음)

1. **정확한 AAB와 활성 트랙**: 후보 AAB의 최종 병합 manifest/의존성, 현재 Play에 배포 중인 다른 버전까지 비교한다. 광고 또는 Crashlytics를 켜면 이 초안은 폐기하고 새로 작성한다.
2. **실제 네트워크 동작**: 기기 모드 첫 실행, 모델 설치, Google 로그인, 클라우드 퀘스트 완료, 사진 업로드, AI 신고, Play 라이선스 테스트 구매/복원/환불에서 전송 도메인과 데이터 범주를 점검한다. 특히 IP→대략 위치, Firebase Installations/Sessions 식별자, Crashlytics 비활성 전송 여부를 확인한다.
3. **실제 서비스 상태**: 삭제 Function/Firestore TTL·Storage/Auth 삭제, App Check, Play 상품/RTDN이 배포되어 작동하는지 확인한다. 현재 코드와 로컬 AAB만으로 운영 중이라고 주장하지 않는다.
4. **공개 고지 일치**: [공개 개인정보처리방침](https://sn-bow.github.io/Life_Quest/#privacy)과 삭제 URL의 실제 배포본을 확인한다. 로컬 `docs/index.html` 및 `PRIVACY_POLICY.md`는 무료 공개 APK와 미배포 유료 후보를 구분하도록 10/3 갱신했다. 이번 변경에는 루트·메모·타이머와 한국어/영어/일본어/번체 안내가 포함된다. 2026-10-03 이 변경을 공개 사이트에 게시했고 Pages 커밋 `1078423`의 실제 화면을 확인했다. **유료 테스트 제출 직전 활성 기능과 공개 URL을 다시 확인**해야 한다. 국내·해외 출시 언어의 스토어 설명/앱 안내도 일치시킨다.
5. **계정 소유자 제출**: Google Play Console의 데이터 보안 답변은 실제 개발자 계정에서 저장 전 검토한다. 이 문서는 콘솔에 입력하거나 제출한 기록이 아니다.

공식 근거: [Google Play Data safety 양식·분류·공유 예외](https://support.google.com/googleplay/android-developer/answer/10787469?hl=en), [Firebase Android SDK 공개](https://firebase.google.com/docs/android/play-data-disclosure), [Firebase 개인정보/보존](https://firebase.google.com/support/privacy), [Play Integrity 데이터 처리](https://developer.android.com/google/play/integrity/terms#data-safety), [Crashlytics opt-in 동작](https://firebase.google.com/docs/crashlytics/flutter/customize-crash-reports#enable_opt-in_reporting), [Play Billing 서버 검증](https://developer.android.com/google/play/billing/security).
