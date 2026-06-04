# Life Quest - 프로덕션 릴리스 체크리스트

> **작성일**: 2026-04-06  |  **최종 업데이트**: 2026-04-26
> **목표**: 유저 이탈률 최소화 수준의 완성도로 Google Play Store 배포
> **예상 기간**: 최소 출시 4~5주 / 완성도 높은 출시 8~10주

---

## 2026-05-21 기준 정정

2026-05-25 추가 정정:

- Play Console 제출 시 `docs/lifequest-play-console-submission-runbook-20260525.md`를 우선 적용한다.
- 하단의 오래된 G-4/G-5 문구가 광고/인앱구매 포함 앱처럼 보이더라도, 현재 기본 Android 빌드는 광고와 인앱 결제가 비활성화된 상태로 답변해야 한다.
- Data safety, IARC, Health apps declaration, 스토어 등록 문구, 스크린샷은 모두 같은 기본 Android AAB 기준으로 맞춘다.

이 문서는 2026-04-26 기준 항목이 많이 남아 있어 일부 세부 내용이 현재 코드와 다르다. 반복 작업을 막기 위해 아래 항목을 현재 Android 기본 릴리스 기준으로 우선 적용한다.

- 기본 Android 릴리스 빌드에서 AdMob/Billing 런타임 시작과 광고/결제 UI는 비활성화되어 있다.
- 기본 Android 릴리스 빌드의 AdMob App ID는 빈 값이며, production rewarded ad unit ID는 코드에 하드코딩되어 있지 않다.
- 수익화 활성화 빌드는 별도 빌드 변형으로 취급하며 `ADMOB_ANDROID_APP_ID`, `ADMOB_REWARDED_AD_UNIT_ID_ANDROID`, `LIFEQUEST_MONETIZATION_ENABLED=true`를 명시적으로 주입한 뒤 Data safety를 재검토해야 한다.
- R8/minify와 resource shrink는 release build에 적용되어 있다.
- 개인정보처리방침은 `PRIVACY_POLICY.md`와 GitHub Pages 공개 페이지로 정리되어 있으며, Play Console URL 등록과 최종 Data safety 입력은 수동 미완료 항목이다.
- `cmd /c C:\dev\flutter\bin\flutter.bat analyze --no-pub`, `bash scripts/check_release_readiness.sh`, `cmd /c C:\dev\flutter\bin\flutter.bat build appbundle --release --no-pub`는 2026-06-04에 통과했다.
- 2026-05-21 Google Play target API 공식 문서 재확인 결과, 새 앱/업데이트 제출 기준은 Android 15/API 35 이상이다. 현재 `targetSdk = 35`, `compileSdk = 36`은 기본 Android 릴리스 경로에 적합하다.

계속 유효한 주요 미완료 항목:
- Firebase Console의 Android 앱 패키지명/SHA/App Check/Auth 설정 최종 확인
- Play Console Data safety 실제 입력 및 저장
- Health apps declaration/IARC/store listing 실제 입력
- 실제 Android release/test build 기준 스크린샷 캡처
- 인증된 계정 삭제 및 주요 게임 루프 실기기 smoke test
- AAB 업로드 및 closed testing 제출

---

## 현재 상태 요약 (2026-04-26 기준)

| 항목 | 상태 |
|------|------|
| Dart 소스 파일 | 75개+ |
| 테스트 파일 | 7개 (**73개** 테스트 통과) |
| Soul Deck 카드 | 207장 |
| 렐릭 / 이벤트 | 31개 / 10개 |
| 던전 화면 | 9개 |
| flutter analyze | ✅ No issues found |
| 릴리스 빌드 | ✅ 2026-06-04 기본 release AAB 빌드 성공: 159,416,214 bytes / 152.0MB (v1.0.1+2) |
| 다국어 지원 | 한국어/영어/일본어/중국어 (데이터 모델 포함 완전 지원) |
| 사운드 파일 | Soul Deck SFX 포함 다수 |
| IAP 서버검증 | ✅ Cloud Function 구현 완료 (배포 수동 필요) |
| Firestore 보안 | ✅ Security Rules 작성 완료 (배포 수동 필요) |
| 광고 시간조작 방지 | ✅ 서버 타임스탬프 앵커 구현 |
| 개인정보처리방침 | ✅ GitHub Pages URL 적용 |

