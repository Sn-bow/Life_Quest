import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../../config/monetization_config.dart';
import '../../../services/purchase_service.dart';
import '../../../state/character_state.dart';
import '../../billing/purchase_account_screen.dart';
import '../../billing/purchase_account_state.dart';
import '../../billing/purchase_verifier.dart';
import '../../system/system_journal.dart';
import '../../system/hunter_system_frame.dart';
import '../insights/status_growth_insights.dart';
import '../status_skin_store.dart';

typedef StatusPackSaveFile =
    Future<bool> Function(Uint8List bytes, String filename);

/// A one-time purchase for optional status looks and recorded-growth reports.
/// Purchase ownership comes only from the verified PurchaseService entitlement.
class StatusPackScreen extends StatelessWidget {
  const StatusPackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CharacterState>();
    final purchases = PurchaseService();
    final account = context.watch<PurchaseAccountState?>();
    return ListenableBuilder(
      listenable: Listenable.merge([purchases, StatusSkinStore.instance]),
      builder: (context, _) {
        final product = purchases.products
            .where((item) => item.id == statusWindowPlusProductId)
            .firstOrNull;
        return Theme(
          data: HunterSystemFrame.themeFor(context),
          child: Scaffold(
            backgroundColor: const Color(0xFF07131B),
            appBar: AppBar(
              title: Text(
                StatusPackCopy.forLocale(
                  Localizations.localeOf(context),
                ).t('title'),
              ),
              backgroundColor: const Color(0xFF07131B),
              foregroundColor: const Color(0xFFEAF9FF),
            ),
            body: StatusPackBody(
              receipts: state.systemJournal.receipts,
              owned: purchases.ownsStatusWindowPlus,
              product: product,
              canPurchase: purchases.isAvailable,
              monetizationEnabled: kLifeQuestMonetizationEnabled,
              checkingStore: purchases.checkingStore,
              purchaseBusy: purchases.busy,
              phase: purchases.phase,
              activeProduct: purchases.activeProduct,
              showAccountLink: account?.enabled == true && account?.uid == null,
              onBuy: product == null
                  ? null
                  : () => purchases.buyProduct(product),
              onRestore: purchases.restorePurchases,
              onRefreshCatalog: purchases.refreshCatalog,
            ),
          ),
        );
      },
    );
  }
}

@visibleForTesting
class StatusPackBody extends StatefulWidget {
  const StatusPackBody({
    super.key,
    required this.receipts,
    required this.owned,
    required this.product,
    required this.canPurchase,
    required this.monetizationEnabled,
    required this.checkingStore,
    required this.purchaseBusy,
    required this.phase,
    required this.activeProduct,
    required this.showAccountLink,
    required this.onBuy,
    required this.onRestore,
    required this.onRefreshCatalog,
    this.now,
    this.saveFile,
  });

  final List<GrowthReceipt> receipts;
  final bool owned;
  final ProductDetails? product;
  final bool canPurchase;
  final bool monetizationEnabled;
  final bool checkingStore;
  final bool purchaseBusy;
  final PurchasePhase phase;
  final String? activeProduct;
  final bool showAccountLink;
  final VoidCallback? onBuy;
  final VoidCallback onRestore;
  final VoidCallback onRefreshCatalog;
  final DateTime? now;
  final StatusPackSaveFile? saveFile;

  @override
  State<StatusPackBody> createState() => _StatusPackBodyState();
}

class _StatusPackBodyState extends State<StatusPackBody> {
  final _reportKey = GlobalKey();
  int _days = 30;
  bool _saving = false;
  bool _choosingLook = false;

  @override
  void initState() {
    super.initState();
    unawaited(StatusSkinStore.instance.load());
  }

  StatusGrowthInsights _insights() => StatusGrowthInsights.fromReceipts(
    widget.receipts,
    now: widget.now ?? DateTime.now(),
    days: _days,
  );

  Future<bool> _save(Uint8List bytes, String filename) =>
      widget.saveFile?.call(bytes, filename) ??
      FilePicker.saveFile(
        fileName: filename,
        bytes: bytes,
      ).then((path) => path != null);

