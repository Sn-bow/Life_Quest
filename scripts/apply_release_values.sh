#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

required_vars=(
  ANDROID_PACKAGE_ID
  IOS_BUNDLE_ID
  ADMOB_ANDROID_APP_ID
  ADMOB_IOS_APP_ID
  ADMOB_REWARDED_AD_UNIT_ID
  HOME_WIDGET_APP_GROUP_ID
)

for var_name in "${required_vars[@]}"; do
  if [[ -z "${!var_name:-}" ]]; then
    printf 'Missing required environment variable: %s\n' "$var_name" >&2
    exit 1
  fi
done

IOS_RUNNER_TESTS_BUNDLE_ID="${IOS_RUNNER_TESTS_BUNDLE_ID:-${IOS_BUNDLE_ID}.RunnerTests}"
APP_VERSION="${APP_VERSION:-}"
APP_BUILD_NUMBER="${APP_BUILD_NUMBER:-}"

CURRENT_ANDROID_PACKAGE_ID="com.example.life_quest_final_v2"
CURRENT_IOS_BUNDLE_ID="com.example.lifeQuestFinalV2"
CURRENT_IOS_TEST_BUNDLE_ID="${CURRENT_IOS_BUNDLE_ID}.RunnerTests"
CURRENT_APP_GROUP_ID="group.com.example.lifeQuestWidget"
CURRENT_ADMOB_ANDROID_APP_ID="ca-app-pub-3940256099942544~3347511713"
CURRENT_ADMOB_IOS_APP_ID="ca-app-pub-3940256099942544~1458002511"
CURRENT_ADMOB_REWARDED_AD_UNIT_ID="ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY"

replace_fixed() {
  local file="$1"
  local from="$2"
  local to="$3"
  perl -0pi -e "s/\Q$from\E/$to/g" "$file"
}

replace_regex() {
  local file="$1"
  local pattern="$2"
  local replacement="$3"
  perl -0pi -e "s/$pattern/$replacement/g" "$file"
}

replace_fixed "android/app/build.gradle.kts" "$CURRENT_ANDROID_PACKAGE_ID" "$ANDROID_PACKAGE_ID"
replace_fixed "android/app/google-services.json" "$CURRENT_ANDROID_PACKAGE_ID" "$ANDROID_PACKAGE_ID"
replace_fixed "ios/Runner.xcodeproj/project.pbxproj" "$CURRENT_IOS_TEST_BUNDLE_ID" "$IOS_RUNNER_TESTS_BUNDLE_ID"
replace_fixed "ios/Runner.xcodeproj/project.pbxproj" "$CURRENT_IOS_BUNDLE_ID" "$IOS_BUNDLE_ID"
replace_fixed "android/app/build.gradle.kts" "$CURRENT_ADMOB_ANDROID_APP_ID" "$ADMOB_ANDROID_APP_ID"
replace_fixed "ios/Flutter/AppConfig.xcconfig" "$CURRENT_ADMOB_IOS_APP_ID" "$ADMOB_IOS_APP_ID"
replace_fixed "ios/Flutter/AppConfig.xcconfig" "$CURRENT_APP_GROUP_ID" "$HOME_WIDGET_APP_GROUP_ID"
replace_fixed "lib/main.dart" "$CURRENT_APP_GROUP_ID" "$HOME_WIDGET_APP_GROUP_ID"
replace_fixed "ios/Runner/AppDelegate.swift" "$CURRENT_APP_GROUP_ID" "$HOME_WIDGET_APP_GROUP_ID"
replace_fixed "ios/LifeQuestWidget/LifeQuestWidget.swift" "$CURRENT_APP_GROUP_ID" "$HOME_WIDGET_APP_GROUP_ID"
replace_fixed "lib/services/ad_service.dart" "$CURRENT_ADMOB_REWARDED_AD_UNIT_ID" "$ADMOB_REWARDED_AD_UNIT_ID"

if [[ -n "$APP_VERSION" && -n "$APP_BUILD_NUMBER" ]]; then
  replace_regex "pubspec.yaml" 'version: [^\n]+' "version: ${APP_VERSION}+${APP_BUILD_NUMBER}"
fi

android_package_dir="android/app/src/main/kotlin/${CURRENT_ANDROID_PACKAGE_ID//./\/}"
new_android_package_dir="android/app/src/main/kotlin/${ANDROID_PACKAGE_ID//./\/}"
mkdir -p "$new_android_package_dir"

for file in "$android_package_dir"/*.kt; do
  [[ -f "$file" ]] || continue
  filename="$(basename "$file")"
  replace_fixed "$file" "$CURRENT_ANDROID_PACKAGE_ID" "$ANDROID_PACKAGE_ID"
  mv "$file" "$new_android_package_dir/$filename"
done

current_dir="$android_package_dir"
while [[ "$current_dir" != "android/app/src/main/kotlin" ]]; do
  rmdir "$current_dir" 2>/dev/null || true
  current_dir="$(dirname "$current_dir")"
done

printf 'Applied release values.\n'
printf 'Next steps:\n'
printf '  1. Replace android/app/google-services.json with the file matching %s\n' "$ANDROID_PACKAGE_ID"
printf '  2. Add ios/GoogleService-Info.plist matching %s\n' "$IOS_BUNDLE_ID"
printf '  3. Create android/key.properties and provide the release keystore\n'
printf '  4. Run bash scripts/check_release_readiness.sh\n'

