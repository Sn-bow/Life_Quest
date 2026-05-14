# Soul Deck 카드 전체 바디 이미지 생성 계획

작성일: 2026-05-07  
목적: "프레임 PNG + 중앙 삽화 PNG 조립" 방식을 "카드 전체 바디 이미지 + Flutter 텍스트 오버레이" 방식으로 전환한다.

---

## 1. 핵심 결정

### 변경 이유

기존 방식의 문제:
- 카드 프레임(외곽 테두리)과 중앙 삽화(내부 아트)가 별도 PNG로 생성되어 분리감이 있다.
- 프레임 PNG의 디자인 언어와 삽화 PNG의 스타일이 자연스럽게 어우러지지 않는다.
- 프레임 배경 + 투명 오버레이 + 삽화 레이어의 3단 조립은 불필요한 복잡도를 만든다.

새 방식:
- **카드 한 장 전체를 하나의 바디 이미지로 표현한다.**
- 상단 ~55% 영역: 주 삽화 (드라마틱, 중심 오브젝트 구도)
- 하단 ~45% 영역: 자연스럽게 어두워지는 그라디언트 (텍스트 가독성 확보)
- Flutter가 비용 젬, 카드명, 효과 설명, 희귀도 레이블을 런타임에 오버레이한다.

### 유지되는 원칙

- 이미지 안에 카드명, 비용 숫자, 설명 텍스트, 희귀도 레이블을 넣지 않는다.
- 텍스트는 항상 Flutter UI가 렌더링한다 (다국어 + 동적 수치 대응).
- 기존 프레임/삽화 에셋은 즉시 삭제하지 않는다. 바디 이미지가 등록되기 전까지 `SoulDeckCardView`가 레거시 레이아웃으로 자동 fallback한다.

---

## 2. 이미지 사양

| 항목 | 값 |
|---|---|
| 파일 형식 | PNG (RGBA) |
| 픽셀 크기 | 440 × 616 px |
| 종횡비 | ≈ 0.714 (카드 표시 비율과 일치) |
| 상단 구도 | 주 삽화 영역 (전체 높이의 약 55%) |
| 하단 구도 | 자연스럽게 어두워지는 배경 (전체 높이의 약 45%) |
| 텍스트 금지 | 카드명, 비용, 설명, 수치, 로고, 워터마크 일체 금지 |
| 프레임 금지 | 카드 테두리 선, 희귀도 라인 금지 |
| 생성 방식 | Codex 내장 이미지 생성 기능 (OPENAI_API_KEY 불필요) |

---

## 3. 에셋 경로 정책

```text
assets/images/game/cards/full_body/card_body_{category}_{rarity}.png
```

- category: `attack` / `defense` / `magic` / `tactical`
- rarity: `common` / `uncommon` / `rare` / `legendary`
- 총 16장 (4 × 4)

### 우선순위

| 단계 | 대상 | 이유 |
|---|---|---|
| 1차 | common 4장 | 전체 카드의 80% 이상이 common. 즉시 개선 효과 최대. |
| 2차 | uncommon 4장 | 보상/상점에서 자주 노출. |
| 3차 | rare 4장 | 빌드 핵심 카드. 화려하게 생성. |
| 4차 | legendary 4장 | 소수지만 임팩트가 가장 큰 카드. |

### 2026-05-07 적용 상태

1차 common 4장은 Codex 내장 이미지 생성 기능으로 생성하고 440×616 px로 정규화해 프로젝트에 등록했다.

| 파일 | 상태 |
|---|---|
| `assets/images/game/cards/full_body/card_body_attack_common.png` | 생성/등록 완료 |
| `assets/images/game/cards/full_body/card_body_defense_common.png` | 생성/등록 완료 |
| `assets/images/game/cards/full_body/card_body_magic_common.png` | 생성/등록 완료 |
| `assets/images/game/cards/full_body/card_body_tactical_common.png` | 생성/등록 완료 |

QA용 contact sheet: `docs/card_body_common_contact.png`

---

## 4. 공통 image2 프롬프트 규칙

모든 바디 이미지 프롬프트에 적용한다.

