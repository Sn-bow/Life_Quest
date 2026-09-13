# 재개 체크포인트 · 2026-09-14

먼저 이 파일, `PRODUCT_BRIEF.md`, `ON_DEVICE_AI_DECISION.md`, `BILLING_AND_RELEASE.md`를 읽고 현재 Git 상태와 계정 사용량을 확인한다. Vault/외부 두뇌 요청이 아니므로 Obsidian에는 접근하지 않는다.

사용자 목표: Life Quest를 현대 판타지 상태창 느낌의 습관 RPG로 전면 개선하고 Google Play에서 수익화할 수준으로 출시. 무료 공개 온디바이스 모델이 필수. 디자인은 실제 레퍼런스 조사에서 출발한다. 사용자에게 기획·구현·배포 권한을 위임받았으므로 준비된 작업의 승인을 반복 요청하지 않는다. 이번 회차는 계정 잔량 20% 부근에서 보존하고 다음 회차로 이어간다. 잔량은 공유 계정 한도라 정확한 토큰 예산이 아니다.

## 위치와 재개 방법

- 작업 폴더 `/Users/jeonghyeonseok/Documents/ChatGPT/Life_Quest`, branch `codex/rebirth-2026-09`, base bdc7801. clone은 `~/.graphify/repos/Sn-bow/Life_Quest`.
- Draft PR: https://github.com/Sn-bow/Life_Quest/pull/1. main 병합/공개 릴리스는 아직 하지 않았다.
- Flutter `/Users/jeonghyeonseok/.local/share/lifequest/flutter/bin/flutter` 3.47.4 / Dart 3.13.3. JDK21 `/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home`. Android SDK `~/Library/Android/sdk`.
- **Flutter pub/analyze/test/build/run은 직렬 실행.** plugin registrant와 빌드 산출물을 공유한다. R8 build는 3–4분이 걸린다. 로그는 Git 제외 `qa_artifacts/rebirth/`.
- 전용 Android QA AVD `LifeQuest_API35_16KB`, ARM64 API35 / 16KiB / 6GB, emulator-5556. 모델 cache 다운로드됨. Native QA probe와 제품 main entrypoint를 혼동하지 않는다.
- CUA 브라우저로 실제 UI 관찰/조작. adb로 UI 입력·스크린샷을 우회하지 않는다. CLI는 개발/테스트/설치/로그에만 사용. 현재 CUA에서 에뮬레이터 native surface는 제공되지 않았다.
- Web 미리보기 `flutter build web --release`, `build/web`을 localhost:8765에서 제공. 현재 브라우저 프로필은 합성 QA 데이터. 실물 Android 검증과 구별한다.

## 구현·검증 완료

- 오늘/퀘스트/던전/성장 4탭, 상태창과 행동 중심 레이아웃, 쉬는 날 XP/레벨 차감 제거. LifeUp/Finch/ARISE의 구조·색 대비를 참고했고 타 작품 IP 아트는 복사하지 않았다.
- 계정 없이 기기 전용 시작, 온보딩, 상태 손상 보존, 저장/로그아웃/재시작 경로. 기기 프로필과 개인화 이력은 기본적으로 업로드하지 않는다.
- **Gemma 4 E2B IT, Apache-2.0, LiteRT-LM 0.17.0**. 약 2.59GB 선택 다운로드, 고정 revision/checksum, 취소/재개/삭제, 네이티브 CPU 생성. Gemini Nano/AICore/클라우드 LLM/API 키 없이 작동. Qwen3.5 2B와 비교 실측 후 선택.
- 제품 파서 4언어 × 신규/긴 기록 8/8 통과, 입력 419–630토큰. 값/보상/시간/슬롯은 앱 소유. 조용한 시간대/안전 필터/실패 시 기본 추천. 의미 품질과 실제 휴대폰 성능은 아직 인증되지 않음.
- R8에서 JNI getter 제거로 SIGABRT를 재현·수정. signed native release 신규/긴 기록 21,364/11,748ms, 따뜻한 재실행 9,368/7,867ms. 에뮬레이터 측정이다. `native-release-probe.json`.
- 무료 4장면 원작 프롤로그 「0번 출구」, 4언어. 0/1/3/6개 완료 해금, 선택 반영 대사·저장·다시 읽기. 읽기/선택으로 XP를 늘리지 않는다.
- 무료 암호화 파일 백업: AES-256-GCM + PBKDF2-SHA256 600k, 확인/복원/undo/journal, 손상 프로필에서 복구. Dart→Android→Python 상호 해독, 실제 UI export/import/restart/undo 확인. 네이티브 파일 선택기 UI는 실기기에서 확인해야 한다. `DEVICE_BACKUP.md` / `backup-validation.json`.
- 던전 첫 CTA, 보너스 접기, 지도 버튼/경로 이름, 4언어 안내, 다시 여는 도움말, 읽기 쉬운 보상 선택. 안내/보상에서 배경 semantics·focus 차단. 이전 갈림길이 계속 열리는 로직과 미완료 방문의 다른 경로 진입을 수정. 320px/200%/4언어 입장·지도·보상 테스트 포함. `UX_AUDIT.md`와 `screens/`.
- Flutter analyze 및 **240개 테스트 통과**. 서버 Node22 15개, Firestore+Storage emulator 8개는 앞선 commit에서 통과했고 그 코드에는 이후 변경 없음.
- Android 자동 FirebaseInitProvider 제거; 명시적 Cloud 플래그에서만 초기화. 자동 cloud/D2D 백업 제외. 기본 Cloud/Monetization/Ads는 모두 꺼져 있다.
- 최종 main AAB 216,527,189 bytes, SHA256 `957f5234da51c1869febb66d21ad068f345164f09f75805660d9387691e734ef`, 표본 기기 다운로드 128,276,151 bytes. AAB/서명/manifest/native ELF/split 검증 증거는 `artifact-inspection.json`. 검사 스크립트는 실제 바이너리와 공개 인증서를 검사하며 QA target 문자열을 거부한다. 이 검사는 Play 업로드/공개 승인과 다르다.

