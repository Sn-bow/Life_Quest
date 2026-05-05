# Soul Deck 카드 아트 생성 계획

작성일: 2026-05-05  
목적: 현재 카드 프레임/아이콘 중심 비주얼을 카드별 고유 삽화 기반으로 업그레이드한다.

---

## 1. 핵심 결정

카드 전체를 텍스트까지 포함한 완성 PNG로 만들지 않는다.

이유:

- Life Quest는 한국어/영어/일본어/중국어 다국어 구조를 사용한다.
- 카드 비용, 설명, 수치가 바뀔 때 이미지까지 다시 생성하면 유지보수 비용이 과도하다.
- 작은 Android 화면에서 이미지 안의 텍스트는 Flutter 텍스트보다 줄바꿈/가독성 제어가 어렵다.

따라서 image2는 다음에만 사용한다.

- 카드별 중앙 삽화 PNG
- 추후 category별 프레임 PNG
- 추후 rarity edge/glow PNG

Flutter가 계속 렌더링하는 요소:

- 카드명
- 비용
- 효과 설명
- 레어도
- 업그레이드 상태

---

## 2. 에셋 경로

샘플 카드 삽화 저장 위치:

```text
assets/images/game/cards/art/{cardId}.png
```

현재 샘플 11장만 코드 매핑한다.

매핑 코드:

- `lib/data/card_art_assets.dart`
- `lib/widgets/soul_deck_card_view.dart`

이미지가 없으면 `SoulDeckCardView`는 기존 카테고리 아이콘으로 fallback한다. 단, 최종 배포 전에는 샘플/확정 범위의 실제 PNG가 존재해야 한다.

---

## 3. 공통 image2 프롬프트 규칙

모든 프롬프트에 적용한다.

```text
Use case: stylized-concept
Asset type: roguelike deckbuilder card center art
Style/medium: original dark fantasy mobile game illustration, painterly but readable at small size, polished production asset
Composition/framing: single central object or action symbol, centered, clear silhouette, square composition, slight vignette, no border frame
Lighting/mood: dramatic game-card lighting, restrained glow, high contrast, not overexposed
Quality: high
Constraints: no text, no numbers, no letters, no UI, no card frame, no logo, no watermark, no copyrighted character, no direct Slay the Spire copy
Avoid: flat vector icon, simple geometric placeholder, crude sketch, stock icon, emoji, excessive bloom, cluttered background, readable text
```

생성 방식:

- 이 Codex 대화 환경의 내장 이미지 생성 기능을 사용한다.
- `OPENAI_API_KEY`를 요구하지 않는다.
- 생성 이미지는 기본 생성 폴더에 원본을 남기고, 프로젝트에는 필요한 카드별 PNG만 복사/분할 저장한다.

현재 생성 상태:

