# Life Quest Web QA Preview 빌드 감사

작성일: 2026-05-08 KST  
목적: Web QA Preview를 실제로 만들 수 있는지 `flutter build web` 기준으로 확인하고, 차단점/주의점을 분리 기록한다.

---

## 1. 실행 명령

```powershell
$env:DART_SUPPRESS_ANALYTICS='true'
$env:FLUTTER_SUPPRESS_ANALYTICS='true'
C:\dev\flutter\bin\cache\dart-sdk\bin\dart.exe C:\dev\flutter\packages\flutter_tools\bin\flutter_tools.dart build web --dart-define=LIFEQUEST_QA_PREVIEW=true
```

---

## 2. 결과

결과: **성공**

```text
√ Built build\web
```

의미:

- 현재 코드베이스는 최소한 JS 기반 Flutter Web 배포 산출물을 만들 수 있다.
- `web/` 디렉터리와 기본 웹 엔트리포인트는 존재한다.
- `build/web` 산출물을 정적 호스팅에 올리는 1차 Preview 전략이 가능하다.

---

## 3. 빌드 중 경고

Wasm dry run 경고:

```text
Found incompatibilities with WebAssembly.
flutter_timezone-5.0.1/lib/flutter_timezone_web.dart
invalid_runtime_check_with_js_interop_types lint violation
```

판단:

- 현재 목표인 Web QA Preview의 JS 빌드는 성공했다.
- Wasm 최적화 빌드는 지금 당장 필수 목표가 아니다.
- 추후 성능 최적화 단계에서 `flutter_timezone` 업데이트 또는 웹 알림/타임존 기능 no-op 분리를 검토한다.

---

## 4. 예상 차단점 대비 실제 결과

| 항목 | 예상 | 실제 1차 빌드 결과 | 판단 |
|---|---|---|---|
| `firebase_options.dart` Web 설정 없음 | 런타임 차단 예상 | 컴파일은 성공 | 앱 실행 시 Firebase 초기화에서 `UnsupportedError` 가능성 큼 |
| `notification_service.dart` `dart:io` | 컴파일 차단 예상 | 컴파일 성공 | 직접 import 구조가 웹 컴파일에서 즉시 깨지진 않았지만 런타임/기능 분리 필요 |
| `HomeWidget` | 컴파일 차단 가능 | 컴파일 성공 | 웹 실행 시 호출 금지 필요 |
| `AdService` / AdMob | 컴파일 차단 가능 | 컴파일 성공 | 웹 QA에서는 숨김/no-op 필요 |
| `PurchaseService` / IAP | 컴파일 차단 가능 | 컴파일 성공 | 웹 QA에서는 숨김/no-op 필요 |
| `signup_screen.dart` 이미지 업로드 | 컴파일 차단 가능 | 컴파일 성공 | 웹 QA에서는 프로필 업로드를 숨기거나 별도 구현 필요 |
| `flutter_timezone` | Wasm 경고 가능 | Wasm dry-run 경고 발생 | JS Preview는 가능, Wasm은 추후 대응 |

---

## 5. 다음 실제 차단점

빌드는 성공했지만, **웹 실행 가능**과 **테스터가 쓸 수 있음**은 다르다. 다음 차단점은 런타임이다.

가장 먼저 확인할 런타임 위험:

1. `DefaultFirebaseOptions.currentPlatform`이 웹에서 `UnsupportedError`를 던짐
2. `FirebaseCrashlytics.instance`가 웹에서 정상 동작하지 않을 가능성
3. `FirebaseAppCheck.activate`가 웹 설정 없이 실패할 가능성
4. `HomeWidget.setAppGroupId` 호출이 웹에서 실패할 가능성
5. Firebase Auth 로그인 화면이 테스터 진입을 막음

---

## 6. 다음 작업 계획

### Step A. 로컬 웹 실행 확인

목표:

- `build/web`을 로컬 정적 서버로 열거나 `flutter run -d chrome`으로 실행
- 첫 화면이 어디서 멈추는지 확인

체크:

- Firebase Web 옵션 없음으로 앱이 시작 전에 죽는지
- 로그인 화면까지 도달하는지
- 콘솔 에러가 무엇인지

### Step B. QA Preview 진입점 추가

목표:

- `LIFEQUEST_QA_PREVIEW=true`이면 Firebase Auth 의존 없이 시작 가능하게 만든다.

원칙:

- Android 정식 앱 흐름은 유지
- QA Preview에서만 게스트 프로필/로컬 저장/mock 데이터 사용

### Step C. 웹 전용 서비스 분리

