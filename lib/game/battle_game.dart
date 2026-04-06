import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/game/components/damage_text.dart';
import 'package:life_quest_final_v2/game/components/particle_effect.dart';

/// Root FlameGame subclass that hosts the card battle visuals.
///
/// The game canvas renders behind a Flutter overlay that contains the
/// hand, energy counter, and action buttons.  This class is responsible
/// for background rendering, sprite animations, and floating numbers.
class BattleGame extends FlameGame {
  /// The current dungeon zone (determines background palette).
  int currentZone;

  BattleGame({this.currentZone = 1});

  // Parallax layers
  final List<_ParallaxLayer> _parallaxLayers = [];

  // ───────────────────────────────────────────
  // Lifecycle
  // ───────────────────────────────────────────

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _initParallaxBackground();
  }

  @override
  Color backgroundColor() {
    // Each zone gets a slightly different atmosphere.
    switch (currentZone) {
      case 1:
        return const Color(0xFF1A1A2E); // dark indigo  - forest
      case 2:
        return const Color(0xFF1B2838); // steel blue   - cave
      case 3:
        return const Color(0xFF2D1B2E); // dark purple  - crypt
      case 4:
        return const Color(0xFF0D1117); // near-black   - abyss
      case 5:
        return const Color(0xFF2E1A1A); // dark crimson - inferno
      default:
        return const Color(0xFF1A1A2E);
    }
  }

  // ───────────────────────────────────────────
  // Parallax background
  // ───────────────────────────────────────────

  void _initParallaxBackground() {
    final colors = _zoneParallaxColors(currentZone);

    // Three layers at different depths with different speeds
    for (int i = 0; i < 3; i++) {
      final layer = _ParallaxLayer(
        layerIndex: i,
        color: colors[i % colors.length],
        speed: 8.0 + i * 6.0,
        gameSize: size,
      );
      _parallaxLayers.add(layer);
      add(layer);
    }
  }

  List<Color> _zoneParallaxColors(int zone) {
    switch (zone) {
      case 1: // forest
        return [
          const Color(0x15228B22),
          const Color(0x10006400),
          const Color(0x0D2E8B57),
        ];
      case 2: // cave
        return [
          const Color(0x15708090),
          const Color(0x10556B7B),
          const Color(0x0D4682B4),
        ];
      case 3: // crypt
        return [
          const Color(0x15800080),
          const Color(0x10663399),
          const Color(0x0D9932CC),
        ];
      case 4: // abyss
        return [
          const Color(0x10191970),
          const Color(0x0D000033),
          const Color(0x08483D8B),
        ];
      case 5: // inferno
        return [
          const Color(0x15FF4500),
          const Color(0x10DC143C),
          const Color(0x0DFF6347),
        ];
      default:
        return [
          const Color(0x15228B22),
          const Color(0x10006400),
          const Color(0x0D2E8B57),
        ];
    }
  }

  // ───────────────────────────────────────────
  // Animation hooks (called from Flutter overlay)
  // ───────────────────────────────────────────

  /// Plays a melee slash animation toward the enemy.
  void playAttackAnimation() {
    // TODO: Add slash sprite / tween once assets are available.
  }

  /// Plays a shield-raise animation on the player.
  void playDefendAnimation() {
    // TODO: Add shield sprite / tween once assets are available.
  }

  /// Plays a magic projectile animation toward the enemy.
  void playMagicAnimation() {
    // TODO: Add magic particle effect once assets are available.
  }

  /// Shows a floating damage number at the enemy position.
  ///
  /// [damage] is the numeric value displayed.
  /// [isCritical] triggers larger yellow text instead of red.
  void showDamageNumber(int damage, {bool isCritical = false}) {
    final text = DamageText(
      value: damage,
      type: isCritical ? DamageTextType.critical : DamageTextType.damage,
      // Position near the center-right where the enemy sprite will be.
      startPosition: Vector2(size.x * 0.7, size.y * 0.35),
    );
    add(text);
  }

  /// Shows a floating heal number at the player position.
  void showHealNumber(int amount) {
    final text = DamageText(
      value: amount,
      type: DamageTextType.heal,
      // Position near center-left where the player sprite will be.
      startPosition: Vector2(size.x * 0.3, size.y * 0.35),
    );
    add(text);
  }

  /// Called when the current enemy is defeated.
  ///
  /// Triggers a fade-out / shatter animation on the enemy sprite.
  void onEnemyDefeated() {
    // TODO: Play enemy defeat animation once sprites are ready.
  }

  // ───────────────────────────────────────────
  // Particle effects
  // ───────────────────────────────────────────

  /// Spawns a hit particle burst at the enemy position (red/orange particles).
  void playHitParticle({Vector2? position}) {
    final pos = position ?? Vector2(size.x * 0.7, size.y * 0.35);
    add(ParticleEffect(
      spawnPosition: pos,
      color: const Color(0xFFFF4444),
      count: 15,
      speed: 140.0,
      lifetime: 0.5,
      particleRadius: 3.0,
      gravity: 100.0,
    ));
  }

  /// Spawns green floating heal particles at the player position.
  void playHealParticle({Vector2? position}) {
    final pos = position ?? Vector2(size.x * 0.3, size.y * 0.35);
    add(ParticleEffect(
      spawnPosition: pos,
      color: const Color(0xFF44FF88),
      count: 10,
      speed: 60.0,
      lifetime: 0.7,
      particleRadius: 2.5,
      gravity: -30.0, // float upward
    ));
  }

  /// Spawns a blue shield flash effect at the player position.
  void playBlockParticle({Vector2? position}) {
    final pos = position ?? Vector2(size.x * 0.3, size.y * 0.35);
    add(ParticleEffect(
      spawnPosition: pos,
      color: const Color(0xFF4488FF),
      count: 8,
      speed: 80.0,
      lifetime: 0.4,
      particleRadius: 3.5,
      gravity: 0.0, // no gravity for shield effect - radial burst
    ));
    // Also add a brief shield flash ring
    add(_ShieldFlash(center: pos));
  }
}

