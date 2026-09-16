import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/state/dungeon_state.dart';
import 'package:life_quest_final_v2/screens/dungeon/dungeon_result_screen.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/theme/quest_theme.dart';

void main() {
  SoundService.muteForTesting();
  for (final code in ['ko', 'en', 'ja', 'zh']) {
    for (final victory in [true, false]) {
      testWidgets(
        'result remains readable at 320px / 200%: $code victory=$victory',
        (tester) async {
          SharedPreferences.setMockInitialValues({});
          tester.view.physicalSize = const Size(320, 700);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          final character = CharacterState();
          await character.initializeForLocalGuest(name: 'Result tester');
          final dungeon = DungeonState()
            ..bindCheckpoint(
              saved: null,
              save: character.saveDungeonCheckpoint,
            );
          dungeon.startRun(zone: 1, startingDeck: [], playerMaxHp: 80);
          dungeon.incrementMonstersKilled();
          dungeon.endRun(victory: victory);
          await dungeon.flushCheckpoint();
          await tester.pumpWidget(
            MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: character),
                ChangeNotifierProvider.value(value: dungeon),
              ],
              child: MaterialApp(
                theme: QuestTheme.build(Brightness.dark),
                locale: Locale(code),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(2)),
                  child: child!,
                ),
                home: DungeonResultScreen(isVictory: victory),
              ),
            ),
          );
          await tester.pumpAndSettle();
          await tester.scrollUntilVisible(find.byType(FilledButton), 250);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(
            tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
            isNotNull,
          );
          final gold = character.character.gold;
          await character.settleDungeonRun(dungeon);
          expect(character.character.gold, gold);
          await tester.pumpWidget(const SizedBox());
          character.dispose();
          dungeon.dispose();
        },
      );
    }
  }
}
