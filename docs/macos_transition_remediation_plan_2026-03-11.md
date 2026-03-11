# macOS Transition Remediation Plan - 2026-03-11

## Purpose

This document summarizes the current project status after moving from a Windows-based development environment to macOS, identifies the main gaps, and defines a concrete execution plan to restore a stable development and release workflow.

## Current Assessment

### 1. Repository and continuity state

- The workspace is not a Git repository.
- Progress continuity currently depends on local files and handoff notes, not commit history.
- The main previous handoff is documented in `docs/session_handoff_2026-03-07.md`.

### 2. Environment portability state

- The previous active environment was Windows.
- The current machine is macOS.
- `android/local.properties` still contains Windows SDK paths.
- Asset automation scripts under `scripts/` are PowerShell-only and are not first-class macOS workflows.

### 3. Build and validation state

- `flutter analyze` currently fails before analysis starts.
- `flutter test` currently fails before tests start.
- The immediate blocker is dependency resolution:
  - `google_mobile_ads ^7.0.0` requires Dart `>=3.9.0`
  - the current local Dart version is `3.8.1`
- Because dependency resolution fails, the previously reported validation state from the older environment cannot be trusted on this Mac until re-verified.

### 4. Platform readiness state

#### Android

- Android Firebase config file exists: `android/app/google-services.json`
- Android release signing is only template-ready:
  - `android/key.properties.example` exists
  - actual `android/key.properties` is missing
- Android 12+ splash behavior is still unresolved per the prior handoff.
- Android package/application ID is still placeholder-level:
  - `com.example.life_quest_final_v2`

#### iOS

- iOS Firebase is not configured.
- `lib/firebase_options.dart` throws for iOS.
- `ios/GoogleService-Info.plist` is missing.
- iOS AdMob App ID is still the Google test ID.
- iOS app display naming is still intermediate rather than final branding.

### 5. Release readiness state

- AdMob production IDs are not applied.
- App version is still `1.0.0+1`.
- Android and iOS app identifiers still need final production values.
- No current evidence of a full release build validated on this Mac.

## Main Gaps

### Critical gaps

1. Local Flutter/Dart toolchain does not match project dependency requirements.
2. macOS machine-specific Android configuration has not been regenerated.
3. iOS Firebase configuration is incomplete.
4. Android splash issue remains unresolved.
5. No current reproducible validation pass on the present machine.

### Important gaps

1. Production AdMob IDs are not configured.
2. Release signing is not fully configured.
3. Package identifiers and app naming are not finalized.
4. Asset generation workflow is Windows-biased.
5. No Git history for safe rollback or progress tracking.

## Remediation Strategy

Work should proceed in phases. Do not start release packaging until Phase 1 and Phase 2 are complete.

## Phase 1. Restore a working macOS development baseline

### Objective

Make the project analyzable, testable, and buildable on this Mac.

### Tasks

1. Align Flutter/Dart with the dependency graph.
   - Preferred path: upgrade local Flutter SDK to a version that ships with Dart `>=3.9.0`.
   - Fallback path: downgrade `google_mobile_ads` only if SDK upgrade is not acceptable.

2. Regenerate machine-local Android configuration.
   - Replace Windows values in `android/local.properties` with macOS-generated values.
   - Confirm Android SDK path and Flutter SDK path resolve correctly.

3. Refresh package resolution.
   - Run `flutter pub get`.
   - Confirm lockfile and generated config are consistent on macOS.

4. Re-run baseline validation.
   - `flutter analyze`
   - `flutter test`

### Exit criteria

- `flutter pub get` succeeds
- `flutter analyze` succeeds
- `flutter test` succeeds

## Phase 2. Restore platform configuration completeness

### Objective

Ensure Android and iOS are both structurally build-ready from the current Mac.

### Tasks

1. Complete iOS Firebase setup.
   - Run `flutterfire configure`
   - Generate iOS Firebase options in `lib/firebase_options.dart`
   - Add `ios/GoogleService-Info.plist`

2. Verify Android Firebase setup still matches the intended project.
   - Confirm `android/app/google-services.json` is correct for the target Firebase project.

3. Verify Home Widget app group and iOS capability assumptions.
   - Confirm the `HOME_WIDGET_APP_GROUP_ID` workflow is valid on iOS.
   - Confirm Xcode capability configuration if required by the widget target.

