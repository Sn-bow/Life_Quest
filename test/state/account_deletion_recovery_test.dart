import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';
import 'package:life_quest_final_v2/features/session/account_deletion_journal.dart';
import 'package:life_quest_final_v2/features/session/account_deletion_gate.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/theme/quest_theme.dart';

class DeletionFaultStore extends InMemorySharedPreferencesStore {
  DeletionFaultStore() : super.empty();
  String? rejectedValue;
  String? rejectedRemoval;
  bool rejectReads = false;
  @override
  Future<Map<String, Object>> getAllWithParameters(
    GetAllParameters parameters,
  ) {
    if (rejectReads) throw StateError('Synthetic storage failure');
    return super.getAllWithParameters(parameters);
  }

  @override
  Future<bool> setValue(String type, String key, Object value) async {
    if (value == rejectedValue) return false;
    return super.setValue(type, key, value);
  }

  @override
  Future<bool> remove(String key) async {
    if (key == rejectedRemoval) return false;
    return super.remove(key);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SoundService.muteForTesting();
  setUp(
    () => SharedPreferences.setMockInitialValues({
      'lifequest.director.v1.alice': 'Alice history',
      'lifequest.purchases.v1.alice': ['theme_royal_gold'],
      'lifequest.director.v1.bob': 'Bob history',
      'lifequest.local.state.v1': 'Independent device progress',
    }),
  );

  test('guard is durable before a request can reach the server', () async {
    final state = CharacterState(
      deleteAccountUidOverride: 'alice',
      requestAccountDeletionOverride: (_) async {
        expect(
          await AccountDeletionJournal.read('alice'),
          AccountDeletionPhase.requesting,
        );
        return false;
      },
    );
    expect(await state.deleteAccount(), false);
    expect(await AccountDeletionJournal.read('alice'), isNull);
    expect(state.pendingDeletionUid, isNull);
    state.dispose();
  });

  test('failed guard write sends no deletion request', () async {
    final store = DeletionFaultStore()..rejectedValue = 'requesting';
    SharedPreferencesStorePlatform.instance = store;
    var requested = false;
    final state = CharacterState(
      deleteAccountUidOverride: 'alice',
      requestAccountDeletionOverride: (_) async {
        requested = true;
        return true;
      },
    );
    expect(await state.deleteAccount(), false);
    expect(requested, false);
    expect(await AccountDeletionJournal.read('alice'), isNull);
    state.dispose();
  });

  test('a lost response remains quarantined across restart', () async {
    final state = CharacterState(
      deleteAccountUidOverride: 'alice',
      requestAccountDeletionOverride: (_) async =>
          throw TimeoutException('Synthetic'),
      signOutAfterDeletionOverride: () async => fail('Not confirmed'),
    );
    expect(await state.deleteAccount(), false);
    expect(state.pendingDeletionUid, 'alice');
    expect(state.accountDeletionAccepted, false);
    state.dispose();
    expect(
      await AccountDeletionJournal.read('alice'),
      AccountDeletionPhase.requesting,
    );
    expect(await AccountDeletionJournal.read('bob'), isNull);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('lifequest.director.v1.alice'), 'Alice history');
  });

