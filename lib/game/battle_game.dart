import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
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

  /// Optional monster ID — used to load the monster sprite if present.
  String? monsterId;

  BattleGame({this.currentZone = 1, this.monsterId});

  // Parallax layers
  final List<_ParallaxLayer> _parallaxLayers = [];

  // Sprite components (nullable — graceful fallback to Canvas drawing)
  SpriteComponent? _bgSprite;
  SpriteComponent? _playerSprite;
  SpriteComponent? _monsterSprite;

  // ───────────────────────────────────────────
  // Lifecycle
  // ───────────────────────────────────────────

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _initParallaxBackground();   // 즉시 Canvas 배경 시작
    _loadSprites();              // 스프라이트는 비동기 로드 (화면 블로킹 없음)
  }

  /// Attempts to load background / player / monster sprites.
  /// Failures are silently ignored — the Canvas-drawn fallback is always shown.
  Future<void> _loadSprites() async {
    // Background
    final bgPath = _zoneBgPath(currentZone);
    try {
      final bgImg = await Flame.images.load(bgPath);
      _bgSprite = SpriteComponent(
        sprite: Sprite(bgImg),
        size: size,
        priority: -10,
      );
      add(_bgSprite!);
    } catch (_) {
      // No background image — parallax Canvas fallback handles it.
    }

    // Player hero sprite
    try {
      final heroImg = await Flame.images.load('images/player/hero_idle.png');
      _playerSprite = SpriteComponent(
        sprite: Sprite(heroImg),
        size: Vector2(120, 120),
        position: Vector2(size.x * 0.18, size.y * 0.28),
        priority: 10,
      );
      add(_playerSprite!);
    } catch (_) {
      // No hero sprite — battle still works without it.
    }

    // Monster sprite (if monsterId provided)
    if (monsterId != null) {
      final monsterPath = 'images/monsters/${monsterId!.replaceAll(RegExp(r'_f\d+$'), '')}.png';
      try {
        final monsterImg = await Flame.images.load(monsterPath);
        _monsterSprite = SpriteComponent(
          sprite: Sprite(monsterImg),
          size: Vector2(130, 130),
          position: Vector2(size.x * 0.60, size.y * 0.20),
          priority: 10,
        );
        add(_monsterSprite!);
      } catch (_) {
        // No monster sprite — the Flutter overlay draws the enemy name/HP bar.
      }
    }
  }

  /// Returns the asset path for a zone background image.
  String _zoneBgPath(int zone) {
    switch (zone) {
      case 1: return 'images/backgrounds/bg_zone1_meadow.png';
      case 2: return 'images/backgrounds/bg_zone2_dark_forest.png';
      case 3: return 'images/backgrounds/bg_zone3_stone_castle.png';
      case 4: return 'images/backgrounds/bg_zone4_lava_cavern.png';
      case 5: return 'images/backgrounds/bg_zone5_abyss.png';
      default: return 'images/backgrounds/bg_zone1_meadow.png';
    }
  }

  /// Call this to swap the monster sprite when moving to the next enemy.
  Future<void> updateMonster(String newMonsterId) async {
    monsterId = newMonsterId;
    _monsterSprite?.removeFromParent();
    _monsterSprite = null;

    final monsterPath = 'images/monsters/${newMonsterId.replaceAll(RegExp(r'_f\d+$'), '')}.png';
    try {
      final monsterImg = await Flame.images.load(monsterPath);
      _monsterSprite = SpriteComponent(
        sprite: Sprite(monsterImg),
        size: Vector2(130, 130),
        position: Vector2(size.x * 0.60, size.y * 0.20),
        priority: 10,
      );
      add(_monsterSprite!);
    } catch (_) {}
  }

  @override
  Color backgroundColor() {
    // Transparent — the Flutter Stack layer below GameWidget
    // renders the zone background image (with gradient fallback),
    // so the Flame canvas must be see-through.
    return const Color(0x00000000);
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
  ///
  /// Draws three diagonal lines (primary + two parallels) that quickly
  /// appear and fade — no sprite assets required.
  void playAttackAnimation() {
    final playerSide = Vector2(size.x * 0.28, size.y * 0.40);
    final enemySide  = Vector2(size.x * 0.72, size.y * 0.32);
    add(_SlashEffect(start: playerSide, end: enemySide));
  }

  /// Plays a shield-raise animation on the player.
  ///
  /// Draws a pentagon-shaped shield outline that expands and floats upward
  /// before fading — no sprite assets required.
  void playDefendAnimation() {
    final playerPos = Vector2(size.x * 0.28, size.y * 0.38);
    add(_ShieldRaiseEffect(center: playerPos));
  }

  /// Plays a magic projectile animation toward the enemy.
  ///
  /// A glowing orb with a trailing tail travels from the player to the
  /// enemy position, then triggers a hit-particle burst on arrival.
  void playMagicAnimation() {
    final start  = Vector2(size.x * 0.30, size.y * 0.38);
    final target = Vector2(size.x * 0.72, size.y * 0.32);
    add(_MagicProjectile(
      start: start,
      target: target,
      onHit: () => playHitParticle(position: target),
    ));
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
  /// Triggers a white flash followed by coloured shards flying outward
  /// from the enemy position — no sprite assets required.
  void onEnemyDefeated() {
    final enemyPos = Vector2(size.x * 0.72, size.y * 0.35);
    add(_EnemyDeathEffect(center: enemyPos));
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
// Slash animation (attack)
// =============================================================================

/// Three diagonal lines (primary + two offset parallels) that flash
/// across the screen from the player toward the enemy.
class _SlashEffect extends Component {
  final Vector2 start;
  final Vector2 end;

  double _elapsed = 0;
  static const double _duration = 0.22;

  _SlashEffect({required this.start, required this.end})
      : super(priority: 90);

  @override
  void update(double dt) {
    _elapsed += dt;
    if (_elapsed >= _duration) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final progress = (_elapsed / _duration).clamp(0.0, 1.0);
    // Quick in (first 25%) then fade out (remaining 75%)
    final alpha = progress < 0.25
        ? progress / 0.25
        : (1.0 - (progress - 0.25) / 0.75).clamp(0.0, 1.0);

    final dx = end.x - start.x;
    final dy = end.y - start.y;
    final perpX = -dy * 0.08;
    final perpY =  dx * 0.08;
    final strokeW = 3.0 + (1.0 - progress) * 2.0;

    // Primary slash — bright white/yellow
    canvas.drawLine(
      Offset(start.x, start.y),
      Offset(end.x, end.y),
      Paint()
        ..color = Color.fromRGBO(255, 245, 180, alpha)
        ..strokeWidth = strokeW
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );
    // Upper parallel
    canvas.drawLine(
      Offset(start.x + perpX, start.y + perpY),
      Offset(end.x   + perpX, end.y   + perpY),
      Paint()
        ..color = Color.fromRGBO(255, 180, 0, alpha * 0.55)
        ..strokeWidth = strokeW * 0.6
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );
    // Lower parallel
    canvas.drawLine(
      Offset(start.x - perpX, start.y - perpY),
      Offset(end.x   - perpX, end.y   - perpY),
      Paint()
        ..color = Color.fromRGBO(255, 180, 0, alpha * 0.55)
        ..strokeWidth = strokeW * 0.6
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );
  }
}

// =============================================================================
// Shield raise animation (defend)
// =============================================================================

/// A pentagon-shaped shield outline that expands from the player position,
/// floats upward slightly, then fades out.
class _ShieldRaiseEffect extends Component {
  final Vector2 center;

  double _elapsed = 0;
  static const double _duration = 0.42;

  _ShieldRaiseEffect({required this.center}) : super(priority: 90);

  @override
  void update(double dt) {
    _elapsed += dt;
    if (_elapsed >= _duration) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final progress = (_elapsed / _duration).clamp(0.0, 1.0);
    final alpha = progress < 0.2
        ? progress / 0.2
        : (1.0 - (progress - 0.2) / 0.8).clamp(0.0, 1.0);

    final rise   = -22.0 * progress;
    final scale  = 0.6 + 0.4 * min(progress / 0.25, 1.0);
    final sz     = 30.0 * scale;
    final cx     = center.x;
    final cy     = center.y + rise;

    // Pentagon-style shield path
    final path = Path()
      ..moveTo(cx - sz * 0.6, cy - sz * 0.5)
      ..lineTo(cx + sz * 0.6, cy - sz * 0.5)
      ..lineTo(cx + sz * 0.6, cy + sz * 0.15)
      ..lineTo(cx,             cy + sz * 0.65)
      ..lineTo(cx - sz * 0.6, cy + sz * 0.15)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..color = Color.fromRGBO(64, 180, 255, alpha * 0.18)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = Color.fromRGBO(64, 180, 255, alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4,
    );
  }
}

// =============================================================================
// Magic projectile animation
// =============================================================================

/// A glowing orb with a fading trail that flies from the player toward the
/// enemy.  Calls [onHit] when it arrives, then removes itself.
class _MagicProjectile extends Component {
  final Vector2 start;
  final Vector2 target;
  final VoidCallback onHit;

  double _elapsed = 0;
  static const double _travelTime = 0.30;
  bool _hitFired = false;

  _MagicProjectile({
    required this.start,
    required this.target,
    required this.onHit,
  }) : super(priority: 90);

  @override
  void update(double dt) {
    _elapsed += dt;
    if (_elapsed >= _travelTime) {
      if (!_hitFired) {
        _hitFired = true;
        onHit();
      }
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final t = (_elapsed / _travelTime).clamp(0.0, 1.0);
    final cx = lerpDouble(start.x, target.x, t)!;
    final cy = lerpDouble(start.y, target.y, t)!;

    // Soft glow (blur mask)
    canvas.drawCircle(
      Offset(cx, cy),
      14.0,
      Paint()
        ..color = const Color(0x55BB44FF)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
    );
    // Core orb
    canvas.drawCircle(
      Offset(cx, cy),
      6.0,
      Paint()..color = const Color(0xFFDD88FF),
    );

    // Trail — three ghost copies fading behind the orb
    for (int i = 1; i <= 3; i++) {
      final tt = (t - i * 0.06).clamp(0.0, 1.0);
      final tx = lerpDouble(start.x, target.x, tt)!;
      final ty = lerpDouble(start.y, target.y, tt)!;
      canvas.drawCircle(
        Offset(tx, ty),
        (5.5 - i * 1.3).clamp(0.0, 6.0),
        Paint()
          ..color = Color.fromRGBO(187, 68, 255, 0.28 / i),
      );
    }
  }
}

// =============================================================================
// Enemy defeat animation (shatter + flash)
// =============================================================================

/// White flash followed by 12 rectangular shards flying outward with gravity,
/// all fading to nothing over ~0.6 s.
class _EnemyDeathEffect extends Component {
  final Vector2 center;

  double _elapsed = 0;
  static const double _duration = 0.60;

  final List<_Shard> _shards = [];

  _EnemyDeathEffect({required this.center}) : super(priority: 95) {
    final rng = Random();
    for (int i = 0; i < 12; i++) {
      final base  = (i / 12) * 2 * pi;
      final jitter = rng.nextDouble() * 0.4;
      _shards.add(_Shard(
        angle: base + jitter,
        speed: 55.0 + rng.nextDouble() * 90.0,
        size:  4.0  + rng.nextDouble() * 9.0,
      ));
    }
  }

  @override
  void update(double dt) {
    _elapsed += dt;
    if (_elapsed >= _duration) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final progress = (_elapsed / _duration).clamp(0.0, 1.0);
    final alpha    = (1.0 - progress).clamp(0.0, 1.0);

    // Brief white flash at the start
    if (progress < 0.18) {
      final flashA = (1.0 - progress / 0.18) * 0.75;
      canvas.drawCircle(
        Offset(center.x, center.y),
        60.0 * (progress / 0.18),
        Paint()..color = Color.fromRGBO(255, 255, 255, flashA),
      );
    }

    // Shards
    for (final shard in _shards) {
      final dist = shard.speed * _elapsed;
      final sx   = center.x + cos(shard.angle) * dist;
      final sy   = center.y + sin(shard.angle) * dist
                   + 50.0 * progress * progress; // gravity pull

      final sz = shard.size * (1.0 - progress * 0.6);
      canvas.drawRect(
        Rect.fromCenter(center: Offset(sx, sy), width: sz, height: sz),
        Paint()..color = Color.fromRGBO(200, 140, 255, alpha),
      );
    }
  }
}

class _Shard {
  final double angle;
  final double speed;
  final double size;

  _Shard({required this.angle, required this.speed, required this.size});
}

// =============================================================================
// Parallax background layer
// =============================================================================

/// A single parallax layer: draws a set of slowly drifting translucent shapes
/// to create depth and atmosphere behind the battle.
class _ParallaxLayer extends Component with HasGameReference {
  final int layerIndex;
  final Color color;
  final double speed;
  final Vector2 gameSize;

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
  @override
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
