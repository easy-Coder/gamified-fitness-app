import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamified/gen/assets.gen.dart';

import 'package:gamified/src/features/account/data/preference_repository.dart';
import 'package:gamified/src/features/account/data/user_repository.dart';
import 'package:gamified/src/features/stats/application/weekly_workout_summary_provider.dart';
import 'package:gamified/src/features/stats/model/home_stat.dart';
import 'package:gamified/src/features/stats/model/weekly_workout_summary.dart';
import 'package:gamified/src/features/stats/presentations/controller/health_stats_controller.dart';
import 'package:gamified/src/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsOverviewPage extends ConsumerWidget {
  const StatsOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final preferenceState = ref.watch(preferenceProvider);
    final workoutStats = ref.watch(yesterdayWorkoutSessionStatsProvider);
    final weeklySummary = ref.watch(weeklyWorkoutSummaryProvider);

    final useHealthIntegration = preferenceState.maybeWhen(
      data: (preference) => preference.useHealth,
      orElse: () => false,
    );

    late final AsyncValue<List<HomeStat>> healthStats;
    if (useHealthIntegration) {
      healthStats = ref.watch(yesterdayHealthStatsProvider);
    } else {
      healthStats = const AsyncValue<List<HomeStat>>.data(<HomeStat>[]);
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeroSection(
                userName: userState.maybeWhen(
                  data: (user) => user!.name,
                  orElse: () => '',
                ),
                weeklySummary: weeklySummary,
              ),
              18.verticalSpace,
              WeeklyWorkoutDaysRow(weeklySummary: weeklySummary),
              24.verticalSpace,
              YesterdayStatsSection(
                useHealthIntegration: useHealthIntegration,
                healthStats: healthStats,
                workoutStats: workoutStats,
              ),
              24.verticalSpace,
              StartWorkoutButton(),
              24.verticalSpace,
              const MotivationMessageCard(),
              56.verticalSpace,
              // AISuggestionSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
    required this.userName,
    required this.weeklySummary,
  });

  final String userName;
  final AsyncValue<WeeklyWorkoutSummary> weeklySummary;

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 18) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    final greeting = '${_getGreeting()}\n$userName';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            greeting,
            style: TextStyle(
              fontSize: 48.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: GoogleFonts.bricolageGrotesque().fontFamily,
              height: 1.2,
            ),
          ),
        ),
        StreakCounter(
          days: weeklySummary.maybeWhen(
            data: (summary) => summary.currentStreak,
            orElse: () => null,
          ),
          isLoading: weeklySummary.isLoading,
        ),
      ],
    );
  }
}

