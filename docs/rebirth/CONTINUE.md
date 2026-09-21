# 재개 체크포인트 · 2026-09-21

> **최신 사용자 지시:** Clutter 사례를 참고해 Google Play 중심 + 한국/대만/일본/영어권 현지화 + Threads 유입에 집중한다. 추가 스토어 입점은 후순위. `PLAY_GLOBAL_LAUNCH.md`와 `marketing/THREADS_STARTER_KIT.md`에 방향·계정 이름·소개·KO/TW/EN/JA 원고와 운영안을 저장했다. 사용자가 계정을 직접 생성한다. 공개 게시/DM은 실행하지 않았다.

> **이번 실행 결과:** 일본어 스토어 설명을 Console 초안에 저장, 재진입 후3필드 원문 일치 확인. Alpha3/4·비활성, 검토700F193F 오류 재현. 앱 업로드/참여 링크/심사 제출은 여전히 미완료. 권한 상태 질문에 답변 대기 중이며 파일 업로드를 우회하지 않았다.

> **해외 확장:** Alpha 대상 국가 한국·대만·일본·미국·캐나다·프랑스 6개 저장/재진입 확인. 활성화/출시는 미완료. `INTERNATIONAL_DISTRIBUTION.md`에 스토어별 무료/유료 조건과 언어 공백 기록. 다른 스토어 실제 등록 전이며 우선 후보는 Uptodown, Galaxy Store다.

> **후속 요청:** 비공개 테스트를 먼저 등록하고 사용자 본인이 실제 테스터를 모집한다. 현재 Alpha 초안까지 저장됐고 업로드/심사 미완료다. 최신 상세와 막힌 단계는 `CLOSED_TEST.md`를 우선한다. PR1은 `e5c1eea7a25766e1a20fa1ea942d73ec58c673c4`로 main 병합 완료.

먼저 이 문서, `PUBLIC_PREVIEW.md`, `RELEASE_GATES.md`를 읽고 Git 상태·실제 계정 사용량을 확인한다. Obsidian 요청이 아니므로 Vault에 접근하지 않는다.

## 최신 사용자 결정

Life Quest를 현대 판타지 상태창 습관 RPG로 개선해 Google Play에서 수익화한다. 사용자는 기획·개발·배포 권한을 위임했다. 특정 작품을 복제하지 않으며, 무료 공개 온디바이스 AI가 핵심이다. 아트는 image_gen 또는 권리가 확인된 무료 이미지/템플릿만 사용한다. 수제 SVG/HTML/Canvas 아트는 추가하지 않는다.

**사전 테스터를 모집할 수 없으므로 먼저 공개해서 반응을 본다.** 이전 자체 12명 파일럿·5명 독자 검수를 직접 APK 공개의 필수 조건으로 되살리지 않는다. Google Play의 실제 계정 요건은 별개이며 가짜 계정/참여로 대체하지 않는다. 누구에게도 모집 메시지를 보내지 않았다.

**최신 사용량 하한은 잔여20%.** 반드시20%까지 소모하라는 뜻이 아니다. 9/21 해외 배포 조사 시작 시 주간 사용46%/잔여54%였으며, 공유 계정이므로 재개할 때 다시 조회한다. 이전60%/70% 하한은 폐기됐다. 자동 일정·새 작업·목표·서브에이전트는 만들지 않았다.

## 실제 공개 완료

