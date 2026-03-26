# Dot RPG Implementation Plan

Date: 2026-03-12
Project: Life Quest
Goal: move from profile avatar polish to a combat-ready dot RPG presentation layer

## Phase 1

Build a first playable combat presentation.

- full-body player battle sprite
- monster battle sprite templates
- basic hit / slash / defend feedback
- connect everything to current hunt screen

Exit condition:

- hunt screen no longer uses bust/profile avatar
- hunt screen no longer uses emoji monster placeholder
- player and monster both read as dot RPG combatants

## Phase 2

Expand animation states.

- idle
- attack
- hit
- defend
- run
- victory
- defeat

Exit condition:

- player and monster shift pose by combat state
- at least attack and hit motion are visible

## Phase 3

Equipment overlays and inventory cohesion.

- weapon overlays
- armor silhouette overlays
- accessory accent overlays
- inventory icons aligned to battle visuals

Exit condition:

- changing equipment affects battle sprite look

## Phase 4

Monster family set.

- slime family
- beast family
- humanoid/shadow family
- elite and boss variants

Exit condition:

- at least three visually distinct monster archetypes

## Phase 5

Battle VFX and feedback.

- slash
- impact burst
- defend flash
- heal sparkle
- dodge blur
- crit popup
- loot and reward feedback

Exit condition:

- combat feels readable and responsive, not static

## Phase 6

Production expansion.

- more player presets
- more monster templates
- more equipment art
- more skill effects
- battle background themes

## Immediate implementation order

1. player full-body battle sprite
2. monster full-body battle sprite
3. basic attack / defend VFX
4. emulator verification
