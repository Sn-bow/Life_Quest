import '../features/story/story_screens.dart';
import '../features/story/story_pack_panel.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../features/director/director_widgets.dart';
import '../features/director/director_settings_screen.dart';
import '../l10n/app_localizations.dart';
import '../state/character_state.dart';
import 'achievement_screen.dart';
import 'inventory_screen.dart';
import 'report_screen.dart';
import 'settings_screen.dart';
import 'shop_screen.dart';
import 'skill_screen.dart';
import 'status_screen.dart';

class GrowthHubScreen extends StatelessWidget {
  const GrowthHubScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<CharacterState>();
    if (!state.isDataLoaded) {
      return const Center(child: CircularProgressIndicator());
    }
    final s = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final c = state.character;
    void open(Widget page) => Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => page));
    final links = <({IconData icon, String label, Widget page})>[
      (
        icon: PhosphorIcons.bookOpen,
        label: s.lqStoryLibrary,
        page: const StoryLibraryScreen(),
      ),
      (
        icon: PhosphorIcons.chartBar,
        label: s.statusScreenTitle,
        page: const StatusScreen(),
      ),
      (
        icon: PhosphorIcons.trendUp,
        label: s.statusReportTooltip,
        page: const ReportScreen(),
      ),
      (
        icon: PhosphorIcons.trophy,
        label: s.tabAchievement,
        page: const AchievementScreen(),
      ),
      (
        icon: PhosphorIcons.backpack,
        label: s.tabInventory,
        page: const InventoryScreen(),
      ),
      (
        icon: PhosphorIcons.sparkle,
        label: s.tabSkill,
        page: const SkillScreen(),
      ),
      (
        icon: PhosphorIcons.storefront,
        label: s.tabShop,
        page: const ShopScreen(),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(s.lqGrowth),
        actions: [
          IconButton(
            tooltip: s.statusSettingsTooltip,
            icon: const Icon(PhosphorIcons.gear),
            onPressed: () => open(const SettingsScreen()),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Text(s.lqStatusWindow, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 6),
          Text(s.lqGrowthHint, style: theme.textTheme.bodySmall),
          const SizedBox(height: 22),
          ProgressStatusSummary(state: state),
          const StoryMarks(),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, box) {
              final columns =
                  box.maxWidth < 340 ||
                      MediaQuery.textScalerOf(context).scale(14) > 20
                  ? 2
                  : 4;
              final values = [
                (s.statusStatStrength, c.strength),
                (s.statusStatWisdom, c.wisdom),
                (s.statusStatHealth, c.health),
                (s.statusStatCharm, c.charisma),
              ];
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: values
                    .map(
                      (v) => SizedBox(
                        width: (box.maxWidth - 8 * (columns - 1)) / columns,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Column(
                              children: [
                                Text(
                                  v.$1,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  v.$2.round().toString(),
                                  style: theme.textTheme.titleLarge,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 22),
          Card(
            child: Column(
              children: [
                for (var i = 0; i < links.length; i++) ...[
                  if (i > 0) const Divider(indent: 54),
                  ListTile(
                    minVerticalPadding: 12,
                    leading: Icon(
                      links[i].icon,
                      color: theme.colorScheme.primary,
                    ),
                    title: Text(links[i].label),
                    trailing: const Icon(PhosphorIcons.caretRight, size: 17),
                    onTap: () => open(links[i].page),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              minVerticalPadding: 14,
              leading: Icon(
                PhosphorIcons.cpu,
                color: theme.colorScheme.secondary,
              ),
              title: Text(s.lqDirector),
              subtitle: Text(s.lqModelName, style: theme.textTheme.bodySmall),
              trailing: const Icon(PhosphorIcons.caretRight, size: 17),
              onTap: () => open(const DirectorSettingsScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