// =============================================================================
// Parallax background layer
// =============================================================================

/// A single parallax layer: draws a set of slowly drifting translucent shapes
/// to create depth and atmosphere behind the battle.
class _ParallaxLayer extends Component with HasGameRef {
  final int layerIndex;
  final Color color;
  final double speed;
  final Vector2 gameSize;

  double _offset = 0;
  final List<_FloatingShape> _shapes = [];

  _ParallaxLayer({
    required this.layerIndex,
    required this.color,
    required this.speed,
    required this.gameSize,
  }) : super(priority: -10 + layerIndex);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final rng = Random(layerIndex * 42);

    // Generate random shapes across the canvas
    final count = 5 + layerIndex * 2;
    for (int i = 0; i < count; i++) {
      _shapes.add(_FloatingShape(
        x: rng.nextDouble() * (gameSize.x + 200) - 100,
        y: rng.nextDouble() * gameSize.y,
        radius: 20.0 + rng.nextDouble() * 40.0,
        speedMultiplier: 0.5 + rng.nextDouble() * 1.0,
      ));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _offset += speed * dt;

    // Wrap shapes
    for (final shape in _shapes) {
      shape.x -= speed * shape.speedMultiplier * dt;
      if (shape.x + shape.radius < -100) {
        shape.x = gameSize.x + 100 + shape.radius;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (final shape in _shapes) {
      canvas.drawCircle(
        Offset(shape.x, shape.y),
        shape.radius,
        paint,
      );
    }
  }
}

class _FloatingShape {
  double x;
  double y;
  double radius;
  double speedMultiplier;

  _FloatingShape({
    required this.x,
    required this.y,
    required this.radius,
    required this.speedMultiplier,
  });
}

// =============================================================================
// Shield flash ring effect
// =============================================================================

/// A brief expanding ring that fades out, used for the block/shield effect.
class _ShieldFlash extends CircleComponent {
  final Vector2 center;
  double _elapsed = 0;
  static const double _duration = 0.35;

  _ShieldFlash({required this.center})
      : super(
          position: center.clone(),
          radius: 10,
          anchor: Anchor.center,
          paint: Paint()
            ..color = const Color(0x884488FF)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3.0,
          priority: 85,
        );

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;

    if (_elapsed >= _duration) {
      removeFromParent();
      return;
    }

    final progress = _elapsed / _duration;
    // Expand ring
    radius = 10 + progress * 40;
    // Fade out
    final alpha = ((1.0 - progress) * 0.53).clamp(0.0, 1.0);
    paint.color = Color.fromRGBO(68, 136, 255, alpha);
    paint.strokeWidth = 3.0 * (1.0 - progress * 0.5);
  }
}
