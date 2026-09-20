import 'dart:async';
import '../../state/character_state.dart';
import '../../config/cloud_config.dart';
import '../../config/qa_preview_config.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';
import 'director_widgets.dart';
import 'on_device_quest_model.dart';
import 'quest_director_engine.dart';
import 'quest_director_state.dart';

Future<void> showHunterCheckIn(BuildContext context) =>
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => const FractionallySizedBox(
            heightFactor: .9, child: _CheckInSheet()));

class _CheckInSheet extends StatefulWidget {
  const _CheckInSheet();
  @override
  State<_CheckInSheet> createState() => _CheckInSheetState();
}

class _CheckInSheetState extends State<_CheckInSheet> {
  late HunterProfile profile;
  late TextEditingController goal;
  bool saving = false;
  @override
  void initState() {
    super.initState();
    profile = context.read<QuestDirectorState>().profile;
    goal = TextEditingController(text: profile.goal);
  }

  @override
  void dispose() {
    goal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final energies = [s.lqEnergyLow, s.lqEnergyMedium, s.lqEnergyHigh];
    return ListView(
        padding: EdgeInsets.fromLTRB(
            24, 0, 24, 24 + MediaQuery.viewInsetsOf(context).bottom),
        children: [
          Row(children: [
            Expanded(
                child: Text(s.lqCheckIn, style: theme.textTheme.titleLarge)),
            IconButton(
                tooltip: s.close,
                onPressed: () => Navigator.pop(context),
                icon: const Icon(PhosphorIcons.x))
          ]),
          Text(s.lqCheckInHint, style: theme.textTheme.bodySmall),
          const SizedBox(height: 24),
          Text(s.lqEnergy, style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 4, children: [
            for (var i = 0; i < 3; i++)
              ChoiceChip(
                  label: Text(energies[i]),
                  selected: profile.energy == i + 1,
                  onSelected: (_) =>
                      setState(() => profile = profile.copyWith(energy: i + 1)))
          ]),
          const SizedBox(height: 22),
          Text(s.lqTimeBudget, style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 4, children: [
            for (final m in [3, 9, 15, 30, 60])
              ChoiceChip(
                  label: Text('$m ${s.lqMinutes}'),
                  selected: profile.minutes == m,
                  onSelected: (_) =>
                      setState(() => profile = profile.copyWith(minutes: m)))
          ]),
          const SizedBox(height: 22),
          Text(s.lqFocus, style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 6, children: [
            for (final focus in GrowthFocus.values)
              FilterChip(
                  avatar: Icon(focusIcon(focus), size: 17),
                  label: Text(focusName(focus, s)),
                  selected: profile.focuses.contains(focus),
                  onSelected: (selected) {
                    final next = Set<GrowthFocus>.of(profile.focuses);
                    if (selected) {
                      next.add(focus);
                    } else if (next.length > 1) {
                      next.remove(focus);
                    }
                    setState(() => profile = profile.copyWith(focuses: next));
                  })
          ]),
          const SizedBox(height: 22),
          TextField(
              controller: goal,
              maxLength: 120,
              maxLines: 2,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                  labelText: s.lqGoal,
                  hintText: s.lqGoalHint,
                  alignLabelWithHint: true)),
          const SizedBox(height: 8),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(PhosphorIcons.lockSimple,
                size: 15, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Expanded(
                child: Text(s.lqGoalPrivacy, style: theme.textTheme.bodySmall))
          ]),
          const SizedBox(height: 22),
          FilledButton(
              onPressed: saving
                  ? null
                  : () async {
                      setState(() => saving = true);
                      final director = context.read<QuestDirectorState>();
                      await director
                          .configure(profile.copyWith(goal: goal.text));
                      if (!context.mounted) return;
                      unawaited(director.personalizeIfNeeded(
                          Localizations.localeOf(context).languageCode));
                      Navigator.pop(context);
                    },
              child: Text(s.lqApply)),
        ]);
  }
}

