import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class NavScaffold extends ConsumerStatefulWidget {
  final Widget page;
  final String path;

  const NavScaffold({super.key, required this.page, required this.path});

  @override
  ConsumerState<NavScaffold> createState() => _NavScaffoldState();
}

class _NavScaffoldState extends ConsumerState<NavScaffold> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
  }

  void navigate(int index) {
    setState(() {
      _index = index;
    });
    if (index == 0) {
      context.goNamed(AppRouter.stats.name);
    }
    if (index == 1) {
      context.goNamed(AppRouter.workoutPlans.name);
    }

    if (index == 2) {
      context.goNamed(AppRouter.profile.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final path = GoRouter.of(context).state.uri.path;
    switch (path) {
      case '/':
        _index = 0;
      case '/workout-plans':
        _index = 1;
      case '/profile':
        _index = 2;
    }
    return Scaffold(
      body: widget.page,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(64.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(120),
              borderRadius: BorderRadius.circular(64.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            child: Row(
              spacing: 8.w,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => navigate(0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _index == 0 ? Colors.black87 : null,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(8.w),
                    child: Icon(
                      LucideIcons.house,
                      color: _index == 0 ? Colors.white : Colors.black,
                      size: 24.w,
                    ),
                  ),
                ),
                8.horizontalSpace,
                GestureDetector(
                  onTap: () => navigate(1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _index == 1 ? Colors.black87 : null,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(8.w),
                    child: Icon(
                      LucideIcons.dumbbell,
                      color: _index == 1 ? Colors.white : Colors.black,
                      size: 24.w,
                    ),
                  ),
                ),
                8.horizontalSpace,
                GestureDetector(
                  onTap: () => navigate(2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _index == 2 ? Colors.black87 : null,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(8.w),
                    child: Icon(
                      LucideIcons.userRound,
                      color: _index == 2 ? Colors.white : Colors.black,
                      size: 24.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
