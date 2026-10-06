# 유료 출시 범위 조정 후 Android 퀘스트 화면 QA

2026-09-28. 대상은 `com.lifequest.app` `2.0.0+2013`의 signed QA APK `build/review/life-quest-2.0.0-2013-paid-review.apk`이다. APK SHA-256은 `fcd2b191b673683be34059c2e4e0c3db39d4f6bf95323140deceee56af367bf6`, 앱 소스 HEAD는 `bb33b4b`였다. 에뮬레이터의 설치 패키지에서 `versionCode=2013`, `versionName=2.0.0`을 확인했다.

기기는 `LifeQuest_API35_16KB` AVD(Android 15/API 35, 420dpi, 1080×1920)이다. 기존 `Life` Android 사용자(user 10)에서 새 앱을 실행했고, 상태창의 `Lv. 1`, `0 / 150 XP`를 촬영 전후 확인했다. 앱 설정에서 언어만 일본어 → 영어 → 한국어 → 번체 중국어(대만)로 바꿨다. 퀘스트 수락·완료는 하지 않았다. Android SDK `adb exec-out screencap -p`로 실제 에뮬레이터 화면을 원본 PNG로 저장했고, `sips`로 JPEG 형식만 변환했다. 파일 편집·합성·문구 덧씌우기는 하지 않았다. 이 테스트 환경에서 CUA가 에뮬레이터 창에 입력을 전달하지 못해, 승인된 공식 SDK `adb shell input`으로 탭 이동과 언어 선택을 했다.

| 언어 | 새 APK 화면 PNG / JPEG | 확인한 기본 추천 보상 |
|---|---|---|
| ja-JP | [PNG](android-2013-quests-ja-paid-scope-fresh0.png) / [JPEG](android-2013-quests-ja-paid-scope-fresh0.jpg) | 3개 카드 모두 `+10 XP`; Gold 없음 |
| en-US | [PNG](android-2013-quests-en-paid-scope-fresh0.png) / [JPEG](android-2013-quests-en-paid-scope-fresh0.jpg) | 3개 카드 모두 `+10 XP`; Gold 없음 |
| ko-KR | [PNG](android-2013-quests-ko-paid-scope-fresh0.png) / [JPEG](android-2013-quests-ko-paid-scope-fresh0.jpg) | 3개 카드 모두 `+10 XP`; Gold 없음 |
| zh-TW | [PNG](android-2013-quests-zh-tw-paid-scope-fresh0.png) / [JPEG](android-2013-quests-zh-tw-paid-scope-fresh0.jpg) | 3개 카드 모두 `+10 XP`; Gold 없음 |

기존 [4언어 제출용 화면](LOCALIZED_STORE_SCREENSHOTS_20260928.md)의 `android-2013-quests-*-final-fresh0.jpg`와 새 JPEG를 직접 비교했다. 퀘스트 카드 영역(x=110–970, y=760–1550)의 RGB 채널별 평균 절대 픽셀 차이는 언어별 모두 `0.013–0.017`(8비트 0–255 범위)로, 내용이 사실상 동일하다. 기존 JPEG 역시 카드 보상이 `+10 XP`이고 Gold 문구가 없었다. 따라서 “기존 스토어용 퀘스트 이미지에 +Gold가 보인다”는 초기 진단은 이 네 파일에는 맞지 않으며, 해당 이미지의 교체 근거가 없다.

일본어 기존 상태창 PNG와 새 APK의 상태창을 육안 비교했고, 번체 중국어 새 상태창에서도 기존과 같은 `Lv. 1`, `0 / 150 XP`, 4개 능력치, `PLUS`, 탭 구성을 확인했다. 시간·Android 시스템 아이콘은 달라질 수 있다. 상태창 화면의 변경은 발견하지 않아 새 제출용 상태창 파일은 만들지 않았다. 320dp/200% 글꼴 배율 및 태블릿 실기기·에뮬레이터 레이아웃은 이번 캡처에서 추가 확인하지 않았다.