우선순위:

1. Firebase 초기화 분기 또는 Web Firebase 설정 추가
2. Crashlytics/App Check 웹 skip
3. Notification/HomeWidget skip
4. Ad/IAP 버튼 숨김 또는 no-op
5. 이미지 업로드 숨김

---

## 7. 현재 판단

Web QA Preview는 가능성이 높다. 1차 컴파일이 성공했으므로, 남은 작업은 패키지 교체보다 **런타임 분기와 QA 모드 설계**가 중심이다.

가장 빠른 전략:

```text
Firebase Auth 기반 앱 시작을 우회하는 QA Preview 시작 경로를 만든다.
로컬 게스트 프로필을 SharedPreferences(web)에 저장한다.
핵심 화면에 mock/seed 상태를 넣어 바로 체험 가능하게 만든다.
```

---

## 8. 런타임 1차 확인

실행:

```powershell
flutter run -d chrome --dart-define=LIFEQUEST_QA_PREVIEW=true
```

첫 실행 결과:

- Chrome 디버그 서비스 연결 성공
- 앱 시작 중 `FirebaseCrashlytics.instance`가 웹 Firebase 미설정 상태에서 예외 처리 경로를 다시 터뜨림

조치:

- `kLifeQuestQaPreview` 전역 플래그 추가
- QA Preview 모드에서는 Firebase 초기화, Crashlytics, App Check, optional services 초기화를 skip
- `MaterialApp.home`을 `QaPreviewGateScreen`으로 교체

두 번째 실행 결과:

- Crashlytics 차단점은 제거됨
- `CharacterState` 생성 시 `FirebaseFirestore.instance`를 즉시 잡으면서 웹 Firebase 미설정 예외 발생

조치:

- `CharacterState`의 Firestore 인스턴스를 생성자 즉시 초기화에서 lazy getter로 변경
- QA Preview용 `initializeForQaPreview()` 추가
- `MainScreen`의 FirebaseAuth auth subscription은 QA Preview에서 skip

세 번째 실행 결과:

- Chrome 디버그 서비스 연결 성공
- `flutter run` 콘솔 기준 새 Firebase 런타임 예외 없음
- Playwright로 `http://localhost:2303/` 접근 시 문서 title이 `Life Quest`로 확인됨
- `flutter-view`가 390×844 모바일 뷰포트에 mount됨

주의:

- Flutter Web canvas 기반 화면이라 Playwright 접근성 snapshot만으로 실제 픽셀 화면을 완전히 확인하기 어렵다.
- 수동/스크린샷 기반 시각 QA 또는 Chrome DevTools Protocol screenshot 경로가 추가로 필요하다.
- 좌표 기반 JS synthetic click은 Flutter pointer id 처리와 맞지 않아 콘솔 오류를 만들 수 있으므로 사용하지 않는다.

---

## 9. 현재 구현된 것

- `lib/config/qa_preview_config.dart`
  - `LIFEQUEST_QA_PREVIEW` dart-define 플래그
- `lib/screens/qa_preview_gate_screen.dart`
  - Web QA Preview 시작 화면
  - `게스트로 테스트 시작` 버튼
- `lib/main.dart`
  - QA Preview 모드에서 Firebase/Auth 시작 경로 우회
  - QA Preview 모드에서 Crashlytics/AppCheck/Optional services skip
- `lib/screens/main_screen.dart`
  - QA Preview 모드에서 FirebaseAuth subscription skip
- `lib/state/character_state.dart`
  - Firestore lazy 초기화
  - QA Preview용 seed profile 초기화 메서드

---

## 10. 다음 차단점

1. `게스트로 테스트 시작` 후 MainScreen 내부 실제 화면 조작 QA
2. 퀘스트 완료/카드 보상/상점 구매 등 저장이 발생하는 기능에서 FirebaseAuth/FirebaseFirestore 의존이 다시 호출되는지 확인
3. SharedPreferences(web) 기반 로컬 저장으로 `_performSaveData()`의 QA Preview 분기 구현
4. 웹 화면 픽셀 스크린샷 경로 확보
5. Firebase Hosting 또는 로컬 정적 서버로 외부 공유 URL 준비

---

## 11. SharedPreferences 게스트 저장 1차 구현 및 검증

### 구현