  Future<void> _export(String format, StatusPackCopy copy) async {
    if (!widget.owned || _saving) return;
    setState(() => _saving = true);
    try {
      final insight = _insights();
      final suffix = '${_days}d-${insight.endDay}';
      late final Uint8List bytes;
      if (format == 'png') {
        // Captures the actual native report widget; no generated statistics or
        // hand-authored artwork are introduced by the export.
        // Setting the busy state above schedules a frame. Capture only after
        // it has painted so a rapid tap cannot snapshot a dirty boundary.
        await WidgetsBinding.instance.endOfFrame;
        if (!mounted) return;
        final boundary = _reportKey.currentContext?.findRenderObject();
        if (boundary is! RenderRepaintBoundary) {
          throw StateError('Report is not ready');
        }
        final image = await boundary.toImage(pixelRatio: 2);
        try {
          final data = await image.toByteData(format: ui.ImageByteFormat.png);
          if (data == null) throw StateError('PNG encode failed');
          bytes = data.buffer.asUint8List();
        } finally {
          image.dispose();
        }
      } else if (format == 'csv') {
        // A BOM helps spreadsheet apps identify multilingual UTF-8 exports.
        bytes = Uint8List.fromList(utf8.encode('\uFEFF${insight.toCsv()}'));
      } else {
        bytes = Uint8List.fromList(
          utf8.encode(insight.toTextSummary(copy.localeCode)),
        );
      }
      final saved = await _save(bytes, 'lifequest-growth-$suffix.$format');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(copy.t(saved ? 'saved' : 'cancelled'))),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(copy.t('saveFailed'))));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _selectLook(StatusWindowLook look, StatusPackCopy copy) async {
    if (_choosingLook || (look != StatusWindowLook.core && !widget.owned)) {
      return;
    }
    setState(() => _choosingLook = true);
    try {
      await StatusSkinStore.instance.select(look);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(copy.t('lookSaveFailed'))));
      }
    } finally {
      if (mounted) setState(() => _choosingLook = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final copy = StatusPackCopy.forLocale(Localizations.localeOf(context));
    final insight = _insights();
    final selected = StatusSkinStore.instance.effective(widget.owned);
    final phaseMessage = copy.phase(widget.phase);
    final pendingThis =
        widget.phase == PurchasePhase.pending &&
        widget.activeProduct == statusWindowPlusProductId;
    final purchaseReady =
        widget.monetizationEnabled &&
        widget.product != null &&
        widget.canPurchase &&
        !widget.purchaseBusy &&
        !widget.checkingStore &&
        !pendingThis;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      copy.t('systemTag'),
                      style: const TextStyle(
                        color: Color(0xFF80DEFF),
                        letterSpacing: 2.5,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      copy.t('title'),
                      style: const TextStyle(
                        color: Color(0xFFEAF9FF),
                        fontSize: 27,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(copy.t('pitch'), style: _bodyStyle),
                    const SizedBox(height: 12),
                    Text(
                      copy.t('oneTime'),
                      style: const TextStyle(color: Color(0xFF9BDABD)),
                    ),
                    const SizedBox(height: 6),
                    Text(copy.t('freeCore'), style: _smallStyle),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              _sectionTitle(copy.t('appearance')),
              const SizedBox(height: 8),
              Text(copy.t('appearanceHint'), style: _smallStyle),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (context, constraints) {
                  final cellWidth = constraints.maxWidth < 400
                      ? (constraints.maxWidth - 10) / 2
                      : (constraints.maxWidth - 30) / 4;
                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final look in StatusWindowLook.values)
                        SizedBox(
                          width: cellWidth,
                          child: _LookCard(
                            look: look,
                            label: copy.look(look),
                            selected: selected == look,
                            locked:
                                look != StatusWindowLook.core && !widget.owned,
                            choosing: _choosingLook,
                            copy: copy,
                            onTap: () => _selectLook(look, copy),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 26),
              _sectionTitle(copy.t('growth')),
              const SizedBox(height: 8),
              Text(copy.t('growthHint'), style: _smallStyle),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final days in [30, 90])
                    ChoiceChip(
                      key: ValueKey('growth-days-$days'),
                      label: Text(
                        copy.t(days == 30 ? 'thirtyDays' : 'ninetyDays'),
                      ),
                      selected: _days == days,
                      onSelected: (_) => setState(() => _days = days),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              if (!widget.owned)
                _Panel(
                  key: const ValueKey('locked-growth-preview'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.lock_outline,
                            color: Color(0xFF80DEFF),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              copy.t('lockedReport'),
                              style: _titleStyle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(copy.t('lockedExplain'), style: _bodyStyle),
                      const SizedBox(height: 10),
                      if (insight.coverageStart != null) ...[
                        Text(
                          copy.previewCount(insight.questCount, insight.days),
                          style: _titleStyle,
                        ),
                        const SizedBox(height: 6),
                      ],
                      Text(
                        insight.coverageStart == null
                            ? copy.t('noRecordYet')
                            : copy.recordStart(insight.coverageStart!),
                        style: _smallStyle,
                      ),
                    ],
                  ),
                )
              else ...[
                RepaintBoundary(
                  key: _reportKey,
                  child: _GrowthReport(
                    insight: insight,
                    copy: copy,
                    look: selected,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      key: const ValueKey('export-png'),
                      onPressed: _saving ? null : () => _export('png', copy),
                      icon: const Icon(Icons.image_outlined),
                      label: Text(copy.t('saveImage')),
                    ),
                    OutlinedButton.icon(
                      key: const ValueKey('export-txt'),
                      onPressed: _saving ? null : () => _export('txt', copy),
                      icon: const Icon(Icons.text_snippet_outlined),
                      label: Text(copy.t('saveText')),
                    ),
                    OutlinedButton.icon(
                      key: const ValueKey('export-csv'),
                      onPressed: _saving ? null : () => _export('csv', copy),
                      icon: const Icon(Icons.table_chart_outlined),
                      label: Text(copy.t('saveCsv')),
                    ),
                  ],
                ),
                if (_saving) const LinearProgressIndicator(),
              ],
              const SizedBox(height: 28),
              if (widget.owned)
                _Panel(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.verified_outlined,
                        color: Color(0xFF9BDABD),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(copy.t('owned'), style: _bodyStyle)),
                    ],
                  ),
                )
              else
                _Panel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(copy.t('purchaseTitle'), style: _titleStyle),
                      const SizedBox(height: 8),
                      Text(copy.t('purchaseContents'), style: _bodyStyle),
                      const SizedBox(height: 6),
                      Text(copy.t('noBoost'), style: _smallStyle),
                      const SizedBox(height: 16),
                      if (widget.showAccountLink) const PurchaseAccountTile(),
                      if (!widget.monetizationEnabled)
                        Text(copy.t('storeDisabled'), style: _smallStyle)
                      else if (widget.product == null) ...[
                        Text(copy.t('storeUnavailable'), style: _smallStyle),
                        TextButton.icon(
                          onPressed: widget.checkingStore || widget.purchaseBusy
                              ? null
                              : widget.onRefreshCatalog,
                          icon: const Icon(Icons.refresh),
                          label: Text(copy.t('retry')),
                        ),
                      ] else ...[
                        if (!widget.canPurchase)
                          Text(copy.t('accountRequired'), style: _smallStyle),
                        FilledButton(
                          key: const ValueKey('buy-status-plus'),
                          onPressed: purchaseReady ? widget.onBuy : null,
                          child: Text(copy.buyFor(widget.product!.price)),
                        ),
                      ],
                      if (widget.checkingStore || widget.purchaseBusy)
                        const LinearProgressIndicator(),
                      if (phaseMessage != null) ...[
                        const SizedBox(height: 10),
                        Text(phaseMessage, style: _smallStyle),
                      ],
                    ],
                  ),
                ),
              if (widget.monetizationEnabled) ...[
                const SizedBox(height: 10),
                TextButton.icon(
                  key: const ValueKey('restore-status-plus'),
                  onPressed:
                      widget.canPurchase &&
                          !widget.purchaseBusy &&
                          !widget.checkingStore
                      ? widget.onRestore
                      : null,
                  icon: const Icon(Icons.restore),
                  label: Text(copy.t('restore')),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

const _bodyStyle = TextStyle(color: Color(0xFFD8EAF3), height: 1.45);
const _smallStyle = TextStyle(
  color: Color(0xFF9CB8C7),
  height: 1.4,
  fontSize: 12,
);
const _titleStyle = TextStyle(
  color: Color(0xFFEAF9FF),
  fontSize: 17,
  fontWeight: FontWeight.w700,
);

Widget _sectionTitle(String text) => Text(
  text,
  style: const TextStyle(
    color: Color(0xFF80DEFF),
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: .6,
  ),
);

class _Panel extends StatelessWidget {
  const _Panel({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: const Color(0xFF0C202C),
      border: Border.all(color: const Color(0xFF30556A)),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(padding: const EdgeInsets.all(18), child: child),
  );
}

class _LookCard extends StatelessWidget {
  const _LookCard({
    required this.look,
    required this.label,
    required this.selected,
    required this.locked,
    required this.choosing,
    required this.copy,
    required this.onTap,
  });
  final StatusWindowLook look;
  final String label;
  final bool selected;
  final bool locked;
  final bool choosing;
  final StatusPackCopy copy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: selected ? const Color(0xFF17384A) : const Color(0xFF0C202C),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(9),
      side: BorderSide(
        color: selected ? look.accent : const Color(0xFF30556A),
        width: selected ? 2 : 1,
      ),
    ),
    child: InkWell(
      key: ValueKey('look-${look.name}'),
      borderRadius: BorderRadius.circular(9),
      onTap: locked || choosing ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Center(
                  child: Image.asset(
                    look.assetPath,
                    height: 92,
                    fit: BoxFit.contain,
                    excludeFromSemantics: true,
                  ),
                ),
                if (locked)
                  const Positioned(
                    right: 0,
                    top: 0,
                    child: Icon(
                      Icons.lock_outline,
                      size: 16,
                      color: Color(0xFFEAF9FF),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFFEAF9FF),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              look == StatusWindowLook.core
                  ? copy.t('free')
                  : selected
                  ? copy.t('selected')
                  : locked
                  ? copy.t('plus')
                  : copy.t('tapToApply'),
              style: _smallStyle,
            ),
          ],
        ),
      ),
    ),
  );
}

