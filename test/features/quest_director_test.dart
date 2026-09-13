import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_quest_final_v2/features/director/quest_director_engine.dart';
import 'package:life_quest_final_v2/features/director/quest_director_state.dart';
import 'package:life_quest_final_v2/features/director/quest_generation.dart';
import 'package:life_quest_final_v2/features/director/on_device_quest_model.dart';
import 'package:life_quest_final_v2/models/quest.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';

class FakeModel extends OnDeviceQuestModel {
  Completer<List<DirectedQuest>?>? pending;
  @override
  Future<ModelSnapshot> status() async =>
      const ModelSnapshot(OnDeviceModelStatus.available);
  @override
  Future<void> cancel() async {}
  @override
  Future<List<DirectedQuest>?> generate(
    List<DirectedQuest> plan,
    HunterProfile profile,
    List<QuestSignal> history,
    String locale,
    DateTime now,
  ) => pending!.future;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SoundService.muteForTesting();
  final now = DateTime(2026, 9, 15, 9);
  const engine = QuestDirectorEngine();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('quiet hours exclude audible templates in every focus and budget', () {
    for (final hour in [0, 6, 21, 23]) {
      for (final focus in GrowthFocus.values) {
        final plan = engine.plan(
          profile: HunterProfile(focuses: {focus}, minutes: 60),
          history: [],
          now: DateTime(2026, 9, 15, hour),
        );
        expect(plan, hasLength(3));
        expect(
          plan.any(
            (q) => {'walk', 'language', 'listen'}.contains(q.template.id),
          ),
          false,
        );
      }
    }
  });

  test(
    'quiet output validation rejects audible actions in all four languages',
    () {
      final plan = engine.plan(
        profile: const HunterProfile(),
        history: [],
        now: now,
      );
      final cases = {
        'ko': ['작은 읽기', '한 문장을 소리 내어 읽으세요.', '조용한 시작'],
        'en': ['Small reading', 'Read one sentence aloud.', 'A small start'],
        'ja': ['短い読み物', '一文を声に出して読む。', '小さな始まり'],
        'zh': ['简单阅读', '大声朗读一个句子。', '轻松开始'],
      };
      for (final entry in cases.entries) {
        final raw = jsonEncode({
          'quests': [
            for (var i = 0; i < plan.length; i++)
              {
                'id': plan[i].template.id,
                'title': '${entry.value[0]}$i',
                'instruction': entry.value[1],
                'reason': entry.value[2],
              },
          ],
        });
        expect(QuestGeneration.parse(raw, plan, entry.key), isNotNull);
        expect(
          QuestGeneration.parse(raw, plan, entry.key, silenceRequired: true),
          isNull,
        );
      }
    },
  );

