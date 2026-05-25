# Life Quest Play Console Submission Runbook - 2026-05-25

Scope: the default real Android release build for `com.lifequest.app`.
The web QA Preview is only a tester preview and must not be used as the
production Play listing evidence.

## Official Sources Rechecked

- Google Play Data safety form:
  https://support.google.com/googleplay/android-developer/answer/10787469
- Google Play content ratings / IARC:
  https://support.google.com/googleplay/android-developer/answer/9898843
- Google Play Health apps declaration:
  https://support.google.com/googleplay/android-developer/answer/14738291
- Google Play account deletion requirements:
  https://support.google.com/googleplay/android-developer/answer/13327111

## Build Scope

Use the default Android build unless a separate monetization-enabled build is
explicitly prepared:

- `LIFEQUEST_MONETIZATION_ENABLED` is not supplied.
- `ADMOB_ANDROID_APP_ID` is not supplied.
- `ADMOB_REWARDED_AD_UNIT_ID_ANDROID` is not supplied.
- AdMob startup, rewarded-ad UI, Google Play Billing startup, and paid
  cosmetic purchase flows are disabled by default.

Do not answer Play Console forms as if ads or in-app purchases are active for
this default build. If monetization is enabled later, re-run Data safety,
store listing, IARC, consent copy, and privacy policy review before submission.

## App Content Submission Order

1. Upload or select the exact Android AAB intended for closed testing.
2. Complete the privacy policy URL field.
3. Complete Data safety using
   `docs/lifequest-play-console-data-safety-draft-20260520.md`.
4. Complete App access if Play Console asks for test account instructions.
5. Complete Ads declaration as "No" for the default build.
6. Complete Health apps declaration as "My app doesn't provide any health
   features" for the default build.
7. Complete content rating / IARC based on the real Android build content.
8. Enter the store listing text from
   `docs/lifequest-play-store-listing-draft-20260520.md`.
9. Upload fresh Android screenshots captured from the same build family.
10. Review the final listing, Data safety, Health declaration, IARC answers,
    privacy URL, and screenshots together before closed testing submission.

## Data Safety Answers

Use the existing Data safety draft as the source of truth for default build
answers:

- Collected: name/display name, email address, user IDs, optional profile
  photo, app interactions/progress, user-generated quest/profile content,
  crash logs, diagnostics, and device or other IDs.
- Shared: answer "No" under the current service-provider interpretation for
  Firebase/Google services, then recheck the final wording in Play Console.
- Not collected for the default build: location, financial info/purchase
  history, health and fitness data, messages, contacts, calendar, audio,
  files/docs, web browsing, installed apps, advertising ID, and ad
  interactions.
- Security: app data is transmitted over encrypted Firebase/Google service
  channels where applicable.
- Account deletion: the app has an in-app deletion path and a public account
  deletion page, but an authenticated Android smoke test still must confirm
  Auth, Firestore, and Storage cleanup before release.

Do not mark Data safety complete until the form is actually saved in Play
Console and compared against the public privacy policy URL.

## Health Apps Declaration

For the current default Android build:

- Select that the app does not provide health features.
- Do not select activity/fitness, nutrition/weight management, period
  tracking, medical-device, Health Connect, Google Fit, or health-data access.
- The in-app "Health" stat is a game category only. It does not collect,
  analyze, or infer medical, wellness, fitness, sensor, or location data.

If any future version adds Health Connect, fitness tracking, sensor sync,
medical advice, diet coaching, or similar features, this declaration must be
reopened before that version is submitted.

## Content Rating / IARC

Answer based on the exact Android build:

- App type: game / RPG-style productivity.
- Violence: fantasy/card battle against monsters is present.
- Gambling: no real gambling, no simulated casino, no prize redemption.
- UGC: no public user-generated content feed or user-to-user sharing.
- Location/social/chat: no public chat or location sharing.
- Ads: no active ads in the default build.
- In-app purchases: no active purchases in the default build.

If paid features or ads are enabled later, redo this review before submission.

## Store Listing and Screenshots

Use the listing draft and guardrails in
`docs/lifequest-play-store-listing-draft-20260520.md`.

Screenshots must show the real Android app, not the web QA Preview. Required
capture set for closed testing:

- Today / daily adventure home.
- Quest creation or quest completion.
- Growth profile or title progress.
- Dungeon entry with daily modifier.
- Card battle.
- Card reward or dungeon event.
- Focus timer.
- Settings with account deletion/privacy access if needed for review evidence.

Do not show AdMob, paid cosmetic purchases, subscriptions, Health Connect, AI
coach, AR, web preview, or features hidden from the default Android build.

## Blocking Checks Before Closed Testing

- Firebase Console package/SHA/App Check/Auth settings are confirmed for
  `com.lifequest.app`.
- Release or closed-testing AAB is installed and smoke-tested on Android.
- Authenticated account deletion smoke test passes.
- Timer background/return smoke test passes.
- Default build shows no ad/paywall UI and does not initialize AdMob/Billing.
- Public privacy policy URL is reachable and matches Data safety answers.
- Store listing, Data safety, Health declaration, IARC, and screenshots all
  describe the same default Android build.
