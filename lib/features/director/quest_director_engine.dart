import 'dart:math' as math;

import '../../models/quest.dart';
import '../../state/character_state.dart';

enum GrowthFocus { vitality, learning, order, connection }

enum QuestFeedback { completed, tooHard, skipped, reported }

String localDay(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

class HunterProfile {
  final Set<GrowthFocus> focuses;
  final int minutes;
  final int energy;
  final bool configured;
  final String goal;
  const HunterProfile({
    this.focuses = const {GrowthFocus.learning, GrowthFocus.vitality},
    this.minutes = 15,
    this.energy = 2,
    this.configured = false,
    this.goal = '',
  });

  HunterProfile copyWith(
          {Set<GrowthFocus>? focuses,
          int? minutes,
          int? energy,
          bool? configured,
          String? goal}) =>
      HunterProfile(
          focuses: Set.unmodifiable(focuses ?? this.focuses),
          minutes: (minutes ?? this.minutes).clamp(3, 60),
          energy: (energy ?? this.energy).clamp(1, 3),
          configured: configured ?? this.configured,
          goal: String.fromCharCodes((goal ?? this.goal)
              .replaceAll(RegExp(r'[\x00-\x1f]'), ' ')
              .trim()
              .runes
              .take(120)));

  Map<String, dynamic> toJson() => {
        'focuses': focuses.map((e) => e.name).toList()..sort(),
        'minutes': minutes,
        'energy': energy,
        'configured': configured,
        'goal': goal
      };

  factory HunterProfile.fromJson(Map<String, dynamic> json) {
    final values = json['focuses'];
    final focuses = GrowthFocus.values
        .where((e) => values is List && values.contains(e.name))
        .toSet();
    return const HunterProfile().copyWith(
        focuses: focuses.isEmpty ? null : focuses,
        minutes:
            json['minutes'] is num ? (json['minutes'] as num).toInt() : null,
        energy: json['energy'] is num ? (json['energy'] as num).toInt() : null,
        configured: json['configured'] == true,
        goal: json['goal'] is String ? json['goal'] : null);
  }
}

class QuestSignal {
  final String questId;
  final String templateId;
  final QuestFeedback feedback;
  final DateTime at;
  final String title;
  final int minutes;
  const QuestSignal(
      {required this.questId,
      required this.templateId,
      required this.feedback,
      required this.at,
      this.title = '',
      this.minutes = 0});
  Map<String, dynamic> toJson() => {
        'questId': questId,
        'templateId': templateId,
        'feedback': feedback.name,
        'at': at.toIso8601String(),
        'title': title,
        'minutes': minutes
      };
  static QuestSignal? fromJson(dynamic json) {
    if (json is! Map ||
        json['questId'] is! String ||
        json['templateId'] is! String) {
      return null;
    }
    final at = DateTime.tryParse('${json['at']}');
    final feedback = QuestFeedback.values
        .where((e) => e.name == json['feedback'])
        .firstOrNull;
    if (at == null || feedback == null) return null;
    return QuestSignal(
        questId: json['questId'],
        templateId: json['templateId'],
        feedback: feedback,
        at: at,
        title: json['title'] is String
            ? String.fromCharCodes((json['title'] as String).runes.take(60))
            : '',
        minutes: json['minutes'] is num
            ? (json['minutes'] as num).toInt().clamp(0, 60)
            : 0);
  }
}

class QuestTemplate {
  final String id;
  final GrowthFocus focus;
  final StatType stat;
  final int minMinutes;
  final int maxMinutes;

  /// ko/en/ja/zh. The literal {m} is rendered as the allocated minutes.
  final List<String> titles;
  const QuestTemplate(this.id, this.focus, this.stat, this.minMinutes,
      this.maxMinutes, this.titles);

  String title(String locale, int minutes) {
    final index = switch (locale) { 'en' => 1, 'ja' => 2, 'zh' => 3, _ => 0 };
    return titles[index].replaceAll('{m}', '$minutes');
  }
}

class DirectedQuest {
  final String id;
  final QuestTemplate template;
  final int minutes;
  final bool recovery;
  final String? generatedTitle;
  final String? instruction;
  final String? reason;
  final String? generatedLocale;
  const DirectedQuest(
      {required this.id,
      required this.template,
      required this.minutes,
      required this.recovery,
      this.generatedTitle,
      this.instruction,
      this.reason,
      this.generatedLocale});
  QuestDifficulty get difficulty =>
      minutes <= 5 ? QuestDifficulty.easy : QuestDifficulty.normal;
  int get xp => Quest.xpForDifficulty(difficulty, QuestType.daily);
  bool generatedFor(String locale) =>
      generatedTitle != null && generatedLocale == locale;
  String title(String locale) =>
      generatedFor(locale) ? generatedTitle! : template.title(locale, minutes);

  DirectedQuest withText(
          String title, String instruction, String reason, String locale) =>
      DirectedQuest(
          id: id,
          template: template,
          minutes: minutes,
          recovery: recovery,
          generatedTitle: title,
          instruction: instruction,
          reason: reason,
          generatedLocale: locale);

  Map<String, dynamic> toJson() => {
        'id': id,
        'templateId': template.id,
        'minutes': minutes,
        'recovery': recovery,
        'title': generatedTitle,
        'instruction': instruction,
        'reason': reason,
        'locale': generatedLocale
      };

  static DirectedQuest? fromJson(dynamic json) {
    if (json is! Map || json['id'] is! String || json['minutes'] is! int) {
      return null;
    }
    final template = QuestDirectorEngine.catalog
        .where((t) => t.id == json['templateId'])
        .firstOrNull;
    if (template == null || json['minutes'] < 1 || json['minutes'] > 15) {
      return null;
    }
    String? text(String key, int max) =>
        json[key] is String && (json[key] as String).length <= max
            ? json[key]
            : null;
    return DirectedQuest(
        id: json['id'],
        template: template,
        minutes: json['minutes'],
        recovery: json['recovery'] == true,
        generatedTitle: text('title', 50),
        instruction: text('instruction', 160),
        reason: text('reason', 120),
        generatedLocale: text('locale', 2));
  }
}

/// A bounded, deterministic recommendation policy. All inputs remain on device.
/// It adapts the task dose, mixes interests, and rotates recent tasks. It is not
/// model fine-tuning and does not infer medical conditions from user behaviour.
class QuestDirectorEngine {
  const QuestDirectorEngine();

  List<DirectedQuest> plan(
      {required HunterProfile profile,
      required List<QuestSignal> history,
      required DateTime now,
      Set<String> excludedIds = const {},
      int slots = 3,
      int usedMinutes = 0}) {
    if (slots <= 0 || usedMinutes >= profile.minutes) return [];
    final day = localDay(now);
    final recent = history
        .where((e) => !e.at.isAfter(now) && now.difference(e.at).inDays < 14)
        .toList();
    final completed =
        recent.where((e) => e.feedback == QuestFeedback.completed).length;
    final hard =
        recent.where((e) => e.feedback == QuestFeedback.tooHard).length;
    final recovery = profile.energy == 1 || hard > completed;
    final budget = math.max(
        0,
        (recovery ? math.min(profile.minutes, 9) : profile.minutes) -
            usedMinutes);
    if (budget < slots) return [];
    final target = (budget ~/ slots).clamp(1, recovery ? 3 : 15);
    final seed = day.codeUnits.fold(17, (a, b) => (a * 31 + b) & 0x7fffffff);
    final candidates = catalog
        .where((t) =>
            t.minMinutes <= target &&
            !excludedIds.contains('director:$day:${t.id}'))
        .toList();
    double score(QuestTemplate t) {
      final signals = recent.where((e) => e.templateId == t.id).toList();
      final successes =
          signals.where((e) => e.feedback == QuestFeedback.completed).length;
      final friction =
          signals.where((e) => e.feedback != QuestFeedback.completed).length;
      final repeated =
          signals.where((e) => now.difference(e.at).inDays < 3).length;
      final variation =
          math.Random(seed + catalog.indexOf(t) * 7919).nextDouble();
      return (profile.focuses.contains(t.focus) ? 5 : 0) +
          (successes + 1) / (successes + friction + 2) -
          repeated * 2.5 -
          friction * 0.4 +
          variation;
    }

    candidates.sort((a, b) => score(b).compareTo(score(a)));
    final result = <DirectedQuest>[];
    final used = <GrowthFocus>{};
    var remaining = budget;
    while (candidates.isNotEmpty && result.length < slots) {
      final preferred =
          candidates.where((t) => profile.focuses.contains(t.focus)).toList();
      final pool = preferred.isNotEmpty ? preferred : candidates;
      final diverse = pool
          .where((t) => !used.contains(t.focus) && t.minMinutes <= remaining)
          .firstOrNull;
      final candidate =
          diverse ?? pool.where((t) => t.minMinutes <= remaining).firstOrNull;
      if (candidate == null) break;
      candidates.remove(candidate);
      final minutes = math.min(
          remaining, target.clamp(candidate.minMinutes, candidate.maxMinutes));
      result.add(DirectedQuest(
          id: 'director:$day:${candidate.id}',
          template: candidate,
          minutes: minutes,
          recovery: recovery));
      remaining -= minutes;
      used.add(candidate.focus);
    }
    return List.unmodifiable(result);
  }

  static const catalog = <QuestTemplate>[
    QuestTemplate('walk', GrowthFocus.vitality, StatType.health, 3, 15, [
      '편안한 속도로 {m}분 걷기',
      'Walk at a comfortable pace for {m} minutes',
      '心地よいペースで{m}分歩く',
      '以舒适的速度步行{m}分钟'
    ]),
    QuestTemplate('stretch', GrowthFocus.vitality, StatType.health, 1, 5, [
      '무리 없이 {m}분 몸 풀기',
      'Gently stretch for {m} minutes',
      '無理せず{m}分体をほぐす',
      '轻松舒展身体{m}分钟'
    ]),
    QuestTemplate('rest_eyes', GrowthFocus.vitality, StatType.health, 1, 3, [
      '화면에서 눈을 떼고 {m}분 쉬기',
      'Take a {m}-minute screen break',
      '画面から目を離して{m}分休む',
      '离开屏幕休息{m}分钟'
    ]),
    QuestTemplate('fresh_air', GrowthFocus.vitality, StatType.health, 1, 5, [
      '안전한 곳에서 {m}분 바깥 공기 쐬기',
      'Get fresh air somewhere safe for {m} minutes',
      '安全な場所で{m}分外の空気を吸う',
      '在安全的地方呼吸新鲜空气{m}分钟'
    ]),
    QuestTemplate('read', GrowthFocus.learning, StatType.wisdom, 1, 15, [
      '궁금했던 주제를 {m}분 읽기',
      'Read about a curiosity for {m} minutes',
      '気になるテーマを{m}分読む',
      '阅读感兴趣的主题{m}分钟'
    ]),
    QuestTemplate('focus', GrowthFocus.learning, StatType.wisdom, 1, 15, [
      '가장 중요한 일에 {m}분 집중하기',
      'Focus on one important task for {m} minutes',
      '大切なこと一つに{m}分集中する',
      '专注一件重要的事{m}分钟'
    ]),
    QuestTemplate('recall', GrowthFocus.learning, StatType.wisdom, 1, 5, [
      '오늘 배운 것을 {m}분 동안 떠올리기',
      'Recall what you learned for {m} minutes',
      '今日学んだことを{m}分振り返る',
      '用{m}分钟回顾今天学到的内容'
    ]),
    QuestTemplate('language', GrowthFocus.learning, StatType.wisdom, 2, 10, [
      '배우는 언어로 {m}분 소리 내 읽기',
      'Read aloud in a language you study for {m} minutes',
      '学習中の言語で{m}分音読する',
      '用正在学习的语言朗读{m}分钟'
    ]),
    QuestTemplate('desk', GrowthFocus.order, StatType.strength, 1, 10, [
      '책상 한 구역을 {m}분 정리하기',
      'Clear one area of your desk for {m} minutes',
      '机の一角を{m}分片づける',
      '整理桌面的一角{m}分钟'
    ]),
    QuestTemplate('tomorrow', GrowthFocus.order, StatType.wisdom, 1, 5, [
      '내일의 첫 행동을 {m}분 안에 정하기',
      'Choose tomorrow’s first action in {m} minutes',
      '{m}分で明日の最初の行動を決める',
      '用{m}分钟确定明天的第一步'
    ]),
    QuestTemplate('one_step', GrowthFocus.order, StatType.strength, 2, 10, [
      '미룬 일의 첫 단계만 {m}분 해보기',
      'Try just the first step of a delayed task for {m} minutes',
      '先延ばしの最初の一歩を{m}分試す',
      '用{m}分钟尝试拖延任务的第一步'
    ]),
    QuestTemplate('bag', GrowthFocus.order, StatType.strength, 1, 5, [
      '내일 쓸 물건을 {m}분 준비하기',
      'Prepare what you need tomorrow for {m} minutes',
      '明日使うものを{m}分準備する',
      '用{m}分钟准备明天要用的物品'
    ]),
    QuestTemplate(
        'gratitude', GrowthFocus.connection, StatType.charisma, 1, 5, [
      '고마웠던 순간을 {m}분 기록하기',
      'Write about a moment of gratitude for {m} minutes',
      '感謝した瞬間を{m}分書き留める',
      '用{m}分钟记录感恩的时刻'
    ]),
    QuestTemplate('listen', GrowthFocus.connection, StatType.charisma, 2, 10, [
      '좋아하는 음악을 {m}분 집중해 듣기',
      'Listen closely to music you enjoy for {m} minutes',
      '好きな音楽を{m}分じっくり聴く',
      '专心听喜欢的音乐{m}分钟'
    ]),
    QuestTemplate(
        'kind_note', GrowthFocus.connection, StatType.charisma, 1, 5, [
      '나에게 응원 한마디를 {m}분 적기',
      'Write yourself an encouraging note for {m} minutes',
      '自分への応援を{m}分書く',
      '用{m}分钟写下鼓励自己的话'
    ]),
    QuestTemplate('check_in', GrowthFocus.connection, StatType.charisma, 1, 5, [
      '오늘의 기분을 {m}분 정리하기',
      'Reflect on how today felt for {m} minutes',
      '今日の気持ちを{m}分整理する',
      '用{m}分钟梳理今天的感受'
    ]),
  ];
}
