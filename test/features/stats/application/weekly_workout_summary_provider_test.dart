import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamified/src/common/util/datetime_ext.dart';
import 'package:gamified/src/common/util/workout_log_filter.dart';
import 'package:gamified/src/features/stats/application/weekly_workout_summary_provider.dart';
import 'package:gamified/src/features/stats/model/weekly_workout_summary.dart';
import 'package:gamified/src/features/workout_log/data/workout_log_repository.dart';
import 'package:gamified/src/features/workout_log/model/workout_log.dart';

void main() {
  group('weeklyWorkoutSummaryProvider', () {
    test('maps weekly workouts into day chips and streak data', () async {
      final today = DateTime.now().date;
      final mondayThisWeek = today.subtract(Duration(days: today.weekday - 1));
      final thursday = mondayThisWeek.add(const Duration(days: 3));
      final saturday = mondayThisWeek.add(const Duration(days: 5));

      final weeklyLogs = [
        _logFor(thursday),
        _logFor(today),
        _logFor(saturday),
      ];

      final allLogs = [
        _logFor(today),
        _logFor(today.subtract(const Duration(days: 1))),
        _logFor(today.subtract(const Duration(days: 2))),
      ];

      final repo = _FakeWorkoutLogRepository(
        weeklyLogs: weeklyLogs,
        allLogs: allLogs,
      );

      final container = ProviderContainer(
        overrides: [workoutLogRepoProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      final listener = container.listen(
        weeklyWorkoutSummaryProvider,
        (_, __) {},
        fireImmediately: true,
      );
      addTearDown(listener.close);

      final WeeklyWorkoutSummary summary =
          await container.read(weeklyWorkoutSummaryProvider.future);

      expect(summary.currentStreak, 3);

      final todayChip =
          summary.days.firstWhere((day) => day.date == today, orElse: () {
        fail('Today chip missing from summary');
      });
      expect(todayChip.hasWorkout, isTrue);
      expect(todayChip.isToday, isTrue);

      final mondayChip =
          summary.days.firstWhere((day) => day.date == mondayThisWeek);
      expect(mondayChip.label, 'M');
      expect(mondayChip.hasWorkout, isFalse);
    });

    test('keeps streak when latest workout is before today', () async {
      final today = DateTime.now().date;

      final repo = _FakeWorkoutLogRepository(
        weeklyLogs: [
          _logFor(today.subtract(const Duration(days: 1))),
          _logFor(today.subtract(const Duration(days: 2))),
        ],
        allLogs: [
          _logFor(today.subtract(const Duration(days: 1))),
          _logFor(today.subtract(const Duration(days: 2))),
        ],
      );

      final container = ProviderContainer(
        overrides: [workoutLogRepoProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      final listener = container.listen(
        weeklyWorkoutSummaryProvider,
        (_, __) {},
        fireImmediately: true,
      );
      addTearDown(listener.close);

      final summary =
          await container.read(weeklyWorkoutSummaryProvider.future);

      expect(summary.currentStreak, 2);

      final todayChip =
          summary.days.firstWhere((day) => day.date == today, orElse: () {
        fail('Today chip missing from summary');
      });
      expect(todayChip.hasWorkout, isFalse);
    });
  });
}

WorkoutLogsDTO _logFor(DateTime date) {
  return WorkoutLogsDTO(
    planId: 1,
    duration: const Duration(minutes: 30),
    workoutDate: date.date,
  );
}

class _FakeWorkoutLogRepository implements WorkoutLogRepository {
  _FakeWorkoutLogRepository({
    required List<WorkoutLogsDTO> weeklyLogs,
    required List<WorkoutLogsDTO> allLogs,
  })  : _weeklyLogs = weeklyLogs,
        _allLogs = allLogs;

  final List<WorkoutLogsDTO> _weeklyLogs;
  final List<WorkoutLogsDTO> _allLogs;

  @override
  Future<int> addWorkoutLog(WorkoutLogsDTO log) {
    throw UnimplementedError();
  }

  @override
  Future<List<WorkoutLogsDTO>> getAllWorkoutLogs() async => _allLogs;

  @override
  Future<WorkoutLogsDTO?> getWorkoutLogByDate(DateTime date) {
    throw UnimplementedError();
  }

  @override
  Stream<WorkoutLogsDTO?> getWorkoutLogByDateStream(DateTime date) {
    throw UnimplementedError();
  }

  @override
  Future<List<WorkoutLogsDTO>> getWorkoutLogsByDate(DateTime date) {
    throw UnimplementedError();
  }

  @override
  Stream<List<WorkoutLogsDTO>> getWorkoutLogs(WorkoutLogFilter filter) {
    if (filter != WorkoutLogFilter.week) {
      return Stream.value(const []);
    }
    return Stream.value(_weeklyLogs);
  }
}

