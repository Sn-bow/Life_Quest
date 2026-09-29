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

  HunterProfile copyWith({
    Set<GrowthFocus>? focuses,
    int? minutes,
    int? energy,
    bool? configured,
    String? goal,
  }) => HunterProfile(
    focuses: Set.unmodifiable(focuses ?? this.focuses),
    minutes: (minutes ?? this.minutes).clamp(3, 60),
    energy: (energy ?? this.energy).clamp(1, 3),
    configured: configured ?? this.configured,
    goal: String.fromCharCodes(
      (goal ?? this.goal)
          .replaceAll(RegExp(r'[\x00-\x1f]'), ' ')
          .trim()
          .runes
          .take(120),
    ),
  );

  Map<String, dynamic> toJson() => {
    'focuses': focuses.map((e) => e.name).toList()..sort(),
    'minutes': minutes,
    'energy': energy,
    'configured': configured,
    'goal': goal,
  };

  factory HunterProfile.fromJson(Map<String, dynamic> json) {
    final values = json['focuses'];
    final focuses = GrowthFocus.values
        .where((e) => values is List && values.contains(e.name))
        .toSet();
    return const HunterProfile().copyWith(
      focuses: focuses.isEmpty ? null : focuses,
      minutes: json['minutes'] is num ? (json['minutes'] as num).toInt() : null,
      energy: json['energy'] is num ? (json['energy'] as num).toInt() : null,
      configured: json['configured'] == true,
      goal: json['goal'] is String ? json['goal'] : null,
    );
  }
}

class QuestSignal {
  final String questId;
  final String templateId;
  final QuestFeedback feedback;
  final DateTime at;
  final String title;
  final int minutes;
  const QuestSignal({
    required this.questId,
    required this.templateId,
    required this.feedback,
    required this.at,
    this.title = '',
    this.minutes = 0,
  });
  Map<String, dynamic> toJson() => {
    'questId': questId,
    'templateId': templateId,
    'feedback': feedback.name,
    'at': at.toIso8601String(),
    'title': title,
    'minutes': minutes,
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
          : 0,
    );
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
  const QuestTemplate(
    this.id,
    this.focus,
    this.stat,
    this.minMinutes,
    this.maxMinutes,
    this.titles,
  );

  String title(String locale, int minutes) {
    final index = switch (locale) {
      'en' => 1,
      'ja' => 2,
      'zh' => 3,
      _ => 0,
    };
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
  const DirectedQuest({
    required this.id,
    required this.template,
    required this.minutes,
    required this.recovery,
    this.generatedTitle,
    this.instruction,
    this.reason,
    this.generatedLocale,
  });
  QuestDifficulty get difficulty =>
      minutes <= 5 ? QuestDifficulty.easy : QuestDifficulty.normal;
  int get xp => Quest.xpForDifficulty(difficulty, QuestType.daily);
  bool generatedFor(String locale) =>
      generatedTitle != null && generatedLocale == locale;
  String title(String locale) =>
      generatedFor(locale) ? generatedTitle! : template.title(locale, minutes);

  DirectedQuest withText(
    String title,
    String instruction,
    String reason,
    String locale,
  ) => DirectedQuest(
    id: id,
    template: template,
    minutes: minutes,
    recovery: recovery,
    generatedTitle: title,
    instruction: instruction,
    reason: reason,
    generatedLocale: locale,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'templateId': template.id,
    'minutes': minutes,
    'recovery': recovery,
    'title': generatedTitle,
    'instruction': instruction,
    'reason': reason,
    'locale': generatedLocale,
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
      generatedLocale: text('locale', 2),
    );
  }
}

class _GoalRule {
  final GrowthFocus focus;
  final String templateId;
  final RegExp pattern;

  _GoalRule(this.focus, this.templateId, String expression)
    : pattern = RegExp(expression, caseSensitive: false);
}

/// A bounded, deterministic recommendation policy. All inputs remain on device.
/// It adapts the task dose, mixes interests, and rotates recent tasks. It is not
/// model fine-tuning and does not infer medical conditions from user behaviour.
class QuestDirectorEngine {
  const QuestDirectorEngine();

