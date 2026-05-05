# Life Quest 게임 에셋 인벤토리

작성일: 2026-05-04  
목적: 정식 배포 전 Soul Deck 전투/게임 화면을 단순 도형 기반이 아닌 실제 에셋 기반 비주얼로 전환하기 위한 기준 목록

---

## 1. 적용 원칙

- 플레이어, 몬스터, 전투 이펙트, 카드 프레임, 배경의 최종 비주얼은 PNG/sprite sheet 등 실제 에셋을 우선 사용한다.
- `CustomPainter`, `Canvas.drawLine`, `drawCircle`, `drawRect`, `drawPath`로 만든 단순 도형은 최종 캐릭터/몬스터/카드/전투 이펙트 비주얼로 사용하지 않는다.
- 단순 도형은 배경 보조 파티클, 연결선, 디버그 fallback처럼 제품 핵심 아트가 아닌 곳에서만 제한적으로 허용한다.
- 에셋을 추가하거나 연결하면 반드시 존재 테스트를 추가해 누락을 막는다.

---

## 2. 현재 에셋 현황

| 분류 | 경로 | 상태 | 판정 |
|---|---|---:|---|
| 앱 아이콘/스플래시 | `assets/images/` | 다수 존재 | 사용 가능 |
| 전투 배경 | `assets/images/backgrounds/` | 5개 PNG | 사용 가능 |
| 카드 프레임 | `assets/images/cards/` | 4개 PNG | 공통 카드 컴포넌트 작성, 카드 팩 화면 적용 완료 |
| 카드별 중앙 삽화 | `assets/images/game/cards/art/` | 샘플 11장 PNG | starter/common 샘플 적용 완료, 실기기 카드 화면 QA 필요 |
| 몬스터 | `assets/images/monsters/` | 31개 PNG | 전투 렌더링 적용 완료 |
| 플레이어 | `assets/images/player/hero_idle.png` | 1개 PNG | 전투/프로필 적용 완료, 상태별 에셋 부족 |
| 전투 이펙트 | `assets/images/game/effects/` | 4개 PNG | 공격/방어/마법/처치 적용 완료 |
| 유물 | `assets/images/game/relics/` | 31개 이상 PNG | 사용 가능, 화면별 연결 검증 필요 |
| 카드 아이콘 | `assets/images/game/cards/icons/` | 4개 PNG | 사용 가능 |
| 게임 맵 | `assets/images/game/map/` | `.gitkeep`만 존재 | 부족 |
| SFX | `assets/sounds/sfx/`, `assets/sounds/game/` | 다수 존재 | 연결 검증 필요 |
| BGM | `assets/sounds/bgm/` | 1개 MP3 | 부분 사용 가능 |

---

## 3. 이번 적용 완료

### 몬스터

- `lib/widgets/combat/monster_battle_sprite.dart`
- `MonsterDatabase`의 모든 기본 몬스터/보스 `spritePath`를 `Image.asset(monster.spritePath)`로 렌더링하도록 변경했다.
- 사망/피격 fallback은 남겼지만, 배포 경로에서 누락되지 않도록 테스트로 방지한다.
- 검증: `test/data/monster_assets_test.dart`

### 플레이어

- `lib/widgets/combat/player_battle_sprite.dart`
- `lib/widgets/player_profile_sprite.dart`
- `assets/images/player/hero_idle.png`를 전투 화면과 카드 전투 프로필에 적용했다.
- 기존 생성자 파라미터는 호출부 호환을 위해 유지하되, 제거된 아바타/커스터마이징 기능을 되살리지 않도록 외형 파라미터는 최종 렌더에 반영하지 않는다.
- 검증: `test/data/player_assets_test.dart`

### 전투 이펙트

- `lib/game/battle_game.dart`
- `tools/generate_battle_effect_assets.ps1`
- 공격/방어/마법 투사체/적 처치 이펙트를 PNG 에셋 기반 Flame sprite 렌더링으로 교체했다.
- 생성된 에셋:
  - `assets/images/game/effects/effect_attack_slash.png`
  - `assets/images/game/effects/effect_defense_shield.png`
  - `assets/images/game/effects/effect_magic_projectile.png`
  - `assets/images/game/effects/effect_enemy_death_burst.png`
- 검증: `test/data/battle_effect_assets_test.dart`

### 카드 프레임

