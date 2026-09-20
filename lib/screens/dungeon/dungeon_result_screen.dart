import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/dungeon_state.dart';
import '../../state/character_state.dart';
import '../../l10n/app_localizations.dart';

class DungeonResultScreen extends StatefulWidget {
  final bool isVictory;
  const DungeonResultScreen({super.key, required this.isVictory});
  @override
  State<DungeonResultScreen> createState() => _DungeonResultScreenState();
}

class _DungeonResultScreenState extends State<DungeonResultScreen> {
  Map<String, dynamic>? _rewards;
  bool _busy = true, _saved = false, _failed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_rewards != null) return;
    _rewards = context.read<DungeonState>().calculateRunRewards();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _settle();
    });
  }

  Future<void> _settle() async {
    setState(() {
      _busy = true;
      _failed = false;
    });
    final dungeon = context.read<DungeonState>();
    final character = context.read<CharacterState>();
    try {
      if (!await dungeon.flushCheckpoint()) throw StateError('Save failed');
      await character.settleDungeonRun(dungeon);
      if (mounted) setState(() => _saved = true);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _returnHome() async {
    setState(() {
      _busy = true;
      _failed = false;
    });
    final dungeon = context.read<DungeonState>();
    dungeon.resetRun();
    final saved = await dungeon.flushCheckpoint();
    if (!mounted) return;
    if (saved) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _busy = false;
        _failed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final rewards = _rewards ?? {};
    final victory = rewards['isVictory'] == true;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const SizedBox(height: 24),
                  Icon(
                    victory
                        ? Icons.emoji_events_outlined
                        : Icons.explore_outlined,
                    size: 56,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    victory
                        ? l.dungeonResultVictoryTitle
                        : l.dungeonResultDefeatTitle,
                    style: theme.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    victory
                        ? l.dungeonResultVictoryMessage
                        : l.dungeonResultDefeatMessage,
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l.dungeonResultStatsTitle,
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          _Stat(
                            label: l.dungeonResultStatsZone,
                            value: '${rewards['zone'] ?? 1}',
                          ),
                          _Stat(
                            label: l.dungeonResultStatsNodesCompleted,
                            value: '${rewards['nodesCompleted'] ?? 0}',
                          ),
                          _Stat(
                            label: l.dungeonResultStatsMonsterKilled,
                            value: '${rewards['monstersKilled'] ?? 0}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l.dungeonResultRewardsTitle,
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l.dungeonResultXpReward(rewards['xp'] as int? ?? 0),
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l.dungeonResultGoldReward(
                              rewards['gold'] as int? ?? 0,
                            ),
                            style: theme.textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_busy) const Center(child: CircularProgressIndicator()),
                  if (_failed)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        l.lqDungeonSaveFailed,
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _busy ? null : (_saved ? _returnHome : _settle),
                    child: Text(
                      _saved ? l.dungeonResultReturnHomeButton : l.lqRetry,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  const _Stat({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(label)),
        const SizedBox(width: 12),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    ),
  );
}
