"""
Life Quest — Monster Sprite Generator
Generates 256×256 pixel-art-style sprites for all 36 monsters + 6 bosses
using only Pillow (no external assets required).

Each sprite has:
  - Transparent background
  - A distinctive silhouette using basic shapes
  - Zone-appropriate color palette
  - Simple shading for depth
"""

import math
import os
from PIL import Image, ImageDraw, ImageFilter

OUT_DIR = os.path.join(os.path.dirname(__file__), '..', 'assets', 'images', 'monsters')
SIZE = 256

# ---------------------------------------------------------------------------
# Color palettes per zone
# ---------------------------------------------------------------------------
ZONE_COLORS = {
    1: {'primary': (120, 200, 80),  'dark': (60, 120, 30),   'light': (180, 240, 130), 'eye': (255, 60, 60)},   # meadow — green
    2: {'primary': (80, 100, 160),  'dark': (30, 50, 100),   'light': (140, 160, 220), 'eye': (255, 200, 0)},   # forest — blue-grey
    3: {'primary': (160, 100, 60),  'dark': (80, 40, 20),    'light': (220, 160, 110), 'eye': (200, 50, 200)},  # castle — brown
    4: {'primary': (220, 80, 30),   'dark': (140, 30, 0),    'light': (255, 160, 80),  'eye': (255, 255, 0)},   # lava — orange-red
    5: {'primary': (100, 60, 160),  'dark': (40, 20, 100),   'light': (180, 120, 240), 'eye': (0, 255, 200)},   # abyss — purple
    0: {'primary': (200, 30, 30),   'dark': (120, 0, 0),     'light': (255, 100, 100), 'eye': (255, 255, 0)},   # boss — red
}


def rgba(color, alpha=255):
    if len(color) == 4:
        return tuple(color)  # already has alpha channel
    return (*color, alpha)


def draw_circle(d, cx, cy, r, fill, outline=None, width=2):
    d.ellipse([cx-r, cy-r, cx+r, cy+r], fill=fill, outline=outline, width=width)


def draw_rect(d, cx, cy, w, h, fill, outline=None, width=2):
    d.rectangle([cx-w//2, cy-h//2, cx+w//2, cy+h//2], fill=fill, outline=outline, width=width)


def shade(color, factor):
    return tuple(max(0, min(255, int(c * factor))) for c in color)


def new_img():
    return Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))


# ---------------------------------------------------------------------------
# Monster draw functions
# ---------------------------------------------------------------------------

def draw_slime(img, color):
    d = ImageDraw.Draw(img)
    p, dk, lt, ey = color['primary'], color['dark'], color['light'], color['eye']
    # Body
    d.ellipse([64, 110, 192, 210], fill=rgba(p), outline=rgba(dk), width=3)
    d.ellipse([72, 118, 184, 202], fill=rgba(lt, 120))
    # Eyes
    draw_circle(d, 104, 148, 14, rgba(dk))
    draw_circle(d, 152, 148, 14, rgba(dk))
    draw_circle(d, 104, 148, 8,  rgba(ey))
    draw_circle(d, 152, 148, 8,  rgba(ey))
    draw_circle(d, 106, 146, 4,  rgba((255,255,255)))
    draw_circle(d, 154, 146, 4,  rgba((255,255,255)))
    # Gloss
    d.ellipse([90, 120, 140, 148], fill=rgba((255,255,255,60)))


def draw_bat(img, color):
    d = ImageDraw.Draw(img)
    p, dk, lt, ey = color['primary'], color['dark'], color['light'], color['eye']
    # Wings
    d.polygon([(128,128),(40,80),(60,160),(128,148)], fill=rgba(p), outline=rgba(dk))
    d.polygon([(128,128),(216,80),(196,160),(128,148)], fill=rgba(p), outline=rgba(dk))
    # Body
    draw_circle(d, 128, 148, 28, rgba(dk))
    draw_circle(d, 128, 148, 22, rgba(p))
    # Ears
    d.polygon([(108,128),(116,96),(124,128)], fill=rgba(dk))
    d.polygon([(132,128),(140,96),(148,128)], fill=rgba(dk))
    # Eyes
    draw_circle(d, 118, 146, 8, rgba(ey))
    draw_circle(d, 138, 146, 8, rgba(ey))
    draw_circle(d, 120, 144, 4, rgba((0,0,0)))
    draw_circle(d, 140, 144, 4, rgba((0,0,0)))


def draw_mushroom(img, color):
    d = ImageDraw.Draw(img)
    p, dk, lt, ey = color['primary'], color['dark'], color['light'], color['eye']
    # Stem
    d.rectangle([104, 168, 152, 216], fill=rgba((220,200,160)), outline=rgba((160,130,80)), width=2)
    # Cap
    d.ellipse([56, 90, 200, 186], fill=rgba(p), outline=rgba(dk), width=3)
    # Spots
    for cx, cy, r in [(100,120,16),(155,115,12),(120,100,10),(170,140,10)]:
        draw_circle(d, cx, cy, r, rgba((255,255,255,200)))
    # Face
    draw_circle(d, 108, 158, 10, rgba(dk))
    draw_circle(d, 148, 158, 10, rgba(dk))
    draw_circle(d, 108, 158, 6, rgba(ey))
    draw_circle(d, 148, 158, 6, rgba(ey))
    d.arc([104, 164, 152, 186], 10, 170, fill=rgba(dk), width=3)


def draw_rat(img, color):
    d = ImageDraw.Draw(img)
    p, dk, lt, ey = color['primary'], color['dark'], color['light'], color['eye']
    # Tail
    d.line([(200,196),(230,180),(240,150),(220,130)], fill=rgba(shade(p,0.6)), width=5)
    # Body
    d.ellipse([80, 140, 200, 210], fill=rgba(p), outline=rgba(dk), width=2)
    # Head
    draw_circle(d, 88, 140, 36, rgba(p))
    d.ellipse([76, 128, 100, 152], fill=rgba(p), outline=rgba(dk), width=2)  # snout
    # Ears
    draw_circle(d, 76,  108, 18, rgba(lt))
    draw_circle(d, 106, 104, 18, rgba(lt))
    draw_circle(d, 76,  108, 12, rgba(shade(p, 1.2)))
    draw_circle(d, 106, 104, 12, rgba(shade(p, 1.2)))
    # Eyes
    draw_circle(d, 82, 136, 8, rgba(ey))
    draw_circle(d, 84, 134, 4, rgba((0,0,0)))


