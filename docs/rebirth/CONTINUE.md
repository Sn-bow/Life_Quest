# 재개 체크포인트 · 2026-09-21

> **2026-09-28 XP 분리 후 최신 서명 후보:** 새 카드 탐험은 캐릭터 XP를 주지 않고 골드·구역 해금만 유지하며, 업데이트 전 저장된 탐험의 XP는 한 번만 지급한다(`49fa8fc`). 전체 Flutter 510통과/1 의도적 skip, analyze clean. 새 signed AAB `build/review/life-quest-2.0.0-2013-paid-candidate.aab`는 소스 `4076e83`, SHA-256 `2b95f237fdde7e9518fe23c0f0042ec6c49cdb8ca8d10c7bca34c4f437851c6`, [54개 로컬 검사](paid-candidate-2013-inspection.json) 통과다. 새 signed QA APK `build/review/life-quest-2.0.0-2013-paid-review.apk`의 SHA-256은 `dee00c5916d0b20c09ca0708110b61217bebddd519c8172eb34053a2153c758e`이고 API35 에뮬레이터에 데이터 유지 업데이트 설치했다. 아래 이전 AAB·APK 해시는 당시 이력이며 **현재 파일을 가리키지 않는다**. 새 탐험 결과 화면의 Android QA와 Play/Firebase 운영 연결·실거래 검증은 남아 있다.

> **2026-09-28 최신 준비 상태:** 최종 signed QA APK `2.0.0+2013`를 Android Studio에서 실행해 신규 사용자 `0 / 150 XP`의 [상태창·기본 추천 퀘스트를 일본어·영어·한국어·대만 번체로 각각 실촬영](design/status-system/qa/LOCALIZED_STORE_SCREENSHOTS_20260928.md)했다. Play용 1080×1920 RGB JPEG 8장과 원본 PNG 8장이 저장소에 있고, 이전 소유자 QA 기록은 보존했다. [단위 경제성 민감도](market/UNIT_ECONOMICS_20260928.md)는 가정에 따른 손익분기점일 뿐 실수요 검증은 아니다. [계정 감사](market/PREDEPLOY_ACCOUNT_AUDIT_20260928.md)상 판매자 프로필·Blaze·App Check·Play 상품/권한·실거래는 미완료다. 앱 AAB와 이미지의 Play 업로드는 하지 않았다. 아래의 오래된 '최종 0XP 캡처 미확보' 문장은 당시 기록이며 이 최신 상태가 우선한다.

> **2026-09-28 게임 범위 질문 이후:** [게임 범위 결정](market/GAME_SCOPE_DECISION_20260928.md)을 재확인했다. 카드 전투 확대의 매출·유지 효과를 입증한 재조사는 없으므로 새 게임 개발은 보류하고 기존 탐험만 보조 화면에 둔다. Play Console [네 언어 스토어 문안 초안](store/PLAY_CONSOLE_DRAFT_STATUS_20260928.md)은 저장됐지만 이미지 파일 접근 및 앱 콘텐츠 페이지 오류로 제출 준비가 끝나지 않았다. [비공개 테스트 모집 실행안](CLOSED_TEST_RECRUITMENT_KIT_20260928.md)은 실제 링크가 생긴 후에 사용한다. Android 코드/자산은 변경 없고 아래 signed +2013 AAB는 그대로다. 이후 백엔드 소스 `cfb1752`까지 RTDN 취소·환불 누락 보정·Storage 구매 전용 계정 제한을 추가했고 Node49, Firestore/Storage 에뮬레이터11을 통과했다. Functions/Storage 규칙은 **미배포**이며 Blaze·Cloud Scheduler·Play 금융조회 권한·실제 결제/환불 검증이 남아 있다. 배포는 사용자 다음 명령 전까지 하지 않는다.

