# Life Quest Android Device Smoke Runbook - 2026-06-04

Scope: default real Android release or closed-testing build for
`com.lifequest.app`.

This runbook is required before Play Console closed testing or production
submission. It is not satisfied by the Web QA Preview.

## Current Local Device Status

Checked on 2026-06-04 KST:

```text
C:\Users\wjd54\AppData\Local\Android\Sdk\platform-tools\adb.exe devices
```

Result: ADB starts successfully, but no authorized device is currently listed.
The smoke test remains open until an Android device or emulator appears in
`device` state.

## Artifact Under Test

- AAB record: `docs/lifequest-release-artifact-record-20260605.md`
- Local AAB path: `build/app/outputs/bundle/release/app-release.aab`
- Package name: `com.lifequest.app`
- Default monetization scope: no active AdMob startup, rewarded-ad UI, Google
  Play Billing startup, or paid purchase flow unless explicit monetization
  build flags are supplied.

If the AAB is rebuilt, signing changes, Firebase settings change, or version
changes before testing, update the artifact record first.

## Required Setup

- Use a physical Android device or emulator that appears as `device` in:

```text
C:\Users\wjd54\AppData\Local\Android\Sdk\platform-tools\adb.exe devices
```

- Use the exact build family intended for Play Console closed testing.
- Use a test account that can be deleted without preserving data.
- Keep Firebase Console access available for Auth, Firestore, Storage, and
  Crashlytics verification.

## Smoke Checklist

### 1. Install And Launch

- Install the release/closed-testing package.
- Launch `com.lifequest.app`.
- Confirm the app reaches splash, login/onboarding, or authenticated home
  without crash or ANR.
- Capture a screenshot of the first stable screen.

### 2. First-Run And Core Loop

- Complete sign-up or login with a disposable test account.
- Complete onboarding if shown.
- Create or complete one quest.
- Confirm gold/stat/progress updates persist after app restart.
- Enter dungeon flow and confirm the Soul Deck tutorial appears for a fresh
  user.
- Play at least one Zone 1 battle through reward or defeat without crash.

### 3. Default Monetization-Off Behavior

- Confirm no AdMob placement, rewarded-ad prompt, subscription, purchase,
  premium cosmetic purchase, or paywall UI is visible in the default build.
- Confirm low-AP or reward paths do not require watching ads.
- Check logcat for obvious AdMob or Billing startup errors. The default build
  must not initialize these flows.

### 4. Focus Timer Background/Return

- Start a focus timer.
- Background the app for at least 60 seconds.
- Return to the app.
- Confirm elapsed time is deducted once.
- Stop or complete the timer.
- Confirm there is no crash, duplicate reward, stuck dialog, or obvious Android
  vitals issue.

### 5. Account Deletion

- Ensure the test account has Firestore progress data.
- If profile image upload is available in the tested path, add a disposable
  profile image.
- Delete the account from the in-app settings flow.
- Confirm failed deletion does not navigate away as if deletion succeeded.
- Confirm successful deletion removes:
  - Firebase Auth user.
  - `users/{uid}` Firestore document.
  - known `users/{uid}/_meta/adServerTime` document if present.
  - optional `users/{uid}/profile.jpg` Storage object if present.
- Confirm the app returns to a non-authenticated state after deletion.

### 6. Public Policy And Store Evidence

- Open privacy/account deletion links from the app settings flow.
- Confirm they reach the public policy page represented by `docs/index.html`.
- Capture screenshots needed for Play listing from the actual Android app:
  Today, quest creation/completion, growth profile, dungeon entry, card battle,
  card reward, focus timer, and settings/privacy/account deletion if useful for
  review evidence.

### 7. Crashlytics And Logs

- Review logcat around launch, login, dungeon, timer background/return, and
  account deletion.
- Confirm no fatal exception, repeated platform exception, ANR, or startup loop.
- Confirm Firebase Crashlytics receives a release/test-device event or
  non-fatal diagnostic if a test event path is used.

## Pass Criteria

Closed testing can proceed only when:

- All checklist sections above pass on at least one Android device or emulator.
- Screenshots are captured from the same default Android build family.
- Play Console Data safety, Health declaration, IARC, store listing, privacy
  URL, and screenshots are reviewed together against the tested build.

## Evidence To Record

Append results to `docs/SHARED_WORK_LOG.md` with:

- Device model and Android version.
- Build version and AAB record used.
- ADB device id if available.
- Install/launch result.
- Core-loop result.
- Timer background/return result.
- Account deletion result.
- Monetization-off confirmation.
- Crash/logcat summary.
- Screenshot paths.
