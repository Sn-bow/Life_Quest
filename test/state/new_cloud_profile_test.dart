import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/data/guest_name_localization.dart';
import 'package:life_quest_final_v2/data/title_localization.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/state/character_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('new cloud profile starts with no invented routines or goals', () {
    final state = CharacterState(firestore: FakeFirebaseFirestore())
      ..initializeNewCloudProfileForTesting(MockUser(uid: 'new-user'));

    expect(state.dailyQuests, isEmpty);
    expect(state.weeklyQuests, isEmpty);
    expect(state.monthlyQuests, isEmpty);
    expect(state.yearlyQuests, isEmpty);
    expect(state.character.level, 1);
    expect(state.character.xp, 0);
    expect(state.character.usesDefaultGuestName, isTrue);
    expect(state.unlockedTitles.single.id, 't0');

    for (final language in ['ko', 'en', 'ja', 'zh']) {
      final l10n = lookupAppLocalizations(Locale(language));
      expect(
        GuestNameLocalization.displayName(state.character, l10n),
        l10n.lqGuestName,
      );
      expect(
        TitleLocalization.localizedStoredName(state.character.title, l10n),
        l10n.titleNameT0,
      );
      if (language != 'ko') {
        expect(
          GuestNameLocalization.displayName(state.character, l10n),
          isNot(contains(RegExp(r'[가-힣]'))),
        );
        expect(
          TitleLocalization.localizedStoredName(state.character.title, l10n),
          isNot(contains(RegExp(r'[가-힣]'))),
        );
      }
    }
    state.dispose();
  });

  test('a Google display name remains the name chosen by its owner', () {
    final state = CharacterState(firestore: FakeFirebaseFirestore())
      ..initializeNewCloudProfileForTesting(
        MockUser(uid: 'named-user', displayName: 'Alex'),
      );
    expect(state.character.name, 'Alex');
    expect(state.character.usesDefaultGuestName, isFalse);
    for (final language in ['ko', 'en', 'ja', 'zh']) {
      final l10n = lookupAppLocalizations(Locale(language));
      expect(GuestNameLocalization.displayName(state.character, l10n), 'Alex');
    }
    state.dispose();
  });
}
