import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/src/app.dart';
import 'package:gamified/src/common/failures/failure.dart';
import 'package:gamified/src/common/providers/supabase.dart';
import 'package:gamified/src/common/widgets/button/primary_button.dart';
import 'package:gamified/src/features/stats/presentations/controller/stat_overview_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class StatsOverviewPage extends ConsumerWidget {
  const StatsOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewState = ref.watch(statOverviewControllerProvider);
    return SafeArea(
      child: overviewState.when(
        data: (data) => SingleChildScrollView(
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
                    foregroundImage:
                        NetworkImage(data.user.userMetadata!['avatar_url']),
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
                          data.user.userMetadata!['username'],
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
              20.verticalSpace,
              Flexible(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    _buildStatCard(
                        'Strength',
                        data.userAttribute.strength.toString(),
                        Colors.grey[900]!),
                    _buildStatCard(
                        'Stamina',
                        data.userAttribute.stamina.toString(),
                        Colors.grey[850]!),
                    _buildStatCard(
                        'Agility',
                        data.userAttribute.agility.toString(),
                        Colors.grey[850]!),
                    _buildStatCard(
                        'Endurance',
                        data.userAttribute.endurance.toString(),
                        Colors.grey[900]!),
                  ],
                ),
              ),
              20.verticalSpace,
              Row(
                children: [
                  Text(
                    'WorkOut Days',
                    style: GoogleFonts.pressStart2p(
                      fontSize: 14,
                      color: Colors.grey[900],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // display days
              _buildNextWorkoutCard(),
              const SizedBox(height: 20),
            ],
          ),
        ),
        error: (error, st) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text((error as Failure).message),
              // button for retry,
              PrimaryButton(
                title: 'Retry',
                onTap: () => ref.invalidate(statOverviewControllerProvider),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator.adaptive(),
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
