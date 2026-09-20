import 'dart:async';
import '../features/research/beta_study.dart';
import '../features/research/beta_study_screen.dart' show studySnapshot;
import '../features/billing/purchase_account_state.dart';
import '../state/dungeon_state.dart';
import '../services/purchase_service.dart';
import '../config/qa_preview_config.dart';
import 'package:life_quest_final_v2/screens/growth_hub_screen.dart';
import 'package:life_quest_final_v2/features/director/quest_director_state.dart';
import 'package:life_quest_final_v2/features/director/quest_director_engine.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/screens/quests_screen.dart';
import 'package:life_quest_final_v2/screens/dungeon/dungeon_home_screen.dart';
import 'package:life_quest_final_v2/screens/today_screen.dart';
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
  late CharacterState _character;
  late QuestDirectorState _director;
  late DungeonState _dungeon;
  late ConfettiController _confettiController;
  Timer? _timeSensitiveRefreshTimer;
  bool _isForeground = true;
  PurchaseAccountState? _purchaseAccount;

  void _captureStudy() {
    if (kLifeQuestResearchEnabled &&
        mounted &&
        _isForeground &&
        _character.isLocalGuest &&
        _character.isDataLoaded) {
      unawaited(BetaStudy.instance.observeQuietly(studySnapshot(_character)));
    }
  }

  void _bindPurchaseIdentity() {
    if (!mounted) return;
    unawaited(
      PurchaseService().bindUser(
        kLifeQuestQaPreview
            ? null
            : _character.isLocalGuest
            ? _purchaseAccount?.uid
            : _character.personalizationScope,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    _character = context.read<CharacterState>();
    _character.addListener(_captureStudy);
    _purchaseAccount = context.read<PurchaseAccountState?>();
    _purchaseAccount?.addListener(_bindPurchaseIdentity);
    _director = context.read<QuestDirectorState>();
    _dungeon = context.read<DungeonState>();
    _dungeon.bindCheckpoint(
      saved: _character.dungeonCheckpoint,
      save: _character.saveDungeonCheckpoint,
    );
    _character.onLevelUp = () {
      if (mounted && !MediaQuery.disableAnimationsOf(context)) {
        _confettiController.play();
      }
    };
    _character.onQuestCompleted = (quest) =>
        unawaited(_director.record(quest, QuestFeedback.completed));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      _captureStudy();
      final purchases = PurchaseService();
      purchases.onEntitlementsChanged = _character.setPurchasedEntitlements;
      await _purchaseAccount?.initialize();
      if (!mounted) return;
      await purchases.bindUser(
        kLifeQuestQaPreview
            ? null
            : _character.isLocalGuest
            ? _purchaseAccount?.uid
            : _character.personalizationScope,
      );
      if (!mounted) return;
      await _director.bind(_character.personalizationScope);
      if (!mounted) return;
      await _director.reconcile(_character.dailyQuests);
      if (mounted && _isForeground) {
        unawaited(
          _director.personalizeIfNeeded(
            Localizations.localeOf(context).languageCode,
          ),
        );
      }
    });

    _timeSensitiveRefreshTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => unawaited(_refresh()),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isForeground = state == AppLifecycleState.resumed;
    if (state == AppLifecycleState.resumed) {
      unawaited(_refresh());
    } else if (state == AppLifecycleState.paused) {
      unawaited(_director.cancelModelOperation());
      unawaited(_dungeon.flushCheckpoint());
      unawaited(_character.forceSave());
    }
  }

  Future<void> _refresh() async {
    if (!mounted || !_isForeground) return;
    _captureStudy();
    try {
      await _character.refreshTimeSensitiveState();
      if (!mounted) return;
      await _director.refreshDay();
      await _director.reconcile(_character.dailyQuests);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.lqStorageError)),
        );
      }
    }
    if (mounted && _isForeground) {
      unawaited(
        _director.personalizeIfNeeded(
          Localizations.localeOf(context).languageCode,
        ),
      );
    }
  }

  @override
  void dispose() {
    _character.removeListener(_captureStudy);
    _purchaseAccount?.removeListener(_bindPurchaseIdentity);
    _dungeon.unbindCheckpoint();
    WidgetsBinding.instance.removeObserver(this);
    _timeSensitiveRefreshTimer?.cancel();
    _confettiController.dispose();
    PurchaseService().onEntitlementsChanged = null;
    unawaited(PurchaseService().bindUser(null));
    _character.onLevelUp = null;
    _character.onQuestCompleted = null;
    unawaited(_director.endSession(notify: false));
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _widgetOptions() {
    return <Widget>[
      TodayScreen(
        onOpenQuests: () => _onItemTapped(1),
        onOpenDungeon: () => _onItemTapped(2),
      ),
      const QuestsScreen(),
      const DungeonHomeScreen(),
      const GrowthHubScreen(),
    ];
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
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: _widgetOptions().elementAt(_selectedIndex),
            ),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            destinations: [
              NavigationDestination(
                icon: const Icon(PhosphorIcons.house),
                selectedIcon: const Icon(PhosphorIcons.houseFill),
                label: l10n.lqToday,
              ),
              NavigationDestination(
                icon: const Icon(PhosphorIcons.checkSquare),
                selectedIcon: const Icon(PhosphorIcons.checkSquareFill),
                label: l10n.tabQuests,
              ),
              NavigationDestination(
                icon: const Icon(PhosphorIcons.sword),
                selectedIcon: const Icon(PhosphorIcons.swordFill),
                label: l10n.lqDungeon,
              ),
              NavigationDestination(
                icon: const Icon(PhosphorIcons.chartBar),
                selectedIcon: const Icon(PhosphorIcons.chartBarFill),
                label: l10n.lqGrowth,
              ),
            ],
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
            Colors.purpleAccent,
          ],
        ),
      ],
    );
  }
}
