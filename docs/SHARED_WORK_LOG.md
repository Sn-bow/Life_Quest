# Life Quest 공유 작업 로그

목적: Claude와 Codex가 같은 작업 흐름을 이어받기 위한 단일 기록 문서  
규칙: 조사, 변경 파일, 검증 명령, 결과, 남은 위험을 매 작업마다 최신순으로 기록한다.

---

## 2026-05-17 KST - Codex - Today first tab pilot

### 착수 전 조사
- Threads 추가 피드백의 핵심을 "상태 체크/현실 행동이 앱 경험의 중심이어야 한다"로 재정리했다.
- `lib/screens/main_screen.dart`의 첫 탭이 기존 `StatusScreen`이고, `TodayAdventureSummary`는 퀘스트 탭 내부 보조 블록으로만 노출되는 것을 확인했다.
- `StatusScreen`의 XP/HP/골드/AP 요약, 타이머/리포트/설정 진입점을 확인했다.

### 변경 파일
- `lib/screens/today_screen.dart`
- `lib/screens/main_screen.dart`
- `docs/lifequest-remake-execution-checklist-20260516.md`
- `docs/SHARED_WORK_LOG.md`

### 실행한 변경
- 새 `TodayScreen`을 추가해 `오늘의 상태`, XP, HP, 골드, AP, 퀘스트 관리 CTA, 성장 체감 CTA, 상세 상태 진입을 한 화면에 묶었다.
- 하단 첫 탭을 기존 상태창에서 `오늘`로 교체했다.
- 기존 `StatusScreen`은 삭제하지 않고 `상세 상태 보기`로 이동하게 유지했다.

### 검증
- `dart format lib\screens\today_screen.dart lib\screens\main_screen.dart` 완료.
- `flutter analyze --no-pub` → No issues found.
- `flutter test --no-pub test\data\core_loop_rules_test.dart test\state\today_adventure_summary_state_test.dart test\state\dungeon_state_test.dart test\state\card_combat_state_daily_modifier_test.dart` → 12개 통과.
- `flutter test --no-pub` → 105개 전체 통과.
- `git diff --check -- lib/screens/main_screen.dart lib/screens/today_screen.dart docs/lifequest-remake-execution-checklist-20260516.md docs/SHARED_WORK_LOG.md` 통과.

### 남은 위험
- 모바일 폭에서 TodayScreen CTA 2개가 좁게 보일 수 있으므로 실기기/Web QA가 필요하다.

### 다음 작업
- 첫 화면 스크린샷 QA 후 칭호 -> 추천 행동/이벤트 조건 연결 작업으로 넘어간다.

---

## 2026-05-18 KST - Codex - Title unlock rules pilot

### 착수 전 조사
- `GameTitle`은 조건/보너스 필드만 있고, 던전 이벤트와 직접 연결되는 메타데이터는 없음을 확인했다.
- `DungeonEvent`/`EventChoice`는 정적 이벤트 DB 기반이라 기존 모델을 확장하지 않아도 런타임에서 선택지 합성이 가능함을 확인했다.
- `CoreLoopRules.recommendAction`은 오늘 부족한 스탯만 보며 다음 칭호 조건은 고려하지 않는 상태였다.

### 변경 파일
- `lib/data/title_unlock_rules.dart`
- `lib/data/core_loop_rules.dart`
- `lib/state/character_state.dart`
- `lib/screens/dungeon/dungeon_event_screen.dart`
- `lib/widgets/today_adventure_summary.dart`
- `test/data/core_loop_rules_test.dart`
- `test/data/title_unlock_rules_test.dart`
- `docs/lifequest-remake-execution-checklist-20260516.md`
- `docs/SHARED_WORK_LOG.md`

### 실행한 변경
- `TitleUnlockRules`를 추가해 칭호 ID별 이벤트 선택지와 해금 설명을 별도 규칙으로 관리하게 했다.
- 던전 이벤트 화면에서 플레이어가 해금한 칭호에 맞는 추가 선택지를 기존 선택지 뒤에 표시한다.
- 다음 칭호가 요구하는 스탯과 맞는 미완료 퀘스트가 있으면 오늘 추천 행동이 그 퀘스트를 우선 추천한다.
- 오늘 상태의 다음 칭호 진행도 아래에 이벤트 선택지 해금 미리보기를 표시한다.

### 검증
- `dart format lib\data\title_unlock_rules.dart lib\screens\dungeon\dungeon_event_screen.dart lib\widgets\today_adventure_summary.dart test\data\title_unlock_rules_test.dart`
- `dart format lib\data\core_loop_rules.dart lib\state\character_state.dart test\data\core_loop_rules_test.dart`
- `flutter analyze --no-pub` → No issues found.
- `flutter test --no-pub test\data\core_loop_rules_test.dart test\data\title_unlock_rules_test.dart test\state\today_adventure_summary_state_test.dart` → 10개 통과.
- `flutter test --no-pub` → 109개 전체 통과.

### 남은 위험
- 실제 던전 이벤트 노드에서 칭호 선택지가 보이는지 화면 QA가 필요하다.
- 현재 1차 연결 칭호는 5개라 출시 범위의 10~20개 선정은 아직 미완료다.

### 다음 작업
- 전체 테스트 통과 후 커밋/푸시한다.
- 이후 Phase 3의 남은 UI 보정 출처 설명 또는 Phase 5 오늘 홈 디자인 QA로 넘어간다.

---

## 2026-05-18 KST - Codex - Dungeon modifier source card

### 착수 전 조사
- `DungeonHomeScreen`은 `charState.todayDailyModifier`를 던전 시작 시 `DungeonState.startRun`으로 넘기고 있었다.
- 하지만 던전 홈 UI에는 오늘 어떤 현실 퀘스트 때문에 보정이 생겼는지 설명하는 카드가 없었다.

### 변경 파일
- `lib/screens/dungeon/dungeon_home_screen.dart`
- `docs/lifequest-remake-execution-checklist-20260516.md`
- `docs/SHARED_WORK_LOG.md`

### 실행한 변경
- 던전 홈의 플레이어 정보 카드 아래에 `오늘 현실 행동 보정` 카드를 추가했다.
- 오늘 완료한 퀘스트 이름을 출처로 표시하고, 적용될 보정 라벨을 칩으로 표시한다.
- 보정이 없을 때는 현실 퀘스트 완료 후 보정이 열린다는 empty state를 보여준다.

### 검증
- `dart format lib\screens\dungeon\dungeon_home_screen.dart`
- `flutter analyze --no-pub` → No issues found.
- `flutter test --no-pub` → 109개 전체 통과.

### 남은 위험
- 실제 390px 모바일 폭에서 보정 칩 줄바꿈과 출처 텍스트 가독성 QA가 필요하다.

### 다음 작업
- 전체 테스트 통과 후 커밋/푸시한다.
- 이후 Phase 5 오늘 홈 디자인 QA 또는 Phase 3 카드 보상 확률/이벤트 선택지 보정 적용으로 넘어간다.

---

## 기록 템플릿

```markdown
## YYYY-MM-DD HH:mm KST - 작업자
### 착수 전 조사
- 

### 변경 파일
- 

### 실행한 검증
- 

### 결과
- 

### 남은 위험
- 

### 다음 작업
- 
```

---

## 2026-05-04 KST - Codex

### 착수 전 조사

- `AGENTS.md`, `README.md`, `RELEASE_CHECKLIST.md`, `pubspec.yaml`, `docs/`를 확인했다.
- `repo-scan` 기준으로 프로젝트 구조, Flutter/Flame 스택, 테스트/분석 명령을 확인했다.
- `official-research` 기준으로 Slay the Spire 2 공식 자료를 확인했다.
  - Mega Crit 공식 뉴스: 2026-02-19 릴리스 날짜 트레일러
  - Steam 공식 페이지: 2026-05-04 확인 기준
- `assets/images/monsters/`, `assets/images/backgrounds/`, `assets/images/cards/`, `assets/images/player/`, `assets/images/game/*`, `assets/sounds/*`를 조사했다.
- `rg`로 `CustomPainter`, `Canvas.draw*` 사용 위치를 확인했다.

### 변경 파일

- `docs/2026-05-04-release-upgrade-plan.md`
- `docs/2026-05-04-soul-deck-game-plan.md`
- `docs/2026-05-04-current-app-state.md`
- `docs/AI_WORK_RULES.md`
- `docs/game-asset-inventory.md`
- `docs/SHARED_WORK_LOG.md`

### 실행한 검증

- 문서 작성 단계라 코드 검증은 수행하지 않았다.

### 결과

- 정식 배포 업그레이드 계획서 1을 콘텐츠/디자인/기능/QA 기준으로 작성했다.
- Soul Deck 게임 기능 계획서 2를 Slay the Spire 2 공식 자료 조사 기반으로 작성했다.
- 현재 앱 상태, AI 작업 규칙, 공유 작업 로그 문서를 추가했다.
- 핵심 규칙을 문서화했다: 게임 최종 비주얼에서 단순 도형 기반 임의 제작 금지, 기존/생성 에셋 우선 사용, 작업 전 조사 필수.

### 남은 위험

- 일부 기존 문서가 콘솔 출력에서 인코딩이 깨져 보인다. UTF-8 기준 재저장 또는 에디터 확인이 필요하다.
- 코드 변경 전이므로 실제 앱 상태는 추가 검증이 필요하다.

### 다음 작업

- 게임 에셋 인벤토리를 정리하고, 몬스터/플레이어/전투 이펙트를 실제 PNG 기반으로 전환한다.

---

## 2026-05-04 KST - Codex

### 착수 전 조사

- `MonsterDatabase`의 모든 기본 몬스터/보스가 `spritePath`를 가지고 있음을 확인했다.
- `assets/images/monsters/`에 해당 PNG가 실제 존재하는지 확인했다.
- `lib/widgets/combat/monster_battle_sprite.dart`가 `CustomPainter` 기반 도형 렌더링을 사용하고 있음을 확인했다.

### 변경 파일

- `lib/widgets/combat/monster_battle_sprite.dart`
- `test/data/monster_assets_test.dart`
- `docs/game-asset-inventory.md`
- `docs/SHARED_WORK_LOG.md`

### 실행한 검증

- `dart format lib\widgets\combat\monster_battle_sprite.dart test\data\monster_assets_test.dart`
  - 파일 포맷은 완료됐으나 Dart telemetry 파일 권한 문제로 종료 코드는 실패 처리됐다.
- `flutter_tools.dart test test\data\monster_assets_test.dart`
  - 통과
- `flutter_tools.dart analyze`
  - 통과, No issues found

### 결과

- 몬스터 전투 렌더링을 `CustomPainter` 도형에서 `Image.asset(monster.spritePath)` 기반으로 교체했다.
- 모든 몬스터 spritePath가 실제 PNG 파일을 가리키는지 테스트를 추가했다.

### 남은 위험

- 몬스터 PNG의 아트 품질/크기/투명 여백은 아직 육안 QA가 필요하다.

### 다음 작업

- 플레이어 전투/프로필 렌더링을 실제 이미지 기반으로 교체한다.

---

## 2026-05-04 KST - Codex

### 착수 전 조사

- `assets/images/player/hero_idle.png` 존재를 확인했다.
- `view_image`로 실제 이미지 상태를 확인했다.
- `PlayerBattleSprite` 사용 위치는 `lib/widgets/combat/combat_arena_view.dart`, `PlayerProfileSprite` 사용 위치는 `lib/screens/dungeon/card_battle_screen.dart`임을 확인했다.
- 프로젝트 주의사항에 따라 제거된 아바타/캐릭터 커스터마이징 기능을 되살리지 않는 방향으로 결정했다.

### 변경 파일

- `lib/widgets/combat/player_battle_sprite.dart`
- `lib/widgets/player_profile_sprite.dart`
- `test/data/player_assets_test.dart`
- `docs/game-asset-inventory.md`
- `docs/SHARED_WORK_LOG.md`

### 실행한 검증

- `dart format lib\widgets\combat\player_battle_sprite.dart test\data\player_assets_test.dart`
  - 파일 포맷은 완료됐으나 Dart telemetry 파일 권한 문제로 종료 코드는 실패 처리됐다.
- `dart format lib\widgets\player_profile_sprite.dart`
  - 파일 포맷은 완료됐으나 Dart telemetry 파일 권한 문제로 종료 코드는 실패 처리됐다.
- `flutter_tools.dart test test\data\monster_assets_test.dart test\data\player_assets_test.dart`
  - 통과
- `flutter_tools.dart analyze`
  - 통과, No issues found

### 결과

- 플레이어 전투 스프라이트와 프로필 스프라이트를 `assets/images/player/hero_idle.png` 기반으로 교체했다.
- 기존 생성자 파라미터는 호환을 위해 유지했지만, 커스터마이징 기능은 재도입하지 않았다.
- 플레이어 idle PNG 존재 테스트를 추가했다.

### 남은 위험

- 플레이어는 현재 idle PNG 하나만 사용한다. 공격/방어/시전/피격/승리 상태별 에셋이 필요하다.

### 다음 작업

- 전투 핵심 이펙트 공격/방어/마법/처치를 PNG 기반으로 교체한다.

---

## 2026-05-04 KST - Codex

### 착수 전 조사

- `lib/game/battle_game.dart`의 기존 공격/방어/마법/처치 이펙트가 Canvas 기반 단순 도형 컴포넌트임을 확인했다.
- Flame 1.35.1의 `Sprite.render`가 `overridePaint`를 지원하는지 SDK pub cache에서 직접 확인했다.
- `assets/images/game/effects/`가 비어 있어 새 raster PNG 에셋이 필요함을 확인했다.

### 변경 파일

- `lib/game/battle_game.dart`
- `tools/generate_battle_effect_assets.ps1`
- `assets/images/game/effects/effect_attack_slash.png`
- `assets/images/game/effects/effect_defense_shield.png`
- `assets/images/game/effects/effect_magic_projectile.png`
- `assets/images/game/effects/effect_enemy_death_burst.png`
- `test/data/battle_effect_assets_test.dart`
- `docs/game-asset-inventory.md`
- `docs/SHARED_WORK_LOG.md`

### 실행한 검증

- `tools/generate_battle_effect_assets.ps1`
  - 4개 PNG 생성 완료
- `dart format lib\game\battle_game.dart ...`
  - 파일 포맷은 완료됐으나 Dart telemetry 파일 권한 문제로 종료 코드는 실패 처리됐다.
- `flutter_tools.dart analyze`
  - 1차 실패: `Vector2.lerp` 미지원
  - 수정 후 재실행 통과, No issues found
- `flutter_tools.dart test test\data\monster_assets_test.dart test\data\player_assets_test.dart test\data\battle_effect_assets_test.dart`
  - 통과, 3개 테스트 전체 통과
- `rg -n "CustomPainter|drawLine|drawCircle|drawRect|drawPath|Canvas" ...`
  - 남은 위치: `battle_game.dart`의 보조 sprite render/배경 파티클/ShieldFlash, `dungeon_map_screen.dart`의 맵 연결선

### 결과

- 전투 핵심 이펙트 4종을 단순 도형 클래스에서 PNG sprite 기반 렌더링으로 교체했다.
- 공격, 방어, 마법 투사체, 적 처치 이펙트가 `Flame.images.load`와 `Sprite.render`를 사용한다.
- 새 이펙트 PNG 파일 존재/비어있지 않음 테스트를 추가했다.

### 남은 위험

- 현재 이펙트는 단일 PNG 기반이다. 정식 아트 품질을 더 끌어올리려면 frame sprite sheet와 SFX 타이밍이 필요하다.
- `battle_game.dart`에는 배경 보조 원형 파티클과 블록 보조 링이 남아 있다. 핵심 캐릭터/몬스터/전투 주효과는 아니지만 추후 에셋화 대상이다.
- `dungeon_map_screen.dart`의 연결선은 아직 `CustomPainter`다. 지도 전체 고도화 단계에서 이미지 기반으로 교체해야 한다.
- `flutter_tools.dart` 실행 중 pub.dev advisory decode 경고가 반복된다. 검증 결과 자체는 통과했지만 툴체인 점검 항목으로 남긴다.
- `dart format`은 실제 포맷을 완료하지만 AppData telemetry 파일 권한 문제로 종료 코드가 실패 처리된다.

### 다음 작업

- 카드 공통 UI를 조사하고 `assets/images/cards/card_frame_*.png` 기반 `SoulDeckCardView` 통합 작업을 진행한다.
- 이후 실제 화면 스크린샷 QA로 전투 장면의 배치/겹침/비주얼 품질을 확인한다.

---

## 2026-05-04 KST - Codex

### 착수 전 조사

- Game Studio `game-ui-frontend` 지침을 확인해 게임 UI는 플레이필드를 보호하고, 카드처럼 텍스트가 많은 UI는 명확한 계층과 에셋 기반 표면을 우선해야 함을 확인했다.
- `assets/images/cards/card_frame_attack.png`, `card_frame_defense.png`, `card_frame_magic.png`, `card_frame_tactical.png` 존재를 확인했다.
- `assets/images/game/cards/icons/icon_attack.png`, `icon_defense.png`, `icon_magic.png`, `icon_tactical.png` 존재를 확인했다.
- `card_battle_screen.dart`, `card_pack_screen.dart`, `card_collection_screen.dart`, `dungeon_shop_screen.dart`, `dungeon_rest_screen.dart`의 카드 UI 구현 위치를 조사했다.
- 카드 전투 손패는 이미 프레임 PNG를 일부 사용하고 있었고, 카드 팩 화면은 단순 컨테이너형 카드 타일을 사용하고 있음을 확인했다.

