import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/models/quest.dart';
import 'package:life_quest_final_v2/screens/quests_screen.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SoundService.muteForTesting();

  for (final language in ['ko', 'en', 'ja', 'zh']) {
    testWidgets(
      'quest surfaces show XP without hidden game currency in $language',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        final state = CharacterState();
        await state.initializeForLocalGuest(name: 'Tester');
        state.addQuest('One real action', 10, QuestType.daily, StatType.health);
        await tester.pumpWidget(
          ChangeNotifierProvider.value(
            value: state,
            child: MaterialApp(
              locale: Locale(language),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              home: const QuestsScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final l10n = AppLocalizations.of(
          tester.element(find.byType(QuestsScreen)),
        )!;
        expect(find.byIcon(Icons.monetization_on), findsNothing);

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();
        expect(find.textContaining(l10n.questsGoldUnit), findsNothing);
        await tester.tap(find.text(l10n.cancel));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(Checkbox).first);
        await tester.pumpAndSettle();
        final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
        final message = (dialog.content! as Text).data!;
        expect(message, contains('+10 XP'));
        expect(message, isNot(contains(l10n.questsGoldUnit)));
        expect(message, isNot(contains('AP +')));
        await tester.pumpWidget(const SizedBox());
        state.dispose();
      },
    );
  }
}
