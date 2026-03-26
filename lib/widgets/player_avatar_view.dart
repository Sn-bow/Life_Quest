import 'package:flutter/material.dart';

class AvatarOption {
  final String id;
  final String label;
  const AvatarOption(this.id, this.label);
}

class PlayerAvatarPreset {
  final String id;
  final String name;
  final String gender;
  final String skinTone;
  final String hairStyle;
  final String eyeStyle;
  final String earStyle;
  final String noseStyle;
  final String mouthStyle;
  final String outfitStyle;

  const PlayerAvatarPreset({
    required this.id,
    required this.name,
    required this.gender,
    required this.skinTone,
    required this.hairStyle,
    required this.eyeStyle,
    required this.earStyle,
    required this.noseStyle,
    required this.mouthStyle,
    required this.outfitStyle,
  });
}

const avatarGenderOptions = [
  AvatarOption('feminine', '페미닌'),
  AvatarOption('masculine', '매스큘린'),
];

const avatarSkinToneOptions = [
  AvatarOption('fair', '밝은 톤'),
  AvatarOption('warm', '웜 톤'),
  AvatarOption('tan', '탄 톤'),
  AvatarOption('deep', '딥 톤'),
];

const avatarHairOptions = [
  AvatarOption('short', '숏컷'),
  AvatarOption('bob', '보브'),
  AvatarOption('wave', '웨이브'),
  AvatarOption('spike', '앞머리'),
];

const avatarEyeOptions = [
  AvatarOption('round', '큰 눈'),
  AvatarOption('sharp', '또렷한 눈'),
  AvatarOption('smile', '웃는 눈'),
  AvatarOption('sleepy', '차분한 눈'),
];

const avatarEarOptions = [
  AvatarOption('round', '둥근 귀'),
  AvatarOption('small', '작은 귀'),
  AvatarOption('tall', '긴 귀'),
  AvatarOption('hidden', '가려진 귀'),
];

const avatarNoseOptions = [
  AvatarOption('dot', '점 코'),
  AvatarOption('line', '라인 코'),
  AvatarOption('soft', '부드러운 코'),
];

const avatarMouthOptions = [
  AvatarOption('smile', '미소'),
  AvatarOption('flat', '담백한 입'),
  AvatarOption('open', '작은 열린 입'),
  AvatarOption('smirk', '반미소'),
];

const avatarOutfitOptions = [
  AvatarOption('hunter', '다크 후드'),
  AvatarOption('knight', '블루 니트'),
  AvatarOption('casual', '캐주얼 재킷'),
  AvatarOption('mage', '포인트 코트'),
];

const playerAvatarPresets = [
  PlayerAvatarPreset(
    id: 'preset_shadow',
    name: '짧은 머리',
    gender: 'masculine',
    skinTone: 'warm',
    hairStyle: 'spike',
    eyeStyle: 'sharp',
    earStyle: 'small',
    noseStyle: 'line',
    mouthStyle: 'flat',
    outfitStyle: 'hunter',
  ),
  PlayerAvatarPreset(
    id: 'preset_luna',
    name: '보브 스타일',
    gender: 'feminine',
    skinTone: 'fair',
    hairStyle: 'bob',
    eyeStyle: 'round',
    earStyle: 'round',
    noseStyle: 'dot',
    mouthStyle: 'smirk',
    outfitStyle: 'casual',
  ),
  PlayerAvatarPreset(
    id: 'preset_storm',
    name: '밝은 미소',
    gender: 'masculine',
    skinTone: 'tan',
    hairStyle: 'short',
    eyeStyle: 'smile',
    earStyle: 'tall',
    noseStyle: 'soft',
    mouthStyle: 'smile',
    outfitStyle: 'knight',
  ),
  PlayerAvatarPreset(
    id: 'preset_eclipse',
    name: '웨이브 헤어',
    gender: 'feminine',
    skinTone: 'deep',
    hairStyle: 'wave',
    eyeStyle: 'sleepy',
    earStyle: 'hidden',
    noseStyle: 'line',
    mouthStyle: 'open',
    outfitStyle: 'mage',
  ),
];

PlayerAvatarPreset avatarPresetById(String id) {
  return playerAvatarPresets.where((preset) => preset.id == id).firstOrNull ??
      playerAvatarPresets.first;
}

class PlayerAvatarView extends StatelessWidget {
  final String gender;
  final String skinTone;
  final String hairStyle;
  final String eyeStyle;
  final String earStyle;
  final String noseStyle;
  final String mouthStyle;
  final String outfitStyle;
  final double size;
  final bool showFrame;
  final bool facingRight;

