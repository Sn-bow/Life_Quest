import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/features/director/quest_director_engine.dart';
import 'package:life_quest_final_v2/features/director/quest_director_state.dart';
import 'package:life_quest_final_v2/features/session/session_gate.dart';
import 'package:life_quest_final_v2/features/session/welcome_screen.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../director_layout_test.dart' show LayoutModel;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SoundService.muteForTesting();

  test(
    'interrupted first launch restores real name and quest profile',
    () async {
      SharedPreferences.setMockInitialValues({});
      const setup = WelcomeSetup(
        name: 'Seok',
        focus: GrowthFocus.order,
        goal: 'Clear one shelf after work',
        minutes: 5,
      );
      await setup.savePending();

      final character = CharacterState();
      final director = QuestDirectorState(model: LayoutModel());
      await initializeDeviceHunterProfile(
        character: character,
        director: director,
        fallbackName: 'Chronicler',
        languageCode: 'en',
      );
      expect(character.character.name, 'Seok');
      expect(character.character.usesDefaultGuestName, isFalse);
      expect(director.profile.configured, isTrue);
      expect(director.profile.focuses, {GrowthFocus.order});
      expect(director.profile.goal, setup.goal);
      expect(director.profile.minutes, 5);
      expect(director.suggestions, isNotEmpty);
      expect(await WelcomeSetup.loadPending(), isNull);
      director.dispose();
      character.dispose();

      // On a later launch, saved values take precedence over fallback copy.
      final reopened = CharacterState();
      final restoredDirector = QuestDirectorState(model: LayoutModel());
      await initializeDeviceHunterProfile(
        character: reopened,
        director: restoredDirector,
        fallbackName: 'Chronicler',
        languageCode: 'en',
      );
      await restoredDirector.bind(reopened.personalizationScope);
      expect(reopened.character.name, 'Seok');
      expect(restoredDirector.profile.goal, setup.goal);
      expect(restoredDirector.profile.focuses, {GrowthFocus.order});
      restoredDirector.dispose();
      reopened.dispose();
    },
  );
}
