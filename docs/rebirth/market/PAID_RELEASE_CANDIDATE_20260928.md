# Life Quest 유료 비공개 테스트 후보 · 2026-09-28

## 제품과 수익 판단

첫 화면은 사용자의 이름·레벨·XP·네 능력치·칭호가 보이는 상태창이다. 퀘스트, 기본 외관, 보상, 원본 기록 열람과 암호화 백업은 무료다. 선택 상품 `status_window_plus_01`은 **비소모성 일회 구매**로 생성 이미지 기반 상태창 외관 3종, 저장된 완료 내역의 30/90일 보고서, PNG·TXT·CSV 저장을 한 권한에 묶는다. 능력치·XP 이득, AI 사용권, 구독은 판매하지 않는다. 구매 화면은 Play가 반환한 현지 가격만 표시하며 가격 조회가 실패하면 구매 버튼을 열지 않는다. 기록이 없는 기간은 임의의 0으로 채우지 않고 미관측으로 표시한다.

[게임 범위 재검토](GAME_SCOPE_DECISION_20260928.md)에서 카드 전투의 유지율·구매 효과를 뒷받침할 자료를 찾지 못했다. 따라서 핵심 하단 이동은 상태창·현실 퀘스트·성장 기록의 3탭으로 유지하고, 이미 구현된 탐험은 선택형 보조 화면에서 접근하도록 한다. 새 전투 콘텐츠는 초기 출시 범위에 추가하지 않는다. 캐릭터 XP에는 기존 탐험 보상도 포함되므로 이를 모두 현실 퀘스트 성과라고 설명하지 않는다.

[8개 경쟁 앱/17개 공식 페이지 비교](STATUS_PACK_BENCHMARK_20260928.md)는 RPG 생산성 앱의 일회 구매 사례와 이 범주의 경쟁 강도를 확인했다. 특히 Taskoria의 무료 4능력치·기본 통계 때문에 단순 상태창/XP만으로는 판매 차별화가 약하다. **사용자 자신의 기록을 읽기 쉬운 아카이브로 만드는 기능**이 이 상품의 가설이다. 한국 ₩4,900, 일본 ¥600, 미국 $3.99, 대만 NT$120은 내부 가격 시험점이며 Play 설정값도, 지불 의사 검증 결과도 아니다. 구매자 수·환불률·지원/서버 비용·실제 정산액이 없으므로 흑자나 바이럴을 보장할 근거는 없다. 그러나 무료 핵심을 유지한 채 기능 범위와 일회 구매 약속이 명확해, **실거래로 수요를 검증할 수 있는 상품 형태**까지는 도달했다. 테스트용 구매는 매출로 세지 않는다.

## 검증한 로컬 출시 후보 · 2.0.0+2013

