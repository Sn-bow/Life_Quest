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

## Issue M-01 - Monetization Must Start Hybrid, Not Ad-First

Status: Partially mitigated in code on 2026-05-19.

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
- [ ] No interstitial ads in core quest, status, dungeon, timer, or reward flows.
- [x] AdMob and billing startup are disabled by default in the real Android app unless `LIFEQUEST_MONETIZATION_ENABLED=true` is supplied.
- [ ] Release plan defines one optional premium value bundle before billing implementation.

## Issue M-02 - Subscription Requires Clear Entitlement, Not Vague Support

Status: Partially mitigated in code on 2026-05-19.

Evidence:
- Google Play subscriptions are composed of subscription products, base plans, and offers.
- Users gain entitlement by purchasing a base plan or offer.
- One subscription can have many base plans/offers, but active offers must stay manageable.

Decision:
- Avoid "후원" or vague donation-like copy as the main product.
- Premium must unlock understandable value.

Candidate premium bundle:
- Advanced weekly/monthly reports.
- More custom reward slots.
- Extra theme packs.
- Optional long-term archive/export.
- Advanced title/stat analytics.

Non-candidate for paid gate:
- Basic quest creation.
- Basic daily growth.
- First dungeon chapter.
- Essential local progress.

Acceptance criteria:
- [ ] Premium entitlement list fits on one screen.
- [ ] Free user can understand and complete the core loop.
- [x] Billing is disabled by default until retention loop and premium bundle copy are validated.

## Issue M-03 - Android Vitals Can Affect Store Visibility

Status: Partially mitigated in code on 2026-05-19.

Evidence:
- Android vitals are quality metrics that can affect Google Play visibility.
- Google notes excessive partial wake locks can affect store visibility starting March 1, 2026.

Decision:
- Timer, notification, background, and wake-lock behavior must be audited before release.
- Life Quest should avoid keeping the device awake for focus timer unless the user explicitly enables that behavior.

Acceptance criteria:
- [ ] Focus timer does not require persistent wake lock in default mode.
- [x] Notification permission is requested only after the user enables notifications in settings.
- [ ] Debug/release smoke test includes timer start, background, return, and stop.
- [ ] Android vitals checklist is added to release QA.

Current Android build check:
- `compileSdk = 36`.
- `targetSdk = 35`.
- Android Developers states that, starting August 31, 2025, new apps and updates must target Android 15/API 35 or higher to be submitted to Google Play.

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

Status: Partially mitigated in docs on 2026-05-19.

Evidence:
- Google Play Data safety disclosures must cover data categories and purposes, including name, email, user IDs, and other collected/shared data.

Decision:
- Firebase Auth, Firestore, Crashlytics, Storage, notifications, and future AdMob/Billing SDKs must be mapped before release.
- Do not claim "no data collected" if Firebase Auth or analytics/crash reporting are active.
- Treat the default Android release build and any monetization-enabled build as separate review cases because AdMob/Billing are disabled by default.

Acceptance criteria:
- [x] Data inventory table lists each SDK and data category. See `docs/lifequest-data-safety-inventory-20260519.md`.
- [x] Privacy policy draft matches current default Android Data safety inventory.
- [ ] Published privacy policy URL and Play Console Data safety answers are verified together before release.
- [ ] QA Preview public web version contains no personal credentials or private owner data.
- [x] AdMob remains disabled by default until Data safety and consent implications are updated.

## Current Monetization Direction

Release v1 should not sell "a game." It should sell sustained self-management.

Recommended sequence:

1. Free core loop: quests -> growth -> today state -> optional dungeon feedback.
2. Retention proof: weekly return, quest completion, focus timer completion, reward purchase.
3. Premium pilot: advanced reports, additional customization, theme/title packs, archive/export.
4. Ads: only optional rewarded ads after the core app is trusted, if used at all.

Immediate next implementation target:
- Make the free core loop clearer and reduce screen confusion before adding billing.
- Before enabling `LIFEQUEST_MONETIZATION_ENABLED`, finish Data safety, consent copy, premium entitlement copy, and release smoke tests.