  test(
    'accepted request stays accepted after sign-out failure and local retry is scoped',
    () async {
      var requests = 0;
      final state = CharacterState(
        deleteAccountUidOverride: 'alice',
        requestAccountDeletionOverride: (_) async {
          requests++;
          return true;
        },
        signOutAfterDeletionOverride: () async => throw StateError('Synthetic'),
      );
      expect(await state.deleteAccount(), true);
      expect(state.pendingDeletionUid, 'alice');
      expect(state.accountDeletionAccepted, true);
      expect(
        await AccountDeletionJournal.read('alice'),
        AccountDeletionPhase.accepted,
      );
      var signedOut = false;
      await AccountDeletionJournal.finishLocalCleanup(
        'alice',
        signOut: () async {
          signedOut = true;
        },
      );
      state.forgetFinishedDeletion('alice');
      expect(signedOut, true);
      expect(requests, 1);
      expect(state.pendingDeletionUid, isNull);
      expect(await AccountDeletionJournal.read('alice'), isNull);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey('lifequest.director.v1.alice'), false);
      expect(prefs.getString('lifequest.director.v1.bob'), 'Bob history');
      expect(
        prefs.getString('lifequest.local.state.v1'),
        'Independent device progress',
      );
      state.dispose();
    },
  );

  test(
    'failure to persist acceptance does not erase the pre-request guard',
    () async {
      final store = DeletionFaultStore()..rejectedValue = 'accepted';
      SharedPreferencesStorePlatform.instance = store;
      final state = CharacterState(
        deleteAccountUidOverride: 'alice',
        requestAccountDeletionOverride: (_) async => true,
        signOutAfterDeletionOverride: () async => fail('Receipt write failed'),
      );
      expect(await state.deleteAccount(), true);
      expect(state.accountDeletionAccepted, true);
      expect(
        await AccountDeletionJournal.read('alice'),
        AccountDeletionPhase.requesting,
      );
      state.dispose();
    },
  );

  test(
    'failed cache removal cannot be reported as finished or clear the guard',
    () async {
      final store = DeletionFaultStore()
        ..rejectedRemoval = 'flutter.lifequest.director.v1.alice';
      SharedPreferencesStorePlatform.instance = store;
      var signedOut = false;
      final state = CharacterState(
        deleteAccountUidOverride: 'alice',
        requestAccountDeletionOverride: (_) async => true,
        signOutAfterDeletionOverride: () async {
          signedOut = true;
        },
      );
      expect(await state.deleteAccount(), true);
      expect(signedOut, false);
      expect(state.pendingDeletionUid, 'alice');
      expect(
        await AccountDeletionJournal.read('alice'),
        AccountDeletionPhase.accepted,
      );
      state.dispose();
    },
  );

  test('failed guard removal remains recoverable after sign-out', () async {
    final store = DeletionFaultStore()
      ..rejectedRemoval = 'flutter.${AccountDeletionJournal.key('alice')}';
    SharedPreferencesStorePlatform.instance = store;
    var signedOut = 0;
    await AccountDeletionJournal.write('alice', AccountDeletionPhase.accepted);
    await expectLater(
      AccountDeletionJournal.finishLocalCleanup(
        'alice',
        signOut: () async {
          signedOut++;
        },
      ),
      throwsStateError,
    );
    expect(signedOut, 1);
    expect(
      await AccountDeletionJournal.read('alice'),
      AccountDeletionPhase.accepted,
    );
    store.rejectedRemoval = null;
    await AccountDeletionJournal.finishLocalCleanup(
      'alice',
      signOut: () async {
        signedOut++;
      },
    );
    expect(await AccountDeletionJournal.read('alice'), isNull);
    expect(signedOut, 2);
  });

  testWidgets(
    'uncertain request immediately replaces an already mounted profile',
    (tester) async {
      final state = CharacterState(
        deleteAccountUidOverride: 'alice',
        requestAccountDeletionOverride: (_) async =>
            throw TimeoutException('Synthetic'),
      );
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: state,
          child: MaterialApp(
            locale: const Locale('en'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: AccountDeletionGate(
              uid: 'alice',
              signOut: () async {},
              child: const Text('Protected profile'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Protected profile'), findsOneWidget);
      expect(await state.deleteAccount(), false);
      await tester.pumpAndSettle();
      expect(find.text('Protected profile'), findsNothing);
      final l = AppLocalizations.of(
        tester.element(find.byType(AccountDeletionGate)),
      )!;
      expect(find.text(l.lqDeletionUncertain), findsOneWidget);
      expect(find.text(l.lqDeletionQueued), findsNothing);
      await tester.pumpWidget(const SizedBox());
      state.dispose();
    },
  );

  testWidgets('storage read failure blocks profile until a successful retry', (
    tester,
  ) async {
    final store = DeletionFaultStore()..rejectReads = true;
    SharedPreferencesStorePlatform.instance = store;
    final state = CharacterState();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: AccountDeletionGate(
            uid: 'alice',
            signOut: () async {},
            child: const Text('Protected profile'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Protected profile'), findsNothing);
    final l = AppLocalizations.of(
      tester.element(find.byType(AccountDeletionGate)),
    )!;
    expect(find.text(l.lqDeletionCheckFailed), findsOneWidget);
    store.rejectReads = false;
    await tester.tap(find.text(l.lqRetry));
    await tester.pumpAndSettle();
    expect(find.text('Protected profile'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    state.dispose();
  });

  for (final locale in ['ko', 'en', 'ja', 'zh']) {
    testWidgets(
      'restart gate blocks old profile and retries sign-out at 200% in $locale',
      (tester) async {
        tester.view.physicalSize = const Size(320, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await AccountDeletionJournal.write(
          'alice',
          AccountDeletionPhase.accepted,
        );
        final state = CharacterState();
        var profileMounts = 0, attempts = 0;
        await tester.pumpWidget(
          ChangeNotifierProvider.value(
            value: state,
            child: MaterialApp(
              locale: Locale(locale),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              theme: QuestTheme.build(Brightness.dark),
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(2)),
                child: child!,
              ),
              home: AccountDeletionGate(
                uid: 'alice',
                signOut: () async {
                  if (++attempts == 1) {
                    throw StateError('Synthetic sign-out failure');
                  }
                },
                child: Builder(
                  builder: (_) {
                    profileMounts++;
                    return const Text('Protected profile');
                  },
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(profileMounts, 0);
        final l = AppLocalizations.of(
          tester.element(find.byType(AccountDeletionGate)),
        )!;
        final action = find.text(l.lqDeletionFinishLocal);
        await tester.ensureVisible(action);
        await tester.pumpAndSettle();
        await tester.tap(action);
        await tester.pumpAndSettle();
        expect(find.text(l.lqDeletionLocalRetry), findsOneWidget);
        expect(
          await AccountDeletionJournal.read('alice'),
          AccountDeletionPhase.accepted,
        );
        await tester.ensureVisible(action);
        await tester.pumpAndSettle();
        await tester.tap(action);
        await tester.pumpAndSettle();
        expect(await AccountDeletionJournal.read('alice'), isNull);
        // Even before an Auth event arrives, cleanup cannot remount the old child.
        expect(profileMounts, 0);
        expect(find.text(l.lqDeletionLocalFinished), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        state.dispose();
      },
    );
  }
}
