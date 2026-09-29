import 'package:flutter/widgets.dart';

class SystemCopy {
  final int language;
  SystemCopy(BuildContext context)
    : language = switch (Localizations.localeOf(context).languageCode) {
        'ko' => 0,
        'ja' => 2,
        'zh' => 3,
        _ => 1,
      };
  String get(String key) => _copy[key]![language];
  static const _copy = <String, List<String>>{
    'status': ['상태창', 'Status', 'ステータス', '狀態視窗'],
    'subtitle': [
      '현실의 한 걸음이, 나의 성장으로.',
      'One real step. A little more you.',
      '現実の一歩を、自分の成長に。',
      '現實中的一步，成為自己的成長。',
    ],
    'journal': ['성장 기록', 'Journal', '成長記録', '成長記錄'],
    'explore': ['탐험', 'Explore', '探索', '探索'],
    'offer': ['돌발 퀘스트', 'Unexpected quest', '突発クエスト', '突發任務'],
    'arrival': [
      '새로운 의뢰가 도착했습니다',
      'A new request has arrived',
      '新しい依頼が届きました',
      '收到新的委託',
    ],
    'accepted': ['수행 중인 의뢰', 'Request in progress', '進行中の依頼', '正在進行的委託'],
    'accept': ['수락하기', 'Accept', '受ける', '接受'],
    'decline': ['거절하기', 'Decline', '断る', '拒絕'],
    'abandon': ['의뢰 그만두기', 'Leave this request', '依頼をやめる', '放棄此委託'],
    'noPenalty': [
      '거절하거나 그만둬도 성장은 그대로입니다.',
      'Declining or leaving keeps your progress.',
      '断っても、やめても成長はそのまま。',
      '拒絕或放棄不會失去已有成長。',
    ],
    'offerUntil': ['수락 기한', 'Accept by', '受付期限', '接受期限'],
    'finishUntil': ['수행 기한', 'Finish by', '完了期限', '完成期限'],
    'duration': [
      '수락 후 20분 안에 완료',
      'Finish within 20 minutes of accepting',
      '受けてから20分以内に完了',
      '接受後20分鐘內完成',
    ],
    'done': ['완료 보고', 'Report completion', '完了を報告', '報告完成'],
    'questReward': ['퀘스트 보상', 'Quest reward', 'クエスト報酬', '任務獎勵'],
    'achievementReward': ['업적 추가 보상', 'Achievement bonus', '実績ボーナス', '成就獎勵'],
    'success': ['퀘스트 완료', 'Quest complete', 'クエスト完了', '任務完成'],
    'levelUp': ['레벨 상승', 'Level up', 'レベルアップ', '等級提升'],
    'saved': [
      '성장 기록에 저장되었습니다',
      'Saved in your journal',
      '成長記録に保存しました',
      '已儲存到成長記錄',
    ],
    'questFocus': ['퀘스트 분야', 'Quest focus', 'クエスト分野', '任務領域'],
    'next': ['다음 레벨까지', 'To the next level', '次のレベルまで', '距離下一等級'],
    'return': ['확인', 'Continue', '確認', '確認'],
    'close': ['닫기', 'Close', '閉じる', '關閉'],
    'retry': ['다시 저장', 'Retry saving', '保存を再試行', '重新儲存'],
    'error': [
      '저장을 마치지 못했습니다. 다시 시도해 주세요.',
      'Saving did not finish. Please retry.',
      '保存が完了しませんでした。再試行してください。',
      '儲存未完成，請重試。',
    ],
    'waiting': ['시스템 대기 중', 'System standing by', 'システム待機中', '系統待命中'],
    'waitingBody': [
      '일상 퀘스트를 이어가면, 여유에 맞는 작은 의뢰가 찾아옵니다.',
      'As you complete everyday quests, a small request may arrive when you have time.',
      '日常のクエストを続けると、余裕に合わせた小さな依頼が届くことがあります。',
      '完成日常任務後，有空時可能會收到小委託。',
    ],
    'enabled': [
      '돌발 의뢰 받기',
      'Receive unexpected quests',
      '突発クエストを受け取る',
      '接收突發委託',
    ],
    'expired': [
      '이번 의뢰의 시간이 지났습니다. 기존 성장은 그대로입니다.',
      'This request has ended. Your progress is safe.',
      '今回の依頼は終了しました。これまでの成長はそのままです。',
      '此次委託已結束，已有成長保留。',
    ],
    'emptyJournal': [
      '첫 퀘스트를 완료하면, 실제 받은 보상이 여기에 기록됩니다.',
      'Complete a quest to record the rewards you really earned.',
      'クエストを完了すると、実際に受け取った報酬がここに記録されます。',
      '完成任務後，這裡將記錄實際獲得的獎勵。',
    ],
    'journalNote': [
      '이 화면을 도입한 이후의 완료 기록입니다. 이전 성장은 유지됩니다.',
      'Completion receipts start with this update. Earlier progress is preserved.',
      'この画面の導入以降の完了記録です。以前の成長は保持されます。',
      '此更新之後的完成記錄。此前的成長仍然保留。',
    ],
    'today': ['오늘 퀘스트', 'Quests today', '今日のクエスト', '今日任務'],
    'yesterday': ['어제 퀘스트', 'Quests yesterday', '昨日のクエスト', '昨日任務'],
    'noRecord': ['기록 없음', 'No record', '記録なし', '尚無紀錄'],
    'details': ['상세 상태', 'Status details', '詳細ステータス', '詳細狀態'],
    'reflection': ['기록의 잔향', 'Echo of a thought', '記録の残響', '記錄的迴響'],
    'reflectionTask': [
      '오늘 배운 것을 한 문장으로 정리하기',
      'Sum up something you learned today in one sentence',
      '今日学んだことを一文でまとめる',
      '用一句話總結今天學到的內容',
    ],
    'space': ['작은 질서', 'A little order', '小さな秩序', '小小的秩序'],
    'spaceTask': [
      '눈앞의 물건 세 개를 제자리에 놓기',
      'Put three nearby objects back in their place',
      '目の前の物を3つ、元の場所に戻す',
      '將眼前的三件物品放回原位',
    ],
    'pause': ['잠깐의 여백', 'Room to pause', 'ひと息の余白', '片刻的留白'],
    'pauseTask': [
      '편한 자세로 앉아 3분 쉬기',
      'Sit comfortably and take a three-minute break',
      '楽な姿勢で座って3分休む',
      '舒適地坐下，休息三分鐘',
    ],
    'kindness': ['다정한 한 문장', 'A kind sentence', 'やさしい一言', '溫柔的一句話'],
    'kindnessTask': [
      '나 자신에게 다정한 말 한 문장 적기',
      'Write one kind sentence to yourself',
      '自分にやさしい言葉を一文書く',
      '寫一句溫柔的話給自己',
    ],
  };
}
