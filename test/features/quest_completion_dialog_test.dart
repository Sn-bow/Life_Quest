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

  testWidgets('Japanese completion confirmation shows gains with plus signs', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final state = CharacterState();
    await state.initializeForLocalGuest(name: 'Tester');
    state.addQuest('5分休む', 10, QuestType.daily, StatType.health);
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: const MaterialApp(
          locale: Locale('ja'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: QuestsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
    final message = (dialog.content! as Text).data!;
    expect(message, contains('基本報酬'));
    expect(message, contains('+10 XP'));
    expect(message, contains('+5 ゴールド'));
    expect(message, isNot(contains('- 10 XP')));
    expect(message, isNot(contains('- 5 ゴールド')));
    await tester.pumpWidget(const SizedBox());
    state.dispose();
  });
}
