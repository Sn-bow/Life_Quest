import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/quest.dart';
import '../../state/character_state.dart';
import '../../screens/quests_screen.dart';
import '../director/quest_director_state.dart';
import '../system/hunter_system_frame.dart';
import '../system/system_widgets.dart';
import 'journey_catalog.dart';
import 'journey_progress.dart';
import 'journey_purchase_screen.dart';
import 'journey_record.dart';
import 'mission_focus_screen.dart';
import 'mission_draft_store.dart';

const journeyAccent = Color(0xFF80DCFB);

IconData journeyIcon(JourneyKind kind) => switch (kind) {
  JourneyKind.learning => Icons.auto_stories_outlined,
  JourneyKind.order => Icons.grid_view_rounded,
  JourneyKind.vitality => Icons.self_improvement,
  JourneyKind.connection => Icons.forum_outlined,
};

void openJourneys(BuildContext context) => Navigator.of(
  context,
).push(MaterialPageRoute<void>(builder: (_) => const JourneyLibraryScreen()));

/// A small actionable row inside the user's status window, also after day one.
class JourneyStatusCard extends StatelessWidget {
  final bool compact;
  const JourneyStatusCard({super.key, this.compact = false});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<CharacterState>();
    final run = state.journeys.active;
    final copy = JourneyCopy(Localizations.localeOf(context).languageCode);
    return Material(
      color: const Color(0xFF102B3B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: const BorderSide(color: Color(0xFF326176)),
      ),
      child: InkWell(
        key: const ValueKey('status-journey'),
        onTap: () => run == null
            ? openJourneys(context)
            : Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) =>
                      JourneyRouteScreen(kind: run.kind, runId: run.id),
                ),
              ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    run == null ? Icons.route : journeyIcon(run.kind),
                    color: journeyAccent,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      run == null
                          ? copy.t('routes')
                          : copy.shortTitle(run.kind),
                      style: const TextStyle(
                        color: journeyAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.chevron_right,
                    color: journeyAccent,
                    size: 20,
                  ),
                ],
              ),
              if (run != null) ...[
                const SizedBox(height: 8),
                Text(
                  '${run.completed ? copy.t('finished') : copy.chapter(run.stage)} · ${run.stage}/$journeyStageCount',
                  style: const TextStyle(
                    color: Color(0xFFD9EEF7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 7),
                LinearProgressIndicator(
                  value: run.stage / journeyStageCount,
                  color: journeyAccent,
                  backgroundColor: const Color(0xFF26414E),
                  minHeight: 3,
                ),
              ] else if (!compact) ...[
                const SizedBox(height: 5),
                Text(
                  copy.t('free'),
                  style: const TextStyle(
                    color: Color(0xFFB6CCD8),
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class JourneyLibraryScreen extends StatelessWidget {
  const JourneyLibraryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<CharacterState>();
    final copy = JourneyCopy(Localizations.localeOf(context).languageCode);
    return _JourneyScaffold(
      title: copy.t('routes'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            copy.t('intro'),
            style: const TextStyle(fontSize: 17, height: 1.55),
          ),
          const SizedBox(height: 14),
          Text(
            copy.t('pace'),
            style: const TextStyle(color: Color(0xFFAFC5D2)),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const QuestsScreen()),
            ),
            icon: const Icon(Icons.edit_note),
            label: Text(
              copy.choose(['My own quests', '직접 만든 퀘스트', '自分で作るクエスト', '自訂任務']),
            ),
          ),
          const SizedBox(height: 24),
          for (final kind in JourneyKind.values) ...[
            Card(
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => JourneyRouteScreen(kind: kind),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(journeyIcon(kind), color: journeyAccent, size: 28),
                      const SizedBox(height: 14),
                      Text(
                        copy.title(kind),
                        style: HunterSystemFrame.themeFor(
                          context,
                        ).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        copy.description(kind),
                        style: const TextStyle(height: 1.5),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              state.journeys.latest(kind) != null
                                  ? '${state.journeys.latest(kind)!.stage}/$journeyStageCount · ${state.journeys.latest(kind)!.completed ? copy.t('finished') : copy.t('resume')}'
                                  : copy.t('freeCount'),
                              style: const TextStyle(color: journeyAccent),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            color: journeyAccent,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          OutlinedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const JourneyPurchaseScreen(),
              ),
            ),
            child: Text(copy.t('seeComplete')),
          ),
          if (state.journeys.runs.where((r) => r.completed).isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              copy.t('archive'),
              style: HunterSystemFrame.themeFor(context).textTheme.titleMedium,
            ),
            for (final run
                in state.journeys.runs
                    .where((r) => r.completed)
                    .toList()
                    .reversed)
              ListTile(
                title: Text(run.goal),
                subtitle: Text(copy.title(run.kind)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        JourneyRouteScreen(kind: run.kind, runId: run.id),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class JourneyRouteScreen extends StatefulWidget {
  final JourneyKind kind;
  final String? runId;
  const JourneyRouteScreen({super.key, required this.kind, this.runId});
  @override
  State<JourneyRouteScreen> createState() => _JourneyRouteScreenState();
}

class _JourneyRouteScreenState extends State<JourneyRouteScreen> {
  late Future<JourneyCatalog> _catalog = JourneyCatalog.load();
  String? _runId;
  bool _busy = false;
  String? _error;
  Future<void> _openMission(
    JourneyRun run,
    JourneyCatalog catalog,
    JourneyCopy copy,
  ) async {
    final state = context.read<CharacterState>();
    final scope = state.personalizationScope;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      // Resuming an already accepted mission must also update the status window.
      // Selecting only on first acceptance leaves another route on the home tab.
      await state.selectJourney(run.id);
      if (!mounted || state.personalizationScope != scope) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => JourneyMissionScreen(
            runId: run.id,
            stage: run.stage,
            catalog: catalog,
          ),
        ),
      );
    } catch (_) {
      if (mounted) setState(() => _error = copy.t('error'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _editGoal(JourneyCopy copy, JourneyRun run) async {
    final state = context.read<CharacterState>();
    final goal = await showDialog<String>(
      context: context,
      builder: (_) =>
          _JourneyGoalDialog(initial: run.goal, copy: copy, editing: true),
    );
    if (goal == null || !mounted) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await state.renameJourneyGoal(run.id, goal);
    } catch (_) {
      if (mounted) setState(() => _error = copy.t('error'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _start(JourneyCopy copy, JourneyRun? existing) async {
    final state = context.read<CharacterState>();
    String? goal;
    if (existing == null || existing.completed) {
      goal = await showDialog<String>(
        context: context,
        builder: (_) => _JourneyGoalDialog(
          initial: context.read<QuestDirectorState>().profile.goal,
          copy: copy,
        ),
      );
      if (goal == null || !mounted) return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final run = await state.startJourney(widget.kind, goal ?? existing!.goal);
      if (mounted) setState(() => _runId = run.id);
    } catch (_) {
      if (mounted) setState(() => _error = copy.t('error'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CharacterState>();
    final copy = JourneyCopy(Localizations.localeOf(context).languageCode);
    final id = _runId ?? widget.runId;
    final run = id == null
        ? state.journeys.latest(widget.kind)
        : state.journeys.runs.where((r) => r.id == id).firstOrNull;
    return _JourneyScaffold(
      title: copy.title(widget.kind),
      child: FutureBuilder<JourneyCatalog>(
        future: _catalog,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Column(
              children: [
                Text(copy.t('loadError')),
                TextButton(
                  onPressed: () =>
                      setState(() => _catalog = JourneyCatalog.load()),
                  child: Text(copy.t('retry')),
                ),
              ],
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final catalog = snapshot.requireData;
          final stage = run?.stage ?? 0;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(journeyIcon(widget.kind), color: journeyAccent, size: 36),
              const SizedBox(height: 18),
              Text(
                run?.goal ?? copy.description(widget.kind),
                style: HunterSystemFrame.themeFor(context).textTheme.titleLarge,
              ),
              if (run != null && !run.completed)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _busy ? null : () => _editGoal(copy, run),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: Text(
                      copy.choose(['Edit goal', '목표 다듬기', '目標を編集', '編輯目標']),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                copy.t('pace'),
                style: const TextStyle(color: Color(0xFFAFC5D2), height: 1.5),
              ),
              const SizedBox(height: 20),
              if (run != null) ...[
                Text('$stage/$journeyStageCount · ${copy.t('saved')}'),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: stage / journeyStageCount),
                const SizedBox(height: 22),
                if (run.completed) ...[
                  Text(
                    copy.t('finished'),
                    style: HunterSystemFrame.themeFor(
                      context,
                    ).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Text(copy.t('finishBody')),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _busy ? null : () => _start(copy, run),
                    child: Text(copy.t('restart')),
                  ),
                ] else ...[
                  Text(
                    '${copy.t('next')} · ${stage + 1}',
                    style: const TextStyle(color: journeyAccent),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    catalog.mission(widget.kind, stage).title(copy.locale),
                    style: HunterSystemFrame.themeFor(
                      context,
                    ).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    key: const ValueKey('journey-next'),
                    onPressed: _busy
                        ? null
                        : () => _openMission(run, catalog, copy),
                    child: Text(copy.t('open')),
                  ),
                ],
                if (run.entries.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    key: const ValueKey('journey-record'),
                    onPressed: _busy
                        ? null
                        : () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => JourneyRecordScreen(
                                runId: run.id,
                                catalog: catalog,
                              ),
                            ),
                          ),
                    icon: const Icon(Icons.auto_stories_outlined),
                    label: Text(journeyRecordTitle(copy)),
                  ),
                ],
              ] else
                FilledButton(
                  key: const ValueKey('journey-start'),
                  onPressed: _busy ? null : () => _start(copy, null),
                  child: Text(copy.t('start')),
                ),
              if (_busy) const LinearProgressIndicator(),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Color(0xFFFFB4AB))),
              const SizedBox(height: 28),
              for (var i = 0; i < journeyStageCount; i++) ...[
                if (i % 7 == 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 8),
                    child: Text(
                      '${i ~/ 7 + 1}. ${copy.chapter(i)} · ${i == 0 ? copy.t('free') : copy.t('complete')}',
                      style: const TextStyle(
                        color: journeyAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    i < stage
                        ? Icons.check_circle_outline
                        : i >= journeyFreeStages && !state.ownsJourneys
                        ? Icons.lock_outline
                        : Icons.radio_button_unchecked,
                    color: i < stage ? journeyAccent : const Color(0xFFAFC5D2),
                  ),
                  title: Text(
                    '${i + 1}. ${catalog.mission(widget.kind, i).title(copy.locale)}',
                  ),
                  subtitle: i < stage && run!.entries[i].note.isNotEmpty
                      ? Text(run.entries[i].note)
                      : null,
                  onTap: () => _preview(
                    context,
                    copy,
                    catalog.mission(widget.kind, i),
                    i,
                    run,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Text(
                copy.t('evidence'),
                style: HunterSystemFrame.themeFor(context).textTheme.bodySmall,
              ),
            ],
          );
        },
      ),
    );
  }

  void _preview(
    BuildContext context,
    JourneyCopy copy,
    JourneyMission mission,
    int stage,
    JourneyRun? run,
  ) {
    final entry = run != null && stage < run.stage ? run.entries[stage] : null;
    // Mission 8 is a full paid-chapter sample. Keep completed records readable
    // even after a refund; unfinished paid instructions require ownership.
    final readable =
        stage <= journeyFreeStages ||
        context.read<CharacterState>().ownsJourneys ||
        (run != null && stage < run.stage);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(ctx).height * .85,
        ),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: [
            Text(
              '${copy.t(entry == null ? 'preview' : 'saved')} · ${stage + 1}',
              style: const TextStyle(color: journeyAccent),
            ),
            const SizedBox(height: 12),
            Text(
              mission.title(copy.locale),
              style: Theme.of(ctx).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            if (entry != null) ...[
              Text(journeyRecordMode(entry, copy)),
              const SizedBox(height: 12),
            ],
            if (readable)
              for (final step in mission.steps(
                copy.locale,
                shortVersion: entry?.shortVersion ?? false,
              ))
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(step, style: const TextStyle(height: 1.6)),
                )
            else ...[
              Text(copy.t('lockedBody'), style: const TextStyle(height: 1.6)),
              const SizedBox(height: 12),
              Text(copy.t('sampleHint')),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const JourneyPurchaseScreen(),
                    ),
                  );
                },
                child: Text(copy.t('seeComplete')),
              ),
            ],
            if (entry != null) ...[
              const Divider(),
              Text('${copy.t('saved')} · ${journeyRecordDate(entry.at)}'),
              if (entry.note.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(entry.note),
                ),
            ] else
              Text(
                copy.t('previewHint'),
                style: Theme.of(ctx).textTheme.bodySmall,
              ),
            const SizedBox(height: 18),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(copy.t('back')),
            ),
          ],
        ),
      ),
    );
  }
}

