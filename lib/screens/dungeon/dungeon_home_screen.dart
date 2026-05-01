import 'dart:math' as math;
import 'package:flutter/material.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final charState = context.watch<CharacterState>();
    if (!charState.isDataLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final character = charState.character;
    final hasCompletedZone5 = charState.hasCompletedZone5;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.style,
                color: isDark ? const Color(0xFF00FFFF) : Colors.deepPurple,
                size: 24),
            const SizedBox(width: 8),
            Text(
              l10n.dungeonHomeTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xFF00FFFF) : Colors.deepPurple,
              ),
            ),
          ],
        ),
        actions: [
          // 카드 팩 버튼 (보유 팩 수 배지 표시)
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.card_giftcard,
                  color: charState.cardPackCount > 0
                      ? Colors.amber
                      : (isDark ? Colors.white54 : Colors.black45),
                ),
                tooltip: '카드 팩 (${charState.cardPackCount}개)',
                onPressed: charState.cardPackCount > 0
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CardPackScreen(),
                          ),
                        );
                      }
                    : null,
              ),
              if (charState.cardPackCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${charState.cardPackCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.collections_bookmark,
              color: isDark ? const Color(0xFF00FFFF) : Colors.deepPurple,
            ),
            tooltip: l10n.dungeonHomeCardCollectionTooltip,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CardCollectionScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Season banner ──
            _SeasonBanner(isDark: isDark),
            const SizedBox(height: 16),

            // ── Player info card ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1D1E33), const Color(0xFF0A0E21)]
                      : [Colors.deepPurple.shade50, Colors.white],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF00FFFF).withValues(alpha: 0.3)
                      : Colors.deepPurple.shade200,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${character.name} Lv.${character.level}',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _statChip('STR ${character.strength.toInt()}', Colors.red, isDark),
                      const SizedBox(width: 8),
                      _statChip('WIS ${character.wisdom.toInt()}', Colors.purple, isDark),
                      const SizedBox(width: 8),
                      _statChip('HP ${character.health.toInt()}', Colors.blue, isDark),
                      const SizedBox(width: 8),
                      _statChip('CHA ${character.charisma.toInt()}', Colors.amber, isDark),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // 던전 시작 골드 미리보기
                  Row(
                    children: [
                      Icon(Icons.monetization_on, size: 14,
                          color: isDark ? Colors.amber.shade300 : Colors.amber.shade700),
                      const SizedBox(width: 4),
                      Text(
                        '시작 골드: ${50 + (character.gold * 0.15).clamp(0, 150).toInt()}  (계정 골드 15% 반입)',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          color: isDark ? Colors.white54 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Ascension section (only if Zone 5 cleared) ──
            if (hasCompletedZone5) ...[
              _AscensionSection(
                ascensionLevel: _ascensionLevel,
                onChanged: (level) => setState(() => _ascensionLevel = level),
                isDark: isDark,
              ),
              const SizedBox(height: 24),
            ],

            // ── Zone selection ──
            Text(
              l10n.dungeonHomeDungeonSelection,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            _zoneCard(
              context: context,
              zone: 1,
              name: l10n.zone1Name,
              description: l10n.zone1Description,
              icon: Icons.grass,
              color: Colors.green,
              isLocked: false,
              requiredLevel: 1,
              isDark: isDark,
              isCompleted: charState.completedZones.contains(1),
            ),
            const SizedBox(height: 8),

            _zoneCard(
              context: context,
              zone: 2,
              name: l10n.zone2Name,
              description: l10n.zone2Description,
              icon: Icons.forest,
              color: Colors.teal,
              isLocked: character.level < 5,
              requiredLevel: 5,
              isDark: isDark,
              isCompleted: charState.completedZones.contains(2),
            ),
            const SizedBox(height: 8),

            _zoneCard(
              context: context,
              zone: 3,
              name: l10n.zone3Name,
              description: l10n.zone3Description,
              icon: Icons.castle,
              color: Colors.blueGrey,
              isLocked: character.level < 10,
              requiredLevel: 10,
              isDark: isDark,
              isCompleted: charState.completedZones.contains(3),
            ),
            const SizedBox(height: 8),

            _zoneCard(
              context: context,
              zone: 4,
              name: l10n.zone4Name,
              description: l10n.zone4Description,
              icon: Icons.whatshot,
              color: Colors.deepOrange,
              isLocked: character.level < 20,
              requiredLevel: 20,
              isDark: isDark,
              isCompleted: charState.completedZones.contains(4),
            ),
            const SizedBox(height: 8),

            _zoneCard(
              context: context,
              zone: 5,
              name: l10n.zone5Name,
              description: l10n.zone5Description,
              icon: Icons.blur_on,
              color: Colors.deepPurple,
              isLocked: character.level < 30,
              requiredLevel: 30,
              isDark: isDark,
              isCompleted: charState.completedZones.contains(5),
            ),

            // ── Infinite Tower (only if Zone 5 cleared) ──
            if (hasCompletedZone5) ...[
              const SizedBox(height: 16),
              _InfiniteTowerButton(isDark: isDark),
            ],

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _statChip(String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isDark ? color : color.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _zoneCard({
    required BuildContext context,
    required int zone,
    required String name,
    required String description,
    required IconData icon,
    required Color color,
    required bool isLocked,
    required int requiredLevel,
    required bool isDark,
    bool isCompleted = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: isLocked
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.dungeonHomeRequiredLevel(requiredLevel),
                      style: const TextStyle(fontFamily: 'monospace')),
                  backgroundColor: Colors.red.shade700,
                ),
              );
            }
          : () => _startBattle(context, zone),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isLocked
              ? (isDark ? Colors.grey.shade900 : Colors.grey.shade200)
              : (isDark
                  ? color.withValues(alpha: 0.15)
                  : color.withValues(alpha: 0.08)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isLocked
                ? Colors.grey.withValues(alpha: 0.3)
                : color.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isLocked
                    ? Colors.grey.withValues(alpha: 0.2)
                    : color.withValues(alpha: isDark ? 0.3 : 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isLocked ? Icons.lock : icon,
                color: isLocked ? Colors.grey : color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Zone $zone: $name',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isLocked
                              ? Colors.grey
                              : (isDark ? Colors.white : Colors.black87),
                        ),
                      ),
                      if (isLocked) ...[
                        const SizedBox(width: 8),
                        Text(
                          'Lv.$requiredLevel',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                      if (!isLocked && isCompleted) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.check_circle,
                            size: 14, color: Colors.green),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isLocked
                        ? l10n.dungeonHomeLockedHint(requiredLevel)
                        : description,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: isLocked
                          ? Colors.orange.shade400
                          : (isDark ? Colors.white60 : Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
            if (!isLocked)
              Icon(
                Icons.chevron_right,
                color: isDark ? color : color.withValues(alpha: 0.7),
              ),
          ],
        ),
      ),
    );
  }

  void _startBattle(BuildContext context, int zone) {
    final charState = context.read<CharacterState>();
    final character = charState.character;

    // ── 기본 HP ───────────────────────────────────────────────────────────
    int playerMaxHp = 80 + (character.health * 2).toInt();

    // ── [장비 보너스] 방어구 장착 → 시작 HP +방어력×2 ──────────────────────
    if (character.equippedArmor != null) {
      playerMaxHp += (character.equippedArmor!.defensePower * 2).toInt();
    }

    // ── 시작 골드: 기본 50 + 계정 골드 15% 반입 ──────────────────────────
    int startingGold = 50 + (character.gold * 0.15).clamp(0, 150).toInt();

    // ── [스트릭 보너스] 시작 골드 추가 보정 ──────────────────────────────
    if (character.streak >= 3)  startingGold += 30;   // 3일: +30
    if (character.streak >= 7)  startingGold += 20;   // 7일: 추가 +20
    if (character.streak >= 14) startingGold += 30;   // 14일: 추가 +30

    // ── [장비 보너스] 무기 장착 → 시작 덱에 공격 카드 1장 추가 ─────────────
    RelicData? starterRelic;
    final deck = charState.starterDeck.toList();
    if (character.equippedWeapon != null) {
      // L-2: 항상 첫 번째 카드가 아닌 랜덤 선택
      final attackCards = CardDatabase.getCardsByCategory(CardCategory.attack)
          .where((c) => c.rarity == CardRarity.common && !c.isUpgraded)
          .toList();
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
        );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DungeonMapScreen(),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Season Banner
// ─────────────────────────────────────────────

/// 시즌 종료일을 변경하려면 이 날짜를 수정하세요.
final _seasonEndDate = DateTime(2027, 3, 31);

class _SeasonBanner extends StatelessWidget {
  final bool isDark;

  const _SeasonBanner({required this.isDark});

  String _buildCountdown(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final diff = _seasonEndDate.difference(now);
    if (diff.isNegative) return l10n.seasonEnded;
    final days = diff.inDays;
    if (days == 0) return 'D-Day';
    return l10n.seasonCountdown(days);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE65100), Color(0xFF6A1B9A)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text('🔥', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                l10n.seasonName,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _buildCountdown(context),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Ascension Section
// ─────────────────────────────────────────────

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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: ascensionLevel > 0
                      ? Colors.deepPurple.withValues(alpha: 0.3)
                      : Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  ascensionLevel > 0 ? 'A$ascensionLevel' : l10n.ascensionInactive,
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
                    Icon(Icons.warning_amber_rounded,
                        size: 13, color: Colors.orange.shade400),
                    const SizedBox(width: 6),
                    Text(
                      modifiers[i],
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: isDark ? Colors.orange.shade200 : Colors.orange.shade900,
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
          MaterialPageRoute(
            builder: (context) => const InfiniteTowerScreen(),
          ),
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
              child: const Icon(Icons.trending_up,
                  color: Colors.amber, size: 28),
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