```text
Use case: stylized-concept
Asset type: roguelike deckbuilder card full body background
Format: portrait composition 440×616, aspect ratio 0.714
Upper half: main illustration zone — dramatic centered subject, dark fantasy art
Lower half: naturally darkens toward bottom — creates gradient zone for text overlay
Style: original dark fantasy mobile game illustration, painterly, readable at small size
Lighting: dramatic contrast, atmospheric glow matching card theme
Constraints: no text, no numbers, no letters, no cost gem, no rarity label,
             no card frame border line, no logo, no watermark,
             no direct Slay the Spire copy, no copyrighted character
Avoid: flat vector icon, simple geometric placeholder, crude sketch,
       stock icon, emoji, excessive bloom, cluttered background,
       readable rune or symbol that could be mistaken for text
```

---

## 5. 카테고리별 생성 계획 (1차: common 4장)

### 5-1. `card_body_attack_common.png`

- 저장 경로: `assets/images/game/cards/full_body/card_body_attack_common.png`
- 테마: 공격 — 붉은 전투 에너지, 날카로운 도검/슬래시
- 색조: 적색 계열 (#{E53935} 계열)

```text
Use case: stylized-concept
Asset type: roguelike deckbuilder card full body background, portrait 440x616
Upper half: a battle-worn iron sword crossing a dramatic red slash arc, centered,
            dark battlefield haze in background, no characters
Lower half: darkens naturally toward deep crimson and black at the bottom,
            smooth gradient zone for text readability
Style: original dark fantasy mobile game illustration, painterly, readable at small size
Lighting: intense red-orange combat spark lighting, high contrast
Constraints: no text, no numbers, no letters, no cost gem, no rarity border,
             no card frame line, no logo, no watermark
Avoid: flat icon, excessive glow, cluttered background, anime style
```

### 5-2. `card_body_defense_common.png`

- 저장 경로: `assets/images/game/cards/full_body/card_body_defense_common.png`
- 테마: 방어 — 차가운 청색 보호 에너지, 방패
- 색조: 청색 계열 (#{1E88E5} 계열)

```text
Use case: stylized-concept
Asset type: roguelike deckbuilder card full body background, portrait 440x616
Upper half: a sturdy kite shield surrounded by a faint translucent blue barrier,
            dungeon corridor background, no characters
Lower half: darkens naturally toward deep navy and black at the bottom,
            smooth gradient zone for text readability
Style: original dark fantasy mobile game illustration, painterly, readable at small size
Lighting: cool calm blue glow, defensive and solid
Constraints: no text, no numbers, no letters, no cost gem, no rarity border,
             no card frame line, no logo, no watermark
Avoid: flat icon, sci-fi look, excessive bloom, clutter
```

### 5-3. `card_body_magic_common.png`

- 저장 경로: `assets/images/game/cards/full_body/card_body_magic_common.png`
- 테마: 마법 — 신비로운 보라/자색 아케인 에너지
- 색조: 보라색 계열 (#{AB47BC} 계열)

```text
Use case: stylized-concept
Asset type: roguelike deckbuilder card full body background, portrait 440x616
Upper half: an arcane magic circle releasing purple and violet energy, centered,
            dark arcane smoke background, no readable runes, no characters
Lower half: darkens naturally toward deep purple and black at the bottom,
            smooth gradient zone for text readability
Style: original dark fantasy mobile game illustration, painterly, readable at small size
Lighting: warm violet-purple arcane glow, restrained and atmospheric
Constraints: no text, no numbers, no letters, no readable runes or symbols,
             no cost gem, no rarity border, no card frame line, no logo, no watermark
Avoid: flat icon, readable magical text, excessive bloom, clutter
```

### 5-4. `card_body_tactical_common.png`

- 저장 경로: `assets/images/game/cards/full_body/card_body_tactical_common.png`
- 테마: 전술 — 차분한 녹색 계획 에너지, 지도/전술 도구
- 색조: 녹색 계열 (#{43A047} 계열)

```text
Use case: stylized-concept
Asset type: roguelike deckbuilder card full body background, portrait 440x616
Upper half: a brass compass and blank tactical map lit by a green lantern,
            centered on a dark adventurer table, no readable map markings
Lower half: darkens naturally toward deep forest green and black at the bottom,
            smooth gradient zone for text readability
Style: original dark fantasy mobile game illustration, painterly, readable at small size
Lighting: thoughtful green-gold planning glow, calm and strategic
Constraints: no text, no numbers, no letters, no readable map markings,
             no cost gem, no rarity border, no card frame line, no logo, no watermark
Avoid: flat icon, modern military look, readable text on map, clutter
```

---

## 6. 등록 방법 (생성 후 적용)

이미지를 `assets/images/game/cards/full_body/` 에 저장한 뒤, `lib/data/card_body_assets.dart`의 `_availableBodies` 집합에 키를 추가한다.

```dart
static const Set<String> _availableBodies = <String>{
  'attack_common',    // card_body_attack_common.png 추가 시
  'defense_common',   // card_body_defense_common.png 추가 시
  'magic_common',     // card_body_magic_common.png 추가 시
  'tactical_common',  // card_body_tactical_common.png 추가 시
};
```

키를 추가하면 `SoulDeckCardView`는 해당 카테고리+희귀도의 모든 카드에서 자동으로 full body 모드로 전환된다.

---

## 7. Flutter 텍스트 오버레이 구조 (full body 모드)

```
Stack
├── 카드 바디 이미지 (BoxFit.fill, ClipRRect radius 8)
├── 상단 그라디언트 스크림 (top → transparent, 약 30px)
├── 하단 그라디언트 스크림 (transparent → black 80%, 카드 높이의 46%)
├── Positioned(top): 비용 젬 + 카드명 (흰색 텍스트, shadow)
└── Positioned(bottom): 효과 설명 + 희귀도 레이블 (흰색 텍스트, shadow)
```

hand(110×154) / reward(94×142) / mini(72×108) 세 사이즈 모두 동일 구조.

---

## 8. QA 기준 (이미지 생성 후)

- [x] common 4장 PNG가 440×616 px로 정규화되어 있는지 (`card_body_assets_test.dart`)
- [x] `CardBodyAssets._availableBodies`에 common 4장 등록 완료
- [x] uncommon/rare/legendary 카드는 common 바디 이미지로 fallback되는지 (해당 희귀도 PNG 없을 때)
- [ ] `SoulDeckCardView.hand/reward/mini` 세 사이즈에서 비용 젬, 카드명, 설명이 이미지 위에 가독성 있게 표시되는지
- [ ] 하단 그라디언트 스크림이 설명 텍스트 뒤에서 충분한 대비를 제공하는지
- [ ] `hasBodyFor = false`인 카드는 레거시 레이아웃으로 정상 표시되는지
- [ ] Android 실기기 전투 손패/보상/컬렉션/상점/휴식 화면에서 레이아웃 깨짐 없는지

---

## 9. 레거시 에셋 처리 계획

| 에셋 | 현재 상태 | 처리 방향 |
|---|---|---|
| `assets/images/cards/card_frame_*.png` (4장) | 레거시 fallback으로 유지 | full body 전환 완료 후 pubspec 제거 |
| `assets/images/game/cards/art/*.png` (11장) | 레거시 fallback으로 유지 | full body 전환 완료 후 pubspec 제거 |
| `assets/images/game/cards/icons/icon_*.png` (4장) | 레거시 fallback으로 유지 | full body 전환 완료 후 pubspec 제거 |

---

## 10. 카드별 아트 매칭 확장 계획

테스터 피드백에서 `서리 화살`처럼 카드명과 공통 카테고리 바디가 맞지 않는 문제가 확인됐다. 공통 바디는 빠른 통일에는 유리하지만, 속성/서사 키워드가 강한 카드는 카드별 full-body 이미지가 필요하다.

### 런타임 구조

`CardBodyAssets.resolvedBodyPath(card)` 우선순위:

1. `assets/images/game/cards/full_body/by_card/card_body_{card_id}.png`
2. `assets/images/game/cards/full_body/card_body_{category}_{rarity}.png`
3. `assets/images/game/cards/full_body/card_body_{category}_common.png`
4. legacy frame/art fallback

### 파일 규칙

- 저장 경로: `assets/images/game/cards/full_body/by_card/`
- 파일명: `card_body_{card.id}.png`
- 예시:
  - `card_body_mag_c02.png`
  - `card_body_atk_u03.png`
  - `card_body_def_r02.png`

### 우선 생성 대상

1. 이름에 속성이 명확한 카드
   - 서리/얼음
   - 화염/불꽃
   - 독/부식
   - 빛/신성
   - 그림자/암흑
2. 기본 카드 3장
   - `base_strike`
   - `base_defend`
   - `base_focus`
3. 플레이어가 초반 10분 안에 자주 보는 common 카드

### 생성 원칙

- 카드 자체 full-body PNG를 생성한다.
- 프레임, 텍스트, 숫자, 비용 젬, 희귀도 라벨은 이미지에 넣지 않는다.
- 상단은 카드 주제 일러스트, 하단은 텍스트 가독성을 위한 어두운 자연 그라디언트.
- 카드명과 상충하는 추상 공통 이미지 사용 금지.
