# 재개 체크포인트 · 2026-09-20

먼저 이 문서, `CONCEPT_AND_REVENUE.md`, `RELEASE_GATES.md`, `ON_DEVICE_AI_DECISION.md`를 읽고 현재 Git 상태·계정 사용량·사용자의 새 답변을 확인한다. Obsidian 요청이 아니므로 Vault에 접근하지 않는다.

## 사용자 목표와 한도

Life Quest를 현대 판타지 상태창 습관 RPG로 개선하여 Google Play에서 수익화하는 것이 목표다. 기획·개발·배포 권한은 위임받았다. 무료 공개 온디바이스 AI가 필수이고 새 아트는 image_gen 또는 권리가 확인된 무료 이미지/템플릿만 사용한다. 수제 SVG/HTML/Canvas 아트는 추가하지 않는다.

**이번 회차 최대30% 사용, 최소70% 잔여 보존.** 70% 사용 허용이 아니다. 시작100%, 사용량 도구 중간 확인에서79% 잔여였다. 공유 계정 한도는 토큰 예산이 아니며, 새 회차 허용량을 임의로 추정하지 않는다. 한도는 반드시 다시 읽는다. 자동 일정·새 작업·목표는 만들지 않았다.

## 위치와 도구

- `/Users/jeonghyeonseok/Documents/ChatGPT/Life_Quest`, branch `codex/rebirth-2026-09`, base `bdc7801`. 원본 checkout `~/.graphify/repos/Sn-bow/Life_Quest`.
- Draft PR https://github.com/Sn-bow/Life_Quest/pull/1. main 미병합, 공개 출시/매출 없음.
- Flutter `~/.local/share/lifequest/flutter/bin/flutter`3.47.4 / Dart3.13.3. JDK21 `/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home`. Android SDK `~/Library/Android/sdk`.
- **Flutter pub/analyze/test/build/run 직렬 실행.** R8 release는3–4분. 로그는 Git 제외 `qa_artifacts/rebirth/`.
- UI 검증은 CUA 사용. adb는 설치·개발 로그용이며 UI 입력/캡처 우회 금지.
- Web main release `http://127.0.0.1:8766/`, `scripts/serve_preview.py`의 no-store 서버 유지. 합성 프로필: 기록자60XP, 실제 행동1개, courtyard2/4·atlas1/4·tide2/12. 현재 책atlas. tide선택door=open,receipt=keep은 보존됐다. 임시412×892 viewport는 해제했다.
- 전용 AVD `LifeQuest_API35_16KB`는 종료 상태. 이전 검사 전용2004 APK 설치까지만 확인했다. 이를 아래v5 설치나 실물 검증으로 오인하지 않는다.

## 확정한 제품과 구현

- **Life Quest: 경계의 서가.** 기록자가 현실의 작은 행동으로 도시·수련·탐사의 여러 책을 이어 읽는다. 무림로그인/더 게이머/퀘스트지상주의/전독시/영지 설계사 공식 소개와 LifeUp/Finch를 조사했다. 조사 범위·출처·제품 판단은 `CONCEPT_AND_REVENUE.md`에 구분했다. 단일 푸른 게이트/E→S랭크/각성자 중심을 바꿨다.
- 세 무료 단편: 「0번 출구」/「바람을 듣는 마당」/「잃어버린 별의 지도」, 각4장면×4언어. 누적 현실0/1/3/6개 해금, 앞선 선택 대사·책 전환·재독·백업. 읽기로XP를 주지 않는다.
- **무료 핵심 + 별도 완결 이야기 팩 일회 구매.** 첫 팩 「조수 우체국」12장면×4언어, 앞선11선택으로두결말, 테마/표식. 첫2장면 무조건무료, 이후 누적 현실2~20개 해금. SKU `story_tide_postoffice_01`,6,900원은 검증 전 후보. 실제 Play 미등록/판매off. `TIDE_STORY_PACK.md`.
- 새 팩 조회는 한SKU만, 기존SKU는 영수증 호환성 유지. 상품 조회 오류/재시도, 환불 시 유료장면·테마·표식 회수, 진행/XP 보존, 백업으로 권한 위조 불가. 실제 금융 거래가 아닌 가짜 경계 테스트다.
- image_gen8개: 수련/탐사/기록장/아이콘2종/피처/조수표지/종이배표식. `artwork/README.md`에 원본·출처. 생성 아트 리사이즈만 sips 사용.
- **legacy 삭제 복구:** 요청 전 UID별 영속 guard, 응답 유실/접수 후 정리 실패 구분, 재시작 프로필 차단, 로컬 정리 재시도, 다른 계정 로그아웃 방지.15개검사. 실제 Auth/서버 삭제는 남았다.
- **cloud 저장:** 호출별 깊은 snapshot을 순차 저장하고 완료까지 기다린다. UID/프로필 세대·인증 일치 필수, 전환/삭제/해제 이후 대기 쓰기 차단. 실패 전달·선택 rollback·실패 후 다음 쓰기·저장 실패 시 로그아웃 중지. 새7개검사. 실제 Firebase 네트워크/동시 로그아웃·위젯 캐시는 추가검증 대상이다.

