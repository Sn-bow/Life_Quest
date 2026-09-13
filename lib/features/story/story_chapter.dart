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

class StoryChapter {
  final String id, title, subtitle, description, artwork;
  final String? productId;
  final List<StoryScene> scenes;
  const StoryChapter({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.artwork,
    this.productId,
    required this.scenes,
  });
  factory StoryChapter.fromJson(Map<String, dynamic> data) => StoryChapter(
    id: data['id'] as String,
    title: data['title'] as String,
    subtitle: data['subtitle'] as String,
    description: data['description'] as String,
    artwork: data['artwork'] as String,
    productId: data['productId'] as String?,
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
  bool canOpen(
    int index, {
    required int completedQuests,
    required Map<String, String> choices,
    required bool owned,
  }) {
    if (index < 0 || index >= scenes.length) return false;
    if (productId != null && !owned && index > 0) {
      return false; // First scene is a free sample.
    }
    if (completedQuests < scenes[index].quests) return false;
    for (var i = 0; i < index; i++) {
      if (selectedChoice(i, choices) == null) return false;
    }
    return true;
  }
}

class StoryRepository {
  static const chapterIds = ['prologue'];
  static final Map<String, Future<List<StoryChapter>>> _cache = {};
  static Future<List<StoryChapter>> load(String language) {
    final locale = const {'ko', 'en', 'ja', 'zh'}.contains(language)
        ? language
        : 'en';
    return _cache.putIfAbsent(
      locale,
      () async => [
        for (final id in chapterIds)
          StoryChapter.fromJson(
            jsonDecode(
                  await rootBundle.loadString(
                    'assets/story/${id}_$locale.json',
                  ),
                )
                as Map<String, dynamic>,
          ),
      ],
    );
  }
}
