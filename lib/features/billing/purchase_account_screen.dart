import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';
import 'purchase_account_state.dart';
import 'purchase_status_banner.dart';

class PurchaseAccountTile extends StatelessWidget {
  const PurchaseAccountTile({super.key});
  @override
  Widget build(BuildContext context) {
    final account = context.watch<PurchaseAccountState?>();
    if (account == null || !account.enabled) return const SizedBox.shrink();
    final l = AppLocalizations.of(context)!;
    return Card(
      child: ListTile(
        leading: const Icon(Icons.shopping_bag_outlined),
        title: Text(l.lqPurchaseAccount),
        subtitle: Text(
          account.uid == null
              ? l.lqPurchaseAccountOptional
              : l.lqPurchaseAccountConnected,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const PurchaseAccountScreen(),
          ),
        ),
      ),
    );
  }
}

class PurchaseAccountScreen extends StatelessWidget {
  const PurchaseAccountScreen({super.key});

  Future<void> _delete(
    BuildContext context,
    PurchaseAccountState account,
  ) async {
    final l = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        scrollable: true,
        title: Text(l.lqPurchaseAccountDelete),
        content: Text(l.lqPurchaseAccountDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.lqPurchaseAccountDelete),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) await account.deleteAccount();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final account = context.watch<PurchaseAccountState>();
    final deleted =
        account.status == PurchaseAccountStatus.deleted ||
        account.status == PurchaseAccountStatus.cleanupNeeded;
    return PopScope(
      canPop: !account.busy,
      child: Scaffold(
        appBar: AppBar(title: Text(l.lqPurchaseAccount)),
        body: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const Icon(Icons.lock_outline, size: 40),
                const SizedBox(height: 20),
                Text(
                  l.lqPurchaseAccountOptional,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(l.lqPurchaseAccountPrivacy),
                const SizedBox(height: 12),
                Text(l.lqPurchaseAccountRestoreHint),
                TextButton(
                  onPressed: () => launchUrl(
                    Uri.parse('https://sn-bow.github.io/Life_Quest/#privacy'),
                    mode: LaunchMode.externalApplication,
                  ),
                  child: Text(l.settingsPrivacyPolicy),
                ),
                if (account.signedInIdentity?.email case final email?)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      email,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                if (account.busy) ...[
                  const LinearProgressIndicator(),
                  const SizedBox(height: 16),
                ],
                if (account.status == PurchaseAccountStatus.failed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      l.lqPurchaseAccountFailed,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                if (deleted)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      account.status == PurchaseAccountStatus.cleanupNeeded
                          ? l.lqPurchaseAccountCleanup
                          : l.lqPurchaseAccountDeleted,
                    ),
                  ),
                if (!deleted && account.uid == null)
                  FilledButton(
                    onPressed: account.enabled && !account.busy
                        ? account.connect
                        : null,
                    child: Text(l.lqPurchaseAccountConnect),
                  ),
                if (account.uid != null) ...[
                  Text(
                    l.lqPurchaseAccountConnected,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  const PurchaseStatusBanner(),
                ],
                if (account.signedInIdentity != null ||
                    account.status == PurchaseAccountStatus.cleanupNeeded)
                  OutlinedButton(
                    onPressed: account.busy ? null : account.disconnect,
                    child: Text(l.lqPurchaseAccountDisconnect),
                  ),
                if (account.signedInIdentity != null && !deleted)
                  TextButton(
                    onPressed: account.busy
                        ? null
                        : () => _delete(context, account),
                    child: Text(l.lqPurchaseAccountDelete),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
