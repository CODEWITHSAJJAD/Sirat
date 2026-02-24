// ============================================================
// notification_service.dart
// Manages all local notifications: Azan alerts, Islamic reminders,
// and Sahr/Iftar notifications using flutter_local_notifications.
// ============================================================

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:islamic_companion/core/constants/app_constants.dart';
import 'package:islamic_companion/features/prayer/domain/entities/prayer_time_entity.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone data
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Karachi'));

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for Android 13+
    await _requestPermissions();

    // Create notification channels (Android 8+)
    await _createChannels();
    _initialized = true;
  }

  Future<void> _requestPermissions() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin != null) {
      // Request notification permission
      await androidPlugin.requestNotificationsPermission();
      
      // Request exact alarm permission for Android 12+
      await androidPlugin.requestExactAlarmsPermission();
    }
  }

  Future<void> _createChannels() async {
    const azanChannel = AndroidNotificationChannel(
      AppConstants.azanChannelId,
      AppConstants.azanChannelName,
      description: 'Azan alerts for prayer times',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    const reminderChannel = AndroidNotificationChannel(
      AppConstants.reminderChannelId,
      AppConstants.reminderChannelName,
      description: 'Islamic event and Sahr/Iftar reminders',
      importance: Importance.high,
    );

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(azanChannel);
    await androidPlugin?.createNotificationChannel(reminderChannel);
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Future: navigate to relevant screen based on payload
    debugPrint('Notification tapped: ${response.payload}');
  }

  /// Schedule Azan notifications for all 5 prayers of the day.
  Future<void> scheduleAzanNotifications(PrayerTimeEntity prayers) async {
    // Cancel previous day's prayers first
    await cancelAzanNotifications();

    final prayerList = prayers.allPrayers;
    for (int i = 0; i < prayerList.length; i++) {
      final prayer = prayerList[i];
      final scheduledTime = prayer.value;

      // Only schedule if prayer time is in the future
      if (scheduledTime.isAfter(DateTime.now())) {
        await _scheduleNotification(
          id: i + 100, // IDs 100–104 reserved for Azan
          title: '🕌 ${prayer.key} Time',
          body: 'Time for ${prayer.key} prayer — Allahu Akbar',
          scheduledDate: scheduledTime,
          channelId: AppConstants.azanChannelId,
          channelName: AppConstants.azanChannelName,
          payload: 'azan_${prayer.key.toLowerCase()}',
        );
      }
    }
  }

  /// Schedule a Sahr reminder (15 min before Sahr)
  Future<void> scheduleSahrReminder(DateTime sahrTime) async {
    final reminderTime = sahrTime.subtract(const Duration(minutes: 15));
    if (reminderTime.isAfter(DateTime.now())) {
      await _scheduleNotification(
        id: 200,
        title: '🌙 Sahr Reminder',
        body: 'Sahr time in 15 minutes — don\'t miss your sehri!',
        scheduledDate: reminderTime,
        channelId: AppConstants.reminderChannelId,
        channelName: AppConstants.reminderChannelName,
        payload: 'sahr_reminder',
      );
    }
  }

  /// Schedule an Iftar reminder (5 min before Iftar)
  Future<void> scheduleIftarReminder(DateTime iftarTime) async {
    final reminderTime = iftarTime.subtract(const Duration(minutes: 5));
    if (reminderTime.isAfter(DateTime.now())) {
      await _scheduleNotification(
        id: 201,
        title: '🌅 Iftar Coming Soon',
        body: 'Iftar in 5 minutes — prepare to break your fast!',
        scheduledDate: reminderTime,
        channelId: AppConstants.reminderChannelId,
        channelName: AppConstants.reminderChannelName,
        payload: 'iftar_reminder',
      );
    }
  }

  /// Schedule an Islamic event reminder
  Future<void> scheduleEventReminder({
    required int id,
    required String eventName,
    required DateTime eventDate,
  }) async {
    final reminderTime = eventDate.subtract(const Duration(days: 1));
    if (reminderTime.isAfter(DateTime.now())) {
      await _scheduleNotification(
        id: id,
        title: '📅 Islamic Event Tomorrow',
        body: eventName,
        scheduledDate: reminderTime,
        channelId: AppConstants.reminderChannelId,
        channelName: AppConstants.reminderChannelName,
        payload: 'event_$eventName',
      );
    }
  }

  /// Show an immediate notification (for testing or streak milestones)
  Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    await _plugin.show(
      999, // id
      title, // title
      body, // body
      const NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.reminderChannelId,
          AppConstants.reminderChannelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required String channelId,
    required String channelName,
    String? payload,
  }) async {
    final tzDate = tz.TZDateTime.from(scheduledDate, tz.local);
    await _plugin.zonedSchedule(
      id, // id
      title, // title
      body, // body
      tzDate, // scheduledDate
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          importance: Importance.max,
          priority: Priority.high,
          enableVibration: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  Future<void> cancelAzanNotifications() async {
    // Cancel IDs 100–104 (Azan notifications)
    for (int i = 100; i <= 104; i++) {
      await _plugin.cancel(i);
    }
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}