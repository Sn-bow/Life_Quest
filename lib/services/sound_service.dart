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

  static const int _poolSize = 4;
  List<AudioPlayer>? _playerPool;
  int _poolIndex = 0;

  // ── BGM 전용 플레이어 ────────────────────────────────────────────────────
  AudioPlayer? _bgmPlayer;
  String? _currentBgm;
  final double _bgmVolume = 0.45; // BGM은 SFX보다 낮게

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
      player.stop().ignore();
      player.play(AssetSource(assetPath)).ignore();
    } catch (e) {
      debugPrint('Error playing sound $assetPath: $e');
    }
  }

  /// BGM 재생 (루프). 이미 같은 곡이 재생 중이면 무시.
  Future<void> playBgm(String assetPath) async {
    if (_isMuted) return;
    if (_currentBgm == assetPath) return; // 같은 곡 중복 재생 방지
    try {
      _bgmPlayer ??= AudioPlayer();
      await _bgmPlayer!.stop();
      await _bgmPlayer!.setVolume(_bgmVolume);
      await _bgmPlayer!.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer!.play(AssetSource(assetPath));
      _currentBgm = assetPath;
    } catch (e) {
      debugPrint('Error playing BGM $assetPath: $e');
    }
  }

  /// BGM 정지
  Future<void> stopBgm() async {
    try {
      await _bgmPlayer?.stop();
      _currentBgm = null;
    } catch (e) {
      debugPrint('Error stopping BGM: $e');
    }
  }

  /// BGM 일시정지 / 재개
  Future<void> pauseBgm() async => _bgmPlayer?.pause().ignore();
  Future<void> resumeBgm() async {
    if (_isMuted) return;
    _bgmPlayer?.resume().ignore();
  }

  /// 뮤트 토글 시 BGM도 함께 처리
  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_muted', _isMuted);
    if (_isMuted) {
      await _bgmPlayer?.setVolume(0);
    } else {
      await _bgmPlayer?.setVolume(_bgmVolume);
    }
  }

  void dispose() {
    if (_playerPool != null) {
      for (final player in _playerPool!) {
        player.dispose();
      }
    }
    _bgmPlayer?.dispose();
  }

  // Pre-defined SFX triggers
  void playLevelUp() => playSfx('sounds/sfx/level_up.wav');
  void playQuestComplete() => playSfx('sounds/quest_complete.mp3');
  void playAttack() => playSfx('sounds/hit.mp3');
  void playClick() => playSfx('sounds/click.mp3');

  // ── Soul Deck SFX ─────────────────────────────────────────────────────────
  // 파일이 없을 경우 무시됨 (playSfx 내부 try/catch).
  void playCardDraw() => playSfx('sounds/game/card_draw.mp3');
  void playCardPlayAttack() => playSfx('sounds/sfx/attack_swing.wav');
  void playCardPlayMagic() => playSfx('sounds/sfx/magic_cast.wav');
  void playCardPlayDefense() => playSfx('sounds/sfx/defend_block.wav');
  void playCardPlayTactical() => playSfx('sounds/game/card_tactical.mp3');
  void playBlock() => playSfx('sounds/sfx/defend_block.wav');
  void playHeal() => playSfx('sounds/game/heal.mp3');
  void playEnemyAttack() => playSfx('sounds/sfx/attack_swing.wav');
  void playEnemyDefeat() => playSfx('sounds/sfx/enemy_death.wav');
  void playBossAppear() => playSfx('sounds/game/boss_appear.mp3');
  void playVictory() => playSfx('sounds/sfx/victory.wav');
  void playDefeat() => playSfx('sounds/game/defeat.mp3');
  void playTurnChange() => playSfx('sounds/game/turn_change.mp3');
  void playRelicPickup() => playSfx('sounds/game/relic_pickup.mp3');
  void playShopBuy() => playSfx('sounds/game/shop_buy.mp3');
  void playStatusEffect() => playSfx('sounds/game/status_effect.mp3');

  // ── Battle SFX (WAV — 직접 생성) ───────────────────────────────────────
  void playMagicHit() => playSfx('sounds/sfx/magic_hit.wav');
  void playBattleButtonClick() => playSfx('sounds/sfx/button_click.wav');
  void playCardPlay() => playSfx('sounds/sfx/card_play.wav');

  // ── BGM 편의 메서드 ──────────────────────────────────────────────────────
  /// 던전/전투 배경음악 시작
  Future<void> playDungeonBgm() =>
      playBgm('sounds/bgm/Before_the_Siege.mp3');

  /// 던전 나갈 때 BGM 정지
  Future<void> stopDungeonBgm() => stopBgm();

}
