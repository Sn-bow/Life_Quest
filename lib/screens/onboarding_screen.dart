import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/features/session/welcome_screen.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/screens/main_screen.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:provider/provider.dart';

/// Legacy cloud-account onboarding is a single status reveal. Device profiles
/// use WelcomeScreen -> SessionGate -> MainScreen without this extra page.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _finishing = false;

  Future<void> _finish() async {
    if (_finishing) return;
    setState(() => _finishing = true);
    try {
      await context.read<CharacterState>().completeOnboarding();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder<void>(
          pageBuilder: (context, animation, _) => const MainScreen(),
          transitionsBuilder: (context, animation, _, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 360),
        ),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.lqStorageError)),
        );
      }
    } finally {
      if (mounted) setState(() => _finishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final t = Theme.of(context);
    final profile = context.watch<CharacterState>().character;

    return Scaffold(
      backgroundColor: const Color(0xFF06131E),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 36),
              children: [
                Text(
                  l.lqStatusWindow,
                  style: t.textTheme.labelMedium?.copyWith(
                    color: const Color(0xFF72D9F7),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l.onboardingPage1Title,
                  style: t.textTheme.headlineLarge?.copyWith(
                    color: const Color(0xFFEAF9FF),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l.onboardingPage1Body,
                  style: t.textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFFB2CCDA),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                HunterWelcomeStatusPreview(
                  name: profile.name,
                  level: profile.level,
                  xp: profile.xp,
                  maxXp: profile.maxXp,
                  stats: [
                    profile.strength,
                    profile.wisdom,
                    profile.health,
                    profile.charisma,
                  ],
                ),
                const SizedBox(height: 24),
                _OptionalFeature(
                  title: l.onboardingPage2Title,
                  body: l.onboardingPage2Body,
                ),
                const SizedBox(height: 12),
                _OptionalFeature(
                  title: l.onboardingPage3Title,
                  body: l.onboardingPage3Body,
                ),
                const SizedBox(height: 28),
                FilledButton(
                  onPressed: _finishing ? null : _finish,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF72D9F7),
                    foregroundColor: const Color(0xFF06131E),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Text(_finishing ? l.lqStarting : l.onboardingStart),
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

class _OptionalFeature extends StatelessWidget {
  final String title;
  final String body;
  const _OptionalFeature({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF102B3B),
        border: Border.all(color: const Color(0xFF32546A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: t.textTheme.titleSmall?.copyWith(
              color: const Color(0xFFEAF9FF),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            body,
            style: t.textTheme.bodySmall?.copyWith(
              color: const Color(0xFFB2CCDA),
            ),
          ),
        ],
      ),
    );
  }
}
