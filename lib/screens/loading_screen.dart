import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/screens/main_screen.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _loadDataAndNavigate();
  }

  Future<void> _loadDataAndNavigate() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // CharacterState의 데이터 로딩을 기다림
    await context.read<CharacterState>().loadDataForUser(user);

    // 위젯이 아직 마운트 상태인지 확인 후 화면 전환
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? const [Color(0xFF091327), Color(0xFF102331)]
                : const [Color(0xFFFFF5D9), Color(0xFFF8E4B7)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                isDarkMode
                    ? 'assets/images/splash_logo_dark.png'
                    : 'assets/images/splash_logo.png',
                width: 240,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 28),
              const SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(strokeWidth: 3.2),
              ),
              const SizedBox(height: 18),
              Text(
                '오늘의 퀘스트를 준비하는 중...',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : const Color(0xFF22303B),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
