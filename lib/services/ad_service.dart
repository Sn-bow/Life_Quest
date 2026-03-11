import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Singleton service for managing AdMob rewarded ads.
class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  // =========================================================
  // TODO: Replace these with your actual AdMob Ad Unit IDs!
  // These are Google's official TEST Ad Unit IDs for development.
  // =========================================================
  static const String _productionRewardedAdUnitId = String.fromEnvironment(
    'ADMOB_REWARDED_AD_UNIT_ID',
    defaultValue: 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY',
  );

  static const String _rewardedAdUnitId = kDebugMode
      ? 'ca-app-pub-3940256099942544/5224354917' // Test ID
      : _productionRewardedAdUnitId; // Production ID

  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;
  bool _isAdRemoved = false;

  // --- Daily limits ---
  final Map<String, int> _dailyAdCounts = {};
  String? _lastResetDate;

  static const Map<String, int> dailyLimits = {
    'ap_recovery': 3,
    'quest_double': 2,
    'combat_revive': 1,
  };

  /// Initialize the Mobile Ads SDK.
  Future<void> init() async {
    await MobileAds.instance.initialize();
    await _loadAdRemovalStatus();
    await _loadDailyCounts();
    _resetDailyCountsIfNeeded();
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

  void _resetDailyCountsIfNeeded() {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (_lastResetDate != today) {
      _dailyAdCounts.clear();
      _lastResetDate = today;
      _saveDailyCounts();
    }
  }

  /// Pre-load a rewarded ad for next display.
  void _loadRewardedAd() {
    if (_isAdRemoved) return;

    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isAdLoaded = true;
          debugPrint('[AdService] Rewarded ad loaded.');
        },
        onAdFailedToLoad: (error) {
          _isAdLoaded = false;
          debugPrint('[AdService] Rewarded ad failed to load: $error');
          // Retry after a delay
          Future.delayed(const Duration(seconds: 30), _loadRewardedAd);
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

    bool rewarded = false;

    await _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        rewarded = true;
        _dailyAdCounts[rewardType] = (_dailyAdCounts[rewardType] ?? 0) + 1;
        _saveDailyCounts();
        debugPrint(
            '[AdService] User earned reward: ${reward.amount} ${reward.type}');
      },
    );

    _rewardedAd = null;
    _isAdLoaded = false;
    _loadRewardedAd(); // Pre-load next ad

    return rewarded;
  }

  /// Dispose resources.
  void dispose() {
    _rewardedAd?.dispose();
  }
}


