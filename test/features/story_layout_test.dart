import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_quest_final_v2/features/story/story_chapter.dart';
import 'package:life_quest_final_v2/features/story/story_screens.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/theme/quest_theme.dart';

void main() {
  SoundService.muteForTesting();
  for (final book in StoryRepository.chapterIds) {
    for (final locale in ['ko', 'en', 'ja', 'zh']) {
      testWidgets(
        '$book can be read and chosen at 320px, 200% text in $locale',
        (tester) async {
          SharedPreferences.setMockInitialValues({});
          tester.view.physicalSize = const Size(320, 900);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          final semantics = tester.ensureSemantics();
          final state = CharacterState();
          await state.initializeForLocalGuest(name: 'Synthetic tester');
          final chapter = StoryChapter.fromJson(
            jsonDecode(
              File('assets/story/${book}_$locale.json').readAsStringSync(),
            ),
          );
          final first = chapter.scenes.first;
          await tester.pumpWidget(
            ChangeNotifierProvider.value(
              value: state,
              child: MaterialApp(
                theme: QuestTheme.build(Brightness.dark),
                locale: Locale(locale),
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(2)),
                  child: child!,
                ),
                home: StoryReaderScreen(chapter: chapter, index: 0),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(find.bySemanticsLabel(first.narration), findsOneWidget);
          await tester.scrollUntilVisible(
            find.text(first.choices.first.label),
            600,
            scrollable: find.byType(Scrollable).first,
          );
          await tester.pumpAndSettle();
          await Scrollable.ensureVisible(
            tester.element(find.text(first.choices.first.label)),
            alignment: .5,
          );
          await tester.pumpAndSettle();
          expect(
            find.text(first.choices.first.label).hitTestable(),
            findsOneWidget,
          );
          await tester.tap(find.text(first.choices.first.label));
          await tester.pumpAndSettle();
          expect(
            state.storyChoices[chapter.choiceKey(0)],
            first.choices.first.id,
          );
          await tester.scrollUntilVisible(
            find.text(first.choices.first.response),
            400,
            scrollable: find.byType(Scrollable).first,
          );
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox());
          state.dispose();
          semantics.dispose();
        },
      );
    }
  }
}
