// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'workout_excercise.dart';

class WorkoutExcerciseMapper extends ClassMapperBase<WorkoutExcercise> {
  WorkoutExcerciseMapper._();

  static WorkoutExcerciseMapper? _instance;
  static WorkoutExcerciseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = WorkoutExcerciseMapper._());
      ExcerciseMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'WorkoutExcercise';

  static Excercise _$excercise(WorkoutExcercise v) => v.excercise;
  static const Field<WorkoutExcercise, Excercise> _f$excercise =
      Field('excercise', _$excercise);
  static int _$sets(WorkoutExcercise v) => v.sets;
  static const Field<WorkoutExcercise, int> _f$sets = Field('sets', _$sets);
  static int _$reps(WorkoutExcercise v) => v.reps;
  static const Field<WorkoutExcercise, int> _f$reps = Field('reps', _$reps);

  @override
  final MappableFields<WorkoutExcercise> fields = const {
    #excercise: _f$excercise,
    #sets: _f$sets,
    #reps: _f$reps,
  };

  static WorkoutExcercise _instantiate(DecodingData data) {
    return WorkoutExcercise(
        excercise: data.dec(_f$excercise),
        sets: data.dec(_f$sets),
        reps: data.dec(_f$reps));
  }

  @override
  final Function instantiate = _instantiate;

  static WorkoutExcercise fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<WorkoutExcercise>(map);
  }

  static WorkoutExcercise fromJson(String json) {
    return ensureInitialized().decodeJson<WorkoutExcercise>(json);
  }
}

mixin WorkoutExcerciseMappable {
  String toJson() {
    return WorkoutExcerciseMapper.ensureInitialized()
        .encodeJson<WorkoutExcercise>(this as WorkoutExcercise);
  }

  Map<String, dynamic> toMap() {
    return WorkoutExcerciseMapper.ensureInitialized()
        .encodeMap<WorkoutExcercise>(this as WorkoutExcercise);
  }

  WorkoutExcerciseCopyWith<WorkoutExcercise, WorkoutExcercise, WorkoutExcercise>
      get copyWith => _WorkoutExcerciseCopyWithImpl(
          this as WorkoutExcercise, $identity, $identity);
  @override
  String toString() {
    return WorkoutExcerciseMapper.ensureInitialized()
        .stringifyValue(this as WorkoutExcercise);
  }

  @override
  bool operator ==(Object other) {
    return WorkoutExcerciseMapper.ensureInitialized()
        .equalsValue(this as WorkoutExcercise, other);
  }

  @override
  int get hashCode {
    return WorkoutExcerciseMapper.ensureInitialized()
        .hashValue(this as WorkoutExcercise);
  }
}

extension WorkoutExcerciseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, WorkoutExcercise, $Out> {
  WorkoutExcerciseCopyWith<$R, WorkoutExcercise, $Out>
      get $asWorkoutExcercise =>
          $base.as((v, t, t2) => _WorkoutExcerciseCopyWithImpl(v, t, t2));
}

abstract class WorkoutExcerciseCopyWith<$R, $In extends WorkoutExcercise, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ExcerciseCopyWith<$R, Excercise, Excercise> get excercise;
  $R call({Excercise? excercise, int? sets, int? reps});
  WorkoutExcerciseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _WorkoutExcerciseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, WorkoutExcercise, $Out>
    implements WorkoutExcerciseCopyWith<$R, WorkoutExcercise, $Out> {
  _WorkoutExcerciseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<WorkoutExcercise> $mapper =
      WorkoutExcerciseMapper.ensureInitialized();
  @override
  ExcerciseCopyWith<$R, Excercise, Excercise> get excercise =>
      $value.excercise.copyWith.$chain((v) => call(excercise: v));
  @override
  $R call({Excercise? excercise, int? sets, int? reps}) =>
      $apply(FieldCopyWithData({
        if (excercise != null) #excercise: excercise,
        if (sets != null) #sets: sets,
        if (reps != null) #reps: reps
      }));
  @override
  WorkoutExcercise $make(CopyWithData data) => WorkoutExcercise(
      excercise: data.get(#excercise, or: $value.excercise),
      sets: data.get(#sets, or: $value.sets),
      reps: data.get(#reps, or: $value.reps));

  @override
  WorkoutExcerciseCopyWith<$R2, WorkoutExcercise, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _WorkoutExcerciseCopyWithImpl($value, $cast, t);
}
