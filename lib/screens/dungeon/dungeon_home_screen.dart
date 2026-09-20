import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'dungeon_result_screen.dart';
import 'package:provider/provider.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/state/dungeon_state.dart';
import 'package:life_quest_final_v2/screens/dungeon/dungeon_map_screen.dart';
import 'package:life_quest_final_v2/screens/dungeon/card_collection_screen.dart';
import 'package:life_quest_final_v2/screens/dungeon/card_pack_screen.dart';
import 'package:life_quest_final_v2/screens/dungeon/infinite_tower_screen.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/data/card_database.dart';
import 'package:life_quest_final_v2/data/relic_database.dart';
import 'package:life_quest_final_v2/models/card_data.dart';
import 'package:life_quest_final_v2/models/relic_data.dart';

class DungeonHomeScreen extends StatefulWidget {
  const DungeonHomeScreen({super.key});

  @override
  State<DungeonHomeScreen> createState() => _DungeonHomeScreenState();
}

class _DungeonHomeScreenState extends State<DungeonHomeScreen> {
  int _ascensionLevel = 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final character = context.watch<CharacterState>();
    final dungeon = context.watch<DungeonState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (!character.isDataLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final names = [
      l.zone1Name,
      l.zone2Name,
      l.zone3Name,
      l.zone4Name,
      l.zone5Name,
    ];
    final descriptions = [
      l.zone1Description,
      l.zone2Description,
      l.zone3Description,
      l.zone4Description,
      l.zone5Description,
    ];
    const levels = [1, 5, 10, 20, 30];
    return Scaffold(
      appBar: AppBar(
        title: Text(l.dungeonHomeTitle),
        actions: [
          IconButton(
            tooltip: '${l.lqDungeonPacks} · ${character.cardPackCount}',
            icon: const Icon(Icons.card_giftcard),
            onPressed: character.cardPackCount > 0
                ? () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CardPackScreen()),
                  )
                : null,
          ),
          IconButton(
            tooltip: l.dungeonHomeCardCollectionTooltip,
            icon: const Icon(Icons.collections_bookmark),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CardCollectionScreen()),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/backgrounds/bg_zone1_meadow.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x44090E1B), Color(0xFA090E1B)],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 48),
                          Text(
                            l.lqDungeonIntro,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l.lqDungeonIntroBody,
                            style: const TextStyle(
                              color: Color(0xFFD9E2F2),
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              icon: Icon(
                                dungeon.hasRun
                                    ? Icons.play_arrow
                                    : Icons.explore,
                              ),
                              label: Text(
                                dungeon.hasResult
                                    ? l.lqDungeonCollectResult
                                    : dungeon.hasRun
                                    ? l.lqDungeonResume
                                    : l.lqDungeonStart,
                              ),
                              onPressed: () => dungeon.hasRun
                                  ? Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => dungeon.hasResult
                                            ? DungeonResultScreen(
                                                isVictory:
                                                    dungeon.runPhase ==
                                                    RunPhase.completed,
                                              )
                                            : const DungeonMapScreen(),
                                      ),
                                    )
                                  : _startBattle(context, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l.lqDungeonCheckpointHint,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (dungeon.saveFailed)
                Text(
                  l.lqDungeonSaveFailed,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              const SizedBox(height: 16),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text(l.lqDungeonBonus),
                childrenPadding: const EdgeInsets.only(bottom: 16),
                children: [
                  Text(
                    l.lqDungeonBonusBody,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      Text('STR ${character.character.strength.toInt()}'),
                      Text('INT ${character.character.wisdom.toInt()}'),
                      Text('VIT ${character.character.health.toInt()}'),
                      Text('CHA ${character.character.charisma.toInt()}'),
                    ],
                  ),
                ],
              ),
              if (character.hasCompletedZone5) ...[
                _AscensionSection(
                  ascensionLevel: _ascensionLevel,
                  onChanged: (value) => setState(() => _ascensionLevel = value),
                  isDark: isDark,
                ),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 20),
              Text(
                l.dungeonHomeDungeonSelection,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              for (var i = 0; i < 5; i++) ...[
                Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Icon(
                      character.character.level < levels[i]
                          ? Icons.lock_outline
                          : character.completedZones.contains(i + 1)
                          ? Icons.check_circle_outline
                          : Icons.explore_outlined,
                    ),
                    title: Text(
                      '${i + 1}. ${names[i]}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        character.character.level < levels[i]
                            ? l.dungeonHomeLockedHint(levels[i])
                            : descriptions[i],
                      ),
                    ),
                    // An active run is resumed first, so a zone tap never discards it.
                    enabled:
                        character.character.level >= levels[i] &&
                        !dungeon.hasRun,
                    onTap: () => _startBattle(context, i + 1),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              if (character.hasCompletedZone5)
                _InfiniteTowerButton(isDark: isDark),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startBattle(BuildContext context, int zone) async {
    final dungeon = context.read<DungeonState>();
    if (dungeon.hasRun) return;
    final charState = context.read<CharacterState>();
    final character = charState.character;
    final dailyModifier = charState.todayDailyModifier;

    // ── 기본 HP ───────────────────────────────────────────────────────────
    int playerMaxHp = 80 + (character.health * 2).toInt();

    // ── [장비 보너스] 방어구 장착 → 시작 HP +방어력×2 ──────────────────────
    if (character.equippedArmor != null) {
      playerMaxHp += (character.equippedArmor!.defensePower * 2).toInt();
    }

    // ── 시작 골드: 기본 50 + 계정 골드 15% 반입 ──────────────────────────
    int startingGold = 50 + (character.gold * 0.15).clamp(0, 150).toInt();

    // ── [스트릭 보너스] 시작 골드 추가 보정 ──────────────────────────────
    if (character.streak >= 3) startingGold += 30; // 3일: +30
    if (character.streak >= 7) startingGold += 20; // 7일: 추가 +20
    if (character.streak >= 14) startingGold += 30; // 14일: 추가 +30

    // ── [장비 보너스] 무기 장착 → 시작 덱에 공격 카드 1장 추가 ─────────────
    RelicData? starterRelic;
    final deck = charState.starterDeck.toList();
    if (character.equippedWeapon != null) {
      // L-2: 항상 첫 번째 카드가 아닌 랜덤 선택
      final attackCards = CardDatabase.getCardsByCategory(
        CardCategory.attack,
      ).where((c) => c.rarity == CardRarity.common && !c.isUpgraded).toList();
      if (attackCards.isNotEmpty) {
        attackCards.shuffle(math.Random());
        deck.add(attackCards.first);
      }
    }

    // ── [장비 보너스] 악세서리 장착 → 시작 렐릭 1개 추가 선택지 ─────────────
    // H-3: 보스 렐릭(불리한 패널티 포함)은 제외하고 뽑음
    if (character.equippedAccessory != null) {
      final relics = RelicDatabase.allRelics
          .where((r) => r.rarity != RelicRarity.boss)
          .toList();
      if (relics.isNotEmpty) {
        starterRelic = relics[math.Random().nextInt(relics.length)];
      }
    }

    // ── [스트릭 보너스] 7일: 카드 선택 1회 추가 (덱에 랜덤 좋은 카드 1장) ─────
    if (character.streak >= 7) {
      final uncommonCards = CardDatabase.getCardsByRarity(CardRarity.uncommon);
      if (uncommonCards.isNotEmpty) {
        deck.add(uncommonCards[math.Random().nextInt(uncommonCards.length)]);
      }
    }

    // ── [스트릭 보너스] 14일: 렐릭 1개 무료 (H-3: 보스 렐릭 제외) ────────────
    if (character.streak >= 14 && starterRelic == null) {
      final relics = RelicDatabase.allRelics
          .where((r) => r.rarity != RelicRarity.boss)
          .toList();
      if (relics.isNotEmpty) {
        starterRelic = relics[math.Random().nextInt(relics.length)];
      }
    }

    context.read<DungeonState>().startRun(
      zone: zone,
      startingDeck: deck,
      playerMaxHp: playerMaxHp,
      ascension: _ascensionLevel,
      starterRelic: starterRelic,
      startingGold: startingGold,
      dailyModifier: dailyModifier,
    );

    if (!await dungeon.flushCheckpoint() || !context.mounted) return;
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const DungeonMapScreen()));
  }
}

