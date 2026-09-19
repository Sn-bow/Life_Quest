import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:life_quest_final_v2/features/story/story_chapter.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';

class StoryFaultStore extends InMemorySharedPreferencesStore {
  StoryFaultStore() : super.empty();
  bool fail = false;
  @override
  Future<bool> setValue(String type, String key, Object value) async {
    if (fail && key == 'flutter.${CharacterState.localProfileStorageKey}') {
      throw StateError('Synthetic storage failure');
    }
    return super.setValue(type, key, value);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SoundService.muteForTesting();
  setUp(() => SharedPreferences.setMockInitialValues({}));
  final books = [
    for (final locale in ['ko', 'en', 'ja', 'zh'])
      StoryChapter.fromJson(
        jsonDecode(
          File('assets/story/prologue_$locale.json').readAsStringSync(),
        ),
      ),
  ];

  for (final id in StoryRepository.chapterIds) {
    test(
      '$id ships complete matching choices, assets and echoes in every locale',
      () {
        final localized = [
          for (final locale in ['ko', 'en', 'ja', 'zh'])
            StoryChapter.fromJson(
              jsonDecode(
                File('assets/story/${id}_$locale.json').readAsStringSync(),
              ),
            ),
        ];
        for (final book in localized) {
          expect(book.id, id);
          expect(book.productId, isNull);
          expect(book.scenes.map((s) => s.quests).toList(), [0, 1, 3, 6]);
          expect(
            book.scenes.map((s) => s.id).toList(),
            localized.first.scenes.map((s) => s.id).toList(),
          );
          expect(File(book.artwork).existsSync(), true);
          final validEchoes = <String>{};
          for (var i = 0; i < book.scenes.length; i++) {
            final scene = book.scenes[i];
            expect(scene.narration.length, greaterThan(80));
            expect(
              scene.choices.map((c) => c.id).toList(),
              localized.first.scenes[i].choices.map((c) => c.id).toList(),
            );
            expect(scene.choices.map((c) => c.id).toSet(), hasLength(2));
            for (final echo in scene.echoes.keys) {
              expect(
                validEchoes,
                contains(echo),
                reason: 'Echo must refer to an earlier choice: $echo',
              );
            }
            for (final choice in scene.choices) {
              expect(choice.label, isNotEmpty);
              expect(choice.response, isNotEmpty);
              validEchoes.add('${book.choiceKey(i)}:${choice.id}');
            }
          }
          final choices = <String, String>{};
          expect(book.nextSceneIndex(choices), 0);
          for (var i = 0; i < book.scenes.length; i++) {
            expect(
              book.canOpen(
                i,
                completedQuests: 6,
                choices: choices,
                owned: true,
              ),
              true,
            );
            choices[book.choiceKey(i)] = book.scenes[i].choices.first.id;
          }
          expect(book.completed(choices), 4);
          expect(book.nextSceneIndex(choices), isNull);
          choices.remove(book.choiceKey(1));
          expect(book.nextSceneIndex(choices), 1);
        }
      },
    );
  }

  test(
    'switching worlds preserves choices and XP across device restart',
    () async {
      final state = CharacterState();
      await state.initializeForLocalGuest(name: 'Existing name');
      expect(state.activeStoryChapterId, isNull);
      expect(await state.selectStoryChapter('unknown'), false);
      expect(await state.selectStoryChapter('courtyard'), true);
      final courtyard = StoryChapter.fromJson(
        jsonDecode(File('assets/story/courtyard_ko.json').readAsStringSync()),
      );
      expect(await state.chooseStory(courtyard, 0, 'listen'), true);
      final xp = state.character.xp;
      expect(await state.selectStoryChapter('atlas'), true);
      expect(state.storyChoices['courtyard/arrival'], 'listen');
      expect(state.character.xp, xp);
      state.dispose();
      final restored = CharacterState();
      await restored.initializeForLocalGuest(name: 'New default');
      expect(restored.character.name, 'Existing name');
      expect(restored.activeStoryChapterId, 'atlas');
      expect(restored.storyChoices['courtyard/arrival'], 'listen');
      expect(restored.character.xp, xp);
      restored.character.activeStoryChapterId = 'removed-world';
      expect(restored.activeStoryChapterId, isNull);
      restored.dispose();
    },
  );

  test('failed bookmark save rolls back and retry survives restart', () async {
    final store = StoryFaultStore();
    SharedPreferencesStorePlatform.instance = store;
    final state = CharacterState();
    await state.initializeForLocalGuest(name: 'Storage test');
    expect(await state.selectStoryChapter('courtyard'), true);
    store.fail = true;
    expect(await state.selectStoryChapter('atlas'), false);
    expect(state.activeStoryChapterId, 'courtyard');
    await (await SharedPreferences.getInstance()).reload();
    final raw = jsonDecode(
      (await SharedPreferences.getInstance()).getString(
        CharacterState.localProfileStorageKey,
      )!,
    );
    expect(raw['character']['activeStoryChapterId'], 'courtyard');
    store.fail = false;
    expect(await state.selectStoryChapter('atlas'), true);
    state.dispose();
    await (await SharedPreferences.getInstance()).reload();
    final restored = CharacterState();
    await restored.initializeForLocalGuest(name: 'Ignored');
    expect(restored.activeStoryChapterId, 'atlas');
    restored.dispose();
  });

  test('scene order and completed actions are both required', () {
    final book = books.first;
    expect(
      book.canOpen(-1, completedQuests: 10, choices: {}, owned: true),
      false,
    );
    expect(book.canOpen(0, completedQuests: 0, choices: {}, owned: true), true);
    expect(
      book.canOpen(1, completedQuests: 10, choices: {}, owned: true),
      false,
    );
    final choices = {book.choiceKey(0): 'answer'};
    expect(
      book.canOpen(1, completedQuests: 0, choices: choices, owned: true),
      false,
    );
    expect(
      book.canOpen(1, completedQuests: 1, choices: choices, owned: true),
      true,
    );
    expect(
      book.canOpen(
        1,
        completedQuests: 1,
        choices: {book.choiceKey(0): 'unknown'},
        owned: true,
      ),
      false,
    );
  });

  test(
    'purchased chapters expose only a free first scene without an entitlement',
    () {
      final free = books.first;
      final paid = StoryChapter(
        id: 'paid',
        title: free.title,
        subtitle: free.subtitle,
        description: free.description,
        artwork: free.artwork,
        productId: 'story_neon_archive_01',
        scenes: free.scenes,
      );
      final choices = {paid.choiceKey(0): 'answer'};
      expect(
        paid.canOpen(0, completedQuests: 10, choices: {}, owned: false),
        true,
      );
      expect(
        paid.canOpen(1, completedQuests: 10, choices: choices, owned: false),
        false,
      );
      expect(
        paid.canOpen(1, completedQuests: 10, choices: choices, owned: true),
        true,
      );
    },
  );

  test('choices survive restart and replay never grants experience', () async {
    final state = CharacterState();
    await state.initializeForLocalGuest(name: '각성자');
    final book = books.first;
    final beforeXp = state.character.xp;
    expect(await state.chooseStory(book, 1, 'ask'), false);
    expect(await state.chooseStory(book, 0, 'invalid'), false);
    expect(await state.chooseStory(book, 0, 'answer'), true);
    expect(await state.chooseStory(book, 0, 'observe'), true);
    expect(state.character.xp, beforeXp);
    expect(state.questCompletionCount, 0);
    state.dispose();
    final restored = CharacterState();
    await restored.initializeForLocalGuest(name: '새 기본 이름');
    expect(restored.storyChoices, {book.choiceKey(0): 'observe'});
    expect(book.completed(restored.storyChoices), 1);
    restored.dispose();
  });
}