def draw_goblin(img, color):
    d = ImageDraw.Draw(img)
    p, dk, lt, ey = color['primary'], color['dark'], color['light'], color['eye']
    # Body
    draw_rect(d, 128, 168, 56, 64, rgba(p), rgba(dk))
    # Head
    draw_circle(d, 128, 116, 44, rgba(p))
    d.ellipse([84, 72, 172, 160], fill=rgba(p), outline=rgba(dk), width=2)
    # Ears (pointy)
    d.polygon([(84,104),(64,76),(92,96)], fill=rgba(p), outline=rgba(dk))
    d.polygon([(172,104),(192,76),(164,96)], fill=rgba(p), outline=rgba(dk))
    # Eyes
    draw_circle(d, 112, 112, 12, rgba(ey))
    draw_circle(d, 144, 112, 12, rgba(ey))
    draw_circle(d, 114, 110, 6, rgba((0,0,0)))
    draw_circle(d, 146, 110, 6, rgba((0,0,0)))
    # Mouth (evil grin)
    d.arc([108, 120, 148, 144], 10, 170, fill=rgba(dk), width=3)
    # Teeth
    d.rectangle([116,132,124,142], fill=rgba((240,240,220)))
    d.rectangle([132,132,140,142], fill=rgba((240,240,220)))
    # Club weapon
    d.line([(168,148),(200,108)], fill=rgba(dk), width=6)
    draw_circle(d, 200, 100, 14, rgba(dk))


def draw_skeleton(img, color):
    d = ImageDraw.Draw(img)
    p, dk, lt, ey = (220,220,200), (140,140,120), (255,255,240), color['eye']
    # Body ribs
    for y in [160, 175, 190]:
        d.line([(108, y),(148, y)], fill=rgba(dk), width=3)
    draw_rect(d, 128, 175, 44, 60, rgba(p, 0), rgba(dk), 2)
    # Spine
    d.line([(128,148),(128,210)], fill=rgba(dk), width=4)
    # Arms
    d.line([(108,156),(84,184)], fill=rgba(p), width=6)
    d.line([(148,156),(172,184)], fill=rgba(p), width=6)
    # Head (skull)
    draw_circle(d, 128, 112, 40, rgba(p))
    d.ellipse([88, 72, 168, 152], fill=rgba(p), outline=rgba(dk), width=2)
    # Eye sockets
    draw_circle(d, 112, 108, 14, rgba(ey))
    draw_circle(d, 144, 108, 14, rgba(ey))
    draw_circle(d, 112, 108, 8, rgba((0,0,0)))
    draw_circle(d, 144, 108, 8, rgba((0,0,0)))
    # Nose
    d.polygon([(124,126),(132,126),(128,138)], fill=rgba(dk))
    # Jaw
    d.arc([100, 130, 156, 152], 10, 170, fill=rgba(dk), width=3)
    for tx in [112, 124, 136, 148]:
        d.rectangle([tx, 142, tx+8, 152], fill=rgba(p), outline=rgba(dk))


def draw_wolf(img, color):
    d = ImageDraw.Draw(img)
    p, dk, lt, ey = color['primary'], color['dark'], color['light'], color['eye']
    # Body
    d.ellipse([76, 136, 200, 216], fill=rgba(p), outline=rgba(dk), width=2)
    # Head
    draw_circle(d, 96, 116, 40, rgba(p))
    # Snout
    d.ellipse([64, 120, 108, 148], fill=rgba(lt), outline=rgba(dk), width=2)
    # Ears
    d.polygon([(68,96),(56,60),(88,88)], fill=rgba(p), outline=rgba(dk))
    d.polygon([(108,92),(112,56),(128,84)], fill=rgba(p), outline=rgba(dk))
    # Eyes
    draw_circle(d, 84, 108, 10, rgba(ey))
    draw_circle(d, 108, 106, 10, rgba(ey))
    draw_circle(d, 86, 106, 5, rgba((0,0,0)))
    draw_circle(d, 110, 104, 5, rgba((0,0,0)))
    # Tail
    d.line([(196,160),(230,130),(240,100)], fill=rgba(p), width=10)
    # Legs
    for lx in [100, 124, 148, 172]:
        d.line([(lx, 210), (lx-4, 240)], fill=rgba(dk), width=8)


def draw_spider(img, color):
    d = ImageDraw.Draw(img)
    p, dk, lt, ey = color['primary'], color['dark'], color['light'], color['eye']
    # Legs (8)
    angles = [30,60,300,330, 150,120,210,240]
    for a in angles:
        ex = int(128 + 90 * math.cos(math.radians(a)))
        ey2 = int(152 + 60 * math.sin(math.radians(a)))
        d.line([(128,152),(ex,ey2)], fill=rgba(dk), width=5)
    # Abdomen
    draw_circle(d, 128, 172, 44, rgba(p))
    d.ellipse([84, 128, 172, 216], fill=rgba(p), outline=rgba(dk), width=2)
    # Thorax
    draw_circle(d, 128, 116, 30, rgba(dk))
    # Eyes (8 small)
    for ex2, ey3 in [(112,108),(122,104),(134,104),(144,108),(110,118),(118,114),(138,114),(146,118)]:
        draw_circle(d, ex2, ey3, 5, rgba(ey))


def draw_treant(img, color):
    d = ImageDraw.Draw(img)
    p = (80, 120, 40)
    dk = (40, 70, 20)
    lt = (120, 160, 80)
    ey = color['eye']
    # Trunk/body
    d.rectangle([100, 136, 156, 224], fill=rgba(p), outline=rgba(dk), width=3)
    # Branches (arms)
    d.line([(100,152),(60,112),(48,88)], fill=rgba(dk), width=10)
    d.line([(60,112),(40,100)], fill=rgba(dk), width=6)
    d.line([(156,152),(196,112),(208,88)], fill=rgba(dk), width=10)
    d.line([(196,112),(216,100)], fill=rgba(dk), width=6)
    # Foliage (head)
    draw_circle(d, 128, 96, 56, rgba(lt, 220))
    draw_circle(d, 100, 112, 36, rgba(p, 220))
    draw_circle(d, 156, 112, 36, rgba(p, 220))
    draw_circle(d, 128, 72, 40, rgba(lt, 220))
    # Face in bark
    d.ellipse([108, 140, 148, 180], fill=rgba(dk, 200))
    draw_circle(d, 116, 152, 8, rgba(ey))
    draw_circle(d, 140, 152, 8, rgba(ey))
    d.arc([108, 162, 148, 180], 10, 170, fill=rgba(lt), width=3)


def draw_orc(img, color):
    d = ImageDraw.Draw(img)
    p, dk, lt, ey = color['primary'], color['dark'], color['light'], color['eye']
    # Legs
    d.rectangle([96, 196, 120, 240], fill=rgba(dk), outline=rgba(dk), width=2)
    d.rectangle([136, 196, 160, 240], fill=rgba(dk), outline=rgba(dk), width=2)
    # Body (muscular)
    d.ellipse([80, 136, 176, 212], fill=rgba(p), outline=rgba(dk), width=3)
    # Arms
    d.ellipse([48, 136, 96, 196], fill=rgba(p), outline=rgba(dk), width=2)
    d.ellipse([160, 136, 208, 196], fill=rgba(p), outline=rgba(dk), width=2)
    # Head
    draw_circle(d, 128, 112, 46, rgba(p))
    d.ellipse([82, 66, 174, 158], fill=rgba(p), outline=rgba(dk), width=2)
    # Tusks
    d.polygon([(108,148),(100,172),(116,148)], fill=rgba((240,220,180)))
    d.polygon([(140,148),(132,148),(148,172)], fill=rgba((240,220,180)))
    # Eyes
    draw_circle(d, 110, 106, 14, rgba(ey))
    draw_circle(d, 146, 106, 14, rgba(ey))
    draw_circle(d, 112, 104, 7, rgba((0,0,0)))
    draw_circle(d, 148, 104, 7, rgba((0,0,0)))
    # Axe
    d.line([(56,180),(56,88)], fill=rgba((140,140,140)), width=6)
    d.polygon([(56,88),(32,68),(40,100),(56,104)], fill=rgba((180,180,180)), outline=rgba((100,100,100)))


