# Dot RPG Asset Scope

Date: 2026-03-12
Project: Life Quest
Direction: full-body dot player + combat-ready RPG presentation

## 1. Core Scope

The requested core is:

1. Player character implementation
2. Monster design implementation
3. Weapon, armor, accessory design implementation
4. Skill, attack, defense, run effect implementation

That is necessary, but not sufficient for a complete combat presentation.

## 2. Additional Required Scope

These are the extra pieces that should be implemented together.

### Animation states

Both player and monsters need a minimum state set:

- idle
- attack
- hit
- defend
- run
- victory
- defeat

Without state separation, combat feels static even if sprites exist.

### Combat feedback

The player must see combat results clearly:

- damage numbers
- critical hit numbers
- block text
- dodge text
- heal numbers
- status effect popups

### Status effect visuals

If combat has RPG structure, these need icons and effect cues:

- poison
- burn
- freeze
- stun
- shield
- buff
- debuff

### Equipment overlay system

Equipment should not only exist in inventory UI.
It should affect the player sprite visually where possible.

- weapon overlay
- armor/body overlay
- accessory accent overlay

### Monster tier language

Monsters should read differently by tier:

- normal
- elite
- boss

This should be visible in:

- scale
- color accent
- aura
- animation weight

### Loot and reward presentation

Combat needs reward feedback after battle:

- item drop sparkle
- gold gain effect
- XP gain effect
- rare drop flash

### Arena and environment support

Combat should not float in empty space.
At minimum:

- floor tile
- backdrop silhouette
- encounter-specific color theme
- simple foreground or atmosphere particles

### UI battle layer

Combat readability depends on more than sprites:

- player HP/AP bar
- monster HP bar
- action buttons
- selected target or selected action state
- turn or phase feedback

## 3. Suggested MVP Asset List

### Player

- full-body base sprite
- 4 idle frames
- 4 attack frames
- 2 hit frames
- 2 defend frames
- 3 run frames
- 2 victory frames
- 2 defeat frames

### Monsters

Start with 3:

- slime-type
- beast-type
- humanoid/shadow-type

Each needs:

- idle
- attack
- hit
- defeat

### Equipment

#### Weapons

- sword
- staff
- dagger
- bow or spear

#### Armor

- light top
- medium armor
- robe/coat

#### Accessories

- ring
- pendant
- charm

### VFX

- slash
- impact burst
- defend flash
- dodge blur
- run dust
- heal sparkle
- buff aura
- debuff pulse
- death burst

## 4. Recommended Production Order

1. Full-body player base sprite
2. Basic player idle and attack
3. Monster set x3
4. Basic slash and hit VFX
5. Damage numbers and combat feedback
6. Weapon overlays
7. Defense, dodge, run effects
8. Armor/accessory overlays
9. Buff/debuff icons and effects
10. Arena backgrounds and reward effects

## 5. Why These Extras Matter

Research and references consistently show that 2D combat readability depends on:

- clear animation states
- layered VFX for attack and impact
- readable UI feedback
- sprite layering for gear

Relevant references:

- PixelSource armor sprite and equipment sheet layering:
  https://www.pixelsource.org/Application.html
- RealTimeVFX slash/impact discussion:
  https://realtimevfx.com/t/wip-sword-slash-attack/1272
- 2D VFX pack structure reference:
  https://magusvfx.itch.io/2d-vfx-pack-slashes-and-impacts
- Pixel character pack example with standard animation set:
  https://pixeldream1.itch.io/demonwarrior
- Pixel art slash frame-count example:
  https://frostwindz.itch.io/pixel-art-slashes

## 6. Next Practical Step

The most efficient next milestone is:

- build one full-body player sprite system
- build three monster templates
- build one slash, one hit, one defend, one run effect
- connect those to the current hunt screen

That creates the first real combat presentation layer.
