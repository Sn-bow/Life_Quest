# Life Quest Premium Bundle Plan - 2026-05-20

Scope: future Android production monetization. This is not enabled in the current default release build.

## Sources Checked

- Google Play Commerce: https://play.google.com/console/about/guides/play-commerce/
- Google Play subscriptions concepts: https://support.google.com/googleplay/android-developer/answer/12154973
- Google Play subscription setup and offer transparency: https://support.google.com/googleplay/android-developer/answer/140504
- Google Play Developer Program monetization policy: https://support.google.com/googleplay/android-developer/answer/16070163
- RevenueCat State of Subscription Apps 2026: https://www.revenuecat.com/state-of-subscription-apps-2026-shopping/

## Current Release Decision

Do not enable billing for the first public Android release.

The current app still needs retention proof, Android smoke testing, and Play Console Data safety verification. The production default remains:

- `LIFEQUEST_MONETIZATION_ENABLED=false`
- no Billing initialization
- no AdMob initialization
- no premium paywall

## First Paid Product

Product: `lifequest_premium`

Positioning: a self-management upgrade, not a donation and not a vague "support us" purchase.

Recommended Play Console structure:

| Object | ID | Type | Notes |
| --- | --- | --- | --- |
| Subscription product | `lifequest_premium` | `SUBS` | One clear premium tier |
| Base plan | `monthly-auto` | auto-renewing monthly | Default low-commitment plan |
| Base plan | `annual-auto` | auto-renewing yearly | Better value for retained users |
| Offer | `intro-7d` | optional trial/intro offer | Add only after onboarding and cancel-copy QA |

Draft Korea price anchors:

| Plan | Draft KRW | Why |
| --- | ---: | --- |
| Monthly | 4,900 KRW | Lower than broad global monthly medians; safer for an early Android-only Korean launch |
| Annual | 39,000 KRW | About 34% below twelve monthly payments; aligned with yearly habit value |

Do not ship a weekly subscription for v1. It does not match Life Quest's habit-building value cycle and creates cancellation pressure before the app proves long-term usefulness.

## One-Screen Entitlement List

Life Quest Premium should unlock only sustained, recurring value:

1. Advanced weekly/monthly reports with category balance, best days, and next-stat suggestions.
2. Long-term quest calendar and archive beyond the default recent history window.
3. Extra custom reward slots for real-life reward planning.
4. Premium themes/title frames that do not affect stats or combat power.
5. Export/share summary for personal review.

This list is intentionally short enough for one paywall screen.

## Free User Boundary

The following must remain free:

- quest creation and completion
- basic daily growth
- Today state summary
- focus timer
- first dungeon chapter
- card combat and card rewards
- basic reports
- account deletion and data deletion support path

Premium must not sell stat power, loot odds, required dungeon progress, or core habit completion.

## Ads Position

No interstitial ads for v1.

Rewarded ads may remain a later experiment only after the core app is trusted and only for explicit optional rewards. If ads are enabled later, the app needs a separate Data safety and consent review.

## Existing Code Impact

The current `PurchaseService.removeAdsId = remove_ads_4900` is not the release monetization model. Before enabling billing:

- replace or retire `remove_ads_4900`
- add `lifequest_premium` subscription product handling
- remove any "remove ads" primary value copy
- add entitlement state tests
- update Data safety for Billing purchase history
- verify server-side purchase validation is deployed and fails closed in release

## Revenue Gate Before Implementation

Billing can move from plan to implementation only after all of the following are true:

- 20+ external testers complete at least one full weekly loop.
- Core free loop smoke tests pass on Android.
- Data safety answers and privacy policy are updated for monetization-enabled builds.
- Paywall copy clearly states price, renewal period, cancellation path, and included benefits.
- Premium value can be explained without saying "support development."
