# 재개 체크포인트 · 2026-09-14

사용자 목표: Life Quest를 무료 오픈모델 온디바이스 개인화와 현대 판타지 상태창 RPG로 개선해 Google Play에서 수익화/배포. 잔여 사용량 20% 근처까지 진행하고 재개 가능한 기록을 유지한다.

- 작업 트리: `/Users/jeonghyeonseok/Documents/ChatGPT/Life_Quest`
- 브랜치: `codex/rebirth-2026-09`, 시작 기준 `bdc7801`
- Flutter 3.47.4: `/Users/jeonghyeonseok/.local/share/lifequest/flutter/bin/flutter`
- Android SDK: `/Users/jeonghyeonseok/Library/Android/sdk`, Java: Temurin 21. Flutter 명령은 직렬 실행한다. 동시에 pub/analyze/build를 실행하면 생성 플러그인 목록이 debug/release 사이에서 충돌한다.
- 기획/근거: PRODUCT_BRIEF.md, ON_DEVICE_AI_DECISION.md, UX_AUDIT.md. AGENTS.md 및 docs/AI_WORK_RULES.md 준수.

## 구현 및 검증

- 오늘/퀘스트/던전/성장 네 탭, 상태창 디자인, 시간·에너지·관심사 체크인, 퀘스트 수락/완료/피드백/날짜 경계/이력 기반 조정.
- Gemma 4 E2B Apache 2.0 + LiteRT-LM 0.17.0. 2.59 GB 모델은 명시적 다운로드, 고정 리비전과 SHA-256 검증, 취소/재개, 로컬 실행. AI 미설치/실패에는 무료 안전 템플릿.
- 8개 합성 시나리오 구조 준수 실측: Gemma V2 8/8, Qwen V2 2/8. 의미 품질/실물 기기 성능 인증은 아님.
- Android API 35 / 16 KB / 6 GB 에뮬레이터에서 실제 모델 다운로드 취소·재개·무결성·생성 성공. 한국어 3개 생성 20.087초. 실물 기기 테스트 미완료.
- Flutter analyze 통과, 전체 214개 테스트 통과. 320 px·200% 글자·4언어 레이아웃 포함. qa_artifacts/rebirth/ 로그는 로컬에 보존(추적 제외).
- 기본 main 진입점 서명 release AAB 215,022,354 bytes, bundletool 표본 ARM64/API35 다운로드 127,933,103 bytes. jarsigner/인증서·ELF 11개·기기 split APK ZIP 16 KB 검사 통과. `artifact-inspection.json` 참조. 최신 APK 파일은 QA 전용 타깃이므로 배포 금지. 모델 SDK의 Kotlin 2.4 메타데이터에 맞춰 R8을 공식 Google Maven 9.1.43으로 갱신해 메타데이터 경고 없이 재빌드 성공. 아직 업로드용 최종 빌드 아님.
- Google Play Billing 8 지원 플러그인으로 갱신. 수익화 스위치는 꺼져 있음. 서버 결제 검증/권한 저장/환불 동기화 구현 진행 중이며 실제 구매·복원 검증 전 판매 활성화 금지.

## 실제 외부 상태와 필요한 후속 작업

- Play Console: Log_Ian > Life Quest 기존 초안, `com.lifequest.app`, version 2.0.0+3. 앱 서명은 설정되어 있으나 업로드 인증서는 아직 등록되지 않음.
- https://play.google.com/console/u/1/developers/8167226228602257815/app/4972166589004992203/app-dashboard
- 프로덕션 조건: 12명/14일 연속 비공개 테스트. 현재 0명, 설치 0. 실물 Android 기종/테스터 확보 여부 사용자 답변 대기.
- **Firebase 프로젝트 life-quest-app-95eb9는 Console에서 최근 삭제됨으로 확인됨.** 기존 Android 앱 등록도 구 패키지에 묶여 있음. 정상 백엔드 없이 출시하면 안 됨.
- 기존 프로젝트 복원/새 무료 프로젝트 선택을 사용자에게 질문했고 답변 대기 중. 삭제 결정을 임의로 되돌리거나 유료 결제를 연결하지 않았다. CLI 앱 등록 시도는 404로 실패했고 생성된 앱 없음.
- 복원 후 com.lifequest.app 등록, 앱 서명 SHA 연결, Auth/App Check/Firestore 신고 및 결제 권한 규칙, 실제 계정 탈퇴 검증 필요. 함수/규칙 배포 안 함.
- 사용자의 배포 권한은 이미 있으므로 준비된 가역적 작업은 다시 승인받지 않는다. 공개 출시/실제 매출이 완료됐다고 표현하지 않는다.

## 다음 구현

