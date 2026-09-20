import 'package:life_quest_final_v2/features/backup/device_backup.dart';
import 'package:life_quest_final_v2/models/character.dart';

DeviceSnapshot backupFixture({String name = '검증용 각성자', int level = 1}) =>
    DeviceSnapshot.create(
      createdAt: DateTime.utc(2026, 9, 14, 1),
      profile: {
        'character': Character(
          name: name,
          level: level,
          title: 't0',
          xp: 60,
          maxXp: 150,
          strength: 10,
          wisdom: 10,
          health: 10,
          charisma: 10,
          statPoints: 0,
          skillPoints: 0,
          totalQuestCompletions: 1,
          storyChoices: {'prologue/signal': 'answer'},
          activeStoryChapterId: 'courtyard',
        ).toJson(),
        'dailyQuests': [
          {
            'id': 'director:2026-09-14:read',
            'name': '조용히 책 읽기',
            'xp': 60,
            'type': 0,
            'category': 1,
            'difficulty': 0,
            'isCompleted': true,
            'directorTemplateId': 'read',
            'scheduledDay': '2026-09-14',
            'estimatedMinutes': 5,
          },
        ],
        'weeklyQuests': [],
        'monthlyQuests': [],
        'yearlyQuests': [],
        'themeMode': 2,
        'localeCode': 'ko',
        'isNotificationEnabled': true,
      },
      director: {
        'profile': {
          'goal': '퇴근 후 조용한 영어 공부',
          'minutes': 15,
          'energy': 2,
          'configured': true,
          'focuses': ['learning'],
        },
        'history': [
          {
            'questId': 'director:2026-09-14:read',
            'templateId': 'read',
            'feedback': 'completed',
            'at': '2026-09-14T09:00:00.000',
            'title': '조용히 책 읽기',
            'minutes': 5,
          },
        ],
        'day': '2026-09-14',
        'accepted': {'director:2026-09-14:read': 5},
      },
    );
