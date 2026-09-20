# Life Quest

현실의 작은 행동으로 여러 세계의 성장기를 이어 쓰는 Android 습관 RPG. **경계의 서가**에서 도시 미스터리·무협 수련·기록 탐사의 책을 고르고, 기기 안의 개인화 퀘스트와 상태창으로 다음 장면을 엽니다.

![Life Quest 생성 이미지 배너](docs/rebirth/store/feature-graphic-1024x500.png)

**2.0 재구축 중 · 2026-09-20.** Google Play 공개 출시와 유료 판매는 아직 시작하지 않았습니다. Cloud·결제·광고는 기본적으로 꺼져 있습니다. 실제 출시에 남은 일과 작업 재개 정보는 [CONTINUE.md](docs/rebirth/CONTINUE.md)를 기준으로 확인하세요.

## 제품 구성

- **오늘 / 퀘스트 / 던전 / 성장:** 하루의 실행 가능한 행동을 먼저 보여 주며, 쉬는 날에 일상의 경험치나 레벨을 차감하지 않습니다.
- **무료 온디바이스 AI:** 공개 Apache-2.0 Gemma 4 E2B를 선택 설치합니다. 설치 후 퀘스트 생성은 기기에서 실행하며 목표와 개인화 이력을 클라우드 LLM에 보내지 않습니다. 모델 미설치·미지원·검증 실패 시 기본 추천을 사용할 수 있습니다. 모델은 별도 약2.59GB 다운로드입니다.
- **개인화:** 완료·보류·체감 난이도·가용 시간에 따라 추천을 조정합니다. 모델 가중치를 사용자 데이터로 재학습한다고 주장하지 않습니다. 보상과 시간 제한은 앱이 관리합니다.
- **무료 단편 세 권:** 도시 「0번 출구」, 수련 「바람을 듣는 마당」, 탐사 「잃어버린 별의 지도」. 각4장면이 현실 퀘스트로 열리고 이전 선택이 대사에 반영됩니다. 오늘 이어 읽을 책을 바꿔도 진행·XP가 남고 암호화 백업에도 포함됩니다. 읽기만으로 XP를 주지 않습니다.
- **카드 탐험:** 기존207장 카드와5구역 게임을 활용합니다. 방에 들어가거나 나올 때 저장하며, 미완료 방은 입구에서 다시 시작합니다. 최종 보상과 수령 기록을 함께 저장해 중복 지급을 막습니다.
- **기기 전용 기록과 무료 백업:** 가입 없이 시작합니다. 비밀번호로 암호화한 백업, 복원 전 확인, 직전 기록 되돌리기, 중단된 복원 재개를 제공합니다. 계정 인증·구매 권한·진행 중 탐험·모델·신고 접수 로그는 백업에서 제외합니다.
- **한국어·영어·일본어·중국어:** 주요 새 화면은320px/200% 글자 크기에서 검사했습니다. 전체5구역의 게임 밸런스와 실물 Android 접근성 검증은 남아 있습니다.

새 아이콘·스플래시·첫 화면·이야기 표지·스토어 배너는 image generation으로 제작했습니다. [아트 제작 기록](docs/rebirth/artwork/README.md)에 실제 레퍼런스와 출처를 기록했으며, 다른 작품의 캐릭터·로고·UI 이미지를 복사하지 않았습니다.

## 수익화와 계정

기본 퀘스트·AI·백업·세 단편은 무료입니다. 별도 완결 세계관 팩(12장면·두 결말·테마·기록 표식)을 한 번 구매해 소장하는 방식을 검증하려 합니다. 「조수 우체국」의12장면×4언어·두 결말·두 장면 체험·테마·표식을 구현했습니다. 가격은 미정이며 2,900/4,900/6,900원·비구매·미정을 비교합니다. Play 상품 등록·실제 결제·독자 검수 전입니다. **반복 사용과 콘텐츠의 지불 가치가 확인되기 전에는 공개 판매하지 않습니다.** 실제 상품 완성·테스트 구매·환불·복원 검증도 필요합니다. 가격·전환율·수익은 아직 검증되지 않았습니다.

선택적 Google 구매 계정은 기기의 진행 기록과 분리했습니다. 최소 계정 생성, 서버 영수증 확인, 구매 권한 복원, RTDN 환불, 재시도 가능한 계정 삭제를 구현했습니다. 신고는 사용자 검토 문구만 접수하며 접수번호, 중복 방지, 개별 삭제, 익명 신고 계정 삭제,90일 TTL을 갖춥니다. **지정한 개발자 계정에는 현재 Firebase 프로젝트가 없어 프로젝트 준비와 실제 운영 검증이 필요합니다.**