def draw_dark_mage(img, color):
    d = ImageDraw.Draw(img)
    p = (60, 20, 80)
    dk = (30, 10, 40)
    lt = (120, 60, 160)
    ey = (0, 255, 200)
    # Robe
    d.polygon([(128,136),(76,224),(180,224)], fill=rgba(p), outline=rgba(dk), width=2)
    # Arms with sleeves
    d.polygon([(104,148),(64,168),(72,192),(108,172)], fill=rgba(p), outline=rgba(dk))
    d.polygon([(152,148),(192,168),(184,192),(148,172)], fill=rgba(p), outline=rgba(dk))
    # Body
    d.ellipse([96, 132, 160, 192], fill=rgba(p))
    # Head
    draw_circle(d, 128, 104, 40, rgba(lt))
    d.ellipse([88, 64, 168, 144], fill=rgba(lt), outline=rgba(dk), width=2)
    # Hat
    d.polygon([(128,40),(88,96),(168,96)], fill=rgba(dk), outline=rgba(p), width=2)
    d.ellipse([84,88,172,108], fill=rgba(dk))
    # Glowing eyes
    draw_circle(d, 112, 100, 12, rgba(ey))
    draw_circle(d, 144, 100, 12, rgba(ey))
    draw_circle(d, 112, 100, 6, rgba((255,255,255)))
    draw_circle(d, 144, 100, 6, rgba((255,255,255)))
    # Staff
    d.line([(192,176),(192,64)], fill=rgba(lt), width=5)
    draw_circle(d, 192, 56, 14, rgba(ey, 200))


def draw_golem(img, color):
    d = ImageDraw.Draw(img)
    p = (140, 130, 110)
    dk = (80, 70, 60)
    lt = (200, 190, 170)
    ey = (255, 160, 0)
    # Legs
    d.rectangle([88, 196, 118, 240], fill=rgba(dk), outline=rgba(p), width=3)
    d.rectangle([138, 196, 168, 240], fill=rgba(dk), outline=rgba(p), width=3)
    # Body (chunky block)
    d.rectangle([76, 124, 180, 204], fill=rgba(p), outline=rgba(dk), width=4)
    # Chest crack
    d.line([(128,132),(120,180)], fill=rgba(dk), width=3)
    # Arms (big blocks)
    d.rectangle([40, 128, 80, 196], fill=rgba(p), outline=rgba(dk), width=3)
    d.rectangle([176, 128, 216, 196], fill=rgba(p), outline=rgba(dk), width=3)
    # Head
    d.rectangle([88, 68, 168, 132], fill=rgba(p), outline=rgba(dk), width=4)
    # Eyes (glowing cracks)
    draw_circle(d, 108, 96, 14, rgba(dk))
    draw_circle(d, 148, 96, 14, rgba(dk))
    draw_circle(d, 108, 96, 8, rgba(ey, 220))
    draw_circle(d, 148, 96, 8, rgba(ey, 220))
    # Stone texture lines
    for y in [144, 164, 184]:
        d.line([(80,y),(176,y)], fill=rgba(dk, 80), width=2)


def draw_harpy(img, color):
    d = ImageDraw.Draw(img)
    p, dk, lt, ey = color['primary'], color['dark'], color['light'], color['eye']
    # Wings
    d.polygon([(120,120),(36,64),(48,156),(120,144)], fill=rgba(p), outline=rgba(dk))
    d.polygon([(136,120),(220,64),(208,156),(136,144)], fill=rgba(p), outline=rgba(dk))
    # Wing feather details
    for i in range(3):
        fx = 48 + i * 24
        d.line([(fx, 156-i*16), (fx-8, 120)], fill=rgba(dk), width=2)
        fx2 = 208 - i * 24
        d.line([(fx2, 156-i*16), (fx2+8, 120)], fill=rgba(dk), width=2)
    # Body
    d.ellipse([96, 124, 160, 200], fill=rgba(lt), outline=rgba(dk), width=2)
    # Head
    draw_circle(d, 128, 100, 36, rgba(lt))
    # Crest feathers
    for fx, fy, angle in [(128,68,-10),(116,72,-25),(140,72,25)]:
        tx = int(fx + 20*math.sin(math.radians(angle)))
        ty = int(fy - 24)
        d.line([(fx,fy),(tx,ty)], fill=rgba(p), width=4)
    # Eyes
    draw_circle(d, 114, 96, 10, rgba(ey))
    draw_circle(d, 142, 96, 10, rgba(ey))
    draw_circle(d, 116, 94, 5, rgba((0,0,0)))
    draw_circle(d, 144, 94, 5, rgba((0,0,0)))
    # Beak
    d.polygon([(120,108),(136,108),(128,124)], fill=rgba((220,180,40)), outline=rgba(dk))
    # Talons
    d.line([(108,196),(100,224)], fill=rgba(dk), width=5)
    d.line([(148,196),(156,224)], fill=rgba(dk), width=5)


def draw_mimic(img, color):
    d = ImageDraw.Draw(img)
    p = (160, 120, 60)
    dk = (100, 70, 20)
    lt = (220, 180, 100)
    ey = (255, 60, 0)
    # Treasure chest body
    d.rectangle([72, 140, 184, 220], fill=rgba(p), outline=rgba(dk), width=4)
    d.rectangle([72, 120, 184, 148], fill=rgba(shade(p,1.1)), outline=rgba(dk), width=4)
    # Lock
    draw_circle(d, 128, 140, 12, rgba((220,180,40)))
    draw_circle(d, 128, 140, 7, rgba(dk))
    # Bands
    d.rectangle([72, 155, 184, 163], fill=rgba((220,180,40)), outline=rgba(dk))
    d.rectangle([72, 196, 184, 204], fill=rgba((220,180,40)), outline=rgba(dk))
    # Teeth (the trap)
    for tx in range(84, 172, 12):
        d.rectangle([tx, 140, tx+8, 160], fill=rgba((240,240,220)), outline=rgba(dk))
    # Tentacle tongue
    d.line([(128,160),(128,188),(144,200),(128,212)], fill=rgba((255,80,80)), width=5)
    # Glowing eyes
    draw_circle(d, 104, 132, 12, rgba(ey, 220))
    draw_circle(d, 152, 132, 12, rgba(ey, 220))
    draw_circle(d, 106, 130, 6, rgba((255,200,0)))
    draw_circle(d, 154, 130, 6, rgba((255,200,0)))


