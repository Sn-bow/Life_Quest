# Release Input Register - 2026-03-11

## Purpose

This document separates release settings into:

- values already safe to finalize locally
- values that must come from the user, store setup, Firebase, AdMob, or Apple/Google tooling

## Safe local cleanup already applied

- Android app label set to `Life Quest`
- iOS display name set to `Life Quest`
- Android debug APK build restored on macOS

## External values still required

### 1. Final Android package ID

Current:
- `com.example.life_quest_final_v2`

Used in:
- Android application ID
- Android namespace
- Firebase Android config
- Kotlin package path

Why user input is required:
- This must match the package name intended for Play Store release and Firebase registration.

Files impacted:
- `android/app/build.gradle.kts`
- `android/app/src/main/kotlin/com/example/life_quest_final_v2/...`
- `android/app/google-services.json`

### 2. Final iOS bundle ID

Current:
- `com.example.lifeQuestFinalV2`

Why user input is required:
- It must match Apple Developer and Firebase iOS registration.

Files impacted:
- `ios/Runner.xcodeproj/project.pbxproj`
- future `GoogleService-Info.plist`

### 3. iOS Firebase configuration

Missing:
- `ios/GoogleService-Info.plist`
- iOS entries in `lib/firebase_options.dart`

Why user input is required:
- Requires Firebase console access and `flutterfire configure`.

### 4. AdMob production IDs

Current state:
- Android App ID is Google test ID
- iOS App ID is Google test ID
- Rewarded ad unit ID is placeholder env default

Why user input is required:
- Real IDs must come from the actual AdMob account.

Files impacted:
- `android/app/src/main/AndroidManifest.xml`
- `ios/Runner/Info.plist`
- `lib/services/ad_service.dart`

### 5. Android signing credentials

Missing:
- actual keystore
- `android/key.properties`

Why user input is required:
- Signing credentials must be user-owned and kept private.

### 6. Home Widget App Group ID

Current placeholder:
- `group.com.example.lifeQuestWidget`

Why user input is required:
- Must match the final Apple App Group capability and widget setup.

Files impacted:
- `lib/main.dart`
- `ios/Runner/AppDelegate.swift`
- `ios/LifeQuestWidget/LifeQuestWidget.swift`

### 7. Full Xcode installation

Current blocker:
- Only Command Line Tools are active on this Mac

Why user input is required:
- Full Xcode install and selection is a machine-level prerequisite for iOS builds.

## Recommended order for these inputs

1. Install full Xcode
2. Decide final Android package ID and iOS bundle ID
3. Re-register or confirm Firebase apps with those identifiers
4. Run `flutterfire configure`
5. Create or provide Android signing credentials
6. Provide AdMob production IDs
7. Finalize Home Widget App Group ID

## Values intentionally not changed automatically

- Android package ID
- Android namespace
- Kotlin package directory
- iOS bundle ID
- Firebase config files
- AdMob production identifiers
- App Group identifier
- release version number

These remain untouched because changing them without the matching external console state would break Android, iOS, Firebase, widgets, or ads.
