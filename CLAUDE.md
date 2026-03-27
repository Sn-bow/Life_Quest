# Life Quest - 프로젝트 메모리

## 프로젝트 개요
- **앱 이름**: Life Quest - 일상을 RPG처럼 관리하는 라이프 게이미피케이션 앱
- **프레임워크**: Flutter (Dart)
- **백엔드**: Firebase (Auth, Firestore, Storage, App Check)
- **상태 관리**: Provider
- **GitHub**: https://github.com/Sn-bow/Life_Quest.git (branch: main)

## 현재 상태 (2026-03-28 기준)

### 완료된 작업
- Phase A: 치명적 버그 수정 8건 완료
- Phase B: 높은 우선순위 수정 7건 완료
- Phase C: 코드 품질 개선 10건 완료
- Phase D: 테스트 확장 (7개 → 67개) 완료
- Phase E: 배포 준비 4건 (코드 완료, 수동 작업 3건 남음)
- **아바타/캐릭터 커스터마이징 시스템 전면 제거** (2026-03-28)
  - player_avatar_view.dart 삭제
  - assets/avatar/ 하위 SVG, PNG 에셋 전부 삭제
  - character model에서 avatar 관련 필드 제거
  - signup_screen에서 캐릭터 생성 플로우 제거
  - status_screen에서 아바타 표시 제거
  - combat_arena_view에서 아바타 참조 제거
  - flutter_svg dependency 제거, avatar asset 경로 제거
  - 불필요한 docs/, scripts/ 폴더 전부 삭제
  - 참고: image_picker, firebase_storage는 프로필 사진 업로드용으로 signup_screen에서 사용 중 (유지)
  - 참고: firebase_app_check는 main.dart에서 사용 중 (유지)

### 검증 결과
- `flutter analyze` → No issues found
- `flutter test` → 67개 전체 통과

### 커밋 히스토리
```
1ce2265 refactor: remove avatar/character customization system and cleanup
064356a feat: add avatar system, character creation, and full game progression
be937da Initial project import and branding updates
```

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

## 남은 수동 작업 (사용자가 직접 수행)
1. **Android 릴리스 키스토어** 생성 및 `android/key.properties` 설정
2. **iOS Firebase 설정** (`flutterfire configure` 실행)
3. **AdMob 프로덕션 ID 교체** (ad_service.dart, AndroidManifest.xml, Info.plist)

## 다음 작업 후보
- 수동 작업 완료 후 빌드 검증 (flutter build apk --release)
- applicationId 실제 패키지명으로 변경
- 앱 이름/버전 번호 최종 설정
- 위젯 테스트, 통합 테스트 추가
- CI/CD 파이프라인 설정
- 앱 아이콘 및 스플래시 스크린 커스터마이징

## 주의사항
- 아바타/캐릭터 커스터마이징 기능은 의도적으로 제거됨 (다시 만들지 말 것)
- avatar_preview/ 폴더와 assets/avatar/parts_v2/ 는 로컬에만 남아있을 수 있음 (git에서 제거됨)
- image_picker, firebase_storage, firebase_app_check는 pubspec에 남아있음 (각각 프로필 사진, App Check에 사용 중)
- WORK_INSTRUCTIONS.md에 이전 Phase A~E 작업 상세 내역 및 수동 작업 안내 있음
