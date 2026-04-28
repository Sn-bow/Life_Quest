import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/screens/report_screen.dart';
import 'package:life_quest_final_v2/screens/settings_screen.dart';
import 'package:life_quest_final_v2/screens/timer_screen.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/state/combat_state.dart';
import 'package:life_quest_final_v2/widgets/translucent_card.dart';
import 'package:life_quest_final_v2/widgets/xp_bar.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  // Pending stat allocation (not yet committed)
  Map<StatType, int> _pendingAlloc = {
    StatType.strength: 0,
    StatType.wisdom: 0,
    StatType.health: 0,
    StatType.charisma: 0,
  };

  int get _totalPending => _pendingAlloc.values.fold(0, (sum, v) => sum + v);

  bool get _hasPending => _totalPending > 0;

  void _increment(StatType stat, int availableSP) {
    if (_totalPending < availableSP) {
      setState(() {
        _pendingAlloc[stat] = (_pendingAlloc[stat] ?? 0) + 1;
      });
    }
  }

  void _decrement(StatType stat) {
    if ((_pendingAlloc[stat] ?? 0) > 0) {
      setState(() {
        _pendingAlloc[stat] = (_pendingAlloc[stat] ?? 0) - 1;
      });
    }
  }

  void _applyAllocation(CharacterState characterState) {
    _pendingAlloc.forEach((stat, count) {
      for (int i = 0; i < count; i++) {
        characterState.spendStatPoint(stat);
      }
    });
    setState(() {
      _pendingAlloc = {
        StatType.strength: 0,
        StatType.wisdom: 0,
        StatType.health: 0,
        StatType.charisma: 0,
      };
    });
  }

  void _cancelAllocation() {
    setState(() {
      _pendingAlloc = {
        StatType.strength: 0,
        StatType.wisdom: 0,
        StatType.health: 0,
        StatType.charisma: 0,
      };
    });
  }

  void _showTitleSelectionDialog(
      BuildContext context, CharacterState characterState) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.statusTitleChangeTitle),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: characterState.unlockedTitles.length,
              itemBuilder: (BuildContext context, int index) {
                final title = characterState.unlockedTitles[index];
                return ListTile(
                  title: Text(title.name),
                  subtitle: Text(title.description),
                  onTap: () {
                    characterState.changeTitle(title);
                    Navigator.of(dialogContext).pop();
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.close),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CharacterState>(
      builder: (context, characterState, child) {
        if (characterState.isLoading || !characterState.isDataLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final character = characterState.character;
        final theme = Theme.of(context);
        final l10n = AppLocalizations.of(context)!;
        final int availableSP = character.statPoints;
        final int remainingSP = availableSP - _totalPending;
        final bool canUpgrade = remainingSP > 0;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.statusScreenTitle),
            actions: [
              IconButton(
                icon: const Icon(PhosphorIcons.timer),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TimerScreen()),
                  );
                },
                tooltip: l10n.statusTimerTooltip,
              ),
              IconButton(
                icon: const Icon(PhosphorIcons.gear),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()),
                  );
                },
                tooltip: l10n.statusSettingsTooltip,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TranslucentCard(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                        backgroundImage: character.photoUrl != null
                            ? NetworkImage(character.photoUrl!)
                            : null,
                        child: character.photoUrl == null
                            ? Icon(
                                PhosphorIcons.userCircle,
                                size: 48,
                                color: theme.colorScheme.primary,
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              character.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Builder(
                              builder: (context) {
                                TextStyle titleStyle =
                                    theme.textTheme.titleMedium ??
                                        const TextStyle();
                                if (character.equippedTitleEffect ==
                                    'title_effect_fire') {
                                  titleStyle = titleStyle.copyWith(
                                    color: Colors.deepOrange,
                                    shadows: [
                                      const Shadow(
                                          color: Colors.redAccent,
                                          blurRadius: 8)
                                    ],
                                  );
                                } else if (character.equippedTitleEffect ==
                                    'title_effect_sparkle') {
                                  titleStyle = titleStyle.copyWith(
                                    color: Colors.yellowAccent,
                                    shadows: [
                                      const Shadow(
                                          color: Colors.amber, blurRadius: 8)
                                    ],
                                  );
                                }

                                return InkWell(
                                  onTap: () => _showTitleSelectionDialog(
                                      context, characterState),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Lv. ${character.level} | ${character.title}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: titleStyle,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(PhosphorIcons.caretDown,
                                          size: 16, color: Colors.grey),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(PhosphorIcons.chartBar,
                            color: theme.colorScheme.primary),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ReportScreen()),
                          );
                        },
                        tooltip: l10n.statusReportTooltip,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TranslucentCard(
                  child: XpBar(
                    currentXp: character.xp,
                    maxXp: character.maxXp,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                // HP Bar & Streak
                TranslucentCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.favorite,
                              color: Colors.red.shade400, size: 18),
                          const SizedBox(width: 8),
                          Text('HP',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade400)),
                          const Spacer(),
                          Text(
                            '${character.characterHp} / ${character.characterMaxHp}',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.red.shade400,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value:
                              character.characterHp / character.characterMaxHp,
                          minHeight: 8,
                          backgroundColor: theme.brightness == Brightness.dark
                              ? Colors.grey.shade800
                              : Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            character.characterHp >
                                    character.characterMaxHp * 0.3
                                ? Colors.red.shade400
                                : Colors.red.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.statusHpRecoveryHint,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.brightness == Brightness.dark
                              ? Colors.white60
                              : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            character.streak > 0
                                ? Icons.local_fire_department
                                : Icons.ac_unit,
                            color: character.streak > 0
                                ? Colors.orange.shade400
                                : Colors.blue.shade200,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.statusStreakLabel(character.streak),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: character.streak > 0
                                  ? Colors.orange.shade400
                                  : (theme.brightness == Brightness.dark
                                      ? Colors.white38
                                      : Colors.grey),
                            ),
                          ),
                          if (character.streak > 0) ...[
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade400
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                l10n.statusStreakBonus((character.streak * 10).clamp(0, 50)),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade400,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                TranslucentCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        PhosphorIcons.sparkle,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.statusStatHint,
                          style: TextStyle(
                            height: 1.45,
                            color: theme.brightness == Brightness.dark
                                ? Colors.white70
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Gold & AP resource card
                TranslucentCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.monetization_on,
                                color: Colors.amber.shade400, size: 20),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l10n.statusGoldLabel,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            theme.brightness == Brightness.dark
                                                ? Colors.white54
                                                : Colors.black45)),
                                Text(
                                  '${character.gold}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 36,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white12
                            : Colors.grey.shade300,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bolt,
                                color: theme.colorScheme.primary, size: 20),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l10n.statusApLabel,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            theme.brightness == Brightness.dark
                                                ? Colors.white54
                                                : Colors.black45)),
                                Text(
                                  '${character.actionPoints} / ${character.maxActionPoints}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                TranslucentCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.statusBaseStatTitle, style: theme.textTheme.titleLarge),
                          if (availableSP > 0)
                            Row(
                              children: [
                                Text(
                                  'SP: $remainingSP / $availableSP',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                if (_hasPending) ...[
                                  const SizedBox(width: 4),
                                  Text(
                                    '(-$_totalPending)',
                                    style: TextStyle(
                                      color: Colors.orange.shade400,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Keep detailed stats free. Ads should focus on optional
                      // acceleration rather than basic information access.
                      Center(
                        child: TextButton.icon(
                          icon: Icon(Icons.analytics,
                              color: theme.colorScheme.primary),
                          label: Text(l10n.statusDetailStatButton,
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                              )),
                          onPressed: () async {
                            if (context.mounted) {
                              final char = character;
                              final attack =
                                  CombatState.effectiveAttack(char).round();
                              final defense =
                                  CombatState.effectiveDefense(char).round();
                              final crit =
                                  (CombatState.critChance(char) * 100)
                                      .toStringAsFixed(1);
                              final dodge =
                                  (CombatState.dodgeChance(char) * 100)
                                      .toStringAsFixed(1);

                              showDialog(
                                context: context,
                                builder: (ctx) {
                                  final dialogL10n = AppLocalizations.of(ctx)!;
                                  return AlertDialog(
                                    title: Text(dialogL10n.statusDetailStatTitle),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: const Icon(
                                              Icons.sports_martial_arts,
                                              color: Colors.red),
                                          title: Text(dialogL10n.statusAttackLabel),
                                          trailing: Text('$attack',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.shield,
                                              color: Colors.blue),
                                          title: Text(dialogL10n.statusDefenseLabel),
                                          trailing: Text('$defense',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.flash_on,
                                              color: Colors.orange),
                                          title: Text(dialogL10n.statusCritLabel),
                                          trailing: Text('$crit%',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                        ListTile(
                                          leading: const Icon(
                                              Icons.directions_run,
                                              color: Colors.green),
                                          title: Text(dialogL10n.statusDodgeLabel),
                                          trailing: Text('$dodge%',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: Text(dialogL10n.close),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      // ------------------------------------
                      _buildStatRow(
                        stat: StatType.strength,
                        label: l10n.statusStatStrength,
                        baseValue: character.strength,
                        icon: Icon(PhosphorIcons.barbell,
                            color: Colors.red.shade400),
                        color: Colors.red.shade400,
                        canUpgrade: canUpgrade,
                        availableSP: availableSP,
                        theme: theme,
                      ),
                      const SizedBox(height: 12),
                      _buildStatRow(
                        stat: StatType.wisdom,
                        label: l10n.statusStatWisdom,
                        baseValue: character.wisdom,
                        icon: Icon(PhosphorIcons.brain,
                            color: Colors.blue.shade400),
                        color: Colors.blue.shade400,
                        canUpgrade: canUpgrade,
                        availableSP: availableSP,
                        theme: theme,
                      ),
                      const SizedBox(height: 12),
                      _buildStatRow(
                        stat: StatType.health,
                        label: l10n.statusStatHealth,
                        baseValue: character.health,
                        icon: Icon(PhosphorIcons.heart,
                            color: Colors.green.shade400),
                        color: Colors.green.shade400,
                        canUpgrade: canUpgrade,
                        availableSP: availableSP,
                        theme: theme,
                      ),
                      const SizedBox(height: 12),
                      _buildStatRow(
                        stat: StatType.charisma,
                        label: l10n.statusStatCharm,
                        baseValue: character.charisma,
                        icon: Icon(PhosphorIcons.sparkle,
                            color: Colors.purple.shade400),
                        color: Colors.purple.shade400,
                        canUpgrade: canUpgrade,
                        availableSP: availableSP,
                        theme: theme,
                      ),
                      // Apply / Cancel buttons
                      if (_hasPending) ...[
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _cancelAllocation,
                                icon: const Icon(PhosphorIcons.x, size: 18),
                                label: Text(l10n.cancel),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.redAccent,
                                  side:
                                      const BorderSide(color: Colors.redAccent),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    _showApplyConfirmDialog(characterState),
                                icon: const Icon(PhosphorIcons.check, size: 18),
                                label: Text(l10n.apply),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor:
                                      theme.brightness == Brightness.dark
                                          ? Colors.black
                                          : Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatRow({
    required StatType stat,
    required String label,
    required double baseValue,
    required Icon icon,
    required Color color,
    required bool canUpgrade,
    required int availableSP,
    required ThemeData theme,
  }) {
    final pending = _pendingAlloc[stat] ?? 0;
    final displayValue = baseValue + pending;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            icon,
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            Text(
              displayValue.toStringAsFixed(0),
              style: const TextStyle(fontSize: 16),
            ),
            if (pending > 0)
              Text(
                ' (+$pending)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade400,
                ),
              ),
            const SizedBox(width: 8),
            // Minus button
            SizedBox(
              width: 48,
              height: 48,
              child: pending > 0
                  ? IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                      iconSize: 24,
                      icon: const Icon(PhosphorIcons.minusCircle,
                          color: Colors.redAccent),
                      onPressed: () => _decrement(stat),
                    )
                  : null,
            ),
            // Plus button
            SizedBox(
              width: 48,
              height: 48,
              child: canUpgrade
                  ? IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                      iconSize: 24,
                      icon: Icon(PhosphorIcons.plusCircle,
                          color: theme.colorScheme.primary),
                      onPressed: () => _increment(stat, availableSP),
                    )
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            // M-4 fix: 스탯이 100 초과 시 오버플로우 방지
            value: (displayValue / 100.0).clamp(0.0, 1.0),
            minHeight: 10,
            backgroundColor:
                isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  void _showApplyConfirmDialog(CharacterState characterState) {
    final l10n = AppLocalizations.of(context)!;
    final allocSummary =
        _pendingAlloc.entries.where((e) => e.value > 0).map((e) {
      String name;
      switch (e.key) {
        case StatType.strength:
          name = l10n.statusStatStrength;
          break;
        case StatType.wisdom:
          name = l10n.statusStatWisdom;
          break;
        case StatType.health:
          name = l10n.statusStatHealth;
          break;
        case StatType.charisma:
          name = l10n.statusStatCharm;
          break;
      }
      return '$name +${e.value}';
    }).join(', ');

    showDialog(
      context: context,
      builder: (ctx) {
        final dialogL10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          title: Text(dialogL10n.statusStatApplyTitle),
          content: Text(dialogL10n.statusStatApplyBody(allocSummary)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(dialogL10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                _applyAllocation(characterState);
                Navigator.of(ctx).pop();
              },
              child: Text(dialogL10n.apply),
            ),
          ],
        );
      },
    );
  }
}

