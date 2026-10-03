import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../state/character_state.dart';
import '../system/hunter_system_frame.dart';
import 'journey_catalog.dart';
import 'journey_tool.dart';
import 'journey_tool_copy.dart';
import 'journey_progress.dart';

class JourneyToolEditor extends StatelessWidget {
  final JourneyToolKind kind;
  final List<TextEditingController> controllers;
  final bool enabled;
  final VoidCallback onChanged;
  const JourneyToolEditor({
    super.key,
    required this.kind,
    required this.controllers,
    required this.enabled,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    final copy = JourneyCopy(Localizations.localeOf(context).languageCode);
    final labels = journeyToolLabels(kind, copy);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          journeyToolTitle(kind, copy),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(journeyToolHelp(kind, copy), style: const TextStyle(height: 1.5)),
        const SizedBox(height: 16),
        for (var i = 0; i < labels.length; i++) ...[
          TextField(
            key: ValueKey('journey-tool-field-$i'),
            controller: controllers[i],
            enabled: enabled,
            maxLength: 1200,
            minLines: 2,
            maxLines: 8,
            onChanged: (_) => onChanged(),
            decoration: InputDecoration(
              labelText: labels[i],
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

/// Practice changes only this view. It cannot claim new action/XP or change the
/// user's original completion. Persistent edits go through CharacterState.
class JourneyToolCard extends StatefulWidget {
  final JourneyTool tool;
  final VoidCallback? onEdit;
  const JourneyToolCard({super.key, required this.tool, this.onEdit});
  @override
  State<JourneyToolCard> createState() => _JourneyToolCardState();
}

class _JourneyToolCardState extends State<JourneyToolCard> {
  bool _revealed = false, _small = false;
  final Set<int> _checked = {};
  String? _message;
  @override
  void didUpdateWidget(covariant JourneyToolCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tool.toJson().toString() != widget.tool.toJson().toString()) {
      _revealed = false;
      _checked.clear();
      _message = null;
    }
  }

  Future<void> _copy(JourneyCopy c) async {
    try {
      await Clipboard.setData(
        ClipboardData(
          text: widget.tool.kind == JourneyToolKind.script
              ? widget.tool.field(1)
              : journeyToolExport(widget.tool, c),
        ),
      );
      if (mounted) {
        setState(
          () => _message = c.choose(['Copied', '복사했습니다', 'コピーしました', '已複製']),
        );
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _message = c.choose([
            'Could not copy. Try again.',
            '복사하지 못했습니다. 다시 시도해 주세요.',
            'コピーできませんでした。再試行してください。',
            '無法複製，請重試。',
          ]),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = JourneyCopy(Localizations.localeOf(context).languageCode);
    final tool = widget.tool;
    final labels = journeyToolLabels(tool.kind, c);
    final empty = c.choose([
      'Not written yet',
      '아직 적지 않았습니다',
      'まだ書いていません',
      '尚未填寫',
    ]);
    final items = tool
        .field(1)
        .split('\n')
        .where((s) => s.trim().isNotEmpty)
        .toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              journeyToolTitle(tool.kind, c),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(
              tool.field(0).isEmpty ? empty : tool.field(0),
              style: const TextStyle(fontSize: 18, height: 1.5),
            ),
            const SizedBox(height: 12),
            if (tool.kind == JourneyToolKind.flashcard) ...[
              if (_revealed)
                Text(
                  tool.field(1).isEmpty ? empty : tool.field(1),
                  style: const TextStyle(height: 1.5),
                ),
              OutlinedButton.icon(
                key: const ValueKey('tool-reveal'),
                onPressed: () => setState(() => _revealed = !_revealed),
                icon: Icon(
                  _revealed
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                label: Text(
                  c.choose(
                    _revealed
                        ? ['Hide answer', '답 가리기', '答えを隠す', '隱藏答案']
                        : ['Show answer', '답 확인', '答えを見る', '查看答案'],
                  ),
                ),
              ),
            ] else if (tool.kind == JourneyToolKind.checklist) ...[
              if (items.isEmpty) Text(empty),
              for (var i = 0; i < items.length; i++)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(items[i]),
                  value: _checked.contains(i),
                  onChanged: (value) => setState(() {
                    value == true ? _checked.add(i) : _checked.remove(i);
                  }),
                ),
              if (items.isNotEmpty)
                TextButton(
                  onPressed: () => setState(_checked.clear),
                  child: Text(
                    c.choose(['Reset checks', '체크 초기화', 'チェックをリセット', '清除勾選']),
                  ),
                ),
            ] else if (tool.kind == JourneyToolKind.routine) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: Text(
                      c.choose(['Usual day', '평소대로', 'いつもどおり', '一般日子']),
                    ),
                    selected: !_small,
                    onSelected: (_) => setState(() => _small = false),
                  ),
                  ChoiceChip(
                    label: Text(
                      c.choose([
                        'Low-energy day',
                        '힘이 없는 날',
                        '余裕がない日',
                        '沒精神的日子',
                      ]),
                    ),
                    selected: _small,
                    onSelected: (_) => setState(() => _small = true),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(labels[_small ? 2 : 1]),
              Text(
                tool.field(_small ? 2 : 1).isEmpty
                    ? empty
                    : tool.field(_small ? 2 : 1),
                style: const TextStyle(fontSize: 17, height: 1.5),
              ),
            ] else
              Text(
                tool.field(1).isEmpty ? empty : tool.field(1),
                style: const TextStyle(fontSize: 17, height: 1.5),
              ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (widget.onEdit != null)
                  TextButton.icon(
                    key: const ValueKey('tool-edit'),
                    onPressed: widget.onEdit,
                    icon: const Icon(Icons.edit_outlined),
                    label: Text(c.choose(['Edit', '수정', '編集', '編輯'])),
                  ),
                if (tool.hasContent)
                  TextButton.icon(
                    key: const ValueKey('tool-copy'),
                    onPressed: () => _copy(c),
                    icon: const Icon(Icons.copy_outlined),
                    label: Text(c.choose(['Copy', '복사', 'コピー', '複製'])),
                  ),
              ],
            ),
            if (_message != null) Text(_message!, semanticsLabel: _message),
          ],
        ),
      ),
    );
  }
}

Future<void> editJourneyTool(
  BuildContext context,
  JourneyRun run,
  int stage,
) async {
  final kind = journeyToolFor(run.kind, stage);
  if (kind == null || stage >= run.stage) return;
  final state = context.read<CharacterState>();
  final scope = state.personalizationScope;
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _ToolEditDialog(
      state: state,
      scope: scope,
      runId: run.id,
      stage: stage,
      tool:
          run.entries[stage].tool ??
          JourneyTool(
            kind: kind,
            fields: List.filled(kind == JourneyToolKind.routine ? 3 : 2, ''),
          ),
    ),
  );
}

