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
}
