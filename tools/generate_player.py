"""
Life Quest — Player & UI Sprite Generator
Generates player character sprites and UI elements using Pillow.
"""

import math
import os
from PIL import Image, ImageDraw, ImageFilter

PLAYER_DIR = os.path.join(os.path.dirname(__file__), '..', 'assets', 'images', 'player')
os.makedirs(PLAYER_DIR, exist_ok=True)

SIZE = 256


def rgba(color, alpha=255):
    if len(color) == 4:
        return tuple(color)
    return (*color, alpha)


def draw_circle(d, cx, cy, r, fill, outline=None, width=2):
    d.ellipse([cx-r, cy-r, cx+r, cy+r], fill=fill, outline=outline, width=width)


# ---------------------------------------------------------------------------
# Player — Hero (idle pose, blue armor)
# ---------------------------------------------------------------------------
def make_hero():
    img = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)

    # Shadow
    d.ellipse([80, 228, 176, 248], fill=(0,0,0,60))

    # Boots
    d.rectangle([94, 204, 118, 230], fill=(60,40,20))
    d.rectangle([138, 204, 162, 230], fill=(60,40,20))
    d.ellipse([88, 220, 124, 236], fill=(50,30,10))
    d.ellipse([132, 220, 168, 236], fill=(50,30,10))

    # Legs (pants)
    d.rectangle([96, 164, 120, 212], fill=(30, 30, 80))
    d.rectangle([136, 164, 160, 212], fill=(30, 30, 80))

    # Cloak back
    d.polygon([(88,120),(60,200),(196,200),(168,120)], fill=(20,20,60,180))

    # Body (armor)
    armor_p = (60, 120, 200)
    armor_dk = (30, 70, 140)
    armor_lt = (120, 180, 255)
    d.ellipse([88, 120, 168, 200], fill=rgba(armor_p))
    d.rectangle([92, 140, 164, 192], fill=rgba(armor_p), outline=rgba(armor_dk), width=2)
    # Chest plate detail
    d.polygon([(128,140),(104,152),(104,172),(128,180),(152,172),(152,152)], fill=rgba(armor_lt,180))
    d.line([(128,140),(128,180)], fill=rgba(armor_dk), width=2)

    # Belt
    d.rectangle([92, 186, 164, 200], fill=(80, 60, 20))
    draw_circle(d, 128, 193, 8, (180, 140, 40))
    draw_circle(d, 128, 193, 5, (220, 200, 80))

    # Left arm
    d.ellipse([64, 128, 100, 164], fill=rgba(armor_p))  # shoulder
    d.rectangle([60, 150, 84, 196], fill=rgba(armor_p), outline=rgba(armor_dk), width=2)
    d.ellipse([54, 192, 80, 216], fill=(200, 170, 130))  # hand

    # Right arm (sword arm)
    d.ellipse([156, 128, 192, 164], fill=rgba(armor_p))
    d.rectangle([172, 150, 196, 196], fill=rgba(armor_p), outline=rgba(armor_dk), width=2)
    d.ellipse([176, 192, 202, 216], fill=(200, 170, 130))

    # Sword
    d.line([(192, 100),(192, 210)], fill=(200,200,220), width=5)  # blade
    d.polygon([(188,100),(192,72),(196,100)], fill=(220,220,240))  # tip
    d.rectangle([182,200,202,212], fill=(140,100,40))  # guard
    d.rectangle([188,208,196,236], fill=(100,70,30))   # grip
    draw_circle(d, 192, 238, 6, (180,140,40))          # pommel

    # Shield (left)
    d.ellipse([36, 140, 80, 200], fill=(40,80,160), outline=(20,50,120), width=3)
    d.ellipse([46, 150, 70, 190], fill=(60,120,200,180))
    draw_circle(d, 58, 170, 8, (200,180,40))

    # Neck
    d.rectangle([116, 112, 140, 136], fill=(200, 170, 130))

    # Head (helmet)
    d.ellipse([88, 60, 168, 136], fill=rgba(armor_dk))   # helmet
    d.ellipse([94, 66, 162, 128], fill=rgba(armor_p))
    # Visor
    d.rectangle([104, 88, 152, 108], fill=(10,10,30))
    d.ellipse([100, 84, 156, 112], fill=(0,0,0,0), outline=rgba(armor_lt,200), width=2)
    # Glowing eyes through visor
    draw_circle(d, 116, 98, 6, (100,200,255,200))
    draw_circle(d, 140, 98, 6, (100,200,255,200))
    draw_circle(d, 116, 98, 3, (200,240,255))
    draw_circle(d, 140, 98, 3, (200,240,255))
    # Plume
    for py in range(20, 68, 4):
        t = (py - 20) / 48
        px = int(128 + math.sin(t * math.pi) * 16)
        r = int(8 - t * 4)
        draw_circle(d, px, py, r, (200, 30, 30, 220))

    return img


# ---------------------------------------------------------------------------
# Player HP/MP bar icons
# ---------------------------------------------------------------------------
def make_icon(color_top, color_bot, symbol_fn, size=64):
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    # Background circle
    draw_circle(d, 32, 32, 30, (30,30,30,200), (0,0,0,255), 2)
    # Gradient
    for y in range(4, 60):
        t = (y - 4) / 56
        c = tuple(int(color_top[i] + (color_bot[i] - color_top[i]) * t) for i in range(3))
        d.line([(4, y), (60, y)], fill=(*c, int(180 * (1 - abs(t - 0.5)))))
    symbol_fn(d)
    return img


def make_heart_icon():
    def draw_heart(d):
        # Simple heart
        d.polygon([(32,48),(14,30),(14,22),(23,18),(32,25),(41,18),(50,22),(50,30)], fill=(255,80,80))
        d.ellipse([14,16,32,32], fill=(255,80,80))
        d.ellipse([32,16,50,32], fill=(255,80,80))
        d.ellipse([18,20,28,28], fill=(255,140,140,180))
    return make_icon((220,30,30),(140,0,0), draw_heart)


def make_mana_icon():
    def draw_mana(d):
        # Star/crystal
        pts = []
        for i in range(10):
            angle = math.pi/2 + i * 2*math.pi/10
            r = 14 if i % 2 == 0 else 7
            pts.append((32 + int(r*math.cos(angle)), 32 + int(r*math.sin(angle))))
        d.polygon(pts, fill=(100,180,255))
        d.ellipse([26,26,38,38], fill=(200,240,255,200))
    return make_icon((30,100,220),(10,50,160), draw_mana)


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
SPRITES = [
    ('hero_idle.png',   make_hero),
    ('icon_hp.png',     make_heart_icon),
    ('icon_mp.png',     make_mana_icon),
]

if __name__ == '__main__':
    print('Life Quest \u2014 Player Sprite Generator \uc2dc\uc791')
    count = 0
    for filename, fn in SPRITES:
        try:
            result = fn()
            out_path = os.path.join(PLAYER_DIR, filename)
            result.save(out_path, 'PNG')
            print(f'  \u2713 {filename}')
            count += 1
        except Exception as e:
            import traceback
            print(f'  [!] {filename}: {e}')
            traceback.print_exc()
    print(f'\n\uc644\ub8cc: {count}\uac1c \uc2a4\ud504\ub77c\uc774\ud2b8 \uc0dd\uc131 \u2192 {PLAYER_DIR}')
