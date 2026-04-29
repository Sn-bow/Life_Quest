#!/usr/bin/env python3
"""
Life Quest - Marketing Screenshot Generator v4 (Cinematic Hero)
스타일: Dark Glow · Centered Hero Phone · Short Copy · Floating Chips · Grid Overlay
규격: 1080 × 1920 (Google Play)
레이아웃: 상단 텍스트 (전체 폭) + 중앙 대형 폰 + 하단 chip 2개
"""
from PIL import Image, ImageDraw, ImageFont, ImageFilter
import os, random, math

BASE    = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
QA_DIR  = os.path.join(BASE, "qa_artifacts")
OUT_DIR = os.path.join(BASE, "marketing_screenshots")
os.makedirs(OUT_DIR, exist_ok=True)

W, H = 1080, 1920

# ── 폰트 ──────────────────────────────────────────────────────────────
def load_font(size, bold=False):
    for path in [
        r"C:\Windows\Fonts\malgunbd.ttf" if bold else r"C:\Windows\Fonts\malgun.ttf",
        r"C:\Windows\Fonts\NanumGothicBold.ttf" if bold else r"C:\Windows\Fonts\NanumGothic.ttf",
        "/usr/share/fonts/truetype/nanum/NanumGothicBold.ttf" if bold
            else "/usr/share/fonts/truetype/nanum/NanumGothic.ttf",
    ]:
        if os.path.exists(path):
            try: return ImageFont.truetype(path, size)
            except: pass
    return ImageFont.load_default()

def load_emoji_font(size):
    for path in [r"C:\Windows\Fonts\seguiemj.ttf", r"C:\Windows\Fonts\seguisym.ttf"]:
        if os.path.exists(path):
            try: return ImageFont.truetype(path, size)
            except: pass
    return None

def is_emoji(ch):
    cp = ord(ch)
    return 0x1F000 <= cp <= 0x1FFFF or 0x2600 <= cp <= 0x27BF or cp == 0xFE0F

# ── 슬라이드 정의 (v4: 2줄 헤드라인, chips 2개) ───────────────────────
SLIDES = [
    dict(
        out      = "01_daily_quest.png",
        shot     = "mkt_01_status.png",
        headline = "일상을\nRPG로",
        sub      = "할 일을 퀘스트로 등록하고 레벨업",
        chips    = ["📊 스탯 4종 성장", "🏆 레벨업 & 칭호"],
        bg_dark  = (5, 3, 18),
        glow_col = (120, 40, 220),
        accent   = (190, 110, 255),
        neon     = (210, 150, 255),
        tilt     = 0,
    ),
    dict(
        out      = "02_card_battle.png",
        shot     = "mkt_05_battle_start.png",
        headline = "전략적\n카드 배틀",
        sub      = "207장의 카드로 최강 덱을 완성하라",
        chips    = ["🃏 207장 카드", "⚔️ 턴제 전략"],
        bg_dark  = (18, 3, 3),
        glow_col = (200, 40, 20),
        accent   = (255, 90, 60),
        neon     = (255, 150, 120),
        tilt     = 0,
    ),
    dict(
        out      = "03_dungeon_map.png",
        shot     = "mkt_04_dungeon_map.png",
        headline = "던전을\n정복하라",
        sub      = "5개 존 · 다양한 이벤트 · 보스 전투",
        chips    = ["🗺️ 5개 던전 존", "👹 33종 몬스터"],
        bg_dark  = (3, 8, 22),
        glow_col = (20, 60, 200),
        accent   = (70, 160, 255),
        neon     = (130, 200, 255),
        tilt     = 0,
    ),
    dict(
        out      = "04_quest_system.png",
        shot     = "mkt_02_quest.png",
        headline = "퀘스트로\n레벨업",
        sub      = "일일 · 주간 퀘스트로 XP & 골드 획득",
        chips    = ["📅 일일/주간 퀘스트", "💰 XP & 골드"],
        bg_dark  = (3, 14, 6),
        glow_col = (20, 160, 50),
        accent   = (60, 210, 100),
        neon     = (120, 240, 150),
        tilt     = 0,
    ),
    dict(
        out      = "05_dungeon_home.png",
        shot     = "mkt_03_dungeon_home.png",
        headline = "최강 덱을\n완성하라",
        sub      = "31개 렐릭 · 나만의 전략을 구축",
        chips    = ["💎 31개 렐릭", "🔀 전략 덱 빌딩"],
        bg_dark  = (16, 10, 2),
        glow_col = (180, 110, 10),
        accent   = (255, 190, 45),
        neon     = (255, 215, 100),
        tilt     = 0,
    ),
]

