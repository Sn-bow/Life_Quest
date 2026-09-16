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
  PurchaseIdentity? selection = const PurchaseIdentity(
    'alice',
    email: 'tester@example.test',
  );
  final auth = StreamController<PurchaseIdentity?>.broadcast(sync: true);
  final calls = <String>[];
  Future<bool> Function()? ensure;
  Future<void> Function()? beforeSignIn;
  bool signOutFails = false, deletionAccepted = true;
  @override
  Stream<PurchaseIdentity?> get changes => auth.stream;
  void switchTo(PurchaseIdentity? next) {
    current = next;
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
    Future<void> Function()? mark,
  }) => PurchaseAccountState(
    enabled: enabled,
    isPurchaseOnly: () => session.purchaseOnlyAuth,
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
