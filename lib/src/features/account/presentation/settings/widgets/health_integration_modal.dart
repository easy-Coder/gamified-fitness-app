import 'package:gamified/src/features/account/presentation/settings/controller/settings_controller.dart';
import 'package:open_settings_plus/open_settings_plus.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/widgets/button/primary_button.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class HealthIntegrationModal extends ConsumerWidget {
  final String platformName;
  final IconData platformIcon;
  final Color platformColor;
  final bool useHealth;
  const HealthIntegrationModal({
    super.key,
    required this.platformName,
    required this.platformIcon,
    required this.platformColor,
    required this.useHealth,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String platformName,
    required IconData platformIcon,
    required Color platformColor,
    required bool useHealth,
  }) async {
    final modal = ModalSheetRoute<bool>(
      swipeDismissible: false,
      builder: (context) => HealthIntegrationModal(
        platformName: platformName,
        platformIcon: platformIcon,
        platformColor: platformColor,
        useHealth: useHealth,
      ),
    );

    return Navigator.push<bool>(context, modal);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final isIOS = defaultTargetPlatform == TargetPlatform.iOS;

    return Sheet(
      snapGrid: const SheetSnapGrid.single(snap: SheetOffset(1.0)),
      initialOffset: const SheetOffset(1.0),
      child: SheetContentScaffold(
        topBar: SafeArea(
          bottom: false,
          child: Container(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => context.pop(false),
                  child: SizedBox(
                    width: 48.w,
                    height: 48.w,
                    child: Icon(LucideIcons.x, size: 24),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Icon
                Center(
                  child: Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: platformColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(platformIcon, size: 40, color: platformColor),
                  ),
                ),
                24.verticalSpace,

                // Title
                Text(
                  'Connect to $platformName',
                  style: theme.textTheme.large.copyWith(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                16.verticalSpace,

                // Description
                Text(
                  'By connecting $platformName, you\'ll enable powerful features that help you track your fitness journey more effectively.',
                  style: theme.textTheme.muted.copyWith(
                    fontSize: 16.sp,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                32.verticalSpace,

                // What you'll get section
                Text(
                  'What you\'ll get:',
                  style: theme.textTheme.h3.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                16.verticalSpace,

                _buildFeatureItem(
                  context,
                  icon: LucideIcons.refreshCw,
                  title: 'Automatic Data Sync',
                  description:
                      'Your weight, height, and measurements will automatically sync between the app and $platformName, keeping your data up-to-date.',
                ),
                12.verticalSpace,

                _buildFeatureItem(
                  context,
                  icon: LucideIcons.flame,
                  title: 'Calorie Tracking',
                  description:
                      'Access your daily calorie burn data from $platformName, including active and basal energy burned, to better understand your fitness progress.',
                ),
                12.verticalSpace,

                _buildFeatureItem(
                  context,
                  icon: LucideIcons.activity,
                  title: 'Workout History',
                  description:
                      'Your completed workouts will be saved to $platformName, creating a comprehensive fitness log that syncs across all your devices.',
                ),
                12.verticalSpace,

                _buildFeatureItem(
                  context,
                  icon: LucideIcons.trendingUp,
                  title: 'Progress Insights',
                  description:
                      'View detailed progress charts and statistics by combining data from both the app and $platformName.',
                ),
                32.verticalSpace,

                // How to remove section
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            LucideIcons.info,
                            size: 20,
                            color: Colors.grey.shade700,
                          ),
                          8.horizontalSpace,
                          Text(
                            'How to remove access:',
                            style: theme.textTheme.h4.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      12.verticalSpace,
                      _buildRemovalStep(
                        context,
                        step: 1,
                        text: isIOS
                            ? 'Go to Settings > Privacy & Security > Health > RankUpFit'
                            : 'Go to Settings > Apps > RankUpFit > Permissions',
                      ),
                      8.verticalSpace,
                      _buildRemovalStep(
                        context,
                        step: 2,
                        text: 'Toggle off the permissions you want to revoke',
                      ),
                    ],
                  ),
                ),
                32.verticalSpace,

                // Continue Button
                PrimaryButton(
                  title: 'Continue',
                  onTap: () => _openAppSettings(ref),
                  backgroundColor: platformColor,
                  textColor: Colors.white,
                ),

                32.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openAppSettings(WidgetRef ref) async {
    if (useHealth) {
      switch (OpenSettingsPlus.shared) {
        case OpenSettingsPlusAndroid settings:
          settings.appSettings();
          break;
        case OpenSettingsPlusIOS settings:
          settings.healthKit();
          break;
      }
    } else {
      // ask for health permission using health package
      ref.read(preferenceNotifierProvider.notifier).updateUseHealth();
    }
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = ShadTheme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, size: 20, color: Colors.blue.shade700),
        ),
        12.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.h4.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              4.verticalSpace,
              Text(
                description,
                style: theme.textTheme.muted.copyWith(
                  fontSize: 14.sp,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRemovalStep(
    BuildContext context, {
    required int step,
    required String text,
  }) {
    final theme = ShadTheme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$step',
              style: theme.textTheme.small.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.muted.copyWith(fontSize: 14.sp, height: 1.4),
          ),
        ),
      ],
    );
  }
}
