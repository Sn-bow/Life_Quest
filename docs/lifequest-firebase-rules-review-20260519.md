# Life Quest Firebase Rules Review - 2026-05-19

This review aligns the repository Firebase rules with the Android privacy policy and Data safety inventory.

## Findings

| Area | Current evidence | Risk | Resolution |
| --- | --- | --- | --- |
| Firestore user document isolation | App reads/writes `users/{uid}` in `CharacterState`; local `firestore.rules` scopes access to owner UID | Owner isolation exists, but account deletion failed because `delete` was not allowed on `users/{uid}` | `firestore.rules` now allows owner `delete` for `users/{uid}` |
| Firestore `_meta` subcollection | `AdService` writes `users/{uid}/_meta/adServerTime` when monetization is enabled | Deleting only the parent `users/{uid}` document can leave known subcollection documents behind | `CharacterState.deleteAccount()` now deletes known `_meta/adServerTime` before deleting the parent user doc |
| Storage profile image | Signup uploads `users/{uid}/profile.jpg`; repo had no `storage.rules` | Production Storage access was not represented in repo rules, and account deletion did not delete the optional profile image | Added `storage.rules`, wired it in `firebase.json`, and delete `users/{uid}/profile.jpg` during account deletion |
| Default deny | Firestore already blocks all other paths | Storage had no repo-level equivalent | Storage now denies every path except owner-scoped profile image operations |

## Local Rule Scope

Firestore:
- `users/{uid}`: authenticated owner can read, create, update, delete.
- Update keeps the existing basic progress invariant: character gold must not be negative and character level must be at least 1 when `character` is present.
- `users/{uid}/_meta/{doc}`: authenticated owner can read/write.
- All other document paths are denied.

Storage:
- `users/{uid}/profile.jpg`: authenticated owner can read, create, update, delete.
- Uploads are limited to image content types under 2 MiB.
- All other object paths are denied.

## Remaining Release Checks

- Live Firebase project rules were deployed on 2026-05-20 KST:
  - `firebase deploy --only firestore:rules,storage --project life-quest-app-95eb9` released `firestore.rules`.
  - `firebase deploy --only storage --project life-quest-app-95eb9` released `storage.rules`.
- Smoke-test account deletion on an authenticated Android build with:
  - Firestore user document present.
  - Optional `users/{uid}/profile.jpg` present.
  - Optional `users/{uid}/_meta/adServerTime` present if monetization testing creates it.
- Confirm the account deletion flow still handles recent-login requirements from Firebase Authentication.
- Confirm failed deletion does not navigate away as if deletion succeeded.
- Current device smoke-test blocker: ADB detected `520034bafe9225db` as `unauthorized` on 2026-05-20 KST. USB debugging authorization or a usable emulator is required before testing the real authenticated deletion path.

## Decision

The repository now contains a coherent Firebase rules baseline for the current Android app, and those rules have been deployed to the live Firebase project. The app now keeps the user on the settings flow if deletion fails. Release is still blocked until account deletion is smoke-tested on a real authenticated Android build.
