import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ProfileItem extends StatelessWidget {
  final Icon leading;
  final String title;
  final Widget? trailing;
  final Widget? child;
  final VoidCallback? onTap;

  const ProfileItem({
    super.key,
    required this.leading,
    required this.title,
    this.trailing,
    this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            // border: Border.all(color: Colors.grey.shade200, width: 0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: IconTheme(
            data: IconThemeData(size: 20),
            child: child == null
                ? _buildHeadingRow(theme)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeadingRow(theme),
                      if (child != null) child!,
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Row _buildHeadingRow(ShadThemeData theme) {
    return Row(
      children: [
        leading,
        16.horizontalSpace,
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.h4.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
