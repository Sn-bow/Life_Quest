import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/models/monster.dart';

class MonsterBattleSprite extends StatelessWidget {
  final Monster monster;
  final double size;
  final double hitProgress;

  const MonsterBattleSprite({
    super.key,
    required this.monster,
    required this.size,
    required this.hitProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(-hitProgress * 10, 0),
      child: CustomPaint(
        size: Size.square(size),
        painter: _MonsterBattlePainter(
          monster: monster,
          hitProgress: hitProgress,
        ),
      ),
    );
  }
}

class _MonsterBattlePainter extends CustomPainter {
  final Monster monster;
  final double hitProgress;

  const _MonsterBattlePainter({
    required this.monster,
    required this.hitProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const grid = 64.0;
    final px = size.shortestSide / grid;
    canvas.save();
    canvas.scale(px, px);

    final family = _familyFor(monster.id);
    switch (family) {
      case _MonsterFamily.slime:
        _drawSlime(canvas);
        break;
      case _MonsterFamily.beast:
        _drawBeast(canvas);
        break;
      case _MonsterFamily.plant:
        _drawPlant(canvas);
        break;
      case _MonsterFamily.humanoid:
        _drawHumanoid(canvas);
        break;
      case _MonsterFamily.golem:
        _drawGolem(canvas);
        break;
      case _MonsterFamily.spirit:
        _drawSpirit(canvas);
        break;
    }

    if (hitProgress > 0) {
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: 0.16 + hitProgress * 0.25)
        ..isAntiAlias = false;
      canvas.drawCircle(const Offset(32, 26), 18 + hitProgress * 8, paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MonsterBattlePainter oldDelegate) {
    return monster.id != oldDelegate.monster.id ||
        monster.currentHp != oldDelegate.monster.currentHp ||
        hitProgress != oldDelegate.hitProgress;
  }

  void _drawSlime(Canvas canvas) {
    final base = monster.id.contains('blue')
        ? const Color(0xFF4AA7FF)
        : const Color(0xFF59D97A);
    final dark = _shade(base, -0.18);
    final light = _shade(base, 0.12);
    _rects(canvas, const Color(0xFF172235), const [
      Rect.fromLTWH(14, 23, 36, 23),
      Rect.fromLTWH(18, 18, 28, 6),
    ]);
    _rects(canvas, base, const [
      Rect.fromLTWH(15, 24, 34, 20),
      Rect.fromLTWH(19, 19, 26, 5),
    ]);
    _rects(canvas, dark, const [
      Rect.fromLTWH(18, 40, 28, 3),
      Rect.fromLTWH(23, 28, 6, 3),
      Rect.fromLTWH(35, 28, 6, 3),
    ]);
    _rects(canvas, light, const [
      Rect.fromLTWH(24, 23, 8, 1),
      Rect.fromLTWH(36, 24, 6, 1),
    ]);
    _eyes(canvas, 24, 33, 37, 33);
  }

  void _drawBeast(Canvas canvas) {
    final base = monster.id.contains('wolf')
        ? const Color(0xFF4B5168)
        : const Color(0xFF7B5D42);
    final dark = _shade(base, -0.2);
    final light = _shade(base, 0.14);
    _rects(canvas, const Color(0xFF172033), const [
      Rect.fromLTWH(13, 24, 33, 16),
      Rect.fromLTWH(10, 29, 6, 10),
      Rect.fromLTWH(43, 29, 6, 10),
      Rect.fromLTWH(18, 18, 5, 6),
      Rect.fromLTWH(36, 18, 5, 6),
      Rect.fromLTWH(20, 40, 5, 12),
      Rect.fromLTWH(37, 40, 5, 12),
    ]);
    _rects(canvas, base, const [
      Rect.fromLTWH(14, 25, 31, 13),
      Rect.fromLTWH(11, 30, 4, 8),
      Rect.fromLTWH(44, 30, 4, 8),
      Rect.fromLTWH(19, 19, 3, 4),
      Rect.fromLTWH(37, 19, 3, 4),
      Rect.fromLTWH(21, 41, 3, 10),
      Rect.fromLTWH(38, 41, 3, 10),
    ]);
    _rects(canvas, dark, const [
      Rect.fromLTWH(18, 33, 24, 3),
      Rect.fromLTWH(29, 27, 5, 4),
    ]);
    _rects(canvas, light, const [
      Rect.fromLTWH(20, 26, 9, 1),
    ]);
    _eyes(canvas, 24, 31, 37, 31);
  }

  void _drawPlant(Canvas canvas) {
    final cap = monster.id.contains('mushroom')
        ? const Color(0xFFB14F7B)
        : const Color(0xFF5EAA60);
    _rects(canvas, const Color(0xFF21312E), const [
      Rect.fromLTWH(15, 17, 34, 14),
      Rect.fromLTWH(23, 31, 18, 18),
      Rect.fromLTWH(18, 45, 6, 7),
      Rect.fromLTWH(40, 45, 6, 7),
    ]);
    _rects(canvas, cap, const [
      Rect.fromLTWH(16, 18, 32, 12),
    ]);
    _rects(canvas, const Color(0xFFECE0CA), const [
      Rect.fromLTWH(24, 31, 16, 16),
    ]);
    _rects(canvas, _shade(cap, 0.18), const [
      Rect.fromLTWH(20, 21, 4, 3),
      Rect.fromLTWH(30, 21, 4, 3),
      Rect.fromLTWH(40, 22, 4, 3),
    ]);
    _eyes(canvas, 28, 35, 35, 35);
  }

  void _drawHumanoid(Canvas canvas) {
    final robe = monster.id.contains('mage')
        ? const Color(0xFF6A42A8)
        : monster.id.contains('skeleton')
            ? const Color(0xFFCED4E0)
            : const Color(0xFF5B4B3C);
    final skin = monster.id.contains('skeleton')
        ? const Color(0xFFECE7D7)
        : const Color(0xFF84C96B);
    _rects(canvas, const Color(0xFF162033), const [
      Rect.fromLTWH(21, 8, 24, 18),
      Rect.fromLTWH(18, 26, 30, 24),
      Rect.fromLTWH(15, 30, 4, 14),
      Rect.fromLTWH(47, 30, 4, 14),
      Rect.fromLTWH(23, 50, 6, 10),
      Rect.fromLTWH(38, 50, 6, 10),
    ]);
    _rects(canvas, skin, const [
      Rect.fromLTWH(22, 9, 22, 16),
    ]);
    _rects(canvas, robe, const [
      Rect.fromLTWH(19, 27, 28, 21),
      Rect.fromLTWH(16, 31, 3, 11),
      Rect.fromLTWH(48, 31, 3, 11),
      Rect.fromLTWH(24, 51, 4, 8),
      Rect.fromLTWH(39, 51, 4, 8),
    ]);
    _eyes(canvas, 28, 16, 37, 16);
  }

  void _drawGolem(Canvas canvas) {
    final rock = monster.id.contains('lava')
        ? const Color(0xFF7E5348)
        : const Color(0xFF7F8898);
    final glow = monster.id.contains('lava')
        ? const Color(0xFFFF8B4A)
        : const Color(0xFF7DE1FF);
    _rects(canvas, const Color(0xFF202533), const [
      Rect.fromLTWH(14, 11, 36, 20),
      Rect.fromLTWH(11, 27, 42, 21),
      Rect.fromLTWH(8, 31, 5, 13),
      Rect.fromLTWH(51, 31, 5, 13),
      Rect.fromLTWH(20, 48, 7, 12),
      Rect.fromLTWH(37, 48, 7, 12),
    ]);
    _rects(canvas, rock, const [
      Rect.fromLTWH(15, 12, 34, 18),
      Rect.fromLTWH(12, 28, 40, 18),
      Rect.fromLTWH(9, 32, 3, 10),
      Rect.fromLTWH(52, 32, 3, 10),
      Rect.fromLTWH(21, 49, 5, 10),
      Rect.fromLTWH(38, 49, 5, 10),
    ]);
    _rects(canvas, glow, const [
      Rect.fromLTWH(24, 18, 4, 3),
      Rect.fromLTWH(38, 18, 4, 3),
      Rect.fromLTWH(30, 34, 5, 3),
    ]);
  }

  void _drawSpirit(Canvas canvas) {
    final core = monster.id.contains('fire')
        ? const Color(0xFFFF8B44)
        : const Color(0xFF8A63FF);
    final aura = _shade(core, 0.18);
    final dark = _shade(core, -0.22);
    _rects(canvas, dark.withValues(alpha: 0.5), const [
      Rect.fromLTWH(18, 16, 28, 29),
    ]);
    _rects(canvas, aura, const [
      Rect.fromLTWH(20, 18, 24, 24),
    ]);
    _rects(canvas, core, const [
      Rect.fromLTWH(24, 22, 16, 16),
      Rect.fromLTWH(22, 38, 20, 7),
    ]);
    _eyes(canvas, 27, 28, 37, 28);
  }

  void _eyes(Canvas canvas, double x1, double y1, double x2, double y2) {
    _rects(canvas, Colors.white, [
      Rect.fromLTWH(x1, y1, 4, 4),
      Rect.fromLTWH(x2, y2, 4, 4),
    ]);
    _rects(canvas, const Color(0xFF111827), [
      Rect.fromLTWH(x1 + 1, y1 + 1, 2, 2),
      Rect.fromLTWH(x2 + 1, y2 + 1, 2, 2),
    ]);
  }

  _MonsterFamily _familyFor(String id) {
    if (id.contains('slime')) return _MonsterFamily.slime;
    if (id.contains('bat') ||
        id.contains('rat') ||
        id.contains('wolf') ||
        id.contains('cerberus') ||
        id.contains('harpy') ||
        id.contains('salamander')) {
      return _MonsterFamily.beast;
    }
    if (id.contains('mushroom') || id.contains('treant')) {
      return _MonsterFamily.plant;
    }
    if (id.contains('goblin') ||
        id.contains('skeleton') ||
        id.contains('orc') ||
        id.contains('shadow_knight') ||
        id.contains('demon_warrior') ||
        id.contains('dark_mage') ||
        id.contains('lich')) {
      return _MonsterFamily.humanoid;
    }
    if (id.contains('golem') || id.contains('mimic')) {
      return _MonsterFamily.golem;
    }
    return _MonsterFamily.spirit;
  }

  Color _shade(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  void _rects(Canvas canvas, Color color, List<Rect> rects) {
    final paint = Paint()
      ..color = color
      ..isAntiAlias = false;
    for (final rect in rects) {
      canvas.drawRect(rect, paint);
    }
  }
}

enum _MonsterFamily { slime, beast, plant, humanoid, golem, spirit }
