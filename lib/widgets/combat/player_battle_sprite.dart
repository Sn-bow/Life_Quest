import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/models/item.dart';

class PlayerBattleSprite extends StatelessWidget {
  final String gender;
  final String skinTone;
  final String hairStyle;
  final String eyeStyle;
  final String earStyle;
  final String noseStyle;
  final String mouthStyle;
  final String outfitStyle;
  final EquipmentItem? weapon;
  final EquipmentItem? armor;
  final EquipmentItem? accessory;
  final double size;
  final double attackProgress;
  final double defendProgress;
  final bool facingRight;

  const PlayerBattleSprite({
    super.key,
    required this.gender,
    required this.skinTone,
    required this.hairStyle,
    required this.eyeStyle,
    required this.earStyle,
    required this.noseStyle,
    required this.mouthStyle,
    required this.outfitStyle,
    required this.weapon,
    required this.armor,
    required this.accessory,
    required this.size,
    required this.attackProgress,
    required this.defendProgress,
    this.facingRight = true,
  });

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..scale(facingRight ? 1.0 : -1.0, 1.0),
      child: CustomPaint(
        size: Size.square(size),
        painter: _PlayerBattlePainter(
          gender: gender,
          skinTone: skinTone,
          hairStyle: hairStyle,
          eyeStyle: eyeStyle,
          earStyle: earStyle,
          noseStyle: noseStyle,
          mouthStyle: mouthStyle,
          outfitStyle: outfitStyle,
          weapon: weapon,
          armor: armor,
          accessory: accessory,
          attackProgress: attackProgress,
          defendProgress: defendProgress,
        ),
      ),
    );
  }
}

class _PlayerBattlePainter extends CustomPainter {
  final String gender;
  final String skinTone;
  final String hairStyle;
  final String eyeStyle;
  final String earStyle;
  final String noseStyle;
  final String mouthStyle;
  final String outfitStyle;
  final EquipmentItem? weapon;
  final EquipmentItem? armor;
  final EquipmentItem? accessory;
  final double attackProgress;
  final double defendProgress;

