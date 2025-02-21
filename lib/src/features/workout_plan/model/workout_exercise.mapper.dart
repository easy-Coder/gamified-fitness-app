// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'workout_exercise.dart';

class WorkoutExerciseMapper extends ClassMapperBase<WorkoutExercise> {
  WorkoutExerciseMapper._();

  static WorkoutExerciseMapper? _instance;
  static WorkoutExerciseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = WorkoutExerciseMapper._());
      ExerciseMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'WorkoutExercise';

  static int? _$id(WorkoutExercise v) => v.id;
  static const Field<WorkoutExercise, int> _f$id =
      Field('id', _$id, key: r'workout_exercise_id', opt: true);
  static int? _$planId(WorkoutExercise v) => v.planId;
  static const Field<WorkoutExercise, int> _f$planId =
      Field('planId', _$planId, key: r'plan_id', opt: true);
  static int _$orderInWorkout(WorkoutExercise v) => v.orderInWorkout;
  static const Field<WorkoutExercise, int> _f$orderInWorkout = Field(
      'orderInWorkout', _$orderInWorkout,
      key: r'order_in_workout', opt: true, def: 0);
  static Exercise _$exercise(WorkoutExercise v) => v.exercise;
  static const Field<WorkoutExercise, Exercise> _f$exercise =
      Field('exercise', _$exercise);

  @override
  final MappableFields<WorkoutExercise> fields = const {
    #id: _f$id,
    #planId: _f$planId,
    #orderInWorkout: _f$orderInWorkout,
    #exercise: _f$exercise,
  };

  static WorkoutExercise _instantiate(DecodingData data) {
    return WorkoutExercise(
        id: data.dec(_f$id),
        planId: data.dec(_f$planId),
        orderInWorkout: data.dec(_f$orderInWorkout),
        exercise: data.dec(_f$exercise));
  }

  @override
  final Function instantiate = _instantiate;

  static WorkoutExercise fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<WorkoutExercise>(map);
  }

  static WorkoutExercise fromJson(String json) {
    return ensureInitialized().decodeJson<WorkoutExercise>(json);
  }
}

mixin WorkoutExerciseMappable {
  String toJson() {
    return WorkoutExerciseMapper.ensureInitialized()
        .encodeJson<WorkoutExercise>(this as WorkoutExercise);
  }

  Map<String, dynamic> toMap() {
    return WorkoutExerciseMapper.ensureInitialized()
        .encodeMap<WorkoutExercise>(this as WorkoutExercise);
  }

  WorkoutExerciseCopyWith<WorkoutExercise, WorkoutExercise, WorkoutExercise>
      get copyWith => _WorkoutExerciseCopyWithImpl(
          this as WorkoutExercise, $identity, $identity);
  @override
  String toString() {
    return WorkoutExerciseMapper.ensureInitialized()
        .stringifyValue(this as WorkoutExercise);
  }

  @override
  bool operator ==(Object other) {
    return WorkoutExerciseMapper.ensureInitialized()
        .equalsValue(this as WorkoutExercise, other);
  }

  @override
  int get hashCode {
    return WorkoutExerciseMapper.ensureInitialized()
        .hashValue(this as WorkoutExercise);
  }
}

extension WorkoutExerciseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, WorkoutExercise, $Out> {
  WorkoutExerciseCopyWith<$R, WorkoutExercise, $Out> get $asWorkoutExercise =>
      $base.as((v, t, t2) => _WorkoutExerciseCopyWithImpl(v, t, t2));
}

abstract class WorkoutExerciseCopyWith<$R, $In extends WorkoutExercise, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ExerciseCopyWith<$R, Exercise, Exercise> get exercise;
  $R call({int? id, int? planId, int? orderInWorkout, Exercise? exercise});
  WorkoutExerciseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _WorkoutExerciseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, WorkoutExercise, $Out>
    implements WorkoutExerciseCopyWith<$R, WorkoutExercise, $Out> {
  _WorkoutExerciseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<WorkoutExercise> $mapper =
      WorkoutExerciseMapper.ensureInitialized();
  @override
  ExerciseCopyWith<$R, Exercise, Exercise> get exercise =>
      $value.exercise.copyWith.$chain((v) => call(exercise: v));
  @override
  $R call(
          {Object? id = $none,
          Object? planId = $none,
          int? orderInWorkout,
          Exercise? exercise}) =>
      $apply(FieldCopyWithData({
        if (id != $none) #id: id,
        if (planId != $none) #planId: planId,
        if (orderInWorkout != null) #orderInWorkout: orderInWorkout,
        if (exercise != null) #exercise: exercise
      }));
  @override
  WorkoutExercise $make(CopyWithData data) => WorkoutExercise(
      id: data.get(#id, or: $value.id),
      planId: data.get(#planId, or: $value.planId),
      orderInWorkout: data.get(#orderInWorkout, or: $value.orderInWorkout),
      exercise: data.get(#exercise, or: $value.exercise));

  @override
  WorkoutExerciseCopyWith<$R2, WorkoutExercise, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _WorkoutExerciseCopyWithImpl($value, $cast, t);
}
