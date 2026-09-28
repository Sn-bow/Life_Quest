import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../data/title_localization.dart';
import '../../l10n/app_localizations.dart';
import '../../screens/settings_screen.dart';
import '../../screens/status_screen.dart';
import '../../state/character_state.dart';
import '../../features/status_pack/status_skin_store.dart';
import '../../features/status_pack/ui/status_pack_screen.dart';
import '../../services/purchase_service.dart';
import 'system_copy.dart';
import 'hunter_system_frame.dart';
import 'system_widgets.dart';

enum HunterWindowSection { status, quests, journal }

/// The user's real profile is the face of the system. Raster art is decoration;
/// every value and control remains native, selectable, accessible Flutter UI.
class HunterStatusWindow extends StatelessWidget {
  final CharacterState state;
  final HunterWindowSection section;
  final ValueChanged<HunterWindowSection> onSectionChanged;
  final Widget? child;
  const HunterStatusWindow({
    super.key,
    required this.state,
    required this.section,
    required this.onSectionChanged,
    this.child,
  });

  static const _ink = Color(0xFFEDF8FF);
  static const _muted = Color(0xFF93B5C7);
  Color get _accent => StatusSkinStore.instance
      .effective(PurchaseService().ownsStatusWindowPlus)
      .accent;

  String _label(BuildContext context, List<String> labels) =>
      labels[SystemCopy(context).language];

