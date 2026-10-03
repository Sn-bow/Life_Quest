import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:life_quest_final_v2/features/journeys/journey_catalog.dart';
import 'package:life_quest_final_v2/features/journeys/journey_progress.dart';
import 'package:life_quest_final_v2/features/journeys/journey_tool.dart';
import 'package:life_quest_final_v2/features/journeys/journey_tool_copy.dart';
import 'package:life_quest_final_v2/features/journeys/journey_tool_widgets.dart';
import 'package:life_quest_final_v2/features/journeys/mission_draft_store.dart';
import 'package:life_quest_final_v2/features/backup/device_backup.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'system_journal_test.dart' show JournalFaultStore;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SoundService.muteForTesting();
  setUpAll(() async => JourneyCatalog.load());
  setUp(() => SharedPreferences.setMockInitialValues({}));
  const card = JourneyTool(
    kind: JourneyToolKind.flashcard,
    fields: ['Question 日本語 🌱', 'Answer\n한글'],
  );
  test(
    'legacy drafts, multilingual workspace, blank clearing and corrupt drafts',
    () {
      expect(MissionWorkspaceDraft.decode('Old\nnote').note, 'Old\nnote');
      const value = MissionWorkspaceDraft(note: 'note', tool: card);
      final recovered = MissionWorkspaceDraft.decode(value.encode());
      expect(recovered.note, 'note');
      expect(recovered.tool!.toJson(), card.toJson());
      const empty = MissionWorkspaceDraft(
        tool: JourneyTool(kind: JourneyToolKind.flashcard, fields: ['', '']),
      );
      expect(
        MissionWorkspaceDraft.decode(empty.encode()).tool!.hasContent,
        false,
      );
      expect(
        () => MissionWorkspaceDraft.decode('${MissionWorkspaceDraft.marker}{}'),
        throwsFormatException,
      );
    },
  );
  test(
    'all tool types preserve Unicode/line breaks and reject malformed records',
    () {
      for (final kind in JourneyToolKind.values) {
        final tool = JourneyTool(
          kind: kind,
          fields: List.filled(
            kind == JourneyToolKind.routine ? 3 : 2,
            '日本語\n繁體 한글 🌱',
          ),
        );
        final entry = JourneyEntry(at: DateTime(2026, 10, 4), tool: tool);
        expect(
          JourneyEntry.parse(
            jsonDecode(jsonEncode(entry.toJson())),
          )!.tool!.toJson(),
          tool.toJson(),
        );
        expect(
          JourneyEntry.parse({
            ...entry.toJson(),
            'tool': {
              'kind': kind.name,
              'fields': [42],
            },
          }),
          isNull,
        );
      }
      expect(JourneyEntry.parse({'at': '2026-10-04'})!.tool, isNull);
    },
  );
  test(
    'each route lets free users try a tool before later guided practice',
    () {
      for (final kind in JourneyKind.values) {
        expect(
          [
            for (var i = 0; i < 7; i++) journeyToolFor(kind, i),
          ].whereType<JourneyToolKind>(),
          isNotEmpty,
        );
        expect(
          [
            for (var i = 7; i < 21; i++) journeyToolFor(kind, i),
          ].whereType<JourneyToolKind>(),
          isNotEmpty,
        );
      }
    },
  );
  test(
    'completion, disk retry, app restart and portable backup preserve tools without duplicate XP',
    () async {
      final store = JournalFaultStore();
      SharedPreferencesStorePlatform.instance = store;
      final state = CharacterState();
      await state.initializeForLocalGuest(name: 'Synthetic toolkit QA');
      final run = await state.startJourney(
        JourneyKind.learning,
        'Synthetic goal',
      );
      final quest = await state.acceptJourney(
        runId: run.id,
        title: 'Question',
        instruction: 'Write',
        minutes: 2,
        shortVersion: true,
        locale: 'en',
      );
      quest.journeyTool = card;
      store.fail = true;
      await expectLater(state.completeQuestDurably(quest), throwsStateError);
      final xp = state.character.xp;
      store.fail = false;
      await state.completeQuestDurably(quest);
      expect(state.character.xp, xp);
      expect(
        state.journeys.active!.entries.single.tool!.toJson(),
        card.toJson(),
      );
      final snapshot = DeviceSnapshot.create(
        profile: store.saved!,
        director: {},
        createdAt: DateTime.now(),
      );
      final roundtrip = DeviceSnapshot.fromJson(
        jsonDecode(jsonEncode(snapshot.toJson())),
      );
      expect(
        JourneyBook.fromJson(
          roundtrip.profile['journeys'],
        ).active!.entries.single.tool!.toJson(),
        card.toJson(),
      );
      state.dispose();
      final resumed = CharacterState();
      await resumed.initializeForLocalGuest(name: 'Ignored');
      expect(
        resumed.journeys.active!.entries.single.tool!.field(0),
        card.field(0),
      );
      expect(resumed.ownsJourneys, false);
      const improved = JourneyTool(
        kind: JourneyToolKind.flashcard,
        fields: ['Improved question', 'Better answer'],
      );
      store.fail = true;
      await expectLater(
        resumed.updateJourneyTool(run.id, 0, improved),
        throwsStateError,
      );
      expect(
        resumed.journeys.active!.entries.single.tool!.field(1),
        card.field(1),
      );
      store.fail = false;
      await resumed.updateJourneyTool(run.id, 0, improved);
      expect(
        JourneyBook.fromJson(
          store.saved!['journeys'],
        ).active!.entries.single.tool!.field(1),
        'Better answer',
      );
      expect(resumed.character.xp, xp);
      await expectLater(
        resumed.updateJourneyTool(run.id, 7, card),
        throwsStateError,
      );
      await expectLater(
        resumed.updateJourneyTool(
          run.id,
          0,
          const JourneyTool(kind: JourneyToolKind.script, fields: ['a', 'b']),
        ),
        throwsStateError,
      );
      resumed.dispose();
    },
  );
  test(
    'returning to a smaller mission preserves draft, reduces reward and survives a failed save',
    () async {
      final store = JournalFaultStore();
      SharedPreferencesStorePlatform.instance = store;
      final state = CharacterState();
      await state.initializeForLocalGuest(name: 'Synthetic return QA');
      final run = await state.startJourney(JourneyKind.learning, 'Return');
      final quest = await state.acceptJourney(
        runId: run.id,
        title: 'Question',
        instruction: 'Usual',
        minutes: 15,
        shortVersion: false,
        locale: 'en',
      );
      quest.completionNote = 'Keep my note';
      quest.journeyTool = card;
      final reward = quest.lockedXp!;
      store.fail = true;
      await expectLater(
        state.shortenJourney(run.id, instruction: 'Small', locale: 'en'),
        throwsStateError,
      );
      expect(state.dailyQuests.single.journeyShortVersion, false);
      store.fail = false;
      await state.shortenJourney(run.id, instruction: 'Small', locale: 'en');
      final small = state.dailyQuests.single;
      expect(small.id, quest.id);
      expect(small.estimatedMinutes, 2);
      expect(small.journeyShortVersion, true);
      expect(small.lockedXp, lessThan(reward));
      expect(small.completionNote, 'Keep my note');
      expect(small.journeyTool!.toJson(), card.toJson());
      await state.shortenJourney(run.id, instruction: 'Small', locale: 'en');
      expect(state.dailyQuests, hasLength(1));
      await state.completeQuestDurably(small);
      expect(state.journeys.active!.entries.single.shortVersion, true);
      expect(state.journeys.active!.entries.single.minutes, 2);
      await expectLater(
        state.shortenJourney(run.id, instruction: 'Small', locale: 'en'),
        throwsStateError,
      );
      state.dispose();
    },
  );
  for (final lang in ['en', 'ko', 'ja', 'zh']) {
    for (final width in [320.0, 1280.0]) {
      testWidgets(
        'tool practice, copy and edit are usable with large text $lang / $width',
        (tester) async {
          tester.view.physicalSize = Size(width, 800);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          final state = CharacterState();
          await state.initializeForLocalGuest(name: 'Synthetic toolkit');
          final runs = <JourneyRun>[];
          for (final kind in JourneyKind.values) {
            final stage = [
              for (var i = 0; i < 7; i++)
                if (journeyToolFor(kind, i) != null) i,
            ].first;
            final type = journeyToolFor(kind, stage)!;
            runs.add(
              JourneyRun(
                id: 'qa_${kind.name}',
                kind: kind,
                goal: 'Synthetic goal',
                startedAt: DateTime(2026, 10, 1),
                entries: [
                  for (var i = 0; i <= stage; i++)
                    JourneyEntry(
                      at: DateTime(2026, 10, 1),
                      tool: i == stage
                          ? JourneyTool(
                              kind: type,
                              fields: type == JourneyToolKind.routine
                                  ? [
                                      'After lunch',
                                      'Move comfortably',
                                      'Pause and rest',
                                    ]
                                  : [
                                      'Synthetic cue',
                                      type == JourneyToolKind.checklist
                                          ? 'Return book\nClear cup'
                                          : 'Synthetic answer',
                                    ],
                            )
                          : null,
                    ),
                ],
              ),
            );
          }
          state.journeys = JourneyBook(runs: runs);
          String? copied;
          tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
            SystemChannels.platform,
            (call) async {
              if (call.method == 'Clipboard.setData') {
                copied = (call.arguments as Map)['text'] as String;
              }
              return null;
            },
          );
          addTearDown(
            () => tester.binding.defaultBinaryMessenger
                .setMockMethodCallHandler(SystemChannels.platform, null),
          );
          await tester.pumpWidget(
            ChangeNotifierProvider.value(
              value: state,
              child: MaterialApp(
                locale: Locale(lang),
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(2)),
                  child: child!,
                ),
                home: const JourneyToolkitScreen(),
              ),
            ),
          );
          await tester.runAsync(() async {});
          await tester.pumpAndSettle();
          final c = JourneyCopy(lang);
          Future<void> reveal(Finder finder, {bool upward = false}) async {
            if (finder.evaluate().isEmpty) {
              await tester.scrollUntilVisible(
                finder,
                upward ? -250 : 250,
                scrollable: find.byType(Scrollable).first,
                maxScrolls: 40,
              );
            }
            await Scrollable.ensureVisible(
              tester.element(finder),
              alignment: 0.5,
            );
            await tester.pumpAndSettle();
          }

          // Filter removes offscreen duplicates and keeps each practice focused.
          for (final kind in JourneyKind.values) {
            final filter = find.widgetWithText(ChoiceChip, c.shortTitle(kind));
            await reveal(filter, upward: true);
            await tester.tap(filter);
            await tester.pumpAndSettle();
            if (kind == JourneyKind.learning) {
              expect(find.text('Synthetic answer'), findsNothing);
              final revealButton = find.byKey(const ValueKey('tool-reveal'));
              await reveal(revealButton);
              await tester.tap(revealButton);
              await tester.pumpAndSettle();
              expect(find.text('Synthetic answer'), findsOneWidget);
            } else if (kind == JourneyKind.order) {
              final checkbox = find.widgetWithText(
                CheckboxListTile,
                'Return book',
              );
              await reveal(checkbox);
              await tester.tap(checkbox);
              await tester.pumpAndSettle();
              expect(tester.widget<CheckboxListTile>(checkbox).value, true);
            } else if (kind == JourneyKind.vitality) {
              final small = find.widgetWithText(
                ChoiceChip,
                c.choose(['Low-energy day', '힘이 없는 날', '余裕がない日', '沒精神的日子']),
              );
              await reveal(small);
              await tester.tap(small);
              await tester.pumpAndSettle();
              expect(find.text('Pause and rest'), findsOneWidget);
            }
            final copy = find.byKey(const ValueKey('tool-copy'));
            await reveal(copy);
            await tester.tap(copy);
            await tester.pumpAndSettle();
            expect(copied, isNotEmpty);
            expect(tester.takeException(), isNull);
          }
          final edit = find.byKey(const ValueKey('tool-edit'));
          await reveal(edit);
          await tester.tap(edit);
          await tester.pumpAndSettle();
          final words = find.byKey(const ValueKey('journey-tool-field-1'));
          await reveal(words);
          await tester.enterText(words, 'Changed without a purchase');
          final save = find.byKey(const ValueKey('tool-save'));
          await reveal(save);
          await tester.tap(save);
          await tester.runAsync(() async {});
          await tester.pumpAndSettle();
          expect(find.text('Changed without a purchase'), findsOneWidget);
          expect(state.questCompletionCount, 0);
          expect(state.character.xp, 0);
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox());
          state.dispose();
        },
      );
    }
  }
}
