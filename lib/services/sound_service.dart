import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_quest_final_v2/utils/shared_pref_keys.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;

  bool _isMuted = false;
  bool _isInitialized = false;

  SoundService._internal();

  bool get isMuted => _isMuted;

  static const String _levelUpAsset = 'sounds/sfx/level_up.wav';
  static const String _attackSwingAsset = 'sounds/sfx/attack_swing.wav';
  static const String _buttonClickAsset = 'sounds/sfx/button_click.wav';
  static const String _cardDrawAsset = 'sounds/game/card_draw.mp3';
  static const String _magicCastAsset = 'sounds/sfx/magic_cast.wav';
  static const String _defendBlockAsset = 'sounds/sfx/defend_block.wav';
  static const String _cardTacticalAsset = 'sounds/game/card_tactical.mp3';
  static const String _healAsset = 'sounds/game/heal.mp3';
  static const String _enemyDeathAsset = 'sounds/sfx/enemy_death.wav';
  static const String _bossAppearAsset = 'sounds/game/boss_appear.mp3';
  static const String _victoryAsset = 'sounds/sfx/victory.wav';
  static const String _defeatAsset = 'sounds/game/defeat.mp3';
  static const String _turnChangeAsset = 'sounds/game/turn_change.mp3';
  static const String _relicPickupAsset = 'sounds/game/relic_pickup.mp3';
  static const String _shopBuyAsset = 'sounds/game/shop_buy.mp3';
  static const String _statusEffectAsset = 'sounds/game/status_effect.mp3';
  static const String _magicHitAsset = 'sounds/sfx/magic_hit.wav';
  static const String _cardPlayAsset = 'sounds/sfx/card_play.wav';
  static const String _dungeonBgmAsset = 'sounds/bgm/Before_the_Siege.mp3';

  @visibleForTesting
  static const Set<String> referencedAssetPaths = {
    _levelUpAsset,
    _attackSwingAsset,
    _buttonClickAsset,
    _cardDrawAsset,
    _magicCastAsset,
    _defendBlockAsset,
    _cardTacticalAsset,
    _healAsset,
    _enemyDeathAsset,
    _bossAppearAsset,
    _victoryAsset,
    _defeatAsset,
    _turnChangeAsset,
    _relicPickupAsset,
    _shopBuyAsset,
    _statusEffectAsset,
    _magicHitAsset,
    _cardPlayAsset,
    _dungeonBgmAsset,
  };

  @visibleForTesting
  static void muteForTesting() {
    _instance._isMuted = true;
    _instance._isInitialized = true;
  }

  Future<void> init() async {
    if (_isInitialized) return;
    final prefs = await SharedPreferences.getInstance();
    _isMuted = prefs.getBool(SharedPrefKeys.soundMuted) ?? false;
    _isInitialized = true;
  }

  // ── 볼륨 상수 ────────────────────────────────────────────────────────────
  final double _bgmVolume = 0.55; // BGM
  static const double _sfxVol = 0.38; // 일반 SFX
  static const double _sfxVictory = 0.22; // 승리 팡파르 (1.5s 길어서 따로 낮춤)

  // ── SFX AudioContext ─────────────────────────────────────────────────────
  // AndroidAudioFocus.none: SFX가 포커스를 요청하지 않아
  // BGM(gain)에 아무 포커스 이벤트를 발생시키지 않음 → BGM 끊김 없음
  // ignore: prefer_const_constructors
  static final AudioContext _sfxCtx = AudioContext(
    // ignore: prefer_const_constructors
    android: AudioContextAndroid(
      contentType: AndroidContentType.sonification,
      usageType: AndroidUsageType.game,
      audioFocus: AndroidAudioFocus.none, // ★ 포커스 관리 안 함
      isSpeakerphoneOn: false,
      stayAwake: false,
    ),
    // ignore: prefer_const_constructors
    iOS: AudioContextIOS(
      // ambient 카테고리는 자체적으로 다른 오디오와 혼합됨
      // mixWithOthers 옵션은 playback/playAndRecord/multiRoute 에서만 유효
      category: AVAudioSessionCategory.ambient,
      options: const {},
    ),
  );

  // ── BGM AudioContext ──────────────────────────────────────────────────────
  // ignore: prefer_const_constructors
  static final AudioContext _bgmCtx = AudioContext(
    // ignore: prefer_const_constructors
    android: AudioContextAndroid(
      contentType: AndroidContentType.music,
      usageType: AndroidUsageType.game,
      audioFocus: AndroidAudioFocus.gain,
      isSpeakerphoneOn: false,
      stayAwake: false,
    ),
    // ignore: prefer_const_constructors
    iOS: AudioContextIOS(
      category: AVAudioSessionCategory.playback,
      options: const {AVAudioSessionOptions.mixWithOthers},
    ),
  );

  // ── BGM 전용 플레이어 ─────────────────────────────────────────────────────
  AudioPlayer? _bgmPlayer;
  String? _currentBgm;

  // ── SFX: 호출마다 새 플레이어 생성 → onComplete 시 자동 dispose ──────────
  // 풀(pool) 방식을 버리고 1회용 패턴으로 변경.
  // 이유: 풀 플레이어가 AudioFocus 이벤트를 BGM 플레이어와 공유하며
  //       서로 간섭하는 문제를 근본적으로 차단.
  void playSfx(String assetPath, {double vol = _sfxVol}) {
    if (_isMuted) return;
    final player = AudioPlayer();
    player
      ..setAudioContext(_sfxCtx)
      ..play(AssetSource(assetPath), volume: vol)
          .catchError((e) => debugPrint('SFX error $assetPath: $e'));
    // 재생 완료 시 자동 해제
    player.onPlayerComplete.first
        .then((_) => player.dispose())
        .catchError((_) => player.dispose());
  }

  // ── BGM ───────────────────────────────────────────────────────────────────
  Future<void> playBgm(String assetPath) async {
    if (_isMuted) return;
    if (_currentBgm == assetPath) return;
    try {
      // 항상 새 인스턴스로 시작 (이전 상태 오염 방지)
      await _bgmPlayer?.dispose();
      _bgmPlayer = AudioPlayer();
      await _bgmPlayer!.setAudioContext(_bgmCtx);
      await _bgmPlayer!.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer!.play(AssetSource(assetPath), volume: _bgmVolume);
      _currentBgm = assetPath;
    } catch (e) {
      debugPrint('BGM error $assetPath: $e');
      _bgmPlayer = null;
      _currentBgm = null;
    }
  }

  Future<void> stopBgm() async {
    try {
      await _bgmPlayer?.stop();
      await _bgmPlayer?.dispose();
    } catch (_) {}
    _bgmPlayer = null;
    _currentBgm = null;
  }

  Future<void> pauseBgm() async => _bgmPlayer?.pause().ignore();
  Future<void> resumeBgm() async {
    if (!_isMuted) _bgmPlayer?.resume().ignore();
  }

  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPrefKeys.soundMuted, _isMuted);
    if (_isMuted) {
      await _bgmPlayer?.setVolume(0);
    } else {
      await _bgmPlayer?.setVolume(_bgmVolume);
    }
  }

  void dispose() => _bgmPlayer?.dispose();

  // ── 편의 메서드 ───────────────────────────────────────────────────────────
  void playLevelUp() => playSfx(_levelUpAsset);
  void playQuestComplete() => playSfx(_levelUpAsset);
  void playAttack() => playSfx(_attackSwingAsset);
  void playClick() => playSfx(_buttonClickAsset);

  // Soul Deck SFX
  void playCardDraw() => playSfx(_cardDrawAsset);
  void playCardPlayAttack() => playSfx(_attackSwingAsset);
  void playCardPlayMagic() => playSfx(_magicCastAsset);
  void playCardPlayDefense() => playSfx(_defendBlockAsset);
  void playCardPlayTactical() => playSfx(_cardTacticalAsset);
  void playBlock() => playSfx(_defendBlockAsset);
  void playHeal() => playSfx(_healAsset);
  void playEnemyAttack() => playSfx(_attackSwingAsset);
  void playEnemyDefeat() => playSfx(_enemyDeathAsset);
  void playBossAppear() => playSfx(_bossAppearAsset);
  void playVictory() => playSfx(_victoryAsset, vol: _sfxVictory);
  void playDefeat() => playSfx(_defeatAsset);
  void playTurnChange() => playSfx(_turnChangeAsset);
  void playRelicPickup() => playSfx(_relicPickupAsset);
  void playShopBuy() => playSfx(_shopBuyAsset);
  void playStatusEffect() => playSfx(_statusEffectAsset);

  // Battle SFX
  void playMagicHit() => playSfx(_magicHitAsset);
  void playBattleButtonClick() => playSfx(_buttonClickAsset);
  void playCardPlay() => playSfx(_cardPlayAsset);

  // BGM
  Future<void> playDungeonBgm() => playBgm(_dungeonBgmAsset);
  Future<void> stopDungeonBgm() => stopBgm();
}
