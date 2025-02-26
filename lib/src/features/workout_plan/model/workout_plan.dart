import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:gamified/src/common/providers/db.dart';
import 'package:gamified/src/features/workout_plan/model/workout_exercise.dart';

// Assuming you have DaysOfWeek and WorkoutExercise defined elsewhere:
enum DaysOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

// Assuming WorkoutExercise extension type from previous example.

extension type WorkoutPlan._(
  ({
    int? id,
    String name,
    DaysOfWeek dayOfWeek,
    List<WorkoutExercise> workoutExercise,
  })
  _
) {
  int? get id => _.id;
  String get name => _.name;
  DaysOfWeek get dayOfWeek => _.dayOfWeek;
  List<WorkoutExercise> get workoutExercise => _.workoutExercise;

  WorkoutPlan({
    int? id,
    required String name,
    required DaysOfWeek dayOfWeek,
    List<WorkoutExercise> workoutExercise = const <WorkoutExercise>[],
  }) : this._((
         id: id,
         name: name,
         dayOfWeek: dayOfWeek,
         workoutExercise: workoutExercise,
       ));

  WorkoutPlan copyWith({
    int? id,
    String? name,
    DaysOfWeek? dayOfWeek,
    List<WorkoutExercise>? workoutExercise,
  }) {
    return WorkoutPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      workoutExercise: workoutExercise ?? this.workoutExercise,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dayOfWeek': dayOfWeek.index,
      'workoutExercise': workoutExercise.map((e) => e.toMap()).toList(),
    };
  }

  static WorkoutPlan fromMap(Map<String, dynamic> map) {
    return WorkoutPlan(
      id: map['id'] as int?,
      name: map['name'] as String,
      dayOfWeek: DaysOfWeek.values[map['dayOfWeek'] as int],
      workoutExercise:
          (map['workoutExercise'] as List<WorkoutExercise>?)
              ?.map((e) => WorkoutExercise.fromMap(e as Map<String, dynamic>))
              .toList() ??
          <WorkoutExercise>[],
    );
  }

  static WorkoutPlan fromJson(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return WorkoutPlan.fromMap(map);
  }

  WorkoutPlanCompanion toCompanion() {
    return WorkoutPlanCompanion.insert(
      id: id != null ? Value(id!) : const Value.absent(),
      name: name,
      dayOfWeek: dayOfWeek,
    );
  }
}

extension IsTodayExt on DaysOfWeek {
  bool isToday() {
    final today = DateTime.now().weekday - 1;
    return DaysOfWeek.values[today] == this;
  }
}
