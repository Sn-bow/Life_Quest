# 상태창 중심 공개 안내 페이지 점검 — 2026-09-28

공개 주소: <https://sn-bow.github.io/Life_Quest/>. `docs/index.html`과 `docs/site/status-window-development-preview.jpg`를 `gh-pages`에 게시했다. 최초 게시 커밋은 `f4bed5c`, 320 CSS px 레이아웃 보강은 `b9a4cd3`, 신규 게스트 3탭 상태창 이미지 갱신은 `f16d05a`다. **앱의 Google Play 비공개 테스트·판매·실거래가 시작됐다는 뜻은 아니다.**

## 방문자에게 보여 주는 경계

- 첫 화면 이미지는 Android Studio `Take Screenshot`으로 실제 Android 신규 게스트를 촬영한 `docs/rebirth/design/status-system/qa/android-2013-status-ja-3tab-fresh0.jpg`를 복사했다. `docs/site/status-window-development-preview.jpg`는 1080×1920 RGB JPEG, SHA-256 `faec90adc4400e5b5c2e75642173c0a96c38ca7b10b9eedf53f75d2b7952433b`다. 일본어 이름 `記録者`, Lv. 1, `0 / 150 XP`, 네 능력치와 상태창·퀘스트·성장 기록 3탭이 보인다. 이 캡처는 최종 칭호 현지화 패치 `e6dd1ea` 전의 동일 3탭 UI에서 촬영했으며, 패치가 상세 상태 칭호를 고친 뒤 해당 첫 화면의 표시가 유지되는 것은 Android에서 별도로 육안 확인했다. 이전 390×844/70 XP 내부 캡처는 더 이상 사이트에 쓰지 않는다.
- 현재 다운로드 버튼은 기존 `v2.0.0-preview.1` ARM64 무료 APK만 가리킨다. 캡처의 새 상태창과 유료 확장팩이 이 APK에는 없음을 이미지 설명·다운로드 영역·영어와 일본어 안내에 명시했다.
- 배포 전 2.0.0+2013 후보에 구현된 일회 구매 확장팩의 외관 3종, 기록 기반 30/90일 요약, 기기 파일 내보내기를 설명한다. Google Play 상품 설정·실제 거래 검증·판매는 아직 시작되지 않았다고 밝힌다. 기본 상태창·퀘스트·XP·원본 기록·암호화 백업은 무료 범위로 구분한다.
- 개인정보 안내는 현재 공개 APK의 기기 저장 기록과 선택 설치형 약 2.59GB AI 모델 다운로드를, 새 후보의 선택적 클라우드/구매 계정·AI 신고·Play 토큰 처리와 분리한다. 일본어 개인정보 안내와 계정/기기 기록 삭제 방법 및 지원 이메일 링크가 있다. 실제 Play 제출 시 데이터 보안 신고와 해당 빌드의 동작을 다시 대조해야 한다.

## 게시 후 확인 결과

| 검사 | 결과 |
|---|---|
| 공개 페이지와 이미지 | 페이지 및 JPEG가 HTTP 200. 공개 HTML이 로컬 `docs/index.html`과 바이트 단위로 일치했고, 공개 JPEG SHA-256이 위 원본과 일치했다. |
| 이미지 크기/형식 | 공개 이미지 1080×1920 RGB JPEG. 이미지 `alt`와 캡션에 실제 일본어 2.0.0+2013 후보 화면과 기존 공개 APK의 차이를 설명한다. |
| 페이지 내 링크·자산 | ID 11개, 내부 앵커 14개 모두 대상이 있다. 로컬 이미지 5개 모두 존재하고 `alt` 속성이 있다. `#privacy-ja`, `#delete-account-ja` 확인. |
| 반응형 화면 | Chrome DevTools Protocol의 실제 320·400·768 CSS px viewport에서 각각 `documentElement.scrollWidth == innerWidth`. 320 px에서 두 CTA, 본문, 상태창 이미지가 화면 안에 있으며 육안으로도 확인했다. 단순 `--window-size=320` 캡처는 headless Chrome의 최소 500 CSS px 제약으로 결과가 잘릴 수 있어 판정에 사용하지 않았다. |
| 기존 공개 릴리스 | 릴리스 페이지와 무료 APK 직접 링크에 대한 HTTP HEAD 최종 응답이 각각 200. APK 파일을 다시 내려받거나 설치하지는 않았다. |
| 정적 검사 | `git diff --check -- docs/index.html` 통과. 사이트에 추적 스크립트·수제 SVG·Canvas 그림을 추가하지 않았다. |

이 페이지는 **새 앱의 출시나 구매 수요·수익 발생의 증거가 아니다.** Android/Play 최종 후보를 다시 빌드하면 공개 캡처가 같은 제품 상태를 보여 주는지 재확인한다.

## 2.0.0+2013 개인정보 문구 갱신

계정 선택 전에도 후보 앱이 Firebase/App Check를 초기화하고 Google Play 상품 정보를 조회할 수 있다는 점을 한국어·영어·일본어 안내에 반영했다. 이 초기화가 기기 전용 퀘스트나 AI 입력을 개발자 서버에 자동 업로드한다는 뜻은 아니며, 계정·동기화·신고·구매 데이터의 처리 조건은 각 기능을 선택할 때 적용된다고 분리해 설명한다. 앱의 실제 네트워크 동작은 별도의 기기 검증 대상이다.

- `docs/index.html`을 공개 브랜치 `gh-pages`의 `index.html`에 그대로 복사해 `2edef63`으로 게시했다. `.nojekyll`과 `site/` 자산은 변경하지 않았다.
- GitHub Pages의 해당 빌드 상태가 `built`인 것을 확인했다. 공개 <https://sn-bow.github.io/Life_Quest/>는 HTTP 200으로 응답했고, 조회한 HTML 55,246바이트의 SHA-256 `bcbb910bbdd3493f4a6d5cfcb8ff506713ea24b02956edcd453dc7e28867fbeb`가 로컬 게시 소스와 일치했다.
- 공개 HTML에서 세 언어의 새 문구 및 `#privacy`, `#delete-account` 앵커를 확인했다. 게시 전 HTML 파싱과 내부 링크·이미지 경로 검사를 통과했다. Play 출시·유료 판매·실구매 검증 상태는 이 갱신으로 바뀌지 않았다.
