import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamified/gen/assets.gen.dart';

import 'package:gamified/src/features/account/data/preference_repository.dart';
import 'package:gamified/src/features/account/data/user_repository.dart';
import 'package:gamified/src/features/stats/model/home_stat.dart';
import 'package:gamified/src/features/stats/presentations/controller/health_stats_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsOverviewPage extends ConsumerWidget {
  const StatsOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final preferenceState = ref.watch(preferenceProvider);
    final workoutStats = ref.watch(yesterdayWorkoutSessionStatsProvider);

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
              ),
              SizedBox(height: 24),
              YesterdayStatsSection(
                useHealthIntegration: useHealthIntegration,
                healthStats: healthStats,
                workoutStats: workoutStats,
              ),
              SizedBox(height: 24),
              StartWorkoutButton(),
              const SizedBox(height: 24),
              const MotivationMessageCard(),
              SizedBox(height: 24),
              // AISuggestionSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key, required this.userName});

  final String userName;

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
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: GoogleFonts.bricolageGrotesque().fontFamily,
              height: 1.2,
            ),
          ),
        ),
        const StreakCounter(),
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
  });

  final Color textColor;
  final Color borderColor;
  final Color backgroundColor;

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
                child: Text(
                  '${streakData.days}',
                  style: TextStyle(
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
        Container(
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
                  data: (stats) => _StatsRow(
                    stats: stats.isEmpty ? _zeroHealthStats() : stats,
                  ),
                  loading: () => const SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  ),
                  error: (error, stackTrace) => Column(
                    children: [
                      _StatsRow(stats: _zeroHealthStats()),
                      const SizedBox(height: 12),
                      Text(
                        'Unable to sync with Health right now.',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              if (useHealthIntegration) const SizedBox(height: 20),
              workoutStats.when(
                data: (stats) => _StatsRow(
                  stats: stats.isEmpty ? _zeroWorkoutStats() : stats,
                ),
                loading: () => const SizedBox(
                  height: 100,
                  child: Center(child: CircularProgressIndicator.adaptive()),
                ),
                error: (error, stackTrace) => Column(
                  children: [
                    _StatsRow(stats: _zeroWorkoutStats()),
                    const SizedBox(height: 12),
                    Text(
                      'No local workout data yet.',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
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

List<HomeStat> _zeroHealthStats() => [
  HomeStat(
    value: '0',
    label: '🔥 calories',
    icon: Icons.local_fire_department_outlined,
    color: Colors.deepOrange,
  ),
  HomeStat(
    value: '0',
    label: '👣 steps',
    icon: Icons.directions_walk_outlined,
    color: Colors.blueAccent,
  ),
  HomeStat(
    value: '0 m',
    label: '⏱️ active times',
    icon: Icons.access_time_rounded,
    color: Colors.green,
  ),
];

List<HomeStat> _zeroWorkoutStats() => [
  HomeStat(
    value: '0m',
    label: '⏳ duration',
    icon: Icons.timer_outlined,
    color: Colors.purple,
  ),
  HomeStat(
    value: '0 kg',
    label: '🏋️ volume',
    icon: Icons.fitness_center_outlined,
    color: Colors.teal,
  ),
  HomeStat(
    value: '0',
    label: '📅 sessions',
    icon: Icons.calendar_today_outlined,
    color: Colors.indigo,
  ),
];

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
          onTap: () {},
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