def draw_lava_golem(img, color):
    d = ImageDraw.Draw(img)
    p = (200, 60, 20)
    dk = (80, 20, 0)
    lt = (255, 160, 60)
    ey = (255, 255, 0)
    # Lava glow beneath
    draw_circle(d, 128, 210, 50, rgba((255,80,0,60)))
    # Legs
    d.rectangle([88, 192, 116, 240], fill=rgba(dk), outline=rgba(p), width=3)
    d.rectangle([140, 192, 168, 240], fill=rgba(dk), outline=rgba(p), width=3)
    # Body
    d.rectangle([76, 120, 180, 200], fill=rgba(dk), outline=rgba(p), width=4)
    # Lava cracks on body
    for pts in [[(100,132),(112,152),(104,172)], [(148,128),(140,156),(152,176)], [(120,140),(128,164),(124,180)]]:
        d.line(pts, fill=rgba(lt), width=3)
    # Arms
    d.rectangle([40, 124, 80, 188], fill=rgba(dk), outline=rgba(p), width=3)
    d.rectangle([176, 124, 216, 188], fill=rgba(dk), outline=rgba(p), width=3)
    # Glowing fists
    draw_circle(d, 60, 188, 16, rgba(lt))
    draw_circle(d, 196, 188, 16, rgba(lt))
    # Head
    d.rectangle([88, 60, 168, 128], fill=rgba(dk), outline=rgba(p), width=4)
    # Lava eyes (bright)
    draw_circle(d, 108, 88, 16, rgba(ey))
    draw_circle(d, 148, 88, 16, rgba(ey))
    draw_circle(d, 108, 88, 8, rgba((255,200,0)))
    draw_circle(d, 148, 88, 8, rgba((255,200,0)))


def draw_fire_spirit(img, color):
    d = ImageDraw.Draw(img)
    ey = (255, 255, 100)
    # Flame body (irregular polygon)
    d.polygon([(128,40),(96,100),(72,160),(88,220),(168,220),(184,160),(160,100)], fill=rgba((255,80,0,200)))
    d.polygon([(128,60),(104,110),(88,160),(100,210),(156,210),(168,160),(152,110)], fill=rgba((255,160,0,180)))
    d.polygon([(128,90),(112,130),(108,170),(128,200),(148,170),(144,130)], fill=rgba((255,220,60,160)))
    # Flame tips
    d.polygon([(112,60),(104,28),(120,56)], fill=rgba((255,60,0,200)))
    d.polygon([(144,60),(152,24),(136,56)], fill=rgba((255,60,0,200)))
    d.polygon([(96,100),(80,68),(100,96)], fill=rgba((255,60,0,180)))
    d.polygon([(160,100),(176,68),(156,96)], fill=rgba((255,60,0,180)))
    # Eyes
    draw_circle(d, 112, 140, 14, rgba((255,0,0,220)))
    draw_circle(d, 144, 140, 14, rgba((255,0,0,220)))
    draw_circle(d, 112, 140, 8, rgba(ey))
    draw_circle(d, 144, 140, 8, rgba(ey))


def draw_demon_warrior(img, color):
    d = ImageDraw.Draw(img)
    p = (160, 40, 40)
    dk = (80, 10, 10)
    lt = (220, 100, 100)
    ey = (255, 200, 0)
    # Legs
    d.rectangle([92, 196, 116, 240], fill=rgba(dk))
    d.rectangle([140, 196, 164, 240], fill=rgba(dk))
    # Tail
    d.line([(180,188),(210,164),(220,140),(210,116)], fill=rgba(p), width=8)
    d.polygon([(204,112),(216,106),(218,120)], fill=rgba(dk))
    # Body (armor)
    d.ellipse([84, 128, 172, 208], fill=rgba(dk), outline=rgba(p), width=3)
    # Arms
    d.ellipse([48, 132, 92, 192], fill=rgba(p), outline=rgba(dk), width=2)
    d.ellipse([164, 132, 208, 192], fill=rgba(p), outline=rgba(dk), width=2)
    # Head
    draw_circle(d, 128, 104, 42, rgba(p))
    d.ellipse([86, 62, 170, 146], fill=rgba(p), outline=rgba(dk), width=2)
    # Horns
    d.polygon([(104,74),(88,40),(112,70)], fill=rgba(dk), outline=rgba(p))
    d.polygon([(152,74),(168,40),(144,70)], fill=rgba(dk), outline=rgba(p))
    # Eyes
    draw_circle(d, 110, 100, 14, rgba(ey))
    draw_circle(d, 146, 100, 14, rgba(ey))
    draw_circle(d, 112, 98, 7, rgba((0,0,0)))
    draw_circle(d, 148, 98, 7, rgba((0,0,0)))
    # Sword
    d.line([(48,168),(48,80)], fill=rgba((200,200,220)), width=6)
    d.rectangle([40,80,56,92], fill=rgba((200,180,60)))


def draw_salamander(img, color):
    d = ImageDraw.Draw(img)
    p = (220, 120, 40)
    dk = (140, 60, 10)
    lt = (255, 180, 80)
    ey = (255, 255, 0)
    # Tail
    d.line([(180,180),(220,164),(240,140),(236,116)], fill=rgba(p), width=14)
    d.line([(220,164),(240,164)], fill=rgba(lt), width=5)
    # Body
    d.ellipse([80, 148, 196, 216], fill=rgba(p), outline=rgba(dk), width=3)
    # Legs (4)
    d.line([(100,212),(88,240)], fill=rgba(dk), width=7)
    d.line([(130,214),(126,240)], fill=rgba(dk), width=7)
    d.line([(156,212),(162,238)], fill=rgba(dk), width=7)
    d.line([(180,200),(192,224)], fill=rgba(dk), width=7)
    # Head
    d.ellipse([60, 132, 132, 180], fill=rgba(p), outline=rgba(dk), width=3)
    # Spines on back
    for sx in range(116, 192, 16):
        d.polygon([(sx,152),(sx-6,136),(sx+6,152)], fill=rgba(lt))
    # Eyes
    draw_circle(d, 76, 148, 10, rgba(ey))
    draw_circle(d, 78, 146, 5, rgba((0,0,0)))


