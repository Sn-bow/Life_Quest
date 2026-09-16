import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/screens/main_screen.dart';
import 'package:life_quest_final_v2/screens/onboarding_screen.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key, this.user});

  final User? user;

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _didStartBootstrap = false;

  bool get _isBootstrappingUser => widget.user != null;

  @override
  void initState() {
    super.initState();
    _maybeStartBootstrap();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maybeStartBootstrap();
  }

  @override
  void didUpdateWidget(covariant LoadingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _maybeStartBootstrap();
  }

  void _maybeStartBootstrap() {
    if (_didStartBootstrap || widget.user == null) return;
    _didStartBootstrap = true;
    _loadDataAndNavigate();
  }

  Future<void> _loadDataAndNavigate() async {
    final user = widget.user;
    if (user == null) return;

    final loadFuture = context.read<CharacterState>().loadDataForUser(user);
    final minimumFuture = Future<void>.delayed(
      const Duration(milliseconds: 1200),
    );
    await Future.wait([loadFuture, minimumFuture]);

    if (!mounted) return;
    final charState = context.read<CharacterState>();
    final nextScreen = charState.hasSeenOnboarding
        ? const MainScreen()
        : const OnboardingScreen();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 360),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/splash_mark_dark.png',
                    width: 180,
                    height: 180,
                    excludeFromSemantics: true,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l.loadingTagline,
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isBootstrappingUser ? l.loadingSync : l.loadingGate,
                    style: theme.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isBootstrappingUser
                        ? l.loadingSyncDesc
                        : l.loadingGateDesc,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  const SizedBox(width: 180, child: LinearProgressIndicator()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
