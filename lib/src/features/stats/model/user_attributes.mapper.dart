// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_attributes.dart';

class UserAttributeMapper extends ClassMapperBase<UserAttribute> {
  UserAttributeMapper._();

  static UserAttributeMapper? _instance;
  static UserAttributeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserAttributeMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UserAttribute';

  static String _$user_id(UserAttribute v) => v.user_id;
  static const Field<UserAttribute, String> _f$user_id =
      Field('user_id', _$user_id);
  static DateTime _$updated_at(UserAttribute v) => v.updated_at;
  static const Field<UserAttribute, DateTime> _f$updated_at =
      Field('updated_at', _$updated_at);
  static int _$agility(UserAttribute v) => v.agility;
  static const Field<UserAttribute, int> _f$agility =
      Field('agility', _$agility);
  static int _$endurance(UserAttribute v) => v.endurance;
  static const Field<UserAttribute, int> _f$endurance =
      Field('endurance', _$endurance);
  static int _$strength(UserAttribute v) => v.strength;
  static const Field<UserAttribute, int> _f$strength =
      Field('strength', _$strength);
  static int _$stamina(UserAttribute v) => v.stamina;
  static const Field<UserAttribute, int> _f$stamina =
      Field('stamina', _$stamina);

  @override
  final MappableFields<UserAttribute> fields = const {
    #user_id: _f$user_id,
    #updated_at: _f$updated_at,
    #agility: _f$agility,
    #endurance: _f$endurance,
    #strength: _f$strength,
    #stamina: _f$stamina,
  };

  static UserAttribute _instantiate(DecodingData data) {
    return UserAttribute(
        data.dec(_f$user_id),
        data.dec(_f$updated_at),
        data.dec(_f$agility),
        data.dec(_f$endurance),
        data.dec(_f$strength),
        data.dec(_f$stamina));
  }

  @override
  final Function instantiate = _instantiate;

  static UserAttribute fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserAttribute>(map);
  }

  static UserAttribute fromJson(String json) {
    return ensureInitialized().decodeJson<UserAttribute>(json);
  }
}

mixin UserAttributeMappable {
  String toJson() {
    return UserAttributeMapper.ensureInitialized()
        .encodeJson<UserAttribute>(this as UserAttribute);
  }

  Map<String, dynamic> toMap() {
    return UserAttributeMapper.ensureInitialized()
        .encodeMap<UserAttribute>(this as UserAttribute);
  }

  UserAttributeCopyWith<UserAttribute, UserAttribute, UserAttribute>
      get copyWith => _UserAttributeCopyWithImpl(
          this as UserAttribute, $identity, $identity);
  @override
  String toString() {
    return UserAttributeMapper.ensureInitialized()
        .stringifyValue(this as UserAttribute);
  }

  @override
  bool operator ==(Object other) {
    return UserAttributeMapper.ensureInitialized()
        .equalsValue(this as UserAttribute, other);
  }

  @override
  int get hashCode {
    return UserAttributeMapper.ensureInitialized()
        .hashValue(this as UserAttribute);
  }
}

extension UserAttributeValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserAttribute, $Out> {
  UserAttributeCopyWith<$R, UserAttribute, $Out> get $asUserAttribute =>
      $base.as((v, t, t2) => _UserAttributeCopyWithImpl(v, t, t2));
}

abstract class UserAttributeCopyWith<$R, $In extends UserAttribute, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? user_id,
      DateTime? updated_at,
      int? agility,
      int? endurance,
      int? strength,
      int? stamina});
  UserAttributeCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserAttributeCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserAttribute, $Out>
    implements UserAttributeCopyWith<$R, UserAttribute, $Out> {
  _UserAttributeCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserAttribute> $mapper =
      UserAttributeMapper.ensureInitialized();
  @override
  $R call(
          {String? user_id,
          DateTime? updated_at,
          int? agility,
          int? endurance,
          int? strength,
          int? stamina}) =>
      $apply(FieldCopyWithData({
        if (user_id != null) #user_id: user_id,
        if (updated_at != null) #updated_at: updated_at,
        if (agility != null) #agility: agility,
        if (endurance != null) #endurance: endurance,
        if (strength != null) #strength: strength,
        if (stamina != null) #stamina: stamina
      }));
  @override
  UserAttribute $make(CopyWithData data) => UserAttribute(
      data.get(#user_id, or: $value.user_id),
      data.get(#updated_at, or: $value.updated_at),
      data.get(#agility, or: $value.agility),
      data.get(#endurance, or: $value.endurance),
      data.get(#strength, or: $value.strength),
      data.get(#stamina, or: $value.stamina));

  @override
  UserAttributeCopyWith<$R2, UserAttribute, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _UserAttributeCopyWithImpl($value, $cast, t);
}