  const _PlayerBattlePainter({
    required this.gender,
    required this.skinTone,
    required this.hairStyle,
    required this.eyeStyle,
    required this.earStyle,
    required this.noseStyle,
    required this.mouthStyle,
    required this.outfitStyle,
    required this.weapon,
    required this.armor,
    required this.accessory,
    required this.attackProgress,
    required this.defendProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const grid = 64.0;
    final px = size.shortestSide / grid;
    canvas.save();
    canvas.scale(px, px);

    final palette = _Palette(
      outline: const Color(0xFF152033),
      skin: _skinColor(),
      skinShadow: _shade(_skinColor(), -0.15),
      hair: _hairColor(),
      hairDark: _shade(_hairColor(), -0.18),
      hairLight: _shade(_hairColor(), 0.16),
      cloth: _clothColor(),
      clothDark: _shade(_clothColor(), -0.2),
      clothLight: _shade(_clothColor(), 0.16),
      metal: _metalColor(),
      effect: const Color(0xFF87E8FF),
      eyeDark: const Color(0xFF0F172A),
      eyeWhite: const Color(0xFFFAFBFF),
      blush: const Color(0xFFF3ABA2),
      shoe: const Color(0xFF0D1422),
    );

    _drawGroundShadow(canvas);
    canvas.save();
    canvas.translate(-attackProgress * 3, 0);
    _drawLegs(canvas, palette);
    _drawBody(canvas, palette);
    _drawArms(canvas, palette);
    _drawHead(canvas, palette);
    _drawWeapon(canvas, palette);
    _drawAccessory(canvas, palette);
    canvas.restore();
    if (defendProgress > 0) {
      _drawDefendAura(canvas, palette);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PlayerBattlePainter oldDelegate) {
    return gender != oldDelegate.gender ||
        skinTone != oldDelegate.skinTone ||
        hairStyle != oldDelegate.hairStyle ||
        eyeStyle != oldDelegate.eyeStyle ||
        earStyle != oldDelegate.earStyle ||
        noseStyle != oldDelegate.noseStyle ||
        mouthStyle != oldDelegate.mouthStyle ||
        outfitStyle != oldDelegate.outfitStyle ||
        weapon?.id != oldDelegate.weapon?.id ||
        armor?.id != oldDelegate.armor?.id ||
        accessory?.id != oldDelegate.accessory?.id ||
        attackProgress != oldDelegate.attackProgress ||
        defendProgress != oldDelegate.defendProgress;
  }

  void _drawGroundShadow(Canvas canvas) {
    final shadow = Paint()..color = const Color(0x22152033);
    canvas.drawOval(const Rect.fromLTWH(18, 56, 26, 5), shadow);
  }

  void _drawLegs(Canvas canvas, _Palette p) {
    _rects(canvas, p.outline, const [
      Rect.fromLTWH(24, 39, 7, 18),
      Rect.fromLTWH(33, 39, 7, 18),
    ]);
    _rects(canvas, p.clothDark, const [
      Rect.fromLTWH(25, 40, 5, 14),
      Rect.fromLTWH(34, 40, 5, 14),
    ]);
    _rects(canvas, p.shoe, const [
      Rect.fromLTWH(24, 54, 7, 3),
      Rect.fromLTWH(33, 54, 7, 3),
    ]);
  }

  void _drawBody(Canvas canvas, _Palette p) {
    final torso = armor != null ? p.metal : p.cloth;
    final torsoDark = armor != null ? _shade(p.metal, -0.22) : p.clothDark;
    _rects(canvas, p.outline, const [
      Rect.fromLTWH(19, 23, 27, 18),
      Rect.fromLTWH(23, 19, 18, 5),
    ]);
    _rects(canvas, torso, const [
      Rect.fromLTWH(20, 24, 25, 15),
      Rect.fromLTWH(24, 20, 16, 3),
    ]);
    _rects(canvas, torsoDark, const [
      Rect.fromLTWH(21, 37, 23, 2),
      Rect.fromLTWH(20, 24, 3, 13),
      Rect.fromLTWH(42, 24, 3, 13),
    ]);
    _rects(canvas, p.skin, const [Rect.fromLTWH(29, 19, 6, 5)]);
    if (outfitStyle == 'knight') {
      _rects(canvas, p.clothLight, const [
        Rect.fromLTWH(31, 24, 2, 12),
        Rect.fromLTWH(25, 27, 14, 1),
      ]);
    } else if (outfitStyle == 'mage') {
      _rects(canvas, p.clothLight, const [
        Rect.fromLTWH(31, 24, 2, 11),
        Rect.fromLTWH(23, 38, 19, 1),
      ]);
    } else {
      _rects(canvas, p.clothLight, const [
        Rect.fromLTWH(25, 25, 14, 1),
      ]);
    }
  }

  void _drawArms(Canvas canvas, _Palette p) {
    final lift = (attackProgress * 6).roundToDouble();
    _rects(canvas, p.outline, [
      Rect.fromLTWH(13, 25 - lift, 6, 17),
      const Rect.fromLTWH(46, 25, 6, 17),
    ]);
    _rects(canvas, p.cloth, [
      Rect.fromLTWH(14, 26 - lift, 4, 12),
      const Rect.fromLTWH(47, 26, 4, 12),
    ]);
    _rects(canvas, p.skin, [
      Rect.fromLTWH(14, 38 - lift, 4, 3),
      const Rect.fromLTWH(47, 38, 4, 3),
    ]);
  }

  void _drawHead(Canvas canvas, _Palette p) {
    _rects(canvas, p.outline, const [
      Rect.fromLTWH(18, 5, 28, 22),
      Rect.fromLTWH(17, 8, 1, 14),
      Rect.fromLTWH(46, 8, 1, 14),
      Rect.fromLTWH(22, 27, 20, 1),
    ]);
    _rects(canvas, p.skin, const [
      Rect.fromLTWH(19, 6, 26, 20),
      Rect.fromLTWH(18, 9, 1, 12),
      Rect.fromLTWH(45, 9, 1, 12),
    ]);
    if (earStyle != 'hidden') {
      final earRects = switch (earStyle) {
        'small' => const [Rect.fromLTWH(17, 13, 1, 5), Rect.fromLTWH(46, 13, 1, 5)],
        'tall' => const [Rect.fromLTWH(17, 11, 2, 7), Rect.fromLTWH(45, 11, 2, 7)],
        _ => const [Rect.fromLTWH(17, 12, 2, 6), Rect.fromLTWH(45, 12, 2, 6)],
      };
      _rects(canvas, p.skin, earRects);
      _rects(canvas, p.skinShadow, const [
        Rect.fromLTWH(18, 14, 1, 2),
        Rect.fromLTWH(45, 14, 1, 2),
      ]);
    }
    _drawHair(canvas, p);
    _drawFace(canvas, p);
  }

  void _drawHair(Canvas canvas, _Palette p) {
    final outline = switch (hairStyle) {
      'wave' => const [
          Rect.fromLTWH(16, 3, 32, 11),
          Rect.fromLTWH(15, 11, 6, 15),
          Rect.fromLTWH(43, 11, 6, 15),
        ],
      'bob' => const [
          Rect.fromLTWH(17, 3, 30, 10),
          Rect.fromLTWH(16, 10, 5, 14),
          Rect.fromLTWH(43, 10, 5, 14),
        ],
      'short' => const [
          Rect.fromLTWH(17, 3, 30, 9),
          Rect.fromLTWH(16, 10, 4, 8),
          Rect.fromLTWH(44, 10, 4, 8),
        ],
      _ => const [
          Rect.fromLTWH(17, 3, 30, 10),
          Rect.fromLTWH(16, 10, 5, 10),
          Rect.fromLTWH(43, 10, 5, 10),
        ],
    };
    _rects(canvas, p.outline, outline);
    final fill = switch (hairStyle) {
      'wave' => const [
          Rect.fromLTWH(17, 4, 30, 8),
          Rect.fromLTWH(16, 12, 4, 12),
          Rect.fromLTWH(44, 12, 4, 12),
          Rect.fromLTWH(22, 11, 4, 4),
          Rect.fromLTWH(35, 11, 4, 4),
        ],
      'bob' => const [
          Rect.fromLTWH(18, 4, 28, 7),
          Rect.fromLTWH(17, 11, 3, 11),
          Rect.fromLTWH(44, 11, 3, 11),
          Rect.fromLTWH(24, 11, 5, 3),
          Rect.fromLTWH(34, 11, 5, 3),
        ],
      'short' => const [
          Rect.fromLTWH(18, 4, 28, 6),
          Rect.fromLTWH(17, 11, 3, 6),
          Rect.fromLTWH(44, 11, 3, 6),
        ],
      _ => const [
          Rect.fromLTWH(18, 4, 28, 7),
          Rect.fromLTWH(17, 10, 3, 8),
          Rect.fromLTWH(44, 10, 3, 8),
          Rect.fromLTWH(24, 11, 3, 5),
          Rect.fromLTWH(31, 10, 3, 6),
          Rect.fromLTWH(38, 11, 3, 5),
        ],
    };
    _rects(canvas, p.hair, fill);
    _rects(canvas, p.hairDark, const [Rect.fromLTWH(23, 11, 19, 1)]);
    _rects(canvas, p.hairLight, const [
      Rect.fromLTWH(24, 6, 5, 1),
      Rect.fromLTWH(35, 6, 5, 1),
    ]);
  }

  void _drawFace(Canvas canvas, _Palette p) {
    _rects(canvas, _shade(p.hair, -0.08), _brows());
    _rects(canvas, p.eyeWhite, _eyeWhite());
    _rects(canvas, p.eyeDark, _eyeDark());
    _rects(canvas, Colors.white, _eyeSparkle());
    _rects(canvas, p.blush.withValues(alpha: 0.72), const [
      Rect.fromLTWH(24, 18, 3, 1),
      Rect.fromLTWH(37, 18, 3, 1),
    ]);
    _rects(canvas, p.skinShadow, _nose());
    _rects(canvas, const Color(0xFF915352), _mouth());
  }

  void _drawWeapon(Canvas canvas, _Palette p) {
    if (weapon == null) return;
    if (weapon!.type != ItemType.weapon) return;
    if (attackProgress > 0) {
      final aura = Paint()
        ..color = p.effect.withValues(alpha: 0.22 + attackProgress * 0.4)
        ..isAntiAlias = false;
      canvas.drawOval(
        Rect.fromLTWH(46 + attackProgress * 4, 20 - attackProgress * 3, 14, 10),
        aura,
      );
    }
    _rects(canvas, p.outline, const [
      Rect.fromLTWH(50, 24, 3, 14),
      Rect.fromLTWH(52, 17, 8, 4),
    ]);
    _rects(canvas, const Color(0xFFA67942), const [Rect.fromLTWH(51, 25, 1, 11)]);
    _rects(canvas, p.metal, const [
      Rect.fromLTWH(53, 18, 6, 2),
      Rect.fromLTWH(57, 16, 3, 2),
    ]);
  }

  void _drawAccessory(Canvas canvas, _Palette p) {
    if (accessory == null) return;
    _rects(canvas, p.effect, const [
      Rect.fromLTWH(39, 25, 2, 1),
      Rect.fromLTWH(38, 26, 4, 1),
    ]);
  }

  void _drawDefendAura(Canvas canvas, _Palette p) {
    final aura = Paint()
      ..color = p.effect.withValues(alpha: 0.16 + defendProgress * 0.22)
      ..isAntiAlias = false;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(14, 4, 36, 54),
        const Radius.circular(8),
      ),
      aura,
    );
  }