- `lib/widgets/soul_deck_card_view.dart`
- `lib/screens/dungeon/card_pack_screen.dart`
- `lib/screens/dungeon/card_battle_screen.dart`
- `lib/screens/dungeon/card_collection_screen.dart`
- `lib/screens/dungeon/dungeon_rest_screen.dart`
- `lib/screens/dungeon/dungeon_shop_screen.dart`
- 기존 카드 팩의 단순 컨테이너형 카드 타일을 `assets/images/cards/card_frame_*.png`와 `assets/images/game/cards/icons/icon_*.png` 기반 공통 카드 위젯으로 교체했다.
- **전 화면 통합 완료 (2026-05-04)**: 카드가 등장하는 모든 화면(전투 손패, 전투 보상, 카드 컬렉션, 던전 상점, 휴식 업그레이드)이 `SoulDeckCardView` 단일 컴포넌트를 사용한다. `SoulDeckCardSize.hand/reward/mini` 3종 제공.
- **QA 수행 (2026-05-05)**:
  - PNG alpha 채널 확인: 프레임 4종 + 아이콘 4종 모두 RGBA colorType=6. 투명 배경 정상.
  - 코드 레벨 레이아웃 분석: 6개 화면 overflow/clipping 위험 없음.
  - 버그 수정 1: `card_pack_screen.dart` 선택 테두리 카드 프레임 불일치(100px→94px, radius 12→8).
  - 버그 수정 2: `card_battle_screen.dart` `_VictoryRewardOverlay` 수평 오버플로우 — Container width 320→330 (내부 Row 280→290px, 3카드 282px에 여유 확보).
  - 실기기 화면 QA: APK 설치/실행 확인. 디버그 APK 재설치로 로그인 세션 초기화됨. 재로그인 후 **사용자 직접 확인 필요**.
- 검증: `test/data/card_frame_assets_test.dart`

### 카드별 중앙 삽화

- `docs/card-art-generation-plan.md`
- `lib/data/card_art_assets.dart`
- `lib/widgets/soul_deck_card_view.dart`
- `assets/images/game/cards/art/`
- 샘플 11장 카드에 대해 내장 이미지 생성 기능으로 중앙 삽화를 생성하고 카드별 PNG로 분할 저장했다.
- 샘플 카드 id:
  - `base_strike`, `base_defend`, `base_focus`
  - `atk_c01`, `atk_c02`
  - `def_c01`, `def_c02`
  - `mag_c01`, `mag_c02`
  - `tac_c01`, `tac_c02`
- `SoulDeckCardView`는 샘플 카드 삽화가 있으면 중앙 이미지로 표시하고, 파일이 없거나 샘플 외 카드면 기존 카테고리 아이콘으로 fallback한다.
- 중앙 삽화 영역: hand 64px / reward 48px / mini 32px (PNG 생성 후 Codex가 확대 적용).
- QA용 contact sheet: `docs/card_art_sample_contact_sheet.png` — 11장 다크 판타지 스타일, 어두운 배경, 텍스트/프레임 없음 육안 확인 ✅
- **코드 레벨 QA 수행 (2026-05-05)**: 레이아웃 overflow 없음 / tactical overlay가 아트 미차단 / spritePath→artPath 로직 정확 / `flutter analyze 0건, +7 tests passed` 확인.
- **실기기 QA**: APK 설치 확인, 로그인 화면 도달. 던전 내부 화면(손패/보상/컬렉션/상점/휴식)은 **사용자 직접 확인 필요** (로그인 자격증명 미보유).
- 검증: `test/data/card_art_assets_test.dart`

---

## 4. 남은 도형 기반 비주얼

| 파일 | 위치 | 현재 사용 | 우선순위 | 처리 방향 |
|---|---|---|---|---|
| `lib/game/battle_game.dart` | `_ParallaxLayer` | 배경 보조 원형 파티클 | P2 | 핵심 아트는 아니지만, 추후 zone별 배경 오버레이 PNG로 교체 권장 |
| `lib/game/battle_game.dart` | `_ShieldFlash` | 블록 보조 링 | P2 | 방어 PNG가 주 효과이므로 보조로 허용, 추후 sprite sheet화 가능 |
| `lib/screens/dungeon/dungeon_map_screen.dart` | `_ConnectionPainter` | 던전 맵 노드 연결선 | P2 | 지도 에셋/타일 기반 라인으로 교체 검토 |

---

## 5. 다음 작업

1. ~~`SoulDeckCardView`를 카드 전투 손패/전투 보상/컬렉션/상점/휴식 업그레이드 화면까지 확장한다.~~ ✅ **완료 (2026-05-04)**
2. **[우선]** 사용자 직접 던전 진입 → 카드팩/전투/컬렉션/상점/휴식 화면 시각 QA. 이상 발견 시 즉시 수정.
3. **[우선]** Codex에 STS2 타입별 하단 모양(공격=사다리꼴, 스킬=직사각형, 파워=타원) 적용 카드 프레임 4종 재생성 의뢰.
4. ~~샘플 11장 삽화 코드 레벨 QA.~~ ✅ **완료 (2026-05-05)** — 실기기 던전 화면 직접 확인은 미완료.
5. 샘플 QA 통과 후 common 전체 카드 삽화 생성 계획 확장.
6. 플레이어 상태별 PNG 또는 sprite sheet를 추가한다: `attack`, `defend`, `cast`, `hit`, `victory`.
7. 전투 이펙트는 현재 단일 PNG 기반이므로, 다음 단계에서 프레임별 sprite sheet와 SFX 타이밍을 붙인다.
8. 던전 맵은 노드/연결선/현재 위치를 이미지 기반으로 고도화한다.
