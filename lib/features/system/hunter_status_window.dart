import '../journeys/journey_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../../data/title_localization.dart';
import '../../data/guest_name_localization.dart';
import '../director/quest_director_engine.dart';
import '../director/quest_director_state.dart';
import '../../l10n/app_localizations.dart';
import '../../models/quest.dart';
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

  void _openPlus(BuildContext context) => Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => const StatusPackScreen()));

  String _plusLabel(BuildContext context) => _label(context, [
    '상태창 외관 · 성장 분석',
    'Status looks & growth insights',
    'ステータス外観・成長分析',
    '狀態視窗外觀・成長分析',
  ]);

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Listenable.merge([StatusSkinStore.instance, PurchaseService()]),
    builder: (context, _) => _buildWindow(context),
  );

  Widget _buildWindow(BuildContext context) {
    final profile = state.character;
    final director = context.watch<QuestDirectorState>();
    final copy = SystemCopy(context);
    final l = AppLocalizations.of(context)!;
    final ownsPlus = PurchaseService().ownsStatusWindowPlus;
    final hasFirstRecord =
        state.questCompletionCount > 0 ||
        state.systemJournal.receipts.isNotEmpty ||
        profile.level > 1 ||
        profile.xp > 0;
    final firstAccepted = !hasFirstRecord
        ? state.dailyQuests
              .where(
                (quest) =>
                    quest.scheduledDay == localDay(DateTime.now()) &&
                    !quest.isCompleted,
              )
              .firstOrNull
        : null;
    final firstSuggestion =
        !hasFirstRecord && firstAccepted == null && director.ready
        ? director.suggestions.firstOrNull
        : null;
    final media = MediaQuery.of(context);
    // Keep the complete status frame in view on short, normally-scaled phones.
    // Large text and tablets keep the spacious, scrollable layout.
    final compact =
        media.size.width <= 430 &&
        media.size.height <= 820 &&
        media.textScaler.scale(16) <= 19;
    final shortPhone = compact && media.size.height <= 680;
    final sectionGap = shortPhone ? 12.0 : (compact ? 18.0 : 28.0);
    final statRowGap = shortPhone ? 6.0 : (compact ? 10.0 : 12.0);
    return HunterSystemFrame(
      key: const ValueKey('hunter-status-window'),
      padding: compact
          ? const EdgeInsets.fromLTRB(28, 22, 28, 21)
          : const EdgeInsets.fromLTRB(36, 36, 36, 44),
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
                    fontSize: compact ? 17 : 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ),
              if (compact && ownsPlus)
                Semantics(
                  label: _plusLabel(context),
                  child: TextButton.icon(
                    key: const ValueKey('status-plus-open'),
                    onPressed: () => _openPlus(context),
                    style: TextButton.styleFrom(
                      foregroundColor: _accent,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      minimumSize: const Size(70, 40),
                    ),
                    icon: const Icon(PhosphorIcons.sparkle, size: 14),
                    label: const Text(
                      'PLUS',
                      style: TextStyle(fontSize: 10, letterSpacing: 1),
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
                constraints: compact
                    ? const BoxConstraints.tightFor(width: 40, height: 40)
                    : null,
                padding: compact ? EdgeInsets.zero : null,
              ),
            ],
          ),
          Divider(height: compact ? 8 : 12),
          _menu(context, copy, compact: compact),
          SizedBox(height: shortPhone ? 6 : (compact ? 16 : 28)),
          if (section == HunterWindowSection.status) ...[
            if (compact)
              Row(
                children: [
                  Text(
                    'Lv. ${profile.level}',
                    key: const ValueKey('hunter-level'),
                    style: TextStyle(
                      color: _accent,
                      fontSize: 29,
                      fontWeight: FontWeight.w500,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      GuestNameLocalization.displayName(profile, l),
                      key: const ValueKey('hunter-name'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              )
            else
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
                    GuestNameLocalization.displayName(profile, l),
                    key: const ValueKey('hunter-name'),
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            SizedBox(height: compact ? 6 : 13),
            _field(
              _label(context, ['칭호', 'Title', '称号', '稱號']),
              TitleLocalization.localizedStoredName(profile.title, l),
              compact: compact,
            ),
            SizedBox(height: shortPhone ? 8 : (compact ? 14 : 24)),
            Text(
              '${xpText(profile.xp)} / ${xpText(profile.maxXp)} XP',
              key: const ValueKey('hunter-xp'),
              style: TextStyle(
                color: _ink,
                fontSize: compact ? 14 : 15,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            SizedBox(height: compact ? 5 : 9),
            LinearProgressIndicator(
              value: profile.maxXp <= 0
                  ? 0
                  : (profile.xp / profile.maxXp).clamp(0.0, 1.0),
              minHeight: compact ? 3 : 4,
              color: _accent,
              backgroundColor: const Color(0xFF193448),
              semanticsLabel: 'XP',
            ),
            if (state.journeys.active != null) ...[
              SizedBox(height: sectionGap),
              JourneyStatusCard(compact: compact),
            ] else if (firstAccepted != null || firstSuggestion != null) ...[
              SizedBox(height: sectionGap),
              _firstQuest(
                context,
                accepted: firstAccepted,
                suggested: firstSuggestion,
              ),
            ],
            SizedBox(height: sectionGap),
            if (compact)
              for (var row = 0; row < 2; row++) ...[
                if (row > 0) SizedBox(height: statRowGap),
                Row(
                  children: [
                    Expanded(child: _stat(context, row * 2, compact: true)),
                    const SizedBox(width: 20),
                    Expanded(child: _stat(context, row * 2 + 1, compact: true)),
                  ],
                ),
              ]
            else
              for (var i = 0; i < 4; i++) ...[
                if (i > 0) SizedBox(height: statRowGap),
                _stat(context, i),
              ],
            SizedBox(height: shortPhone ? 8 : (compact ? 12 : 20)),
            InkWell(
              key: const ValueKey('hunter-stat-points'),
              onTap: () => _details(context),
              child: Container(
                constraints: BoxConstraints(minHeight: compact ? 40 : 0),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: compact ? 6 : 12),
                child: _field(
                  _label(context, [
                    '미배분 포인트',
                    'Unspent points',
                    '未配分ポイント',
                    '未分配點數',
                  ]),
                  profile.statPoints.toString(),
                  color: profile.statPoints > 0 ? _accent : _ink,
                  compact: compact,
                ),
              ),
            ),
            if (state.journeys.active == null &&
                firstAccepted == null &&
                firstSuggestion == null) ...[
              SizedBox(height: sectionGap),
              JourneyStatusCard(compact: compact),
            ],
            if (!compact) ...[
              const Divider(height: 16),
              Text(
                '${copy.get('today')}  +${xpText(state.recordedXpToday)} XP',
                style: const TextStyle(color: _muted, fontSize: 12),
              ),
              if (ownsPlus) ...[
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  key: const ValueKey('status-plus-open'),
                  onPressed: () => _openPlus(context),
                  icon: const Icon(PhosphorIcons.sparkle, size: 16),
                  label: Text(_plusLabel(context)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _accent,
                    side: BorderSide(color: _accent.withValues(alpha: .35)),
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ],
            ],
          ] else if (child != null)
            child!,
        ],
      ),
    );
  }

  Widget _firstQuest(
    BuildContext context, {
    Quest? accepted,
    DirectedQuest? suggested,
  }) {
    final l = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final title = accepted?.name ?? suggested!.title(locale);
    final minutes = accepted?.estimatedMinutes ?? suggested?.minutes ?? 0;
    return Container(
      key: const ValueKey('status-first-quest'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF102B3B),
        border: Border.all(color: _accent.withValues(alpha: .5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.lqFirstQuest,
            style: TextStyle(
              color: _accent,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            title,
            key: const ValueKey('status-first-quest-title'),
            style: const TextStyle(
              color: _ink,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$minutes ${l.lqMinutes} · ${context.read<QuestDirectorState>().profile.configured ? l.lqFirstQuestNote : l.lqFirstQuestDefaultNote}',
            style: const TextStyle(color: _muted, fontSize: 12),
          ),
          const SizedBox(height: 12),
          FilledButton(
            key: const ValueKey('status-first-quest-action'),
            onPressed: accepted == null
                ? () => _acceptFirstQuest(context, suggested!, locale)
                : () => onSectionChanged(HunterWindowSection.quests),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(44),
              backgroundColor: _accent,
              foregroundColor: const Color(0xFF06131E),
            ),
            child: Text(
              accepted == null ? l.lqFirstQuestAccept : l.lqFirstQuestOpen,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _acceptFirstQuest(
    BuildContext context,
    DirectedQuest suggestion,
    String locale,
  ) async {
    final director = context.read<QuestDirectorState>();
    if (!director.ready ||
        !director.suggestions.any((q) => q.id == suggestion.id) ||
        !suggestion.id.startsWith('director:${localDay(DateTime.now())}:')) {
      return;
    }
    final title = suggestion.title(locale);
    final quest = Quest(
      id: suggestion.id,
      name: title,
      xp: suggestion.xp,
      type: QuestType.daily,
      category: suggestion.template.stat,
      difficulty: suggestion.difficulty,
      scheduledDay: localDay(DateTime.now()),
      directorTemplateId: suggestion.template.id,
      estimatedMinutes: suggestion.minutes,
      instruction: suggestion.generatedFor(locale)
          ? suggestion.instruction
          : null,
      directorReason: suggestion.generatedFor(locale)
          ? suggestion.reason
          : null,
      generatedLocale: suggestion.generatedFor(locale) ? locale : null,
    );
    if (!state.acceptDailySuggestion(quest)) return;
    // The quest is saved first. If the director preference write later fails,
    // MainScreen.reconcile restores its accepted state from this quest.
    if (!await state.forceSave()) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.lqStorageError)),
        );
      }
      return;
    }
    await director.accept(suggestion);
    if (!context.mounted) return;
    HapticFeedback.selectionClick();
    onSectionChanged(HunterWindowSection.quests);
  }

  Widget _menu(BuildContext context, SystemCopy copy, {bool compact = false}) {
    final labels = [
      copy.get('status'),
      _label(context, ['퀘스트', 'Quests', 'クエスト', '任務']),
      copy.get('journal'),
    ];
    final tabs = List.generate(HunterWindowSection.values.length, (i) {
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
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 9 : 11,
              vertical: compact ? 6 : 12,
            ),
            shape: const RoundedRectangleBorder(),
          ),
          onPressed: () => onSectionChanged(item),
          child: Text(labels[i], style: TextStyle(fontSize: compact ? 12 : 13)),
        ),
      );
    });
    return compact
        ? Row(
            children: [
              for (var i = 0; i < tabs.length; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                Expanded(child: tabs[i]),
              ],
            ],
          )
        : Wrap(spacing: 4, runSpacing: 4, children: tabs);
  }

  Widget _field(
    String label,
    String value, {
    Color color = _ink,
    bool compact = false,
  }) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (compact)
        Text(
          label,
          maxLines: 1,
          style: const TextStyle(color: _muted, fontSize: 12),
        )
      else
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: _muted, fontSize: 13),
          ),
        ),
      const SizedBox(width: 14),
      Flexible(
        fit: compact ? FlexFit.tight : FlexFit.loose,
        child: Text(
          value,
          maxLines: compact ? 1 : null,
          overflow: compact ? TextOverflow.ellipsis : null,
          textAlign: TextAlign.end,
          style: TextStyle(
            color: color,
            fontSize: compact ? 13 : 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  );

  Widget _stat(BuildContext context, int i, {bool compact = false}) {
    final c = state.character;
    final values = [c.strength, c.wisdom, c.health, c.charisma];
    final labels = statLabels(context);
    return InkWell(
      key: ValueKey('status-stat-$i'),
      onTap: () => _inspectStat(context, i, labels[i], values[i]),
      child: Container(
        constraints: BoxConstraints(minHeight: compact ? 40 : 48),
        padding: EdgeInsets.symmetric(vertical: compact ? 6 : 12),
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
                style: TextStyle(color: _ink, fontSize: compact ? 14 : 16),
              ),
            ),
            SizedBox(width: compact ? 8 : 16),
            Text(
              xpText(values[i]),
              style: TextStyle(
                color: _accent,
                fontSize: compact ? 18 : 21,
                fontWeight: FontWeight.w600,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            SizedBox(width: compact ? 6 : 10),
            Icon(
              PhosphorIcons.caretRight,
              size: compact ? 10 : 12,
              color: _muted,
            ),
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
