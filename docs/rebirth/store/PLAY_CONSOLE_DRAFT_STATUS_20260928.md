# Google Play Console 초안 입력 상태 — 2026-09-28

대상: `hyeonseok460@gmail.com`의 개발자 계정 `Log_Ian`, 앱 `Life Quest` (`com.lifequest.app`, Play Console 앱 ID `4972166589004992203`). 앞선 확인에서 앱은 임시 상태·설치 사용자 0명이었다. **기본 스토어 등록정보는 `검토를 위해 전송 준비 완료`로 저장됐지만, 퀘스트 스크린샷 4장은 현 후보와 불일치해 교체 대기 중이다.** 이 기록은 콘솔 UI에서 직접 저장·재열람한 결과다. AAB 업로드, 테스트 트랙 게시, 심사 제출, 판매자 계정·상품·가격 설정은 하지 않았다. 테스터 참여 링크도 없다.

## 저장한 필드

기본 스토어 등록정보의 아래 세 필드를 [`en-US.txt`](en-US.txt), [`ja-JP.txt`](ja-JP.txt), [`ko-KR.txt`](ko-KR.txt), [`zh-TW.txt`](zh-TW.txt)의 현재 문구로 각각 교체했다. 네 언어 모두 콘솔에서 `변경사항이 저장되었습니다`를 확인했고, 언어를 바꿨다가 다시 열어 각 본문 글자 수와 바뀐 문장을 재확인했다. `zh-TW`는 앞선 작업에서 새로 추가했다. 2026-09-28에 2/2단계 리뷰에서도 `저장`을 눌렀고, 기본 등록정보 행의 상태는 `검토를 위해 전송 준비 완료`, 최근 수정일은 2026-09-28이다. 이는 심사 전송이 아니다.

| 언어 | 앱 이름 | 간단한 설명 | 자세한 설명 |
| --- | --- | --- | --- |
| en-US | `Life Quest: My Status Window` | `Open your status window. Turn small daily actions into quests and earn XP.` | `en-US.txt` 본문 2,654자 |
| ja-JP | `Life Quest：自分のステータス画面` | `アプリを開けば、まず自分のステータス画面。日常の小さな行動がクエストに。` | `ja-JP.txt` 본문 1,287자 |
| ko-KR | `Life Quest: 나의 상태창` | `앱을 열면 내 상태창. 일상의 작은 행동을 퀘스트로 바꾸고 XP를 쌓아보세요.` | `ko-KR.txt` 본문 1,432자 |
| zh-TW | `Life Quest：我的狀態視窗` | `打開 App，先看自己的狀態視窗。把日常小事變成任務，累積 XP。` | `zh-TW.txt` 본문 950자 |

네 본문은 상태창을 첫 경험으로, 현실 행동의 퀘스트와 기록 기반 성장을 주 사용 이유로 설명한다. 제품 범위 변경에 맞춰 기존 카드·던전 탐험 소개와 진행 중 탐험 백업 문구를 제거하고, **무료 단편 이야기 3편**을 보조 콘텐츠로 소개한다. 새 게임 콘텐츠 개발은 보류했다. `Status Window Plus`의 구매 이유는 추가 외관 3종·실제 기록에 근거한 30/90일 요약·PNG/TXT/CSV 저장으로 한정했다. 지역 가격이나 구매 가능 상태를 단정하지 않는다.

## 저장한 이미지 자산

2026-09-28에 기본 스토어 등록정보의 네 언어 각각에 **실제 Android QA 앱 화면 2장**을 휴대전화 스크린샷으로 업로드·저장했다. 각 언어를 다시 선택했을 때 `스크린샷 2/8`과 `변경사항이 저장되었습니다`가 보였고, 콘솔 축소 미리보기에서도 해당 언어 UI를 확인했다.

