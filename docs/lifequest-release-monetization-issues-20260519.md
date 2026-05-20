# Life Quest Release & Monetization Issues - 2026-05-19

This document records current release/monetization issues directly from 2026 official platform guidance. It is intentionally written as an issue list, not a research archive.

## Sources Checked

- Google Play Commerce guide: https://play.google.com/console/about/guides/play-commerce/
- Google Play subscriptions help: https://support.google.com/googleplay/android-developer/answer/12154973
- Google Play monetization policy: https://support.google.com/googleplay/android-developer/answer/16329168
- Android vitals: https://developer.android.com/topic/performance/vitals/index.html
- Google Play target API level requirement: https://developer.android.com/google/play/requirements/target-sdk
- Large screen app quality: https://developer.android.com/docs/quality-guidelines/archive/adaptive/large-screen-app-quality
- Google Play Data safety help: https://support.google.com/googleplay/answer/11416267
- Google Play Data safety form help: https://support.google.com/googleplay/android-developer/answer/10787469
- RevenueCat State of Subscription Apps 2026: https://www.revenuecat.com/state-of-subscription-apps-2026-shopping/

## Issue M-01 - Monetization Must Start Hybrid, Not Ad-First

Status: Partially mitigated in code and planned on 2026-05-20.

Evidence:
- Google Play explicitly supports paid distribution, in-app products, subscriptions, and ad-based models.
- Google Play Commerce recommends matching monetization model to business goals and supports hybrid strategies.
- Ads that interrupt normal use or gameplay are policy risk and product-quality risk.

Decision:
- Do not make ads the primary first monetization model.
- Keep tester preview and early release free of AdMob surfaces.
- First viable model should be optional premium/subscription after the core loop proves retention.

Life Quest implication:
- P0/P1 product must prove daily retention before subscription work.
- Rewarded ads can remain a later optional candidate only if they are explicit opt-in and do not break the habit flow.

Acceptance criteria:
- [x] No ad surfaces in QA Preview.
- [x] No interstitial ads in core quest, status, dungeon, timer, or reward flows. Repository search found only rewarded ads, no `InterstitialAd` usage.
- [x] AdMob and billing startup are disabled by default in the real Android app unless `LIFEQUEST_MONETIZATION_ENABLED=true` is supplied.
- [x] Default Android builds do not embed a configured AdMob App ID or production rewarded-ad unit ID. Monetization-enabled builds must inject `ADMOB_ANDROID_APP_ID` and `ADMOB_REWARDED_AD_UNIT_ID_ANDROID`.
- [x] Release plan defines one optional premium value bundle before billing implementation. See `docs/lifequest-premium-bundle-plan-20260520.md`.

## Issue M-02 - Subscription Requires Clear Entitlement, Not Vague Support

Status: Premium bundle defined on 2026-05-20; billing remains disabled.

Evidence:
- Google Play subscriptions are composed of subscription products, base plans, and offers.
- Users gain entitlement by purchasing a base plan or offer.
- One subscription can have many base plans/offers, but active offers must stay manageable.

Decision:
- Avoid "후원" or vague donation-like copy as the main product.
- Premium must unlock understandable value.

Candidate premium bundle:
- Product ID: `lifequest_premium`.
- Base plans: `monthly-auto` and `annual-auto`.
- Draft Korea price anchors: 4,900 KRW monthly and 39,000 KRW yearly.
- Entitlements: advanced reports, long-term archive/calendar, extra custom reward slots, premium themes/title frames, export/share summary.

Non-candidate for paid gate:
- Basic quest creation.
- Basic daily growth.
- First dungeon chapter.
- Essential local progress.

Acceptance criteria:
- [x] Premium entitlement list fits on one screen. See `docs/lifequest-premium-bundle-plan-20260520.md`.
- [ ] Free user can understand and complete the core loop.
- [x] Billing is disabled by default until retention loop and premium bundle copy are validated.

## Issue M-03 - Android Vitals Can Affect Store Visibility

Status: Partially mitigated in code and audited on 2026-05-20.

Evidence:
- Android vitals are quality metrics that can affect Google Play visibility.
- Google notes excessive partial wake locks can affect store visibility starting March 1, 2026.

Decision:
- Timer, notification, background, and wake-lock behavior must be audited before release.
- Life Quest should avoid keeping the device awake for focus timer unless the user explicitly enables that behavior.

Acceptance criteria:
- [x] Focus timer does not require persistent wake lock in default mode. See `docs/lifequest-android-vitals-timer-audit-20260520.md`.
- [x] Notification permission is requested only after the user enables notifications in settings.
- [ ] Debug/release smoke test includes timer start, background, return, and stop.
- [x] Android vitals checklist is added to release QA. See `docs/lifequest-android-vitals-timer-audit-20260520.md`.

Current Android build check:
- `compileSdk = 36`.
- `targetSdk = 35`.
- Android Developers states that, starting August 31, 2025, new apps and updates must target Android 15/API 35 or higher to be submitted to Google Play.

2026-05-20 audit notes:
- `android.permission.WAKE_LOCK` is not declared in `AndroidManifest.xml`.
- No app code references `PARTIAL_WAKE_LOCK`, `PowerManager.WakeLock`, `keepScreenOn`, or `FLAG_KEEP_SCREEN_ON`.
- Audio contexts explicitly set `stayAwake: false`.
- Focus timer pauses its foreground timer on background and reconciles elapsed wall-clock time on resume.

