# Life Quest - 프로젝트 메모리

## 프로젝트 개요
- **앱 이름**: Life Quest - 일상을 RPG처럼 관리하는 라이프 게이미피케이션 앱
- **프레임워크**: Flutter (Dart)
- **백엔드**: Firebase (Auth, Firestore, Storage, App Check)
- **상태 관리**: Provider
- **GitHub**: https://github.com/Sn-bow/Life_Quest.git (branch: main)
- **applicationId**: `com.lifequest.app` (2026-04-01 변경, 이전: com.example.life_quest_final_v2)

## 현재 상태 (2026-04-01 기준)

### 완료된 작업
- Phase A~E: 버그 수정, 코드 품질, 테스트, 배포 준비 완료
- 아바타/캐릭터 커스터마이징 시스템 전면 제거 (2026-03-28)
- **Android 릴리스 빌드 설정 완료** (2026-04-01)
  - applicationId: `com.example.life_quest_final_v2` → `com.lifequest.app`
  - namespace, google-services.json, Kotlin 파일 패키지명 모두 변경
  - Kotlin 소스 `com/example/life_quest_final_v2/` → `com/lifequest/app/` 이동
  - compileSdk: 35 → 36 (플러그인 요구사항)
  - 릴리스 키스토어 생성 (`android/upload-keystore.jks`, alias: upload)
  - `android/key.properties` 설정 완료
  - AAB 빌드 성공 (`build/app/outputs/bundle/release/app-release.aab`, 64MB)
- **코드 품질 분석 완료** (2026-04-01) - 아래 "다음 작업" 섹션 참조

### 검증 결과
- `flutter analyze` → No issues found
- `flutter test` → 67개 전체 통과
- `flutter build appbundle --release` → 성공 (64MB)

## 주요 기능
- 퀘스트 시스템 (일간/주간/월간/연간)
- 캐릭터 성장 (레벨업, 스탯 분배: 힘/지혜/건강/매력, 칭호)
- 전투/사냥 (던전 탐험, 턴제 전투, 전리품)
- 장비 & 인벤토리
- 상점 (골드로 장비 구매, 코스메틱)
- 스킬 트리
- 업적 시스템
- 성장 리포트
- 집중 타이머 (포모도로)
- 홈 위젯 (iOS/Android)
- 알림 (퀘스트 리마인더)
- 광고 & 인앱결제 (Google AdMob, IAP)

## 프로젝트 구조
```
lib/
├── main.dart
├── firebase_options.dart
├── models/          # character, quest, item, monster, skill, achievement, title, cosmetic, custom_reward
├── screens/         # main, status, quests, hunt, inventory, shop, skill, achievement, report, timer, settings, login, signup, loading, cosmetic_shop
├── state/           # character_state (Provider), combat_state
├── services/        # sound, notification, ad, purchase
├── data/            # monster_database, achievement_database, skill_database, title_database, loot_table
└── widgets/         # translucent_card, xp_bar, quest_tile, stat_bar, player_profile_sprite, combat/
```

## 다음 작업: 코드 품질 수정 (우선순위별)

### CRITICAL (즉시 수정)
1. **소모 아이템 전체 삭제 버그** - `combat_state.dart:365`
   - `removeWhere`가 같은 ID 아이템 모두 삭제. `removeAt(indexWhere(...))`로 변경 필요
2. **장비 착용 시 중복 삭제** - `combat_state.dart:380-397`
   - 동일한 removeWhere 버그. `inventory.remove(item)` 사용 필요
3. **Firestore 역직렬화 타입 캐스트 누락** - `character.dart:116-124`
   - equippedWeapon/Armor/Accessory에 `as Map<String, dynamic>` 캐스팅 필요
4. **CustomReward 안전하지 않은 캐스팅** - `custom_reward.dart:25-29`
   - null 체크/기본값 없이 직접 캐스팅. null coalescing 추가 필요
5. **Enum 직렬화 불일치** - `item.dart:55-77`
   - toJson()은 `.name`, fromJson()은 `.toString()` 비교. 통일 필요

### HIGH (중요)
6. **Firebase 오프라인 지원 없음** - Firestore persistence 미설정
7. **IAP 서버사이드 영수증 검증 없음** - `purchase_service.dart:84-115`
8. **인증 상태 라우트 가드 없음** - `main_screen.dart:81-86`
9. **Android 13+ 알림 권한 미처리** - `notification_service.dart:18-48`
10. **GDPR 광고 동의 처리 없음** - `ad_service.dart`
11. **Save/Load 레이스 컨디션** - `character_state.dart:838-1025`

### MEDIUM (품질)
12. 전투 로그 높이 무제한 → 버튼 가림 - `hunt_screen.dart:271-294`
13. 퀘스트/캐릭터명 길이 제한 없음 - `quests_screen.dart`, `settings_screen.dart`
14. 전투 액션 버튼 연타 방지 없음 - `hunt_screen.dart:428-481`
15. quest_tile.dart에 maxLines/overflow 누락 - `quest_tile.dart:69-78`
16. 업적 진행률 targetValue=0 시 NaN - `achievement_screen.dart:68-70`
17. 광고 일일 횟수 초기화가 기기 시간 기반 - `ad_service.dart:96-103`
18. _saveData() 대부분 await 없이 호출 - `character_state.dart` 19곳

### 테스트 커버리지 현황
- Models: 5/9 테스트됨 (cosmetic, custom_reward, monster, title 미테스트)
- State: 2/2 양호
- **Services: 0/4 전부 미테스트** (ad, purchase, notification, sound)
- **Screens: 0/15 전부 미테스트**
- **Data: 0/5 전부 미테스트**

## 남은 수동 작업
1. **iOS Firebase 설정** (`flutterfire configure` 실행)
2. **AdMob 프로덕션 ID 교체** (ad_service.dart, AndroidManifest.xml, Info.plist)
3. **Firebase 콘솔에서 Android 앱 패키지명을 `com.lifequest.app`으로 업데이트**
4. **Google Play Console에 AAB 업로드** (파일: `build/app/outputs/bundle/release/app-release.aab`)

## 주의사항
- 아바타/캐릭터 커스터마이징 기능은 의도적으로 제거됨 (다시 만들지 말 것)
- image_picker, firebase_storage, firebase_app_check는 pubspec에 유지 (각각 프로필 사진, App Check용)
- 릴리스 키스토어(`upload-keystore.jks`)와 `key.properties`는 `.gitignore`에 포함 (git에 올라가지 않음)
- Dart 패키지명은 `life_quest_final_v2` 그대로 유지 (Android applicationId만 변경)
- WORK_INSTRUCTIONS.md에 이전 Phase A~E 작업 상세 내역 있음