class JourneyRecordScreen extends StatefulWidget {
  final String runId;
  final JourneyCatalog catalog;
  const JourneyRecordScreen({
    super.key,
    required this.runId,
    required this.catalog,
  });
  @override
  State<JourneyRecordScreen> createState() => _JourneyRecordScreenState();
}

class _JourneyRecordScreenState extends State<JourneyRecordScreen> {
  late final String _scope = context
      .read<CharacterState>()
      .personalizationScope;
  bool _copying = false;
  @override
  Widget build(BuildContext context) {
    final state = context.watch<CharacterState>();
    final copy = JourneyCopy(Localizations.localeOf(context).languageCode);
    final run = state.personalizationScope == _scope
        ? state.journeys.runs.where((r) => r.id == widget.runId).firstOrNull
        : null;
    return _JourneyScaffold(
      title: journeyRecordTitle(copy),
      child: run == null
          ? Text(
              copy.choose([
                'This record is no longer available.',
                '이 기록을 더 이상 볼 수 없습니다.',
                'この記録は表示できません。',
                '此紀錄已無法顯示。',
              ]),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (run.entries.isNotEmpty) ...[
                  OutlinedButton.icon(
                    key: const ValueKey('journey-record-copy'),
                    onPressed: _copying
                        ? null
                        : () async {
                            setState(() => _copying = true);
                            var succeeded = false;
                            try {
                              await Clipboard.setData(
                                ClipboardData(
                                  text: journeyRecordText(
                                    run,
                                    widget.catalog,
                                    copy,
                                  ),
                                ),
                              );
                              succeeded = true;
                            } catch (_) {
                              // Keep the record readable and let the user retry.
                            }
                            if (!context.mounted) return;
                            setState(() => _copying = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  copy.choose(
                                    succeeded
                                        ? [
                                            'Record copied. Paste it into your notes.',
                                            '기록을 복사했습니다. 원하는 메모 앱에 붙여 넣으세요.',
                                            '記録をコピーしました。メモなどに貼り付けられます。',
                                            '已複製紀錄，可貼到自己的筆記。',
                                          ]
                                        : [
                                            'Could not copy. Please retry.',
                                            '복사하지 못했습니다. 다시 시도해 주세요.',
                                            'コピーできませんでした。再試行してください。',
                                            '無法複製，請重試。',
                                          ],
                                  ),
                                ),
                              ),
                            );
                          },
                    icon: const Icon(Icons.copy_outlined),
                    label: Text(
                      copy.choose([
                        'Copy my record',
                        '내 기록 복사',
                        '自分の記録をコピー',
                        '複製我的紀錄',
                      ]),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                JourneyRecordBody(run: run, catalog: widget.catalog),
              ],
            ),
    );
  }
}