  // A deliberately small vocabulary, not a claim to understand arbitrary
  // prose. Unrecognised, mixed, negated and risky goals use the user's chosen
  // focuses instead. The private goal text is never copied into a quest title.
  static final _unsafeGoal = RegExp(
    r'자해|자살|굶|단식|체중|살\s*빼|치료|진단|약물|밤새|'
    r'\b(?:suicid\w*|self.harm|starv\w*|fasting|weight.loss|lose.weight|'
    r'diagnos\w*|medicat\w*|all.night)\b|'
    r'自傷|自殺|断食|痩せ|治療|診断|徹夜|'
    r'自殘|自殺|絕食|減肥|治療|診斷',
    caseSensitive: false,
  );
  static final _negatedGoal = RegExp(
    r'싫|하지\s*않|안\s+하|싶지\s*않|그만두|피하고|'
    r'\b(?:don.t|do not|not|never|quit|avoid|hate|cannot|can.t)\b|'
    r'嫌|やめ|しない|したくない|避け|不想|不要|不能|討厭|避免',
    caseSensitive: false,
  );
  static final _goalRules = <_GoalRule>[
    _GoalRule(
      GrowthFocus.learning,
      'language',
      r'영어|일본어|중국어|외국어|어학|단어|'
          r'\b(?:english|japanese|chinese|foreign language|vocabulary)\b|'
          r'英語|日本語|中国語|外国語|語学|単語|英文|日文|外語|語言|單字|詞彙',
    ),
    _GoalRule(
      GrowthFocus.learning,
      'read',
      r'독서|책.{0,3}읽|읽.{0,3}책|'
          r'\b(?:read|reading)\b|読書|本を読|閱讀|看書',
    ),
    _GoalRule(
      GrowthFocus.learning,
      'focus',
      r'공부|학습|시험|자격증|과제|집중|'
          r'\b(?:study|studying|learn|learning|exam|homework|focus)\b|'
          r'勉強|学習|試験|宿題|集中|學習|考試|功課|專注',
    ),
    _GoalRule(
      GrowthFocus.vitality,
      'walk',
      r'걷기|걸어|산책|\b(?:walk|walking)\b|散歩|歩く|散步|走路',
    ),
    _GoalRule(
      GrowthFocus.vitality,
      'stretch',
      r'스트레칭|몸\s*풀|운동|'
          r'\b(?:stretch|stretching|exercise|workout|yoga)\b|'
          r'ストレッチ|運動|体を動か|伸展|運動|瑜伽',
    ),
    _GoalRule(
      GrowthFocus.order,
      'desk',
      r'책상.{0,8}(정리|치우)|\bdesk\b.{0,20}\b(?:tidy|clean|organize)\b|'
          r'\b(?:tidy|clean|organize)\b.{0,20}\bdesk\b|'
          r'机.{0,8}(片づけ|片付け|整理)|デスク.{0,8}(片づけ|片付け|整理)|'
          r'(?:書桌|桌面).{0,8}整理|整理.{0,8}(?:書桌|桌面)',
    ),
    _GoalRule(
      GrowthFocus.order,
      'tomorrow',
      r'내일.{0,8}(계획|할\s*일)|'
          r'\b(?:plan|prepare)\b.{0,20}\btomorrow\b|'
          r'明日.{0,8}(予定|計画)|明天.{0,8}(計畫|安排)',
    ),
    _GoalRule(
      GrowthFocus.connection,
      'gratitude',
      r'감사|고마|\b(?:gratitude|thankful)\b|感謝|ありがた',
    ),
    _GoalRule(
      GrowthFocus.connection,
      'listen',
      r'음악|노래\s*듣|\b(?:music|listen to songs?)\b|音楽|音樂',
    ),
    _GoalRule(
      GrowthFocus.connection,
      'check_in',
      r'기분.{0,5}(기록|정리)|감정.{0,5}(기록|정리)|'
          r'\b(?:mood|feelings?)\b.{0,20}\b(?:journal|reflect|write)\b|'
          r'気持ち.{0,8}(書|記録|整理)|心情.{0,8}(記錄|整理)',
    ),
  ];

  static _GoalRule? _clearGoal(String goal) {
    final text = String.fromCharCodes(goal.trim().runes.take(120));
    if (text.isEmpty ||
        _unsafeGoal.hasMatch(text) ||
        _negatedGoal.hasMatch(text)) {
      return null;
    }
    final matches = _goalRules
        .where((rule) => rule.pattern.hasMatch(text))
        .toList();
    if (matches.isEmpty ||
        matches.any((rule) => rule.focus != matches.first.focus)) {
      return null;
    }
    // Rules are ordered from specific to broad. "Study English" is a
    // language goal, while "read and walk" is not guessed at all.
    return matches.first;
  }

