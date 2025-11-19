import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/logger.dart';
import 'package:gamified/src/features/account/data/notification_repository.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  final Ref _ref;

  NotificationService(this._ref);

  /// Check if notification permission is granted and is stored inside preference
  Stream<PermissionStatus> hasPermission() async* {
    while (true) {
      try {
        final status = await Permission.notification.status;

        yield status;
      } catch (e) {
        _ref
            .read(loggerProvider)
            .e('Failed to check notification permission: $e');
        yield PermissionStatus.denied;
      }
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  /// Request notification permission and initialize the plugin
  Future<bool> requestPermission() async {
    try {
      final repo = _ref.read(notificationRepositoryProvider);

      final initialized = await repo.initialize();
      if (!initialized) {
        if (Platform.isIOS) {
          await repo.requestIOSPermission();
        }
      }
      return true;
    } catch (e) {
      _ref
          .read(loggerProvider)
          .e('Failed to request notification permission: $e');
      throw Failure(message: 'Failed to request notification permission: $e');
    }
  }

  /// Send a test notification
  Future<void> sendTestNotification() async {
    try {
      final repo = _ref.read(notificationRepositoryProvider);

      await repo.sendNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: 'RankUpFit',
        body: 'This is what your reminders will look like.',
      );
    } on Failure catch (e) {
      _ref.read(loggerProvider).e(e.message, error: e);
      rethrow;
    } catch (e) {
      _ref.read(loggerProvider).e('Failed to send test notification: $e');
      throw Failure(message: 'Failed to send test notification: $e');
    }
  }

  /// Disable all notifications (cancel all pending)
  Future<void> disableNotifications() async {
    try {
      final repo = _ref.read(notificationRepositoryProvider);
      await repo.disableNotifications();
    } catch (e) {
      _ref.read(loggerProvider).e('Failed to disable notifications: $e');
      throw Failure(message: 'Failed to disable notifications: $e');
    }
  }
}

final notificationServiceProvider = Provider((ref) {
  return NotificationService(ref);
});

final notificationPermissionProvider = StreamProvider<PermissionStatus>((ref) {
  return ref.read(notificationServiceProvider).hasPermission();
});
