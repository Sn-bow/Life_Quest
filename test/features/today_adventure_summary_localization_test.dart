import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/data/title_localization.dart';
import 'package:life_quest_final_v2/data/title_unlock_rules.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/models/character.dart';
import 'package:life_quest_final_v2/models/quest.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/widgets/today_adventure_summary.dart';

void main() {
  SoundService.muteForTesting();

  testWidgets('Japanese adventure summary localizes generated copy and title', (
    tester,
  ) async {
    final state = CharacterState(firestore: FakeFirebaseFirestore());
    final now = DateTime.now();
    state.debugSeedState(
      character: Character(
        name: 'Tester',
        level: 1,
        title: '새싹 모험가',
        xp: 0,
        maxXp: CharacterState.xpRequiredForLevel(1),
        strength: 1,
        wisdom: 1,
        health: 1,
        charisma: 1,
        statPoints: 0,
        skillPoints: 0,
        lastLoginDate: now,
        lastHpRegenAt: now,
      ),
      dailyQuests: [
        Quest(
          id: 'completed',
          name: 'Recovery',
          xp: 20,
          type: QuestType.daily,
          category: StatType.health,
          isCompleted: true,
          completedDate: now,
        ),
        Quest(
          id: 'open',
          name: 'Practice',
          xp: 20,
          type: QuestType.daily,
          category: StatType.wisdom,
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ja'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: SingleChildScrollView(
            child: TodayAdventureSummary(state: state),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final l10n = lookupAppLocalizations(const Locale('ja'));
    expect(find.text(l10n.todayAdventureHeading), findsOneWidget);
    expect(find.text(l10n.todayAdventureCompletedCount(1)), findsOneWidget);
    expect(find.text(l10n.todayAdventureRecommendationHeading), findsOneWidget);
    expect(find.text(l10n.todayAdventureWisdomReason), findsOneWidget);
    final nextTitle = state.nextTitleProgress!;
    expect(
      find.text(
        l10n.todayAdventureNextTitle(
          TitleLocalization.localizedName(nextTitle.title.id, l10n),
        ),
      ),
      findsOneWidget,
    );
    if (TitleUnlockRules.unlockPreviewForTitle(nextTitle.title) != null) {
      expect(
        find.text(
          TitleLocalization.localizedUnlockPreview(nextTitle.title.id, l10n),
        ),
        findsOneWidget,
      );
    }
    expect(state.character.title, '새싹 모험가');

    final displayedText = tester
        .widgetList<Text>(
          find.descendant(
            of: find.byType(TodayAdventureSummary),
            matching: find.byType(Text),
          ),
        )
        .map((widget) => widget.data ?? '')
        .join(' ');
    expect(displayedText, isNot(contains(RegExp(r'[가-힣]'))));

    await tester.pumpWidget(const SizedBox());
    state.dispose();
  });
}
