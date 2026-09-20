import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:life_quest_final_v2/features/billing/purchase_verifier.dart';
import 'package:life_quest_final_v2/features/backup/device_backup.dart';
import 'package:life_quest_final_v2/features/story/story_chapter.dart';
import 'package:life_quest_final_v2/features/story/story_pack_panel.dart';
import 'package:life_quest_final_v2/features/story/story_screens.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/theme/quest_theme.dart';
import 'backup_fixture.dart';

StoryChapter tide(String locale) => StoryChapter.fromJson(
  jsonDecode(File('assets/story/tide_$locale.json').readAsStringSync()),
);
Map<String, String> decisions(
  StoryChapter book,
  String choice, {
  int count = 12,
}) => {for (var i = 0; i < count; i++) book.choiceKey(i): choice};

class PackFaultStore extends InMemorySharedPreferencesStore {
  PackFaultStore() : super.empty();
  bool reject = false;
  Completer<void>? pause;
  @override
  Future<bool> setValue(String type, String key, Object value) async {
    if (key == 'flutter.${CharacterState.localProfileStorageKey}') {
      if (pause != null) await pause!.future;
      if (reject) return false;
    }
    return super.setValue(type, key, value);
  }
}

Widget packHost(CharacterState state, Widget child, String locale) =>
    ChangeNotifierProvider.value(
      value: state,
      child: MaterialApp(
        locale: Locale(locale),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        theme: QuestTheme.build(Brightness.dark),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: child,
      ),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SoundService.muteForTesting();
  setUp(() => SharedPreferences.setMockInitialValues({}));
  final book = tide('ko');

  for (final locale in ['ko', 'en', 'ja', 'zh']) {
    test(
      'complete pack structure, two preview scenes and both endings in $locale',
      () {
        final local = tide(locale);
        expect(local.productId, tideProductId);
        expect(local.previewScenes, 2);
        expect(local.scenes.map((s) => s.id), book.scenes.map((s) => s.id));
        expect(local.scenes.map((s) => s.quests), [
          0,
          0,
          2,
          4,
          6,
          8,
          10,
          12,
          14,
          16,
          18,
          20,
        ]);
        expect(local.endings.keys.toSet(), {'open', 'keep'});
        for (final path in [local.artwork, local.markArtwork!]) {
          expect(File(path).existsSync(), true);
        }
        final prior = <String>{};
        for (var i = 0; i < local.scenes.length; i++) {
          final scene = local.scenes[i];
          expect(scene.narration.length, greaterThan(100));
          expect(scene.choices.map((c) => c.id).toSet(), {'open', 'keep'});
          for (final key in scene.echoes.keys) {
            expect(prior, contains(key));
          }
          for (final choice in scene.choices) {
            expect(choice.label, isNotEmpty);
            expect(choice.response, isNotEmpty);
            prior.add('${local.choiceKey(i)}:${choice.id}');
          }
        }
        expect(
          local.canOpen(0, completedQuests: 0, choices: {}, owned: false),
          true,
        );
        expect(
          local.canOpen(
            1,
            completedQuests: 0,
            choices: decisions(local, 'open', count: 1),
            owned: false,
          ),
          true,
        );
        for (var i = 2; i < 12; i++) {
          expect(
            local.canOpen(
              i,
              completedQuests: 999,
              choices: decisions(local, 'open'),
              owned: false,
            ),
            false,
          );
          expect(
            local.canOpen(
              i,
              completedQuests: local.scenes[i].quests - 1,
              choices: decisions(local, 'open'),
              owned: true,
            ),
            false,
          );
          expect(
            local.canOpen(
              i,
              completedQuests: local.scenes[i].quests,
              choices: decisions(local, 'open'),
              owned: true,
            ),
            true,
          );
        }
        expect(local.endingFor(decisions(local, 'open', count: 10)), isNull);
        expect(
          local.endingFor(decisions(local, 'open'))?.title,
          local.endings['open']!.title,
        );
        expect(
          local.endingFor(decisions(local, 'keep'))?.title,
          local.endings['keep']!.title,
        );
      },
    );

    testWidgets(
      'pack detail, owned theme and finale fit 320px / 200% in $locale',
      (tester) async {
        tester.view.physicalSize = const Size(320, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final state = CharacterState();
        await state.initializeForLocalGuest(name: 'Reader');
        final local = tide(locale);
        await tester.pumpWidget(
          packHost(state, StoryChapterScreen(chapter: local), locale),
        );
        await tester.pumpAndSettle();
        final l = AppLocalizations.of(
          tester.element(find.byType(StoryChapterScreen)),
        )!;
        await tester.scrollUntilVisible(
          find.text(l.lqPackUnavailable),
          300,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        expect(find.text(l.lqPackUnavailable), findsOneWidget);
        expect(find.textContaining('₩'), findsNothing); // No fake price.
        expect(tester.takeException(), isNull);
        state.setPurchasedEntitlements({tideProductId});
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(
          find.text(l.lqPackThemeApply),
          300,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text(l.lqPackThemeApply));
        await tester.pumpAndSettle();
        await tester.tap(find.text(l.lqPackThemeApply));
        await tester.pumpAndSettle();
        expect(state.character.equippedTheme, local.themeId);
        state.character.totalQuestCompletions = 20;
        state.character.storyChoices.addAll(
          decisions(local, 'keep', count: 11),
        );
        await tester.pumpWidget(
          packHost(state, StoryReaderScreen(chapter: local, index: 11), locale),
        );
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(
          find.text(local.endings['keep']!.title),
          400,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        expect(find.text(local.endings['open']!.title), findsNothing);
        expect(tester.takeException(), isNull);
        // Revoking ownership while reading must remove the paid prose immediately.
        state.setPurchasedEntitlements({});
        await tester.pumpAndSettle();
        expect(find.text(local.endings['keep']!.narration), findsNothing);
        expect(state.character.equippedTheme, isNull);
        await tester.pumpWidget(const SizedBox());
        state.dispose();
      },
    );
  }

  test(
    'every possible eleven-choice route reaches the documented majority ending',
    () {
      for (var mask = 0; mask < (1 << 11); mask++) {
        final choices = <String, String>{};
        var open = 0;
        for (var i = 0; i < 11; i++) {
          final outbound = mask & (1 << i) != 0;
          if (outbound) open++;
          choices[book.choiceKey(i)] = outbound ? 'open' : 'keep';
        }
        expect(
          book.endingFor(choices),
          same(book.endings[open >= 6 ? 'open' : 'keep']),
        );
      }
    },
  );

  test(
    'theme, replay and refund preserve real progress and restore only with ownership',
    () async {
      final state = CharacterState();
      await state.initializeForLocalGuest(name: 'Reader');
      final xp = state.character.xp;
      expect(await state.chooseStory(book, 0, 'open'), true);
      expect(await state.chooseStory(book, 1, 'keep'), true);
      state.character.totalQuestCompletions = 20;
      expect(await state.chooseStory(book, 2, 'open'), false);
      expect(await state.setStoryTheme(book, enabled: true), false);
      state.setPurchasedEntitlements({tideProductId});
      for (var i = 2; i < 12; i++) {
        expect(await state.chooseStory(book, i, 'open'), true);
      }
      expect(await state.setStoryTheme(book, enabled: true), true);
      final saved = Map<String, String>.of(state.storyChoices);
      state.setPurchasedEntitlements({});
      expect(state.character.equippedTheme, isNull);
      expect(state.storyChoices, saved);
      expect(state.canOpenStory(book, 11), false);
      expect(state.character.xp, xp);
      state.setPurchasedEntitlements({tideProductId});
      expect(state.canOpenStory(book, 11), true);
      for (var i = 0; i < 11; i++) {
        await state.chooseStory(book, i, 'keep');
      }
      expect(book.endingFor(state.storyChoices), same(book.endings['keep']));
      expect(state.character.xp, xp);
      state.dispose();
      final restored = CharacterState();
      await restored.initializeForLocalGuest(name: 'New');
      expect(
        restored.storyChoices,
        decisions(book, 'keep', count: 11)..[book.choiceKey(11)] = 'open',
      );
      expect(restored.canOpenStory(book, 11), false);
      restored.setPurchasedEntitlements({tideProductId});
      expect(restored.canOpenStory(book, 11), true);
      expect(restored.character.xp, xp);
      restored.dispose();
    },
  );

  test(
    'theme write failure rolls back; backup cannot grant bundled ownership',
    () async {
      final store = PackFaultStore();
      SharedPreferencesStorePlatform.instance = store;
      final state = CharacterState();
      await state.initializeForLocalGuest(name: 'Reader');
      state.setPurchasedEntitlements({tideProductId});
      store.reject = true;
      expect(await state.setStoryTheme(book, enabled: true), false);
      expect(state.character.equippedTheme, isNull);
      store.reject = false;
      expect(await state.setStoryTheme(book, enabled: true), true);
      final snapshot = backupFixture();
      snapshot.profile['character']['equippedTheme'] = book.themeId;
      snapshot.profile['character']['unlockedCosmetics'] = [book.themeId];
      final sanitized = DeviceSnapshot.fromJson(snapshot.toJson());
      expect(sanitized.profile['character']['equippedTheme'], isNull);
      expect(sanitized.profile['character']['unlockedCosmetics'], isEmpty);
      state.setPurchasedEntitlements({});
      state.character.unlockedCosmetics.add(book.themeId!);
      expect(state.ownsCosmetic(book.themeId!), false);
      state.dispose();
    },
  );

  test(
    'entitlement lost during theme save cannot leave the paid theme equipped',
    () async {
      final store = PackFaultStore();
      SharedPreferencesStorePlatform.instance = store;
      final state = CharacterState();
      await state.initializeForLocalGuest(name: 'Reader');
      state.setPurchasedEntitlements({tideProductId});
      store.pause = Completer<void>();
      final save = state.setStoryTheme(book, enabled: true);
      state.setPurchasedEntitlements({});
      store.pause!.complete();
      expect(await save, false);
      expect(state.character.equippedTheme, isNull);
      state.dispose();
      final restored = CharacterState();
      await restored.initializeForLocalGuest(name: 'Reader');
      expect(restored.character.equippedTheme, isNull);
      restored.dispose();
    },
  );

  testWidgets('completion mark disappears on refund without deleting choices', (
    tester,
  ) async {
    final state = CharacterState();
    await state.initializeForLocalGuest(name: 'Reader');
    state.character.storyChoices.addAll(decisions(book, 'open'));
    state.setPurchasedEntitlements({tideProductId});
    await tester.runAsync(() => StoryRepository.load('en'));
    await tester.pumpWidget(
      packHost(state, const Scaffold(body: StoryMarks()), 'en'),
    );
    await tester.pumpAndSettle();
    final l = AppLocalizations.of(tester.element(find.byType(StoryMarks)))!;
    expect(find.text(l.lqPackMark), findsOneWidget);
    state.setPurchasedEntitlements({});
    await tester.pumpAndSettle();
    expect(find.text(l.lqPackMark), findsNothing);
    expect(state.storyChoices, hasLength(12));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    state.dispose();
  });
}
