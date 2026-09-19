import 'dart:convert';
import 'package:flutter/services.dart';

class StoryChoice {
  final String id, label, response;
  const StoryChoice({
    required this.id,
    required this.label,
    required this.response,
  });
  factory StoryChoice.fromJson(Map<String, dynamic> data) => StoryChoice(
    id: data['id'] as String,
    label: data['label'] as String,
    response: data['response'] as String,
  );
}

class StoryScene {
  final String id, title, narration;
  final int quests;
  final List<StoryChoice> choices;
  final Map<String, String> echoes;
  const StoryScene({
    required this.id,
    required this.title,
    required this.narration,
    required this.quests,
    required this.choices,
    this.echoes = const {},
  });
  factory StoryScene.fromJson(Map<String, dynamic> data) => StoryScene(
    id: data['id'] as String,
    title: data['title'] as String,
    narration: data['narration'] as String,
    quests: data['quests'] as int,
    choices: (data['choices'] as List)
        .map((e) => StoryChoice.fromJson(Map<String, dynamic>.from(e)))
        .toList(),
    echoes: Map<String, String>.from(data['echoes'] ?? {}),
  );
}

class StoryEnding {
  final String title, narration;
  const StoryEnding({required this.title, required this.narration});
  factory StoryEnding.fromJson(Map<String, dynamic> data) => StoryEnding(
    title: data['title'] as String,
    narration: data['narration'] as String,
  );
}

class StoryChapter {
  final String id, title, subtitle, description, artwork;
  final String? productId, themeId, markArtwork;
  final int previewScenes;
  final Map<String, StoryEnding> endings;
  final List<StoryScene> scenes;
  const StoryChapter({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.artwork,
    this.productId,
    this.themeId,
    this.markArtwork,
    this.previewScenes = 1,
    this.endings = const {},
    required this.scenes,
  });
  factory StoryChapter.fromJson(Map<String, dynamic> data) => StoryChapter(
    id: data['id'] as String,
    title: data['title'] as String,
    subtitle: data['subtitle'] as String,
    description: data['description'] as String,
    artwork: data['artwork'] as String,
    productId: data['productId'] as String?,
    themeId: data['themeId'] as String?,
    markArtwork: data['markArtwork'] as String?,
    previewScenes: data['previewScenes'] as int? ?? 1,
    endings: (data['endings'] as Map<String, dynamic>? ?? {}).map(
      (key, value) =>
          MapEntry(key, StoryEnding.fromJson(Map<String, dynamic>.from(value))),
    ),
    scenes: (data['scenes'] as List)
        .map((e) => StoryScene.fromJson(Map<String, dynamic>.from(e)))
        .toList(),
  );
  String choiceKey(int index) => '$id/${scenes[index].id}';
  String? selectedChoice(int index, Map<String, String> choices) {
    final selected = choices[choiceKey(index)];
    return scenes[index].choices.any((e) => e.id == selected) ? selected : null;
  }

  int completed(Map<String, String> choices) => List.generate(
    scenes.length,
    (i) => i,
  ).where((i) => selectedChoice(i, choices) != null).length;

  /// Find the first unanswered scene, even if a restored record has gaps.
  /// A completed book returns null and remains available for rereading.
  int? nextSceneIndex(Map<String, String> choices) {
    for (var i = 0; i < scenes.length; i++) {
      if (selectedChoice(i, choices) == null) return i;
    }
    return null;
  }

  /// The first eleven Tide choices each vote for one approach. The odd count
  /// avoids an arbitrary tie-break. Earlier choices can be revisited; no XP is
  /// awarded and the finale is derived, never persisted as a second reward.
  StoryEnding? endingFor(Map<String, String> choices) {
    if (endings.isEmpty) return null;
    final votes = <String, int>{};
    for (var i = 0; i < scenes.length - 1; i++) {
      final choice = selectedChoice(i, choices);
      if (choice == null || !endings.containsKey(choice)) return null;
      votes[choice] = (votes[choice] ?? 0) + 1;
    }
    final ranked = votes.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    if (ranked.length > 1 && ranked[0].value == ranked[1].value) return null;
    return ranked.isEmpty ? null : endings[ranked.first.key];
  }

  bool needsPurchase(int index, {required bool owned}) =>
      productId != null && !owned && index >= previewScenes;

  bool canOpen(
    int index, {
    required int completedQuests,
    required Map<String, String> choices,
    required bool owned,
  }) {
    if (index < 0 || index >= scenes.length) return false;
    if (needsPurchase(index, owned: owned)) return false;
    if (completedQuests < scenes[index].quests) return false;
    for (var i = 0; i < index; i++) {
      if (selectedChoice(i, choices) == null) return false;
    }
    return true;
  }
}

class StoryRepository {
  static const freeChapterIds = ['prologue', 'courtyard', 'atlas'];
  static const chapterIds = [...freeChapterIds, 'tide'];
  static final Map<String, Future<List<StoryChapter>>> _loading = {};
  static final Map<String, List<StoryChapter>> _loaded = {};
  static Future<List<StoryChapter>> load(String language) {
    final locale = const {'ko', 'en', 'ja', 'zh'}.contains(language)
        ? language
        : 'en';
    final loaded = _loaded[locale];
    if (loaded != null) return Future.value(loaded);
    return _loading.putIfAbsent(locale, () => _read(locale));
  }

  static Future<List<StoryChapter>> _read(String locale) async {
    try {
      final books = <StoryChapter>[
        for (final id in chapterIds)
          StoryChapter.fromJson(
            jsonDecode(
                  await rootBundle.loadString(
                    'assets/story/${id}_$locale.json',
                  ),
                )
                as Map<String, dynamic>,
          ),
      ];
      _loaded[locale] = List.unmodifiable(books);
      return _loaded[locale]!;
    } finally {
      // A transient asset failure must be retryable on the next visit.
      _loading.remove(locale);
    }
  }
}
