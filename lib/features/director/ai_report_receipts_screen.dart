import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';
import 'ai_report_service.dart';

class AiReportReceiptsScreen extends StatefulWidget {
  final AiReportService service;
  const AiReportReceiptsScreen({
    super.key,
    this.service = const AiReportService(),
  });
  @override
  State<AiReportReceiptsScreen> createState() => _AiReportReceiptsScreenState();
}

class _AiReportReceiptsScreenState extends State<AiReportReceiptsScreen> {
  late Future<List<AiReportReceipt>> _receipts;
  bool _busy = false;
  @override
  void initState() {
    super.initState();
    _receipts = widget.service.receipts();
  }

  Future<void> _delete(AiReportReceipt receipt) async {
    final l = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        scrollable: true,
        title: Text(l.lqReportDelete),
        content: Text(l.lqReportDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.lqReportDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _busy = true);
    final success = await widget.service.delete(receipt);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _receipts = widget.service.receipts();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? l.lqReportDeleted : l.lqReportFailed)),
    );
  }

  Future<void> _deleteAnonymous() async {
    final l = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        scrollable: true,
        title: Text(l.lqReportDeleteIdentity),
        content: Text(l.lqReportDeleteIdentityBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.lqReportDeleteIdentity),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _busy = true);
    final accepted = await widget.service.deleteAnonymousIdentity();
    if (!mounted) return;
    setState(() {
      _busy = false;
      _receipts = widget.service.receipts();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(accepted ? l.lqReportIdentityDeleted : l.lqReportFailed),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return PopScope(
      canPop: !_busy,
      child: Scaffold(
        appBar: AppBar(title: Text(l.lqReportReceipts)),
        body: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: FutureBuilder<List<AiReportReceipt>>(
              future: _receipts,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: TextButton(
                      onPressed: () =>
                          setState(() => _receipts = widget.service.receipts()),
                      child: Text(l.lqRetry),
                    ),
                  );
                }
                final records = snapshot.data ?? [];
                return ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Text(l.lqReportRetention),
                    const SizedBox(height: 12),
                    Text(l.lqReportReceiptHelp),
                    const SizedBox(height: 20),
                    if (widget.service.canDeleteAnonymousIdentity)
                      OutlinedButton(
                        onPressed: _busy ? null : _deleteAnonymous,
                        child: Text(l.lqReportDeleteIdentity),
                      ),
                    if (_busy) const LinearProgressIndicator(),
                    if (records.isEmpty) Text(l.lqReportReceiptsEmpty),
                    for (final receipt in records)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                MaterialLocalizations.of(
                                  context,
                                ).formatMediumDate(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    receipt.createdAt,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              SelectableText(receipt.reference),
                              TextButton.icon(
                                onPressed: () => Clipboard.setData(
                                  ClipboardData(text: receipt.reference),
                                ),
                                icon: const Icon(Icons.copy_outlined),
                                label: Text(l.lqReportCopyReceipt),
                              ),
                              if (widget.service.currentUid == receipt.ownerUid)
                                TextButton(
                                  onPressed: _busy
                                      ? null
                                      : () => _delete(receipt),
                                  child: Text(l.lqReportDelete),
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
