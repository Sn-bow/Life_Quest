import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/cloud_config.dart';
import '../../l10n/app_localizations.dart';
import 'ai_report_service.dart';

class AiReportButton extends StatelessWidget {
  final AiReportContent content;
  final Future<void> Function() onReported;
  const AiReportButton({
    super.key,
    required this.content,
    required this.onReported,
  });
  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    return TextButton.icon(
      icon: const Icon(PhosphorIcons.flag, size: 16),
      label: Text(s.lqReportSuggestion),
      onPressed: () async {
        if (!kLifeQuestCloudEnabled) {
          await showDialog<void>(
            context: context,
            builder: (_) => OfflineAiReportDialog(content: content),
          );
          return;
        }
        final response = await showDialog<AiReportResponse>(
          context: context,
          builder: (_) => _ReportDialog(content: content),
        );
        if (response == null || !context.mounted) return;
        final result = response.result;
        if (result != AiReportResult.failed) await onReported();
        if (!context.mounted) return;
        final messenger = ScaffoldMessenger.of(context);
        Navigator.pop(context);
        messenger.showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 12),
            action: response.receipt == null
                ? null
                : SnackBarAction(
                    label: s.lqReportCopyReceipt,
                    onPressed: () => Clipboard.setData(
                      ClipboardData(text: response.receipt!.reference),
                    ),
                  ),
            content: Text(switch (result) {
              AiReportResult.sent => s.lqReportSent,
              AiReportResult.preview => s.lqReportPreview,
              AiReportResult.failed => s.lqReportFailed,
            }),
          ),
        );
      },
    );
  }
}

/// Public APK feedback: the user reviews and copies only this suggestion.
/// Opening support never sends its text or claims a server receipt.
class OfflineAiReportDialog extends StatelessWidget {
  final AiReportContent content;
  const OfflineAiReportDialog({super.key, required this.content});
  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(s.lqReportSuggestion),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.lqReportManualDescription),
            const SizedBox(height: 16),
            SelectableText(
              '${content.title}\n${content.instruction}\n${content.reason}',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(s.close),
        ),
        TextButton(
          onPressed: () async {
            await Clipboard.setData(
              ClipboardData(
                text:
                    'Life Quest · Gemma 4 E2B · ${content.locale}\n${content.title}\n${content.instruction}\n${content.reason}',
              ),
            );
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(s.lqReportManualCopied)));
            }
          },
          child: Text(s.lqReportCopySuggestion),
        ),
        TextButton(
          onPressed: () async {
            await launchUrl(
              Uri.parse('https://sn-bow.github.io/Life_Quest/#contact'),
              mode: LaunchMode.externalApplication,
            );
          },
          child: Text(s.lqFeedbackTitle),
        ),
      ],
    );
  }
}

class _ReportDialog extends StatefulWidget {
  final AiReportContent content;
  const _ReportDialog({required this.content});
  @override
  State<_ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<_ReportDialog> {
  bool sending = false;
  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    return PopScope(
      canPop: !sending,
      child: AlertDialog(
        title: Text(s.lqReportSuggestion),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(s.lqReportBody),
              const SizedBox(height: 8),
              Text(s.lqReportRetention),
              const SizedBox(height: 16),
              Text(widget.content.title),
              Text(widget.content.instruction),
              const SizedBox(height: 8),
              Text(widget.content.reason),
              if (sending)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: LinearProgressIndicator(),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: sending ? null : () => Navigator.pop(context),
            child: Text(s.close),
          ),
          TextButton(
            onPressed: sending
                ? null
                : () async {
                    setState(() => sending = true);
                    final result = await const AiReportService().submit(
                      widget.content,
                    );
                    if (!context.mounted) return;
                    setState(() => sending = false);
                    Navigator.pop(context, result);
                  },
            child: Text(s.lqSendReport),
          ),
        ],
      ),
    );
  }
}
