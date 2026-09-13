import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/app_localizations.dart';
import '../../state/character_state.dart';
import '../director/quest_director_state.dart';
import '../session/session_state.dart';
import 'backup_files.dart';
import 'device_backup.dart';
import 'device_backup_store.dart';

class BackupScreen extends StatefulWidget {
  final BackupFiles? files;
  final bool restoreOnly;
  const BackupScreen({super.key, this.files, this.restoreOnly = false});
  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  late final BackupFiles files = widget.files ?? NativeBackupFiles();
  bool busy = false;
  DeviceSnapshot? previous;
  @override
  void initState() {
    super.initState();
    _loadPrevious();
  }

  Future<void> _loadPrevious() async {
    try {
      final store = DeviceBackupStore.preferences(
        await SharedPreferences.getInstance(),
      );
      final value = store.previousSnapshot();
      if (mounted) setState(() => previous = value);
    } catch (_) {
      // Export/import remain available if the optional undo record cannot load.
    }
  }

  void _message(String text) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    }
  }

  Future<String?> _password({required bool creating}) => showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _PasswordDialog(creating: creating),
  );

  Future<void> _export() async {
    final l = AppLocalizations.of(context)!;
    final password = await _password(creating: true);
    if (password == null || !mounted) return;
    setState(() => busy = true);
    try {
      // Both snapshots are captured synchronously from the current device scope.
      final snapshot = DeviceSnapshot.create(
        profile: context.read<CharacterState>().exportDeviceProfile(),
        director: context.read<QuestDirectorState>().exportDeviceProfile(),
        createdAt: DateTime.now(),
      );
      final bytes = await DeviceBackupCodec().encrypt(snapshot, password);
      if (!mounted) return;
      final name =
          'lifequest-${DateFormat('yyyy-MM-dd-HHmmss').format(DateTime.now())}.lqbackup';
      final saved = await files.save(bytes, name);
      bytes.fillRange(0, bytes.length, 0);
      if (saved) _message(l.lqBackupSaved);
    } catch (_) {
      _message(l.lqBackupSaveFailed);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _import() async {
    final l = AppLocalizations.of(context)!;
    setState(() => busy = true);
    try {
      final bytes = await files.open();
      if (bytes == null || !mounted) return;
      final password = await _password(creating: false);
      if (password == null || !mounted) return;
      final snapshot = await DeviceBackupCodec().decrypt(bytes, password);
      bytes.fillRange(0, bytes.length, 0);
      if (!mounted) return;
      if (await _confirm(snapshot) != true || !mounted) return;
      await _restore(snapshot);
    } catch (_) {
      _message(l.lqBackupInvalid);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<bool?> _confirm(DeviceSnapshot snapshot, {bool undo = false}) {
    final l = AppLocalizations.of(context)!;
    final date = DateFormat.yMMMd(
      Localizations.localeOf(context).languageCode,
    ).add_Hm().format(snapshot.createdAt.toLocal());
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(undo ? l.lqBackupUndo : l.lqBackupReview),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${snapshot.name} · Lv. ${snapshot.level}',
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
              if (!undo) ...[const SizedBox(height: 8), Text(date)],
              const SizedBox(height: 20),
              Text(l.lqBackupReplaceBody),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.lqBackupRestore),
          ),
        ],
      ),
    );
  }

  Future<void> _restore(DeviceSnapshot snapshot) async {
    final l = AppLocalizations.of(context)!;
    final session = context.read<SessionState>();
    final character = context.read<CharacterState>();
    final director = context.read<QuestDirectorState>();
    var committed = false;
    try {
      await character.suspendLocalPersistence();
      await director.endSession();
      final prefs = await SharedPreferences.getInstance();
      await DeviceBackupStore.preferences(prefs).restore(snapshot);
      committed = true;
    } catch (_) {
      // Journal recovery is handled by the fresh root loader below.
    } finally {
      if (mounted) {
        setState(() => busy = false);
        final messenger = ScaffoldMessenger.of(context);
        Navigator.of(context).popUntil((route) => route.isFirst);
        // A fresh loader handles journal recovery, errors and retry. It also
        // disposes the old MainScreen before rebinding the director.
        session.reloadDevice();
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              committed ? l.lqBackupRestored : l.lqBackupRestoreInterrupted,
            ),
          ),
        );
      }
    }
  }

  Future<void> _undo() async {
    final snapshot = previous;
    if (snapshot == null) return;
    if (await _confirm(snapshot, undo: true) != true || !mounted) return;
    setState(() => busy = true);
    try {
      await _restore(snapshot);
    } catch (_) {
      /* The fresh profile loader explains storage recovery errors. */
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return PopScope(
      canPop: !busy,
      child: Scaffold(
        appBar: AppBar(title: Text(l.lqBackupTitle)),
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.lock_outline, size: 34),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l.lqBackupHeadline,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(l.lqBackupBody, style: const TextStyle(height: 1.7)),
                  const SizedBox(height: 28),
                  if (!widget.restoreOnly) ...[
                    FilledButton.icon(
                      onPressed: busy ? null : _export,
                      icon: const Icon(Icons.save_alt),
                      label: Text(l.lqBackupExport),
                    ),
                    const SizedBox(height: 12),
                  ],
                  OutlinedButton.icon(
                    onPressed: busy ? null : _import,
                    icon: const Icon(Icons.restore),
                    label: Text(l.lqBackupImport),
                  ),
                  if (previous != null) ...[
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: busy ? null : _undo,
                      child: Text(l.lqBackupUndo),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Text(
                    l.lqBackupIncluded,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.lqBackupIncludesBody,
                    style: const TextStyle(height: 1.7),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l.lqBackupPasswordNotice,
                    style: const TextStyle(height: 1.7),
                  ),
                  if (busy) ...[
                    const SizedBox(height: 24),
                    const LinearProgressIndicator(),
                    const SizedBox(height: 12),
                    Text(l.lqBackupWorking),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordDialog extends StatefulWidget {
  final bool creating;
  const _PasswordDialog({required this.creating});
  @override
  State<_PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<_PasswordDialog> {
  final password = TextEditingController();
  final repeat = TextEditingController();
  bool visible = false;
  String? error;
  @override
  void dispose() {
    password.clear();
    repeat.clear();
    password.dispose();
    repeat.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(
        widget.creating ? l.lqBackupSetPassword : l.lqBackupEnterPassword,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.lqBackupPasswordHint),
            const SizedBox(height: 20),
            TextField(
              controller: password,
              obscureText: !visible,
              enableSuggestions: false,
              autocorrect: false,
              autofillHints: const [],
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: l.lqBackupPassword,
                suffixIcon: IconButton(
                  onPressed: () => setState(() => visible = !visible),
                  tooltip: visible
                      ? l.lqBackupHidePassword
                      : l.lqBackupShowPassword,
                  icon: Icon(visible ? Icons.visibility_off : Icons.visibility),
                ),
              ),
            ),
            if (widget.creating) ...[
              const SizedBox(height: 16),
              TextField(
                controller: repeat,
                obscureText: !visible,
                enableSuggestions: false,
                autocorrect: false,
                autofillHints: const [],
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: l.lqBackupRepeatPassword,
                ),
              ),
            ],
            if (error != null) ...[
              const SizedBox(height: 12),
              Semantics(
                liveRegion: true,
                child: Text(
                  error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (!DeviceBackupCodec.validPassword(password.text)) {
              setState(() => error = l.lqBackupPasswordHint);
              return;
            }
            if (widget.creating && password.text != repeat.text) {
              setState(() => error = l.lqBackupPasswordMismatch);
              return;
            }
            Navigator.pop(context, password.text);
          },
          child: Text(widget.creating ? l.lqBackupExport : l.lqBackupUnlock),
        ),
      ],
    );
  }
}
