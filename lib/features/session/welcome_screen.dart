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
    return Scaffold(
      backgroundColor: const Color(0xFF06131E),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
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
                          color: const Color(0xFFEAF9FF),
                          letterSpacing: 2.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  l.lqFirstContract,
                  style: t.textTheme.labelMedium?.copyWith(
                    color: const Color(0xFF72D9F7),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l.lqWelcomeTitle,
                  style: t.textTheme.headlineLarge?.copyWith(
                    color: const Color(0xFFEAF9FF),
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                    letterSpacing: -1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l.lqWelcomeBody,
                  style: t.textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFFB2CCDA),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                HunterWelcomeStatusPreview(name: l.lqGuestName),
                const SizedBox(height: 12),
                Text(
                  l.lqWelcomePreviewNote,
                  style: t.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF93B5C7),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF102B3B),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF32546A)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF72D9F7),
                    foregroundColor: const Color(0xFF06131E),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Text(_starting ? l.lqStarting : l.lqStartOnDevice),
                  ),
                ),
                if (widget.onLogin != null)
                  TextButton(
                    onPressed: widget.onLogin,
                    child: Text(
                      l.lqExistingAccount,
                      style: const TextStyle(color: Color(0xFF91DFF5)),
                    ),
                  ),
                const SizedBox(height: 14),
                Text(
                  l.lqDeviceStorageNotice,
                  style: t.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFFB2CCDA),
                  ),
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: () => launchUrl(
                    Uri.parse('https://sn-bow.github.io/Life_Quest/#privacy'),
                    mode: LaunchMode.externalApplication,
                  ),
                  child: Text(
                    l.settingsPrivacyPolicy,
                    style: const TextStyle(color: Color(0xFF91DFF5)),
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

/// The preview uses the same original generated raster frame as the live
/// hunter window. All values are native Flutter text and can scale/accessibly
/// reflow; only the frame art is a bitmap.
class HunterWelcomeStatusPreview extends StatelessWidget {
  final String name;
  final int level;
  final double xp;
  final double maxXp;
  final List<double> stats;

  const HunterWelcomeStatusPreview({
    super.key,
    required this.name,
    this.level = 1,
    this.xp = 0,
    this.maxXp = 150,
    this.stats = const [0, 0, 0, 0],
  });

  static const _ink = Color(0xFFEAF9FF);
  static const _accent = Color(0xFF72D9F7);

  String _number(num value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final t = Theme.of(context);
    final labels = [
      l.statusStatStrength,
      l.statusStatWisdom,
      l.statusStatHealth,
      l.statusStatCharm,
    ];
    return Stack(
      key: const ValueKey('welcome-status-preview'),
      children: [
        Positioned.fill(
          child: ExcludeSemantics(
            child: Image.asset(
              'assets/images/ui/hunter_status_frame_v1.png',
              fit: BoxFit.fill,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 27, 30, 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l.lqStatusWindow,
                style: t.textTheme.titleMedium?.copyWith(
                  color: _accent,
                  letterSpacing: 1,
                ),
              ),
              const Divider(color: Color(0xFF32546A), height: 22),
              Wrap(
                spacing: 12,
                runSpacing: 3,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Lv. $level',
                    style: t.textTheme.headlineSmall?.copyWith(color: _accent),
                  ),
                  Text(
                    name,
                    style: t.textTheme.titleLarge?.copyWith(color: _ink),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                '${_number(xp)} / ${_number(maxXp)} XP',
                style: t.textTheme.bodyMedium?.copyWith(color: _ink),
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: maxXp <= 0 ? 0 : (xp / maxXp).clamp(0.0, 1.0),
                minHeight: 4,
                color: _accent,
                backgroundColor: const Color(0xFF193448),
                semanticsLabel: 'XP',
              ),
              const SizedBox(height: 14),
              for (var i = 0; i < labels.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          labels[i],
                          style: t.textTheme.bodyMedium?.copyWith(color: _ink),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _number(stats[i]),
                        style: t.textTheme.titleMedium?.copyWith(
                          color: _accent,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
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
            color: const Color(0xFF72D9F7),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
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
        ),
      ],
    );
  }
}
