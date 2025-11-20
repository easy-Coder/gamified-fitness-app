import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/theme/theme.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WorkoutHistoryEmptyState extends StatelessWidget {
  const WorkoutHistoryEmptyState({
    super.key,
    this.subtitle = 'Complete your first workout to see it here',
  });

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 60.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.dumbbell,
            size: 64,
            color: context.appColors.grey400,
          ),
          16.verticalSpace,
          Text(
            'No workout history yet',
            style: theme.textTheme.muted.copyWith(fontSize: 16.sp),
          ),
          8.verticalSpace,
          Text(
            subtitle,
            style: theme.textTheme.muted.copyWith(fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}