> **2026-09-28 오후 재개 우선:** 사용량 하한은 사용자가 승인한 **잔여 20%**이며 실제 조회값은 매번 다시 확인한다. 최신 소스 `e6dd1ea`의 `2.0.0+2013` signed AAB는 `build/review/life-quest-2.0.0-2013-paid-candidate.aab`(SHA-256 `be65f4e7751d4f82c0e7b845da09eb20415f5a76bf1a472d048a16e2d58864ab`), signed Android QA APK는 `build/review/life-quest-2.0.0-2013-paid-review.apk`(SHA-256 `beabedbc176642d83fa8e8b80baeeec8429420a3a608bf9e27e8229fffa1ec90`)다. [실제 AAB 검사](paid-candidate-2013-inspection.json)는 통과했다. Flutter 전체 508통과/1 의도적 skip, Cloud/Billing on41·Node42·에뮬레이터 규칙10·Python 권한2 통과. Android API35/420dpi(1080×1920) 데이터 유지 업그레이드와 일본어 상태창 프레임 하단·미배분 포인트·PLUS 버튼 표시를 실화면에서 확인했다. 최종 APK의 일본어 상태창·현실 퀘스트 JPEG 2장은 실제 Android에서 확보했고 상세 칭호 현지화도 확인했다. 신규 게스트 0XP 사이트 이미지는 최종 현지화 패치 전 동일 3탭 UI 촬영본이며, 최종 빌드의 0XP Play용 캡처는 Android Studio의 검정 캡처 문제로 확보하지 못했다. Firebase에는 업로드·Play 배포 인증서 4개를 등록하고 Auth 3제공자·Firestore 규칙을 배포했다. **콘솔 직접 확인 장애:** Firebase Spark·Storage 버킷 없음·App Check 미등록, Play 앱 draft/Alpha 무버전·판매자 계정 없음. Blaze 종량제 허용 한도, App Check 약관 동의, Play 판매자 프로필 값/약관 동의를 사용자에게 비동기 질문으로 요청했고 답변 전 해당 조치는 보류한다. 앱 AAB 업로드·테스터 배포는 사용자의 다음 명령 “배포까지 진행해” 전에는 하지 않는다. [계정 감사](market/PREDEPLOY_ACCOUNT_AUDIT_20260928.md)와 [유료 후보](market/PAID_RELEASE_CANDIDATE_20260928.md)를 먼저 읽는다.

> **2026-09-28 오전 후보 이력:** 사용자는 이번 작업의 하한을 **잔여 사용량 20%**로 넓혔으며 9/28 조회는 사용36%·잔여64%다. `market/PAID_RELEASE_CANDIDATE_20260928.md`를 먼저 읽는다. `status_window_plus_01` 외관3종·실제 완료 기록의30/90일 보고서·PNG/TXT/CSV 저장을 구현하고 기존 Google/이메일 클라우드 계정 구매 연결, RTDN 환불·ack 작업 큐·7일 오프라인 권한을 보완했다. **최종 후보 2.0.0+2013** signed AAB `build/review/life-quest-2.0.0-2013-paid-candidate.aab`의 SHA256은 `cc22c31f9c3e953f21fbc05cc488264240885fe7b1d9bd8a96e72e43f31bfff8`이다. 당시 별도 로컬 검사에서 versionCode2013·매니페스트·서명·16KB 정렬을 통과했고 표본 ARM64/API35/16KB 다운로드는 149,172,637bytes였다. 이 검사 JSON 경로는 이후 최신 후보 검사로 갱신됐으므로 이전 SHA와 연결하지 않는다. 당시 소스 커밋은 `7dd7312`. Flutter analyze clean, 전체497통과/1skip, Cloud/Billing on41통과, Node42, Python 권한2통과. 이전 `2.0.0+12` signed AAB `build/review/life-quest-2.0.0-12-paid-candidate.aab`와 SHA256 `4d1eb1f7a987fa5858cbd081ad5f1802db060b01a71a7ac5fe208300f5b3de88`는 **이력 산출물**이다. 상태창 아이콘/배너 생성 이미지, 네 언어 스토어 문구와 번체 QA, 웹사이트 로컬 개편을 준비했다. 당시 Android 실제 화면 캡처는 아직 없었고 기존 390×844 내부 캡처는 Play 비율 규격을 충족하지 못했다. 이후 위의 최신 점검을 우선한다. **유료 수요·실거래·Play 판매 설정은 아직 검증/활성화되지 않았고 배포는 사용자의 다음 요청까지 하지 않는다.** 이전 아래의 잔여70% 하한 및 확장팩 미구현 메모는 당시 기록이다.

