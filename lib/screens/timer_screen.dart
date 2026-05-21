import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:life_quest_final_v2/controllers/focus_timer_controller.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/state/character_state.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final FocusTimerController _controller = FocusTimerController();
  Timer? _timer;

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
      if (_controller.pauseForBackground(DateTime.now())) {
        _timer?.cancel();
      }
    } else if (state == AppLifecycleState.resumed) {
      final completion = _controller.resumeFromBackground(DateTime.now());
      if (completion != FocusTimerCompletion.none) {
        setState(() {});
        _handleCompletion(completion);
      } else if (_controller.isRunning) {
        setState(() {
          _startTicker();
        });
      }
    }
  }

  void _startTimer() {
    if (_controller.isRunning) return;
    setState(() {
      _controller.start();
      _startTicker();
    });
  }

  void _startTicker() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final completion = _controller.tick();
      setState(() {
        if (completion != FocusTimerCompletion.none) {
          _timer?.cancel();
        }
      });
      if (completion != FocusTimerCompletion.none) {
        _handleCompletion(completion);
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(_controller.pause);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(_controller.reset);
  }

  void _handleCompletion(FocusTimerCompletion completion) {
    if (completion == FocusTimerCompletion.focus) {
      _onFocusComplete();
    } else if (completion == FocusTimerCompletion.breakTime) {
      _onBreakComplete();
    }
  }

  void _onFocusComplete() {
    // Give rewards
    final charState = context.read<CharacterState>();
    charState.addTimerReward(_xpPerSession, _goldPerSession);

    // Show completion dialog
    _showRewardDialog();
  }

  void _onBreakComplete() {}

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
              Text(l10nCtx.timerFocusCompleteBody(_controller.focusMinutes),
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome,
                      size: 16, color: Colors.blue.shade300),
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
              Text(l10nCtx.timerTodaySessions(_controller.completedSessions),
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
    final progress = _controller.progress;
    final accentColor = _controller.isFocusPhase
        ? const Color(0xFFFF6B6B)
        : const Color(0xFF51CF66);

    return Scaffold(
      appBar: AppBar(
        title: Text(_controller.isFocusPhase
            ? l10n.timerScreenFocus
            : l10n.timerScreenBreak),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 640;
            final timerSize = compact ? 220.0 : 240.0;
            final timerFontSize = compact ? 48.0 : 52.0;
            final modeTimerGap = compact ? 28.0 : 40.0;
            final timerControlsGap = compact ? 34.0 : 48.0;
            final controlButtonGap = compact ? 20.0 : 24.0;
            final controlsDurationGap = compact ? 28.0 : 40.0;
            final durationPadding = compact ? 12.0 : 16.0;
            final rewardGap = compact ? 12.0 : 16.0;
            final rewardPadding = compact ? 10.0 : 12.0;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Phase indicator
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: accentColor, width: 1.5),
                        ),
                        child: Text(
                          _controller.isFocusPhase
                              ? l10n.timerFocusMode
                              : l10n.timerBreakMode,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                          ),
                        ),
                      ),
                      SizedBox(height: modeTimerGap),

                      // Circular timer
                      SizedBox(
                        width: timerSize,
                        height: timerSize,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: timerSize,
                              height: timerSize,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: compact ? 7 : 8,
                                backgroundColor: isDark
                                    ? Colors.white10
                                    : Colors.grey.shade200,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(accentColor),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _formatTime(_controller.remainingSeconds),
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: timerFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.grey.shade800,
                                  ),
                                ),
                                Text(
                                  l10n.timerSessionCount(
                                      _controller.completedSessions),
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
                      SizedBox(height: timerControlsGap),

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
                          SizedBox(width: controlButtonGap),
                          // Play/Pause
                          _circleButton(
                            icon: _controller.isRunning
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: accentColor,
                            isDark: isDark,
                            size: 72,
                            iconSize: 36,
                            onTap: _controller.isRunning
                                ? _pauseTimer
                                : _startTimer,
                          ),
                          SizedBox(width: controlButtonGap),
                          // Skip
                          _circleButton(
                            icon: Icons.skip_next,
                            color: Colors.grey,
                            isDark: isDark,
                            onTap: () {
                              _timer?.cancel();
                              setState(() {
                                _controller.skipPhase();
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: controlsDurationGap),

                      // Duration settings
                      Container(
                        padding: EdgeInsets.all(durationPadding),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isDark ? Colors.white12 : Colors.grey.shade200,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _durationChip(l10n.timerDuration15, 15, isDark),
                            _durationChip(l10n.timerDuration25, 25, isDark),
                            _durationChip(l10n.timerDuration45, 45, isDark),
                            _durationChip(l10n.timerDuration60, 60, isDark),
                          ],
                        ),
                      ),
                      SizedBox(height: rewardGap),

                      // Reward preview
                      Container(
                        padding: EdgeInsets.all(rewardPadding),
                        decoration: BoxDecoration(
                          color: Colors.amber
                              .withValues(alpha: isDark ? 0.1 : 0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Colors.amber.withValues(alpha: 0.3),
                              width: 1),
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
            );
          },
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
    final isSelected =
        _controller.focusMinutes == minutes && !_controller.isRunning;
    return GestureDetector(
      onTap: _controller.isRunning
          ? null
          : () {
              setState(() {
                _controller.setFocusMinutes(minutes);
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