## 실제 검증과 한계

- Flutter 전체337개 통과, 정적 분석 문제 없음. 별도 Cloud/Billing-enabled 카탈로그1개통과(기본 전체 실행은 해당1개 의도적skip). Node22서버27개통과. 로그 cloud-save-full-tests/pack-catalog-tests/pack-server-tests.
- 추가 `dungeon_campaign_test.dart`6개통과:5구역×200seed=1,000지도 모든노드도달/막다른길없음/상점·휴식·보스도달,각구역6개방입구 저장/복원·보스종류·최종보상 중복 방지. 전투 승패를 공급한 상태검사이며 실제전투·밸런스·재미검증이 아니다. 앱소스 변경 없음.
- CUA 실제 웹: 책선택→현실퀘스트→후속장면→선택반응→재시작, 무료체험2장면→종료→상세→재독. v5에서도60XP/선택유지. `CONCEPT_UX_REVIEW.md`, screens/concept-review/01~13. Play용 Android 스크린샷이 아니다.
- 9월17일 기준선: Firestore/Storage emulator9개, native manifest7조합, signed/R8 모델·백업probe. 변경 없는 검사를 이번회차 새 실행으로 표현하지 않는다.
- Gemma4E2BIT/Apache-2.0/LiteRT-LM0.17.0.2,588,147,712byte 선택다운로드, pinnedrevision/hash, 취소/재개/삭제,CPU4/context2048/output550/thinkingoff. Qwen비교후선택. 4언어×신규/긴기록8/8 구조통과; 의미품질인증아님. 에뮬레이터signed21,364/11,748ms, warm9,368/7,867ms. 실물속도/메모리/발열미검증.
- AES256GCM/PBKDF2SHA256600k 무료백업/원자복원·undo/journal. 실제 Android 파일선택기는 미검증. 구매/인증/진행중탐험/모델/신고기록은 백업제외.

## 최신 바이너리

소스 **489ccff232fd5114df96d6b2e261720b6a5bd963**, **2.0.0+5**, main진입점. 삭제복구·조수팩·cloud쓰기수정포함.

- AAB `build/app/outputs/bundle/release/app-release.aab`: **221,628,319bytes**, SHA256 `1f8895dcdf91f4d509c342f4702129eaa321f8c1cface5992101708e74dfdef0`.
- 표본 ARM64/API35 다운로드 **130,430,117bytes**. 공개서명/manifest/11ELF/기기splitZIP16KB/QA진입점제외통과.
- 직접설치ARM64 APK `build/app/outputs/flutter-apk/app-release.apk`: **186,524,856bytes**, SHA256 `7a3686ab065d0901e3f005b8d4c828aa0b5c36fe409ad25111f0a8b3ce93ab5c`. versionCode5/서명/16KB/default권한/팩4언어아트포함검사통과.
- APK는실물기기에서미실행. 업로드키서명이며Play앱서명키가다르면전환시백업후재설치필요. APK설치를Play테스터참여로계산하지않는다.