def draw_cerberus(img, color):
    d = ImageDraw.Draw(img)
    p = (60, 40, 80)
    dk = (20, 10, 40)
    lt = (120, 100, 160)
    ey = (255, 100, 0)
    # Body
    d.ellipse([76, 148, 192, 220], fill=rgba(p), outline=rgba(dk), width=3)
    # Tail (spiky)
    d.line([(188,172),(220,148),(236,120)], fill=rgba(p), width=10)
    d.polygon([(224,116),(232,108),(240,120)], fill=rgba(lt))
    # Legs
    for lx in [92,116,140,164]:
        d.line([(lx,216),(lx-4,244)], fill=rgba(dk), width=8)
    # Three necks
    for nx, angle in [(98,-20),(128,0),(158,20)]:
        tx = int(nx + 20*math.sin(math.radians(angle)))
        d.ellipse([nx-14, 80, nx+14, 152], fill=rgba(p), outline=rgba(dk), width=2)
    # Three heads
    for hx in [92, 128, 164]:
        draw_circle(d, hx, 72, 28, rgba(p))
        d.ellipse([hx-28, 44, hx+28, 100], fill=rgba(p), outline=rgba(dk), width=2)
        # Ears
        d.polygon([(hx-20,52),(hx-28,32),(hx-8,48)], fill=rgba(p), outline=rgba(dk))
        d.polygon([(hx+20,52),(hx+28,32),(hx+8,48)], fill=rgba(p), outline=rgba(dk))
        # Eyes
        draw_circle(d, hx-10, 68, 8, rgba(ey))
        draw_circle(d, hx+10, 68, 8, rgba(ey))
        draw_circle(d, hx-10, 68, 4, rgba((0,0,0)))
        draw_circle(d, hx+10, 68, 4, rgba((0,0,0)))
    # Fangs on middle head
    d.polygon([(120,88),(124,100),(128,88)], fill=rgba((240,230,200)))
    d.polygon([(128,88),(132,100),(136,88)], fill=rgba((240,230,200)))


def draw_shadow_knight(img, color):
    d = ImageDraw.Draw(img)
    p = (20, 20, 40)
    dk = (10, 10, 20)
    lt = (60, 80, 120)
    ey = (0, 200, 255)
    # Cape
    d.polygon([(128,120),(60,224),(196,224)], fill=rgba((10,10,30,220)))
    # Legs (armored)
    d.rectangle([92, 192, 116, 240], fill=rgba(lt), outline=rgba(dk), width=2)
    d.rectangle([140, 192, 164, 240], fill=rgba(lt), outline=rgba(dk), width=2)
    # Body armor
    d.rectangle([84, 120, 172, 200], fill=rgba(lt), outline=rgba(p), width=3)
    # Armor details
    d.line([(128,120),(128,200)], fill=rgba(dk), width=3)
    d.line([(84,156),(172,156)], fill=rgba(dk), width=3)
    # Arms
    d.rectangle([52, 124, 88, 188], fill=rgba(lt), outline=rgba(dk), width=2)
    d.rectangle([168, 124, 204, 188], fill=rgba(lt), outline=rgba(dk), width=2)
    # Helmet
    d.rectangle([84, 56, 172, 128], fill=rgba(lt), outline=rgba(dk), width=3)
    d.rectangle([84, 56, 172, 72], fill=rgba(p), outline=rgba(dk), width=2)
    # Visor glow
    d.rectangle([96, 80, 160, 100], fill=rgba(dk))
    draw_circle(d, 108, 90, 8, rgba(ey))
    draw_circle(d, 148, 90, 8, rgba(ey))
    # Great sword
    d.line([(52,188),(52,60)], fill=rgba((160,180,200)), width=8)
    d.rectangle([40,60,64,76], fill=rgba((200,180,60)))
    d.polygon([(52,44),(44,64),(60,64)], fill=rgba((200,200,220)))


def draw_lich(img, color):
    d = ImageDraw.Draw(img)
    p = (40, 20, 60)
    dk = (20, 10, 30)
    lt = (100, 60, 140)
    ey = (0, 255, 150)
    # Robe
    d.polygon([(128,132),(56,224),(200,224)], fill=rgba(p), outline=rgba(lt), width=2)
    # Bony arms
    d.line([(100,152),(60,176),(48,196)], fill=rgba((180,170,160)), width=5)
    d.line([(156,152),(196,176),(208,196)], fill=rgba((180,170,160)), width=5)
    # Crown
    for cx in [100, 116, 128, 140, 156]:
        ht = 14 if cx == 128 else 10
        d.polygon([(cx-6,76),(cx,76-ht),(cx+6,76)], fill=rgba((200,180,40)), outline=rgba((140,120,20)))
    d.rectangle([92, 76, 164, 88], fill=rgba((200,180,40)), outline=rgba((140,120,20)))
    # Skull head
    draw_circle(d, 128, 104, 40, rgba((200,190,175)))
    d.ellipse([88, 64, 168, 144], fill=rgba((200,190,175)), outline=rgba((160,150,135)), width=2)
    # Glowing eye sockets
    draw_circle(d, 110, 100, 14, rgba(ey, 80))
    draw_circle(d, 146, 100, 14, rgba(ey, 80))
    draw_circle(d, 110, 100, 8, rgba(ey))
    draw_circle(d, 146, 100, 8, rgba(ey))
    # Nose void
    d.polygon([(122,118),(134,118),(128,130)], fill=rgba(dk))
    # Jaw + teeth
    d.arc([100, 124, 156, 148], 10, 170, fill=rgba(dk), width=3)
    for tx in [108, 120, 132, 144]:
        d.rectangle([tx, 136, tx+8, 148], fill=rgba((210,200,185)), outline=rgba(dk))
    # Staff with glowing orb
    d.line([(200,200),(200,60)], fill=rgba(lt), width=5)
    draw_circle(d, 200, 52, 16, rgba(ey, 200))
    draw_circle(d, 200, 52, 8, rgba((255,255,255)))


def draw_behemoth(img, color):
    d = ImageDraw.Draw(img)
    p = (100, 80, 60)
    dk = (50, 40, 30)
    lt = (160, 140, 110)
    ey = (255, 100, 0)
    # Massive body
    d.ellipse([52, 96, 220, 240], fill=rgba(p), outline=rgba(dk), width=4)
    # Legs (thick)
    for lx in [76, 108, 148, 180]:
        d.rectangle([lx-14, 208, lx+14, 250], fill=rgba(dk), outline=rgba(p), width=2)
    # Neck
    d.rectangle([108, 64, 148, 104], fill=rgba(p), outline=rgba(dk), width=2)
    # Head (big and brutish)
    d.ellipse([80, 32, 192, 116], fill=rgba(p), outline=rgba(dk), width=3)
    # Horns
    d.polygon([(96,48),(72,12),(104,44)], fill=rgba(dk), outline=rgba(lt))
    d.polygon([(160,48),(184,12),(152,44)], fill=rgba(dk), outline=rgba(lt))
    # Eyes (small, deep-set)
    draw_circle(d, 104, 64, 12, rgba(dk))
    draw_circle(d, 152, 64, 12, rgba(dk))
    draw_circle(d, 104, 64, 7, rgba(ey))
    draw_circle(d, 152, 64, 7, rgba(ey))
    # Armored plates on back
    for px2 in range(80, 196, 24):
        d.ellipse([px2, 96, px2+20, 116], fill=rgba(lt), outline=rgba(dk))
    # Nostrils
    draw_circle(d, 120, 90, 6, rgba(dk))
    draw_circle(d, 136, 90, 6, rgba(dk))


