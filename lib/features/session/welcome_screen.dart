import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../director/director_widgets.dart';
import '../director/quest_director_engine.dart';
import '../../l10n/app_localizations.dart';

/// The only information needed to put a real first quest in a new device
/// profile. Existing saved profiles are never overwritten by this draft.
class WelcomeSetup {
  static const pendingKey = 'lifequest.session.pendingWelcome.v1';
  final String name;
  final GrowthFocus focus;
  final String goal;
  final int minutes;

  const WelcomeSetup({
    required this.name,
    required this.focus,
    required this.goal,
    required this.minutes,
  });

  Map<String, Object> toJson() => {
    'name': name,
    'focus': focus.name,
    'goal': goal,
    'minutes': minutes,
  };

  Future<void> savePending() async {
    final prefs = await SharedPreferences.getInstance();
    if (!await prefs.setString(pendingKey, jsonEncode(toJson()))) {
      throw StateError('Initial profile could not be saved.');
    }
  }

  static Future<WelcomeSetup?> loadPending() async {
    final raw = (await SharedPreferences.getInstance()).getString(pendingKey);
    if (raw == null) return null;
    try {
      return fromJson(jsonDecode(raw));
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearPending() async {
    if (!await (await SharedPreferences.getInstance()).remove(pendingKey)) {
      throw StateError('Initial profile draft could not be cleared.');
    }
  }

  static WelcomeSetup? fromJson(dynamic json) {
    if (json is! Map ||
        json['name'] is! String ||
        json['goal'] is! String ||
        json['minutes'] is! int) {
      return null;
    }
    final focus = GrowthFocus.values
        .where((value) => value.name == json['focus'])
        .firstOrNull;
    final name = (json['name'] as String).trim();
    final goal = (json['goal'] as String).trim();
    final minutes = json['minutes'] as int;
    if (focus == null ||
        name.isEmpty ||
        name.runes.length > 20 ||
        goal.isEmpty ||
        goal.runes.length > 120 ||
        !const [5, 15, 30].contains(minutes)) {
      return null;
    }
    return WelcomeSetup(name: name, focus: focus, goal: goal, minutes: minutes);
  }
}

class WelcomeScreen extends StatefulWidget {
  final Future<void> Function(WelcomeSetup setup) onStart;
  final VoidCallback? onLogin;
  const WelcomeScreen({super.key, required this.onStart, this.onLogin});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _name = TextEditingController();
  final _goal = TextEditingController();
  GrowthFocus? _focus;
  String? _suggestedGoal;
  int _minutes = 5;
  bool _starting = false;

  @override
  void initState() {
    super.initState();
    _name.addListener(_refresh);
    _goal.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _name.dispose();
    _goal.dispose();
    super.dispose();
  }

  bool get _canStart =>
      _name.text.trim().isNotEmpty &&
      _goal.text.trim().isNotEmpty &&
      _focus != null;

  String _exampleGoal(GrowthFocus focus, AppLocalizations l) => switch (focus) {
    GrowthFocus.vitality => l.lqWelcomeExampleVitality,
    GrowthFocus.learning => l.lqWelcomeExampleLearning,
    GrowthFocus.order => l.lqWelcomeExampleOrder,
    GrowthFocus.connection => l.lqWelcomeExampleConnection,
  };

  void _selectFocus(GrowthFocus focus, AppLocalizations l) {
    final example = _exampleGoal(focus, l);
    if (_goal.text.trim().isEmpty || _goal.text == _suggestedGoal) {
      _goal.text = example;
    }
    setState(() {
      _focus = focus;
      _suggestedGoal = example;
    });
  }

  Future<void> _start() async {
    if (_starting || !_canStart) return;
    setState(() => _starting = true);
    try {
      await widget.onStart(
        WelcomeSetup(
          name: _name.text.trim(),
          focus: _focus!,
          goal: _goal.text.trim(),
          minutes: _minutes,
        ),
      );
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
                TextField(
                  key: const ValueKey('welcome-name'),
                  controller: _name,
                  maxLength: 20,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l.lqWelcomeName,
                    hintText: l.lqWelcomeNameHint,
                  ),
                ),
                const SizedBox(height: 12),
                Text(l.lqWelcomeFocus, style: t.textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final focus in GrowthFocus.values)
                      ChoiceChip(
                        key: ValueKey('welcome-focus-${focus.name}'),
                        label: Text(focusName(focus, l)),
                        selected: _focus == focus,
                        onSelected: (_) => _selectFocus(focus, l),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  l.lqWelcomeGoalQuickHint,
                  style: t.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF93B5C7),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  key: const ValueKey('welcome-goal'),
                  controller: _goal,
                  maxLength: 120,
                  maxLines: 2,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: l.lqWelcomeGoal,
                    hintText: l.lqWelcomeGoalHint,
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 12),
                Text(l.lqWelcomeMinutes, style: t.textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final minutes in const [5, 15, 30])
                      ChoiceChip(
                        key: ValueKey('welcome-minutes-$minutes'),
                        label: Text('$minutes ${l.lqMinutes}'),
                        selected: _minutes == minutes,
                        onSelected: (_) => setState(() => _minutes = minutes),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  l.lqWelcomeSetupPrivacy,
                  style: t.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFFB2CCDA),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  key: const ValueKey('welcome-start'),
                  onPressed: _starting || !_canStart ? null : _start,
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
                    onPressed: _starting ? null : widget.onLogin,
                    child: Text(
                      l.lqExistingAccount,
                      style: const TextStyle(color: Color(0xFF91DFF5)),
                    ),
                  ),
                const SizedBox(height: 24),
                HunterWelcomeStatusPreview(
                  name: _name.text.trim().isEmpty
                      ? l.lqWelcomeNamePlaceholder
                      : _name.text.trim(),
                ),
                const SizedBox(height: 12),
                Text(
                  l.lqWelcomePreviewNote,
                  style: t.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF93B5C7),
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
