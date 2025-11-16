import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/theme/app_spacing.dart';
import 'package:gamified/src/common/theme/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PushNotificationsPage extends ConsumerStatefulWidget {
  const PushNotificationsPage({super.key});

  @override
  ConsumerState<PushNotificationsPage> createState() =>
      _PushNotificationsPageState();
}

class _PushNotificationsPageState extends ConsumerState<PushNotificationsPage> {
  bool _workoutReminders = true;
  bool _achievementNotifications = true;
  bool _weeklyProgress = true;
  bool _socialUpdates = false;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: ShadButton(
          leading: Icon(LucideIcons.arrowLeft, size: AppSpacing.iconMd),
          backgroundColor: Colors.transparent,
          foregroundColor: context.appColors.onSurface,
          onPressed: () => context.pop(),
          decoration: ShadDecoration(shape: BoxShape.circle),
        ),
        title: Text('Push Notifications', style: theme.textTheme.large),
        titleTextStyle: theme.textTheme.large,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // General Settings Section
            _buildSection(
              context,
              'General',
              [
                _NotificationSwitch(
                  title: 'Workout Reminders',
                  subtitle: 'Get notified about your scheduled workouts',
                  icon: LucideIcons.dumbbell,
                  value: _workoutReminders,
                  onChanged: (value) {
                    setState(() {
                      _workoutReminders = value;
                    });
                  },
                ),
                _NotificationSwitch(
                  title: 'Achievement Notifications',
                  subtitle: 'Celebrate your milestones and achievements',
                  icon: LucideIcons.trophy,
                  value: _achievementNotifications,
                  onChanged: (value) {
                    setState(() {
                      _achievementNotifications = value;
                    });
                  },
                ),
                _NotificationSwitch(
                  title: 'Weekly Progress',
                  subtitle: 'Receive weekly summaries of your progress',
                  icon: LucideIcons.trendingUp,
                  value: _weeklyProgress,
                  onChanged: (value) {
                    setState(() {
                      _weeklyProgress = value;
                    });
                  },
                ),
                _NotificationSwitch(
                  title: 'Social Updates',
                  subtitle: 'Notifications about friends and community',
                  icon: LucideIcons.users,
                  value: _socialUpdates,
                  onChanged: (value) {
                    setState(() {
                      _socialUpdates = value;
                    });
                  },
                ),
              ],
            ),
            AppSpacing.verticalXxl.verticalSpace,

            // Notification Timing Section
            _buildSection(
              context,
              'Timing',
              [
                _NotificationTimeItem(
                  title: 'Quiet Hours',
                  subtitle: 'No notifications between 10 PM - 8 AM',
                  icon: LucideIcons.moon,
                  onTap: () {
                    // TODO: Implement quiet hours settings
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Quiet hours settings coming soon!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
            AppSpacing.verticalXxl.verticalSpace,

            // System Settings Section
            _buildSection(
              context,
              'System',
              [
                _NotificationSystemItem(
                  title: 'Notification Permission',
                  subtitle: 'Manage system notification permissions',
                  icon: LucideIcons.settings,
                  onTap: () {
                    // TODO: Open system notification settings
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Opening system settings...'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> items,
  ) {
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
      padding: EdgeInsets.symmetric(
        vertical: 14,
        horizontal: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Icon(icon, color: appColors.grey700, size: 20),
          AppSpacing.horizontalSm.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.h4,
                ),
                4.verticalSpace,
                Text(
                  subtitle,
                  style: theme.textTheme.muted.copyWith(fontSize: 12.sp),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
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
        padding: EdgeInsets.symmetric(
          vertical: 14,
          horizontal: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Icon(icon, color: appColors.grey700, size: 20),
            AppSpacing.horizontalSm.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.h4,
                  ),
                  4.verticalSpace,
                  Text(
                    subtitle,
                    style: theme.textTheme.muted.copyWith(fontSize: 12.sp),
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.arrowRight,
              color: appColors.onSurfaceContainer,
            ),
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
        padding: EdgeInsets.symmetric(
          vertical: 14,
          horizontal: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Icon(icon, color: appColors.grey700, size: 20),
            AppSpacing.horizontalSm.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.h4,
                  ),
                  4.verticalSpace,
                  Text(
                    subtitle,
                    style: theme.textTheme.muted.copyWith(fontSize: 12.sp),
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.arrowRight,
              color: appColors.onSurfaceContainer,
            ),
          ],
        ),
      ),
    );
  }
}

