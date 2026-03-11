# Release Blockers Checklist

## Real values still required
- Pass ADMOB_REWARDED_AD_UNIT_ID at build time or replace the production ID fallback in lib/services/ad_service.dart.
- Run flutterfire configure for iOS/web and regenerate lib/firebase_options.dart if those platforms must ship.
- Replace placeholder package and bundle identifiers now set to com.example.*.
- Pass HOME_WIDGET_APP_GROUP_ID at build time and replace the remaining native Home Widget App Group placeholders.

## Files to update when real values are available
- lib/services/ad_service.dart
- lib/firebase_options.dart
- lib/main.dart
- ios/Flutter/AppConfig.xcconfig
- android/app/build.gradle.kts
- android/app/google-services.json
- android/app/src/main/kotlin/com/example/life_quest_final_v2/MainActivity.kt
- android/app/src/main/kotlin/com/example/life_quest_final_v2/LifeQuestWidgetReceiver.kt
- ios/Runner.xcodeproj/project.pbxproj
- ios/Runner/AppDelegate.swift
- ios/LifeQuestWidget/LifeQuestWidget.swift

## Build-time define example
- flutter build apk --dart-define=ADMOB_REWARDED_AD_UNIT_ID=<prod_id> --dart-define=HOME_WIDGET_APP_GROUP_ID=<group_id>

## Native config injection
- Android AdMob App ID is now injected through the Gradle property `ADMOB_ANDROID_APP_ID`.
- iOS AdMob App ID and Home Widget App Group are now read from `ios/Flutter/AppConfig.xcconfig`.

## Readiness script
- Run `bash scripts/check_release_readiness.sh` to verify whether placeholder values and missing release inputs still remain.

## Apply script
- Copy `scripts/release_values.example.env` to your own env file, fill the real values, then run:
- `set -a; source <your env file>; set +a; bash scripts/apply_release_values.sh`

## Notes
- Theme font declarations were removed because no NotoSansKR asset is present in the source tree.
- Notification schedules are now synchronized from the saved app state at runtime.
