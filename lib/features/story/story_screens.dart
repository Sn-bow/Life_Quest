import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../state/character_state.dart';
import 'story_chapter.dart';
import 'story_pack_panel.dart';

void _openChapter(
  BuildContext context,
  StoryChapter chapter, {
  bool continueReading = false,
}) {
  final state = context.read<CharacterState>();
  final next = chapter.nextSceneIndex(state.storyChoices);
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) =>
          continueReading && next != null && state.canOpenStory(chapter, next)
          ? StoryReaderScreen(
              chapter: chapter,
              index: next,
              openedDirectly: true,
            )
          : StoryChapterScreen(chapter: chapter),
    ),
  );
}

class StoryBanner extends StatelessWidget {
  const StoryBanner({super.key});
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final t = Theme.of(context);
    final state = context.watch<CharacterState>();
    void library() => Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const StoryLibraryScreen()));
    return FutureBuilder<List<StoryChapter>>(
      future: StoryRepository.load(
        Localizations.localeOf(context).languageCode,
      ),
      builder: (context, snapshot) {
        final chapter = snapshot.data
            ?.where((book) => book.id == state.activeStoryChapterId)
            .firstOrNull;
        final next = chapter?.nextSceneIndex(state.storyChoices);
        final remaining = next == null
            ? 0
            : (chapter!.scenes[next].quests - state.questCompletionCount).clamp(
                0,
                chapter.scenes[next].quests,
              );
        final caption = chapter == null
            ? l.lqWorldChooseHint
            : next == null
            ? l.lqStoryReadAgain
            : chapter.needsPurchase(next, owned: state.ownsStory(chapter))
            ? l.lqPackLocked
            : remaining > 0
            ? l.lqStoryActionsRemaining(remaining)
            : l.lqStoryReadNow;
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: chapter == null
                    ? library
                    : () =>
                          _openChapter(context, chapter, continueReading: true),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      ExcludeSemantics(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            chapter?.artwork ??
                                'assets/images/backgrounds/journal_worlds.jpg',
                            width: 70,
                            height: 76,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.lqWorldCurrent,
                              style: t.textTheme.labelSmall?.copyWith(
                                color: t.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              chapter?.title ?? l.lqWorldChoose,
                              style: t.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(caption, style: t.textTheme.bodySmall),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.chevron_right, size: 20),
                    ],
                  ),
                ),
              ),
              if (snapshot.hasError)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(l.lqStoryLoadFailed),
                ),
              if (chapter != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 8, 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${chapter.completed(state.storyChoices)} / ${chapter.scenes.length} · ${l.lqStoryProgress}',
                          style: t.textTheme.bodySmall,
                        ),
                      ),
                      Flexible(
                        child: TextButton(
                          onPressed: library,
                          child: Text(l.lqWorldChange),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class StoryLibraryScreen extends StatefulWidget {
  const StoryLibraryScreen({super.key});
  @override
  State<StoryLibraryScreen> createState() => _StoryLibraryScreenState();
}

class _StoryLibraryScreenState extends State<StoryLibraryScreen> {
  String? _saving;
  Future<void> _select(StoryChapter chapter) async {
    if (_saving != null) return;
    setState(() => _saving = chapter.id);
    final saved = await context.read<CharacterState>().selectStoryChapter(
      chapter.id,
    );
    if (!mounted) return;
    setState(() => _saving = null);
    if (saved) {
      _openChapter(context, chapter, continueReading: true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.lqStorySaveFailed),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final t = Theme.of(context);
    final state = context.watch<CharacterState>();
    return Scaffold(
      appBar: AppBar(title: Text(l.lqStoryLibrary)),
      body: FutureBuilder<List<StoryChapter>>(
        future: StoryRepository.load(
          Localizations.localeOf(context).languageCode,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l.lqStoryLoadFailed),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return _StoryWidth(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              children: [
                Text(
                  l.lqStoryLibraryHeadline,
                  style: t.textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                Text(l.lqStoryLibraryHint, style: t.textTheme.bodyMedium),
                const SizedBox(height: 10),
                Text(
                  l.lqWorldFreeCollection,
                  style: t.textTheme.labelLarge?.copyWith(
                    color: t.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 22),
                for (final chapter in snapshot.data!) ...[
                  if (chapter.productId != null) ...[
                    const SizedBox(height: 10),
                    Text(l.lqPackCollection, style: t.textTheme.titleMedium),
                    const SizedBox(height: 12),
                  ],
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          InkWell(
                            onTap: () => _openChapter(context, chapter),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ExcludeSemantics(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: Image.asset(
                                            chapter.artwork,
                                            width: 84,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              chapter.subtitle,
                                              style: t.textTheme.labelSmall
                                                  ?.copyWith(
                                                    color:
                                                        t.colorScheme.primary,
                                                  ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              chapter.title,
                                              style: t.textTheme.titleMedium,
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              '${chapter.completed(state.storyChoices)} / ${chapter.scenes.length} · ${l.lqStoryProgress}',
                                              style: t.textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.chevron_right, size: 18),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                            child: OutlinedButton.icon(
                              onPressed: _saving != null
                                  ? null
                                  : () => _select(chapter),
                              icon: Icon(
                                state.activeStoryChapterId == chapter.id
                                    ? Icons.bookmark
                                    : Icons.bookmark_add_outlined,
                                size: 18,
                              ),
                              label: Text(
                                _saving == chapter.id
                                    ? l.lqWorldSaving
                                    : state.activeStoryChapterId == chapter.id
                                    ? l.lqWorldContinue
                                    : chapter.productId != null &&
                                          !state.ownsStory(chapter)
                                    ? l.lqPackPreview
                                    : l.lqWorldSelect,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                Text(l.lqWorldCollectionPromise, style: t.textTheme.bodySmall),
              ],
            ),
          );
        },
      ),
    );
  }
}

class StoryChapterScreen extends StatelessWidget {
  final StoryChapter chapter;
  const StoryChapterScreen({super.key, required this.chapter});
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final t = Theme.of(context);
    final state = context.watch<CharacterState>();
    final nextIndex = chapter.nextSceneIndex(state.storyChoices);
    final canContinue =
        nextIndex != null && state.canOpenStory(chapter, nextIndex);
    final resumeIndex = canContinue ? nextIndex : 0;
    return Scaffold(
      appBar: AppBar(title: Text(chapter.title)),
      body: _StoryWidth(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ExcludeSemantics(
                child: AspectRatio(
                  aspectRatio: 1.8,
                  child: Image.asset(chapter.artwork, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              chapter.subtitle,
              style: t.textTheme.labelMedium?.copyWith(
                color: t.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 10),
            Text(chapter.description, style: t.textTheme.bodyLarge),
            const SizedBox(height: 12),
            Text(l.lqStoryFiction, style: t.textTheme.bodySmall),
            if (chapter.productId != null) ...[
              const SizedBox(height: 18),
              if (state.canOpenStory(chapter, resumeIndex)) ...[
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => StoryReaderScreen(
                        chapter: chapter,
                        index: resumeIndex,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.menu_book_outlined),
                  label: Text(
                    !canContinue
                        ? l.lqStoryReadAgain
                        : state.ownsStory(chapter)
                        ? l.lqWorldContinue
                        : l.lqPackPreview,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              StoryPackPanel(chapter: chapter),
            ],
            const SizedBox(height: 24),
            for (var i = 0; i < chapter.scenes.length; i++)
              _SceneRow(chapter: chapter, index: i),
            const SizedBox(height: 18),
            Text(l.lqStoryNoDeadline, style: t.textTheme.bodySmall),
            const SizedBox(height: 8),
            Text(
              '${l.lqStoryActionCount} ${state.questCompletionCount}',
              style: t.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _SceneRow extends StatelessWidget {
  final StoryChapter chapter;
  final int index;
  const _SceneRow({required this.chapter, required this.index});
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final state = context.watch<CharacterState>();
    final t = Theme.of(context);
    final scene = chapter.scenes[index];
    final open = state.canOpenStory(chapter, index);
    final completed = chapter.selectedChoice(index, state.storyChoices) != null;
    final remaining = (scene.quests - state.questCompletionCount).clamp(
      0,
      scene.quests,
    );
    final needsPurchase = chapter.needsPurchase(
      index,
      owned: state.ownsStory(chapter),
    );
    final subtitle = needsPurchase
        ? l.lqPackLocked
        : completed
        ? l.lqStoryReadAgain
        : open
        ? l.lqStoryReadNow
        : remaining > 0
        ? '${l.lqStoryUnlockAfter} $remaining ${l.lqStoryQuestUnit}'
        : l.lqStoryReadPrevious;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 9,
          ),
          leading: Icon(
            completed && open
                ? Icons.check_circle_outline
                : open
                ? Icons.menu_book_outlined
                : Icons.lock_outline,
            color: open
                ? t.colorScheme.primary
                : t.colorScheme.onSurfaceVariant,
          ),
          title: Text(
            '${(index + 1).toString().padLeft(2, '0')}  ${scene.title}',
            style: t.textTheme.titleSmall,
          ),
          subtitle: Text(subtitle, style: t.textTheme.bodySmall),
          trailing: open ? const Icon(Icons.chevron_right, size: 18) : null,
          onTap: open
              ? () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        StoryReaderScreen(chapter: chapter, index: index),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

class StoryReaderScreen extends StatefulWidget {
  final StoryChapter chapter;
  final int index;
  final bool openedDirectly;
  const StoryReaderScreen({
    super.key,
    required this.chapter,
    required this.index,
    this.openedDirectly = false,
  });
  @override
  State<StoryReaderScreen> createState() => _StoryReaderScreenState();
}

class _StoryReaderScreenState extends State<StoryReaderScreen> {
  bool _saving = false;
  bool _choosingAgain = false;
  Future<void> _choose(StoryChoice choice) async {
    if (_saving) return;
    setState(() => _saving = true);
    final saved = await context.read<CharacterState>().chooseStory(
      widget.chapter,
      widget.index,
      choice.id,
    );
    if (!mounted) return;
    setState(() {
      _saving = false;
      if (saved) _choosingAgain = false;
    });
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
    final l = AppLocalizations.of(context)!;
    final t = Theme.of(context);
    final state = context.watch<CharacterState>();
    final chapter = widget.chapter;
    final index = widget.index;
    final scene = chapter.scenes[index];
    if (!state.canOpenStory(chapter, index)) {
      return Scaffold(
        appBar: AppBar(title: Text(chapter.title)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    chapter.needsPurchase(
                          index,
                          owned: state.ownsStory(chapter),
                        )
                        ? l.lqPackLocked
                        : l.lqStoryReadPrevious,
                  ),
                  if (chapter.productId != null)
                    StoryPackPanel(chapter: chapter),
                ],
              ),
            ),
          ),
        ),
      );
    }
    final selectedId = chapter.selectedChoice(index, state.storyChoices);
    final selected = scene.choices.where((c) => c.id == selectedId).firstOrNull;
    final next = index + 1;
    final ending = next == chapter.scenes.length
        ? chapter.endingFor(state.storyChoices)
        : null;
    return Scaffold(
      appBar: AppBar(title: Text(chapter.title)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            children: [
              Text(
                '${l.lqStoryRecord} ${(index + 1).toString().padLeft(2, '0')} / ${chapter.scenes.length.toString().padLeft(2, '0')}',
                style: t.textTheme.labelMedium?.copyWith(
                  color: t.colorScheme.primary,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(scene.title, style: t.textTheme.headlineMedium),
              const SizedBox(height: 24),
              Semantics(
                label: scene.narration,
                child: ExcludeSemantics(
                  child: SelectableText(
                    scene.narration,
                    style: t.textTheme.bodyLarge?.copyWith(
                      fontSize: 17,
                      height: 1.9,
                    ),
                  ),
                ),
              ),
              for (final entry in scene.echoes.entries)
                if (state.storyChoices[entry.key.split(':').first] ==
                    entry.key.split(':').last)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(entry.value, style: t.textTheme.bodyLarge),
                  ),
              if (ending != null) ...[
                const SizedBox(height: 24),
                Text(ending.title, style: t.textTheme.titleLarge),
                const SizedBox(height: 16),
                Text(
                  ending.narration,
                  style: t.textTheme.bodyLarge?.copyWith(height: 1.9),
                ),
                const SizedBox(height: 16),
                Text(l.lqPackEndingHint, style: t.textTheme.bodySmall),
              ],
              const SizedBox(height: 28),
              if (selected == null || _choosingAgain) ...[
                Text(l.lqStoryChoose, style: t.textTheme.labelLarge),
                const SizedBox(height: 12),
                for (final choice in scene.choices)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: OutlinedButton(
                      onPressed: _saving ? null : () => _choose(choice),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(choice.label),
                        ),
                      ),
                    ),
                  ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: t.colorScheme.surface,
                    border: Border(
                      left: BorderSide(color: t.colorScheme.primary, width: 3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selected.label,
                        style: t.textTheme.titleSmall?.copyWith(
                          color: t.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        selected.response,
                        style: t.textTheme.bodyLarge?.copyWith(height: 1.8),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                if (next < chapter.scenes.length &&
                    state.canOpenStory(chapter, next))
                  FilledButton(
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) => StoryReaderScreen(
                          chapter: chapter,
                          index: next,
                          openedDirectly: widget.openedDirectly,
                        ),
                      ),
                    ),
                    child: Text(l.lqStoryNext),
                  )
                else ...[
                  Text(
                    next == chapter.scenes.length
                        ? l.lqStoryChapterComplete
                        : chapter.needsPurchase(
                            next,
                            owned: state.ownsStory(chapter),
                          )
                        ? l.lqPackPreviewEnd
                        : l.lqStoryReturnLater,
                    style: t.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () {
                      if (widget.openedDirectly) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                StoryChapterScreen(chapter: chapter),
                          ),
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(l.lqStoryBackToChapter),
                  ),
                ],
                TextButton(
                  onPressed: () => setState(() => _choosingAgain = true),
                  child: Text(l.lqStoryChooseAgain),
                ),
              ],
              if (_saving) const LinearProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoryWidth extends StatelessWidget {
  final Widget child;
  const _StoryWidth({required this.child});
  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 720),
      child: child,
    ),
  );
}
