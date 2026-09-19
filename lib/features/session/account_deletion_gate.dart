import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../state/character_state.dart';
import 'account_deletion_journal.dart';

/// Checks the durable guard before a legacy cloud profile is ever mounted.
/// A lost network response is distinct from a server-confirmed deletion.
class AccountDeletionGate extends StatefulWidget {
  final String uid;
  final Widget child;
  final Future<void> Function() signOut;
  const AccountDeletionGate({
    super.key,
    required this.uid,
    required this.child,
    required this.signOut,
  });
  @override
  State<AccountDeletionGate> createState() => _AccountDeletionGateState();
}

class _AccountDeletionGateState extends State<AccountDeletionGate> {
  late Future<AccountDeletionPhase?> _phase;
  bool _working = false;
  bool _cleanupFailed = false;
  bool _finished = false;
  @override
  void initState() {
    super.initState();
    _phase = AccountDeletionJournal.read(widget.uid);
  }

  Future<void> _finish() async {
    if (_working) return;
    final character = context.read<CharacterState>();
    setState(() {
      _working = true;
      _cleanupFailed = false;
    });
    try {
      await AccountDeletionJournal.finishLocalCleanup(
        widget.uid,
        signOut: widget.signOut,
      );
      character.forgetFinishedDeletion(widget.uid);
      if (!mounted) return;
      // Auth emits asynchronously. Never briefly mount the old profile while
      // waiting for SessionGate to observe the signed-out identity.
      setState(() => _finished = true);
    } catch (_) {
      if (mounted) setState(() => _cleanupFailed = true);
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final character = context.watch<CharacterState>();
    final pendingHere = character.pendingDeletionUid == widget.uid;
    final l = AppLocalizations.of(context)!;
    return FutureBuilder<AccountDeletionPhase?>(
      future: _phase,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasError &&
            snapshot.data == null &&
            !pendingHere &&
            !_finished) {
          return widget.child;
        }
        final accepted =
            snapshot.data == AccountDeletionPhase.accepted ||
            (pendingHere && character.accountDeletionAccepted);
        return Scaffold(
          appBar: AppBar(title: Text(l.settingsWithdrawTitle)),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock_outline, size: 40),
                    const SizedBox(height: 20),
                    Text(
                      snapshot.hasError
                          ? l.lqDeletionCheckFailed
                          : accepted
                          ? l.lqDeletionQueued
                          : l.lqDeletionUncertain,
                    ),
                    const SizedBox(height: 16),
                    if (_finished)
                      Text(l.lqDeletionLocalFinished)
                    else if (snapshot.hasError)
                      FilledButton(
                        onPressed: () => setState(() {
                          _phase = AccountDeletionJournal.read(widget.uid);
                        }),
                        child: Text(l.lqRetry),
                      )
                    else ...[
                      Text(l.lqDeletionLocalHint),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: _working ? null : _finish,
                        child: Text(l.lqDeletionFinishLocal),
                      ),
                    ],
                    if (_working) const LinearProgressIndicator(),
                    if (_cleanupFailed)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(l.lqDeletionLocalRetry),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
