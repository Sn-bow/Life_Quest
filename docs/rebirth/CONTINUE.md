# Life Quest 재개 체크포인트 · 2026-09-28

이 문서는 현재 상태만 기록한다. 이전 판단과 해시는 Git 이력과 각 QA 문서에 있다. 다음 작업 전 git status, [유료 후보](market/PAID_RELEASE_CANDIDATE_20260928.md), [Play 초안](store/PLAY_CONSOLE_DRAFT_STATUS_20260928.md), [게임 범위](market/GAME_SCOPE_DECISION_20260928.md)를 확인한다. 사용량 하한은 사용자가 승인한 **잔여 20%**이며 매번 다시 조회한다. Obsidian 요청이 없으면 개인 Vault에 접근하지 않는다.

## 사용자 결정과 제품 범위

- Life Quest는 현대 판타지 작품의 **내 상태창을 열어 보는 느낌**을 현실 퀘스트와 성장 기록에 연결한다. 첫 화면은 상태창이며 하단 핵심 이동은 상태창 → 현실 퀘스트 → 성장 기록이다. 특정 웹툰의 그림·명칭·서사를 복제하지 않는다.
- [카드 탐험 범위 결정](market/GAME_SCOPE_DECISION_20260928.md): 새 전투·몬스터·카드 콘텐츠의 유지율/매출 효과를 입증한 자료가 없다. 이번 후보는 탐험·전투·상점·몬스터 업적 진입과 신규 게임 재화 보상을 숨긴다. **이전 저장 데이터와 획득한 레벨은 보존**하며 새 게임 콘텐츠는 보류한다. 집중 타이머와 스킬 업적도 일부 XP를 줄 수 있으므로 캐릭터 레벨을 퀘스트 완료만의 수치로 설명하지 않는다.
- 무료 핵심은 상태창, 현실 퀘스트, 기록, 기기 백업 및 선택적 온디바이스 AI다. status_window_plus_01은 외관 3종, 기록 기반 30/90일 보고서, PNG/TXT/CSV 저장을 묶은 **비소모성 일회 구매 후보**다. 가격·구매 전환·흑자는 아직 가설이다. [벤치마크](market/STATUS_PACK_BENCHMARK_20260928.md)와 [단위 경제성](market/UNIT_ECONOMICS_20260928.md)을 구분해서 읽는다.
- 이미지 요소는 ImageGen 래스터나 권리 확인된 공개 자료를 쓴다. 수제 SVG/HTML/Canvas 그림을 추가하지 않는다. 일본어·영어·한국어·대만 번체를 우선한다.
- 다음 사용자의 명시적 **“배포해”** 요청 전에는 유료 후보의 AAB 업로드·테스트 트랙 배포를 하지 않는다. 기존 무료 GitHub APK/사이트 공개는 별개다.

## 앱과 로컬 검증