### 변경 파일

- `lib/widgets/soul_deck_card_view.dart`
- `lib/screens/dungeon/card_pack_screen.dart`
- `test/data/card_frame_assets_test.dart`
- `docs/game-asset-inventory.md`
- `docs/SHARED_WORK_LOG.md`

### 실행한 검증

- `dart format lib\widgets\soul_deck_card_view.dart lib\screens\dungeon\card_pack_screen.dart lib\screens\dungeon\card_battle_screen.dart test\data\card_frame_assets_test.dart`
  - 파일 포맷은 완료됐으나 Dart telemetry 파일 권한 문제로 종료 코드는 실패 처리됐다.
- `flutter_tools.dart analyze`
  - 1차: `card_battle_screen.dart` unused import 및 기존 one-line if lint 3건 감지
  - 정리 후 재실행 통과, No issues found
- `flutter_tools.dart test test\data\monster_assets_test.dart test\data\player_assets_test.dart test\data\battle_effect_assets_test.dart test\data\card_frame_assets_test.dart`
  - 통과, 4개 테스트 전체 통과

### 결과

- `SoulDeckCardView` 공통 위젯을 추가해 카드 프레임 PNG와 카드 카테고리 아이콘 PNG를 한 곳에서 매핑하도록 했다.
- 카드 팩 선택 카드 `_CardTile`을 공통 카드 위젯 기반으로 교체했다.
- 카드 프레임/아이콘 파일 누락을 막는 테스트를 추가했다.
- `card_battle_screen.dart` 포맷 과정에서 노출된 기존 one-line if lint를 블록 형태로 정리했다.

### 남은 위험

- 카드 전투 손패, 전투 보상, 컬렉션, 상점, 휴식 업그레이드는 아직 모두 공통 `SoulDeckCardView`로 통합된 상태가 아니다.
- `card_pack_screen.dart`의 `_CardTile` 생성자에는 이전 레이아웃에서 쓰던 필드가 호환 목적으로 남아 있다. 다음 통합 단계에서 호출부와 함께 정리해야 한다.
- 실제 화면 캡처 QA는 아직 수행하지 않았다.

### 다음 작업

- `SoulDeckCardView`를 카드 전투 손패와 전투 보상 선택부터 확장한다.
- 이후 카드 컬렉션/상점/휴식 업그레이드 화면을 같은 컴포넌트로 합친다.

---

## 2026-05-04 KST - Claude

### 착수 전 조사

- `lib/widgets/soul_deck_card_view.dart` 전체 구조 확인: `SoulDeckCardSize.hand/reward` 2종, `_CostGem` 고정 크기로 구현됨.
- `lib/screens/dungeon/card_battle_screen.dart` 조사: `_HandCard`(손패용 Container+도형 카드), `_CardRewardChoice`(보상 선택 Container+이모지) 두 클래스가 별도 구현되어 있음.
- `lib/screens/dungeon/card_collection_screen.dart` 조사: `_cardGridItem`이 60줄짜리 Container+색상 테두리 방식으로 구현됨.
- `lib/screens/dungeon/dungeon_rest_screen.dart` 조사: `_UpgradeCardWidget`이 130줄짜리 Container+헤더바 방식으로 구현됨.
- `lib/screens/dungeon/dungeon_shop_screen.dart` 조사: `_MiniCardWidget`이 80줄짜리 Container+Column 방식으로 구현됨, `_CardShopItem`에서 비용 뱃지(28px 원형 Container) 별도 사용.
- `rg`로 카드 렌더링 방식 전수 조사 완료. 총 5개 파일에서 통합 대상 클래스 확인.
- Slay the Spire 2 공식 자료 조사: 카드 타입 식별을 프레임 하단 모양으로 구분(공격=사다리꼴, 스킬=직사각형, 파워=타원), 희귀도는 배너 색상으로 구분(일반=회색, 비범=파랑, 희귀=금).

### 변경 파일

- `lib/widgets/soul_deck_card_view.dart` — `mini` SoulDeckCardSize 추가 (72×108px, 아이콘 28px, 이름 8.5pt, 설명 7.5pt/3줄), `_CostGem`에 `dimension`/`fontSize` 파라미터 추가.
- `lib/screens/dungeon/card_battle_screen.dart` — `_HandCard` 클래스 삭제, `_CardRewardChoice` 클래스 삭제; 각각 `SoulDeckCardView.hand` / `SoulDeckCardView.reward`로 교체. 불필요 import(`card_localization.dart`) 제거.
- `lib/screens/dungeon/card_collection_screen.dart` — `_cardGridItem` 60줄 Container 구현 → `FittedBox + SoulDeckCardView.hand` 4줄로 교체.
- `lib/screens/dungeon/dungeon_rest_screen.dart` — `_UpgradeCardWidget.build` 130줄 Container 구현 → `FittedBox + SoulDeckCardView.reward` 8줄로 교체.
- `lib/screens/dungeon/dungeon_shop_screen.dart` — `_MiniCardWidget.build` 80줄 Container 구현 → `FittedBox + SoulDeckCardView.mini` 8줄로 교체. `_CardShopItem` 선두 위젯(비용 뱃지 Container) → `SizedBox(72×108) + SoulDeckCardView.mini`로 교체.
- `docs/2026-05-04-sts2-research.md` — Slay the Spire 2 심층 조사 문서 신규 작성.
- `docs/2026-05-04-game-redesign-master-plan.md` — 게임 비주얼 전면 재설계 마스터 플랜 신규 작성.
- `docs/game-asset-inventory.md` — 카드 프레임 섹션 3 업데이트, 섹션 5 다음 작업 업데이트.
- `docs/SHARED_WORK_LOG.md` — 본 항목 추가.

### 실행한 검증

- `flutter analyze` → `No issues found!` (분석 오류 0건)
- `flutter test test/data/card_frame_assets_test.dart test/data/monster_assets_test.dart test/data/player_assets_test.dart test/data/battle_effect_assets_test.dart` → `+4: All tests passed!`

### 결과

- 카드 렌더링 구현체가 기존 5개(`_HandCard`, `_CardRewardChoice`, `_cardGridItem`, `_UpgradeCardWidget`, `_MiniCardWidget`)에서 `SoulDeckCardView` 단일 컴포넌트로 통합됐다.
- `SoulDeckCardSize.mini` 신규 추가로 상점 Row 레이아웃에서 소형 카드 미리보기가 가능해졌다.
- 전투 손패·보상·컬렉션 그리드·상점·휴식 업그레이드 — 카드가 등장하는 모든 화면이 동일한 PNG 프레임 기반 비주얼을 사용한다.
- 총 약 460줄의 중복 Container 기반 카드 UI 코드를 제거했다.
- `lint 0건, 테스트 4개 전부 통과` 검증 완료.

### 남은 위험

- **실기기 스크린샷 QA 미수행**: tactical 카드 프레임의 내부 반투명 overlay가 예상대로 렌더링되는지, FittedBox 스케일이 각 GridView 셀에서 잘리지 않는지 기기에서 확인 필요.
- **카드 삽화 부재**: 현재 카드는 카테고리 아이콘 PNG만 표시하며 STS2 스타일의 개별 카드 삽화가 없다. Codex 생성 방향으로 진행 예정.
- **STS2 프레임 하단 모양 미분화**: 현재 4종 프레임(공격/방어/마법/전술) PNG는 하단 모양 차별화가 없다. STS2 디자인 언어 기준으로 프레임 재생성 필요.
- **mini 사이즈 가독성**: 72×108px에서 8.5pt 이름/7.5pt 설명이 실제 기기에서 충분히 읽히는지 시각적 확인 필요.

### 다음 작업

1. APK 빌드 후 SM A530N 실기기 설치 → 카드 UI 전 화면 스크린샷 QA
2. Codex에 STS2 타입별 프레임 하단 모양이 적용된 카드 프레임 4종 생성 의뢰
3. 카드 개별 삽화 생성 전략 확정 (Codex 생성 또는 외부 에셋)
4. GitHub 커밋·푸시

---

## 2026-05-05 KST - Claude

### 착수 전 조사

- `git status` / `git log -1` / `git show --stat 656e2d9` — 커밋 정상, 워킹트리 clean 확인.
- `docs/SHARED_WORK_LOG.md`, `docs/game-asset-inventory.md`, `docs/AI_WORK_RULES.md` 전체 정독.
- `SoulDeckCardView` 사용 위치 `rg` 전수 조사: 6개 파일 확인.
- 각 QA 대상 화면의 GridView `crossAxisCount`, `childAspectRatio`, FittedBox 스케일 계산:
  - 컬렉션 그리드(3열, 0.75): hand 카드 110×154 → 약 1.01× 스케일. 정상.
  - 휴식 업그레이드 그리드(2열, 0.72): reward 카드 94×142 → 약 1.67× 스케일 업. 고해상도 PNG라 품질 이상 없음.
  - 상점 Row: SizedBox(72×108) + mini 카드 72×108 — 정확히 일치.
  - 상점 제거 그리드(3열, 0.75): mini 72×108 → 약 1.44× 스케일 업.
  - 전투 손패: SizedBox(height: 160) + hand 카드 154px — 6px 여백, 문제 없음.
  - 전투 보상 Row: SizedBox(height: 152) + reward 카드 142px — 10px 여백, 문제 없음.
- 카드 프레임/아이콘 PNG alpha 채널 확인: `card_frame_*.png` 4종 + `icon_*.png` 4종 모두 colorType=6 (RGBA). 투명 배경 정상.
- `card_pack_screen.dart` `_CardTile` 확인: `AnimatedContainer(width: 100)` 와 `SoulDeckCardView.reward(94px)` 간 6px 불일치 → 선택 테두리가 카드 프레임 밖에 그려지는 시각적 버그 확인.
- ADB 기기 확인: SM A530N (520034bafe9225db) 연결됨.
- APK 빌드 → 설치 → 앱 실행 시도: 스플래시("헌터 정보를 동기화하는 중") 까지 도달. 이후 PIN 잠금 화면에 막혀 던전 화면 직접 QA 불가.

### QA 대상

| 화면 | QA 방법 | 결과 |
|---|---|---|
| 카드팩 화면 | 코드 레벨 | 버그 1건 발견·수정 |
| 컬렉션 그리드 | 코드 레벨 | 이상 없음 |
| 상점 카드 Row | 코드 레벨 | 이상 없음 |
| 상점 제거 그리드 | 코드 레벨 | 이상 없음 |
| 휴식 업그레이드 그리드 | 코드 레벨 | 스케일 업 크지만 허용 범위 |
| 전투 손패 | 코드 레벨 | 이상 없음 |
| 전투 보상 선택 | 코드 레벨 | 이상 없음 |
| 전 화면 실기기 스크린샷 | ADB | **불가** — 기기 PIN 잠금 |

### 변경 파일

- `lib/screens/dungeon/card_pack_screen.dart`
  - `AnimatedContainer(width: 100)` → `width: 94` (SoulDeckCardSize.reward 폭과 일치)
  - `borderRadius: BorderRadius.circular(12)` → `circular(8)` (카드 ClipRRect radius 일치)
  - `_CardTile` 사용하지 않는 생성자 파라미터 6개 제거 (`isDark`, `isSelected`, `rarityColor`, `rarityBorder`, `rarityLabel`, `categoryIcon`)
  - `_rarityLabel`, `_categoryIcon` 미사용 헬퍼 메서드 제거
  - 호출부 단순화: `_CardTile(card: card)`
- `docs/SHARED_WORK_LOG.md` — 본 항목 추가
- `docs/game-asset-inventory.md` — QA 결과 반영 갱신

### 실행한 검증

- `flutter analyze` → `No issues found!` (수정 전·후 각 1회)
- `flutter test test/data/card_frame_assets_test.dart test/data/monster_assets_test.dart test/data/player_assets_test.dart test/data/battle_effect_assets_test.dart` → `+4: All tests passed!`
- `flutter build apk --debug` → 성공
- `adb install` → 설치 성공
- `adb shell monkey` → 앱 실행, 스플래시 확인
- 기기 PIN 잠금으로 던전 화면 진입 불가 — 화면 스크린샷: `docs/qa_screenshots/` 저장

### 결과

- `card_pack_screen.dart` 선택 테두리 정렬 버그 수정: 선택 글로우/테두리가 카드 프레임에 정확히 맞게 됨.
- `_CardTile` dead code 제거: 6개 미사용 파라미터 + 2개 미사용 메서드 정리.
- 코드 레벨 QA에서 PNG alpha 채널 전수 확인: 프레임·아이콘 모두 투명 배경 — 흰 박스 문제 없음.
- 6개 QA 대상 레이아웃 전부 overflow/clipping 위험 없음.
- `flutter analyze 0건, +4 tests passed` 유지.

### 남은 위험

- **실기기 던전 화면 QA 미완료**: 기기 PIN으로 내부 진입 불가. 사용자가 직접 던전 → 각 화면을 열어 시각적으로 확인해야 한다.
- **휴식 업그레이드 그리드 스케일 업**: reward 카드 1.67× 확대. PNG 해상도는 충분하지만 실기기에서 너무 크게 보이면 `childAspectRatio` 조정 필요.
- **미니 카드 가독성**: 72px 너비에서 8.5pt/7.5pt — 상점 Row에서 오른쪽 텍스트가 보완하지만 직접 확인 필요.
- **STS2 프레임 하단 모양 미분화**: 4종 프레임 하단이 동일. Codex 재생성 필요.
- **카드 삽화 부재**: 카테고리 아이콘만 표시, 개별 삽화 없음.

### 다음 작업

1. **사용자 직접 QA**: 기기 잠금 해제 후 던전 진입 → 카드팩/전투/컬렉션/상점/휴식 화면 시각 확인
2. Codex에 STS2 타입별 하단 모양 카드 프레임 4종 재생성 의뢰
3. 카드 개별 삽화 전략 확정

---

## 2026-05-05 KST (2차) - Claude

### 착수 전 조사

- 이전 세션 토큰 소진으로 중단된 지점 파악: `qa_reward_close.png` / `qa_victory.png` 스크린샷에서 3번째 보상 카드("생명의")에 Flutter debug 오버플로우 줄무늬(노란/검은 사선) 확인.
- `lib/widgets/soul_deck_card_view.dart` Column 레이아웃 분석:
  - reward 카드 내부 가용 높이 = 142 - 10(패딩) = 132px; 고정 높이 합계(이름 20+gap 3+아이콘 38+gap 3) = 64px; 나머지 68px은 `Expanded`(설명)+희귀도 레이블. 수직 오버플로우 아님.
- `lib/screens/dungeon/card_battle_screen.dart` `_VictoryRewardOverlay` 레이아웃 분석:
  - Container `width: 320`, `padding: EdgeInsets.all(20)` → 내부 Row 가용 폭 = 320 - 40 = **280px**.
  - 보상 카드 3장 × 94px = **282px** → **2px 수평 오버플로우** 발생. 원인 확정.
- 나머지 화면 레이아웃 코드 레벨 재검증:
  - 컬렉션 그리드(3열 0.75): `FittedBox.contain + hand` — 안전.
  - 휴식 그리드(2열 0.72): `FittedBox.contain + reward` (비율 0.662 < 0.72) — FittedBox 축소. 안전.
  - 상점 Row: `SizedBox(72×108) + mini` — 정확히 일치. 안전.

### 변경 파일

- `lib/screens/dungeon/card_battle_screen.dart`
  - `_VictoryRewardOverlay` Container `width: 320` → `width: 330` (내부 Row 가용 폭 280 → 290px, 3카드 282px에 여유 8px 확보)

### 실행한 검증

- `flutter analyze --no-pub` → `No issues found!` (61.9s)
- `flutter build apk --debug` → `√ Built build\app\outputs\flutter-apk\app-debug.apk` (31.8s)
- `adb uninstall + adb install` → `Success`
- `adb shell monkey` → 앱 실행, 로그인 화면 도달 확인 (`docs/qa_screenshots/qa_after_install.png`)

### 결과

- 전투 승리 보상 오버레이의 수평 오버플로우 버그 수정. 3장 카드(282px)가 290px 공간에 여유 있게 표시됨.
- `flutter analyze 0건` 유지.
- 전 화면 코드 레벨 레이아웃 검증 완료 — 컬렉션/휴식/상점 3개 화면 추가 이상 없음.

### 남은 위험

- **실기기 던전 화면 QA 미완료**: 디버그 APK 재설치로 로그인 세션 초기화됨. 재로그인 후 사용자가 직접 확인 필요.
- **휴식 업그레이드 그리드 스케일 업**: reward 카드 1.67× 확대. 실기기에서 너무 크게 보이면 `childAspectRatio` 조정 필요.
- **미니 카드 가독성**: 72px 너비에서 8.5pt/7.5pt 텍스트 — 실기기 확인 필요.
- **STS2 프레임 하단 모양 미분화**: 4종 프레임 하단이 동일. Codex 재생성 필요.
- **카드 삽화 부재**: 카테고리 아이콘만 표시, 개별 삽화 없음.

