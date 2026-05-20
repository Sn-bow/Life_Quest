# Life Quest Play Console Data Safety Draft - 2026-05-20

Scope: draft answers for the default real Android release build. This is not a final Play Console submission.

## Build Variant Covered

Default Android release:

- `LIFEQUEST_MONETIZATION_ENABLED=false` or not supplied
- Firebase Auth, Google Sign-In, Firestore, Firebase Storage, Crashlytics, App Check, local notifications, home widget, local preferences
- AdMob and Google Play Billing SDK startup disabled by the runtime gate
- No configured AdMob App ID or rewarded-ad unit ID in the default Android build
- No Health Connect, Google Fit, medical/fitness sensor collection, or generative AI feature
- Web QA Preview is excluded because it is a tester-only preview, not the Android package listing

If monetization is enabled later, this draft is invalid until AdMob and Google Play Billing collection/sharing are reviewed again.

## Official References

- Google Play Data safety form guidance: https://support.google.com/googleplay/android-developer/answer/10787469
- Google Play user-facing Data safety categories: https://support.google.com/googleplay/answer/11416267
- Google Play services data disclosure guidance: https://developers.google.com/android/guides/play-data-disclosure
- Firebase privacy and security: https://firebase.google.com/support/privacy

Key interpretation as of 2026-05-20:

- Data safety applies to closed testing, open testing, and production tracks.
- The form is global per package name and should cover app versions, regions, and user ages.
- Data transmitted off-device by app code or third-party SDKs must be considered, including SDKs used in the app.
- On-device-only data does not need to be declared as collected unless transmitted off-device.
- The developer remains responsible for final answers in Play Console.

## Security Practices Draft

| Play Console question | Draft answer | Evidence / note |
| --- | --- | --- |
| Is all user data collected by your app encrypted in transit? | Yes | Firebase services and Google Sign-In use HTTPS/TLS transport. |
| Do you provide a way for users to request that their data is deleted? | Yes | App includes account deletion flow; privacy policy documents deletion contact and account deletion path. |
| Independent security review? | No, unless a formal review is completed before submission | No independent MASA/security review evidence is currently in the repository. |

## Data Shared Draft

Draft answer: no user data is shared under Google Play's Data safety definition for the default Android build, assuming Firebase/Google services are treated as service providers processing data on the developer's behalf and Google Sign-In is user-initiated.

Notes:

- Life Quest does not sell personal data.
- Google Play's Data safety guidance says transfers to service providers processing data on behalf of the developer do not need to be disclosed as "sharing."
- Firebase/Google services process user data for app functionality, account management, security, crash diagnostics, and optional sign-in/profile image features.
- The app does not intentionally share data for advertising in the default build because AdMob startup is disabled.
- Final Play Console entry should be rechecked against Firebase/Google's current SDK disclosure guidance and the developer's legal/privacy interpretation.

## Data Collected Draft

Use this table to fill the Play Console form for the default Android build.

| Category | Data type | Collected? | Shared? | Required or optional | Purposes to select | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| Personal info | Name | Yes | No, service provider / user-initiated exception | Optional for Google Sign-In/profile; app profile display may use a display name | App functionality, Account management, Personalization | Google Sign-In may provide profile name; app profile may store character/display name. |
| Personal info | Email address | Yes | No, service provider / user-initiated exception | Required for email account mode; optional if Google Sign-In selected | App functionality, Account management, Fraud prevention/security | Firebase Auth and Google Sign-In. |
| Personal info | User IDs | Yes | No, service provider exception | Required for cloud account mode | App functionality, Account management, Fraud prevention/security | Firebase UID/account identifiers. |
| Photos and videos | Photos | Yes, if user chooses a profile image | No, service provider exception | Optional | App functionality, Personalization | Optional profile image upload to Firebase Storage. |
| App activity | App interactions | Yes | No, service provider exception | Required for synced gameplay/progress | App functionality, Personalization, Account management | Quest completion, settings, dungeon/progression interactions stored in Firestore. |
| App activity | Other user-generated content | Yes | No, service provider exception | Required for synced gameplay/progress where users create quests/profile state | App functionality, Personalization, Account management | Quest names, custom rewards, character/progress state. |
| App info and performance | Crash logs | Yes | No, service provider exception | Required in current release build unless Crashlytics is disabled | App functionality, Analytics, Fraud prevention/security | Firebase Crashlytics crash traces and stack traces. |
| App info and performance | Diagnostics | Yes | No, service provider exception | Required for Crashlytics/App Check | App functionality, Analytics, Fraud prevention/security | Device/app diagnostics and app integrity/security signals. |
| Device or other IDs | Device or other IDs | Yes | No, service provider exception | Required for Firebase/Auth/Crashlytics/App Check operation | App functionality, Account management, Fraud prevention/security, Analytics | Firebase installation/auth/app check/crash identifiers. |

## Data Types To Leave Unselected For Default Build

Leave these unselected unless the implementation changes:

- Location: no location permission or app code path.
- Financial info / Purchase history: Google Play Billing startup is disabled by default.
- Health and fitness: no Health Connect, Google Fit, medical, or sensor collection; "health" is only an in-game stat.
- Messages, contacts, calendar, audio, files/docs, web browsing, installed apps: no current evidence in manifest or app code.
- Advertising ID / ad interactions: AdMob startup and ad surfaces are disabled in the default build.

## Optional Feature Notes

Profile photo:
- Declare as collected because the app can upload an image when the user chooses it during sign-up.
- Mark optional.

Google Sign-In:
- Declare profile name/email/user ID data because the user can choose Google Sign-In.
- Mark the sign-in method optional where Play Console permits optional/required detail.

Local notifications:
- Reminder schedules are local-only in current app code and notification permission is opt-in.
- Do not declare notification schedule content as collected unless a future remote notification or server sync path is added.

Home widget/local preferences:
- Current widget/preferences state is local-only and does not add a separate collected data type beyond synced app progress already declared.

## Must Re-Review Before Submission

- Verify the public privacy policy URL is reachable from Play Console and matches this draft.
- Verify the final store listing does not claim features that alter data practices.
- Run authenticated Android smoke tests for account deletion and profile image cleanup.
- Confirm the default release build does not initialize AdMob or Billing and does not show ad/paywall UI.
- Re-run this draft if `LIFEQUEST_MONETIZATION_ENABLED=true`, Firebase Analytics is added, Health Connect is added, or any remote AI feature is added.
