import 'dart:convert';
import 'package:flutter/services.dart';
import 'journey_progress.dart';

int journeyLanguage(String locale) => switch (locale) {
  'ko' => 1,
  'ja' => 2,
  'zh' => 3,
  _ => 0,
};

class JourneyMission {
  final List<String> titles;
  final List<List<String>> instructions;
  final List<String> smallInstructions;
  const JourneyMission(this.titles, this.instructions, this.smallInstructions);
  String title(String locale) => titles[journeyLanguage(locale)];
  List<String> steps(String locale, {bool shortVersion = false}) => shortVersion
      ? [smallInstructions[journeyLanguage(locale)]]
      : instructions[journeyLanguage(locale)];
}

class JourneyCatalog {
  static Future<JourneyCatalog>? _cached;
  final Map<JourneyKind, List<JourneyMission>> routes;
  const JourneyCatalog(this.routes);
  static Future<JourneyCatalog> load() =>
      _cached ??= _load().catchError((Object error) {
        _cached = null;
        throw error;
      });
  static Future<JourneyCatalog> _load() async {
    final routes = <JourneyKind, List<JourneyMission>>{};
    for (final kind in JourneyKind.values) {
      final raw =
          jsonDecode(
                await rootBundle.loadString(
                  'assets/journeys/${kind.name}.json',
                ),
              )
              as List;
      if (raw.length != journeyStageCount) {
        throw const FormatException('Incomplete route');
      }
      routes[kind] = List.unmodifiable(
        raw.map((value) {
          final titles = List<String>.from(value['title']);
          final small = List<String>.from(value['small']);
          final steps = (value['steps'] as List)
              .map((v) => List<String>.from(v))
              .toList();
          if (titles.length != 4 ||
              small.length != 4 ||
              small.any((s) => s.trim().isEmpty) ||
              steps.length != 4 ||
              steps.any(
                (s) => s.length != 2 || s.any((t) => t.trim().isEmpty),
              ) ||
              titles.any((s) => s.trim().isEmpty)) {
            throw const FormatException('Incomplete translation');
          }
          return JourneyMission(
            List.unmodifiable(titles),
            List.unmodifiable(steps),
            List.unmodifiable(small),
          );
        }),
      );
    }
    return JourneyCatalog(Map.unmodifiable(routes));
  }

  JourneyMission mission(JourneyKind kind, int stage) => routes[kind]![stage];
}