### 다음 작업

1. **사용자 직접 QA**: 앱 로그인 후 던전 진입 → 전투 승리 보상/카드팩/컬렉션/상점/휴식 화면 오버플로우 없음 최종 확인
2. Codex에 STS2 타입별 하단 모양 카드 프레임 4종 재생성 의뢰
3. 카드 개별 삽화 전략 확정

---

## 2026-05-05 KST - Codex

### 착수 전 조사

- `docs/AI_WORK_RULES.md`, `docs/SHARED_WORK_LOG.md`, `docs/game-asset-inventory.md`를 확인했다.
- imagegen skill을 확인했다. 라이브 image2 생성은 `OPENAI_API_KEY`가 필요하고, 기본 모델은 `gpt-image-1.5`임을 확인했다.
- 현재 환경 변수 확인 결과 `OPENAI_API_KEY`가 설정되어 있지 않았다.
- `CardData` 모델에 이미 `spritePath` 필드가 있으므로 새 모델 필드 추가 없이 카드 삽화 경로를 연결할 수 있음을 확인했다.
- `CardDatabase`에서 샘플 11장 후보를 확인했다:
  - starter 3장: `base_strike`, `base_defend`, `base_focus`
  - attack common 2장: `atk_c01`, `atk_c02`
  - defense common 2장: `def_c01`, `def_c02`
  - magic common 2장: `mag_c01`, `mag_c02`
  - tactical common 2장: `tac_c01`, `tac_c02`
- `SoulDeckCardView`가 현재 중앙 영역에 카테고리 아이콘만 표시하고 있음을 확인했다.

### 변경 파일

- `docs/card-art-generation-plan.md`
- `lib/data/card_art_assets.dart`
- `lib/widgets/soul_deck_card_view.dart`
- `assets/images/game/cards/art/.gitkeep`
- `test/data/card_art_assets_test.dart`
- `pubspec.yaml`
- `docs/game-asset-inventory.md`
- `docs/SHARED_WORK_LOG.md`

### 실행한 검증

- `dart format lib\data\card_art_assets.dart lib\widgets\soul_deck_card_view.dart test\data\card_art_assets_test.dart`
  - 파일 포맷은 완료됐으나 Dart telemetry 파일 권한 문제로 종료 코드는 실패 처리됐다.
- `flutter_tools.dart analyze --no-pub`
  - 통과, No issues found
- `flutter_tools.dart test test\data\card_art_assets_test.dart test\data\card_frame_assets_test.dart`
  - 통과, 3개 테스트 전체 통과
- imagegen CLI dry-run:
  - `C:\Users\wjd54\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe C:\Users\wjd54\.codex\skills\imagegen\scripts\image_gen.py generate ... --dry-run`
  - 통과. `OPENAI_API_KEY` 미설정 경고와 함께 `gpt-image-1.5`, `1024x1024`, `quality=high` 요청 형태 확인.

### 결과

- 카드 전체 PNG가 아니라 카드별 중앙 삽화 PNG만 image2로 생성하는 방향을 문서로 고정했다.
- `docs/card-art-generation-plan.md`에 샘플 11장 각각의 카드 id, 콘셉트, 저장 경로, image2 프롬프트, 금지 요소를 작성했다.
- `CardArtAssets` 헬퍼를 추가해 샘플 11장만 `assets/images/game/cards/art/{cardId}.png`로 매핑했다.
- `SoulDeckCardView`는 카드 삽화가 있으면 중앙 이미지로 표시하고, 파일이 없거나 샘플 외 카드면 기존 카테고리 아이콘으로 fallback한다.
- `pubspec.yaml`에 `assets/images/game/cards/art/`를 등록했다.
- 실제 생성 PNG가 아직 없어도 앱은 기존 아이콘 fallback으로 유지된다.

### 남은 위험

- `OPENAI_API_KEY`가 없어 실제 image2 샘플 11장 생성은 아직 수행하지 못했다.
- 샘플 삽화가 들어가면 현재 중앙 영역 크기(`hand 54`, `reward 38`, `mini 28`)가 너무 작게 느껴질 수 있다. 실제 이미지 생성 후 `SoulDeckCardView`의 art plate 크기/설명 영역 재조정이 필요할 수 있다.
- 현재 카드 프레임 자체의 품질 문제는 별도 작업이다. 이번 작업은 중앙 삽화 파이프라인만 준비했다.

### 다음 작업

1. `OPENAI_API_KEY` 설정 후 `docs/card-art-generation-plan.md`의 샘플 11장 프롬프트로 실제 PNG 생성.
2. 생성된 11장 삽화를 `assets/images/game/cards/art/`에 저장한 뒤 실기기에서 전투 손패/보상/컬렉션/상점/휴식 화면 QA.
3. 샘플 QA가 통과하면 common 전체 카드 삽화 프롬프트 확장.

### 정정

- 사용자 지시에 따라 이미지 생성 방식 기준을 정정한다.
- 이 Codex 대화 환경에서는 로컬 `OPENAI_API_KEY`가 필요한 imagegen CLI를 우선하지 않는다.
- 새 게임 이미지 생성은 Codex 내장 이미지 생성 기능을 사용한다.
- 이 규칙을 `docs/AI_WORK_RULES.md`의 `2-A. 이미지 생성 규칙`에 기록했다.

---

## 2026-05-05 KST (2차) - Codex

### 착수 전 조사

