import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/purchase_service.dart';
import '../../l10n/app_localizations.dart';
import '../../state/character_state.dart';
import '../billing/purchase_account_screen.dart';
import '../billing/purchase_account_state.dart';
import '../billing/purchase_status_banner.dart';
import '../billing/purchase_verifier.dart';
import '../status_pack/ui/status_pack_screen.dart';
import '../system/hunter_system_frame.dart';
import 'journey_catalog.dart';

class JourneyPurchaseScreen extends StatelessWidget {
  const JourneyPurchaseScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final copy = JourneyCopy(Localizations.localeOf(context).languageCode);
    final account = context.watch<PurchaseAccountState?>();
    final state = context.watch<CharacterState>();
    final purchases = PurchaseService();
    final l = AppLocalizations.of(context)!;
    String t(List<String> values) => copy.choose(values);
    return ListenableBuilder(
      listenable: purchases,
      builder: (context, _) {
        final product = purchases.products
            .where((p) => p.id == journeysCompleteProductId)
            .firstOrNull;
        final owned = state.ownsJourneys;
        return Theme(
          data: HunterSystemFrame.themeFor(context),
          child: Scaffold(
            backgroundColor: const Color(0xFF07131B),
            appBar: AppBar(title: const Text('Life Quest Complete')),
            body: SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      const Icon(
                        Icons.route,
                        size: 42,
                        color: Color(0xFF80DCFB),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        t([
                          'Keep going with a plan you can use.',
                          '다음 단계도, 실행할 수 있는 계획으로.',
                          'その先も、使える計画と一緒に。',
                          '帶著做得到的計畫，繼續下一步。',
                        ]),
                        style: HunterSystemFrame.themeFor(
                          context,
                        ).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        t([
                          'One purchase. The complete routes and tools below. No subscription, no paid XP boost.',
                          '한 번 구매하면 아래 전체 루트와 도구를 사용합니다. 정기결제나 유료 경험치 배율은 없습니다.',
                          '一度の購入で、以下の全ルートとツールを使えます。定期購入や有料の経験値倍率はありません。',
                          '購買一次，即可使用下列完整路線與工具。沒有訂閱，也不販售經驗值倍率。',
                        ]),
                        style: const TextStyle(height: 1.6),
                      ),
                      const SizedBox(height: 24),
                      for (final row in [
                        t([
                          '84 guided missions · four complete routes',
                          '안내가 있는 84개 미션 · 네 개의 전체 루트',
                          '手順つき84ミッション・4つの全ルート',
                          '84個有步驟的任務・四條完整路線',
                        ]),
                        t([
                          'Missions 8–21: practise, make a result, and build your own repeatable method',
                          '8–21번째 미션: 연습하고 결과를 만들며 다시 쓸 방법을 정리',
                          'ミッション8〜21：試して成果を作り、また使える方法を残す',
                          '第8–21個任務：練習、做出成果、留下可再次使用的方法',
                        ]),
                        t([
                          'New goals after finishing · keep past route notes',
                          '완료 후 새 목표로 재사용 · 지난 루트 메모 보관',
                          '完了後は新しい目標で・過去のメモも保存',
                          '完成後以新目標再使用・保留過往筆記',
                        ]),
                        t([
                          'Three status looks · 30/90-day reports · PNG, text and CSV export',
                          '상태창 외관 3종 · 30/90일 보고서 · PNG·텍스트·CSV 저장',
                          '3種のステータス外観・30/90日レポート・PNG/テキスト/CSV保存',
                          '三種狀態外觀・30/90日報告・PNG、文字與CSV匯出',
                        ]),
                      ])
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check,
                                color: Color(0xFF80DCFB),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  row,
                                  style: const TextStyle(height: 1.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const Divider(),
                      const SizedBox(height: 12),
                      Text(
                        t([
                          'Still free: the first 7 missions of every route, your own quests, daily suggestions, your saved progress and backup.',
                          '계속 무료: 모든 루트의 첫 7개 미션, 직접 만든 퀘스트, 일일 추천, 저장된 진도와 백업.',
                          'ずっと無料：各ルートの最初の7ミッション、自作クエスト、毎日の提案、保存済みの進み具合とバックアップ。',
                          '仍然免費：每條路線前7個任務、自訂任務、每日建議、已存進度與備份。',
                        ]),
                        style: const TextStyle(height: 1.6),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        t([
                          'Your goal and action notes stay in your chosen profile. Buying links a Google account to verify and restore the purchase; a device profile stays on this device. Purchase and restore need internet. Verified paid access works offline for up to 7 days, then needs another online check.',
                          '목표와 실행 메모는 선택한 프로필에 남습니다. 구매 시 Google 계정은 구매 확인·복원에 사용하며 기기 프로필은 기기에 남습니다. 구매·복원에는 인터넷이 필요합니다. 확인된 유료 권한은 최대 7일간 오프라인으로 사용한 뒤 온라인에서 다시 확인합니다.',
                          '目標とメモは選んだプロフィールに残ります。購入には確認・復元用のGoogleアカウントを使い、端末プロフィールは端末に残ります。購入・復元にはネット接続が必要です。確認済みの有料機能はオフラインで最大7日間使え、その後は再確認が必要です。',
                          '目標與行動筆記留在你選的個人檔案。購買時連結Google帳號以驗證及還原購買，裝置個人檔案仍留在裝置。購買及還原需要網路。已驗證的付費權限可離線使用最多7天，之後需再次連網確認。',
                        ]),
                        style: HunterSystemFrame.themeFor(
                          context,
                        ).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 24),
                      if (owned) ...[
                        Text(
                          t([
                            'Complete is unlocked',
                            '전체 확장을 사용할 수 있습니다',
                            '完全版が使えます',
                            '完整版已解鎖',
                          ]),
                          style: const TextStyle(
                            color: Color(0xFF80DCFB),
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const StatusPackScreen(),
                            ),
                          ),
                          child: Text(
                            t([
                              'Status looks & reports',
                              '상태창 외관·보고서',
                              'ステータス外観・レポート',
                              '狀態外觀與報告',
                            ]),
                          ),
                        ),
                      ] else ...[
                        if (account?.enabled == true && account?.uid == null)
                          const PurchaseAccountTile(
                            returnAfterConnection: true,
                          ),
                        if (product != null)
                          FilledButton(
                            key: const ValueKey('buy-journeys'),
                            onPressed:
                                purchases.isAvailable &&
                                    !purchases.busy &&
                                    !purchases.checkingStore
                                ? () => purchases.buyProduct(product)
                                : null,
                            child: Text(
                              t([
                                'Unlock once · ${product.price}',
                                '한 번 구매 · ${product.price}',
                                '買い切り・${product.price}',
                                '一次購買・${product.price}',
                              ]),
                            ),
                          ),
                        if (product == null) ...[
                          Text(
                            purchases.checkingStore
                                ? t([
                                    'Checking Google Play…',
                                    'Google Play 확인 중…',
                                    'Google Playを確認中…',
                                    '正在確認Google Play…',
                                  ])
                                : t([
                                    'Google Play pricing is unavailable right now. You can keep using the free chapters.',
                                    '지금 Google Play 가격을 불러올 수 없습니다. 무료 첫 장은 계속 사용할 수 있습니다.',
                                    '現在Google Playの価格を読み込めません。無料の章はそのまま使えます。',
                                    '目前無法取得Google Play價格。免費章節仍可繼續使用。',
                                  ]),
                          ),
                          TextButton(
                            onPressed: purchases.checkingStore || purchases.busy
                                ? null
                                : purchases.refreshCatalog,
                            child: Text(copy.t('retry')),
                          ),
                        ],
                      ],
                      const SizedBox(height: 12),
                      const PurchaseStatusBanner(),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(l.cancel),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
