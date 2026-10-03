import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:life_quest_final_v2/features/status_pack/status_skin_store.dart';
import 'package:life_quest_final_v2/features/status_pack/ui/status_pack_screen.dart';
import 'package:life_quest_final_v2/features/system/system_journal.dart';
import 'package:life_quest_final_v2/services/purchase_service.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _now = DateTime(2026, 9, 28, 18);

GrowthReceipt _receipt() => GrowthReceipt(
  id: 'real-1',
  questId: 'q-1',
  title: 'Private quest title',
  day: '2026-09-28',
  source: 'quest',
  at: DateTime(2026, 9, 28, 11),
  category: 0,
  baseXp: 20,
  gold: 5,
  levelBefore: 2,
  levelAfter: 3,
  xp: 20,
  xpBefore: 80,
  xpAfter: 0,
  maxXpAfter: 110,
  statChanges: const [1, 0, 0, 0],
);

ProductDetails _product() => ProductDetails(
  id: 'status_window_plus_01',
  title: 'Synthetic Play product',
  description: 'Test catalog',
  price: '¥700',
  rawPrice: 700,
  currencyCode: 'JPY',
);

Widget _app({
  Locale locale = const Locale('en'),
  bool owned = false,
  ProductDetails? product,
  bool canPurchase = true,
  bool monetizationEnabled = true,
  PurchasePhase phase = PurchasePhase.idle,
  List<GrowthReceipt>? receipts,
  VoidCallback? onBuy,
  StatusPackSaveFile? saveFile,
  double textScale = 1,
  bool withAppBar = false,
}) => MaterialApp(
  locale: locale,
  supportedLocales: const [
    Locale('ko'),
    Locale('en'),
    Locale('ja'),
    Locale('zh'),
  ],
  localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
  theme: ThemeData.dark(),
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(
      context,
    ).copyWith(textScaler: TextScaler.linear(textScale)),
    child: child!,
  ),
  home: Scaffold(
    appBar: withAppBar ? AppBar(title: const Text('PLUS')) : null,
    body: StatusPackBody(
      now: _now,
      receipts: receipts ?? [_receipt()],
      owned: owned,
      product: product,
      canPurchase: canPurchase,
      monetizationEnabled: monetizationEnabled,
      checkingStore: false,
      purchaseBusy: false,
      phase: phase,
      activeProduct: null,
      showAccountLink: false,
      onBuy: onBuy,
      onRestore: () {},
      onRefreshCatalog: () {},
      saveFile: saveFile,
    ),
  ),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    StatusSkinStore.instance.resetForTesting();
  });

  test(
    'Every target locale has a real one-time pack and record-scope copy',
    () {
      for (final locale in const ['ko', 'en', 'ja', 'zh']) {
        final copy = StatusPackCopy(locale);
        expect(copy.t('title'), isNotEmpty);
        expect(copy.t('oneTime'), isNotEmpty);
        expect(copy.t('partialWarning'), isNotEmpty);
        expect(copy.t('noBoost'), isNotEmpty);
        expect(copy.t('salePaused'), isNotEmpty);
        expect(copy.buyFor('¥700'), contains('¥700'));
      }
    },
  );

  testWidgets('old pack entry leads to Complete without selling legacy SKU', (
    tester,
  ) async {
    final character = CharacterState()..initializeForTesting();
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: character,
        child: const MaterialApp(
          locale: Locale('ja'),
          supportedLocales: [Locale('ja'), Locale('en')],
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: StatusPackScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Life Quest Complete'), findsOneWidget);
    expect(find.byKey(const ValueKey('buy-status-plus')), findsNothing);
    expect(
      find.byKey(const ValueKey('status-pack-purchase-panel')),
      findsNothing,
    );
    expect(find.byKey(const ValueKey('restore-status-plus')), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    character.dispose();
  });

  testWidgets(
    'Locked report shows no invented statistics and live Play price',
    (tester) async {
      var purchases = 0;
      await tester.pumpWidget(
        _app(
          locale: const Locale('ja'),
          product: _product(),
          onBuy: () => purchases++,
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('locked-growth-preview')),
        findsOneWidget,
      );
      expect(find.text('過去30日 · 記録された達成1件'), findsOneWidget);
      expect(find.byKey(const ValueKey('growth-report')), findsNothing);
      expect(find.text('¥700で購入'), findsOneWidget);
      expect(find.textContaining('Private quest title'), findsNothing);
      final buy = find.byKey(const ValueKey('buy-status-plus'));
      await tester.ensureVisible(buy);
      await tester.tap(buy);
      expect(purchases, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('No Play price or purchase account never becomes a fake offer', (
    tester,
  ) async {
    await tester.pumpWidget(_app(product: null));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('buy-status-plus')), findsNothing);
    expect(
      find.textContaining('Google Play product is unavailable'),
      findsOneWidget,
    );

    await tester.pumpWidget(_app(product: _product(), canPurchase: false));
    await tester.pumpAndSettle();
    final button = tester.widget<FilledButton>(
      find.byKey(const ValueKey('buy-status-plus')),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('Verified pack shows real 30/90-day metrics and safe exports', (
    tester,
  ) async {
    final saved = <String, Uint8List>{};
    Future<bool> save(Uint8List bytes, String filename) async {
      saved[filename] = bytes;
      return true;
    }

    await tester.pumpWidget(_app(owned: true, saveFile: save));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('locked-growth-preview')), findsNothing);
    expect(find.byKey(const ValueKey('growth-report')), findsOneWidget);
    expect(find.text('30-day growth record'), findsOneWidget);
    expect(find.text('20'), findsOneWidget);
    expect(find.text('1 recorded completions · XP 20'), findsOneWidget);
    expect(find.text('0 recorded completions · XP 0'), findsNWidgets(3));
    expect(find.text('Private quest title'), findsNothing);

    final csv = find.byKey(const ValueKey('export-csv'));
    await tester.ensureVisible(csv);
    await tester.tap(csv);
    await tester.pumpAndSettle();
    final csvName = saved.keys.single;
    expect(csvName, contains('30d'));
    expect(csvName, endsWith('.csv'));
    final csvText = String.fromCharCodes(saved[csvName]!);
    expect(csvText, contains('2026-09-28,1,1,20'));
    expect(csvText, isNot(contains('recorded_gold')));
    expect(csvText, isNot(contains('Private quest title')));

    final ninety = find.byKey(const ValueKey('growth-days-90'));
    await tester.ensureVisible(ninety);
    await tester.tap(ninety);
    await tester.pumpAndSettle();
    expect(find.text('90-day growth record'), findsOneWidget);
    final txt = find.byKey(const ValueKey('export-txt'));
    await tester.ensureVisible(txt);
    await tester.tap(txt);
    await tester.pumpAndSettle();
    final txtName = saved.keys.where((name) => name.endsWith('.txt')).single;
    expect(txtName, contains('90d'));
    final text = String.fromCharCodes(saved[txtName]!);
    expect(text, contains('records start'));
    expect(text, contains('Strength 1 / 20 XP'));
    expect(text, isNot(contains('Gold')));
    expect(text, isNot(contains('Private quest title')));
    expect(tester.takeException(), isNull);
  });

  testWidgets('PNG export captures the real report widget', (tester) async {
    final pngs = <Uint8List>[];
    Future<void> waitForSavedPngs(int count) async {
      // PNG encoding crosses the widget test's fake/real async boundary.
      // Wait for the actual save callback instead of guessing its duration.
      await tester.runAsync(() async {
        final deadline = DateTime.now().add(const Duration(seconds: 5));
        while (pngs.length < count && DateTime.now().isBefore(deadline)) {
          await Future<void>.delayed(const Duration(milliseconds: 20));
        }
      });
      await tester.pump();
      expect(pngs, hasLength(count));
    }

    await tester.pumpWidget(
      _app(
        owned: true,
        saveFile: (bytes, filename) async {
          if (filename.endsWith('.png')) pngs.add(bytes);
          return true;
        },
      ),
    );
    await tester.pumpAndSettle();
    final button = find.byKey(const ValueKey('export-png'));
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();
    await waitForSavedPngs(1);
    expect(pngs.first.take(8).toList(), [137, 80, 78, 71, 13, 10, 26, 10]);
    var reportFrame = tester.widget<Image>(
      find.byKey(const ValueKey('report-frame')),
    );
    expect(
      (reportFrame.image as AssetImage).assetName,
      StatusWindowLook.core.assetPath,
    );

    final look = find.byKey(const ValueKey('look-obsidian'));
    await tester.ensureVisible(look);
    await tester.tap(look);
    await tester.pumpAndSettle();
    reportFrame = tester.widget<Image>(
      find.byKey(const ValueKey('report-frame')),
    );
    expect(
      (reportFrame.image as AssetImage).assetName,
      StatusWindowLook.obsidian.assetPath,
    );
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();
    await waitForSavedPngs(2);
    expect(listEquals(pngs[0], pngs[1]), false);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Premium look is inaccessible without entitlement and applies after it',
    (tester) async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();
      final locked = find.byKey(const ValueKey('look-obsidian'));
      await tester.ensureVisible(locked);
      await tester.tap(locked);
      await tester.pumpAndSettle();
      expect(StatusSkinStore.instance.selected, StatusWindowLook.core);

      await tester.pumpWidget(_app(owned: true));
      await tester.pumpAndSettle();
      final unlocked = find.byKey(const ValueKey('look-obsidian'));
      await tester.ensureVisible(unlocked);
      await tester.tap(unlocked);
      await tester.pumpAndSettle();
      expect(StatusSkinStore.instance.selected, StatusWindowLook.obsidian);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Japanese at 320px and 200% text scale has no overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(640, 1200);
    tester.view.devicePixelRatio = 2;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(
      _app(locale: const Locale('ja'), owned: true, textScale: 2),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('growth-report')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Japanese phone shows the Play offer before looks and can scroll to reports',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 2.625; // 411 x 731 logical pixels.
      tester.view.padding = const FakeViewPadding(top: 52, bottom: 24);
      tester.view.viewPadding = const FakeViewPadding(top: 52, bottom: 24);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPadding);
      addTearDown(tester.view.resetViewPadding);

      var purchases = 0;
      await tester.pumpWidget(
        _app(
          locale: const Locale('ja'),
          product: _product(),
          onBuy: () => purchases++,
          withAppBar: true,
        ),
      );
      await tester.pumpAndSettle();

      final offer = find.byKey(const ValueKey('status-pack-purchase-panel'));
      final buy = find.byKey(const ValueKey('buy-status-plus'));
      final appearance = find.text('ステータス画面の外観');
      expect(offer, findsOneWidget);
      expect(buy, findsOneWidget);
      expect(tester.getBottomLeft(buy).dy, lessThan(731 - 24));
      expect(
        tester.getTopLeft(offer).dy,
        lessThan(tester.getTopLeft(appearance).dy),
      );
      await tester.tap(buy);
      expect(purchases, 1);

      final report = find.byKey(const ValueKey('locked-growth-preview'));
      expect(tester.getTopLeft(report).dy, greaterThan(731));
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -650),
      );
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(report).dy, lessThan(731 - 24));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Tablet widths and 30/90-day free/paid states do not overflow', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    for (final width in [768.0, 1024.0]) {
      tester.view.physicalSize = Size(width, 900);
      for (final owned in [false, true]) {
        await tester.pumpWidget(
          _app(
            locale: const Locale('zh'),
            owned: owned,
            product: _product(),
            textScale: 1.5,
          ),
        );
        await tester.pumpAndSettle();
        final ninety = find.byKey(const ValueKey('growth-days-90'));
        await tester.ensureVisible(ninety);
        await tester.tap(ninety);
        await tester.pumpAndSettle();
        final section = find.byKey(
          ValueKey(owned ? 'growth-report' : 'locked-growth-preview'),
        );
        await tester.ensureVisible(section);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    }
  });
}