  List<DirectedQuest> plan({
    required HunterProfile profile,
    required List<QuestSignal> history,
    required DateTime now,
    Set<String> excludedIds = const {},
    int slots = 3,
    int usedMinutes = 0,
  }) {
    if (slots <= 0 || usedMinutes >= profile.minutes) return [];
    final day = localDay(now);
    final recent = history
        .where((e) => !e.at.isAfter(now) && now.difference(e.at).inDays < 14)
        .toList();
    final completed = recent
        .where((e) => e.feedback == QuestFeedback.completed)
        .length;
    final hard = recent
        .where((e) => e.feedback == QuestFeedback.tooHard)
        .length;
    final recovery = profile.energy == 1 || hard > completed;
    final budget = math.max(
      0,
      (recovery ? math.min(profile.minutes, 9) : profile.minutes) - usedMinutes,
    );
    if (budget < slots) return [];
    final target = (budget ~/ slots).clamp(1, recovery ? 3 : 15);
    final goal = _clearGoal(profile.goal);
    final seed = day.codeUnits.fold(17, (a, b) => (a * 31 + b) & 0x7fffffff);
    final candidates = catalog
        .where(
          (t) =>
              t.minMinutes <= target &&
              (!(now.hour >= 21 || now.hour < 7) ||
                  !const {'walk', 'language', 'listen'}.contains(t.id)) &&
              !excludedIds.contains('director:$day:${t.id}'),
        )
        .toList();
    double score(QuestTemplate t) {
      final signals = recent.where((e) => e.templateId == t.id).toList();
      final successes = signals
          .where((e) => e.feedback == QuestFeedback.completed)
          .length;
      final friction = signals
          .where((e) => e.feedback != QuestFeedback.completed)
          .length;
      final repeated = signals
          .where((e) => now.difference(e.at).inDays < 3)
          .length;
      final declinedRecently = signals.any(
        (e) =>
            now.difference(e.at).inDays < 3 &&
            e.feedback != QuestFeedback.completed,
      );
      final variation = math.Random(
        seed + catalog.indexOf(t) * 7919,
      ).nextDouble();
      return (profile.focuses.contains(t.focus) ? 5 : 0) +
          (goal?.focus == t.focus ? 7 : 0) +
          (goal?.templateId == t.id && !declinedRecently ? 8 : 0) +
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
      final preferred = candidates
          .where(
            (t) => profile.focuses.contains(t.focus) || goal?.focus == t.focus,
          )
          .toList();
      final pool = preferred.isNotEmpty ? preferred : candidates;
      final diverse = pool
          .where((t) => !used.contains(t.focus) && t.minMinutes <= remaining)
          .firstOrNull;
      final candidate =
          diverse ?? pool.where((t) => t.minMinutes <= remaining).firstOrNull;
      if (candidate == null) break;
      candidates.remove(candidate);
      final minutes = math.min(
        remaining,
        target.clamp(candidate.minMinutes, candidate.maxMinutes),
      );
      result.add(
        DirectedQuest(
          id: 'director:$day:${candidate.id}',
          template: candidate,
          minutes: minutes,
          recovery: recovery,
        ),
      );
      remaining -= minutes;
      used.add(candidate.focus);
    }
    return List.unmodifiable(result);
  }

