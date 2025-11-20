import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/theme/theme.dart';

class WorkoutHistoryOverviewSkeleton extends StatelessWidget {
  const WorkoutHistoryOverviewSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      margin: EdgeInsets.only(bottom: 20.h),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Container(
              height: 24,
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.appColors.grey200,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            12.verticalSpace,
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: context.appColors.grey100,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

