// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'workout_plan.dart';

class DaysOfWeekMapper extends EnumMapper<DaysOfWeek> {
  DaysOfWeekMapper._();

  static DaysOfWeekMapper? _instance;
  static DaysOfWeekMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DaysOfWeekMapper._());
    }
    return _instance!;
  }

  static DaysOfWeek fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  DaysOfWeek decode(dynamic value) {
    switch (value) {
      case 'monday':
        return DaysOfWeek.monday;
      case 'tuesday':
        return DaysOfWeek.tuesday;
      case 'wednesday':
        return DaysOfWeek.wednesday;
      case 'thursday':
        return DaysOfWeek.thursday;
      case 'friday':
        return DaysOfWeek.friday;
      case 'saturday':
        return DaysOfWeek.saturday;
      case 'sunday':
        return DaysOfWeek.sunday;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(DaysOfWeek self) {
    switch (self) {
      case DaysOfWeek.monday:
        return 'monday';
      case DaysOfWeek.tuesday:
        return 'tuesday';
      case DaysOfWeek.wednesday:
        return 'wednesday';
      case DaysOfWeek.thursday:
        return 'thursday';
      case DaysOfWeek.friday:
        return 'friday';
      case DaysOfWeek.saturday:
        return 'saturday';
      case DaysOfWeek.sunday:
        return 'sunday';
    }
  }
}

extension DaysOfWeekMapperExtension on DaysOfWeek {
  String toValue() {
    DaysOfWeekMapper.ensureInitialized();
    return MapperContainer.globals.toValue<DaysOfWeek>(this) as String;
  }
}

class WorkoutPlanMapper extends ClassMapperBase<WorkoutPlan> {
  WorkoutPlanMapper._();

  static WorkoutPlanMapper? _instance;
  static WorkoutPlanMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = WorkoutPlanMapper._());
      DaysOfWeekMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'WorkoutPlan';

  static int? _$id(WorkoutPlan v) => v.id;
  static const Field<WorkoutPlan, int> _f$id = Field('id', _$id);
  static String _$name(WorkoutPlan v) => v.name;
  static const Field<WorkoutPlan, String> _f$name = Field('name', _$name);
  static DaysOfWeek _$dayOfWeek(WorkoutPlan v) => v.dayOfWeek;
  static const Field<WorkoutPlan, DaysOfWeek> _f$dayOfWeek =
      Field('dayOfWeek', _$dayOfWeek, key: r'day_of_week');
  static List<InvalidType> _$workoutExercise(WorkoutPlan v) =>
      v.workoutExercise;
  static const Field<WorkoutPlan, List<InvalidType>> _f$workoutExercise =
      Field('workoutExercise', _$workoutExercise);

  @override
  final MappableFields<WorkoutPlan> fields = const {
    #id: _f$id,
    #name: _f$name,
    #dayOfWeek: _f$dayOfWeek,
    #workoutExercise: _f$workoutExercise,
  };

  static WorkoutPlan _instantiate(DecodingData data) {
    return WorkoutPlan(data.dec(_f$id), data.dec(_f$name),
        data.dec(_f$dayOfWeek), data.dec(_f$workoutExercise));
  }

  @override
  final Function instantiate = _instantiate;

  static WorkoutPlan fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<WorkoutPlan>(map);
  }

  static WorkoutPlan fromJson(String json) {
    return ensureInitialized().decodeJson<WorkoutPlan>(json);
  }
}

mixin WorkoutPlanMappable {
  String toJson() {
    return WorkoutPlanMapper.ensureInitialized()
        .encodeJson<WorkoutPlan>(this as WorkoutPlan);
  }

  Map<String, dynamic> toMap() {
    return WorkoutPlanMapper.ensureInitialized()
        .encodeMap<WorkoutPlan>(this as WorkoutPlan);
  }

  WorkoutPlanCopyWith<WorkoutPlan, WorkoutPlan, WorkoutPlan> get copyWith =>
      _WorkoutPlanCopyWithImpl(this as WorkoutPlan, $identity, $identity);
  @override
  String toString() {
    return WorkoutPlanMapper.ensureInitialized()
        .stringifyValue(this as WorkoutPlan);
  }

  @override
  bool operator ==(Object other) {
    return WorkoutPlanMapper.ensureInitialized()
        .equalsValue(this as WorkoutPlan, other);
  }

  @override
  int get hashCode {
    return WorkoutPlanMapper.ensureInitialized().hashValue(this as WorkoutPlan);
  }
}

extension WorkoutPlanValueCopy<$R, $Out>
    on ObjectCopyWith<$R, WorkoutPlan, $Out> {
  WorkoutPlanCopyWith<$R, WorkoutPlan, $Out> get $asWorkoutPlan =>
      $base.as((v, t, t2) => _WorkoutPlanCopyWithImpl(v, t, t2));
}

abstract class WorkoutPlanCopyWith<$R, $In extends WorkoutPlan, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, InvalidType, ObjectCopyWith<$R, InvalidType, InvalidType>>
      get workoutExercise;
  $R call(
      {int? id,
      String? name,
      DaysOfWeek? dayOfWeek,
      List<InvalidType>? workoutExercise});
  WorkoutPlanCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _WorkoutPlanCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, WorkoutPlan, $Out>
    implements WorkoutPlanCopyWith<$R, WorkoutPlan, $Out> {
  _WorkoutPlanCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<WorkoutPlan> $mapper =
      WorkoutPlanMapper.ensureInitialized();
  @override
  ListCopyWith<$R, InvalidType, ObjectCopyWith<$R, InvalidType, InvalidType>>
      get workoutExercise => ListCopyWith(
          $value.workoutExercise,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(workoutExercise: v));
  @override
  $R call(
          {Object? id = $none,
          String? name,
          DaysOfWeek? dayOfWeek,
          List<InvalidType>? workoutExercise}) =>
      $apply(FieldCopyWithData({
        if (id != $none) #id: id,
        if (name != null) #name: name,
        if (dayOfWeek != null) #dayOfWeek: dayOfWeek,
        if (workoutExercise != null) #workoutExercise: workoutExercise
      }));
  @override
  WorkoutPlan $make(CopyWithData data) => WorkoutPlan(
      data.get(#id, or: $value.id),
      data.get(#name, or: $value.name),
      data.get(#dayOfWeek, or: $value.dayOfWeek),
      data.get(#workoutExercise, or: $value.workoutExercise));

  @override
  WorkoutPlanCopyWith<$R2, WorkoutPlan, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _WorkoutPlanCopyWithImpl($value, $cast, t);
}
