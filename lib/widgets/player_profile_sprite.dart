import 'package:flutter/material.dart';

class PlayerProfileSprite extends StatelessWidget {
  final String gender;
  final String skinTone;
  final String hairStyle;
  final String eyeStyle;
  final String earStyle;
  final String noseStyle;
  final String mouthStyle;
  final String outfitStyle;
  final double size;
  final bool facingRight;

  const PlayerProfileSprite({
    super.key,
    required this.gender,
    required this.skinTone,
    required this.hairStyle,
    required this.eyeStyle,
    required this.earStyle,
    required this.noseStyle,
    required this.mouthStyle,
    required this.outfitStyle,
    required this.size,
    this.facingRight = true,
  });

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.diagonal3Values(facingRight ? 1.0 : -1.0, 1.0, 1.0),
      child: CustomPaint(
        size: Size.square(size),
        painter: _FreshProfilePainter(
          skinTone: skinTone,
          hairStyle: hairStyle,
          eyeStyle: eyeStyle,
          earStyle: earStyle,
          noseStyle: noseStyle,
          mouthStyle: mouthStyle,
          outfitStyle: outfitStyle,
        ),
      ),
    );
  }
}

class _FreshProfilePainter extends CustomPainter {
  final String skinTone;
  final String hairStyle;
  final String eyeStyle;
  final String earStyle;
  final String noseStyle;
  final String mouthStyle;
  final String outfitStyle;

