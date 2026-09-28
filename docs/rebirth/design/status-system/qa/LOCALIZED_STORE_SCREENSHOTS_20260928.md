# 최종 QA APK의 4개 언어 Android 실화면

2026-09-28 촬영. 대상은 `com.lifequest.app` `2.0.0+2013`의 signed QA APK `build/review/life-quest-2.0.0-2013-paid-review.apk` (SHA-256 `beabedbc176642d83fa8e8b80baeeec8429420a3a608bf9e27e8229fffa1ec90`, 빌드 소스 `e6dd1ea`)이다. `adb shell dumpsys package`에서 실행 기기의 versionCode `2013`, versionName `2.0.0`을 읽어 확인했다. 이후 소스 변경이 해당 화면에 영향을 주면 재촬영해야 한다.

기기는 기존 `LifeQuest_API35_16KB` AVD(Android 15/API 35, 420dpi, 1080×1920)다. Android Studio **Running Devices**에서 CUA로 Android 화면의 사용자 전환·앱 실행·언어 선택·탭 이동을 했다. IDE의 **Take Screenshot**으로 원본 PNG를 저장했다. PNG를 `sips`로 **형식만** 변환해 Play용 JPEG를 만들었다. 8장의 JPEG 모두 `file`과 `sips`에서 1080×1920, RGB 3채널, 알파 없음으로 확인했다. 합성·문구 덧씌우기·SVG/HTML 목업은 하지 않았다.

AVD의 소유자(user 0)에는 이전 QA의 `85 / 150 XP`가 있었다. 이를 수정하거나 삭제하지 않고, 이미 존재하는 분리된 `Life` 사용자(user 10)로 Android UI에서 전환했다. 이 사용자에서 앱의 실제 첫 상태창 `Lv. 1`, `0 / 150 XP`, 기본 칭호, 미배분 포인트 `0`을 확인했다. 앱 설정에서 언어만 일본어 → 영어 → 한국어 → `繁體中文（台灣）` → 일본어로 바꿨다. 퀘스트를 수락·완료하지 않았으므로 0 XP가 유지됐다. 아래 퀘스트 화면의 3개 제안은 앱의 **기본 추천**이며 AI가 실시간 생성한 예시라고 표시하지 않는다.

| 스토어 언어 | 상태창 원본 / Play용 JPEG | 기본 추천 퀘스트 원본 / Play용 JPEG | 실화면에서 확인한 문구 |
|---|---|---|---|
| ja-JP | [PNG](android-2013-status-ja-final-fresh0.png) / [JPEG](android-2013-status-ja-final-fresh0.jpg) | [PNG](android-2013-quests-ja-final-fresh0.png) / [JPEG](android-2013-quests-ja-final-fresh0.jpg) | `記録者`, `新芽の冒険者`, `今日のおすすめ`; 5분 몸풀기·배움 복기·3분 화면 휴식 |
| en-US | [PNG](android-2013-status-en-final-fresh0.png) / [JPEG](android-2013-status-en-final-fresh0.jpg) | [PNG](android-2013-quests-en-final-fresh0.png) / [JPEG](android-2013-quests-en-final-fresh0.jpg) | `Chronicler`, `Sprout Adventurer`, `Your daily quests`; stretch·recall·screen break |
| ko-KR | [PNG](android-2013-status-ko-final-fresh0.png) / [JPEG](android-2013-status-ko-final-fresh0.jpg) | [PNG](android-2013-quests-ko-final-fresh0.png) / [JPEG](android-2013-quests-ko-final-fresh0.jpg) | `기록자`, `새싹 모험가`, `오늘의 추천`; 몸풀기·배움 복기·화면 휴식 |
| zh-TW | [PNG](android-2013-status-zh-tw-final-fresh0.png) / [JPEG](android-2013-status-zh-tw-final-fresh0.jpg) | [PNG](android-2013-quests-zh-tw-final-fresh0.png) / [JPEG](android-2013-quests-zh-tw-final-fresh0.jpg) | `記錄者`, `嫩芽冒險者`, `今日推薦`; 活動身體·回顧所學·離開螢幕 |

상태창 첫 화면에서는 밝은 프레임 전체, 4개 능력치, `PLUS` 진입, 3개 하단 탭이 잘림 없이 보였다. 추천 퀘스트 첫 화면에서는 카드 3장과 수락용 `+` 버튼, 분 단위와 `+10 XP`를 확인했다. 화면 아래 이어지는 콘텐츠는 스크롤 영역에 있어 첫 뷰포트에 포함되지 않는다. 이 촬영은 화면·번역·스토어 이미지 자료의 검증일 뿐, Play 업로드·결제 거래·물리 기기 QA·AI 생성 검증은 아니다.
