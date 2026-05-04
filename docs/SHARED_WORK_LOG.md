# Life Quest 공유 작업 로그

목적: Claude와 Codex가 같은 작업 흐름을 이어받기 위한 단일 기록 문서  
규칙: 조사, 변경 파일, 검증 명령, 결과, 남은 위험을 매 작업마다 최신순으로 기록한다.

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
