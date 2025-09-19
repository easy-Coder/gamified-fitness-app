import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/features/excersice/data/excercise_repository.dart';
import 'package:gamified/src/features/workout_log/model/exercise_log.dart';

class ExerciseLogCard extends ConsumerWidget {
  const ExerciseLogCard({super.key, required this.exerciseLog});

  final ExercisesLog exerciseLog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseState = ref.watch(
      exerciseDetailsProvider(exerciseLog.exerciseId),
    );
    return exerciseState.when(
      data: (exercise) => Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(24.r),
        ),
        padding: EdgeInsets.all(8),
        child: Row(
          spacing: 8,
          children: [
            Container(
              height: 64.w,
              width: 64.w,
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(image: NetworkImage(exercise.gifUrl)),
                borderRadius: BorderRadius.circular(18.r),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Row(
                //   spacing: 8,
                //   children: [
                //     Text.rich(
                //       TextSpan(
                //         text: "Total Sets:",
                //         children: [TextSpan(text: "4")],
                //       ),
                //     ),
                //     Text.rich(
                //       TextSpan(
                //         text: "Total Reps:",
                //         children: [TextSpan(text: "4")],
                //       ),
                //     ),
                //     // Text.rich(
                //     //   TextSpan(
                //     //     text: "Total Weight:",
                //     //     children: [TextSpan(text: "50kg")],
                //     //   ),
                //     // ),
                //   ],
                // ),
              ],
            ),
          ],
        ),
      ),
      error: (error, st) => Container(),
      loading: () => Container(),
    );
  }
}
