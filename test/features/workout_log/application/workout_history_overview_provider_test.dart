import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamified/src/features/workout_log/application/workout_history_overview_provider.dart';
import 'package:gamified/src/features/workout_log/model/workout_log.dart';

void main() {
  group('workoutHistoryOverviewProvider', () {
    test('builds 6-week calendar grid with streak data', () async {
      final today = DateTime(2024, 6, 15);
      final logs = [
        _logOn(DateTime(2024, 6, 15)),
        _logOn(DateTime(2024, 6, 14)),
        _logOn(DateTime(2024, 6, 13)),
        _logOn(DateTime(2024, 6, 1)),
        _logOn(DateTime(2024, 5, 30)),
      ];

      final container = ProviderContainer(overrides: [
        workoutHistoryLogsProvider.overrideWith(
          (_) => Future.value(logs),
        ),
        workoutHistoryNowProvider.overrideWith((_) => today),
      ]);
      addTearDown(container.dispose);

      await container.read(workoutHistoryLogsProvider.future);
      final overviewAsync =
          container.read(workoutHistoryOverviewProvider(DateTime(2024, 6, 1)));
      expect(overviewAsync.hasValue, isTrue);
      final overview = overviewAsync.value!;

      expect(overview.days.length, 42);
      expect(overview.currentStreak, 3);
      expect(overview.workoutsThisMonth, 4);
      expect(overview.totalWorkouts, logs.length);

      final firstDay = overview.days.first.date;
      expect(firstDay.weekday, DateTime.monday);

      final highlightedDates = overview.days
          .where((day) => day.hasWorkout)
          .map((day) => day.date)
          .toSet();
      expect(highlightedDates.contains(DateTime(2024, 6, 15)), isTrue);
      expect(highlightedDates.contains(DateTime(2024, 5, 30)), isTrue);
    });

    test('returns zero streak when there are no workouts', () async {
      final today = DateTime(2024, 7, 1);

      final container = ProviderContainer(overrides: [
        workoutHistoryLogsProvider.overrideWith(
          (_) => Future.value(<WorkoutLogsDTO>[]),
        ),
        workoutHistoryNowProvider.overrideWith((_) => today),
      ]);
      addTearDown(container.dispose);

      await container.read(workoutHistoryLogsProvider.future);
      final overviewAsync =
          container.read(workoutHistoryOverviewProvider(DateTime(2024, 7, 1)));
      expect(overviewAsync.hasValue, isTrue);
      final overview = overviewAsync.value!;

      expect(overview.currentStreak, 0);
      expect(overview.workoutsThisMonth, 0);
      expect(
        overview.days.where((day) => day.hasWorkout),
        isEmpty,
      );
    });
  });
}

WorkoutLogsDTO _logOn(DateTime date) {
  return WorkoutLogsDTO(
    planId: 1,
    duration: const Duration(minutes: 45),
    workoutDate: date,
  );
}

