# Google Play 제출 정보 감사 — 2026-09-28

대상은 `com.lifequest.app` **2.0.0+2013 유료 비공개 테스트 후보**다. signed AAB SHA-256은 `be65f4e7751d4f82c0e7b845da09eb20415f5a76bf1a472d048a16e2d58864ab`이고 [로컬 검사](../paid-candidate-2013-inspection.json)는 54개 항목을 통과했다. 이전 +12 AAB는 이력이다. 로컬 코드·4개 언어 등록정보 초안과 공개 웹페이지를 읽고, 아래 정책 판단은 Google Play 공식 문서로 확인했다. **9/28 hyeonseok460 Play Console에서 앱은 draft·설치 사용자 0, Alpha 트랙은 버전 없음, 일회성 제품 메뉴는 판매자 계정 설정 필요로 확인했다.** 트랙 게시·상품 설정·판매는 하지 않았다. Data safety의 항목별 답안은 별도 감사에서 다룬다.

## 제출에 사용할 수 있는 초안

| 항목 | 제안 값과 근거 | 상태 |
|---|---|---|
| 제품 경계 | 무료 설치·무료 기본 상태창/퀘스트/온디바이스 AI/암호화 백업. `status_window_plus_01`은 **선택형 비소모성 일회 구매**로 외관 3종·기록 기반 30/90일 보고서·PNG/TXT/CSV 저장을 연다. XP·능력치 판매와 광고는 없다. 구매 UI에는 Play가 반환한 지역 가격을 표시한다. [결제 정책](https://support.google.com/googleplay/android-developer/answer/9858738?hl=en)은 유료 기능 및 가격을 정확히 고지하도록 한다. | 4개 언어 등록정보 초안은 이 경계를 명시. 실제 Play 상품/가격은 미확인. |
| 등록정보 언어 | [`ko-KR`](ko-KR.txt), [`en-US`](en-US.txt), [`ja-JP`](ja-JP.txt), [`zh-TW`](zh-TW.txt). 상태창을 첫 화면으로 소개하고, 돌발 퀘스트가 **앱 안에서** 나오며 푸시가 아니라는 점, AI 모델의 선택 다운로드 약 2.59GB/권장 여유공간/기기 차이를 명시한다. | 파일 초안 준비. **예전 책·유료 이야기 중심 Console 임시보관함이 자동 갱신된 것은 아님.** |
| 분류·광고 | 앱의 중심이 일상 행동 기록이라면 **앱/생산성**은 설명 가능한 분류. 카드 던전·전투 비중을 실제 화면·사용 흐름과 다시 비교한다. +2013 AAB는 Ads off이고 광고 ID/모바일 광고 구성요소가 없다는 로컬 검사 결과가 있다. [광고 선언 안내](https://support.google.com/googleplay/android-developer/answer/9859455?hl=en-GB)는 인앱 구매 제안만으로 `Contains ads`가 되지는 않는다고 구분한다. | Console의 종류·태그·광고 답변과 실제 활성 AAB 재대조 필요. |
| 앱 접근 | 가입 없이 무료 핵심을 사용할 수 있지만 Plus 구매/복원에는 Google 구매 계정과 Play Billing이 필요하다. [앱 접근 안내](https://support.google.com/googleplay/android-developer/answer/9859455?hl=en-GB)는 인증·멤버십 등으로 제한된 부분의 심사 접근 정보를 요구한다. | 예전 “전체 또는 일부 기능 제한” 초안을 그대로 쓰지 말고 무료 경로와 유료 경로를 정확히 설명; 필요시 심사용 접근 수단을 Console에 제공. |
| AI 생성 | 퀘스트 문구를 선택형 온디바이스 모델로 생성한다. 앱에서 AI 제안을 표시하고 신고 버튼 및 검토 후 전송 흐름이 코드에 있다. [AI 콘텐츠 정책](https://support.google.com/googleplay/android-developer/answer/13985936?hl=en)은 적용 대상 앱의 인앱 신고/표시 수단을 요구한다. [적용 범위 도움말](https://support.google.com/googleplay/android-developer/answer/14094294?hl=en)은 기존 생산성 기능을 AI로 개선하는 앱을 현재 정책 의도 밖의 예로도 든다. **Life Quest의 최종 정책 분류를 단정하지 않고, 신고 경로를 유지한다.** | 실제 신고 Functions·App Check 운영과 제출 빌드에서의 접수 확인 필요. |
| 이미지 자산 | 새 아이콘·피처 그래픽과 상태창 장식에 생성 이미지가 쓰였다. [Play AI 자산 선언](https://support.google.com/googleplay/android-developer/answer/17262077?hl=en)은 **업로드 자산마다** AI 생성/편집 해당 여부를 자가 신고하도록 안내한다. | 원본 생성 그래픽은 해당 여부를 표시. 실제 화면 캡처도 각 자산을 검토. 생성 홍보 이미지를 앱 스크린샷으로 제출하지 말 것. |
| 개인정보·삭제 URL | 사이트 소스에 `#privacy`와 `#delete-account` 섹션 및 이메일 삭제 신청 경로가 있다. 계정이 선택 사항이어도 앱에서 만들 수 있다면 인앱 삭제 경로와 앱 밖의 삭제 신청 URL이 모두 필요하다. [계정 삭제 요건](https://support.google.com/googleplay/android-developer/answer/13327111?hl=en). | 제출 시 공개 URL의 **현재 게시본**과 앱 내 연결 경로가 같은 버전의 실제 데이터 처리를 설명하는지 확인. 삭제 필드에는 `https://sn-bow.github.io/Life_Quest/#delete-account`처럼 직접 링크 권장. |
| 스크린샷 | [미리보기 자산 지침](https://support.google.com/googleplay/android-developer/answer/9866151?hl=en-GB)은 휴대전화 화면 2장 이상과 실제 앱 경험을 보여주는 캡처를 요구한다. | 최종 `e6dd1ea` signed APK를 Android API35/420dpi 에뮬레이터에서 촬영한 일본어 [상태창](../design/status-system/qa/android-2013-status-ja-final-owner85.jpg)·[현실 퀘스트](../design/status-system/qa/android-2013-quest-recommendations-ja-final-owner85.jpg) 1080×1920 RGB JPEG 두 장을 확보했다. 상태창의 `85 / 150 XP`는 내부 QA 완료 기록이며 실제 사용자 성과가 아니다. 기존 브라우저 목업·일러스트·내부 390×844 QA 캡처를 제출본으로 대체하지 말 것. |

## 실제 Console에서 다시 답할 선언

1. **IARC 콘텐츠 등급을 새 빌드 기준으로 재응답.** 과거 문서에는 이전 선언 완료 표시만 있다. 현재 `lib/screens/dungeon/card_battle_screen.dart`, `lib/screens/hunt_screen.dart`, `lib/screens/dungeon/dungeon_result_screen.dart`에 적 공격/HP/몬스터 처치·승패가 있으므로 전투 및 판타지 폭력 여부를 화면 그대로 답한다. 서사 속 연습용 검 등도 실제 표현을 확인한다. 도박/현금성 랜덤 상품이 있다고 추정하지 않는다. [IARC 질문지 안내](https://support.google.com/googleplay/android-developer/answer/9859655?hl=en-GB)는 정확한 응답을 요구하며, 등급은 국가별 기관이 결정한다. 이 문서가 등급을 미리 지정하지 않는다.
2. **타깃 연령을 개인정보 방침과 일치시킬 것.** 사이트는 만 14세 미만을 대상으로 하지 않는다고 쓴다. Play의 `13–15` 그룹을 선택하면 13세도 대상에 넣는 셈이므로 현 문구와 충돌한다. **16–17 및 18+**가 현재 문구와 더 일치하는 출발점이지만, 실제 마케팅 자산·기능·법적 대상과 함께 결정한다. 미성년자 그룹을 선택하면 관련 [타깃 연령·Families 안내](https://support.google.com/googleplay/android-developer/answer/9867159?hl=en)를 검토해야 한다.
3. **광고, 앱 접근, 개인정보처리방침, 계정 삭제 링크, Data safety, 기타 `Needs attention`을 같은 AAB 기준으로 재확인.** 이전 9/21의 `9/11 완료` 표시는 새 버전의 승인 근거가 아니다. 정확한 선언 항목은 Console이 표시하는 [앱 콘텐츠 화면](https://support.google.com/googleplay/android-developer/answer/9859455?hl=en-GB)을 따른다.

## 제출 전에 바로잡을 불일치

- **공개 정책 페이지 갱신 완료, 제출 시 재확인 필요.** 9/28 `https://sn-bow.github.io/Life_Quest/`의 새 게시본 HTTP 200과 상태창 실제 화면 JPEG의 해시 일치를 확인했다. 공개 HTML에는 무료 APK와 미배포 +2013 후보의 차이, `#privacy`·`#delete-account`·`#privacy-ja`·`#delete-account-ja`가 포함된다. Play 제출 직전 URL이 계속 열리는지와 실제 활성 기능에 맞는지 다시 확인한다.
- **Console 등록정보 초안은 예전 제품을 설명한다.** `STORE_AND_TEST_PLAN.md`와 `CLOSED_TEST.md`에 기록된 Console 초안은 책/이야기와 v7 무료 후보 중심이다. 4개 언어 최종 텍스트, 아이콘, 피처 그래픽, 실제 2.0.0+2013 스크린샷을 Console에서 저장·재열람해 일치시켜야 한다. 현지 가격이 아직 Play 상품에 설정되지 않았으므로 특정 가격을 외부 문구에 확정가로 쓰지 않는다.
- **기존 앱 접근 설명은 무료 경로와 유료 경로를 혼동할 수 있다.** 무료 앱 이용에 계정이 필요한 것처럼 쓰거나, 반대로 모든 기능이 가입 없이 열리는 것처럼 선언하면 모두 실제 동작과 다르다. Plus의 인증/구매 제한과 심사 방법을 따로 적는다.
- **일본어 개인정보 안내가 공개됐다.** `docs/index.html`의 구매 계정·선택적 기존 클라우드 동기화·AI 신고·삭제 및 2.59GB 외부 다운로드에 관한 일본어 본문이 9/28 공개 HTML에 있고, `#privacy-ja`·`#delete-account-ja`를 확인했다. 이는 **Play의 언어별 전체 번역 의무**를 입증한다는 뜻은 아니다. 일본 대상 제출 직전 공개 URL의 표시·링크를 다시 확인한다.
- **현재 제출 완료 판단은 불가하다.** Play Console의 draft·Alpha 무버전·판매자 계정 미설정, Firebase Spark·App Check 미등록을 9/28 확인했다. 판매자 프로필 양식은 기존 개인 결제 프로필 재사용이 가능하지만 공개 업체명·지원 이메일·명세서 이름 및 개발자·결제 약관 동의가 필요해 제출하지 않았다. 실제 Play 라이선스 거래도 없다. 정확한 상태와 배포 순서는 [`PREDEPLOY_ACCOUNT_AUDIT_20260928.md`](../market/PREDEPLOY_ACCOUNT_AUDIT_20260928.md), [`PAID_RELEASE_CANDIDATE_20260928.md`](../market/PAID_RELEASE_CANDIDATE_20260928.md)를 따른다.
