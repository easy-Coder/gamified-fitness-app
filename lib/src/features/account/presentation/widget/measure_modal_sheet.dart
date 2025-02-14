import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class MeasureModalSheet extends StatefulWidget {
  const MeasureModalSheet({super.key});

  @override
  State<MeasureModalSheet> createState() => _MeasureModalSheetState();
}

class _MeasureModalSheetState extends State<MeasureModalSheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableSheet(
      child: Card(
        child: Column(
          children: [
            Container(
              height: 56.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(48.r),
                color: Colors.grey.shade300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
