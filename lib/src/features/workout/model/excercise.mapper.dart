// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'excercise.dart';

class ExcerciseMapper extends ClassMapperBase<Excercise> {
  ExcerciseMapper._();

  static ExcerciseMapper? _instance;
  static ExcerciseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ExcerciseMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Excercise';

  static int _$exerciseId(Excercise v) => v.exerciseId;
  static const Field<Excercise, int> _f$exerciseId =
      Field('exerciseId', _$exerciseId);
  static String _$name(Excercise v) => v.name;
  static const Field<Excercise, String> _f$name = Field('name', _$name);
  static String _$force(Excercise v) => v.force;
  static const Field<Excercise, String> _f$force = Field('force', _$force);
  static String _$level(Excercise v) => v.level;
  static const Field<Excercise, String> _f$level = Field('level', _$level);
  static String _$mechanic(Excercise v) => v.mechanic;
  static const Field<Excercise, String> _f$mechanic =
      Field('mechanic', _$mechanic);
  static String _$equipment(Excercise v) => v.equipment;
  static const Field<Excercise, String> _f$equipment =
      Field('equipment', _$equipment);
  static List<String> _$primaryMuscles(Excercise v) => v.primaryMuscles;
  static const Field<Excercise, List<String>> _f$primaryMuscles =
      Field('primaryMuscles', _$primaryMuscles);
  static List<String> _$secondaryMuscles(Excercise v) => v.secondaryMuscles;
  static const Field<Excercise, List<String>> _f$secondaryMuscles =
      Field('secondaryMuscles', _$secondaryMuscles);
  static List<String> _$instructions(Excercise v) => v.instructions;
  static const Field<Excercise, List<String>> _f$instructions =
      Field('instructions', _$instructions);
  static String _$category(Excercise v) => v.category;
  static const Field<Excercise, String> _f$category =
      Field('category', _$category);
  static List<String> _$images(Excercise v) => v.images;
  static const Field<Excercise, List<String>> _f$images =
      Field('images', _$images);

  @override
  final MappableFields<Excercise> fields = const {
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

  static Excercise _instantiate(DecodingData data) {
    return Excercise(
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

  static Excercise fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Excercise>(map);
  }

  static Excercise fromJson(String json) {
    return ensureInitialized().decodeJson<Excercise>(json);
  }
}

mixin ExcerciseMappable {
  String toJson() {
    return ExcerciseMapper.ensureInitialized()
        .encodeJson<Excercise>(this as Excercise);
  }

  Map<String, dynamic> toMap() {
    return ExcerciseMapper.ensureInitialized()
        .encodeMap<Excercise>(this as Excercise);
  }

  ExcerciseCopyWith<Excercise, Excercise, Excercise> get copyWith =>
      _ExcerciseCopyWithImpl(this as Excercise, $identity, $identity);
  @override
  String toString() {
    return ExcerciseMapper.ensureInitialized()
        .stringifyValue(this as Excercise);
  }

  @override
  bool operator ==(Object other) {
    return ExcerciseMapper.ensureInitialized()
        .equalsValue(this as Excercise, other);
  }

  @override
  int get hashCode {
    return ExcerciseMapper.ensureInitialized().hashValue(this as Excercise);
  }
}

extension ExcerciseValueCopy<$R, $Out> on ObjectCopyWith<$R, Excercise, $Out> {
  ExcerciseCopyWith<$R, Excercise, $Out> get $asExcercise =>
      $base.as((v, t, t2) => _ExcerciseCopyWithImpl(v, t, t2));
}

abstract class ExcerciseCopyWith<$R, $In extends Excercise, $Out>
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
  ExcerciseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ExcerciseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Excercise, $Out>
    implements ExcerciseCopyWith<$R, Excercise, $Out> {
  _ExcerciseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Excercise> $mapper =
      ExcerciseMapper.ensureInitialized();
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
          String? force,
          String? level,
          String? mechanic,
          String? equipment,
          List<String>? primaryMuscles,
          List<String>? secondaryMuscles,
          List<String>? instructions,
          String? category,
          List<String>? images}) =>
      $apply(FieldCopyWithData({
        if (exerciseId != null) #exerciseId: exerciseId,
        if (name != null) #name: name,
        if (force != null) #force: force,
        if (level != null) #level: level,
        if (mechanic != null) #mechanic: mechanic,
        if (equipment != null) #equipment: equipment,
        if (primaryMuscles != null) #primaryMuscles: primaryMuscles,
        if (secondaryMuscles != null) #secondaryMuscles: secondaryMuscles,
        if (instructions != null) #instructions: instructions,
        if (category != null) #category: category,
        if (images != null) #images: images
      }));
  @override
  Excercise $make(CopyWithData data) => Excercise(
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
  ExcerciseCopyWith<$R2, Excercise, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ExcerciseCopyWithImpl($value, $cast, t);
}
