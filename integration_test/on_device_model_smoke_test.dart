import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:life_quest_final_v2/features/director/on_device_quest_model.dart';
import 'package:life_quest_final_v2/features/director/quest_director_engine.dart';

// Explicit opt-in: downloads the pinned 2.59 GB model to this test device.
// Run only on a disposable QA emulator/device, never a user's existing install.
const fullModel = bool.fromEnvironment('LIFEQUEST_AI_MODEL_SMOKE');
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final model = OnDeviceQuestModel();
  testWidgets('native bridge, interrupted download, resume and local inference',
      (tester) async {
    await tester.runAsync(() async {
      final before = await model.status();
      expect(before.status, isNot(OnDeviceModelStatus.checking));
      expect(before.status, isNot(OnDeviceModelStatus.unavailable),
          reason: before.reason);
      await expectLater(
        OnDeviceQuestModel.channel.invokeMethod(
            'generate', {'system': 'x' * 6001, 'prompt': 'invalid'}),
        throwsA(isA<PlatformException>()
            .having((e) => e.code, 'code', 'invalid_input')),
      );
      if (!fullModel) return;
      if (before.status == OnDeviceModelStatus.downloadable &&
          before.progress == 0) {
        Object? downloadError;
        final pending = model.download().catchError((Object error) {
          downloadError = error;
        });
        final progressDeadline = DateTime.now().add(const Duration(minutes: 2));
        while (DateTime.now().isBefore(progressDeadline)) {
          await Future<void>.delayed(const Duration(seconds: 1));
          final status = await model.status();
          if (status.progress > .001 || downloadError != null) break;
        }
        await model.cancel();
        await pending.timeout(const Duration(seconds: 40));
        expect(
            downloadError,
            isA<PlatformException>()
                .having((e) => e.code, 'code', 'cancelled'));
        final interrupted = await model.status();
        expect(interrupted.status, OnDeviceModelStatus.downloadable);
        expect(interrupted.progress, greaterThan(0));
        // ignore: avoid_print
        print('QA_MODEL_DOWNLOAD_RESUME_OFFSET=${interrupted.progress}');
      }
      if ((await model.status()).status != OnDeviceModelStatus.available) {
        await model.download().timeout(const Duration(minutes: 20));
      }
      expect((await model.status()).status, OnDeviceModelStatus.available);
      final now = DateTime(2026, 9, 15, 10);
      const profile = HunterProfile(
          focuses: {GrowthFocus.learning},
          minutes: 9,
          energy: 2,
          goal: '영어 공부를 작게 다시 시작하기');
      final plan = const QuestDirectorEngine()
          .plan(profile: profile, history: [], now: now);
      final watch = Stopwatch()..start();
      final generated = await model.generate(plan, profile, [], 'ko', now);
      watch.stop();
      // Synthetic QA profile only; never print real user goals or history.
      // ignore: avoid_print
      print(
          'QA_MODEL_INFERENCE_MS=${watch.elapsedMilliseconds}; VALID=${generated != null}');
      expect(generated, isNotNull,
          reason: 'Actual native output must pass the production parser');
      expect(generated!.every((q) => q.generatedFor('ko')), isTrue);
      expect(generated.map((q) => q.id), plan.map((q) => q.id));
      expect(generated.map((q) => q.minutes), plan.map((q) => q.minutes));
    });
  }, timeout: const Timeout(Duration(minutes: 25)));
}
