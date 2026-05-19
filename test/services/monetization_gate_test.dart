import 'package:flutter_test/flutter_test.dart';
import 'package:life_quest_final_v2/config/monetization_config.dart';
import 'package:life_quest_final_v2/services/ad_service.dart';
import 'package:life_quest_final_v2/services/purchase_service.dart';

void main() {
  test('release default keeps monetization disabled unless explicitly enabled',
      () {
    expect(kLifeQuestMonetizationEnabled, isFalse);
    expect(AdService().getRemainingViews('quest_double'), 0);
  });

  test('disabled monetization does not attempt ad or billing flows', () async {
    expect(await AdService().showRewardedAd('quest_double'), isFalse);
    await PurchaseService().init();
    await PurchaseService().restorePurchases();
    expect(PurchaseService().isAvailable, isFalse);
  });
}
