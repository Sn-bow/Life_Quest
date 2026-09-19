import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/monetization_config.dart';
import '../../l10n/app_localizations.dart';
import '../../services/purchase_service.dart';
import '../../state/character_state.dart';
import '../billing/purchase_account_screen.dart';
import '../billing/purchase_status_banner.dart';
import 'story_chapter.dart';

class StoryPackPanel extends StatefulWidget {
  final StoryChapter chapter;
  const StoryPackPanel({super.key, required this.chapter});
  @override
  State<StoryPackPanel> createState() => _StoryPackPanelState();
}

class _StoryPackPanelState extends State<StoryPackPanel> {
  bool _saving = false;
  Future<void> _theme(CharacterState state, bool enabled) async {
    if (_saving) return;
    setState(() => _saving = true);
    final saved = await state.setStoryTheme(widget.chapter, enabled: enabled);
    if (!mounted) return;
    setState(() => _saving = false);
    if (!saved) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.lqStorySaveFailed),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chapter = widget.chapter;
    if (chapter.productId == null) return const SizedBox.shrink();
    final l = AppLocalizations.of(context)!;
    final state = context.watch<CharacterState>();
    final owned = state.ownsStory(chapter);
    final t = Theme.of(context);
    final purchases = PurchaseService();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              owned ? l.lqPackOwned : l.lqPackPreview,
              style: t.textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Text(l.lqPackContents),
            const SizedBox(height: 10),
            Text(l.lqPackPacing, style: t.textTheme.bodySmall),
            const SizedBox(height: 10),
            Text(l.lqPackThemeHint, style: t.textTheme.bodySmall),
            if (owned && chapter.themeId != null) ...[
              const SizedBox(height: 14),
              OutlinedButton(
                onPressed: _saving
                    ? null
                    : () => _theme(
                        state,
                        state.character.equippedTheme != chapter.themeId,
                      ),
                child: Text(
                  state.character.equippedTheme == chapter.themeId
                      ? l.lqPackThemeRemove
                      : l.lqPackThemeApply,
                ),
              ),
              if (_saving) const LinearProgressIndicator(),
            ],
            const SizedBox(height: 14),
            if (chapter.markArtwork != null)
              Row(
                children: [
                  Image.asset(
                    chapter.markArtwork!,
                    width: 56,
                    height: 56,
                    excludeFromSemantics: true,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      owned &&
                              chapter.completed(state.storyChoices) ==
                                  chapter.scenes.length
                          ? l.lqPackMark
                          : l.lqPackMarkHint,
                      style: t.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            if (!owned) ...[
              const SizedBox(height: 14),
              if (state.isLocalGuest) const PurchaseAccountTile(),
              ListenableBuilder(
                listenable: purchases,
                builder: (context, _) {
                  final product = purchases.products
                      .where((p) => p.id == chapter.productId)
                      .firstOrNull;
                  if (!kLifeQuestMonetizationEnabled) {
                    return Text(
                      l.lqPackUnavailable,
                      style: t.textTheme.bodySmall,
                    );
                  }
                  if (product == null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l.lqPackStoreUnavailable,
                          style: t.textTheme.bodySmall,
                        ),
                        TextButton(
                          onPressed: purchases.checkingStore || purchases.busy
                              ? null
                              : purchases.refreshCatalog,
                          child: Text(l.lqRetry),
                        ),
                        if (purchases.checkingStore)
                          const LinearProgressIndicator(),
                      ],
                    );
                  }
                  if (!purchases.isAvailable) {
                    return Text(
                      l.lqPurchaseAccountOptional,
                      style: t.textTheme.bodySmall,
                    );
                  }
                  return FilledButton(
                    onPressed:
                        purchases.busy ||
                            purchases.checkingStore ||
                            (purchases.phase == PurchasePhase.pending &&
                                purchases.activeProduct == product.id)
                        ? null
                        : () => purchases.buyProduct(product),
                    child: Text(l.lqPackBuy(product.price)),
                  );
                },
              ),
            ],
            if (kLifeQuestMonetizationEnabled) const PurchaseStatusBanner(),
          ],
        ),
      ),
    );
  }
}

/// Completion is derived from the book's saved choices and current ownership.
/// Neither a backup nor a revoked entitlement can grant a paid mark.
class StoryMarks extends StatelessWidget {
  const StoryMarks({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<CharacterState>();
    final l = AppLocalizations.of(context)!;
    return FutureBuilder<List<StoryChapter>>(
      future: StoryRepository.load(
        Localizations.localeOf(context).languageCode,
      ),
      builder: (context, snapshot) {
        final completed =
            snapshot.data
                ?.where(
                  (book) =>
                      book.markArtwork != null &&
                      state.ownsStory(book) &&
                      book.completed(state.storyChoices) == book.scenes.length,
                )
                .toList() ??
            [];
        if (completed.isEmpty) return const SizedBox.shrink();
        return Column(
          children: [
            for (final book in completed)
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Card(
                  child: ListTile(
                    leading: Image.asset(
                      book.markArtwork!,
                      width: 48,
                      height: 48,
                      excludeFromSemantics: true,
                    ),
                    title: Text(l.lqPackMark),
                    subtitle: Text(l.lqPackThemeHint),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