- 내장 이미지 생성 결과 저장 위치를 확인했다: `C:\Users\wjd54\.codex\generated_images\019dee9e-c5ee-7791-a88e-40c0d4b07383\`
- starter 3장 생성 시트를 육안 확인했다. 텍스트/숫자/프레임 없이 중앙 삽화로 사용 가능하다고 판단했다.
- 샘플 8장 추가 생성 시트를 육안 확인했다. 4×2 패널 모두 카드 중앙 삽화로 사용 가능하다고 판단했다.

### 변경 파일

- `assets/images/game/cards/art/base_strike.png`
- `assets/images/game/cards/art/base_defend.png`
- `assets/images/game/cards/art/base_focus.png`
- `assets/images/game/cards/art/atk_c01.png`
- `assets/images/game/cards/art/atk_c02.png`
- `assets/images/game/cards/art/def_c01.png`
- `assets/images/game/cards/art/def_c02.png`
- `assets/images/game/cards/art/mag_c01.png`
- `assets/images/game/cards/art/mag_c02.png`
- `assets/images/game/cards/art/tac_c01.png`
- `assets/images/game/cards/art/tac_c02.png`
- `docs/card_art_sample_contact_sheet.png`
- `lib/widgets/soul_deck_card_view.dart`
- `test/data/card_art_assets_test.dart`
- `docs/card-art-generation-plan.md`
- `docs/game-asset-inventory.md`
- `docs/SHARED_WORK_LOG.md`

### 실행한 검증

- 내장 이미지 생성:
  - starter 3장 시트 생성
  - common 샘플 8장 시트 생성
- 생성 시트 분할:
  - starter 3장 → 1024×1024 PNG 3개
  - common 샘플 8장 → 1024×1024 PNG 8개
- contact sheet 생성: `docs/card_art_sample_contact_sheet.png`
- `dart format lib\widgets\soul_deck_card_view.dart test\data\card_art_assets_test.dart lib\data\card_art_assets.dart`
  - 파일 포맷은 완료됐으나 Dart telemetry 파일 권한 문제로 종료 코드는 실패 처리됐다.
- `flutter_tools.dart analyze --no-pub`
  - 1차 실패: 테스트에서 `package:image` 직접 import로 `depend_on_referenced_packages` 발생
  - PNG 헤더 직접 파싱 방식으로 수정 후 재실행 통과, No issues found
- `flutter_tools.dart test test\data\card_art_assets_test.dart test\data\card_frame_assets_test.dart`
  - 통과, 4개 테스트 전체 통과

### 결과

- 샘플 11장 카드별 중앙 삽화가 실제 프로젝트 에셋으로 저장됐다.
- `SoulDeckCardView` 중앙 삽화 영역을 키웠다:
  - hand: 54 → 64
  - reward: 38 → 48
  - mini: 28 → 32
- `card_art_assets_test.dart`가 샘플 11장 PNG의 존재, 비어 있지 않음, PNG decode 가능, 1024×1024 크기를 검증하도록 강화됐다.

### 남은 위험

- 실제 Flutter 화면에서 삽화가 텍스트와 충돌하지 않는지 아직 기기 QA가 필요하다.
- `mag_c02`는 마법진 형태가 포함되어 있으나 읽을 수 있는 텍스트는 아니다. 기기에서 너무 복잡해 보이면 재생성 후보로 둔다.
- 전체 207장 생성 전, 이번 11장 샘플의 화면 내 가독성을 먼저 확정해야 한다.

### 다음 작업

1. Android 실기기에서 전투 손패/보상/컬렉션/상점/휴식 화면의 샘플 카드 표시 QA.
2. QA 통과 시 common 전체 카드 삽화 생성으로 확장.
3. 카드 프레임 자체 재생성 여부 결정.

---

## 2026-05-05 KST (3차) - Claude

### 착수 전 조사

- `git status` → main 브랜치, origin/main 동기화됨. untracked: `assets/images/game/cards/art/`, `lib/data/card_art_assets.dart`, `test/data/card_art_assets_test.dart`, `docs/card-art-generation-plan.md`, `docs/card_art_sample_contact_sheet.png`.
- `docs/AI_WORK_RULES.md`, `docs/card-art-generation-plan.md`, `docs/game-asset-inventory.md`, `docs/SHARED_WORK_LOG.md` 전체 정독.
- `lib/data/card_art_assets.dart` 확인: 샘플 11장 ID Set, `artPathFor(card)` — `spritePath` 우선, fallback `sampleCardIds` 체크. 로직 정확.
- `lib/widgets/soul_deck_card_view.dart` 확인: `_CardVisual` 위젯 추가됨. artPath 있으면 `ClipRRect+Image.asset(BoxFit.cover)`, 없으면 `_CategoryIcon` fallback. `_iconSize`: hand 64 / reward 48 / mini 32 (이전 54/38/28에서 확대).
- `test/data/card_art_assets_test.dart` 확인: PNG 존재·비어있지 않음·1024×1024 크기 검증. `atk_c03` fallback null 반환 검증.
- `assets/images/game/cards/art/` 실제 파일 확인: 11개 PNG 존재 (각 1.3~1.6MB, 1024×1024 확인).
- `pubspec.yaml` 확인: `assets/images/game/cards/art/` 등록됨.
- `docs/card_art_sample_contact_sheet.png` 육안 확인: 11장 모두 다크 판타지 스타일, 어두운 배경, 중앙 단일 오브젝트 구도, 텍스트/숫자/프레임 없음. 카드 중앙 삽화 적격.
- 레이아웃 수치 코드 레벨 분석 (art 크기 확대 후):
  - hand (110×154): 고정 94px(이름22+갭4+아트64+갭4), 나머지 50px → Expanded 설명 ~3.5줄, 오버플로우 없음.
  - reward (94×142): 고정 74px(이름20+갭3+아트48+갭3), 나머지 58px → ~3.6줄, 오버플로우 없음.
  - mini (72×108): 고정 55px(이름17+갭3+아트32+갭3), 나머지 43px → ~3.7줄, 오버플로우 없음.
- tactical overlay (alpha:0.82) 스택 레이어 확인: overlay=layer 2, 아트 이미지=layer 3(content Column 내부). 아트가 overlay 위에 렌더링 → overlay가 아트를 가리지 않음.
- `CardData.spritePath` 기본값 `''` → `artPathFor`에서 비어 있으면 `sampleCardIds` 체크로 이어짐. 정확.

### 변경 파일

- 없음 (코드 변경 불필요. 분석·검증·커밋만 수행)

### 실행한 검증

- `flutter analyze --no-pub` → `No issues found!` (11.4s) ✅
- `flutter test test/data/card_art_assets_test.dart test/data/card_frame_assets_test.dart test/data/monster_assets_test.dart test/data/player_assets_test.dart test/data/battle_effect_assets_test.dart` → `+7: All tests passed!` ✅
- `flutter build apk --debug` → `√ Built` (32.4s) ✅
- `adb uninstall + adb install` → `Success` ✅
- `adb shell monkey` → 앱 실행, 스플래시→로그인 화면 도달 (`docs/qa_screenshots/qa_art_login.png`)
- 로그인 자격증명 미보유로 던전 화면 진입 불가 — 기기 QA는 사용자 직접 확인 필요

### 결과

- 코드 레벨 QA 전 체크리스트 통과: 레이아웃 overflow 없음, tactical overlay 아트 미차단, spritePath 로직 정확, 11장 PNG 품질·크기·다양성 양호.
- `flutter analyze 0건, +7 tests passed` 유지.
- 신규 파일(art PNG 11장, card_art_assets.dart, test, contact sheet, plan.md)이 git 추적에 추가됨.

### 남은 위험

- **실기기 던전 화면 QA 미완료**: 로그인 자격증명 없어 자동화 불가. 사용자가 앱 로그인 후 아래 화면을 직접 확인해야 한다.
  - 전투 손패: 샘플 카드 삽화가 프레임 내 중앙에 표시되는지
  - 전투 보상 선택: 3장 Row overflow 없는지(이전 세션에서 수정됨), 삽화 표시 정상인지
  - 카드 컬렉션: hand 사이즈 64px 삽화가 그리드에서 잘리지 않는지
  - 카드팩: reward 사이즈 48px 삽화, 선택 테두리 정렬(이전 세션 수정됨)
  - 던전 상점: mini 32px 삽화 가독성
  - 휴식 업그레이드: FittedBox 스케일 업 시 삽화 품질
- **`mag_c02` 복잡도**: 마법진+서리 문양 조합. 32×32px mini에서 의미 파악 어려울 수 있음. 기기 확인 후 재생성 결정.
- **전체 카드(207장) 삽화**: 샘플 QA 통과 후 확장. 스타터 3장+common 샘플 8장만 적용.

### 다음 작업

1. **사용자 직접 QA**: 앱 로그인 → 던전 진입 → 전투 손패/보상/컬렉션/상점/휴식 화면에서 샘플 카드 삽화 표시 확인
2. 문제 발견 시 `SoulDeckCardView` 중앙 이미지 크기/padding/설명 maxLines 조정
3. QA 통과 후 common 전체 카드 삽화 생성 계획 확장
4. Codex에 STS2 타입별 하단 모양 카드 프레임 4종 재생성 의뢰

---

## 2026-05-05 KST (4차 - Codex)

### 착수 전 조사

- 사용자 피드백: Life Quest의 전투 주체는 별도 캐릭터가 아니라 현실 퀘스트를 수행하는 사용자 본인이다. 던전/전투의 플레이어 캐릭터 표시는 의미가 없으므로 제거 요청.
- `rg`로 `PlayerBattleSprite`, `PlayerProfileSprite`, `hero_idle`, `character.name`, 장비 비주얼 사용 위치를 조사했다.
- 확인된 런타임 사용처:
  - `lib/screens/dungeon/card_battle_screen.dart`: 전투 상단 플레이어 프로필 스프라이트
  - `lib/widgets/combat/combat_arena_view.dart`: 일반 전투 아레나 플레이어 전신 스프라이트와 장비 비주얼
  - `lib/screens/dungeon/dungeon_home_screen.dart`: 캐릭터 이름/STR/WIS/HP/CHA 중심 던전 홈 카드
- `CharacterState`/`Character`는 XP, 골드, HP, 덱, 장비 보정 계산에 광범위하게 묶여 있어 즉시 모델 삭제는 위험하다고 판단했다. 이번 작업 범위는 화면에서 별도 캐릭터 존재감을 제거하고 내부 진행 데이터로만 남기는 것이다.

### 변경 파일

- `lib/screens/dungeon/card_battle_screen.dart`
- `lib/widgets/combat/combat_arena_view.dart`
- `lib/screens/dungeon/dungeon_home_screen.dart`
- `lib/widgets/combat/player_battle_sprite.dart` 삭제
- `lib/widgets/player_profile_sprite.dart` 삭제
- `test/data/player_assets_test.dart` 삭제
- `docs/AI_WORK_RULES.md`
- `docs/game-asset-inventory.md`
- `docs/SHARED_WORK_LOG.md`

### 변경 내용

- 카드 전투 상단 HP 바에서 `PlayerProfileSprite`와 장비 기반 outfit 계산을 제거했다.
- 일반 전투 아레나에서 `PlayerBattleSprite`, 플레이어 이름, 장비 시각 반영, 장착 전투 이펙트 아이콘을 제거했다.
- 일반 전투 아레나 왼쪽 영역은 `나의 전투 상태` + HP 바 + `퀘스트 성장 Lv.x`만 표시하도록 변경했다.
- 던전 홈의 `${character.name} Lv.x`, `STR/WIS/HP/CHA` 표기를 `나의 던전 진행 Lv.x`, `공격/전술/생존/보상 보정`으로 변경했다.
- 캐릭터 스프라이트 위젯 2개와 해당 에셋 존재 테스트를 삭제했다.
- `hero_idle.png`는 즉시 삭제하지 않고 폐기 예정/미사용 에셋으로 문서화했다.
- 작업 중 PowerShell 라인 교체로 두 화면 파일의 한글 인코딩이 깨지는 문제가 발생했으나, 해당 파일만 HEAD 기준으로 복원한 뒤 의도 변경만 재적용했다.

### 실행한 검증

- `dart format lib\screens\dungeon\card_battle_screen.dart lib\screens\dungeon\dungeon_home_screen.dart lib\widgets\combat\combat_arena_view.dart`
- `flutter_tools.dart analyze --no-pub` → `No issues found`
- `flutter_tools.dart test test\data\card_art_assets_test.dart test\data\card_frame_assets_test.dart test\data\monster_assets_test.dart test\data\battle_effect_assets_test.dart` → `+6: All tests passed`

### 결과

- 던전/전투 화면의 별도 플레이어 캐릭터 비주얼은 제거됐다.
- 내부 성장/보상 계산은 유지했다. 현재 구조에서 `Character` 모델 전체 삭제는 별도 마이그레이션/리팩토링 단계로 분리해야 한다.

### 남은 위험

- `status_screen.dart`, `settings_screen.dart`, `inventory_screen.dart`, 로컬라이제이션 문구에는 여전히 캐릭터 중심 표현이 남아 있다. 다음 단계에서 앱 전체 용어를 `캐릭터 성장`에서 `사용자/계정/퀘스트 성장`으로 바꾸는 전역 카피 리팩토링이 필요하다.
- `assets/images/player/hero_idle.png`는 미사용 상태로 남아 있다. pubspec 또는 다른 화면에서 참조가 완전히 없음을 재확인한 뒤 별도 cleanup에서 삭제 가능하다.

### 다음 작업

1. ARB 카피 리팩토링: `loginSubtitle`, `onboardingPage1Body` 4개 언어에서 `캐릭터` → 사용자 중심 표현으로 변경.
2. `status_screen.dart`에서 `character.name` 헤드라인 강조 해제.
3. `combat_state.dart` 전투 로그에서 `[character.name]` → `나` / 중립 표현.

---

## 2026-05-05 KST (5차) - Claude

### 착수 전 조사

- Codex 4차 작업 로그 정독 — `status_screen.dart`, `settings_screen.dart`, 로컬라이제이션이 잔여 캐릭터 중심 표현으로 남아 있음 확인.
- `lib/l10n/` ARB 4개 파일에서 `캐릭터`, `character`, `キャラクター`, `角色` 사용 위치 확인:
  - `loginSubtitle` (4개 언어): "캐릭터와 하루를 함께 성장" / "grow your character and your day" / "キャラクターと一日を共に成長" / "与角色共同成长"
  - `onboardingPage1Body` (4개 언어): "캐릭터가 성장합니다" / "watch your character grow" / "キャラクターが成長します" / "让角色不断成长"
- `lib/screens/status_screen.dart` 184~191줄: `character.name`을 `headlineSmall bold primary color`로 화면 최상위 정체성 요소로 표시 — RPG 캐릭터 이름으로 오해될 수 있는 강조.
- `lib/state/combat_state.dart` 138, 140, 173, 205줄: `[${character.name}]` 전투 로그 삽입.
- `settings_screen.dart`: l10n 키(`settingsNicknameLabel`) 기반 닉네임 설정. 계정 이름 맥락으로 수용 가능. 변경 불필요.
- `inventory_screen.dart`: l10n 키 기반 장비/스탯 레이블. 변경 불필요.
- `signup_screen.dart`: 프로필 사진 업로드 (Firebase user photo). 계정 설정 맥락으로 수용 가능. 변경 불필요.

### 변경 파일

- `lib/l10n/app_ko.arb`: `loginSubtitle` "캐릭터와 하루를 함께 성장시키는" → "나의 하루를 함께 성장시키는". `onboardingPage1Body` "캐릭터가 성장합니다" → "나의 퀘스트 성장이 쌓입니다".
- `lib/l10n/app_en.arb`: `loginSubtitle` "grow your character and your day" → "grow your skills and shape your day". `onboardingPage1Body` "watch your character grow" → "grow your stats and skills".
- `lib/l10n/app_ja.arb`: `loginSubtitle` "キャラクターと一日を共に成長させる" → "あなたの実力と一日を共に成長させる". `onboardingPage1Body` "キャラクターが成長します" → "あなたの実力が成長します".
- `lib/l10n/app_zh.arb`: `loginSubtitle` "与角色共同成长" → "让自己每天成长". `onboardingPage1Body` "让角色不断成长" → "不断提升自己的实力".
- `lib/screens/status_screen.dart`: `character.name` 스타일 `headlineSmall bold primary` → `titleMedium onSurface` (닉네임 정체성 강조 해제, 계정 이름 수준으로 유지).
- `lib/state/combat_state.dart`: 전투 로그 4곳 `[${character.name}]` → `나의` / `나는` / 생략 처리.

### 실행한 검증

- `flutter gen-l10n` → l10n.yaml 기반 자동 실행 확인.
- `flutter analyze --no-pub` → `No issues found!` ✅
- `flutter test` → `82개 전체 통과` ✅

### 결과

- ARB 4개 언어 `loginSubtitle` + `onboardingPage1Body`에서 캐릭터 중심 표현 완전 제거. l10n grep 결과 0건 확인.
- `status_screen.dart` 닉네임 표시: RPG 주인공 이름 강조에서 일반 계정 닉네임 수준으로 하향.
- `combat_state.dart` 전투 로그: `[닉네임]의 공격!` → `나의 공격!` 등 1인칭 사용자 시점으로 통일.
- 앱 전체에서 별도 캐릭터 존재감이 시각/카피 양 측면에서 제거 완료.

### 남은 위험

- **실기기 확인 미완료**: 로그인 화면의 새 `loginSubtitle` 문구, 온보딩 1페이지의 새 Body 문구를 실제 기기에서 직접 확인 필요.
- **`hero_idle.png` 미사용 에셋**: 아직 파일 삭제 안 됨. pubspec에서 참조 없음. 별도 cleanup에서 삭제 가능.

### 다음 작업

1. **사용자 직접 QA**: 앱 로그인 화면 subtitle, 온보딩 1페이지 body 문구 확인.
2. **APK 재빌드·설치**: 새 문구 반영 APK로 기기 확인 (필요 시).
3. 카드 삽화 실기기 QA (던전 진입 후 각 화면).

---

## 2026-05-07 KST - Claude

### 착수 전 조사

- `docs/AI_WORK_RULES.md`, `docs/SHARED_WORK_LOG.md`, `docs/game-asset-inventory.md`, `docs/card-art-generation-plan.md` 정독.
- `lib/widgets/soul_deck_card_view.dart` 전체 구조 분석:
  - Stack 3레이어: frame PNG (layer 1) → tactical overlay (layer 2) → content Column (layer 3)
  - content Column: headerRow(22px) + gap(4px) + centerArt(64px) + gap(4px) + Expanded(desc) + rarity
  - fallback: `errorBuilder` → solid color + accentColor border
- `lib/data/card_art_assets.dart` 확인: sampleCardIds 11장 Set, `artPathFor()` 로직.
- `assets/images/cards/` 확인: 카드 프레임 4종 PNG 존재.
- `assets/images/game/cards/art/` 확인: 샘플 11장 PNG 존재 (1024×1024).
- `lib/models/card_data.dart` 확인: `CardCategory` (attack/magic/defense/tactical), `CardRarity` (common/uncommon/rare/legendary), `CardData` 생성자.
- `pubspec.yaml` 확인: 현재 asset 등록 목록.
- 기존 방식 문제 정리: 프레임 PNG + 삽화 PNG가 별개 생성으로 분리감 → "카드 한 장 전체 바디 이미지 + Flutter 텍스트 오버레이" 방식이 목표.

### 설계 결정

- 파일명 정책: `assets/images/game/cards/full_body/card_body_{category}_{rarity}.png` (총 16장 예정)
- 이미지 사양: 440×616 px, 상단 55% 주삽화, 하단 45% 자연 어두워지는 그라디언트
- Flutter 오버레이: 비용 젬 + 카드명 (상단 Positioned) + 설명 + 희귀도 (하단 Positioned)
- 전환 제어: `CardBodyAssets._availableBodies` Set — 키 추가 시 즉시 full body 모드 전환
- 레거시 유지: `_availableBodies` 비어 있으면 기존 frame+art 레이아웃으로 자동 fallback

### 변경 파일

- `lib/data/card_body_assets.dart` (신규):
  - `CardBodyAssets` 클래스: `bodyDirectory`, `_availableBodies`, `hasBodyFor()`, `bodyPathFor()`, `resolvedBodyPath()`, `allExpectedPaths()`.
  - `resolvedBodyPath()`: 정확한 희귀도 → common fallback → null (레거시 사용) 순서 적용.
- `lib/widgets/soul_deck_card_view.dart` (수정):
  - `_hPad`, `_vPad`, `_headerHeight` getter 추출 (기존 인라인 삼항 표현식 대체).
  - `_fullBodyDescriptionLines` getter 추가 (hand: 6 / reward: 5 / mini: 4).
  - `build()`: `CardBodyAssets.resolvedBodyPath()` 기반으로 `_buildFullBody()` / `_buildLegacy()` 분기.
  - `_buildFullBody()`: Positioned Stack — 바디이미지 + 상단스크림 + 하단스크림 + 비용/이름 + 설명/희귀도.
  - `_buildLegacy()`: 기존 frame+art+Column 레이아웃 완전 보존.
- `test/data/card_body_assets_test.dart` (신규):
  - 경로 생성 테스트 (8개 대표 조합 + 16개 allExpectedPaths).
  - 가용성 레지스트리 테스트 (초기 false, resolvedBodyPath null).
  - pubspec 등록 + 디렉터리 존재 테스트.
  - fallback 안전성 테스트.
- `assets/images/game/cards/full_body/.gitkeep` (신규): 디렉터리 생성.
- `pubspec.yaml`: `assets/images/game/cards/full_body/` 등록.
- `docs/card-full-body-generation-plan.md` (신규): 이미지 사양, common 4장 프롬프트, 등록 방법, QA 기준, 레거시 에셋 처리 계획.
- `docs/game-asset-inventory.md`: 카드 전체 바디 행 추가, 다음 작업 갱신.
- `docs/SHARED_WORK_LOG.md`: 본 항목 추가.

### 실행한 검증

- `flutter analyze --no-pub` → `No issues found!` (63.5s) ✅
- `flutter test test/data/card_body_assets_test.dart ...card_art... ...card_frame... ...monster... ...battle_effect...` → `+16: All tests passed!` ✅
- `flutter test` (전체) → `92개 전체 통과` ✅
- grep `PlayerBattleSprite|PlayerProfileSprite|hero_idle` lib/ → 0건 (잔여 참조 없음) ✅

### 결과

- `SoulDeckCardView`가 full body 이미지 방식과 레거시 방식을 모두 지원하는 구조로 전환됐다.
- 현재는 `_availableBodies`가 비어 있어 모든 카드가 레거시 레이아웃으로 렌더링된다. (기존 동작 유지)
- 바디 이미지 PNG를 생성해 디렉터리에 넣고 `_availableBodies`에 키를 추가하면 즉시 full body 모드로 전환된다.
- 테스트 82 → 92개로 증가.

### 남은 위험

- **이미지 생성 미완료**: common 4장(`attack/defense/magic/tactical`)이 아직 없어 full body 모드는 실제 동작하지 않는다. Codex 내장 이미지 생성으로 4장 생성 필요.
- **하단 스크림 높이 조정 가능성**: `_height * 0.46` 값이 실기기에서 텍스트 가독성을 충분히 확보하는지 확인 필요. 조정 시 `_buildFullBody()` 내 `bottomScrimH` 상수 변경.
- **mini 사이즈 레이아웃**: 72×108 mini에서 설명 텍스트 4줄이 실기기에서 스크림 영역 안에 완전히 들어오는지 확인 필요.

### 다음 작업

1. **[최우선]** Codex: `docs/card-full-body-generation-plan.md` 섹션 5의 프롬프트로 common 4장 생성. `assets/images/game/cards/full_body/`에 저장. `_availableBodies`에 키 추가.
2. APK 빌드 → 실기기에서 full body 카드 시각 QA.
3. QA 통과 후 uncommon/rare/legendary 확장.

---

## 2026-05-07 KST - Codex

### 착수 전 조사

- Claude가 커밋한 full body 카드 전환 설계(`9ac7ffe`)를 이어받아 `docs/card-full-body-generation-plan.md`, `lib/data/card_body_assets.dart`, `lib/widgets/soul_deck_card_view.dart`, `test/data/card_body_assets_test.dart`를 확인했다.
- 기존 dirty worktree에 `.claude/` 및 이전 영상 제작 산출물이 섞여 있음을 확인했다. 이번 작업과 무관한 파일은 건드리지 않았다.
- `CardBodyAssets._availableBodies`가 비어 있어 full body 렌더링이 아직 실제로 켜지지 않는 상태임을 확인했다.

### 변경 파일

- `assets/images/game/cards/full_body/card_body_attack_common.png` (신규): 공격 common 카드 전체 바디.
- `assets/images/game/cards/full_body/card_body_defense_common.png` (신규): 방어 common 카드 전체 바디.
- `assets/images/game/cards/full_body/card_body_magic_common.png` (신규): 마법 common 카드 전체 바디.
- `assets/images/game/cards/full_body/card_body_tactical_common.png` (신규): 전술 common 카드 전체 바디.
- `docs/card_body_candidates/` (신규): Codex 내장 이미지 생성 원본 후보 4장 보관.
- `docs/card_body_common_contact.png` (신규): common 4장 QA용 contact sheet.
- `lib/data/card_body_assets.dart`: `_availableBodies`에 `attack_common`, `defense_common`, `magic_common`, `tactical_common` 등록.
- `test/data/card_body_assets_test.dart`: "이미지 없음" 기준 테스트를 "common 4장 등록 + common fallback + PNG 440×616 검증" 기준으로 갱신.
- `docs/card-full-body-generation-plan.md`: common 4장 생성/등록 완료 상태와 QA 기준 갱신.
- `docs/game-asset-inventory.md`: 카드 전체 바디 에셋 현황 갱신.
- `docs/SHARED_WORK_LOG.md`: 본 항목 추가.

### 실행한 작업

- Codex 내장 이미지 생성 기능으로 4개 카테고리 common 카드 바디를 생성했다. OPENAI_API_KEY는 사용하지 않았다.
- 생성 원본을 `docs/card_body_candidates/`에 보관했다.
- ffmpeg로 4장 모두 440×616 px로 cover crop 정규화해 `assets/images/game/cards/full_body/`에 저장했다.
- contact sheet(`docs/card_body_common_contact.png`)를 만들어 육안 QA했다.

### 실행한 검증

- `flutter analyze --no-pub` → `No issues found!` ✅
- `flutter test test/data/card_body_assets_test.dart test/data/card_art_assets_test.dart test/data/card_frame_assets_test.dart` → `16개 전체 통과` ✅
- `flutter build apk --debug` → `build/app/outputs/flutter-apk/app-debug.apk` 생성 성공 ✅
- `tar -tf build/app/outputs/flutter-apk/app-debug.apk | Select-String "card_body_.*_common.png"` → APK 내부에 common 4장 포함 확인 ✅

### 결과

- full body 카드 모드가 실제로 켜졌다.
- 현재 attack/defense/magic/tactical 카테고리의 모든 희귀도 카드는 전용 희귀도 PNG가 없을 경우 common 바디로 fallback된다.
- 레거시 프레임+중앙 삽화 방식은 `_availableBodies`에 없는 조합을 위한 fallback으로 유지된다.
- 생성된 4장 모두 단순 프레임/삽화 분리 방식이 아니라 카드 한 장 전체의 분위기와 하단 텍스트 영역을 포함한 바디 이미지다.

### 남은 위험

- 실기기에서 `hand/reward/mini` 세 사이즈의 텍스트 가독성, 하단 스크림 대비, 카드명/비용 위치를 직접 확인해야 한다.
- common 바디만 먼저 적용했기 때문에 uncommon/rare/legendary 전용 차별화는 아직 없다.
- 4장 바디가 실제 앱 화면에서 너무 강하거나 텍스트와 충돌하면 `SoulDeckCardView._buildFullBody()`의 스크림/텍스트 위치 조정이 필요하다.
- 연결 기기 `520034bafe9225db`는 ADB 응답 정상이나 `adb install -r build/app/outputs/flutter-apk/app-debug.apk`가 장시간 무응답으로 중단했다. debug APK가 274MB로 커서 설치 재시도는 별도 세션에서 진행 권장.

### 다음 작업

1. APK 빌드 및 실기기 설치.
2. 전투 손패, 전투 승리 보상, 카드팩, 컬렉션, 상점, 휴식 업그레이드 화면에서 full body 카드 QA.
3. QA 통과 후 uncommon/rare/legendary 12장 추가 생성.

---

## 2026-05-07 KST - Codex 실기기 QA 진행 계획

### 목적

full body 카드 common 4종이 실제 Android 기기에서 카드 UI로 표시될 때, 텍스트 가독성/배치/overflow/이미지 분위기가 배포 가능한 수준인지 확인한다.

### 진행 순서

1. ADB 기기 상태 확인: `520034bafe9225db` 연결/부팅/화면 상태 확인.
2. 설치 전략 결정:
   - 1차: 기존 APK 위에 `adb install -r` 재시도.
   - 장시간 무응답이면 `adb install --no-streaming -r` 또는 Gradle install task로 전환.
   - 서명 충돌이 있으면 사용자 데이터 삭제 위험이 있으므로 무단 uninstall은 하지 않는다.
3. 앱 실행 확인:
   - `com.lifequest.app` activity resolve 후 `am start`.
   - 실행 직후 스크린샷과 crash logcat 확인.
4. 카드 화면 QA:
   - 전투 손패: full body 이미지 위 카드명/비용/설명 가독성.
   - 승리 보상: 3장 Row overflow 재발 여부.
   - 카드팩/컬렉션: reward/card grid에서 카드 이미지 잘림 여부.
   - 상점/휴식: mini/reward 크기에서 텍스트가 과밀하지 않은지.
5. 수정 기준:
   - 텍스트가 배경에 묻히면 하단 스크림 opacity/높이 조정.
   - 이름/비용이 상단 삽화와 충돌하면 top scrim/패딩 조정.
   - mini 설명이 과밀하면 mini full-body 설명 줄 수 축소 또는 mini 전용 표시 정책 조정.
6. 모든 결과를 본 문서에 계속 누적 기록한다.

### 착수 전 주의

- 이번 QA는 카드 full body 작업만 대상으로 한다.
- `.claude/` 변경과 이전 영상 제작 산출물은 건드리지 않는다.
- 단순 도형/임시 프레임 방식으로 되돌리지 않는다.

### 진행 결과

- ADB 기기 `520034bafe9225db` 연결 확인.
- 기존 universal debug APK는 274MB, arm64 split debug APK는 약 199MB였다.
- 최초 설치 실패 원인:
  - `/data` 여유 공간 1.2GB 수준에서 `INSTALL_FAILED_INSUFFICIENT_STORAGE` 발생.
  - `/data/local/tmp/lifequest-debug.apk` stale 파일 225MB 발견 및 제거.
  - `pm trim-caches 2G` 실행 후 `/data` 여유 공간 2.0GB 확보.
- arm64 split APK 설치 성공:
  - `adb install -r build/app/outputs/flutter-apk/app-arm64-v8a-debug.apk`
  - 설치 후 `primaryCpuAbi=arm64-v8a`, `versionCode=2002`, `lastUpdateTime=2026-05-07 22:49:18` 확인.
- 앱 실행 초기 검정 화면은 앱 크래시가 아니라 화면 꺼짐/키가드 상태였다.
  - `mWakefulness=Dozing`, `Display Power: state=OFF`, `isStatusBarKeyguard=true` 확인.
  - `KEYCODE_WAKEUP` + `wm dismiss-keyguard` 후 앱 화면 정상 표시.

### 실기기 카드 QA

- 전투 손패 full body 카드 표시 확인:
  - `docs/qa_card_fullbody_04_awake_launch.png`
  - 공격/방어/전술 common 바디 이미지가 실제 카드 배경으로 표시됨.
  - hand 카드에서 비용/이름/설명 텍스트는 읽힘.
  - 하단 스크림 대비는 충분함.
- 전투 승리 보상 full body 카드 표시 확인:
  - `docs/qa_card_fullbody_10_reward.png`
  - 보상 카드 3장 overflow는 없음.
  - 단, reward 카드 폭 94px에서 한국어 설명 줄바꿈 품질이 낮음:
    - `정렬한 / 다.`
    - `독 2 / 를`
  - 원인: 이미지 문제가 아니라 reward 카드 폭/오버레이 컨테이너 폭 부족.

### 수정

- `lib/widgets/soul_deck_card_view.dart`
  - `SoulDeckCardSize.reward` width: `94` → `102`
  - reward 카드 폭을 full body 비율에 더 가깝게 조정하고 설명 텍스트 가로폭 확보.
- `lib/screens/dungeon/card_pack_screen.dart`
  - 카드팩 선택 테두리 컨테이너 width: `94` → `102`
  - `SoulDeckCardSize.reward`와 다시 일치.
- `lib/screens/dungeon/card_battle_screen.dart`
  - 승리 보상 오버레이 width: `330` → `350`
  - padding: `EdgeInsets.all(20)` → `EdgeInsets.symmetric(horizontal: 16, vertical: 20)`
  - 내부 가용폭을 290px → 318px로 늘려 102px reward 카드 3장이 들어가도록 조정.

### 수정 후 검증

- `flutter analyze --no-pub` → `No issues found!` ✅
- `flutter test test/data/card_body_assets_test.dart test/data/card_art_assets_test.dart test/data/card_frame_assets_test.dart` → `16개 전체 통과` ✅
- `flutter build apk --debug --split-per-abi` → arm64/armeabi/x86_64 split APK 생성 성공 ✅
- 수정 APK 기기 설치 성공 ✅
- 수정 후 전투 손패 재확인:
  - `docs/qa_card_fullbody_15_battle_after_fix.png`
  - reward 폭 변경이 hand 카드에는 영향 없음.

### 남은 위험

- 수정 후 승리 보상 화면을 다시 캡처하려 했으나, 재진입한 전투에서 드로우가 방어/집중 위주로 꼬여 보상 화면 재도달이 지연됐다.
- 따라서 reward 폭 수정의 실기기 재확인은 다음 세션에서 보상 화면까지 다시 도달해 `docs/qa_card_fullbody_10_reward.png`와 비교해야 한다.
- 그래도 원인과 수정 지점은 명확하다: 보상 카드 텍스트 폭 부족 → reward 카드/오버레이 가용폭 확장.

### 다음 작업

1. 수정 APK 상태에서 전투 1회 더 완료해 승리 보상 화면 재캡처.
2. 보상 설명 줄바꿈이 개선됐는지 확인.
3. 카드팩 화면의 102px 선택 테두리 정렬 확인.
4. 문제가 없으면 uncommon/rare/legendary 12장 생성으로 넘어간다.

---

## 2026-05-07 KST - Codex reward 카드 폭/overflow 최종 QA

### 목적

직전 세션에서 남긴 보상 카드 폭 수정이 실제 Android 기기에서 충분한지 재확인하고, 보상 카드 3장 Row에서 발생하는 노란/검은 overflow 줄무늬를 완전히 제거한다.

### 추가 확인

- 기기: `520034bafe9225db`
- 수정 전 재확인 스크린샷:
  - `docs/qa_card_fullbody_25_reward_after_width_fix.png`
  - reward 폭 `102` 상태에서도 한국어 설명 줄바꿈이 아직 어색했다.
- reward 폭 `104` 중간 확인:
  - `docs/qa_card_fullbody_31_second_fix_reward_confirm.png`
  - 전체 배치는 개선됐지만 일부 긴 설명에서 줄바꿈 품질이 부족했다.
- reward 폭 `108` 확인 중 발견:
  - `docs/qa_card_fullbody_40_reward_final_width108.png`
  - 카드 자체 줄바꿈은 좋아졌지만 보상 오버레이 Row의 오른쪽 카드가 `RIGHT OVERFLOWED BY 2.0 PIXELS`를 냈다.

### 최종 수정

- `lib/widgets/soul_deck_card_view.dart`
  - `SoulDeckCardSize.reward` width: `102` -> `108`
  - reward description font size: `8.2` -> `7.7`
  - 목적: full-body reward 카드에서 긴 한국어 설명의 가로 폭을 확보하고, 텍스트가 카드 하단에서 안정적으로 2~3줄로 들어가게 조정.
- `lib/screens/dungeon/card_pack_screen.dart`
  - 카드팩 선택 테두리 width: `102` -> `108`
  - 목적: reward 카드 실제 폭과 선택 테두리 폭을 계속 일치시킴.
- `lib/screens/dungeon/card_battle_screen.dart`
  - 승리 보상 오버레이 padding: `EdgeInsets.symmetric(horizontal: 16, vertical: 20)` -> `EdgeInsets.symmetric(horizontal: 8, vertical: 20)`
  - 보상 카드 Row 배치: `MainAxisAlignment.spaceEvenly` -> `MainAxisAlignment.spaceBetween`
  - 목적: 108px 카드 3장 총 324px을 오버레이 내부에 확실히 넣고, Flutter Row overflow를 제거.

### 검증

- `flutter analyze --no-pub` -> `No issues found!` ✅
- `flutter test test/data/card_body_assets_test.dart test/data/card_art_assets_test.dart test/data/card_frame_assets_test.dart` -> `16개 전체 통과` ✅
- `flutter build apk --debug --split-per-abi` -> arm64/armeabi/x86_64 split APK 생성 성공 ✅
- `adb install -r build/app/outputs/flutter-apk/app-arm64-v8a-debug.apk` -> 설치 성공 ✅
- 실기기 전투 보상 화면 최종 확인:
  - `docs/qa_card_fullbody_44_reward_padding_fix.png`
  - overflow 줄무늬 제거 확인.
  - 3장 reward 카드가 오버레이 안에 정상 배치됨.
  - full-body 카드 이미지와 이름/비용/설명/희귀도 텍스트가 기능적으로 읽힘.

### 남은 위험

- 카드 자체는 이제 프레임 분리 방식보다 훨씬 낫지만, reward 사이즈에서 긴 한국어 설명은 아직 문장 자체가 짧게 다듬어져야 더 고급스럽다.
- 다음 단계에서는 UI 폭을 더 키우기보다 카드 설명 카피를 카드 UI용으로 짧고 강하게 재작성하는 쪽이 맞다.
- uncommon/rare/legendary 전용 12장 이미지를 추가하면 희귀도별 시각 차별화가 생기지만, 그 전에 현재 common 4장 체계가 전 화면에서 깨지지 않는지 한 번 더 넓게 확인해야 한다.

### 다음 작업

1. 카드팩/컬렉션/상점/휴식 화면에서 `reward=108`, `mini=72`, `hand=110` 조합의 전체 화면 QA.
2. 긴 한국어 카드 설명을 카드 UI 기준으로 짧게 정리하는 카피 QA.
3. 문제가 없으면 uncommon/rare/legendary 12장 full-body 카드 생성 및 등록.

---

## 2026-05-08 KST - Web QA Preview 계획 수립

### 목적

Google Play 테스트 배포까지 기다리지 않고, 웹 링크로 외부 테스터에게 현재 Life Quest의 핵심 화면과 소울 덱 흐름을 먼저 보여주고 피드백을 받는 방식을 검토한다.

### 기존 작업 유지 확인

- 직전 카드 QA 결과와 다음 작업은 이 문서 마지막 항목에 기록되어 있음을 확인했다.
- 남은 카드 작업:
  1. 카드팩/컬렉션/상점/휴식 화면에서 `reward=108`, `mini=72`, `hand=110` 조합의 전체 화면 QA
  2. 긴 한국어 카드 설명을 카드 UI 기준으로 짧게 정리하는 카피 QA
  3. 문제가 없으면 uncommon/rare/legendary 12장 full-body 카드 생성 및 등록
- Web QA Preview는 위 작업을 대체하지 않고, 피드백 수집을 앞당기는 별도 채널로 취급한다.

### 조사 결과

- Flutter Web 자체는 프로젝트에 `web/` 디렉터리가 있어 시도 가능하다.
- `lib/firebase_options.dart`는 현재 `kIsWeb`에서 `UnsupportedError`를 던진다. Web Firebase 설정이 없다.
- `lib/main.dart`는 앱 시작 시 Notification, Sound, Ad, Purchase, HomeWidget 서비스를 공통 초기화한다.
- 웹 차단 가능성이 높은 항목:
  - `firebase_options.dart` Web 설정 누락
  - `notification_service.dart`의 `dart:io` / `Platform`
  - `HomeWidget.setAppGroupId`
  - `FirebaseCrashlytics`
  - `FirebaseAppCheck`
  - `AdService` / `google_mobile_ads`
  - `PurchaseService` / `in_app_purchase`
  - `signup_screen.dart`의 `dart:io`, `image_picker`, `firebase_storage`

### 작성 문서

- `docs/web-qa-preview-plan.md`

### 결정

- Android 앱을 그대로 웹 제품화하지 않는다.
- 범위를 `Web QA Preview`로 제한한다.
- 로그인 없이 들어가는 QA/Test Mode를 만든다.
- Google 로그인, AdMob, IAP, Android 알림, 홈 위젯, 이미지 업로드는 1차 웹 QA에서 비활성화하거나 mock 처리한다.

### 다음 작업

1. `flutter build web`을 실제 실행해 예상 차단점과 실제 차단점을 분리한다.
2. 실패 로그를 `docs/web-qa-preview-build-audit.md`에 기록한다.
3. Web Firebase 설정 또는 QA Preview용 Firebase 우회 전략을 결정한다.
4. `LIFEQUEST_QA_PREVIEW` dart-define 기반 테스트 모드 진입점을 설계/구현한다.
5. 로컬 Chrome 실행 또는 `build/web` 생성까지 확인한다.

---

## 2026-05-08 KST - Web QA Preview 1차 빌드 감사

### 목적

Web QA Preview가 말뿐인 계획인지, 실제 Flutter Web 산출물 생성이 가능한지 확인한다.

### 자료조사 반영

- Flutter 공식 문서 기준 Web 배포 빌드는 `flutter build web` 산출물을 정적 호스팅에 배포하는 구조다.
- Firebase Hosting Preview Channel은 외부 테스터에게 공유 가능한 임시 URL 전략에 적합하다.
- `shared_preferences`는 웹 구현을 제공하므로 localStorage 기반 게스트 테스트 프로필 저장에 사용할 수 있다.
- Web QA Preview는 Android 앱의 1:1 복제가 아니라 같은 시각 언어, 정보 구조, 핵심 루프를 제공하는 피드백용 체험판으로 정의했다.

### 실행

```powershell
flutter build web --dart-define=LIFEQUEST_QA_PREVIEW=true
```

### 결과

- `√ Built build\web` — 1차 Web 빌드 성공.
- 별도 감사 문서 작성:
  - `docs/web-qa-preview-build-audit.md`

### 발견 사항

- JS 기반 Flutter Web 빌드는 성공했다.
- Wasm dry-run에서 `flutter_timezone-5.0.1`의 JS interop 관련 경고가 발생했다.
- 현재 목표는 Web QA Preview이므로 Wasm 대응은 즉시 차단점이 아니다.
- 컴파일은 성공했지만 런타임에서는 `firebase_options.dart`의 Web 설정 누락이 가장 먼저 막을 가능성이 높다.

### 다음 작업

1. 로컬 웹 실행으로 런타임 차단점 확인.
2. `LIFEQUEST_QA_PREVIEW=true`일 때 Firebase Auth 없이 진입하는 QA 시작 경로 추가.
3. Web QA에서는 Crashlytics/AppCheck/HomeWidget/Notification/Ad/IAP를 skip 또는 no-op 처리.
4. SharedPreferences(web) 기반 로컬 게스트 프로필 저장 설계.
5. 퀘스트/상태창/소울 덱/보상/카드팩/컬렉션/상점/휴식 핵심 루프를 5~10분 체험 가능하게 연결.

---

## 2026-05-08 KST - Web QA Preview 진입점 1차 구현

### 목적

`flutter build web` 성공 이후 실제 Chrome 런타임에서 앱이 시작 가능한지 확인하고, Firebase/Auth에 막히지 않는 QA Preview 시작 경로를 만든다.

### 진행

- `flutter run -d chrome --dart-define=LIFEQUEST_QA_PREVIEW=true` 실행.
- 1차 런타임 차단점:
  - `FirebaseCrashlytics.instance`가 웹 Firebase 미설정 상태에서 예외 처리 중 다시 예외 발생.
- 2차 런타임 차단점:
  - `CharacterState` 생성 시 `FirebaseFirestore.instance`를 즉시 잡아 웹 Firebase 미설정 예외 발생.

### 수정

- `lib/config/qa_preview_config.dart`
  - `kLifeQuestQaPreview` 추가.
- `lib/screens/qa_preview_gate_screen.dart`
  - QA Preview 시작 화면 추가.
  - `게스트로 테스트 시작` 버튼 추가.
- `lib/main.dart`
  - QA Preview 모드에서 Firebase initialize, Crashlytics, AppCheck, optional services 초기화 skip.
  - QA Preview 모드에서 `AuthWrapper` 대신 `QaPreviewGateScreen` 사용.
- `lib/screens/main_screen.dart`
  - QA Preview 모드에서 FirebaseAuth auth subscription skip.
- `lib/state/character_state.dart`
  - Firestore 즉시 초기화를 lazy getter로 변경.
  - `initializeForQaPreview()` 추가.
  - QA Preview seed profile: `testuser1`, Lv.1, XP 85/150, 골드 52, 카드팩 1, 기본/샘플 카드 일부 보유.

### 검증

- `dart format` 완료.
- `flutter analyze --no-pub` -> No issues found.
- `flutter build web --dart-define=LIFEQUEST_QA_PREVIEW=true` -> 성공.
- `flutter run -d chrome --dart-define=LIFEQUEST_QA_PREVIEW=true` -> Chrome 디버그 서비스 연결 성공.
- Playwright로 `http://localhost:2303/` 접근 확인:
  - page title: `Life Quest`
  - `flutter-view` 390×844 mount 확인.
  - 새 Firebase 런타임 예외 없음.

