# Life Quest Android Vitals Timer Audit - 2026-05-20

Scope: default Android release build.

## Source

- Android vitals: https://developer.android.com/topic/performance/vitals
- Excessive partial wake locks: https://developer.android.com/topic/performance/vitals/wakelock

As checked on 2026-05-20, Android vitals treats excessive partial wake locks as a core vital that can affect Google Play visibility. The current official threshold is based on non-exempted partial wake locks totaling 2 or more hours in a 24-hour period, counted while the app is backgrounded or running a foreground service.

## Repository Evidence

Commands used:

```powershell
rg -n "WAKE_LOCK|wakelock|WakeLock|PARTIAL_WAKE_LOCK|keepScreenOn|FLAG_KEEP_SCREEN_ON|stayAwake|Timer\.periodic|WidgetsBindingObserver|AppLifecycleState" lib android pubspec.yaml
```

Findings:

- `android/app/src/main/AndroidManifest.xml` does not declare `android.permission.WAKE_LOCK`.
- No app code references `PARTIAL_WAKE_LOCK`, `PowerManager.WakeLock`, `keepScreenOn`, or `FLAG_KEEP_SCREEN_ON`.
- `lib/services/sound_service.dart` sets both SFX and BGM Android audio contexts to `stayAwake: false`.
- `lib/screens/timer_screen.dart` uses a foreground `Timer.periodic`, cancels the timer when the app is paused, stores a timestamp, and subtracts elapsed time on resume.
- The timer does not start a foreground service and does not schedule wakeup alarms.

## Decision

The default focus timer does not require a persistent wake lock. This satisfies the code-audit portion of release issue M-03.

## Remaining Release QA

The following still requires a usable Android device or emulator:

- Start a focus timer.
- Background the app.
- Wait at least 60 seconds.
- Return to the app and confirm elapsed time is deducted once.
- Stop/reset the timer.
- Confirm no crash, ANR, duplicate reward, or stuck dialog.

Current device blocker: `adb devices` reported physical device `520034bafe9225db` as `unauthorized` on 2026-05-20.
