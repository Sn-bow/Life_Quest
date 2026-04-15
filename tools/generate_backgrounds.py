"""
Life Quest — Battle Background Generator
Generates 5 zone battle backgrounds (800x480) using Pillow.
Zone 1: Meadow, Zone 2: Dark Forest, Zone 3: Stone Castle,
Zone 4: Lava Cavern, Zone 5: Abyssal Void
"""

import math
import os
import random
from PIL import Image, ImageDraw, ImageFilter

OUT_DIR = os.path.join(os.path.dirname(__file__), '..', 'assets', 'images', 'backgrounds')
W, H = 800, 480

os.makedirs(OUT_DIR, exist_ok=True)
random.seed(42)


def lerp_color(c1, c2, t):
    return tuple(int(c1[i] + (c2[i] - c1[i]) * t) for i in range(3))


def gradient_fill(img, top_color, bottom_color):
    d = ImageDraw.Draw(img)
    for y in range(H):
        t = y / H
        c = lerp_color(top_color, bottom_color, t)
        d.line([(0, y), (W, y)], fill=(*c, 255))


# ---------------------------------------------------------------------------
# Zone 1 — Meadow (bright green plains, blue sky)
# ---------------------------------------------------------------------------
def make_meadow():
    img = Image.new('RGBA', (W, H))
    gradient_fill(img, (100, 160, 230), (190, 220, 255))  # sky
    d = ImageDraw.Draw(img)

    # Distant hills
    for hx, hy, hr in [(100,320,160),(300,300,200),(550,310,180),(750,325,150)]:
        d.ellipse([hx-hr, hy-hr//2, hx+hr, hy+hr//2], fill=(90,160,80,200))

    # Ground
    d.rectangle([0, 340, W, H], fill=(80, 160, 60))
    d.ellipse([-100, 300, W+100, 420], fill=(100, 180, 70))

    # Grass tufts
    rng = random.Random(1)
    for _ in range(60):
        gx = rng.randint(0, W)
        gy = rng.randint(340, H - 20)
        for dx in [-6, 0, 6]:
            d.line([(gx+dx, gy), (gx+dx+rng.randint(-4,4), gy-rng.randint(10,22))],
                   fill=(60, 140, 40), width=2)

    # Clouds
    for cx, cy in [(150,80),(380,60),(620,90),(760,55)]:
        for ox, oy, r in [(0,0,30),(-28,-8,22),(28,-8,22),(0,-18,18)]:
            d.ellipse([cx+ox-r, cy+oy-r, cx+ox+r, cy+oy+r], fill=(255,255,255,220))

    # Flowers
    flower_rng = random.Random(7)
    colors = [(255,80,80),(255,200,50),(200,80,255),(255,255,80)]
    for _ in range(30):
        fx = flower_rng.randint(0, W)
        fy = flower_rng.randint(350, H-10)
        fc = colors[flower_rng.randint(0, len(colors)-1)]
        d.ellipse([fx-4,fy-4,fx+4,fy+4], fill=(*fc,220))
        d.ellipse([fx-2,fy-2,fx+2,fy+2], fill=(255,240,100,255))

    # Light rays
    overlay = Image.new('RGBA', (W, H), (0,0,0,0))
    od = ImageDraw.Draw(overlay)
    for rx in range(0, W, 80):
        od.polygon([(rx-20,0),(rx+20,0),(rx+60,H),(rx-60,H)], fill=(255,255,220,12))
    img = Image.alpha_composite(img, overlay)

    return img.filter(ImageFilter.GaussianBlur(0.6))


# ---------------------------------------------------------------------------
# Zone 2 — Dark Forest (twilight, tall trees, fog)
# ---------------------------------------------------------------------------
def make_dark_forest():
    img = Image.new('RGBA', (W, H))
    gradient_fill(img, (20, 30, 60), (40, 60, 40))
    d = ImageDraw.Draw(img)

    # Moon
    d.ellipse([620, 30, 680, 90], fill=(230, 230, 180, 200))
    d.ellipse([634, 34, 690, 90], fill=(20, 30, 60, 180))  # crescent cutout

    # Stars
    rng = random.Random(3)
    for _ in range(60):
        sx, sy = rng.randint(0, W), rng.randint(0, 160)
        sa = rng.randint(100, 220)
        d.ellipse([sx-1,sy-1,sx+1,sy+1], fill=(255,255,255,sa))

    # Background trees (far)
    for tx in range(-30, W+30, 55):
        th = rng.randint(180, 260)
        d.polygon([(tx,H),(tx+28,H),(tx+14,H-th)], fill=(15,35,20,200))
        d.polygon([(tx,H),(tx+28,H),(tx+14,H-th*0.7)], fill=(20,50,25,150))

    # Foreground trees (dark silhouettes)
    for tx in [0, 120, 260, 380, 500, 650, 780]:
        th = rng.randint(300, 420)
        tw = rng.randint(22, 36)
        d.polygon([(tx,H),(tx+tw,H),(tx+tw//2,H-th)], fill=(8,18,10,240))

    # Fog layers
    fog = Image.new('RGBA', (W, H), (0,0,0,0))
    fd = ImageDraw.Draw(fog)
    for _ in range(8):
        fy = rng.randint(300, 420)
        fw = rng.randint(200, 400)
        fx = rng.randint(-100, W)
        fd.ellipse([fx, fy-30, fx+fw, fy+30], fill=(180,200,180,25))
    img = Image.alpha_composite(img, fog)

    # Ground
    d2 = ImageDraw.Draw(img)
    d2.rectangle([0, 400, W, H], fill=(20, 35, 15, 240))

    return img.filter(ImageFilter.GaussianBlur(0.8))


# ---------------------------------------------------------------------------
# Zone 3 — Stone Castle (interior, torch-lit dungeon)
# ---------------------------------------------------------------------------
def make_stone_castle():
    img = Image.new('RGBA', (W, H))
    gradient_fill(img, (30, 25, 35), (55, 45, 50))
    d = ImageDraw.Draw(img)

    # Stone wall bricks
    brick_color = (80, 70, 75)
    mortar_color = (45, 40, 45)
    bh, bw = 40, 80
    for row in range(H // bh + 1):
        offset = (row % 2) * (bw // 2)
        for col in range(-1, W // bw + 2):
            bx = col * bw + offset
            by = row * bh
            d.rectangle([bx+2, by+2, bx+bw-2, by+bh-2], fill=brick_color, outline=mortar_color, width=2)

    # Darkness overlay (top/sides)
    overlay = Image.new('RGBA', (W, H), (0,0,0,0))
    od = ImageDraw.Draw(overlay)
    od.rectangle([0,0,W,H//3], fill=(0,0,0,120))
    for darkness_x in [(0, 120), (W-120, W)]:
        od.rectangle([darkness_x[0],0,darkness_x[1],H], fill=(0,0,0,100))
    img = Image.alpha_composite(img, overlay)

    # Torches (left and right)
    d2 = ImageDraw.Draw(img)
    for tx in [140, W-140]:
        # Bracket
        d2.rectangle([tx-6, 200, tx+6, 240], fill=(100,80,40))
        d2.rectangle([tx-16, 196, tx+16, 208], fill=(120,100,50))
        # Flame (layered ellipses)
        for r, fc, fa in [(22,(255,200,0),180),(16,(255,140,0),200),(9,(255,80,0),230),(4,(255,255,180),255)]:
            d2.ellipse([tx-r//2, 168-r, tx+r//2, 200], fill=(*fc,fa))

    # Torch glow (additive)
    for tx in [140, W-140]:
        for radius in [120, 80, 50]:
            alpha = max(0, 50 - radius // 3)
            glow = Image.new('RGBA', (W, H), (0,0,0,0))
            gd = ImageDraw.Draw(glow)
            gd.ellipse([tx-radius, 180-radius, tx+radius, 180+radius], fill=(255,160,0,alpha))
            img = Image.alpha_composite(img, glow)

    # Floor
    d3 = ImageDraw.Draw(img)
    d3.rectangle([0, 380, W, H], fill=(50, 40, 45))
    for fx in range(0, W, 60):
        d3.line([(fx, 380),(fx, H)], fill=(35,28,32), width=2)
    for fy in range(380, H, 40):
        d3.line([(0, fy),(W, fy)], fill=(35,28,32), width=2)

    return img


# ---------------------------------------------------------------------------
# Zone 4 — Lava Cavern (red/orange, glowing rock, lava pools)
# ---------------------------------------------------------------------------
def make_lava_cavern():
    img = Image.new('RGBA', (W, H))
    gradient_fill(img, (40, 10, 5), (80, 25, 10))
    d = ImageDraw.Draw(img)

    rng = random.Random(5)

    # Stalactites (top)
    for sx in range(20, W, 55):
        sh = rng.randint(60, 160)
        sw = rng.randint(16, 36)
        d.polygon([(sx-sw//2, 0),(sx+sw//2, 0),(sx, sh)], fill=(60,20,10))

    # Rock walls (sides)
    for _ in range(20):
        rx = rng.randint(0, 80) if rng.random() < 0.5 else rng.randint(W-80, W)
        ry = rng.randint(0, H)
        rr = rng.randint(20, 60)
        d.ellipse([rx-rr,ry-rr,rx+rr,ry+rr], fill=(55,20,8))

    # Lava pools (bottom)
    d.rectangle([0, 390, W, H], fill=(200,50,0))
    for lx, lw in [(50,120),(220,180),(450,140),(640,160)]:
        d.ellipse([lx, 380, lx+lw, 420], fill=(240,100,0,220))
        # Glow on lava
        d.ellipse([lx+10, 384, lx+lw-10, 414], fill=(255,200,0,140))

    # Lava glow upward
    glow_layer = Image.new('RGBA', (W, H), (0,0,0,0))
    gd = ImageDraw.Draw(glow_layer)
    gd.rectangle([0, 300, W, H], fill=(200,60,0,40))
    img = Image.alpha_composite(img, glow_layer)

    # Hot cracks in ceiling
    d2 = ImageDraw.Draw(img)
    for _ in range(6):
        cx = rng.randint(100, W-100)
        cy = rng.randint(0, 60)
        pts = [(cx, cy)]
        for _ in range(6):
            pts.append((pts[-1][0]+rng.randint(-30,30), pts[-1][1]+rng.randint(10,30)))
        for i in range(len(pts)-1):
            d2.line([pts[i], pts[i+1]], fill=(255,140,0,180), width=2)

    # Embers / sparks
    for _ in range(40):
        ex = rng.randint(0, W)
        ey = rng.randint(280, H)
        ea = rng.randint(100, 220)
        er = rng.randint(1, 3)
        d2.ellipse([ex-er,ey-er,ex+er,ey+er], fill=(255,200,50,ea))

    return img.filter(ImageFilter.GaussianBlur(0.5))


# ---------------------------------------------------------------------------
# Zone 5 — Abyssal Void (deep space/void, purple/black, cosmic)
# ---------------------------------------------------------------------------
def make_abyss():
    img = Image.new('RGBA', (W, H))
    gradient_fill(img, (5, 0, 20), (15, 5, 40))
    d = ImageDraw.Draw(img)

    rng = random.Random(9)

    # Nebula clouds (blurred ellipses)
    nebula = Image.new('RGBA', (W, H), (0,0,0,0))
    nd = ImageDraw.Draw(nebula)
    for _ in range(12):
        nx = rng.randint(-60, W+60)
        ny = rng.randint(-40, H+40)
        nw = rng.randint(80, 260)
        nh = rng.randint(40, 120)
        nc = rng.choice([(80,0,140),(40,0,100),(100,20,180),(0,60,120),(120,0,80)])
        nd.ellipse([nx-nw//2,ny-nh//2,nx+nw//2,ny+nh//2], fill=(*nc,40))
    nebula = nebula.filter(ImageFilter.GaussianBlur(30))
    img = Image.alpha_composite(img, nebula)

    # Stars (varied brightness)
    d2 = ImageDraw.Draw(img)
    for _ in range(200):
        sx, sy = rng.randint(0, W), rng.randint(0, H)
        sa = rng.randint(80, 255)
        sr = rng.randint(0, 2)
        if sr == 0:
            d2.point((sx, sy), fill=(255,255,255,sa))
        else:
            d2.ellipse([sx-sr,sy-sr,sx+sr,sy+sr], fill=(200,180,255,sa))

    # Void tendrils
    for _ in range(8):
        tx = rng.randint(0, W)
        ty = rng.randint(H//2, H)
        pts = [(tx, ty)]
        for _ in range(8):
            pts.append((pts[-1][0]+rng.randint(-40,40), pts[-1][1]-rng.randint(20,60)))
        for i in range(len(pts)-1):
            alpha = int(200 * (1 - i/len(pts)))
            d2.line([pts[i], pts[i+1]], fill=(100,0,180,alpha), width=rng.randint(2,5))

    # Glowing orbs (void eyes)
    for ox, oy, oc in [(160,200,(180,0,255)),(600,160,(0,200,255)),(380,300,(255,0,180))]:
        for r, a in [(40,30),(25,60),(14,120),(6,240)]:
            d2.ellipse([ox-r,oy-r,ox+r,oy+r], fill=(*oc,a))

    # Ground/platform (dark)
    d2.rectangle([0, 420, W, H], fill=(8, 3, 18))
    d2.ellipse([-100, 400, W+100, 450], fill=(12, 4, 28))

    # Void mist at bottom
    mist = Image.new('RGBA', (W, H), (0,0,0,0))
    md = ImageDraw.Draw(mist)
    for _ in range(6):
        mx = rng.randint(-80, W)
        mw = rng.randint(200, 500)
        md.ellipse([mx, 380, mx+mw, 440], fill=(60,0,120,35))
    mist = mist.filter(ImageFilter.GaussianBlur(20))
    img = Image.alpha_composite(img, mist)

    return img


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
BACKGROUNDS = [
    ('bg_zone1_meadow.png',       make_meadow),
    ('bg_zone2_dark_forest.png',  make_dark_forest),
    ('bg_zone3_stone_castle.png', make_stone_castle),
    ('bg_zone4_lava_cavern.png',  make_lava_cavern),
    ('bg_zone5_abyss.png',        make_abyss),
]

if __name__ == '__main__':
    print('Life Quest \u2014 Background Generator \uc2dc\uc791')
    count = 0
    for filename, fn in BACKGROUNDS:
        try:
            result = fn()
            out_path = os.path.join(OUT_DIR, filename)
            result.save(out_path, 'PNG')
            print(f'  \u2713 {filename}')
            count += 1
        except Exception as e:
            print(f'  [!] {filename}: {e}')
    print(f'\n\uc644\ub8cc: {count}\uac1c \ubc30\uacbd \uc0dd\uc131 \u2192 {OUT_DIR}')
