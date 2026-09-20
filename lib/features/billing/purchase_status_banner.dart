import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../services/purchase_service.dart';

class PurchaseStatusBanner extends StatelessWidget {
  const PurchaseStatusBanner({super.key});
  @override
  Widget build(BuildContext context) {
    final p = PurchaseService();
    return ListenableBuilder(
      listenable: p,
      builder: (context, _) {
        final l = AppLocalizations.of(context)!;
        final message = switch (p.phase) {
          PurchasePhase.pending => l.lqPurchasePending,
          PurchasePhase.verifying => l.lqPurchaseVerifying,
          PurchasePhase.granted => l.lqPurchaseGranted,
          PurchasePhase.cancelled => l.lqPurchaseCancelled,
          PurchasePhase.retry => l.lqPurchaseRetry,
          PurchasePhase.failed => l.lqPurchaseFailed,
          PurchasePhase.restoring => l.lqPurchaseRestoring,
          PurchasePhase.restoreFinished => l.lqPurchaseRestoreFinished,
          _ => null,
        };
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (message != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(message),
              ),
            TextButton.icon(
              onPressed: !p.isAvailable || p.busy ? null : p.restorePurchases,
              icon: const Icon(Icons.restore),
              label: Text(l.lqRestorePurchases),
            ),
          ],
        );
      },
    );
  }
}
