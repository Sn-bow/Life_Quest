# +2013 개인정보 수정 후보 Android QA — 2026-09-29

> 이 문서는 당시 패키지 `com.lifequest.app`에서 촬영한 이력이다. 아래 `build/review/` 경로는 촬영 시점의 경로이며, 이후 `com.logian.lifequest` 후보 빌드가 같은 파일명을 사용한다. 따라서 현재 경로의 바이너리를 아래 해시·캡처와 동일한 파일로 간주하지 않는다.

## 대상 및 아티팩트

- 빌드 시 HEAD: `99ebfc0`; 마지막 앱 코드 커밋: `d9f2cc5` (`5da4454`의 계정별 보고서 영수증 격리와 빈 주간 활동 안내 포함).
- Play 제출 후보: `build/review/life-quest-2.0.0-2013-paid-candidate.aab`, 156,033,898 bytes, SHA-256 `ae7efd7c8cb548f350a33e42ac96ec7536bfa59473a05ffe497d0324d5de66c6`.
- UI 확인용 signed universal APK: `build/review/life-quest-2.0.0-2013-paid-review.apk`, 163,188,472 bytes, SHA-256 `ce7ecdd633a420c7bfc06956f72baf877f5425226c40ea7f1f019ab9ad8bdeb1`. 이 APK는 Play 업로드 대상이 아니다.
- 두 빌드 모두 `LIFEQUEST_CLOUD_ENABLED=true`, `LIFEQUEST_MONETIZATION_ENABLED=true`, `LIFEQUEST_ADS_ENABLED=false`, `LIFEQUEST_QA_PREVIEW=false`로 생성했다.

## 바이너리 검사

[`paid-candidate-2013-inspection.json`](../../../paid-candidate-2013-inspection.json)의 AAB 검사 **54/54 통과**: `com.lifequest.app`, `2.0.0+2013`, 공개 업로드 인증서 SHA-256 `1537d6f39ee3eed153e134128bbe661132183847ca3aa7f4b511276bfd352bb3`, API 36, 결제 권한, 광고 ID 및 Mobile Ads 부재, 네이티브 ELF 및 표본 split ZIP 16KB 정렬. ARM64/API35/16KB 표본 다운로드 크기는 65,330,594 bytes다. 표본 split은 검사 전용 디버그 서명이며 제출 파일이 아니다.

APK도 같은 공개 업로드 인증서와 패키지·버전·API 36을 확인했다. `apksigner verify`, `zipalign -c -P 16 4`, 11개 네이티브 `.so`의 ELF 정렬, ARM64 JNI, 광고 ID 및 QA 진입점 부재 검사가 통과했다.

## Android 화면 확인 범위

Android API 35 16KB 에뮬레이터의 기존 앱 사용자 10에 새 APK를 설치했다. 디스플레이는 1080×1920, 420 dpi, 앱 언어는 zh-TW, 상태는 Lv.1/0 XP/완료 임무 0이었다. Android `screencap` 원본을 보존했다.

| 화면 | 실제 캡처 | 관찰 |
| --- | --- | --- |
| 상태창 | [PNG](paid-candidate-2013-privacy-status-zh-TW-1080x1920.png) | 0/150 XP, 네 능력치, Plus 진입, 하단 탭이 표시되고 겹침·잘림은 보이지 않았다. |
| Plus | [PNG](paid-candidate-2013-privacy-plus-zh-TW-1080x1920.png) | 일회성 구매 설명과 구매용 계정 안내가 표시됐다. 테스트 에뮬레이터에서 Google Play 상품을 불러오지 못해 가격·구매는 검사하지 못했다. |
| 무료 성장 보고서 상단 | [PNG](paid-candidate-2013-privacy-report-top-zh-TW-1080x1920.png) | 연속 기록·XP·완료 임무·칭호가 표시됐다. 활동이 0건일 때 큰 빈 차트 대신 중앙 안내와 ‘查看任務’ 버튼이 표시됐다. |
| 보고서 Plus 안내 | [PNG](paid-candidate-2013-privacy-report-cta-zh-TW-1080x1920.png) | 스크롤 후 30/90일 기록 설명과 Plus 안내 버튼이 표시되고 겹침·잘림은 보이지 않았다. |

수정 전 후보에서 주간 차트가 새 계정에도 300dp 빈 영역으로 표시되는 결함을 발견했다. `d9f2cc5`에서 0건이면 현지화 안내와 퀘스트 이동 버튼을 넣고, 활동이 있으면 기존 차트를 유지하도록 수정했다. en/ja/ko/zh-TW 빈 상태·활동 상태 전환/이동 위젯 테스트 4개와 기존 Plus 레이아웃 테스트 6개, `flutter analyze --no-pub`가 통과했다.

이 화면 확인은 **기본 배율 휴대전화 한 사용자**에 한정된다. 최신 APK의 320dp/200% 및 태블릿 에뮬레이터 화면은 재검사하지 않았다. 앞선 [상태창·보고서 QA](FINAL_PAID_FLOW_ANDROID_QA_20260928.md)는 별도 소스 시점의 증거다. 계정 두 개를 전환하며 영수증 격리 동작을 확인하지 않았고, 실제 결제·복원·Play 배포도 이 검사 범위에 없다.
