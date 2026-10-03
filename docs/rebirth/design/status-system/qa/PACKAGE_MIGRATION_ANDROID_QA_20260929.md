# +2013 새 Android 패키지 후보 QA — 2026-09-29

## 대상

- 빌드 소스: `8a14501` (`d7fe395` 패키지 변경과 온보딩 탐험 문구 수정 포함).
- 제출 후보 AAB: `build/review/life-quest-2.0.0-2013-paid-candidate.aab`, 156,033,758 bytes, SHA-256 `a50e22b8ea3d85d8d823dccf62ab792b18b533f48646141f25d0a2153a098b8c`.
- UI 확인용 signed universal APK: `build/review/life-quest-2.0.0-2013-paid-review.apk`, 163,188,472 bytes, SHA-256 `4db8d8028e0645d03d2ca89e03e7b5143e2a54a501d07cbc36068424ec8bbddf`. APK는 Play 제출 파일이 아니다.
- 두 빌드 모두 Cloud=true, Monetization=true, Ads=false, QA Preview=false 네 `--dart-define`으로 생성했다.

## 아티팩트 검사

[AAB 검사 JSON](../../../paid-candidate-2013-inspection.json)의 **54/54 항목 통과**: `com.logian.lifequest`, `2.0.0+2013`, target API36, BILLING 권한, 광고 ID·Mobile Ads 부재, 업로드 인증서 SHA-256 `1537d6f39ee3eed153e134128bbe661132183847ca3aa7f4b511276bfd352bb3`, 네이티브 ELF와 표본 split ZIP 16KB 정렬. ARM64/API35/16KB 표본 다운로드 크기는 65,330,545 bytes다. 표본 split은 검사 전용 디버그 서명이며 업로드 파일이 아니다.

APK는 `apksigner verify`, `aapt2 dump badging`, `zipalign -c -P 16 4`와 11개 `.so`의 ELF 정렬을 별도로 확인했다. 인증서·패키지·버전·BILLING/API36 일치, ARM64 JNI 포함, 광고 ID·Mobile Ads 구성요소·QA 진입점 부재를 확인했다.

## 실제 Android 화면

Android API35 16KB 에뮬레이터의 사용자 0에 새 패키지를 설치했다. `dumpsys package com.logian.lifequest`는 versionCode2013/versionName2.0.0을 반환했다. 기존 `com.lifequest.app`도 같은 사용자에 **별도 패키지**로 설치된 상태였고, 새 패키지는 첫 실행 안내를 표시했다. 화면은 1080×1920/420dpi, 앱 언어는 en이며 아래 PNG는 새 APK의 `screencap` 원본이다.

| 화면 | 캡처 | 확인 내용 |
| --- | --- | --- |
| 첫 실행 하단 | [PNG](paid-candidate-2013-new-package-welcome-en-1080x1920.png) | 3단계가 탐험 대신 Growth Record를 안내하고, 무료 상태창·기존 계정 진입이 보인다. |
| 기존 계정 로그인 진입 | [PNG](paid-candidate-2013-new-package-login-en-1080x1920.png) | 이메일·비밀번호 화면으로 이동한다. 실제 인증은 수행하지 않았다. |
| 무료 상태창 | [PNG](paid-candidate-2013-new-package-status-en-1080x1920.png) | Lv.1/0 XP, 네 능력치, 퀘스트·성장 기록 탭과 Plus 진입이 표시된다. |
| Plus | [PNG](paid-candidate-2013-new-package-plus-en-1080x1920.png) | 일회성 구매 설명·계정 안내가 표시된다. 이 에뮬레이터에서는 Play 상품이 로드되지 않아 가격·구매·복원은 확인하지 못했다. |

처음 발견한 온보딩의 탐험·이야기 홍보 문구는 `8a14501`에서 새 프로필과 기존 계정 경로 모두 en/ja/ko/zh-TW의 성장 기록 안내로 수정했다. 두 경로의 320px/200%를 포함한 집중 위젯 테스트 9개와 `flutter analyze --no-pub`가 통과했다. **실제 에뮬레이터 캡처는 en 한 언어와 기본 배율에 한정된다.**

패키지 변경은 기존 앱의 제자리 업데이트가 아니다. `com.lifequest.app`의 로컬 데이터가 새 패키지로 자동 이전되는지 확인하지 않았다. 실제 계정 로그인·데이터 복구, Play 상품·구매·복원, 물리 기기·태블릿은 이 QA 범위 밖이다. [이전 패키지 QA](PRIVACY_CANDIDATE_ANDROID_QA_20260929.md)의 zh-TW 화면은 새 APK의 캡처가 아니다.
