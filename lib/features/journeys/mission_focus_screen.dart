import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/quest.dart';
import '../system/hunter_system_frame.dart';
import 'journey_catalog.dart';
import 'mission_focus_clock.dart';
import 'mission_focus_store.dart';

class MissionFocusScreen extends StatefulWidget {
  final Quest quest;
  final String scope;
  const MissionFocusScreen({
    super.key,
    required this.quest,
    required this.scope,
  });
  @override
  State<MissionFocusScreen> createState() => _MissionFocusScreenState();
}

class _MissionFocusScreenState extends State<MissionFocusScreen>
    with WidgetsBindingObserver {
  late MissionFocusClock _clock = MissionFocusClock(
    (widget.quest.estimatedMinutes ?? 5) * 60,
  );
  Timer? _ticker;
  bool _ready = false, _saving = false, _failed = false;
  String get _key => MissionFocusStore.key(widget.scope, widget.quest.id);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  Future<void> _load() async {
    try {
      final raw = (await SharedPreferences.getInstance()).getString(_key);
      if (raw != null) {
        _clock = MissionFocusClock.fromJson(
          jsonDecode(raw),
          (widget.quest.estimatedMinutes ?? 5) * 60,
        );
      }
    } catch (_) {
      _failed = true;
    }
    if (!mounted) return;
    setState(() => _ready = true);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _clock.running) setState(() {});
    });
  }

  Future<void> _change(void Function() change) async {
    if (_saving) return;
    final before = _clock.toJson();
    setState(() {
      _saving = true;
      _failed = false;
      change();
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!await prefs.setString(_key, jsonEncode(_clock.toJson()))) {
        throw StateError('Timer save failed');
      }
    } catch (_) {
      _clock = MissionFocusClock.fromJson(before, _clock.durationSeconds);
      _failed = true;
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) setState(() {});
  }

  @override
  void dispose() {
    _ticker?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final copy = JourneyCopy(Localizations.localeOf(context).languageCode);
    final seconds = _clock.remaining(DateTime.now());
    String text(List<String> values) => copy.choose(values);
    return PopScope(
      canPop: !_saving,
      child: Theme(
        data: HunterSystemFrame.themeFor(context),
        child: Scaffold(
          backgroundColor: const Color(0xFF07131B),
          appBar: AppBar(title: Text(copy.t('timer'))),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.quest.name,
                        textAlign: TextAlign.center,
                        style: HunterSystemFrame.themeFor(
                          context,
                        ).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 32),
                      if (!_ready)
                        const Center(child: CircularProgressIndicator())
                      else ...[
                        Semantics(
                          label:
                              '${seconds ~/ 60} ${copy.t('min')}, ${seconds % 60}',
                          child: ExcludeSemantics(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                  fontSize: 80,
                                  color: Color(0xFF80DCFB),
                                  fontFeatures: [FontFeature.tabularFigures()],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        LinearProgressIndicator(
                          value: 1 - seconds / _clock.durationSeconds,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          text(
                            seconds == 0
                                ? [
                                    'Time is up. Return to the mission and record what you did. The timer does not mark it complete.',
                                    '시간이 끝났습니다. 미션으로 돌아가 실행한 내용을 남기세요. 타이머가 자동 완료하지는 않습니다.',
                                    '時間になりました。ミッションに戻り、できたことを記録しましょう。タイマーで自動完了にはなりません。',
                                    '時間到了。回到任務記錄你做的事，計時器不會自動完成任務。',
                                  ]
                                : [
                                    'The timer keeps counting when you leave this screen. There is no background alarm. Return when ready; you can pause or stop at any time.',
                                    '화면을 나가도 시간이 흐릅니다. 백그라운드 알람은 울리지 않습니다. 준비되면 돌아오세요. 언제든 멈출 수 있습니다.',
                                    'この画面を離れても時間は進みます。バックグラウンドのアラームは鳴りません。いつでも戻って一時停止できます。',
                                    '離開畫面後仍會計時，但沒有背景鬧鐘。準備好再回來，隨時都能暫停。',
                                  ],
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(height: 1.6),
                        ),
                        const SizedBox(height: 24),
                        if (seconds > 0)
                          FilledButton(
                            onPressed: _saving
                                ? null
                                : () => _change(
                                    () => _clock.running
                                        ? _clock.pause(DateTime.now())
                                        : _clock.start(DateTime.now()),
                                  ),
                            child: Text(
                              text(
                                _clock.running
                                    ? ['Pause', '잠시 멈춤', '一時停止', '暫停']
                                    : [
                                        'Start focus',
                                        '집중 시작',
                                        '集中を始める',
                                        '開始專注',
                                      ],
                              ),
                            ),
                          ),
                        TextButton(
                          onPressed: _saving
                              ? null
                              : () => _change(_clock.reset),
                          child: Text(
                            text([
                              'Reset timer',
                              '타이머 초기화',
                              'タイマーをリセット',
                              '重設計時器',
                            ]),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: _saving
                              ? null
                              : () => Navigator.pop(context),
                          child: Text(copy.t('back')),
                        ),
                      ],
                      if (_failed)
                        Text(
                          copy.t('error'),
                          style: const TextStyle(color: Color(0xFFFFB4AB)),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
