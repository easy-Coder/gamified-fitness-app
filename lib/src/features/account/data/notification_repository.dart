import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:logger/logger.dart';

class NotificationRepository {
  NotificationRepository();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static const _channelId = 'rankupfit_general';
  static const _channelName = 'General Notifications';
  static const _channelDescription =
      'Notifications for reminders, achievements, and progress.';

  Future<bool> initialize() async {
    try {
      Logger().d('Initializing notification plugin');
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const darwinSettings = DarwinInitializationSettings();

      const initializationSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
      );

      return await _plugin.initialize(initializationSettings) ?? false;
    } catch (e) {
      Logger().e('Failed to initialize notification plugin: $e');
      throw Failure(message: 'Failed to initialize notification plugin: $e');
    }
  }

  Future<void> requestIOSPermission() async {
    await IOSFlutterLocalNotificationsPlugin().requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> sendNotification({
    required String title,
    required String body,
    String? payload,
    int id = 0,
  }) async {
    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: const DefaultStyleInformation(true, true),
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    await _plugin.show(id, title, body, notificationDetails, payload: payload);
  }

  Future<void> disableNotifications() async {
    await _plugin.cancelAll();
  }
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final repository = NotificationRepository();
  return repository;
});
