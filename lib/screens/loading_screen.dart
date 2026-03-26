import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/screens/main_screen.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key, this.user});

  final User? user;

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _didStartBootstrap = false;

  bool get _isBootstrappingUser => widget.user != null;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();
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
    final minimumFuture = Future<void>.delayed(const Duration(milliseconds: 1200));
    await Future.wait([loadFuture, minimumFuture]);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 360),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusText = _isBootstrappingUser ? '헌터 정보를 동기화하는 중' : '게이트를 여는 중';
    final captionText = _isBootstrappingUser
        ? '오늘의 퀘스트와 성장 기록을 불러옵니다'
        : '시스템을 초기화하고 있습니다';

    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _controller.value;
          final pulse = Curves.easeInOut.transform((math.sin(t * math.pi * 2) + 1) / 2);
          final rotation = t * math.pi * 2;

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF040912),
                  Color(0xFF081120),
                  Color(0xFF10263A),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _StartupBackdropPainter(pulse: pulse),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.scale(
                        scale: 0.96 + pulse * 0.08,
                        child: SizedBox(
                          width: 240,
                          height: 240,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 208 + pulse * 12,
                                height: 208 + pulse * 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF3DE0FF).withValues(
                                      alpha: 0.18 + pulse * 0.18,
                                    ),
                                    width: 2.2,
                                  ),
                                ),
                              ),
                              Transform.rotate(
                                angle: rotation * 0.28,
                                child: Container(
                                  width: 164,
                                  height: 164,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF68F0FF).withValues(
                                        alpha: 0.54,
                                      ),
                                      width: 5,
                                    ),
                                  ),
                                ),
                              ),
                              Transform.rotate(
                                angle: -rotation * 0.22,
                                child: Image.asset(
                                  'assets/images/splash_mark_dark.png',
                                  width: 130,
                                  height: 130,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'ARISE YOUR QUEST',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: const Color(0xFFE5F6FF),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        statusText,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        captionText,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF9FC6DA),
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 26),
                      SizedBox(
                        width: 196,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            minHeight: 6,
                            backgroundColor: const Color(0xFF133044),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color.lerp(
                                const Color(0xFF2DD4FF),
                                const Color(0xFF7CF7FF),
                                pulse,
                              )!,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StartupBackdropPainter extends CustomPainter {
  const _StartupBackdropPainter({required this.pulse});

  final double pulse;

  @override
  void paint(Canvas canvas, Size size) {
    final cyanGlow = Paint()
      ..color = const Color(0xFF27DAFF).withValues(alpha: 0.10 + pulse * 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 90);
    canvas.drawCircle(
      Offset(size.width * 0.72, size.height * 0.24),
      size.width * 0.24,
      cyanGlow,
    );

    final blueGlow = Paint()
      ..color = const Color(0xFF3567FF).withValues(alpha: 0.10)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 110);
    canvas.drawCircle(
      Offset(size.width * 0.24, size.height * 0.78),
      size.width * 0.22,
      blueGlow,
    );

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = const Color(0xFF5CCBFF).withValues(alpha: 0.12);
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      size.width * 0.37 + pulse * 6,
      ringPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      size.width * 0.28 + pulse * 4,
      ringPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _StartupBackdropPainter oldDelegate) {
    return oldDelegate.pulse != pulse;
  }
}
