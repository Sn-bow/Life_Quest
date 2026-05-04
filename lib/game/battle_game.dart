import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:life_quest_final_v2/game/components/damage_text.dart';
import 'package:life_quest_final_v2/game/components/particle_effect.dart';

/// Flame layer behind the Flutter battle UI.
///
/// Player and monster bodies are rendered by Flutter widgets. This layer owns
/// background atmosphere, card play effects, particles, and floating numbers.
class BattleGame extends FlameGame {
  int currentZone;

  BattleGame({this.currentZone = 1});

  final List<_ParallaxLayer> _parallaxLayers = [];

  SpriteComponent? _bgSprite;
  Sprite? _attackEffectSprite;
  Sprite? _defenseEffectSprite;
  Sprite? _magicEffectSprite;
  Sprite? _enemyDeathEffectSprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadSprites();
    _initParallaxBackground();
  }

  Future<void> _loadSprites() async {
    try {
      final bgImg = await Flame.images.load(_zoneBgPath(currentZone));
      _bgSprite = SpriteComponent(
        sprite: Sprite(bgImg),
        size: size,
        priority: -10,
      );
      add(_bgSprite!);
    } catch (_) {
      // The Flutter wrapper also paints the zone background.
    }

    _attackEffectSprite =
        await _tryLoadSprite('game/effects/effect_attack_slash.png');
    _defenseEffectSprite =
        await _tryLoadSprite('game/effects/effect_defense_shield.png');
    _magicEffectSprite =
        await _tryLoadSprite('game/effects/effect_magic_projectile.png');
    _enemyDeathEffectSprite =
        await _tryLoadSprite('game/effects/effect_enemy_death_burst.png');
  }

  Future<Sprite?> _tryLoadSprite(String path) async {
    try {
      return Sprite(await Flame.images.load(path));
    } catch (_) {
      return null;
    }
  }

  String _zoneBgPath(int zone) {
    switch (zone) {
      case 1:
        return 'backgrounds/bg_zone1_meadow.png';
      case 2:
        return 'backgrounds/bg_zone2_dark_forest.png';
      case 3:
        return 'backgrounds/bg_zone3_stone_castle.png';
      case 4:
        return 'backgrounds/bg_zone4_lava_cavern.png';
      case 5:
        return 'backgrounds/bg_zone5_abyss.png';
      default:
        return 'backgrounds/bg_zone1_meadow.png';
    }
  }

  @override
  Color backgroundColor() => const Color(0x00000000);

  void _initParallaxBackground() {
    final colors = _zoneParallaxColors(currentZone);

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
      case 1:
        return const [
          Color(0x15228B22),
          Color(0x10006400),
          Color(0x0D2E8B57),
        ];
      case 2:
        return const [
          Color(0x15708090),
          Color(0x10556B7B),
          Color(0x0D4682B4),
        ];
      case 3:
        return const [
          Color(0x15800080),
          Color(0x10663399),
          Color(0x0D9932CC),
        ];
      case 4:
        return const [
          Color(0x10191970),
          Color(0x0D000033),
          Color(0x08483D8B),
        ];
      case 5:
        return const [
          Color(0x15FF4500),
          Color(0x10DC143C),
          Color(0x0DFF6347),
        ];
      default:
        return const [
          Color(0x15228B22),
          Color(0x10006400),
          Color(0x0D2E8B57),
        ];
    }
  }

  void playAttackAnimation() {
    final sprite = _attackEffectSprite;
    if (sprite == null) return;

    add(_SpriteSweepEffect(
      sprite: sprite,
      start: Vector2(size.x * 0.28, size.y * 0.40),
      end: Vector2(size.x * 0.72, size.y * 0.32),
    ));
  }

  void playDefendAnimation() {
    final sprite = _defenseEffectSprite;
    if (sprite == null) return;

    add(_SpritePulseEffect(
      sprite: sprite,
      center: Vector2(size.x * 0.28, size.y * 0.38),
      baseSize: Vector2.all(92),
      duration: 0.42,
      rise: -22,
    ));
  }

  void playMagicAnimation() {
    final target = Vector2(size.x * 0.72, size.y * 0.32);
    final sprite = _magicEffectSprite;
    if (sprite == null) {
      playHitParticle(position: target);
      return;
    }

    add(_SpriteProjectile(
      sprite: sprite,
      start: Vector2(size.x * 0.30, size.y * 0.38),
      target: target,
      onHit: () => playHitParticle(position: target),
    ));
  }

  void showDamageNumber(int damage, {bool isCritical = false}) {
    add(DamageText(
      value: damage,
      type: isCritical ? DamageTextType.critical : DamageTextType.damage,
      startPosition: Vector2(size.x * 0.7, size.y * 0.35),
    ));
  }

  void showHealNumber(int amount) {
    add(DamageText(
      value: amount,
      type: DamageTextType.heal,
      startPosition: Vector2(size.x * 0.3, size.y * 0.35),
    ));
  }

  void onEnemyDefeated() {
    final sprite = _enemyDeathEffectSprite;
    if (sprite == null) return;

    add(_SpriteBurstEffect(
      sprite: sprite,
      center: Vector2(size.x * 0.72, size.y * 0.35),
    ));
  }

  void playHitParticle({Vector2? position}) {
    try {
      add(ParticleEffect(
        spawnPosition: position ?? Vector2(size.x * 0.7, size.y * 0.35),
        color: const Color(0xFFFF4444),
        count: 15,
        speed: 140.0,
        lifetime: 0.5,
        particleRadius: 3.0,
        gravity: 100.0,
      ));
    } catch (_) {}
  }

  void playHealParticle({Vector2? position}) {
    try {
      add(ParticleEffect(
        spawnPosition: position ?? Vector2(size.x * 0.3, size.y * 0.35),
        color: const Color(0xFF44FF88),
        count: 10,
        speed: 60.0,
        lifetime: 0.7,
        particleRadius: 2.5,
        gravity: -30.0,
      ));
    } catch (_) {}
  }

  void playBlockParticle({Vector2? position}) {
    try {
      final pos = position ?? Vector2(size.x * 0.3, size.y * 0.35);
      add(ParticleEffect(
        spawnPosition: pos,
        color: const Color(0xFF4488FF),
        count: 8,
        speed: 80.0,
        lifetime: 0.4,
        particleRadius: 3.5,
        gravity: 0.0,
      ));
      add(_ShieldFlash(center: pos));
    } catch (_) {}
  }
}