1. 기기 전용 프로필과 첫 실행, QA 저장 분리, 저장 손상 보존, 로그아웃 라우팅 구현/검증 완료. 브라우저에서 수락→완료→재시작 복원→시작화면 복귀 확인.
2. 결제 검증 debug 우회 제거, 계정 바인딩·서버 영속 권한·환불·복원 UI 구현. 서버 테스트 10개 및 npm audit 0건. 실제 Play 테스트는 미완료. BILLING_AND_RELEASE.md 참고.
3. 서버 요청 기반 계정 삭제/재시도/구매 원장 삭제 구현. Node22 서버 테스트 15개, 실제 Firestore+Storage 에뮬레이터 규칙 테스트 8개 통과. 함수/규칙/TTL 실제 배포와 운영 재시도 검증 필요. 기존 원격 인덱스 보존 및 Storage→Firestore 권한을 배포 전에 확인한다.
4. 무료 4장면 프롤로그 「0번 출구」를 4언어로 구현. 선택 반영 대사/0·1·3·6 완료 해금/다시 읽기/XP 불변/진행 복원 검증. 소유형 유료 챕터와 던전 첫 경험은 남음. 개인정보 공개 페이지를 현재 기기 중심 구조로 고치고 GitHub Pages 오류를 해결할 예정.
5. Firebase 응답과 실물 검증 후 내부 테스트 업로드. 비공개 테스트 요건을 거쳐 프로덕션 신청.


## 추가 검증과 바로 이어갈 작업

- 제품 프롬프트를 4언어 × 신규/긴 기록으로 실행: 419–630 입력 토큰, 실제 Dart 파서 8/8 통과. 중국어 1건은 완성된 JSON 배열 뒤 루트 괄호 누락만 제한 복구. `production-model-probe.json`은 합성 원시 출력이며 의미 품질 인증이 아니다.
- 21시–07시 조용한 활동, 슬롯 ID 결속, 6개 짧은 기록, 응답 언어/길이 검증. 전체 14일 기반 앱 정책은 유지.
- 실제 R8 release에서 JNI getter 제거로 SIGABRT를 재현·수정. SDK JNI 메서드 보존 후 신규/긴 기록 21,364/11,748ms 통과, 캐시가 따뜻한 재실행 9,368/7,867ms. `native-release-probe.json`에 6개 합성 결과 보존. 실물 폰 성능 아님.
- 계정 삭제는 durable 요청→Storage→사용자 전체 하위 문서→구매 토큰→Auth 순서. 이전 ID 토큰 쓰기 차단, 완료 표식은 7일 후 TTL 대상. 수락 뒤 앱 종료돼도 서버 처리 계속. 삭제/결제/신고 운영 백엔드는 아직 없음.
- `scripts/check_release_readiness.sh`를 실제 AAB/서명/manifest/ELF/split 검사로 교체했다. 로컬 빌드 검사만 하며 공개 출시 승인을 뜻하지 않는다.
- **다음:** Android 자동 Firebase 초기화와 기기 간 백업 제외를 명시해 로컬 기본값 강화 → 개인정보/삭제 공개 페이지 갱신과 Pages 복구 → 기기 프로필을 업로드하지 않는 선택적 구매 계정 연결/복원 → 무료 백업/콘텐츠/스토어 준비.
- 알려진 추가 빈틈: 기기 모드의 Google 구매 계정 연결 아직 없음. 익명 AI 신고 후 삭제/보관 안내와 실제 전송도 출시에 앞서 마무리 필요. 서버 계정 삭제 수락 후 로컬 정리만 실패하는 경우 안내 보완 여지.
- GitHub Pages 현재 main/docs, 상태 errored, 마지막 빌드 2026-06-12에 building으로 멈춘 것으로 확인. 개인정보 URL은 아직 정상 공개 검증 안 됨.
- draft PR: https://github.com/Sn-bow/Life_Quest/pull/1. 이 시점 사용량 약 36% 남음; 20% 부근에서 checkpoint 후 재개.

## 비밀 정보와 산출물

- 새 업로드 키는 `~/.local/share/lifequest/signing/`에 보관, android/key.properties는 Git 제외. 파일 내용을 출력하거나 업로드하지 않는다. 예전 공개 문서의 키 비밀번호는 제거했고 재사용하지 않았다.
- 모델 캐시 `~/.local/share/lifequest/models/`, 모델/키/QA 개인 데이터 Git 제외.
- Obsidian Vault 작업 요청이 아니므로 Vault 접근 없음.

- 기본 실행은 Cloud/Monetization/Ads 모두 꺼진 기기 전용 모드. Web: `flutter build web --release` → build/web. 모델 설치는 Android에서만 가능.
