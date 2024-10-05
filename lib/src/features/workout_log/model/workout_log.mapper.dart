// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'workout_log.dart';

class WorkoutLogMapper extends ClassMapperBase<WorkoutLog> {
  WorkoutLogMapper._();

  static WorkoutLogMapper? _instance;
  static WorkoutLogMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = WorkoutLogMapper._());
      DaysOfWeekMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'WorkoutLog';

  static int? _$logId(WorkoutLog v) => v.logId;
  static const Field<WorkoutLog, int> _f$logId =
      Field('logId', _$logId, key: 'log_id', opt: true);
  static String? _$userId(WorkoutLog v) => v.userId;
  static const Field<WorkoutLog, String> _f$userId =
      Field('userId', _$userId, key: 'user_id', opt: true);
  static String _$notes(WorkoutLog v) => v.notes;
  static const Field<WorkoutLog, String> _f$notes =
      Field('notes', _$notes, opt: true, def: '');
  static int _$stamina(WorkoutLog v) => v.stamina;
  static const Field<WorkoutLog, int> _f$stamina = Field('stamina', _$stamina);
  static int _$endurance(WorkoutLog v) => v.endurance;
  static const Field<WorkoutLog, int> _f$endurance =
      Field('endurance', _$endurance);
  static int _$agility(WorkoutLog v) => v.agility;
  static const Field<WorkoutLog, int> _f$agility = Field('agility', _$agility);
  static int _$strength(WorkoutLog v) => v.strength;
  static const Field<WorkoutLog, int> _f$strength =
      Field('strength', _$strength);
  static DaysOfWeek _$dayOfWeek(WorkoutLog v) => v.dayOfWeek;
  static const Field<WorkoutLog, DaysOfWeek> _f$dayOfWeek =
      Field('dayOfWeek', _$dayOfWeek, key: 'day_of_week');

  @override
  final MappableFields<WorkoutLog> fields = const {
    #logId: _f$logId,
    #userId: _f$userId,
    #notes: _f$notes,
    #stamina: _f$stamina,
    #endurance: _f$endurance,
    #agility: _f$agility,
    #strength: _f$strength,
    #dayOfWeek: _f$dayOfWeek,
  };

  static WorkoutLog _instantiate(DecodingData data) {
    return WorkoutLog(
        logId: data.dec(_f$logId),
        userId: data.dec(_f$userId),
        notes: data.dec(_f$notes),
        stamina: data.dec(_f$stamina),
        endurance: data.dec(_f$endurance),
        agility: data.dec(_f$agility),
        strength: data.dec(_f$strength),
        dayOfWeek: data.dec(_f$dayOfWeek));
  }

  @override
  final Function instantiate = _instantiate;

  static WorkoutLog fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<WorkoutLog>(map);
  }

  static WorkoutLog fromJson(String json) {
    return ensureInitialized().decodeJson<WorkoutLog>(json);
  }
}

mixin WorkoutLogMappable {
  String toJson() {
    return WorkoutLogMapper.ensureInitialized()
        .encodeJson<WorkoutLog>(this as WorkoutLog);
  }

  Map<String, dynamic> toMap() {
    return WorkoutLogMapper.ensureInitialized()
        .encodeMap<WorkoutLog>(this as WorkoutLog);
  }

  WorkoutLogCopyWith<WorkoutLog, WorkoutLog, WorkoutLog> get copyWith =>
      _WorkoutLogCopyWithImpl(this as WorkoutLog, $identity, $identity);
  @override
  String toString() {
    return WorkoutLogMapper.ensureInitialized()
        .stringifyValue(this as WorkoutLog);
  }

  @override
  bool operator ==(Object other) {
    return WorkoutLogMapper.ensureInitialized()
        .equalsValue(this as WorkoutLog, other);
  }

  @override
  int get hashCode {
    return WorkoutLogMapper.ensureInitialized().hashValue(this as WorkoutLog);
  }
}

extension WorkoutLogValueCopy<$R, $Out>
    on ObjectCopyWith<$R, WorkoutLog, $Out> {
  WorkoutLogCopyWith<$R, WorkoutLog, $Out> get $asWorkoutLog =>
      $base.as((v, t, t2) => _WorkoutLogCopyWithImpl(v, t, t2));
}

abstract class WorkoutLogCopyWith<$R, $In extends WorkoutLog, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {int? logId,
      String? userId,
      String? notes,
      int? stamina,
      int? endurance,
      int? agility,
      int? strength,
      DaysOfWeek? dayOfWeek});
  WorkoutLogCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _WorkoutLogCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, WorkoutLog, $Out>
    implements WorkoutLogCopyWith<$R, WorkoutLog, $Out> {
  _WorkoutLogCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<WorkoutLog> $mapper =
      WorkoutLogMapper.ensureInitialized();
  @override
  $R call(
          {Object? logId = $none,
          Object? userId = $none,
          String? notes,
          int? stamina,
          int? endurance,
          int? agility,
          int? strength,
          DaysOfWeek? dayOfWeek}) =>
      $apply(FieldCopyWithData({
        if (logId != $none) #logId: logId,
        if (userId != $none) #userId: userId,
        if (notes != null) #notes: notes,
        if (stamina != null) #stamina: stamina,
        if (endurance != null) #endurance: endurance,
        if (agility != null) #agility: agility,
        if (strength != null) #strength: strength,
        if (dayOfWeek != null) #dayOfWeek: dayOfWeek
      }));
  @override
  WorkoutLog $make(CopyWithData data) => WorkoutLog(
      logId: data.get(#logId, or: $value.logId),
      userId: data.get(#userId, or: $value.userId),
      notes: data.get(#notes, or: $value.notes),
      stamina: data.get(#stamina, or: $value.stamina),
      endurance: data.get(#endurance, or: $value.endurance),
      agility: data.get(#agility, or: $value.agility),
      strength: data.get(#strength, or: $value.strength),
      dayOfWeek: data.get(#dayOfWeek, or: $value.dayOfWeek));

  @override
  WorkoutLogCopyWith<$R2, WorkoutLog, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _WorkoutLogCopyWithImpl($value, $cast, t);
}