# ── 배경: Dark + Radial Glow (중앙 상단 배치) ─────────────────────────
def make_dark_bg(w, h, bg_dark, glow_col, glow_cx_ratio=0.5, glow_cy_ratio=0.35):
    base = Image.new("RGB", (w, h), bg_dark)

    # Glow blob 1 (메인 — 중앙 상단)
    gr = int(min(w, h) * 0.85)
    gcx = int(w * glow_cx_ratio)
    gcy = int(h * glow_cy_ratio)
    glow = Image.new("RGB", (w, h), (0, 0, 0))
    gd = ImageDraw.Draw(glow)
    r, g, b = glow_col
    for i in range(5):
        alpha_factor = 0.55 - i * 0.09
        ri = int(gr * (1 - i * 0.14))
        col = (int(r * alpha_factor), int(g * alpha_factor), int(b * alpha_factor))
        gd.ellipse([(gcx - ri, gcy - ri), (gcx + ri, gcy + ri)], fill=col)
    glow = glow.filter(ImageFilter.GaussianBlur(radius=gr // 2))
    result = Image.blend(base, glow, 0.9)

    # Glow blob 2 (소형 — 좌하단 포인트)
    glow2 = Image.new("RGB", (w, h), (0, 0, 0))
    gd2 = ImageDraw.Draw(glow2)
    gr2 = int(min(w, h) * 0.32)
    gd2.ellipse([(int(w*0.08)-gr2, int(h*0.82)-gr2),
                  (int(w*0.08)+gr2, int(h*0.82)+gr2)],
                 fill=(int(r*0.22), int(g*0.22), int(b*0.22)))
    glow2 = glow2.filter(ImageFilter.GaussianBlur(radius=gr2 // 2))
    result = Image.blend(result, glow2, 0.45)
    return result

# ── 배경 격자 패턴 (게임 UI 분위기) ──────────────────────────────────
def add_grid_overlay(canvas, accent_col, spacing=64, alpha=6):
    """얇은 수직/수평 라인 그리드 — 매우 은은하게"""
    overlay = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    od = ImageDraw.Draw(overlay)
    r, g, b = accent_col
    for y in range(0, canvas.height, spacing):
        od.line([(0, y), (canvas.width - 1, y)], fill=(r, g, b, alpha), width=1)
    for x in range(0, canvas.width, spacing):
        od.line([(x, 0), (x, canvas.height - 1)], fill=(r, g, b, alpha), width=1)
    base = canvas.convert("RGBA")
    return Image.alpha_composite(base, overlay).convert("RGB")

# ── Noise/grain overlay ───────────────────────────────────────────────
def add_noise(img, seed=0, intensity=10):
    rng = random.Random(seed * 7919)
    overlay = Image.new("RGBA", img.size, (0, 0, 0, 0))
    pixels = overlay.load()
    for y in range(0, img.height, 2):
        for x in range(0, img.width, 2):
            v = rng.randint(-intensity, intensity)
            a = rng.randint(0, 16)
            pixels[x, y] = (max(0, v), max(0, v), max(0, v), a)
    base = img.convert("RGBA")
    return Image.alpha_composite(base, overlay).convert("RGB")

# ── 배경에 스크린샷 흐리게 깔기 (depth) ─────────────────────────────
def add_bg_screenshot(canvas, shot_path, opacity=0.12):
    if not os.path.exists(shot_path):
        return canvas
    src = Image.open(shot_path).convert("RGB")
    src = src.resize((W, H), Image.LANCZOS)
    src = src.filter(ImageFilter.GaussianBlur(radius=30))
    dark = Image.new("RGB", (W, H), (0, 0, 0))
    src = Image.blend(dark, src, opacity)
    return Image.blend(canvas, src, 0.6)

# ── 텍스트 글로우 ─────────────────────────────────────────────────────
def draw_glow_text(canvas, text, x, y, font, color, glow_color, glow_r=26):
    """멀티라인 지원 텍스트 + Gaussian glow 효과"""
    text_lines = text.split("\n")
    dummy = ImageDraw.Draw(canvas)
    line_h = dummy.textbbox((0, 0), "가", font=font)[3] + 14

    for i, line in enumerate(text_lines):
        ly = y + i * line_h
        # 글로우 레이어 (2회 합성으로 강도↑)
        glow = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
        gd = ImageDraw.Draw(glow)
        gd.text((x, ly), line, font=font, fill=(*glow_color, 175))
        glow = glow.filter(ImageFilter.GaussianBlur(glow_r))
        base_rgba = canvas.convert("RGBA")
        base_rgba = Image.alpha_composite(base_rgba, glow)
        base_rgba = Image.alpha_composite(base_rgba, glow)
        canvas.paste(base_rgba.convert("RGB"), (0, 0))
        # 실제 텍스트 (흰색)
        ImageDraw.Draw(canvas).text((x, ly), line, font=font, fill=color)

    return y + len(text_lines) * line_h

# ── 스크린샷 폰 목업 ──────────────────────────────────────────────────
def make_phone_card(shot_path, pw, ph, accent, tilt_deg=0):
    """실제 스크린샷이 들어간 폰 목업 RGBA 이미지 반환"""
    card = Image.new("RGBA", (pw + 80, ph + 80), (0, 0, 0, 0))
    draw = ImageDraw.Draw(card)
    radius = 48
    ox, oy = 40, 30

    # 드롭 섀도 (20레이어, 부드럽게)
    for i in range(20, 0, -2):
        a = int(165 * (20 - i) / 20)
        draw.rounded_rectangle(
            [(ox - i // 2, oy + i // 3), (ox + pw + i // 2, oy + ph + i // 3)],
            radius=radius + i // 3, fill=(0, 0, 0, a)
        )

    # 베젤
    draw.rounded_rectangle(
        [(40, 30), (40 + pw, 30 + ph)],
        radius=radius, fill=(22, 22, 30, 255),
        outline=(70, 70, 90, 255), width=3
    )

    # 스크린 영역
    sx, sy = 40 + 13, 30 + 13
    sw, sh = pw - 26, ph - 26
    draw.rounded_rectangle(
        [(sx, sy), (sx + sw, sy + sh)],
        radius=radius - 8, fill=(8, 8, 14, 255)
    )

    # 노치
    nw_notch, nh_notch = 100, 16
    nx = 40 + (pw - nw_notch) // 2
    draw.rounded_rectangle([(nx, 32), (nx + nw_notch, 32 + nh_notch)],
                            radius=8, fill=(15, 15, 22, 255))

    # 홈바
    bw = 80
    bx = 40 + (pw - bw) // 2
    draw.rounded_rectangle([(bx, 30 + ph - 16), (bx + bw, 30 + ph - 10)],
                            radius=3, fill=(120, 120, 140, 200))

    # 측면 버튼
    draw.rounded_rectangle([(36, 130), (40, 185)], radius=2, fill=(50, 50, 70, 255))
    draw.rounded_rectangle([(36, 200), (40, 250)], radius=2, fill=(50, 50, 70, 255))
    draw.rounded_rectangle([(40 + pw, 160), (44 + pw, 230)], radius=2, fill=(50, 50, 70, 255))

    # 액센트 라인 (화면 상단)
    ar, ag, ab = accent
    draw.line([(sx + 18, sy + 2), (sx + sw - 18, sy + 2)],
              fill=(ar, ag, ab, 100), width=2)

    # 스크린샷 붙이기 (crop & fit)
    if os.path.exists(shot_path):
        src = Image.open(shot_path).convert("RGB")
        src_r = src.width / src.height
        scr_r = sw / sh
        if src_r > scr_r:
            nw2 = round(src.width * sh / src.height); nh2 = sh
        else:
            nw2 = sw; nh2 = round(src.height * sw / src.width)
        src = src.resize((nw2, nh2), Image.LANCZOS)
        cx2 = (nw2 - sw) // 2; cy2 = (nh2 - sh) // 2
        src = src.crop((cx2, cy2, cx2 + sw, cy2 + sh))
        mask = Image.new("L", (sw, sh), 0)
        ImageDraw.Draw(mask).rounded_rectangle(
            [(0, 0), (sw - 1, sh - 1)], radius=radius - 8, fill=255)
        card.paste(src, (sx, sy), mask)

    # 기울임
    if tilt_deg != 0:
        card = card.rotate(tilt_deg, expand=True, resample=Image.BICUBIC)
    return card

# ── 이모지 혼합 텍스트 유틸 ──────────────────────────────────────────
def measure_mixed(draw, text, main_font, emoji_font):
    total = 0
    for ch in text:
        if ch == "\uFE0F": continue
        font = emoji_font if (emoji_font and is_emoji(ch)) else main_font
        bb = draw.textbbox((0, 0), ch, font=font)
        total += bb[2] - bb[0]
    return total

def draw_mixed(draw, text, x, y, main_font, emoji_font, fill):
    for ch in text:
        if ch == "\uFE0F": continue
        use_e = emoji_font and is_emoji(ch)
        font = emoji_font if use_e else main_font
        bb = draw.textbbox((0, 0), ch, font=font)
        cw = bb[2] - bb[0]
        ey = y + (0 if not use_e else max(0, -bb[1]))
        draw.text((x, ey), ch, font=font, fill=fill)
        x += cw

# ── Floating Chips (하단 2개, 크고 선명하게) ─────────────────────────
def draw_floating_chips(canvas, chips, y, accent, neon):
    """폰 아래 떠있는 stat chip 2개 — 이모지+텍스트 혼합"""
    draw = ImageDraw.Draw(canvas)
    font_main = load_font(34)
    emoji_font = load_emoji_font(34)
    r, g, b = accent
    nr, ng, nb = neon
    gap = 36
    pad_x, pad_y = 34, 18

    # chip별 텍스트 너비 측정
    chip_inner_ws = [measure_mixed(draw, c, font_main, emoji_font) for c in chips]
    chip_outer_ws = [w + pad_x * 2 for w in chip_inner_ws]
    total_w = sum(chip_outer_ws) + gap * (len(chips) - 1)
    sx = (W - total_w) // 2

    ch_h = draw.textbbox((0, 0), "가", font=font_main)[3]
    bh = ch_h + pad_y * 2

    for i, chip in enumerate(chips):
        bx = sx + sum(chip_outer_ws[:i]) + gap * i
        pw = chip_outer_ws[i]

        # pill 배경
        overlay = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
        od = ImageDraw.Draw(overlay)
        od.rounded_rectangle(
            [(bx, y), (bx + pw, y + bh)],
            radius=bh // 2,
            fill=(r, g, b, 38),
            outline=(r, g, b, 210), width=2
        )
        canvas_rgba = canvas.convert("RGBA")
        canvas.paste(Image.alpha_composite(canvas_rgba, overlay).convert("RGB"), (0, 0))

        # 텍스트 (중앙 정렬)
        iw = chip_inner_ws[i]
        tx = bx + (pw - iw) // 2
        ty = y + pad_y
        draw_mixed(ImageDraw.Draw(canvas), chip, tx, ty,
                   font_main, emoji_font, (nr, ng, nb))

# ── 메인 생성 ─────────────────────────────────────────────────────────
def generate(slide, idx):
    bg_dark  = slide["bg_dark"]
    glow_col = slide["glow_col"]
    accent   = slide["accent"]
    neon     = slide["neon"]
    tilt     = slide["tilt"]
    r, g, b  = accent
    nr, ng, nb = neon

    # ① 배경 (glow 중앙 상단)
    canvas = make_dark_bg(W, H, bg_dark, glow_col,
                          glow_cx_ratio=0.5, glow_cy_ratio=0.32)

    # ② 배경 스크린샷 (흐리게, depth 강화)
    canvas = add_bg_screenshot(canvas,
                               os.path.join(QA_DIR, slide["shot"]),
                               opacity=0.12)

    # ③ 격자 패턴 (게임 UI 분위기)
    canvas = add_grid_overlay(canvas, accent, spacing=64, alpha=6)

    # ④ Noise grain
    canvas = add_noise(canvas, seed=idx, intensity=10)

    draw = ImageDraw.Draw(canvas)

    # ⑤ 앱 이름 (좌상단, 작게)
    font_name = load_font(28, bold=True)
    name_col = (min(r + 100, 255), min(g + 100, 255), min(b + 100, 255))
    draw.text((72, 64), "LIFE QUEST", font=font_name, fill=name_col)
    bb_name = draw.textbbox((0, 0), "LIFE QUEST", font=font_name)
    draw.line([(72, 64 + bb_name[3] + 6),
               (72 + bb_name[2] + 16, 64 + bb_name[3] + 6)],
              fill=(r, g, b), width=2)

    # ⑥ 헤드라인 (좌측, 110px bold, 2줄)
    font_hl = load_font(110, bold=True)
    hl_x = 66
    hl_y = 126
    hl_bottom = draw_glow_text(canvas, slide["headline"], hl_x, hl_y,
                               font_hl, (255, 255, 255), (r, g, b), glow_r=28)

    # ⑦ Accent 수직 라인 (헤드라인 왼쪽)
    ImageDraw.Draw(canvas).rectangle(
        [(50, hl_y), (55, hl_bottom - 16)],
        fill=(r, g, b)
    )

    # ⑧ 서브텍스트 (헤드라인 아래)
    font_sub = load_font(36)
    sub_col = (min(nr + 30, 255), min(ng + 30, 255), min(nb + 30, 255))
    sub_text = slide["sub"]
    # 너비 체크 (W*0.8 초과 시 중간 공백에서 줄바꿈)
    sub_bb = ImageDraw.Draw(canvas).textbbox((0, 0), sub_text, font=font_sub)
    if sub_bb[2] > int(W * 0.8):
        mid = len(sub_text) // 2
        for delta in range(mid):
            done = False
            for pos in [mid - delta, mid + delta]:
                if 0 < pos < len(sub_text) and sub_text[pos] == ' ':
                    sub_text = sub_text[:pos] + '\n' + sub_text[pos + 1:]
                    done = True
                    break
            if done:
                break
    sub_y = hl_bottom + 24
    sub_lh = ImageDraw.Draw(canvas).textbbox((0, 0), "가", font=font_sub)[3] + 8
    for sl in sub_text.split('\n'):
        ImageDraw.Draw(canvas).text((hl_x, sub_y), sl, font=font_sub, fill=sub_col)
        sub_y += sub_lh

    text_bottom = sub_y + 16  # 텍스트 영역 하단

    # ⑨ 폰 목업 (중앙 배치, 570px 폭, 62% 최대 높이)
    ph_w = 570
    ph_h = int(ph_w * 2220 / 1080)   # ≈ 1172
    max_ph_h = int(H * 0.62)          # ≈ 1190  →  ph_h 1172 < 1190 (OK)
    if ph_h > max_ph_h:
        ph_h = max_ph_h
        ph_w = int(ph_h * 1080 / 2220)

    phone_card = make_phone_card(
        os.path.join(QA_DIR, slide["shot"]),
        ph_w, ph_h, accent, tilt_deg=tilt
    )
    pc_w, pc_h = phone_card.size

    # 중앙 배치 (텍스트 끝난 뒤부터, 하단 chip 공간 보존)
    pc_x = (W - pc_w) // 2
    pc_x = max(0, min(pc_x, W - pc_w))

    chip_reserve = 145      # chip 높이 + 여백
    pc_y = max(text_bottom, 430)
    # 하단 chip 공간 확보
    if pc_y + pc_h > H - chip_reserve:
        pc_y = H - chip_reserve - pc_h

    # 폰 뒤 글로우 (부드러운 halo)
    phone_glow = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    pgd = ImageDraw.Draw(phone_glow)
    pg_cx = pc_x + pc_w // 2
    pg_cy = pc_y + pc_h // 2
    for i in range(4):
        pg_r = int(min(pc_w, pc_h) * (0.52 - i * 0.08))
        pgd.ellipse([(pg_cx - pg_r, pg_cy - pg_r),
                     (pg_cx + pg_r, pg_cy + pg_r)],
                    fill=(r, g, b, 20 - i * 4))
    phone_glow = phone_glow.filter(ImageFilter.GaussianBlur(90))
    c_rgba = canvas.convert("RGBA")
    canvas.paste(Image.alpha_composite(c_rgba, phone_glow).convert("RGB"), (0, 0))

    # 폰 붙이기
    canvas.paste(phone_card, (pc_x, pc_y), phone_card)

    # ⑩ 하단 그라디언트 (chip 가독성)
    fade_h = 260
    fade_full = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    fd = ImageDraw.Draw(fade_full)
    for fy in range(fade_h):
        a = int(205 * (fy / fade_h) ** 0.65)
        r2 = int(bg_dark[0] * fy / fade_h)
        g2 = int(bg_dark[1] * fy / fade_h)
        b2 = int(bg_dark[2] * fy / fade_h)
        fd.line([(0, H - fade_h + fy), (W - 1, H - fade_h + fy)],
                fill=(r2, g2, b2, a))
    c_rgba = canvas.convert("RGBA")
    canvas.paste(Image.alpha_composite(c_rgba, fade_full).convert("RGB"), (0, 0))

    # ⑪ Floating Chips (하단 2개)
    chip_y = H - 128
    draw_floating_chips(canvas, slide["chips"], chip_y, accent, neon)

    # ⑫ 하단 thin accent line
    ImageDraw.Draw(canvas).line(
        [(72, H - 155), (W - 72, H - 155)],
        fill=(r, g, b, 60), width=1
    )

    # 저장
    out_path = os.path.join(OUT_DIR, slide["out"])
    canvas.save(out_path, "PNG", optimize=True)
    size_kb = os.path.getsize(out_path) // 1024
    print(f"  OK {slide['out']}  ({size_kb} KB)")


# ── Feature Graphic (1024×500) — 폰 목업 추가 ────────────────────────
def generate_feature_graphic():
    FW, FH = 1024, 500
    # 배경
    canvas = make_dark_bg(FW, FH, (5, 3, 18), (100, 30, 200),
                          glow_cx_ratio=0.42, glow_cy_ratio=0.5)
    canvas = add_grid_overlay(canvas, (150, 80, 255), spacing=48, alpha=5)
    canvas = add_noise(canvas, seed=99)
    draw = ImageDraw.Draw(canvas)

    # 앱 이름
    fn = load_font(24, bold=True)
    draw.text((58, 42), "LIFE QUEST", font=fn, fill=(190, 150, 255))
    bb = draw.textbbox((0, 0), "LIFE QUEST", font=fn)
    draw.line([(58, 42 + bb[3] + 4), (58 + bb[2] + 14, 42 + bb[3] + 4)],
              fill=(150, 80, 255), width=2)

    # 헤드라인 (크기 자동 조정)
    hl_text = "일상을 RPG로 — 매일 성장하라"
    fhl = load_font(68, bold=True)
    bb_hl = draw.textbbox((0, 0), hl_text, font=fhl)
    if bb_hl[2] > FW - 380:   # 우측 폰 공간 확보
        fhl = load_font(54, bold=True)
    # 글로우
    glow = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    gd = ImageDraw.Draw(glow)
    gd.text((56, 90), hl_text, font=fhl, fill=(120, 40, 220, 155))
    glow = glow.filter(ImageFilter.GaussianBlur(18))
    c_rgba = canvas.convert("RGBA")
    c_rgba = Image.alpha_composite(c_rgba, glow)
    c_rgba = Image.alpha_composite(c_rgba, glow)
    canvas.paste(c_rgba.convert("RGB"), (0, 0))
    draw2 = ImageDraw.Draw(canvas)
    draw2.text((56, 90), hl_text, font=fhl, fill=(255, 255, 255))

    # 수직 액센트 라인
    draw2.rectangle([(42, 90), (47, 178)], fill=(180, 80, 255))

    # 서브
    fsub = load_font(28)
    draw2.text((58, 198), "퀘스트 · Soul Deck 카드 배틀 · 던전 탐험",
               font=fsub, fill=(175, 145, 225))

    # Feature pills
    tags = ["207장 카드", "31개 렐릭", "5개 던전"]
    font_t = load_font(24)
    tx = 58
    for tag in tags:
        bb_t = draw2.textbbox((0, 0), tag, font=font_t)
        tw = bb_t[2] - bb_t[0]; th = bb_t[3] - bb_t[1]
        px2, py2 = 20, 9
        pw2 = tw + px2 * 2; ph2 = th + py2 * 2
        ov = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
        od = ImageDraw.Draw(ov)
        od.rounded_rectangle([(tx, 268), (tx + pw2, 268 + ph2)],
                              radius=ph2 // 2,
                              fill=(140, 60, 220, 38),
                              outline=(160, 80, 255, 190), width=2)
        c_rgba = canvas.convert("RGBA")
        canvas.paste(Image.alpha_composite(c_rgba, ov).convert("RGB"), (0, 0))
        draw3 = ImageDraw.Draw(canvas)
        draw3.text((tx + px2, 268 + py2), tag, font=font_t, fill=(200, 170, 255))
        tx += pw2 + 18

    # 슬로건
    fsl = load_font(21)
    ImageDraw.Draw(canvas).text(
        (58, 388), "Google Play에서 무료 다운로드",
        font=fsl, fill=(115, 95, 155)
    )

    # 우측 폰 목업 (소형, 기울임)
    pfx_w = 200
    pfx_h = int(pfx_w * 2220 / 1080)   # ≈ 411
    max_pfx_h = FH - 20
    if pfx_h > max_pfx_h:
        pfx_h = max_pfx_h
        pfx_w = int(pfx_h * 1080 / 2220)

    shot_path = os.path.join(QA_DIR, "mkt_03_dungeon_home.png")
    phone_sm = make_phone_card(shot_path, pfx_w, pfx_h, (190, 110, 255), tilt_deg=-8)
    px, py = FW - phone_sm.width - 10, (FH - phone_sm.height) // 2
    px = max(0, px); py = max(0, py)

    # 폰 글로우
    pg = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    pgd = ImageDraw.Draw(pg)
    pg_cx = px + phone_sm.width // 2
    pg_cy = py + phone_sm.height // 2
    for i in range(3):
        pgr = int(min(phone_sm.width, phone_sm.height) * (0.55 - i * 0.1))
        pgd.ellipse([(pg_cx - pgr, pg_cy - pgr), (pg_cx + pgr, pg_cy + pgr)],
                    fill=(120, 40, 220, 18 - i * 4))
    pg = pg.filter(ImageFilter.GaussianBlur(40))
    c_rgba = canvas.convert("RGBA")
    canvas.paste(Image.alpha_composite(c_rgba, pg).convert("RGB"), (0, 0))
    canvas.paste(phone_sm, (px, py), phone_sm)

    out_path = os.path.join(OUT_DIR, "feature_graphic.png")
    canvas.save(out_path, "PNG", optimize=True)
    size_kb = os.path.getsize(out_path) // 1024
    print(f"  OK feature_graphic.png  ({size_kb} KB)  [1024×500]")


if __name__ == "__main__":
    import sys
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    print("Life Quest — Marketing Generator v4 (Cinematic Hero)\n")
    print("[Screenshots 1080×1920]")
    for i, slide in enumerate(SLIDES):
        generate(slide, i)
    print("\n[Feature Graphic 1024×500]")
    generate_feature_graphic()
    print(f"\n[Output] {OUT_DIR}")
    print(f"[Done]   {len(SLIDES)} screenshots + 1 feature graphic")
