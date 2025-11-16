import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/theme/app_spacing.dart';
import 'package:gamified/src/common/theme/app_text_theme.dart';
import 'package:gamified/src/common/theme/theme.dart';
import 'package:gamified/src/common/util/haptic_util.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RestCountDownModal extends StatefulWidget {
  const RestCountDownModal({
    super.key,
    required this.restDuration,
    required this.onClose,
  });

  final Duration restDuration;
  final VoidCallback onClose;

  @override
  State<RestCountDownModal> createState() => _RestCountDownModalState();
}

class _RestCountDownModalState extends State<RestCountDownModal>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late Duration _remaining;
  late Duration _lastTick;

  @override
  void initState() {
    super.initState();
    _remaining = widget.restDuration;
    _lastTick = Duration.zero;

    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    final delta = elapsed - _lastTick;
    _lastTick = elapsed;

    if (_remaining > Duration.zero) {
      setState(() {
        _remaining -= delta;
        if (_remaining.isNegative) {
          _remaining = Duration.zero;
        }
      });

      if (_remaining == Duration.zero) {
        _closeTimer();
      }
    }
  }

  void _adjustTime(int seconds) {
    setState(() {
      final updated = _remaining + Duration(seconds: seconds);
      _remaining = updated.isNegative ? Duration.zero : updated;
    });
  }

  String _formatTime(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress =
        _remaining.inMilliseconds / widget.restDuration.inMilliseconds;

    return ClipRRect(
      borderRadius: BorderRadius.circular(64.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          decoration: BoxDecoration(
            color: context.appColors.surface.withAlpha(200),
            borderRadius: BorderRadius.circular(AppSpacing.radiusXxl),
          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              CircularProgressIndicator(value: progress.clamp(0.0, 1.0)),
              10.horizontalSpace,
              Text(
                _formatTime(_remaining),
                style: AppTextTheme.h1(context).copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _adjustTime(-10),
                child: Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(
                          LucideIcons.undo2,
                          color: context.appColors.info,
                        ),
                      ),
                      const TextSpan(text: " -10s "),
                    ],
                  ),
                  style: AppTextTheme.labelMedium(context).copyWith(
                    color: context.appColors.info,
                  ),
                ),
              ),
              5.horizontalSpace,
              GestureDetector(
                onTap: () => _adjustTime(10),
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: "+10s "),
                      WidgetSpan(
                        child: Icon(
                          LucideIcons.redo2,
                          color: context.appColors.info,
                        ),
                      ),
                    ],
                  ),
                  style: AppTextTheme.labelMedium(context).copyWith(
                    color: context.appColors.info,
                  ),
                ),
              ),
              10.horizontalSpace,
              GestureDetector(
                onTap: _closeTimer,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.appColors.grey300,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    LucideIcons.x,
                    size: AppSpacing.iconMd,
                    color: context.appColors.error,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _closeTimer() {
    HapticUtil.soft();
    _ticker.stop();
    widget.onClose();
  }
}
