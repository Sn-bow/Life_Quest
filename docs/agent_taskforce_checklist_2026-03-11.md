# Agent Taskforce Checklist - 2026-03-11

## Operating model

This project will be handled as a small taskforce rather than a single undifferentiated workstream.

There is one shared rule:

- No release work starts until the local macOS development baseline is restored.

## Agent roster

### Agent 1. Environment Lead

Mission:
- Restore a working macOS Flutter environment for this project.

Owns:
- Flutter/Dart version compatibility
- `flutter pub get`
- `flutter analyze`
- `flutter test`
- local machine path regeneration

Primary blockers:
- Dart version mismatch with `google_mobile_ads`
- Windows paths still present in `android/local.properties`

Definition of done:
- project dependencies resolve
- analysis passes
- tests pass

### Agent 2. Android Build Lead

Mission:
- Make Android builds reproducible from source on macOS.

Owns:
- Android local config sanity
- Gradle/Flutter Android build path
- Android 12+ splash packaging issue
- launcher icon and splash verification

Primary blockers:
- prior handoff shows unstable `flutter run`
- unresolved Android 12+ splash behavior

Definition of done:
- fresh source-built APK installs
- splash behavior is verified
- launcher icon is verified

### Agent 3. iOS Platform Lead

Mission:
- Make iOS structurally build-ready on macOS.

Owns:
- FlutterFire iOS setup
- `GoogleService-Info.plist`
- iOS Firebase options generation
- CocoaPods/Xcode dependency readiness
- app group / widget assumptions review

Primary blockers:
- iOS Firebase not configured
- `lib/firebase_options.dart` throws on iOS

Definition of done:
- iOS Firebase config is complete
- iOS build dependencies install successfully
- app can proceed past Firebase init on iOS

### Agent 4. Release Config Lead

Mission:
- Replace placeholders with release-grade values and signing config.

Owns:
- package identifiers
- app names
- versioning
- AdMob production IDs
- Android signing config

Primary blockers:
- test IDs still present
- identifiers still placeholder-level
- signing config incomplete

Definition of done:
- release-critical placeholders are removed
- signing is configured
- version is intentionally set

### Agent 5. QA Lead

Mission:
- Re-validate the whole project after environment and config changes.

Owns:
- regression checklist
- smoke tests
- final build verification

Primary blockers:
- validation currently cannot be trusted on this Mac

Definition of done:
- core flows are smoke-tested
- Android release build is validated
- iOS release build is validated as far as credentials allow

### Agent 6. Documentation Controller

Mission:
- Keep state, decisions, blockers, and handoff quality clean.

Owns:
- checklists
- session notes
- unresolved blockers
- final handoff summary

Definition of done:
- another machine or session can resume without rediscovery

## Dependency map

### Must finish first

- Agent 1 before meaningful work by Agents 2, 3, 4, and 5

### Can start after Agent 1

- Agent 2 and Agent 3 can proceed in parallel

### Must wait for Agent 2 and Agent 3

- Agent 4 should finalize release values only after platform setup is stable

### Final gate

- Agent 5 runs after Agents 1 to 4 complete their required work

## Master checklist

## Phase A. Baseline recovery

Owner:
- Agent 1

Checklist:
- [ ] Confirm current Flutter version on macOS
- [ ] Confirm current Dart version on macOS
- [ ] Resolve `google_mobile_ads` and Dart compatibility mismatch
- [ ] Regenerate `android/local.properties` for macOS
- [ ] Run `flutter pub get`
- [ ] Run `flutter analyze`
- [ ] Run `flutter test`

Completion gate:
- All three commands succeed: `flutter pub get`, `flutter analyze`, `flutter test`

## Phase B. Platform recovery

Owner:
- Agent 2
- Agent 3

### Android stream

Owner:
- Agent 2

Checklist:
- [ ] Confirm Android SDK path is valid on macOS
- [ ] Confirm Gradle wrapper runs correctly on macOS
- [ ] Build fresh Android debug artifact from source
- [ ] Verify `values-v31` and `values-night-v31` packaging
- [ ] Install APK on Android 12+ emulator or device
- [ ] Verify launcher icon
- [ ] Verify startup splash
- [ ] Verify login screen after splash