  test(
    'all supported budgets stay within the daily limit and have unique IDs',
    () {
      for (var minute = 3; minute <= 60; minute++) {
        for (var energy = 1; energy <= 3; energy++) {
          final profile = HunterProfile(minutes: minute, energy: energy);
          final plan = engine.plan(profile: profile, history: [], now: now);
          expect(plan.length, 3);
          expect(plan.map((q) => q.id).toSet().length, 3);
          expect(
            plan.fold(0, (sum, q) => sum + q.minutes),
            lessThanOrEqualTo(minute),
          );
          if (energy == 1) expect(plan.every((q) => q.minutes <= 3), isTrue);
          expect(
            plan.every(
              (q) =>
                  q.xp == Quest.xpForDifficulty(q.difficulty, QuestType.daily),
            ),
            isTrue,
          );
        }
      }
    },
  );
  test(
    'repeated difficulty reduces effort, and accepted time is never reassigned',
    () {
      final hard = [
        QuestSignal(
          questId: 'old',
          templateId: 'read',
          feedback: QuestFeedback.tooHard,
          at: now.subtract(const Duration(days: 1)),
        ),
      ];
      final plan = engine.plan(
        profile: const HunterProfile(minutes: 30),
        history: hard,
        now: now,
      );
      expect(plan.every((q) => q.recovery && q.minutes <= 3), isTrue);
      expect(
        engine.plan(
          profile: const HunterProfile(minutes: 3),
          history: [],
          now: now,
          usedMinutes: 3,
          slots: 1,
        ),
        isEmpty,
      );
    },
  );
  test(
    'model text cannot add reward fields, change counts, or hide a longer duration',
    () {
      final plan = engine.plan(
        profile: const HunterProfile(),
        history: [],
        now: now,
      );
      final valid = {
        'quests': List.generate(
          3,
          (i) => {
            'id': plan[i].template.id,
            'title': '작은 행동 $i',
            'instruction': '책상 위 물건 하나를 정리하세요.',
            'reason': '작게 시작하고 싶은 목표에 맞췄어요.',
          },
        ),
      };
      final accepted = QuestGeneration.parse(jsonEncode(valid), plan, 'ko');
      expect(accepted, hasLength(3));
      expect(accepted!.map((q) => q.id), plan.map((q) => q.id));
      expect(accepted.map((q) => q.xp), plan.map((q) => q.xp));
      final encoded = jsonEncode(valid);
      expect(
        QuestGeneration.parse(
          encoded.substring(0, encoded.length - 1),
          plan,
          'ko',
        ),
        isNotNull,
      );
      expect(
        QuestGeneration.parse(
          encoded.substring(0, encoded.length - 2),
          plan,
          'ko',
        ),
        isNull,
      );
      expect(QuestGeneration.parse('$encoded extra text', plan, 'ko'), isNull);
      final reordered = QuestGeneration.parse(
        jsonEncode({'quests': (valid['quests'] as List).reversed.toList()}),
        plan,
        'ko',
      );
      expect(
        reordered!.map((q) => q.generatedTitle),
        accepted.map((q) => q.generatedTitle),
      );
      final duplicate = List<Map<String, dynamic>>.from(
        valid['quests'] as List,
      ).map((q) => {...q}).toList();
      duplicate[1]['id'] = duplicate.first['id'];
      expect(
        QuestGeneration.parse(jsonEncode({'quests': duplicate}), plan, 'ko'),
        isNull,
      );
      (valid['quests'] as List)[0]['xp'] = '99999';
      expect(QuestGeneration.parse(jsonEncode(valid), plan, 'ko'), isNull);
      (valid['quests'] as List)[0].remove('xp');
      (valid['quests'] as List)[0]['instruction'] = '밤새 공부하세요.';
      expect(QuestGeneration.parse(jsonEncode(valid), plan, 'ko'), isNull);
      (valid['quests'] as List)[0]['instruction'] = '30분 정리하세요.';
      expect(QuestGeneration.parse(jsonEncode(valid), plan, 'ko'), isNull);
      expect(QuestGeneration.parse('{"quests":[]}', plan, 'ko'), isNull);
    },
  );
  test('profile parsing bounds corrupt inputs and keeps Unicode intact', () {
    final profile = HunterProfile.fromJson({
      'minutes': -50,
      'energy': 900,
      'goal': '🙂' * 200,
      'focuses': ['invalid'],
    });
    expect(profile.minutes, 3);
    expect(profile.energy, 3);
    expect(profile.goal.runes.length, 120);
    expect(profile.focuses, isNotEmpty);
  });
  test(
    'accepted IDs survive restarts and never produce a fourth daily quest',
    () async {
      final state = QuestDirectorState(clock: () => now, model: FakeModel());
      await state.bind('person-a');
      for (final quest in List<DirectedQuest>.of(state.suggestions)) {
        await state.accept(quest);
      }
      expect(state.suggestions, isEmpty);
      expect(state.acceptedToday, 3);
      await state.configure(const HunterProfile(minutes: 60));
      expect(state.suggestions, isEmpty);
      final restored = QuestDirectorState(clock: () => now, model: FakeModel());
      await restored.bind('person-a');
      expect(restored.suggestions, isEmpty);
      expect(restored.acceptedToday, 3);
      await restored.bind('person-b');
      expect(restored.acceptedToday, 0);
      expect(restored.profile.minutes, 15);
      state.dispose();
      restored.dispose();
    },
  );