  static const catalog = <QuestTemplate>[
    QuestTemplate('walk', GrowthFocus.vitality, StatType.health, 3, 15, [
      '안전한 실내에서 {m}분 천천히 걷기',
      'Walk slowly indoors for {m} minutes',
      '安全な室内で{m}分ゆっくり歩く',
      '在安全的室內慢走 {m} 分鐘',
    ]),
    QuestTemplate('stretch', GrowthFocus.vitality, StatType.health, 1, 5, [
      '무리 없이 {m}분 몸 풀기',
      'Gently stretch for {m} minutes',
      '無理せず{m}分体をほぐす',
      '輕鬆活動身體 {m} 分鐘',
    ]),
    QuestTemplate('rest_eyes', GrowthFocus.vitality, StatType.health, 1, 3, [
      '화면에서 눈을 떼고 {m}분 쉬기',
      'Take a {m}-minute screen break',
      '画面から目を離して{m}分休む',
      '離開螢幕休息 {m} 分鐘',
    ]),
    QuestTemplate('fresh_air', GrowthFocus.vitality, StatType.health, 1, 5, [
      '창밖 풍경을 {m}분 바라보기',
      'Notice the view through a window for {m} minutes',
      '窓の外の景色を{m}分眺める',
      '看看窗外的風景 {m} 分鐘',
    ]),
    QuestTemplate('read', GrowthFocus.learning, StatType.wisdom, 1, 15, [
      '궁금했던 주제를 {m}분 읽기',
      'Read about a curiosity for {m} minutes',
      '気になるテーマを{m}分読む',
      '閱讀有興趣的主題 {m} 分鐘',
    ]),
    QuestTemplate('focus', GrowthFocus.learning, StatType.wisdom, 1, 15, [
      '가장 중요한 일에 {m}분 집중하기',
      'Focus on one important task for {m} minutes',
      '大切なこと一つに{m}分集中する',
      '專注做一件重要的事 {m} 分鐘',
    ]),
    QuestTemplate('recall', GrowthFocus.learning, StatType.wisdom, 1, 5, [
      '오늘 배운 것을 {m}분 동안 떠올리기',
      'Recall what you learned for {m} minutes',
      '今日学んだことを{m}分振り返る',
      '花 {m} 分鐘回顧今天學到的事',
    ]),
    QuestTemplate('language', GrowthFocus.learning, StatType.wisdom, 2, 10, [
      '배우는 분야의 단어를 {m}분 소리 내 읽기',
      'Read terms from a topic you study aloud for {m} minutes',
      '学習中の分野の言葉を{m}分音読する',
      '朗讀正在學習的詞語 {m} 分鐘',
    ]),
    QuestTemplate('desk', GrowthFocus.order, StatType.strength, 1, 10, [
      '책상 한 구역을 {m}분 정리하기',
      'Clear one area of your desk for {m} minutes',
      '机の一角を{m}分片づける',
      '整理桌面一角 {m} 分鐘',
    ]),
    QuestTemplate('tomorrow', GrowthFocus.order, StatType.wisdom, 1, 5, [
      '내일의 첫 행동을 {m}분 안에 정하기',
      'Choose tomorrow’s first action in {m} minutes',
      '{m}分で明日の最初の行動を決める',
      '花 {m} 分鐘決定明天的第一步',
    ]),
    QuestTemplate('one_step', GrowthFocus.order, StatType.strength, 2, 10, [
      '미룬 일의 첫 단계만 {m}분 해보기',
      'Try just the first step of a delayed task for {m} minutes',
      '先延ばしの最初の一歩を{m}分試す',
      '花 {m} 分鐘試做拖延事項的第一步',
    ]),
    QuestTemplate('bag', GrowthFocus.order, StatType.strength, 1, 5, [
      '내일 쓸 물건을 {m}분 준비하기',
      'Prepare what you need tomorrow for {m} minutes',
      '明日使うものを{m}分準備する',
      '花 {m} 分鐘準備明天要用的東西',
    ]),
    QuestTemplate(
      'gratitude',
      GrowthFocus.connection,
      StatType.charisma,
      1,
      5,
      [
        '고마웠던 순간을 {m}분 기록하기',
        'Write about a moment of gratitude for {m} minutes',
        '感謝した瞬間を{m}分書き留める',
        '花 {m} 分鐘記下值得感謝的時刻',
      ],
    ),
    QuestTemplate('listen', GrowthFocus.connection, StatType.charisma, 2, 10, [
      '좋아하는 음악을 {m}분 집중해 듣기',
      'Listen closely to music you enjoy for {m} minutes',
      '好きな音楽を{m}分じっくり聴く',
      '專心聽喜歡的音樂 {m} 分鐘',
    ]),
    QuestTemplate(
      'kind_note',
      GrowthFocus.connection,
      StatType.charisma,
      1,
      5,
      [
        '나에게 응원 한마디를 {m}분 적기',
        'Write yourself an encouraging note for {m} minutes',
        '自分への応援を{m}分書く',
        '花 {m} 分鐘寫一句鼓勵自己的話',
      ],
    ),
    QuestTemplate('check_in', GrowthFocus.connection, StatType.charisma, 1, 5, [
      '오늘의 기분을 {m}분 정리하기',
      'Reflect on how today felt for {m} minutes',
      '今日の気持ちを{m}分整理する',
      '花 {m} 分鐘整理今天的感受',
    ]),
  ];
}
