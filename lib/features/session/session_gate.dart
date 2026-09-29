import 'account_deletion_gate.dart';
import '../backup/backup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/cloud_config.dart';
import '../director/quest_director_engine.dart';
import '../director/quest_director_state.dart';
import '../../l10n/app_localizations.dart';
import '../../screens/login_screen.dart';
import '../../screens/main_screen.dart';
import '../../state/character_state.dart';
import 'session_state.dart';
import 'welcome_screen.dart';

/// Finishes an interrupted first launch before MainScreen can bind the
/// director. An existing device profile and its configured preferences win.
Future<void> initializeDeviceHunterProfile({
  required CharacterState character,
  required QuestDirectorState director,
  required String fallbackName,
  required String languageCode,
}) async {
  final setup = await WelcomeSetup.loadPending();
  await character.initializeForLocalGuest(
    name: setup?.name ?? fallbackName,
    languageCode: languageCode,
    usesDefaultGuestName: setup == null,
  );
  if (setup == null) return;
  await director.bind(character.personalizationScope);
  if (!director.profile.configured) {
    await director.configure(
      HunterProfile(
        focuses: {setup.focus},
        minutes: setup.minutes,
        goal: setup.goal,
      ),
    );
    if (director.saveFailed) {
      throw StateError('Initial recommendations could not be saved.');
    }
  }
  await WelcomeSetup.clearPending();
}

/// This widget stays at the navigation root. Auth changes replace its child,
/// so logout never leaves a detached MainScreen waiting for a deleted profile.
class SessionGate extends StatefulWidget {
  const SessionGate({super.key});
  @override
  State<SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends State<SessionGate> {
  bool _showLogin = false;
  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionState>();
    if (!session.ready) return const _Progress();
    if (session.deviceSelected) {
      return _ProfileLoader(key: ValueKey('device-${session.deviceRevision}'));
    }
    final welcome = WelcomeScreen(
      onStart: (setup) async {
        // Save the choice before routing. A process restart during first load
        // can then finish creating the same profile and recommendations.
        await setup.savePending();
        await session.selectDevice(true);
      },
      onLogin: kLifeQuestCloudEnabled && !session.purchaseOnlyAuth
          ? () => setState(() => _showLogin = true)
          : null,
    );
    if (!kLifeQuestCloudEnabled || session.purchaseOnlyAuth) return welcome;
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: FirebaseAuth.instance.currentUser,
      builder: (context, snapshot) {
        final user = snapshot.data;
        // An anonymous identity exists only to send a user-reviewed AI report.
        if (user != null && !user.isAnonymous) {
          return AccountDeletionGate(
            key: ValueKey('deletion-guard-${user.uid}'),
            uid: user.uid,
            signOut: () async {
              // Never sign out a different identity after an account switch.
              if (FirebaseAuth.instance.currentUser?.uid == user.uid) {
                await FirebaseAuth.instance.signOut();
              }
            },
            child: _ProfileLoader(key: ValueKey(user.uid), user: user),
          );
        }
        if (!_showLogin) return welcome;
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) setState(() => _showLogin = false);
          },
          child: Scaffold(
            appBar: AppBar(
              leading: BackButton(
                onPressed: () => setState(() => _showLogin = false),
              ),
            ),
            body: const LoginScreen(),
          ),
        );
      },
    );
  }
}

class _ProfileLoader extends StatefulWidget {
  final User? user;
  const _ProfileLoader({super.key, this.user});
  @override
  State<_ProfileLoader> createState() => _ProfileLoaderState();
}

class _ProfileLoaderState extends State<_ProfileLoader> {
  Future<void>? _load;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load ??= _initialize();
  }

  Future<void> _initialize() async {
    final character = context.read<CharacterState>();
    if (widget.user == null) {
      await initializeDeviceHunterProfile(
        character: character,
        director: context.read<QuestDirectorState>(),
        fallbackName: AppLocalizations.of(context)!.lqGuestName,
        languageCode: Localizations.localeOf(context).languageCode,
      );
    } else {
      await character.loadDataForUser(widget.user!);
      if (!character.isDataLoaded || character.hasLoadError) {
        throw StateError('Profile could not be loaded.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return FutureBuilder<void>(
      future: _load,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _Progress();
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cloud_off_outlined, size: 36),
                      const SizedBox(height: 16),
                      Text(l.lqProfileLoadFailed, textAlign: TextAlign.center),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: () => setState(() => _load = _initialize()),
                        child: Text(l.lqRetry),
                      ),
                      if (widget.user == null)
                        TextButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  const BackupScreen(restoreOnly: true),
                            ),
                          ),
                          child: Text(l.lqBackupImport),
                        ),
                      TextButton(
                        onPressed: () async {
                          if (widget.user != null) {
                            await FirebaseAuth.instance.signOut();
                          }
                          if (context.mounted) {
                            await context.read<SessionState>().selectDevice(
                              false,
                            );
                          }
                        },
                        child: Text(l.lqBackToStart),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return const MainScreen();
      },
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}