### 핵심 미비 사항 (2026-04-26 기준)
- ❌ 실제 기기 테스트 **한 번도 안 함** ← 가장 중요
- ✅ Game asset directory skeleton exists and pubspec asset directories are release-gated; final custom art remains manual
- ✅ Soul Deck SFX 참조 에셋 존재 테스트 추가 (`test/services/sound_service_assets_test.dart`)
- ✅ 전투 애니메이션 4종 Canvas 구현 완료 (에셋 없이)
- ✅ First-run Life Quest onboarding exists and is release-gated; Soul Deck first-battle guide exists and is release-gated
- ✅ Starter deck automated balance smoke exists; full manual card balance playtest still required
- ✅ Crashlytics dependency/plugin and fatal/non-fatal error hooks are wired; console event collection still requires release-device verification
- ❌ Firebase 콘솔 패키지명 업데이트 (수동 필요)
- ❌ Cloud Function / Firestore Rules 배포 (수동 필요)
- ✅ 개인정보처리방침 공개 페이지 갱신 및 encoding/URL readiness-gated. Play Console URL 등록과 최종 Data safety 입력은 수동 미완료
- ✅ 시즌 카운트다운 하드코딩 제거 및 날짜 경계 테스트 추가 (`test/utils/season_countdown_test.dart`)

---

## Phase A: Critical (출시 전 필수 — 스토어 거절/크래시 방지)

### A-1. 실제 기기 테스트 & 크래시 검증
| 항목 | 내용 |
|------|------|
| **현재 상태** | 2026-06-04 기준 ADB 실행 파일은 존재하지만 연결된 authorized device가 없다. `docs/lifequest-android-device-smoke-runbook-20260604.md`에 closed testing 전 필수 실기기 smoke 절차를 정리했고 readiness가 이 runbook 존재를 확인한다. |
| **문제** | 최신 default release/closed-testing AAB가 실제 Android 기기에서 아직 smoke-tested 되지 않았다. Firebase, 계정 삭제, 타이머 background/return, Flame 렌더링, 기본 monetization-off UI, Crashlytics 이벤트 수집을 같은 빌드 기준으로 확인해야 한다. |
| **위치** | 전체 앱 (`lib/main.dart` 초기화 시퀀스부터) |
| **위험** | 런치 크래시, Firebase 연결 실패, Flame GPU 호환성 문제 |
| **난이도** | 보통 |
| **소요 시간** | 2~3시간 1차 smoke + 이후 반복 QA |
| **우선순위** | 🔴 P0 |
| **작업 주체** | 수동 (물리 기기 또는 emulator + USB 디버깅/ADB authorization 필수) |

### A-2. Firebase 콘솔 패키지명 업데이트
| 항목 | 내용 |
|------|------|
| **문제** | `applicationId`가 `com.lifequest.app`으로 변경되었지만 Firebase 콘솔 미업데이트 시 Auth/Firestore/App Check 전부 동작 안 함 |
| **위치** | Firebase Console (웹) → 새 `google-services.json` 다운로드 → `android/app/` |
| **위험** | 앱 실행 시 Firebase 연결 전면 실패 |
| **난이도** | 쉬움 |
| **소요 시간** | 30분 |
| **우선순위** | 🔴 P0 |
| **작업 주체** | 수동 (Firebase Console 접근 필요) |

### A-3. AdMob App ID 확인 (AndroidManifest)
| 항목 | 내용 |
|------|------|
| **현재 상태** | 기본 Android 빌드에서는 AdMob App ID가 빈 값이며, 수익화 활성화 빌드에서만 `-PADMOB_ANDROID_APP_ID=...`로 주입한다. |
| **위치** | `android/app/src/main/AndroidManifest.xml:37-41`, `android/app/build.gradle.kts:22-24` |
| **위험** | Google Play 거절 또는 광고 미표시 |
| **난이도** | 쉬움 |
| **소요 시간** | 15분 |
| **우선순위** | 🔴 P0 |
| **작업 주체** | 수동 (AdMob Console 확인) |

### A-4. AdMob Ad Unit ID 확인
| 항목 | 내용 |
|------|------|
| **현재 상태** | 기본 Android 빌드에는 production rewarded ad unit ID가 하드코딩되어 있지 않다. 수익화 활성화 빌드에서만 `--dart-define=ADMOB_REWARDED_AD_UNIT_ID_ANDROID=...`로 주입한다. |
| **위치** | `lib/services/ad_service.dart:15-27` |
| **위험** | 프로덕션에서 광고 무응답, 수익 0원 |
| **난이도** | 쉬움 |
| **소요 시간** | 15분 |
| **우선순위** | 🔴 P0 |
| **작업 주체** | 수동 (AdMob Console 확인) |

### A-5. 게임 에셋 디렉토리 생성

2026-06-04 update: the `assets/images/game/` directory skeleton exists in the repository, and `test/data/pubspec_asset_directories_test.dart` verifies every directory-style asset declared in `pubspec.yaml` exists on disk. `scripts/check_release_readiness.sh` now gates this test. Remaining work is final custom game art, not release-breaking missing asset directories.

