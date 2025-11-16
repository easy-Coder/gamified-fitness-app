import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/widgets/measure_modal_sheet.dart';
import 'package:gamified/src/common/widgets/settings_list_item.dart';
import 'package:gamified/src/features/account/data/measurement_repository.dart';
import 'package:gamified/src/features/account/presentation/measurements/controller/measurements_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MeasurementsPage extends ConsumerWidget {
  const MeasurementsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final userAsync = ref.watch(measurementsControllerProvider);
    final measurementsAsync = ref.watch(measurementsProvider);
    final controller = ref.read(measurementsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: ShadButton(
          leading: Icon(LucideIcons.arrowLeft, size: 24),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          onPressed: () => context.pop(),
          decoration: ShadDecoration(shape: BoxShape.circle),
        ),
        title: Text('Measurements', style: theme.textTheme.large),
        titleTextStyle: theme.textTheme.large,
        actions: [
          userAsync.when(
            data: (user) => userAsync.isLoading
                ? Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : TextButton(
                    onPressed: () => controller.saveMeasurement(),
                    child: Text(
                      'Save',
                      style: theme.textTheme.h4.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
            loading: () => Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (error, stack) => SizedBox.shrink(),
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) => SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Current Measurements Section
              Text(
                'Current Measurements',
                style: theme.textTheme.h3.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              16.verticalSpace,
              _WeightSelector(user: user, controller: controller),
              8.verticalSpace,
              _HeightSelector(user: user, controller: controller),
              24.verticalSpace,
              measurementsAsync.when(
                data: (measurements) {
                  if (measurements.isEmpty) {
                    return Container(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.trending_up,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          16.verticalSpace,
                          Text(
                            'No measurements yet',
                            style: theme.textTheme.muted.copyWith(
                              fontSize: 16.sp,
                            ),
                          ),
                          8.verticalSpace,
                          Text(
                            'Add your first measurement to start tracking',
                            style: theme.textTheme.muted.copyWith(
                              fontSize: 14.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
                loading: () => Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stack) => Container(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red.shade300,
                      ),
                      16.verticalSpace,
                      Text(
                        'Error loading measurements',
                        style: theme.textTheme.muted.copyWith(fontSize: 16.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
              16.verticalSpace,
              Text(
                'Error loading user data',
                style: theme.textTheme.muted.copyWith(fontSize: 16.sp),
              ),
              16.verticalSpace,
              TextButton(
                onPressed: () => ref
                    .read(measurementsControllerProvider.notifier)
                    .loadUser(),
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeightSelector extends ConsumerWidget {
  final user;
  final MeasurementsController controller;

  const _WeightSelector({required this.user, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);

    return SettingsListItem(
      leadingIcon: Icon(LucideIcons.weight),
      title: 'Weight',
      value: user.weight != 0 ? '${user.weight.toStringAsFixed(1)} kg' : null,
      onTap: () async {
        double getWeight(int index) => (20.0 + (index / 10));
        final weightIndex = await MeasureModalSheet.showModalSheet<int>(
          context,
          MeasureModalSheet(
            title: 'Select Your Weight',
            itemCount: 801, // 20kg to 100kg (0.1kg increments)
            builder: (BuildContext context, int index, int currentIndex) =>
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '${getWeight(index).toStringAsFixed(1)} kg',
                    style: theme.textTheme.small.copyWith(
                      color: index == currentIndex ? Colors.white : null,
                    ),
                  ),
                ),
          ),
        );

        if (weightIndex != null) {
          controller.updateWeight(getWeight(weightIndex));
        }
      },
    );
  }
}

class _HeightSelector extends ConsumerWidget {
  final user;
  final MeasurementsController controller;

  const _HeightSelector({required this.user, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);

    return SettingsListItem(
      leadingIcon: Icon(LucideIcons.ruler),
      title: 'Height',
      value: user.height != 0 ? '${user.height.toStringAsFixed(0)} cm' : null,
      onTap: () async {
        final heightIndex = await MeasureModalSheet.showModalSheet<int>(
          context,
          MeasureModalSheet(
            title: 'Select Your Height',
            itemCount: 151, // 100cm to 250cm
            builder: (BuildContext context, int index, int currentIndex) =>
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '${100 + index} cm',
                    style: theme.textTheme.small.copyWith(
                      color: index == currentIndex ? Colors.white : null,
                    ),
                  ),
                ),
          ),
        );

        if (heightIndex != null) {
          controller.updateHeight((100 + heightIndex).toDouble());
        }
      },
    );
  }
}
