import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/config/cloud_config.dart';
import 'package:life_quest_final_v2/features/session/cloud_profile_registration.dart';
import 'package:life_quest_final_v2/features/session/session_gate.dart';
import 'package:life_quest_final_v2/features/session/session_state.dart';
import 'package:life_quest_final_v2/features/session/welcome_screen.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/screens/signup_screen.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/theme/quest_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _CountingAuth extends MockFirebaseAuth {
  int creations = 0;
  String? receivedPassword;
  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    ++creations;
    receivedPassword = password;
    return super.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}

class _UnavailableOnceFirestore extends FakeFirebaseFirestore {
  bool unavailable = true;
  @override
  Future<T> runTransaction<T>(
    TransactionHandler<T> handler, {
    Duration timeout = const Duration(seconds: 30),
    int maxAttempts = 5,
  }) {
    if (unavailable) {
      unavailable = false;
      throw FirebaseException(plugin: 'cloud_firestore', code: 'unavailable');
    }
    return super.runTransaction(
      handler,
      timeout: timeout,
      maxAttempts: maxAttempts,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('email signup has zero XP and no invented schedules or goals', () async {
    final auth = _CountingAuth();
    final db = FakeFirebaseFirestore();
    final registration = CloudProfileRegistration(auth: auth, firestore: db);
    await registration.finish(
      email: ' qa@example.test ',
      password: '  synthetic-password  ',
      name: '  QA Hunter  ',
      languageCode: 'ja',
    );
    final data = (await db.doc('users/${auth.currentUser!.uid}').get()).data()!;
    expect(auth.creations, 1);
    expect(auth.receivedPassword, '  synthetic-password  ');
    expect(data['character']['name'], 'QA Hunter');
    expect(data['character']['usesDefaultGuestName'], false);
    expect(data['character']['level'], 1);
    expect(data['character']['xp'], 0);
    expect(data['character']['maxXp'], CharacterState.xpRequiredForLevel(1));
    for (final key in [
      'dailyQuests',
      'weeklyQuests',
      'monthlyQuests',
      'yearlyQuests',
    ]) {
      expect(data[key], isEmpty);
    }
    expect(data['journeys']['runs'], isEmpty);
    expect(data['localeCode'], 'ja');
    expect(data['isNotificationEnabled'], false);
    expect(data.containsKey('accountKind'), false);
  });

  test('signup does not replace a different signed-in account', () async {
    final owner = MockUser(
      uid: 'existing-owner',
      email: 'existing@example.test',
    );
    final auth = MockFirebaseAuth(mockUser: owner, signedIn: true);
    final db = FakeFirebaseFirestore();
    final registration = CloudProfileRegistration(auth: auth, firestore: db);
    await expectLater(
      registration.finish(
        email: 'new@example.test',
        password: 'synthetic-password',
        name: 'New person',
        languageCode: 'en',
      ),
      throwsA(isA<StateError>()),
    );
    expect(auth.currentUser?.uid, 'existing-owner');
    expect((await db.collection('users').get()).docs, isEmpty);
  });

  test(
    'photo failure retries the created identity rather than creating it twice',
    () async {
      final auth = _CountingAuth();
      final db = FakeFirebaseFirestore();
      var attempts = 0;
      final registration = CloudProfileRegistration(
        auth: auth,
        firestore: db,
        uploadPhoto: (uid, photo) async {
          if (++attempts == 1) {
            throw const FileSystemException('Synthetic upload outage');
          }
          return 'https://example.test/qa-profile.jpg';
        },
      );
      Future<void> finish() => registration.finish(
        email: 'qa@example.test',
        password: 'synthetic-password',
        name: 'QA',
        languageCode: 'en',
        photo: File('/synthetic/qa-profile.jpg'),
      );
      await expectLater(finish(), throwsA(isA<FileSystemException>()));
      final uid = auth.currentUser!.uid;
      expect(registration.hasCreatedAccount, true);
      expect((await db.doc('users/$uid').get()).exists, false);
      await finish();
      expect(auth.currentUser!.uid, uid);
      expect(auth.creations, 1);
      expect(
        (await db.doc('users/$uid').get()).data()!['character']['photoUrl'],
        'https://example.test/qa-profile.jpg',
      );
    },
  );

  test(
    'finishing signup preserves any progress already saved by another task',
    () async {
      final auth = _CountingAuth();
      final db = FakeFirebaseFirestore();
      Map<String, dynamic>? before;
      final registration = CloudProfileRegistration(
        auth: auth,
        firestore: db,
        uploadPhoto: (uid, _) async {
          before = CharacterState.newCloudProfilePayload(
            auth.currentUser!,
            languageCode: 'en',
          );
          before!['character']['xp'] = 91.0;
          before!['character']['name'] = 'Existing record';
          before!['dailyQuests'] = [
            {'id': 'own-task', 'name': 'My chosen action'},
          ];
          before!['journeys'] = {
            'runs': [
              {'goal': 'My chosen goal', 'tool': 'My saved card'},
            ],
          };
          await db.doc('users/$uid').set(before!);
          return 'https://example.test/qa-profile.jpg';
        },
      );
      await registration.finish(
        email: 'qa@example.test',
        password: 'synthetic-password',
        name: 'Chosen name',
        languageCode: 'ja',
        photo: File('/synthetic/qa-profile.jpg'),
      );
      final after = (await db.doc('users/${auth.currentUser!.uid}').get())
          .data()!;
      expect(after['character']['name'], 'Chosen name');
      expect(after['character']['xp'], 91);
      expect(after['dailyQuests'], before!['dailyQuests']);
      expect(after['journeys'], before!['journeys']);
      expect(after['localeCode'], 'en');
      expect(after['isNotificationEnabled'], false);
    },
  );

  test(
    'Firestore failure can finish setup without another Auth creation',
    () async {
      final auth = _CountingAuth();
      final db = _UnavailableOnceFirestore();
      final registration = CloudProfileRegistration(auth: auth, firestore: db);
      Future<void> finish() => registration.finish(
        email: 'qa@example.test',
        password: 'synthetic-password',
        name: 'QA',
        languageCode: 'zh',
      );
      await expectLater(finish(), throwsA(isA<FirebaseException>()));
      final uid = auth.currentUser!.uid;
      await finish();
      expect(auth.creations, 1);
      expect(auth.currentUser!.uid, uid);
      expect((await db.doc('users/$uid').get()).exists, true);
    },
  );

  test('sign-out during photo upload stops profile writes', () async {
    final auth = _CountingAuth();
    final db = FakeFirebaseFirestore();
    final entered = Completer<void>(), release = Completer<String>();
    final registration = CloudProfileRegistration(
      auth: auth,
      firestore: db,
      uploadPhoto: (_, _) {
        entered.complete();
        return release.future;
      },
    );
    final finishing = registration.finish(
      email: 'qa@example.test',
      password: 'synthetic-password',
      name: 'QA',
      languageCode: 'en',
      photo: File('/synthetic/qa-profile.jpg'),
    );
    await entered.future;
    final uid = auth.currentUser!.uid;
    final failure = expectLater(finishing, throwsA(isA<StateError>()));
    await auth.signOut();
    release.complete('https://example.test/qa-profile.jpg');
    await failure;
    expect((await db.doc('users/$uid').get()).exists, false);
  });

  test(
    'a second submit cannot create another identity while setup is running',
    () async {
      final auth = _CountingAuth();
      final db = FakeFirebaseFirestore();
      final entered = Completer<void>(), release = Completer<String>();
      final registration = CloudProfileRegistration(
        auth: auth,
        firestore: db,
        uploadPhoto: (_, _) {
          entered.complete();
          return release.future;
        },
      );
      final first = registration.finish(
        email: 'qa@example.test',
        password: 'synthetic-password',
        name: 'QA',
        languageCode: 'en',
        photo: File('/synthetic/qa-profile.jpg'),
      );
      await entered.future;
      await expectLater(
        registration.finish(
          email: 'other@example.test',
          password: 'synthetic-password',
          name: 'Other',
          languageCode: 'en',
        ),
        throwsA(isA<StateError>()),
      );
      expect(auth.creations, 1);
      release.complete('https://example.test/qa-profile.jpg');
      await first;
    },
  );

  test('a retry cannot change the created account email', () async {
    final auth = _CountingAuth();
    final registration = CloudProfileRegistration(
      auth: auth,
      firestore: _UnavailableOnceFirestore(),
    );
    await expectLater(
      registration.finish(
        email: 'qa@example.test',
        password: 'synthetic-password',
        name: 'QA',
        languageCode: 'en',
      ),
      throwsA(isA<FirebaseException>()),
    );
    final uid = auth.currentUser!.uid;
    await expectLater(
      registration.finish(
        email: 'different@example.test',
        password: 'synthetic-password',
        name: 'QA',
        languageCode: 'en',
      ),
      throwsA(isA<StateError>()),
    );
    expect(auth.currentUser!.uid, uid);
    expect(auth.creations, 1);
  });

  test(
    'a server-owned purchase identity is never converted to a cloud profile',
    () async {
      final auth = _CountingAuth();
      final db = FakeFirebaseFirestore();
      final registration = CloudProfileRegistration(
        auth: auth,
        firestore: db,
        uploadPhoto: (uid, _) async {
          await db.doc('users/$uid').set({'accountKind': 'purchaseOnly'});
          return 'https://example.test/qa-profile.jpg';
        },
      );
      await expectLater(
        registration.finish(
          email: 'qa@example.test',
          password: 'synthetic-password',
          name: 'QA',
          languageCode: 'en',
          photo: File('/synthetic/qa-profile.jpg'),
        ),
        throwsA(isA<StateError>()),
      );
      expect((await db.doc('users/${auth.currentUser!.uid}').get()).data(), {
        'accountKind': 'purchaseOnly',
      });
    },
  );

  Future<void> showSignup(
    WidgetTester tester,
    SessionState session,
    CloudProfileRegistration registration,
    String language,
    Size size,
  ) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: session,
        child: MaterialApp(
          theme: QuestTheme.build(Brightness.dark),
          locale: Locale(language),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(2)),
            child: child!,
          ),
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                key: const ValueKey('open-signup'),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => SignUpScreen(registration: registration),
                  ),
                ),
                child: const Text('Open signup'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(const ValueKey('open-signup')));
    await tester.pumpAndSettle();
    for (final (index, value) in [
      (0, 'qa@example.test'),
      (1, 'QA Hunter'),
      (2, '  synthetic-password  '),
      (3, '  synthetic-password  '),
    ]) {
      final field = find.byType(TextFormField).at(index);
      await tester.ensureVisible(field);
      await tester.pumpAndSettle();
      await tester.enterText(field, value);
    }
    final l = AppLocalizations.of(tester.element(find.byType(SignUpScreen)))!;
    await tester.ensureVisible(find.text(l.signupButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l.signupButton));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  }

  for (final language in ['ko', 'en', 'ja', 'zh']) {
    for (final size in [const Size(320, 720), const Size(1280, 800)]) {
      testWidgets(
        'signup recovery remains usable at 200% text: $language $size',
        (tester) async {
          final auth = _CountingAuth();
          final db = _UnavailableOnceFirestore();
          final registration = CloudProfileRegistration(
            auth: auth,
            firestore: db,
          );
          final session = SessionState();
          await session.initialize();
          addTearDown(session.dispose);
          await showSignup(tester, session, registration, language, size);
          final l = AppLocalizations.of(
            tester.element(find.byType(SignUpScreen)),
          )!;
          expect(find.text(l.signupSetupPending), findsOneWidget);
          expect(session.cloudRegistrationPending, true);
          expect(auth.creations, 1);
          for (final index in [0, 2, 3]) {
            expect(
              tester
                  .widget<EditableText>(
                    find.descendant(
                      of: find.byType(TextFormField).at(index),
                      matching: find.byType(EditableText),
                    ),
                  )
                  .readOnly,
              true,
            );
          }
          await tester.ensureVisible(find.text(l.signupFinishSetup));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          await tester.tap(find.text(l.signupFinishSetup));
          await tester.pumpAndSettle();
          expect(find.byType(SignUpScreen), findsNothing);
          expect(session.cloudRegistrationPending, false);
          expect(auth.creations, 1);
          final saved = (await db.doc('users/${auth.currentUser!.uid}').get())
              .data()!;
          expect(saved['character']['name'], 'QA Hunter');
          expect(saved['dailyQuests'], isEmpty);
          expect(saved['localeCode'], language);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets(
    'back after interrupted signup signs out and releases the routing guard',
    (tester) async {
      final auth = _CountingAuth();
      final registration = CloudProfileRegistration(
        auth: auth,
        firestore: _UnavailableOnceFirestore(),
      );
      final session = SessionState();
      await session.initialize();
      addTearDown(session.dispose);
      await showSignup(
        tester,
        session,
        registration,
        'en',
        const Size(400, 800),
      );
      expect(session.cloudRegistrationPending, true);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(SignUpScreen), findsNothing);
      expect(auth.currentUser, isNull);
      expect(session.cloudRegistrationPending, false);
      expect(auth.creations, 1);
    },
  );

  testWidgets(
    'SessionGate does not load the signed-in profile while registration is incomplete',
    (tester) async {
      final auth = _CountingAuth();
      final session = SessionState();
      await session.initialize();
      final character = CharacterState(firestore: FakeFirebaseFirestore());
      addTearDown(session.dispose);
      addTearDown(character.dispose);
      session.setCloudRegistrationPending(true);
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: session),
            ChangeNotifierProvider.value(value: character),
          ],
          child: MaterialApp(
            locale: const Locale('en'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: SessionGate(auth: auth),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await auth.createUserWithEmailAndPassword(
        email: 'qa@example.test',
        password: 'synthetic-password',
      );
      await tester.pumpAndSettle();
      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(character.isDataLoaded, false);
      expect(tester.takeException(), isNull);
      await auth.signOut();
      session.setCloudRegistrationPending(false);
      await tester.pumpAndSettle();
      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
    skip: !kLifeQuestCloudEnabled,
  );
}