| 콘솔 언어 | 상태창 | 기본 추천 퀘스트 | 확인한 수량 |
| --- | --- | --- | --- |
| en-US | [`android-2013-status-en-final-fresh0.jpg`](../design/status-system/qa/android-2013-status-en-final-fresh0.jpg) | [`android-2013-quests-en-final-fresh0.jpg`](../design/status-system/qa/android-2013-quests-en-final-fresh0.jpg) | 2/8 |
| ja-JP | [`android-2013-status-ja-final-fresh0.jpg`](../design/status-system/qa/android-2013-status-ja-final-fresh0.jpg) | [`android-2013-quests-ja-final-fresh0.jpg`](../design/status-system/qa/android-2013-quests-ja-final-fresh0.jpg) | 2/8 |
| ko-KR | [`android-2013-status-ko-final-fresh0.jpg`](../design/status-system/qa/android-2013-status-ko-final-fresh0.jpg) | [`android-2013-quests-ko-final-fresh0.jpg`](../design/status-system/qa/android-2013-quests-ko-final-fresh0.jpg) | 2/8 |
| zh-TW | [`android-2013-status-zh-tw-final-fresh0.jpg`](../design/status-system/qa/android-2013-status-zh-tw-final-fresh0.jpg) | [`android-2013-quests-zh-tw-final-fresh0.jpg`](../design/status-system/qa/android-2013-quests-zh-tw-final-fresh0.jpg) | 2/8 |

이미지의 앱 버전·촬영 방식·`0 / 150 XP` 출처는 [촬영 기록](../design/status-system/qa/LOCALIZED_STORE_SCREENSHOTS_20260928.md)에 있다. 저장 전 비기본 언어에서 기본 영어 이미지 2장이 상속 표시됐지만, 해당 언어에 첫 현지 이미지를 추가하자 그 언어의 목록이 `1/8`로 바뀌었다. 두 번째를 추가해 `2/8`로 저장했고, 영어 목록을 다시 열어 영어 이미지 두 장이 유지되는 것을 확인했다. 따라서 각 언어 목록에는 영어 이미지가 섞여 있지 않다.

**재촬영 필요:** 네 언어의 퀘스트 스크린샷 4장에는 `+Gold` 등 현 후보에서 제거한 게임 경제 표시가 있다. 따라서 이 4장은 현 앱과 일치하는 최종 스토어 이미지로 사용하면 안 된다. 기존 이미지 8장은 아직 Console에 저장돼 있다. 게임 경제 표시를 숨긴 새 signed APK의 실제 화면을 네 언어로 다시 촬영·검증한 뒤, 적어도 퀘스트 4장을 교체해야 한다. 상태창 4장도 최종 APK와 비교해 표시가 달라졌다면 다시 촬영한다. 이미지 교체 전에는 스토어 심사를 전송하지 않는다.

기본 `en-US` 목록의 필수 앱 아이콘에는 생성 래스터 [`app-icon-512.png`](app-icon-512.png)(512×512 PNG, 340KB), 그래픽 이미지에는 [`feature-graphic-1024x500.png`](feature-graphic-1024x500.png)(1024×500 PNG, 665KB)를 올려 저장했다. 저장 뒤 콘솔에서 각각 `아이콘 1/1`, `이미지 1/1`을 확인했고, 다른 언어의 목록에도 기본 그래픽이 표시됐다. 8장 스크린샷은 실제 앱을 촬영한 것이며 합성한 홍보 목업이 아니다.

파일 업로드에는 Chrome의 광범위한 `Allow access to file URLs` 확장 프로그램 권한을 사용하지 않았다. Chrome에서 열린 **macOS 기본 파일 선택창**에 위 공개용 자산의 정확한 로컬 경로만 지정했다. 확장 프로그램·브라우저 권한 설정은 변경하지 않았다.

## 현재 입력 불가/미완료