## 운영 상태와 사용자 답변 대기

- Play: Log_Ian > Life Quest (`com.lifequest.app`, 2.0.0+3).
  https://play.google.com/console/u/1/developers/8167226228602257815/app/4972166589004992203/app-dashboard
- 앱 서명 설정됨. 업로드 인증서는 아직 등록 전이며 첫 AAB를 아직 올리지 않았다. 프로덕션 접근은 **12명/14일 연속 비공개 테스트** 필요. 현재 참여 0명. 실물 Android 기종 및 테스터 확보 여부를 질문했고 답변 대기.
- **Firebase `life-quest-app-95eb9`는 삭제 상태**. 기존 Android app ID도 구 패키지에 묶여 있다. 복원/새 프로젝트 선택을 질문했고 답변 대기. 임의 복원·프로젝트 생성·요금제 연결·배포 없음. Functions는 Blaze/결제 계정 검토 필요; 모델의 무료 실행과 별개다.
- 기존 배포 키 비밀값은 재사용하지 않았다. 새 key/p12/password는 `~/.local/share/lifequest/signing/`와 Git 제외 android/key.properties. 내용을 출력·업로드하지 않는다. 공개 SHA256: `15:37:D6:F3:9E:E3:EE:D1:53:E1:34:12:8B:BE:66:11:32:18:38:47:CA:3A:A7:F4:B5:11:27:6B:FD:35:2B:B3`.
- **개인정보/약관/삭제 공개 페이지 정상 배포·CUA 검증 완료**: https://sn-bow.github.io/Life_Quest/ (#privacy, #terms, #delete-account).
- Pages는 orphan `gh-pages` branch / root. 정책 checkout `~/.local/share/lifequest/policy-site.daHZpl`, 9a3b460까지 반영. 앱 branch의 docs/index.html이 canonical. 변경 후 checkout에 복사·commit·push, 필요 시 `gh api --method POST repos/Sn-bow/Life_Quest/pages/builds`. 앱 main을 정책 게시 때문에 병합하지 않는다.
- Play 앱/생산성 카테고리와 기존 공개 지원 이메일·HTTPS 웹사이트를 초안에 저장했다. 심사 제출은 하지 않았다. `store/`의 한국어·영어 이름/소개를 기본 스토어 등록정보 임시보관함에 저장했고 저장 성공을 확인했다. 필수 그래픽이 없어 등록 완료/심사 가능 상태는 아니다. 원문과 실제 테스트 계획을 같은 폴더에 보관. 기존 콘텐츠 선언이 완료로 보여도 2.0 제출 빌드에 맞춰 재검토 필요.

## 다음 작업 순서

1. 사용자 답변이 있으면 Firebase 처리와 실기기 검증부터 이어간다. 답변 전에도 아래 로컬 구현은 가능하다.
2. 기본 기기 프로필을 클라우드에 올리지 않는 **선택적 Google 구매 계정 연결** 구현. 현재 로컬 모드는 PurchaseService.bindUser(null)이며 SessionGate의 legacy cloud profile과 구별해야 한다.
3. AI 신고 접수 운영 백엔드, 익명 신고의 삭제/보관 안내, 실제 전송·탈퇴 검증. 실제 제출 전 이 기능을 갖춘다.
4. Functions의 결제 검증/서버 권한/RTDN 환불/삭제 job을 실제 배포·테스트한다. 원격 Firestore 인덱스를 보존하고 TTL만 안전하게 추가. Storage→Firestore 규칙 권한 및 실제 bucket 확인. 계정 삭제 수락 뒤 로컬 정리만 실패할 때의 안내 보강.
5. 완결 유료 이야기/테마 상품을 완성한 다음 실제 Play 테스트 구매/보류/취소/복원/환불/계정 변경을 검증한다. 가격은 `PRODUCT_BRIEF.md`의 실험 가설이며 실제 매출 없음. 현재 판매 UI는 off.
6. 던전 앱 종료 복원과 원자적 최종 보상 정산을 설계한다. 현재 run은 메모리만 보관하며 백업은 완료한 던전 기록만 포함한다. 전투 도중 종료/재진입으로 중복 보상이 생기지 않게 검증해야 한다. 남은 게임 화면의 4언어/큰 글자·전체 5구역 밸런스 검토도 필요.
7. 식별력 있는 최종 아이콘/feature graphic와 실제 Android 스크린샷, 스토어 문구·정책·콘텐츠 선언 완성 → 검증한 signed AAB 내부 테스트 업로드 → 실제 12명/14일 비공개 테스트 → 프로덕션 액세스/공개 심사.

재개 시 기존 테스트를 무조건 전부 반복하지 말고 변경·실패·미검증 범위에 맞춰 실행한다. 출시 승인이나 수익 발생을 확인하지 않고 완료됐다고 표현하지 않는다.
