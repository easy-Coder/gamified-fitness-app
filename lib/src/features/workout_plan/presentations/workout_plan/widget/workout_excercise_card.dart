import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/features/workout_excercise/model/workout_excercise.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkoutExcerciseCard extends StatelessWidget {
  const WorkoutExcerciseCard({
    super.key,
    required this.workoutExcercise,
  });

  final WorkoutExcercise workoutExcercise;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workoutExcercise.exercise.name,
                    style: GoogleFonts.rubik(
                      color: Colors.grey[900],
                      // fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  4.verticalSpace,
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Level: ',
                          style: GoogleFonts.rubik(
                            color: Colors.grey[500],
                          ),
                        ),
                        TextSpan(
                          text: workoutExcercise.exercise.level,
                          style: GoogleFonts.rubik(
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            8.horizontalSpace,
            Row(
              children: [
                Container(
                  width: 48.w,
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                  ),
                  child: Text(
                    workoutExcercise.sets.toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rubik(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                    ),
                  ),
                ),
                4.horizontalSpace,
                Text(
                  'X',
                  style: GoogleFonts.rubik(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade400,
                  ),
                ),
                4.horizontalSpace,
                Container(
                  width: 48.w,
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                  ),
                  child: Text(
                    workoutExcercise.reps.toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rubik(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