  List<Rect> _brows() => switch (eyeStyle) {
        'sharp' => const [Rect.fromLTWH(23, 14, 5, 1), Rect.fromLTWH(36, 14, 5, 1)],
        'sleepy' => const [Rect.fromLTWH(23, 15, 5, 1), Rect.fromLTWH(36, 15, 5, 1)],
        _ => const [Rect.fromLTWH(24, 14, 4, 1), Rect.fromLTWH(37, 14, 4, 1)],
      };

  List<Rect> _eyeWhite() => switch (eyeStyle) {
        'smile' => const [Rect.fromLTWH(23, 18, 5, 1), Rect.fromLTWH(36, 18, 5, 1)],
        'sharp' => const [Rect.fromLTWH(23, 17, 5, 3), Rect.fromLTWH(36, 17, 5, 3)],
        'sleepy' => const [Rect.fromLTWH(23, 18, 5, 2), Rect.fromLTWH(36, 18, 5, 2)],
        _ => const [Rect.fromLTWH(22, 17, 6, 4), Rect.fromLTWH(36, 17, 6, 4)],
      };

  List<Rect> _eyeDark() => switch (eyeStyle) {
        'smile' => const [Rect.fromLTWH(24, 18, 3, 1), Rect.fromLTWH(37, 18, 3, 1)],
        'sharp' => const [Rect.fromLTWH(24, 17, 3, 3), Rect.fromLTWH(37, 17, 3, 3)],
        'sleepy' => const [Rect.fromLTWH(24, 18, 3, 2), Rect.fromLTWH(37, 18, 3, 2)],
        _ => const [Rect.fromLTWH(24, 18, 3, 2), Rect.fromLTWH(38, 18, 3, 2)],
      };

