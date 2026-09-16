import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';

class WelcomeScreen extends StatefulWidget {
  final Future<void> Function() onStart;
  final VoidCallback? onLogin;
  const WelcomeScreen({super.key, required this.onStart, this.onLogin});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _starting = false;
  Future<void> _start() async {
    if (_starting) return;
    setState(() => _starting = true);
    try {
      await widget.onStart();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.lqProfileLoadFailed),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final t = Theme.of(context);
    final c = t.colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/splash_mark_dark.png',
                      width: 32,
                      height: 32,
                      excludeFromSemantics: true,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'LIFE QUEST',
                        style: t.textTheme.titleSmall?.copyWith(
                          letterSpacing: 2.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    'assets/images/backgrounds/exit_zero_gateway.jpg',
                    height: 180,
                    fit: BoxFit.cover,
                    alignment: const Alignment(.55, 0),
                    excludeFromSemantics: true,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'CHAPTER 00',
                  style: t.textTheme.labelMedium?.copyWith(
                    color: c.primary,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l.lqWelcomeTitle,
                  style: t.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                    letterSpacing: -1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l.lqWelcomeBody,
                  style: t.textTheme.bodyLarge?.copyWith(
                    color: c.onSurfaceVariant,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: c.outline),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome_outlined,
                            color: c.primary,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l.lqFirstContract,
                              style: t.textTheme.labelLarge?.copyWith(
                                color: c.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _Step(
                        number: '01',
                        title: l.lqWelcomeStepOne,
                        body: l.lqWelcomeStepOneBody,
                      ),
                      const Divider(height: 28),
                      _Step(
                        number: '02',
                        title: l.lqWelcomeStepTwo,
                        body: l.lqWelcomeStepTwoBody,
                      ),
                      const Divider(height: 28),
                      _Step(
                        number: '03',
                        title: l.lqWelcomeStepThree,
                        body: l.lqWelcomeStepThreeBody,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _starting ? null : _start,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Text(_starting ? l.lqStarting : l.lqStartOnDevice),
                  ),
                ),
                if (widget.onLogin != null)
                  TextButton(
                    onPressed: widget.onLogin,
                    child: Text(l.lqExistingAccount),
                  ),
                const SizedBox(height: 14),
                Text(
                  l.lqDeviceStorageNotice,
                  style: t.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: () => launchUrl(
                    Uri.parse('https://sn-bow.github.io/Life_Quest/#privacy'),
                    mode: LaunchMode.externalApplication,
                  ),
                  child: Text(l.settingsPrivacyPolicy),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String number, title, body;
  const _Step({required this.number, required this.title, required this.body});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: t.textTheme.labelMedium?.copyWith(
            color: t.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: t.textTheme.titleSmall),
              const SizedBox(height: 5),
              Text(body, style: t.textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
