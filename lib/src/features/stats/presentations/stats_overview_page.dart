import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/app.dart';
import 'package:gamified/src/common/providers/supabase.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class StatsOverviewPage extends ConsumerWidget {
  const StatsOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.grey[600],
                  ),
                  8.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Welcome,",
                          style: GoogleFonts.rubikMonoOne(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '_easyCoder',
                          style: GoogleFonts.pressStart2p(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              8.verticalSpace,
              Text(
                'Your Stats',
                style: GoogleFonts.pressStart2p(
                  fontSize: 18,
                  color: Colors.grey[900],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    _buildStatCard('Strength', '75', Colors.grey[900]!),
                    _buildStatCard('Stamina', '82', Colors.grey[850]!),
                    _buildStatCard('Agility', '68', Colors.grey[850]!),
                    _buildStatCard('Endurance', '79', Colors.grey[900]!),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildNextWorkoutCard(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: 250.w,
        height: 45.h,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(24.r),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 8.w,
          vertical: 4.h,
        ),
        child: Row(
          children: [
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedHome01,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => ref.read(supabaseProvider).auth.signOut(),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    color: Colors.grey[900],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Workout',
                    style: GoogleFonts.pressStart2p(
                      color: Colors.grey[50],
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedPresentationBarChart01,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: color.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.rubikMonoOne(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: GoogleFonts.pressStart2p(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextWorkoutCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Next Workout',
              style: GoogleFonts.rubikMonoOne(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              'Tomorrow, 7:00 AM',
              style: GoogleFonts.pressStart2p(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
