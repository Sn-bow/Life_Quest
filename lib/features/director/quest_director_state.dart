import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/quest.dart';
import 'on_device_quest_model.dart';
import 'quest_director_engine.dart';

class QuestDirectorState extends ChangeNotifier {
  final QuestDirectorEngine engine;
  final OnDeviceQuestModel model;
  final DateTime Function() clock;
  HunterProfile profile = const HunterProfile();
  final List<QuestSignal> _history = [];
  final Map<String, int> _accepted = {};
  List<DirectedQuest> suggestions = [];
  ModelSnapshot modelSnapshot =
      const ModelSnapshot(OnDeviceModelStatus.checking);
  bool ready = false;
  bool busy = false;
  bool saveFailed = false;
  String? modelIssue;
  String? _scope;
  String? _day;
  String? _lastAutomaticContext;
  String? _pendingAutomaticLocale;
  int _revision = 0;
  int _binding = 0;
  int _operation = 0;
  Future<void> _writes = Future.value();
  Timer? _downloadPoll;
  bool _disposed = false;

  QuestDirectorState(
      {this.engine = const QuestDirectorEngine(),
      OnDeviceQuestModel? model,
      DateTime Function()? clock})
      : model = model ?? OnDeviceQuestModel(),
        clock = clock ?? DateTime.now;

  List<QuestSignal> get history => List.unmodifiable(_history);
  OnDeviceModelStatus get modelStatus => modelSnapshot.status;
  bool get usedModel => suggestions.any((q) => q.generatedTitle != null);
  int get acceptedToday => _accepted.length;
  String get _key => 'lifequest.director.v1.$_scope';
  void _notify() {
    if (!_disposed) notifyListeners();
  }

  /// Stop private work before sign-out/deletion, then drain captured disk writes.
  /// Callers may safely delete this scope's preference only after this completes.
  Future<void> endSession({bool notify = true}) async {
    ++_binding;
    ++_revision;
    ++_operation;
    _downloadPoll?.cancel();
    _scope = null;
    ready = false;
    busy = false;
    _history.clear();
    _accepted.clear();
    suggestions = [];
    profile = const HunterProfile();
    modelIssue = null;
    _pendingAutomaticLocale = null;
    _lastAutomaticContext = null;
    if (notify) _notify();
    await model.cancel();
    await _writes;
  }

