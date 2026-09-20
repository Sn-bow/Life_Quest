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

Widget host(
  CharacterState state,
  Widget home, {
  String locale = 'en',
  double scale = 1,
}) => ChangeNotifierProvider.value(
  value: state,
  child: MaterialApp(
    theme: QuestTheme.build(Brightness.dark),
    locale: Locale(locale),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(scale)),
      child: child!,
    ),
    home: home,
  ),
);

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    350,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
  await Scrollable.ensureVisible(tester.element(finder), alignment: .5);
  await tester.pumpAndSettle();
  expect(finder.hitTestable(), findsOneWidget);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  SoundService.muteForTesting();
  setUp(() => SharedPreferences.setMockInitialValues({}));
  for (final locale in ['ko', 'en', 'ja', 'zh']) {
    testWidgets('free stories and the pack preview can be selected at 320px / 200% in $locale', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final books = (await tester.runAsync(
        () => StoryRepository.load(locale),
      ))!;
      final state = CharacterState();
      await state.initializeForLocalGuest(name: 'Reader');
      await tester.pumpWidget(
        host(state, const StoryLibraryScreen(), locale: locale, scale: 2),
      );
      await tester.pumpAndSettle();
      for (final book in books) {
        final card = find.ancestor(
          of: find.text(book.title),
          matching: find.byType(Card),
        );
        final button = find.descendant(
          of: card,
          matching: find.byType(OutlinedButton),
        );
        await tapVisible(tester, button);
        expect(find.byType(StoryReaderScreen), findsOneWidget);
        expect(state.activeStoryChapterId, book.id);
        expect(tester.takeException(), isNull);
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
      }
      await tester.pumpWidget(const SizedBox());
      state.dispose();
    });
  }

  testWidgets(
    'direct reader continues and returns to its chapter, preserving earlier choices',
    (tester) async {
      final books = (await tester.runAsync(() => StoryRepository.load('en')))!;
      final book = books.singleWhere((b) => b.id == 'courtyard');
      final state = CharacterState();
      await state.initializeForLocalGuest(name: 'Reader');
      state.character.totalQuestCompletions = 1;
      await tester.pumpWidget(host(state, const StoryLibraryScreen()));
      await tester.pumpAndSettle();
      final card = find.ancestor(
        of: find.text(book.title),
        matching: find.byType(Card),
      );
      await tapVisible(
        tester,
        find.descendant(of: card, matching: find.byType(OutlinedButton)),
      );
      await tapVisible(tester, find.text(book.scenes[0].choices.first.label));
      final l = AppLocalizations.of(
        tester.element(find.byType(StoryReaderScreen)),
      )!;
      await tapVisible(tester, find.text(l.lqStoryNext));
      expect(find.text(book.scenes[1].title), findsOneWidget);
      await tapVisible(tester, find.text(book.scenes[1].choices.last.label));
      await tapVisible(tester, find.text(l.lqStoryBackToChapter));
      expect(find.byType(StoryChapterScreen), findsOneWidget);
      expect(
        state.storyChoices[book.choiceKey(0)],
        book.scenes[0].choices.first.id,
      );
      expect(
        state.storyChoices[book.choiceKey(1)],
        book.scenes[1].choices.last.id,
      );
      expect(state.canOpenStory(book, 2), false);
      expect(state.character.xp, 0);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.byType(StoryLibraryScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      state.dispose();
    },
  );
}
