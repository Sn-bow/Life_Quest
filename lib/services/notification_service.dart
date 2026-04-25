import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:io';

// 알림 텍스트 다국어 헬퍼
// [langCode]: CharacterState.locale?.languageCode 전달, null이면 기기 언어 사용
String _localizedString({
  required String ko,
  required String en,
  required String ja,
  required String zh,
  String? langCode,
}) {
  final lang =
      (langCode ?? Platform.localeName.split('_').first).toLowerCase();
  switch (lang) {
    case 'ja':
      return ja;
    case 'zh':
      return zh;
    case 'ko':
      return ko;
    default:
      return en;
  }
}

class NotificationService {
  // 싱글톤 패턴으로 인스턴스 관리
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() {
    return _instance;
  }
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // 안드로이드 초기화 설정 — 알림 소형 아이콘은 모노크롬(흰색+투명) drawable 사용
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification');

    // iOS 초기화 설정 (권한 요청 포함)
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // 타임존 데이터 초기화
    tz.initializeTimeZones();
    try {
      final timeZoneInfo = await FlutterTimezone.getLocalTimezone();
      final String timeZoneName = timeZoneInfo.identifier;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      debugPrint('Error getting local timezone: $e - falling back to Asia/Seoul');
      try {
        tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
      } catch (_) {}
    }

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Android 13+ (API 33+) 알림 권한 요청
    if (Platform.isAndroid) {
      final androidPlugin = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.requestNotificationsPermission();
    }
  }

  // 매일 아침 알림 예약 (기본 9시)
  // [languageCode]: CharacterState.locale?.languageCode — null이면 기기 언어 사용
  Future<void> scheduleDailyNotification({int hour = 9, String? languageCode}) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0, // 알림 ID
      _localizedString(
        ko: '오늘의 퀘스트를 시작하세요!',
        en: "Start today's quests!",
        ja: '今日のクエストを始めよう！',
        zh: '开始今日任务！',
        langCode: languageCode,
      ),
      _localizedString(
        ko: '새로운 하루가 시작되었습니다. 당신의 성장을 기록해 보세요.',
        en: 'A new day has begun. Record your growth.',
        ja: '新しい一日が始まりました。あなたの成長を記録しましょう。',
        zh: '新的一天开始了。记录你的成长吧。',
        langCode: languageCode,
      ),
      _nextInstanceOf(hour),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_notification_channel_id',
          'Daily Notifications',
          channelDescription: 'Channel for daily quest reminders',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@drawable/ic_notification',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // 매일 같은 시간에 반복
    );
  }

  tz.TZDateTime _nextInstanceOf(int hour) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // 매일 저녁 알림 예약 (기본 20시)
  // [languageCode]: CharacterState.locale?.languageCode — null이면 기기 언어 사용
  Future<void> scheduleNightReminder({int hour = 20, String? languageCode}) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      1, // 알림 ID (아침 알림과 다르게)
      _localizedString(
        ko: '오늘 퀘스트를 모두 완료하셨나요?',
        en: "Did you complete today's quests?",
        ja: '今日のクエストをすべて完了しましたか？',
        zh: '今天的任务都完成了吗？',
        langCode: languageCode,
      ),
      _localizedString(
        ko: '아직 완료하지 못한 퀘스트가 있다면 HP가 감소할 수 있어요!',
        en: 'Incomplete quests may reduce your HP!',
        ja: '未完了のクエストがあるとHPが減少することがあります！',
        zh: '还有未完成的任务，可能会减少HP！',
        langCode: languageCode,
      ),
      _nextInstanceOf(hour),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'night_reminder_channel_id',
          'Night Reminders',
          channelDescription: 'Channel for night quest reminders',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@drawable/ic_notification',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // 매일 같은 시간에 반복
    );
  }


  // 모든 예약된 알림 취소
  Future<void> cancelAllNotifications() async {
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
    } catch (e) {
      debugPrint('Error canceling notifications: $e');
    }
  }
}