결제와 광고의 Android 권한은 독립적입니다. 결제를 켜도 광고가 켜지지 않습니다. 무료 모델 실행과 별개로 Functions·Firestore·TTL 삭제에는 플랫폼 요금이 발생할 수 있습니다.

## 개발

검증한 도구: Flutter3.47.4 / Dart3.13.3 / JDK21 / Android SDK36 / LiteRT-LM0.17.0. Android 전용이며 iOS는 지원하지 않습니다. Flutter 도구는 같은 checkout에서 직렬 실행하세요.

```sh
flutter pub get
flutter analyze
flutter test
flutter build appbundle --release --target lib/main.dart
```

릴리스는 Git에 포함하지 않는 `android/key.properties`와 업로드 키 설정이 필요합니다. 비밀값을 문서·로그·명령 인수에 직접 넣지 마세요. 공개 서명 지문으로 실제 산출물을 검사합니다.

```sh
bash scripts/check_release_readiness.sh --certificate-sha256 <PUBLIC_CERTIFICATE_SHA256>
python3 scripts/check_android_feature_manifests.py
```

`integration_test/`의 모델·백업 probe는 QA 진입점입니다. 해당 probe로 만든 APK/AAB를 Play에 올리지 마세요. 예전 iOS·광고 통합 설정용 `scripts/apply_release_values.sh`는2.0 출시 경로에서 사용하지 않습니다.

## 확인된 범위

- Flutter analyze: 문제 없음. 2026-09-20 전체368개 테스트 통과. 별도 Cloud/Billing 활성 상품 카탈로그 검사1개 통과(기본 전체 실행에서는 의도적 skip).
- Node22 서버 정책27개 통과(9월20일). 실제 Firestore/Storage 로컬 emulator9개와 아래 manifest 검사는9월17일 기준선입니다.
- 실제 Gradle manifest merger의7개 권한 조합 통과.
- 서명된 R8 Android probe에서 모델 생성과 암호화 백업 상호 호환 확인. 에뮬레이터 측정이며 실물 성능 인증이 아닙니다.
- 캠페인 검사6개:1,000개 생성 지도 연결 및5구역의 모든 방 저장/복원·보상 재수령 방지. 전투 밸런스 검증은 별도입니다.
- 실제 브라우저 UI에서 첫 퀘스트, 이야기 체험, 백업/복원/재시작과 첫 전투를 확인했습니다. 최신 검토에서 탐험 진행도를 경로의6단계로 수정하고, 0비용 카드 안내와 저주 카드 활성 조건을 바로잡았습니다.
- 내부 빌드의 자발적14일 연구는 기기에만 저장하고 직접 파일로 내보냅니다. Python 집계8개 검사 통과. 이 기능과 개발용 웹 입력은 실제 사용자 유지율·구매 증거가 아닙니다.
- 정확한 최신 AAB의 서명·16KiB·용량 증거는 [artifact-inspection.json](docs/rebirth/artifact-inspection.json). 빌드 검사와 Play 출시 승인은 다릅니다.

## 설계·출시 문서

[수익화 검증 계획](docs/rebirth/REVENUE_VALIDATION.md) · [테스터 안내](docs/rebirth/RESEARCH_TESTER_GUIDE.md) · [최신 화면 검토](docs/rebirth/REVENUE_UX_REVIEW.md) · [콘셉트·수익 결정](docs/rebirth/CONCEPT_AND_REVENUE.md) · [화면 검토](docs/rebirth/CONCEPT_UX_REVIEW.md) · [제품 방향](docs/rebirth/PRODUCT_BRIEF.md) · [모델 선정·실측](docs/rebirth/ON_DEVICE_AI_DECISION.md) · [던전 저장](docs/rebirth/DUNGEON_CHECKPOINTS.md) · [암호화 백업](docs/rebirth/DEVICE_BACKUP.md) · [구매 계정](docs/rebirth/PURCHASE_ACCOUNT.md) · [신고 운영](docs/rebirth/AI_REPORTING.md) · [결제·출시](docs/rebirth/BILLING_AND_RELEASE.md) · [Play 초안·테스트](docs/rebirth/store/STORE_AND_TEST_PLAN.md)

공개 안내: [개인정보·데이터 삭제·이용약관](https://sn-bow.github.io/Life_Quest/). 지원: logian621@gmail.com.
