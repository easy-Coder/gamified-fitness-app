import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/theme/app_spacing.dart';
import 'package:gamified/src/common/theme/app_text_theme.dart';
import 'package:gamified/src/common/theme/theme.dart';
import 'package:gamified/src/common/util/bmi_util.dart';
import 'package:gamified/src/features/account/model/user.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class BMICard extends StatelessWidget {
  final UserDTO user;

  const BMICard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final appColors = context.appColors;
    final bmiColors = Theme.of(context).bmiColors;
    final bmi = BMIUtil.calculateBMI(user.weight, user.height);
    final bmiInfo = BMIUtil.getBMICategory(bmi);

    return Container(
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: appColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: appColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.heart, size: AppSpacing.iconMd, color: bmiInfo.color),
              AppSpacing.horizontalMd.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Body Mass Index (BMI)',
                      style: AppTextTheme.h4(context),
                    ),
                    AppSpacing.verticalXs.verticalSpace,
                    Text(
                      bmiInfo.description,
                      style: AppTextTheme.bodySmall(context),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: bmiInfo.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  border: Border.all(color: bmiInfo.color.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      bmi.toStringAsFixed(1),
                      style: theme.textTheme.h3.copyWith(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: bmiInfo.color,
                      ),
                    ),
                    Text(
                      bmiInfo.category,
                      style: theme.textTheme.muted.copyWith(
                        fontSize: 11.sp,
                        color: bmiInfo.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.verticalLg.verticalSpace,
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: appColors.surfaceContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _BMIRangeItem(
                  range: '< 18.5',
                  color: bmiColors.underweight,
                  isActive: bmi < 18.5,
                ),
                _BMIRangeItem(
                  range: '18.5 - 24.9',
                  color: bmiColors.normal,
                  isActive: bmi >= 18.5 && bmi < 25.0,
                ),
                _BMIRangeItem(
                  range: '25.0 - 29.9',
                  color: bmiColors.overweight,
                  isActive: bmi >= 25.0 && bmi < 30.0,
                ),
                _BMIRangeItem(
                  range: '≥ 30.0',
                  color: bmiColors.obese,
                  isActive: bmi >= 30.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BMIRangeItem extends StatelessWidget {
  final String range;
  final Color color;
  final bool isActive;

  const _BMIRangeItem({
    required this.range,
    required this.color,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: AppSpacing.sizeSm,
            height: AppSpacing.sizeSm,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? color : appColors.grey300,
            ),
          ),
          AppSpacing.verticalXs.verticalSpace,
          Text(
            range,
            style: AppTextTheme.labelSmall(context).copyWith(
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              color: isActive ? color : appColors.grey600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

