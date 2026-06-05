#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

failures=0
merged_release_manifest="build/app/intermediates/merged_manifests/release/processReleaseManifest/AndroidManifest.xml"

pass() {
  printf 'PASS: %s\n' "$1"
}

fail() {
  printf 'FAIL: %s\n' "$1"
  failures=$((failures + 1))
}

check_file_exists() {
  local file="$1"
  local message="$2"

  if [[ -f "$file" ]]; then
    pass "$message"
  else
    fail "$message"
  fi
}

check_file_min_bytes() {
  local file="$1"
  local min_bytes="$2"
  local message="$3"
  local size

  if [[ ! -f "$file" ]]; then
    fail "$message"
    return
  fi

  size="$(wc -c < "$file" | tr -d '[:space:]')"
  if [[ "$size" =~ ^[0-9]+$ ]] && (( size >= min_bytes )); then
    pass "$message"
  else
    fail "$message"
    printf '  %s is %s bytes; expected at least %s bytes.\n' \
      "$file" "${size:-unknown}" "$min_bytes"
  fi
}

check_contains() {
  local file="$1"
  local pattern="$2"
  local message="$3"

  if [[ -f "$file" ]] && grep -Fq -- "$pattern" "$file"; then
    pass "$message"
  else
    fail "$message"
  fi
}

check_not_contains() {
  local file="$1"
  local pattern="$2"
  local message="$3"

  if [[ -f "$file" ]] && grep -Fq -- "$pattern" "$file"; then
    fail "$message"
  else
    pass "$message"
  fi
}

check_no_prod_admob_ids_outside_docs() {
  local message="Default Android source has no production AdMob publisher IDs"
  local matches

  matches="$(
    grep -R -n --include='*.dart' --include='*.kt' --include='*.kts' \
      --include='*.xml' --include='*.yaml' -- "ca-app-pub-" \
      android lib pubspec.yaml 2>/dev/null \
      | grep -v '^lib/services/ad_service.dart:' || true
  )"

  if [[ -z "$matches" ]]; then
    pass "$message"
  else
    fail "$message"
    printf '%s\n' "$matches"
  fi
}

printf 'Android default release readiness check for %s\n' "$ROOT_DIR"
printf 'Scope: com.lifequest.app default build, monetization disabled unless explicitly enabled.\n\n'

check_contains "android/app/build.gradle.kts" 'namespace = "com.lifequest.app"' \
  "Android namespace is com.lifequest.app"
check_contains "android/app/build.gradle.kts" 'applicationId = "com.lifequest.app"' \
  "Android applicationId is com.lifequest.app"
check_contains "android/app/google-services.json" '"package_name": "com.lifequest.app"' \
  "google-services.json is bound to com.lifequest.app"
check_not_contains "android/app/build.gradle.kts" "com.example.life_quest_final_v2" \
  "Android package ID is not left at the old placeholder"

check_contains "android/app/build.gradle.kts" "compileSdk = 36" \
  "compileSdk remains at the documented release baseline"
check_contains "android/app/build.gradle.kts" "targetSdk = 35" \
  "targetSdk satisfies the documented Google Play API 35 baseline"
check_contains "android/app/build.gradle.kts" "isMinifyEnabled = true" \
  "Release minify is enabled"
check_contains "android/app/build.gradle.kts" "isShrinkResources = true" \
  "Release resource shrinking is enabled"
check_contains "android/app/build.gradle.kts" "Missing android/key.properties for release signing" \
  "Release signing fails closed when key.properties is missing"
check_not_contains "android/app/build.gradle.kts" 'signingConfigs.getByName("debug")' \
  "Release builds do not fall back to debug signing"

check_contains "lib/config/monetization_config.dart" "LIFEQUEST_MONETIZATION_ENABLED" \
  "Monetization gate exists"
check_contains "android/app/build.gradle.kts" '.gradleProperty("ADMOB_ANDROID_APP_ID")' \
  "AdMob App ID is externally injected only when needed"
check_contains "android/app/build.gradle.kts" '.orElse("")' \
  "Default Android AdMob App ID placeholder is empty"
