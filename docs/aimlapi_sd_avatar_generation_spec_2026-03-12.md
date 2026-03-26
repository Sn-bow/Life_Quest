# AIMLAPI SD Avatar Generation Spec

Date: 2026-03-12
Target: Korean webtoon-inspired SD/chibi avatar parts
Use case: `Life Quest` player avatar system

## 1. Objective

Generate a cohesive set of cute SD avatar parts that feel:
- friendly
- modern
- webtoon-goods inspired
- self-insert friendly
- readable at small mobile UI sizes

The goal is not to generate one finished illustration.

The goal is to generate:
- reusable part assets
- consistent style variants
- transparent-background layers for in-app assembly

## 2. Style Rules

### Required visual qualities

- 1.8 to 2.3 head proportion
- large head, very small body
- soft rounded face
- large expressive eyes
- tiny or nearly absent nose
- tiny mouth
- clear hair silhouette
- soft sticker-like finish
- minimal costume complexity
- modern Korean webtoon SD merchandise vibe

### Must avoid

- class/job fantasy identity
- armor-heavy RPG look
- harsh shading
- realistic anatomy
- long-limbed anime proportion
- retro pixel or mascot feel
- symbol/emblem/icon look

## 3. Asset Breakdown

Generate assets in this order.

### Phase A: style exploration

Generate complete character sheets only to lock visual style:
- 4 front-facing full SD characters
- 4 expressions
- same lighting and rendering style

Purpose:
- choose one art direction before part extraction work

### Phase B: part generation

Generate the actual reusable part groups:
- face base
- back hair
- front hair
- eyes
- mouth
- outfit

## 4. Part Inventory

### Base set

- Face base: 2
- Back hair: 4
- Front hair: 4
- Eyes: 4
- Mouth: 4
- Outfit: 4

### Suggested style labels

- Hair:
  - short neat
  - soft bob
  - gentle wave
  - light bangs
- Eyes:
  - bright round
  - calm sleepy
  - cheerful smile
  - focused clear
- Mouth:
  - soft smile
  - tiny flat
  - small open
  - shy smirk
- Outfit:
  - hoodie
  - knit top
  - simple jacket
  - long soft coat

## 5. Generation Rules

### Global prompt rules

Every prompt should include:
- Korean webtoon-style SD character
- cute mobile game avatar
- front-facing
- soft rounded shapes
- clean silhouette
- large expressive eyes
- tiny nose and mouth
- simple modern outfit
- sticker-like clarity
- transparent background

### Global negative prompt rules

Always avoid:
- realistic
- detailed hands
- complex props
- weapon
- class fantasy
- armor
- emblem
- symbol
- side pose
- full scene background
- text
- watermark
- extra limbs
- asymmetrical face
- low contrast eyes

## 6. Style Exploration Prompt

Use this before generating actual parts.

### Prompt A

```text
Create a front-facing Korean webtoon-inspired SD character sheet for a mobile app avatar.
The character should be cute, soft, rounded, and easy to read at small sizes.
Use a 2-head-tall chibi proportion, very large expressive eyes, a soft round face, tiny nose, tiny mouth, short limbs, and a clean sticker-like silhouette.
The style should feel like popular Korean webtoon merchandise or cute SD bonus art, not like a fantasy RPG class design.
Use a simple modern outfit with clean shapes and subtle highlights.
Show 4 small expression variations in one sheet: neutral, smile, happy, calm.
Front-facing only.
Transparent or plain light background.
No props, no weapons, no text, no logos.
```

### Negative Prompt A

```text
realistic, semi-realistic, mature proportions, long legs, detailed fingers, fantasy armor, weapon, magical sigil, emblem, mascot, animal ears, clutter, background scene, text, watermark, extra limbs, distorted eyes
```

## 7. Part Generation Prompts

### 7.1 Face base

```text
Create a front-facing Korean webtoon-style SD face base for a mobile avatar system.
Cute rounded chibi face, very clean silhouette, soft cheeks, tiny nose placement guide only, designed for part-based assembly.
No hair, no eyes, no mouth.
Transparent background.
Sticker-like readability at small size.
```

### 7.2 Back hair

```text
Create a front-facing back-hair layer for a Korean webtoon-style SD avatar.
Cute, rounded, readable silhouette, designed for a chibi self-insert character.
No face, no eyes, no mouth, no outfit.
Only the back hair layer.
Transparent background.
Consistent style with Korean webtoon goods SD art.
```

### 7.3 Front hair

```text
Create a front-facing front-hair layer for a Korean webtoon-style SD avatar.
Cute, soft, rounded bangs and front hair silhouette, readable at small mobile size.
Only the front hair layer.
Transparent background.
No face features, no outfit.
```

### 7.4 Eyes

```text
Create a pair of front-facing Korean webtoon-style SD avatar eyes.
Very large, expressive, cute, and readable at small size.
Use clean shapes and strong contrast.
No eyelashes overload, no realism.
Transparent background.
Only the eye layer.
```

### 7.5 Mouth

```text
Create a tiny front-facing mouth layer for a Korean webtoon-style SD avatar.
Cute, simple, soft expression, designed for part assembly.
Only the mouth.
Transparent background.
```

### 7.6 Outfit

```text
Create a front-facing outfit layer for a Korean webtoon-style SD avatar.
Cute and simple modern clothing for a self-insert character.
No fantasy class identity, no armor, no weapons.
Only the outfit layer.
Transparent background.
Readable at small mobile size.
```

## 8. Variation Prompts

Use these as suffixes.

### Hair variation suffixes

- `short neat hair, soft rounded silhouette`
- `cute bob haircut, tidy rounded ends`
- `gentle wavy hair, soft volume`
- `light bangs, soft front fringe`

### Eye variation suffixes

- `bright rounded eyes`
- `calm sleepy eyes`
- `cheerful smiling eyes`
- `clear focused eyes`

### Outfit variation suffixes

- `simple hoodie`
- `soft knit top`
- `clean casual jacket`
- `long soft coat`

## 9. Output Requirements

Best case:
- transparent PNG

Acceptable:
- flat background image that can be manually cleaned

Preferred framing:
- centered
- generous margin
- one asset per image

## 10. Review Checklist

Reject outputs that:
- feel like game class art
- have small or lifeless eyes
- make the body too large
- have noisy hair details
- look like mascot icons instead of a person
- include background clutter
- do not align front-facing
- are too realistic

Accept outputs that:
- feel cute instantly
- read clearly at tiny size
- emphasize face first
- look like a human self-insert
- could fit in a Korean webtoon goods sticker pack

## 11. Best Model Strategy

Recommended order:

1. style exploration with strongest overall illustration model
2. once style is fixed, regenerate cleaner single-part assets
3. keep prompts extremely consistent across all parts

If AIMLAPI model choice is flexible:
- use the most consistent image model for character illustration first
- do not start with image editing/inpainting until the visual direction is locked

## 12. What To Build After Generation

After assets are accepted:
- normalize canvas size
- trim transparent margins consistently
- map assets into Flutter avatar slots
- add unlock metadata
- connect achievement/shop rewards
