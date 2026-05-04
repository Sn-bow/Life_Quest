import 'package:flutter/material.dart';

class PlayerProfileSprite extends StatelessWidget {
  static const String _heroIdleAsset = 'assets/images/player/hero_idle.png';

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
    final direction = facingRight ? 1.0 : -1.0;

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.diagonal3Values(direction, 1.0, 1.0),
      child: SizedBox.square(
        dimension: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFF111827).withValues(alpha: 0.42),
            borderRadius: BorderRadius.circular(size * 0.18),
            border: Border.all(
              color: const Color(0xFFE2C85F).withValues(alpha: 0.55),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size * 0.16),
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  bottom: size * 0.05,
                  child: Container(
                    width: size * 0.56,
                    height: size * 0.10,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.24),
                      borderRadius: BorderRadius.all(
                        Radius.elliptical(size * 0.56, size * 0.10),
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, size * 0.08),
                  child: Transform.scale(
                    scale: 1.55,
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      _heroIdleAsset,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.medium,
                      errorBuilder: (_, __, ___) =>
                          const _MissingPlayerProfileAsset(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MissingPlayerProfileAsset extends StatelessWidget {
  const _MissingPlayerProfileAsset();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.person,
        color: Color(0xFFE2C85F),
        size: 26,
      ),
    );
  }
}