class JourneyCopy {
  String shortTitle(JourneyKind kind) => choose(switch (kind) {
    JourneyKind.learning => ['Learning route', '학습 루트', '学びのルート', '學習路線'],
    JourneyKind.order => ['Order route', '정리 루트', '片付けルート', '整理路線'],
    JourneyKind.vitality => ['Reset route', '회복 루트', '休息のルート', '休息路線'],
    JourneyKind.connection => ['Connection route', '관계 루트', 'つながりルート', '交流路線'],
  });
  final String locale;
  const JourneyCopy(this.locale);
  String choose(List<String> values) => values[journeyLanguage(locale)];
  String title(JourneyKind kind) => choose(switch (kind) {
    JourneyKind.learning => [
      'From curious to capable',
      '배움에서 결과까지',
      '気になることを、できることへ',
      '從好奇到做得到',
    ],
    JourneyKind.order => [
      'A space that works for you',
      '내 생활에 맞는 공간',
      '自分に合う場所を作る',
      '讓空間適合自己',
    ],
    JourneyKind.vitality => [
      'Make room to move',
      '편안하게 움직이는 일상',
      '無理なく動ける毎日へ',
      '讓日常有活動的空間',
    ],
    JourneyKind.connection => [
      'Connect in your own way',
      '내 속도로 관계 가꾸기',
      '自分のペースでつながる',
      '用自己的步調連結',
    ],
  });
  String description(JourneyKind kind) => choose(switch (kind) {
    JourneyKind.learning => [
      'Turn a topic into a small result: recall, practise, make and review.',
      '궁금한 주제를 복습·연습·제작으로 작은 결과물까지 연결합니다.',
      '知りたいことを、思い出す・試す・作る・見直すことで小さな成果に。',
      '透過回想、練習、製作與回顧，把想學的主題變成小成果。',
    ],
    JourneyKind.order => [
      'Clear one useful space, make things easier to find and build a reset you can repeat.',
      '쓸 공간을 만들고, 찾기 쉽게 정리하고, 다시 돌아올 방법을 만듭니다.',
      '使える場所を作り、探しやすく整え、また戻れる方法を見つけます。',
      '清出能用的空間，讓物品好找，建立能再次使用的整理方式。',
    ],
    JourneyKind.vitality => [
      'Find comfortable movement breaks and rest options that fit your actual day.',
      '실제 하루에 맞는 가벼운 움직임과 휴식 방법을 찾습니다.',
      'いつもの一日に合う、楽な動きと休む選択肢を見つけます。',
      '找出適合真實日常的輕柔活動與休息選項。',
    ],
    JourneyKind.connection => [
      'Practise listening, thoughtful words and boundaries. Sending a message is always optional.',
      '듣기, 배려하는 말, 경계 표현을 연습합니다. 연락은 언제나 선택입니다.',
      '聞くこと、気づかいの言葉、境界を練習します。連絡するかはいつも自由です。',
      '練習聆聽、體貼表達與界線。傳訊息永遠是選擇。',
    ],
  });
  String chapter(int stage) => choose([
    ['Begin', 'Find your method', 'Make it yours'][stage.clamp(0, 20) ~/ 7],
    ['시작', '방법 찾기', '내 것으로 만들기'][stage.clamp(0, 20) ~/ 7],
    ['始める', '合う方法を探す', '自分の形にする'][stage.clamp(0, 20) ~/ 7],
    ['開始', '找到方法', '變成自己的'][stage.clamp(0, 20) ~/ 7],
  ]);
  String t(String key) => choose(_strings[key]!);
  static const _strings = <String, List<String>>{
    'routes': ['Quest routes', '퀘스트 루트', 'クエストルート', '任務路線'],
    'intro': [
      'A clear next step, without writing a whole plan. Each route has 21 missions. The first 7 are free.',
      '계획을 전부 짜지 않아도 다음 행동이 보이도록. 루트마다 21개 미션, 첫 7개는 무료입니다.',
      '計画を全部作らなくても、次の一歩が分かります。各ルート21ミッション、最初の7つは無料です。',
      '不用先寫完整計畫，也能知道下一步。每條路線21個任務，前7個免費。',
    ],
    'open': ['Open mission', '미션 열기', 'ミッションを開く', '開啟任務'],
    'next': ['Your next mission', '다음 미션', '次のミッション', '下一個任務'],
    'preview': ['Preview', '미리보기', 'プレビュー', '預覽'],
    'free': ['Free chapter', '무료 첫 장', '無料の最初の章', '免費第一章'],
    'freeCount': [
      '7 free · 21 missions',
      '7개 무료 · 전체 21개',
      '7つ無料・全21ミッション',
      '7個免費・共21個任務',
    ],
    'complete': ['Complete edition', '전체 확장', '完全版', '完整版'],
    'start': ['Start this route', '이 루트 시작', 'このルートを始める', '開始這條路線'],
    'resume': ['Continue route', '루트 이어가기', 'ルートを続ける', '繼續路線'],
    'goal': [
      'What would you like to work on?',
      '어떤 목표로 진행할까요?',
      '何に取り組みたいですか？',
      '你想朝什麼目標前進？',
    ],
    'goalHint': [
      'A topic, place or small change. Only you need to understand it.',
      '주제, 공간, 작은 변화. 내가 알아볼 수 있게 적으세요.',
      'テーマ、場所、小さな変化。自分に分かる言葉で。',
      '一個主題、空間或小改變，自己看得懂就好。',
    ],
    'goalMissing': [
      'Add a short goal to start.',
      '짧은 목표를 적어주세요.',
      '短い目標を入力してください。',
      '請寫下一個簡短目標。',
    ],
    'cancel': ['Cancel', '취소', 'キャンセル', '取消'],
    'accept': ['Accept mission', '미션 수락', 'ミッションを受ける', '接受任務'],
    'accepted': ['Mission accepted', '수락한 미션', '受けたミッション', '已接受任務'],
    'done': ['I did this', '실행 완료', 'できた', '我完成了'],
    'note': [
      'One thing to remember (optional)',
      '남길 한 줄 (선택)',
      '残したいこと（任意）',
      '想記住的一件事（選填）',
    ],
    'noteHint': [
      'What did you make, notice or decide?',
      '만든 것, 발견한 것, 결정한 것을 남기세요.',
      '作ったこと、気づいたこと、決めたこと。',
      '做出了什麼、注意到什麼，或做了什麼決定？',
    ],
    'short': ['Small version · 2 min', '작게 하기 · 2분', '小さくやる・2分', '小版本・2分鐘'],
    'usual': ['Usual version', '기본 버전', 'いつもの形', '一般版本'],
    'shortHint': [
      'The small action below is enough to complete this mission.',
      '아래의 작은 행동이면 충분합니다. 짧게 해도 미션을 완료합니다.',
      '下の小さな行動で十分です。小さくやってもミッション完了です。',
      '完成下方的小行動就足夠，一樣能完成任務。',
    ],
    'pace': [
      '21 missions, at your pace. Days off never erase progress.',
      '내 속도로 21개 미션. 쉬는 날에도 진도는 남습니다.',
      '自分のペースで21ミッション。休んでも進み具合は消えません。',
      '照自己的步調完成21個任務。休息不會清除進度。',
    ],
    'finished': ['Route complete', '루트 완료', 'ルート完了', '路線完成'],
    'finishBody': [
      'You have a record of actions and a method you can reuse. Revisit your notes or start again with a new goal.',
      '실행 기록과 다시 쓸 방법을 남겼습니다. 기록을 돌아보거나 새 목표로 다시 시작하세요.',
      '行動の記録と、また使える方法が残りました。記録を見返すか、新しい目標で始めましょう。',
      '你留下了行動紀錄與可再次使用的方法。回顧筆記，或以新目標再開始。',
    ],
    'restart': ['Start a new goal', '새 목표로 시작', '新しい目標で始める', '以新目標開始'],
    'archive': ['Past routes', '지난 루트', 'これまでのルート', '過往路線'],
    'saved': ['Recorded actions', '실행 기록', '行動の記録', '行動紀錄'],
    'noNotes': [
      'Your completed missions and notes will appear here.',
      '완료한 미션과 메모가 여기에 쌓입니다.',
      '完了したミッションとメモがここに残ります。',
      '完成的任務與筆記會留在這裡。',
    ],
    'error': [
      'Could not save. Your step is still here; try again.',
      '저장하지 못했습니다. 단계는 남아 있으니 다시 시도하세요.',
      '保存できませんでした。ステップは残っています。もう一度お試しください。',
      '無法儲存。步驟仍在，請重試。',
    ],
    'retry': ['Try again', '다시 시도', 'もう一度', '重試'],
    'timer': ['Focus on this mission', '이 미션에 집중', 'このミッションに集中', '專注在這個任務'],
    'back': ['Back to route', '루트로 돌아가기', 'ルートに戻る', '回到路線'],
    'locked': [
      'Continue beyond the first chapter',
      '첫 장 다음으로 이어가기',
      '最初の章の、その先へ',
      '繼續第一章之後的旅程',
    ],
    'lockedBody': [
      'Missions 8–21 in all four routes are included in Life Quest Complete. Your first chapter and saved progress remain free.',
      'Life Quest Complete에 네 루트의 8–21번째 미션이 포함됩니다. 첫 장과 저장된 진도는 무료로 남습니다.',
      'Life Quest Completeには4ルートのミッション8〜21が含まれます。最初の章と保存済みの進み具合は無料のままです。',
      'Life Quest Complete包含四條路線的第8–21個任務。第一章與已儲存的進度仍然免費。',
    ],
    'seeComplete': [
      'See Life Quest Complete',
      'Life Quest Complete 보기',
      'Life Quest Completeを見る',
      '查看Life Quest Complete',
    ],
    'previewHint': [
      'Preview only. Complete the current mission to advance in order.',
      '미리보기입니다. 현재 미션을 완료하면 순서대로 진행합니다.',
      'プレビューです。現在のミッションを終えると順に進めます。',
      '這是預覽。完成目前任務後會依序前進。',
    ],
    'sampleHint': [
      'Mission 8 is available as a full preview of the next chapter.',
      '8번째 미션에서 다음 장의 안내를 무료로 미리 볼 수 있습니다.',
      'ミッション8では、次の章の手順を無料でプレビューできます。',
      '第8個任務提供下一章的完整免費預覽。',
    ],
    'evidence': [
      'Progress comes from the actions you record, not a measurement of real-world ability.',
      '진도는 기록한 행동을 보여주며 실제 능력을 측정한 수치는 아닙니다.',
      '進み具合は記録した行動を表すもので、現実の能力の測定値ではありません。',
      '進度呈現的是你記錄的行動，並非現實能力的測量值。',
    ],
    'loadError': [
      'Could not open the route library. Try again.',
      '루트를 불러오지 못했습니다. 다시 시도하세요.',
      'ルートを読み込めませんでした。もう一度お試しください。',
      '無法開啟路線，請重試。',
    ],
    'min': ['min', '분', '分', '分鐘'],
  };
}