def draw_dark_phoenix(img, color):
    d = ImageDraw.Draw(img)
    p = (20, 20, 60)
    dk = (10, 10, 30)
    flame_c = (100, 0, 200)
    ey = (200, 0, 255)
    # Tail feathers (flame-like)
    d.polygon([(128,176),(96,240),(128,216),(160,240)], fill=rgba((80,0,160,200)))
    d.polygon([(128,176),(80,232),(116,212)], fill=rgba(flame_c, 160))
    d.polygon([(128,176),(176,232),(140,212)], fill=rgba(flame_c, 160))
    # Wings
    d.polygon([(108,120),(20,72),(36,152),(108,140)], fill=rgba(p), outline=rgba(flame_c))
    d.polygon([(148,120),(236,72),(220,152),(148,140)], fill=rgba(p), outline=rgba(flame_c))
    # Wing flame edges
    for i in range(4):
        wx = 20 + i*20
        d.line([(wx, 152-i*12), (wx+8, 120)], fill=rgba(flame_c), width=2)
        wx2 = 220 - i*20
        d.line([(wx2, 152-i*12), (wx2-8, 120)], fill=rgba(flame_c), width=2)
    # Body
    d.ellipse([96, 124, 160, 188], fill=rgba(dk), outline=rgba(flame_c), width=3)
    # Head
    draw_circle(d, 128, 100, 36, rgba(dk))
    # Crest flames
    d.polygon([(128,68),(116,44),(128,64)], fill=rgba(flame_c))
    d.polygon([(128,68),(140,44),(128,64)], fill=rgba(flame_c))
    d.polygon([(118,72),(104,52),(120,68)], fill=rgba(flame_c, 180))
    d.polygon([(138,72),(152,52),(136,68)], fill=rgba(flame_c, 180))
    # Eyes
    draw_circle(d, 114, 96, 12, rgba(ey))
    draw_circle(d, 142, 96, 12, rgba(ey))
    draw_circle(d, 116, 94, 6, rgba((255,255,255)))
    draw_circle(d, 144, 94, 6, rgba((255,255,255)))
    # Beak
    d.polygon([(120,110),(136,110),(128,124)], fill=rgba((80,60,120)))


def draw_void_worm(img, color):
    d = ImageDraw.Draw(img)
    p = (20, 60, 80)
    dk = (10, 30, 40)
    lt = (40, 120, 160)
    ey = (0, 220, 255)
    # Tail segments (tapering)
    for i, (sx, sy, r) in enumerate([(200,212,10),(210,188,12),(216,164,14),(208,140,16)]):
        draw_circle(d, sx, sy, r, rgba(p), rgba(dk))
    # Body segments
    for cx2, cy2, r2 in [(192,120,20),(172,104,22),(152,92,24),(132,84,26),(112,80,28),(92,80,28)]:
        draw_circle(d, cx2, cy2, r2, rgba(p), rgba(dk))
    # Head
    draw_circle(d, 80, 88, 38, rgba(lt))
    d.ellipse([42, 50, 118, 126], fill=rgba(lt), outline=rgba(dk), width=3)
    # Void eyes (multiple)
    for ex2, ey2 in [(62,76),(76,68),(90,72),(60,92),(78,90)]:
        draw_circle(d, ex2, ey2, 8, rgba(dk))
        draw_circle(d, ex2, ey2, 5, rgba(ey))
    # Tentacles around mouth
    for angle2 in range(0, 360, 45):
        tx = int(80 + 44 * math.cos(math.radians(angle2)))
        ty = int(88 + 44 * math.sin(math.radians(angle2)))
        d.line([(80,88),(tx,ty)], fill=rgba(lt, 160), width=3)
    # Mouth
    draw_circle(d, 80, 100, 20, rgba(dk))
    # Void rings
    for r3 in [8, 14, 20]:
        d.ellipse([80-r3, 100-r3, 80+r3, 100+r3], fill=rgba((0,0,0,0)), outline=rgba(ey, 100), width=2)


def draw_boss_troll(img, color):
    d = ImageDraw.Draw(img)
    p = (80, 120, 60)
    dk = (40, 70, 30)
    lt = (130, 170, 100)
    ey = (255, 50, 50)
    # Legs (massive)
    d.rectangle([80, 196, 114, 250], fill=rgba(p), outline=rgba(dk), width=3)
    d.rectangle([142, 196, 176, 250], fill=rgba(p), outline=rgba(dk), width=3)
    # Body (huge)
    d.ellipse([56, 112, 200, 216], fill=rgba(p), outline=rgba(dk), width=4)
    # Arms
    d.ellipse([20, 120, 68, 196], fill=rgba(p), outline=rgba(dk), width=3)
    d.ellipse([188, 120, 236, 196], fill=rgba(p), outline=rgba(dk), width=3)
    # Fists
    draw_circle(d, 44, 196, 20, rgba(dk))
    draw_circle(d, 212, 196, 20, rgba(dk))
    # Head
    draw_circle(d, 128, 92, 50, rgba(p))
    d.ellipse([78, 42, 178, 142], fill=rgba(p), outline=rgba(dk), width=3)
    # Big nose
    d.ellipse([110, 96, 146, 120], fill=rgba(shade(p,0.8)), outline=rgba(dk), width=2)
    # Tiny eyes (angry)
    draw_circle(d, 106, 80, 14, rgba(dk))
    draw_circle(d, 150, 80, 14, rgba(dk))
    draw_circle(d, 106, 80, 8, rgba(ey))
    draw_circle(d, 150, 80, 8, rgba(ey))
    # Club (spiked)
    d.line([(220,188),(220,80)], fill=rgba(dk), width=10)
    draw_circle(d, 220, 72, 22, rgba(dk))
    for spike_a in range(0, 360, 45):
        sx = int(220 + 24 * math.cos(math.radians(spike_a)))
        sy = int(72 + 24 * math.sin(math.radians(spike_a)))
        draw_circle(d, sx, sy, 5, rgba(lt))