class _AscensionSection extends StatelessWidget {
  final int ascensionLevel;
  final ValueChanged<int> onChanged;
  final bool isDark;

  const _AscensionSection({
    required this.ascensionLevel,
    required this.onChanged,
    required this.isDark,
  });

  List<String> _modifiers(AppLocalizations l10n) => [
    l10n.ascensionLevel1Modifier,
    l10n.ascensionLevel2Modifier,
    l10n.ascensionLevel3Modifier,
    l10n.ascensionLevel4Modifier,
    l10n.ascensionLevel5Modifier,
    l10n.ascensionLevel6Modifier,
    l10n.ascensionLevel7Modifier,
    l10n.ascensionLevel8Modifier,
    l10n.ascensionLevel9Modifier,
    l10n.ascensionLevel10Modifier,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final modifiers = _modifiers(l10n);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1A0033), const Color(0xFF0A0E21)]
              : [Colors.purple.shade50, Colors.white],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.purple.withValues(alpha: 0.5)
              : Colors.purple.shade200,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.whatshot, color: Colors.deepPurple, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.ascensionModeTitle,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: ascensionLevel > 0
                      ? Colors.deepPurple.withValues(alpha: 0.3)
                      : Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  ascensionLevel > 0
                      ? 'A$ascensionLevel'
                      : l10n.ascensionInactive,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: ascensionLevel > 0
                        ? Colors.purple.shade300
                        : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Slider
          Row(
            children: [
              Text(
                '0',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
              Expanded(
                child: Slider(
                  value: ascensionLevel.toDouble(),
                  min: 0,
                  max: 10,
                  divisions: 10,
                  activeColor: Colors.deepPurple,
                  inactiveColor: Colors.grey.withValues(alpha: 0.3),
                  label: 'A$ascensionLevel',
                  onChanged: (v) => onChanged(v.round()),
                ),
              ),
              Text(
                '10',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
            ],
          ),

          // Active modifiers list
          if (ascensionLevel > 0) ...[
            const SizedBox(height: 8),
            Text(
              l10n.ascensionActiveModifiers,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
            const SizedBox(height: 6),
            ...List.generate(ascensionLevel, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 13,
                      color: Colors.orange.shade400,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      modifiers[i],
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: isDark
                            ? Colors.orange.shade200
                            : Colors.orange.shade900,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ] else ...[
            Text(
              l10n.ascensionSliderHint,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Infinite Tower Button
// ─────────────────────────────────────────────

class _InfiniteTowerButton extends StatelessWidget {
  final bool isDark;

  const _InfiniteTowerButton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final charState = context.watch<CharacterState>();
    final bestFloor = charState.infiniteTowerFloor;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const InfiniteTowerScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF1A1A2E), const Color(0xFF2D1B00)]
                : [Colors.amber.shade50, Colors.deepOrange.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? Colors.amber.withValues(alpha: 0.5)
                : Colors.deepOrange.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.trending_up,
                color: Colors.amber,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.infiniteTowerTitle,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.infiniteTowerBestFloorDesc(bestFloor),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.amber),
          ],
        ),
      ),
    );
  }
}