- `CharacterState.initializeForQaPreview()`를 비동기 진입점으로 변경했다.
- QA Preview 최초 진입 시 `testuser1` 로컬 게스트 프로필을 생성하고 즉시 저장한다.
- QA Preview 재진입 시 `SharedPreferences`에서 `lifequest.qaPreview.state.v1` snapshot을 복원한다.
- `_performSaveData()`에 QA Preview 분기를 추가해 Firebase Auth/Firestore 없이 로컬 저장만 수행한다.
- 저장 payload는 기존 Firestore payload와 같은 구조를 사용하되, Web localStorage에 저장할 수 없도록 `FieldValue.serverTimestamp()`만 제외한다.
- QA Preview 시작 화면은 저장/복원 실패를 SnackBar로 표시하고, 성공 시 `MainScreen`으로 이동한다.

### 검증

```powershell
flutter analyze --no-pub
flutter test
flutter build web --dart-define=LIFEQUEST_QA_PREVIEW=true
flutter run -d chrome --dart-define=LIFEQUEST_QA_PREVIEW=true
```

결과:

- `flutter analyze --no-pub` -> No issues found.
- `flutter test` -> 95개 전체 통과.
- `flutter build web --dart-define=LIFEQUEST_QA_PREVIEW=true` -> `build\web` 생성 성공.
- Chrome 런타임에서 QA Preview 게이트 표시 확인.
- Playwright 접근성 활성화 후 `게스트로 테스트 시작` 버튼 클릭 성공.
- `MainScreen` 상태창 진입 확인:
  - `testuser1`
  - `Lv. 1 | 새싹 모험가`
  - `XP 85 / 150`
  - `HP 100 / 100`
  - `골드 52`
- Web localStorage에 `flutter.lifequest.qaPreview.state.v1` 생성 확인.
- 저장 snapshot 안에 daily/weekly/monthly/yearly QA 퀘스트, 기본 카드, 샘플 카드, 커스텀 보상이 포함됨을 확인.

### 남은 차단/주의

- Wasm dry-run 경고는 여전히 `flutter_timezone-5.0.1`의 JS interop lint에서 발생한다. 현재 JS 기반 Web QA Preview 빌드는 성공하므로 즉시 차단 사항은 아니다.
- Flutter Web canvas 특성상 일반 DOM 스냅샷만으로는 시각 QA가 부족하다. 이후 카드팩/컬렉션/상점/휴식/전투 보상 화면은 실제 스크린샷 기반으로 확인해야 한다.
- 다음 구현 범위는 퀘스트 완료, 사냥 진입, 카드 보상, 상점/휴식처럼 저장을 발생시키는 핵심 루프에서 Firebase 호출 없이 진행되는지 확인하는 것이다.

---

## 12. Firebase Hosting 실배포 결과

### 최종 URL

- https://life-quest-app-95eb9.web.app

### Hosting 설정

- `.firebaserc`
  - default project: `life-quest-app-95eb9`
- `firebase.json`
  - `hosting.public`: `build/web`
  - `rewrites`: 모든 경로를 `/index.html`로 연결해 Flutter Web SPA 진입 보장
  - `headers`: QA Preview 배포 반영 지연을 줄이기 위해 `Cache-Control: no-cache`

### 빌드/배포 명령

```powershell
flutter build web --dart-define=LIFEQUEST_QA_PREVIEW=true --pwa-strategy=none
npx firebase-tools deploy --only hosting --project life-quest-app-95eb9
```

### 검증 결과

- `flutter analyze --no-pub` -> No issues found.
- `flutter test` -> 96개 전체 통과.
- `flutter build web --dart-define=LIFEQUEST_QA_PREVIEW=true --pwa-strategy=none` -> 성공.
- Firebase Hosting deploy -> 성공.
- 배포 URL 런타임 확인:
  - QA Preview 게이트 표시.
  - 게스트 시작 후 상태창 진입.
  - `testuser1`, `Lv. 1 | 새싹 모험가`, `XP 85 / 150`, `골드 52` 표시.
  - localStorage에 `flutter.lifequest.qaPreview.state.v1` 생성.
  - 첫 일일 퀘스트 완료 후 Lv.2, XP 약 5.2, max XP 200, 골드 62 저장.
  - 최종 JS가 더 이상 `sounds/quest_complete.mp3`를 참조하지 않고 `sounds/sfx/level_up.wav`를 참조함.
  - Hosting 응답 헤더 `Cache-Control: no-cache` 확인.

### 주의사항

- `no-cache` 헤더 적용 전에 열려 있던 브라우저 탭은 기존 JS를 유지할 수 있다. 해당 탭은 강력 새로고침 후 다시 확인해야 한다.
- Wasm dry-run 경고는 `flutter_timezone-5.0.1`의 JS interop lint에서 발생한다. 현재 공유 URL은 JS Flutter Web 빌드이므로 배포 차단 사항은 아니다.
- 다음 QA 범위는 카드팩, 컬렉션, 상점, 휴식, 사냥/전투/보상 흐름의 실제 모바일 브라우저 검증이다.

