import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/src/features/account/application/notification_service.dart';
import 'package:gamified/src/features/account/application/preference_service.dart';

class NotificationNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // no-op
  }

  Future<void> updateNotificationPreferences({
    bool? workoutReminders,
    bool? achievementNotifications,
    bool? weeklyProgress,
  }) async {
    if (state is! AsyncData) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(preferenceServiceProvider)
          .updateNotificationPreferences(
            workoutReminders: workoutReminders,
            achievementNotifications: achievementNotifications,
            weeklyProgress: weeklyProgress,
          ),
    );
  }

  /// Request notification permission (updates notifier state for loading/error)
  void requestPermission() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async =>
          await ref.read(notificationServiceProvider).requestPermission(),
    );
  }

  Future<void> sendTestNotification() async {
    if (state is! AsyncData) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(notificationServiceProvider).sendTestNotification(),
    );
  }

  Future<void> disableNotifications() async {
    if (state is! AsyncData) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(notificationServiceProvider).disableNotifications(),
    );
  }
}

final notificationNotifierProvider =
    AsyncNotifierProvider<NotificationNotifier, void>(NotificationNotifier.new);
