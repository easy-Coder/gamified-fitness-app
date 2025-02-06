import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.title,
    required this.onTap,
    this.isLoading = false,
    this.size = ShadButtonSize.lg,
    this.foregroundColor,
    this.backgroundColor,
  });

  final String title;
  final VoidCallback onTap;
  final ShadButtonSize size;
  final bool isLoading;
  final Color? foregroundColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ShadButton(
      onPressed: onTap,
      size: size,
      icon: isLoading
          ? SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: ShadTheme.of(context).colorScheme.primaryForeground,
              ),
            )
          : null,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      child: Text(title),
    );
  }
}
