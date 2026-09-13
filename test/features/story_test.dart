import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_quest_final_v2/features/story/story_chapter.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';

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

  test(
    'all shipped locales have the same playable, complete story structure',
    () {
      for (final book in books) {
        expect(book.id, 'prologue');
        expect(book.scenes.map((s) => s.quests).toList(), [0, 1, 3, 6]);
        expect(
          book.scenes.map((s) => s.id).toList(),
          books.first.scenes.map((s) => s.id).toList(),
        );
        expect(File(book.artwork).existsSync(), true);
        for (var i = 0; i < book.scenes.length; i++) {
          final scene = book.scenes[i];
          expect(scene.narration.length, greaterThan(80));
          expect(
            scene.choices.map((c) => c.id).toList(),
            books.first.scenes[i].choices.map((c) => c.id).toList(),
          );
          expect(scene.choices.map((c) => c.id).toSet(), hasLength(2));
          for (final choice in scene.choices) {
            expect(choice.label, isNotEmpty);
            expect(choice.response, isNotEmpty);
          }
        }
      }
    },
  );

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
