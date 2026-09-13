import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_quest_final_v2/features/director/quest_director_state.dart';
import 'package:life_quest_final_v2/features/director/on_device_quest_model.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/screens/today_screen.dart';
import 'package:life_quest_final_v2/screens/growth_hub_screen.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/theme/quest_theme.dart';

class LayoutModel extends OnDeviceQuestModel {
  @override
  Future<ModelSnapshot> status() async =>
      const ModelSnapshot(OnDeviceModelStatus.unavailable);
  @override
  Future<void> cancel() async {}
}

void main() {
  SoundService.muteForTesting();
  for (final locale in ['ko', 'en', 'ja', 'zh']) {
    for (final scene in ['today', 'growth']) {
      testWidgets('$scene fits 320px with 200% text in $locale',
          (tester) async {
        SharedPreferences.setMockInitialValues({});
        tester.view.physicalSize = const Size(320, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final character = CharacterState()..initializeForTesting();
        character.character.name = '아주 긴 사용자 이름 Long';
        final director = QuestDirectorState(model: LayoutModel());
        await director.bind('layout-test');
        await tester.pumpWidget(MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: character),
              ChangeNotifierProvider.value(value: director),
            ],
            child: MaterialApp(
              theme: QuestTheme.build(Brightness.dark),
              locale: Locale(locale),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(2)),
                  child: child!),
              home: scene == 'today'
                  ? TodayScreen(onOpenQuests: () {}, onOpenDungeon: () {})
                  : const GrowthHubScreen(),
            )));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.drag(find.byType(ListView).first, const Offset(0, -650));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        director.dispose();
        character.dispose();
      });
    }
  }
}