### 주의

- Flutter Web canvas 기반이라 Playwright accessibility snapshot만으로 실제 픽셀 화면을 충분히 확인하기 어렵다.
- 좌표 기반 JS synthetic click은 Flutter pointer id 오류를 만들 수 있어 사용하지 않는다.
- 다음에는 실제 스크린샷 확인 경로와 버튼 클릭/화면 전환 QA 방식을 확보해야 한다.

### 다음 작업

1. `게스트로 테스트 시작` 버튼 클릭 후 MainScreen 진입을 안정적으로 확인.
2. `_performSaveData()`에 QA Preview 로컬 저장 분기 추가.
3. SharedPreferences(web)에 guest profile/progress snapshot 저장.
4. 퀘스트 완료, 던전 전투, 카드 보상에서 Firebase 호출 없이 진행되는지 확인.
5. Web QA Preview 화면 스크린샷/영상 캡처 경로 확보.

---

## 2026-05-08 KST - Web QA Preview 로컬 게스트 저장 구현

### 목적

테스터가 Google/Firestore 로그인 없이 Web QA Preview에 진입하고, 브라우저 localStorage 기반으로 최소 진행 상태를 유지할 수 있게 만든다.

### 수정

- `lib/state/character_state.dart`
  - `initializeForQaPreview()`를 async로 변경.
  - 최초 진입 시 QA seed profile 생성 후 `SharedPreferences`에 저장.
  - 재진입 시 `lifequest.qaPreview.state.v1` snapshot 복원.
  - `_performSaveData()`에 `kLifeQuestQaPreview` 분기를 추가해 Firestore 대신 로컬 저장 수행.
  - Firestore 저장 payload와 QA Preview 저장 payload를 `_buildSavePayload()`로 통합.
  - QA seed 데이터에 daily/weekly/monthly/yearly 퀘스트, 기본 카드, 샘플 카드, 커스텀 보상 포함.
