# Life Quest · current App access preparation · 2026-10-06

Scope: `com.logian.lifequest`, 2.2.1+2018 Google Play candidate. The current owner-only internal installation is 2.2.0+2017 until the new artifact is posted. This is a review-preparation document, not a submitted Console entry. The June draft describes a historical `com.lifequest.app` build and is not current.

**REVIEW ACCESS NOT YET PREPARED.** Do not claim all features are unrestricted, or reuse the developer's personal Google login as review credentials. Core device features require no sign-in; optional cloud accounts and Complete content are restricted. A reviewer must be able to inspect the full app without purchasing or requesting support. The owner-only test-card evidence does not itself provide that access. External closed testing remains on hold.

## Actual paths

- Core device features require no sign-in. Open the app, choose a name, a focus and a small goal, then open the status window. The four routes' first seven missions, saved toolkit results and encrypted backup are free.
- Optional cloud profiles support Email/password sign-in, Email/password sign-up, and Google Sign-In from the welcome screen. They are separate from the device profile and are not required for ordinary free use. Signup waits for setup to finish; after a failed photo/profile save it can retry the same newly created identity. Back signs out without deleting that account.
- Purchase connection uses Google Sign-In and a server-verified Play entitlement. A pre-existing email cloud identity links Google to the same UID; a credential already belonging to a different Firebase identity must not be forcibly merged. Do not fabricate a purchase or weaken App Check to prepare review access.
- Complete content is restricted: later missions, new route goals, three paid looks, 30/90-day reports and exports. Existing user-created tools and records remain accessible after entitlement revocation.
- Ads are disabled. Cloud/Billing are enabled in the Google Play candidate; both are disabled in the default development build. The Web QA Preview is not the production Android app.

## Console preparation

Use Play Console > Policy and programs > App content > App access. Describe the free device path and the restricted features separately. Enter the dedicated reviewer email and enter the reviewer password **inside Play Console only**, once full access has actually been prepared and verified.

Prepared English guidance for the core path:

```text
1. Install and open Life Quest.
2. Create a device profile with a name, focus and goal; no login is required.
3. The first screen is the status window. Open Quests to accept a small mission.
4. Complete a mission and use Growth Record / Toolkit to revisit saved results.
5. Open Settings for encrypted backup, privacy and account controls.
6. Optional cloud profile: from the welcome screen choose Sign in.
   Sign-in method: Email and password
7. Full Complete review access: [PREPARATION REQUIRED; do not submit this placeholder].
```

The reviewer account must remain active, reusable, and valid regardless of location and must not require 2-Step Verification, OTP, SMS or a reset email during review. Use a separate disposable account for deletion tests; never delete the reusable reviewer account during QA.

Do not commit reviewer credentials, recovery codes, auth tokens or private Console information. Keep any reviewer password in Play Console or the developer's private credential manager. Confirm actual native access to every paid area before submitting App access; public samples are not assumed to satisfy full reviewer access.

## Primary sources checked 2026-10-06

- [Google Play review sign-in requirements](https://support.google.com/googleplay/android-developer/answer/15748846?hl=en): reusable access and instructions for all restricted functions, including Google sign-in and freely accessible paywalled content. The developer's personal Google account is not prepared as a reusable review account.
- [Prepare app review](https://support.google.com/googleplay/android-developer/answer/9859455): the earlier official preparation reference; this session's fetch timed out, so no new inference is attributed to that page.