| 항목 | 내용 |
|------|------|
| **문제** | `pubspec.yaml:73-85`에 10개 에셋 디렉토리 선언되어 있으나 실제 디렉토리 미존재. 빌드 실패 또는 런타임 에셋 로딩 크래시 위험 |
| **위치** | `assets/images/game/player/`, `assets/images/game/monsters/`, `assets/images/game/backgrounds/` 등 |
| **위험** | 빌드 실패 또는 Flame 컴포넌트 크래시 |
| **난이도** | 쉬움 (빈 디렉토리 + placeholder) / 어려움 (실제 에셋) |
| **소요 시간** | 1시간 (placeholder) / 수 주 (실제 아트) |
| **우선순위** | 🔴 P0 |
| **작업 주체** | Claude (디렉토리 생성) + 수동 (실제 에셋) |

### A-6. ProGuard / R8 코드 축소 설정
| 항목 | 내용 |
|------|------|
| **현재 상태** | release build에 `isMinifyEnabled = true`, `isShrinkResources = true` 적용 완료. 2026-06-04 기본 release AAB 빌드 성공. `docs/lifequest-release-artifact-record-20260604.md`에 산출물 기록을 남겼고 readiness가 AAB 존재/최소 크기를 확인한다. |
| **위치** | `android/app/build.gradle.kts:59-67` |
| **위험** | APK 크기 비대, 코드 노출, Play Store 랭킹 불이익 |
| **난이도** | 보통 |
| **소요 시간** | 2~4시간 |
| **우선순위** | 🟡 P1 |
| **작업 주체** | Claude (설정 작성) + 수동 (테스트) |

### A-7. 개인정보 처리방침 (Privacy Policy) ✅ 완료
| 항목 | 내용 |
|------|------|
| **상태** | ✅ `PRIVACY_POLICY.md` 작성 완료, GitHub Pages URL 앱 설정 화면에 적용 (`e461051`) |
| **위치** | `PRIVACY_POLICY.md`, `lib/screens/settings_screen.dart` |
| **남은 작업** | Play Console에 URL 등록 (수동) |

### A-8. 앱 버전 번호 설정 ✅ 완료
| 항목 | 내용 |
|------|------|
| **상태** | ✅ `version: 1.0.1+2` — 커밋 `268077e` |
| **위치** | `pubspec.yaml:4` |

### A-9. Crashlytics 통합

2026-05-28 update: Crashlytics dependency/plugin, `runZonedGuarded`, `FlutterError.onError`, fatal zone error capture, and startup non-fatal recording are wired. `scripts/check_release_readiness.sh` now verifies this repository-side integration. Remaining work is release/test-device event collection verification in Firebase Console.

| 항목 | 내용 |
|------|------|
| **현재 상태** | Crashlytics dependency/plugin, `runZonedGuarded`, `FlutterError.onError`, fatal zone error capture, startup non-fatal recording are wired. |
| **위치** | `pubspec.yaml`, `android/app/build.gradle.kts`, `lib/main.dart`, `scripts/check_release_readiness.sh` |
| **남은 작업** | Release/test device에서 Crashlytics test event 수집 확인 (수동) |
| **난이도** | 보통 |
| **소요 시간** | 2~3시간 |
| **우선순위** | 🔴 P0 |
| **작업 주체** | Claude |

---

## Phase B: Core UX (유저 리텐션 핵심 — 첫인상이 중요)

### B-1. 카드 비주얼 시스템 (카드 아트)
| 항목 | 내용 |
|------|------|
| **문제** | 카드 207장이 전부 색상 컨테이너 + 텍스트만으로 렌더링됨. 카드 프레임 이미지, 카드 아이콘 없음 (`assets/images/game/cards/` 미존재) |
| **위치** | `lib/screens/dungeon/card_battle_screen.dart` (`_CardHand` 위젯), `card_collection_screen.dart` |
| **위험** | 유저가 프로토타입으로 인식, 첫 실행에서 이탈 |
| **난이도** | 어려움 |
| **소요 시간** | 1~2주 |
| **우선순위** | 🔴 P0 |
| **작업 주체** | Claude (카드 위젯 프레임/아이콘 슬롯 구현) + 아티스트 또는 AI 생성 (실제 아트) |
| **대안** | AI 아트 생성 도구 (Midjourney, Stable Diffusion)로 카드 프레임 + 아이콘 세트 생성 |

### B-2. 적/플레이어 스프라이트
| 항목 | 내용 |
|------|------|
| **문제** | `battle_game.dart`에 `SpriteComponent` 없음. Flame 캔버스에 배경 + 숫자 + 파티클만 표시. 전투 상대가 시각적으로 보이지 않음 |
| **위치** | `lib/game/battle_game.dart` — 스프라이트 로딩 코드 전무 |
| **위험** | 전투 화면에서 "무엇과 싸우는지" 보이지 않음 |
| **난이도** | 어려움 |
| **소요 시간** | 1~2주 |
| **우선순위** | 🔴 P0 |
| **작업 주체** | Claude (SpriteComponent 로딩 및 애니메이션 코드) + 아티스트/AI (스프라이트 제작) |
| **추천 무료 에셋** | LuizMelo CC0 픽셀 아트 스프라이트 (itch.io), Shikashi 아이콘 284종 |

