import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/state/character_state.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // Timer settings
  int _focusMinutes = 25;
  final int _breakMinutes = 5;
  int _remainingSeconds = 25 * 60;
  bool _isRunning = false;
  bool _isFocusPhase = true;
  int _completedSessions = 0;
  Timer? _timer;
  DateTime? _backgroundTimestamp;

  // Rewards
  static const int _xpPerSession = 30;
  static const int _goldPerSession = 15;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (_isRunning) {
        _backgroundTimestamp = DateTime.now();
        _timer?.cancel();
      }
    } else if (state == AppLifecycleState.resumed) {
      if (_backgroundTimestamp != null && _isRunning) {
        final elapsed = DateTime.now().difference(_backgroundTimestamp!).inSeconds;
        _backgroundTimestamp = null;
        setState(() {
          _remainingSeconds = (_remainingSeconds - elapsed).clamp(0, _remainingSeconds);
          if (_remainingSeconds <= 0) {
            _isRunning = false;
            if (_isFocusPhase) {
              _onFocusComplete();
            } else {
              _onBreakComplete();
            }
          } else {
            _startTimer();
          }
        });
      }
    }
  }

  void _startTimer() {
    if (_isRunning) return;
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          _isRunning = false;
          if (_isFocusPhase) {
            _onFocusComplete();
          } else {
            _onBreakComplete();
          }
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isFocusPhase = true;
      _remainingSeconds = _focusMinutes * 60;
    });
  }

  void _onFocusComplete() {
    _completedSessions++;
    // Give rewards
    final charState = context.read<CharacterState>();
    charState.addTimerReward(_xpPerSession, _goldPerSession);

    // Show completion dialog
    _showRewardDialog();

    // Switch to break
    setState(() {
      _isFocusPhase = false;
      _remainingSeconds = _breakMinutes * 60;
    });
  }

  void _onBreakComplete() {
    setState(() {
      _isFocusPhase = true;
      _remainingSeconds = _focusMinutes * 60;
    });
  }

  void _showRewardDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        final l10nCtx = AppLocalizations.of(ctx)!;
        return AlertDialog(
          title: Text(l10nCtx.timerFocusCompleteTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10nCtx.timerFocusCompleteBody(_focusMinutes),
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome, size: 16, color: Colors.blue.shade300),
                  const SizedBox(width: 4),
                  const Text('XP +', style: TextStyle(fontSize: 14)),
                  const Text('30',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber)),
                  const SizedBox(width: 16),
                  const Icon(Icons.monetization_on,
                      size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(l10nCtx.timerGoldRewardLabel,
                      style: const TextStyle(fontSize: 14)),
                  const Text('15',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber)),
                ],
              ),
              const SizedBox(height: 8),
              Text(l10nCtx.timerTodaySessions(_completedSessions),
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _startTimer();
              },
              child: Text(l10nCtx.timerStartBreak),
            ),
          ],
        );
      },
    );
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final progress = _isFocusPhase
        ? 1.0 - (_remainingSeconds / (_focusMinutes * 60))
        : 1.0 - (_remainingSeconds / (_breakMinutes * 60));
    final accentColor =
        _isFocusPhase ? const Color(0xFFFF6B6B) : const Color(0xFF51CF66);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isFocusPhase ? l10n.timerScreenFocus : l10n.timerScreenBreak),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Phase indicator
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: accentColor, width: 1.5),
                  ),
                  child: Text(
                    _isFocusPhase ? l10n.timerFocusMode : l10n.timerBreakMode,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Circular timer
                SizedBox(
                  width: 240,
                  height: 240,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 240,
                        height: 240,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 8,
                          backgroundColor:
                              isDark ? Colors.white10 : Colors.grey.shade200,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(accentColor),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _formatTime(_remainingSeconds),
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 52,
                              fontWeight: FontWeight.bold,
                              color:
                                  isDark ? Colors.white : Colors.grey.shade800,
                            ),
                          ),
                          Text(
                            l10n.timerSessionCount(_completedSessions),
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 13,
                              color: isDark
                                  ? Colors.white54
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                // Control buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Reset
                    _circleButton(
                      icon: Icons.refresh,
                      color: Colors.grey,
                      isDark: isDark,
                      onTap: _resetTimer,
                    ),
                    const SizedBox(width: 24),
                    // Play/Pause
                    _circleButton(
                      icon: _isRunning ? Icons.pause : Icons.play_arrow,
                      color: accentColor,
                      isDark: isDark,
                      size: 72,
                      iconSize: 36,
                      onTap: _isRunning ? _pauseTimer : _startTimer,
                    ),
                    const SizedBox(width: 24),
                    // Skip
                    _circleButton(
                      icon: Icons.skip_next,
                      color: Colors.grey,
                      isDark: isDark,
                      onTap: () {
                        _timer?.cancel();
                        setState(() {
                          _isRunning = false;
                          if (_isFocusPhase) {
                            _isFocusPhase = false;
                            _remainingSeconds = _breakMinutes * 60;
                          } else {
                            _isFocusPhase = true;
                            _remainingSeconds = _focusMinutes * 60;
                          }
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Duration settings
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.grey.shade200,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _durationChip('15분', 15, isDark),
                      _durationChip('25분', 25, isDark),
                      _durationChip('45분', 45, isDark),
                      _durationChip('60분', 60, isDark),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Reward preview
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: isDark ? 0.1 : 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: Colors.amber.withValues(alpha: 0.3), width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(l10n.timerFocusRewardLabel,
                          style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.white54
                                  : Colors.grey.shade600)),
                      Row(
                        children: [
                          Icon(Icons.auto_awesome,
                              size: 14, color: Colors.blue.shade300),
                          const SizedBox(width: 4),
                          const Text('XP +30',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber)),
                          const SizedBox(width: 12),
                          const Icon(Icons.monetization_on,
                              size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text('${l10n.timerGoldRewardLabel}15',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required Color color,
    required bool isDark,
    double size = 52,
    double iconSize = 26,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: isDark ? 0.2 : 0.1),
          border: Border.all(color: color, width: 2),
        ),
        child: Icon(icon, size: iconSize, color: color),
      ),
    );
  }

  Widget _durationChip(String label, int minutes, bool isDark) {
    final isSelected = _focusMinutes == minutes && !_isRunning;
    return GestureDetector(
      onTap: _isRunning
          ? null
          : () {
              setState(() {
                _focusMinutes = minutes;
                if (_isFocusPhase) {
                  _remainingSeconds = minutes * 60;
                }
              });
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFF6B6B).withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF6B6B) : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? const Color(0xFFFF6B6B)
                : (isDark ? Colors.white54 : Colors.grey.shade600),
          ),
        ),
      ),
    );
  }
}