---

## 13. QA Preview 초기 프로필 정상화

초기 seed가 `testuser1`, XP `85 / 150`, 골드 `52`로 시작하면 실제 테스터에게 개발 검증 계정처럼 보인다. QA Preview의 목적은 로그인 없는 체험이므로, 초기 상태는 신규 사용자에 가까운 값으로 맞춘다.

변경:

- 기본 이름: `게스트 모험가`
- 기본 XP: `0 / 150`
- 기본 골드: `0`
- 기본 스탯: STR/WIS/HP/CHA 모두 `0`
- 기본 카드 포인트: `0`
- localStorage key: `lifequest.qaPreview.state.v2`

주의:

- 저장 키를 v2로 올렸기 때문에 기존 v1 개발용 preview 상태는 복원하지 않는다.
- 기존에 열려 있던 브라우저 탭은 새 배포 후 강력 새로고침 또는 localStorage 초기화가 필요할 수 있다.

검증/배포:

- `dart analyze` -> No issues found.
- `flutter test --no-pub test/state/character_state_test.dart` -> 22개 통과.
- `flutter build web --dart-define=LIFEQUEST_QA_PREVIEW=true --pwa-strategy=none` -> 성공.
- Firebase Hosting 재배포 -> 성공.
- 배포 URL: https://life-quest-app-95eb9.web.app
- 배포된 JS에 `lifequest.qaPreview.state.v2`가 포함되고 `lifequest.qaPreview.state.v1`이 빠진 것을 확인했다.
- QA Preview 게이트와 `게스트로 테스트 시작` 문구는 Playwright 접근성 활성화 후 확인했다.
- 버튼 클릭 이후 상태창 값 검증은 Codex 사용량 제한으로 자동화하지 못했다. 다음 확인 기준은 새 접속 후 `게스트 모험가`, XP `0 / 150`, 골드 `0`이다.

---

## 14. QA Preview 광고/후원 노출 제거

테스터 공개용 프리뷰에서는 수익화 장치를 설명하거나 광고 시청을 유도하는 UI가 제품 인상을 흐린다. QA Preview 전용 분기로 아래 노출을 제거했다.

- 설정:
  - 광고 후원 안내 카드 숨김.
  - debug 광고 검증 카드 숨김.
- 리포트:
  - 확장 리포트를 광고 없이 즉시 열린 상태로 표시.
  - 광고 보기 버튼 미노출.
- 사냥:
  - 전투 승리 보상 2배 광고 버튼 미노출.
  - 전투 패배 부활 광고 버튼 미노출.
  - AP 부족 시 광고 회복 다이얼로그 대신 일반 부족 안내만 표시.
- 코스메틱 상점:
  - 광고 후원형 운영 문구가 들어간 준비 안내 카드 숨김.

검증:

- `dart analyze` -> No issues found.
- `flutter build web --dart-define=LIFEQUEST_QA_PREVIEW=true --pwa-strategy=none` -> 성공.
- Firebase Hosting 재배포 -> 성공.
- 배포 URL: https://life-quest-app-95eb9.web.app

---

## 15. 모바일 프레임 웹 렌더링

문제:

- 데스크톱 브라우저에서 QA Preview가 화면 전체를 차지해 실제 앱 체험과 거리가 있었다.
- `flutter-view` 자체를 CSS로 직접 제어하면 Flutter 런타임 배치와 충돌했다.

해결:

- `web/flutter_bootstrap.js`를 추가해 공식 Flutter Web `hostElement` 방식으로 `#flutter_host`에 앱을 렌더링.
- `web/index.html`에 `#flutter_host` 프레임 스타일 추가:
  - 데스크톱: 최대 `430 x 932`, 중앙 배치, 둥근 모서리와 프레임 경계.
  - 모바일 폭 `430px` 이하: 전체 화면.

검증:

- `flutter build web --dart-define=LIFEQUEST_QA_PREVIEW=true --pwa-strategy=none` -> 성공.
- Firebase Hosting 재배포 -> 성공.
- 배포 URL: https://life-quest-app-95eb9.web.app
- Browser QA:
  - 데스크톱 뷰포트에서 중앙 휴대폰 프레임 확인.
  - `390 x 844` 뷰포트에서 전체 화면 모바일 렌더링 확인.
  - page title `Life Quest`, relevant console warn/error 없음.
