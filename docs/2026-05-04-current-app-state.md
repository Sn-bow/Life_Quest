# Life Quest 현재 앱 상태 기록

작성일: 2026-05-04  
작성 목적: 정식 배포 준비 전 현재 상태를 Claude/Codex가 동일하게 이해하기 위한 기준점

---

## 1. 프로젝트 개요

- 앱 이름: Life Quest
- 목적: 일상 퀘스트 관리와 RPG 성장, Soul Deck 카드 전투를 결합한 Android 앱
- 프레임워크: Flutter/Dart
- 게임 엔진: Flame
- 상태 관리: Provider
- 백엔드: Firebase Auth, Firestore, Storage, App Check, Crashlytics
- 플랫폼: Android 전용
- Android applicationId: `com.lifequest.app`
- Dart package name: `life_quest_final_v2`
- 버전: `1.0.1+2` (`pubspec.yaml`)

---

## 2. 빌드/테스트 명령

```bash
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
flutter build appbundle --release
```

기존 문서상 최근 기록:

- `flutter analyze`: No issues found
- `flutter test`: 73~76개 통과 기록이 문서별로 혼재
- `flutter build appbundle --release`: 성공 기록, AAB 약 64MB

주의:

- 이 문서 작성 시점에는 코드 변경 없이 문서 추가만 진행했다.
- 다음 실제 구현 착수 전에는 `flutter analyze`와 `flutter test`를 다시 실행해 기준을 갱신해야 한다.

---

## 3. 주요 기능 상태

### 생활 관리

- 퀘스트 생성/완료/보상
- 캐릭터 레벨/스탯 성장
- 장비/인벤토리
- 상점/IAP 구조
- 업적/칭호/스킬
- 리포트/타이머
- 알림/홈 위젯
- 다국어 지원

### Soul Deck

- 카드 데이터 207장
- 카드 카테고리: Attack, Magic, Defense, Tactical
- 카드 희귀도: Common, Uncommon, Rare, Legendary
- 전투 상태: `lib/state/card_combat_state.dart`
- 던전 상태: `lib/state/dungeon_state.dart`
- 전투 화면: `lib/screens/dungeon/card_battle_screen.dart`
- 던전 화면 9개:
  - `dungeon_home_screen.dart`
  - `dungeon_map_screen.dart`
  - `card_battle_screen.dart`
  - `dungeon_event_screen.dart`
  - `dungeon_shop_screen.dart`
  - `dungeon_rest_screen.dart`
  - `dungeon_result_screen.dart`
  - `card_collection_screen.dart`
  - `infinite_tower_screen.dart`

---

## 4. 에셋 상태

### 존재하는 핵심 에셋

- 앱 아이콘/스플래시: `assets/images/`
- 몬스터 PNG: `assets/images/monsters/`
- 존 배경 PNG 5종: `assets/images/backgrounds/`
- 카드 프레임 PNG 4종: `assets/images/cards/`
- 플레이어 이미지 일부: `assets/images/player/hero_idle.png`
- 유물 PNG 다수: `assets/images/game/relics/`
- UI 소형 PNG: `assets/images/ui/`
- SFX/BGM: `assets/sounds/`, `assets/sounds/sfx/`, `assets/sounds/game/`, `assets/sounds/bgm/`

### 비어 있거나 실사용 미흡한 에셋 디렉터리

- `assets/images/game/player/`: `.gitkeep`만 있음
- `assets/images/game/monsters/`: `.gitkeep`만 있음
- `assets/images/game/backgrounds/`: `.gitkeep`만 있음
- `assets/images/game/effects/`: `.gitkeep`만 있음
- `assets/images/game/cards/frames/`: `.gitkeep`만 있음
- `assets/images/game/map/`: `.gitkeep`만 있음

판정:

- 몬스터/배경/카드 프레임은 실제 PNG가 이미 있으므로 이를 우선 활용해야 한다.
- `assets/images/game/*` 하위는 선언만 있고 내용이 비어 있어, 에셋 로드 설계와 실제 파일 위치를 정리해야 한다.

---

## 5. 확인된 문제

### P0

- 정식 배포용 게임 비주얼 품질 부족: `PlayerBattleSprite`, `MonsterBattleSprite`, `BattleGame` 이펙트에 도형 기반 렌더링이 남아 있다.
- 실제 기기 QA 기록 부족: Firebase, AdMob, IAP, 알림, 홈 위젯, Flame 렌더링 검증 필요.
- Play Console/Firebase/AdMob/IAP 수동 작업 남음.
- 일부 기존 문서가 인코딩 깨짐 상태라 공유 지식으로 쓰기 어렵다.

### P1

- 카드 UI 컴포넌트가 화면별로 분산되어 일관성이 약하다.
- 카드별 고유 일러스트가 부족하다.
- 카드/몬스터/유물 밸런스 플레이테스트 기록이 없다.
- 튜토리얼/키워드 도움말이 부족하다.
- 전투 사운드와 햅틱 피드백 연결이 불완전할 수 있다.

### P2

- 던전 맵 노드 비주얼 강화 필요.
- 상점/휴식/이벤트 화면의 게임적 몰입감 개선 필요.
- 스토어 스크린샷/피처 그래픽/프로모션 자료 정리 필요.

---

## 6. 현재 git 상태 참고

문서 작성 전 `git status --short`에서 확인된 사항:

- `.claude/settings.local.json` 수정됨
- `.claude/worktrees/*` 변경/미추적 있음
- `docs/2026-05-04-game-redesign-master-plan.md` 미추적
- `docs/2026-05-04-sts2-research.md` 미추적
- `scripts/generate_relics.py` 미추적
- `scripts/generate_test_slime_sts2.py` 미추적

주의:

- 위 항목들은 기존 사용자/다른 에이전트 작업일 수 있으므로 임의로 되돌리지 않는다.
- 이번 작업은 새 문서 추가 중심으로 진행한다.

---

## 7. 다음 착수 우선순위

1. `docs/game-asset-inventory.md` 작성
2. 도형 기반 비주얼 사용 위치 전체 목록화
3. 몬스터 PNG를 전투 화면에 직접 연결
4. 플레이어 에셋 생성/적용 계획 확정
5. 공통 카드 컴포넌트 설계
6. `flutter analyze`, `flutter test` 기준 갱신
