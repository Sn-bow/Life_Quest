# Life Quest Firebase Client Config Risk Review - 2026-05-20

This review closes the repository-side audit for the release checklist item "Firebase API key exposure risk review" for the real Android app.

## Scope

- Default Android app target: `com.lifequest.app`
- Firebase project: `life-quest-app-95eb9`
- Checked files:
  - `lib/firebase_options.dart`
  - `android/app/google-services.json`
  - `android/app/build.gradle.kts`
  - `android/app/src/main/AndroidManifest.xml`
  - `lib/main.dart`
  - `firestore.rules`
  - `storage.rules`
  - `firebase.json`

## Official References

- Firebase security checklist: https://firebase.google.com/support/guides/security-checklist
- Firebase API key management: https://firebase.google.com/docs/projects/api-keys
- Firebase App Check: https://firebase.google.com/docs/app-check

Key interpretation as of 2026-05-20:
- Firebase API keys used only for Firebase services are client configuration, not authorization secrets.
- Firebase-related APIs use these keys to identify the Firebase project or app; access control must come from Firebase Security Rules, IAM, and App Check.
- Firebase still recommends applying API restrictions, app restrictions, and quota limits as a defense-in-depth measure.
- Service account keys and legacy FCM server keys are secrets and must not be committed.

## Repository Findings

| Area | Evidence | Release assessment |
| --- | --- | --- |
| Android package binding | `android/app/build.gradle.kts` uses `namespace` and `applicationId` `com.lifequest.app`; `android/app/google-services.json` has `package_name` `com.lifequest.app`. | Matches the real Android package target. |
| Firebase client API key | `lib/firebase_options.dart` and `android/app/google-services.json` contain the Android Firebase API key. | Expected for Firebase client config; not a secret by itself. |
| OAuth Android client binding | `android/app/google-services.json` contains an Android OAuth client with package `com.lifequest.app` and certificate hash `27cf18b7c1d3f8fde13fcafe0208d5b3c48d14c0`. | Repository config is bound to a package/signing hash. Play/App signing SHA values still need console verification before production release. |
| Service account/private keys | `rg` found no service account private key material in tracked app config. | No repository evidence of committed Firebase Admin secrets. |
| Firestore data boundary | `firestore.rules` allows each signed-in user to access only `users/{uid}` and approved `_meta` children, then denies all other paths. | API key disclosure alone does not grant cross-user Firestore access under these rules. |
| Storage data boundary | `storage.rules` allows owner-only access to `users/{uid}/profile.jpg`, image MIME only, below 2 MiB, then denies all other paths. | API key disclosure alone does not grant arbitrary Storage access under these rules. |
| App Check startup | `lib/main.dart` activates Firebase App Check with Play Integrity in non-debug Android builds. | App-side integration exists. Console enforcement state still needs final verification before release. |
| Web QA preview | `kLifeQuestQaPreview` skips Firebase initialization. | The temporary tester web preview does not exercise the production Firebase client config path. |

## Required Console Checks Before Play Release

These cannot be fully proven from the repository alone and remain release-blocking manual console checks:

- Confirm Google Cloud API key application restrictions include the Android package `com.lifequest.app` and the production upload/app signing SHA certificates used by Google Play.
- Confirm API restrictions only allow Firebase-related APIs required by this app, and that separate keys are used for any non-Firebase Google APIs if added later.
- Confirm Firebase App Check enforcement is enabled for Cloud Firestore and Cloud Storage after validating real Android traffic with the release signing path.
- Confirm Firebase Authentication authorized domains/providers match the release app and no unused providers are enabled.
- Confirm no service account key files or legacy FCM server keys are committed or distributed with the app.

## Decision

Repository-side Firebase client config risk is acceptable for the current Android release candidate because the exposed Firebase API key is expected client configuration and the actual data access boundary is enforced by Auth, Firestore rules, Storage rules, and App Check startup.

This does not complete the full security release gate. Play release remains blocked until the manual console checks above and authenticated Android smoke tests are completed.
