import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kLifeQuestResearchEnabled = bool.fromEnvironment(
  'LIFEQUEST_RESEARCH_ENABLED',
);

/// Voluntary, device-only study. There is deliberately no network dependency.
/// A report measures app-reported behavior, never verified real-world effort.
class BetaSnapshot {
  final int completions;
  final bool previewComplete;
  const BetaSnapshot({
    required this.completions,
    required this.previewComplete,
  });
}

class BetaStudy {
  static const key = 'lifequest.beta.crossing.v1';
  static final instance = BetaStudy(enabled: kLifeQuestResearchEnabled);
  final bool enabled;
  final DateTime Function() clock;
  final Future<SharedPreferences> Function() preferences;
  final String Function() makeId;
  final String environment;
  Future<void> _tail = Future.value();
  bool _lostWrite = false;
  BetaStudy({
    required this.enabled,
    DateTime Function()? clock,
    Future<SharedPreferences> Function()? preferences,
    String Function()? makeId,
    this.environment = kIsWeb ? 'web_preview' : 'device',
  }) : clock = clock ?? DateTime.now,
       preferences = preferences ?? SharedPreferences.getInstance,
       makeId =
           makeId ??
           (() => List.generate(
             16,
             (_) =>
                 Random.secure().nextInt(256).toRadixString(16).padLeft(2, '0'),
           ).join());

  Future<T> _serial<T>(Future<T> Function() work) {
    final result = _tail.then((_) => work());
    _tail = result.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    return result;
  }

  Map<String, dynamic>? _read(SharedPreferences prefs) {
    final raw = prefs.getString(key);
    if (raw == null) return null;
    final d = jsonDecode(raw);
    if (d is! Map<String, dynamic> ||
        d['schema'] != 1 ||
        d['cohort'] != 'crossing-library-v1' ||
        d['content'] != 'tide-v1' ||
        !const {'device', 'web_preview'}.contains(d['environment']) ||
        d['participant'] is! String ||
        !RegExp(r'^[a-f0-9]{32}$').hasMatch(d['participant']) ||
        d['startedAt'] is! String ||
        DateTime.tryParse(d['startedAt']) == null ||
        d['lastAt'] is! String ||
        DateTime.tryParse(d['lastAt']) == null ||
        d['baseline'] is! int ||
        d['lastCount'] is! int ||
        d['baseline'] < 0 ||
        d['lastCount'] < 0 ||
        d['baselinePreview'] is! bool ||
        d['days'] is! Map ||
        d['flags'] is! List ||
        d['feedback'] is! Map ||
        d['previewDay'] != null &&
            (d['previewDay'] is! int ||
                d['previewDay'] < 0 ||
                d['previewDay'] > 13)) {
      throw const FormatException(
        'Invalid study record; preserved for explicit removal.',
      );
    }
    if (DateTime.parse(d['lastAt']).isBefore(DateTime.parse(d['startedAt']))) {
      throw const FormatException('Invalid study time.');
    }
    for (final e in (d['days'] as Map).entries) {
      final day = int.tryParse('${e.key}');
      if (day == null ||
          '$day' != e.key ||
          day < 0 ||
          day > 13 ||
          e.value is! int ||
          e.value < 0 ||
          e.value > 10000) {
        throw const FormatException('Invalid study day.');
      }
    }
    final feedback = d['feedback'] as Map;
    if (feedback.isNotEmpty &&
        (feedback.length != 2 ||
            feedback['value'] is! int ||
            feedback['value'] < 1 ||
            feedback['value'] > 5 ||
            !const {
              -1,
              0,
              2900,
              4900,
              6900,
            }.contains(feedback['maxPriceKRW']))) {
      throw const FormatException('Invalid study feedback.');
    }
    if ((d['flags'] as List).any(
      (f) => !const {
        'clock_reversed',
        'profile_changed',
        'storage_failure',
        'profile_restored',
        'profile_deleted',
      }.contains(f),
    )) {
      throw const FormatException('Invalid study quality flag.');
    }
    return d;
  }