- 2026-05-05: 샘플 11장 생성 및 분할 저장 완료.
- 원본 생성 시트는 `C:\Users\wjd54\.codex\generated_images\019dee9e-c5ee-7791-a88e-40c0d4b07383\`에 보존.
- 프로젝트 저장 경로는 `assets/images/game/cards/art/{cardId}.png`.
- QA용 contact sheet: `docs/card_art_sample_contact_sheet.png`.

---

## 4. 샘플 11장

### 1. `base_strike`

- 분류: starter / attack
- 콘셉트: 기본 검격, 낡았지만 명확한 첫 공격
- 저장 경로: `assets/images/game/cards/art/base_strike.png`
- 프롬프트:

```text
Use case: stylized-concept
Asset type: roguelike deckbuilder card center art
Primary request: a worn adventurer sword cutting through the air with a clean white slash trail
Scene/background: dark muted battlefield haze, no characters
Subject: single iron sword and sharp slash arc
Style/medium: original dark fantasy mobile game illustration, painterly, readable at small size
Composition/framing: centered sword diagonal, clear silhouette, square composition, no border frame
Lighting/mood: restrained red-orange combat spark lighting
Constraints: no text, no numbers, no letters, no UI, no card frame, no logo, no watermark, no direct Slay the Spire copy
Avoid: flat vector icon, emoji, crude sketch, excessive bloom, clutter
```

### 2. `base_defend`

- 분류: starter / defense
- 콘셉트: 기본 방어, 초보 모험가의 단단한 방패
- 저장 경로: `assets/images/game/cards/art/base_defend.png`
- 프롬프트:

```text
Use case: stylized-concept
Asset type: roguelike deckbuilder card center art
Primary request: a weathered round shield absorbing a small incoming impact
Scene/background: cool smoky dungeon background, no characters
Subject: single round shield with subtle blue protective sparks
Style/medium: original dark fantasy mobile game illustration, painterly, readable at small size
Composition/framing: centered shield, strong silhouette, square composition, no border frame
Lighting/mood: calm blue defensive glow, restrained contrast
Constraints: no text, no numbers, no letters, no UI, no card frame, no logo, no watermark
Avoid: flat vector icon, emoji, crude sketch, excessive bloom, clutter
```

### 3. `base_focus`

- 분류: starter / tactical
- 콘셉트: 집중, 다음 행동을 준비하는 정신 에너지
- 저장 경로: `assets/images/game/cards/art/base_focus.png`
- 프롬프트:

```text
Use case: stylized-concept
Asset type: roguelike deckbuilder card center art
Primary request: a small floating blue mind-flame above an open adventurer journal
Scene/background: dim study-like dungeon table, no readable writing
Subject: glowing focus flame and open blank journal pages
Style/medium: original dark fantasy mobile game illustration, painterly, readable at small size
Composition/framing: centered still life, square composition, no border frame
Lighting/mood: quiet teal-blue concentration glow
Constraints: no text, no numbers, no letters, no readable marks, no UI, no card frame, no logo, no watermark
Avoid: flat vector icon, emoji, readable runes, clutter
```

### 4. `atk_c01`

- 분류: attack common
- 콘셉트: 강타, 무거운 일격
- 저장 경로: `assets/images/game/cards/art/atk_c01.png`
- 프롬프트:

```text
Use case: stylized-concept
Asset type: roguelike deckbuilder card center art
Primary request: a heavy iron blade smashing downward into cracked stone
Scene/background: dark dungeon floor, fragments flying
Subject: impact point of a powerful sword strike
Style/medium: original dark fantasy mobile game illustration, painterly, readable at small size
Composition/framing: centered impact, diagonal weapon motion, square composition, no border frame
Lighting/mood: red combat sparks and dust, strong impact
Constraints: no text, no numbers, no letters, no UI, no card frame, no logo, no watermark
Avoid: flat vector icon, emoji, crude sketch, excessive bloom, clutter
```

### 5. `atk_c02`

- 분류: attack common
- 콘셉트: 베기 + 카드 드로우, 빠른 절단 후 흐름 확보
- 저장 경로: `assets/images/game/cards/art/atk_c02.png`
- 프롬프트:

```text
Use case: stylized-concept
Asset type: roguelike deckbuilder card center art
Primary request: a swift curved dagger slash passing over three blank parchment cards
Scene/background: dark combat haze, no readable symbols
Subject: fast blade arc and blank cards swept by motion
Style/medium: original dark fantasy mobile game illustration, painterly, readable at small size
Composition/framing: centered sweeping motion, square composition, no border frame
Lighting/mood: sharp red-white slash light, agile motion
Constraints: no text, no numbers, no letters, no readable card markings, no UI, no card frame, no logo, no watermark
Avoid: flat vector icon, emoji, clutter, direct Slay the Spire copy
```

### 6. `def_c01`

- 분류: defense common
- 콘셉트: 방어, 안정적인 가드
- 저장 경로: `assets/images/game/cards/art/def_c01.png`
- 프롬프트:

```text
Use case: stylized-concept
Asset type: roguelike deckbuilder card center art
Primary request: a sturdy kite shield raised in front of a faint blue barrier
Scene/background: muted dungeon corridor, no characters
Subject: shield and translucent protective barrier
Style/medium: original dark fantasy mobile game illustration, painterly, readable at small size
Composition/framing: centered shield silhouette, square composition, no border frame
Lighting/mood: cool defensive blue, calm and solid
Constraints: no text, no numbers, no letters, no UI, no card frame, no logo, no watermark
Avoid: flat vector icon, emoji, crude sketch, clutter
```

### 7. `def_c02`

- 분류: defense common
- 콘셉트: 철벽, 높은 방어력
- 저장 경로: `assets/images/game/cards/art/def_c02.png`
- 프롬프트:

```text
Use case: stylized-concept
Asset type: roguelike deckbuilder card center art
Primary request: an interlocking wall of heavy steel shields forming an impenetrable barricade
Scene/background: dark stone passage, no soldiers visible
Subject: overlapping steel shields with blue edge light
Style/medium: original dark fantasy mobile game illustration, painterly, readable at small size
Composition/framing: centered shield wall, square composition, no border frame
Lighting/mood: cold blue steel, heavy and immovable
Constraints: no text, no numbers, no letters, no UI, no card frame, no logo, no watermark
Avoid: flat vector icon, emoji, clutter, sci-fi look
```

### 8. `mag_c01`

- 분류: magic common
- 콘셉트: 화염탄/화염 마법, 피해 + 화상
- 저장 경로: `assets/images/game/cards/art/mag_c01.png`
- 프롬프트:

```text
Use case: stylized-concept
Asset type: roguelike deckbuilder card center art
Primary request: a compact firebolt forming from a wizard's ember-red magic circle, no visible caster
Scene/background: dark arcane smoke, no readable runes
Subject: fire projectile and circular magical energy
Style/medium: original dark fantasy mobile game illustration, painterly, readable at small size
Composition/framing: centered firebolt, square composition, no border frame
Lighting/mood: warm orange flame with controlled glow
Constraints: no text, no numbers, no letters, no readable runes, no UI, no card frame, no logo, no watermark
Avoid: flat vector icon, emoji, excessive bloom, clutter
```

### 9. `mag_c02`

- 분류: magic common
- 콘셉트: 서리/약화 마법, 차가운 약화 효과
- 저장 경로: `assets/images/game/cards/art/mag_c02.png`
- 프롬프트:

```text
Use case: stylized-concept
Asset type: roguelike deckbuilder card center art
Primary request: a pale frost sigil releasing icy mist around a cracked dark crystal
Scene/background: cold arcane darkness, no readable symbols
Subject: frost sigil and weakened crystal
Style/medium: original dark fantasy mobile game illustration, painterly, readable at small size
Composition/framing: centered crystal and frost ring, square composition, no border frame
Lighting/mood: cold cyan and violet magic, brittle and weakening
Constraints: no text, no numbers, no letters, no readable runes, no UI, no card frame, no logo, no watermark
Avoid: flat vector icon, emoji, clutter, excessive bloom
```

### 10. `tac_c01`

- 분류: tactical common
- 콘셉트: 관찰/정찰, 상황 파악 후 드로우
- 저장 경로: `assets/images/game/cards/art/tac_c01.png`
- 프롬프트:

```text
Use case: stylized-concept
Asset type: roguelike deckbuilder card center art
Primary request: a brass spyglass and blank tactical map lit by a small green lantern
Scene/background: dark adventurer table, no readable map text
Subject: spyglass, blank map shapes, green planning light
Style/medium: original dark fantasy mobile game illustration, painterly, readable at small size
Composition/framing: centered tactical still life, square composition, no border frame
Lighting/mood: thoughtful green-gold planning glow
Constraints: no text, no numbers, no letters, no readable map markings, no UI, no card frame, no logo, no watermark
Avoid: flat vector icon, emoji, clutter, modern military look
```

### 11. `tac_c02`

- 분류: tactical common
- 콘셉트: 보물 탐색/전투 골드 획득
- 저장 경로: `assets/images/game/cards/art/tac_c02.png`
- 프롬프트:

```text
Use case: stylized-concept
Asset type: roguelike deckbuilder card center art
Primary request: a small open treasure pouch spilling a few glowing coins beside a dungeon key
Scene/background: dark stone floor, no readable markings
Subject: treasure pouch, coins, key, subtle green tactical glow
Style/medium: original dark fantasy mobile game illustration, painterly, readable at small size
Composition/framing: centered treasure still life, square composition, no border frame
Lighting/mood: warm gold highlights with restrained green planning accent
Constraints: no text, no numbers, no letters, no UI, no card frame, no logo, no watermark
Avoid: flat vector icon, emoji, clutter, cartoon coin pile, excessive sparkle
```

---

## 5. 적용 후 QA 기준

샘플 11장 생성 후 다음을 확인한다.

- `SoulDeckCardView.hand/reward/mini` 모두에서 삽화가 잘리지 않는지
- 카드명/비용/설명 텍스트가 이미지와 겹쳐 가독성을 해치지 않는지
- fallback 아이콘과 실제 삽화가 섞여도 화면이 깨지지 않는지
- tactical 카드의 어두운 overlay가 삽화를 과하게 가리지 않는지
- Android 실기기에서 전투 손패/보상/컬렉션/상점/휴식 화면 스크린샷 확인
