# 재개 체크포인트 · 2026-09-20

먼저 이 문서, `REVENUE_VALIDATION.md`, `RELEASE_GATES.md`, `ON_DEVICE_AI_DECISION.md`를 읽고 Git 상태와 실제 계정 사용량을 확인한다. Obsidian 요청이 아니므로 Vault에 접근하지 않는다.

## 사용자 목표와 최신 제약

Life Quest를 현대 판타지 상태창 습관 RPG로 개선하여 Google Play에서 수익화한다. 기획·개발·배포 권한은 위임받았다. 특정 작품에 치우치지 않으며 무료 공개 온디바이스 AI가 핵심이다. 새 아트는 image_gen 또는 권리가 확인된 무료 이미지/템플릿만 사용한다. 수제 SVG/HTML/Canvas 아트는 추가하지 않는다.

**최신 허용량: 잔여60% 이상 보존.** 이전70% 기준을 대체한다. 이번 요청 시작은78% 잔여였고 가장 최근 확인은67%다. 공유 계정의 실제 한도를 다시 읽으며 사용 가능한 분량을 임의 추정하지 않는다. 60% 남기라는 것은60%를 사용하라는 뜻이 아니다. 자동 일정·새 작업·목표·서브에이전트는 만들지 않았다.

**수익화 가능성 검증 전 공개 판매를 하지 않는다.** 현재는 반복 사용·전체 원고의 가치·실제 구매·제작비 회수 근거가 없다. 보고서 생성과 코드 검사를 시장 검증으로 보고하지 않는다. 공개 배포/매출 없음. 현재 판정은 `HOLD_PUBLIC_RELEASE`다.

## 위치와 도구

- Repo `/Users/jeonghyeonseok/Documents/ChatGPT/Life_Quest`, branch `codex/rebirth-2026-09`, base `bdc7801`. 원본 checkout `~/.graphify/repos/Sn-bow/Life_Quest`.
- Draft PR https://github.com/Sn-bow/Life_Quest/pull/1, main 미병합.
- Flutter `~/.local/share/lifequest/flutter/bin/flutter`3.47.4 / Dart3.13.3 / JDK21 `/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home` / Android SDK `~/Library/Android/sdk`.
- Flutter pub/analyze/test/build/run은 직렬 실행. R8 빌드는2–4분. Gradle8.14.3/AGP8.13.2 향후지원경고가 있지만 현재 빌드 실패는 아니다. R8 9.1.43override는 유지한다.
- UI 검증은 CUA. adb는 설치/개발 로그 용도로만 사용하고 입력/캡처 우회에 쓰지 않는다. Android Emulator는 이번 CUA 앱 목록에서 조작할 수 없었고 `getApp`도 실패했다. 기존 AVD 데이터를 변경하거나 우회 조작하지 않고 종료했다.
- 로컬 웹 `http://127.0.0.1:8766/`, `scripts/serve_preview.py` no-store 서버 유지. 최신 main + research enabled 빌드. 412×892 임시 viewport는 해제했고 Today 화면을 남겼다.
- 웹은 합성 프로필: 기록자60XP·현실행동1개, courtyard2/4·atlas1/4·tide2/12, 현재책atlas. 연구 점수3/가격미정은 가상 UI 입력이며 `web_preview`로 실제 사용자 분석 제외. 첫 전투 후HP74·골드62·덱11, 2번째 방 입구 체크포인트가 있다. 다음 재개는 방 처음부터다.

## 계정과 외부 상태

- Firebase와 Play는 사용자가 지정한 **hyeonseok460** 계정을 사용한다. Play Console 계정 메뉴, Firebase Console `u/1`, FirebaseCLI `login:list`에서 일치를 확인했다. 이 계정의 Firebase 프로젝트 목록은 CLI/Console 모두0개다.
- **gcloud 활성 계정은 hyeonseok45로 달랐다.** 그 계정의 조회 실패를460 프로젝트 상태 근거로 쓰지 않는다.45 계정의 다른 프로젝트는 건드리지 않았다. 프로젝트 생성/복원, Blaze/결제 계정 연결, 서버 배포 없음.
- Firebase MCP는 같은CLI 자격을 사용하므로0프로젝트 문제를 해결하지 않는다. 지금 추가 설치하지 않았다. fastlane supply는 업로드 자동화에 적합하지만 PlayAPI 접근 설정과 실제 출시 조건을 먼저 충족해야 한다. 새 서비스 계정/키/권한 확대 없음.
- Play Log_Ian, developer8167226228602257815, app4972166589004992203, packagecom.lifequest.app. EN/KR 설명 초안 저장9/20. AAB업로드·상품등록·심사제출 없음.
- 이전 Chrome 업로드는 확장의 파일URL 접근 제한으로 실패했다. 공식 안내를 전달했으며 우회하지 않았다. 초안탭은handoff로 보존했다. 최신 대시보드는9/20Console오류로 미확인, 마지막 테스터 값은9/17의0명/프로덕션 접근 없음이다.
- 실제Android 기종/RAM·12명테스터 확보 정보는 아직 없다. 다시 같은 계정 질문을 하지 않는다. 모집 메시지를 보낼 권한은 없으며 누구에게도 연락하지 않았다.
- 공개 정책 페이지 https://sn-bow.github.io/Life_Quest/ 배포 상태는 기존gh-pagesa4ea4f4. 이번에는 새로 배포하지 않았다. 계정의 법적/금융 설정이나 개인정보 선언을 임의 확정하지 않는다.