> **2026-09-27 최신 태블릿/수익화 검토:** 최신 요청은 휴대폰·태블릿 UI 수정과 실제 돈을 받을 수 있는 완성 앱의 배포 직전까지 작업이며, 무료 프리뷰/초안을 완료 단계로 계산하지 않는다. 잔여70% 하한 유지, 최종 조회 사용29%·잔여71%, 한도 확장 질문은 답변 대기/리셋 사용 없음. `docs/rebirth/design/status-system/TABLET_RELEASE_REVIEW_20260927.md`와 `docs/rebirth/MONETIZATION_READINESS_20260927.md`를 먼저 읽는다. 태블릿 raster 테두리의 글자 겹침, 상세 상태 큰 글자/배분/팝업, XpBar overflow 수정. 관련45·전체Flutter451통과/1skip·Cloud/Billing on 상품 테스트1통과·analyze clean. 서버의 앱 종료 후 구매 acknowledgment 복구를 private 작업 큐로 구현, 정책31통과(Node24 로컬, 원격Node22 미검증). 무료/유료 artifact 정책검사2통과, 실제 유료 AAB versionCode10의31검사 통과. 파일 `build/review/life-quest-2.0.0-10-paid-candidate.aab`는 Cloud/Billing on·Ads/QA off 후보이며 판매/출시 가능 판정이 아니다. 상태창 중심 새 유료 혜택의 구현/권한 연결, 가격/정산, Blaze/Auth/AppCheck/Play API/RTDN/private 큐 IAM, 실제 구매/복원/환불과 Android 실기, 제출 자료/Play 접근 검증이 남아 있다. 현재 Tide 단편과 핵심 상태창 구매 이유의 공백을 발견했고 확장팩은 권고/미구현이다. 수익성 불가능을 입증한 것은 아니며 우리 앱의 실제 매출/구매 전환은 없음. Play/Firebase 배포·상품 활성화·SNS·과금 계정 변경 없음. 완료 유료 출시라고 보고하지 않는다. 추가 작업 전 사용량과 사용자 하한 답변을 재확인한다.

> **2026-09-27 이전 v9 구현 기록:** 사용자가 조사 이후 앱 구현 변경을 명시적으로 지시했다. 사용량 하한은 **잔여70%**이며 아래5%/20%는 과거 이력이다. 최종 단계 조회 사용28%·잔여72%, 리셋 크레딧 사용 없음. `docs/rebirth/design/status-system/HUNTER_WINDOW_V9.md`를 먼저 읽는다. 첫 화면을 실제 이름·레벨·현지화 칭호·XP·4능력치·미배분 포인트의 개인 상태창으로 재구성했고, 퀘스트/성장 기록을 내부 메뉴로 옮겼다. 능력치 조회, 360ms 호출/모션 감소, 돌발 신호, 실제 보상 결과를 연결했다. 프레임은 생성 RGBA PNG이며 수제 SVG/HTML/Canvas 아트 없음. analyze 문제 없음·관련25테스트 통과·Web/ARM64 APK 최종 빌드 및 서명 확인. 검토 APK `build/review/life-quest-2.0.0-9-hunter-status-arm64.apk`(split ABI 실제versionCode2009). 신규 QA0XP→테스트 완료70XP→재진입70XP 유지 확인, 실제 사용자 반응 아님. 상세 배분 화면 전체의 시각 변경과 Android 실기 확인은 남아 있다. Play/SNS/수익화 변경 없음. v8 거절을 보존하고 v9 디자인 승인/출시 완료로 간주하지 않는다. 105개 IP 조사와 확인 수준은 `docs/rebirth/research/status-window-100/README.md`, `DESIGN_TRANSLATION.md`, `FOLLOWUP_20260927.md`에 유지했다. 코드가 포함된 최신 체크포인트를 아래 연구 전용 이력보다 우선한다. 추가 작업 전 사용량을 다시 확인한다.


> **최우선 재개 기준 — 2026-09-22 사용자 디자인 거절:** v8의 배경 일러스트 + 상태 요약 + 추천 할 일 구조가 요구와 다르다고 사용자가 명확히 지적했다. 첫 화면은 헌터물의 상태창 자체여야 한다. [수정 기준](design/status-system/STATUS_FIRST_CORRECTION.md)을 먼저 읽는다. 이번에는 현재 첫 화면을 재확인하고 설계 기준만 기록했다. 코드/배포 변경 없음. 아래 ‘구현/QA 완료’는 기술 이력이며 디자인 승인 아님. 다음은 복수 작품의 실제 상태창 패널 조사 → 상태창 자체의 시안 → 확인된 방향으로 실제 Flutter 첫 화면 재구성. 잔여 사용량5% 하한이 최신이며 아래20%는 과거 이력이다.

> **2026-09-22 최신 구현:** 사용자 승인으로 상태창 디자인·돌발 의뢰·완료/레벨업·실제 보상 기록을 구현했다. 앱 소스 `785cf93` (기능 `0ea5125`), [조사/화면/검증 체크포인트](design/status-system/README.md)를 우선한다. 427 tests pass/1 intentional skip, 최종 관련21 tests pass, analyze clean. ARM64 2.0.0+8 APK `build/review/life-quest-2.0.0-8-status-arm64.apk`, 서명/16KiB 검사 통과. Web QA 실제 UI 검증 완료, Android 실기 미검증, Play 미업로드. 돌발은 검수4종·앱 내 방식, AI 돌발 문장/푸시는 미구현. 기존 마케팅 초안 변경은 작업 시작 전 변경으로 남겨 두었다.

