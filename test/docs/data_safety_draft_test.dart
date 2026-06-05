import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Play Console Data safety draft', () {
    late String draft;
    late String inventory;
    late String manifest;
    late String releaseManifest;
    late String monetizationManifest;
    late String buildGradle;
    late String monetizationConfig;
    late String pubspec;

    setUpAll(() {
      draft = File(
        'docs/lifequest-play-console-data-safety-draft-20260520.md',
      ).readAsStringSync();
      inventory = File(
        'docs/lifequest-data-safety-inventory-20260519.md',
      ).readAsStringSync();
      manifest =
          File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
      releaseManifest = File('android/app/src/release/AndroidManifest.xml')
          .readAsStringSync();
      monetizationManifest = File(
        'android/app/src/monetization/AndroidManifest.xml',
      ).readAsStringSync();
      buildGradle = File('android/app/build.gradle.kts').readAsStringSync();
      monetizationConfig = File(
        'lib/config/monetization_config.dart',
      ).readAsStringSync();
      pubspec = File('pubspec.yaml').readAsStringSync();
    });

    test('keeps default Android release scope explicit', () {
      expect(draft, contains('default real Android release build'));
      expect(draft, contains('LIFEQUEST_MONETIZATION_ENABLED=false'));
      expect(
        draft,
        contains('AdMob and Google Play Billing SDK startup disabled'),
      );
      expect(draft, contains('No configured AdMob App ID'));
      expect(draft, contains('No Health Connect'));
      expect(draft, contains('Web QA Preview is excluded'));
      expect(
        draft,
        contains('If monetization is enabled later, this draft is invalid'),
      );
    });

    test('matches repository monetization and analytics evidence', () {
      expect(monetizationConfig, contains('LIFEQUEST_MONETIZATION_ENABLED'));
      expect(buildGradle, contains('.gradleProperty("ADMOB_ANDROID_APP_ID")'));
      expect(buildGradle, contains('.orElse("")'));
      expect(
        buildGradle,
        contains('manifest.srcFile(releaseManifestPath)'),
      );
      expect(releaseManifest, contains('tools:node="remove"'));
      expect(
        releaseManifest,
        contains('com.google.android.gms.permission.AD_ID'),
      );
      expect(
        releaseManifest,
        contains('android.permission.ACCESS_ADSERVICES_AD_ID'),
      );
      expect(
        releaseManifest,
        contains('android.permission.ACCESS_ADSERVICES_ATTRIBUTION'),
      );
      expect(
        releaseManifest,
        contains('android.permission.ACCESS_ADSERVICES_TOPICS'),
      );
      expect(releaseManifest, contains('com.android.vending.BILLING'));
      expect(
        monetizationManifest,
        isNot(contains('tools:node="remove"')),
      );
      expect(pubspec, contains('google_mobile_ads:'));
      expect(pubspec, contains('in_app_purchase:'));
      expect(pubspec, isNot(contains('firebase_analytics:')));
      expect(
        draft,
        contains('Advertising ID / ad interactions: AdMob startup'),
      );
      expect(draft, contains('Financial info / Purchase history'));
    });

    test('does not contain mojibake or active unsupported data claims', () {
      const forbiddenMarkers = [
        '媛',
        '怨',
        '留',
        '�',
        'Firebase Analytics is enabled',
        'AdMob is enabled in the default build',
        'Google Play Billing is enabled in the default build',
        'Health Connect data is collected',
        'Google Fit data is collected',
        'fitness sensor data is collected',
        'remote AI feature is enabled',
      ];

      for (final marker in forbiddenMarkers) {
        expect(
          draft.contains(marker) || inventory.contains(marker),
          isFalse,
          reason: 'Data safety docs contain forbidden marker or claim: $marker',
        );
      }
    });

    test('keeps unselected data categories aligned with manifest', () {
      const forbiddenPermissions = [
        'android.permission.ACCESS_FINE_LOCATION',
        'android.permission.ACCESS_COARSE_LOCATION',
        'android.permission.CAMERA',
        'android.permission.RECORD_AUDIO',
        'android.permission.READ_CONTACTS',
        'android.permission.READ_CALENDAR',
        'android.permission.READ_SMS',
        'android.permission.QUERY_ALL_PACKAGES',
      ];

      for (final permission in forbiddenPermissions) {
        expect(
          manifest,
          isNot(contains(permission)),
          reason: 'Manifest permission would require Data safety re-review.',
        );
      }

      expect(
          draft, contains('Location: no location permission or app code path'));
      expect(draft, contains('Health and fitness: no Health Connect'));
      expect(draft, contains('Messages, contacts, calendar, audio'));
      expect(
        draft,
        contains('Advertising ID / ad interactions: AdMob startup'),
      );
      expect(
        draft,
        contains(
          'final merged release manifest excludes advertising and billing',
        ),
      );
    });
  });
}
