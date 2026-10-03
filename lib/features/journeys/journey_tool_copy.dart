import 'journey_catalog.dart';
import 'journey_progress.dart';
import 'journey_tool.dart';

/// Only offer a worksheet where the mission actually produces a reusable item.
/// Every route includes one in its free chapter, before any purchase decision.
JourneyToolKind? journeyToolFor(JourneyKind kind, int stage) => switch (kind) {
  JourneyKind.learning when [0, 7, 10, 12, 13, 20].contains(stage) =>
    JourneyToolKind.flashcard,
  JourneyKind.order when [6, 7, 13, 16, 20].contains(stage) =>
    JourneyToolKind.checklist,
  JourneyKind.vitality when [6, 7, 13, 18, 20].contains(stage) =>
    JourneyToolKind.routine,
  JourneyKind.connection when [2, 7, 8, 15, 18].contains(stage) =>
    JourneyToolKind.script,
  _ => null,
};

String journeyToolkitTitle(JourneyCopy c) =>
    c.choose(['My toolkit', '내 도구함', '自分の道具箱', '我的工具箱']);
String journeyToolTitle(JourneyToolKind k, JourneyCopy c) =>
    c.choose(switch (k) {
      JourneyToolKind.flashcard => ['Recall card', '복습 카드', '復習カード', '複習卡'],
      JourneyToolKind.checklist => [
        'Reset checklist',
        '정리 체크리스트',
        '片づけチェックリスト',
        '整理清單',
      ],
      JourneyToolKind.routine => [
        'My everyday routine',
        '나의 일상 루틴',
        '自分の生活ルーティン',
        '我的日常步驟',
      ],
      JourneyToolKind.script => [
        'Words to keep',
        '다시 쓸 문장',
        'また使いたい言葉',
        '想再次使用的話',
      ],
    });
List<String> journeyToolLabels(JourneyToolKind k, JourneyCopy c) => switch (k) {
  JourneyToolKind.flashcard => [
    c.choose(['Question or cue', '질문 또는 떠올릴 단서', '問い・思い出すきっかけ', '問題或回想線索']),
    c.choose(['My answer / example', '내 답 또는 예시', '自分の答え・例', '我的答案或例子']),
  ],
  JourneyToolKind.checklist => [
    c.choose(['Space or situation', '공간 또는 상황', '場所・場面', '空間或情境']),
    c.choose(['One action per line', '한 줄에 행동 하나씩', '1行に1つの行動', '每行一個行動']),
  ],
  JourneyToolKind.routine => [
    c.choose(['When / after what?', '언제, 무엇을 한 뒤에?', 'いつ・何をした後？', '何時、做完什麼後？']),
    c.choose(['The action that fits me', '나에게 맞는 행동', '自分に合う行動', '適合我的行動']),
    c.choose(['On a low-energy day', '힘이 없는 날에는', '余裕がない日には', '沒精神的日子']),
  ],
  JourneyToolKind.script => [
    c.choose(['The situation', '사용할 상황', '使いたい場面', '使用情境']),
    c.choose(['In my own words', '내 말투로 쓴 문장', '自分の言葉で', '用自己的語氣']),
  ],
};
String journeyToolHelp(
  JourneyToolKind k,
  JourneyCopy c,
) => c.choose(switch (k) {
  JourneyToolKind.flashcard => [
    'Write what you know now. After completing the mission, hide the answer and recall it from your toolkit. You can improve it later.',
    '지금 아는 만큼 적으세요. 완료 후 도구함에서 답을 가리고 다시 떠올릴 수 있고, 나중에 고칠 수 있습니다.',
    '今わかる範囲で書きましょう。完了後は道具箱で答えを隠して思い出せます。後から直すこともできます。',
    '先寫目前知道的內容。完成後可在工具箱隱藏答案、練習回想，也能隨時修改。',
  ],
  JourneyToolKind.checklist => [
    'Keep a few actions you would actually repeat. Use the checklist again whenever this space needs a reset.',
    '실제로 다시 할 행동 몇 가지만 남기세요. 공간을 정리할 때 도구함에서 하나씩 체크할 수 있습니다.',
    'またできそうな行動を少しだけ残しましょう。片づける時に道具箱から1つずつ確認できます。',
    '留下幾個真的會再做的行動。整理時能從工具箱逐項勾選。',
  ],
  JourneyToolKind.routine => [
    'Connect a small action to an ordinary moment. Keep an easier option for busy days. Choose what feels comfortable.',
    '평소의 순간에 작은 행동을 연결하고 바쁜 날 버전도 남기세요. 편안하게 할 수 있는 행동이면 됩니다.',
    'いつもの場面に小さな行動をつなげ、忙しい日の選択肢も残しましょう。無理なくできることで大丈夫です。',
    '把小行動接在日常時刻後，也留下忙碌時的簡單版本。選擇舒服做得到的就好。',
  ],
  JourneyToolKind.script => [
    'Save a draft you can reuse or adapt. Copying never sends it to anyone; deciding whether to contact someone is yours.',
    '다음에도 고쳐 쓸 문장을 남기세요. 복사는 누구에게도 전송하지 않으며, 연락할지는 직접 선택합니다.',
    'また使ったり書き直したりできる言葉を残しましょう。コピーしても送信されません。連絡するかは自分で決められます。',
    '留下可再次使用或修改的草稿。複製不會傳送給任何人，要不要聯絡由你決定。',
  ],
});
String journeyToolExport(JourneyTool tool, JourneyCopy c) {
  final labels = journeyToolLabels(tool.kind, c);
  return [
    journeyToolTitle(tool.kind, c),
    for (var i = 0; i < labels.length; i++) '${labels[i]}\n${tool.field(i)}',
  ].join('\n\n');
}