## Issue M-04 - Mobile First, But Large Screen Cannot Break

Status: Open

Evidence:
- Android large screen quality guidance requires apps to fill available display area, handle resizing, and preserve state across configuration changes.

Decision:
- Life Quest remains phone-first.
- Tablet/desktop web can use a phone-frame layout for tester preview, but Android release should not hard-crash or expose broken full-width layouts on larger screens.

Acceptance criteria:
- [ ] 390px phone layout smoke test.
- [ ] 600dp+ large screen smoke test or documented limitation.
- [ ] Scroll position/text entry survives rotation where applicable.
- [ ] Web QA Preview remains phone-framed for tester clarity.

## Issue M-05 - Data Safety Must Match Actual SDK Behavior

Status: Drafted for Play Console entry on 2026-05-20; final submission remains blocked.

Evidence:
- Google Play Data safety disclosures must cover data categories and purposes, including name, email, user IDs, and other collected/shared data.

Decision:
- Firebase Auth, Firestore, Crashlytics, Storage, notifications, and future AdMob/Billing SDKs must be mapped before release.
- Do not claim "no data collected" if Firebase Auth or analytics/crash reporting are active.
- Treat the default Android release build and any monetization-enabled build as separate review cases because AdMob/Billing are disabled by default.

Acceptance criteria:
- [x] Data inventory table lists each SDK and data category. See `docs/lifequest-data-safety-inventory-20260519.md`.
- [x] Privacy policy draft matches current default Android Data safety inventory.
- [x] Play Console Data safety draft answers exist for the default Android build. See `docs/lifequest-play-console-data-safety-draft-20260520.md`.
- [ ] Published privacy policy URL and Play Console Data safety answers are verified together before release.
- [x] QA Preview public web version contains no personal credentials or private owner data in the repository-side localStorage/Firebase startup audit. See `docs/lifequest-qa-preview-localstorage-audit-20260520.md`.
- [x] AdMob remains disabled by default until Data safety and consent implications are updated.

## Issue M-06 - Health/AI Copy Must Not Overclaim Deferred Features

Status: Repository-side copy audit completed on 2026-05-20.

Evidence:
- Google Play Health Content and Services policy and Health apps declaration guidance require health-related app declarations and accurate representation of health functionality.
- Google Play AI-Generated Content policy applies when apps generate content using AI and requires compliance with existing policies, including deceptive behavior restrictions.
- Repository search found no Health Connect, Google Fit, medical/fitness sensor permission, OpenAI/Gemini/Vertex/Firebase AI SDK, chatbot, generative model, or AI coach runtime path in the current Android app.

Decision:
- Keep "health" as a game stat label only.
- Do not market v1 as Health Connect, Google Fit, medical, fitness analytics, or AI coach software.
- Keep recommendations framed as deterministic app guidance, not AI coaching.

Acceptance criteria:
- [x] Runtime and manifest search show no Health Connect, Google Fit, medical sensor, or generative AI implementation.
- [x] Privacy policy and public privacy page explain that "Health" is an in-game stat, not medical or fitness data.
- [x] Store-copy guardrails are documented. See `docs/lifequest-health-ai-copy-audit-20260520.md`.
- [ ] Play Console Health apps declaration and final store listing copy are verified together before closed testing or production.

## Issue M-07 - Store Listing Must Match The Android Build

Status: Draft copy prepared on 2026-05-20; final console submission remains open.

Evidence:
- Google Play store listing fields have strict character limits: app name 30 characters, short description 80 characters, and full description 4000 characters.
- Google Play metadata and deceptive behavior policies require clear, accurate descriptions and prohibit misleading claims in descriptions, title, icon, screenshots, and promotional images.

Decision:
- List the real Android app, not the temporary web QA preview.
- Use copy that describes only shipped/default behavior: manual quests, RPG growth, titles, rewards, card combat, focus timer, reports, account sync/deletion.
- Do not advertise Health Connect, AI coaching, active ads, subscriptions, or premium benefits until those features are implemented, declared, and tested.

Acceptance criteria:
- [x] Korean short and full description draft exists within Play Console limits. See `docs/lifequest-play-store-listing-draft-20260520.md`.
- [x] English fallback draft exists for later localization.
- [x] Listing guardrails mention Health/AI, monetization, Data safety, and screenshot alignment.
- [ ] Final Play Console listing is reviewed against the exact release build screenshots and declarations.

## Current Monetization Direction

Release v1 should not sell "a game." It should sell sustained self-management.

Recommended sequence:

1. Free core loop: quests -> growth -> today state -> optional dungeon feedback.
2. Retention proof: weekly return, quest completion, focus timer completion, reward purchase.
3. Premium pilot: `lifequest_premium` with advanced reports, long-term archive/calendar, extra custom reward slots, premium themes/title frames, export/share summary.
4. Ads: only optional rewarded ads after the core app is trusted, if used at all.

Immediate next implementation target:
- Make the free core loop clearer and reduce screen confusion before adding billing.
- Before enabling `LIFEQUEST_MONETIZATION_ENABLED`, finish Data safety, consent copy, premium entitlement copy, and release smoke tests.
