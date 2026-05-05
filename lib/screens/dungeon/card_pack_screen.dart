import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/data/card_database.dart';
import 'package:life_quest_final_v2/data/card_localization.dart';
import 'package:life_quest_final_v2/models/card_data.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/widgets/soul_deck_card_view.dart';

/// 카드 팩 오픈 화면
/// 3장을 뽑아 보여주고, 1장을 선택하면 컬렉션에 추가됩니다.
class CardPackScreen extends StatefulWidget {
  const CardPackScreen({super.key});

  @override
  State<CardPackScreen> createState() => _CardPackScreenState();
}

class _CardPackScreenState extends State<CardPackScreen>
    with SingleTickerProviderStateMixin {
  List<CardData>? _drawnCards;
  int? _selectedIndex;
  bool _opening = false;
  bool _confirmed = false;
  late AnimationController _flipController;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  /// 팩 뽑기: 3장을 레어리티 가중치로 결정하며, 같은 회차 내 중복 ID 방지.
  List<CardData> _drawThreeCards(CharacterState charState) {
    final rng = Random();
    final result = <CardData>[];
    final usedIds = <String>{}; // M-2: 같은 팩 내 중복 방지

    for (int i = 0; i < 3; i++) {
      final roll = rng.nextDouble();
      CardRarity rarity;
      if (roll < 0.55) {
        rarity = CardRarity.common;
      } else if (roll < 0.85) {
        rarity = CardRarity.uncommon;
      } else if (roll < 0.97) {
        rarity = CardRarity.rare;
      } else {
        rarity = CardRarity.legendary;
      }

      // M-2: 이미 이번 팩에서 뽑힌 카드 ID 제외
      final pool = CardDatabase.getCardsByRarity(rarity)
          .where((c) => !c.isUpgraded && !usedIds.contains(c.id))
          .toList();

      // 풀이 비면 레어리티 관계없이 미중복 풀 전체에서 뽑음
      final fallbackPool = pool.isNotEmpty
          ? pool
          : CardDatabase.allCards
              .where((c) => !c.isUpgraded && !usedIds.contains(c.id))
              .toList();

      if (fallbackPool.isEmpty) break; // 모든 카드 소진 시 중단

      final card = fallbackPool[rng.nextInt(fallbackPool.length)];
      usedIds.add(card.id);
      result.add(card);
    }
    return result;
  }

  void _openPack() {
    final charState = context.read<CharacterState>();
    if (charState.cardPackCount <= 0) return;

    setState(() {
      _opening = true;
      _drawnCards = _drawThreeCards(charState);
      _selectedIndex = null;
      _confirmed = false;
    });

    _flipController.forward(from: 0);
  }

  void _confirmSelection() {
    if (_selectedIndex == null || _drawnCards == null) return;
    final charState = context.read<CharacterState>();
    final chosen = _drawnCards![_selectedIndex!];

    // 팩 차감 + 카드 해금
    charState.consumeCardPack(chosen.id);

    setState(() => _confirmed = true);

    final l10n = AppLocalizations.of(context)!;
    final chosenName = CardLocalization.localizedName(chosen, l10n);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '카드 획득: $chosenName',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: _rarityColor(chosen.rarity),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Color _rarityColor(CardRarity rarity) {
    switch (rarity) {
      case CardRarity.common:
        return Colors.grey.shade600;
      case CardRarity.uncommon:
        return Colors.green.shade700;
      case CardRarity.rare:
        return Colors.blue.shade700;
      case CardRarity.legendary:
        return Colors.amber.shade700;
    }
  }

  Color _rarityBorder(CardRarity rarity) {
    switch (rarity) {
      case CardRarity.common:
        return Colors.grey;
      case CardRarity.uncommon:
        return Colors.greenAccent;
      case CardRarity.rare:
        return Colors.lightBlueAccent;
      case CardRarity.legendary:
        return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final charState = context.watch<CharacterState>();
    final packCount = charState.cardPackCount;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0E21) : Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          '카드 팩',
          style: TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
            color: isDark ? const Color(0xFF00FFFF) : Colors.deepPurple,
          ),
        ),
        backgroundColor: isDark ? const Color(0xFF1D1E33) : Colors.white,
      ),
      body: Column(
        children: [
          // ── 상단: 보유 팩 수 + CP 정보 ──────────────────────────────
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1D1E33), const Color(0xFF2A1F4E)]
                    : [Colors.deepPurple.shade50, Colors.white],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF00FFFF).withValues(alpha: 0.3)
                    : Colors.deepPurple.shade200,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _infoChip(
                  icon: Icons.card_giftcard,
                  label: '보유 팩',
                  value: '$packCount개',
                  color: packCount > 0 ? Colors.amber : Colors.grey,
                  isDark: isDark,
                ),
                _infoChip(
                  icon: Icons.stars,
                  label: 'CP',
                  value: '${charState.cardPoints} / 10',
                  color: Colors.cyan,
                  isDark: isDark,
                ),
              ],
            ),
          ),

          // ── 팩 오픈 버튼 (팩이 있고 아직 열지 않았을 때) ──────────────
          if (!_opening) ...[
            const Spacer(),
            _PackOpenButton(
              packCount: packCount,
              isDark: isDark,
              onPressed: packCount > 0 ? _openPack : null,
            ),
            const Spacer(),
          ],

          // ── 뽑은 카드 3장 표시 ────────────────────────────────────────
          if (_opening && _drawnCards != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                _confirmed ? '카드를 획득했습니다!' : '카드를 선택하세요',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (i) {
                  final card = _drawnCards![i];
                  final isSelected = _selectedIndex == i;
                  return GestureDetector(
                    onTap: _confirmed
                        ? null
                        : () {
                            setState(() => _selectedIndex = i);
                          },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 94, // SoulDeckCardSize.reward._width 와 일치
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8), // 카드 ClipRRect(8) 과 일치
                        border: Border.all(
                          color: isSelected
                              ? _rarityBorder(card.rarity)
                              : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: _rarityBorder(card.rarity)
                                      .withValues(alpha: 0.6),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ]
                            : [],
                      ),
                      child: _CardTile(card: card),
                    ),
                  );
                }),
              ),
            ),
            // ── 확인 버튼 ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (!_confirmed)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed:
                            _selectedIndex != null ? _confirmSelection : null,
                        icon: const Icon(Icons.check_circle),
                        label: const Text(
                          '이 카드 선택',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  if (_confirmed) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: packCount > 0
                            ? () {
                                setState(() {
                                  _opening = false;
                                  _drawnCards = null;
                                  _selectedIndex = null;
                                  _confirmed = false;
                                });
                              }
                            : null,
                        icon: const Icon(Icons.refresh),
                        label: Text(
                          packCount > 0 ? '다음 팩 열기 ($packCount개 남음)' : '팩 없음',
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          '닫기',
                          style: TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 11,
            color: isDark ? Colors.white54 : Colors.black54,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? color : color.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 팩 오픈 버튼
// ─────────────────────────────────────────────────────────────
class _PackOpenButton extends StatelessWidget {
  final int packCount;
  final bool isDark;
  final VoidCallback? onPressed;

  const _PackOpenButton({
    required this.packCount,
    required this.isDark,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 팩 이미지 (아이콘으로 대체)
        Container(
          width: 140,
          height: 180,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: packCount > 0
                  ? [Colors.deepPurple.shade700, Colors.indigo.shade900]
                  : [Colors.grey.shade700, Colors.grey.shade900],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: packCount > 0
                  ? const Color(0xFF00FFFF).withValues(alpha: 0.7)
                  : Colors.grey.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: packCount > 0
                ? [
                    BoxShadow(
                      color: Colors.deepPurple.withValues(alpha: 0.5),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.card_giftcard,
                size: 60,
                color: packCount > 0 ? Colors.amber : Colors.grey.shade500,
              ),
              const SizedBox(height: 8),
              Text(
                'Soul Pack',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: packCount > 0 ? Colors.white : Colors.grey.shade500,
                ),
              ),
              Text(
                'x$packCount',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: packCount > 0 ? Colors.amber : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.auto_awesome),
          label: Text(
            packCount > 0 ? '팩 열기' : '팩이 없습니다',
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                packCount > 0 ? Colors.deepPurple : Colors.grey.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        if (packCount == 0)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              '퀘스트를 완료하면 CP를 얻을 수 있어요\n10 CP = 카드 팩 1개',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 카드 타일 위젯
// ─────────────────────────────────────────────────────────────
class _CardTile extends StatelessWidget {
  final CardData card;

  const _CardTile({required this.card});

  @override
  Widget build(BuildContext context) {
    return SoulDeckCardView(
      card: card,
      size: SoulDeckCardSize.reward,
    );
  }
}
