import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/data/event_database.dart';
import 'package:life_quest_final_v2/data/title_database.dart';
import 'package:life_quest_final_v2/data/title_unlock_rules.dart';

void main() {
  group('TitleUnlockRules', () {
    test('keeps event choices unchanged when no matching title is unlocked',
        () {
      final event = EventDatabase.getEvent('E08')!;
      final strengthTitle =
          TitleDatabase.all.firstWhere((title) => title.id == 't3');

      final choices = TitleUnlockRules.choicesFor(event, [strengthTitle]);

      expect(choices.length, event.choices.length);
      expect(choices.map((choice) => choice.text),
          isNot(contains('[현자 지망생] 색인을 해석한다')));
    });

    test('adds wisdom title choice to ancient library event', () {
      final event = EventDatabase.getEvent('E08')!;
      final wisdomTitle =
          TitleDatabase.all.firstWhere((title) => title.id == 't4');

      final choices = TitleUnlockRules.choicesFor(event, [wisdomTitle]);

      expect(choices.length, event.choices.length + 1);
      expect(
        choices.map((choice) => choice.text),
        contains('[현자 지망생] 색인을 해석한다'),
      );
    });

    test('exposes unlock preview copy for titles with event rules', () {
      final wisdomTitle =
          TitleDatabase.all.firstWhere((title) => title.id == 't4');
      final levelTitle =
          TitleDatabase.all.firstWhere((title) => title.id == 't1');

      expect(
        TitleUnlockRules.unlockPreviewForTitle(wisdomTitle),
        '고대 도서관 이벤트에서 지혜 기반 해석 선택지 해금',
      );
      expect(TitleUnlockRules.unlockPreviewForTitle(levelTitle), isNull);
    });
  });
}