`artifact-inspection.json`/`apk-inspection.json`이 해당 실제파일의 검사 근거다. 업로드 공개인증서 SHA256 `15:37:D6:F3:9E:E3:EE:D1:53:E1:34:12:8B:BE:66:11:32:18:38:47:CA:3A:A7:F4:B5:11:27:6B:FD:35:2B:B3`. 비밀값/keystore/key.properties를 읽거나 출력하지 않는다. 검사는 공개인증서와 바이너리만 읽는다.

AAB검사 `scripts/inspect_release_artifact.py`; APK검사 `scripts/inspect_review_apk.py`에 공개지문·version-code5·source-commit을 전달한다. `qa_artifacts/rebirth/main-release-device.apks`는debug서명 검사split이므로 배포금지. 이전v4/해시는 Git이력에 있으며 최신파일에 재사용하지 않는다. Cloud/Billing/Ads는 기본off다. AI 신고백엔드가 작동하기 전 공개출시금지.

Flutter가 AGP8.13.2의향후지원종료를 경고한다. 현재 R8 9.1.43override로빌드/서명/검사통과. AGP9전환은 별도회귀가 필요하며 빌드경고를오류로보고하거나 검증없이 업데이트하지 않는다.

## 외부 배포 상태

- Play Log_Ian,developer8167226228602257815,app4972166589004992203,packagecom.lifequest.app. EN/KR새문구초안 저장성공9/20. 필수이미지·실물스크린샷·콘텐츠/Data safety선언미완료. AAB업로드/심사제출없음.
- Chrome이미지업로드 `Not allowed`: ChatGPT확장의‘파일 URL에 대한 액세스 허용’을사용자가켜야함. 공식안내 전달했고우회안함. Play초안탭을handoff로보존했다.
- Dashboard9/20두차례Console오류. 마지막테스터수는9/17의0명/프로덕션접근없음. 실제12명연속14일필요. 모집메시지발송/가짜테스터없음.
- FirebaseCLI접근프로젝트0개9/20. gcloud기존프로젝트권한없음/없음.9/17Console에서는life-quest-app-95eb9삭제상태,Android등록도구패키지. 복원/신규/서버비용방향질문답변대기. Functions용Blaze/결제계정 임의연결/생성/배포없음.
- 실물Android기종/RAM및테스터확보 질문답변대기. `DEVICE_ACCEPTANCE.md`와store/STORE_AND_TEST_PLAN.md 준비.
- 정책공개페이지 https://sn-bow.github.io/Life_Quest/ (#privacy,#terms,#delete-account) 배포/검증완료. canonicaldocs/index.html,별도gh-pagescheckout `~/.local/share/lifequest/policy-site.daHZpl`,a4ea4f4. 정책게시를위해앱main병합하지않음.

## 다음 작업

1. 사용자 답변을 확인하고 Firebase복원/신규·비용과 실제Android를 준비. 같은승인질문을반복하지않는다.
2. 실제Auth/App Check/신고접수·삭제·TTL·최소구매계정·영수증·RTDN환불을검증한다. 원격인덱스보존,결제off유지.
3. 실물한국어AI성능·안전성,TalkBack/큰글자/알림거부/파일백업/저장부족/앱강제종료,5구역실제전투밸런스. 팩원고/4언어독자검수와가격가치평가.
4. 준비된실제상품을Play등록하고테스트구매·보류·취소·복원·환불·계정전환검증.검증없이판매켜지않음.
5. 그래픽/실물스크린샷·최종선언→검증AAB내부테스트→실제12명/14일→프로덕션액세스/공개심사.

앱·기획·설치파일·스토어초안을 완성된공개배포/매출로보고하지않는다. 검사는변경·실패·미검증범위에맞춰실행하며 기존전체검사를무조건반복하지않는다.
