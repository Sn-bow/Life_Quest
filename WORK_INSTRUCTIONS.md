# Life Quest 프로젝트 작업 지시서

## 현재 완료 상태 (2026-03-03 기준)

| Phase | 내용 | 상태 |
|-------|------|------|
| A | 치명적 버그 수정 8건 | 완료 |
| B | 높은 우선순위 수정 7건 | 완료 |
| C | 코드 품질 개선 10건 | 완료 |
| D | 테스트 확장 (7개 → 67개) | 완료 |
| E | 배포 준비 4건 | 코드 완료, 수동 작업 3건 남음 |

### 검증 결과
- `flutter analyze` → No issues found
- `flutter test` → 67개 전체 통과

---

## 사용자 수동 작업 (3건)

### 1. Android 릴리스 키스토어 생성 및 설정
```bash
# 키스토어 생성
keytool -genkey -v -keystore ~/life-quest-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias life-quest-key
```
생성 후 `android/key.properties` 파일 생성:
```properties
storePassword=입력한_비밀번호
keyPassword=입력한_비밀번호
keyAlias=life-quest-key
storeFile=키스토어_절대경로/life-quest-release.jks
```
참고: `android/key.properties.example` 템플릿 있음

### 2. iOS Firebase 설정
```bash
# 프로젝트 루트에서 실행
flutterfire configure
```
- Firebase 콘솔에서 iOS 앱 등록 필요 (Bundle ID: com.example.life_quest_final_v2)
- 실행 후 `lib/firebase_options.dart`에 iOS 옵션이 자동 생성됨

### 3. AdMob 프로덕션 ID 교체 (3곳)
AdMob 콘솔(https://admob.google.com)에서 앱 등록 후 ID 발급받아 교체:

| 파일 | 현재 값 (테스트 ID) | 교체 대상 |
|------|---------------------|-----------|
| `lib/services/ad_service.dart` 17행 | `ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY` | 보상형 광고 단위 ID |
| `android/app/src/main/AndroidManifest.xml` 40행 | `ca-app-pub-3940256099942544~3347511713` | Android 앱 ID |
| `ios/Runner/Info.plist` GADApplicationIdentifier | `ca-app-pub-3940256099942544~1458002511` | iOS 앱 ID |

---

## 다음 세션 작업 지시

위 수동 작업 완료 후 아래 내용을 Claude에게 전달:

```
수동 작업 완료 상태:
- [ ] 키스토어 생성 및 key.properties 설정 완료/미완료
- [ ] flutterfire configure 실행하여 iOS Firebase 설정 완료/미완료
- [ ] AdMob 프로덕션 ID 교체 완료/미완료

이어서 다음 작업 진행해줘:

1. 수동 작업 결과 검증
   - flutter analyze 실행하여 0 issues 확인
   - flutter test 실행하여 67개 전체 통과 확인
   - flutter build apk --release 빌드 성공 확인 (키스토어 설정 완료 시)

2. 앱 최종 점검
   - applicationId를 com.example.life_quest_final_v2에서 실제 패키지명으로 변경 (필요시)
   - 앱 이름(android:label, CFBundleDisplayName) 최종 확인
   - 버전 번호 설정 (pubspec.yaml의 version 필드)

3. 빌드 및 배포
   - Android: flutter build appbundle --release (Play Store용 AAB)
   - iOS: flutter build ios --release (flutterfire configure 완료 시)

4. (선택) 추가 개선 사항
   - 위젯 테스트 추가 (UI 테스트)
   - 통합 테스트 추가
   - CI/CD 파이프라인 설정
   - 앱 아이콘 및 스플래시 스크린 커스터마이징
```

---

## 수정된 주요 파일 목록 (Phase A~E)

### 모델
- `lib/models/character.dart` — fromJson null 안전성
- `lib/models/quest.dart` — fromJson null 안전성, enum 범위 검증
- `lib/models/item.dart` — fromJson 방어 코드
- `lib/models/achievement.dart` — fromJson 방어 코드

### 상태 관리
- `lib/state/character_state.dart` — 날짜비교, 스킬조회, maxXp, 업적저장, 이중로드방지, 성능최적화, 데이터 추출
- `lib/state/combat_state.dart` — 음수 데미지 수정

### 서비스
- `lib/services/sound_service.dart` — lazy 풀, init 분리, 테스트 지원
- `lib/services/ad_service.dart` — 일일 횟수 SharedPreferences 저장

### 화면
- `lib/main.dart` — 테마 null 가드, AppCheck try-catch, SoundService init
- `lib/screens/hunt_screen.dart` — 컴포넌트 분리
- `lib/screens/timer_screen.dart` — 백그라운드 타이머
- `lib/screens/status_screen.dart` — 터치 타겟 48x48
- `lib/screens/inventory_screen.dart` — 장비 저장
- `lib/screens/shop_screen.dart` — 비용 검증
- `lib/screens/quests_screen.dart` — 광고 실패 피드백

### 신규 파일
- `lib/widgets/combat/dungeon_floor_selector.dart`
- `lib/widgets/combat/combat_arena_view.dart`
- `lib/data/achievement_database.dart`
- `lib/data/title_database.dart`
- `lib/data/skill_database.dart`

### 테스트
- `test/models/character_test.dart` (9개)
- `test/models/quest_test.dart` (9개)
- `test/models/item_test.dart` (5개)
- `test/models/achievement_test.dart` (4개)
- `test/models/skill_test.dart` (1개)
- `test/state/character_state_test.dart` (16개)
- `test/state/combat_state_test.dart` (23개)

### 배포
- `android/app/build.gradle.kts` — 릴리스 서명 설정
- `android/key.properties.example` — 템플릿
- `ios/Runner/Info.plist` — ATT 권한, AdMob TODO
- `lib/firebase_options.dart` — iOS TODO
- `.gitignore` — key.properties, keystore 제외
- `pubspec.yaml` — 중복 assets 제거