### B-3. 전투 애니메이션 구현 ✅ 완료 (Canvas 방식)
| 항목 | 내용 |
|------|------|
| **상태** | ✅ 4종 Canvas 애니메이션 구현 완료 (에셋 없이 `Paint`/`Path` 드로잉) |
| **구현** | `_SlashEffect`(공격), `_ShieldRaiseEffect`(방어), `_MagicProjectile`(마법), `_EnemyDeathEffect`+`_Shard`(사망) |
| **위치** | `lib/game/battle_game.dart` |
| **비고** | 스프라이트 에셋 추가 시 B-2와 연동 가능 |

### B-4. 던전 맵 비주얼 강화
| 항목 | 내용 |
|------|------|
| **문제** | 맵 화면이 아이콘/색상 원으로만 표현됨. `assets/images/game/map/` 미존재 |
| **위치** | `lib/screens/dungeon/dungeon_map_screen.dart` |
| **난이도** | 보통 |
| **소요 시간** | 3~5일 |
| **우선순위** | 🟡 P1 |
| **작업 주체** | Claude (절차적 비주얼 강화) + 수동 (커스텀 맵 아트) |

### B-5. 렐릭 아이콘 시스템
| 항목 | 내용 |
|------|------|
| **문제** | 31개 렐릭에 시각적 표현 없음. `assets/images/game/relics/` 미존재 |
| **위치** | `lib/data/relic_database.dart` (271줄) |
| **난이도** | 보통 |
| **소요 시간** | 2~3일 |
| **우선순위** | 🟡 P1 |
| **작업 주체** | Claude (Material/Phosphor 아이콘 기반 placeholder) + 아티스트 (커스텀 아이콘) |

---

## Phase C: Visual Polish (게임다운 비주얼)

### C-1. 전투 존별 배경 아트
| 항목 | 내용 |
|------|------|
| **문제** | 현재 절차적 파랄랙스 (색상 도형). 5존 각각 고유한 배경 분위기 필요 |
| **위치** | `lib/game/battle_game.dart` `_initParallaxBackground()` |
| **난이도** | 보통 |
| **소요 시간** | 3~5일 (절차적 개선) / 1~2주 (실제 아트) |
| **우선순위** | 🟢 P2 |
| **작업 주체** | Claude (절차적 배경 강화) + 수동 (실제 아트) |

### C-2. 카드 플레이 애니메이션 강화
| 항목 | 내용 |
|------|------|
| **문제** | Phase 2에서 슬라이드+페이드 기본 구현됨. 글로우, 트레일 파티클 등 juice 추가 필요 |
| **위치** | `lib/screens/dungeon/card_battle_screen.dart` |
| **난이도** | 보통 |
| **소요 시간** | 2~3일 |
| **우선순위** | 🟢 P2 |
| **작업 주체** | Claude |

### C-3. 상태이상 아이콘 세련화
| 항목 | 내용 |
|------|------|
| **문제** | 11종 상태이상 아이콘이 색상 원 + 글자 약어 수준. 구분 어려움 |
| **위치** | `lib/game/components/status_icon.dart` |
| **난이도** | 쉬움 |
| **소요 시간** | 1일 |
| **우선순위** | 🟢 P2 |
| **작업 주체** | Claude |

### C-4. 카테고리별 파티클 차별화
| 항목 | 내용 |
|------|------|
| **문제** | 히트/힐/블록 3종만 있음. 카드 카테고리별 고유 파티클 필요 (공격=불, 마법=얼음 등) |
| **위치** | `lib/game/components/particle_effect.dart` |
| **난이도** | 보통 |
| **소요 시간** | 2~3일 |
| **우선순위** | 🟢 P2 |
| **작업 주체** | Claude |

### C-5. 시즌 카운트다운 하드코딩 수정
| 항목 | 내용 |
|------|------|
| **현재 상태** | `dungeon_home_screen.dart`가 `calculateSeasonCountdown()`과 `kSoulDeckSeasonOneEndDate`를 사용하며, 하드코딩된 `D-25`는 남아 있지 않다. |
| **위치** | `lib/utils/season_countdown.dart`, `lib/screens/dungeon/dungeon_home_screen.dart`, `test/utils/season_countdown_test.dart` |
| **난이도** | 완료 |
| **소요 시간** | 1시간 |
| **우선순위** | 🟢 P2 |
| **작업 주체** | Claude (설정 가능한 종료일 또는 Firebase Remote Config 연동) |