  Future<void> bind(String scope) async {
    if (_scope == scope && ready) {
      await refreshDay();
      return;
    }
    final binding = ++_binding;
    ++_revision;
    _scope = scope;
    ready = false;
    _history.clear();
    _accepted.clear();
    suggestions = [];
    profile = const HunterProfile();
    modelIssue = null;
    _lastAutomaticContext = null;
    _pendingAutomaticLocale = null;
    saveFailed = false;
    await _writes;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (binding != _binding || _disposed) return;
      final raw = prefs.getString(_key);
      final json = raw == null ? null : jsonDecode(raw);
      if (json is Map<String, dynamic>) {
        if (json['lastAutomaticContext'] is String) {
          _lastAutomaticContext = json['lastAutomaticContext'];
        }
        if (json['profile'] is Map<String, dynamic>) {
          profile = HunterProfile.fromJson(json['profile']);
        }
        if (json['history'] is List) {
          _history.addAll((json['history'] as List)
              .map(QuestSignal.fromJson)
              .whereType<QuestSignal>());
        }
        if (json['accepted'] is Map) {
          for (final entry in (json['accepted'] as Map).entries) {
            if (entry.key is String && entry.value is int) {
              _accepted[entry.key] = (entry.value as int).clamp(1, 60);
            }
          }
        }
        if (json['day'] == localDay(clock()) && json['suggestions'] is List) {
          suggestions = (json['suggestions'] as List)
              .map(DirectedQuest.fromJson)
              .whereType<DirectedQuest>()
              .take(3)
              .toList();
        }
      }
    } catch (_) {
      saveFailed = true;
    }
    if (binding != _binding || _disposed) return;
    _prune();
    if (suggestions.isEmpty) _buildPlan();
    _day = localDay(clock());
    suggestions = suggestions
        .where((q) =>
            q.id.startsWith('director:$_day:') && !_accepted.containsKey(q.id))
        .toList();
    ready = true;
    _notify();
    final snapshot = await model.status();
    if (binding != _binding || _disposed) return;
    modelSnapshot = snapshot;
    _notify();
  }

  void _prune() {
    final now = clock();
    final day = localDay(now);
    _history.removeWhere(
        (e) => e.at.isAfter(now) || now.difference(e.at).inDays >= 90);
    if (_history.length > 270) _history.removeRange(0, _history.length - 270);
    _accepted.removeWhere((id, _) => !id.startsWith('director:$day:'));
  }

  void _buildPlan() {
    _day = localDay(clock());
    final excluded = {
      ..._accepted.keys,
      ..._history.where((e) => localDay(e.at) == _day).map((e) => e.questId)
    };
    suggestions = engine.plan(
        profile: profile,
        history: _history,
        now: clock(),
        excludedIds: excluded,
        slots: (3 - _accepted.length).clamp(0, 3),
        usedMinutes: _accepted.values.fold(0, (sum, m) => sum + m));
  }

  Future<void> refreshDay() async {
    if (!ready || _day == localDay(clock())) return;
    ++_revision;
    _prune();
    _buildPlan();
    _notify();
    await _save();
  }

  /// Reconcile accepted quests after a restart or interrupted pair of local writes.
  Future<void> reconcile(List<Quest> quests) async {
    if (!ready) return;
    var changed = false;
    for (final quest
        in quests.where((q) => q.scheduledDay == localDay(clock()))) {
      if (!_accepted.containsKey(quest.id)) {
        _accepted[quest.id] = quest.estimatedMinutes ?? 1;
        changed = true;
      }
    }
    if (changed) {
      ++_revision;
      suggestions =
          suggestions.where((q) => !_accepted.containsKey(q.id)).toList();
      _notify();
      await _save();
    }
  }

  Future<void> configure(HunterProfile value) async {
    if (!ready) return;
    ++_revision;
    profile = value.copyWith(configured: true);
    modelIssue = null;
    _buildPlan();
    _notify();
    await _save();
  }

  Future<void> accept(DirectedQuest quest) async {
    if (!ready ||
        !suggestions.any((q) => q.id == quest.id) ||
        _accepted.containsKey(quest.id)) {
      return;
    }
    ++_revision;
    _accepted[quest.id] = quest.minutes;
    suggestions = suggestions.where((q) => q.id != quest.id).toList();
    _notify();
    await _save();
  }

  Future<void> record(Quest quest, QuestFeedback feedback) => recordSignal(
      quest.id,
      quest.directorTemplateId ?? 'manual:${quest.category.name}',
      feedback,
      title: quest.name,
      minutes: quest.estimatedMinutes ?? 0);

  Future<void> recordSignal(
      String id, String templateId, QuestFeedback feedback,
      {String title = '', int minutes = 0}) async {
    if (!ready) return;
    final day = localDay(clock());
    final previous = _history
        .where((e) => e.questId == id && localDay(e.at) == day)
        .firstOrNull;
    if (previous?.feedback == QuestFeedback.completed) return;
    ++_revision;
    _history.removeWhere((e) => e.questId == id && localDay(e.at) == day);
    _history.add(QuestSignal(
        questId: id,
        templateId: templateId,
        feedback: feedback,
        at: clock(),
        title: title,
        minutes: minutes));
    suggestions = suggestions.where((q) => q.id != id).toList();
    _prune();
    _notify();
    await _save();
  }

  Future<void> skip(
      DirectedQuest quest, QuestFeedback feedback, String locale) async {
    if (!ready) return;
    final binding = _binding;
    await recordSignal(quest.id, quest.template.id, feedback,
        title: quest.title(locale), minutes: quest.minutes);
    if (!ready || binding != _binding || _disposed) return;
    _buildPlan();
    _notify();
    await _save();
  }

  Future<void> personalize(String locale) async {
    if (!ready ||
        busy ||
        modelStatus != OnDeviceModelStatus.available ||
        suggestions.isEmpty) {
      return;
    }
    busy = true;
    modelIssue = null;
    _lastAutomaticContext = _automaticContext(locale);
    final revision = _revision;
    final operation = ++_operation;
    final day = localDay(clock());
    final plan = List<DirectedQuest>.of(suggestions);
    final inputProfile = profile;
    final inputHistory = history;
    _notify();
    try {
      await _save();
      if (_disposed || revision != _revision || operation != _operation) return;
      final result = await model.generate(plan, inputProfile, inputHistory, locale, clock());
      if (_disposed ||
          revision != _revision ||
          operation != _operation ||
          day != localDay(clock())) {
        return;
      }
      if (result == null) {
        modelIssue = 'generation_rejected';
      } else {
        suggestions = result;
        await _save();
      }
    } finally {
      if (operation == _operation) {
        busy = false;
        _notify();
        final pending = _pendingAutomaticLocale;
        _pendingAutomaticLocale = null;
        if (pending != null) unawaited(personalizeIfNeeded(pending));
      }
    }
  }

  String _automaticContext(String locale) => jsonEncode([
        localDay(clock()),
        locale,
        profile.toJson(),
      ]);

  /// At most one automatic attempt per day, locale and check-in combination.
  /// Inference runs only from a visible app; explicit retry remains available.
  Future<void> personalizeIfNeeded(String locale) async {
    if (!ready ||
        !profile.configured ||
        modelStatus != OnDeviceModelStatus.available ||
        suggestions.isEmpty ||
        _lastAutomaticContext == _automaticContext(locale)) {
      return;
    }
    if (busy) {
      _pendingAutomaticLocale = locale;
      return;
    }
    await personalize(locale);
  }

  Future<void> downloadModel() async {
    if (busy || modelStatus != OnDeviceModelStatus.downloadable) return;
    busy = true;
    modelIssue = null;
    final operation = ++_operation;
    modelSnapshot = ModelSnapshot(OnDeviceModelStatus.downloading,
        progress: modelSnapshot.progress);
    _notify();
    _downloadPoll = Timer.periodic(const Duration(seconds: 1), (_) async {
      final status = await model.status();
      if (_disposed || operation != _operation) return;
      modelSnapshot = status;
      _notify();
    });
    try {
      await model.download();
    } on PlatformException catch (e) {
      modelIssue = e.code == 'cancelled' ? null : e.code;
    } on Exception {
      modelIssue = 'download_failed';
    } finally {
      _downloadPoll?.cancel();
      final status = await model.status();
      if (operation == _operation && !_disposed) {
        modelSnapshot = status;
        busy = false;
        _notify();
      }
    }
  }

  Future<void> cancelModelOperation() async {
    ++_revision;
    _pendingAutomaticLocale = null;
    await model.cancel();
  }

  Future<void> removeModel() async {
    if (busy) return;
    busy = true;
    _notify();
    try {
      await model.deleteModel();
      modelIssue = null;
    } on Exception {
      modelIssue = 'delete_failed';
    } finally {
      modelSnapshot = await model.status();
      busy = false;
      _notify();
    }
  }

  Future<void> clearLearning() async {
    if (!ready) return;
    ++_revision;
    _history.clear();
    _buildPlan();
    _notify();
    await _save();
  }

  Future<void> _save() {
    if (_scope == null || !ready) return Future.value();
    final key = _key;
    final binding = _binding;
    final payload = jsonEncode({
      'profile': profile.toJson(),
      'lastAutomaticContext': _lastAutomaticContext,
      'day': _day,
      'history': _history.map((e) => e.toJson()).toList(),
      'accepted': _accepted,
      'suggestions': suggestions.map((q) => q.toJson()).toList()
    });
    _writes = _writes.then((_) async {
      try {
        final prefs = await SharedPreferences.getInstance();
        if (!await prefs.setString(key, payload)) {
          throw StateError('Local write rejected');
        }
        if (binding == _binding) saveFailed = false;
      } catch (_) {
        if (binding == _binding) saveFailed = true;
      }
      _notify();
    });
    return _writes;
  }

  @override
  void dispose() {
    _disposed = true;
    ++_revision;
    ++_binding;
    ++_operation;
    _downloadPoll?.cancel();
    unawaited(model.cancel());
    super.dispose();
  }
}
