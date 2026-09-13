import '../features/story/story_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../features/director/director_settings_screen.dart';
import '../features/director/ai_report_service.dart';
import '../features/director/ai_report_button.dart';
import '../features/director/director_widgets.dart';
import '../features/director/on_device_quest_model.dart';
import '../features/director/quest_director_engine.dart';
import '../features/director/quest_director_state.dart';
import '../l10n/app_localizations.dart';
import '../models/quest.dart';
import '../state/character_state.dart';
import 'timer_screen.dart';

class TodayScreen extends StatelessWidget {
  final VoidCallback onOpenQuests;
  final VoidCallback onOpenDungeon;
  const TodayScreen(
      {super.key, required this.onOpenQuests, required this.onOpenDungeon});

  @override
  Widget build(BuildContext context) {
    final character = context.watch<CharacterState>();
    final director = context.watch<QuestDirectorState>();
    final s = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final locale = Localizations.localeOf(context).languageCode;
    if (!character.isDataLoaded) {
      return const Center(child: CircularProgressIndicator());
    }
    final today = localDay(DateTime.now());
    final missions =
        character.dailyQuests.where((q) => q.scheduledDay == today).toList();
    final ordinary = character.sortedDailyQuests
        .where((q) => q.scheduledDay == null && !q.isCompleted)
        .take(2)
        .toList();
    final energy = [
      s.lqEnergyLow,
      s.lqEnergyMedium,
      s.lqEnergyHigh
    ][director.profile.energy - 1];
    return Scaffold(
        body: SafeArea(
            bottom: false,
            child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                children: [
                  Row(children: [
                    Icon(PhosphorIcons.compass,
                        color: colors.primary, size: 23),
                    const SizedBox(width: 9),
                    Expanded(
                        child: Text('LIFE QUEST',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2.1,
                                color: colors.onSurface))),
                    IconButton(
                        tooltip: s.statusTimerTooltip,
                        icon: const Icon(PhosphorIcons.timer, size: 23),
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                                builder: (_) => const TimerScreen()))),
                  ]),
                  const SizedBox(height: 16),
                  Text(s.lqHeadline, style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 5),
                  Text(s.lqSubtitle,
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 13)),
                  const SizedBox(height: 22),
                  HunterStatusSummary(state: character),
                  const SizedBox(height: 14),
                  Material(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: director.ready
                              ? () => showHunterCheckIn(context)
                              : null,
                          child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(14, 13, 10, 13),
                              child: Row(children: [
                                Icon(PhosphorIcons.slidersHorizontal,
                                    size: 20, color: colors.primary),
                                const SizedBox(width: 11),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Text(
                                          director.profile.configured
                                              ? '$energy · ${director.profile.minutes} ${s.lqMinutes}'
                                              : s.lqCheckIn,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(fontSize: 13)),
                                      if (!director.profile.configured)
                                        Text(s.lqCheckInHint,
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(fontSize: 11)),
                                    ])),
                                const Icon(PhosphorIcons.caretRight, size: 17),
                              ])))),
                  const SizedBox(height: 26),
                  Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(s.lqDailyMissions,
                            style: theme.textTheme.titleLarge
                                ?.copyWith(fontSize: 18)),
                        QuestTag(
                            director.usedModel ? s.lqLocalAi : s.lqBasicMode,
                            icon: director.usedModel
                                ? PhosphorIcons.cpu
                                : PhosphorIcons.sparkle,
                            color: colors.primary)
                      ]),
                  const SizedBox(height: 12),
                  if (!director.ready)
                    const Padding(
                        padding: EdgeInsets.all(28),
                        child: Center(child: CircularProgressIndicator())),
                  for (final quest in missions)
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _acceptedCard(context, quest)),
                  for (final quest in director.suggestions)
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _suggestionCard(context, quest, locale)),
                  if (director.ready &&
                      director.suggestions.isEmpty &&
                      missions.isEmpty)
                    Card(
                        child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(PhosphorIcons.checkCircle,
                                      color: colors.primary, size: 28),
                                  const SizedBox(height: 12),
                                  Text(s.lqAllSet,
                                      style: theme.textTheme.titleMedium),
                                  const SizedBox(height: 5),
                                  Text(s.lqAllSetBody,
                                      style: theme.textTheme.bodySmall),
                                ]))),
                  if (director.saveFailed)
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(s.lqStorageError,
                            style:
                                TextStyle(color: colors.error, fontSize: 12))),
                  if (director.modelIssue == 'generation_rejected')
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(s.lqModelRejected,
                            style: theme.textTheme.bodySmall)),
                  if (director.busy)
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(children: [
                          const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2)),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(s.lqGenerating,
                                  style: theme.textTheme.bodySmall)),
                          TextButton(
                              onPressed: director.cancelModelOperation,
                              child: Text(s.lqCancel)),
                        ]))
                  else
                    Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                            icon: Icon(
                                director.modelStatus == OnDeviceModelStatus.available
                                    ? PhosphorIcons.sparkle
                                    : PhosphorIcons.cpu,
                                size: 17),
                            onPressed: () => director.modelStatus == OnDeviceModelStatus.available
                                ? director.personalize(locale)
                                : Navigator.of(context).push(MaterialPageRoute<void>(
                                    builder: (_) =>
                                        const DirectorSettingsScreen())),
                            label: Text(director.modelStatus == OnDeviceModelStatus.available
                                ? s.lqGenerate
                                : s.lqDirector))),
                  if (ordinary.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Row(children: [
                      Expanded(
                          child: Text(s.lqActiveQuests,
                              style: theme.textTheme.titleMedium)),
                      TextButton(
                          onPressed: onOpenQuests, child: Text(s.lqAllQuests))
                    ]),
                    for (final quest in ordinary)
                      Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _acceptedCard(context, quest)),
                  ],
                  const SizedBox(height: 26),
                  const StoryBanner(),
                  const SizedBox(height: 10),
                  TextButton.icon(onPressed: onOpenDungeon, icon: const Icon(PhosphorIcons.sword, size: 18), label: Text(s.lqEnterDungeon)),
                ])));
  }

  Widget _suggestionCard(
      BuildContext context, DirectedQuest quest, String locale) {
    final theme = Theme.of(context);
    final s = AppLocalizations.of(context)!;
    final color = focusColor(quest.template.focus, context);
    return Card(
        child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => _showSuggestion(context, quest, locale),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 14, 10, 14),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: 36,
                                height: 36,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: color.withValues(alpha: .12),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Icon(focusIcon(quest.template.focus),
                                    color: color, size: 20)),
                            const SizedBox(width: 11),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text(quest.title(locale),
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(fontSize: 14)),
                                  const SizedBox(height: 5),
                                  Text(
                                      '${quest.minutes} ${s.lqMinutes}  ·  ${focusName(quest.template.focus, s)}  ·  +${quest.xp} XP',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(fontSize: 11)),
                                ])),
                            const SizedBox(width: 6),
                            IconButton(
                                tooltip: s.lqAccept,
                                style: IconButton.styleFrom(
                                    backgroundColor:
                                        color.withValues(alpha: .12),
                                    foregroundColor: color),
                                icon: const Icon(PhosphorIcons.plus, size: 21),
                                onPressed: () =>
                                    _accept(context, quest, locale)),
                          ]),
                      if (quest.generatedFor(locale) &&
                          quest.instruction != null)
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 47, top: 8, right: 8),
                            child: Text(quest.instruction!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall)),
                    ]))));
  }

  void _accept(BuildContext context, DirectedQuest suggestion, String locale) {
    final director = context.read<QuestDirectorState>();
    final character = context.read<CharacterState>();
    if (!director.suggestions.any((q) => q.id == suggestion.id) ||
        !suggestion.id.startsWith('director:${localDay(DateTime.now())}:')) {
      return;
    }
    final quest = Quest(
        id: suggestion.id,
        name: suggestion.title(locale),
        xp: suggestion.xp,
        type: QuestType.daily,
        category: suggestion.template.stat,
        difficulty: suggestion.difficulty,
        scheduledDay: localDay(DateTime.now()),
        directorTemplateId: suggestion.template.id,
        estimatedMinutes: suggestion.minutes,
        instruction:
            suggestion.generatedFor(locale) ? suggestion.instruction : null,
        directorReason:
            suggestion.generatedFor(locale) ? suggestion.reason : null,
        generatedLocale: suggestion.generatedFor(locale) ? locale : null);
    if (character.acceptDailySuggestion(quest)) {
      director.accept(suggestion);
      HapticFeedback.selectionClick();
    }
  }

  Widget _acceptedCard(BuildContext context, Quest quest) {
    final s = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Card(
        color: quest.isCompleted ? colors.primary.withValues(alpha: .06) : null,
        child: ListTile(
          contentPadding: const EdgeInsets.fromLTRB(8, 7, 14, 7),
          leading: IconButton(
              tooltip: quest.isCompleted ? s.lqCompleted : s.lqDone,
              onPressed:
                  quest.isCompleted ? null : () => _showActive(context, quest),
              icon: Icon(
                  quest.isCompleted
                      ? PhosphorIcons.checkCircleFill
                      : PhosphorIcons.circle,
                  color: quest.isCompleted
                      ? colors.primary
                      : colors.onSurfaceVariant,
                  size: 25)),
          title: Text(quest.name,
              style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 14,
                  color: quest.isCompleted ? colors.onSurfaceVariant : null)),
          subtitle: Text(
              quest.isCompleted
                  ? s.lqCompleted
                  : '${quest.estimatedMinutes != null ? '${quest.estimatedMinutes} ${s.lqMinutes}  ·  ' : ''}+${quest.xp} XP',
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 11)),
          onTap: () => _showActive(context, quest),
          trailing: quest.isCompleted
              ? null
              : const Icon(PhosphorIcons.caretRight, size: 16),
        ));
  }

  Future<void> _showSuggestion(
      BuildContext context, DirectedQuest quest, String locale) async {
    final s = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final director = context.read<QuestDirectorState>();
    await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (sheet) => ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.sizeOf(sheet).height * .8),
            child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 26),
                children: [
                  Text(quest.title(locale), style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    QuestTag('${quest.minutes} ${s.lqMinutes}',
                        icon: PhosphorIcons.timer),
                    QuestTag('+${quest.xp} XP',
                        color: theme.colorScheme.primary),
                    QuestTag(focusName(quest.template.focus, s))
                  ]),
                  if (quest.generatedFor(locale) && quest.instruction != null)
                    Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(quest.instruction!)),
                  const SizedBox(height: 22),
                  Text(s.lqWhy, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(
                      quest.generatedFor(locale)
                          ? quest.reason!
                          : (quest.recovery
                              ? s.lqRecoveryReason
                              : s.lqDefaultReason),
                      style: theme.textTheme.bodySmall),
                  const SizedBox(height: 24),
                  FilledButton(
                      onPressed: () {
                        _accept(context, quest, locale);
                        Navigator.pop(sheet);
                      },
                      child: Text(s.lqAccept)),
                  const SizedBox(height: 8),
                  Wrap(alignment: WrapAlignment.center, spacing: 8, children: [
                    TextButton(
                        onPressed: () {
                          director.skip(quest, QuestFeedback.tooHard, locale);
                          Navigator.pop(sheet);
                        },
                        child: Text(s.lqTooHard)),
                    TextButton(
                        onPressed: () {
                          director.skip(quest, QuestFeedback.skipped, locale);
                          Navigator.pop(sheet);
                        },
                        child: Text(s.lqSkip)),
                  ]),
                  if (quest.generatedFor(locale))
                    AiReportButton(
                      content: AiReportContent(
                          title: quest.generatedTitle!,
                          instruction: quest.instruction!,
                          reason: quest.reason!,
                          locale: locale),
                      onReported: () =>
                          director.skip(quest, QuestFeedback.reported, locale),
                    ),
                ])));
  }

  Future<void> _showActive(BuildContext context, Quest quest) async {
    final s = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final character = context.read<CharacterState>();
    final director = context.read<QuestDirectorState>();
    await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (sheet) => ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.sizeOf(sheet).height * .8),
            child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 26),
                children: [
                  Text(quest.name, style: theme.textTheme.titleLarge),
                  if (quest.instruction != null)
                    Padding(
                        padding: const EdgeInsets.only(top: 18),
                        child: Text(quest.instruction!)),
                  const SizedBox(height: 22),
                  QuestTag('+${quest.xp} XP', color: theme.colorScheme.primary),
                  const SizedBox(height: 22),
                  FilledButton.icon(
                      icon: const Icon(PhosphorIcons.check),
                      label: Text(s.lqDone),
                      onPressed: quest.isCompleted
                          ? null
                          : () {
                              final result = character.completeQuest(quest);
                              Navigator.pop(sheet);
                              if (result != null) {
                                HapticFeedback.lightImpact();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        '${s.lqCompleted} · +${result.totalXpAwarded.round()} XP')));
                              }
                            }),
                  if (quest.directorTemplateId != null && !quest.isCompleted)
                    TextButton(
                        onPressed: () {
                          director.record(quest, QuestFeedback.tooHard);
                          character.deleteQuest(quest);
                          Navigator.pop(sheet);
                        },
                        child: Text(s.lqTooHard)),
                  if (quest.generatedLocale != null &&
                      quest.instruction != null &&
                      quest.directorReason != null)
                    AiReportButton(
                      content: AiReportContent(
                          title: quest.name,
                          instruction: quest.instruction!,
                          reason: quest.directorReason!,
                          locale: quest.generatedLocale!),
                      onReported: () async {
                        await director.record(quest, QuestFeedback.reported);
                        character.deleteQuest(quest);
                      },
                    ),
                ])));
  }

}
