import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_quest_final_v2/features/billing/purchase_account_state.dart';
import 'package:life_quest_final_v2/features/billing/purchase_account_screen.dart';
import 'package:life_quest_final_v2/features/session/session_state.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/theme/quest_theme.dart';

class FakeGateway implements PurchaseAccountGateway {
  @override
  PurchaseIdentity? current;
  @override
  PurchaseIdentity? currentSession;
  PurchaseIdentity? selection = const PurchaseIdentity(
    'alice',
    email: 'tester@example.test',
  );
  final auth = StreamController<PurchaseIdentity?>.broadcast(sync: true);
  final calls = <String>[];
  Future<bool> Function()? ensure;
  Future<PurchaseIdentity?> Function()? link;
  Future<void> Function()? beforeSignIn;
  bool signOutFails = false, deletionAccepted = true;
  @override
  Stream<PurchaseIdentity?> get changes => auth.stream;
  void switchTo(PurchaseIdentity? next) {
    current = next;
    currentSession = next;
    auth.add(next);
  }

  @override
  Future<PurchaseIdentity?> signIn() async {
    calls.add('signIn');
    await beforeSignIn?.call();
    if (selection != null) switchTo(selection);
    return selection;
  }

  @override
  Future<PurchaseIdentity?> linkCurrentWithGoogle() async {
    calls.add('link');
    if (link != null) return link!();
    final selected = selection;
    if (selected != null) switchTo(selected);
    return selected;
  }

  @override
  Future<bool> ensureAccount() async {
    calls.add('ensure');
    return await ensure?.call() ?? true;
  }

  @override
  Future<void> signOut() async {
    calls.add('signOut');
    if (signOutFails) throw StateError('sign-out failed');
    switchTo(null);
  }