> **현재 작업 범위 — 전체 구조만:** 사용자가 기존에 발견한 고칠 부분들도 돌발 퀘스트와 **함께 구조를 잡으라**고 명확히 했다. `STATUS_WINDOW_PRODUCT_STRUCTURE.md`에 상태창 통합, 완료 결과, 일별 변화, 공통 보상 기록, 주간 집계와 돌발 연결을 정리했다. `SYSTEM_QUEST_STRUCTURE.md`는 돌발의 발생/수락/거절/기한/보상/AI 상세다. **아직 구현하지 말라**는 지시가 유효하다. 이후 명시적 구현 지시 전까지 앱 코드·프롬프트·알림·배포를 변경하지 않는다.

> **최신 제품 대조:** `STATUS_WINDOW_PROMISE_AUDIT.md` 확인. 로컬 웹 흐름에서 퀘스트→XP는 작동하지만 상태창 약속은 부분 충족. 오늘 기본XP와 실제 보너스XP 불일치, 월요일 주간 집계 누락, 일별 성장 비교/완료 피드백 부족을 확인했다. 코드 수정은 아직 하지 않았다. 마케팅 문구를 제품 구현 완료로 해석하지 않는다.

> **최신 타깃 수정:** 사용자가 일반 RPG 타깃과 대만 고정을 바로잡았다. 상태창·퀘스트·레벨업 현대 판타지 웹툰/웹소설 독자를 우선한다. `marketing/TARGET_MARKETS.md` 근거로 일본어 소개부터, 영어권 비교를 준비했다. 프랑스 후속 후보. 국가별 구매 전환은 미확보. 콘셉트/출시전략/Threads 원고에 반영했으며 UI 개편·SNS 게시·Play 배포를 완료한 것은 아니다.

> **최신 사용자 지시:** Clutter 사례를 참고해 Google Play 중심 + 한국/대만/일본/영어권 현지화 + Threads 유입에 집중한다. 추가 스토어 입점은 후순위. `PLAY_GLOBAL_LAUNCH.md`와 `marketing/THREADS_STARTER_KIT.md`에 방향·계정 이름·소개·KO/TW/EN/JA 원고와 운영안을 저장했다. 사용자가 계정을 직접 생성한다. 공개 게시/DM은 실행하지 않았다.

> **이번 실행 결과:** 일본어 스토어 설명을 Console 초안에 저장, 재진입 후3필드 원문 일치 확인. Alpha3/4·비활성, 검토700F193F 오류 재현. 앱 업로드/참여 링크/심사 제출은 여전히 미완료. 권한 상태 질문에 답변 대기 중이며 파일 업로드를 우회하지 않았다.

> **해외 확장:** Alpha 대상 국가 한국·대만·일본·미국·캐나다·프랑스 6개 저장/재진입 확인. 활성화/출시는 미완료. `INTERNATIONAL_DISTRIBUTION.md`에 스토어별 무료/유료 조건과 언어 공백 기록. 다른 스토어 실제 등록 전이며 우선 후보는 Uptodown, Galaxy Store다.

> **후속 요청:** 비공개 테스트를 먼저 등록하고 사용자 본인이 실제 테스터를 모집한다. 현재 Alpha 초안까지 저장됐고 업로드/심사 미완료다. 최신 상세와 막힌 단계는 `CLOSED_TEST.md`를 우선한다. PR1은 `e5c1eea7a25766e1a20fa1ea942d73ec58c673c4`로 main 병합 완료.

먼저 이 문서, `PUBLIC_PREVIEW.md`, `RELEASE_GATES.md`를 읽고 Git 상태·실제 계정 사용량을 확인한다. Obsidian 요청이 아니므로 Vault에 접근하지 않는다.

## 최신 사용자 결정

Life Quest를 현대 판타지 웹툰/웹소설 독자를 위한 현실 상태창·퀘스트 앱으로 개선해 Google Play에서 수익화한다. 사용자는 기획·개발·배포 권한을 위임했다. 특정 작품을 복제하지 않으며, 무료 공개 온디바이스 AI가 핵심이다. 아트는 image_gen 또는 권리가 확인된 무료 이미지/템플릿만 사용한다. 수제 SVG/HTML/Canvas 아트는 추가하지 않는다.

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