4. Check iOS CocoaPods readiness on macOS.
   - Ensure pods can install successfully after Firebase setup.

### Exit criteria

- iOS Firebase config exists and is referenced correctly
- Android Firebase config is confirmed valid
- iOS dependency installation succeeds

## Phase 3. Resolve Android splash and branding packaging issues

### Objective

Finish the Android-specific issue left unresolved in the prior Windows session.

### Tasks

1. Rebuild Android from source using the normal build pipeline.
   - Avoid relying on manual APK patching.

2. Verify packaging of:
   - `android/app/src/main/res/values-v31/styles.xml`
   - `android/app/src/main/res/values-night-v31/styles.xml`
   - `android/app/src/main/AndroidManifest.xml`

3. Install the rebuilt APK on an Android 12+ emulator or device.

4. Validate separately:
   - launcher icon
   - startup splash
   - transition to login screen

5. If splash still falls back to system appearance:
   - inspect generated splash resources
   - inspect theme inheritance
   - inspect Flutter embedding launch theme interaction

### Exit criteria

- Fresh source-built APK installs normally
- launcher icon is correct
- Android 12+ splash matches intended behavior
- app reaches login screen after splash

## Phase 4. Finish release configuration

### Objective

Move from development placeholders to release-ready identifiers and credentials.

### Tasks

1. Finalize package and bundle identifiers.
   - Android `applicationId`
   - iOS bundle identifier

2. Finalize user-facing naming.
   - Android app label
   - iOS display name

3. Apply production AdMob IDs.
   - Android app ID
   - iOS app ID
   - rewarded ad unit ID

4. Configure Android signing.
   - create keystore if missing
   - create `android/key.properties`

5. Set release versioning.
   - update `pubspec.yaml` version

### Exit criteria

- No placeholder identifiers remain in release-critical paths
- Android release signing is configured
- Release version is intentionally set

## Phase 5. Perform release-grade verification

### Objective

Confirm the app is actually releasable from the current environment.

### Tasks

1. Run quality checks again after all config changes.
   - `flutter analyze`
   - `flutter test`

2. Validate platform builds.
   - Android debug build
   - Android release APK or AAB
   - iOS release build on macOS

3. Smoke-test core flows.
   - app launch
   - login
   - quest flow
   - inventory/equipment persistence
   - ad reward flow
   - notification flow if supported in the environment
   - purchase initialization without runtime crash

### Exit criteria

- analysis and tests pass after final configuration
- Android release artifact builds successfully
- iOS release build completes successfully
- no critical runtime startup errors are observed

## Recommended Execution Order

1. Fix Flutter/Dart version mismatch
2. Regenerate local Android/macOS machine config
3. Restore `flutter pub get`, analysis, and tests
4. Complete iOS Firebase setup
5. Reproduce and fix Android splash packaging
6. Finalize release identifiers, signing, and ads
7. Build and verify release artifacts

## Risks and cautions

### High risk

- Changing SDK versions may alter plugin compatibility and generated files.
- iOS Firebase setup may require Firebase console access and Apple-side configuration.
- Android splash behavior can differ between generated resources and runtime theme usage.

### Medium risk

- Re-running generators may overwrite manually tweaked native assets or config.
- Production AdMob identifiers cannot be safely guessed and must come from the actual account.
- Changing package identifiers late can affect Firebase, AdMob, and store setup together.

## What should be done first

The first practical step is to restore a valid local toolchain state on macOS. Until `flutter pub get`, `flutter analyze`, and `flutter test` succeed on this machine, every later step remains speculative.

## Suggested owner checklist

- [ ] Upgrade Flutter or adjust dependency constraints to resolve Dart incompatibility
- [ ] Regenerate `android/local.properties` on macOS
- [ ] Run `flutter pub get`
- [ ] Run `flutter analyze`
- [ ] Run `flutter test`
- [ ] Run `flutterfire configure` for iOS
- [ ] Add iOS Firebase config file
- [ ] Rebuild Android and verify splash behavior
- [ ] Configure Android signing
- [ ] Replace AdMob test IDs
- [ ] Finalize identifiers and version
- [ ] Build Android release artifact
- [ ] Build iOS release artifact
