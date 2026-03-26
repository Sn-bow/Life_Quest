# SD Character Rebuild Research

Date: 2026-03-12
Platform focus: Android first
Related code:
- `lib/widgets/player_avatar_view.dart`
- `lib/screens/status_screen.dart`
- `lib/screens/signup_screen.dart`
- `lib/widgets/combat/combat_arena_view.dart`

## 1. Goal

The target is not a symbolic avatar or a game class icon.

The target is a Korean webtoon-style SD/chibi human character that:
- feels cute and friendly
- lets the user project themselves into the app
- reads clearly at small sizes in profile/status/combat UI
- can later support unlockable parts in achievements and shop

## 2. Reference Style Summary

The user-provided reference and SD/chibi drawing guides point to the same direction:
- head-heavy proportion: around 2 to 2.5 heads tall
- very small body and limbs
- large, simple, expressive eyes
- soft round face shape
- hair read by silhouette masses, not thin strand detail
- sticker-like white outer edge works well at mobile sizes
- costume should be simple and secondary to face and hair

Useful references:
- CLIP STUDIO chibi proportion guide:
  - https://tips.clip-studio.com/en-us/articles/4868
- CLIP STUDIO simplification for cute characters:
  - https://tips.clip-studio.com/en-us/articles/4796
- CLIP STUDIO eye/expression emphasis:
  - https://tips.clip-studio.com/en-us/articles/4946
- Korean SD commission example post:
  - https://www.postype.com/%40pickledesign007/post/17488699

## 3. Current Approach Limitations

Current implementation is code-drawn using Flutter shapes in `player_avatar_view.dart`.

This is good enough for:
- fast iteration
- layout wiring
- saved avatar state
- basic part swapping

This is not good enough for:
- webtoon goods quality
- charming hair silhouettes
- nuanced face appeal
- emotionally attractive SD character art

Why it falls short:
- hair is still geometric, not illustrated
- face detail is assembled from primitives rather than designed
- body, outfit, and silhouette do not have enough authored shape language
- code-drawn parts produce consistency, but not illustration appeal

## 4. Honest Capability Assessment

What I can do well:
- build the avatar system architecture
- define part slots and save/load structure
- render layered SVG or PNG parts
- wire customization UI
- connect avatar appearance to status/combat/report screens
- implement unlock and purchase flows for parts

What I cannot credibly promise at illustrator-grade quality:
- creating highly appealing commercial-grade webtoon SD character art entirely from geometric Flutter code

Conclusion:
- continuing with shape-only rendering is the wrong path
- the right path is an asset-based layered avatar system

## 5. Recommended Avatar Architecture

### 5.1 Rendering mode

Move from:
- procedural shape rendering

Move to:
- layered SVG or transparent PNG parts

Recommended part order:
1. shadow
2. back hair
3. body/base outfit
4. neck
5. face
6. eyes
7. nose
8. mouth
9. front hair/bangs
10. accessory
11. optional outline or sticker frame

### 5.2 Minimum part slots

MVP slots:
- gender style
- skin tone
- face base
- back hair
- front hair
- eyes
- nose
- mouth
- outfit

Optional later:
- eyebrows
- blush style
- accessory
- outerwear
- aura
- title frame

## 6. Minimum Asset Set For MVP

To reach a clearly better result, prepare at least:

Base faces:
- 2 face bases

Hair:
- 4 back hair variants
- 4 front hair variants

Eyes:
- 4 styles

Nose:
- 2 styles

Mouth:
- 4 styles

Outfits:
- 4 styles

Skin tones:
- 4 palette variants

That gives enough variation without making the first implementation too heavy.

## 7. Visual Design Rules

Rules to follow when creating the actual parts:
- head should occupy roughly 60 to 70 percent of total character height
- limbs should be short and simple
- eyes should be large and readable even at 48 to 72 px display sizes
- nose should stay weak or nearly absent
- mouth should be tiny
- hair must be readable as one clear silhouette first
- avoid class/job symbolism
- use modern Korean webtoon/goods styling, not retro RPG icon styling

## 8. Product Rules For This App

This app should not assign a job/class identity to the user avatar.

Avatar should represent:
- me
- my mood
- my style
- my growth

Not:
- warrior
- mage
- hunter
- class archetype

This means unlockables should be:
- hairstyles
- outfits
- expressions
- accessories
- sticker frames

Not:
- class skins with combat identity

## 9. Recommended Build Plan

### Phase 1: Replace rendering foundation
- keep current avatar data model
- replace procedural body rendering with asset layer renderer
- support SVG-first loading
- keep same customization flow temporarily

### Phase 2: Add first real SD asset pack
- 4 hairstyles
- 4 eye styles
- 4 mouths
- 4 outfits
- 2 face bases
- 4 skin tones

### Phase 3: Improve screens using the new assets
- status screen profile
- signup avatar creation
- combat player character

### Phase 4: Add progression hooks
- achievement-based unlocks
- shop-based cosmetic purchases with in-game gold
- raid rewards for rare parts

## 10. What I Should Do Next

Immediate next step:
- stop polishing the current shape renderer
- build a layered asset renderer interface
- define asset folder structure
- create temporary SVG-based SD parts to validate the pipeline

Proposed asset structure:

`assets/avatar/base/`
- `face_round.svg`
- `face_soft.svg`

`assets/avatar/hair/back/`
- `short_back.svg`
- `bob_back.svg`
- `wave_back.svg`
- `soft_back.svg`

`assets/avatar/hair/front/`
- `short_front.svg`
- `bang_front.svg`
- `wave_front.svg`
- `soft_front.svg`

`assets/avatar/eyes/`
- `round.svg`
- `bright.svg`
- `sleepy.svg`
- `smile.svg`

`assets/avatar/mouth/`
- `smile.svg`
- `flat.svg`
- `open.svg`
- `smirk.svg`

`assets/avatar/outfit/`
- `hoodie.svg`
- `knit.svg`
- `jacket.svg`
- `coat.svg`

## 11. Decision

Decision for this project:
- current code-shape SD renderer is only a temporary placeholder
- the project should move to a layered asset-based SD avatar system
- if we want the result to feel truly attractive, authored assets are required

## 12. Practical Recommendation

Best path if only using my implementation work:
- I build the full asset pipeline and starter SVG avatar pack
- we accept that the result can become "good and usable" but may still stop short of professional illustration charm

Best path if top-tier visual quality matters:
- obtain or commission SD character parts in the target style
- I integrate them into the app and complete the system around them
