import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/screens/main_screen.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:provider/provider.dart';

class QaPreviewGateScreen extends StatefulWidget {
  const QaPreviewGateScreen({super.key});

  @override
  State<QaPreviewGateScreen> createState() => _QaPreviewGateScreenState();
}

class _QaPreviewGateScreenState extends State<QaPreviewGateScreen> {
  bool _isStarting = false;

  void _startPreview() {
    if (_isStarting) return;
    setState(() => _isStarting = true);
    final characterState = context.read<CharacterState>();
    characterState.initializeForQaPreview();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => const MainScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
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
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/images/splash_mark_dark.png',
                      height: 116,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Life Quest',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Web QA Preview',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF38DFF8),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      '설치 없이 퀘스트, 성장, 소울 덱 전투 흐름을 먼저 테스트하는 임시 체험판입니다.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFB7CAD8),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    FilledButton(
                      onPressed: _isStarting ? null : _startPreview,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF27D3F5),
                        foregroundColor: const Color(0xFF04111A),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _isStarting ? '시작 중...' : '게스트로 테스트 시작',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '현재 데이터는 정식 계정과 분리된 QA용 임시 데이터입니다.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF7F93A3),
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
