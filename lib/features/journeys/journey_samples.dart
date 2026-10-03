import 'package:flutter/material.dart';
import 'journey_catalog.dart';
import 'journey_progress.dart';
import 'journey_tool_copy.dart';
import 'journey_tool_widgets.dart';

/// Uses the shipped content, not a separate marketing-only example. Opening a
/// sample neither starts a route nor grants ownership or progress.
class JourneySamples extends StatefulWidget {
  const JourneySamples({super.key});
  @override
  State<JourneySamples> createState() => _JourneySamplesState();
}

class _JourneySamplesState extends State<JourneySamples>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  JourneyKind _kind = JourneyKind.learning;
  Future<JourneyCatalog>? _catalog;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final copy = JourneyCopy(Localizations.localeOf(context).languageCode);
    return ExpansionTile(
      key: const ValueKey('journey-purchase-samples'),
      maintainState: true,
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: 20),
      onExpansionChanged: (open) {
        if (open && _catalog == null) {
          setState(() {
            _catalog = JourneyCatalog.load();
          });
        }
      },
      title: Text(
        copy.choose([
          'Try a mission and its tools before buying',
          '미션과 도구 먼저 체험하기',
          '購入前にミッションと道具を試す',
          '購買前先試任務與工具',
        ]),
      ),
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final kind in JourneyKind.values)
              ChoiceChip(
                key: ValueKey('journey-sample-${kind.name}'),
                label: Text(copy.shortTitle(kind)),
                selected: _kind == kind,
                onSelected: (_) => setState(() => _kind = kind),
              ),
          ],
        ),
        const SizedBox(height: 16),
        FutureBuilder<JourneyCatalog>(
          future: _catalog,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return TextButton(
                onPressed: () => setState(() {
                  _catalog = JourneyCatalog.load();
                }),
                child: Text(copy.t('retry')),
              );
            }
            if (!snapshot.hasData) return const LinearProgressIndicator();
            final mission = snapshot.data!.mission(_kind, journeyFreeStages);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  copy.description(_kind),
                  style: const TextStyle(height: 1.5),
                ),
                const SizedBox(height: 16),
                Text(
                  '${copy.t('preview')} · ${journeyFreeStages + 1}/$journeyStageCount',
                  style: const TextStyle(color: Color(0xFF80DCFB)),
                ),
                const SizedBox(height: 8),
                Text(
                  mission.title(copy.locale),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                for (final step in mission.steps(copy.locale))
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(step, style: const TextStyle(height: 1.6)),
                  ),
                const SizedBox(height: 16),
                Text(
                  copy.t('short'),
                  style: const TextStyle(color: Color(0xFF80DCFB)),
                ),
                const SizedBox(height: 8),
                Text(
                  mission.steps(copy.locale, shortVersion: true).single,
                  style: const TextStyle(height: 1.6),
                ),
                const SizedBox(height: 16),
                Text(
                  copy.choose([
                    'Try a sample result · example content',
                    '결과물 체험 · 예시 내용',
                    '成果を体験・サンプルの内容',
                    '試用成果・範例內容',
                  ]),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                JourneyToolCard(
                  key: ValueKey('sample-tool-${_kind.name}'),
                  tool: journeyToolSample(_kind, copy),
                ),
                const SizedBox(height: 16),
                Text(
                  copy.choose([
                    'This is mission 8 from the complete route. Reading this sample does not change your progress.',
                    '전체 루트의 실제 8번째 미션입니다. 미리보기로 진도는 바뀌지 않습니다.',
                    '完全版ルートの実際の8番目のミッションです。読むだけで進み具合は変わりません。',
                    '這是完整路線實際的第8個任務。閱讀預覽不會改變進度。',
                  ]),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