- `lib/screens/qa_preview_gate_screen.dart`
  - 게스트 시작 버튼에서 async 초기화 대기.
  - 실패 시 SnackBar로 원인 표시.
- `test/state/character_state_test.dart`
  - `SharedPreferences.setMockInitialValues({})` 기반 QA Preview seed/restore 테스트 추가.

### 검증

- `flutter analyze --no-pub` -> No issues found.
- `flutter test` -> 95개 전체 통과.
- `flutter build web --dart-define=LIFEQUEST_QA_PREVIEW=true` -> `build\web` 생성 성공.
- `flutter run -d chrome --dart-define=LIFEQUEST_QA_PREVIEW=true` -> Chrome 런타임 실행 성공.
- Playwright:
  - QA Preview 게이트 표시 확인.
  - 접근성 활성화 후 `게스트로 테스트 시작` 버튼 클릭.
  - `MainScreen` 상태창 진입 확인.
  - `testuser1`, `Lv. 1 | 새싹 모험가`, `XP 85 / 150`, `HP 100 / 100`, `골드 52` 표시 확인.
  - localStorage에 `flutter.lifequest.qaPreview.state.v1` 저장 확인.

### 남은 작업

1. Web QA Preview에서 퀘스트 완료 후 XP/골드/저장 반영 확인.
2. 사냥 탭 진입, 던전 전투, 카드 보상까지 Firebase 호출 없이 진행되는지 확인.
3. 카드팩, 컬렉션, 상점, 휴식 화면에서 full-body 카드 UI를 스크린샷 기반으로 넓게 QA.
4. 긴 한국어 카드 설명을 카드 UI 기준으로 짧게 정리.
5. Web QA Preview 공유 방식 결정: Firebase Hosting preview channel 또는 별도 정적 호스팅.

---

## 2026-05-12 KST - Web QA Preview Firebase Hosting 실배포

### 목적

테스터가 앱 설치나 Google 로그인 없이 Life Quest의 핵심 흐름을 바로 만져볼 수 있도록 Web QA Preview를 실제 공유 가능한 서버에 배포한다.

### 배포

- 배포 URL: https://life-quest-app-95eb9.web.app
- Firebase project: `life-quest-app-95eb9`
- 빌드 명령:
  - `flutter build web --dart-define=LIFEQUEST_QA_PREVIEW=true --pwa-strategy=none`
- 배포 명령:
  - `npx firebase-tools deploy --only hosting --project life-quest-app-95eb9`

### 수정

- `.firebaserc`
  - 기본 Firebase project를 `life-quest-app-95eb9`로 고정.
- `firebase.json`
  - Hosting public directory를 `build/web`으로 설정.
  - Flutter Web SPA 라우팅을 위해 모든 경로를 `/index.html`로 rewrite.
  - QA Preview 특성상 새 배포가 즉시 반영되도록 `Cache-Control: no-cache` 헤더 추가.
- `lib/state/character_state.dart`
  - QA Preview 모드에서는 저장 debounce를 기다리지 않고 `_performSaveData()`를 즉시 실행.
  - 퀘스트 완료 직후 localStorage 진행 상태가 바로 갱신되도록 수정.
- `lib/screens/quests_screen.dart`
  - QA Preview 모드에서는 광고 보상 버튼을 숨기고 기본 완료 경로만 노출.
- `lib/services/sound_service.dart`
  - WebAudio decode 오류를 만들던 6-byte placeholder mp3 참조를 실제 wav SFX로 교체.
- `.gitignore`
  - Firebase CLI 로컬 배포 캐시 `.firebase/` 제외.

### 검증

- `flutter analyze --no-pub` -> No issues found.
- `flutter test` -> 96개 전체 통과.
- `flutter build web --dart-define=LIFEQUEST_QA_PREVIEW=true --pwa-strategy=none` -> 성공.
- Firebase Hosting 배포 -> 성공.
- Playwright 런타임 확인:
  - 배포 URL에서 `Life Quest`, `Web QA Preview`, `게스트로 테스트 시작` 표시 확인.
  - 게스트 시작 후 상태창 진입 확인.
  - `testuser1`, `Lv. 1 | 새싹 모험가`, `XP 85 / 150`, `골드 52` 표시 확인.
  - localStorage key `flutter.lifequest.qaPreview.state.v1` 생성 확인.
  - 첫 일일 퀘스트 완료 후 localStorage에 Lv.2, XP 약 5.2, max XP 200, 골드 62, 완료 상태 저장 확인.
  - 최종 배포 JS에 `sounds/quest_complete.mp3` 참조가 없고 `sounds/sfx/level_up.wav` 참조가 있는지 `no-store` fetch로 확인.
  - Hosting 응답 헤더 `Cache-Control: no-cache` 확인.

### 남은 리스크

- 최종 `no-cache` 적용 전 접속했던 기존 브라우저 탭은 낡은 `main.dart.js`를 잡고 있을 수 있으므로 한 번 강력 새로고침이 필요할 수 있다.
- Wasm dry-run 경고는 `flutter_timezone-5.0.1` JS interop lint에서 계속 발생한다. 현재 배포는 JS Flutter Web 빌드라 공유 차단 사항은 아니다.
- 테스터 공개 전 다음 넓은 QA가 필요하다:
  - 카드팩, 컬렉션, 상점, 휴식 화면의 full-body 카드 표시.
  - 사냥 탭, 던전 전투, 전투 보상 흐름.
  - 긴 한국어 카드 설명 축약.
  - 모바일 브라우저 실제 터치 스크린샷 확인.

---

## 2026-05-12 KST - Web QA Preview 초기 프로필 정상화

### 목적

배포된 QA Preview의 첫 화면이 개발용 테스트 계정처럼 보이지 않도록 초기 게스트 상태를 실제 신규 사용자에 가깝게 정리한다.

### 수정

- QA Preview 기본 이름: `testuser1` -> `게스트 모험가`
- QA Preview 기본 XP: `85 / 150` -> `0 / 150`
- QA Preview 기본 골드: `52` -> `0`
- QA Preview 기본 스탯: STR/WIS/HP/CHA 사전 부여값 제거 -> 전부 `0`
- QA Preview 기본 카드 포인트: `6` -> `0`
- QA Preview localStorage key: `lifequest.qaPreview.state.v1` -> `lifequest.qaPreview.state.v2`
  - 기존 브라우저에 남은 개발용 seed가 계속 복원되지 않도록 버전을 올렸다.

### 검증 기준

- 신규 접속자는 `게스트 모험가`, Lv.1, XP `0 / 150`, 골드 `0`에서 시작해야 한다.
- 첫 일일 퀘스트 완료 후 퀘스트 XP, 첫 완료 업적 XP, 골드 보상이 localStorage에 즉시 반영되어야 한다.

### 검증/배포

- `dart analyze` -> No issues found.
- `flutter test --no-pub test/state/character_state_test.dart` -> 22개 통과.
- `flutter build web --dart-define=LIFEQUEST_QA_PREVIEW=true --pwa-strategy=none` -> 성공.
- Firebase Hosting 재배포 -> 성공.
- 배포 URL: https://life-quest-app-95eb9.web.app
- 배포된 `main.dart.js` 확인:
  - `lifequest.qaPreview.state.v2` 포함.
  - `lifequest.qaPreview.state.v1` 미포함.
- Playwright 접근성 확인:
  - QA Preview 게이트와 `게스트로 테스트 시작` 문구 표시 확인.
  - 이후 버튼 클릭 검증은 Codex 사용량 제한으로 중단됨. 다음 세션 또는 수동 브라우저에서 새 localStorage v2 초기값을 확인해야 한다.

---

## 2026-05-13 KST - Web QA Preview 광고/후원 노출 제거

### 목적

테스터 피드백용 웹 프리뷰에서는 수익화 안내보다 핵심 경험이 먼저 보여야 한다. QA Preview 모드에서 광고 후원 안내와 보상형 광고 유도를 제거한다.

### 수정

- `lib/screens/settings_screen.dart`
  - QA Preview에서 `광고 후원 안내` 카드 숨김.
  - QA Preview에서 debug 광고 검증 카드 숨김.
- `lib/screens/report_screen.dart`
  - QA Preview에서는 확장 리포트를 광고 잠금 없이 즉시 열린 상태로 취급.
  - 광고 보기 버튼과 남은 광고 횟수 노출 제거.
- `lib/screens/hunt_screen.dart`
  - 전투 승리 보상 2배 광고 버튼 숨김.
  - 전투 패배 부활 광고 버튼 숨김.
  - AP 부족 시 광고 회복 다이얼로그 대신 일반 AP 부족 안내만 표시.
- `lib/screens/cosmetic_shop_screen.dart`
  - 광고 후원형 운영을 설명하는 코스메틱 준비 안내 카드 숨김.

### 검증/배포

- `dart analyze` -> No issues found.
- `flutter build web --dart-define=LIFEQUEST_QA_PREVIEW=true --pwa-strategy=none` -> 성공.
- Firebase Hosting 재배포 -> 성공.
- 배포 URL: https://life-quest-app-95eb9.web.app

### 남은 확인

- 브라우저에서 설정 화면, 확장 리포트, 사냥 AP 부족/전투 결과 화면을 직접 순회하며 광고 관련 문구가 남지 않았는지 시각 QA가 필요하다.

---

## 2026-05-13 KST - Web QA Preview 휴대폰 프레임 렌더링

### 목적

데스크톱 브라우저에서 QA Preview가 화면 전체를 차지해 앱의 실제 사용 감각을 흐리는 문제를 줄인다. 테스터가 모바일 앱처럼 인식할 수 있도록 웹에서도 휴대폰 크기 뷰포트를 기준으로 보여준다.

### 수정

- `web/index.html`
  - 데스크톱에서는 앱 host를 최대 `430 x 932` 크기의 중앙 휴대폰 프레임으로 표시.
  - 실제 모바일 폭(`430px` 이하)에서는 프레임 없이 전체 화면으로 렌더링.
  - 외곽 배경과 프레임 테두리 대비를 분리해 데스크톱에서 모바일 미리보기임을 분명히 표시.
  - 로딩 이후 배경색 유지.
- `web/flutter_bootstrap.js`
  - 공식 Flutter Web `hostElement` 방식으로 렌더링 대상을 `#flutter_host`에 고정.
  - 런타임이 `flutter-view` 배치를 덮어쓰는 문제를 피했다.

### 검증/배포

- `flutter build web --dart-define=LIFEQUEST_QA_PREVIEW=true --pwa-strategy=none` -> 성공.
- Firebase Hosting 재배포 -> 성공.
- 배포 URL: https://life-quest-app-95eb9.web.app
- Browser QA:
  - 데스크톱 기본 뷰포트에서 휴대폰 프레임 중앙 렌더링 확인.
  - `390 x 844` 모바일 뷰포트에서 프레임 없이 전체 화면 렌더링 확인.
  - 배포 페이지 title `Life Quest`, 관련 console warn/error 없음 확인.

---

## 2026-05-13 KST - Threads 테스터 모집 홍보물 제작

### 산출물

- 홍보 영상:
  - `docs/lifequest_threads_tester_preview_20260513.mp4`
  - 세로 `1080 x 1920`, 약 14초.
  - Web QA Preview 실제 흐름을 자동 촬영:
    - 게스트 시작
    - 상태창
    - 퀘스트 목록
    - 사냥/던전 화면
- 포스터 프레임:
  - `docs/lifequest_threads_tester_preview_20260513_poster.jpg`
- 게시글 원고:
  - `docs/threads_tester_recruit_post_20260513.md`

### 메시지 방향

- “설치 없이 지금 바로 체험 가능”
- “퀘스트 -> 성장 -> 던전 흐름을 먼저 봐달라”
- 댓글 또는 DM으로 피드백 수집
- 요청 피드백 범위:
  - 첫 이해도
  - 화면/흐름의 어색함
  - 계속 쓰고 싶은지
  - 버그/불편 지점

---

## 2026-05-14 KST - Web QA Preview 공개 링크 보안 점검

### 배경

- Threads에 `https://life-quest-app-95eb9.web.app` 링크를 공개했다.
- 외부 반응을 기다리는 동안, 공개된 Web QA Preview에 개인정보나 위험한 설정이 포함됐는지 먼저 점검했다.

### 점검 결과

- `build/web/main.dart.js` 기준 내 PC 경로, Windows 사용자명, OneDrive/Desktop 경로, 개인 이메일 문자열 없음.
- Firebase API key, AdMob publisher id, `OPENAI_API_KEY`, Firebase project id는 배포 JS에 직접 포함되지 않음.
- `access_token` 문자열 1건은 Firebase SDK 내부 필드명으로 확인. 실제 토큰 값 아님.
- `build/web/assets/NOTICES`의 이메일들은 오픈소스 라이선스 고지에 포함된 외부 기여자 정보이며 내 개인정보가 아님.
- QA Preview는 Firebase 초기화/Auth 구독/AdService/Crashlytics/App Check를 skip하고, 저장은 브라우저 localStorage의 `lifequest.qaPreview.state.v2`에만 수행.
- `firestore.rules` 로컬 파일은 본인 UID 경로 외 모든 접근을 차단하는 형태로 확인.
- 당시 `storage.rules`는 repo에 없었음. 2026-05-19에 Android 정식 앱용 Storage rules를 추가했다.

### 조치

- `firebase.json` Hosting headers 보강:
  - `Content-Security-Policy`
  - `X-Content-Type-Options: nosniff`
  - `Referrer-Policy: no-referrer`
  - `Permissions-Policy`
  - `X-Frame-Options: DENY`
- 초기 CSP가 Flutter Web의 `gstatic` CanvasKit/Roboto 로드를 차단해 앱 로드가 깨지는 문제를 확인했다.
- CSP를 `www.gstatic.com`, `fonts.gstatic.com`만 추가 허용하는 방식으로 조정했다.
- `web/index.html`의 사용되지 않는 inline splash script를 제거하고, 공개 페이지 title/description을 `Life Quest` 기준으로 정리했다.
- 브라우저 QA에서 `Life Quest`, `Web QA Preview`, `게스트로 테스트 시작` 렌더링 확인.
- Google Sign-In 웹 플러그인의 `accounts.google.com/gsi/client` 로드 시도는 CSP가 차단 중. QA Preview에서는 로그인 미사용이므로 허용하지 않는다.
- 세부 감사 내용은 `docs/web-qa-preview-build-audit.md` 섹션 16에 기록.

### 남은 확인

- Firebase 콘솔에 실제 배포된 Firestore/Storage rules가 로컬 파일과 동일한지 별도 확인 필요.
- Hosting headers 배포 후 공개 URL에서 앱이 정상 렌더링되는지 최종 브라우저 QA 필요.

---

## 2026-05-14 KST - 테스터 피드백 P0/P1 반영

### 배경

Claude Code 피드백에서 이벤트 복귀, 노드 진입 무반응, Web 스크롤, 카드 지연 로드, 구매 확인, 업적 진행 바, 퀘스트 탭 잘림 문제가 보고됐다. 즉시 체감되는 P0/P1 항목을 우선 반영했다.

### 문서

- `docs/feedback-remediation-plan-20260514.md`
  - 피드백 항목을 P0/P1/후속 설계로 분류.
  - 완료된 코드 수정과 검증 결과 기록.

### 코드 변경

