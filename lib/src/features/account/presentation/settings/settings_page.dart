import 'package:flash/flash_helper.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/theme/app_spacing.dart';
import 'package:gamified/src/common/theme/theme.dart';
import 'package:gamified/src/common/widgets/measure_modal_sheet.dart';
import 'package:gamified/src/common/widgets/settings_list_item.dart';
import 'package:gamified/src/features/account/data/preference_repository.dart';
import 'package:gamified/src/features/account/presentation/settings/controller/settings_controller.dart';
import 'package:gamified/src/features/account/presentation/settings/widgets/health_integration_modal.dart';
import 'package:gamified/src/features/account/schema/preference.dart'
    show WeightUnit;
import 'package:gamified/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final appColors = context.appColors;
    final healthColors = Theme.of(context).healthIntegrationColors;
    final isIOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final preferenceAsync = ref.watch(preferenceProvider);

    ref.listen(preferenceNotifierProvider, (previous, next) {
      if (next.hasError) {
        context.showErrorBar(content: Text((next.error! as Failure).message));
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        title: Text('Settings', style: theme.textTheme.large),
        titleTextStyle: theme.textTheme.large,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: preferenceAsync.when(
          data: (preference) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Integrations Section
              if (isIOS || isAndroid)
                _buildSection(context, 'Integrations', [
                  if (isIOS)
                    _HealthIntegrationSwitch(
                      platformName: 'Apple Health',
                      platformIcon: LucideIcons.heart,
                      platformColor: healthColors.appleHealth,
                      useHealth: preference.useHealth,
                    ),
                  if (isAndroid)
                    _HealthIntegrationSwitch(
                      platformName: 'Google Health Connect',
                      platformIcon: LucideIcons.activity,
                      platformColor: healthColors.googleFit,
                      useHealth: preference.useHealth,
                    ),
                ]),
              if (isIOS || isAndroid) AppSpacing.verticalXxl.verticalSpace,

              // Units Section
              _buildSection(context, 'Units', [_WeightUnitSelector()]),
              AppSpacing.verticalXxl.verticalSpace,

              // Notifications Section
              _buildSection(context, 'Notifications', [
                SettingsListItem(
                  leadingIcon: Icon(LucideIcons.bell, color: appColors.grey700),
                  title: 'Push Notifications',
                  onTap: () {
                    context.pushNamed(AppRouter.pushNotifications.name);
                  },
                ),
                SettingsListItem(
                  leadingIcon: Icon(
                    LucideIcons.alarmClock,
                    color: appColors.grey700,
                  ),
                  title: 'Reminders',
                  onTap: () {
                    // TODO: Implement reminder settings
                    _showNotImplementedSnackBar(context);
                  },
                ),
              ]),
              AppSpacing.verticalXxl.verticalSpace,

              // Data & Privacy Section
              _buildSection(context, 'Data & Privacy', [
                SettingsListItem(
                  leadingIcon: Icon(
                    LucideIcons.download,
                    color: appColors.grey700,
                  ),
                  title: 'Export Data',
                  onTap: () {
                    // TODO: Implement data export
                    _showNotImplementedSnackBar(context);
                  },
                ),
                SettingsListItem(
                  leadingIcon: Icon(LucideIcons.trash2, color: appColors.error),
                  title: 'Delete All Data',
                  onTap: () {
                    // TODO: Implement data deletion
                    _showNotImplementedSnackBar(context);
                  },
                ),
              ]),
              AppSpacing.verticalXxl.verticalSpace,

              // About Section
              _buildSection(context, 'About', [
                SettingsListItem(
                  leadingIcon: Icon(LucideIcons.info, color: appColors.grey700),
                  title: 'App Version',
                  value: '1.0.0',
                  onTap: () {
                    // Could show version info dialog
                  },
                ),
                SettingsListItem(
                  leadingIcon: Icon(
                    LucideIcons.fileText,
                    color: appColors.grey700,
                  ),
                  title: 'Terms of Service',
                  onTap: () {
                    // TODO: Implement terms of service
                    _showNotImplementedSnackBar(context);
                  },
                ),
                SettingsListItem(
                  leadingIcon: Icon(
                    LucideIcons.shield,
                    color: appColors.grey700,
                  ),
                  title: 'Privacy Policy',
                  onTap: () {
                    // TODO: Implement privacy policy
                    _showNotImplementedSnackBar(context);
                  },
                ),
              ]),
              AppSpacing.verticalXxxl.verticalSpace,
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
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

  void _showNotImplementedSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('This feature is coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class _HealthIntegrationSwitch extends ConsumerStatefulWidget {
  final String platformName;
  final IconData platformIcon;
  final Color platformColor;
  final bool useHealth;
  const _HealthIntegrationSwitch({
    required this.platformName,
    required this.platformIcon,
    required this.platformColor,
    required this.useHealth,
  });

  @override
  ConsumerState<_HealthIntegrationSwitch> createState() =>
      _HealthIntegrationSwitchState();
}

class _HealthIntegrationSwitchState
    extends ConsumerState<_HealthIntegrationSwitch> {
  Future<void> _handleTap() async {
    // Show modal when requesting permission
    await HealthIntegrationModal.show(
      context,
      platformName: widget.platformName,
      platformIcon: widget.platformIcon,
      platformColor: widget.platformColor,
      useHealth: widget.useHealth,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsListItem(
      leadingIcon: Icon(widget.platformIcon, color: widget.platformColor),
      title: widget.platformName,
      value: widget.useHealth ? 'Manage' : 'Allow',
      onTap: () => _handleTap(),
    );
  }
}

class _WeightUnitSelector extends ConsumerWidget {
  const _WeightUnitSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final appColors = context.appColors;
    final preferenceAsync = ref.watch(preferenceProvider);

    return preferenceAsync.when(
      data: (preference) {
        final currentUnit = preference.weightUnit;
        final unitLabel = currentUnit == WeightUnit.kg ? 'kg' : 'lbs';

        return SettingsListItem(
          leadingIcon: Icon(LucideIcons.ruler, color: appColors.grey700),
          title: 'Weight Unit',
          value: unitLabel,
          onTap: () async {
            final currentIndex = preference.weightUnit.index;
            final selectedIndex =
                await MeasureModalSheet.showModalSheet<int>(
                  context,
                  MeasureModalSheet(
                    title: 'Select Weight Unit',
                    itemCount: WeightUnit.values.length,
                    builder:
                        (BuildContext context, int index, int currentIndex) {
                          final unit = WeightUnit.values[index];
                          final label = unit == WeightUnit.kg ? 'kg' : 'lbs';
                          return Container(
                            alignment: Alignment.center,
                            child: Text(
                              label,
                              style: theme.textTheme.small.copyWith(
                                color: index == currentIndex
                                    ? appColors.onPrimary
                                    : null,
                              ),
                            ),
                          );
                        },
                  ),
                ) ??
                currentIndex;

            if (selectedIndex != currentIndex) {
              final selectedUnit = WeightUnit.values[selectedIndex];
              ref
                  .read(preferenceNotifierProvider.notifier)
                  .updateWeightUnit(selectedUnit);
            }
          },
        );
      },
      loading: () => SettingsListItem(
        leadingIcon: Icon(LucideIcons.ruler, color: appColors.grey700),
        title: 'Weight Unit',
        value: '...',
        onTap: () {},
      ),
      error: (error, stack) => SettingsListItem(
        leadingIcon: Icon(LucideIcons.ruler, color: appColors.grey700),
        title: 'Weight Unit',
        value: 'Error',
        onTap: () {},
      ),
    );
  }
}