  test(
    'quiet hours rebuild suggestions without releasing accepted daily slots',
    () async {
      var time = DateTime(2026, 9, 15, 20);
      final state = QuestDirectorState(clock: () => time, model: FakeModel());
      await state.bind('quiet-transition');
      final accepted = state.suggestions.first;
      await state.accept(accepted);
      time = DateTime(2026, 9, 15, 21);
      await state.refreshDay();
      expect(state.acceptedToday, 1);
      expect(state.suggestions.length, lessThanOrEqualTo(2));
      expect(state.suggestions.any((q) => q.id == accepted.id), false);
      expect(
        state.suggestions.any(
          (q) => {'walk', 'language', 'listen'}.contains(q.template.id),
        ),
        false,
      );
      state.dispose();
    },
  );
  test(
    'an inference completing after a profile change cannot replace the current plan',
    () async {
      final model = FakeModel()..pending = Completer();
      final state = QuestDirectorState(clock: () => now, model: model);
      await state.bind('a');
      final old = List<DirectedQuest>.of(state.suggestions);
      final generation = state.personalize('ko');
      await state.configure(const HunterProfile(energy: 1, minutes: 3));
      model.pending!.complete(
        old.map((q) => q.withText('옛 추천', '옛 행동', '옛 이유', 'ko')).toList(),
      );
      await generation;
      expect(state.usedModel, isFalse);
      expect(state.suggestions.every((q) => q.minutes == 1), isTrue);
      expect(state.busy, isFalse);
      state.dispose();
    },
  );
  test(
    'new days rotate one-off quests; recurring completions can teach on each day',
    () async {
      var clock = now;
      final state = QuestDirectorState(clock: () => clock, model: FakeModel());
      await state.bind('a');
      await state.recordSignal(
        'daily-1',
        'manual:wisdom',
        QuestFeedback.completed,
        title: '읽기',
      );
      await state.recordSignal(
        'daily-1',
        'manual:wisdom',
        QuestFeedback.completed,
        title: '읽기',
      );
      expect(state.history.length, 1);
      for (final q in List<DirectedQuest>.of(state.suggestions)) {
        await state.accept(q);
      }
      clock = clock.add(const Duration(days: 1));
      await state.refreshDay();
      expect(state.acceptedToday, 0);
      expect(state.suggestions, hasLength(3));
      await state.recordSignal(
        'daily-1',
        'manual:wisdom',
        QuestFeedback.completed,
        title: '읽기',
      );
      expect(state.history.length, 2);
      state.dispose();
    },
  );
  test(
    'returning after missed habits keeps earned XP, level and combat HP',
    () {
      final state = CharacterState()..initializeForTesting();
      final c = state.character;
      c.level = 4;
      c.xp = 67;
      c.characterHp = 5;
      final yesterday = now.subtract(const Duration(days: 1));
      final recurring = Quest(
        id: 'recurring',
        name: 'read',
        xp: 10,
        type: QuestType.daily,
        category: StatType.wisdom,
      );
      final daily = Quest(
        id: 'director:2026-09-14:read',
        name: 'read once',
        xp: 10,
        type: QuestType.daily,
        category: StatType.wisdom,
        scheduledDay: '2026-09-14',
        directorTemplateId: 'read',
      );
      state.debugSeedState(character: c, dailyQuests: [recurring, daily]);
      state.debugResetQuestsIfNeeded(yesterday, now: now);
      expect(c.level, 4);
      expect(c.xp, 67);
      expect(c.characterHp, 5);
      expect(state.dailyQuests.map((q) => q.id), ['recurring']);
      state.dispose();
    },
  );
  test(
    'selected focus stays selected when three safe actions are available',
    () {
      for (final focus in GrowthFocus.values) {
        final plan = engine.plan(
          profile: HunterProfile(focuses: {focus}, minutes: 3),
          history: [],
          now: now,
        );
        expect(plan.length, 3);
        expect(plan.every((q) => q.template.focus == focus), isTrue);
      }
    },
  );
  test(
    'sign-out drains writes and ignores late inference after account deletion',
    () async {
      final model = FakeModel()..pending = Completer();
      final state = QuestDirectorState(model: model, clock: () => now);
      await state.bind('deleted');
      await state.configure(const HunterProfile(goal: 'private goal'));
      final old = List<DirectedQuest>.of(state.suggestions);
      final inference = state.personalize('ko');
      await state.endSession();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('lifequest.director.v1.deleted');
      model.pending!.complete(
        old.map((q) => q.withText('이전 추천', '이전 행동', '이전 이유', 'ko')).toList(),
      );
      await inference;
      expect(prefs.containsKey('lifequest.director.v1.deleted'), isFalse);
      expect(state.ready, isFalse);
      expect(state.profile.goal, isEmpty);
      await state.bind('next');
      expect(state.usedModel, isFalse);
      expect(state.profile.goal, isEmpty);
      state.dispose();
    },
  );
  test(
    'automatic inference is bounded across reopen, retries remain explicit',
    () async {
      final model = FakeModel()..pending = Completer();
      final state = QuestDirectorState(model: model, clock: () => now);
      await state.bind('bounded');
      await state.configure(const HunterProfile(goal: '작게 시작'));
      final work = state.personalizeIfNeeded('ko');
      model.pending!.complete(null);
      await work;
      expect(state.modelIssue, 'generation_rejected');
      final restored = QuestDirectorState(model: model, clock: () => now);
      await restored.bind('bounded');
      model.pending = Completer();
      await restored.personalizeIfNeeded('ko');
      expect(restored.busy, isFalse);
      final retry = restored.personalize('ko');
      expect(restored.busy, isTrue);
      model.pending!.complete(null);
      await retry;
      state.dispose();
      restored.dispose();
    },
  );
  test(
    'character boundary rejects stale, malformed and excess recommendations',
    () {
      final state = CharacterState()..initializeForTesting();
      final plan = engine.plan(
        profile: const HunterProfile(),
        history: [],
        now: now,
      );
      Quest make(DirectedQuest q, {String? day, String? id}) => Quest(
        id: id ?? q.id,
        name: q.title('ko'),
        xp: q.xp,
        difficulty: q.difficulty,
        type: QuestType.daily,
        category: q.template.stat,
        directorTemplateId: q.template.id,
        scheduledDay: day ?? localDay(now),
        estimatedMinutes: q.minutes,
      );
      expect(
        state.acceptDailySuggestion(
          make(plan.first, day: '2026-09-14'),
          now: now,
        ),
        isFalse,
      );
      expect(
        state.acceptDailySuggestion(make(plan.first, id: 'spoof'), now: now),
        isFalse,
      );
      for (final q in plan) {
        expect(state.acceptDailySuggestion(make(q), now: now), isTrue);
      }
      expect(state.acceptDailySuggestion(make(plan.first), now: now), isTrue);
      expect(
        state.dailyQuests.where((q) => q.scheduledDay == localDay(now)).length,
        3,
      );
      final next = engine.plan(
        profile: const HunterProfile(),
        history: [],
        now: now,
        excludedIds: plan.map((q) => q.id).toSet(),
      );
      expect(state.acceptDailySuggestion(make(next.first), now: now), isFalse);
      state.dispose();
    },
  );
}
