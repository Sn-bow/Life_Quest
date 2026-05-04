"""
Life Quest - Relic & Card Frame Image Generator
OpenAI gpt-image-2 직접 호출, ChatGPT 인증 토큰 사용
"""
import base64
import json
import os
import sys
import time
import requests

# ── 인증 토큰 로드 ──────────────────────────────────────────────
AUTH_PATH = os.path.expanduser(r"~\.codex\auth.json")
with open(AUTH_PATH, "r") as f:
    auth = json.load(f)
ACCESS_TOKEN = auth["tokens"]["access_token"]
HEADERS = {
    "Authorization": f"Bearer {ACCESS_TOKEN}",
    "Content-Type": "application/json",
}
API_URL = "https://api.openai.com/v1/images/generations"

BASE_STYLE = (
    "Dark fantasy game item icon. The object itself centered and filling most of the frame. "
    "No character, no hand, no background — just the floating item. "
    "Thick bold black outlines, vibrant cel-shaded 2D illustration, "
    "Slay the Spire 2 art style: crisp clean linework, colorful dark fantasy with whimsy. "
    "Pure transparent background."
)

RELIC_SAVE_DIR = r"C:\Users\wjd54\Documents\Life_Quest\assets\images\game\relics"
CARD_SAVE_DIR  = r"C:\Users\wjd54\Documents\Life_Quest\assets\images\cards"

# ── 남은 렐릭 14개 ────────────────────────────────────────────────
RELICS = [
    ("relic_arcane_tome",
     "A thick leather-bound arcane tome with a glowing purple eye embossed on the cover, "
     "golden page edges, mystical energy wisps rising from it. Deep purple and gold."),
    ("relic_hourglass",
     "An ornate hourglass with golden frame, upper half filled with glowing white-gold magical sand "
     "still flowing, arcane runes on the glass. Gold and white shimmer."),
    ("relic_skull_lantern",
     "A worn iron lantern with a carved skull face, eerie green soul-fire glowing through the eye sockets. "
     "Rusty dark iron, glowing green flames."),
    ("relic_dark_mirror",
     "An ornate hand mirror with a cracked obsidian frame, the glass showing a dark swirling void "
     "instead of a reflection, purple energy at the edges. Black and deep purple."),
    ("relic_star_map",
     "A partially unrolled parchment star map showing glowing constellation lines and a gold compass rose. "
     "Deep blue night sky on warm parchment."),
    ("relic_mana_prism",
     "A multifaceted magical crystal prism splitting light into vivid rainbow mana beams radiating outward. "
     "Crystal clear with rainbow refractions."),
    ("relic_dragon_scale",
     "A single large dark emerald dragon scale, iridescent surface shimmering with embedded magic, "
     "sharp pointed edges. Dark green with golden shimmer."),
    ("relic_void_eye",
     "A disembodied floating eye with a deep purple iris and vertical slit pupil, "
     "crackling void energy tendrils, all-seeing gaze. Purple and black."),
    ("relic_shadow_cloak",
     "A swirling dark cloak made of living shadow, folds rippling as if blown by a ghostly wind, "
     "faint silver runes on the hem. Pure black with silver accents."),
    ("relic_blood_rune",
     "A carved stone rune tablet glowing with pulsing crimson blood-red arcane energy, "
     "ancient awakening symbols etched deep. Dark stone with red glow."),
    ("relic_spider_web",
     "An intricate magical spider web strung between two ancient twigs, a small glowing fate gem "
     "caught at the center. Silver web threads catching starlight."),
    ("relic_iron_crown",
     "A heavy iron crown with jagged spikes, set with a single dark gemstone, "
     "radiating dark authority and power. Gunmetal iron with purple gem."),
    ("relic_charm_bracelet",
     "A golden charm bracelet with several magical charms — a tiny orb, star, moon, skull, and swirl — "
     "all glowing with chaotic multicolored energy. Gold with colorful magic."),
    ("relic_meditation_bell",
     "A small ornate bronze temple bell with time-warp runes etched on it, "
     "golden hammer attached, soft golden time-light rippling around it. Bronze and gold."),
]

# ── 카드 프레임 4종 ───────────────────────────────────────────────
CARD_FRAME_STYLE = (
    "Dark fantasy trading card frame UI element for a mobile RPG. "
    "Ornate decorative border/frame with no interior content — just the frame itself. "
    "Thick bold outlines, cel-shaded 2D illustration, Slay the Spire 2 style. "
    "Portrait card shape (roughly 2:3 ratio). Center area is empty dark space for card art. "
    "Pure transparent background PNG."
)

CARDS = [
    ("card_frame_attack",
     "A fierce red and black attack card frame. Sharp angular metalwork borders, "
     "crossed swords motif at top, flame effects at corners, red gemstones embedded in frame. "
     "Red, black, dark gold color scheme."),
    ("card_frame_defense",
     "A sturdy blue and silver defense card frame. Rounded shield motif at top, "
     "stone fortress texture on the border, blue crystal gems at corners. "
     "Royal blue, silver, white color scheme."),
    ("card_frame_magic",
     "An arcane purple and gold magic card frame. Flowing mystical swirls on the border, "
     "star and moon motifs, glowing purple crystal orbs at corners, magical runes along the edges. "
     "Deep purple, gold, glowing violet color scheme."),
    ("card_frame_tactical",
     "A sharp green and bronze tactical card frame. Geometric angular border with compass rose at top, "
     "cog and gear motifs, emerald gems at corners. Forest green, bronze, dark teal color scheme."),
]


def generate_image(prompt: str, filename: str, save_dir: str, is_card: bool = False):
    full_prompt = f"{CARD_FRAME_STYLE if is_card else BASE_STYLE}\n\n{prompt}"
    payload = {
        "model": "gpt-image-2",
        "prompt": full_prompt,
        "size": "1024x1024",
        "quality": "high",
        "background": "transparent",
        "output_format": "png",
        "n": 1,
    }
    print(f"  Generating {filename}...", end="", flush=True)
    resp = requests.post(API_URL, headers=HEADERS, json=payload, timeout=120)
    if resp.status_code != 200:
        print(f" FAILED ({resp.status_code}): {resp.text[:200]}")
        return False
    data = resp.json()
    img_b64 = data["data"][0]["b64_json"]
    img_bytes = base64.b64decode(img_b64)
    out_path = os.path.join(save_dir, f"{filename}.png")
    with open(out_path, "wb") as f:
        f.write(img_bytes)
    print(f" ✓ saved ({len(img_bytes)//1024}KB)")
    return True


def main():
    print("=== Life Quest Asset Generator ===\n")

    # 렐릭 생성
    print(f"[1/2] Relics ({len(RELICS)} images)")
    os.makedirs(RELIC_SAVE_DIR, exist_ok=True)
    relic_ok = 0
    for name, desc in RELICS:
        ok = generate_image(desc, name, RELIC_SAVE_DIR, is_card=False)
        if ok:
            relic_ok += 1
        time.sleep(1)  # rate limit 방지

    # 카드 프레임 생성
    print(f"\n[2/2] Card Frames ({len(CARDS)} images)")
    os.makedirs(CARD_SAVE_DIR, exist_ok=True)
    card_ok = 0
    for name, desc in CARDS:
        ok = generate_image(desc, name, CARD_SAVE_DIR, is_card=True)
        if ok:
            card_ok += 1
        time.sleep(1)

    print(f"\n=== Done: {relic_ok}/{len(RELICS)} relics, {card_ok}/{len(CARDS)} card frames ===")


if __name__ == "__main__":
    main()
