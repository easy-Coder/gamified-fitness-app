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
      case 'Monday':
        return DaysOfWeek.Monday;
      case 'Tuesday':
        return DaysOfWeek.Tuesday;
      case 'Wednesday':
        return DaysOfWeek.Wednesday;
      case 'Thursday':
        return DaysOfWeek.Thursday;
      case 'Friday':
        return DaysOfWeek.Friday;
      case 'Saturday':
        return DaysOfWeek.Saturday;
      case 'Sunday':
        return DaysOfWeek.Sunday;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(DaysOfWeek self) {
    switch (self) {
      case DaysOfWeek.Monday:
        return 'Monday';
      case DaysOfWeek.Tuesday:
        return 'Tuesday';
      case DaysOfWeek.Wednesday:
        return 'Wednesday';
      case DaysOfWeek.Thursday:
        return 'Thursday';
      case DaysOfWeek.Friday:
        return 'Friday';
      case DaysOfWeek.Saturday:
        return 'Saturday';
      case DaysOfWeek.Sunday:
        return 'Sunday';
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

  static int? _$planId(WorkoutPlan v) => v.planId;
  static const Field<WorkoutPlan, int> _f$planId =
      Field('planId', _$planId, key: r'plan_id');
  static String _$name(WorkoutPlan v) => v.name;
  static const Field<WorkoutPlan, String> _f$name = Field('name', _$name);
  static DaysOfWeek _$dayOfWeek(WorkoutPlan v) => v.dayOfWeek;
  static const Field<WorkoutPlan, DaysOfWeek> _f$dayOfWeek =
      Field('dayOfWeek', _$dayOfWeek, key: r'day_of_week');
  static String? _$userId(WorkoutPlan v) => v.userId;
  static const Field<WorkoutPlan, String> _f$userId =
      Field('userId', _$userId, key: r'user_id');

  @override
  final MappableFields<WorkoutPlan> fields = const {
    #planId: _f$planId,
    #name: _f$name,
    #dayOfWeek: _f$dayOfWeek,
    #userId: _f$userId,
  };

  static WorkoutPlan _instantiate(DecodingData data) {
    return WorkoutPlan(data.dec(_f$planId), data.dec(_f$name),
        data.dec(_f$dayOfWeek), data.dec(_f$userId));
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
  $R call({int? planId, String? name, DaysOfWeek? dayOfWeek, String? userId});
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
  $R call(
          {Object? planId = $none,
          String? name,
          DaysOfWeek? dayOfWeek,
          Object? userId = $none}) =>
      $apply(FieldCopyWithData({
        if (planId != $none) #planId: planId,
        if (name != null) #name: name,
        if (dayOfWeek != null) #dayOfWeek: dayOfWeek,
        if (userId != $none) #userId: userId
      }));
  @override
  WorkoutPlan $make(CopyWithData data) => WorkoutPlan(
      data.get(#planId, or: $value.planId),
      data.get(#name, or: $value.name),
      data.get(#dayOfWeek, or: $value.dayOfWeek),
      data.get(#userId, or: $value.userId));

  @override
  WorkoutPlanCopyWith<$R2, WorkoutPlan, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _WorkoutPlanCopyWithImpl($value, $cast, t);
}
