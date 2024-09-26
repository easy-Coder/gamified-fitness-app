// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'overview_model.dart';

class OverviewModelMapper extends ClassMapperBase<OverviewModel> {
  OverviewModelMapper._();

  static OverviewModelMapper? _instance;
  static OverviewModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = OverviewModelMapper._());
      UserAttributeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'OverviewModel';

  static User _$user(OverviewModel v) => v.user;
  static const Field<OverviewModel, User> _f$user = Field('user', _$user);
  static UserAttribute _$userAttribute(OverviewModel v) => v.userAttribute;
  static const Field<OverviewModel, UserAttribute> _f$userAttribute =
      Field('userAttribute', _$userAttribute);

  @override
  final MappableFields<OverviewModel> fields = const {
    #user: _f$user,
    #userAttribute: _f$userAttribute,
  };

  static OverviewModel _instantiate(DecodingData data) {
    return OverviewModel(
        user: data.dec(_f$user), userAttribute: data.dec(_f$userAttribute));
  }

  @override
  final Function instantiate = _instantiate;

  static OverviewModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<OverviewModel>(map);
  }

  static OverviewModel fromJson(String json) {
    return ensureInitialized().decodeJson<OverviewModel>(json);
  }
}

mixin OverviewModelMappable {
  String toJson() {
    return OverviewModelMapper.ensureInitialized()
        .encodeJson<OverviewModel>(this as OverviewModel);
  }

  Map<String, dynamic> toMap() {
    return OverviewModelMapper.ensureInitialized()
        .encodeMap<OverviewModel>(this as OverviewModel);
  }

  OverviewModelCopyWith<OverviewModel, OverviewModel, OverviewModel>
      get copyWith => _OverviewModelCopyWithImpl(
          this as OverviewModel, $identity, $identity);
  @override
  String toString() {
    return OverviewModelMapper.ensureInitialized()
        .stringifyValue(this as OverviewModel);
  }

  @override
  bool operator ==(Object other) {
    return OverviewModelMapper.ensureInitialized()
        .equalsValue(this as OverviewModel, other);
  }

  @override
  int get hashCode {
    return OverviewModelMapper.ensureInitialized()
        .hashValue(this as OverviewModel);
  }
}

extension OverviewModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, OverviewModel, $Out> {
  OverviewModelCopyWith<$R, OverviewModel, $Out> get $asOverviewModel =>
      $base.as((v, t, t2) => _OverviewModelCopyWithImpl(v, t, t2));
}

abstract class OverviewModelCopyWith<$R, $In extends OverviewModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  UserAttributeCopyWith<$R, UserAttribute, UserAttribute> get userAttribute;
  $R call({User? user, UserAttribute? userAttribute});
  OverviewModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _OverviewModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, OverviewModel, $Out>
    implements OverviewModelCopyWith<$R, OverviewModel, $Out> {
  _OverviewModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<OverviewModel> $mapper =
      OverviewModelMapper.ensureInitialized();
  @override
  UserAttributeCopyWith<$R, UserAttribute, UserAttribute> get userAttribute =>
      $value.userAttribute.copyWith.$chain((v) => call(userAttribute: v));
  @override
  $R call({User? user, UserAttribute? userAttribute}) =>
      $apply(FieldCopyWithData({
        if (user != null) #user: user,
        if (userAttribute != null) #userAttribute: userAttribute
      }));
  @override
  OverviewModel $make(CopyWithData data) => OverviewModel(
      user: data.get(#user, or: $value.user),
      userAttribute: data.get(#userAttribute, or: $value.userAttribute));

  @override
  OverviewModelCopyWith<$R2, OverviewModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _OverviewModelCopyWithImpl($value, $cast, t);
}
