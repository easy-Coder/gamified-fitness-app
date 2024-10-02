import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class ExcerciseCard extends StatelessWidget {
  const ExcerciseCard({
    super.key,
    required this.excercise,
    required this.value,
    required this.onSelected,
  });

  final Excercise excercise;
  final bool value;
  final Function(Excercise) onSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected(excercise),
      child: Card.outlined(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: value ? Colors.grey.shade900 : Colors.grey.shade400,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Row(
            children: [
              Container(
                width: 120.w,
                height: 120.w,
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
                    Text(
                      excercise.name,
                      style: GoogleFonts.rubik(
                        color: Colors.grey[900],
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
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
                        const Icon(
                          Icons.circle,
                          color: Colors.black,
                          size: 10,
                        ),
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
}
