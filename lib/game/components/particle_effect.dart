import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

/// A single particle that moves outward from a spawn point, affected by
/// gravity, and fades out over its lifetime.
class _Particle extends CircleComponent {
  final Vector2 velocity;
  final double gravity;
  final double lifetime;
  double _elapsed = 0;

  _Particle({
    required Vector2 position,
    required this.velocity,
    required double radius,
    required Color color,
    this.gravity = 120.0,
    this.lifetime = 0.5,
  }) : super(
          position: position,
          radius: radius,
          anchor: Anchor.center,
          paint: Paint()..color = color,
          priority: 90,
        );

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;

    if (_elapsed >= lifetime) {
      removeFromParent();
      return;
    }

    // Move
    position.x += velocity.x * dt;
    position.y += velocity.y * dt;

    // Apply gravity
    velocity.y += gravity * dt;

    // Fade out
    final alpha = (1.0 - (_elapsed / lifetime)).clamp(0.0, 1.0);
    paint.color = paint.color.withOpacity(alpha);
  }
}

/// A reusable Flame Component that spawns [count] small circles from
/// [spawnPosition], each moving outward in random directions with gravity,
/// fading out over ~[lifetime] seconds.
///
/// Parameters:
///   - [spawnPosition]: The world-space point where particles originate.
///   - [color]: The base color for all particles.
///   - [count]: Number of particles to spawn (default 12).
///   - [speed]: Maximum initial speed of particles (default 120).
///   - [lifetime]: How long each particle lives in seconds (default 0.5).
///   - [particleRadius]: Radius of each circle particle (default 3).
///   - [gravity]: Downward acceleration applied to particles (default 120).
class ParticleEffect extends Component {
  final Vector2 spawnPosition;
  final Color color;
  final int count;
  final double speed;
  final double lifetime;
  final double particleRadius;
  final double gravity;

  ParticleEffect({
    required this.spawnPosition,
    required this.color,
    this.count = 12,
    this.speed = 120.0,
    this.lifetime = 0.5,
    this.particleRadius = 3.0,
    this.gravity = 120.0,
  }) : super(priority: 90);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final rng = Random();

    for (int i = 0; i < count; i++) {
      // Random angle in full circle
      final angle = rng.nextDouble() * 2 * pi;
      // Random speed between 30% and 100% of max
      final spd = speed * (0.3 + rng.nextDouble() * 0.7);

      final velocity = Vector2(
        cos(angle) * spd,
        sin(angle) * spd,
      );

      // Slight color variation
      final variation = (rng.nextDouble() * 40 - 20).round();
      final r = (color.red + variation).clamp(0, 255);
      final g = (color.green + variation).clamp(0, 255);
      final b = (color.blue + variation).clamp(0, 255);
      final particleColor = Color.fromARGB(255, r, g, b);

      // Slight size variation
      final radius = particleRadius * (0.6 + rng.nextDouble() * 0.8);

      add(_Particle(
        position: spawnPosition.clone(),
        velocity: velocity,
        radius: radius,
        color: particleColor,
        gravity: gravity,
        lifetime: lifetime * (0.6 + rng.nextDouble() * 0.4),
      ));
    }

    // Remove this container after all particles should be gone
    add(RemoveEffect(delay: lifetime + 0.2));
  }
}