class JourneyMissionScreen extends StatefulWidget {
  final String runId;
  final JourneyCatalog catalog;
  final int stage;
  const JourneyMissionScreen({
    super.key,
    required this.runId,
    required this.stage,
    required this.catalog,
  });
  @override
  State<JourneyMissionScreen> createState() => _JourneyMissionScreenState();
}

class _JourneyMissionScreenState extends State<JourneyMissionScreen> {
  bool _short = false, _busy = false;
  bool _rewardVisible = false;
  String? _error;
  final _note = TextEditingController();
  late final CharacterState _profile;
  late final String _scope;
  String get _questId => 'journey:${widget.runId}:${widget.stage}';
  bool _draftReady = false, _draftFailed = false, _leaving = false;
  String _savedNote = '';
  int _draftRevision = 0;
  Future<bool> _draftWrite = Future.value(true);
  bool get _sameProfile =>
      _profile.personalizationScope == _scope &&
      _profile.journeys.runs.any((r) => r.id == widget.runId);
  bool get _dirty => _draftReady && _note.text != _savedNote;

  @override
  void initState() {
    super.initState();
    _profile = context.read<CharacterState>();
    _scope = _profile.personalizationScope;
    unawaited(_loadDraft());
  }

  Future<void> _loadDraft() async {
    try {
      final draft = await MissionDraftStore.read(_scope, _questId);
      if (!mounted || !_sameProfile) return;
      final accepted = _profile.dailyQuests
          .where((q) => q.id == _questId)
          .firstOrNull;
      _note.text = draft ?? accepted?.completionNote ?? '';
      _savedNote = _note.text;
      setState(() {
        _draftReady = true;
        _draftFailed = false;
      });
    } catch (_) {
      if (mounted) setState(() => _draftFailed = true);
    }
  }