class _GrowthReport extends StatelessWidget {
  const _GrowthReport({
    required this.insight,
    required this.copy,
    required this.look,
  });
  final StatusGrowthInsights insight;
  final StatusPackCopy copy;
  final StatusWindowLook look;

  @override
  Widget build(BuildContext context) {
    final recent = insight.byDay.values.toList().reversed.take(14).toList()
      ..sort((a, b) => a.day.compareTo(b.day));
    final largestCategory = insight.categoryCounts.values.fold<int>(
      0,
      math.max,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final frameInset = (constraints.maxWidth * .09).clamp(26.0, 62.0);
        return Stack(
          key: const ValueKey('growth-report'),
          children: [
            Container(
              decoration: const BoxDecoration(color: Color(0xFF081723)),
              padding: EdgeInsets.fromLTRB(frameInset, 40, frameInset, 46),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    copy.t('reportTag'),
                    style: const TextStyle(
                      color: Color(0xFF80DEFF),
                      letterSpacing: 1.7,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(copy.reportTitle(insight.days), style: _titleStyle),
                  const SizedBox(height: 5),
                  Text(
                    '${insight.startDay} — ${insight.endDay}',
                    style: _smallStyle,
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 22,
                    runSpacing: 14,
                    children: [
                      _Metric(
                        copy.t('recordedQuests'),
                        '${insight.questCount}',
                      ),
                      _Metric('XP', _formatXp(insight.totalXp)),
                      _Metric(copy.t('activeDays'), '${insight.activeDays}'),
                      _Metric(copy.t('levelGain'), '+${insight.levelGain}'),
                      _Metric(
                        copy.t('longestStreak'),
                        '${insight.longestStreak}',
                      ),
                      _Metric(copy.t('gold'), '${insight.totalGold}'),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(copy.t('recordedByCategory'), style: _titleStyle),
                  const SizedBox(height: 4),
                  Text(copy.t('categoryScope'), style: _smallStyle),
                  const SizedBox(height: 10),
                  for (var i = 0; i < 4; i++) ...[
                    Text(
                      copy.categoryName(i),
                      style: TextStyle(
                        color: look.accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      copy.categoryLine(
                        insight.categoryCounts[i] ?? 0,
                        insight.categoryXp[i] ?? 0,
                      ),
                      style: _smallStyle,
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      minHeight: 3,
                      value: largestCategory == 0
                          ? 0
                          : (insight.categoryCounts[i] ?? 0) / largestCategory,
                      color: look.accent,
                      backgroundColor: const Color(0xFF2A4351),
                    ),
                    const SizedBox(height: 10),
                  ],
                  const SizedBox(height: 8),
                  Text(copy.t('recentDays'), style: _smallStyle),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (final day in recent)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 3),
                            child: Tooltip(
                              message: day.observed
                                  ? copy.dayTooltip(day.day, day.questCount)
                                  : copy.unknownDay(day.day),
                              child: Container(
                                height: 18,
                                decoration: BoxDecoration(
                                  color: !day.observed
                                      ? const Color(0xFF263B46)
                                      : day.questCount == 0
                                      ? const Color(0xFF436072)
                                      : const Color(0xFF80DEFF),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    insight.coverageStart == null
                        ? copy.t('noRecordYet')
                        : copy.coverage(insight.observedDays, insight.days),
                    style: _smallStyle,
                  ),
                  if (insight.partialHistory) ...[
                    const SizedBox(height: 6),
                    Text(copy.t('partialWarning'), style: _smallStyle),
                  ],
                  const SizedBox(height: 6),
                  Text(copy.t('privacyNote'), style: _smallStyle),
                ],
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: ExcludeSemantics(
                  child: Image.asset(
                    look.assetPath,
                    key: const ValueKey('report-frame'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric(this.label, this.value);
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 91,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFEAF9FF),
            fontSize: 21,
            fontWeight: FontWeight.w700,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
        Text(label, maxLines: 2, style: _smallStyle),
      ],
    ),
  );
}

String _formatXp(double value) =>
    value.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');

@visibleForTesting
class StatusPackCopy {
  const StatusPackCopy(this.localeCode);
  final String localeCode;

  static StatusPackCopy forLocale(Locale locale) {
    final lang = locale.languageCode;
    return StatusPackCopy({'ko', 'ja', 'zh'}.contains(lang) ? lang : 'en');
  }

  static const _strings = <String, Map<String, String>>{
    'ko': {
      'title': '상태창 확장팩',
      'systemTag': 'SYSTEM / PLUS',
      'pitch': '내 상태창을 바꾸고, 실제로 기록된 성장을 돌아보세요.',
      'oneTime': '한 번 구매 · 계정에서 구매 복원 가능',
      'freeCore': '퀘스트, 기본 상태창, 성장 보상은 계속 무료입니다.',
      'appearance': '상태창 외관',
      'appearanceHint': '원하는 상태창을 선택하세요. 기본 외관은 항상 무료입니다.',
      'core': '기본',
      'obsidian': '흑요석',
      'eclipse': '일식',
      'verdant': '청록',
      'free': '무료',
      'selected': '적용 중',
      'plus': 'PLUS',
      'tapToApply': '탭하여 적용',
      'lookSaveFailed': '외관을 저장하지 못했습니다.',
      'growth': '성장 기록',
      'growthHint': '저장된 퀘스트 완료 기록만 집계합니다.',
      'recordedByCategory': '분류별 완료 기록',
      'categoryScope': '각 분류로 완료한 퀘스트와 받은 XP입니다. 실제 능력 향상을 측정한 값은 아닙니다.',
      'strength': '힘',
      'wisdom': '지혜',
      'health': '건강',
      'charm': '매력',
      'thirtyDays': '최근 30일',
      'ninetyDays': '최근 90일',
      'lockedReport': '나의 성장 리포트',
      'lockedExplain': '구매 후 실제 완료 기록을 기준으로 XP, 활동일, 연속 활동과 레벨 상승을 볼 수 있습니다.',
      'noRecordYet': '아직 기록된 완료가 없습니다. 첫 퀘스트를 완료하면 기록이 시작됩니다.',
      'reportTag': 'RECORDED GROWTH',
      'recordedQuests': '기록된 퀘스트',
      'activeDays': '활동일',
      'levelGain': '레벨 상승',
      'longestStreak': '최장 연속 활동',
      'gold': '골드',
      'recentDays': '최근 14일 · 밝음: 완료 / 어두움: 완료 없음 / 회색: 기록 이전',
      'partialWarning': '기록 시작 전 활동은 복원되지 않아 이 기간의 일부만 표시됩니다.',
      'privacyNote': '내보내기에 퀘스트 제목은 포함되지 않습니다.',
      'saveImage': '이미지 저장',
      'saveText': '텍스트 저장',
      'saveCsv': 'CSV 저장',
      'saved': '기록을 저장했습니다.',
      'cancelled': '저장을 취소했습니다.',
      'saveFailed': '기록을 저장하지 못했습니다.',
      'owned': '확장팩을 보유 중입니다. 구매 내역으로 확인된 외관과 기록 기능을 사용할 수 있습니다.',
      'purchaseTitle': '상태창 확장팩 구매',
      'purchaseContents': '상태창 외관 3종 · 30/90일 성장 분석 · 이미지/텍스트/CSV 저장',
      'noBoost': '능력치나 XP 보너스는 포함되지 않습니다.',
      'storeDisabled': '이 빌드에서는 구매를 사용할 수 없습니다.',
      'storeUnavailable': 'Google Play 상품을 불러오지 못했습니다. 가격이 확인되면 구매할 수 있습니다.',
      'retry': '상품 다시 불러오기',
      'accountRequired': '구매와 복원을 위해 구매 계정을 연결하세요.',
      'restore': '구매 복원',
      'pending': 'Google Play에서 구매가 처리 중입니다.',
      'verifying': '구매를 확인하고 있습니다.',
      'granted': '구매가 확인되었습니다.',
      'cancelledPurchase': '구매가 취소되었습니다.',
      'retryVerification': '구매 확인을 다시 시도해야 합니다. 복원을 눌러주세요.',
      'purchaseFailed': '구매를 완료하지 못했습니다. 다시 시도할 수 있습니다.',
      'restoring': '구매 내역을 복원하고 있습니다.',
      'restoreFinished': '구매 내역 확인을 마쳤습니다.',
    },
    'en': {
      'title': 'Status Window Plus',
      'systemTag': 'SYSTEM / PLUS',
      'pitch':
          'Change the look of your status window and review your recorded growth.',
      'oneTime': 'One-time purchase · Restore with your account',
      'freeCore':
          'Quests, the core status window and growth rewards remain free.',
      'appearance': 'Status looks',
      'appearanceHint': 'Choose your window. The core look is always free.',
      'core': 'Core',
      'obsidian': 'Obsidian',
      'eclipse': 'Eclipse',
      'verdant': 'Verdant',
      'free': 'Free',
      'selected': 'Applied',
      'plus': 'PLUS',
      'tapToApply': 'Tap to apply',
      'lookSaveFailed': 'Could not save the look.',
      'growth': 'Growth record',
      'growthHint': 'Only saved quest completion records are counted.',
      'recordedByCategory': 'Recorded by category',
      'categoryScope':
          'Completed quests and XP earned in each category, not a measure of real-world ability.',
      'strength': 'Strength',
      'wisdom': 'Wisdom',
      'health': 'Health',
      'charm': 'Charm',
      'thirtyDays': 'Last 30 days',
      'ninetyDays': 'Last 90 days',
      'lockedReport': 'Your growth report',
      'lockedExplain':
          'After purchase, see XP, active days, streaks and level gains from your real completion records.',
      'noRecordYet':
          'No completions recorded yet. Your first completed quest starts the record.',
      'reportTag': 'RECORDED GROWTH',
      'recordedQuests': 'Recorded quests',
      'activeDays': 'Active days',
      'levelGain': 'Level gain',
      'longestStreak': 'Longest streak',
      'gold': 'Gold',
      'recentDays':
          'Last 14 days · bright: activity / dark: none / gray: unknown',
      'partialWarning':
          'Earlier activity cannot be recovered; only part of this window is recorded.',
      'privacyNote': 'Exports do not include quest titles.',
      'saveImage': 'Save image',
      'saveText': 'Save text',
      'saveCsv': 'Save CSV',
      'saved': 'Growth record saved.',
      'cancelled': 'Save cancelled.',
      'saveFailed': 'Could not save the growth record.',
      'owned':
          'You own this pack. Verified purchase unlocks the looks and recorded-growth report.',
      'purchaseTitle': 'Get Status Window Plus',
      'purchaseContents':
          'Three status looks · 30/90-day growth analysis · Image/text/CSV export',
      'noBoost': 'Does not include XP or stat boosts.',
      'storeDisabled': 'Purchases are unavailable in this build.',
      'storeUnavailable':
          'The Google Play product is unavailable. Purchase opens when its price loads.',
      'retry': 'Reload product',
      'accountRequired': 'Connect a purchase account to buy or restore.',
      'restore': 'Restore purchase',
      'pending': 'Google Play is processing the purchase.',
      'verifying': 'Verifying your purchase.',
      'granted': 'Purchase verified.',
      'cancelledPurchase': 'Purchase cancelled.',
      'retryVerification':
          'Purchase verification needs another try. Use Restore.',
      'purchaseFailed': 'Purchase could not be completed. You can retry.',
      'restoring': 'Restoring purchases.',
      'restoreFinished': 'Purchase history checked.',
    },
    'ja': {
      'title': 'ステータス画面 拡張パック',
      'systemTag': 'SYSTEM / PLUS',
      'pitch': '自分のステータス画面を着せ替えて、記録された成長を振り返れます。',
      'oneTime': '買い切り · アカウントから購入を復元できます',
      'freeCore': 'クエスト、基本のステータス画面、成長報酬は引き続き無料です。',
      'appearance': 'ステータス画面の外観',
      'appearanceHint': '好きな外観を選べます。基本デザインはいつでも無料です。',
      'core': '基本',
      'obsidian': '黒曜',
      'eclipse': '蝕',
      'verdant': '翡翠',
      'free': '無料',
      'selected': '適用中',
      'plus': 'PLUS',
      'tapToApply': 'タップして適用',
      'lookSaveFailed': '外観を保存できませんでした。',
      'growth': '成長の記録',
      'growthHint': '保存されたクエスト達成記録のみ集計します。',
      'recordedByCategory': '分類ごとの達成記録',
      'categoryScope': '各分類で達成したクエストと獲得 XP です。実際の能力向上を測るものではありません。',
      'strength': '筋力',
      'wisdom': '知恵',
      'health': '健康',
      'charm': '魅力',
      'thirtyDays': '過去30日',
      'ninetyDays': '過去90日',
      'lockedReport': '自分の成長レポート',
      'lockedExplain': '購入後、実際の達成記録から XP、活動日、連続活動、レベル上昇を確認できます。',
      'noRecordYet': '達成記録はまだありません。最初のクエスト達成から記録が始まります。',
      'reportTag': 'RECORDED GROWTH',
      'recordedQuests': '記録されたクエスト',
      'activeDays': '活動日',
      'levelGain': 'レベル上昇',
      'longestStreak': '最長連続活動',
      'gold': 'ゴールド',
      'recentDays': '直近14日 · 明: 達成 / 暗: 達成なし / 灰: 記録前',
      'partialWarning': '記録開始前の活動は復元できないため、この期間の一部のみ表示します。',
      'privacyNote': '書き出しにクエスト名は含まれません。',
      'saveImage': '画像を保存',
      'saveText': 'テキストを保存',
      'saveCsv': 'CSVを保存',
      'saved': '成長記録を保存しました。',
      'cancelled': '保存を取り消しました。',
      'saveFailed': '成長記録を保存できませんでした。',
      'owned': '拡張パックを所有しています。確認済みの購入で外観と成長レポートを利用できます。',
      'purchaseTitle': '拡張パックを購入',
      'purchaseContents': '外観3種 · 30/90日の成長分析 · 画像/テキスト/CSV保存',
      'noBoost': '能力値や XP の追加報酬はありません。',
      'storeDisabled': 'このビルドでは購入できません。',
      'storeUnavailable': 'Google Play の商品を読み込めませんでした。価格の取得後に購入できます。',
      'retry': '商品を再読み込み',
      'accountRequired': '購入・復元には購入用アカウントを接続してください。',
      'restore': '購入を復元',
      'pending': 'Google Play で購入を処理中です。',
      'verifying': '購入を確認しています。',
      'granted': '購入を確認しました。',
      'cancelledPurchase': '購入を取り消しました。',
      'retryVerification': '購入の確認が必要です。「購入を復元」を押してください。',
      'purchaseFailed': '購入できませんでした。もう一度お試しください。',
      'restoring': '購入履歴を復元しています。',
      'restoreFinished': '購入履歴を確認しました。',
    },
    'zh': {
      'title': '狀態視窗擴充包',
      'systemTag': 'SYSTEM / PLUS',
      'pitch': '替自己的狀態視窗換上新外觀，回顧實際記錄的成長。',
      'oneTime': '一次購買 · 可透過帳號還原購買',
      'freeCore': '任務、基本狀態視窗與成長獎勵仍可免費使用。',
      'appearance': '狀態視窗外觀',
      'appearanceHint': '選擇喜歡的視窗。基本外觀始終免費。',
      'core': '基本',
      'obsidian': '黑曜',
      'eclipse': '日蝕',
      'verdant': '翠綠',
      'free': '免費',
      'selected': '使用中',
      'plus': 'PLUS',
      'tapToApply': '點選套用',
      'lookSaveFailed': '無法儲存外觀。',
      'growth': '成長紀錄',
      'growthHint': '僅統計已儲存的任務完成紀錄。',
      'recordedByCategory': '各類別完成紀錄',
      'categoryScope': '各類別完成的任務與取得的 XP，並非實際能力提升的測量結果。',
      'strength': '力量',
      'wisdom': '智慧',
      'health': '健康',
      'charm': '魅力',
      'thirtyDays': '近30天',
      'ninetyDays': '近90天',
      'lockedReport': '我的成長報告',
      'lockedExplain': '購買後可依實際完成紀錄查看 XP、活躍天數、連續活動與升級次數。',
      'noRecordYet': '尚無完成紀錄。完成第一個任務後就會開始記錄。',
      'reportTag': 'RECORDED GROWTH',
      'recordedQuests': '已記錄任務',
      'activeDays': '活躍天數',
      'levelGain': '升級次數',
      'longestStreak': '最長連續活動',
      'gold': '金幣',
      'recentDays': '近14天 · 亮色：完成 / 暗色：未完成 / 灰色：尚無記錄',
      'partialWarning': '無法補回開始記錄前的活動，因此只顯示此期間的部分資料。',
      'privacyNote': '匯出內容不包含任務名稱。',
      'saveImage': '儲存圖片',
      'saveText': '儲存文字',
      'saveCsv': '儲存 CSV',
      'saved': '成長紀錄已儲存。',
      'cancelled': '已取消儲存。',
      'saveFailed': '無法儲存成長紀錄。',
      'owned': '你已擁有擴充包。完成驗證的購買可使用外觀與成長報告。',
      'purchaseTitle': '購買狀態視窗擴充包',
      'purchaseContents': '3 款外觀 · 30/90 天成長分析 · 圖片/文字/CSV 匯出',
      'noBoost': '不包含 XP 或能力值加成。',
      'storeDisabled': '此版本無法購買。',
      'storeUnavailable': '無法載入 Google Play 商品。取得價格後即可購買。',
      'retry': '重新載入商品',
      'accountRequired': '請連結購買帳號以購買或還原。',
      'restore': '還原購買',
      'pending': 'Google Play 正在處理購買。',
      'verifying': '正在驗證購買。',
      'granted': '購買已驗證。',
      'cancelledPurchase': '已取消購買。',
      'retryVerification': '需要再次驗證購買。請點選「還原購買」。',
      'purchaseFailed': '無法完成購買，請稍後重試。',
      'restoring': '正在還原購買。',
      'restoreFinished': '已確認購買紀錄。',
    },
  };

  String t(String key) => _strings[localeCode]?[key] ?? _strings['en']![key]!;
  String look(StatusWindowLook look) => t(look.name);
  String categoryName(int index) =>
      t(const ['strength', 'wisdom', 'health', 'charm'][index]);
  String categoryLine(int count, double xp) => switch (localeCode) {
    'ko' => '기록된 완료 $count건 · XP ${_formatXp(xp)}',
    'ja' => '記録された達成 $count件 · XP ${_formatXp(xp)}',
    'zh' => '已記錄完成 $count 個 · XP ${_formatXp(xp)}',
    _ => '$count recorded completions · XP ${_formatXp(xp)}',
  };
  String buyFor(String price) => switch (localeCode) {
    'ko' => '$price에 구매',
    'ja' => '$priceで購入',
    'zh' => '以 $price 購買',
    _ => 'Buy for $price',
  };
  String recordStart(String start) => switch (localeCode) {
    'ko' => '저장된 기록은 $start부터 시작합니다.',
    'ja' => '保存された記録は $start から始まります。',
    'zh' => '已儲存紀錄從 $start 開始。',
    _ => 'Saved records begin on $start.',
  };
  String previewCount(int count, int days) => switch (localeCode) {
    'ko' => '최근 $days일 · 기록된 완료 $count건',
    'ja' => '過去$days日 · 記録された達成$count件',
    'zh' => '近 $days 天 · 已記錄完成 $count 個',
    _ => 'Last $days days · $count recorded completions',
  };
  String reportTitle(int days) => switch (localeCode) {
    'ko' => '최근 $days일 성장 기록',
    'ja' => '過去$days日間の成長記録',
    'zh' => '近 $days 天成長紀錄',
    _ => '$days-day growth record',
  };
  String coverage(int observed, int days) => switch (localeCode) {
    'ko' => '$days일 중 기록 범위 $observed일',
    'ja' => '$days日間のうち記録対象 $observed日',
    'zh' => '$days 天中有 $observed 天在記錄範圍內',
    _ => '$observed of $days days within the recorded range',
  };
  String dayTooltip(String day, int count) => switch (localeCode) {
    'ko' => '$day · 기록된 퀘스트 $count개',
    'ja' => '$day · 記録されたクエスト $count件',
    'zh' => '$day · 已記錄任務 $count 個',
    _ => '$day · $count recorded quests',
  };
  String unknownDay(String day) => switch (localeCode) {
    'ko' => '$day · 기록 이전',
    'ja' => '$day · 記録前',
    'zh' => '$day · 尚無記錄',
    _ => '$day · before records began',
  };
  String? phase(PurchasePhase phase) => switch (phase) {
    PurchasePhase.pending => t('pending'),
    PurchasePhase.verifying => t('verifying'),
    PurchasePhase.granted => t('granted'),
    PurchasePhase.cancelled => t('cancelledPurchase'),
    PurchasePhase.retry => t('retryVerification'),
    PurchasePhase.failed => t('purchaseFailed'),
    PurchasePhase.restoring => t('restoring'),
    PurchasePhase.restoreFinished => t('restoreFinished'),
    _ => null,
  };
}
