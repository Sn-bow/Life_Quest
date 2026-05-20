# Life Quest Android Data Safety Inventory - 2026-05-19

This inventory maps the current Android app code, manifest permissions, and SDK dependencies to Google Play Data safety categories. It is a release-prep document, not a final Play Console submission.

Play Console input draft: `docs/lifequest-play-console-data-safety-draft-20260520.md`.

## Official References

- Google Play Data safety form guidance: https://support.google.com/googleplay/android-developer/answer/10787469
- Google Play user-facing Data safety categories: https://support.google.com/googleplay/answer/11416267
- Firebase privacy and security: https://firebase.google.com/support/privacy

Key interpretation:
- Google Play says Data safety must include data collected by third-party libraries and SDKs used in the app.
- Google Play defines collection as user data transmitted off the device.
- Data processed only on-device does not need to be declared as collected.
- The developer remains responsible for complete and accurate declarations.

## Build Variant Assumption

Default Android release build:
- `LIFEQUEST_MONETIZATION_ENABLED` is not supplied, so AdMob and Google Play Billing runtime startup are disabled.
- Firebase, Crashlytics, App Check, Firestore, Auth, Google Sign-In, Storage, local notifications, home widget, and local preferences remain in scope.

Monetization-enabled build:
- If `--dart-define=LIFEQUEST_MONETIZATION_ENABLED=true` is used, Data safety must be re-reviewed for AdMob and purchase history before submission.

## Manifest Permissions

| Permission | Current purpose | Data safety impact |
| --- | --- | --- |
| `android.permission.INTERNET` | Firebase Auth, Firestore sync, Crashlytics, App Check, optional Google services | Enables off-device collection; declarations must match active SDK behavior |
| `android.permission.POST_NOTIFICATIONS` | User-enabled reminders | Permission is requested only after user opt-in; notification schedule content is local |
| `android.permission.VIBRATE` | Local notification/device feedback | No user data category by itself |
| `android.permission.RECEIVE_BOOT_COMPLETED` | Restore scheduled local notifications after reboot | No user data category by itself, but background behavior must be smoke-tested |

## SDK And Data Category Inventory

| Component | Code evidence | Data sent off device | Google Play data category candidate | Purpose candidate | Required or optional |
| --- | --- | --- | --- | --- | --- |
| Firebase Authentication | `lib/main.dart`, `lib/screens/login_screen.dart`, `lib/screens/signup_screen.dart` | Email/password auth data, Firebase user ID, auth metadata; Google Sign-In may provide name, email, profile photo | Personal info: email address, name; User IDs; Device or other IDs | Account management, app functionality, fraud prevention/security | Required for cloud account mode |
| Google Sign-In | `lib/screens/login_screen.dart`, `lib/screens/settings_screen.dart` | Google account profile selected by user | Personal info: name, email address, profile photo if used | Account management, app functionality | Optional sign-in method |
| Cloud Firestore | `lib/state/character_state.dart`, `lib/screens/signup_screen.dart`, `lib/services/ad_service.dart` | Character name/photo URL, quest names, quest completion state, stats, inventory, achievements, settings, progression | App activity: app interactions, other actions; Other user-generated content; User IDs | App functionality, personalization, account management | Required for synced app data |
| Firebase Storage | `lib/screens/signup_screen.dart` | Optional selected profile image uploaded to `users/{uid}/profile.jpg` | Photos and videos: photos | App functionality, personalization | Optional |
| Firebase Crashlytics | `lib/main.dart` | Crash traces, installation IDs, device/app diagnostics | App info and performance: crash logs, diagnostics; Device or other IDs | Analytics, app functionality, fraud prevention/security | Required in current release build unless disabled |
| Firebase App Check | `lib/main.dart` | App/device attestation material and App Check tokens | Device or other IDs, diagnostics/security signals | Fraud prevention, security, compliance | Required for protected Firebase access |
| SharedPreferences | `lib/state/character_state.dart`, `lib/services/sound_service.dart`, `lib/services/ad_service.dart` | Local-only settings and cached state in current default build | Not collected if not transmitted off device | App functionality | Local-only |
| Home Widget | `lib/main.dart`, `lib/state/character_state.dart` | Local widget values: character name/level/xp | Not collected if not transmitted off device beyond app/widget storage | App functionality | Optional local feature |
| Flutter Local Notifications | `lib/services/notification_service.dart`, `lib/state/character_state.dart` | Local reminder schedule; no remote push provider currently used | Not collected if notification content remains local | App functionality, developer communications only if promotional messages are added later | Optional opt-in |
| Image Picker | `lib/screens/signup_screen.dart` | User-selected gallery image if uploaded to Firebase Storage | Photos and videos: photos | App functionality, personalization | Optional |
| URL Launcher | `lib/screens/settings_screen.dart` | Opens external privacy policy URL by user action | Usually out of scope for app-controlled collection after user leaves app | App functionality | Optional |
| Google Mobile Ads | `lib/services/ad_service.dart`, manifest metadata | Disabled by default; if enabled, advertising identifiers and ad interaction data may be collected by Google Mobile Ads SDK | Device or other IDs; App activity; Approximate location may apply depending SDK/config; advertising data | Advertising or marketing, analytics | Out of scope for default build; required re-review before enabling |
| In-App Purchase | `lib/services/purchase_service.dart`, `lib/screens/cosmetic_shop_screen.dart` | Disabled by default; if enabled, purchase entitlement/receipt data may be observed by app/Google Play | Financial info: purchase history | App functionality, account management | Out of scope for default build; required re-review before enabling |
| Cloud Functions dependency | `pubspec.yaml` only; no current `FirebaseFunctions` code usage found | No current app code path found | No declaration from app behavior unless used later | None currently | Not active |

