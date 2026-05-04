import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/models/item.dart';

class PlayerBattleSprite extends StatelessWidget {
  static const String _heroIdleAsset = 'assets/images/player/hero_idle.png';

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
    final normalizedAttack = attackProgress.clamp(0.0, 1.0).toDouble();
    final normalizedDefend = defendProgress.clamp(0.0, 1.0).toDouble();
    final direction = facingRight ? 1.0 : -1.0;

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.diagonal3Values(direction, 1.0, 1.0),
      child: Transform.translate(
        offset: Offset(
            normalizedAttack * size * 0.08, -normalizedAttack * size * 0.02),
        child: SizedBox.square(
          dimension: size,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                bottom: size * 0.02,
                child: _GroundShadow(
                  width: size * 0.52,
                  height: size * 0.10,
                  opacity: 0.22,
                ),
              ),
              if (normalizedDefend > 0)
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF8EE7FF).withValues(
                            alpha: 0.26 + normalizedDefend * 0.32,
                          ),
                          width: 2 + normalizedDefend * 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8EE7FF).withValues(
                              alpha: 0.12 + normalizedDefend * 0.20,
                            ),
                            blurRadius: 18 + normalizedDefend * 18,
                            spreadRadius: normalizedDefend * 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.all(size * 0.02),
                  child: Image.asset(
                    _heroIdleAsset,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.medium,
                    errorBuilder: (_, __, ___) => const _MissingPlayerAsset(),
                  ),
                ),
              ),
              if (normalizedAttack > 0)
                Positioned(
                  right: size * 0.02,
                  top: size * 0.30,
                  child: IgnorePointer(
                    child: Container(
                      width: size * (0.24 + normalizedAttack * 0.18),
                      height: size * 0.08,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.0),
                            const Color(0xFFFFF4A8).withValues(
                              alpha: 0.28 + normalizedAttack * 0.30,
                            ),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(size * 0.04),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GroundShadow extends StatelessWidget {
  final double width;
  final double height;
  final double opacity;

  const _GroundShadow({
    required this.width,
    required this.height,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: opacity),
        borderRadius: BorderRadius.all(Radius.elliptical(width, height)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: opacity * 0.7),
            blurRadius: height,
            spreadRadius: height * 0.2,
          ),
        ],
      ),
    );
  }
}

class _MissingPlayerAsset extends StatelessWidget {
  const _MissingPlayerAsset();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF1E2433),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF8EE7FF), width: 2),
      ),
      child: const Center(
        child: Icon(
          Icons.person,
          color: Color(0xFF8EE7FF),
          size: 40,
        ),
      ),
    );
  }
}
