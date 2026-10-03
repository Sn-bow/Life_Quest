import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/features/status_pack/status_skin_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    StatusSkinStore.instance.resetForTesting();
  });

  test(
    'a paid look is saved, restored and immediately hidden on revocation',
    () async {
      final store = StatusSkinStore.instance;
      await store.select(StatusWindowLook.obsidian);
      expect(store.effective(true), StatusWindowLook.obsidian);
      expect(store.effective(false), StatusWindowLook.core);

      store.resetForTesting();
      await store.load();
      expect(store.selected, StatusWindowLook.obsidian);
      expect(store.effective(false), StatusWindowLook.core);
    },
  );

  test('an unknown stored look safely falls back to the free frame', () async {
    SharedPreferences.setMockInitialValues({
      StatusSkinStore.preferenceKey: 'unrecognised_look',
    });
    final store = StatusSkinStore.instance;
    await store.load();
    expect(store.selected, StatusWindowLook.core);
  });
}