  Future<void> _write(SharedPreferences prefs, Map<String, dynamic> d) async {
    if (_lostWrite && !(d['flags'] as List).contains('storage_failure')) {
      (d['flags'] as List).add('storage_failure');
    }
    try {
      if (!await prefs.setString(key, jsonEncode(d))) {
        throw StateError('Study save failed.');
      }
    } catch (_) {
      _lostWrite = true;
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> load() =>
      _serial(() async => _read(await preferences()));

  Future<void> start(BetaSnapshot initial) => _serial(() async {
    if (!enabled) throw StateError('Study is not enabled in this build.');
    final prefs = await preferences();
    if (_read(prefs) != null) throw StateError('Already enrolled.');
    if (initial.completions < 0) throw ArgumentError('Invalid initial count.');
    final now = clock().toUtc().toIso8601String();
    final id = makeId();
    if (!RegExp(r'^[a-f0-9]{32}$').hasMatch(id)) {
      throw StateError('Invalid participant ID.');
    }
    _lostWrite = false;
    await _write(prefs, {
      'schema': 1,
      'cohort': 'crossing-library-v1',
      'content': 'tide-v1',
      'environment': environment,
      'participant': id,
      'startedAt': now,
      'lastAt': now,
      'baseline': initial.completions,
      'lastCount': initial.completions,
      'baselinePreview': initial.previewComplete,
      'previewDay': null,
      'days': <String, int>{'0': 0},
      'flags': <String>[],
      'feedback': <String, dynamic>{},
    });
  });

  Future<void> observe(BetaSnapshot snapshot) => _serial(() async {
    if (!enabled) return;
    final prefs = await preferences();
    final d = _read(prefs);
    if (d == null) return; // No consent: no record, even a participant ID.
    final now = clock().toUtc();
    final last = DateTime.parse(d['lastAt']);
    final day = now.difference(DateTime.parse(d['startedAt'])).inDays;
    final flags = d['flags'] as List;
    void flag(String value) {
      if (!flags.contains(value)) flags.add(value);
    }

    if (now.isBefore(last)) flag('clock_reversed');
    if (snapshot.completions < d['lastCount']) flag('profile_changed');
    if (_lostWrite) flag('storage_failure');
    if (flags.isNotEmpty) {
      await _write(prefs, d);
      return;
    }
    if (day >= 14) return;
    final days = d['days'] as Map;
    final delta = snapshot.completions - (d['lastCount'] as int);
    final nextCount = ((days['$day'] as int? ?? 0) + delta).clamp(0, 10000);
    final preview =
        d['previewDay'] == null &&
        d['baselinePreview'] == false &&
        snapshot.previewComplete;
    if (days.containsKey('$day') && delta == 0 && !preview) return;
    days['$day'] = nextCount;
    d['lastCount'] = snapshot.completions;
    d['lastAt'] = now.toIso8601String();
    if (preview) d['previewDay'] = day;
    await _write(prefs, d);
  });

  /// Mutating a device profile invalidates comparability, not the user's app data.
  Future<void> invalidate(String reason) => _serial(() async {
    // A consented record can survive installing a normal build over a beta.
    // Restoring that profile must still invalidate the old study; never create
    // a new record here or collect activity while research is disabled.
    if (!const {'profile_restored', 'profile_deleted'}.contains(reason)) {
      throw ArgumentError('Unknown reason.');
    }
    final prefs = await preferences();
    final d = _read(prefs);
    if (d == null) return;
    if (!(d['flags'] as List).contains(reason)) {
      (d['flags'] as List).add(reason);
    }
    await _write(prefs, d);
  });

  Future<void> feedback({required int value, required int price}) =>
      _serial(() async {
        if (!enabled ||
            value < 1 ||
            value > 5 ||
            !const {-1, 0, 2900, 4900, 6900}.contains(price)) {
          throw ArgumentError('Invalid study feedback.');
        }
        final prefs = await preferences();
        final d = _read(prefs);
        if (d == null) throw StateError('Consent required.');
        if (d['baselinePreview'] != true && d['previewDay'] == null) {
          throw StateError('Finish the preview first.');
        }
        d['feedback'] = {'value': value, 'maxPriceKRW': price};
        await _write(prefs, d);
      });

  /// Explicit allowlist: no names, goals, quest text, choices, account IDs,
  /// exact times, device identifiers, model prompts or purchase receipts.
  Future<Map<String, dynamic>> report() => _serial(() async {
    if (!enabled) throw StateError('Study is not enabled in this build.');
    final d = _read(await preferences());
    if (d == null) throw StateError('Consent required.');
    final elapsed = clock().toUtc().difference(DateTime.parse(d['startedAt']));
    final flags = List<String>.from(d['flags']);
    if (elapsed.isNegative ||
        clock().toUtc().isBefore(DateTime.parse(d['lastAt']))) {
      if (!flags.contains('clock_reversed')) flags.add('clock_reversed');
    }
    if (_lostWrite && !flags.contains('storage_failure')) {
      flags.add('storage_failure');
    }
    return {
      'schema': 1,
      'cohort': d['cohort'],
      'content': d['content'],
      'environment': d['environment'],
      'participant': d['participant'],
      'elapsedDays': elapsed.inDays.clamp(0, 3650),
      'baselineCompletions': d['baseline'],
      'baselinePreviewComplete': d['baselinePreview'],
      'days': Map<String, int>.from(d['days']),
      'previewDay': d['previewDay'],
      'feedback': (d['feedback'] as Map).isEmpty
          ? <String, int>{}
          : {
              'value': d['feedback']['value'] as int,
              'maxPriceKRW': d['feedback']['maxPriceKRW'] as int,
            },
      'qualityFlags': flags,
      'evidence': 'device_reported_not_purchase',
    };
  });

  Future<void> withdraw() => _serial(() async {
    final prefs = await preferences();
    if (!await prefs.remove(key)) throw StateError('Study removal failed.');
    _lostWrite = false;
  });

  /// Collection failure is separate from quest saving and must never crash play.
  Future<void> observeQuietly(BetaSnapshot snapshot) async {
    try {
      await observe(snapshot);
    } catch (_) {
      _lostWrite = true;
    }
  }

  Future<void> invalidateQuietly(String reason) async {
    try {
      await invalidate(reason);
    } catch (_) {
      _lostWrite = true;
    }
  }
}
