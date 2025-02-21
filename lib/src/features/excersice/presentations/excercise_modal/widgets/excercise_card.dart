import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/gen/assets.gen.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ExcerciseCard extends StatelessWidget {
  const ExcerciseCard({
    super.key,
    required this.excercise,
    required this.value,
    required this.onSelected,
  });

  final ExcerciseDataClass excercise;
  final bool value;
  final Function(ExcerciseDataClass) onSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected(excercise),
      child: Card.outlined(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: value ? Colors.grey.shade900 : Colors.grey.shade400,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
          child: Row(
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/${excercise.images[0]}',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              8.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      excercise.name,
                      style: GoogleFonts.rubik(
                        color: Colors.grey[900],
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      spacing: 20,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Difficulty: ',
                              style: ShadTheme.of(context).textTheme.muted,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: List.generate(
                                    _levelConverter(),
                                    (index) => Assets.svg.flame.svg(
                                      width: 12.w,
                                      height: 12.w,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedBodyArmor,
                              color: Colors.grey.shade900,
                              size: 10,
                            ),
                            2.horizontalSpace,
                            Text(
                              excercise.primaryMuscles[0],
                              style: GoogleFonts.rubik(
                                fontSize: 12.sp,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    4.verticalSpace,
                    Row(
                      children: [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedEquipmentGym01,
                          color: Colors.grey.shade900,
                          size: 10,
                        ),
                        2.horizontalSpace,
                        Text(
                          excercise.equipment ?? 'No Equipment',
                          style: GoogleFonts.rubik(
                            color: Colors.grey[800],
                            fontSize: 12.sp,
                          ),
                        ),
                        4.horizontalSpace,
                        const Icon(Icons.circle, color: Colors.black, size: 10),
                        4.horizontalSpace,
                        HugeIcon(
                          icon: Icons.strikethrough_s,
                          color: Colors.grey.shade900,
                          size: 10,
                        ),
                        2.horizontalSpace,
                        Text(
                          excercise.category,
                          style: GoogleFonts.rubik(
                            color: Colors.grey[800],
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _levelConverter() => switch (excercise.level) {
    'beginner' => 1,
    'intermediate' => 2,
    _ => 3,
  };
}
