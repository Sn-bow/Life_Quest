import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/utils/season_countdown.dart';

void main() {
  group('calculateSeasonCountdown', () {
    test('uses calendar days rather than time-of-day fractions', () {
      final countdown = calculateSeasonCountdown(
        now: DateTime(2027, 3, 30, 23, 59),
        endDate: DateTime(2027, 3, 31),
      );

      expect(countdown.isEnded, isFalse);
      expect(countdown.isDday, isFalse);
      expect(countdown.daysRemaining, 1);
    });

    test('returns D-Day on the season end date', () {
      final countdown = calculateSeasonCountdown(
        now: DateTime(2027, 3, 31, 12),
        endDate: DateTime(2027, 3, 31),
      );

      expect(countdown.isEnded, isFalse);
      expect(countdown.isDday, isTrue);
      expect(countdown.daysRemaining, 0);
    });

    test('returns ended after the season end date', () {
      final countdown = calculateSeasonCountdown(
        now: DateTime(2027, 4, 1),
        endDate: DateTime(2027, 3, 31),
      );

      expect(countdown.isEnded, isTrue);
      expect(countdown.daysRemaining, isNull);
    });
  });
}