/// Clearly labelled sample content, never written to a profile or rewarded.
JourneyTool journeyToolSample(
  JourneyKind kind,
  JourneyCopy c,
) => switch (kind) {
  JourneyKind.learning => JourneyTool(
    kind: JourneyToolKind.flashcard,
    fields: [
      c.choose(['What is a variable?', '변수란 무엇일까?', '変数とは何？', '什麼是變數？']),
      c.choose([
        'A named value I can use in a program. For example: count = 3.',
        '프로그램에서 이름으로 가리켜 사용할 수 있는 값. 예: count = 3.',
        'プログラムで名前を付けて扱える値。例えば count = 3。',
        '在程式中可以用名稱存取的值。例如 count = 3。',
      ]),
    ],
  ),
  JourneyKind.order => JourneyTool(
    kind: JourneyToolKind.checklist,
    fields: [
      c.choose([
        'My desk before work',
        '작업을 시작하기 전 책상',
        '作業を始める前の机',
        '開始工作前的書桌',
      ]),
      c.choose([
        'Put the book back\nClear the cup\nOpen my notebook',
        '책 제자리에 두기\n컵 치우기\n노트 펼치기',
        '本を戻す\nカップを片づける\nノートを開く',
        '把書放回原位\n收走杯子\n打開筆記本',
      ]),
    ],
  ),
  JourneyKind.vitality => JourneyTool(
    kind: JourneyToolKind.routine,
    fields: [
      c.choose(['After I close my laptop', '노트북을 덮은 뒤', 'パソコンを閉じた後', '闔上筆電之後']),
      c.choose([
        'Take a comfortable break away from the screen',
        '화면에서 떨어져 편안하게 잠깐 쉬기',
        '画面から離れて、無理なくひと休み',
        '離開螢幕，舒服地休息片刻',
      ]),
      c.choose([
        'Stay seated and pause for a moment',
        '앉은 채로 잠깐 쉬기',
        '座ったまま少し休む',
        '坐著暫停一下',
      ]),
    ],
  ),
  JourneyKind.connection => JourneyTool(
    kind: JourneyToolKind.script,
    fields: [
      c.choose([
        'An invitation without pressure',
        '부담 없이 제안할 때',
        '気軽に誘いたい時',
        '想輕鬆邀約時',
      ]),
      c.choose([
        'Want to take a short walk this weekend? No worries if you are busy.',
        '주말에 잠깐 산책할래? 바쁘면 다음에 해도 괜찮아.',
        '週末、少し散歩しない？忙しかったら、また今度でも大丈夫。',
        '週末要不要散個步？忙的話改天也沒關係。',
      ]),
    ],
  ),
};
