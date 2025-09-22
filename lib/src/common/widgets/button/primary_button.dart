import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/widgets/loading_widget.dart';

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.title,
    required this.onTap,
    this.isLoading = false,
    this.textColor,
    this.backgroundColor,
    this.icon,
  });

  final String title;
  final Widget? icon;
  final VoidCallback onTap;
  final bool isLoading;
  final Color? textColor;
  final Color? backgroundColor;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 500),
      reverseDuration: const Duration(microseconds: 500),
    );
    final curveAnim = CurvedAnimation(
      parent: controller,
      curve: Curves.bounceInOut,
    );
    scaleAnimation = Tween<double>(begin: 0, end: 0.06).animate(curveAnim);
    // TODO: make sure onPressed work with accessibility
    controller.addListener(() {
      final status = controller.status;
      print("Status: $status");
      if (status == AnimationStatus.dismissed) {
        print("Button pressed");
        if (widget.isLoading) return;
        widget.onTap();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 0.96;
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.scale(scale: 1 - scaleAnimation.value, child: child);
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (details) {
          debugPrint("Tap Down");
          controller.forward();
        },
        onTapUp: (details) {
          debugPrint("Tap Up");
          controller.reverse();
        },
        onTapCancel: () {
          debugPrint("Tap Cancel");
          controller.reverse();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            color: widget.backgroundColor ?? Colors.blue,
          ),
          constraints: BoxConstraints(maxHeight: 40.h, maxWidth: width),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...[
                if (widget.icon != null) ...[?widget.icon, 4.horizontalSpace],
                Text(
                  widget.title,
                  style: TextStyle(
                    color: widget.textColor ?? Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              if (widget.isLoading) LoadingWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
