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
- Flutter analyze 통과, 전체 196개 테스트 통과. 320 px·200% 글자·4언어 레이아웃 포함. qa_artifacts/rebirth/ 로그는 로컬에 보존(추적 제외).
- 서명 release AAB 215.9 MB 생성·jarsigner 확인·ELF 11개 16 KB 정렬 확인. 모델 SDK의 Kotlin 2.4 메타데이터에 맞춰 R8을 공식 Google Maven 9.1.43으로 갱신해 메타데이터 경고 없이 재빌드 성공. 아직 업로드용 최종 빌드 아님.
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
3. Firestore 규칙 에뮬레이터 테스트, 서버에서 일관된 계정 삭제/재시도 처리, 구매 원장 보존 정책 보완. 앱 전체 분석/196개 테스트 통과, 새 Flutter 편집 후 AAB 재생성 필요.
4. 무료 프롤로그와 소유형 챕터 콘텐츠, 던전 첫 경험, 실제 UI로 스토어 이미지/문구/개인정보 문서 완성.
5. Firebase 응답과 실물 검증 후 내부 테스트 업로드. 비공개 테스트 요건을 거쳐 프로덕션 신청.

## 비밀 정보와 산출물

- 새 업로드 키는 `~/.local/share/lifequest/signing/`에 보관, android/key.properties는 Git 제외. 파일 내용을 출력하거나 업로드하지 않는다. 예전 공개 문서의 키 비밀번호는 제거했고 재사용하지 않았다.
- 모델 캐시 `~/.local/share/lifequest/models/`, 모델/키/QA 개인 데이터 Git 제외.
- Obsidian Vault 작업 요청이 아니므로 Vault 접근 없음.

- 기본 실행은 Cloud/Monetization/Ads 모두 꺼진 기기 전용 모드. Web: `flutter build web --release` → build/web. 모델 설치는 Android에서만 가능.
