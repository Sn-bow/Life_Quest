import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kDebugMode, defaultTargetPlatform, TargetPlatform, debugPrint;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Singleton service for managing AdMob rewarded ads.
class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  // =========================================================
  // Production AdMob Ad Unit IDs (platform-specific)
  // =========================================================
  static const String _productionRewardedAdUnitIdAndroid =
      'ca-app-pub-5571035794358799/6920800679';
  static const String _productionRewardedAdUnitIdIOS =
      'ca-app-pub-5571035794358799/3529184725';

  static String get _rewardedAdUnitId {
    if (kDebugMode) {
      return 'ca-app-pub-3940256099942544/5224354917'; // Test ID
    }
    return defaultTargetPlatform == TargetPlatform.iOS
        ? _productionRewardedAdUnitIdIOS
        : _productionRewardedAdUnitIdAndroid;
  }

  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;
  bool _isAdLoading = false;
  bool _isAdRemoved = false;
  int _retryCount = 0;
  static const int _maxRetries = 5;

  // --- Daily limits ---
  final Map<String, int> _dailyAdCounts = {};
  String? _lastResetDate;

  // --- Server-time anchor (anti-tampering) ---
  // 앱 세션 내에서 DateTime.now() 조작을 무시하기 위해
  // 서버 시각을 앵커로 잡고 모노토닉 Stopwatch로 경과시간을 측정한다.
  DateTime? _serverAnchor;
  final Stopwatch _anchorElapsed = Stopwatch();
  DateTime? _lastKnownServerTime;

  static const Map<String, int> dailyLimits = {
    'ap_recovery': 3,
    'quest_double': 2,
    'combat_revive': 1,
    'report_detail': 3,
    'combat_multiplier': 3,
  };

  /// Initialize the Mobile Ads SDK.
  /// GDPR: UMP SDK를 통해 사용자 동의 상태를 확인하고, 동의 완료 후 광고를 로드합니다.
  Future<void> init() async {
    await _loadAdRemovalStatus();
    await _loadDailyCounts();
    // 서버 시각 앵커를 먼저 확보한 뒤 리셋 판정 — 실패 시 폴백(아래 _serverNow 참고)
    await _syncServerTime();
    _resetDailyCountsIfNeeded();

    // UMP(User Messaging Platform) - GDPR 동의 플로우
    await _requestConsentAndInitAds();
  }

  /// Firestore 서버 타임스탬프로 시각 앵커를 확보한다.
  /// 성공 시 [_serverAnchor] 와 모노토닉 [_anchorElapsed] 를 세팅하고
  /// [_lastKnownServerTime] 을 영속 저장한다.
  /// 실패(오프라인/미인증 등)해도 조용히 통과 — 호출부는 [_serverNow] 폴백을 사용.
  Future<void> _syncServerTime() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint('[AdService] Server time sync skipped: no auth user.');
        return;
      }
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('_meta')
          .doc('adServerTime');
      await docRef
          .set({'t': FieldValue.serverTimestamp()}, SetOptions(merge: true))
          .timeout(const Duration(seconds: 5));
      final snap = await docRef
          .get(const GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 5));
      final ts = (snap.data()?['t'] as Timestamp?)?.toDate();
      if (ts != null) {
        _serverAnchor = ts;
        _anchorElapsed
          ..reset()
          ..start();
        _lastKnownServerTime = ts;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('ad_last_server_ms', ts.millisecondsSinceEpoch);
      }
    } catch (e) {
      debugPrint('[AdService] Server time sync failed: $e');
    }
  }

  /// 서버 기준 현재 시각.
  /// 우선순위: (1) 세션 시작 시 확보한 서버 앵커 + 모노토닉 경과,
  /// (2) max(디바이스 시각, 영속 저장된 마지막 서버 시각) — 시각 되감기 방지.
  DateTime _serverNow() {
    if (_serverAnchor != null) {
      return _serverAnchor!.add(_anchorElapsed.elapsed);
    }
    final device = DateTime.now();
    final last = _lastKnownServerTime;
    if (last != null && device.isBefore(last)) return last;
    return device;
  }

  Future<void> _requestConsentAndInitAds() async {
    final completer = Completer<void>();

    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () async {
        // 동의 정보 업데이트 성공
        try {
          final formAvailable =
              await ConsentInformation.instance.isConsentFormAvailable();
          if (formAvailable) {
            await ConsentForm.loadAndShowConsentFormIfRequired(
              (FormError? error) {
                if (error != null) {
                  debugPrint('[AdService] UMP form dismissed with error: ${error.message}');
                }
              },
            );
          }
        } catch (e) {
          debugPrint('[AdService] UMP consent form error: $e');
        }
        if (!completer.isCompleted) completer.complete();
      },
      (FormError error) {
        debugPrint('[AdService] UMP consent info update failed: ${error.message}');
        if (!completer.isCompleted) completer.complete(); // 실패해도 광고 초기화는 진행
      },
    );

    // 최대 5초 대기 (UMP 응답 없을 경우 타임아웃)
    await completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        debugPrint('[AdService] UMP consent timed out');
        if (!completer.isCompleted) completer.complete();
      },
    );

    // 동의 완료 또는 불필요 지역: 광고 SDK 초기화
    await MobileAds.instance.initialize();
    _loadRewardedAd();
  }

  /// Check if ads have been removed via IAP.
  bool get isAdRemoved => _isAdRemoved;

  /// Mark ads as removed (called after successful IAP).
  Future<void> setAdRemoved(bool removed) async {
    _isAdRemoved = removed;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ad_removed', removed);
  }

  Future<void> _loadAdRemovalStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isAdRemoved = prefs.getBool('ad_removed') ?? false;
  }

  /// Get remaining ad views for a specific reward type.
  int getRemainingViews(String rewardType) {
    _resetDailyCountsIfNeeded();
    final limit = dailyLimits[rewardType] ?? 0;
    final used = _dailyAdCounts[rewardType] ?? 0;
    return (limit - used).clamp(0, limit);
  }

  Future<void> _loadDailyCounts() async {
    final prefs = await SharedPreferences.getInstance();
    _lastResetDate = prefs.getString('ad_last_reset_date');
    final lastServerMs = prefs.getInt('ad_last_server_ms');
    if (lastServerMs != null) {
      _lastKnownServerTime =
          DateTime.fromMillisecondsSinceEpoch(lastServerMs, isUtc: true);
    }
    final keys = dailyLimits.keys;
    for (final key in keys) {
      _dailyAdCounts[key] = prefs.getInt('ad_count_$key') ?? 0;
    }
  }

  Future<void> _saveDailyCounts() async {
    final prefs = await SharedPreferences.getInstance();
    if (_lastResetDate != null) {
      await prefs.setString('ad_last_reset_date', _lastResetDate!);
    }
    for (final entry in _dailyAdCounts.entries) {
      await prefs.setInt('ad_count_${entry.key}', entry.value);
    }
  }

  /// 일일 카운트 초기화. 시각 조작 방지를 위해:
  /// - [_serverNow] 로 오늘 날짜를 계산 (세션 내 앵커 + 모노토닉 경과)
  /// - `_lastResetDate` 는 사전순 강증가만 허용 (클럭 롤백 공격 차단)
  void _resetDailyCountsIfNeeded() {
    final today = _serverNow().toIso8601String().substring(0, 10);
    final last = _lastResetDate;
    if (last == null || today.compareTo(last) > 0) {
      _dailyAdCounts.clear();
      _lastResetDate = today;
      _saveDailyCounts();
    }
  }

  /// Pre-load a rewarded ad for next display.
  void _loadRewardedAd() {
    if (_isAdRemoved || _isAdLoading) return;

    _isAdLoading = true;
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isAdLoaded = true;
          _isAdLoading = false;
          _retryCount = 0;
          debugPrint('[AdService] Rewarded ad loaded.');
        },
        onAdFailedToLoad: (error) {
          _isAdLoaded = false;
          _isAdLoading = false;
          _retryCount++;
          debugPrint('[AdService] Rewarded ad failed to load: $error (retry $_retryCount/$_maxRetries)');
          if (_retryCount < _maxRetries) {
            // Exponential backoff: 30s, 60s, 120s, 240s, 480s
            final delay = Duration(seconds: 30 * (1 << (_retryCount - 1)));
            Future.delayed(delay, _loadRewardedAd);
          }
        },
      ),
    );
  }

  /// Show a rewarded ad and return true if the user earned their reward.
  /// If ads are removed via IAP, immediately returns true (free reward).
  Future<bool> showRewardedAd(String rewardType) async {
    // If user purchased ad removal, grant reward immediately
    if (_isAdRemoved) return true;

    // Check daily limit
    _resetDailyCountsIfNeeded();
    final remaining = getRemainingViews(rewardType);
    if (remaining <= 0) return false;

    if (!_isAdLoaded || _rewardedAd == null) {
      debugPrint('[AdService] Rewarded ad not loaded yet.');
      _loadRewardedAd();
      return false;
    }

    final ad = _rewardedAd!;
    _rewardedAd = null;
    _isAdLoaded = false;

    bool rewarded = false;
    final resultCompleter = Completer<bool>();

    void finish(bool value) {
      if (!resultCompleter.isCompleted) {
        resultCompleter.complete(value);
      }
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _retryCount = 0;
        _loadRewardedAd();
        finish(rewarded);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('[AdService] Rewarded ad failed to show: $error');
        ad.dispose();
        _loadRewardedAd();
        finish(false);
      },
    );

    await ad.show(
      onUserEarnedReward: (AdWithoutView adWithoutView, RewardItem reward) {
        rewarded = true;
        _dailyAdCounts[rewardType] = (_dailyAdCounts[rewardType] ?? 0) + 1;
        unawaited(_saveDailyCounts());
        debugPrint(
            '[AdService] User earned reward: ${reward.amount} ${reward.type}');
      },
    );

    return resultCompleter.future;
  }

  /// Dispose resources.
  void dispose() {
    _rewardedAd?.dispose();
  }
}


