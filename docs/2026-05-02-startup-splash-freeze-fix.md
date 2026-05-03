# 2026-05-02 Android Startup Splash Freeze Fix

## Summary

Android device: SM A530N, Android 9 (API 28)

Symptom:

- App installed successfully.
- App process stayed alive.
- No `FATAL EXCEPTION` appeared in logcat.
- The screen stayed on the native Android launch/splash image and never reached Flutter UI.

Final result:

- The app now launches past the native splash screen and reaches the Life Quest login screen.
- `flutter analyze` passes.
- `flutter test` passes: 76 tests.
- Release APK builds and installs on the connected SM A530N.

## Root Cause

`lib/main.dart` awaited several non-critical service initializers before calling `runApp()`:

- `NotificationService().init()`
- `SoundService().init()`
- `AdService().init()`
- `PurchaseService().init()`
- `HomeWidget.setAppGroupId(...)`

Because Android keeps showing the native launch theme until Flutter draws its first frame, any long-running or stuck initialization before `runApp()` makes the app look like it cannot start.

The likely trigger during this incident was Play/Billing/Ads related startup work. Device logcat contained many Google Play / Google auth `BadAuthentication` messages, while the app itself did not crash. Even when those services eventually recover, they must not block the first Flutter frame.

## Fix

Changed `lib/main.dart` so startup does only the required app bootstrap before `runApp()`:

1. `WidgetsFlutterBinding.ensureInitialized()`
2. `Firebase.initializeApp(...)`
3. Crashlytics error hook setup
4. Firestore settings
5. Firebase App Check activation, with catch
6. `runApp(...)`

Then optional services are initialized in the background:

- `_initializeOptionalServices()` runs via `unawaited(...)`.
- Each optional startup task runs through `_runStartupTask(...)`.
- Each task has a timeout.
- Failures are logged with `debugPrint(...)` and recorded to Crashlytics as non-fatal.

This keeps login/onboarding reachable even if ads, billing, notification, sound, or widget setup is slow or unavailable.

## Verification Commands

Run these from the repository root:

```powershell
C:\dev\flutter\bin\flutter.bat analyze
C:\dev\flutter\bin\flutter.bat test
C:\dev\flutter\bin\flutter.bat build apk --release
```

Install on the connected Android device:

```powershell
C:\Users\wjd54\AppData\Local\Android\Sdk\platform-tools\adb.exe -s 520034bafe9225db install -r build\app\outputs\flutter-apk\app-release.apk
```

Clear logs, launch, and check the process:

```powershell
C:\Users\wjd54\AppData\Local\Android\Sdk\platform-tools\adb.exe -s 520034bafe9225db logcat -c
C:\Users\wjd54\AppData\Local\Android\Sdk\platform-tools\adb.exe -s 520034bafe9225db shell am force-stop com.lifequest.app
C:\Users\wjd54\AppData\Local\Android\Sdk\platform-tools\adb.exe -s 520034bafe9225db shell monkey -p com.lifequest.app -c android.intent.category.LAUNCHER 1
C:\Users\wjd54\AppData\Local\Android\Sdk\platform-tools\adb.exe -s 520034bafe9225db shell pidof com.lifequest.app
```

Check for critical runtime errors:

```powershell
C:\Users\wjd54\AppData\Local\Android\Sdk\platform-tools\adb.exe -s 520034bafe9225db logcat -d -t 500 |
  Select-String -Pattern "AndroidRuntime|FATAL EXCEPTION|Unable to load asset|MissingPluginException| E flutter| E AndroidRuntime"
```

Expected result:

- No fatal app crash lines.
- No Flutter asset loading failure.
- App reaches the login screen.

## Local Tooling Note

In the Codex sandbox, Flutter commands may hang or fail because `C:\dev\flutter` is owned by the host user, not the sandbox user.

Observed errors:

- `Flutter failed to open a file at "C:\dev\flutter\bin\cache\lockfile"`
- `fatal: detected dubious ownership in repository at 'C:/dev/flutter'`

When that happens, run Flutter/Dart commands with elevated host-user execution rather than treating it as an app build failure.

## Important Distinction

The Google Play / Google auth `BadAuthentication` log lines are device/account environment issues, not the Flutter app crash. The app must tolerate them by not blocking startup on billing or ads initialization.

