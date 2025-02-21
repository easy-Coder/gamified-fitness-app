// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'excercise.dart';

class ExerciseMapper extends ClassMapperBase<Exercise> {
  ExerciseMapper._();

  static ExerciseMapper? _instance;
  static ExerciseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExerciseMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Exercise';

  static int _$exerciseId(Exercise v) => v.exerciseId;
  static const Field<Exercise, int> _f$exerciseId =
      Field('exerciseId', _$exerciseId, key: r'exercise_id');
  static String _$name(Exercise v) => v.name;
  static const Field<Exercise, String> _f$name = Field('name', _$name);
  static String? _$force(Exercise v) => v.force;
  static const Field<Exercise, String> _f$force = Field('force', _$force);
  static String _$level(Exercise v) => v.level;
  static const Field<Exercise, String> _f$level = Field('level', _$level);
  static String? _$mechanic(Exercise v) => v.mechanic;
  static const Field<Exercise, String> _f$mechanic =
      Field('mechanic', _$mechanic);
  static String? _$equipment(Exercise v) => v.equipment;
  static const Field<Exercise, String> _f$equipment =
      Field('equipment', _$equipment);
  static List<String> _$primaryMuscles(Exercise v) => v.primaryMuscles;
  static const Field<Exercise, List<String>> _f$primaryMuscles =
      Field('primaryMuscles', _$primaryMuscles, key: r'primary_muscles');
  static List<String> _$secondaryMuscles(Exercise v) => v.secondaryMuscles;
  static const Field<Exercise, List<String>> _f$secondaryMuscles =
      Field('secondaryMuscles', _$secondaryMuscles, key: r'secondary_muscles');
  static List<String> _$instructions(Exercise v) => v.instructions;
  static const Field<Exercise, List<String>> _f$instructions =
      Field('instructions', _$instructions);
  static String _$category(Exercise v) => v.category;
  static const Field<Exercise, String> _f$category =
      Field('category', _$category);
  static List<String> _$images(Exercise v) => v.images;
  static const Field<Exercise, List<String>> _f$images =
      Field('images', _$images);

  @override
  final MappableFields<Exercise> fields = const {
    #exerciseId: _f$exerciseId,
    #name: _f$name,
    #force: _f$force,
    #level: _f$level,
    #mechanic: _f$mechanic,
    #equipment: _f$equipment,
    #primaryMuscles: _f$primaryMuscles,
    #secondaryMuscles: _f$secondaryMuscles,
    #instructions: _f$instructions,
    #category: _f$category,
    #images: _f$images,
  };

  static Exercise _instantiate(DecodingData data) {
    return Exercise(
        exerciseId: data.dec(_f$exerciseId),
        name: data.dec(_f$name),
        force: data.dec(_f$force),
        level: data.dec(_f$level),
        mechanic: data.dec(_f$mechanic),
        equipment: data.dec(_f$equipment),
        primaryMuscles: data.dec(_f$primaryMuscles),
        secondaryMuscles: data.dec(_f$secondaryMuscles),
        instructions: data.dec(_f$instructions),
        category: data.dec(_f$category),
        images: data.dec(_f$images));
  }

  @override
  final Function instantiate = _instantiate;

  static Exercise fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Exercise>(map);
  }

  static Exercise fromJson(String json) {
    return ensureInitialized().decodeJson<Exercise>(json);
  }
}

mixin ExerciseMappable {
  String toJson() {
    return ExerciseMapper.ensureInitialized()
        .encodeJson<Exercise>(this as Exercise);
  }

  Map<String, dynamic> toMap() {
    return ExerciseMapper.ensureInitialized()
        .encodeMap<Exercise>(this as Exercise);
  }

  ExerciseCopyWith<Exercise, Exercise, Exercise> get copyWith =>
      _ExerciseCopyWithImpl(this as Exercise, $identity, $identity);
  @override
  String toString() {
    return ExerciseMapper.ensureInitialized().stringifyValue(this as Exercise);
  }

  @override
  bool operator ==(Object other) {
    return ExerciseMapper.ensureInitialized()
        .equalsValue(this as Exercise, other);
  }

  @override
  int get hashCode {
    return ExerciseMapper.ensureInitialized().hashValue(this as Exercise);
  }
}

extension ExerciseValueCopy<$R, $Out> on ObjectCopyWith<$R, Exercise, $Out> {
  ExerciseCopyWith<$R, Exercise, $Out> get $asExercise =>
      $base.as((v, t, t2) => _ExerciseCopyWithImpl(v, t, t2));
}

abstract class ExerciseCopyWith<$R, $In extends Exercise, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
      get primaryMuscles;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
      get secondaryMuscles;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get instructions;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get images;
  $R call(
      {int? exerciseId,
      String? name,
      String? force,
      String? level,
      String? mechanic,
      String? equipment,
      List<String>? primaryMuscles,
      List<String>? secondaryMuscles,
      List<String>? instructions,
      String? category,
      List<String>? images});
  ExerciseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ExerciseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Exercise, $Out>
    implements ExerciseCopyWith<$R, Exercise, $Out> {
  _ExerciseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Exercise> $mapper =
      ExerciseMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
      get primaryMuscles => ListCopyWith(
          $value.primaryMuscles,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(primaryMuscles: v));
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
      get secondaryMuscles => ListCopyWith(
          $value.secondaryMuscles,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(secondaryMuscles: v));
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
      get instructions => ListCopyWith(
          $value.instructions,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(instructions: v));
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get images =>
      ListCopyWith($value.images, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(images: v));
  @override
  $R call(
          {int? exerciseId,
          String? name,
          Object? force = $none,
          String? level,
          Object? mechanic = $none,
          Object? equipment = $none,
          List<String>? primaryMuscles,
          List<String>? secondaryMuscles,
          List<String>? instructions,
          String? category,
          List<String>? images}) =>
      $apply(FieldCopyWithData({
        if (exerciseId != null) #exerciseId: exerciseId,
        if (name != null) #name: name,
        if (force != $none) #force: force,
        if (level != null) #level: level,
        if (mechanic != $none) #mechanic: mechanic,
        if (equipment != $none) #equipment: equipment,
        if (primaryMuscles != null) #primaryMuscles: primaryMuscles,
        if (secondaryMuscles != null) #secondaryMuscles: secondaryMuscles,
        if (instructions != null) #instructions: instructions,
        if (category != null) #category: category,
        if (images != null) #images: images
      }));
  @override
  Exercise $make(CopyWithData data) => Exercise(
      exerciseId: data.get(#exerciseId, or: $value.exerciseId),
      name: data.get(#name, or: $value.name),
      force: data.get(#force, or: $value.force),
      level: data.get(#level, or: $value.level),
      mechanic: data.get(#mechanic, or: $value.mechanic),
      equipment: data.get(#equipment, or: $value.equipment),
      primaryMuscles: data.get(#primaryMuscles, or: $value.primaryMuscles),
      secondaryMuscles:
          data.get(#secondaryMuscles, or: $value.secondaryMuscles),
      instructions: data.get(#instructions, or: $value.instructions),
      category: data.get(#category, or: $value.category),
      images: data.get(#images, or: $value.images));

  @override
  ExerciseCopyWith<$R2, Exercise, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ExerciseCopyWithImpl($value, $cast, t);
}
