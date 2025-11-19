import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/theme/theme.dart';
import 'package:gamified/src/features/account/application/notification_service.dart';
import 'package:gamified/src/features/account/data/preference_repository.dart';
import 'package:gamified/src/features/account/presentation/notification/controller/notification_controller.dart';
import 'package:open_settings_plus/core/open_settings_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PushNotificationsPage extends ConsumerStatefulWidget {
  const PushNotificationsPage({super.key});

  @override
  ConsumerState<PushNotificationsPage> createState() =>
      _PushNotificationsPageState();
}

class _PushNotificationsPageState extends ConsumerState<PushNotificationsPage>
    with WidgetsBindingObserver {
  bool? _hasNotificationPermission;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _requestNotificationPermission() async {
    ref.read(notificationNotifierProvider.notifier).requestPermission();
  }

  Future<void> _openNotificationSettings() async {
    final opened = switch (OpenSettingsPlus.shared) {
      OpenSettingsPlusAndroid settings => await settings.appSettings(),
      OpenSettingsPlusIOS settings => await settings.appSettings(),
      _ => false,
    };

    if (!opened && mounted) {
      Fluttertoast.showToast(msg: 'Unable to open system settings.');
    }
  }

  Future<void> _sendTestNotification() async {
    ref.read(notificationNotifierProvider.notifier).sendTestNotification();

    Fluttertoast.showToast(msg: 'Test notification sent!');
  }

  Future<void> _disableNotifications() async {
    ref.read(notificationNotifierProvider.notifier).disableNotifications();

    Fluttertoast.showToast(
      msg: 'Pending notifications cleared. You can re-enable anytime.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final hasPermission = ref.watch(notificationPermissionProvider);
    ref.listen(notificationNotifierProvider, (previous, next) {
      if (next.hasError) {
        Fluttertoast.showToast(msg: (next.error! as Failure).message);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Push Notifications'),
        titleTextStyle: theme.textTheme.large.copyWith(
          color: theme.colorScheme.foreground,
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: hasPermission.when(
        data: (permission) => permission.isGranted
            ? _buildContent(context)
            : _NotificationPermissionRequired(
                permission: permission,
                onRequest: _requestNotificationPermission,
                onOpenSettings: _openNotificationSettings,
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final preferenceState = ref.watch(preferenceProvider);
    return preferenceState.when(
      data: (preference) => SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection(context, 'General', [
              _NotificationSwitch(
                title: 'Workout Reminders',
                subtitle: 'Get notified about your scheduled workouts',
                icon: LucideIcons.dumbbell,
                value: preference.workoutReminders,
                onChanged: (value) => _onToggle(workoutReminders: value),
              ),
              _NotificationSwitch(
                title: 'Achievement Notifications',
                subtitle: 'Celebrate your milestones and achievements',
                icon: LucideIcons.trophy,
                value: preference.achievementNotifications,
                onChanged: (value) =>
                    _onToggle(achievementNotifications: value),
              ),
              _NotificationSwitch(
                title: 'Weekly Progress',
                subtitle: 'Receive weekly summaries of your progress',
                icon: LucideIcons.trendingUp,
                value: preference.weeklyProgress,
                onChanged: (value) => _onToggle(weeklyProgress: value),
              ),
            ]),
            AppSpacing.verticalXxl.verticalSpace,
            _buildSection(context, 'System', [
              _NotificationSystemItem(
                title: 'Notification Permission',
                subtitle: 'Manage system notification permissions',
                icon: LucideIcons.settings,
                onTap: _openNotificationSettings,
              ),
              if (kDebugMode) ...[
                _NotificationSystemItem(
                  title: 'Disable Notifications',
                  subtitle: 'Clear pending and scheduled alerts',
                  icon: LucideIcons.bellOff,
                  onTap: _disableNotifications,
                ),
              ],
            ]),
          ],
        ),
      ),
      error: (Object error, StackTrace stackTrace) {
        return Center(child: Text('Error: $error'));
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void _onToggle({
    bool? workoutReminders,
    bool? achievementNotifications,
    bool? weeklyProgress,
  }) {
    ref
        .read(notificationNotifierProvider.notifier)
        .updateNotificationPreferences(
          workoutReminders: workoutReminders,
          achievementNotifications: achievementNotifications,
          weeklyProgress: weeklyProgress,
        );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> items) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: theme.textTheme.h3.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSpacing.verticalMd.verticalSpace,
        Card.outlined(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          margin: EdgeInsets.zero,
          child: Column(children: items),
        ),
      ],
    );
  }
}

class _NotificationPermissionRequired extends ConsumerWidget {
  final VoidCallback onRequest;
  final VoidCallback onOpenSettings;
  final PermissionStatus permission;

  const _NotificationPermissionRequired({
    required this.onRequest,
    required this.onOpenSettings,
    required this.permission,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final notifier = ref.watch(notificationNotifierProvider);
    final isRequesting = notifier.isLoading;
    return Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            LucideIcons.bellOff,
            size: 56,
            color: theme.colorScheme.mutedForeground,
          ),
          AppSpacing.verticalLg.verticalSpace,
          Text(
            'Enable Notifications',
            style: theme.textTheme.h3.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          AppSpacing.verticalSm.verticalSpace,
          Text(
            'Allow notifications in your device settings to manage reminders, achievements, and weekly progress alerts.',
            style: theme.textTheme.muted.copyWith(fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
          AppSpacing.verticalXxl.verticalSpace,
          if (permission.isPermanentlyDenied)
            // Beautified important message box with icon and title for emphasis
            Container(
              padding: EdgeInsets.symmetric(
                vertical: AppSpacing.lg,
                horizontal: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.destructive.withOpacity(0.06),
                border: Border.all(
                  color: theme.colorScheme.destructive,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    LucideIcons.info,
                    color: theme.colorScheme.destructive,
                    size: 28,
                  ),
                  AppSpacing.horizontalMd.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Action Required',
                          style: theme.textTheme.h4.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.destructive,
                          ),
                        ),
                        AppSpacing.verticalXs.verticalSpace,
                        Text(
                          'Notifications are blocked for this app. You must open system settings to allow notifications.',
                          style: theme.textTheme.p.copyWith(
                            fontSize: 14.sp,
                            color: theme.colorScheme.destructive,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Spacer(),
          FilledButton(
            onPressed: isRequesting ? null : onRequest,
            child: isRequesting
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Allow Notifications'),
          ),
          AppSpacing.verticalXs.verticalSpace,
          OutlinedButton(
            onPressed: onOpenSettings,
            child: const Text('Open Settings'),
          ),
          AppSpacing.verticalXs.verticalSpace,
        ],
      ),
    );
  }
}

class _NotificationSwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationSwitch({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final theme = ShadTheme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, color: appColors.grey700, size: 20),
          AppSpacing.horizontalSm.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.h4),
                4.verticalSpace,
                Text(
                  subtitle,
                  style: theme.textTheme.muted.copyWith(fontSize: 12.sp),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _NotificationTimeItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _NotificationTimeItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final theme = ShadTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: AppSpacing.sm),
        child: Row(
          children: [
            Icon(icon, color: appColors.grey700, size: 20),
            AppSpacing.horizontalSm.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.h4),
                  4.verticalSpace,
                  Text(
                    subtitle,
                    style: theme.textTheme.muted.copyWith(fontSize: 12.sp),
                  ),
                ],
              ),
            ),
            Icon(LucideIcons.arrowRight, color: appColors.onSurfaceContainer),
          ],
        ),
      ),
    );
  }
}

class _NotificationSystemItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _NotificationSystemItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final theme = ShadTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: AppSpacing.sm),
        child: Row(
          children: [
            Icon(icon, color: appColors.grey700, size: 20),
            AppSpacing.horizontalSm.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.h4),
                  4.verticalSpace,
                  Text(
                    subtitle,
                    style: theme.textTheme.muted.copyWith(fontSize: 12.sp),
                  ),
                ],
              ),
            ),
            Icon(LucideIcons.arrowRight, color: appColors.onSurfaceContainer),
          ],
        ),
      ),
    );
  }
}
