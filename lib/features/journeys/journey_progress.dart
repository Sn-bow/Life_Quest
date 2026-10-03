/// Authored routes advance through actions, never through a streak or a date.
/// This document is saved atomically with the character and its XP receipt.
enum JourneyKind { learning, order, vitality, connection }

const journeyStageCount = 21;
const journeyFreeStages = 7;

String journeyText(String value, int limit) => String.fromCharCodes(
  value.replaceAll(RegExp(r'[\x00-\x1f]'), ' ').trim().runes.take(limit),
);

class JourneyEntry {
  final DateTime at;
  final String note;
  final bool shortVersion;
  final int minutes;
  const JourneyEntry({
    required this.at,
    this.note = '',
    this.shortVersion = false,
    this.minutes = 5,
  });
  Map<String, dynamic> toJson() => {
    'at': at.toIso8601String(),
    'note': note,
    'short': shortVersion,
    'minutes': minutes,
  };
  static JourneyEntry? parse(Object? value) {
    if (value is! Map || value['at'] is! String) return null;
    final at = DateTime.tryParse(value['at']);
    if (at == null) return null;
    return JourneyEntry(
      at: at,
      note: journeyText(value['note'] is String ? value['note'] : '', 240),
      shortVersion: value['short'] == true,
      minutes: value['minutes'] is int
          ? (value['minutes'] as int).clamp(1, 15)
          : 5,
    );
  }
}

class JourneyRun {
  final String id;
  final JourneyKind kind;
  final String goal;
  final DateTime startedAt;
  final List<JourneyEntry> entries;
  const JourneyRun({
    required this.id,
    required this.kind,
    required this.goal,
    required this.startedAt,
    this.entries = const [],
  });
  int get stage => entries.length;
  bool get completed => stage >= journeyStageCount;
  String get questId => 'journey:$id:$stage';
  JourneyRun withGoal(String value) => JourneyRun(
    id: id,
    kind: kind,
    goal: journeyText(value, 120),
    startedAt: startedAt,
    entries: entries,
  );
  JourneyRun append(JourneyEntry entry) => JourneyRun(
    id: id,
    kind: kind,
    goal: goal,
    startedAt: startedAt,
    entries: List.unmodifiable([...entries, entry]),
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'kind': kind.name,
    'goal': goal,
    'startedAt': startedAt.toIso8601String(),
    'entries': entries.map((e) => e.toJson()).toList(),
  };
  static JourneyRun? parse(Object? value) {
    if (value is! Map ||
        value['id'] is! String ||
        !RegExp(r'^[a-z0-9_-]{1,64}$').hasMatch(value['id']) ||
        value['startedAt'] is! String ||
        value['entries'] is! List) {
      return null;
    }
    final kind = JourneyKind.values
        .where((k) => k.name == value['kind'])
        .firstOrNull;
    final at = DateTime.tryParse(value['startedAt']);
    final raw = value['entries'] as List;
    if (kind == null || at == null || raw.length > journeyStageCount) {
      return null;
    }
    final entries = raw
        .map(JourneyEntry.parse)
        .whereType<JourneyEntry>()
        .toList();
    if (entries.length != raw.length) return null;
    return JourneyRun(
      id: value['id'],
      kind: kind,
      goal: journeyText(value['goal'] is String ? value['goal'] : '', 120),
      startedAt: at,
      entries: List.unmodifiable(entries),
    );
  }
}

class JourneyBook {
  final String? activeId;
  final List<JourneyRun> runs;
  const JourneyBook({this.activeId, this.runs = const []});
  JourneyRun? get active => runs.where((r) => r.id == activeId).firstOrNull;
  JourneyRun? latest(JourneyKind kind) =>
      runs.where((r) => r.kind == kind).lastOrNull;
  JourneyBook start(JourneyRun run) {
    if (runs.any((r) => r.id == run.id)) return select(run.id);
    // A finite, visible archive. Never silently erase completed work.
    if (runs.length >= 100) throw StateError('Journey archive is full');
    return JourneyBook(
      activeId: run.id,
      runs: List.unmodifiable([...runs, run]),
    );
  }

  JourneyBook select(String id) => runs.any((r) => r.id == id)
      ? JourneyBook(activeId: id, runs: runs)
      : this;
  JourneyBook record(String questId, JourneyEntry entry) {
    final run = runs
        .where((r) => !r.completed && r.questId == questId)
        .firstOrNull;
    if (run == null) return this;
    return JourneyBook(
      activeId: activeId,
      runs: List.unmodifiable([
        for (final item in runs) item.id == run.id ? item.append(entry) : item,
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
    'version': 1,
    'activeId': activeId,
    'runs': runs.map((r) => r.toJson()).toList(),
  };
  factory JourneyBook.fromJson(Object? value) {
    if (value == null) return const JourneyBook();
    if (value is! Map ||
        value['version'] != 1 ||
        value['runs'] is! List ||
        (value['runs'] as List).length > 100) {
      throw const FormatException('Invalid journey progress');
    }
    final raw = value['runs'] as List;
    final runs = raw.map(JourneyRun.parse).whereType<JourneyRun>().toList();
    if (runs.length != raw.length ||
        runs.map((r) => r.id).toSet().length != runs.length) {
      throw const FormatException('Invalid journey entries');
    }
    final id = value['activeId'];
    return JourneyBook(
      activeId: runs.any((r) => r.id == id) ? id : null,
      runs: List.unmodifiable(runs),
    );
  }
}
