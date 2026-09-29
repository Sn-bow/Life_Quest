# Android 패키지명 이전 · 2026-09-29

## 결정 근거

기존 Play 앱 초안은 `com.lifequest.app`에 묶여 있지만 AAB 업로드·테스트 게시·설치 사용자는 없다. Android 개발자 인증에서 이 ID는 **기존 패키지**로 판정됐고, 다른 서명 인증서 지문 59개를 표시했다. 현재 로컬 APK 서명키와 기존 Play 앱 서명키는 그 목록에 없었다. 이 ID에 대한 소유·공유 권한을 주장할 근거가 없다. [Google의 패키지 등록 안내](https://support.google.com/googleplay/android-developer/answer/16761053?hl=ko)는 공유할 정당한 사유가 없으면 새 패키지명을 권장한다.

`com.logian.lifequest`를 Android 개발자 인증에 입력했을 때 **새 패키지**로 취급돼 공개키 지문 입력 양식이 열렸다. 현재 로컬 서명키의 공개 SHA-256 지문을 추가한 뒤 상태는 **검토 중**이었다. 이는 등록 완료가 아니다. Play의 새 앱 만들기 양식에서는 같은 ID가 `이미 계정에 등록된 패키지 이름이며 이 앱을 만드는 데 사용할 수 있습니다`로 판정됐다.

기존 Firebase 프로젝트에 `com.logian.lifequest` Android 앱을 추가하고 종전의 공개 SHA 인증서 지문을 복사했다. 9/29 Firebase Console에서 사용자가 Google API·Play Integrity API 약관 동의를 승인한 뒤 이 앱의 **App Check / Play Integrity 등록됨**을 확인했다. API에 App Check **적용(enforcement)** 을 켜거나 실제 Play 설치본의 토큰 발급을 확인한 것은 아니다. 현재 요금제는 Spark다.

Cloud Billing 계정에는 이미 **월 ₩10,000 예산 알림**이 있으며 계정 전체 알림일 뿐 지출 제한이 아니다. `Budgets & caps`의 새 예산 양식에서 *Spend cap enforcement*와 *Cloud Run Functions*가 선택 가능함을 확인했다. 하지만 Life Quest Firebase 프로젝트는 아직 이 결제 계정에 연결되지 않아 프로젝트를 선택할 수 없었고, 어떤 지출 상한도 저장하지 않았다. [Google 문서](https://docs.cloud.google.com/billing/docs/how-to/budgets-spend-caps)에 따르면 이 미리보기 상한은 단일 프로젝트·서비스에 적용되고 집행 지연의 초과 비용과 다른 서비스 비용은 남는다. Blaze 전환도 하지 않았다.

## 이전과 출시 게이트

- 앱 코드·검증 함수·Firebase Android 앱 설정을 새 ID로 일치시키고 최종 빌드를 다시 검증한다. 이전 ID의 AAB·APK 해시는 새 후보의 근거로 재사용하지 않는다.
- 기존 Play 앱 초안의 스토어 문구·스크린샷·테스트 노트는 새 앱에 자동 이전되지 않는다. 새 앱 초안 생성은 개발자 프로그램 정책 준수 확인 및 미국 수출법 동의에 대한 사용자 답변 뒤 진행한다.
- 이전 공개 GitHub APK는 다른 패키지이므로 새 앱으로 제자리 업데이트할 수 없다. 동일 Firebase 프로젝트에서 로그인 데이터가 이어지는지는 실제 검증 전 단정하지 않는다.
- 새 Play 앱의 앱 서명 인증서는 첫 바이너리 업로드 후 확인해 Android 인증·Firebase에 추가해야 할 수 있다. Android 인증의 `검토 중`이 `등록됨`으로 바뀌는지 확인한다.
- 새 AAB의 Play 업로드·비공개 테스트 배포는 사용자의 다음 명시적 `배포해` 지시 전까지 하지 않는다.

기존 `com.lifequest.app`의 임시 인증 레코드와 Play 초안은 이 문서 작성 시 삭제하지 않았다. 이 문서는 계정 화면의 관찰 사실과 이전 작업을 구분한다.
