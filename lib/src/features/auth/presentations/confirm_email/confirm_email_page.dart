import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/app.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmEmailPage extends StatelessWidget {
  const ConfirmEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // logo

            // title
            Text(
              '🎉 Welcome to RankUpFit!',
              style: GoogleFonts.rubikMonoOne(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            16.verticalSpace,
            Text(
              'We’re excited to have you on board! A confirmation email has been sent to your inbox. Please check your email and follow the instructions to complete your registration.',
              style: GoogleFonts.rubik(
                fontSize: 16.sp,
              ),
            ),
            Text(
              'If you don’t see it soon, be sure to check your spam or junk folder.',
              style: GoogleFonts.rubik(
                fontSize: 16.sp,
              ),
            ),
            Text(
              'Let’s get started on your fitness journey!',
              style: GoogleFonts.rubik(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
