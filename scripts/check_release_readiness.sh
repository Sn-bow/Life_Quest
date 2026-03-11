#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

failures=0

check_contains() {
  local file="$1"
  local pattern="$2"
  local message="$3"

  if rg -q --fixed-strings "$pattern" "$file"; then
    printf 'FAIL: %s\n' "$message"
    failures=$((failures + 1))
  else
    printf 'PASS: %s\n' "$message"
  fi
}

check_missing_file() {
  local file="$1"
  local message="$2"

  if [[ -f "$file" ]]; then
    printf 'PASS: %s\n' "$message"
  else
    printf 'FAIL: %s\n' "$message"
    failures=$((failures + 1))
  fi
}

printf 'Release readiness check for %s\n' "$ROOT_DIR"

check_contains "android/app/build.gradle.kts" "com.example.life_quest_final_v2" \
  "Android package ID is not left at the placeholder value"

check_contains "ios/Runner.xcodeproj/project.pbxproj" "com.example.lifeQuestFinalV2" \
  "iOS bundle ID is not left at the placeholder value"

check_contains "android/app/build.gradle.kts" "ca-app-pub-3940256099942544~3347511713" \
  "Android AdMob app ID is not left at the Google test value"

check_contains "ios/Flutter/AppConfig.xcconfig" "ca-app-pub-3940256099942544~1458002511" \
  "iOS AdMob app ID is not left at the Google test value"

check_contains "lib/services/ad_service.dart" "ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY" \
  "Rewarded ad unit fallback is not left at the placeholder value"

check_contains "ios/Flutter/AppConfig.xcconfig" "group.com.example.lifeQuestWidget" \
  "iOS Home Widget App Group is not left at the placeholder value"

check_contains "lib/firebase_options.dart" "run \`flutterfire configure\` to set up iOS Firebase support." \
  "iOS Firebase options are present in firebase_options.dart"

check_missing_file "ios/GoogleService-Info.plist" \
  "iOS GoogleService-Info.plist exists"

check_missing_file "android/key.properties" \
  "Android key.properties exists"

if [[ -d /Applications/Xcode.app ]]; then
  printf 'PASS: Full Xcode appears to be installed\n'
else
  printf 'FAIL: Full Xcode is not installed at /Applications/Xcode.app\n'
  failures=$((failures + 1))
fi

if (( failures > 0 )); then
  printf '\nRelease readiness check failed with %d issue(s).\n' "$failures"
  exit 1
fi

printf '\nRelease readiness check passed.\n'
