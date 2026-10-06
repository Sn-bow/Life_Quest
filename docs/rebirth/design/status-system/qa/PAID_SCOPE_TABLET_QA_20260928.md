# 유료 출시 범위 조정 후 태블릿 세로 화면 QA

2026-09-28. [퀘스트 화면 QA](PAID_SCOPE_QUEST_SCREENSHOT_QA_20260928.md)와 동일한 `com.lifequest.app` `2.0.0+2013` signed APK(SHA-256 `fcd2b191b673683be34059c2e4e0c3db39d4f6bf95323140deceee56af367bf6`)를 기존 `LifeQuest_API35_16KB` 에뮬레이터의 `Life` 사용자(user 10)에서 확인했다. `wm size 800x1280`, `wm density 160`으로 800×1280dp 세로 논리 화면을 만들었다. 런타임 크기 변경 직후 에뮬레이터의 프레임 버퍼가 검정으로 나와 한 번 재부팅한 후 앱 실화면을 촬영했다. 첨부한 PNG는 `adb exec-out screencap -p` 원본이며 합성·편집하지 않았다.

| 화면 | 실화면 증거 | 결과 |
|---|---|---|
| 상태창 첫 뷰포트 | [PNG](android-2013-tablet-portrait-status-paid-scope-800dp.png) | `Lv. 1`, `0 / 150 XP`, 상태창 탭과 `PLUS`가 보임. 아래 능력치는 화면 길이에 따라 스크롤 영역으로 이어짐. |
| 성장 기록 무료 보고서 상단 | [PNG](android-2013-tablet-portrait-growth-paid-scope-800dp.png) | 오늘 퀘스트 `+0 XP`, 어제 기록 없음, 기록 안내가 보임. |
| 성장 기록 하단 | [PNG](android-2013-tablet-portrait-growth-bottom-paid-scope-800dp.png) | 손가락 스크롤로 마지막 안내 문구와 프레임 하단까지 확인. 하단 탐색바가 보고서 내용을 막지 않음. |
| Plus 설명 상단 | [PNG](android-2013-tablet-portrait-plus-top-paid-scope-800dp.png) | 무료 기능 유지와 일회성 구매 설명이 정상 줄바꿈됨. |
| Plus 구매 영역 | [PNG](android-2013-tablet-portrait-plus-cta-paid-scope-800dp.png) | 구매용 계정 행과 `重新載入商品` 동작이 보이고, 구매 영역 내용이 스크롤로 접근 가능함. |

확인한 세로 화면에서는 글자·버튼의 겹침이나 영구적인 잘림을 발견하지 못했다. 첫 뷰포트 밖의 상태창 능력치와 성장 기록 마지막 줄은 스크롤해서 확인했다. Plus 화면에는 Google Play 상품을 불러오지 못했다는 오류가 표시되어 실제 가격·구매 버튼·결제 성공은 검증하지 못했다. 가로 1280×800dp는 이번 재부팅 후 추가 확인하지 않았다. 별도 320px/200% 글꼴 배율 테스트에서는 성장 기록 overflow가 확인되었으므로, 이 기본 배율의 태블릿 결과를 그 문제의 통과 근거로 사용하면 안 된다. 테스트 후 에뮬레이터의 `wm size`와 `wm density` 오버라이드를 해제해 1080×1920/420dpi로 되돌렸고, 복원 후 1080×1920 화면 버퍼가 다시 표시되는 것도 확인했다.