- 기본 등록정보 상단에 한때 `일부 언어에 오류가 있습니다` 경고가 보였지만, 기본 아이콘·그래픽을 저장한 뒤 목록 개요를 다시 열고 편집 화면에 돌아왔을 때는 **더 이상 표시되지 않았다**. 오류가 사라진 정확한 원인을 콘솔이 명시하지는 않았으므로, 필수 기본 그래픽 누락 때문이었다는 해석은 추론이다.
- 편집의 `다음`으로 열린 **2/2단계 리뷰**에서 en-US·ja-JP·ko-KR·zh-TW 각각 제목·설명, 휴대전화 스크린샷 2장, 기본 언어에서 대체된 아이콘·그래픽을 확인했다. 언어별 누락/유효성 오류는 화면에 없었다. 리뷰의 `AI 애셋 선언`에서 **`AI를 사용하여 생성 또는 수정한 것으로 애셋 라벨 지정`**을 선택했다. 개별 자산 창에서 생성 이미지 `app-icon-512.png`와 `feature-graphic-1024x500.png`만 선택하고, 실제 Android 화면 JPEG 8장은 모두 선택하지 않았다. 자산 라벨 신고와 리뷰 `저장` 뒤 목록 상태가 `검토를 위해 전송 준비 완료`로 바뀌었다. 편집 화면을 다시 열어 선언 라디오와 두 이미지의 선택, 스크린샷 8장의 미선택이 유지된 것을 확인했다. 이는 **검토 전송 버튼을 누른 것이 아니다.**
- `스토어 설정` 본문은 Console의 `예기치 않은 오류`(처음 `499E1289`, 새로고침 후 `6B6A227F`, 이후 `7ED8A07D`)로 로드되지 않아 카테고리·연락처 등의 현재값을 확인하거나 변경하지 못했다.
- `앱 콘텐츠`는 기존 방문 기록의 정확한 Console 주소 `/app-content/overview`로 열고 새로고침했지만 `예기치 않은 오류`(`78BB5634`, 이후 `6AE26B70`, 이후 `79DE51B8`)가 반복되어 광고·앱 접근·개인정보처리방침·삭제 URL·데이터 보안·콘텐츠 등급 선언을 수정하지 못했다. 과거 완료 표시를 이번 유료 후보의 완료 근거로 삼으면 안 된다.
- AI 자산 선언 저장 뒤 별도로 연 `게시 개요` 본문은 `예기치 않은 오류 (7D02DD75)`를 보여 검토 대기 목록을 확인할 수 없었다. 기본 등록정보 행에서 확인된 `검토를 위해 전송 준비 완료`와 실제 심사 전송은 구분해야 한다.
- 후보 AAB의 로컬 검사([`paid-candidate-2013-inspection.json`](../paid-candidate-2013-inspection.json))는 Play 업로드·결제 작동·데이터 보안 선언을 대신하지 않는다. 스토어 정보 저장만으로 비공개 테스트가 시작되거나 테스터 링크가 생성되지 않는다.

현재 로컬 signed AAB 후보는 `build/review/life-quest-2.0.0-2013-paid-candidate.aab`, SHA-256 `2b1b57e3f7ec81095e6668837262046328724080257c9c2d13dcd4a7e6909c24`, **156,043,538 bytes**, 소스 `bb33b4b`다. [로컬 검사](../paid-candidate-2013-inspection.json)는 **54/54 통과**했다. Console에 저장된 스크린샷은 그보다 앞선 소스 `e6dd1ea`의 signed QA APK에서 촬영했으며, 퀘스트 4장의 `+Gold`가 현 후보와 달라 교체가 필요하다. 현재 AAB는 Console에 업로드하지 않았다.

앱 콘텐츠 로드가 정상화된 뒤 현재 AAB·백엔드 동작에 맞는 선언, 상품 설정/라이선스 검증을 따로 마쳐야 한다. 사용자의 다음 `배포해` 지시 전에는 AAB나 트랙을 게시하지 않는다.