- 다운로드 페이지: https://sn-bow.github.io/Life_Quest/
- 무료 Android 공개판: https://github.com/Sn-bow/Life_Quest/releases/tag/v2.0.0-preview.1
- GitHub 공개 시각 2026-09-21 00:53 KST. draft=false, prerelease=true. **Google Play 정식 출시나 매출 발생은 아니다.**
- Android8+/ARM64, **2.0.0+7**, main 진입점. Cloud/Billing/Ads/Research 모두false. 자동 분석 없음.
- 공개 파일 `LifeQuest-2.0.0-preview.1-arm64.apk`, **160,519,338bytes**, SHA256 `587da3cee0a5d55a62e3158a404f36a6ea55045193ab505d98ce9e708c172a88`.
- 실제 앱 소스 **d69aafbaef9b761198af29ac07c76dae5ddb0f24**. 태그는 이 커밋을 가리킨다. 이후 변경은 배포 기록/문서다.
- 공개 링크에서 전체 APK를 내려받아 해시 일치 확인. 자체 검증 다운로드는 수요·설치자·재방문으로 집계하지 않는다. 근거 `public-distribution.json`, `public-preview-apk.json`.
- 사이트는 gh-pages **aee4c152800203b2e2cee213f59e2e908b051fe4**, Pages built 확인. 기존 생성 아트 재사용, 다운로드/제약/문의/정책 포함. CUA 데스크톱·390px 로컬 확인과 공개 페이지 확인은 `PUBLIC_PREVIEW_UX.md`. 브라우저에서 작동하는 앱 자체를 공개한 것은 아니다.
- APK는 자동 업데이트되지 않는다. Play 앱 서명과 다르면 전환 시 백업 후 재설치가 필요할 수 있음을 안내했다. 사용자의 기록을 지우지 않는다.

## 저장소와 도구

- Repo `/Users/jeonghyeonseok/Documents/ChatGPT/Life_Quest`, 작업 branch `codex/rebirth-2026-09`, 이전 main `bdc7801`.
- PR https://github.com/Sn-bow/Life_Quest/pull/1. 재개 시 실제 병합 상태와 main을 확인한다. 다른 main checkout `~/.graphify/repos/Sn-bow/Life_Quest`는 이 세션에서 변경하지 않았다.
- Flutter `~/.local/share/lifequest/flutter/bin/flutter`3.47.4, Dart3.13.3, JDK21 `/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home`, Android SDK `~/Library/Android/sdk`, build-tools36.0.0.
- **Flutter pub/gen-l10n/analyze/test/build/run은 같은 checkout에서 직렬 실행.** `--no-pub` APK 빌드의 오래된 플러그인 등록 오류는 일반 release 빌드로 해결했다. 생성 등록 파일을 손으로 우회하지 않았다.
- Firebase CLI `/opt/homebrew/bin/firebase`, bundletool `~/.local/share/lifequest/tools/bundletool-1.18.3.jar`.
- Python 모델 런타임 `~/.local/share/uv/tools/litert-lm/bin/python`. 로그/합성 입력/다운로드/검사용 산출물은 Git 제외 `qa_artifacts/rebirth/`.
- UI는 CUA. 실제 Android 기기 미연결. Android Emulator는 이번 CUA에서 조작할 수 없었다. UI 입력/캡처를 adb나 다른 도구로 우회하지 않는다.
- 기존 로컬 앱 프리뷰8766은 합성 QA 상태이며 연구true일 수 있다. 일반 공개판으로 혼동하지 않는다. 새 다운로드 사이트 확인용8767은 종료해도 된다.

## 계정과 외부 상태

**Firebase 지정 계정 hyeonseok460.** `lifequest-crossing-2026`를 실제 생성했고 Android `com.lifequest.app`, appID `1:61563760091:android:4f449ea668e5a19120cbfe`, 공개 업로드 인증서를 등록했다. Spark무료, Firestore(default)서울 `asia-northeast3`, STANDARD/FIRESTORE_NATIVE, 클라이언트 모두 거부 규칙 및 삭제 보호 적용. 과금 계정/Blaze 연결 없음.

Auth/Functions/AppCheck/Storage/구매 검증/RTDN/신고 서버는 아직 배포하지 않았다. 새 서비스 계정 키나 권한 확대도 없다. 앱 Cloudfalse이므로 이 프로젝트에 앱 기록을 전송하지 않는다. `.firebaserc`, Android SDK 설정, `lib/firebase_options.dart`는 새 프로젝트를 가리킨다.