  const PlayerAvatarView({
    super.key,
    required this.gender,
    required this.skinTone,
    required this.hairStyle,
    required this.eyeStyle,
    required this.earStyle,
    required this.noseStyle,
    required this.mouthStyle,
    required this.outfitStyle,
    this.size = 88,
    this.showFrame = false,
    this.facingRight = true,
  });

  factory PlayerAvatarView.fromPreset({
    Key? key,
    required PlayerAvatarPreset preset,
    double size = 88,
    bool showFrame = false,
    bool facingRight = true,
  }) {
    return PlayerAvatarView(
      key: key,
      gender: preset.gender,
      skinTone: preset.skinTone,
      hairStyle: preset.hairStyle,
      eyeStyle: preset.eyeStyle,
      earStyle: preset.earStyle,
      noseStyle: preset.noseStyle,
      mouthStyle: preset.mouthStyle,
      outfitStyle: preset.outfitStyle,
      size: size,
      showFrame: showFrame,
      facingRight: facingRight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final decoration = showFrame
        ? BoxDecoration(
            color: const Color(0x0FFFFFFF),
            borderRadius: BorderRadius.circular(size * 0.24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.28),
              width: size * 0.016,
            ),
          )
        : null;

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..scale(facingRight ? 1.0 : -1.0, 1.0),
      child: Container(
        width: size,
        height: size,
        decoration: decoration,
        padding: EdgeInsets.all(size * 0.03),
        child: CustomPaint(
          painter: _PixelAvatarPainter(
            gender: gender,
            skinTone: skinTone,
            hairStyle: hairStyle,
            eyeStyle: eyeStyle,
            earStyle: earStyle,
            noseStyle: noseStyle,
            mouthStyle: mouthStyle,
            outfitStyle: outfitStyle,
          ),
        ),
      ),
    );
  }
}

class _PixelAvatarPainter extends CustomPainter {
  final String gender;
  final String skinTone;
  final String hairStyle;
  final String eyeStyle;
  final String earStyle;
  final String noseStyle;
  final String mouthStyle;
  final String outfitStyle;

