import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/common/util/lower_case_to_space.dart';
import 'package:gamified/src/features/excersice/data/excercise_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class ExerciseDetailsModal extends ConsumerWidget {
  const ExerciseDetailsModal({super.key, required this.exerciseId});

  final String exerciseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseState = ref.watch(exerciseDetailsProvider(exerciseId));
    return Sheet(
      // minPosition: SheetAnchor.proportional(0.9),
      // initialPosition: SheetAnchor.proportional(0.9),
      child: SheetContentScaffold(
        topBar: PreferredSize(
          preferredSize: Size.fromHeight(80.h),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const SizedBox(
                      width: 64,
                      height: 64,
                      child: Icon(LucideIcons.x, size: 24),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: exerciseState.when(
            data: (exercise) => SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Exercise GIF
                  Container(
                    width: double.infinity,
                    height: 200.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.network(
                        exercise.gifUrl,
                        fit: BoxFit.contain,
                        // width: double.infinity,
                        // height: 200.h,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.fitness_center,
                              size: 50.sp,
                              color: Colors.grey[400],
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  24.verticalSpace,

                  // Exercise Name
                  Text(
                    exercise.name.toTitleCase(),
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  16.verticalSpace,
                  Row(
                    children: [
                      _buildChip(
                        exercise.exerciseType,
                        Colors.lightBlue,
                        Colors.white,
                      ),
                    ],
                  ),
                  16.verticalSpace,

                  // Target Muscles Section
                  if (exercise.targetMuscles.isNotEmpty) ...[
                    _buildSectionHeader("Primary Target Muscles"),
                    8.verticalSpace,
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: exercise.targetMuscles
                          .map(
                            (muscle) => _buildChip(
                              muscle.toTitleCase(),
                              Colors.red.shade100,
                              Colors.red.shade700,
                            ),
                          )
                          .toList(),
                    ),
                    16.verticalSpace,
                  ],

                  // Secondary Muscles Section
                  if (exercise.secondaryMuscles.isNotEmpty) ...[
                    _buildSectionHeader("Secondary Muscles"),
                    8.verticalSpace,
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: exercise.secondaryMuscles
                          .map(
                            (muscle) => _buildChip(
                              muscle.toTitleCase(),
                              Colors.orange.shade100,
                              Colors.orange.shade700,
                            ),
                          )
                          .toList(),
                    ),
                    16.verticalSpace,
                  ],

                  // Body Parts Section
                  if (exercise.bodyParts.isNotEmpty) ...[
                    _buildSectionHeader("Body Parts"),
                    8.verticalSpace,
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: exercise.bodyParts
                          .map(
                            (part) => _buildChip(
                              part.toTitleCase(),
                              Colors.blue.shade100,
                              Colors.blue.shade700,
                            ),
                          )
                          .toList(),
                    ),
                    16.verticalSpace,
                  ],

                  // Equipment Section
                  if (exercise.equipments.isNotEmpty) ...[
                    _buildSectionHeader("Equipment"),
                    8.verticalSpace,
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: exercise.equipments
                          .map(
                            (equipment) => _buildChip(
                              equipment.toTitleCase(),
                              Colors.green.shade100,
                              Colors.green.shade700,
                            ),
                          )
                          .toList(),
                    ),
                    16.verticalSpace,
                  ],

                  // Instructions Section
                  if (exercise.instructions.isNotEmpty) ...[
                    _buildSectionHeader("Instructions"),
                    12.verticalSpace,
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: exercise.instructions
                            .asMap()
                            .entries
                            .map(
                              (entry) => Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      entry.key ==
                                          exercise.instructions.length - 1
                                      ? 0
                                      : 12.h,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 24.w,
                                      height: 24.h,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${entry.key + 1}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    12.horizontalSpace,
                                    Expanded(
                                      child: Text(
                                        entry.value,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          height: 1.4,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    24.verticalSpace,
                  ],

                  // Add some bottom padding for better scrolling experience
                  32.verticalSpace,
                ],
              ),
            ),
            error: (Object error, StackTrace stackTrace) => Container(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.sp,
                    color: Colors.red.shade300,
                  ),
                  16.verticalSpace,
                  Text(
                    'Failed to load exercise details',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade700,
                    ),
                  ),
                  8.verticalSpace,
                  Text(
                    'Please try again later',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            loading: () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator.adaptive(),
                16.verticalSpace,
                Text(
                  'Loading exercise details...',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildChip(String label, Color backgroundColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: textColor.withAlpha(77)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}