- 저장소 /Users/jeonghyeonseok/Documents/ChatGPT/Life_Quest, 브랜치 codex/rebirth-2026-09, [draft PR #2](https://github.com/Sn-bow/Life_Quest/pull/2). Flutter/Dart/Android 빌드·테스트는 같은 checkout에서 직렬 실행한다.
- Android `com.lifequest.app`, `2.0.0+2013`; signed AAB `build/review/life-quest-2.0.0-2013-paid-candidate.aab`, SHA-256 `2b1b57e3f7ec81095e6668837262046328724080257c9c2d13dcd4a7e6909c24`, **156,043,538 bytes**. **Android 바이너리 소스 커밋 `bb33b4b`**. Cloud/Billing on, Ads/QA preview off. 선택 AI 모델은 AAB에서 별도 설치한다. 이 파일은 Play에 업로드하지 않았다.
- [실제 AAB 검사](paid-candidate-2013-inspection.json): 패키지·versionCode2013·target API36·서명·결제 권한·광고 ID/Ads 부재·Firebase 설정·16KB ELF/ZIP 등 **54/54 로컬 검사 통과**. ARM64/API35/16KB 표본 다운로드 **65,331,385 bytes**. 검사용 split APK는 debug 서명이며 배포용이 아니다.
- signed QA APK `build/review/life-quest-2.0.0-2013-paid-review.apk`, SHA-256 `fcd2b191b673683be34059c2e4e0c3db39d4f6bf95323140deceee56af367bf6`, **163,188,472 bytes**. 이 APK로 네 언어 퀘스트 화면을 실제 Android 에뮬레이터에서 재촬영했다. 이 APK는 Play 제출용 AAB가 아니다.
- 소스 기준 `flutter analyze` clean, 전체 Flutter **512 통과/1 의도적 skip**, Cloud/Billing on 관련 테스트 **38 통과**. 문서 테스트는 최신 실행에서 **20 통과**했다. 앞선 범위에서 실행한 서버 정책 **49 통과**, Firestore/Storage emulator **11 통과**, Python 릴리스 권한 **2 통과**는 운영 배포 검증이 아니다. 실제 Play 결제·환불, 물리 기기 성능/온디바이스 모델, 장기 사용/유료 수요를 증명하지 않는다.
- [Console에 저장된 네 언어 캡처](design/status-system/qa/LOCALIZED_STORE_SCREENSHOTS_20260928.md)는 이전 APK(소스 `e6dd1ea`)에서 촬영했다. [현 후보 Android QA](design/status-system/qa/PAID_SCOPE_QUEST_SCREENSHOT_QA_20260928.md)에서 퀘스트 4장 모두 `+10 XP`만 표시하고 Gold가 없으며 새 APK 화면과 카드 영역 RGB 평균차가 0.013–0.017/255임을 확인했다. 따라서 이미지 교체 근거는 없다. [이전 APK의 프로필 보존 QA](design/status-system/qa/POST_XP_APK_QA_20260928.md)는 현 바이너리의 데이터 보존 검증으로 간주하지 않는다.

## 외부 상태

- [무료 GitHub APK](https://github.com/Sn-bow/Life_Quest/releases/tag/v2.0.0-preview.1)와 [안내 사이트](https://sn-bow.github.io/Life_Quest/)는 공개됐다. **무료 이전 버전이며 Play 출시·유료 후보 설치·매출이 아니다.** 다운로드에 자체 검증이 섞여 있으므로 수요로 세지 않는다.
- Google Play는 사용자 지정 계정 hyeonseok460의 Log_Ian, 앱 ID 4972166589004992203, 패키지 com.lifequest.app이다. 상태는 임시, 설치 사용자 0. 네 언어 스토어 문구와 각 언어의 이전 APK 실화면 스크린샷 2장, 기본 아이콘/피처 그래픽을 Console 초안에 저장했다. 이전 퀘스트 화면은 현 후보와 시각 동일함을 확인해 교체할 필요가 없다. 생성 이미지 라벨은 아이콘/피처 그래픽에만 지정하고 실제 Android 캡처 8장은 제외했다. 등록정보는 **검토를 위해 전송 준비 완료**로 표시됐지만 심사 전송·AAB/트랙/상품/판매자 프로필 등록은 하지 않았다. 옵트인 링크도 없다. [Play 초안 기록](store/PLAY_CONSOLE_DRAFT_STATUS_20260928.md)에 Console 오류도 기록한다.
- 신규 개인 Google Play 계정의 프로덕션 접근은 [공식 12명·14일 비공개 테스트 요건](https://support.google.com/googleplay/android-developer/answer/14151465?hl=en)을 따른다. 가짜 참여로 대체하지 않는다. 테스트 링크가 생기면 [모집안](CLOSED_TEST_RECRUITMENT_KIT_20260928.md)을 사용할 수 있다.
- Firebase 프로젝트 lifequest-crossing-2026은 hyeonseok460 계정 아래 있다. Spark, Firestore 서울과 인증 구성 일부는 준비됐지만 **Blaze/Storage/App Check/Functions/운영 규칙/RTDN/실구매 검증은 미완료**다. 비용 청구 프로필과 약관을 임의 선택하지 않는다. [계정 감사](market/PREDEPLOY_ACCOUNT_AUDIT_20260928.md), [데이터 보안 초안](store/PAID_DATA_SAFETY_DRAFT_20260928.md), [비공개 테스트 절차](CLOSED_TEST.md)를 참조한다.
- 공개 개인정보 안내는 무료판과 미배포 유료 후보를 구분한다. 후보가 첫 실행 시 Firebase/App Check·Play 상품 조회로 연결 정보/무결성 신호를 처리할 수 있음을 [사이트 QA](market/PRELAUNCH_SITE_QA_20260928.md)에 따라 공개 페이지에 반영했다. **기기 퀘스트/AI 입력은 초기화만으로 자동 업로드되지 않는다.**

## 다음 작업

1. 최신 signed QA APK에서 네 언어 퀘스트 화면을 확인했다. 성장 기록·Plus 동선과 게임 진입/보상 숨김의 Android 현장 검증은 별도로 마무리한다.
2. 반복되는 Play 스토어 설정·앱 콘텐츠 오류를 해결하거나 Console 장애로 기록한다. 실제 접근 화면에 맞춰 IARC·앱 분류·광고·데이터 보안 선언을 재검토한다.
3. 유료 테스트 전 판매자·상품·Firebase Blaze/운영 인프라 선택과 실제 구매→복원→취소/환불 검증이 필요하다. 테스터 참여와 실결제 수요는 앱 코드나 경쟁사 설치 수치로 대체할 수 없다.
4. 다음 명시적 배포 지시가 있을 때 최종 스토어 자산·AAB·운영 상태를 재확인하고 비공개 트랙 절차를 진행한다.