Completion gate:
- Fresh Android build installs and visual launch path is correct

### iOS stream

Owner:
- Agent 3

Checklist:
- [ ] Run `flutterfire configure`
- [ ] Generate iOS Firebase config into `lib/firebase_options.dart`
- [ ] Add `ios/GoogleService-Info.plist`
- [ ] Verify `pod install` or Flutter iOS dependency resolution
- [ ] Review widget/app group assumptions
- [ ] Confirm app can initialize Firebase on iOS

Completion gate:
- iOS Firebase and dependency setup are structurally complete

## Phase C. Release configuration

Owner:
- Agent 4

Checklist:
- [ ] Replace Android package identifier with final value
- [ ] Replace iOS bundle identifier with final value
- [ ] Finalize Android app label
- [ ] Finalize iOS display name
- [ ] Replace Android AdMob App ID
- [ ] Replace iOS AdMob App ID
- [ ] Replace rewarded ad unit ID
- [ ] Create Android keystore if missing
- [ ] Create `android/key.properties`
- [ ] Set final app version in `pubspec.yaml`

Completion gate:
- No release-critical placeholder values remain

## Phase D. Verification and signoff

Owner:
- Agent 5
- Agent 6

Checklist:
- [ ] Re-run `flutter analyze`
- [ ] Re-run `flutter test`
- [ ] Build Android debug
- [ ] Build Android release or AAB
- [ ] Build iOS release
- [ ] Smoke-test launch flow
- [ ] Smoke-test login flow
- [ ] Smoke-test quest flow
- [ ] Smoke-test inventory persistence
- [ ] Smoke-test ad reward path
- [ ] Record unresolved issues, if any
- [ ] Write final handoff summary

Completion gate:
- Build artifacts are reproducible and residual risk is clearly documented

## Immediate task assignment

### Active now

Agent 1:
- Fix the macOS toolchain baseline first.

Agent 6:
- Maintain updated progress notes while Agent 1 work is happening.

### Queued next

Agent 2:
- Start once Agent 1 clears dependency and analysis/test gates.

Agent 3:
- Start once Agent 1 clears dependency and analysis/test gates.

### Queued after platform stabilization

Agent 4:
- Finalize production identifiers, ads, signing, and versioning.

Agent 5:
- Run full regression and release verification last.

## Command board

### Agent 1 expected commands

- `flutter --version`
- `dart --version`
- `flutter pub get`
- `flutter analyze`
- `flutter test`

### Agent 2 expected commands

- `flutter build apk --debug`
- `./gradlew app:assembleDebug`

### Agent 3 expected commands

- `flutterfire configure`
- `flutter build ios`

### Agent 5 expected commands

- `flutter build appbundle --release`
- `flutter build ios --release`

## Progress tracking table

| Agent | Status | Next action | Blocker |
|------|--------|-------------|---------|
| Agent 1 - Environment Lead | Completed | Hand off to Agents 2 and 3 | None |
| Agent 2 - Android Build Lead | Completed | Hand off Android splash refinement to follow-up work | Android 12 custom splash intentionally deferred after build recovery |
| Agent 3 - iOS Platform Lead | Blocked | Install full Xcode, then resume iOS setup | Full Xcode is not installed; only Command Line Tools are active |
| Agent 4 - Release Config Lead | Blocked | Apply external release identifiers, signing, and ad IDs | Waiting for user-provided package IDs, Xcode, Firebase, AdMob, and keystore |
| Agent 5 - QA Lead | Completed | Hand off residual blockers for follow-up | Device smoke test not executed; iOS remains blocked by missing full Xcode |
| Agent 6 - Documentation Controller | Active | Keep plan and handoff current | None |

## Management note

The current commander's priority is not "do everything at once". The correct order is:

1. restore the macOS baseline
2. stabilize Android and iOS
3. finalize release config
4. verify and document

Any attempt to skip Step 1 will create noisy failures and wasted effort.