---

## Phase D: Audio & Feedback (만족스러운 인터랙션)

### D-1. 게임 사운드 이펙트 (핵심 갭)
| 항목 | 내용 |
|------|------|
| **현재 상태** | Soul Deck SFX/BGM 참조 에셋이 존재하며 `SoundService.referencedAssetPaths` 테스트로 잠김. block/heal 카드 효과도 전투 화면에서 SFX를 재생한다. |
| **위치** | `lib/services/sound_service.dart`, `lib/screens/dungeon/card_battle_screen.dart`, `test/services/sound_service_assets_test.dart` |
| **위험** | 신규 사운드 추가 시 에셋 누락은 테스트에서 잡히지만, 최종 믹싱/음량 밸런스는 실기기 QA 필요 |
| **난이도** | 코드 완료 / 최종 사운드 믹싱은 실기기 QA |
| **소요 시간** | 코드 완료 |
| **우선순위** | 🟡 P1 |
| **작업 주체** | Claude (SoundService 확장 코드) + 수동 (무료 사운드 라이브러리에서 소싱) |
| **추천 소스** | Freesound.org (CC0), Kenney.nl/assets (CC0 사운드), Pixabay Sound Effects |

### D-2. 배경 음악 시스템
| 항목 | 내용 |
|------|------|
| **문제** | BGM 시스템 없음. `flame_audio: ^2.10.4` pubspec에 있지만 미사용. 필요: 메뉴 BGM, 던전 탐험 BGM, 전투 BGM (존별), 보스 전투 BGM, 상점 BGM |
| **위치** | `pubspec.yaml:37` (`flame_audio`), 새 BGM 매니저 필요 |
| **난이도** | 보통 |
| **소요 시간** | 코드 2~3일 + 음악 소싱 |
| **우선순위** | 🟡 P1 |
| **작업 주체** | Claude (BGM 매니저) + 수동 (음악 파일) |

### D-3. 햅틱 피드백
| 항목 | 내용 |
|------|------|
| **문제** | 카드 플레이, 데미지, 크리티컬, 레벨업 시 진동 피드백 없음 |
| **위치** | `card_battle_screen.dart` 카드 플레이 핸들러, `card_combat_state.dart` 데미지 이벤트에 `HapticFeedback.heavyImpact()` 등 추가 |
| **난이도** | 쉬움 |
| **소요 시간** | 2~4시간 |
| **우선순위** | 🟢 P2 |
| **작업 주체** | Claude |

### D-4. SoundService Soul Deck 확장
| 항목 | 내용 |
|------|------|
| **현재 상태** | Soul Deck SFX 메서드가 구현되어 있고 참조 에셋 존재 테스트가 추가됨. 카드 카테고리, 턴 전환, block/heal 효과 사운드 연결 완료. |
| **위치** | `lib/services/sound_service.dart`, `lib/screens/dungeon/card_battle_screen.dart`, `test/services/sound_service_assets_test.dart` |
| **난이도** | 완료 |
| **소요 시간** | 완료 |
| **우선순위** | 🟡 P1 |
| **작업 주체** | Claude |

---

## Phase E: Onboarding & Tutorial (유저가 뭘 해야 할지 알려주기)

### E-1. Life Quest 첫 실행 튜토리얼

2026-05-28 update: first-run onboarding exists in `lib/screens/onboarding_screen.dart`, authenticated startup routes users without `hasSeenOnboarding` through it, onboarding completion is persisted via `CharacterState.completeOnboarding()`, and `scripts/check_release_readiness.sh` now verifies the screen, route, localized copy, and unit test. The separate Soul Deck first-battle guide now has its own persisted readiness gate.

| 항목 | 내용 |
|------|------|
| **문제** | 온보딩 플로우 없음. 신규 유저가 메인 화면에 도착해도 퀘스트 생성, 스탯, 게이미피케이션 루프에 대한 안내 없음 |
| **위치** | 새 화면/오버레이 필요, `lib/main.dart` AuthWrapper에서 첫 로그인 시 트리거 |
| **난이도** | 보통 |
| **소요 시간** | 3~5일 |
| **우선순위** | 🟡 P1 |
| **작업 주체** | Claude (Coach marks 오버레이, 단계별 가이드) |

### E-2. Soul Deck 튜토리얼 전투

2026-05-28 update: `lib/screens/dungeon/card_battle_screen.dart` now shows a first-battle guide for EP, card costs, attack/magic, defense/block, target selection, and End Turn. The guide is hidden after acknowledgement with `SharedPrefKeys.soulDeckBattleTutorialSeen`, and `scripts/check_release_readiness.sh` verifies the overlay, persistence key, and key test. Remaining work is richer scripted combat practice and real-device visual QA.

