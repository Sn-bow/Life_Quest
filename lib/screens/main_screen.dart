import 'dart:async';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/screens/quests_screen.dart';
import 'package:life_quest_final_v2/screens/achievement_screen.dart';
import 'package:life_quest_final_v2/screens/dungeon/dungeon_home_screen.dart';
import 'package:life_quest_final_v2/screens/inventory_screen.dart';
import 'package:life_quest_final_v2/screens/shop_screen.dart';
import 'package:life_quest_final_v2/screens/skill_screen.dart';
import 'package:life_quest_final_v2/screens/status_screen.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  late ConfettiController _confettiController;
  Timer? _timeSensitiveRefreshTimer;
  StreamSubscription<User?>? _authSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));

    context.read<CharacterState>().onLevelUp = () {
      _confettiController.play();
    };

    _timeSensitiveRefreshTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => unawaited(
        context.read<CharacterState>().refreshTimeSensitiveState(),
      ),
    );

    // 인증 상태 감시: 토큰 만료 또는 외부 로그아웃 시 자동으로 루트로 이동
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null && mounted) {
        context.read<CharacterState>().resetState();
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(context.read<CharacterState>().refreshTimeSensitiveState());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timeSensitiveRefreshTimer?.cancel();
    _authSubscription?.cancel();
    _confettiController.dispose();
    context.read<CharacterState>().onLevelUp = null;
    super.dispose();
  }

  static const List<Widget> _widgetOptions = <Widget>[
    StatusScreen(),
    QuestsScreen(),
    DungeonHomeScreen(),
    InventoryScreen(),
    ShopScreen(),
    AchievementScreen(),
    SkillScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // 데이터 로딩 중일 때 로딩 화면 표시
    if (context.watch<CharacterState>().isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A0E21),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(PhosphorIcons.user),
                label: l10n.tabStatus,
              ),
              BottomNavigationBarItem(
                icon: const Icon(PhosphorIcons.sword),
                label: l10n.tabQuests,
              ),
              BottomNavigationBarItem(
                icon: const Icon(PhosphorIcons.gameController),
                label: l10n.tabHunt,
              ),
              BottomNavigationBarItem(
                icon: const Icon(PhosphorIcons.backpack),
                label: l10n.tabInventory,
              ),
              BottomNavigationBarItem(
                icon: const Icon(PhosphorIcons.storefront),
                label: l10n.tabShop,
              ),
              BottomNavigationBarItem(
                icon: const Icon(PhosphorIcons.trophy),
                label: l10n.tabAchievement,
              ),
              BottomNavigationBarItem(
                icon: const Icon(PhosphorIcons.sparkle),
                label: l10n.tabSkill,
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
          ),
        ),
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          numberOfParticles: 20,
          gravity: 0.3,
          emissionFrequency: 0.05,
          colors: const [
            Colors.lightGreen,
            Colors.lightBlue,
            Colors.pinkAccent,
            Colors.orangeAccent,
            Colors.purpleAccent
          ],
        ),
      ],
    );
  }
}