- `lib/screens/dungeon/dungeon_event_screen.dart`
  - 이벤트 `계속` 버튼이 `Navigator.pop(true)`를 반환하도록 변경.
  - 이벤트 데이터가 없는 경우 빈 화면에 고립되지 않고 이전 화면으로 `false` 반환.
- `lib/screens/dungeon/dungeon_map_screen.dart`
  - 노드 탭 중 `_pendingNodeId`로 중복 탭 차단.
  - 진입 중 overlay + spinner 표시.
  - 이벤트 노드는 `true` 결과일 때만 node complete.
- `lib/main.dart`
  - `LifeQuestScrollBehavior` 추가.
  - Web/desktop에서 mouse/stylus drag scroll 허용.
- `lib/screens/dungeon/card_pack_screen.dart`
  - 뽑힌 카드 full-body/card-art asset precache.
- `lib/screens/dungeon/dungeon_shop_screen.dart`
  - 카드/유물 구매 전 확인 다이얼로그 추가.
- `lib/screens/achievement_screen.dart`
  - 낮은 진행률도 최소 4%로 보이게 표시.
- `lib/screens/quests_screen.dart`
  - 탭 정렬/padding/font size 조정.
- `web/index.html`
  - CSP inline script 제거 이후 splash image가 앱을 덮을 위험을 없애기 위해 splash picture 제거.

### 검증/배포

- `flutter analyze --no-pub` -> No issues found.
- `flutter test --no-pub` -> 96개 전체 통과.
- `flutter build web --dart-define=LIFEQUEST_QA_PREVIEW=true --pwa-strategy=none` -> 성공.
- Firebase Hosting 재배포 -> 성공.
- 공개 URL smoke QA:
  - page title `Life Quest`.
  - `flutter-view` mount 확인.
  - `#splash` DOM 제거 확인.
  - Google Sign-In web script는 CSP가 차단 중. QA Preview에서는 로그인 미사용이므로 허용하지 않는다.

### 후속 작업

- HP/체력/건강 용어 통합 정리.
- 카드별/속성별 full-body art 매칭.
- 타이머 접근 경로 재설계.
- 던전 맵 범례/현재 위치 강조.

---

## 2026-05-14 KST - 테스터 피드백 P2 반영

### 목적

P0/P1 이후 남은 피드백 중 앱 이해도에 영향을 주는 P2 항목을 반영했다. 범위는 HP 용어 혼선 완화, 타이머 접근성, 던전 맵 해석성, 카드 아트 매칭 구조다.

### 코드 변경

- HP/체력/건강 용어 분리
  - `statusHpLabel`: `생활 HP`
  - `huntMyHpLabel`: `전투 HP`
  - `inventoryHpLabel`: `건강 보정`
  - 상태창 HP 라벨이 하드코딩 `HP`가 아니라 l10n 라벨을 사용하도록 수정.
  - 던전 맵/휴식/전투 화면의 플레이어 HP 수치를 `전투 HP` 라벨과 함께 표시.
- 타이머 접근성
  - `lib/screens/quests_screen.dart`
  - 퀘스트 화면 AppBar에 집중 타이머 버튼 추가.
- 던전 맵 해석성
  - `lib/screens/dungeon/dungeon_map_screen.dart`
  - 노드 타입 범례 추가: 전투/엘리트/이벤트/상점/휴식/보스/현재.
  - 선택 중인 노드는 `현재` 배지와 흰색 강조 테두리로 표시.
  - 진행 가능한 노드는 작은 컬러 점으로 표시.
- 카드 아트 매칭 기반
  - `lib/data/card_body_assets.dart`
  - 카드별 full-body PNG override 구조 추가.
  - 우선순위: 카드별 이미지 -> category+rarity -> category common -> legacy fallback.

### 문서

- `docs/feedback-remediation-plan-20260514.md`
  - P2 반영 결과 추가.
- `docs/card-full-body-generation-plan.md`
  - 카드별 full-body art 파일 규칙과 생성 우선순위 추가.

### 검증

- `flutter gen-l10n` -> 성공.
- `flutter analyze --no-pub` -> No issues found.
- `flutter test --no-pub` -> 96개 전체 통과.
- `flutter build web --dart-define=LIFEQUEST_QA_PREVIEW=true --pwa-strategy=none` -> 성공.
- Firebase Hosting 재배포 -> 성공.
- 공개 URL smoke QA:
  - URL: https://life-quest-app-95eb9.web.app/?p2_fix=20260514
  - page title `Life Quest`.
  - Flutter Web view mount 확인.
  - `#splash` 제거 상태 확인.
  - QA Preview localStorage 키 `flutter.lifequest.qaPreview.state.v2` 확인.
  - 남은 console error는 Google Sign-In web script의 CSP 차단 1건이다. QA Preview는 게스트 모드 테스트라 로그인 스크립트를 허용하지 않는다.

---

## 2026-05-15 KST - Threads 제품 방향성 피드백 기록

### 목적

Threads 테스터 모집 글에 달린 외부 피드백을 제품 방향성 문서로 정리했다. 이번 피드백은 버그가 아니라 Life Quest의 핵심 루프, 현실 행동과 RPG 보상 연결, 칭호/이벤트 의미, 첫 진입 정보 구조에 대한 지적이다.

### 문서

- `docs/threads-core-loop-feedback-20260515.md`
  - 원문 요지 정리.
  - 제품 관점 해석.
  - Core Loop 명확성 부족, 현실 행동과 RPG 수치 연결 약함, 칭호/이벤트 의미 부족, 첫 진입 정보 구조 부족을 문제로 분류.
  - 후속 작업으로 Core Loop UX 문서 작성, 오늘의 모험 요약 블록, 칭호-이벤트 매핑, 현실 행동 -> 전투 효과 매핑을 제안.

### 판단

- 다음 큰 작업은 전체 디자인 리디자인보다 `Life Quest Core Loop UX 재설계`가 우선이다.
- Figma/Canva/Hyperframes 기반 전체 리디자인은 보류한다.
- Health Connect, 인바디, AR, 외부 활동 연동은 장기 과제로 분리한다.

---

## 2026-05-15 KST - Life Quest 대대적 리메이크 계획서 작성

### 목적

Threads 피드백 중 실현 가능성과 수익 가능성이 있는 부분만 받아 현재 앱을 재기획/재구축하는 마스터 계획서를 작성했다. 기존 작업물에 연연하지 않고, 버릴 것과 가져갈 것을 냉정하게 분리하는 기준을 세웠다.

### 신규 문서

- `docs/lifequest-remake-master-plan-20260515.md`

### 조사 기준

- 2026년 기준 최신 자료를 다시 확인했다.
- 자료를 별도 모음으로 쌓지 않고, 즉시 제품 이슈 형태로 기록했다.
- 확인한 주요 영역:
  - Health Connect 공식 문서와 권한/데이터 타입 구조
  - Google Play Billing 구독 lifecycle
  - RevenueCat 2026 subscription retention 자료
  - Finch/Habitica/Duolingo식 gamification/retention 참고
  - Figma2Code, UI-Bench, Penpot, ComfyUI 등 AI 디자인/오픈소스 디자인 도구 흐름

### 핵심 판단

- 현재 앱은 기능이 부족한 것이 아니라 기능들이 하나의 이유로 묶이지 않는 것이 문제다.
- 소울 덱은 유지하되 `별도 미니게임`이 아니라 `현실 행동의 성장 체감 장치`로 재설계한다.
- Health Connect/인바디/AR 자동 연동은 강력하지만 출시 1차 범위에서는 제외한다.
- AI 기능은 전면 상품화하지 않고 추천/분류/요약 보조로 숨긴다.
- 구독은 당장 넣지 않고 무료 + 광고 제거/후원/테마성 일회성 결제를 우선 검토한다.
- 디자인은 현재 스타일을 고집하지 않는다. 단, Figma/이미지 생성 전체 리디자인은 파일럿 1개 화면 성공 전까지 금지한다.

### 다음 계획 후보

1. `docs/lifequest-feature-cutline-20260515.md`
   - 현재 기능을 유지/재배치/숨김/삭제 후보로 분류.
2. `docs/lifequest-core-loop-ux-20260515.md`
   - 현실 행동 -> 성장 -> 던전 보정 -> 칭호/이벤트 해금 규칙 확정.
3. 앱 구현 파일럿
   - 퀘스트 홈 또는 새 홈 상단에 `오늘의 모험` 요약 블록 추가.

---

## 2026-05-16 KST - 리메이크 세부 계획서와 체크리스트 작성

### 목적

마스터 계획서만으로는 구현 착수가 어렵기 때문에, 기능 컷라인, Core Loop UX 상세 설계, 실행 체크리스트를 별도 문서로 분리했다. 목표는 Claude/Codex가 다음 작업에서 바로 조사/구현/검증 단위로 움직일 수 있게 만드는 것이다.

### 최신 자료 재확인

- Android Developers Health Connect data types/permissions
- Google Play Billing subscriptions/lifecycle
- Android vitals
- RevenueCat State of Subscription Apps 2026
- Finch/Duolingo gamification 참고 자료

### 신규 문서

- `docs/lifequest-feature-cutline-20260516.md`
  - 현재 기능을 유지/재배치/숨김/삭제 후보/장기 보류로 분류.
  - 출시 1차 하단 탭을 `오늘/성장/모험/보상` 4개로 줄이는 방향 제안.
  - Health Connect, 구독, AI 개인 코치, 무한 타워, 승천, 월간/연간 레이드는 출시 1차 전면 제외로 판정.
- `docs/lifequest-core-loop-ux-20260516.md`
  - 현실 행동 -> GrowthDelta -> DailyModifier -> Title/Event unlock 흐름 상세화.
  - 퀘스트 카테고리별 스탯/던전 보정 규칙 초안 작성.
  - 오늘의 모험 화면 정보 위계와 던전 연결 규칙 작성.
  - 칭호-이벤트 매핑 후보 10개 작성.
- `docs/lifequest-remake-execution-checklist-20260516.md`
  - Phase 0~7 실행 체크리스트 작성.
  - 각 Phase별 선행 조사, 관련 파일, 구현 후보, 테스트, 완료 조건 기록.
  - 첫 구현 권장 범위를 `TodayAdventureSummary` 파일럿으로 제한.

### 판단

- 다음 실제 구현은 전체 리팩토링이 아니라 `오늘의 모험` 요약 블록 파일럿부터 시작해야 한다.
- 기존 기능 삭제보다 숨김/재배치로 위험을 줄인다.
- Health Connect, AI 개인 코치, 구독은 출시 1차 검증 전까지 금지한다.

---

## 2026-05-16 KST - Core Loop 파일럿 1차 구현

### 목적

리메이크 계획의 첫 구현으로 `오늘의 모험` 요약 블록을 퀘스트 화면 일일 탭 상단에 추가했다. 목표는 기존 기능을 크게 뒤집기 전에 현실 퀘스트 -> 성장 -> 오늘 던전 보정 -> 다음 행동 흐름을 실제 UI에서 보이게 만드는 것이다.

### 변경

- `lib/data/core_loop_rules.dart`
  - `GrowthDelta`, `DailyModifier`, `RecommendedAction`, `TitleProgressSnapshot` 추가.
  - 퀘스트 카테고리/난이도/타입을 성장량과 오늘 던전 보정으로 변환하는 순수 룰 추가.
  - 추천 행동 계산 추가.
- `lib/state/character_state.dart`
  - `todayCompletedQuests`
  - `todayGrowthDelta`
  - `todayDailyModifier`
  - `todayRecommendedAction`
  - `nextTitleProgress`
  - 저장 구조 변경 없이 기존 Quest/Title 데이터를 읽는 getter만 추가.
- `lib/widgets/today_adventure_summary.dart`
  - 오늘 완료 수, XP/골드, 주 성장 성향, 오늘 던전 보정, 다음 행동, 다음 칭호 진행도를 보여주는 파일럿 위젯 추가.
- `lib/screens/quests_screen.dart`
  - 일일 퀘스트 탭 상단에 `TodayAdventureSummary` 삽입.
- `test/data/core_loop_rules_test.dart`
  - 성장 변환, 보정 상한, 추천 행동 테스트 추가.
- `test/state/character_state_test.dart`
  - 오늘 완료 퀘스트만 요약에 반영되는지 테스트 추가.

### 검증

- `dart analyze` 대상 파일 한정 -> No issues found.
- `flutter analyze --no-pub` -> No issues found.
- `flutter test --no-pub test/data/core_loop_rules_test.dart test/state/character_state_test.dart` -> 27개 통과.
- `flutter test --no-pub` -> 101개 전체 통과.
- `flutter build web --dart-define=LIFEQUEST_QA_PREVIEW=true --pwa-strategy=none` -> 성공.
- Firebase Hosting 재배포 -> 성공.
  - URL: https://life-quest-app-95eb9.web.app
- 공개 URL smoke QA:
  - page title `Life Quest`.
  - Flutter Web view mount 확인.
  - `#splash` 제거 확인.
  - QA Preview localStorage 키 확인.
  - Google Sign-In web script CSP 차단 1건은 기존과 동일. QA Preview는 게스트 테스트라 허용하지 않는다.

### 남은 위험

- Playwright가 Flutter Canvas UI 텍스트를 직접 잡지 못해 `오늘의 모험` 블록 내부 시각 QA는 아직 실기기/수동 확인이 필요하다.
- 현재는 파일럿이므로 실제 던전 전투 수치에는 DailyModifier를 적용하지 않았다. 다음 단계에서 던전 시작 시 modifier snapshot을 저장하고 전투 HP 보정부터 실제 적용한다.
- 문구는 우선 한국어 하드코딩이다. 파일럿 검증 후 l10n으로 승격한다.
---

## 2026-05-17 KST - Additional feedback integration and modifier application

### Purpose

Threads feedback clarified that Life Quest should not be treated as a dungeon-first app. The primary product loop is real-life action/status check -> growth/reward/recommendation. Dungeon play is a secondary place where that growth can be felt.

### Documentation

- Added `docs/threads-core-loop-feedback-20260517.md`.
  - Recorded the decision that dungeon is an optional support loop, not the product center.
  - Deferred AR, motion recognition, Health Connect, and realtime competition to P2.
  - Reframed "Today Adventure" as a real-life action status board.
- Updated `docs/lifequest-remake-master-plan-20260515.md`.
  - Added the 2026-05-17 product sentence and priority changes.
- Updated `docs/lifequest-remake-execution-checklist-20260516.md`.
  - Added checklist items for DailyModifier snapshot and actual combat application.

### Code

- `lib/data/core_loop_rules.dart`
  - Added `DailyModifier.toJson()` and `DailyModifier.fromJson()` for dungeon run snapshots.
- `lib/state/dungeon_state.dart`
  - Stores the run's `DailyModifier`.
  - Applies today's HP bonus to `playerMaxHp` and `playerHp` at run start.
  - Applies today's starting gold bonus to dungeon gold at run start.
  - Persists `dailyModifier` in `toJson()`/`fromJson()`.
- `lib/screens/dungeon/dungeon_home_screen.dart`
  - Passes `CharacterState.todayDailyModifier` into `DungeonState.startRun()`.
- `lib/screens/dungeon/card_battle_screen.dart`
  - Passes the run snapshot modifier into `CardCombatState.startCombat()`.
- `lib/state/card_combat_state.dart`
  - Stores the combat modifier snapshot.
  - Applies attack damage bonus through the existing strength damage path.
  - Applies first-turn draw bonus on turn 0.

### Tests

- `test/state/dungeon_state_test.dart`
  - Added run snapshot test for HP/gold modifier application.
- `test/state/card_combat_state_daily_modifier_test.dart`
  - Added first-turn draw bonus test.
  - Added attack damage bonus test.

### Remaining risk

- Today Adventure copy still over-emphasizes dungeon and needs a wording pass.
- Card reward weights, event option chance, and shop/rest discounts are still not applied.
- Additional feedback implies a larger IA change: first screen should become a real-life action status board, not just a quest tab pilot.

---

## 2026-05-17 KST - Today status-board copy cleanup

### Purpose

The additional feedback requires the first visible loop to read as real-life action -> growth/recommendation, not as dungeon-first gameplay. The previous pilot still used broken Korean text and dungeon-heavy copy, so it could not communicate the new direction.

### Changes

- `lib/widgets/today_adventure_summary.dart`
  - Rewrote the panel copy from `오늘의 모험` to `오늘의 상태`.
  - Reframed the description around real-life actions becoming growth, rewards, and next recommended action.
  - Kept dungeon as an optional loop for feeling the growth.
  - Replaced broken Korean labels with readable Korean UI copy.
- `lib/data/core_loop_rules.dart`
  - Replaced broken modifier labels and recommendation reasons with readable Korean.
  - Recommendation reasons now explain which real-life action category is missing and what it unlocks.
- `test/data/core_loop_rules_test.dart`
  - Rebuilt test fixtures with readable Korean names.
  - Added a label regression test so broken/mojibake modifier labels are caught earlier.

### Remaining risk

- The pilot still lives inside the daily quest tab. The next IA step is moving this status board to the first app surface or a dedicated Today screen.

---

## 2026-05-18 KST - Web QA Preview offline render hardening

### Purpose