| 항목 | 내용 |
|------|------|
| **문제** | 첫 Soul Deck 진입 시 가이드 없음. 에너지, 카드 드로우, 카드 플레이, 블록/공격 차이, 상태이상, 적 인텐트 아이콘 등 설명 필요. Slay the Spire의 스크립트된 첫 전투 방식 |
| **위치** | `lib/screens/dungeon/dungeon_home_screen.dart`에서 첫 진입 시 트리거 |
| **난이도** | 어려움 |
| **소요 시간** | 5~7일 |
| **우선순위** | 🟡 P1 |
| **작업 주체** | Claude |

### E-3. 카드 툴팁 시스템
| 항목 | 내용 |
|------|------|
| **문제** | 카드에 복잡한 효과 (상태이상, 멀티히트, 조건부 트리거)가 있지만 상세 설명 없음. 롱프레스 시 "취약", "약화", "독" 등 키워드 설명 팝업 필요 |
| **위치** | `card_battle_screen.dart`, `card_collection_screen.dart` 카드 위젯 |
| **난이도** | 보통 |
| **소요 시간** | 2~3일 |
| **우선순위** | 🟡 P1 |
| **작업 주체** | Claude |

### E-4. 키워드 용어집
| 항목 | 내용 |
|------|------|
| **문제** | 11종 상태이상 타입에 대한 접근 가능한 용어집 필요 (전투 일시정지 메뉴 또는 Soul Deck 홈에서) |
| **위치** | 새 위젯/다이얼로그, `dungeon_home_screen.dart` 및 전투 일시정지에서 접근 |
| **난이도** | 쉬움 |
| **소요 시간** | 1일 |
| **우선순위** | 🟢 P2 |
| **작업 주체** | Claude |

---

## Phase F: Balance & QA (공정하고 재미있는 게임)

### F-1. 카드 밸런스 플레이 테스팅

2026-05-28 update: `test/balance/soul_deck_balance_smoke_test.dart` now verifies the starter deck composition, basic damage/block totals, playable non-curse card cost bounds, and that the starter deck clears every Zone 1 monster under a simple auto-play policy. `scripts/check_release_readiness.sh` gates the existence of this smoke test. This does not replace the required full manual balance playtest across all 207 cards.

| 항목 | 내용 |
|------|------|
| **문제** | 207장 카드가 한 번도 실제 플레이 테스트되지 않음. 데미지/비용/효과 비율이 불균형일 수 있음. 특정 카드 조합이 너무 강하거나 게임이 너무 쉽거나 어려울 수 있음 |
| **위치** | `lib/data/card_database.dart` (3902줄), `lib/state/card_combat_state.dart` (799줄) |
| **위험** | **재미없는 게임은 아트보다 더 빨리 유저를 이탈시킴** |
| **난이도** | 어려움 |
| **소요 시간** | 2~4주 (반복적 테스트) |
| **우선순위** | 🔴 P0 |
| **작업 주체** | 수동 플레이 테스트 필수. Claude는 통계 분석 (에너지당 DPS 계산, 파워 커브) 및 밸런스 조정 제안 가능 |

### F-2. 적 밸런스 / 난이도 곡선

2026-05-28 update: `test/balance/monster_balance_smoke_test.dart` now verifies zone threat averages increase, regular monsters stay within a bounded per-zone threat band, dungeon boss progression does not drop in threat, and early chapter floor scaling ramps upward. Dungeon boss node selection now uses an explicit Troll -> Hydra -> Dragon -> Demon Lord -> Fallen Angel progression instead of relying on raw list order. This is an automated curve guard, not a replacement for real-device and long-run enemy balance QA.

| 항목 | 내용 |
|------|------|
| **문제** | 5존 적/엘리트/보스 난이도 곡선 미검증. 어센션 모디파이어도 미테스트 |
| **위치** | `lib/data/monster_database.dart`, `lib/data/dungeon_generator.dart` |
| **난이도** | 어려움 |
| **소요 시간** | 1~2주 |
| **우선순위** | 🟡 P1 |
| **작업 주체** | 수동 플레이 테스트 + Claude (스탯 스케일링 수학적 분석) |

### F-3. IAP 서버사이드 영수증 검증 ✅ 코드 완료 (배포 수동 필요)
| 항목 | 내용 |
|------|------|
| **상태** | ✅ Cloud Function `verifyGooglePlayPurchase` 구현 완료 (`functions/src/index.ts`, 커밋 `4a821fd`) |
| **남은 작업** | `firebase functions:secrets:set GOOGLE_PLAY_SERVICE_ACCOUNT` → `firebase deploy --only functions` (수동) |
| **위치** | `functions/src/index.ts`, `lib/services/purchase_service.dart` |

