import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;

  bool _isMuted = false;
  bool _isInitialized = false;

  SoundService._internal();

  bool get isMuted => _isMuted;

  @visibleForTesting
  static void muteForTesting() {
    _instance._isMuted = true;
    _instance._isInitialized = true;
  }

  Future<void> init() async {
    if (_isInitialized) return;
    final prefs = await SharedPreferences.getInstance();
    _isMuted = prefs.getBool('sound_muted') ?? false;
    _isInitialized = true;
  }

  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_muted', _isMuted);
  }

  static const int _poolSize = 4;
  List<AudioPlayer>? _playerPool;
  int _poolIndex = 0;

  List<AudioPlayer> _getPool() {
    _playerPool ??= List.generate(_poolSize, (_) => AudioPlayer());
    return _playerPool!;
  }

  void playSfx(String assetPath) {
    if (_isMuted) return;
    try {
      final pool = _getPool();
      final player = pool[_poolIndex];
      _poolIndex = (_poolIndex + 1) % _poolSize;
      player.stop();
      player.play(AssetSource(assetPath));
    } catch (e) {
      debugPrint('Error playing sound $assetPath: $e');
    }
  }

  void dispose() {
    if (_playerPool != null) {
      for (final player in _playerPool!) {
        player.dispose();
      }
    }
  }

  // Pre-defined SFX triggers
  void playLevelUp() => playSfx('sounds/level_up.mp3');
  void playQuestComplete() => playSfx('sounds/quest_complete.mp3');
  void playAttack() => playSfx('sounds/hit.mp3');
  void playClick() => playSfx('sounds/click.mp3');

  // ── Soul Deck SFX ─────────────────────────────────────────────────────────
  // 파일이 없을 경우 무시됨 (playSfx 내부 try/catch).
  // 실제 사운드는 assets/sounds/game/ 에 추가하세요.
  void playCardDraw() => playSfx('sounds/game/card_draw.mp3');
  void playCardPlayAttack() => playSfx('sounds/game/card_attack.mp3');
  void playCardPlayMagic() => playSfx('sounds/game/card_magic.mp3');
  void playCardPlayDefense() => playSfx('sounds/game/card_defense.mp3');
  void playCardPlayTactical() => playSfx('sounds/game/card_tactical.mp3');
  void playBlock() => playSfx('sounds/game/block.mp3');
  void playHeal() => playSfx('sounds/game/heal.mp3');
  void playEnemyAttack() => playSfx('sounds/game/enemy_attack.mp3');
  void playEnemyDefeat() => playSfx('sounds/game/enemy_defeat.mp3');
  void playBossAppear() => playSfx('sounds/game/boss_appear.mp3');
  void playVictory() => playSfx('sounds/game/victory.mp3');
  void playDefeat() => playSfx('sounds/game/defeat.mp3');
  void playTurnChange() => playSfx('sounds/game/turn_change.mp3');
  void playRelicPickup() => playSfx('sounds/game/relic_pickup.mp3');
  void playShopBuy() => playSfx('sounds/game/shop_buy.mp3');
  void playStatusEffect() => playSfx('sounds/game/status_effect.mp3');
}
