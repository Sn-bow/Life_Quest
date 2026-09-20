import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../state/character_state.dart';
import '../backup/backup_files.dart';
import 'beta_study.dart';

BetaSnapshot studySnapshot(CharacterState character) => BetaSnapshot(
  completions: character.questCompletionCount,
  previewComplete: ['tide/door', 'tide/receipt'].every(
    (key) => const {'open', 'keep'}.contains(character.storyChoices[key]),
  ),
);

class BetaStudyScreen extends StatefulWidget {
  final BetaStudy? study;
  final BackupFiles? files;
  const BetaStudyScreen({super.key, this.study, this.files});
  @override
  State<BetaStudyScreen> createState() => _BetaStudyScreenState();
}

class _BetaStudyScreenState extends State<BetaStudyScreen> {
  late final study = widget.study ?? BetaStudy.instance;
  Map<String, dynamic>? record;
  bool busy = true;
  bool failed = false;
  int? value;
  int? price;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    try {
      final data = await study.load();
      final report = data == null ? null : await study.report();
      if (!mounted) return;
      setState(() {
        record = report;
        value = report?['feedback']['value'] as int?;
        price = report?['feedback']['maxPriceKRW'] as int?;
        failed = false;
        busy = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          failed = true;
          busy = false;
        });
      }
    }
  }

  Future<void> _run(Future<bool> Function() action) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      final saved = await action();
      if (!mounted) return;
      if (saved) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.lqStudySaved)),
        );
      }
      await _reload();
    } catch (_) {
      if (mounted) {
        setState(() {
          busy = false;
          failed = true;
        });
      }
    }
  }

  Future<void> _withdraw() async {
    final l = AppLocalizations.of(context)!;
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.lqStudyWithdraw),
        content: Text(l.lqStudyWithdrawNote),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.lqStudyWithdraw),
          ),
        ],
      ),
    );
    if (yes == true && mounted) {
      await _run(() async {
        await study.withdraw();
        return true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final d = record;
    final canRate =
        d != null &&
        (d['baselinePreviewComplete'] == true || d['previewDay'] != null);
    final days = d == null ? <String, int>{} : Map<String, int>.from(d['days']);
    return Scaffold(
      appBar: AppBar(title: Text(l.lqStudyTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                l.lqStudyIntro,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(l.lqStudyConsent),
              const SizedBox(height: 20),
              if (busy) const LinearProgressIndicator(),
              if (failed) ...[
                Text(l.lqStudyError),
                TextButton(
                  onPressed: busy ? null : _reload,
                  child: Text(l.lqRetry),
                ),
              ],
              if (!study.enabled)
                Text(l.lqStudyWebPreview)
              else if (d == null && !failed)
                FilledButton(
                  onPressed: busy
                      ? null
                      : () => _run(() async {
                          await study.start(
                            studySnapshot(context.read<CharacterState>()),
                          );
                          return true;
                        }),
                  child: Text(l.lqStudyStart),
                ),
              if (d != null) ...[
                if (d['environment'] == 'web_preview')
                  Text(l.lqStudyWebPreview),
                if ((d['qualityFlags'] as List).isNotEmpty)
                  Text(l.lqStudyFlagged),
                const SizedBox(height: 12),
                Text(
                  l.lqStudySummary,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${days.length} / ${days.values.fold<int>(0, (a, b) => a + b)}',
                ),
                const SizedBox(height: 24),
                if (!canRate)
                  Text(l.lqStudyPreviewFirst)
                else ...[
                  Text(l.lqStudyValue),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: List.generate(
                      5,
                      (index) => ChoiceChip(
                        label: Text('${index + 1}'),
                        selected: value == index + 1,
                        onSelected: busy
                            ? null
                            : (_) => setState(() => value = index + 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(l.lqStudyPrice),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [-1, 0, 2900, 4900, 6900]
                        .map(
                          (p) => ChoiceChip(
                            label: Text(
                              p == -1
                                  ? l.lqStudyUndecided
                                  : p == 0
                                  ? l.lqStudyNoPurchase
                                  : '₩$p',
                            ),
                            selected: price == p,
                            onSelected: busy
                                ? null
                                : (_) => setState(() => price = p),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  Text(l.lqStudyPriceNote),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: busy || value == null || price == null
                        ? null
                        : () => _run(() async {
                            await study.feedback(value: value!, price: price!);
                            return true;
                          }),
                    child: Text(l.lqStudySave),
                  ),
                ],
                const SizedBox(height: 24),
                Text(l.lqStudyExportNote),
                const SizedBox(height: 8),
                SelectableText(d['participant'] as String),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: busy
                      ? null
                      : () => _run(() async {
                          final report = await study.report();
                          return (widget.files ?? NativeBackupFiles()).save(
                            Uint8List.fromList(
                              utf8.encode(
                                const JsonEncoder.withIndent(
                                  '  ',
                                ).convert(report),
                              ),
                            ),
                            'lifequest-study-${report['participant']}.json',
                          );
                        }),
                  icon: const Icon(Icons.save_alt),
                  label: Text(l.lqStudyExport),
                ),
              ],
              if (d != null || failed) ...[
                const SizedBox(height: 16),
                TextButton(
                  onPressed: busy ? null : _withdraw,
                  child: Text(l.lqStudyWithdraw),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