class _ToolEditDialog extends StatefulWidget {
  final CharacterState state;
  final String scope, runId;
  final int stage;
  final JourneyTool tool;
  const _ToolEditDialog({
    required this.state,
    required this.scope,
    required this.runId,
    required this.stage,
    required this.tool,
  });
  @override
  State<_ToolEditDialog> createState() => _ToolEditDialogState();
}

class _ToolEditDialogState extends State<_ToolEditDialog> {
  late final _fields = List.generate(
    widget.tool.fieldCount,
    (i) => TextEditingController(text: widget.tool.field(i)),
  );
  bool _busy = false, _failed = false;
  @override
  void initState() {
    super.initState();
    widget.state.addListener(_profileChanged);
  }

  void _profileChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.state.removeListener(_profileChanged);
    for (final controller in _fields) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _busy = true;
      _failed = false;
    });
    try {
      if (widget.scope != widget.state.personalizationScope) {
        throw StateError('Profile changed');
      }
      await widget.state.updateJourneyTool(
        widget.runId,
        widget.stage,
        JourneyTool(
          kind: widget.tool.kind,
          fields: _fields.map((c) => c.text).toList(),
        ),
      );
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = JourneyCopy(Localizations.localeOf(context).languageCode);
    if (widget.scope != widget.state.personalizationScope ||
        !widget.state.journeys.runs.any((r) => r.id == widget.runId)) {
      return AlertDialog(
        content: Text(c.t('finished')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(c.t('cancel')),
          ),
        ],
      );
    }
    return PopScope(
      canPop: !_busy,
      child: AlertDialog(
        scrollable: true,
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              JourneyToolEditor(
                kind: widget.tool.kind,
                controllers: _fields,
                enabled: !_busy,
                onChanged: () {},
              ),
              if (_failed)
                Text(
                  c.t('error'),
                  style: const TextStyle(color: Color(0xFFFFB4AB)),
                ),
              if (_busy) const LinearProgressIndicator(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: _busy ? null : () => Navigator.pop(context),
            child: Text(c.t('cancel')),
          ),
          FilledButton(
            key: const ValueKey('tool-save'),
            onPressed: _busy ? null : _save,
            child: Text(c.choose(['Save', '저장', '保存', '儲存'])),
          ),
        ],
      ),
    );
  }
}

