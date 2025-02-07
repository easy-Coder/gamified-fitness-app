import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/features/workout_excercise/model/workout_excercise.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkoutExcerciseEditCard extends StatefulWidget {
  const WorkoutExcerciseEditCard({
    super.key,
    required this.workoutExcercise,
    required this.onSetsChange,
    required this.onRepsChange,
  });

  final WorkoutExcercise workoutExcercise;
  final Function(String) onSetsChange;
  final Function(String) onRepsChange;

  @override
  State<WorkoutExcerciseEditCard> createState() =>
      _WorkoutExcerciseEditCardState();
}

class _WorkoutExcerciseEditCardState extends State<WorkoutExcerciseEditCard> {
  final TextEditingController _setsController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with existing values or "0"
    _setsController.text = widget.workoutExcercise.sets?.toString() ?? '0';
    _repsController.text = widget.workoutExcercise.reps?.toString() ?? '0';
  }

  @override
  void dispose() {
    _setsController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  void _handleSetsChange(String value) {
    final newValue = value.isEmpty ? '0' : value;
    widget.onSetsChange(newValue);
  }

  void _handleRepsChange(String value) {
    final newValue = value.isEmpty ? '0' : value;
    widget.onRepsChange(newValue);
  }

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
                    widget.workoutExcercise.exercise.name,
                    style: GoogleFonts.rubik(
                      color: Colors.grey[900],
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
                          text: widget.workoutExcercise.exercise.level,
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
                  height: 64.w,
                  width: 48.w,
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                  ),
                  child: TextField(
                    controller: _setsController,
                    onChanged: _handleSetsChange,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.r),
                        borderSide: BorderSide(
                          color: Colors.grey.shade900,
                        ),
                      ),
                      hintText: '0',
                      hintStyle: GoogleFonts.rubik(
                        fontSize: 10.sp,
                        color: Colors.grey.shade400,
                      ),
                    ),
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
                  height: 64.w,
                  width: 48.w,
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                  ),
                  child: TextField(
                    controller: _repsController,
                    onChanged: _handleRepsChange,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.r),
                        borderSide: BorderSide(
                          color: Colors.grey.shade900,
                        ),
                      ),
                      hintText: '0',
                      hintStyle: GoogleFonts.rubik(
                        fontSize: 10.sp,
                        color: Colors.grey.shade400,
                      ),
                    ),
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
