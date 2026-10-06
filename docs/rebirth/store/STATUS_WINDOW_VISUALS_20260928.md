# 상태창 중심 Play 그래픽 — 2026-09-28

현행 Google Play 후보의 시각 소재다. 이전 책·나침반 그래픽을 상태창 중심으로 교체했다. 캐릭터, 웹툰 컷, 기존 작품의 로고나 문양을 복제하지 않았다.

| 용도 | 제출 경로 | 원본/가공 | 실제 파일 검사 |
| --- | --- | --- | --- |
| Play 피처 그래픽 | `feature-graphic-1024x500.png` | ImageGen 가로 원본을 비율에 맞게 1024×500으로 축소 | 1024×500, 24-bit PNG, 알파 없음 |
| Play 스토어 아이콘 | `app-icon-512.png` | ImageGen 정사각 원본을 512×512로 축소하고 불투명 알파 채널을 붙임 | 512×512, 32-bit PNG, 알파 채널 있음 |
| Android 런처 원본 | `../../../assets/images/app_icon_status_master.png` | ImageGen 정사각 원본 그대로 | 1254×1254 |
| Android 적응형 전경 원본 | `../../../assets/images/app_icon_status_foreground.png` | ImageGen 투명 전경, 원형 마스크 여백을 고려한 축소 버전 | 1254×1254, 실제 투명 알파 |

편집하지 않은 생성물은 `/Users/jeonghyeonseok/.codex/generated_images/01a0e5d5-3473-73f2-9fc9-3550d8ff4623/`에 있다.

- 피처 그래픽: `exec-02177b2d-cb81-4a58-9159-a7b555918df5.png` (1795×876). 기존 배너는 편집 대상, 실제 한국어 상태창 QA 화면은 형태 참고 자료로만 사용했다. 프롬프트 핵심: “replace its storybook artwork entirely”, “one vertical translucent cyan-blue holographic status window”, 왼쪽 정확히 `LIFE QUEST`만 표기, 가짜 능력치·버튼·캐릭터·책·나침반 금지. 가로 원본을 `sips -z 500 1024`로 기계적으로 축소했다.
- 불투명 정사각 아이콘: `exec-3bec5856-cb08-44e5-bccb-7731882fa1e2.png` (1254×1254). 피처 그래픽과 실제 상태창 QA 화면을 색·형태 참고 자료로 사용했다. 프롬프트 핵심: 검은 배경, 하나의 푸른 각진 상태창 프레임과 중앙 광점, 작은 크기에서도 식별, 책·문자·숫자 금지. 스토어용 512본은 크기 축소 뒤 Swift/AppKit으로 이미지의 외관을 변경하지 않고 8-bit RGBA 채널을 보장했다.
- 투명 적응형 전경: 최초 `exec-47a85606-04d1-459f-9fea-e416b743130e.png`, 최종 `exec-43b18005-4e44-4140-bec3-a6fd9cdaf9e7.png` (1254×1254). 아이콘을 편집 대상으로 사용해 배경만 실제 투명 알파로 제거한 다음, Android 원형 마스크를 위한 사방 여백을 추가했다.

이 배너는 **광고용 이미지**이며 앱 화면 캡처라고 설명하거나 스크린샷 칸에 제출하지 않는다. Google의 [미리보기 자산 요구사항](https://support.google.com/googleplay/android-developer/answer/9866151?hl=en-GB)은 피처 그래픽 1024×500 무알파 PNG/JPEG, 512×512 32-bit PNG 아이콘, 앱의 실제 경험을 보여주는 스크린샷을 요구한다. Play Console 업로드 시 [AI 생성 자산의 자가 신고 안내](https://support.google.com/googleplay/android-developer/answer/17262077?hl=en)에 따라 각 해당 자산을 사실대로 표시한다.

## 스크린샷 현황

`../design/status-system/qa/`의 상태창·퀘스트 화면은 Flutter QA 캡처다. 대표 휴대폰 이미지 `hunter-window-70xp-ko.png`, `status-initial-ko-final.png`, `accepted-ja-final.png`는 모두 **390×844**로, 긴 변이 짧은 변의 2배를 넘는다. 현행 [Play 스크린샷 규격](https://support.google.com/googleplay/android-developer/answer/9866151?hl=en-GB)과 맞지 않아 그대로 제출하지 않는다. 테스트 화면은 출시 빌드의 Android 화면과 완전히 같은 조건이라고 주장하지 않는다.

최종 Play 제출용은 정확한 서명 릴리스 빌드를 Android에서 실행하여 실제 앱 화면을 캡처한다. 권장 우선순위는 (1) 첫 상태창, (2) 돌발 퀘스트 수락/거절, (3) 성장 기록과 Status Window Plus, (4) 실제 게임·일상 완료 흐름이다. 최소 2장 규격 충족에 그치지 않고, 가능하면 추천 영역의 권장 조건인 **휴대폰 4장 이상, 최소 1080×1920 해상도와 9:16 비율**을 맞춘다. 일본어·한국어·번체 중국어·영어 목록별 캡처 문구와 앱 언어를 일치시킨다. 생성 이미지나 합성 UI를 앱 스크린샷으로 사용하지 않는다. 태블릿 카테고리 캡처는 실제 태블릿 레이아웃을 별도로 확인한 뒤 제출한다.
