import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/screens/report_screen.dart';
import 'package:life_quest_final_v2/screens/settings_screen.dart';
import 'package:life_quest_final_v2/screens/timer_screen.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/state/combat_state.dart';
import 'package:life_quest_final_v2/widgets/player_avatar_view.dart';
import 'package:life_quest_final_v2/widgets/translucent_card.dart';
import 'package:life_quest_final_v2/widgets/xp_bar.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  // Pending stat allocation (not yet committed)
  Map<StatType, int> _pendingAlloc = {
    StatType.strength: 0,
    StatType.wisdom: 0,
    StatType.health: 0,
    StatType.charisma: 0,
  };

  int get _totalPending => _pendingAlloc.values.fold(0, (sum, v) => sum + v);

  bool get _hasPending => _totalPending > 0;

  Widget _buildAvatarPlaceholder(ThemeData theme, {double size = 120}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withValues(alpha: 0.04),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIcons.userCircle,
            size: size * 0.34,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(
            '캐릭터 리빌드 중',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.72),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _increment(StatType stat, int availableSP) {
    if (_totalPending < availableSP) {
      setState(() {
        _pendingAlloc[stat] = (_pendingAlloc[stat] ?? 0) + 1;
      });
    }
  }

  void _decrement(StatType stat) {
    if ((_pendingAlloc[stat] ?? 0) > 0) {
      setState(() {
        _pendingAlloc[stat] = (_pendingAlloc[stat] ?? 0) - 1;
      });
    }
  }

  void _applyAllocation(CharacterState characterState) {
    _pendingAlloc.forEach((stat, count) {
      for (int i = 0; i < count; i++) {
        characterState.spendStatPoint(stat);
      }
    });
    setState(() {
      _pendingAlloc = {
        StatType.strength: 0,
        StatType.wisdom: 0,
        StatType.health: 0,
        StatType.charisma: 0,
      };
    });
  }

  void _cancelAllocation() {
    setState(() {
      _pendingAlloc = {
        StatType.strength: 0,
        StatType.wisdom: 0,
        StatType.health: 0,
        StatType.charisma: 0,
      };
    });
  }

  void _showTitleSelectionDialog(
      BuildContext context, CharacterState characterState) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('칭호 변경'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: characterState.unlockedTitles.length,
              itemBuilder: (BuildContext context, int index) {
                final title = characterState.unlockedTitles[index];
                return ListTile(
                  title: Text(title.name),
                  subtitle: Text(title.description),
                  onTap: () {
                    characterState.changeTitle(title);
                    Navigator.of(dialogContext).pop();
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('닫기'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAvatarSelectionDialog(
      BuildContext context, CharacterState characterState) {
    final character = characterState.character;
    String selectedPreset = character.avatarPreset;
    String selectedGender = character.avatarGender;
    String selectedSkinTone = character.avatarSkinTone;
    String selectedHairStyle = character.avatarHairStyle;
    String selectedEyeStyle = character.avatarEyeStyle;
    String selectedEarStyle = character.avatarEarStyle;
    String selectedNoseStyle = character.avatarNoseStyle;
    String selectedMouthStyle = character.avatarMouthStyle;
    String selectedOutfitStyle = character.avatarOutfitStyle;
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('내 캐릭터 꾸미기'),
          content: StatefulBuilder(
            builder: (context, setModalState) {
              Widget buildOptionSection(
                String title,
                List<AvatarOption> options,
                String selected,
                ValueChanged<String> onSelected,
              ) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: options.map((option) {
                        return ChoiceChip(
                          label: Text(option.label),
                          selected: selected == option.id,
                          onSelected: (_) => setModalState(() {
                            onSelected(option.id);
                          }),
                        );
                      }).toList(),
                    ),
                  ],
                );
              }

              return SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: _buildAvatarPlaceholder(
                          Theme.of(context),
                          size: 116,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '기본 스타일',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 114,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: playerAvatarPresets.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final preset = playerAvatarPresets[index];
                            final selected = selectedPreset == preset.id;
                            return InkWell(
                              onTap: () {
                                setModalState(() {
                                  selectedPreset = preset.id;
                                  selectedGender = preset.gender;
                                  selectedSkinTone = preset.skinTone;
                                  selectedHairStyle = preset.hairStyle;
                                  selectedEyeStyle = preset.eyeStyle;
                                  selectedEarStyle = preset.earStyle;
                                  selectedNoseStyle = preset.noseStyle;
                                  selectedMouthStyle = preset.mouthStyle;
                                  selectedOutfitStyle = preset.outfitStyle;
                                });
                              },
                              child: Container(
                                width: 106,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: selected
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.white.withValues(alpha: 0.08),
                                    width: selected ? 2 : 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 66,
                                      height: 66,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.white.withValues(alpha: 0.04),
                                      ),
                                      alignment: Alignment.center,
                                      child: Icon(
                                        PhosphorIcons.userCircle,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      preset.name,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      buildOptionSection(
                        '성별 스타일',
                        avatarGenderOptions,
                        selectedGender,
                        (value) => selectedGender = value,
                      ),
                      const SizedBox(height: 16),
                      buildOptionSection(
                        '피부 톤',
                        avatarSkinToneOptions,
                        selectedSkinTone,
                        (value) => selectedSkinTone = value,
                      ),
                      const SizedBox(height: 16),
                      buildOptionSection(
                        '머리',
                        avatarHairOptions,
                        selectedHairStyle,
                        (value) => selectedHairStyle = value,
                      ),
                      const SizedBox(height: 16),
                      buildOptionSection(
                        '눈',
                        avatarEyeOptions,
                        selectedEyeStyle,
                        (value) => selectedEyeStyle = value,
                      ),
                      const SizedBox(height: 16),
                      buildOptionSection(
                        '귀',
                        avatarEarOptions,
                        selectedEarStyle,
                        (value) => selectedEarStyle = value,
                      ),
                      const SizedBox(height: 16),
                      buildOptionSection(
                        '코',
                        avatarNoseOptions,
                        selectedNoseStyle,
                        (value) => selectedNoseStyle = value,
                      ),
                      const SizedBox(height: 16),
                      buildOptionSection(
                        '입',
                        avatarMouthOptions,
                        selectedMouthStyle,
                        (value) => selectedMouthStyle = value,
                      ),
                      const SizedBox(height: 16),
                      buildOptionSection(
                        '의상',
                        avatarOutfitOptions,
                        selectedOutfitStyle,
                        (value) => selectedOutfitStyle = value,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                characterState.updateAvatarLoadout(
                  presetId: selectedPreset,
                  gender: selectedGender,
                  skinTone: selectedSkinTone,
                  hairStyle: selectedHairStyle,
                  eyeStyle: selectedEyeStyle,
                  earStyle: selectedEarStyle,
                  noseStyle: selectedNoseStyle,
                  mouthStyle: selectedMouthStyle,
                  outfitStyle: selectedOutfitStyle,
                );
                Navigator.of(dialogContext).pop();
              },
              child: const Text('적용'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CharacterState>(
      builder: (context, characterState, child) {
        if (characterState.isLoading || !characterState.isDataLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final character = characterState.character;
        final theme = Theme.of(context);
        final int availableSP = character.statPoints;
        final int remainingSP = availableSP - _totalPending;
        final bool canUpgrade = remainingSP > 0;

        return Scaffold(
          appBar: AppBar(
            title: const Text('상태창'),
            actions: [
              IconButton(
                icon: const Icon(PhosphorIcons.timer),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TimerScreen()),
                  );
                },
                tooltip: '집중 타이머',
              ),
              IconButton(
                icon: const Icon(PhosphorIcons.gear),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()),
                  );
                },
                tooltip: '설정',
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TranslucentCard(
                  child: Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(48),
                        onTap: () =>
                            _showAvatarSelectionDialog(context, characterState),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            _buildAvatarPlaceholder(theme, size: 120),
                            Positioned(
                              right: -2,
                              bottom: -2,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  PhosphorIcons.pencilSimple,
                                  size: 14,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              character.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Builder(
                              builder: (context) {
                                TextStyle titleStyle =
                                    theme.textTheme.titleMedium ??
                                        const TextStyle();
                                if (character.equippedTitleEffect ==
                                    'title_effect_fire') {
                                  titleStyle = titleStyle.copyWith(
                                    color: Colors.deepOrange,
                                    shadows: [
                                      const Shadow(
                                          color: Colors.redAccent,
                                          blurRadius: 8)
                                    ],
                                  );
                                } else if (character.equippedTitleEffect ==
                                    'title_effect_sparkle') {
                                  titleStyle = titleStyle.copyWith(
                                    color: Colors.yellowAccent,
                                    shadows: [
                                      const Shadow(
                                          color: Colors.amber, blurRadius: 8)
                                    ],
                                  );
                                }

                                return InkWell(
                                  onTap: () => _showTitleSelectionDialog(
                                      context, characterState),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Lv. ${character.level} | ${character.title}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: titleStyle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(PhosphorIcons.caretDown,
                                          size: 16, color: Colors.grey),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(PhosphorIcons.chartBar,
                            color: theme.colorScheme.primary),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ReportScreen()),
                          );
                        },
                        tooltip: '상세 리포트 보기',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TranslucentCard(
                  child: XpBar(
                    currentXp: character.xp,
                    maxXp: character.maxXp,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                // HP Bar & Streak
                TranslucentCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.favorite,
                              color: Colors.red.shade400, size: 18),
                          const SizedBox(width: 8),
                          Text('HP',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade400)),
                          const Spacer(),
                          Text(
                            '${character.characterHp} / ${character.characterMaxHp}',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.red.shade400,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value:
                              character.characterHp / character.characterMaxHp,
                          minHeight: 8,
                          backgroundColor: theme.brightness == Brightness.dark
                              ? Colors.grey.shade800
                              : Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            character.characterHp >
                                    character.characterMaxHp * 0.3
                                ? Colors.red.shade400
                                : Colors.red.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '비전투 상태에서는 10분마다 HP가 조금씩 자연 회복됩니다.',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.brightness == Brightness.dark
                              ? Colors.white60
                              : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            character.streak > 0
                                ? Icons.local_fire_department
                                : Icons.ac_unit,
                            color: character.streak > 0
                                ? Colors.orange.shade400
                                : Colors.blue.shade200,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '연속 달성: ${character.streak}일',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: character.streak > 0
                                  ? Colors.orange.shade400
                                  : (theme.brightness == Brightness.dark
                                      ? Colors.white38
                                      : Colors.grey),
                            ),
                          ),
                          if (character.streak > 0) ...[
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade400
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'XP +${(character.streak * 10).clamp(0, 50)}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade400,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                TranslucentCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        PhosphorIcons.sparkle,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '레벨업 시 3포인트는 최근 완료한 퀘스트 성향에 따라 자동 성장하고, 나머지 포인트만 직접 분배합니다.',
                          style: TextStyle(
                            height: 1.45,
                            color: theme.brightness == Brightness.dark
                                ? Colors.white70
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Gold & AP resource card
                TranslucentCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.monetization_on,
                                color: Colors.amber.shade400, size: 20),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('골드',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            theme.brightness == Brightness.dark
                                                ? Colors.white54
                                                : Colors.black45)),
                                Text(
                                  '${character.gold}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 36,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white12
                            : Colors.grey.shade300,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bolt,
                                color: theme.colorScheme.primary, size: 20),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('행동력',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            theme.brightness == Brightness.dark
                                                ? Colors.white54
                                                : Colors.black45)),
                                Text(
                                  '${character.actionPoints} / ${character.maxActionPoints}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                TranslucentCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('기본 스탯', style: theme.textTheme.titleLarge),
                          if (availableSP > 0)
                            Row(
                              children: [
                                Text(
                                  'SP: $remainingSP / $availableSP',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                if (_hasPending) ...[
                                  const SizedBox(width: 4),
                                  Text(
                                    '(-$_totalPending)',
                                    style: TextStyle(
                                      color: Colors.orange.shade400,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Keep detailed stats free. Ads should focus on optional
                      // acceleration rather than basic information access.
                      Center(
                        child: TextButton.icon(
                          icon: Icon(Icons.analytics,
                              color: theme.colorScheme.primary),
                          label: Text('상세 스탯 보기',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                              )),
                          onPressed: () async {
                            if (context.mounted) {
                              final char = character;
                              final attack =
                                  CombatState.effectiveAttack(char).round();
                              final defense =
                                  CombatState.effectiveDefense(char).round();
                              final crit =
                                  (CombatState.critChance(char) * 100)
                                      .toStringAsFixed(1);
                              final dodge =
                                  (CombatState.dodgeChance(char) * 100)
                                      .toStringAsFixed(1);

                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('📊 상세 전투 스탯'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(
                                            Icons.sports_martial_arts,
                                            color: Colors.red),
                                        title: const Text('공격력 (Attack)'),
                                        trailing: Text('$attack',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.shield,
                                            color: Colors.blue),
                                        title: const Text('방어력 (Defense)'),
                                        trailing: Text('$defense',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.flash_on,
                                            color: Colors.orange),
                                        title: const Text('치명타율 (Crit Chance)'),
                                        trailing: Text('$crit%',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                            Icons.directions_run,
                                            color: Colors.green),
                                        title: const Text('회피율 (Dodge Chance)'),
                                        trailing: Text('$dodge%',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('닫기'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      // ------------------------------------
                      _buildStatRow(
                        stat: StatType.strength,
                        label: '힘',
                        baseValue: character.strength,
                        icon: Icon(PhosphorIcons.barbell,
                            color: Colors.red.shade400),
                        color: Colors.red.shade400,
                        canUpgrade: canUpgrade,
                        availableSP: availableSP,
                        theme: theme,
                      ),
                      const SizedBox(height: 12),
                      _buildStatRow(
                        stat: StatType.wisdom,
                        label: '지혜',
                        baseValue: character.wisdom,
                        icon: Icon(PhosphorIcons.brain,
                            color: Colors.blue.shade400),
                        color: Colors.blue.shade400,
                        canUpgrade: canUpgrade,
                        availableSP: availableSP,
                        theme: theme,
                      ),
                      const SizedBox(height: 12),
                      _buildStatRow(
                        stat: StatType.health,
                        label: '건강',
                        baseValue: character.health,
                        icon: Icon(PhosphorIcons.heart,
                            color: Colors.green.shade400),
                        color: Colors.green.shade400,
                        canUpgrade: canUpgrade,
                        availableSP: availableSP,
                        theme: theme,
                      ),
                      const SizedBox(height: 12),
                      _buildStatRow(
                        stat: StatType.charisma,
                        label: '매력',
                        baseValue: character.charisma,
                        icon: Icon(PhosphorIcons.sparkle,
                            color: Colors.purple.shade400),
                        color: Colors.purple.shade400,
                        canUpgrade: canUpgrade,
                        availableSP: availableSP,
                        theme: theme,
                      ),
                      // Apply / Cancel buttons
                      if (_hasPending) ...[
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _cancelAllocation,
                                icon: const Icon(PhosphorIcons.x, size: 18),
                                label: const Text('취소'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.redAccent,
                                  side:
                                      const BorderSide(color: Colors.redAccent),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    _showApplyConfirmDialog(characterState),
                                icon: const Icon(PhosphorIcons.check, size: 18),
                                label: const Text('적용'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor:
                                      theme.brightness == Brightness.dark
                                          ? Colors.black
                                          : Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatRow({
    required StatType stat,
    required String label,
    required double baseValue,
    required Icon icon,
    required Color color,
    required bool canUpgrade,
    required int availableSP,
    required ThemeData theme,
  }) {
    final pending = _pendingAlloc[stat] ?? 0;
    final displayValue = baseValue + pending;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            icon,
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            Text(
              displayValue.toStringAsFixed(0),
              style: const TextStyle(fontSize: 16),
            ),
            if (pending > 0)
              Text(
                ' (+$pending)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade400,
                ),
              ),
            const SizedBox(width: 8),
            // Minus button
            SizedBox(
              width: 48,
              height: 48,
              child: pending > 0
                  ? IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                      iconSize: 24,
                      icon: const Icon(PhosphorIcons.minusCircle,
                          color: Colors.redAccent),
                      onPressed: () => _decrement(stat),
                    )
                  : null,
            ),
            // Plus button
            SizedBox(
              width: 48,
              height: 48,
              child: canUpgrade
                  ? IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                      iconSize: 24,
                      icon: Icon(PhosphorIcons.plusCircle,
                          color: theme.colorScheme.primary),
                      onPressed: () => _increment(stat, availableSP),
                    )
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: displayValue / 100.0,
            minHeight: 10,
            backgroundColor:
                isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  void _showApplyConfirmDialog(CharacterState characterState) {
    final allocSummary =
        _pendingAlloc.entries.where((e) => e.value > 0).map((e) {
      String name;
      switch (e.key) {
        case StatType.strength:
          name = '힘';
          break;
        case StatType.wisdom:
          name = '지혜';
          break;
        case StatType.health:
          name = '건강';
          break;
        case StatType.charisma:
          name = '매력';
          break;
      }
      return '$name +${e.value}';
    }).join(', ');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('스탯 적용 확인'),
        content:
            Text('다음 스탯을 적용하시겠습니까?\n\n$allocSummary\n\n적용 후에는 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              _applyAllocation(characterState);
              Navigator.of(ctx).pop();
            },
            child: const Text('적용'),
          ),
        ],
      ),
    );
  }
}

