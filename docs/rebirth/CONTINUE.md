# Life Quest 재개 체크포인트 · 2026-09-29

이 문서는 **현재 Android 패키지 `com.logian.lifequest`**의 출시 전 상태다. 이전 `com.lifequest.app` 빌드·Play 초안은 [패키지 이전 기록](store/PACKAGE_MIGRATION_20260929.md)의 이력이며, 해시나 검증 결과를 새 패키지에 재사용하지 않는다. 작업 전 `git status`를 확인하고 사용량을 다시 조회한다. 사용자 승인 하한은 **잔여 5%**다. Obsidian 요청이 없으면 개인 Vault에 접근하지 않는다.

## 제품 범위와 데이터

- 첫 화면은 개인 상태창이고 핵심 이동은 상태창 → 현실 퀘스트 → 성장 기록이다. 선택형 `status_window_plus_01`은 외관 3종, 기록 기반 30/90일 보고서, PNG/TXT/CSV 저장의 **비소모성 일회 구매 후보**다. 가격·구매 전환·흑자는 검증되지 않았다. [게임 범위 결정](market/GAME_SCOPE_DECISION_20260928.md)에 따라 탐험·전투·상점·몬스터 업적 진입과 신규 게임 재화 보상은 숨겼으며 새 게임 콘텐츠는 보류한다.
- 이전 패키지의 게임 저장 데이터는 그 앱의 이력으로 남지만, **패키지 ID가 달라 기존 설치 앱을 제자리 업데이트하거나 기기 로컬 데이터를 새 앱으로 자동 이전할 수 없다.** 동일 Firebase 프로젝트의 계정 데이터가 실제 로그인 후 이어지는지는 미검증이다. [새 패키지 Android QA](design/status-system/qa/PACKAGE_MIGRATION_ANDROID_QA_20260929.md)에서 두 앱이 별도 설치되고 새 앱이 첫 실행 화면을 표시함을 확인했다.
- 다음 명시적 **“배포해”** 요청 전에는 새 AAB를 Play에 업로드하거나 테스트 트랙을 게시하지 않는다. 기존 공개 GitHub APK와 안내 사이트는 이전 패키지의 무료 프리뷰이며 새 유료 후보의 Play 출시·매출이 아니다.

## 새 패키지 로컬 후보와 검증

- Android `com.logian.lifequest`, `2.0.0+2013`, **빌드 소스 `8a14501`**. signed AAB `build/review/life-quest-2.0.0-2013-paid-candidate.aab`: **156,033,758 bytes**, SHA-256 `a50e22b8ea3d85d8d823dccf62ab792b18b533f48646141f25d0a2153a098b8c`. Cloud/Billing on, Ads/QA preview off. 선택 AI 모델은 AAB에서 별도 설치한다. 이 AAB는 Play에 업로드하지 않았다.
- signed QA APK `build/review/life-quest-2.0.0-2013-paid-review.apk`: **163,188,472 bytes**, SHA-256 `4db8d8028e0645d03d2ca89e03e7b5143e2a54a501d07cbc36068424ec8bbddf`. APK는 Play 제출 파일이 아니다.
- [AAB 검사 JSON](paid-candidate-2013-inspection.json) **54/54 통과**: 새 패키지/versionCode2013, target API36, 결제 권한, 광고 ID·Mobile Ads 부재, 공개 업로드 인증서, ELF/표본 split ZIP 16KB 정렬. ARM64/API35/16KB 표본 다운로드는 **65,330,545 bytes**다. 표본 split은 디버그 서명의 검사 전용 파일이다.
- [실제 Android QA](design/status-system/qa/PACKAGE_MIGRATION_ANDROID_QA_20260929.md): API35/16KB 에뮬레이터에서 새 signed APK 설치·첫 실행, 기존 계정 로그인 진입, 무료 상태창, Plus 화면을 **영어·기본 배율**로 캡처했다. 온보딩의 옛 탐험 안내를 네 언어 두 진입 경로에서 성장 기록 안내로 수정했고 집중 위젯 테스트 **9개** 및 `flutter analyze --no-pub`가 통과했다. 실제 계정 인증·복구, Play 상품 조회·구매·복원, 물리 기기·태블릿은 아직 검증하지 않았다. 이전 패키지에서 실행한 전체 Flutter 518 통과/1 skip은 새 패키지 최종 전체 실행 결과가 아니다.

## Play·Firebase·판매 상태

- 이전 `com.lifequest.app` Play 임시 앱에 저장한 4언어 등록정보·스크린샷·출시 노트는 **새 앱으로 자동 이전되지 않는다**. [이전 초안 기록](store/PLAY_CONSOLE_DRAFT_STATUS_20260928.md)은 현재 출시 대상이 아니다. 새 Play 앱 생성은 개발자 프로그램 정책 준수·미국 수출법 선언에 대한 사용자 결정 뒤 진행한다. 새 앱 AAB 업로드·트랙 게시·심사 제출·테스터 opt-in 링크는 없다.
- Android 개발자 인증의 새 패키지는 9/29 공개 서명키 등록 후 **검토 중**으로 관찰됐고 등록 완료는 미확인이다. 새 Play 앱 서명 인증서는 첫 Play 바이너리 업로드 뒤 확인해야 한다. [패키지 이전 기록](store/PACKAGE_MIGRATION_20260929.md)을 따른다.
- 기존 개인 판매자 결제 프로필은 **LOGIAN** 명세서명으로 연결됐다. 지급 은행 계좌는 등록하지 않았고 Plus 상품·지역 가격도 없다. 실제 구매·복원·환불과 수익은 검증되지 않았다. [계정 감사](market/PREDEPLOY_ACCOUNT_AUDIT_20260928.md)를 참조한다.
- 기존 Firebase 프로젝트에 **새 패키지 Android 앱**을 등록하고 공개 SHA 지문과 App Check / Play Integrity provider 등록을 확인했다. **Enforcement와 실제 Play 설치본 토큰은 미검증**이다. 프로젝트의 **Blaze 연결**과 **Cloud Run Functions 월 ₩5,000 지출 상한 생성**은 Firebase Console에서 확인했다. 기존 결제 계정 전체의 월 ₩10,000 **예산 알림**도 유지 중이다. 함수 상한은 해당 서비스에만 적용되며 집행 지연 초과분과 다른 서비스 비용을 막지 못한다. 운영 Storage/Functions·구매 검증·RTDN·작업 큐·실거래는 준비 완료로 보지 않는다.

## 다음 작업

1. 현재 소스의 전체 Flutter/서버 검증과 필요한 새 패키지 Android·태블릿·계정 복구 QA를 마친다. 이전 패키지 화면은 새 앱의 직접 캡처로 표시하지 않는다.
2. 사용자 결정 후 새 Play 앱을 만들고 해당 앱의 스토어 등록정보·앱 콘텐츠·테스트 초안을 별도로 준비한다. 과거 앱의 Console 오류나 저장 상태를 새 앱의 현재값으로 간주하지 않는다.
3. Blaze 연결 뒤에도 남은 운영 인프라·비용, 지급 수단, Plus 상품·가격과 실제 라이선스 거래를 확인한다. 함수 지출 상한은 전체 프로젝트 지출 상한이 아니며 로컬 54/54 검사는 판매 가능 판정이 아니다.
4. 다음 명시적 배포 지시 때 최종 AAB·Play 등록/심사 상태를 재확인하고 비공개 테스트 절차를 진행한다.
