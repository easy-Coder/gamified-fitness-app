import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/providers/today_workout.dart';
import 'package:gamified/src/common/widgets/button/primary_button.dart';
import 'package:gamified/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class NavScaffold extends ConsumerStatefulWidget {
  final Widget page;

  const NavScaffold({super.key, required this.page});

  @override
  ConsumerState<NavScaffold> createState() => _NavScaffoldState();
}

class _NavScaffoldState extends ConsumerState<NavScaffold> {
  int _index = 0;

  void navigate(int index) {
    setState(() {
      _index = index;
    });
    if (index == 0) {
      context.goNamed(AppRouter.stats.name);
    }
    if (index == 1) {
      context.goNamed(AppRouter.leaderboard.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayPlan = ref.watch(todayWorkoutProvider);
    return Scaffold(
      body: widget.page,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: 250.w,
        height: 45.h,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(24.r),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 8.w,
          vertical: 4.h,
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => navigate(0),
              child: Container(
                decoration: BoxDecoration(
                  color: _index == 0 ? Colors.grey.shade400 : null,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(8.w),
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedHome01,
                  color: Colors.black,
                ),
              ),
            ),
            8.horizontalSpace,
            PrimaryButton(
              onTap: () => context.pushNamed(
                AppRouter.workoutPlan.name,
                extra: todayPlan,
              ),
              title: 'Workout',
            ),
            8.horizontalSpace,
            GestureDetector(
              onTap: () => navigate(1),
              child: Container(
                decoration: BoxDecoration(
                  color: _index == 1 ? Colors.grey.shade400 : null,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(8.w),
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedPresentationBarChart01,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