### F-4. 광고 일일 리셋 시간 조작 방지 ✅ 완료
| 항목 | 내용 |
|------|------|
| **상태** | ✅ Firestore 서버 타임스탬프 앵커 + 모노토닉 Stopwatch 기반 구현 완료 (`d1025a4`) |
| **위치** | `lib/services/ad_service.dart` `_syncServerTime()`, `_serverNow()` |

### F-5. 서비스 유닛 테스트
| 항목 | 내용 |
|------|------|
| **문제** | 핵심 서비스(AdService, PurchaseService 등) 테스트 미흡. 현재 73개 테스트는 CharacterState/Quest 위주 |
| **위치** | `test/` 디렉토리 |
| **난이도** | 보통 |
| **소요 시간** | 3~5일 |
| **우선순위** | 🟡 P1 |
| **작업 주체** | Claude |

### F-6. flutter analyze & flutter test 재검증 ✅ 완료
| 항목 | 내용 |
|------|------|
| **상태** | ✅ `flutter analyze` → No issues / `flutter test` → 73개 통과 (2026-04-26 기준) |

---

## Phase G: Store Listing and Play Console App Content

### G-1. Play Store 스크린샷
| 항목 | 내용 |
|------|------|
| **문제** | 4~8장 스크린샷 필요: Today/일일 모험, 퀘스트 생성 또는 완료, 성장 프로필, 던전 입장, Soul Deck 전투, 카드 보상, 집중 타이머, 설정/계정 삭제 접근 |
| **현재 정정** | 스크린샷은 실제 Android 빌드에서 캡처해야 하며 Web QA Preview, 비활성 광고/결제, Health Connect, AI 코치, 구독 기능을 암시하면 안 된다. |
| **난이도** | 보통 |
| **소요 시간** | 1~2일 (비주얼 폴리시 완료 후) |
| **우선순위** | 🟡 P1 |
| **작업 주체** | 수동 (기기 캡처 + 디자인 도구로 프레임/텍스트 추가) |

### G-2. Play Store 설명 & 메타데이터

2026-06-04 update: `docs/lifequest-play-store-listing-draft-20260520.md` has been rewritten with readable Korean and English listing copy for the default Android build. `test/docs/play_store_listing_draft_test.dart` now gates Play Console field lengths, common mojibake markers, unsupported Health/AI/subscription/ad claims, and default-build monetization/health-scope wording. Final Play Console entry remains manual.

| 항목 | 내용 |
|------|------|
| **문제** | 앱 제목, 짧은 설명 (80자), 전체 설명 (4000자), 카테고리, 콘텐츠 등급, 대상 연령 |
| **난이도** | 쉬움 |
| **소요 시간** | 2~3시간 |
| **우선순위** | 🟡 P1 |
| **작업 주체** | Claude (텍스트 초안) + 수동 (Play Console 입력) |

### G-3. 대표 이미지 & 프로모션 영상
| 항목 | 내용 |
|------|------|
| **문제** | 1024x500 대표 이미지 필수. 프로모션 영상은 선택이지만 전환율 대폭 향상 |
| **난이도** | 보통 |
| **소요 시간** | 1~2일 |
| **우선순위** | 🟡 P1 (이미지) / 🟢 P2 (영상) |
| **작업 주체** | 수동 (디자인 도구 또는 AI 이미지 생성) |

### G-4. 콘텐츠 등급 설문 (IARC)
| 항목 | 내용 |
|------|------|
| **현재 정정** | IARC는 `docs/lifequest-play-console-submission-runbook-20260525.md` 기준으로 답변한다. 기본 Android 빌드는 판타지 카드 전투가 있지만 실제 도박, UGC, 활성 광고, 활성 인앱구매는 없다. |
| **난이도** | 쉬움 |
| **소요 시간** | 30분 |
| **우선순위** | 🔴 P0 |
| **작업 주체** | 수동 |

### G-5. 데이터 안전 섹션

2026-06-04 update: `test/docs/data_safety_draft_test.dart` now gates the repository-side Data safety draft against the default Android release scope, monetization/analytics evidence, common mojibake markers, unsupported Health/AI claims, and manifest permissions that would require re-review. Final Play Console Data safety entry remains manual.

| 항목 | 내용 |
|------|------|
| **현재 정정** | Data safety는 `docs/lifequest-play-console-data-safety-draft-20260520.md`와 `docs/lifequest-play-console-submission-runbook-20260525.md` 기준으로 입력한다. 기본 Android 빌드에서는 AdMob/Billing이 비활성화되어 광고 데이터와 구매 기록을 현재 수집 항목으로 답변하지 않는다. |
| **난이도** | 보통 |
| **소요 시간** | 1~2시간 |
| **우선순위** | 🔴 P0 |
| **작업 주체** | 수동 (Play Console 폼) + Claude (답변 초안) |

---

