import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/controllers/focus_timer_controller.dart';

void main() {
  group('FocusTimerController', () {
    test('completes a focus session exactly when remaining time elapses', () {
      final controller = FocusTimerController(focusMinutes: 1);

      controller.start();
      final completion = controller.tick(seconds: 60);

      expect(completion, FocusTimerCompletion.focus);
      expect(controller.completedSessions, 1);
      expect(controller.isRunning, isFalse);
      expect(controller.isFocusPhase, isFalse);
      expect(controller.remainingSeconds, 5 * 60);
    });

    test('reconciles background elapsed time and keeps timer running', () {
      final controller = FocusTimerController(focusMinutes: 25);
      final backgroundedAt = DateTime(2026, 5, 21, 8);

      controller.start();
      expect(controller.pauseForBackground(backgroundedAt), isTrue);

      final completion = controller.resumeFromBackground(
        backgroundedAt.add(const Duration(minutes: 7, seconds: 30)),
      );

      expect(completion, FocusTimerCompletion.none);
      expect(controller.isRunning, isTrue);
      expect(controller.isFocusPhase, isTrue);
      expect(controller.remainingSeconds, 17 * 60 + 30);
    });

    test('completes focus session while app is backgrounded', () {
      final controller = FocusTimerController(focusMinutes: 25);
      final backgroundedAt = DateTime(2026, 5, 21, 8);

      controller.start();
      controller.pauseForBackground(backgroundedAt);

      final completion = controller.resumeFromBackground(
        backgroundedAt.add(const Duration(minutes: 26)),
      );

      expect(completion, FocusTimerCompletion.focus);
      expect(controller.completedSessions, 1);
      expect(controller.isRunning, isFalse);
      expect(controller.isFocusPhase, isFalse);
      expect(controller.remainingSeconds, 5 * 60);
    });

    test('pause stops foreground timer without completing or advancing later',
        () {
      final controller = FocusTimerController(focusMinutes: 25);
      final now = DateTime(2026, 5, 21, 8);

      controller.start();
      controller.tick(seconds: 120);
      controller.pause();

      final completion =
          controller.resumeFromBackground(now.add(const Duration(hours: 1)));

      expect(completion, FocusTimerCompletion.none);
      expect(controller.isRunning, isFalse);
      expect(controller.completedSessions, 0);
      expect(controller.remainingSeconds, 23 * 60);
    });
  });
}
