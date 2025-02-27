import 'package:drift/drift.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart'
    show DaysOfWeek;

class WorkoutPlan extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 10, max: 50)();
  IntColumn get dayOfWeek => intEnum<DaysOfWeek>()();
  BoolColumn get isVisible => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}