**후속 서버 감사(2026-09-28):** Android 소스와 자산은 변경되지 않아 아래 AAB 해시가 그대로다. 서버 코드에서 잘못된 RTDN 입력, 대기 구매 취소 선행, RTDN 누락 시 Voided Purchases API의 최근 28일 중복 조회로 완전 환불 권한을 철회하는 경로를 보강했다. 구매 전용 계정은 Storage 프로필 사진 업로드를 할 수 없게 했다. Node 정책 **49 통과**, Firestore/Storage 에뮬레이터 **11 통과**, 프로덕션 의존성 감사 0건이다. 이 기능과 규칙은 **운영 배포/실거래 미검증**이며, Blaze·Cloud Scheduler 비용/권한·Play `View financial reports` 권한이 필요하다. API는 최근 30일까지만 조회하므로 스케줄러 장기 중단은 별도 감시가 필요하다. [Google Voided Purchases 안내](https://developers.google.com/android-publisher/voided-purchases)를 따른다.

- Android `com.lifequest.app`, `2.0.0+2013`: `build/review/life-quest-2.0.0-2013-paid-candidate.aab`. SHA-256 `be65f4e7751d4f82c0e7b845da09eb20415f5a76bf1a472d048a16e2d58864ab`, 242,279,230bytes, 소스 커밋 `e6dd1ea`. 상태창 중심 일회 구매, Cloud/Billing on, Ads/QA preview off. 선택 AI 모델은 AAB에 넣지 않고 별도 선택 다운로드한다.
- [실제 +2013 AAB 검사](../paid-candidate-2013-inspection.json): 패키지·versionCode2013·target API36·공개 업로드 인증서·결제 권한·광고 ID 및 Mobile Ads 부재·Firebase 자동 초기화 제거·Crashlytics/Analytics 수집 off·네이티브 ELF와 표본 split ZIP 16KB 정렬을 통과했다. ARM64/API35/16KB 표본 다운로드는 149,179,287bytes. 검사용 split은 업로드 파일이 아니다.
- +2013 현재 소스 기준 `flutter analyze --no-pub` clean, 전체 Flutter **508 통과/1 의도적 skip**, Cloud/Billing on **41 통과**, Node 서버 정책 **42 통과**, Python 릴리스 권한 검사 **2 통과**. 모두 로컬 검증이며 Android 에뮬레이터 UI 확인과 별개로 물리 기기 또는 Play 구매를 대신하지 않는다.

## 이전 2.0.0+12 로컬 검증 기록

- Android `com.lifequest.app`, `2.0.0+12`: `build/review/life-quest-2.0.0-12-paid-candidate.aab`. SHA-256 `4d1eb1f7a987fa5858cbd081ad5f1802db060b01a71a7ac5fe208300f5b3de88`, 242,187,233 bytes. 표본 ARM64/API35/16KB 기기 예상 다운로드 149,169,238 bytes. Cloud/Billing on, Ads/QA preview off.
- [당시 AAB 검사 결과](../paid-candidate-12-inspection.json): 실제 +12 AAB의 패키지·versionCode·API36·서명·결제 권한·광고 ID 부재·네이티브 ELF 및 표본 split ZIP 16KB 정렬을 모두 통과했다. 표본 split은 **검사용 debug 서명**이라 제출하지 않는다. +12 산출물은 새 제출 대상이 아니다.
- 당시 `flutter analyze --no-pub`: 문제 없음. Flutter 전체 **475 통과/1 의도적 skip**. Cloud/Billing on 상품 조회 실패·재시도 테스트 별도 1 통과. Node 서버 정책 **42 통과**. Firestore/Storage 에뮬레이터 규칙 **10 통과**. 생산 의존성 `npm audit --omit=dev --audit-level=high` 취약점 0건. 이 결과는 +2013이나 실제 Play 구매를 대신하지 않는다.
- [Play 4개 언어 문구](../store/ja-JP.txt), [번체 중국어 QA](TAIWAN_LOCALE_QA_20260928.md), [생성 자산 기록](../store/STATUS_WINDOW_VISUALS_20260928.md), [마케팅 페이지 사전 점검](PRELAUNCH_SITE_QA_20260928.md)을 준비했다. 9/28 수정 사이트가 `gh-pages`에 게시됐고 공개 개인정보/삭제 앵커와 실제 Android 상태창 JPEG를 HTTP 200으로 확인했다.

## 배포 요청에서 실행할 운영 순서

1. 사용자가 지정한 **hyeonseok460 계정**의 Play Console과 Firebase 프로젝트 `lifequest-crossing-2026`를 확인한다. [계정 감사](PREDEPLOY_ACCOUNT_AUDIT_20260928.md)의 9/21 Play 상태를 현재 상태로 오인하지 않는다.
2. 판매자 프로필·Play 앱·국가/언어·상품 `status_window_plus_01`의 일회 구매 옵션과 실제 지역 가격을 확인/구성한다. Firebase Blaze 비용 한도와 Auth/App Check, Functions, Firestore/Storage 규칙, Play Developer API 권한, RTDN 및 비공개 acknowledgment 작업 큐를 실제 운영 환경에 연결한다.
3. 새 +2013 signed AAB를 검증한 뒤 비공개 트랙에 제출하고 앱 설치본에서 라이선스 구매→서버 검증→권한 해제→재설치 복원→취소·환불·권한 회수, 계정 전환, 서버 장애 재시도를 확인한다. **실제 라이선스 거래가 통과하기 전 유료 판매 완료라고 표시하지 않는다.**
4. Play가 요구하는 비공개 테스트 참여 링크를 받은 뒤 실제 테스터를 모집한다. 생산 접근 제한이 남아 있다면 실제 12명 이상 연속 14일 opt-in 후 신청·심사를 진행한다. 직접 APK 설치, 이메일 목록 등록, 합성 테스트는 참여로 계산하지 않는다.
5. [Android 시각 QA](../design/status-system/FINAL_VISUAL_QA_20260928.md)에서 최종 APK의 일본어 실제 앱 스크린샷 1080×1920 RGB JPEG 두 장(상태창·현실 퀘스트)을 확보했다. 국가별 등록정보의 최종 선정과 다른 언어/태블릿 자산은 제출 때 확인한다. 기존 390×844 내부 캡처는 Play 비율 요건을 넘으며, 생성 일러스트를 앱 스크린샷으로 제시하지 않는다.

**판정:** +2013의 코드·현지화·서명 산출물에 대한 위 로컬 검증을 통과했다. Play/Firebase 결제 운영 설정, 물리 Android 기기와 구매·환불, 플랫폼 심사는 아직 실행한 사실이 없으므로 유료 판매 가능성이나 이익은 실증되지 않았다. 이번 요청 범위에 따라 업로드·백엔드 배포·상품 활성화는 하지 않았다.