class MotivationMessageCard extends StatelessWidget {
  const MotivationMessageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: const NetworkImage(
              'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&w=900&q=80',
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.55),
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Stay consistent and keep your body moving!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Small steps every day lead to big wins.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class StreakCounter extends StatelessWidget {
  const StreakCounter({
    super.key,
    this.textColor = Colors.black87,
    this.borderColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.days,
    this.isLoading = false,
  });

  final Color textColor;
  final Color borderColor;
  final Color backgroundColor;
  final int? days;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: Stack(
            children: [
              Assets.svg.flame.svg(width: 60, height: 60),
              Positioned.fill(
                top: 25,
                left: 20,
                child: isLoading
                    ? const Center(
                        child: SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        '${days ?? 0}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'days streak',
          style: TextStyle(
            fontSize: 12,
            color: textColor.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class WeeklyWorkoutDaysRow extends StatelessWidget {
  const WeeklyWorkoutDaysRow({super.key, required this.weeklySummary});

  final AsyncValue<WeeklyWorkoutSummary> weeklySummary;

  @override
  Widget build(BuildContext context) {
    return weeklySummary.when(
      data: (summary) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: summary.days
                .map((day) => _WeeklyDayChip(day: day))
                .toList(growable: false),
          ),
        );
      },
      loading: () => Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _WeeklyDayChip extends StatelessWidget {
  const _WeeklyDayChip({required this.day});

  final WeeklyWorkoutDay day;

  @override
  Widget build(BuildContext context) {
    final isActive = day.hasWorkout;
    final Color borderColor = day.isToday
        ? Colors.black87
        : Colors.grey.shade300;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          day.label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: day.isToday ? Colors.black : Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isActive ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isActive ? Colors.black : borderColor,
              width: isActive ? 2 : 1.2,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: isActive
              ? const Icon(Icons.check_rounded, size: 20, color: Colors.white)
              : Icon(
                  Icons.remove_rounded,
                  size: 18,
                  color: Colors.grey.shade400,
                ),
        ),
      ],
    );
  }
}

class YesterdayStatsSection extends StatelessWidget {
  const YesterdayStatsSection({
    super.key,
    required this.useHealthIntegration,
    required this.healthStats,
    required this.workoutStats,
  });

  final bool useHealthIntegration;
  final AsyncValue<List<HomeStat>> healthStats;
  final AsyncValue<List<HomeStat>> workoutStats;

  bool _isLoading() {
    final healthLoading =
        useHealthIntegration &&
        healthStats.maybeWhen(loading: () => true, orElse: () => false);
    final workoutLoading = workoutStats.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );
    return healthLoading || workoutLoading;
  }

  bool _hasAnyData() {
    final hasHealthData =
        useHealthIntegration &&
        healthStats.maybeWhen(
          data: (stats) => stats.isNotEmpty,
          orElse: () => false,
        );
    final hasWorkoutData = workoutStats.maybeWhen(
      data: (stats) => stats.isNotEmpty,
      orElse: () => false,
    );
    return hasHealthData || hasWorkoutData;
  }

  bool _hasNoData() {
    if (_isLoading()) return false;
    return !_hasAnyData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Yesterday',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        _hasNoData()
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bar_chart_outlined,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No data yet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      useHealthIntegration
                          ? 'Complete workouts or sync with Health to see your stats here'
                          : 'Complete workouts to see your stats here',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                child: Column(
                  children: [
                    if (useHealthIntegration)
                      healthStats.when(
                        data: (stats) => stats.isEmpty
                            ? const SizedBox.shrink()
                            : _StatsRow(stats: stats),
                        loading: () => const SizedBox(
                          height: 100,
                          child: Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        ),
                        error: (error, stackTrace) => const SizedBox.shrink(),
                      ),
                    if (useHealthIntegration &&
                        healthStats.maybeWhen(
                          data: (stats) => stats.isNotEmpty,
                          orElse: () => false,
                        ) &&
                        workoutStats.maybeWhen(
                          data: (stats) => stats.isNotEmpty,
                          orElse: () => false,
                        ))
                      const SizedBox(height: 20),
                    workoutStats.when(
                      data: (stats) => stats.isEmpty
                          ? const SizedBox.shrink()
                          : _StatsRow(stats: stats),
                      loading: () => const SizedBox(
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                      error: (error, stackTrace) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});

  final List<HomeStat> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: stats.map((stat) {
        return Expanded(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: stat.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Icon(stat.icon, size: 22, color: stat.color),
              ),
              const SizedBox(height: 12),
              Text(
                stat.value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stat.label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class StartWorkoutButton extends StatelessWidget {
  const StartWorkoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.goNamed(AppRouter.workoutPlans.name);
          },
          child: Ink(
            height: 180,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const NetworkImage(
                  'https://images.unsplash.com/photo-1554284126-aa88f22d8b74?auto=format&fit=crop&w=900&q=80',
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.35),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.8),
                        Colors.black.withValues(alpha: 0.1),
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Push Harder Today',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Text(
                        'Start Workout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 18,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Let’s go',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AISuggestionSection extends StatelessWidget {
  const AISuggestionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suggestion (A.I.)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Text(
            aiSuggestion.message,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
