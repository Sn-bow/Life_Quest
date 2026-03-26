import 'dart:async';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/screens/quests_screen.dart';
import 'package:life_quest_final_v2/screens/achievement_screen.dart';
import 'package:life_quest_final_v2/screens/hunt_screen.dart';
import 'package:life_quest_final_v2/screens/inventory_screen.dart';
import 'package:life_quest_final_v2/screens/shop_screen.dart';
import 'package:life_quest_final_v2/screens/skill_screen.dart';
import 'package:life_quest_final_v2/screens/status_screen.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  late ConfettiController _confettiController;
  Timer? _timeSensitiveRefreshTimer;

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
    _confettiController.dispose();
    context.read<CharacterState>().onLevelUp = null;
    super.dispose();
  }

  static const List<Widget> _widgetOptions = <Widget>[
    StatusScreen(),
    QuestsScreen(),
    HuntScreen(),
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
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(PhosphorIcons.user),
                label: '상태창',
              ),
              BottomNavigationBarItem(
                icon: Icon(PhosphorIcons.sword),
                label: '퀘스트',
              ),
              BottomNavigationBarItem(
                icon: Icon(PhosphorIcons.gameController),
                label: '사냥',
              ),
              BottomNavigationBarItem(
                icon: Icon(PhosphorIcons.backpack),
                label: '인벤토리',
              ),
              BottomNavigationBarItem(
                icon: Icon(PhosphorIcons.storefront),
                label: '상점',
              ),
              BottomNavigationBarItem(
                icon: Icon(PhosphorIcons.trophy),
                label: '업적',
              ),
              BottomNavigationBarItem(
                icon: Icon(PhosphorIcons.sparkle),
                label: '스킬',
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




