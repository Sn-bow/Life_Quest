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
    final normalizedHit = hitProgress.clamp(0.0, 1.0).toDouble();
    final assetPath = monster.spritePath.trim();

    return Transform.translate(
      offset: Offset(-normalizedHit * 12, 0),
      child: Transform.scale(
        scale: 1.0 + normalizedHit * 0.04,
        child: SizedBox.square(
          dimension: size,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                bottom: size * 0.04,
                child: _GroundShadow(
                  width: size * 0.64,
                  height: size * 0.12,
                  opacity: 0.20,
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.all(size * 0.03),
                  child: _MonsterImage(
                    assetPath: assetPath,
                    monsterName: monster.name,
                  ),
                ),
              ),
              if (normalizedHit > 0)
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: 0.10 + normalizedHit * 0.24,
                        ),
                        backgroundBlendMode: BlendMode.screen,
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

class _MonsterImage extends StatelessWidget {
  final String assetPath;
  final String monsterName;

  const _MonsterImage({
    required this.assetPath,
    required this.monsterName,
  });

  @override
  Widget build(BuildContext context) {
    if (assetPath.isEmpty) {
      return _MissingMonsterAsset(monsterName: monsterName);
    }

    return Image.asset(
      assetPath,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      errorBuilder: (_, __, ___) {
        return _MissingMonsterAsset(monsterName: monsterName);
      },
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
            color: Colors.black.withValues(alpha: opacity * 0.6),
            blurRadius: height,
            spreadRadius: height * 0.2,
          ),
        ],
      ),
    );
  }
}

class _MissingMonsterAsset extends StatelessWidget {
  final String monsterName;

  const _MissingMonsterAsset({required this.monsterName});

  @override
  Widget build(BuildContext context) {
    final label = monsterName.isEmpty ? '?' : monsterName.characters.first;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF1E2433),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFD166), width: 2),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFFFFD166),
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