  List<Rect> _eyeSparkle() => eyeStyle == 'round'
      ? const [Rect.fromLTWH(24, 18, 1, 1), Rect.fromLTWH(38, 18, 1, 1)]
      : const [];

  List<Rect> _nose() => switch (noseStyle) {
        'line' => const [Rect.fromLTWH(31, 22, 2, 1)],
        'soft' => const [Rect.fromLTWH(32, 22, 1, 2)],
        _ => const [Rect.fromLTWH(32, 22, 1, 1)],
      };

  List<Rect> _mouth() => switch (mouthStyle) {
        'open' => const [Rect.fromLTWH(29, 26, 4, 2)],
        'smirk' => const [Rect.fromLTWH(28, 26, 4, 1), Rect.fromLTWH(32, 25, 1, 1)],
        'flat' => const [Rect.fromLTWH(28, 26, 6, 1)],
        _ => const [Rect.fromLTWH(28, 26, 6, 1), Rect.fromLTWH(29, 27, 4, 1)],
      };

  Color _skinColor() {
    switch (skinTone) {
      case 'warm':
        return const Color(0xFFD59F7A);
      case 'tan':
        return const Color(0xFFB37B56);
      case 'deep':
        return const Color(0xFF835036);
      default:
        return const Color(0xFFF1D7C4);
    }
  }

  Color _hairColor() {
    switch (hairStyle) {
      case 'short':
        return const Color(0xFF372C2D);
      case 'wave':
        return const Color(0xFF4D3532);
      case 'bob':
        return const Color(0xFF5A3E34);
      default:
        return const Color(0xFF26212A);
    }
  }

  Color _clothColor() {
    switch (outfitStyle) {
      case 'hunter':
        return const Color(0xFF24314A);
      case 'knight':
        return const Color(0xFF4F79C6);
      case 'mage':
        return const Color(0xFF6A51A2);
      default:
        return const Color(0xFFDED1C1);
    }
  }

  Color _metalColor() {
    if (armor?.rarity == ItemRarity.legendary || weapon?.rarity == ItemRarity.legendary) {
      return const Color(0xFFE2C85F);
    }
    if (armor?.rarity == ItemRarity.epic || weapon?.rarity == ItemRarity.epic) {
      return const Color(0xFF9985FF);
    }
    return const Color(0xFFB7C1D5);
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
  final Color metal;
  final Color effect;
  final Color eyeDark;
  final Color eyeWhite;
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
    required this.metal,
    required this.effect,
    required this.eyeDark,
    required this.eyeWhite,
    required this.blush,
    required this.shoe,
  });
}
