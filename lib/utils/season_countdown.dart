class SeasonCountdown {
  const SeasonCountdown._(this.daysRemaining);

  const SeasonCountdown.active(int daysRemaining)
      : this._(daysRemaining < 0 ? 0 : daysRemaining);
  const SeasonCountdown.ended() : this._(null);

  final int? daysRemaining;

  bool get isEnded => daysRemaining == null;
  bool get isDday => daysRemaining == 0;
}

final DateTime kSoulDeckSeasonOneEndDate = DateTime(2027, 3, 31);

SeasonCountdown calculateSeasonCountdown({
  required DateTime now,
  required DateTime endDate,
}) {
  final today = DateTime(now.year, now.month, now.day);
  final endDay = DateTime(endDate.year, endDate.month, endDate.day);
  final days = endDay.difference(today).inDays;

  if (days < 0) {
    return const SeasonCountdown.ended();
  }

  return SeasonCountdown.active(days);
}
