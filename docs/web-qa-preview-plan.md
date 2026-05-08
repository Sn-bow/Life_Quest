# Life Quest Web QA Preview 계획서

작성일: 2026-05-08 KST  
목적: Google Play 테스트 배포 전, 웹 링크로 테스터를 먼저 모집하고 UI/게임 흐름 피드백을 받을 수 있는 임시 QA Preview를 만든다.

---

## 1. 결론

가능하다. 다만 현재 Android 앱을 그대로 웹에 올리는 방식이 아니라, **피드백 수집용 Web QA Preview**로 범위를 제한해야 한다.

이 Preview는 정식 웹 서비스가 아니다. 설치 없이 링크로 접속해 Life Quest의 핵심 루프를 눌러보고, 부족한 디자인/카피/게임 흐름을 피드백받기 위한 임시 빌드다.

정확한 제품 목표:

- Android 앱의 1:1 복제품을 만들지 않는다.
- 대신 Android 앱과 같은 **시각 언어, 정보 구조, 핵심 루프**를 웹에서 체험 가능하게 만든다.
- 테스터가 추후 Android 앱을 설치했을 때 낯설지 않도록 하단 탭, 다크 RPG UI, 카드 비주얼, 던전/전투/보상 흐름은 최대한 유지한다.
- 로그인/광고/결제/알림/홈 위젯처럼 Android 또는 운영 인프라 의존 기능은 게스트 프로필, localStorage/shared_preferences(web), mock UI, 숨김 처리로 대체한다.

권장 운영 흐름:

1. Flutter Web 빌드 가능 여부 확인
2. 웹에서 깨지는 Android 전용 기능을 mock/비활성화
3. Firebase 로그인 없이 진입 가능한 QA/Test Mode 추가
4. 퀘스트/상태창/소울 덱/카드 보상/컬렉션/상점/휴식 중심으로 피드백 가능하게 구성
5. Firebase Hosting Preview Channel 또는 별도 Hosting URL로 공유
6. 충분한 피드백 후 Firebase App Distribution 또는 Google Play Closed Testing으로 이동

---

## 1-1. 자료조사 요약

공식 자료 기준 확인 사항:

- Flutter는 Web 배포 빌드를 공식 지원하며, `flutter build web` 산출물을 정적 호스팅에 올리는 흐름을 제공한다.
- Flutter Web은 CanvasKit 계열 렌더링을 사용하므로, 모바일 Flutter UI와 같은 위젯/자산 기반 디자인을 웹에서도 비교적 일관되게 보여줄 수 있다. 단, 실제 Android 터치감/네이티브 기능까지 동일하다고 보면 안 된다.
- Firebase Hosting Preview Channel은 만료일이 있는 임시 미리보기 URL을 제공하므로, 외부 테스터에게 빠르게 공유하기 좋다.
- `shared_preferences`는 웹 구현을 제공하므로, QA Preview의 로컬 게스트 프로필 저장소로 사용할 수 있다. 브라우저/기기 변경, 시크릿 모드, 저장소 삭제 시 데이터가 사라지는 제약은 명시해야 한다.

참고 공식 문서:

- Flutter Web 배포: https://docs.flutter.dev/deployment/web
- Flutter Web 렌더러: https://docs.flutter.dev/platform-integration/web/renderers
- Firebase Hosting Preview Channel: https://firebase.google.com/docs/hosting/test-preview-deploy
- shared_preferences 패키지: https://pub.dev/packages/shared_preferences

---

## 2. 기존 작업 유지 확인

아래 항목은 이미 `docs/SHARED_WORK_LOG.md`에 기록되어 있으며, Web QA 작업으로 덮어쓰거나 잊으면 안 된다.

- `flutter analyze --no-pub` -> No issues found
- 카드 에셋 관련 테스트 16개 -> All passed
- `flutter build apk --debug --split-per-abi` -> 성공
- ADB 설치 -> 성공
- 실기기 전투 보상 화면 -> overflow 제거 확인
- 다음 작업:
  1. 카드팩/컬렉션/상점/휴식 화면에서 `reward=108`, `mini=72`, `hand=110` 조합 전체 화면 QA
  2. 긴 한국어 카드 설명을 카드 UI 기준으로 짧게 정리하는 카피 QA
  3. 문제가 없으면 uncommon/rare/legendary 12장 full-body 카드 생성 및 등록

