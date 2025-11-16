import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/theme/app_spacing.dart';
import 'package:gamified/src/common/theme/theme.dart';
import 'package:gamified/src/common/util/weight_stats_util.dart';
import 'package:gamified/src/features/account/model/measurement.dart';
import 'package:gamified/src/features/account/model/user.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WeightStatsCard extends StatelessWidget {
  final List<MeasurementDTO> measurements;
  final UserDTO user;

  const WeightStatsCard({
    super.key,
    required this.measurements,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final stats = WeightStatsUtil.calculateWeightStats(measurements, user.weight);

    if (measurements.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: appColors.surfaceContainer,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: appColors.grey200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: _WeightStatItem(
                  label: 'Initial Weight',
                  value: '${stats.initialWeight.toStringAsFixed(1)} kg',
                  icon: LucideIcons.trendingDown,
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: appColors.grey200,
              ),
              Expanded(
                child: _WeightStatItem(
                  label: 'Current Weight',
                  value: '${stats.currentWeight.toStringAsFixed(1)} kg',
                  icon: LucideIcons.scale,
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: appColors.grey200,
              ),
              Expanded(
                child: _WeightStatItem(
                  label: stats.difference >= 0 ? 'Gained' : 'Lost',
                  value: '${stats.difference.abs().toStringAsFixed(1)} kg',
                  icon: stats.difference >= 0
                      ? LucideIcons.trendingUp
                      : LucideIcons.trendingDown,
                  color: stats.difference >= 0
                      ? appColors.warning
                      : appColors.success,
                ),
              ),
            ],
          ),
        ),
        32.verticalSpace,
      ],
    );
  }
}

class _WeightStatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const _WeightStatItem({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final appColors = context.appColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: AppSpacing.iconSm,
          color: color ?? appColors.grey600,
        ),
        8.verticalSpace,
        Text(
          value,
          style: theme.textTheme.h4.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
        4.verticalSpace,
        Text(
          label,
          style: theme.textTheme.muted.copyWith(fontSize: 11.sp),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