  @override
  Future<bool> requestDeletion() async {
    calls.add('delete');
    return deletionAccepted;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SessionState session;
  late FakeGateway gateway;
  PurchaseAccountState make({
    bool enabled = true,
    bool localProfile = true,
    Future<void> Function()? mark,
  }) => PurchaseAccountState(
    enabled: enabled,
    isPurchaseOnly: () => session.purchaseOnlyAuth,
    isLocalProfile: () => localProfile,
    markPurchaseOnly: mark ?? session.markPurchaseOnlyAuth,
    createGateway: () => gateway,
  );
  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'lifequest.local.state.v1': 'private progress',
      'lifequest.director.v1.device': 'private personalization',
    });
    session = SessionState();
    await session.initialize();
    gateway = FakeGateway();
  });
  tearDown(() async {
    session.dispose();
    await gateway.auth.close();
  });

  test('disabled build never constructs an auth gateway', () async {
    final account = PurchaseAccountState(
      enabled: false,
      isPurchaseOnly: () => true,
      markPurchaseOnly: () async => fail('purpose'),
      createGateway: () => throw StateError('auth'),
    );
    await account.initialize();
    await account.connect();
    await account.disconnect();
    expect(account.uid, isNull);
    account.dispose();
  });
  test(
    'purpose must be durable before sign-in; device data stays untouched',
    () async {
      final prefs = await SharedPreferences.getInstance();
      gateway.beforeSignIn = () async {
        expect(prefs.getBool(SessionState.purchasePurposeKey), true);
        expect(prefs.getString(PurchaseAccountState.readyUidKey), isNull);
      };
      final account = make();
      await account.connect();
      expect(account.uid, 'alice');
      expect(prefs.getString(PurchaseAccountState.readyUidKey), 'alice');
      expect(prefs.getString('lifequest.local.state.v1'), 'private progress');
      expect(
        prefs.getString('lifequest.director.v1.device'),
        'private personalization',
      );
      await session.selectDevice(false);
      final restartedSession = SessionState();
      await restartedSession.initialize();
      expect(restartedSession.purchaseOnlyAuth, true);
      expect(restartedSession.deviceSelected, false);
      restartedSession.dispose();
      account.dispose();
    },
  );
  test('failed purpose write cannot start authentication', () async {
    final account = make(mark: () async => throw StateError('disk'));
    await account.connect();
    expect(gateway.calls, isEmpty);
    expect(account.status, PurchaseAccountStatus.failed);
    account.dispose();
  });
  test('cancellation creates no ready account', () async {
    gateway.selection = null;
    final account = make();
    await account.connect();
    expect(gateway.calls, ['signIn']);
    expect(account.status, PurchaseAccountStatus.idle);
    expect(account.uid, isNull);
    account.dispose();
  });
  test(
    'server denial leaves auth manageable but cannot enable paid access',
    () async {
      gateway.ensure = () async => false;
      final account = make();
      await account.connect();
      expect(account.uid, isNull);
      expect(account.signedInIdentity?.uid, 'alice');
      expect(account.status, PurchaseAccountStatus.failed);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(PurchaseAccountState.readyUidKey), isNull);
      await account.deleteAccount();
      expect(account.status, PurchaseAccountStatus.deleted);
      account.dispose();
    },
  );
  test(
    'account change during confirmation cannot grant the selected account',
    () async {
      final waiting = Completer<bool>();
      gateway.ensure = () => waiting.future;
      final account = make();
      final connecting = account.connect();
      while (!gateway.calls.contains('ensure')) {
        await Future<void>.delayed(Duration.zero);
      }
      gateway.switchTo(const PurchaseIdentity('bob'));
      waiting.complete(true);
      await connecting;
      expect(account.uid, isNull);
      expect(account.status, PurchaseAccountStatus.failed);
      account.dispose();
    },
  );
  test(
    'offline restart accepts only a previously confirmed matching purchase identity',
    () async {
      final account = make();
      await account.connect();
      account.dispose();
      gateway.calls.clear();
      final restarted = make();
      await restarted.initialize();
      expect(restarted.uid, 'alice');
      expect(gateway.calls, isEmpty);
      gateway.switchTo(const PurchaseIdentity('bob'));
      expect(restarted.uid, isNull);
      restarted.dispose();
      final different = make();
      await different.initialize();
      expect(different.uid, isNull);
      different.dispose();
    },
  );
  test(
    'legacy auth and forged ready cache do not select a cloud or purchase profile',
    () async {
      gateway.current = const PurchaseIdentity('alice');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(PurchaseAccountState.readyUidKey, 'alice');
      final account = make();
      await account.initialize();
      expect(account.uid, isNull);
      account.dispose();
    },
  );
  test(
    'disconnect revokes restart access even when auth sign-out fails',
    () async {
      final account = make();
      await account.connect();
      gateway.signOutFails = true;
      await account.disconnect();
      expect(account.uid, isNull);
      expect(account.status, PurchaseAccountStatus.failed);
      account.dispose();
      final restarted = make();
      await restarted.initialize();
      expect(restarted.uid, isNull);
      expect(session.purchaseOnlyAuth, true);
      restarted.dispose();
    },
  );
  test(
    'accepted deletion with cleanup failure is not reported as a failed request',
    () async {
      final account = make();
      await account.connect();
      gateway.signOutFails = true;
      await account.deleteAccount();
      expect(account.status, PurchaseAccountStatus.cleanupNeeded);
      expect(account.uid, isNull);
      await account.disconnect();
      expect(account.status, PurchaseAccountStatus.cleanupNeeded);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(PurchaseAccountState.readyUidKey), isNull);
      expect(prefs.getString('lifequest.local.state.v1'), 'private progress');
      account.dispose();
      final restarted = make();
      await restarted.initialize();
      expect(restarted.uid, isNull);
      restarted.dispose();
    },
  );
  test(
    'rejected deletion leaves device data and no automatic paid session',
    () async {
      final account = make();
      await account.connect();
      gateway.deletionAccepted = false;
      await account.deleteAccount();
      expect(account.status, PurchaseAccountStatus.failed);
      expect(account.uid, isNull);
      expect(gateway.current?.uid, 'alice');
      account.dispose();
    },
  );

  test('existing Google cloud profile prepares purchases without changing its purpose', () async {
    gateway.switchTo(const PurchaseIdentity('alice', email: 'alice@example.test'));
    final account = make(localProfile: false);
    await account.initialize();
    expect(account.uid, 'alice');
    await account.connect();
    expect(gateway.calls, ['ensure']);
    expect(gateway.currentSession?.uid, 'alice');
    expect(session.purchaseOnlyAuth, false);
    account.dispose();
  });

  test('email cloud profile links Google to the same UID and retains profile routing', () async {
    gateway.currentSession = const PurchaseIdentity('alice', email: 'alice@example.test');
    gateway.selection = const PurchaseIdentity('alice', email: 'alice@example.test');
    final account = make(localProfile: false);
    await account.initialize();
    expect(account.uid, isNull);
    await account.connect();
    expect(gateway.calls, ['link', 'ensure']);
    expect(account.uid, 'alice');
    expect(gateway.currentSession?.uid, 'alice');
    expect(session.purchaseOnlyAuth, false);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(PurchaseAccountState.readyUidKey), isNull);
    expect(prefs.getString('lifequest.local.state.v1'), 'private progress');
    account.dispose();
  });

  test('failed Google link leaves the email cloud account and local purpose unchanged', () async {
    gateway.currentSession = const PurchaseIdentity('alice', email: 'alice@example.test');
    gateway.link = () async => throw StateError('credential-already-in-use');
    final account = make(localProfile: false);
    await account.connect();
    expect(account.uid, isNull);
    expect(account.status, PurchaseAccountStatus.failed);
    expect(gateway.currentSession?.uid, 'alice');
    expect(session.purchaseOnlyAuth, false);
    expect(gateway.calls, ['link']);
    account.dispose();
  });

  test('cloud account switch during confirmation cannot grant the old profile', () async {
    gateway.currentSession = const PurchaseIdentity('alice');
    gateway.selection = const PurchaseIdentity('alice');
    final waiting = Completer<bool>();
    gateway.ensure = () => waiting.future;
    final account = make(localProfile: false);
    final connecting = account.connect();
    while (!gateway.calls.contains('ensure')) {
      await Future<void>.delayed(Duration.zero);
    }
    gateway.switchTo(const PurchaseIdentity('bob'));
    waiting.complete(true);
    await connecting;
    expect(account.uid, isNull);
    expect(account.status, PurchaseAccountStatus.failed);
    expect(session.purchaseOnlyAuth, false);
    account.dispose();
  });

  test('purchase account controls cannot sign out or delete an existing cloud profile', () async {
    gateway.switchTo(const PurchaseIdentity('alice'));
    final account = make(localProfile: false);
    await account.initialize();
    await account.disconnect();
    await account.deleteAccount();
    expect(gateway.calls, isEmpty);
    expect(gateway.currentSession?.uid, 'alice');
    account.dispose();
  });

  testWidgets(
    'Plus account connection returns to its purchase screen only when ready',
    (tester) async {
      final account = make();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: account,
          child: const MaterialApp(
            locale: Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Column(
                children: [
                  Text('Plus purchase screen'),
                  PurchaseAccountTile(returnAfterConnection: true),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(PurchaseAccountTile));
      await tester.pumpAndSettle();
      expect(find.byType(PurchaseAccountScreen), findsOneWidget);

      gateway.ensure = () async => false;
      await tester.tap(find.byKey(const ValueKey('connect-purchase-account')));
      await tester.pumpAndSettle();
      expect(find.byType(PurchaseAccountScreen), findsOneWidget);
      expect(account.uid, isNull);
      expect(account.status, PurchaseAccountStatus.failed);

      gateway.ensure = () async => true;
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('connect-purchase-account')),
        180,
      );
      await tester.tap(find.byKey(const ValueKey('connect-purchase-account')));
      await tester.pumpAndSettle();
      expect(account.uid, 'alice');
      expect(find.byType(PurchaseAccountScreen), findsNothing);
      expect(find.text('Plus purchase screen'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      account.dispose();
    },
  );

  for (final code in ['ko', 'en', 'ja', 'zh']) {
    testWidgets(
      'purchase identity and deletion are readable at 320px / 200%: $code',
      (tester) async {
        tester.view.physicalSize = const Size(320, 700);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final account = make();
        await account.connect();
        await tester.pumpWidget(
          ChangeNotifierProvider.value(
            value: account,
            child: MaterialApp(
              theme: QuestTheme.build(Brightness.dark),
              locale: Locale(code),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(2)),
                child: child!,
              ),
              home: const PurchaseAccountScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final l = await AppLocalizations.delegate.load(Locale(code));
        final deletion = find.text(l.lqPurchaseAccountDelete);
        await tester.scrollUntilVisible(deletion, 300);
        await tester.tap(deletion);
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        account.dispose();
      },
    );
  }
}