## 현재 제품과 이번 변경

**Life Quest: 경계의 서가.** 기록자가 현실의 작은 행동으로 도시·수련·탐사의 책을 이어 읽는다. 공식 무림로그인/더게이머/퀘스트지상주의/전독시/영지설계사 소개와LifeUp/Finch를 조사했다. 전편 정독이라고 주장하지 않는다. 기존 푸른게이트/E→S랭크/각성자 중심 방향은 종료했다.

- 무료3권×4장면×4언어, 누적 현실0/1/3/6개 해금. 책 전환/재독/선택 반응/백업. 읽기로XP를 주지 않는다.
- 별도팩「조수 우체국」12장면×4언어·앞선11선택으로두결말·테마/표식. 처음2장면무료, 이후누적현실2~20개. SKU `story_tide_postoffice_01`, 판매off. 환불·권한변경시유료장면/장식회수,진행보존. 백업으로 소유권을 만들 수 없다.
- **가격 미확정.** 기존6,900원 단일 가설을 수정해2,900/4,900/6,900원·미정·비구매를 탐색한다. 한국어한경로7,896–8,046자(선택·이전선택반응·한결말포함)를 실제4096경로계산했다. `content-scope.json`. 분량·원고·번역·읽는시간·재미·지불의사는별도독자검수대상이다.
- **연구용 빌드** `LIFEQUEST_RESEARCH_ENABLED=true`에서만 성장→설정→14일 사용성 테스트. 직접 참여 후 로컬 기록, 자동 업로드 없음. 무작위ID·날짜구간별완료수·체험·평가·이상플래그만내보낸다. 이름·목표·원문·계정·정확한시각·영수증 제외.14일후관찰중단,자발적파일저장,참여삭제. 기기프로필삭제시연구삭제,백업복원시무효화(일반빌드로갈아탄경우도포함). 연구오류가퀘스트저장을막지않는다.
- `scripts/analyze_beta_reports.py`: 명단누락/중복/충돌/새사용자vs기존/성숙D1·D7/미정vs비구매구분. 실제결제는unknown. `scripts/prepare_story_review.py`:4언어원고검토본·실측생성. `RESEARCH_TESTER_GUIDE.md`는준비된안내일뿐모집/참여완료가아니다.
- **AI설정개인정보수정:** 기기전용인데Firebase에저장한다고표시하던문구를실제프로필/Cloud플래그에맞췄다.
- **실제전투에서발견한수정:** 진행도11개갈림길대신6단계,0EP무료카드가있으면사용가능표시,음수비용저주카드활성/집계제외. 전투상태와손패가같은`canPlayCard`판정을쓴다.
- 기존중요수정유지:legacy삭제UID별영속guard·로컬복구,cloud호출별깊은snapshot순차저장·실패전달·삭제/전환세대차단·저장실패시로그아웃중지.

## 검증 근거

