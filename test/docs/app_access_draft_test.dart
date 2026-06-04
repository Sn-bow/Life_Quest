import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Play Console App access draft', () {
    late String draft;
    late String loginScreen;
    late String signupScreen;

    setUpAll(() {
      draft = File(
        'docs/lifequest-play-console-app-access-draft-20260604.md',
      ).readAsStringSync();
      loginScreen = File('lib/screens/login_screen.dart').readAsStringSync();
      signupScreen = File('lib/screens/signup_screen.dart').readAsStringSync();
    });

    test('matches the shipped authentication paths', () {
      expect(loginScreen, contains('signInWithEmailAndPassword'));
      expect(signupScreen, contains('createUserWithEmailAndPassword'));
      expect(loginScreen, contains('GoogleSignIn'));
      expect(draft, contains('Email/password sign-in'));
      expect(draft, contains('Email/password sign-up'));
      expect(draft, contains('Google Sign-In'));
      expect(draft, contains('Sign-in method: Email and password'));
    });

    test('gives reviewer access instructions without committing secrets', () {
      expect(draft, contains('Play Console > Policy and programs'));
      expect(draft, contains('enter the dedicated reviewer email'));
      expect(draft, contains('enter the reviewer password'));
      expect(draft, contains('Do not commit reviewer'));
      expect(draft, contains('credential manager'));

      final forbiddenSecretPatterns = [
        RegExp(r'Password:\s*[^\n]*(?:@|[A-Za-z0-9]{12,})'),
        RegExp(r'Email:\s*[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'),
        RegExp(r'otp\s*:\s*\d+', caseSensitive: false),
        RegExp(r'2fa\s*:\s*\d+', caseSensitive: false),
      ];

      for (final pattern in forbiddenSecretPatterns) {
        expect(
          pattern.hasMatch(draft),
          isFalse,
          reason: 'App access draft must not commit reviewer credentials.',
        );
      }
    });

    test('keeps default release scope and review blockers explicit', () {
      expect(draft, contains('com.lifequest.app'));
      expect(draft, contains('default Android build'));
      expect(draft, contains('Ads and in-app purchases are disabled'));
      expect(
          draft, contains('Web QA Preview is not the production Android app'));
      expect(draft, contains('must remain active, reusable, and valid'));
      expect(draft, contains('must not require 2-Step Verification'));
      expect(draft, contains('separate disposable account for deletion tests'));
    });

    test('does not contain mojibake markers', () {
      const forbiddenMarkers = ['媛', '怨', '留', '�'];

      for (final marker in forbiddenMarkers) {
        expect(
          draft.contains(marker),
          isFalse,
          reason: 'App access draft contains mojibake marker: $marker',
        );
      }
    });
  });
}
