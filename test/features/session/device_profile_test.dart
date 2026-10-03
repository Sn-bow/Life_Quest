import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_quest_final_v2/data/guest_name_localization.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/features/session/session_state.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/features/research/beta_study.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SoundService.muteForTesting();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'only generated guest names localize without rewriting saved name',
    () async {
      final state = CharacterState();
      await state.initializeForLocalGuest(
        name: 'Chronicler',
        languageCode: 'en',
        usesDefaultGuestName: true,
      );
      expect(state.character.name, 'Chronicler');
      expect(state.character.usesDefaultGuestName, true);
      for (final (code, expected) in [
        ('ko', '기록자'),
        ('en', 'Chronicler'),
        ('ja', '記録者'),
        ('zh', '記錄者'),
      ]) {
        expect(
          GuestNameLocalization.displayName(
            state.character,
            lookupAppLocalizations(Locale(code)),
          ),
          expected,
        );
      }
      await state.forceSave();
      final prefs = await SharedPreferences.getInstance();
      final saved =
          jsonDecode(prefs.getString(CharacterState.localProfileStorageKey)!)
              as Map<String, dynamic>;
      expect(saved['character']['name'], 'Chronicler');
      expect(saved['character']['usesDefaultGuestName'], true);
      state.dispose();

      final restored = CharacterState();
      await restored.initializeForLocalGuest(name: '記録者', languageCode: 'ja');
      expect(restored.character.name, 'Chronicler');
      expect(
        GuestNameLocalization.displayName(
          restored.character,
          lookupAppLocalizations(const Locale('ja')),
        ),
        '記録者',
      );
      await restored.changeCharacterName('Chronicler');
      expect(restored.character.usesDefaultGuestName, false);
      expect(
        GuestNameLocalization.displayName(
          restored.character,
          lookupAppLocalizations(const Locale('ja')),
        ),
        'Chronicler',
      );
      restored.dispose();
    },
  );

  test(
    'legacy guest default migrates only for an exact built-in name',
    () async {
      final state = CharacterState();
      await state.initializeForLocalGuest(name: 'Chronicler');
      await state.forceSave();
      state.dispose();
      final prefs = await SharedPreferences.getInstance();
      final saved =
          jsonDecode(prefs.getString(CharacterState.localProfileStorageKey)!)
              as Map<String, dynamic>;
      (saved['character'] as Map<String, dynamic>).remove(
        'usesDefaultGuestName',
      );
      await prefs.setString(
        CharacterState.localProfileStorageKey,
        jsonEncode(saved),
      );
      final migrated = CharacterState();
      await migrated.initializeForLocalGuest(name: '記録者', languageCode: 'ja');
      expect(migrated.character.name, 'Chronicler');
      expect(migrated.character.usesDefaultGuestName, true);
      migrated.dispose();
    },
  );

  test(
    'real device profile starts empty, preserves rewards and name across restart',
    () async {
      final state = CharacterState();
      await state.initializeForLocalGuest(name: '각성자');
      expect(state.isLocalGuest, true);
      expect(state.personalizationScope, 'device');
      expect(state.dailyQuests, isEmpty);
      expect(state.weeklyQuests, isEmpty);
      state.character.xp = 40;
      await state.changeCharacterName('나의 기록');
      await state.forceSave();
      state.dispose();
      final restored = CharacterState();
      await restored.initializeForLocalGuest(name: '다른 기본 이름');
      expect(restored.character.name, '나의 기록');
      expect(restored.character.xp, 40);
      expect(restored.isDataLoaded, true);
      restored.dispose();
    },
  );

  test(
    'invalid device save is preserved and never silently replaced',
    () async {
      for (final raw in [
        '',
        '{bad json',
        jsonEncode({'character': 'invalid'}),
      ]) {
        SharedPreferences.setMockInitialValues({
          CharacterState.localProfileStorageKey: raw,
        });
        final state = CharacterState();
        await expectLater(
          state.initializeForLocalGuest(name: '새 이름'),
          throwsA(isA<FormatException>()),
        );
        expect(state.isDataLoaded, false);
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString(CharacterState.localProfileStorageKey), raw);
        state.dispose();
      }
    },
  );

  test(
    'leaving a device profile retains it; delete clears only its own data',
    () async {
      final state = CharacterState();
      final session = SessionState();
      await session.initialize();
      await session.selectDevice(true);
      await state.initializeForLocalGuest(name: '각성자');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('lifequest.director.v1.device', 'device history');
      await prefs.setString(BetaStudy.key, 'study record from a previous beta');
      await prefs.setString(
        'lifequest.director.v1.another-account',
        'other history',
      );
      await prefs.setString(
        'lifequest.qaPreview.state.v2',
        'QA remains separate',
      );
      await session.selectDevice(false);
      expect(prefs.containsKey(CharacterState.localProfileStorageKey), true);
      await state.deleteLocalProfile();
      expect(prefs.containsKey(CharacterState.localProfileStorageKey), false);
      expect(prefs.containsKey('lifequest.director.v1.device'), false);
      expect(prefs.containsKey(BetaStudy.key), false);
      expect(
        prefs.getString('lifequest.director.v1.another-account'),
        'other history',
      );
      expect(
        prefs.getString('lifequest.qaPreview.state.v2'),
        'QA remains separate',
      );
      state.dispose();
      session.dispose();
    },
  );

  test(
    'queued device snapshots keep their destination when the session resets',
    () async {
      final state = CharacterState();
      await state.initializeForLocalGuest(name: '원래 프로필');
      state.character.xp = 91;
      final saving = state.forceSave();
      state.resetState();
      state.initializeForTesting();
      await saving;
      final prefs = await SharedPreferences.getInstance();
      final data = jsonDecode(
        prefs.getString(CharacterState.localProfileStorageKey)!,
      );
      expect(data['character']['name'], '원래 프로필');
      expect(data['character']['xp'], 91);
      state.dispose();
    },
  );
}
