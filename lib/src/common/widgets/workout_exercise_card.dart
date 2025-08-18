import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WorkoutExcerciseCard extends StatelessWidget {
  const WorkoutExcerciseCard({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black38, width: 0.4),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Row(
          spacing: 8,
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                image: DecorationImage(
                  image: NetworkImage(exercise.gifUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 2,
                children: [
                  Text(
                    exercise.name,
                    style: ShadTheme.of(context).textTheme.large,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Row(
                    spacing: 8,
                    children: [
                      Row(
                        spacing: 4,
                        children: [
                          Icon(LucideIcons.target, color: Colors.red),
                          Text(
                            exercise.targetMuscles.isEmpty
                                ? "No Primary Muscles"
                                : exercise.targetMuscles.length > 1
                                ? "${exercise.targetMuscles[0]} + ${exercise.targetMuscles.length - 1}"
                                : exercise.targetMuscles[0],
                            style: ShadTheme.of(
                              context,
                            ).textTheme.p.copyWith(fontSize: 10),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 4,
                        children: [
                          Icon(LucideIcons.dumbbell),
                          Text(
                            exercise.equipments.isNotEmpty
                                ? exercise.equipments.length > 1
                                      ? "${exercise.equipments[0]} + ${exercise.equipments.length - 1}"
                                      : exercise.equipments[0]
                                : 'No Equipment',
                            style: ShadTheme.of(
                              context,
                            ).textTheme.p.copyWith(fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
