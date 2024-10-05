import 'package:dart_mappable/dart_mappable.dart';
import 'package:gamified/src/features/stats/model/user_attributes.dart';
import 'package:gamified/src/features/workout_plan/model/workout_plan.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'overview_model.mapper.dart';

@MappableClass()
class OverviewModel with OverviewModelMappable {
  final User user;
  final UserAttribute userAttribute;
  final List<WorkoutPlan> workoutPlans;

  OverviewModel({
    required this.user,
    required this.userAttribute,
    required this.workoutPlans,
  });
}
