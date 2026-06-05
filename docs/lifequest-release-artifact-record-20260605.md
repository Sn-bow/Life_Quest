# Life Quest Release Artifact Record - 2026-06-05

Scope: default real Android release build for `com.lifequest.app`.

This record describes the local AAB built from the current source tree for
Play Console closed-testing preparation. The AAB itself lives under `build/`
and is intentionally not committed.

## Build Command

```text
cmd /c C:\dev\flutter\bin\flutter.bat build appbundle --release --no-pub
```

## Artifact

| Field | Value |
| --- | --- |
| Path | `build/app/outputs/bundle/release/app-release.aab` |
| Size | `159,415,691` bytes |
| Flutter version source | `pubspec.yaml` |
| App version | `1.0.1+2` |
| Android package | `com.lifequest.app` |
| Monetization scope | Default build; AdMob and Google Play Billing disabled unless explicit build flags are supplied |
| Merged manifest | Advertising ID, AdServices attribution/topics, Google Play Billing permissions, and Mobile Ads application components absent |

## Submission Notes

- Use this AAB family for Play Console closed testing only after the manual
  Firebase Console, Data safety, Health declaration, IARC, privacy URL, and
  screenshot checks are completed against the same default Android build.
- If any source, dependency, version, signing, Firebase, monetization, or
  manifest setting changes before upload, rebuild the AAB and update this
  record before submission.