def draw_boss_dragon(img, color):
    d = ImageDraw.Draw(img)
    p = (180, 40, 20)
    dk = (100, 10, 0)
    lt = (255, 120, 60)
    ey = (255, 220, 0)
    # Tail
    d.line([(196,180),(228,160),(244,130),(240,100)], fill=rgba(p), width=16)
    d.polygon([(232,96),(240,88),(244,100)], fill=rgba(dk))
    # Body
    d.ellipse([64, 104, 212, 216], fill=rgba(p), outline=rgba(dk), width=4)
    # Wing membranes
    d.polygon([(108,116),(24,52),(40,136),(108,136)], fill=rgba((140,20,10,200)), outline=rgba(dk))
    d.polygon([(168,116),(240,52),(224,136),(168,136)], fill=rgba((140,20,10,200)), outline=rgba(dk))
    # Wing bones
    d.line([(108,116),(40,60)], fill=rgba(dk), width=4)
    d.line([(168,116),(220,60)], fill=rgba(dk), width=4)
    # Spine plates
    for px3 in range(92, 196, 18):
        d.polygon([(px3,108),(px3-6,86),(px3+6,108)], fill=rgba(lt))
    # Neck
    d.rectangle([104, 60, 152, 116], fill=rgba(p), outline=rgba(dk), width=3)
    # Head
    d.ellipse([72, 24, 188, 100], fill=rgba(p), outline=rgba(dk), width=3)
    # Horns
    d.polygon([(96,36),(76,4),(108,32)], fill=rgba(dk), outline=rgba(lt))
    d.polygon([(160,36),(180,4),(148,32)], fill=rgba(dk), outline=rgba(lt))
    # Eyes
    draw_circle(d, 100, 56, 14, rgba(dk))
    draw_circle(d, 156, 56, 14, rgba(dk))
    draw_circle(d, 100, 56, 8, rgba(ey))
    draw_circle(d, 156, 56, 8, rgba(ey))
    # Mouth + flame
    d.arc([80, 68, 176, 96], 10, 170, fill=rgba(dk), width=4)
    d.polygon([(80,82),(52,72),(60,90),(80,90)], fill=rgba((255,160,0,200)))
    d.polygon([(80,82),(44,78),(52,92)], fill=rgba((255,100,0,180)))


def draw_boss_demon_lord(img, color):
    d = ImageDraw.Draw(img)
    p = (80, 0, 20)
    dk = (40, 0, 10)
    lt = (160, 40, 60)
    ey = (255, 255, 0)
    # Dark aura
    for r4 in [110, 100, 90]:
        draw_circle(d, 128, 128, r4, rgba((60,0,20, 30)))
    # Cape / wings (bat-like)
    d.polygon([(128,120),(24,40),(32,160),(96,148)], fill=rgba((20,0,30,220)))
    d.polygon([(128,120),(232,40),(224,160),(160,148)], fill=rgba((20,0,30,220)))
    # Legs
    d.rectangle([92, 196, 116, 250], fill=rgba(dk))
    d.rectangle([140, 196, 164, 250], fill=rgba(dk))
    # Body (armored)
    d.rectangle([80, 116, 176, 208], fill=rgba(p), outline=rgba(lt), width=3)
    # Chest emblem
    d.polygon([(128,132),(118,148),(128,164),(138,148)], fill=rgba(ey))
    # Arms
    d.ellipse([44, 120, 88, 188], fill=rgba(p), outline=rgba(lt), width=2)
    d.ellipse([168, 120, 212, 188], fill=rgba(p), outline=rgba(lt), width=2)
    # Head
    draw_circle(d, 128, 88, 44, rgba(p))
    d.ellipse([84, 44, 172, 132], fill=rgba(p), outline=rgba(lt), width=3)
    # Crown of horns
    for ang in [-40,-20,0,20,40]:
        hx = int(128 + 40*math.sin(math.radians(ang)))
        hy = int(88 - 40*math.cos(math.radians(ang)))
        ht2 = 30 if ang == 0 else 20
        d.polygon([(hx-6,hy),(hx,hy-ht2),(hx+6,hy)], fill=rgba(lt), outline=rgba(dk))
    # Eyes (burning)
    draw_circle(d, 110, 84, 16, rgba(dk))
    draw_circle(d, 146, 84, 16, rgba(dk))
    draw_circle(d, 110, 84, 10, rgba(ey))
    draw_circle(d, 146, 84, 10, rgba(ey))
    draw_circle(d, 110, 84, 5, rgba((255,255,255)))
    draw_circle(d, 146, 84, 5, rgba((255,255,255)))
    # Dark sword
    d.line([(44,176),(44,48)], fill=rgba((60,0,80)), width=8)
    d.rectangle([32,48,56,64], fill=rgba(lt))
    d.polygon([(44,32),(36,52),(52,52)], fill=rgba((100,0,140)))


def draw_boss_hydra(img, color):
    d = ImageDraw.Draw(img)
    p = (40, 100, 60)
    dk = (20, 60, 30)
    lt = (80, 160, 100)
    ey = (255, 60, 0)
    # Main body
    d.ellipse([76, 148, 196, 240], fill=rgba(p), outline=rgba(dk), width=3)
    # 5 necks
    neck_data = [(88,-30),(104,-10),(128,0),(152,-10),(168,-30)]
    for nx2, ang2 in neck_data:
        end_x = int(nx2 + 50*math.sin(math.radians(ang2)))
        end_y = int(176 - 80)
        d.line([(nx2, 176),(end_x, end_y)], fill=rgba(p), width=12)
    # 5 heads
    head_xs = [60, 92, 128, 164, 196]
    for hx2 in head_xs:
        draw_circle(d, hx2, 84, 22, rgba(lt))
        d.ellipse([hx2-22, 62, hx2+22, 106], fill=rgba(lt), outline=rgba(dk), width=2)
        # Eyes
        draw_circle(d, hx2-8, 78, 7, rgba(ey))
        draw_circle(d, hx2+8, 78, 7, rgba(ey))
        draw_circle(d, hx2-8, 78, 4, rgba((0,0,0)))
        draw_circle(d, hx2+8, 78, 4, rgba((0,0,0)))
        # Fangs
        d.polygon([(hx2-8,90),(hx2-4,102),(hx2,90)], fill=rgba((230,220,200)))
        d.polygon([(hx2,90),(hx2+4,102),(hx2+8,90)], fill=rgba((230,220,200)))
    # Scales on body
    for sx2 in range(84, 190, 18):
        for sy2 in range(160, 230, 14):
            d.ellipse([sx2, sy2, sx2+14, sy2+10], fill=rgba((0,0,0,0)), outline=rgba(dk, 100), width=1)
    # Tail
    d.line([(192,216),(224,200),(240,176)], fill=rgba(p), width=12)
    d.polygon([(232,172),(240,164),(244,176)], fill=rgba(lt))


def draw_boss_fallen_angel(img, color):
    d = ImageDraw.Draw(img)
    p = (60, 40, 80)
    dk = (30, 20, 40)
    lt = (140, 100, 180)
    ey = (200, 0, 255)
    gold = (200, 180, 40)
    # Dark wings (large, tattered)
    d.polygon([(112,120),(12,52),(24,160),(80,152),(112,140)], fill=rgba((20,10,30,220)), outline=rgba(lt))
    d.polygon([(144,120),(244,52),(232,160),(176,152),(144,140)], fill=rgba((20,10,30,220)), outline=rgba(lt))
    # Torn wing edges
    for i in range(4):
        wx3 = 24 + i*14
        d.line([(wx3, 160-i*10),(wx3-4,148)], fill=rgba(lt), width=2)
        wx4 = 232 - i*14
        d.line([(wx4, 160-i*10),(wx4+4,148)], fill=rgba(lt), width=2)
    # Robe
    d.polygon([(128,132),(72,224),(184,224)], fill=rgba(p), outline=rgba(lt), width=2)
    # Body
    d.ellipse([96, 116, 160, 192], fill=rgba(p), outline=rgba(lt), width=2)
    # Halo (broken)
    d.arc([96, 40, 160, 72], 30, 320, fill=rgba(gold), width=5)
    draw_circle(d, 128, 56, 6, rgba(gold, 180))
    # Head
    draw_circle(d, 128, 96, 36, rgba(lt))
    d.ellipse([92, 60, 164, 132], fill=rgba(lt), outline=rgba(dk), width=2)
    # Eyes
    draw_circle(d, 112, 90, 12, rgba(ey))
    draw_circle(d, 144, 90, 12, rgba(ey))
    draw_circle(d, 114, 88, 6, rgba((255,255,255)))
    draw_circle(d, 146, 88, 6, rgba((255,255,255)))
    # Divine sword
    d.line([(72,196),(72,80)], fill=rgba(gold), width=6)
    d.rectangle([60,80,84,96], fill=rgba(gold))
    d.polygon([(72,64),(64,84),(80,84)], fill=rgba(lt))