  const _FreshProfilePainter({
    required this.skinTone,
    required this.hairStyle,
    required this.eyeStyle,
    required this.earStyle,
    required this.noseStyle,
    required this.mouthStyle,
    required this.outfitStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const grid = 64.0;
    final px = size.shortestSide / grid;
    canvas.save();
    canvas.scale(px, px);

    final palette = _Palette(
      outline: const Color(0xFF182031),
      skin: _skinColor(),
      skinShadow: _shift(_skinColor(), -0.10),
      hair: _hairColor(),
      hairDark: _shift(_hairColor(), -0.18),
      hairLight: _shift(_hairColor(), 0.12),
      cloth: _clothColor(),
      clothDark: _shift(_clothColor(), -0.14),
      clothLight: _shift(_clothColor(), 0.10),
      accent: _accentColor(),
      eyeWhite: const Color(0xFFF6F8FF),
      eyeDark: const Color(0xFF161B24),
      blush: const Color(0xFFF0AAA7),
      shoe: const Color(0xFF131A25),
    );

    _shadow(canvas);
    _body(canvas, palette);
    _legs(canvas, palette);
    _head(canvas, palette);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _FreshProfilePainter oldDelegate) {
    return skinTone != oldDelegate.skinTone ||
        hairStyle != oldDelegate.hairStyle ||
        eyeStyle != oldDelegate.eyeStyle ||
        earStyle != oldDelegate.earStyle ||
        noseStyle != oldDelegate.noseStyle ||
        mouthStyle != oldDelegate.mouthStyle ||
        outfitStyle != oldDelegate.outfitStyle;
  }

  void _shadow(Canvas canvas) {
    final paint = Paint()
      ..color = const Color(0x22111A24)
      ..isAntiAlias = false;
    canvas.drawOval(const Rect.fromLTWH(18, 55, 28, 4), paint);
  }

  void _body(Canvas canvas, _Palette p) {
    final coat = outfitStyle == 'mage';
    final jacket = outfitStyle == 'hunter' || outfitStyle == 'knight';

    _r(canvas, p.outline, [
      const Rect.fromLTWH(22, 30, 20, 11),
      if (jacket) const Rect.fromLTWH(20, 31, 24, 2),
      if (coat) const Rect.fromLTWH(24, 40, 16, 3),
      const Rect.fromLTWH(18, 32, 2, 7),
      const Rect.fromLTWH(44, 32, 2, 7),
    ]);
    _r(canvas, p.cloth, [
      const Rect.fromLTWH(23, 31, 18, 10),
      if (jacket) const Rect.fromLTWH(21, 31, 22, 2),
      if (coat) const Rect.fromLTWH(25, 40, 14, 2),
    ]);
    _r(canvas, p.clothDark, const [
      Rect.fromLTWH(24, 40, 16, 1),
      Rect.fromLTWH(19, 33, 1, 5),
      Rect.fromLTWH(44, 33, 1, 5),
    ]);
    _r(canvas, p.clothLight, switch (outfitStyle) {
      'hunter' => const [
          Rect.fromLTWH(25, 32, 12, 2),
          Rect.fromLTWH(28, 35, 8, 2),
        ],
      'knight' => const [
          Rect.fromLTWH(29, 31, 5, 9),
          Rect.fromLTWH(26, 34, 10, 1),
        ],
      'mage' => const [
          Rect.fromLTWH(28, 31, 8, 2),
          Rect.fromLTWH(30, 34, 4, 5),
        ],
      _ => const [
          Rect.fromLTWH(26, 32, 12, 2),
        ],
    });
    _r(canvas, p.accent, switch (outfitStyle) {
      'hunter' => const [
          Rect.fromLTWH(24, 34, 3, 4),
          Rect.fromLTWH(37, 34, 3, 4),
          Rect.fromLTWH(30, 30, 4, 2),
        ],
      'knight' => const [
          Rect.fromLTWH(27, 36, 10, 2),
        ],
      'mage' => const [
          Rect.fromLTWH(25, 39, 14, 1),
        ],
      _ => const [
          Rect.fromLTWH(29, 35, 6, 1),
        ],
    });
    _r(canvas, p.skin, const [
      Rect.fromLTWH(19, 38, 1, 2),
      Rect.fromLTWH(44, 38, 1, 2),
      Rect.fromLTWH(28, 28, 8, 2),
    ]);
  }

  void _legs(Canvas canvas, _Palette p) {
    _r(canvas, p.outline, const [
      Rect.fromLTWH(25, 42, 5, 10),
      Rect.fromLTWH(34, 42, 5, 10),
    ]);
    _r(canvas, p.skin, const [
      Rect.fromLTWH(26, 43, 3, 7),
      Rect.fromLTWH(35, 43, 3, 7),
    ]);
    _r(canvas, p.skinShadow, const [
      Rect.fromLTWH(28, 43, 1, 7),
      Rect.fromLTWH(37, 43, 1, 7),
    ]);
    _r(canvas, p.shoe, const [
      Rect.fromLTWH(24, 51, 7, 3),
      Rect.fromLTWH(34, 51, 7, 3),
    ]);
  }

  void _head(Canvas canvas, _Palette p) {
    _r(canvas, p.outline, const [
      Rect.fromLTWH(18, 6, 28, 1),
      Rect.fromLTWH(16, 7, 32, 1),
      Rect.fromLTWH(15, 8, 34, 18),
      Rect.fromLTWH(16, 26, 32, 2),
      Rect.fromLTWH(18, 28, 28, 1),
      Rect.fromLTWH(14, 11, 1, 12),
      Rect.fromLTWH(49, 11, 1, 12),
    ]);
    _r(canvas, p.skin, const [
      Rect.fromLTWH(19, 7, 26, 1),
      Rect.fromLTWH(17, 8, 30, 1),
      Rect.fromLTWH(16, 9, 32, 16),
      Rect.fromLTWH(17, 25, 30, 2),
      Rect.fromLTWH(19, 27, 26, 1),
      Rect.fromLTWH(15, 12, 1, 10),
      Rect.fromLTWH(48, 12, 1, 10),
    ]);
    _ears(canvas, p);
    _hair(canvas, p);
    _face(canvas, p);
  }

  void _ears(Canvas canvas, _Palette p) {
    if (earStyle == 'hidden') return;
    final ears = switch (earStyle) {
      'small' => const [
          Rect.fromLTWH(14, 18, 1, 3),
          Rect.fromLTWH(49, 18, 1, 3),
        ],
      'tall' => const [
          Rect.fromLTWH(13, 16, 2, 6),
          Rect.fromLTWH(49, 16, 2, 6),
        ],
      _ => const [
          Rect.fromLTWH(13, 17, 2, 5),
          Rect.fromLTWH(49, 17, 2, 5),
        ],
    };
    _r(canvas, p.skin, ears);
    _r(canvas, p.skinShadow, const [
      Rect.fromLTWH(14, 19, 1, 2),
      Rect.fromLTWH(49, 19, 1, 2),
    ]);
  }

  void _hair(Canvas canvas, _Palette p) {
    _r(canvas, p.outline, switch (hairStyle) {
      'wave' => const [
          Rect.fromLTWH(11, 3, 42, 12),
          Rect.fromLTWH(10, 15, 9, 15),
          Rect.fromLTWH(45, 15, 9, 15),
          Rect.fromLTWH(16, 27, 7, 4),
          Rect.fromLTWH(41, 27, 7, 4),
        ],
      'bob' => const [
          Rect.fromLTWH(13, 3, 38, 12),
          Rect.fromLTWH(11, 15, 8, 13),
          Rect.fromLTWH(45, 15, 8, 13),
        ],
      'short' => const [
          Rect.fromLTWH(14, 4, 36, 9),
          Rect.fromLTWH(13, 14, 4, 6),
          Rect.fromLTWH(47, 14, 4, 6),
        ],
      _ => const [
          Rect.fromLTWH(13, 3, 38, 10),
          Rect.fromLTWH(12, 14, 5, 9),
          Rect.fromLTWH(47, 14, 5, 9),
          Rect.fromLTWH(17, 12, 8, 10),
          Rect.fromLTWH(29, 9, 6, 12),
          Rect.fromLTWH(39, 12, 8, 10),
          Rect.fromLTWH(21, 8, 4, 2),
          Rect.fromLTWH(39, 8, 4, 2),
        ],
    });

    _r(canvas, p.hair, switch (hairStyle) {
      'wave' => const [
          Rect.fromLTWH(12, 4, 40, 10),
          Rect.fromLTWH(11, 16, 7, 13),
          Rect.fromLTWH(46, 16, 7, 13),
          Rect.fromLTWH(17, 12, 8, 8),
          Rect.fromLTWH(28, 11, 8, 10),
          Rect.fromLTWH(39, 12, 8, 8),
        ],
      'bob' => const [
          Rect.fromLTWH(14, 4, 36, 10),
          Rect.fromLTWH(12, 16, 6, 11),
          Rect.fromLTWH(46, 16, 6, 11),
          Rect.fromLTWH(19, 13, 8, 8),
          Rect.fromLTWH(29, 12, 7, 9),
          Rect.fromLTWH(38, 13, 7, 8),
        ],
      'short' => const [
          Rect.fromLTWH(15, 5, 34, 7),
          Rect.fromLTWH(14, 15, 3, 4),
          Rect.fromLTWH(47, 15, 3, 4),
          Rect.fromLTWH(20, 12, 7, 5),
          Rect.fromLTWH(29, 11, 6, 5),
          Rect.fromLTWH(38, 12, 6, 5),
        ],
      _ => const [
          Rect.fromLTWH(14, 4, 36, 8),
          Rect.fromLTWH(13, 15, 4, 7),
          Rect.fromLTWH(47, 15, 4, 7),
          Rect.fromLTWH(17, 12, 8, 9),
          Rect.fromLTWH(28, 8, 8, 13),
          Rect.fromLTWH(39, 12, 8, 9),
          Rect.fromLTWH(23, 16, 4, 5),
          Rect.fromLTWH(37, 16, 4, 5),
        ],
    });

    _r(canvas, p.hairDark, switch (hairStyle) {
      'wave' => const [
          Rect.fromLTWH(17, 14, 30, 2),
          Rect.fromLTWH(17, 23, 2, 4),
          Rect.fromLTWH(45, 23, 2, 4),
        ],
      'bob' => const [
          Rect.fromLTWH(17, 14, 30, 2),
        ],
      'short' => const [
          Rect.fromLTWH(18, 13, 28, 2),
        ],
      _ => const [
          Rect.fromLTWH(18, 14, 28, 2),
          Rect.fromLTWH(28, 9, 8, 2),
          Rect.fromLTWH(24, 20, 4, 1),
          Rect.fromLTWH(36, 20, 4, 1),
        ],
    });

    _r(canvas, p.hairLight, switch (hairStyle) {
      'short' => const [
          Rect.fromLTWH(21, 7, 6, 1),
          Rect.fromLTWH(37, 7, 6, 1),
        ],
      _ => const [
          Rect.fromLTWH(19, 7, 8, 1),
          Rect.fromLTWH(37, 7, 8, 1),
        ],
    });
  }

  void _face(Canvas canvas, _Palette p) {
    _r(canvas, p.eyeWhite, switch (eyeStyle) {
      'sharp' => const [
          Rect.fromLTWH(20, 19, 8, 4),
          Rect.fromLTWH(36, 19, 8, 4),
        ],
      'sleepy' => const [
          Rect.fromLTWH(20, 20, 8, 3),
          Rect.fromLTWH(36, 20, 8, 3),
        ],
      'smile' => const [
          Rect.fromLTWH(20, 21, 8, 2),
          Rect.fromLTWH(36, 21, 8, 2),
        ],
      _ => const [
          Rect.fromLTWH(20, 18, 8, 7),
          Rect.fromLTWH(36, 18, 8, 7),
        ],
    });

    _r(canvas, p.eyeDark, switch (eyeStyle) {
      'sharp' => const [
          Rect.fromLTWH(22, 19, 4, 3),
          Rect.fromLTWH(38, 19, 4, 3),
        ],
      'sleepy' => const [
          Rect.fromLTWH(22, 20, 4, 2),
          Rect.fromLTWH(38, 20, 4, 2),
        ],
      'smile' => const [
          Rect.fromLTWH(21, 21, 5, 1),
          Rect.fromLTWH(37, 21, 5, 1),
        ],
      _ => const [
          Rect.fromLTWH(22, 19, 3, 5),
          Rect.fromLTWH(39, 19, 3, 5),
        ],
    });

    if (eyeStyle != 'smile') {
      _r(canvas, Colors.white, const [
        Rect.fromLTWH(22, 20, 1, 1),
        Rect.fromLTWH(39, 20, 1, 1),
      ]);
    }

    _r(canvas, p.blush.withValues(alpha: 0.8), const [
      Rect.fromLTWH(22, 25, 2, 1),
      Rect.fromLTWH(40, 25, 2, 1),
    ]);

    _r(canvas, p.skinShadow, switch (noseStyle) {
      'line' => const [
          Rect.fromLTWH(31, 27, 2, 1),
          Rect.fromLTWH(32, 28, 1, 1),
        ],
      'soft' => const [
          Rect.fromLTWH(32, 27, 1, 2),
        ],
      _ => const [
          Rect.fromLTWH(32, 27, 1, 1),
        ],
    });

    _r(canvas, const Color(0xFF8E5258), switch (mouthStyle) {
      'open' => const [
          Rect.fromLTWH(29, 31, 5, 2),
        ],
      'flat' => const [
          Rect.fromLTWH(28, 31, 6, 1),
        ],
      'smirk' => const [
          Rect.fromLTWH(28, 31, 5, 1),
          Rect.fromLTWH(32, 30, 1, 1),
        ],
      _ => const [
          Rect.fromLTWH(28, 31, 6, 1),
          Rect.fromLTWH(29, 32, 4, 1),
        ],
    });
  }

  Color _skinColor() {
    switch (skinTone) {
      case 'warm':
        return const Color(0xFFD8A47D);
      case 'tan':
        return const Color(0xFFB87F59);
      case 'deep':
        return const Color(0xFF83563E);
      default:
        return const Color(0xFFF4DBCA);
    }
  }

  Color _hairColor() {
    switch (hairStyle) {
      case 'short':
        return const Color(0xFF2A2431);
      case 'wave':
        return const Color(0xFF4A2F39);
      case 'bob':
        return const Color(0xFF6E4937);
      default:
        return const Color(0xFF1F2432);
    }
  }

  Color _clothColor() {
    switch (outfitStyle) {
      case 'hunter':
        return const Color(0xFF2C3E5C);
      case 'knight':
        return const Color(0xFF6A8EE8);
      case 'mage':
        return const Color(0xFF7259A8);
      default:
        return const Color(0xFFE4D6C8);
    }
  }

  Color _accentColor() {
    switch (outfitStyle) {
      case 'hunter':
        return const Color(0xFF79A8D7);
      case 'knight':
        return const Color(0xFFE4F0FF);
      case 'mage':
        return const Color(0xFFD9C7FF);
      default:
        return const Color(0xFFC9B59F);
    }
  }

  Color _shift(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  void _r(Canvas canvas, Color color, List<Rect> rects) {
    final paint = Paint()
      ..color = color
      ..isAntiAlias = false;
    for (final rect in rects) {
      canvas.drawRect(rect, paint);
    }
  }
}

class _Palette {
  final Color outline;
  final Color skin;
  final Color skinShadow;
  final Color hair;
  final Color hairDark;
  final Color hairLight;
  final Color cloth;
  final Color clothDark;
  final Color clothLight;
  final Color accent;
  final Color eyeWhite;
  final Color eyeDark;
  final Color blush;
  final Color shoe;

  const _Palette({
    required this.outline,
    required this.skin,
    required this.skinShadow,
    required this.hair,
    required this.hairDark,
    required this.hairLight,
    required this.cloth,
    required this.clothDark,
    required this.clothLight,
    required this.accent,
    required this.eyeWhite,
    required this.eyeDark,
    required this.blush,
    required this.shoe,
  });
}
