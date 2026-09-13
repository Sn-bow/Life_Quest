// Isolated QA entry point: NEVER upload a build made from this target to Play.
// Exercises the shipping JNI bridge and parser with R8 and AOT enabled.
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/features/director/on_device_quest_model.dart';
import 'package:life_quest_final_v2/features/director/quest_director_engine.dart';

const enabled = bool.fromEnvironment('LIFEQUEST_NATIVE_RELEASE_PROBE');
final statusText = ValueNotifier<String>('Local synthetic release test');

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (!enabled) throw StateError('Explicit QA opt-in required.');
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: ValueListenableBuilder(
            valueListenable: statusText,
            builder: (_, value, child) => Text(
              'LIFE QUEST · RELEASE QA\n$value',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    ),
  );
  unawaited(runProbe());
}

Future<void> runProbe() async {
  final model = OnDeviceQuestModel();
  Timer? poll;
  try {
    final initial = await model.status();
    if (initial.status != OnDeviceModelStatus.available) {
      if (initial.status != OnDeviceModelStatus.downloadable) {
        throw StateError('Model unavailable: ${initial.reason}');
      }
      statusText.value =
          'Downloading pinned open model to disposable QA device';
      var lastBucket = -1;
      poll = Timer.periodic(const Duration(seconds: 5), (_) async {
        final snapshot = await model.status();
        final bucket = (snapshot.progress * 10).floor();
        if (bucket != lastBucket) {
          lastBucket = bucket;
          // ignore: avoid_print
          print('LIFEQUEST_RELEASE_DOWNLOAD=${bucket * 10}%');
        }
      });
      await model.download().timeout(const Duration(minutes: 15));
      poll.cancel();
    }
    final results = <Map<String, dynamic>>[];
    for (final fullHistory in [false, true]) {
      final now = DateTime(2026, 9, 15, 23);
      const goal = '퇴근 후 영어 공부를 다시 시작하고 싶다. 조용한 방에서 부담 없이 작은 일을 끝내고 싶다. ';
      final profile = const HunterProfile().copyWith(
        focuses: {GrowthFocus.learning, GrowthFocus.order},
        minutes: 3,
        energy: 1,
        goal: fullHistory ? goal * 5 : goal,
      );
      final history = <QuestSignal>[
        if (fullHistory)
          for (var i = 0; i < 42; i++)
            QuestSignal(
              questId: 'synthetic-$i',
              templateId: QuestDirectorEngine
                  .catalog[i % QuestDirectorEngine.catalog.length]
                  .id,
              feedback: QuestFeedback.values[i % QuestFeedback.values.length],
              at: now.subtract(Duration(hours: 42 - i)),
              title: String.fromCharCodes((goal * 2).runes.take(60)),
              minutes: 3,
            ),
      ];
      final plan = const QuestDirectorEngine().plan(
        profile: profile,
        history: history,
        now: now,
      );
      statusText.value =
          'Generating ${fullHistory ? 'with history' : 'first quests'} offline';
      final watch = Stopwatch()..start();
      final generated = await model.generate(plan, profile, history, 'ko', now);
      results.add({
        'case': fullHistory ? 'ko_history' : 'ko_new',
        'milliseconds': watch.elapsedMilliseconds,
        'valid': generated != null,
        'quests': generated?.map((q) => q.toJson()).toList(),
      });
    }
    final pass = results.every((e) => e['valid'] == true);
    statusText.value = pass
        ? 'PASS · native release inference'
        : 'FAIL · inspect synthetic outputs';
    // Only synthetic fixtures are printed, never real app profiles/history.
    // ignore: avoid_print
    print('LIFEQUEST_RELEASE_PROBE=${jsonEncode({'pass': pass, 'cases': [
      for (final row in results) {'case': row['case'], 'milliseconds': row['milliseconds'], 'valid': row['valid']},
    ]})}');
    // Android truncates long log entries; each synthetic quest gets its own line.
    for (final row in results) {
      for (final quest in row['quests'] as List? ?? []) {
        // ignore: avoid_print
        print('LIFEQUEST_RELEASE_QUEST=${jsonEncode({'case': row['case'], 'quest': quest})}');
      }
    }
  } catch (error) {
    statusText.value = 'FAIL · ${error.runtimeType}';
    // ignore: avoid_print
    print(
      'LIFEQUEST_RELEASE_PROBE=${jsonEncode({'pass': false, 'error': error.runtimeType.toString()})}',
    );
  } finally {
    poll?.cancel();
  }
}
