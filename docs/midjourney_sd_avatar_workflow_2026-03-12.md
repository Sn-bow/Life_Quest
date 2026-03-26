# Midjourney SD Avatar Workflow

Date: 2026-03-12
Goal: Build a reusable SD avatar set for Life Quest using Midjourney-quality style direction

## 1. Why Midjourney

For this project, Midjourney is better for:
- stronger first-impression quality
- cuter and more commercially appealing SD character styling
- better hair silhouette and eye appeal
- better merchandise/goods-like finish

It is worse for:
- strict part separation
- deterministic asset pipelines
- direct app-ready layer output

So the right use is:
- use Midjourney to lock the visual language
- then extract or recreate app-ready assets from that direction

## 2. Official Workflow To Use

Midjourney official features relevant here:
- `--sref` Style Reference for matching visual vibe
- Style Creator for building a reusable custom style code
- V7 Style Reference system
- Omni Reference for consistent character handling in V7

Sources:
- Midjourney Style Reference:
  - https://docs.midjourney.com/hc/en-us/articles/32180011136653-Style-Reference
- Midjourney Style Creator:
  - https://docs.midjourney.com/hc/en-us/articles/41308374558221-Style-Creator
- Midjourney Character Reference / Omni note:
  - https://docs.midjourney.com/hc/en-us/articles/32162917505293-Character-Reference
- Midjourney V7 style reference update:
  - https://updates.midjourney.com/style-references-for-v7/

## 3. Recommended Generation Strategy

### Phase A: Find the style first

Use Midjourney Style Creator with a simple prompt:

`cute korean webtoon merchandise style sd character, front facing, soft rounded chibi, modern casual outfit`

Reason:
- Midjourney says simple prompts make Style Creator output easier to evaluate
- style should be selected by look, not content

Target:
- create one reusable custom `--sref` style code

### Phase B: Generate full avatar set

After the style code is fixed, generate:
- male x 2
- female x 2
- skin tones x 4
- hairstyles x 4
- expressions x 4

Do not start with parts.
Start with full characters to lock the style.

### Phase C: Build consistent variants

Use the same:
- `--sref`
- prompt skeleton
- aspect ratio
- stylize settings

For character consistency in V7:
- use Omni Reference with the best selected avatar image

## 4. Prompt Skeleton

### Base prompt

`front-facing korean webtoon merchandise style sd character, ultra cute chibi self-insert avatar, 2-head-tall proportion, very large glossy eyes, soft round face, tiny nose, tiny mouth, short limbs, soft blush, modern casual outfit, sticker-like silhouette, clean background --ar 1:1 --v 7 --stylize 150 --sref <YOUR_STYLE_CODE>`

### Male variation

`front-facing korean webtoon merchandise style sd male avatar, ultra cute chibi self-insert, 2-head-tall proportion, large glossy eyes, soft round face, tiny nose, tiny mouth, soft dark hair, modern hoodie and jogger outfit, sticker-like silhouette, clean background --ar 1:1 --v 7 --stylize 150 --sref <YOUR_STYLE_CODE>`

### Female variation

`front-facing korean webtoon merchandise style sd female avatar, ultra cute chibi self-insert, 2-head-tall proportion, large glossy eyes, soft round face, tiny nose, tiny mouth, soft bob hair, modern knit top and skirt or wide pants, sticker-like silhouette, clean background --ar 1:1 --v 7 --stylize 150 --sref <YOUR_STYLE_CODE>`

## 5. Variant Matrix

Build the first usable set like this.

### Gender/style
- soft short male
- clean neat male
- soft bob female
- gentle wave female

### Skin tones
- very light
- light warm
- medium warm
- deeper brown

### Hair
- short neat
- soft bangs
- bob cut
- gentle wave

### Expression
- neutral
- smile
- happy
- calm

## 6. What To Avoid In Prompting

Avoid words like:
- fantasy
- hunter
- knight
- mage
- warrior
- epic
- armor
- weapon
- game class

Why:
- user wants self-insert, not role/class identity

## 7. Quality Filters

Accept if:
- character reads as cute immediately
- head is much larger than body
- eyes dominate the face
- silhouette is clean at small size
- feels like Korean webtoon goods art

Reject if:
- looks like generic anime mascot
- too detailed or realistic
- fantasy class vibe appears
- body is too big
- eyes are too small
- linework feels harsh

## 8. Practical Recommendation

Best route for this project:
1. Use Midjourney Style Creator to find one style code
2. Generate 8 to 12 full avatars with one unified style
3. Pick 4 final base avatars
4. Use those in-app first as selectable presets
5. Only later attempt part-separated asset extraction

This is faster and more likely to succeed than trying to force Midjourney into clean part layers from the start.