390px Web QA Preview verification exposed a release risk: Flutter Web could render a blank or textless screen when external CanvasKit/font requests were blocked. Tester preview must not depend on Google font/CDN access just to show basic Korean UI.

### Change

- `assets/fonts/NotoSansKR-Regular.ttf`
  - Added OFL-licensed Noto Sans KR from Google Fonts as a bundled app font.
- `pubspec.yaml`
  - Registered the `NotoSansKR` font family.
- `lib/main.dart`
  - Added app-level bundled font usage for both light and dark themes.
  - This keeps QA Preview and Android code on the same theme path while removing dependence on remote Roboto/Noto font fetches.

### QA note

- Local Web QA Preview should be run with `--no-web-resources-cdn` when possible:
  - `flutter run -d web-server --web-hostname=127.0.0.1 --web-port=51234 --no-web-resources-cdn --dart-define=LIFEQUEST_QA_PREVIEW=true`
  - `flutter build web --no-web-resources-cdn --dart-define=LIFEQUEST_QA_PREVIEW=true --pwa-strategy=none`

### Verification

- `flutter analyze --no-pub` -> No issues found.
- `flutter test --no-pub` -> 109 tests passed.
- `flutter build web --no-web-resources-cdn --dart-define=LIFEQUEST_QA_PREVIEW=true --pwa-strategy=none` -> `build/web` created.
- 390px Playwright screenshots confirmed the QA Preview gate and Today screen text render correctly with the bundled font.

### Remaining risk

- The Flutter Web engine still attempts some remote fallback font requests in headless CanvasKit, but bundled Noto Sans KR keeps the visible Korean UI readable when those requests fail.
- Google Sign-In web script may still be blocked by CSP in QA Preview. This is acceptable because QA Preview intentionally uses local guest mode.
- Headless screenshot navigation into some non-Today tabs can intermittently render a blank CanvasKit frame without page errors; this needs a separate Web QA investigation and should not block the current font hardening commit.

---

## 2026-05-19 KST - DailyModifier card reward weighting

### Purpose

The remake plan says real-life actions must affect visible game outcomes, not just show labels. HP, starting gold, attack damage, and first-turn draw were already connected. The next missing Phase 3 item was card reward weighting.

### Change

- `lib/data/core_loop_rules.dart`
  - Added `cardRewardCategoryWeightsFor()` to convert `DailyModifier.defenseCardWeightBonus` and `magicCardWeightBonus` into reward category weights.
  - Added `pickCardRewardCategory()` so card reward UI can select only from categories that actually exist in the current rarity pool.
- `lib/screens/dungeon/card_battle_screen.dart`
  - Victory card choices now read `DungeonState.dailyModifier`.
  - Defense/magic daily bonuses now bias the card reward category pool before choosing the final card.
- `test/data/core_loop_rules_test.dart`
  - Added tests for category weight calculation and available-category picker safety.
- `docs/lifequest-remake-execution-checklist-20260516.md`
  - Marked card reward weighting as complete.

### Verification

- `flutter analyze --no-pub` -> No issues found.
- `flutter test --no-pub test/data/core_loop_rules_test.dart` -> 8 tests passed.

### Remaining risk

- Event choice chance, shop discount, and rest recovery modifiers are still not wired.
- Card reward weighting is probabilistic; the current test verifies rule shape and category safety, not long-run statistical distribution.

---

## 2026-05-19 KST - DailyModifier shop and rest effects

### Purpose

Continue Phase 3 of the remake plan: real-life action modifiers should affect the dungeon beyond combat. Charisma should make the shop feel better, and health/recovery actions should make rest nodes more valuable.

### Change

- `lib/data/core_loop_rules.dart`
  - Added `DailyModifier.shopDiscountRate`.
  - Added `DailyModifier.restHealPercentBonus`.
  - Added `discountedDungeonPrice()` helper.
  - Added `restHealPercentFor()` helper.
  - Persisted both new fields through `DailyModifier.toJson()` / `fromJson()`.
- `lib/screens/dungeon/dungeon_shop_screen.dart`
  - Card, relic, and card-removal prices now use `DungeonState.dailyModifier` discount.
- `lib/screens/dungeon/dungeon_rest_screen.dart`
  - Normal rest healing now uses the daily rest heal bonus.
  - Full-heal relic behavior remains unchanged.
- `test/data/core_loop_rules_test.dart`
  - Added discount/rest helper tests.
  - Added serialization regression test for the new modifier fields.
- `docs/lifequest-remake-execution-checklist-20260516.md`
  - Marked shop discount and rest recovery modifier work as complete.

### Verification

- `flutter analyze --no-pub` -> No issues found.
- `flutter test --no-pub test/data/core_loop_rules_test.dart test/state/dungeon_state_test.dart` -> 14 tests passed.

### Remaining risk

- Shop UI currently shows only the final discounted price, not the original price or discount reason. This is functionally correct but less explanatory than the target product direction.

---

## 2026-05-19 KST - DailyModifier event outcome bias

### Purpose

Finish the remaining Phase 3 modifier wiring: charisma/event bonuses should affect actual dungeon events, not only appear as a label.

### Change

- `lib/data/core_loop_rules.dart`
  - Added `eventOutcomeScore()` to rank event outcomes by gold, HP, card/relic reward, card removal, upgrade, and curse penalties.
  - Added `pickEventOutcome()` so `DailyModifier.eventOptionBonusChance` can bias a choice toward the best available outcome.
- `lib/screens/dungeon/dungeon_event_screen.dart`
  - Event choices now pick outcomes through `CoreLoopRules.pickEventOutcome()`.
  - Existing title-unlocked extra choices remain intact.
- `test/data/core_loop_rules_test.dart`
  - Added tests for outcome scoring and forced best-outcome selection.
- `docs/lifequest-remake-execution-checklist-20260516.md`
  - Marked event option modifier wiring complete.

### Verification

- `flutter analyze --no-pub` -> No issues found.
- `flutter test --no-pub test/data/core_loop_rules_test.dart` -> 12 tests passed.
- `flutter test --no-pub` -> 115 tests passed.

### Remaining risk

- The current event modifier affects random outcome quality inside a selected choice. It does not yet add visible "bonus" labels or reorder choices, so the mechanic is functional but not fully explained to users.

---

## 2026-05-19 KST - DailyModifier snapshot regression coverage

### Purpose

Close the remaining Phase 3 safety gap: real-life quest bonuses should be visible and meaningful, but a dungeon run must keep the modifier snapshot it started with. Mid-run quest changes should affect the next run, not silently rebalance the current one.

### Change

- `test/state/dungeon_state_test.dart`
  - Added a regression test proving the current run keeps its original `DailyModifier`.
  - Added the next-run assertion proving a newly calculated modifier applies only when `startRun()` is called again.
- `docs/lifequest-remake-execution-checklist-20260516.md`
  - Reconciled Phase 3 implementation, file, and snapshot-test checklist items with the actual code state.

### Verification

- `flutter analyze --no-pub` -> No issues found.
- `flutter test --no-pub test/state/dungeon_state_test.dart` -> 5 tests passed.
- `flutter test --no-pub` -> 116 tests passed.

---

## 2026-05-19 KST - Expanded title-driven event choices

### Purpose

Address tester feedback that titles should not be cosmetic. More titles now open concrete dungeon event choices, so long-term real-life progress changes the available decisions inside events.

### Change

- `lib/data/title_unlock_rules.dart`
  - Expanded title event rules from 5 to 17.
  - Added level, stat, all-stat, quest-count, monthly raid, and yearly raid title choices.
  - Kept the existing `TitleUnlockRules.choicesFor()` integration path unchanged.
- `test/data/title_unlock_rules_test.dart`
  - Added coverage requiring at least 10 title-driven event choices.
  - Added content integrity coverage: every rule must point to an existing title and event, and must expose non-empty copy/outcomes.
- `docs/lifequest-remake-execution-checklist-20260516.md`
  - Marked the Phase 4 title-effect/event-rule expansion items complete.

### Verification

- `flutter analyze --no-pub` -> No issues found.
- `flutter test --no-pub test/data/title_unlock_rules_test.dart` -> 5 tests passed.
- `flutter test --no-pub` -> 118 tests passed.

---

## 2026-05-19 KST - Shop discount explanation UI

### Purpose

Close the Phase 3 UX gap where shop discounts were applied mechanically but not explained. Tester feedback repeatedly pointed out weak screen-to-screen connection; this change makes the real-life charisma/social modifier visible at the purchase point.

### Change

- `lib/screens/dungeon/dungeon_shop_screen.dart`
  - Added a daily shop discount banner when `DailyModifier.shopDiscountRate` is active.
  - Card, relic, and card-removal prices now show original price with a strikethrough plus the discounted price.
  - Reused a single `_ShopPriceButton` for card/relic/removal price display to keep the shop UI consistent.
- `docs/lifequest-remake-execution-checklist-20260516.md`
  - Marked Phase 3 completion conditions for actual dungeon impact and bounded balance complete.

### Verification

- `flutter analyze --no-pub` -> No issues found.
- `flutter test --no-pub` -> 118 tests passed.

---

## 2026-05-19 KST - Release monetization issue register

### Purpose

Continue current-source research for the remake goal without creating a loose research pile. The result is an issue register that directly affects release scope, monetization sequencing, and Play Store readiness.

### Sources

- Google Play Commerce guide: https://play.google.com/console/about/guides/play-commerce/
- Google Play subscriptions help: https://support.google.com/googleplay/android-developer/answer/12154973
- Google Play monetization policy: https://support.google.com/googleplay/android-developer/answer/16329168
- Android vitals: https://developer.android.com/topic/performance/vitals/index.html
- Large screen app quality: https://developer.android.com/docs/quality-guidelines/archive/adaptive/large-screen-app-quality
- Google Play Data safety help: https://support.google.com/googleplay/answer/11416267

### Change

- Added `docs/lifequest-release-monetization-issues-20260519.md`.
- Recorded five actionable issues:
  - Hybrid monetization should not start ad-first.
  - Subscription must have concrete entitlement, not vague support copy.
  - Android vitals and wake-lock behavior are release risks.
  - Phone-first UI still needs large-screen breakage checks.
  - Data safety must match Firebase/Crashlytics/Storage/AdMob/Billing reality.
- Updated the execution checklist to mark the current monetization/Android vitals research decisions as documented.

### Verification

- Documentation-only change. No code verification required.

---

## 2026-05-19 KST - Android release monetization gate

### Purpose

The active goal now treats the real Android app as the default release target, while the web build is only a tester preview. The current release direction says early release should not expose AdMob or billing until Data safety, consent, and premium value copy are finished, so the Android runtime needed a default-off gate rather than only web-preview hiding.

### Change

- Added `lib/config/monetization_config.dart` with `LIFEQUEST_MONETIZATION_ENABLED`, defaulting to `false`.
- Guarded `AdService` and `PurchaseService` startup so AdMob, UMP, and billing do not initialize in the default Android app build.
- Hid rewarded-ad entry points in quest completion, hunt AP recovery, combat victory/defeat, expanded reports, and settings unless monetization is explicitly enabled.
- Expanded reports remain available in the free default build instead of being locked behind an ad.
- Added `test/services/monetization_gate_test.dart` to lock the default-off behavior.

### Verification

- `flutter analyze --no-pub` -> No issues found.
- `flutter test --no-pub test/services/monetization_gate_test.dart` -> 2 tests passed.
- `flutter test --no-pub` -> 120 tests passed.

---

## 2026-05-19 KST - Android notification permission gate

### Purpose

Move another Google Play readiness item from research to code. The real Android app should not ask for notification permission on first launch; it should request that permission only when the user explicitly enables reminders.

### Source

- Android Developers target API guidance: https://developer.android.com/google/play/requirements/target-sdk

### Change

- `NotificationService.init()` no longer requests Android notification permission during startup.
- Added `NotificationService.requestNotificationPermission()` for explicit opt-in.
- New accounts and default local state now start with notifications disabled.
- `CharacterState.changeNotificationSetting(true)` requests permission before scheduling reminders.
- Documented the current build values: `compileSdk = 36`, `targetSdk = 35`.

### Verification

- `flutter analyze --no-pub` -> No issues found.
- `flutter test --no-pub test/state/character_state_test.dart` -> 23 tests passed.
- `flutter test --no-pub` -> 121 tests passed.

---

## 2026-05-19 KST - Android Data safety inventory

### Purpose

Continue Play Store readiness for the real Android app by mapping current SDKs, manifest permissions, and code paths to Google Play Data safety categories before rewriting the privacy policy or filling the Play Console form.

### Sources

- Google Play Data safety form guidance: https://support.google.com/googleplay/android-developer/answer/10787469
- Google Play user-facing Data safety categories: https://support.google.com/googleplay/answer/11416267
- Firebase privacy and security: https://firebase.google.com/support/privacy

### Change

- Added `docs/lifequest-data-safety-inventory-20260519.md`.
- Mapped Firebase Auth, Google Sign-In, Firestore, Storage, Crashlytics, App Check, local preferences, home widget, local notifications, image picker, AdMob, Billing, URL launcher, and unused Cloud Functions dependency.
- Marked only the M-05 inventory criterion complete; privacy policy rewrite, Firebase rules review, and final Play Console Data safety entry remain blocked.
- Recorded privacy policy gaps: Korean text encoding corruption, placeholder contact email, Firebase Analytics claim mismatch, and AdMob/Billing copy mismatch with the default-off monetization gate.

### Verification

- Documentation-only change; verified with `git diff --check`.

---

## 2026-05-19 KST - Android privacy policy refresh

### Purpose

Close the policy mismatch found by the Android Data safety inventory. The previous policy had visible Korean encoding corruption, placeholder contact text, an inactive Firebase Analytics claim, and active AdMob/Billing wording even though monetization is disabled by default.

### Change

- Rewrote `PRIVACY_POLICY.md` in Korean and English for the real Android release app.
- Rewrote `docs/index.html`, which is the public policy/account-deletion page linked from app settings.
- Documented that QA Preview is a tester preview, not the production Android app.
- Documented current data handling for Firebase Auth, Google Sign-In, Firestore, optional Storage profile image upload, Crashlytics, App Check, local settings, home widget, local notifications, and default-disabled Ads/Billing.
- Marked the privacy policy draft aligned with the current default Android Data safety inventory; final Play Console URL/Data safety consistency check remains open.

### Verification

- Documentation/static HTML change; verified with `git diff --check`.

---

## 2026-05-19 KST - Firebase rules and account deletion alignment

### Purpose

Make the real Android app's Firebase behavior match the refreshed privacy policy. The local Firestore rules did not allow account document deletion, there was no repository Storage rules file for optional profile images, and the account deletion flow did not attempt Storage cleanup.

### Change

- Updated `firestore.rules` to keep owner-only access while allowing owner deletion of `users/{uid}`.
- Added `storage.rules` for owner-only `users/{uid}/profile.jpg` read/create/update/delete, image MIME types, and a 2 MiB upload limit.
- Wired Storage rules into `firebase.json`.
- Updated `CharacterState.deleteAccount()` to delete the optional profile image and known `_meta/adServerTime` document before deleting the Firestore user document and Auth account.
- Added `docs/lifequest-firebase-rules-review-20260519.md`.

### Verification

- `dart format lib/state/character_state.dart` -> formatted, no file changes.
- `flutter analyze --no-pub` -> No issues found.
- `flutter test --no-pub test/state/character_state_test.dart` -> 23 tests passed.
- `flutter test --no-pub` -> 121 tests passed.
- `node -e "JSON.parse(...firebase.json...)"` -> `firebase.json ok`.
- `firebase emulators:exec --only firestore "cmd /c echo firebase-rules-ok"` -> Firestore emulator started and script exited successfully.
- `firebase emulators:exec --only storage "cmd /c echo storage-rules-ok"` -> Storage emulator started and script exited successfully.

---

## 2026-05-20 KST - Live Firebase rules deployment

### Purpose

Close the gap between repository rules and the live Firebase project for the real Android release path.

### Change

- Deployed Firestore rules to `life-quest-app-95eb9`.
- Deployed Storage rules to `life-quest-app-95eb9`.
- Updated release documentation to mark live rules deployment complete while keeping authenticated Android account deletion smoke testing open.

### Verification

- `firebase deploy --only firestore:rules,storage --project life-quest-app-95eb9` -> `firestore.rules` compiled successfully and released to `cloud.firestore`.
- `firebase deploy --only storage --project life-quest-app-95eb9` -> `storage.rules` compiled successfully and released to `firebase.storage`.

---

## 2026-05-20 KST - Account deletion failure handling

### Purpose

Tighten the remaining account deletion release path before a device smoke test. The settings screen previously navigated back to the first route after calling deletion even if `CharacterState.deleteAccount()` failed.

### Change

- `CharacterState.deleteAccount()` now returns a success boolean.
- Settings only navigates away after a confirmed deletion success.
- Added readable Korean/Japanese/Chinese deletion failure fallback messages before the older garbled fallback switch can be reached.

### Verification

- `dart format lib/state/character_state.dart lib/screens/settings_screen.dart` -> formatted.
- `flutter analyze --no-pub` -> No issues found.
- `flutter test --no-pub test/state/character_state_test.dart` -> 23 tests passed.
- `flutter test --no-pub` -> 121 tests passed.
- `git diff --check` -> no whitespace errors.
