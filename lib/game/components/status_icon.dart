import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// A Flame Component that displays a status effect icon as a colored circle
/// with a single-letter abbreviation floating above an entity.
///
/// The icon gently bobs up and down to draw attention.
class StatusIcon extends PositionComponent {
  /// The abbreviation letter displayed inside the circle.
  final String abbreviation;

  /// The background color of the circle.
  final Color color;

  /// Whether this status is a debuff (uses slightly different styling).
  final bool isDebuff;

  late final CircleComponent _circle;
  late final TextComponent _label;

  double _bobTime = 0;

  StatusIcon({
    required this.abbreviation,
    required this.color,
    required Vector2 position,
    this.isDebuff = false,
  }) : super(
          position: position,
          size: Vector2(20, 20),
          anchor: Anchor.center,
          priority: 80,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Background circle
    _circle = CircleComponent(
      radius: 10,
      position: Vector2(10, 10),
      anchor: Anchor.center,
      paint: Paint()
        ..color = color.withValues(alpha: 0.85)
        ..style = PaintingStyle.fill,
    );
    add(_circle);

    // Border
    add(CircleComponent(
      radius: 10,
      position: Vector2(10, 10),
      anchor: Anchor.center,
      paint: Paint()
        ..color = isDebuff ? Colors.red.shade300 : Colors.white70
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    ));

    // Letter label
    _label = TextComponent(
      text: abbreviation,
      position: Vector2(10, 10),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(offset: Offset(0.5, 0.5), blurRadius: 1, color: Colors.black),
          ],
        ),
      ),
    );
    add(_label);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Gentle bob animation
    _bobTime += dt * 2.5;
    position.y += (0.3 * _sin(_bobTime)) * dt * 10;
  }

  /// Simple sine approximation using dart:math would require import,
  /// but we can just use a manual calculation.
  double _sin(double x) {
    // Normalize to 0..2PI range
    x = x % 6.2831853;
    // Taylor series approximation good enough for gentle bobbing
    double x2 = x * x;
    double x3 = x2 * x;
    double x5 = x3 * x2;
    double x7 = x5 * x2;
    return x - x3 / 6.0 + x5 / 120.0 - x7 / 5040.0;
  }

  // -----------------------------------------------------------------------
  // Factory constructors for common status types
  // -----------------------------------------------------------------------

  /// "V" for Vulnerable (orange)
  factory StatusIcon.vulnerable(Vector2 position) => StatusIcon(
        abbreviation: 'V',
        color: Colors.orange.shade700,
        position: position,
        isDebuff: true,
      );

  /// "W" for Weak (purple)
  factory StatusIcon.weak(Vector2 position) => StatusIcon(
        abbreviation: 'W',
        color: Colors.purple.shade600,
        position: position,
        isDebuff: true,
      );

  /// "P" for Poison (green)
  factory StatusIcon.poison(Vector2 position) => StatusIcon(
        abbreviation: 'P',
        color: Colors.green.shade800,
        position: position,
        isDebuff: true,
      );

  /// "B" for Burn (red-orange)
  factory StatusIcon.burn(Vector2 position) => StatusIcon(
        abbreviation: 'B',
        color: Colors.deepOrange.shade700,
        position: position,
        isDebuff: true,
      );

  /// "F" for Freeze (cyan)
  factory StatusIcon.freeze(Vector2 position) => StatusIcon(
        abbreviation: 'F',
        color: Colors.cyan.shade600,
        position: position,
        isDebuff: true,
      );

  /// "S" for Strength (red, buff)
  factory StatusIcon.strength(Vector2 position) => StatusIcon(
        abbreviation: 'S',
        color: Colors.red.shade600,
        position: position,
      );

  /// "D" for Dexterity (green, buff)
  factory StatusIcon.dexterity(Vector2 position) => StatusIcon(
        abbreviation: 'D',
        color: Colors.green.shade600,
        position: position,
      );

  /// "T" for Thorns (brown, buff)
  factory StatusIcon.thorns(Vector2 position) => StatusIcon(
        abbreviation: 'T',
        color: Colors.brown.shade600,
        position: position,
      );

  /// "R" for Regen (lime, buff)
  factory StatusIcon.regen(Vector2 position) => StatusIcon(
        abbreviation: 'R',
        color: Colors.lightGreen.shade600,
        position: position,
      );

  /// "+" for Focus (blue, buff)
  factory StatusIcon.focus(Vector2 position) => StatusIcon(
        abbreviation: '+',
        color: Colors.blue.shade600,
        position: position,
      );

  /// "!" for Fortify (steel blue, buff)
  factory StatusIcon.fortify(Vector2 position) => StatusIcon(
        abbreviation: '!',
        color: Colors.blueGrey.shade600,
        position: position,
      );
}