- **Flutter 전체368개 통과**, analyze문제없음. 기본전체에서결제카탈로그1개의도적skip,이전별도Cloud/Billing-enabled1개통과. 로그`research-full-tests.log`/`research-analyze.log`.
- 연구 기능flag on 별도23개통과. Python 집계8개통과. 연구중복/동의/철회/복원/시계/저장실패/원문미노출·4언어320px200%포함. 실제14일사용/구매증거가아니다.
- 게임피드백대상20개통과:4언어0비용표시·음수비용/잘못된index차단·기존5구역각단계진행도/복원/보상·4언어작은화면. 1,000seed그래프연결검사는유지한다.
- CUA웹:기기저장안내·연구참여/가격미정저장·팩가치안내·첫실제전투승리/12골드/카드선택·새로고침HP74골드62덱11보존·1/6진행도·다음전투0EP1장가능확인. `REVENUE_UX_REVIEW.md`,screens/revenue-review/01~12. 실물Android스크린샷이나전체전투밸런스검증은아니다.
- 웹보고서파일저장버튼실행후앱오류는없었지만다운로드실물파일은이번에확보하지못했다. 위젯가짜파일경계의bytes/취소/철회검사는실제네이티브파일선택기를대체하지않는다.
- Node22서버27개는이전9/20검증,새서버코드변경없음. Firestore/Storage에뮬레이터9개·manifest7조합·signed/R8모델/백업probe는9/17기준선. 새실행이라고표현하지않는다.
- Gemma4E2BIT Apache2/LiteRTLM0.17.0.2,588,147,712bytes 선택다운로드,pinnedrevision/hash,CPU4/context2048/output550/thinkingoff.4언어×2입력8/8구조통과. 에뮬레이터signed21,364/11,748ms,warm9,368/7,867ms. 실물의속도/RAM/발열/배터리·의미안전성미검증.

## 최신 바이너리

소스 **e05f117182b212227fe963ed263aba322d175bf3**, **2.0.0+6**, main 진입점. 연구·개인정보·전투 안내 수정 포함.

- **기본 AAB** `build/app/outputs/bundle/release/app-release.aab`: **221,659,038bytes**, SHA256 `10e98578510204a5e827be28ab8701469b593830366c351d7c386045b019524f`. 연구/Cloud/Billing/Ads 기본off. 표본 ARM64/API35 다운로드 **130,433,973bytes**. 공개서명·manifest·11ELF·기기splitZIP16KB·QA진입점제외 검사 통과.
- **내부 연구용 ARM64 APK** `qa_artifacts/rebirth/LifeQuest-2.0.0-6-research-arm64.apk`: **160,585,298bytes**, SHA256 `a70b9face4cdb022daa73ee177a4076009fdf2d05045e723ff55d081f9a6d190`. 연구true,Cloud/Billing/Adsfalse. 서명·versionCode6·16KB·번들팩4언어 검사 통과. 실물Android 미실행. 원본은 `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`다.
- APK는 `--split-per-abi --target-platform android-arm64 -Pforce-version-code-ignoring-abi=true`로 만들었다. 다른ABI JNI를빼고도Android versionCode6을유지했다. 기본split이만드는2006중간파일과혼동하지않는다.
- `artifact-inspection.json`/`apk-inspection.json`은 위실제파일의근거다. `REVIEW_BUILDS.md`에재현명령이있다. 일반출시용빌드와연구용APK를구분한다.

공개업로드인증서SHA256 `15:37:D6:F3:9E:E3:EE:D1:53:E1:34:12:8B:BE:66:11:32:18:38:47:CA:3A:A7:F4:B5:11:27:6B:FD:35:2B:B3`. keystore/key.properties나비밀값을열어출력하지않는다. 실제파일의공개서명/manifest/nativebinary만검사한다.

AAB검사 `scripts/inspect_release_artifact.py`; 연구APK검사 `scripts/inspect_review_apk.py`. APK는업로드키서명이며Play앱서명키와다르면전환시백업후재설치가필요하다. 연구APK의직접설치는Play테스터참여로세지않는다. Debug서명검사용`*.apks`는배포금지. 이전v5와중간빌드의해시는Git이력/로컬로그에있으며최신파일에재사용하지않는다.

## 다음 작업

1. 실제Android와실제목표사용자로`REVENUE_VALIDATION.md`의관찰인터뷰/14일연구/전체원고검수를진행한다. 기기가연결되면네이티브파일내보내기·백업·TalkBack·알림거부·저장부족·종료복원부터검증한다. 기존진행기록을지우지않는다.
2. 실물한국어AI속도/RAM/발열/출력안전성,5구역실제전투및회복/패배/보스밸런스,번역검수. 실제사용자의재방문·가격이해·전체원고가치와제작단가를확인한다.
3. 신호가좋고비용방향이정해지면460계정프로젝트/Auth/AppCheck/신고/삭제/TTL/구매검증/RTDN을실제로연결하고검증한다. Play라이선스테스트구매/환불은매출이아니다. 실제상품/국가가격은검증전판매켜지않음.
4. 실물스토어스크린샷·최종DataSafety/콘텐츠선언·검증AAB내부테스트·실제12명연속14일·프로덕션접근/공개심사를구분해진행한다. 공개판매는사용자가강조한상업적준비조건과손익가설을충족한뒤결정한다.

수익을보장하거나실제사용자/거래를가공하지않는다. 설치파일·웹QA·스토어초안을공개출시로보고하지않는다. 실제한도60%하한을우선하고변경/실패/미검증범위에맞춰검사한다.
