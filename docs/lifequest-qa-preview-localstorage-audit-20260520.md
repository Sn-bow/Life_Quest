# Life Quest QA Preview localStorage Audit - 2026-05-20

Scope: tester-only Web QA Preview. This does not replace or redefine the real Android release target.

## Build Assumption

QA Preview is built with:

```text
flutter build web --dart-define=LIFEQUEST_QA_PREVIEW=true --pwa-strategy=none
```

The production Android app must not be judged from this web build. QA Preview exists only to let testers try the core loop before Play testing.

## Code Findings

| Area | Evidence | Assessment |
| --- | --- | --- |
| Mode flag | `lib/config/qa_preview_config.dart` defines `kLifeQuestQaPreview` from `LIFEQUEST_QA_PREVIEW`. | Preview behavior is compile-time gated. |
| Entry point | `lib/main.dart` uses `QaPreviewGateScreen` instead of `AuthWrapper` when `kLifeQuestQaPreview` is true. | No Firebase Auth sign-in is required for QA Preview. |
| Firebase startup | `lib/main.dart` skips `Firebase.initializeApp`, Crashlytics setup, Firestore settings, and App Check activation in QA Preview. | The preview does not initialize production Firebase clients. |
| Optional services | `lib/main.dart` skips `_initializeOptionalServices()` in QA Preview. | Notification, sound startup, AdMob, Billing, and HomeWidget startup are not invoked from app startup. |
| Guest profile | `CharacterState.initializeForQaPreview()` initializes or restores a local guest profile. | The preview profile is separate from Firebase-backed Android accounts. |
| localStorage key | `CharacterState._qaPreviewStorageKey` is `lifequest.qaPreview.state.v2`; SharedPreferences web stores it in browser localStorage, typically under `flutter.lifequest.qaPreview.state.v2`. | One known app-scoped key is used for QA state. |
| Saved payload | `_buildSavePayload(includeServerTimestamp: false)` stores character, quests, unlocked titles, skills, achievements, theme, locale, onboarding flag, and notification hour/settings fields. | Data is gameplay/progress state only; no email, UID, auth token, Firebase credential, profile photo binary, billing receipt, ad ID, or device identifier is stored by this path. |
| Restore hardening | `_restoreQaPreviewData()` forces `_isNotificationEnabled = false` and accepts only supported locale codes. | Restored preview state cannot silently enable notifications. |
| Firestore writes | `_performSaveData()` returns through `_performQaPreviewSaveData()` before Firebase Auth or Firestore access when `kLifeQuestQaPreview` is true. | Quest completion and other saves remain local in QA Preview. |
| Existing tests | `test/state/character_state_test.dart` covers QA Preview seed/restore and immediate quest-completion progress. | Unit coverage exists for the local guest profile path. |

## Public Preview Data Boundary

QA Preview localStorage may contain:

- guest character name, level, XP, HP, gold, stats, inventory/card IDs, cosmetics, and settings
- quest titles and completion state entered by a tester in that browser
- achievement/title/skill progress
- locale/theme/onboarding flags
- notification preference fields, but restored notification enabled state is forced false

QA Preview localStorage must not contain:

- Firebase Auth UID, ID token, refresh token, or email/password credentials
- Google Sign-In tokens
- Firestore document paths for a real user account
- Firebase Storage profile image binaries
- AdMob identifiers, ad interaction history, or Google Mobile Ads consent state from the preview path
- Google Play Billing purchase tokens, receipts, or entitlement state
- private owner/tester production data

## Verification Commands

Commands used for this audit:

```text
rg -n "QA Preview|kLifeQuestQaPreview|LIFEQUEST_QA_PREVIEW|localStorage|shared_preferences|SharedPreferences|Firebase.initializeApp|FirebaseAuth|Firestore|Crashlytics|AppCheck|AdService|PurchaseService|google_mobile_ads|in_app_purchase|image_picker|firebase_storage|url_launcher|privacy|Data safety" lib web docs PRIVACY_POLICY.md firebase.json pubspec.yaml
rg -n "qaPreview|lifequest\.qaPreview|_saveQaPreview|_loadQaPreview|SharedPreferences|setString|getString|remove\(|clear\(|kLifeQuestQaPreview|_buildSavePayload|_performSaveData" lib/state/character_state.dart lib/screens/qa_preview_gate_screen.dart lib/main.dart lib/services/ad_service.dart lib/services/purchase_service.dart
flutter test --no-pub test/state/character_state_test.dart
```

## Decision

Repository-side QA Preview localStorage scope is acceptable for the tester preview. The known localStorage state is limited to disposable guest gameplay/progress data and is separated from Firebase-backed Android accounts.

This does not complete production Android data safety. The real Android app still requires Play Console Data safety, privacy URL, authenticated device smoke tests, and final release-build verification.
