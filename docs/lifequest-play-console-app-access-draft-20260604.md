# Life Quest Play Console App Access Draft - 2026-06-04

Scope: default real Android release or closed-testing build for
`com.lifequest.app`.

This draft prepares the Play Console App access entry. Do not commit reviewer
passwords, Google account recovery details, one-time codes, or private console
credentials to the repository.

## Official References

- Google Play app review preparation:
  https://support.google.com/googleplay/android-developer/answer/9859455
- Google Play login credential requirements:
  https://support.google.com/googleplay/android-developer/answer/15748846

## Why App Access Is Required

The default Android app uses Firebase Authentication and routes reviewers
through the login/sign-up flow before synced progress, quests, settings,
dungeon play, account deletion, and profile data can be reviewed.

The app supports:

- Email/password sign-in.
- Email/password sign-up.
- Google Sign-In.

For Play review, provide a reusable email/password reviewer account in Play
Console App access. Do not require Google Sign-In, two-step verification, a
one-time password, a location-specific password, or private support contact to
access the app.

## Play Console Entry Draft

Use this content in Play Console > Policy and programs > App content > App
access. Add the actual reviewer email and password only inside Play Console.

```text
Access type: Login credentials are required.

Reviewer account:
- Sign-in method: Email and password
- Email: enter the dedicated reviewer email in Play Console only
- Password: enter the reviewer password in Play Console only

Instructions:
1. Install and open the Android app.
2. On the Life Quest login screen, enter the reviewer email and password.
3. Tap Login.
4. If onboarding appears, complete it with the default choices.
5. Use the Today screen to view or complete quests.
6. Open dungeon/Soul Deck screens to review card battle gameplay.
7. Open Settings to review privacy, account deletion, and logout paths.

Notes:
- Do not use Google Sign-In for review unless explicitly needed.
- The reviewer account must remain active, reusable, and valid regardless of
  reviewer location.
- The reviewer account must not require 2-Step Verification, OTP, SMS, email
  code, or password reset during review.
- Ads and in-app purchases are disabled in the default Android build.
- The Web QA Preview is not the production Android app and should not be used
  as Play review access evidence.
```

## Reviewer Account Preparation Checklist

Before closed testing submission:

- Create a dedicated Firebase Auth email/password account for Play review.
- Sign in once on the default Android build and complete onboarding.
- Leave enough sample progress for reviewers to inspect:
  - Today/quest screen.
  - Growth/profile state.
  - Dungeon entry.
  - Soul Deck card battle.
  - Settings/privacy/account deletion path.
- Confirm account deletion is not accidentally run on the reviewer account
  during smoke testing. Use a separate disposable account for deletion tests.
- Store the reviewer password only in Play Console or the developer's private
  credential manager, not in git, docs, screenshots, logs, or issue comments.

## Re-Review Triggers

Update this draft before submission if:

- The app adds mandatory Google Sign-In.
- The app adds MFA, OTP, SMS, email-code, invitation-code, geo-gated, or
  subscription-gated access.
- The app enables paid access, ads, or subscription-only content.
- The reviewer account is deleted, disabled, or its password changes.
