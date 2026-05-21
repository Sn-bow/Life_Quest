enum FocusTimerPhase { focus, breakTime }

enum FocusTimerCompletion { none, focus, breakTime }

class FocusTimerController {
  FocusTimerController({
    int focusMinutes = 25,
    int breakMinutes = 5,
  })  : _focusMinutes = focusMinutes,
        _breakMinutes = breakMinutes,
        _remainingSeconds = focusMinutes * 60;

  int _focusMinutes;
  final int _breakMinutes;
  int _remainingSeconds;
  bool _isRunning = false;
  FocusTimerPhase _phase = FocusTimerPhase.focus;
  int _completedSessions = 0;
  DateTime? _backgroundTimestamp;

  int get focusMinutes => _focusMinutes;
  int get breakMinutes => _breakMinutes;
  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;
  bool get isFocusPhase => _phase == FocusTimerPhase.focus;
  int get completedSessions => _completedSessions;

  double get progress {
    final totalSeconds = isFocusPhase ? _focusMinutes * 60 : _breakMinutes * 60;
    if (totalSeconds <= 0) return 1;
    return 1.0 - (_remainingSeconds / totalSeconds);
  }

  void start() {
    if (_isRunning) return;
    _isRunning = true;
  }

  void pause() {
    _isRunning = false;
    _backgroundTimestamp = null;
  }

  void reset() {
    _isRunning = false;
    _phase = FocusTimerPhase.focus;
    _remainingSeconds = _focusMinutes * 60;
    _backgroundTimestamp = null;
  }

  void setFocusMinutes(int minutes) {
    if (_isRunning) return;
    _focusMinutes = minutes;
    if (isFocusPhase) {
      _remainingSeconds = minutes * 60;
    }
  }

  FocusTimerCompletion tick({int seconds = 1}) {
    if (!_isRunning || seconds <= 0) return FocusTimerCompletion.none;
    return _advance(seconds);
  }

  bool pauseForBackground(DateTime now) {
    if (!_isRunning) return false;
    _backgroundTimestamp = now;
    return true;
  }

  FocusTimerCompletion resumeFromBackground(DateTime now) {
    final backgroundTimestamp = _backgroundTimestamp;
    if (backgroundTimestamp == null || !_isRunning) {
      _backgroundTimestamp = null;
      return FocusTimerCompletion.none;
    }

    _backgroundTimestamp = null;
    final elapsedSeconds = now.difference(backgroundTimestamp).inSeconds;
    return _advance(elapsedSeconds);
  }

  FocusTimerCompletion skipPhase() {
    _backgroundTimestamp = null;
    _isRunning = false;
    if (isFocusPhase) {
      _phase = FocusTimerPhase.breakTime;
      _remainingSeconds = _breakMinutes * 60;
    } else {
      _phase = FocusTimerPhase.focus;
      _remainingSeconds = _focusMinutes * 60;
    }
    return FocusTimerCompletion.none;
  }

  FocusTimerCompletion _advance(int elapsedSeconds) {
    if (elapsedSeconds <= 0) return FocusTimerCompletion.none;
    _remainingSeconds =
        (_remainingSeconds - elapsedSeconds).clamp(0, _remainingSeconds);

    if (_remainingSeconds > 0) return FocusTimerCompletion.none;

    _isRunning = false;
    return _completeCurrentPhase();
  }

  FocusTimerCompletion _completeCurrentPhase() {
    if (isFocusPhase) {
      _completedSessions++;
      _phase = FocusTimerPhase.breakTime;
      _remainingSeconds = _breakMinutes * 60;
      return FocusTimerCompletion.focus;
    }

    _phase = FocusTimerPhase.focus;
    _remainingSeconds = _focusMinutes * 60;
    return FocusTimerCompletion.breakTime;
  }
}