class JourneyToolkitScreen extends StatefulWidget {
  const JourneyToolkitScreen({super.key});
  @override
  State<JourneyToolkitScreen> createState() => _JourneyToolkitScreenState();
}

class _JourneyToolkitScreenState extends State<JourneyToolkitScreen> {
  late final _scope = context.read<CharacterState>().personalizationScope;
  Future<JourneyCatalog> _catalog = JourneyCatalog.load();
  JourneyKind? _filter;
  @override
  Widget build(BuildContext context) {
    final state = context.watch<CharacterState>();
    final c = JourneyCopy(Localizations.localeOf(context).languageCode);
    final runs = state.personalizationScope == _scope
        ? state.journeys.runs.reversed.toList()
        : <JourneyRun>[];
    return Theme(
      data: HunterSystemFrame.themeFor(context),
      child: Scaffold(
        backgroundColor: const Color(0xFF07131B),
        appBar: AppBar(title: Text(journeyToolkitTitle(c))),
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: FutureBuilder<JourneyCatalog>(
                future: _catalog,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: TextButton(
                        onPressed: () =>
                            setState(() => _catalog = JourneyCatalog.load()),
                        child: Text(c.t('retry')),
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final entries = [
                    for (final run in runs)
                      for (var i = 0; i < run.stage; i++)
                        if ((_filter == null || run.kind == _filter) &&
                            journeyToolFor(run.kind, i) != null)
                          (run: run, stage: i),
                  ];
                  return ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      Text(
                        c.choose([
                          'Use what you made. Review, reset, practise, or copy — without earning extra XP. Saved tools stay available without a purchase.',
                          '내가 만든 것을 다시 써보세요. 복습·정리·연습·복사는 경험치를 추가하지 않습니다. 저장한 도구는 구매 없이 계속 사용할 수 있습니다.',
                          '作ったものをまた使いましょう。復習・片づけ・練習・コピーでは経験値は増えません。保存した道具は購入なしで使えます。',
                          '再次使用自己做出的成果。複習、整理、練習或複製不會增加經驗值。已存工具不需購買也能繼續使用。',
                        ]),
                        style: const TextStyle(height: 1.5),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ChoiceChip(
                            label: Text(c.choose(['All', '전체', 'すべて', '全部'])),
                            selected: _filter == null,
                            onSelected: (_) => setState(() => _filter = null),
                          ),
                          for (final kind in JourneyKind.values)
                            ChoiceChip(
                              label: Text(c.shortTitle(kind)),
                              selected: _filter == kind,
                              onSelected: (_) => setState(() => _filter = kind),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (entries.isEmpty)
                        Text(
                          c.choose([
                            'Your completed missions will appear here when they include a card, checklist, routine or reusable phrase. Try a free first chapter.',
                            '카드·체크리스트·루틴·문장을 만드는 미션을 완료하면 여기에 모입니다. 무료 첫 장에서 먼저 써볼 수 있습니다.',
                            'カード・チェックリスト・ルーティン・言葉を残すミッションを完了すると、ここに集まります。無料の第1章で試せます。',
                            '完成卡片、清單、日常步驟或句子任務後，會集中在這裡。可先從免費第一章體驗。',
                          ]),
                        ),
                      for (final item in entries) ...[
                        Text(
                          '${item.run.goal}\n${item.stage + 1}. ${snapshot.data!.mission(item.run.kind, item.stage).title(c.locale)}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        JourneyToolCard(
                          key: ValueKey('tool-${item.run.id}-${item.stage}'),
                          tool:
                              item.run.entries[item.stage].tool ??
                              JourneyTool(
                                kind: journeyToolFor(
                                  item.run.kind,
                                  item.stage,
                                )!,
                                fields: const [],
                              ),
                          onEdit: () =>
                              editJourneyTool(context, item.run, item.stage),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
