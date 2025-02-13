import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/widgets/hydration_progress.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WaterIntakeDetailPage extends StatelessWidget {
  const WaterIntakeDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HydrationProgress(
            progress: 45,
            size: Size.square(120),
            radius: 60,
            duration: Duration(
              milliseconds: 500,
            ),
          ),
          20.verticalSpace,
          Text.rich(
            TextSpan(
              text: '1665',
              children: [
                TextSpan(text: '/'),
                TextSpan(text: '3700'),
                TextSpan(text: 'ml'),
              ],
              style: ShadTheme.of(context).textTheme.h2,
            ),
          ),
        ],
      ),
    );
  }
}