## 실행 스프린트 계획

### Sprint 1 (1~2주차): 기반 정비 — 빌드 & 크래시 방지

| ID | 작업 | 소요 | 작업자 |
|----|------|------|--------|
| A-2 | Firebase 패키지명 업데이트 | 30분 | 수동 |
| A-3/A-4 | AdMob ID 확인 | 30분 | 수동 |
| A-5 | 에셋 디렉토리 + placeholder 생성 | 1시간 | Claude |
| A-7 | 개인정보 처리방침 작성 + 호스팅 | 3시간 | Claude+수동 |
| A-8 | 버전 번호 설정 | 5분 | Claude |
| A-9 | Crashlytics 통합 | 3시간 | Claude |
| F-6 | flutter analyze + test 재실행 | 1시간 | Claude |
| A-1 | **첫 기기 테스트 (가장 중요!)** | 2~3일 | 수동 |

### Sprint 2 (2~4주차): 게임답게 만들기 — 비주얼 핵심

| ID | 작업 | 소요 | 작업자 |
|----|------|------|--------|
| B-1 | 카드 비주얼 시스템 (프레임, 테두리, 아이콘) | 1~2주 | Claude+아티스트/AI |
| B-2 | 적 & 플레이어 스프라이트 Flame 통합 | 1~2주 | Claude+아티스트/AI |
| B-5 | 렐릭 아이콘 시스템 | 2~3일 | Claude |
| D-1 | 게임 사운드 이펙트 소싱 | 1~2주 | 수동 |
| D-4 | SoundService 확장 코드 | 완료 | Claude |

### Sprint 3 (4~5주차): 게임 느낌 — 애니메이션 & 오디오

| ID | 작업 | 소요 | 작업자 |
|----|------|------|--------|
| B-3 | 전투 애니메이션 (B-2 의존) | 3~5일 | Claude |
| B-4 | 던전 맵 비주얼 강화 | 3~5일 | Claude |
| D-2 | 배경 음악 시스템 | 2~3일 | Claude |
| D-3 | 햅틱 피드백 | 4시간 | Claude |
| C-5 | 시즌 카운트다운 수정 | 1시간 | Claude |

### Sprint 4 (5~7주차): 온보딩 & 밸런스

| ID | 작업 | 소요 | 작업자 |
|----|------|------|--------|
| E-1 | Life Quest 튜토리얼 | 3~5일 | Claude |
| E-2 | Soul Deck 튜토리얼 전투 | 5~7일 | Claude |
| E-3 | 카드 툴팁 시스템 | 2~3일 | Claude |
| F-1 | **카드 밸런스 플레이 테스트** | 2~4주 | 수동 |
| F-2 | 적 밸런스 | 1~2주 | 수동 |

### Sprint 5 (7~8주차): 마감 & 출시

| ID | 작업 | 소요 | 작업자 |
|----|------|------|--------|
| A-6 | ProGuard / R8 설정 | 4시간 | Claude |
| F-3 | IAP 서버 검증 | 3~5일 | Claude+수동 |
| F-5 | 서비스/스크린 테스트 | 3~5일 | Claude |
| C-1~C-4 | 비주얼 폴리시 | 1주 | Claude |
| G-1~G-5 | 스토어 등록 | 2~3일 | Claude+수동 |

---

## 전체 일정 요약

| 목표 | 기간 | 설명 |
|------|------|------|
| **최소 출시 가능** | 4~5주 | 기본 에셋 + 핵심 UX + 크래시 방지 |
| **완성도 높은 출시** | 8~10주 | 풀 비주얼 + 사운드 + 튜토리얼 + 밸런싱 |

### 🚨 병목 지점
> **아트 에셋 (스프라이트, 카드 아트, 배경)**이 B-1, B-2, B-3, C-1을 블로킹합니다.
> AI 아트 생성 도구 (Midjourney, Stable Diffusion, DALL-E)를 사용하면 1~2주 → 3~5일로 단축 가능.

### 핵심 파일 참조

| 파일 | 중요 사항 |
|------|----------|
| `lib/game/battle_game.dart` | 4개 빈 애니메이션 스텁, 스프라이트 로딩 없음, 핵심 비주얼 갭 |
| `lib/services/sound_service.dart` | Soul Deck SFX 메서드와 에셋 존재 테스트 완료. 남은 것은 실기기 음량/믹싱 QA |
| `lib/services/purchase_service.dart` | Release builds reject unverified purchases; Cloud Function deployment/console verification still required |
| `lib/screens/dungeon/card_battle_screen.dart` | 1858줄 전투 UI, 카드 렌더링에 아트 통합 필요, TODO (line 242) |
| `android/app/build.gradle.kts` | Release minify/shrink enabled; release signing fails closed if key.properties is missing; default AdMob App ID remains empty |
