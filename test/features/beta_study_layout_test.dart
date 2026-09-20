import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_quest_final_v2/features/backup/backup_files.dart';
import 'package:life_quest_final_v2/features/research/beta_study.dart';
import 'package:life_quest_final_v2/features/research/beta_study_screen.dart';
import 'package:life_quest_final_v2/features/director/director_settings_screen.dart';
import 'package:life_quest_final_v2/features/director/quest_director_state.dart';
import 'package:life_quest_final_v2/features/director/on_device_quest_model.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/theme/quest_theme.dart';

class StudyFiles extends BackupFiles {
  Uint8List? bytes;
  bool succeeds = true;
  @override
  Future<Uint8List?> open() async => null;
  @override
  Future<bool> save(Uint8List data, String filename) async {
    bytes = data;
    return succeeds;
  }
}

class NoStudyModel extends OnDeviceQuestModel {
  @override
  Future<ModelSnapshot> status() async =>
      const ModelSnapshot(OnDeviceModelStatus.unavailable);
  @override
  Future<void> cancel() async {}
}

Widget host(
  CharacterState character,
  Widget page, {
  String locale = 'ko',
  double scale = 1,
}) => ChangeNotifierProvider.value(
  value: character,
  child: MaterialApp(
    theme: QuestTheme.build(Brightness.dark),
    locale: Locale(locale),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(scale)),
      child: child!,
    ),
    home: page,
  ),
);

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  for (final locale in ['ko', 'en', 'ja', 'zh']) {
    testWidgets('consent, ratings and export fit 320px / 200% in $locale', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final character = CharacterState()..initializeForTesting();
      final study = BetaStudy(enabled: true);
      await study.start(
        const BetaSnapshot(completions: 0, previewComplete: true),
      );
      await tester.pumpWidget(
        host(
          character,
          BetaStudyScreen(study: study),
          locale: locale,
          scale: 2,
        ),
      );
      await tester.pumpAndSettle();
      for (var i = 0; i < 10; i++) {
        expect(tester.takeException(), isNull);
        await tester.drag(find.byType(ListView), const Offset(0, -600));
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      character.dispose();
    });
  }

  testWidgets(
    'explicit enrollment, file cancellation and withdrawal preserve app data',
    (tester) async {
      final character = CharacterState()..initializeForTesting();
      final originalXP = character.character.xp;
      final study = BetaStudy(enabled: true);
      final files = StudyFiles()..succeeds = false;
      await tester.pumpWidget(
        host(character, BetaStudyScreen(study: study, files: files)),
      );
      await tester.pumpAndSettle();
      expect(await study.load(), isNull);
      await tester.ensureVisible(find.text('내용을 이해했고 참여합니다'));
      await tester.tap(find.text('내용을 이해했고 참여합니다'));
      await tester.pumpAndSettle();
      expect(await study.load(), isNotNull);
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('결과 파일 저장'));
      await tester.tap(find.text('결과 파일 저장'));
      await tester.pumpAndSettle();
      expect(
        jsonDecode(utf8.decode(files.bytes!))['evidence'],
        'device_reported_not_purchase',
      );
      expect(find.textContaining('기록을 읽거나 저장하지 못했습니다'), findsNothing);
      await tester.ensureVisible(find.text('참여 중단 및 테스트 기록 삭제'));
      await tester.tap(find.text('참여 중단 및 테스트 기록 삭제'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, '참여 중단 및 테스트 기록 삭제'));
      await tester.pumpAndSettle();
      expect(await study.load(), isNull);
      expect(character.character.xp, originalXP);
      await tester.pumpWidget(const SizedBox());
      character.dispose();
    },
  );

  testWidgets('device-only AI settings never claim Firebase quest storage', (
    tester,
  ) async {
    final character = CharacterState()..initializeForTesting();
    final director = QuestDirectorState(model: NoStudyModel());
    await director.bind('study-layout');
    await tester.pumpWidget(
      host(
        character,
        ChangeNotifierProvider.value(
          value: director,
          child: const DirectorSettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.textContaining('수락한 퀘스트와 개인화 기록은 이 기기에'),
      250,
    );
    expect(find.textContaining('Firebase에 저장됩니다'), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    director.dispose();
    character.dispose();
  });
}
