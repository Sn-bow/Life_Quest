import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/quest.dart';
import '../../screens/settings_screen.dart';
import '../../screens/status_screen.dart';
import '../../state/character_state.dart';
import '../director/quest_director_state.dart';
import 'system_copy.dart';
import 'system_journal.dart';
import 'hunter_system_frame.dart';

const systemJade = Color(0xFF9EDCD0);
String xpText(num value) => value == value.roundToDouble()
    ? value.toInt().toString()
    : value.toStringAsFixed(1);
List<String> statLabels(BuildContext c) {
  final l = AppLocalizations.of(c)!;
  return [
    l.statusStatStrength,
    l.statusStatWisdom,
    l.statusStatHealth,
    l.statusStatCharm,
  ];
}

class SystemEntrance extends StatelessWidget {
  final Widget child;
  const SystemEntrance({super.key, required this.child});
  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(
      begin: MediaQuery.disableAnimationsOf(context) ? 1 : 0,
      end: 1,
    ),
    duration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 360),
    curve: Curves.easeOutCubic,
    builder: (c, v, child) => Opacity(
      opacity: v,
      child: Transform.scale(
        scale: .96 + .04 * v,
        alignment: Alignment.topCenter,
        child: child,
      ),
    ),
    child: child,
  );
}

class SystemStatusHeader extends StatelessWidget {
  final CharacterState state;
  const SystemStatusHeader({super.key, required this.state});
  @override
  Widget build(BuildContext context) {
    final copy = SystemCopy(context), l = AppLocalizations.of(context)!;
    final theme = Theme.of(context), c = state.character;
    final colors = theme.colorScheme;
    final progress = (c.xp / c.maxXp).clamp(0.0, 1.0);
    final stats = [c.strength, c.wisdom, c.health, c.charisma];
    final labels = statLabels(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Positioned.fill(
              child: ExcludeSemantics(
                child: Image.asset(
                  'assets/images/ui/status_threshold_v1.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.centerRight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 14, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        PhosphorIcons.compass,
                        color: Color(0xFFDABC83),
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'LIFE QUEST',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: l.statusSettingsTooltip,
                        icon: const Icon(
                          PhosphorIcons.gear,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const SettingsScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    copy.get('status'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'NotoSerifKR',
                      fontSize: 38,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    copy.get('subtitle'),
                    style: const TextStyle(
                      color: Color(0xFFE2E6E5),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 18,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Lv.${c.level.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontFamily: 'NotoSerifKR',
                      fontSize: 40,
                      height: 1.1,
                      color: colors.primary,
                      fontWeight: FontWeight.w500,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  Text(
                    c.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontFamily: 'NotoSerifKR',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 16,
                runSpacing: 6,
                children: [
                  Text(
                    '${xpText(c.xp)} / ${xpText(c.maxXp)} XP',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    '${copy.get('next')} ${xpText(c.maxXp - c.xp)} XP',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: progress, end: progress),
                duration: MediaQuery.disableAnimationsOf(context)
                    ? Duration.zero
                    : const Duration(milliseconds: 650),
                builder: (c, v, _) => Semantics(
                  container: true,
                  child: LinearProgressIndicator(
                    value: v,
                    minHeight: 5,
                    semanticsLabel: 'XP',
                    semanticsValue: '${(v * 100).round()}%',
                  ),
                ),
              ),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (context, box) {
                  final columns =
                      MediaQuery.textScalerOf(context).scale(14) > 21 ||
                          box.maxWidth < 300
                      ? 2
                      : 4;
                  return Wrap(
                    runSpacing: 18,
                    children: List.generate(
                      4,
                      (i) => SizedBox(
                        width: box.maxWidth / columns,
                        child: Column(
                          children: [
                            Text(labels[i], style: theme.textTheme.bodyMedium),
                            const SizedBox(height: 6),
                            Text(
                              xpText(stats[i]),
                              style: theme.textTheme.headlineMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    '${copy.get('today')}  +${xpText(state.recordedXpToday)} XP',
                    style: theme.textTheme.bodySmall,
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const StatusScreen(),
                      ),
                    ),
                    child: Text(copy.get('details')),
                  ),
                ],
              ),
              const Divider(),
            ],
          ),
        ),
      ],
    );
  }
}

class SystemOfferCard extends StatefulWidget {
  final bool compact;
  const SystemOfferCard({super.key, this.compact = false});
  @override
  State<SystemOfferCard> createState() => _SystemOfferCardState();
}

class _SystemOfferCardState extends State<SystemOfferCard> {
  String? _checked;
  bool _busy = false;
  String? _error;
  Future<void> Function()? _retry;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.watch<CharacterState>(),
        director = context.watch<QuestDirectorState>();
    final key =
        '${systemDay(DateTime.now())}:${state.questCompletionCount}:${director.ready}:${director.profile.minutes}:${state.systemJournal.enabled}';
    if (_checked == key || !director.ready) return;
    _checked = key;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final used = state.dailyQuests
          .where((q) => q.scheduledDay == systemDay(DateTime.now()))
          .fold<int>(0, (n, q) => n + (q.estimatedMinutes ?? 0));
      Future<void> propose() => state.maybeOfferSystemQuest(
        availableMinutes: director.profile.minutes - used,
        category: state.lastGrowthReceipt?.category ?? 1,
      );
      try {
        await propose();
      } catch (_) {
        if (mounted) {
          setState(() {
            _error = SystemCopy(context).get('error');
            _retry = propose;
          });
        }
      }
    });
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
      _retry = null;
    });
    try {
      await action();
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = SystemCopy(context).get('error');
          _retry = action;
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CharacterState>(),
        copy = SystemCopy(context),
        theme = Theme.of(context);
    final offer = state.systemJournal.current;
    final color = theme.brightness == Brightness.dark
        ? systemJade
        : const Color(0xFF23685D);
    final latest = state.systemJournal.offers.lastOrNull;
    if (widget.compact) {
      // Keep the offer-generation hook mounted without occupying the first
      // screen with a "waiting" link before there is an actual event.
      if (offer == null && _error == null) {
        return const SizedBox.shrink();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton.icon(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              builder: (_) => const SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 28),
                child: SystemOfferCard(),
              ),
            ),
            icon: Icon(
              PhosphorIcons.lightning,
              size: 17,
              color: offer == null
                  ? const Color(0xFF93B5C7)
                  : const Color(0xFF7FDEFF),
            ),
            label: Text(
              copy.get(
                offer == null
                    ? 'waiting'
                    : offer.status == SystemOfferStatus.accepted
                    ? 'accepted'
                    : 'arrival',
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFB9D7E6),
            ),
          ),
          if (_error != null) ...[
            Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
            TextButton(
              onPressed: _busy || _retry == null ? null : () => _run(_retry!),
              child: Text(copy.get('retry')),
            ),
          ],
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (offer != null)
          SystemEntrance(
            key: ValueKey(offer.id),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border.all(color: color.withValues(alpha: .65)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(PhosphorIcons.lightning, color: color, size: 21),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          copy.get(
                            offer.status == SystemOfferStatus.accepted
                                ? 'accepted'
                                : 'offer',
                          ),
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    copy.get(offer.template),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontFamily: 'NotoSerifKR',
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    copy.get('${offer.template}Task'),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 18),
                  const Divider(),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 20,
                    runSpacing: 8,
                    children: [
                      Text(
                        '${offer.minutes} ${AppLocalizations.of(context)!.lqMinutes}',
                      ),
                      Text(
                        '+${offer.reward} XP',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${copy.get(offer.status == SystemOfferStatus.accepted ? 'finishUntil' : 'offerUntil')} · ${DateFormat('MM/dd HH:mm').format((offer.deadline ?? offer.offerDeadline).toLocal())}',
                    style: theme.textTheme.bodySmall,
                  ),
                  if (offer.status == SystemOfferStatus.offered)
                    Text(
                      copy.get('duration'),
                      style: theme.textTheme.bodySmall,
                    ),
                  const SizedBox(height: 18),
                  LayoutBuilder(
                    builder: (c, box) {
                      final buttons = [
                        FilledButton(
                          key: const ValueKey('system-primary'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(0, 48),
                          ),
                          onPressed: _busy
                              ? null
                              : () => _run(() async {
                                  if (offer.status ==
                                      SystemOfferStatus.offered) {
                                    await state.changeSystemOffer(
                                      offer,
                                      SystemOfferStatus.accepted,
                                    );
                                    if (context.mounted &&
                                        !MediaQuery.disableAnimationsOf(
                                          context,
                                        )) {
                                      HapticFeedback.selectionClick();
                                    }
                                  } else {
                                    final receipt = await state
                                        .completeSystemOffer(
                                          offer,
                                          copy.get('${offer.template}Task'),
                                        );
                                    if (context.mounted) {
                                      unawaited(
                                        showSystemReward(context, receipt),
                                      );
                                    }
                                  }
                                }),
                          child: Text(
                            copy.get(
                              offer.status == SystemOfferStatus.offered
                                  ? 'accept'
                                  : 'done',
                            ),
                          ),
                        ),
                        OutlinedButton(
                          key: const ValueKey('system-decline'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: color,
                            side: BorderSide(color: color),
                            minimumSize: const Size(0, 48),
                          ),
                          onPressed: _busy
                              ? null
                              : () => _run(
                                  () => state.changeSystemOffer(
                                    offer,
                                    offer.status == SystemOfferStatus.offered
                                        ? SystemOfferStatus.declined
                                        : SystemOfferStatus.abandoned,
                                  ),
                                ),
                          child: Text(
                            copy.get(
                              offer.status == SystemOfferStatus.offered
                                  ? 'decline'
                                  : 'abandon',
                            ),
                          ),
                        ),
                      ];
                      if (MediaQuery.textScalerOf(c).scale(14) > 20 ||
                          box.maxWidth < 300) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            buttons[0],
                            const SizedBox(height: 10),
                            buttons[1],
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(child: buttons[0]),
                          const SizedBox(width: 12),
                          Expanded(child: buttons[1]),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(copy.get('noPenalty'), style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(copy.get('waiting'), style: theme.textTheme.titleMedium),
                const SizedBox(height: 5),
                Text(
                  copy.get(
                    latest?.status == SystemOfferStatus.expired
                        ? 'expired'
                        : 'waitingBody',
                  ),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          dense: true,
          title: Text(copy.get('enabled'), style: theme.textTheme.bodySmall),
          value: state.systemJournal.enabled,
          onChanged: _busy
              ? null
              : (v) => _run(() => state.setSystemOffersEnabled(v)),
        ),
        if (_busy) const LinearProgressIndicator(),
        if (_error != null)
          Semantics(
            liveRegion: true,
            child: Column(
              children: [
                Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
                if (_retry != null)
                  TextButton(
                    onPressed: () => _run(_retry!),
                    child: Text(copy.get('retry')),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

Future<void> completeAndPresentQuest(
  BuildContext context,
  Quest quest,
  CharacterState state, {
  double multiplier = 1,
}) async {
  try {
    final receipt = await state.completeQuestDurably(
      quest,
      xpMultiplier: multiplier,
    );
    if (context.mounted) await showSystemReward(context, receipt);
  } catch (_) {
    if (!context.mounted) return;
    final copy = SystemCopy(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(copy.get('error')),
        action: SnackBarAction(
          label: copy.get('retry'),
          onPressed: () => unawaited(
            completeAndPresentQuest(
              context,
              quest,
              state,
              multiplier: multiplier,
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showSystemReward(
  BuildContext context,
  GrowthReceipt receipt,
) async {
  final reduce = MediaQuery.disableAnimationsOf(context);
  if (!reduce) HapticFeedback.lightImpact();
  await showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: SystemCopy(context).get('close'),
    barrierColor: Colors.black87,
    transitionDuration: reduce
        ? Duration.zero
        : const Duration(milliseconds: 320),
    transitionBuilder: (c, a, _, child) => FadeTransition(
      opacity: a,
      child: ScaleTransition(
        scale: Tween(
          begin: .96,
          end: 1.0,
        ).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
        child: child,
      ),
    ),
    pageBuilder: (c, _, _) => SystemRewardScene(receipt: receipt),
  );
}

class SystemRewardScene extends StatelessWidget {
  final GrowthReceipt receipt;
  const SystemRewardScene({super.key, required this.receipt});
  @override
  Widget build(BuildContext context) {
    final copy = SystemCopy(context),
        theme = HunterSystemFrame.themeFor(context),
        r = receipt;
    final levelUp = r.levelAfter > r.levelBefore;
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 460,
            maxHeight: MediaQuery.sizeOf(context).height * .92,
          ),
          child: HunterSystemFrame(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(26, 26, 26, 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'SYSTEM / ${levelUp ? 'LEVEL UP' : 'COMPLETE'}',
                                style: TextStyle(
                                  fontSize: 12,
                                  letterSpacing: 2,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              tooltip: copy.get('close'),
                              icon: const Icon(PhosphorIcons.x),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Icon(
                          levelUp
                              ? PhosphorIcons.sparkle
                              : PhosphorIcons.checkCircle,
                          size: 52,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          copy.get(levelUp ? 'levelUp' : 'success'),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontFamily: 'NotoSansKR',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(r.title, textAlign: TextAlign.center),
                        const SizedBox(height: 28),
                        Text(
                          '+${xpText(r.xp)} XP',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        if (r.bonusXp > 0) ...[
                          const SizedBox(height: 12),
                          Text(
                            '${copy.get('questReward')} +${xpText(r.questXp)} XP\n${copy.get('achievementReward')} +${xpText(r.bonusXp)} XP',
                            textAlign: TextAlign.center,
                          ),
                        ],
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 20),
                        Text(
                          'Lv.${r.levelBefore}  →  Lv.${r.levelAfter}',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: (r.xpAfter / r.maxXpAfter).clamp(0.0, 1.0),
                          minHeight: 6,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          levelUp
                              ? '${xpText(r.xpAfter)} / ${xpText(r.maxXpAfter)} XP'
                              : '${xpText(r.xpBefore)} → ${xpText(r.xpAfter)} / ${xpText(r.maxXpAfter)} XP',
                          key: const ValueKey('system-reward-xp-change'),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '${statLabels(context)[r.category]} · ${copy.get('contribution')}',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium,
                        ),
                        for (var i = 0; i < 4; i++)
                          if (r.statChanges[i] > 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                '${statLabels(context)[i]} +${xpText(r.statChanges[i])}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                        const SizedBox(height: 24),
                        Text(
                          copy.get('saved'),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(26, 8, 26, 34),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      key: const ValueKey('system-reward-return'),
                      onPressed: () => Navigator.pop(context),
                      child: Text(copy.get('return')),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SystemHistorySection extends StatelessWidget {
  const SystemHistorySection({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<CharacterState>(),
        copy = SystemCopy(context),
        theme = Theme.of(context);
    final receipts = state.systemJournal.receipts.reversed.toList();
    final yesterday = systemDay(
      DateTime.now().subtract(const Duration(days: 1)),
    );
    final previous = receipts.where((r) => r.day == yesterday).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(copy.get('journal'), style: theme.textTheme.headlineMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 22,
          runSpacing: 12,
          children: [
            Text('${copy.get('today')}  +${xpText(state.recordedXpToday)} XP'),
            Text(
              '${copy.get('yesterday')}  ${previous.isEmpty ? copy.get('noRecord') : '+${xpText(previous.fold<double>(0, (v, r) => v + r.xp))} XP'}',
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(copy.get('journalNote'), style: theme.textTheme.bodySmall),
        const SizedBox(height: 18),
        if (receipts.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(copy.get('emptyJournal')),
          ),
        for (final r in receipts.take(30))
          Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  r.source == 'system'
                      ? PhosphorIcons.lightning
                      : PhosphorIcons.checkCircle,
                  color: theme.colorScheme.primary,
                ),
                title: Text(r.title),
                subtitle: Text(
                  '${DateFormat('MM/dd HH:mm').format(r.at.toLocal())} · +${xpText(r.xp)} XP',
                ),
                trailing: const Icon(PhosphorIcons.caretRight, size: 18),
                onTap: () => showSystemReward(context, r),
              ),
              const Divider(),
            ],
          ),
      ],
    );
  }
}
