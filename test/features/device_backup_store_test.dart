import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_quest_final_v2/features/backup/device_backup.dart';
import 'package:life_quest_final_v2/features/backup/device_backup_store.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'backup_fixture.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SoundService.muteForTesting();
  final old = backupFixture(name: 'Before');
  final next = backupFixture(name: 'After');

  test(
    'interruption at each restore write recovers a consistent pair and keeps undo',
    () async {
      for (var failureAt = 1; failureAt <= 5; failureAt++) {
        final memory = <String, String>{
          DeviceBackupStore.profileKey: jsonEncode(old.profile),
          DeviceBackupStore.directorKey: jsonEncode(old.director),
          'unrelated-user-key': 'keep',
        };
        var operations = 0;
        var fail = true;
        final store = DeviceBackupStore(
          read: (key) => memory[key],
          write: (key, value) async {
            if (++operations == failureAt && fail) return false;
            memory[key] = value;
            return true;
          },
          remove: (key) async {
            if (++operations == failureAt && fail) return false;
            memory.remove(key);
            return true;
          },
        );
        await expectLater(store.restore(next), throwsStateError);
        fail = false;
        await store.recover();
        final name = jsonDecode(
          memory[DeviceBackupStore.profileKey]!,
        )['character']['name'];
        expect(name, failureAt == 1 ? 'Before' : 'After');
        expect(memory[DeviceBackupStore.journalKey], null);
        expect(memory['unrelated-user-key'], 'keep');
        if (failureAt > 1) expect(store.previousSnapshot()!.name, 'Before');
      }
    },
  );

  test('corrupt journal is preserved and does not overwrite profile', () async {
    SharedPreferences.setMockInitialValues({
      DeviceBackupStore.profileKey: jsonEncode(old.profile),
      DeviceBackupStore.journalKey: '{"version":1,"snapshot":{}}',
    });
    final prefs = await SharedPreferences.getInstance();
    await expectLater(
      DeviceBackupStore.preferences(prefs).recover(),
      throwsA(isA<InvalidBackup>()),
    );
    expect(prefs.getString(DeviceBackupStore.journalKey), isNotNull);
    expect(
      jsonDecode(
        prefs.getString(DeviceBackupStore.profileKey)!,
      )['character']['name'],
      'Before',
    );
  });

  test(
    'explicit validated import replaces a corrupt journal without losing the previous profile',
    () async {
      SharedPreferences.setMockInitialValues({
        DeviceBackupStore.profileKey: jsonEncode(old.profile),
        DeviceBackupStore.journalKey: '{broken',
      });
      final prefs = await SharedPreferences.getInstance();
      final store = DeviceBackupStore.preferences(prefs);
      await store.restore(next);
      expect(
        jsonDecode(
          prefs.getString(DeviceBackupStore.profileKey)!,
        )['character']['name'],
        'After',
      );
      expect(store.previousSnapshot()!.name, 'Before');
      expect(prefs.containsKey(DeviceBackupStore.journalKey), false);
    },
  );

  test(
    'fresh CharacterState recovers interrupted journal, then device deletion clears undo',
    () async {
      SharedPreferences.setMockInitialValues({
        DeviceBackupStore.profileKey: jsonEncode(old.profile),
        DeviceBackupStore.journalKey: jsonEncode({
          'version': 1,
          'snapshot': next.toJson(),
          'previous': {
            'profile': jsonEncode(old.profile),
            'director': jsonEncode(old.director),
          },
        }),
        'lifequest.purchases.v1.other-user': ['keep'],
      });
      final state = CharacterState();
      await state.initializeForLocalGuest(name: 'Unused');
      expect(state.character.name, 'After');
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey(DeviceBackupStore.journalKey), false);
      expect(
        DeviceBackupStore.preferences(prefs).previousSnapshot()!.name,
        'Before',
      );
      await state.deleteLocalProfile();
      expect(prefs.containsKey(DeviceBackupStore.profileKey), false);
      expect(prefs.containsKey(DeviceBackupStore.undoKey), false);
      expect(prefs.getStringList('lifequest.purchases.v1.other-user'), [
        'keep',
      ]);
      state.dispose();
    },
  );
}
