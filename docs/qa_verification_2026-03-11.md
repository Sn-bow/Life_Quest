# QA Verification Summary - 2026-03-11

## Completed checks

- `flutter analyze` passed
- `flutter test` passed
- `flutter build apk --debug` passed
- `flutter build apk --release` passed
- `flutter build appbundle --release` passed

## Built artifacts

- `build/app/outputs/flutter-apk/app-debug.apk`
- `build/app/outputs/flutter-apk/app-release.apk`
- `build/app/outputs/bundle/release/app-release.aab`

## Android status

- Android build pipeline is now reproducible on macOS.
- Windows-generated path contamination was removed by cleaning and regenerating Flutter build state.
- `minSdk` is now 23 because the current `google_mobile_ads` path requires it.
- Android 12 custom splash was intentionally deferred to restore build stability first.

## Test status

- Existing model and state tests passed.
- The accidental default `test/widget_test.dart` introduced by `flutter create` was removed because it referenced a nonexistent `MyApp` sample app.

## iOS status

- Xcode 26.3 is installed and selected.
- CocoaPods 1.16.2 is installed and usable.
- The `iOS 26.2` SDK/runtime is installed and visible to `xcodebuild`.
- `Podfile` was updated to force pod targets to `IPHONEOS_DEPLOYMENT_TARGET = 14.0`.
- `ios/Flutter/Profile.xcconfig` was added so the Pods profile configuration can be included.
- `pod install` completes successfully after the iOS config fixes.
- `flutter build ios --no-codesign` still does not complete cleanly in this environment; the build reaches the Xcode phase and remains the active blocker for local iOS verification.
- iOS Firebase is still incomplete: `ios/GoogleService-Info.plist` is missing and `lib/firebase_options.dart` still throws for `TargetPlatform.iOS`.

## Smoke-test status

- Android emulator `emulator-5554` was detected and used for install-and-launch testing.
- `build/app/outputs/flutter-apk/app-debug.apk` installed successfully with `adb install -r`.
- `com.example.life_quest_final_v2/.MainActivity` launched successfully and the process remained alive.
- Login smoke test succeeded with the supplied test account.
- Post-login UI verification confirmed entry into the main in-app status screen rather than the login view.
- Launcher icon was rechecked directly on the emulator home screen after the branding refresh.
- Cold-start verification rechecked the branded login entry screen after the splash/login refresh.
- Rewarded-ad UX was tightened so all remaining ad flows now have explicit failure feedback:
  - `quest_double`: falls back to base reward with a snackbar
  - `ap_recovery`: now shows a retry snackbar when the ad fails to load
  - `combat_revive`: now shows success and failure snackbars

## Ad-only monetization status

- Purchase-oriented settings UI was removed from the main settings surface.
- Cosmetic shop purchases were converted into a showcase-only flow with `준비 중` messaging.
- Detailed stat viewing is now free and no longer gated behind rewarded ads.
- Store purchase initialization was removed from app startup so the current Android runtime aligns with the ad-only rollout.
- Report messaging was softened from `프리미엄 기능` to a future-facing expansion note.
- A debug-only QA panel was added to Settings so rewarded-ad flows can be triggered directly on emulator builds without depending on unstable quest/combat touch automation.
- Active rewarded-ad surfaces are now limited to:
  - `quest_double`
  - `ap_recovery`
  - `combat_revive`

## Remaining Android verification gap

- Direct emulator evidence was captured for rewarded-ad runtime behavior:
  - `quest_double`: `AdService` logged `User earned reward`
  - rewarded ad fullscreen activity (`com.google.android.gms.ads.AdActivity`) was observed directly on emulator
  - ad UI capture showed `Reward granted`
- Because emulator touch routing remained inconsistent across several in-app surfaces, the QA panel became the stable verification path for runtime ad execution.

## Residual blockers

1. Install the `iOS 26.2` platform runtime in Xcode and rerun iOS build verification
2. Resolve the remaining local iOS Xcode build hang/failure path and confirm a successful `flutter build ios --no-codesign`
3. iOS Firebase setup and `GoogleService-Info.plist`
4. Production package IDs, AdMob IDs, signing credentials, and App Group values
5. Android 12 custom splash reintroduction through a verified compatible implementation
