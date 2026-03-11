# Session Handoff - 2026-03-07

## Current State

- This workspace is not a Git repository, so there is no commit-based checkpoint.
- The current source state is already saved on disk in this workspace.
- A written checkpoint is stored in this file so the next session can resume without re-discovery.

## What Was Completed

- Investigated and fixed multiple app logic issues in login/bootstrap, quest reset timing, report values, AP save timing, custom reward persistence, loot box rarity handling, and Android manifest structure.
- Added release blocker notes and build-time configuration hooks for AdMob and Home Widget app group values.
- Removed undeclared `NotoSansKR` theme usage.
- Generated new branding assets for app icon and splash visuals.
- Updated Android and iOS asset files under native resource directories.

## Branding Asset Sources

- Main icon source: `assets/images/app_icon.png`
- Compat icon source: `assets/images/icon.png`
- Splash logo (light): `assets/images/splash_logo.png`
- Splash logo (dark): `assets/images/splash_logo_dark.png`
- Splash background (light): `assets/images/splash_background_light.png`
- Splash background (dark): `assets/images/splash_background_dark.png`

## Android Verification Status

- Android emulator install/run was not stable through `flutter run`.
- `flutter run` kept hanging and Gradle build invocation behaved abnormally in this environment.
- As a workaround, the debug APK was manually reinstalled with `adb`.
- A second manual APK patch confirmed that the launcher icon resource can be updated in the packaged APK.
- The launcher icon is confirmed changed on the emulator home screen.
- The app launches and reaches the login screen normally.

## Remaining Android Issue

- Android 12+ startup still shows the system-style splash layout instead of the full intended custom splash composition.
- The `values-v31` splash theme needs to be packaged through a normal build path, not only by manual APK patching.
- The current Gradle/Flutter Android build path appears to start and then exit before task execution is visible in logs.

## Important Files To Continue From

- `android/app/src/main/res/values-v31/styles.xml`
- `android/app/src/main/res/values-night-v31/styles.xml`
- `android/app/src/main/AndroidManifest.xml`
- `pubspec.yaml`
- `scripts/generate_brand_assets.ps1`
- `lib/main.dart`
- `lib/state/character_state.dart`

## Reference Images Captured During Verification

- `tmp_emulator_home_after_patch2.png`
- `tmp_emulator_patch2_035.png`
- `tmp_emulator_patch2_2s.png`
- `tmp_emulator_patch2_5s.png`
- `tmp_emulator_screen.png`

## Resume Plan

1. Re-check Android build pipeline so `gradlew` or `flutter build apk --debug` produces a fresh APK from source.
2. Package `values-v31` and `values-night-v31` splash theme changes through a normal build.
3. Reinstall from the newly built APK.
4. Verify three things separately:
   - home launcher icon
   - Android 12+ startup splash
   - post-splash login screen
5. If the system splash still appears, inspect whether Flutter embedding, theme inheritance, or generated splash resources are overriding the v31 theme.

## Practical Note For Next Session

- Start by opening this file and continue from the Android build/splash packaging issue.
- Do not assume the current emulator visuals match the latest source without rebuilding or repackaging the APK.
