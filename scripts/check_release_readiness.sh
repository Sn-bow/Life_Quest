#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

failures=0

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
check_file_exists "PRIVACY_POLICY.md" \
  "Repository privacy policy exists"
check_file_exists "docs/index.html" \
  "Public privacy/account-deletion page exists"
check_file_exists "docs/lifequest-play-console-submission-runbook-20260525.md" \
  "Play Console submission runbook exists"
check_file_exists "docs/lifequest-play-console-data-safety-draft-20260520.md" \
  "Play Console Data safety draft exists"
check_file_exists "docs/lifequest-play-store-listing-draft-20260520.md" \
  "Play Store listing draft exists"

if (( failures > 0 )); then
  printf '\nAndroid default release readiness check failed with %d issue(s).\n' "$failures"
  exit 1
fi

printf '\nAndroid default release readiness check passed.\n'
