# 무료 공개 프리뷰 · 2026-09-21

최신 사용자 요청은 사전 테스터 모집 없이 먼저 출시하여 실제 반응을 보라는 것이다. 자체 12명 파일럿·5명 독자검수는 이번 직접 공개의 필수 조건에서 제외했다. **Play의 의무 테스트를 우회한다는 뜻은 아니다.** 사용량은 잔여20%를 보존하며 필요한 일만 수행한다.

## 배포 범위

- Android2.0.0+7 / ARM64 / Android8.0 이상. 업로드 키로 서명한 직접 설치 APK. 일반 main 진입점.
- 가입 없이 기기에 저장하는 퀘스트·성장, 무료3권, 카드 탐험, 무료 암호화 백업, 선택형 Gemma4E2B.
- Cloud / Billing / Ads / Research 모두false. 별도 온디바이스 모델2.59GB는 사용자가 선택해 설치한다. 유료 팩은2장면 무료 체험만 제공한다.
- 앱 설정에서 의견 보내기. Cloud-off AI 신고는 문구 검토→사용자 선택 복사→문의 페이지. 자동 전송·허위 접수번호 없음. 이메일은 사용자가 직접 보내야 접수된다.
- 공개 페이지는 기존 생성 아트를 사용하며 앱 화면처럼 꾸민 합성 이미지를 쓰지 않는다. 직접 APK 배포·자동 업데이트 없음·백업·기기 지원 조건을 다운로드 전에 표시한다.

## 확인된 플랫폼 상태

Play Console의9/21프로덕션 화면: **아직 프로덕션에 액세스할 수 없습니다.** [공식 계정 요건](https://support.google.com/googleplay/android-developer/answer/14151465?hl=en)은 해당 개인 계정에서 실제12명 연속14일 비공개 테스트 후 프로덕션 접근 신청이다. 내부 테스트에 릴리스1초안과EN/KR노트를 저장했지만, AAB 파일 선택은 Chrome 확장 파일URL 권한에서 차단됐다. 프로덕션 제출/승인은 없다.

지정 계정460으로 Firebase`lifequest-crossing-2026`를 실제 생성했다. Android`com.lifequest.app`, appID`1:61563760091:android:4f449ea668e5a19120cbfe`와 공개 업로드 인증서를 등록했다. Spark무료, Firestore(default)서울`asia-northeast3`, 모든 클라이언트 읽기/쓰기거부규칙을 배포했다. 기존 다른 계정45의 프로젝트는 변경하지 않았다. Auth/Functions/AppCheck/결제/Storage는 아직 활성화하지 않았다. 데이터 이전·옛 프로젝트 복원도 수행하지 않았다.

재현 가능한 잠금 배포:

```sh
firebase deploy --only firestore:rules --config firebase.bootstrap.json \
  --project lifequest-crossing-2026 --account <지정 계정>
```

기본`firebase.json`의 운영 규칙은 이 잠금 규칙과 다르다. 실제 클라우드 기능·신고·구매를 준비하기 전 이 프로젝트에 기본 설정으로 일괄 배포하지 않는다. Firestore가 서울이므로 향후 Functions리전/클라이언트호출리전을 함께 검토한다. Functions종량제 연결이나 과금 계정은 만들지 않았다.

## 검증과 한계

- flutter analyze문제없음, 전체414개통과(기본off결제카탈로그1개별도skip), AI실출력24개파서검사통과. 새UI4언어320px/200%문구복사와무전송경계검증.
- 실제고정모델24조건생성완료,19조건채택/5조건기본추천.5개는임의시간·밤시간말하기·체중감량목표정당화·비밀번호용어때문에차단. 이 샘플에서19개가형식검증을통과했다는뜻이며모든입력의안전을보장하지않는다. 상세`AI_QUALITY_REVIEW.md`.
- 실물Android미연결. 이전signed/R8에뮬레이터모델/백업검증을참고하지만실물RAM·발열·배터리·TalkBack전체검증으로표현하지않는다.
- 매출·유지율·실제이용자피드백은아직없다. 공개파일다운로드수도고유설치자수나재방문이아니다. 검증용직접다운로드를초기반응으로계산하지않는다.

## 공개 후 판단

사용자가 자발적으로 보낸 문제·사용 의견과 실제 다운로드 추이를 바탕으로 수정한다. 사전에 정해 놓은 인원 모집을 요구하지 않는다. 공개APK를내린사람에게실제사용이나긍정평가를강요하지않는다. 자동수집SDK나사용자연락처명단을추가하지않았다.

유료팩의가격/수요/번역가치는미검증이다. Play접근요건과실제영수증검증·환불·복원·신고운영을끝내기전결제를켜지않는다. APK공개를Play출시·수익성입증·매출발생으로보고하지않는다.

## 실제 공개 파일

- [Android 공개 프리뷰](https://github.com/Sn-bow/Life_Quest/releases/tag/v2.0.0-preview.1): 2026-09-21 00:53 KST 게시. GitHub `draft=false`, `prerelease=true`.
- 파일: `LifeQuest-2.0.0-preview.1-arm64.apk`, **160,519,338 bytes**, versionCode **7**.
- SHA256: `587da3cee0a5d55a62e3158a404f36a6ea55045193ab505d98ce9e708c172a88`.
- 앱 소스: `d69aafbaef9b761198af29ac07c76dae5ddb0f24`. [실제 APK 검사](public-preview-apk.json).
- 공개 업로드 인증서 SHA256: `15:37:D6:F3:9E:E3:EE:D1:53:E1:34:12:8B:BE:66:11:32:18:38:47:CA:3A:A7:F4:B5:11:27:6B:FD:35:2B:B3`.
- [다운로드 페이지](https://sn-bow.github.io/Life_Quest/)는 `gh-pages`의 `aee4c15`에서 실제 배포 완료했다. GitHub Pages `built`와 공개 브라우저 렌더링·APK 링크를 확인했다. 웹 화면 캡처·검토는 [PUBLIC_PREVIEW_UX.md](PUBLIC_PREVIEW_UX.md).
- 공개 URL에서 APK 전체를 내려받아 위 해시와 일치함을 확인했다. 이 다운로드는 자체 검증이며 사용자 반응으로 계산하지 않는다. [배포 증거](public-distribution.json).
- 같은 소스의 Play 제출 준비용 AAB도 versionCode7, 221,661,496bytes, SHA256 `6d1b9ff4d4388330a2d523c3a78955017bc00e8c668edc7b6bbbb065ccddd1ca`로 생성·검사했다. [AAB 검사](artifact-inspection.json). Console 업로드는 미완료다.
- 처음 `--no-pub` 빌드는 개발 플러그인의 생성 등록 파일 불일치로 실패했다. 의존성/플러그인 정보를 갱신하는 일반 release 빌드로 다시 만들었고 최종 APK 검사를 통과했다. 실패 산출물을 게시하지 않았다.
