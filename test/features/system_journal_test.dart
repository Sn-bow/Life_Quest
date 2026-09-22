import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:life_quest_final_v2/features/system/system_journal.dart';
import 'package:life_quest_final_v2/features/backup/device_backup.dart';
import 'package:life_quest_final_v2/models/quest.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/state/character_state.dart';

class JournalFaultStore extends InMemorySharedPreferencesStore {
  JournalFaultStore() : super.empty();
  bool fail = false;
  Map<String, dynamic>? saved;
  @override
  Future<bool> setValue(String type, String key, Object value) async {
    if (key == 'flutter.${CharacterState.localProfileStorageKey}') {
      if (fail) throw StateError('Disk full');
      saved = jsonDecode(value as String);
    }
    return super.setValue(type, key, value);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SoundService.muteForTesting();
  final monday = DateTime(2026, 9, 21, 10);
  late JournalFaultStore store;
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    store = JournalFaultStore();
    SharedPreferencesStorePlatform.instance = store;
  });
  Future<CharacterState> profile() async {
    final s = CharacterState();
    await s.initializeForLocalGuest(name: 'Tester');
    addTearDown(s.dispose);
    return s;
  }

  test(
    'requires first action and time, respects refusal and rolling limits',
    () {
      final j = SystemJournal();
      expect(
        j.propose(
          now: monday,
          completions: 0,
          availableMinutes: 15,
          category: 1,
        ),
        isNull,
      );
      expect(
        j.propose(
          now: monday,
          completions: 1,
          availableMinutes: 2,
          category: 1,
        ),
        isNull,
      );
      final first = j.propose(
        now: monday,
        completions: 1,
        availableMinutes: 15,
        category: 1,
      )!;
      expect(
        j.propose(
          now: monday,
          completions: 1,
          availableMinutes: 15,
          category: 1,
        ),
        isNull,
      );
      first.status = SystemOfferStatus.declined;
      expect(
        j.propose(
          now: monday.add(const Duration(hours: 3)),
          completions: 1,
          availableMinutes: 15,
          category: 1,
        ),
        isNull,
      );
      for (var i = 1; i <= 2; i++) {
        final o = j.propose(
          now: monday.add(Duration(days: i)),
          completions: 1,
          availableMinutes: 15,
          category: 1,
        )!;
        o.status = SystemOfferStatus.declined;
      }
      expect(j.offers.map((o) => o.template).toSet().length, 3);
      expect(
        j.propose(
          now: monday.add(const Duration(days: 3)),
          completions: 1,
          availableMinutes: 15,
          category: 1,
        ),
        isNull,
      );
      expect(
        j.propose(
          now: monday.add(const Duration(days: 7, minutes: 1)),
          completions: 1,
          availableMinutes: 15,
          category: 1,
        ),
        isNotNull,
      );
    },
  );
  test('expiry is exclusive, serialized deadlines do not restart', () {
    final j = SystemJournal();
    final o = j.propose(
      now: monday,
      completions: 1,
      availableMinutes: 15,
      category: 1,
    )!;
    o.status = SystemOfferStatus.accepted;
    o.acceptedAt = monday;
    o.deadline = monday.add(const Duration(minutes: 20));
    final restored = SystemJournal.fromJson(jsonDecode(jsonEncode(j.toJson())));
    expect(restored.current!.deadline, o.deadline);
    expect(restored.expire(monday.add(const Duration(minutes: 19))), isFalse);
    expect(restored.expire(monday.add(const Duration(minutes: 20))), isTrue);
    expect(restored.current, isNull);
  });
  test(
    'actual bonus receipt and level crossing persist, retry never duplicates',
    () async {
      final s = await profile();
      s.character.xp = 145;
      s.character.streak = 1;
      s.addQuest('Read', 10, QuestType.daily, StatType.wisdom);
      final q = s.dailyQuests.last;
      final r = await s.completeQuestDurably(q);
      expect(r.questXp, 11);
      expect(r.bonusXp, 50);
      expect(r.xp, 61);
      expect(r.levelBefore, 1);
      expect(r.levelAfter, 2);
      expect(r.xpAfter, 56);
      expect(s.todayGrowthDelta.xp, 11);
      expect(s.recordedXpToday, 61);
      expect(r.statChanges[1], 3);
      await s.completeQuestDurably(q);
      expect(s.systemJournal.receipts.length, 1);
      expect(s.character.xp, 56);
      final restored = await profile();
      expect(restored.character.xp, 56);
      expect(restored.lastGrowthReceipt!.xp, 61);
    },
  );
  test('failed write emits no completion, retry stores same award', () async {
    final s = await profile();
    s.addQuest('Read', 10, QuestType.daily, StatType.wisdom);
    await s.forceSave();
    var calls = 0;
    s.onQuestCompleted = (_) => calls++;
    store.fail = true;
    final q = s.dailyQuests.last;
    await expectLater(s.completeQuestDurably(q), throwsStateError);
    expect(calls, 0);
    final xp = s.character.xp;
    store.fail = false;
    await s.completeQuestDurably(q);
    expect(s.character.xp, xp);
    expect(s.systemJournal.receipts.length, 1);
    expect(calls, 1);
    expect(store.saved!['systemJournal']['receipts'].length, 1);
  });
  test(
    'decline saves and does not take XP or generate another same day',
    () async {
      final s = await profile();
      s.character.totalQuestCompletions = 1;
      s.character.xp = 31;
      await s.maybeOfferSystemQuest(availableMinutes: 15, now: monday);
      await s.changeSystemOffer(
        s.systemJournal.current!,
        SystemOfferStatus.declined,
        now: monday,
      );
      expect(s.character.xp, 31);
      await s.maybeOfferSystemQuest(
        availableMinutes: 15,
        now: monday.add(const Duration(hours: 1)),
      );
      expect(s.systemJournal.current, isNull);
      expect(s.systemJournal.offers.length, 1);
    },
  );
  test(
    'system reward is fixed, durable, survives backup, and cannot be claimed twice',
    () async {
      final s = await profile();
      s.character.totalQuestCompletions = 1;
      s.character.streak = 5;
      final now = DateTime.now();
      await s.maybeOfferSystemQuest(availableMinutes: 15, now: now);
      final o = s.systemJournal.current!;
      await s.changeSystemOffer(o, SystemOfferStatus.accepted, now: now);
      final r = await s.completeSystemOffer(
        o,
        'Three minutes',
        now: now.add(const Duration(minutes: 3)),
      );
      expect(r.questXp, 15);
      expect(r.bonusXp, 50);
      expect(r.xp, 65);
      expect(o.status, SystemOfferStatus.completed);
      await s.completeSystemOffer(o, 'Three minutes');
      expect(s.character.xp, 65);
      expect(s.systemJournal.receipts.length, 1);
      final snapshot = DeviceSnapshot.create(
        profile: s.exportDeviceProfile(),
        director: {},
        createdAt: now,
      );
      expect(snapshot.profile['systemJournal']['receipts'].length, 1);
      final restored = await profile();
      expect(
        restored.systemJournal.offers.single.status,
        SystemOfferStatus.completed,
      );
    },
  );
  test('failed accept can retry with original handle after rollback', () async {
    final s = await profile();
    s.character.totalQuestCompletions = 1;
    await s.maybeOfferSystemQuest(availableMinutes: 15);
    final original = s.systemJournal.current!;
    store.fail = true;
    await expectLater(
      s.changeSystemOffer(original, SystemOfferStatus.accepted),
      throwsStateError,
    );
    expect(s.systemJournal.current!.status, SystemOfferStatus.offered);
    store.fail = false;
    await s.changeSystemOffer(original, SystemOfferStatus.accepted);
    expect(s.systemJournal.current!.status, SystemOfferStatus.accepted);
  });
  test('late completion cannot grant a system reward', () async {
    final s = await profile();
    s.character.totalQuestCompletions = 1;
    await s.maybeOfferSystemQuest(availableMinutes: 15, now: monday);
    final o = s.systemJournal.current!;
    await s.changeSystemOffer(o, SystemOfferStatus.accepted, now: monday);
    await expectLater(
      s.completeSystemOffer(
        o,
        'Late',
        now: monday.add(const Duration(minutes: 20)),
      ),
      throwsStateError,
    );
    expect(s.character.xp, 0);
    expect(s.systemJournal.receipts, isEmpty);
    expect(o.status, SystemOfferStatus.expired);
  });
  test(
    'weekly window includes Monday midnight and excludes future completions',
    () async {
      final s = await profile();
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, now.day - now.weekday + 1);
      s.addQuest('Monday', 10, QuestType.weekly, StatType.wisdom);
      s.weeklyQuests.last.isCompleted = true;
      s.weeklyQuests.last.completedDate = start;
      s.addQuest('Future', 10, QuestType.weekly, StatType.wisdom);
      s.weeklyQuests.last.isCompleted = true;
      s.weeklyQuests.last.completedDate = now.add(const Duration(days: 8));
      expect(s.weeklyCompletedQuests[1], 1);
      expect(s.weeklyCompletedQuests.values.fold<int>(0, (a, b) => a + b), 1);
    },
  );
}