Web QA Preview는 위 카드 QA 흐름을 대체하지 않는다. 오히려 위 항목을 더 많은 사람에게 빠르게 확인받기 위한 보조 배포 채널이다.

---

## 3. 현재 앱의 Web 빌드 예상 차단점

### 3-1. Firebase Web 설정 없음

파일: `lib/firebase_options.dart`

현재 `kIsWeb`에서 바로 `UnsupportedError`를 던진다.

필요 작업:

- Firebase Web App 등록
- Web용 `FirebaseOptions` 추가
- Web QA Preview에서는 App Check/Crashlytics를 강제하지 않도록 분기

### 3-2. Android/iOS 전용 서비스 초기화

파일: `lib/main.dart`

현재 앱 시작 시 아래 서비스가 공통으로 초기화된다.

- `NotificationService.init`
- `SoundService.init`
- `AdService.init`
- `PurchaseService.init`
- `HomeWidget.setAppGroupId`

웹에서는 최소한 아래 처리가 필요하다.

- `NotificationService`: 웹에서는 no-op 또는 브라우저 알림 별도 구현 전까지 비활성화
- `AdService`: 웹 QA에서는 비활성화
- `PurchaseService`: 웹 QA에서는 비활성화
- `HomeWidget`: 웹에서는 호출 금지
- `SoundService`: 웹 지원 여부 확인 후 실패해도 앱 진행 가능하게 유지

### 3-3. `dart:io` 사용

파일:

- `lib/services/notification_service.dart`
- `lib/screens/signup_screen.dart`

위 파일은 웹 컴파일에서 직접 문제가 될 가능성이 높다.

필요 작업:

- `notification_service.dart`를 platform 분기 또는 stub 구조로 분리
- `signup_screen.dart`의 `File`, `ImagePicker`, Firebase Storage 업로드 흐름을 웹 대응 또는 QA Preview에서 숨김

### 3-4. Android 중심 패키지

주의 대상:

- `flutter_local_notifications`
- `flutter_timezone`
- `home_widget`
- `google_mobile_ads`
- `in_app_purchase`
- `firebase_crashlytics`
- `firebase_app_check`
- `image_picker`
- `firebase_storage`

이 중 일부는 웹 패키지가 있거나 빌드는 될 수 있지만, QA Preview에서는 기능을 줄이는 편이 안전하다.

---

## 4. Web QA Preview 범위

### 반드시 열 기능

- 로그인 없이 테스트 진입
- 상태창 기본 확인
- 퀘스트 생성/완료 흐름
- 소울 덱 홈
- 던전 진입
- 전투 손패 카드
- 전투 승리 보상 카드
- 카드팩
- 카드 컬렉션
- 던전 상점
- 휴식 업그레이드
- 피드백 제출 버튼 또는 외부 폼 링크

### 일단 막거나 mock 처리할 기능

- Google 로그인
- 실계정 Firebase 데이터 저장
- AdMob 보상 광고
- 인앱결제
- Android 알림
- 홈 위젯
- 이미지 업로드/프로필 사진
- Crashlytics/App Check 강제 초기화

---

## 5. 테스트 모드 진입점 설계

권장 방식:

```text
flutter run -d chrome --dart-define=LIFEQUEST_QA_PREVIEW=true
flutter build web --dart-define=LIFEQUEST_QA_PREVIEW=true
```

앱 내부 설계:

- `bool kQaPreview = bool.fromEnvironment('LIFEQUEST_QA_PREVIEW')`
- `kQaPreview == true`이면:
  - Firebase Auth 로그인 화면 대신 QA 시작 화면 제공
  - `testuser1` 고정 프로필 생성
  - 기본 퀘스트/스탯/골드/카드/던전 상태를 로컬 메모리 또는 SharedPreferences 기반으로 주입
  - 위험 기능 메뉴는 숨기거나 disabled 상태로 표시

초기 QA 화면 버튼:

