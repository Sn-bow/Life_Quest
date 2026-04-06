import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

/// The kind of floating number to display.
enum DamageTextType {
  /// Red text for damage dealt to enemies.
  damage,

  /// Yellow, larger text for critical hits.
  critical,

  /// Green text for healing.
  heal,
}

/// A floating text component that drifts upward and fades out.
///
/// Used to show damage dealt, critical hits, and healing amounts on the
/// battle canvas.  The text moves up 50 logical pixels over 0.8 seconds
/// while its opacity fades from 1.0 to 0.0, then removes itself.
class DamageText extends TextComponent {
  /// The numeric value to display (always shown as a positive integer).
  final int value;

  /// Controls color and size of the text.
  final DamageTextType type;

  /// The world-space position where the text spawns.
  final Vector2 startPosition;

  DamageText({
    required this.value,
    required this.type,
    required this.startPosition,
  }) : super(
          text: type == DamageTextType.heal ? '+$value' : '$value',
          position: startPosition.clone(),
          anchor: Anchor.center,
          priority: 100, // render on top of everything
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // --- Style ---
    textRenderer = TextPaint(
      style: TextStyle(
        fontSize: _fontSize,
        fontWeight: FontWeight.bold,
        color: _color,
        shadows: const [
          Shadow(offset: Offset(1, 1), blurRadius: 2, color: Colors.black87),
        ],
      ),
    );

    // --- Float upward ---
    add(
      MoveByEffect(
        Vector2(0, -50),
        EffectController(duration: 0.8, curve: Curves.easeOut),
      ),
    );

    // --- Fade out ---
    add(
      OpacityEffect.fadeOut(
        EffectController(duration: 0.8, curve: Curves.easeIn),
      ),
    );

    // --- Remove after animation completes ---
    add(
      RemoveEffect(delay: 0.85),
    );
  }

  // ───────────────────────────────────────────
  // Helpers
  // ───────────────────────────────────────────

  double get _fontSize {
    switch (type) {
      case DamageTextType.damage:
        return 24;
      case DamageTextType.critical:
        return 32;
      case DamageTextType.heal:
        return 22;
    }
  }

  Color get _color {
    switch (type) {
      case DamageTextType.damage:
        return const Color(0xFFFF4444); // red
      case DamageTextType.critical:
        return const Color(0xFFFFD700); // gold / yellow
      case DamageTextType.heal:
        return const Color(0xFF44FF44); // green
    }
  }
}
