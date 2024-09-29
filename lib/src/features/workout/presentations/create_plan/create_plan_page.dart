// https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/features/workout/presentations/create_plan/widgets/excercise_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class CreatePlanPage extends ConsumerStatefulWidget {
  const CreatePlanPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePlanPageState();
}

class _CreatePlanPageState extends ConsumerState<CreatePlanPage> {
  String selected = 'Monday';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Workout Plan'),
        titleTextStyle: GoogleFonts.rubik(
          fontSize: 18.sp,
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              // onChanged: (value) => setState(() {
              //   email = value;
              // }),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  borderSide: BorderSide(
                    color: Colors.grey.shade900,
                  ),
                ),
                hintText: 'Workout\'s Name',
                hintStyle: GoogleFonts.rubikMonoOne(
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                ),
              ),
              style: GoogleFonts.rubik(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade900,
              ),
            ),
            8.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Workout Day:'),
                DropdownButton(
                  value: selected,
                  underline: const SizedBox.shrink(),
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedArrowDown01,
                    color: Colors.black,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Monday',
                      child: Text('Monday'),
                    ),
                    DropdownMenuItem(
                      value: 'Tuesday',
                      child: Text('Tuesday'),
                    ),
                    DropdownMenuItem(
                      value: 'Wednesday',
                      child: Text('Wednesday'),
                    ),
                    DropdownMenuItem(
                      value: 'Thursday',
                      child: Text('Thursday'),
                    ),
                    DropdownMenuItem(
                      value: 'Friday',
                      child: Text('Friday'),
                    ),
                    DropdownMenuItem(
                      value: 'Saturday',
                      child: Text('Saturday'),
                    ),
                    DropdownMenuItem(
                      value: 'Sunday',
                      child: Text('Sunday'),
                    ),
                  ],
                  onChanged: (value) {},
                ),
              ],
            ),
            24.verticalSpace,
            Text(
              'Excercises',
              style: GoogleFonts.pressStart2p(
                  color: Colors.black, fontSize: 14.sp),
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) => ExcerciseCard(),
                separatorBuilder: (context, index) => 8.verticalSpace,
                itemCount: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
