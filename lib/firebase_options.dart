// Public Firebase client configuration. This is not a service-account key.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return android;
    }
    throw UnsupportedError('Firebase is configured only for the Android app.');
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBAeM1nqaiJywxOgzj8JPTcmHtr9wZItZs',
    appId: '1:61563760091:android:4f449ea668e5a19120cbfe',
    messagingSenderId: '61563760091',
    projectId: 'lifequest-crossing-2026',
  );
}
