import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../state/character_state.dart';
import 'story_chapter.dart';

class StoryBanner extends StatelessWidget {
  const StoryBanner({super.key});
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final t = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const StoryLibraryScreen()),
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: t.colorScheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ExcludeSemantics(
              child: SizedBox(
                height: 112,
                child: Image.asset(
                  'assets/images/backgrounds/bg_zone2_dark_forest.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.lqStoryFreePrologue,
                    style: t.textTheme.labelMedium?.copyWith(
                      color: t.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l.lqStoryBannerTitle,
                          style: t.textTheme.titleLarge,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(l.lqStoryBannerBody, style: t.textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StoryLibraryScreen extends StatelessWidget {
  const StoryLibraryScreen({super.key});
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
                const SizedBox(height: 24),
                for (final chapter in snapshot.data!)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 22),
                    child: Card(
                      margin: EdgeInsets.zero,
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                StoryChapterScreen(chapter: chapter),
                          ),
                        ),
                        child: Semantics(
                          button: true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ExcludeSemantics(
                                child: AspectRatio(
                                  aspectRatio: 1.85,
                                  child: Image.asset(
                                    chapter.artwork,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chapter.subtitle,
                                      style: t.textTheme.labelMedium?.copyWith(
                                        color: t.colorScheme.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      chapter.title,
                                      style: t.textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      chapter.description,
                                      style: t.textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: 18),
                                    ExcludeSemantics(
                                      child: LinearProgressIndicator(
                                        value:
                                            chapter.completed(
                                              state.storyChoices,
                                            ) /
                                            chapter.scenes.length,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${chapter.completed(state.storyChoices)} / ${chapter.scenes.length} · ${l.lqStoryProgress}',
                                      style: t.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
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
    final subtitle = completed
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
            completed
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
  const StoryReaderScreen({
    super.key,
    required this.chapter,
    required this.index,
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
            child: Text(l.lqStoryReadPrevious),
          ),
        ),
      );
    }
    final selectedId = chapter.selectedChoice(index, state.storyChoices);
    final selected = scene.choices.where((c) => c.id == selectedId).firstOrNull;
    final next = index + 1;
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
                        builder: (_) =>
                            StoryReaderScreen(chapter: chapter, index: next),
                      ),
                    ),
                    child: Text(l.lqStoryNext),
                  )
                else ...[
                  Text(
                    next == chapter.scenes.length
                        ? l.lqStoryChapterComplete
                        : l.lqStoryReturnLater,
                    style: t.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
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