## Draft Data Safety Answers For Default Android Build

Use this as a Play Console drafting aid only:

| Data type | Collected? | Shared? | Notes |
| --- | --- | --- | --- |
| Name | Yes | No under service provider / user-initiated exception | Display name/profile name used for account/profile features |
| Email address | Yes | No under service provider / user-initiated exception | Required for email auth or Google Sign-In |
| User IDs | Yes | No under service provider exception | Firebase UID / account identifiers |
| Photos | Optional | No under service provider exception | Only if user selects a profile image |
| App interactions / other actions | Yes | No under service provider exception | Quest/progression/gameplay state stored in Firestore |
| Other user-generated content | Yes | No under service provider exception | User-created quest names and profile/game state |
| Crash logs | Yes | No under service provider exception | Crash reports and stack traces |
| Diagnostics | Yes | No under service provider exception | Device/app diagnostic and security signals |
| Device or other IDs | Yes | No under service provider exception | Firebase installation/app check/crash identifiers |
| Purchase history | No in default build | N/A | Re-review if monetization flag is enabled |
| Advertising ID / ad interactions | No in default build | N/A | Re-review if monetization flag is enabled |
| Health info / fitness info | No | N/A | The app has a "health" stat category, but no Health Connect/medical/fitness sensor collection is implemented |
| Location, contacts, calendar, SMS, audio, files/docs | No current evidence | N/A | No matching Android permissions or code paths found |

## Privacy Policy Gaps Before Release

- `PRIVACY_POLICY.md` was rewritten on 2026-05-19 to remove encoding corruption and placeholder contact text.
- The Firebase Analytics claim was removed because `firebase_analytics` is not in `pubspec.yaml`.
- AdMob and in-app purchases are now described as disabled in the default Android release build unless `LIFEQUEST_MONETIZATION_ENABLED=true`.
- The policy now mentions optional profile photo upload, Firestore-stored quest/progression data, Crashlytics diagnostics, App Check security data, deletion path, and real operator contact.
- Public QA Preview privacy copy is explicitly separated from real Android release behavior because QA Preview is a tester web build, not the production app.
- Health/AI copy risk was reviewed in `docs/lifequest-health-ai-copy-audit-20260520.md`; current evidence supports no Health Connect, Google Fit, medical, fitness sensor, or generative AI data category in the default Android app.

## Security/Rules Checks Still Required

- Firebase API keys in `firebase_options.dart` and `android/app/google-services.json` are client configuration, not secret keys by themselves. The repository-side risk review is documented in `docs/lifequest-firebase-client-config-risk-review-20260520.md`.
- Release safety still depends on Firebase Auth provider/domain restrictions, Google Cloud API key restrictions, App Check enforcement, Firestore rules, and Storage rules being correct in the live consoles.
- Repository Firestore rules now scope each user to `users/{uid}` plus the approved `_meta` child path and permit owner account deletion.
- Repository Storage rules now scope profile images to `users/{uid}/profile.jpg`, owner-only access, image content types, and a 2 MiB upload limit.
- Account deletion now attempts to delete the optional profile image and known `_meta/adServerTime` document before deleting the user document and Auth account.
- Live Firebase project rules were deployed on 2026-05-20 KST; account deletion still needs an authenticated Android smoke test.

## Release Decision

M-05 is not complete. The SDK/data-category inventory and Play Console draft answers are complete enough to unblock manual Play Console entry, but final submission should remain blocked until:

- Privacy policy publication path is verified from the released app and store listing.
- Authenticated Android account deletion smoke test confirms Auth, Firestore, and Storage cleanup.
- A default release AAB is smoke-tested to confirm no AdMob/Billing UI or SDK startup occurs without the monetization flag.
- Any monetization-enabled build receives a separate Data safety review.