  Future<bool> _saveDraft() {
    if (!_draftReady || !_sameProfile) return Future.value(false);
    final value = _note.text;
    final revision = ++_draftRevision;
    setState(() => _draftFailed = false);
    return _draftWrite = MissionDraftStore.write(_scope, _questId, value).then(
      (_) {
        if (mounted && _sameProfile && revision == _draftRevision) {
          setState(() {
            _savedNote = value;
            _draftFailed = false;
          });
        }
        return true;
      },
      onError: (Object _, StackTrace __) {
        if (mounted && _sameProfile && revision == _draftRevision) {
          setState(() => _draftFailed = true);
        }
        return false;
      },
    );
  }

  Future<void> _leave() async {
    if (_busy || _leaving) return;
    if (!await _draftWrite || _dirty) {
      if (!await _saveDraft()) return;
    }
    if (!mounted) return;
    setState(() => _leaving = true);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _accept(
    CharacterState state,
    JourneyRun run,
    JourneyMission mission,
    JourneyCopy copy,
    int minutes,
  ) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await state.acceptJourney(
        runId: run.id,
        title: mission.title(copy.locale),
        instruction: mission
            .steps(copy.locale, shortVersion: _short)
            .join('\n\n'),
        minutes: minutes,
        shortVersion: _short,
        locale: copy.locale,
      );
    } catch (_) {
      if (mounted) setState(() => _error = copy.t('error'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _finish(
    CharacterState state,
    Quest quest,
    JourneyCopy copy,
  ) async {
    setState(() {
      _busy = true;
      _error = null;
      _rewardVisible = false;
    });
    try {
      quest.completionNote = journeyNote(_note.text);
      final receipt = await state.completeQuestDurably(quest);
      // Wait for the final local write before cleanup. A cleanup failure must
      // not turn an already persisted completion into a second XP attempt.
      await _draftWrite;
      try {
        await MissionDraftStore.remove(_scope, _questId);
      } catch (_) {
        // Account/device deletion also removes all remaining scoped drafts.
      }
      if (!mounted) return;
      setState(() {
        _rewardVisible = true;
        _savedNote = _note.text;
      });
      await showSystemReward(context, receipt);
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) setState(() => _error = copy.t('error'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CharacterState>();
    final copy = JourneyCopy(Localizations.localeOf(context).languageCode);
    final run = state.journeys.runs
        .where((r) => r.id == widget.runId)
        .firstOrNull;
    if (run == null || !_sameProfile) {
      return _JourneyScaffold(
        title: copy.t('routes'),
        child: Text(copy.t('finished')),
      );
    }
    final mission = widget.catalog.mission(run.kind, widget.stage);
    final accepted = state.dailyQuests
        .where((q) => q.id == 'journey:${run.id}:${widget.stage}')
        .firstOrNull;
    final paid =
        widget.stage >= journeyFreeStages &&
        !state.ownsJourneys &&
        accepted == null;
    final short = accepted?.journeyShortVersion ?? _short;
    final minutes =
        accepted?.estimatedMinutes ??
        (_short
            ? 2
            : context.watch<QuestDirectorState>().profile.minutes.clamp(3, 15));
    return PopScope(
      canPop: !_busy && ((!_dirty && !_draftFailed) || _leaving),
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) unawaited(_leave());
      },
      child: _JourneyScaffold(
        title: copy.title(run.kind),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${copy.chapter(widget.stage)} · ${widget.stage + 1}/$journeyStageCount',
              style: const TextStyle(color: journeyAccent),
            ),
            const SizedBox(height: 14),
            Text(
              mission.title(copy.locale),
              style: HunterSystemFrame.themeFor(
                context,
              ).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(run.goal, style: const TextStyle(color: Color(0xFFAFC5D2))),
            if (run.entries.any((e) => e.note.isNotEmpty)) ...[
              const SizedBox(height: 12),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text(
                  copy.choose([
                    'Your earlier notes',
                    '앞서 남긴 메모',
                    'これまでのメモ',
                    '先前的筆記',
                  ]),
                ),
                children: [
                  for (var i = run.entries.length - 1; i >= 0; i--)
                    if (run.entries[i].note.isNotEmpty)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          '${i + 1}. ${widget.catalog.mission(run.kind, i).title(copy.locale)}',
                        ),
                        subtitle: Text(run.entries[i].note),
                      ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            if (paid) ...[
              Text(
                copy.t('locked'),
                style: HunterSystemFrame.themeFor(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(copy.t('lockedBody'), style: const TextStyle(height: 1.6)),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const JourneyPurchaseScreen(),
                  ),
                ),
                child: Text(copy.t('seeComplete')),
              ),
            ] else ...[
              if (accepted == null) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text(
                        '${copy.t('usual')} · ${context.read<QuestDirectorState>().profile.minutes.clamp(3, 15)} ${copy.t('min')}',
                      ),
                      selected: !_short,
                      onSelected: _busy
                          ? null
                          : (_) => setState(() => _short = false),
                    ),
                    ChoiceChip(
                      key: const ValueKey('journey-small'),
                      label: Text(copy.t('short')),
                      selected: _short,
                      onSelected: _busy
                          ? null
                          : (_) => setState(() => _short = true),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ] else
                Text(
                  '${copy.t('accepted')} · $minutes ${copy.t('min')}',
                  style: const TextStyle(color: journeyAccent),
                ),
              if (short)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(copy.t('shortHint')),
                ),
              for (
                var i = 0;
                i < mission.steps(copy.locale, shortVersion: short).length;
                i++
              )
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${i + 1}'.padLeft(2, '0'),
                        style: const TextStyle(
                          color: journeyAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          mission.steps(copy.locale, shortVersion: short)[i],
                          style: const TextStyle(fontSize: 17, height: 1.6),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              if (accepted == null)
                FilledButton(
                  key: const ValueKey('journey-accept'),
                  onPressed: _busy
                      ? null
                      : () => _accept(state, run, mission, copy, minutes),
                  child: Text(copy.t('accept')),
                )
              else ...[
                OutlinedButton.icon(
                  onPressed: _busy
                      ? null
                      : () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => MissionFocusScreen(
                              quest: accepted,
                              scope: state.personalizationScope,
                            ),
                          ),
                        ),
                  icon: const Icon(Icons.timer_outlined),
                  label: Text(copy.t('timer')),
                ),
                const SizedBox(height: 20),
                TextField(
                  key: const ValueKey('journey-note'),
                  controller: _note,
                  maxLength: 240,
                  minLines: 2,
                  maxLines: 5,
                  enabled: !_busy && _draftReady && _sameProfile,
                  onChanged: (_) => unawaited(_saveDraft()),
                  decoration: InputDecoration(
                    labelText: copy.t('note'),
                    hintText: copy.t('noteHint'),
                    alignLabelWithHint: true,
                  ),
                ),
                Text(
                  copy.choose(
                    _draftFailed
                        ? [
                            'Draft not saved. Keep this screen open and retry.',
                            '임시 저장에 실패했습니다. 화면을 닫지 말고 다시 시도해 주세요.',
                            '下書きを保存できませんでした。この画面で再試行してください。',
                            '草稿儲存失敗。請留在此畫面重試。',
                          ]
                        : !_draftReady
                        ? [
                            'Loading draft…',
                            '메모 불러오는 중…',
                            '下書きを読み込み中…',
                            '正在載入草稿…',
                          ]
                        : _dirty
                        ? ['Saving draft…', '임시 저장 중…', '下書きを保存中…', '正在儲存草稿…']
                        : [
                            'Draft saved on this device. Complete the mission to add it to your record.',
                            '이 기기에 임시 저장됩니다. 실행 완료하면 기록에 남습니다.',
                            '下書きはこの端末に保存されます。ミッションを完了すると記録に残ります。',
                            '草稿儲存在此裝置。完成任務後會加入紀錄。',
                          ],
                  ),
                  style: TextStyle(
                    color: _draftFailed ? const Color(0xFFFFB4AB) : null,
                    fontSize: 12,
                  ),
                ),
                if (_draftFailed)
                  TextButton(
                    key: const ValueKey('journey-draft-retry'),
                    onPressed: () => _draftReady ? _saveDraft() : _loadDraft(),
                    child: Text(copy.choose(['Retry', '다시 시도', '再試行', '重試'])),
                  ),
                const SizedBox(height: 12),
                FilledButton(
                  key: const ValueKey('journey-finish'),
                  onPressed: _busy || !_draftReady || !_sameProfile
                      ? null
                      : () => _finish(state, accepted, copy),
                  child: Text(copy.t('done')),
                ),
              ],
            ],
            if (_busy && !_rewardVisible)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: LinearProgressIndicator(),
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Color(0xFFFFB4AB)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _JourneyScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  const _JourneyScaffold({required this.title, required this.child});
  @override
  Widget build(BuildContext context) => Theme(
    data: HunterSystemFrame.themeFor(context),
    child: Scaffold(
      backgroundColor: const Color(0xFF07131B),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF07131B),
      ),
      body: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
              child: child,
            ),
          ),
        ),
      ),
    ),
  );
}

class _JourneyGoalDialog extends StatefulWidget {
  final String initial;
  final JourneyCopy copy;
  final bool editing;
  const _JourneyGoalDialog({
    required this.initial,
    required this.copy,
    this.editing = false,
  });
  @override
  State<_JourneyGoalDialog> createState() => _JourneyGoalDialogState();
}

class _JourneyGoalDialogState extends State<_JourneyGoalDialog> {
  late final _controller = TextEditingController(text: widget.initial);
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    scrollable: true,
    title: Text(widget.copy.t('goal')),
    content: TextField(
      key: const ValueKey('journey-goal'),
      controller: _controller,
      maxLength: 120,
      minLines: 1,
      maxLines: 3,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(hintText: widget.copy.t('goalHint')),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(widget.copy.t('cancel')),
      ),
      FilledButton(
        onPressed: _controller.text.trim().isEmpty
            ? null
            : () => Navigator.pop(context, _controller.text.trim()),
        child: Text(
          widget.editing
              ? widget.copy.choose(['Save', '저장', '保存', '儲存'])
              : widget.copy.t('start'),
        ),
      ),
    ],
  );
}
