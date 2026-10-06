/// Wall-clock timer; returning from background never creates extra rewards.
class MissionFocusClock {
  final int durationSeconds;
  int remainingAtPause;
  DateTime? deadline;
  MissionFocusClock(int seconds)
    : durationSeconds = seconds.clamp(60, 900),
      remainingAtPause = seconds.clamp(60, 900);
  bool get running => deadline != null;
  int remaining(DateTime now) => deadline == null
      ? remainingAtPause
      : ((deadline!.difference(now).inMilliseconds / 1000).ceil()).clamp(
          0,
          durationSeconds,
        );
  void start(DateTime now) {
    if (running || remainingAtPause == 0) return;
    deadline = now.add(Duration(seconds: remainingAtPause));
  }

  void pause(DateTime now) {
    remainingAtPause = remaining(now);
    deadline = null;
  }

  void reset() {
    deadline = null;
    remainingAtPause = durationSeconds;
  }

  Map<String, dynamic> toJson() => {
    'duration': durationSeconds,
    'remaining': remainingAtPause,
    'deadline': deadline?.toIso8601String(),
  };
  factory MissionFocusClock.fromJson(Map<String, dynamic> json, int seconds) {
    final clock = MissionFocusClock(seconds);
    if (json['duration'] != clock.durationSeconds) return clock;
    if (json['remaining'] is int) {
      clock.remainingAtPause = (json['remaining'] as int).clamp(
        0,
        clock.durationSeconds,
      );
    }
    if (json['deadline'] is String) {
      clock.deadline = DateTime.tryParse(json['deadline']);
    }
    return clock;
  }
}
