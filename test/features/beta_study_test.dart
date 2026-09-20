import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:life_quest_final_v2/features/research/beta_study.dart';

class StudyFaultStore extends InMemorySharedPreferencesStore {
  StudyFaultStore() : super.empty();
  bool fail = false;
  bool returnFalse = false;
  @override
  Future<bool> setValue(String type, String key, Object value) async {
    if (fail) {
      if (returnFalse) return false;
      throw StateError('Synthetic full disk');
    }
    return super.setValue(type, key, value);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late DateTime now;
  late BetaStudy study;
  const zero = BetaSnapshot(completions: 0, previewComplete: false);
  BetaSnapshot snapshot(int count, [bool preview = false]) =>
      BetaSnapshot(completions: count, previewComplete: preview);
  BetaStudy create({bool enabled = true, String environment = 'device'}) =>
      BetaStudy(
        enabled: enabled,
        clock: () => now,
        environment: environment,
        makeId: () => '0123456789abcdef0123456789abcdef',
      );
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    now = DateTime.utc(2026, 9, 20);
    study = create();
  });

  test(
    'disabled build and no consent produce no participant or record',
    () async {
      await study.observe(snapshot(3));
      expect(await study.load(), isNull);
      final disabled = create(enabled: false);
      await disabled.observe(snapshot(3));
      await expectLater(disabled.start(zero), throwsStateError);
      await expectLater(disabled.report(), throwsStateError);
      expect((await SharedPreferences.getInstance()).getKeys(), isEmpty);
    },
  );

  test('completion deltas survive restart without double counting', () async {
    await study.start(snapshot(10));
    await Future.wait([
      study.observe(snapshot(11)),
      study.observe(snapshot(12)),
      study.observe(snapshot(12)),
    ]);
    study = create();
    await study.observe(snapshot(12));
    now = now.add(const Duration(days: 1));
    await study.observe(snapshot(13));
    final report = await study.report();
    expect(report['baselineCompletions'], 10);
    expect(report['days'], {'0': 2, '1': 1});
    expect(report['elapsedDays'], 1);
  });

  test(
    'study records day 7 only after returning and stops after day 13',
    () async {
      await study.start(zero);
      now = now.add(const Duration(days: 7, hours: 23));
      await study.observe(snapshot(1));
      expect((await study.report())['elapsedDays'], 7);
      now = now.add(const Duration(hours: 1));
      expect((await study.report())['elapsedDays'], 8);
      now = now.add(const Duration(days: 5));
      await study.observe(snapshot(2));
      now = now.add(const Duration(days: 1));
      await study.observe(snapshot(3));
      expect((await study.report())['days'], {'0': 0, '7': 1, '13': 1});
    },
  );

  test(
    'price feedback requires preview and preserves unknown vs no purchase',
    () async {
      await study.start(zero);
      await expectLater(
        study.feedback(value: 4, price: 6900),
        throwsStateError,
      );
      await study.observe(snapshot(1, true));
      await study.feedback(value: 4, price: -1);
      expect((await study.report())['feedback'], {
        'value': 4,
        'maxPriceKRW': -1,
      });
      await study.feedback(value: 2, price: 0);
      final report = await study.report();
      expect(report['feedback'], {'value': 2, 'maxPriceKRW': 0});
      expect(report['previewDay'], 0);
      await expectLater(
        study.feedback(value: 6, price: 6900),
        throwsArgumentError,
      );
      await expectLater(
        study.feedback(value: 4, price: 1),
        throwsArgumentError,
      );
    },
  );

  test(
    'returning preview reader is distinguished from newly completed preview',
    () async {
      await study.start(snapshot(8, true));
      await study.observe(snapshot(8, true));
      await study.feedback(value: 3, price: 2900);
      final report = await study.report();
      expect(report['baselinePreviewComplete'], true);
      expect(report['previewDay'], isNull);
    },
  );

  test('clock rollback flags instead of creating a negative day', () async {
    await study.start(zero);
    now = now.subtract(const Duration(hours: 2));
    await study.observe(snapshot(1));
    final report = await study.report();
    expect(report['qualityFlags'], contains('clock_reversed'));
    expect(report['days'], {'0': 0});
  });

  test(
    'counter rollback and explicit restore invalidate retention comparability',
    () async {
      await study.start(snapshot(5));
      await study.observe(snapshot(4));
      await study.invalidate('profile_restored');
      await study.observe(snapshot(100));
      final report = await study.report();
      expect(
        report['qualityFlags'],
        containsAll(['profile_changed', 'profile_restored']),
      );
      expect(report['days'], {'0': 0});
    },
  );

  for (final returnsFalse in [false, true]) {
    test(
      'failed write ($returnsFalse) cannot poison queue or become valid evidence',
      () async {
        final store = StudyFaultStore();
        SharedPreferencesStorePlatform.instance = store;
        await study.start(zero);
        store
          ..fail = true
          ..returnFalse = returnsFalse;
        await study.observeQuietly(snapshot(1));
        store.fail = false;
        await study.observe(snapshot(2));
        expect(
          (await study.report())['qualityFlags'],
          contains('storage_failure'),
        );
        await study.withdraw();
        await study.start(zero);
        expect((await study.report())['qualityFlags'], isEmpty);
      },
    );
  }

  test('queued observation cannot resurrect withdrawn consent', () async {
    await study.start(zero);
    await Future.wait([
      study.observe(snapshot(1)),
      study.withdraw(),
      study.observe(snapshot(2)),
    ]);
    expect(await study.load(), isNull);
    await expectLater(study.report(), throwsStateError);
  });

  test(
    'normal-build restore invalidates a prior beta without collecting activity',
    () async {
      await study.start(zero);
      final disabled = create(enabled: false);
      await disabled.invalidate('profile_restored');
      await disabled.observe(snapshot(50));
      final report = await study.report();
      expect(report['qualityFlags'], ['profile_restored']);
      expect(report['days'], {'0': 0});
      await disabled.withdraw();
      await disabled.invalidate('profile_restored');
      expect(await study.load(), isNull);
    },
  );

  test(
    'unknown nested fields cannot leak through export and corruption is preserved',
    () async {
      await study.start(zero);
      final prefs = await SharedPreferences.getInstance();
      final original = jsonDecode(prefs.getString(BetaStudy.key)!);
      for (final mutation in [
        {
          'feedback': {'value': 4, 'maxPriceKRW': 6900, 'goal': 'PRIVATE'},
        },
        {'content': 'PRIVATE'},
        {
          'days': {'00': 1},
        },
        {
          'flags': ['PRIVATE'],
        },
      ]) {
        final raw = jsonEncode({...original, ...mutation});
        await prefs.setString(BetaStudy.key, raw);
        await expectLater(study.report(), throwsFormatException);
        expect(prefs.getString(BetaStudy.key), raw);
      }
      await prefs.setString(
        BetaStudy.key,
        jsonEncode({...original, 'goal': 'PRIVATE'}),
      );
      final report = jsonEncode(await study.report());
      expect(report, isNot(contains('PRIVATE')));
      expect(report, isNot(contains('startedAt')));
      expect(report, isNot(contains('lastAt')));
      await study.withdraw();
      expect(await study.load(), isNull);
    },
  );

  test('web provenance survives report and local restart', () async {
    await create(environment: 'web_preview').start(zero);
    expect((await study.report())['environment'], 'web_preview');
  });
}
