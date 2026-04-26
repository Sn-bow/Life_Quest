/// SharedPreferences 키 상수 모음.
/// 키 문자열을 한 곳에서 관리하여 오타/타입 불일치 방지.
abstract final class SharedPrefKeys {
  // AdService
  static const String adRemoved = 'ad_removed';
  static const String adLastResetDate = 'ad_last_reset_date';
  static const String adLastServerMs = 'ad_last_server_ms';
  static const String adCountPrefix = 'ad_count_'; // + adType key

  // SoundService
  static const String soundMuted = 'sound_muted';
}