  void _details(BuildContext context) => Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => const StatusScreen()));

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: StatusSkinStore.instance,
    builder: (context, _) => _buildWindow(context),
  );

  Widget _buildWindow(BuildContext context) {
    final profile = state.character;
    final copy = SystemCopy(context);
    final l = AppLocalizations.of(context)!;
    final equippedTitle = state.unlockedTitles
        .where((title) => title.name == profile.title)
        .firstOrNull;
    return HunterSystemFrame(
      key: const ValueKey('hunter-status-window'),
      padding: const EdgeInsets.fromLTRB(36, 36, 36, 44),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  copy.get('status'),
                  style: TextStyle(
                    color: _accent,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ),
              IconButton(
                tooltip: l.statusSettingsTooltip,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const SettingsScreen(),
                  ),
                ),
                icon: const Icon(PhosphorIcons.gear, color: _muted, size: 20),
              ),
            ],
          ),
          const Divider(height: 12),
          _menu(context, copy),
          const SizedBox(height: 20),
          if (section == HunterWindowSection.status) ...[
            Wrap(
              spacing: 20,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Lv. ${profile.level}',
                  key: const ValueKey('hunter-level'),
                  style: TextStyle(
                    color: _accent,
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                Text(
                  profile.name,
                  key: const ValueKey('hunter-name'),
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
            _field(
              _label(context, ['칭호', 'Title', '称号', '稱號']),
              equippedTitle == null
                  ? profile.title
                  : TitleLocalization.localizedName(equippedTitle.id, l),
            ),
            const SizedBox(height: 17),
            Text(
              '${xpText(profile.xp)} / ${xpText(profile.maxXp)} XP',
              key: const ValueKey('hunter-xp'),
              style: const TextStyle(
                color: _ink,
                fontSize: 15,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 9),
            LinearProgressIndicator(
              value: profile.maxXp <= 0
                  ? 0
                  : (profile.xp / profile.maxXp).clamp(0.0, 1.0),
              minHeight: 4,
              color: _accent,
              backgroundColor: const Color(0xFF193448),
              semanticsLabel: 'XP',
            ),
            const SizedBox(height: 19),
            for (var i = 0; i < 4; i++) _stat(context, i),
            const SizedBox(height: 12),
            InkWell(
              key: const ValueKey('hunter-stat-points'),
              onTap: () => _details(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: _field(
                  _label(context, [
                    '미배분 포인트',
                    'Unspent points',
                    '未配分ポイント',
                    '未分配點數',
                  ]),
                  profile.statPoints.toString(),
                  color: profile.statPoints > 0 ? _accent : _ink,
                ),
              ),
            ),
            const Divider(height: 16),
            Text(
              '${copy.get('today')}  +${xpText(state.recordedXpToday)} XP',
              style: const TextStyle(color: _muted, fontSize: 12),
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              key: const ValueKey('status-plus-open'),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const StatusPackScreen(),
                ),
              ),
              icon: Icon(
                PurchaseService().ownsStatusWindowPlus
                    ? PhosphorIcons.sparkle
                    : PhosphorIcons.lockSimple,
                size: 16,
              ),
              label: Text(
                _label(context, [
                  '상태창 외관 · 성장 분석',
                  'Status looks & growth insights',
                  'ステータス外観・成長分析',
                  '狀態視窗外觀・成長分析',
                ]),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: _accent,
                side: BorderSide(color: _accent.withValues(alpha: .35)),
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ] else if (child != null)
            child!,
        ],
      ),
    );
  }

  Widget _menu(BuildContext context, SystemCopy copy) {
    final labels = [
      copy.get('status'),
      _label(context, ['퀘스트', 'Quests', 'クエスト', '任務']),
      copy.get('journal'),
    ];
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: List.generate(HunterWindowSection.values.length, (i) {
        final item = HunterWindowSection.values[i];
        final selected = item == section;
        return Semantics(
          selected: selected,
          child: TextButton(
            key: ValueKey('${item.name}-tab'),
            style: TextButton.styleFrom(
              foregroundColor: selected ? _accent : _muted,
              backgroundColor: selected
                  ? const Color(0xFF102B3B)
                  : Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 12),
              shape: const RoundedRectangleBorder(),
            ),
            onPressed: () => onSectionChanged(item),
            child: Text(labels[i], style: const TextStyle(fontSize: 13)),
          ),
        );
      }),
    );
  }

  Widget _field(String label, String value, {Color color = _ink}) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Text(label, style: const TextStyle(color: _muted, fontSize: 13)),
      ),
      const SizedBox(width: 14),
      Flexible(
        child: Text(
          value,
          textAlign: TextAlign.end,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  );

  Widget _stat(BuildContext context, int i) {
    final c = state.character;
    final values = [c.strength, c.wisdom, c.health, c.charisma];
    final labels = statLabels(context);
    return InkWell(
      key: ValueKey('status-stat-$i'),
      onTap: () => _inspectStat(context, i, labels[i], values[i]),
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: _accent.withValues(alpha: .17)),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                labels[i],
                style: const TextStyle(color: _ink, fontSize: 16),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              xpText(values[i]),
              style: TextStyle(
                color: _accent,
                fontSize: 21,
                fontWeight: FontWeight.w600,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(PhosphorIcons.caretRight, size: 12, color: _muted),
          ],
        ),
      ),
    );
  }

  void _inspectStat(BuildContext context, int i, String label, double value) {
    final copy = SystemCopy(context);
    final descriptions = [
      [
        '운동과 신체 활동 퀘스트',
        'Exercise and physical activity quests',
        '運動や身体活動のクエスト',
        '運動與身體活動任務',
      ],
      ['학습과 지식 퀘스트', 'Learning and knowledge quests', '学習や知識のクエスト', '學習與知識任務'],
      ['건강과 회복 퀘스트', 'Health and recovery quests', '健康や休息のクエスト', '健康與恢復任務'],
      [
        '관계와 소통 퀘스트',
        'Relationships and communication quests',
        '交流やコミュニケーションのクエスト',
        '人際關係與溝通任務',
      ],
    ];
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheet) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label  ${xpText(value)}',
              style: Theme.of(sheet).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(_label(context, descriptions[i])),
            const SizedBox(height: 10),
            Text(
              _label(context, [
                '퀘스트 성장과 포인트 배분으로 쌓이는 앱 안의 능력치입니다.',
                'An in-app growth stat built through quests and point allocation.',
                'クエストによる成長とポイント配分で積み重なる、アプリ内の能力値です。',
                '透過完成任務與分配點數累積的 App 內能力值。',
              ]),
            ),
            const SizedBox(height: 22),
            FilledButton(
              onPressed: () {
                Navigator.pop(sheet);
                _details(context);
              },
              child: Text(copy.get('details')),
            ),
          ],
        ),
      ),
    );
  }
}
