import 'package:flutter/material.dart';
import 'package:gamified/src/common/theme/app_spacing.dart';
import 'package:gamified/src/common/theme/theme.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SettingsListItem extends StatelessWidget {
  const SettingsListItem({
    super.key,
    this.leadingIcon,
    required this.title,
    this.value,
    required this.onTap,
  });

  final Widget? leadingIcon;
  final String title;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 14,
          horizontal: AppSpacing.sm,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: AppSpacing.sm,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (leadingIcon != null) leadingIcon!,
                Text(title, style: ShadTheme.of(context).textTheme.h4),
              ],
            ),
            Row(
              spacing: AppSpacing.sm,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (value != null)
                  Text(value!, style: ShadTheme.of(context).textTheme.muted),
                Icon(
                  LucideIcons.arrowRight,
                  color: appColors.onSurfaceContainer,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