  const _PixelAvatarPainter({
    required this.gender,
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
    const grid = 32.0;
    final pixel = size.shortestSide / grid;
    canvas.save();
    canvas.scale(pixel, pixel);

    final palette = _AvatarPalette(
      skin: _skinColor(),
      skinShadow: _darken(_skinColor(), 0.18),
      hair: _hairColor(),
      hairShadow: _darken(_hairColor(), 0.24),
      hairHighlight: _lighten(_hairColor(), 0.18),
      outfit: _outfitColor(),
      outfitShadow: _darken(_outfitColor(), 0.22),
      outline: const Color(0xFF1A2238),
      eyeWhite: const Color(0xFFF5F2FF),
      eyeDark: const Color(0xFF1C1D2E),
      blush: const Color(0xFFF3A6A0),
      nose: _darken(_skinColor(), 0.22),
      mouth: const Color(0xFF9C4A49),
    );

    _drawShadow(canvas);
    _drawOutfit(canvas, palette);
    _drawHead(canvas, palette);
    _drawHair(canvas, palette);
    _drawFace(canvas, palette);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PixelAvatarPainter oldDelegate) {
    return gender != oldDelegate.gender ||
        skinTone != oldDelegate.skinTone ||
        hairStyle != oldDelegate.hairStyle ||
        eyeStyle != oldDelegate.eyeStyle ||
        noseStyle != oldDelegate.noseStyle ||
        mouthStyle != oldDelegate.mouthStyle ||
        outfitStyle != oldDelegate.outfitStyle;
  }

  void _drawShadow(Canvas canvas) {
    final shadow = Paint()..color = const Color(0x221A2238);
    canvas.drawRect(const Rect.fromLTWH(7, 28, 18, 2), shadow);
  }

  void _drawOutfit(Canvas canvas, _AvatarPalette p) {
    final masculine = gender == 'masculine';
    final outlineRects = switch (outfitStyle) {
      'hunter' => const [
          Rect.fromLTWH(8, 20, 16, 8),
          Rect.fromLTWH(7, 26, 18, 3),
          Rect.fromLTWH(7, 23, 2, 4),
          Rect.fromLTWH(23, 23, 2, 4),
        ],
      'knight' => const [
          Rect.fromLTWH(9, 20, 14, 8),
          Rect.fromLTWH(8, 26, 16, 3),
          Rect.fromLTWH(7, 23, 2, 4),
          Rect.fromLTWH(23, 23, 2, 4),
          Rect.fromLTWH(12, 20, 8, 1),
        ],
      'mage' => const [
          Rect.fromLTWH(8, 20, 16, 9),
          Rect.fromLTWH(7, 27, 18, 2),
          Rect.fromLTWH(7, 23, 2, 4),
          Rect.fromLTWH(23, 23, 2, 4),
        ],
      _ => const [
          Rect.fromLTWH(9, 20, 14, 8),
          Rect.fromLTWH(8, 26, 16, 3),
          Rect.fromLTWH(7, 23, 2, 4),
          Rect.fromLTWH(23, 23, 2, 4),
        ],
    };
    _fill(canvas, p.outline, outlineRects);

    final fillRects = switch (outfitStyle) {
      'hunter' => const [
          Rect.fromLTWH(9, 21, 14, 6),
          Rect.fromLTWH(8, 26, 16, 2),
          Rect.fromLTWH(8, 24, 1, 2),
          Rect.fromLTWH(23, 24, 1, 2),
        ],
      'knight' => const [
          Rect.fromLTWH(10, 21, 12, 6),
          Rect.fromLTWH(9, 26, 14, 2),
          Rect.fromLTWH(8, 24, 2, 2),
          Rect.fromLTWH(22, 24, 2, 2),
        ],
      'mage' => const [
          Rect.fromLTWH(9, 21, 14, 7),
          Rect.fromLTWH(8, 27, 16, 1),
          Rect.fromLTWH(8, 24, 1, 2),
          Rect.fromLTWH(23, 24, 1, 2),
        ],
      _ => const [
          Rect.fromLTWH(10, 21, 12, 6),
          Rect.fromLTWH(9, 26, 14, 2),
          Rect.fromLTWH(8, 24, 2, 2),
          Rect.fromLTWH(22, 24, 2, 2),
        ],
    };
    _fill(canvas, p.outfit, fillRects);

    _fill(canvas, p.outfitShadow, switch (outfitStyle) {
      'hunter' => const [
          Rect.fromLTWH(9, 26, 14, 1),
          Rect.fromLTWH(12, 21, 8, 1),
        ],
      'knight' => const [
          Rect.fromLTWH(10, 26, 12, 1),
          Rect.fromLTWH(15, 22, 2, 4),
        ],
      'mage' => const [
          Rect.fromLTWH(10, 27, 12, 1),
          Rect.fromLTWH(10, 21, 2, 6),
          Rect.fromLTWH(20, 21, 2, 6),
        ],
      _ => const [
          Rect.fromLTWH(10, 26, 12, 1),
          Rect.fromLTWH(8, 25, 1, 1),
          Rect.fromLTWH(23, 25, 1, 1),
        ],
    });

    _fill(canvas, p.skin, [
      Rect.fromLTWH(14, 19, masculine ? 4 : 3, 2),
      const Rect.fromLTWH(8, 24, 1, 2),
      const Rect.fromLTWH(23, 24, 1, 2),
    ]);
  }

  void _drawHead(Canvas canvas, _AvatarPalette p) {
    _fill(canvas, p.outline, const [
      Rect.fromLTWH(8, 4, 16, 15),
      Rect.fromLTWH(7, 6, 1, 10),
      Rect.fromLTWH(24, 6, 1, 10),
      Rect.fromLTWH(10, 19, 12, 1),
      Rect.fromLTWH(11, 20, 10, 1),
      Rect.fromLTWH(7, 8, 1, 2),
      Rect.fromLTWH(24, 8, 1, 2),
    ]);
    _fill(canvas, p.skin, const [
      Rect.fromLTWH(9, 5, 14, 13),
      Rect.fromLTWH(8, 7, 1, 8),
      Rect.fromLTWH(23, 7, 1, 8),
      Rect.fromLTWH(11, 18, 10, 1),
    ]);
    _fill(canvas, p.skinShadow, const [
      Rect.fromLTWH(9, 16, 14, 2),
      Rect.fromLTWH(10, 18, 12, 1),
    ]);
    _drawEars(canvas, p);
  }

  void _drawHair(Canvas canvas, _AvatarPalette p) {
    _fill(canvas, p.outline, _hairOutlineRects());
    _fill(canvas, p.hair, _hairFillRects());
    _fill(canvas, p.hairShadow, _hairShadowRects());
    _fill(canvas, p.hairHighlight, _hairHighlightRects());
  }

  void _drawFace(Canvas canvas, _AvatarPalette p) {
    _drawBrows(canvas, p);
    _fill(canvas, p.eyeWhite, _eyeWhiteRects());
    _fill(canvas, p.eyeDark, _eyeDarkRects());
    _fill(canvas, Colors.white, _eyeSparkleRects());
    _fill(canvas, p.blush.withValues(alpha: 0.7), _blushRects());
    _fill(canvas, p.nose, _noseRects());
    _fill(canvas, p.mouth, _mouthRects());
  }

  void _drawEars(Canvas canvas, _AvatarPalette p) {
    if (earStyle == 'hidden') {
      return;
    }
    final rects = switch (earStyle) {
      'small' => const [
          Rect.fromLTWH(6, 12, 1, 2),
          Rect.fromLTWH(25, 12, 1, 2),
        ],
      'tall' => const [
          Rect.fromLTWH(6, 10, 2, 5),
          Rect.fromLTWH(24, 10, 2, 5),
        ],
      _ => switch (gender) {
          'feminine' => const [
              Rect.fromLTWH(6, 11, 2, 3),
              Rect.fromLTWH(24, 11, 2, 3),
            ],
          _ => const [
              Rect.fromLTWH(6, 11, 2, 4),
              Rect.fromLTWH(24, 11, 2, 4),
            ],
        },
    };
    _fill(canvas, p.skin, rects);
    _fill(canvas, p.outline, switch (earStyle) {
      'small' => const [
          Rect.fromLTWH(6, 12, 1, 1),
          Rect.fromLTWH(25, 12, 1, 1),
        ],
      'tall' => const [
          Rect.fromLTWH(6, 11, 1, 3),
          Rect.fromLTWH(25, 11, 1, 3),
        ],
      _ => switch (gender) {
          'feminine' => const [
              Rect.fromLTWH(6, 12, 1, 1),
              Rect.fromLTWH(25, 12, 1, 1),
            ],
          _ => const [
              Rect.fromLTWH(6, 12, 1, 2),
              Rect.fromLTWH(25, 12, 1, 2),
            ],
        },
    });
    _fill(canvas, p.skinShadow, switch (earStyle) {
      'small' => const [],
      _ => const [
          Rect.fromLTWH(7, 12, 1, 1),
          Rect.fromLTWH(24, 12, 1, 1),
        ],
    });
  }

  void _drawBrows(Canvas canvas, _AvatarPalette p) {
    final brows = switch (eyeStyle) {
      'sharp' => const [
          Rect.fromLTWH(10, 10, 4, 1),
          Rect.fromLTWH(18, 10, 4, 1),
        ],
      'smile' => const [
          Rect.fromLTWH(10, 10, 4, 1),
          Rect.fromLTWH(18, 10, 4, 1),
        ],
      'sleepy' => const [
          Rect.fromLTWH(10, 11, 4, 1),
          Rect.fromLTWH(18, 11, 4, 1),
        ],
      _ => const [
          Rect.fromLTWH(10, 10, 3, 1),
          Rect.fromLTWH(19, 10, 3, 1),
        ],
    };
    _fill(canvas, _darken(p.hair, 0.12), brows);
  }

  List<Rect> _hairOutlineRects() {
    switch (hairStyle) {
      case 'bob':
        return const [
          Rect.fromLTWH(7, 3, 18, 8),
          Rect.fromLTWH(6, 7, 3, 9),
          Rect.fromLTWH(23, 7, 3, 9),
          Rect.fromLTWH(8, 14, 3, 4),
          Rect.fromLTWH(21, 14, 3, 4),
        ];
      case 'wave':
        return const [
          Rect.fromLTWH(6, 3, 20, 8),
          Rect.fromLTWH(5, 8, 4, 10),
          Rect.fromLTWH(23, 8, 4, 10),
          Rect.fromLTWH(7, 16, 3, 4),
          Rect.fromLTWH(22, 16, 3, 4),
        ];
      case 'spike':
        return const [
          Rect.fromLTWH(7, 3, 18, 7),
          Rect.fromLTWH(6, 6, 3, 6),
          Rect.fromLTWH(23, 6, 3, 6),
          Rect.fromLTWH(10, 9, 1, 3),
          Rect.fromLTWH(14, 8, 1, 3),
          Rect.fromLTWH(18, 9, 1, 3),
        ];
      case 'short':
      default:
        return const [
          Rect.fromLTWH(7, 3, 18, 6),
          Rect.fromLTWH(6, 6, 3, 5),
          Rect.fromLTWH(23, 6, 3, 5),
        ];
    }
  }

  List<Rect> _hairFillRects() {
    switch (hairStyle) {
      case 'bob':
        return const [
          Rect.fromLTWH(8, 4, 16, 6),
          Rect.fromLTWH(7, 8, 2, 7),
          Rect.fromLTWH(23, 8, 2, 7),
          Rect.fromLTWH(9, 14, 2, 3),
          Rect.fromLTWH(21, 14, 2, 3),
          Rect.fromLTWH(10, 9, 3, 2),
          Rect.fromLTWH(15, 9, 3, 2),
        ];
      case 'wave':
        return const [
          Rect.fromLTWH(7, 4, 18, 6),
          Rect.fromLTWH(6, 9, 2, 8),
          Rect.fromLTWH(24, 9, 2, 8),
          Rect.fromLTWH(8, 16, 2, 3),
          Rect.fromLTWH(22, 16, 2, 3),
          Rect.fromLTWH(11, 9, 2, 3),
          Rect.fromLTWH(18, 9, 2, 3),
        ];
      case 'spike':
        return const [
          Rect.fromLTWH(8, 4, 16, 5),
          Rect.fromLTWH(7, 6, 2, 5),
          Rect.fromLTWH(23, 6, 2, 5),
          Rect.fromLTWH(10, 9, 1, 2),
          Rect.fromLTWH(13, 8, 1, 3),
          Rect.fromLTWH(16, 8, 1, 3),
          Rect.fromLTWH(19, 9, 1, 2),
        ];
      case 'short':
      default:
        return const [
          Rect.fromLTWH(8, 4, 16, 4),
          Rect.fromLTWH(7, 6, 2, 4),
          Rect.fromLTWH(23, 6, 2, 4),
          Rect.fromLTWH(11, 8, 2, 1),
          Rect.fromLTWH(18, 8, 2, 1),
        ];
    }
  }

  List<Rect> _hairShadowRects() {
    switch (hairStyle) {
      case 'wave':
        return const [
          Rect.fromLTWH(8, 10, 2, 7),
          Rect.fromLTWH(22, 10, 2, 7),
          Rect.fromLTWH(12, 8, 8, 1),
        ];
      case 'bob':
        return const [
          Rect.fromLTWH(8, 10, 2, 5),
          Rect.fromLTWH(22, 10, 2, 5),
          Rect.fromLTWH(12, 8, 8, 1),
        ];
      case 'spike':
        return const [
          Rect.fromLTWH(12, 8, 8, 1),
          Rect.fromLTWH(8, 7, 2, 2),
          Rect.fromLTWH(22, 7, 2, 2),
        ];
      case 'short':
      default:
        return const [
          Rect.fromLTWH(12, 7, 8, 1),
        ];
    }
  }

  List<Rect> _hairHighlightRects() {
    switch (hairStyle) {
      case 'wave':
        return const [
          Rect.fromLTWH(10, 5, 3, 1),
          Rect.fromLTWH(18, 5, 3, 1),
        ];
      case 'bob':
        return const [
          Rect.fromLTWH(10, 5, 3, 1),
          Rect.fromLTWH(18, 5, 3, 1),
        ];
      case 'spike':
        return const [
          Rect.fromLTWH(10, 5, 2, 1),
          Rect.fromLTWH(19, 5, 2, 1),
        ];
      case 'short':
      default:
        return const [
          Rect.fromLTWH(11, 5, 2, 1),
          Rect.fromLTWH(18, 5, 2, 1),
        ];
    }
  }

  List<Rect> _eyeWhiteRects() {
    switch (eyeStyle) {
      case 'sharp':
        return const [
          Rect.fromLTWH(10, 12, 4, 2),
          Rect.fromLTWH(18, 12, 4, 2),
        ];
      case 'smile':
        return const [
          Rect.fromLTWH(10, 12, 4, 1),
          Rect.fromLTWH(18, 12, 4, 1),
        ];
      case 'sleepy':
        return const [
          Rect.fromLTWH(10, 13, 4, 1),
          Rect.fromLTWH(18, 13, 4, 1),
        ];
      case 'round':
      default:
        return const [
          Rect.fromLTWH(10, 11, 4, 4),
          Rect.fromLTWH(18, 11, 4, 4),
        ];
    }
  }

  List<Rect> _eyeDarkRects() {
    switch (eyeStyle) {
      case 'sharp':
        return const [
          Rect.fromLTWH(10, 12, 4, 1),
          Rect.fromLTWH(18, 12, 4, 1),
        ];
      case 'smile':
        return const [
          Rect.fromLTWH(10, 12, 4, 1),
          Rect.fromLTWH(18, 12, 4, 1),
        ];
      case 'sleepy':
        return const [
          Rect.fromLTWH(10, 13, 4, 1),
          Rect.fromLTWH(18, 13, 4, 1),
        ];
      case 'round':
      default:
        return const [
          Rect.fromLTWH(11, 12, 2, 3),
          Rect.fromLTWH(19, 12, 2, 3),
        ];
    }
  }

  List<Rect> _eyeSparkleRects() {
    return switch (eyeStyle) {
      'round' => const [
          Rect.fromLTWH(11, 12, 1, 1),
          Rect.fromLTWH(19, 12, 1, 1),
        ],
      'sharp' => const [
          Rect.fromLTWH(11, 12, 1, 1),
          Rect.fromLTWH(19, 12, 1, 1),
        ],
      _ => const [],
    };
  }

  List<Rect> _noseRects() {
    switch (noseStyle) {
      case 'line':
        return const [Rect.fromLTWH(15, 15, 2, 1), Rect.fromLTWH(16, 16, 1, 1)];
      case 'soft':
        return const [Rect.fromLTWH(15, 15, 1, 2)];
      case 'dot':
      default:
        return const [Rect.fromLTWH(16, 15, 1, 1)];
    }
  }

  List<Rect> _mouthRects() {
    switch (mouthStyle) {
      case 'flat':
        return const [Rect.fromLTWH(14, 17, 4, 1)];
      case 'open':
        return const [Rect.fromLTWH(15, 17, 2, 2)];
      case 'smirk':
        return const [Rect.fromLTWH(14, 17, 3, 1), Rect.fromLTWH(17, 16, 1, 1)];
      case 'smile':
      default:
        return const [Rect.fromLTWH(14, 17, 4, 1), Rect.fromLTWH(15, 18, 2, 1)];
    }
  }

  List<Rect> _blushRects() {
    return switch (skinTone) {
      'deep' => const [
          Rect.fromLTWH(10, 14, 1, 1),
          Rect.fromLTWH(21, 14, 1, 1),
        ],
      _ => const [
          Rect.fromLTWH(10, 14, 2, 1),
          Rect.fromLTWH(20, 14, 2, 1),
        ],
    };
  }

  Color _skinColor() {
    switch (skinTone) {
      case 'warm':
        return const Color(0xFFD9A67F);
      case 'tan':
        return const Color(0xFFBE845B);
      case 'deep':
        return const Color(0xFF8F5A3A);
      case 'fair':
      default:
        return const Color(0xFFF0D3BD);
    }
  }

  Color _hairColor() {
    switch (hairStyle) {
      case 'short':
        return const Color(0xFF3A2D2B);
      case 'wave':
        return const Color(0xFF47312E);
      case 'spike':
        return const Color(0xFF2A2328);
      case 'bob':
      default:
        return gender == 'feminine'
            ? const Color(0xFF4B3332)
            : const Color(0xFF33292B);
    }
  }

  Color _outfitColor() {
    switch (outfitStyle) {
      case 'hunter':
        return const Color(0xFF2B3650);
      case 'knight':
        return const Color(0xFF4D78C9);
      case 'mage':
        return const Color(0xFF7056A8);
      case 'casual':
      default:
        return const Color(0xFFE8D8C6);
    }
  }

  static Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  static Color _lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  void _fill(Canvas canvas, Color color, List<Rect> rects) {
    final paint = Paint()
      ..color = color
      ..isAntiAlias = false;
    for (final rect in rects) {
      canvas.drawRect(rect, paint);
    }
  }
}

class _AvatarPalette {
  final Color skin;
  final Color skinShadow;
  final Color hair;
  final Color hairShadow;
  final Color hairHighlight;
  final Color outfit;
  final Color outfitShadow;
  final Color outline;
  final Color eyeWhite;
  final Color eyeDark;
  final Color blush;
  final Color nose;
  final Color mouth;

  const _AvatarPalette({
    required this.skin,
    required this.skinShadow,
    required this.hair,
    required this.hairShadow,
    required this.hairHighlight,
    required this.outfit,
    required this.outfitShadow,
    required this.outline,
    required this.eyeWhite,
    required this.eyeDark,
    required this.blush,
    required this.nose,
    required this.mouth,
  });
}