잠금 규칙은 `firebase.bootstrap.json` + `firestore.bootstrap.rules`로만 배포했다. **기본 firebase.json을 일괄 배포하지 않는다.** 운영 규칙·함수는 아직 준비 대상이다. Firestore서울과 기존 Functions/us-central1 호출 설정은 실제 클라우드 기능을 켜기 전에 함께 검토한다. gcloud 활성 계정hyeonseok45는 다른 계정이므로460 조회·배포 근거로 쓰지 않는다.45 계정의 다른 프로젝트는 변경하지 않았다.

**Google Play Log_Ian**, developer8167226228602257815, app4972166589004992203, packagecom.lifequest.app. 9/21 실제 프로덕션 화면에서 ‘아직 프로덕션에 액세스할 수 없습니다’를 확인했다. 대시보드의 Console 오류와 별개다. 공식 개인 계정 요건: https://support.google.com/googleplay/android-developer/answer/14151465?hl=en . 실제12명 연속14일 참여 후 신청/심사이며, 직접 APK 배포가 이를 충족하지 않는다.

내부 테스트 릴리스1 초안과 EN/KR 노트를 저장했다. EN/KR 등록정보 설명도 저장돼 있다. AAB 선택은 Chrome 확장 파일URL 권한 제한으로 실패했고 공식 설정 안내를 이미 전달했다. 권한 변경 없이 재시도/우회하지 않는다. AAB 업로드·프로덕션 제출·상품 판매 없음. 실제 Android 스토어 캡처·최종 선언/데이터 보안·인앱 AI 신고 운영도 남아 있다. 사용자에게 사전 친구 모집을 다시 요구하지 않는다.

## 제품과 수익 방향

**Life Quest: 경계의 서가 / The Crossing Library.** 기록자가 작은 현실 행동으로 도시·수련·탐사의 책을 이어 읽는다. Today/Quests/Dungeon/Growth 네 탭, 읽기 좋은 상태창, 선택형 카드 탐험. 무림로그인·더 게이머·퀘스트지상주의·전독시·영지설계사 공식 소개와 LifeUp/Finch를 참고했으며 전편 정독이나 해당 IP 사용을 주장하지 않는다.

무료3권×4장면×4언어, 누적 현실0/1/3/6개로 해금. 책 전환/재독/선택/백업 유지. 읽기로 XP를 주지 않으며 휴식으로 일상 XP를 깎지 않는다. 조수 우체국은12장면×4언어·두 결말·테마·표식, 처음2장면 무료 체험. **판매off, 가격미정.** 2,900/4,900/6,900원은 가설이고 실제 수요·매출은 없다. 본편 원고/번들은 공개 저장소이므로 독점 콘텐츠/DRM을 주장하지 않는다.

수익 방향은 무료 개인화/백업 + 선택 구매하는 완결 이야기·장식이다. 광고·실패 페널티 과금·능력치 판매·AI 구독은 현재 도입하지 않았다. 먼저 공개 의견과 실제 사용 문제를 보고 콘텐츠·가격을 결정한다. 공개 파일 다운로드만으로 수익화 근거가 확보됐다고 말하지 않는다.

## 이번 코드와 품질 근거