def draw_boss_death_knight(img, color):
    d = ImageDraw.Draw(img)
    p = (20, 20, 30)
    dk = (10, 10, 15)
    lt = (60, 70, 100)
    ey = (0, 180, 255)
    # Shadow aura
    for r5 in [108, 96]:
        draw_circle(d, 128, 136, r5, rgba((0,0,30, 25)))
    # Legs (full plate)
    d.rectangle([88, 196, 114, 250], fill=rgba(lt), outline=rgba(dk), width=2)
    d.rectangle([142, 196, 168, 250], fill=rgba(lt), outline=rgba(dk), width=2)
    # Body (heavy armor)
    d.rectangle([76, 116, 180, 208], fill=rgba(lt), outline=rgba(dk), width=4)
    # Armor details
    d.line([(128,116),(128,208)], fill=rgba(dk), width=3)
    d.line([(76,156),(180,156)], fill=rgba(dk), width=3)
    d.polygon([(128,124),(118,140),(128,156),(138,140)], fill=rgba(ey, 150))
    # Pauldrons (shoulder armor)
    d.ellipse([52, 108, 92, 148], fill=rgba(lt), outline=rgba(dk), width=3)
    d.ellipse([164, 108, 204, 148], fill=rgba(lt), outline=rgba(dk), width=3)
    # Arms
    d.rectangle([52, 140, 84, 196], fill=rgba(lt), outline=rgba(dk), width=2)
    d.rectangle([172, 140, 204, 196], fill=rgba(lt), outline=rgba(dk), width=2)
    # Helm
    d.rectangle([84, 52, 172, 124], fill=rgba(lt), outline=rgba(dk), width=4)
    d.rectangle([84, 52, 172, 72], fill=rgba(p), outline=rgba(dk), width=2)
    # T-shaped visor
    d.rectangle([92, 76, 164, 92], fill=rgba(dk))
    d.rectangle([120, 76, 136, 116], fill=rgba(dk))
    draw_circle(d, 108, 84, 10, rgba(ey))
    draw_circle(d, 148, 84, 10, rgba(ey))
    # Death scythe
    d.line([(204,196),(204,48)], fill=rgba((80,80,100)), width=7)
    d.arc([164, 32, 216, 84], 200, 360, fill=rgba((160,160,200)), width=8)
    draw_circle(d, 196, 36, 8, rgba(ey))


# ---------------------------------------------------------------------------
# Monster registry
# ---------------------------------------------------------------------------

MONSTERS = [
    # Zone 1
    ('slime_green',   1, draw_slime),
    ('bat',           1, draw_bat),
    ('mushroom',      1, draw_mushroom),
    ('slime_blue',    2, lambda img, c: draw_slime(img, {**c, 'primary':(80,140,220),'dark':(40,80,160),'light':(140,200,255),'eye':(255,80,80)})),
    ('rat',           1, draw_rat),
    # Zone 2
    ('goblin',        2, draw_goblin),
    ('skeleton',      2, draw_skeleton),
    ('wolf',          2, draw_wolf),
    ('spider_giant',  2, draw_spider),
    ('treant',        1, draw_treant),
    # Zone 3
    ('orc',           3, draw_orc),
    ('dark_mage',     3, draw_dark_mage),
    ('golem',         3, draw_golem),
    ('harpy',         2, draw_harpy),
    ('mimic',         3, draw_mimic),
    # Zone 4
    ('lava_golem',    4, draw_lava_golem),
    ('fire_spirit',   4, draw_fire_spirit),
    ('demon_warrior', 4, draw_demon_warrior),
    ('salamander',    4, draw_salamander),
    ('cerberus',      5, draw_cerberus),
    # Zone 5
    ('shadow_knight', 5, draw_shadow_knight),
    ('lich',          5, draw_lich),
    ('behemoth',      3, draw_behemoth),
    ('dark_phoenix',  5, draw_dark_phoenix),
    ('void_worm',     5, draw_void_worm),
    # Bosses
    ('boss_troll',    0, draw_boss_troll),
    ('boss_dragon',   0, draw_boss_dragon),
    ('boss_demon_lord',0, draw_boss_demon_lord),
    ('boss_hydra',    0, draw_boss_hydra),
    ('boss_fallen_angel',0, draw_boss_fallen_angel),
    ('boss_death_knight',0, draw_boss_death_knight),
]


def apply_glow(img, color, radius=3):
    """Add a subtle outer glow by compositing a blurred tinted copy."""
    glow = img.filter(ImageFilter.GaussianBlur(radius))
    tint = Image.new('RGBA', img.size, (*color, 0))
    blended = Image.composite(glow, tint, glow)
    result = Image.alpha_composite(blended, img)
    return result


def generate_all():
    os.makedirs(OUT_DIR, exist_ok=True)
    for name, zone, draw_fn in MONSTERS:
        img = new_img()
        color = ZONE_COLORS[zone]
        try:
            draw_fn(img, color)
        except Exception as e:
            print(f"  [!] {name}: draw error ({e}), using fallback")
            img = new_img()
            _fallback(img, name, color)

        # Light glow pass
        img = apply_glow(img, ZONE_COLORS[zone]['primary'], 2)

        out_path = os.path.join(OUT_DIR, f'{name}.png')
        img.save(out_path, 'PNG')
        print(f'  ✓ {name}.png')
    print(f'\n총 {len(MONSTERS)}개 스프라이트 생성 완료 → {OUT_DIR}')


def _fallback(img, name, color):
    """Simple labeled circle as last resort."""
    d = ImageDraw.Draw(img)
    p = color['primary']
    draw_circle(d, 128, 128, 80, rgba(p), rgba(color['dark']), 4)
    draw_circle(d, 128, 100, 20, rgba(color['eye']))
    draw_circle(d, 108, 100, 12, rgba(color['eye']))
    draw_circle(d, 148, 100, 12, rgba(color['eye']))


if __name__ == '__main__':
    print('Life Quest — Sprite Generator 시작')
    generate_all()