class _SpriteSweepEffect extends Component {
  final Sprite sprite;
  final Vector2 start;
  final Vector2 end;

  double _elapsed = 0;
  static const double _duration = 0.22;

  _SpriteSweepEffect({
    required this.sprite,
    required this.start,
    required this.end,
  }) : super(priority: 90);

  @override
  void update(double dt) {
    _elapsed += dt;
    if (_elapsed >= _duration) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final progress = (_elapsed / _duration).clamp(0.0, 1.0);
    final alpha = progress < 0.25
        ? progress / 0.25
        : (1.0 - (progress - 0.25) / 0.75).clamp(0.0, 1.0);
    final center = Vector2(
      lerpDouble(start.x, end.x, 0.62)!,
      lerpDouble(start.y, end.y, 0.62)!,
    );
    final distance = start.distanceTo(end);

    _renderSprite(
      canvas: canvas,
      sprite: sprite,
      center: center,
      size:
          Vector2(distance * 1.08, distance * 0.40) * (0.92 + progress * 0.16),
      alpha: alpha,
      angle: atan2(end.y - start.y, end.x - start.x) - 0.12,
    );
  }
}

class _SpritePulseEffect extends Component {
  final Sprite sprite;
  final Vector2 center;
  final Vector2 baseSize;
  final double duration;
  final double rise;

  double _elapsed = 0;

  _SpritePulseEffect({
    required this.sprite,
    required this.center,
    required this.baseSize,
    required this.duration,
    required this.rise,
  }) : super(priority: 90);

  @override
  void update(double dt) {
    _elapsed += dt;
    if (_elapsed >= duration) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final progress = (_elapsed / duration).clamp(0.0, 1.0);
    final alpha = progress < 0.2
        ? progress / 0.2
        : (1.0 - (progress - 0.2) / 0.8).clamp(0.0, 1.0);

    _renderSprite(
      canvas: canvas,
      sprite: sprite,
      center: center + Vector2(0, rise * progress),
      size: baseSize * (0.72 + 0.36 * min(progress / 0.25, 1.0)),
      alpha: alpha,
    );
  }
}

class _SpriteProjectile extends Component {
  final Sprite sprite;
  final Vector2 start;
  final Vector2 target;
  final VoidCallback onHit;

  double _elapsed = 0;
  static const double _travelTime = 0.30;
  bool _hitFired = false;

  _SpriteProjectile({
    required this.sprite,
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
    final progress = (_elapsed / _travelTime).clamp(0.0, 1.0);
    final center = Vector2(
      lerpDouble(start.x, target.x, progress)!,
      lerpDouble(start.y, target.y, progress)!,
    );

    _renderSprite(
      canvas: canvas,
      sprite: sprite,
      center: center,
      size: Vector2.all(72),
      alpha: 1.0,
      angle: atan2(target.y - start.y, target.x - start.x),
    );
  }
}

class _SpriteBurstEffect extends Component {
  final Sprite sprite;
  final Vector2 center;

  double _elapsed = 0;
  static const double _duration = 0.46;

  _SpriteBurstEffect({
    required this.sprite,
    required this.center,
  }) : super(priority: 95);

  @override
  void update(double dt) {
    _elapsed += dt;
    if (_elapsed >= _duration) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final progress = (_elapsed / _duration).clamp(0.0, 1.0);
    final alpha =
        progress < 0.12 ? progress / 0.12 : (1.0 - progress).clamp(0.0, 1.0);

    _renderSprite(
      canvas: canvas,
      sprite: sprite,
      center: center,
      size: Vector2.all(90 + progress * 90),
      alpha: alpha,
      angle: progress * 0.28,
    );
  }
}

void _renderSprite({
  required Canvas canvas,
  required Sprite sprite,
  required Vector2 center,
  required Vector2 size,
  required double alpha,
  double angle = 0,
}) {
  canvas.save();
  canvas.translate(center.x, center.y);
  if (angle != 0) canvas.rotate(angle);

  final paint = Paint()
    ..color = Color.fromRGBO(255, 255, 255, alpha.clamp(0.0, 1.0))
    ..blendMode = BlendMode.modulate
    ..filterQuality = FilterQuality.medium;

  sprite.render(
    canvas,
    position: Vector2(-size.x / 2, -size.y / 2),
    size: size,
    overridePaint: paint,
  );
  canvas.restore();
}

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
    radius = 10 + progress * 40;
    final alpha = ((1.0 - progress) * 0.53).clamp(0.0, 1.0);
    paint.color = Color.fromRGBO(68, 136, 255, alpha);
    paint.strokeWidth = 3.0 * (1.0 - progress * 0.5);
  }
}