check_contains "android/app/src/main/AndroidManifest.xml" 'android:value="${admobAppId}"' \
  "Android manifest uses the injected AdMob placeholder"
check_contains "lib/services/ad_service.dart" "ADMOB_REWARDED_AD_UNIT_ID_ANDROID" \
  "Rewarded ad unit is injected through dart-define"
check_no_prod_admob_ids_outside_docs
check_contains "lib/services/purchase_service.dart" "shouldAcceptUnverifiedPurchase" \
  "Purchase verification has an explicit unverified-purchase policy"
check_contains "lib/services/purchase_service.dart" "Purchase verification rejected." \
  "Purchase verification errors are rejected"
check_not_contains "lib/services/purchase_service.dart" "Falling back to local verification" \
  "Purchase verification does not fall back to local acceptance"
check_not_contains "lib/services/purchase_service.dart" "Verification error: \$e. Falling back." \
  "Generic purchase verification errors do not fall back"
check_file_exists "test/services/purchase_verification_policy_test.dart" \
  "Purchase verification policy test exists"

check_file_exists "android/key.properties" \
  "Android release signing key.properties exists"
check_file_min_bytes "build/app/outputs/bundle/release/app-release.aab" 104857600 \
  "Current release AAB exists and is at least 100 MiB"
check_file_exists "$merged_release_manifest" \
  "Merged release manifest exists"
check_not_contains "$merged_release_manifest" 'com.google.android.gms.permission.AD_ID' \
  "Default merged release manifest excludes Google advertising ID permission"
check_not_contains "$merged_release_manifest" 'android.permission.ACCESS_ADSERVICES_AD_ID' \
  "Default merged release manifest excludes AdServices advertising ID permission"
check_not_contains "$merged_release_manifest" 'android.permission.ACCESS_ADSERVICES_ATTRIBUTION' \
  "Default merged release manifest excludes AdServices attribution permission"
check_not_contains "$merged_release_manifest" 'android.permission.ACCESS_ADSERVICES_TOPICS' \
  "Default merged release manifest excludes AdServices topics permission"
check_not_contains "$merged_release_manifest" 'com.android.vending.BILLING' \
  "Default merged release manifest excludes Google Play Billing permission"
check_contains "android/app/src/main/AndroidManifest.xml" 'android.permission.INTERNET' \
  "Android manifest declares only expected network access"
check_contains "android/app/src/main/AndroidManifest.xml" 'android.permission.POST_NOTIFICATIONS' \
  "Android manifest declares notification permission explicitly"
check_not_contains "android/app/src/main/AndroidManifest.xml" 'android.permission.WAKE_LOCK' \
  "Android manifest does not request wake lock permission"
check_not_contains "android/app/src/main/AndroidManifest.xml" 'android.permission.QUERY_ALL_PACKAGES' \
  "Android manifest does not request broad package visibility"
check_not_contains "android/app/src/main/AndroidManifest.xml" 'android:debuggable="true"' \
  "Android release manifest is not marked debuggable"
check_not_contains "android/app/src/main/AndroidManifest.xml" 'android:testOnly="true"' \
  "Android release manifest is not marked testOnly"
check_not_contains "android/app/src/main/AndroidManifest.xml" 'android:usesCleartextTraffic="true"' \
  "Android release manifest does not allow cleartext traffic globally"
check_contains "pubspec.yaml" "firebase_crashlytics:" \
  "Crashlytics dependency is declared"
check_contains "android/app/build.gradle.kts" 'id("com.google.firebase.crashlytics")' \
  "Crashlytics Gradle plugin is applied"
check_contains "lib/main.dart" "runZonedGuarded" \
  "App startup is wrapped in runZonedGuarded"
check_contains "lib/main.dart" "FlutterError.onError" \
  "Flutter framework errors are hooked"
check_contains "lib/main.dart" "recordFlutterFatalError" \
  "Flutter fatal errors are sent to Crashlytics"
check_contains "lib/main.dart" "recordError(error, stack, fatal: true)" \
  "Uncaught zone errors are sent to Crashlytics"
check_contains "lib/main.dart" "recordError(" \
  "Startup task failures are recorded as non-fatal errors"