- `퀘스트부터 시작`
- `소울 덱 바로 테스트`
- `카드 보상 화면 테스트`
- `상점/휴식 테스트`
- `피드백 보내기`

---

## 6. 배포 방식 후보

### 6-1. Firebase Hosting Preview Channel

장점:

- Firebase 프로젝트와 자연스럽게 연결
- 임시 URL 공유 가능
- QA 빌드 교체가 빠름

주의:

- 현재 `firebase.json`에 hosting 설정이 없다.
- `firebase init hosting` 또는 수동 hosting 설정이 필요하다.

### 6-2. Netlify/Vercel

장점:

- `build/web` 폴더 정적 배포가 간단
- Preview URL 공유가 쉽다.

주의:

- Firebase 연동 기능을 쓸 경우 도메인 허용 목록 설정 필요.
- 현재 프로젝트는 Firebase 중심이라 Firebase Hosting이 더 자연스럽다.

---

## 7. 작업 계획

### Step 1. 빌드 가능성 조사

- `flutter build web --no-pub` 또는 `flutter build web` 실행
- 실패 로그를 기준으로 실제 차단 파일 목록 작성
- 예상 차단점과 실제 차단점을 분리 기록

산출물:

- `docs/web-qa-preview-build-audit.md`

### Step 2. 플랫폼 분기 최소 패치

- `main.dart`에서 웹 전용으로 optional service 초기화 일부 skip
- `firebase_options.dart` 웹 설정 추가 또는 QA Preview에서 Firebase 초기화 우회 여부 결정
- `notification_service`, `home_widget`, `ad_service`, `purchase_service`의 웹 no-op 전략 확정

산출물:

- 코드 패치
- `flutter analyze`
- `flutter build web` 결과

### Step 3. QA Preview Mode 추가

- `LIFEQUEST_QA_PREVIEW` dart-define 추가
- 로그인 없이 QA 시작 가능하게 진입점 구성
- mock 데이터 주입
- 위험 기능 숨김

산출물:

- 로컬 Chrome 실행 가능 상태
- QA Preview 시작 화면

### Step 4. 핵심 플로우 연결

- 퀘스트 생성/완료
- 소울 덱 전투
- 카드 보상
- 카드팩/컬렉션/상점/휴식

산출물:

- 테스터가 5~10분 안에 핵심 앱 경험을 눌러볼 수 있는 웹 링크

### Step 5. 피드백 수집

1차는 가장 단순하게 외부 Google Form 링크로 시작한다.  
이후 필요하면 Firestore feedback collection 또는 Notion 연동을 검토한다.

필수 수집 항목:

- 좋았던 점
- 헷갈린 점
- 보기 싫거나 촌스러운 화면
- 다시 쓰고 싶은지
- 모바일 기종/브라우저
- 스크린샷 첨부 여부

---

## 8. 성공 기준

1. `flutter build web`이 성공한다.
2. QA Preview URL로 외부 사용자가 설치 없이 접속할 수 있다.
3. 로그인 없이 30초 안에 핵심 화면에 진입할 수 있다.
4. 전투 손패/보상/카드팩/컬렉션/상점/휴식 화면을 클릭해볼 수 있다.
5. 피드백 제출 경로가 화면 안에 있다.
6. Android 정식 배포용 코드와 QA Preview용 mock 코드가 섞여 실제 출시 안정성을 해치지 않는다.

---

## 9. 현재 판단

즉시 Google Play 테스트 배포까지 기다리는 것보다, Web QA Preview를 먼저 만드는 것이 낫다.

이유:

- 현재 가장 큰 리스크는 서버 부하나 결제보다 UI/카피/게임 루프의 설득력이다.
- 이 리스크는 설치형 테스트보다 링크형 웹 QA에서 훨씬 빠르게 피드백을 받을 수 있다.
- 단, 웹판을 완전한 제품으로 만들려고 하면 범위가 커진다. 반드시 QA Preview로 제한해야 한다.

다음 착수 순서:

1. `flutter build web` 실제 실행
2. 실패 로그 기반 `docs/web-qa-preview-build-audit.md` 작성
3. 웹 차단점 최소 분기 패치
4. QA Preview Mode 설계 구현
5. 로컬 Chrome 또는 `build/web` 생성 확인
