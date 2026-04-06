# Life Quest - 프로젝트 메모리

## 프로젝트 개요
- **앱 이름**: Life Quest - 일상을 RPG처럼 관리하는 라이프 게이미피케이션 앱
- **프레임워크**: Flutter (Dart)
- **백엔드**: Firebase (Auth, Firestore, Storage, App Check)
- **상태 관리**: Provider
- **GitHub**: https://github.com/Sn-bow/Life_Quest.git (branch: main)
- **applicationId**: `com.lifequest.app` (2026-04-01 변경, 이전: com.example.life_quest_final_v2)

## 현재 상태 (2026-04-06 기준)

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
- **Soul Deck 게임 시스템 전면 재설계 완료** (2026-04-06)
  - 기존 단순 턴제 전투 → Slay the Spire 스타일 덱빌딩 로그라이크로 교체
  - Flame 엔진 기반 전투 씬 + Flutter 오버레이 UI

### Soul Deck 구현 현황 (2026-04-06)
#### Phase 1 - 핵심 시스템 ✅
- **모델**: `card_data.dart`, `status_effect.dart`, `relic_data.dart`, `dungeon_map.dart`, `dungeon_event.dart`
- **데이터**: `card_database.dart` (207장: Common 40+Uncommon 32+Rare 20+Legendary 8+Starter 10+Curse 4+업그레이드), `relic_database.dart` (31개), `event_database.dart` (10개), `dungeon_generator.dart` (6행 노드맵)
- **상태**: `card_combat_state.dart` (에너지/핸드/덱/상태이상/데미지 전투 로직), `dungeon_state.dart` (런 관리, 노드 플로우, 저장/불러오기)
- **게임**: `battle_game.dart` (Flame), `damage_text.dart`
- **화면**: dungeon_home, dungeon_map, card_battle, dungeon_event, dungeon_shop, dungeon_rest, dungeon_result (7개)

#### Phase 2 - 전투 이펙트 ✅
- 카드 재생 애니메이션 (위로 올라가며 페이드), 카드 드로우 슬라이드인
- 적 히트 플래시 (빨간색), 방어도 실드 아이콘
- 턴 전환 오버레이 ("Your Turn"/"Enemy Turn"), 빅히트 스크린 쉐이크
- Flame 파티클 이펙트 (히트/힐/블록), 존별 배경 파랄랙스
- 상태이상 아이콘 컴포넌트 (11종), 결과 팝업 스케일 애니메이션

#### Phase 3 - 던전↔캐릭터 보상 연동 ✅
- `calculateRunRewards()`: 존/몬스터/노드 기반 XP+골드 계산 (승리 x1.5, 패배 x0.5)
- `character_state.addDungeonReward()`: 레벨업/칭호 체크 포함
- 전투 승리 → 카드 3장 선택 보상 UI
- 결과 화면: XP/골드 표시, 중복 적용 방지, 홈 복귀

#### Phase 4 - 카드 컬렉션 시스템 🔄 (진행 중)

### 검증 결과
- `flutter analyze` → No issues found (Phase 1 시점)
- `flutter test` → 67개 전체 통과 (Phase 1 시점)
- `flutter build appbundle --release` → 성공 (64MB, Phase 1 시점)
- **Phase 2~4 이후 재검증 필요**

## 주요 기능
- 퀘스트 시스템 (일간/주간/월간/연간)
- 캐릭터 성장 (레벨업, 스탯 분배: 힘/지혜/건강/매력, 칭호)
- **Soul Deck 던전** (덱빌딩 로그라이크, 5존, 보스, 어센션)
  - 카드 207장 (4카테고리×4등급), 렐릭 31개, 이벤트 10개
  - Flame 엔진 전투씬 + Flutter 오버레이 UI
  - 에너지 시스템, 상태이상 11종, 적 인텐트
- 카드 컬렉션 (퀘스트 완료 → 카드 획득, 덱 커스텀)
- 장비 & 인벤토리
- 상점 (골드로 장비 구매, 코스메틱)
- 스킬 트리
- 업적 시스템
- 성장 리포트
- 집중 타이머 (포모도로)
- 홈 위젯 (Android)
- 알림 (퀘스트 리마인더)
- 광고 & 인앱결제 (Google AdMob, IAP)

## 프로젝트 구조
```
lib/
├── main.dart
├── firebase_options.dart
├── models/          # character, quest, item, monster, skill, achievement, title, cosmetic, custom_reward
│                    # + card_data, status_effect, relic_data, dungeon_map, dungeon_event (신규)
├── screens/
│   ├── [기존]       # main, status, quests, hunt, inventory, shop, skill, achievement, report, timer, settings, login, signup, loading, cosmetic_shop
│   └── dungeon/     # dungeon_home, dungeon_map, card_battle, dungeon_event, dungeon_shop, dungeon_rest, dungeon_result, card_collection (신규)
├── state/           # character_state, combat_state
│                    # + card_combat_state, dungeon_state (신규)
├── services/        # sound, notification, ad, purchase
├── data/            # monster_database, achievement_database, skill_database, title_database, loot_table
│                    # + card_database, relic_database, event_database, dungeon_generator (신규)
├── game/            # battle_game.dart (신규 - Flame)
│   └── components/  # damage_text, particle_effect, status_icon (신규)
└── widgets/         # translucent_card, xp_bar, quest_tile, stat_bar, player_profile_sprite, combat/
```

## 버그 수정 현황 (2026-04-06 기준)

### CRITICAL (1-5) - 모두 수정 완료 ✅
- 소모 아이템 삭제 버그, 장비 중복 삭제, Firestore 역직렬화, CustomReward 캐스팅, Enum 직렬화 → 이미 이전 Phase에서 수정됨

### HIGH (6-11) - 모두 수정 완료 ✅
- Firebase 오프라인, 인증 라우트 가드, Android 13+ 알림, GDPR UMP → 이미 구현됨
- IAP 영수증 검증: TODO/WARNING 코멘트 추가 (서버 인프라 필요)
- Save/Load 레이스 컨디션: `_pendingSave` 플래그 메커니즘 추가

### MEDIUM (12-18) - 모두 수정 완료 ✅
- 전투로그 높이, 이름 길이 제한, 텍스트 overflow, NaN 방지 → 이미 구현됨
- 전투 버튼 연타 방지: `_isActionBusy` + 300ms 딜레이 추가
- 광고 시간 기반: TODO 코멘트 추가
- _saveData await: 3초 디바운스 확인 + 코멘트 추가

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