check_file_exists "lib/screens/onboarding_screen.dart" \
  "First-run onboarding screen exists"
check_contains "lib/screens/loading_screen.dart" "hasSeenOnboarding" \
  "Authenticated startup routes unseen users to onboarding"
check_contains "lib/screens/onboarding_screen.dart" "completeOnboarding" \
  "Onboarding completion is persisted through CharacterState"
check_contains "lib/l10n/app_ko.arb" "onboardingPage1Title" \
  "Korean onboarding copy exists"
check_contains "lib/l10n/app_en.arb" "onboardingPage1Title" \
  "English onboarding copy exists"
check_contains "test/state/character_state_test.dart" "completeOnboarding marks onboarding as seen" \
  "Onboarding completion policy test exists"
check_contains "lib/screens/dungeon/card_battle_screen.dart" "_SoulDeckBattleTutorialOverlay" \
  "Soul Deck battle tutorial overlay exists"
check_contains "lib/screens/dungeon/card_battle_screen.dart" "soulDeckBattleTutorialSeen" \
  "Soul Deck battle tutorial is gated by persisted state"
check_contains "lib/utils/shared_pref_keys.dart" "soulDeckBattleTutorialSeen" \
  "Soul Deck tutorial persistence key exists"
check_contains "test/utils/shared_pref_keys_test.dart" "soul_deck_battle_tutorial_seen" \
  "Soul Deck tutorial persistence key test exists"
check_contains "test/balance/soul_deck_balance_smoke_test.dart" "starter deck clears every Zone 1 monster" \
  "Soul Deck starter balance smoke test exists"
check_contains "test/balance/monster_balance_smoke_test.dart" "dungeon boss progression does not drop in threat" \
  "Monster balance smoke test exists"
check_contains "test/data/pubspec_asset_directories_test.dart" "all declared directory assets exist on disk" \
  "Pubspec asset directory test exists"
check_contains "test/docs/public_policy_page_test.dart" "does not contain common mojibake markers" \
  "Public policy page encoding test exists"
check_contains "firebase.json" '"rules": "firestore.rules"' \
  "Firebase config wires Firestore rules"
check_contains "firebase.json" '"rules": "storage.rules"' \
  "Firebase config wires Storage rules"
check_contains "firestore.rules" "allow read, write: if false;" \
  "Firestore rules deny unmatched paths"
check_contains "storage.rules" "allow read, write: if false;" \
  "Storage rules deny unmatched paths"
check_file_exists "PRIVACY_POLICY.md" \
  "Repository privacy policy exists"
check_file_exists "docs/index.html" \
  "Public privacy/account-deletion page exists"
check_file_exists "docs/lifequest-play-console-submission-runbook-20260525.md" \
  "Play Console submission runbook exists"
check_contains "docs/lifequest-release-artifact-record-20260605.md" "flutter.bat build appbundle --release --no-pub" \
  "Release AAB artifact record exists"
check_contains "docs/lifequest-android-device-smoke-runbook-20260604.md" "Default Monetization-Off Behavior" \
  "Android device smoke runbook exists"
check_contains "test/docs/app_access_draft_test.dart" "matches the shipped authentication paths" \
  "Play Console App access draft policy test exists"
check_contains "test/docs/iarc_draft_test.dart" "discloses randomized equipment boxes" \
  "Play Console IARC draft policy test exists"
check_file_exists "docs/lifequest-play-console-data-safety-draft-20260520.md" \
  "Play Console Data safety draft exists"
check_contains "test/docs/data_safety_draft_test.dart" "keeps default Android release scope explicit" \
  "Play Console Data safety draft policy test exists"
check_file_exists "docs/lifequest-play-store-listing-draft-20260520.md" \
  "Play Store listing draft exists"
check_contains "test/docs/play_store_listing_draft_test.dart" "does not contain mojibake" \
  "Play Store listing draft policy test exists"

if (( failures > 0 )); then
  printf '\nAndroid default release readiness check failed with %d issue(s).\n' "$failures"
  exit 1
fi

printf '\nAndroid default release readiness check passed.\n'