- 설정에4언어 피드백/도움말 추가. Cloudoff AI 추천 신고는 문구 검토→명시적 복사→문의 페이지다. 자동 전송되지 않으며 ‘접수 완료’라고 거짓 표시하지 않는다. 개인 목표/전체 기록을 자동 첨부하지 않는다. 공개 이메일과 GitHub 이슈 경로를 제공했다.
- 실제 온디바이스 모델 샘플에서 목표와 무관한 외국어 학습을 발견해 학습 슬롯을 해당 분야 단어/용어로 변경했다. 임의 초 단위 시간·밤 말하기·체중감량 정당화·숨 참기·송금·보이지 않는 제어문자 검사를 보강했다. 실패 시 앱의 기본 추천으로 돌아간다.
- **Flutter 전체414통과**, 결제카탈로그1개 기본off 의도적skip. analyze clean. `preview-full-tests.log`, `preview-analyze.log`. 4언어320px/200% 수동 신고·복사·무전송 경계 포함. 변경 후 전체 실행했다.
- 실제 Gemma4E2B + LiteRT-LM으로4언어×6조건24회 생성:19채택/5기본추천, 엔진오류0. 앱 파서24조건검사 통과. Mac 지연7.43–12.27초/중앙8.46초이며 실물 성능이 아니다. `AI_QUALITY_REVIEW.md`, `ai-quality-20260921.json`. 인간 번역 검수·전반적 안전성 보증이 아니다.
- 모델은 Apache2, 선택다운로드2,588,147,712bytes, revision/hash 고정. CPU4/context2048/output550/thinkingoff. AndroidAI는 ARM64 및 총RAM>=5500MiB 조건이다. 모델 미설치에서도 기본 추천 가능. API 호출료 없음과 모든 운영비 무료는 구분한다.
- Node22서버27개는9/20 기준선. Firestore/Storage에뮬레이터9개·manifest7조합·signed/R8 모델/백업 probe는9/17 결과이며 이번에 재실행했다고 쓰지 않는다. 실제 기기/RAM/발열/배터리/파일 선택기/TalkBack은 남아 있다.
- 기존 연구 코드/집계 도구는 보존됐으나 공개판 Researchfalse다. 사전 모집 조건이 아니며 합성 QA를 실제 참여/사용자 반응으로 계산하지 않는다.

## 최신 파일과 재현

공개 APK 로컬 사본: `qa_artifacts/rebirth/LifeQuest-2.0.0-preview.1-arm64.apk`. 원본 `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`. 오래된 `app-release.apk`나 v6 연구용 APK를 대신 배포하지 않는다.

같은 앱 소스의 기본 AAB: `build/app/outputs/bundle/release/app-release.aab`, versionCode7, **221,661,496bytes**, SHA256 `6d1b9ff4d4388330a2d523c3a78955017bc00e8c668edc7b6bbbb065ccddd1ca`. 표본 ARM64/API35 다운로드130,435,164bytes. 서명/manifest/11ELF/기기splitZIP16KiB/QA진입점제외 검사 통과. `artifact-inspection.json`. Play업로드는 미완료다.

공개 업로드 인증서 SHA256 `15:37:D6:F3:9E:E3:EE:D1:53:E1:34:12:8B:BE:66:11:32:18:38:47:CA:3A:A7:F4:B5:11:27:6B:FD:35:2B:B3`. 비밀키/인증저장소/토큰을 열거나 출력하지 않는다. 검사split `v7-inspection-only.apks`는 debug서명이므로 배포하지 않는다. `REVIEW_BUILDS.md`에 재현 명령이 있다.

## 다음에 이어갈 일

1. 자발적으로 들어온 공개 이슈/문의와 실제 파일 다운로드 현황을 확인한다. 사용자 메시지나 평가를 만들거나 타인에게 연락하지 않는다. GitHub 다운로드에는 자체 검증도 섞이므로 고유 설치자·유지율로 보고하지 않는다.
2. 연결 가능한 실제 Android가 생기면 네이티브 저장/복원·모델 설치/중단·TalkBack·발열부터 확인한다. 공개판을 ‘실물 검증 완료’로 바꾸지 않는다.
3. Play는 실제 계정 접근 요건·파일 업로드 권한이 해결되면 최신 AAB/최종 그래픽/선언/AI 신고 운영을 준비해 제출한다. 자동화 도구가 플랫폼 요건을 없애지는 않는다.
4. 유료 판매는 실제 구매 검증·환불·복원·신고/삭제 운영과 가격/콘텐츠 판단을 마친 뒤 켠다. 무료 공개 완료와 Google Play 출시/수익화 완료를 구분한다.