class DirectorSettingsScreen extends StatelessWidget {
  const DirectorSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<QuestDirectorState>();
    final s = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final status = state.modelStatus;
    final downloadable = status == OnDeviceModelStatus.downloadable;
    return Scaffold(
        appBar: AppBar(title: Text(s.lqDirector)),
        body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
            children: [
              Align(alignment: Alignment.centerRight, child: TextButton(
                onPressed: () => showLicensePage(context: context, applicationName: 'Life Quest'),
                child: Text(s.lqOpenSourceLicenses))),
              Card(
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(PhosphorIcons.cpu,
                                size: 36, color: colors.primary),
                            const SizedBox(height: 16),
                            Text(s.lqModelName,
                                style: theme.textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text(s.lqModelIntro),
                            const SizedBox(height: 12),
                            Text(context.watch<CharacterState>().isLocalGuest ||
                                    !kLifeQuestCloudEnabled || kLifeQuestQaPreview
                                    ? s.lqDeviceQuestNotice : s.lqCloudQuestNotice,
                                style: theme.textTheme.bodySmall),
                            const SizedBox(height: 16),
                            QuestTag(
                                status == OnDeviceModelStatus.available
                                    ? s.lqLocalAi
                                    : s.lqBasicMode,
                                color: colors.primary,
                                icon: PhosphorIcons.lockSimple),
                            const SizedBox(height: 16),
                            if (downloadable ||
                                status == OnDeviceModelStatus.downloading) ...[
                              Text(s.lqModelDownloadInfo,
                                  style: theme.textTheme.bodySmall),
                              const SizedBox(height: 16),
                              if (status ==
                                  OnDeviceModelStatus.downloading) ...[
                                LinearProgressIndicator(
                                    value: state.modelSnapshot.progress,
                                    semanticsLabel: s.lqDownload),
                                const SizedBox(height: 8),
                                Text(
                                    '${(state.modelSnapshot.progress * 100).toStringAsFixed(1)}%',
                                    style: theme.textTheme.bodySmall),
                                TextButton.icon(
                                    onPressed: state.cancelModelOperation,
                                    icon: const Icon(PhosphorIcons.pause),
                                    label: Text(s.lqCancel)),
                              ] else
                                SizedBox(
                                    width: double.infinity,
                                    child: FilledButton.icon(
                                        onPressed: state.busy
                                            ? null
                                            : () async {
                                                final locale =
                                                    Localizations.localeOf(
                                                            context)
                                                        .languageCode;
                                                await state.downloadModel();
                                                if (context.mounted) {
                                                  unawaited(
                                                      state.personalizeIfNeeded(
                                                          locale));
                                                }
                                              },
                                        icon: const Icon(
                                            PhosphorIcons.downloadSimple),
                                        label: Text(s.lqDownload))),
                            ],
                            if (status == OnDeviceModelStatus.unavailable)
                              Text(s.lqModelUnavailable,
                                  style: theme.textTheme.bodySmall),
                            if (status == OnDeviceModelStatus.checking)
                              const LinearProgressIndicator(),
                            if (status == OnDeviceModelStatus.available)
                              TextButton.icon(
                                  onPressed:
                                      state.busy ? null : state.removeModel,
                                  icon:
                                      const Icon(PhosphorIcons.trash, size: 18),
                                  label: Text(s.lqRemoveModel)),
                            if (state.modelIssue != null)
                              Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Text(
                                      state.modelIssue == 'generation_rejected'
                                          ? s.lqModelRejected
                                          : s.lqModelError,
                                      style: TextStyle(
                                          color: colors.error, fontSize: 13))),
                            const SizedBox(height: 8),
                            TextButton(
                                onPressed: () => launchUrl(
                                    Uri.parse(
                                        'https://huggingface.co/litert-community/gemma-4-E2B-it-litert-lm'),
                                    mode: LaunchMode.externalApplication),
                                child: const Text('Gemma 4 · Apache 2.0 ↗')),
                          ]))),
              const SizedBox(height: 20),
              Card(
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.lqLearningHistory,
                                style: theme.textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text(s.lqLearningHistoryBody,
                                style: theme.textTheme.bodySmall),
                            const SizedBox(height: 12),
                            TextButton.icon(
                                onPressed: () => showHunterCheckIn(context),
                                icon: const Icon(
                                    PhosphorIcons.slidersHorizontal,
                                    size: 18),
                                label: Text(s.lqCheckIn)),
                            TextButton(
                                onPressed: state.busy
                                    ? null
                                    : () async {
                                        final reset = await showDialog<bool>(
                                            context: context,
                                            builder: (dialog) => AlertDialog(
                                                    title:
                                                        Text(s.lqClearLearning),
                                                    content:
                                                        Text(s.lqResetConfirm),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  dialog,
                                                                  false),
                                                          child: Text(s.close)),
                                                      TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  dialog, true),
                                                          child: Text(s
                                                              .lqClearLearning))
                                                    ]));
                                        if (reset == true) {
                                          await state.clearLearning();
                                        }
                                      },
                                child: Text(s.lqClearLearning)),
                          ]))),
              if (state.saveFailed)
                Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(s.lqStorageError,
                        style: TextStyle(color: colors.error))),
            ]));
  }
}
