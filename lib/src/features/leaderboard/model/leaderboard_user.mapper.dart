// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'leaderboard_user.dart';

class LeaderboardUserMapper extends ClassMapperBase<LeaderboardUser> {
  LeaderboardUserMapper._();

  static LeaderboardUserMapper? _instance;
  static LeaderboardUserMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LeaderboardUserMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'LeaderboardUser';

  static String _$id(LeaderboardUser v) => v.id;
  static const Field<LeaderboardUser, String> _f$id = Field('id', _$id);
  static String _$username(LeaderboardUser v) => v.username;
  static const Field<LeaderboardUser, String> _f$username =
      Field('username', _$username);
  static int _$score(LeaderboardUser v) => v.score;
  static const Field<LeaderboardUser, int> _f$score = Field('score', _$score);

  @override
  final MappableFields<LeaderboardUser> fields = const {
    #id: _f$id,
    #username: _f$username,
    #score: _f$score,
  };

  static LeaderboardUser _instantiate(DecodingData data) {
    return LeaderboardUser(
        id: data.dec(_f$id),
        username: data.dec(_f$username),
        score: data.dec(_f$score));
  }

  @override
  final Function instantiate = _instantiate;

  static LeaderboardUser fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LeaderboardUser>(map);
  }

  static LeaderboardUser fromJson(String json) {
    return ensureInitialized().decodeJson<LeaderboardUser>(json);
  }
}

mixin LeaderboardUserMappable {
  String toJson() {
    return LeaderboardUserMapper.ensureInitialized()
        .encodeJson<LeaderboardUser>(this as LeaderboardUser);
  }

  Map<String, dynamic> toMap() {
    return LeaderboardUserMapper.ensureInitialized()
        .encodeMap<LeaderboardUser>(this as LeaderboardUser);
  }

  LeaderboardUserCopyWith<LeaderboardUser, LeaderboardUser, LeaderboardUser>
      get copyWith => _LeaderboardUserCopyWithImpl(
          this as LeaderboardUser, $identity, $identity);
  @override
  String toString() {
    return LeaderboardUserMapper.ensureInitialized()
        .stringifyValue(this as LeaderboardUser);
  }

  @override
  bool operator ==(Object other) {
    return LeaderboardUserMapper.ensureInitialized()
        .equalsValue(this as LeaderboardUser, other);
  }

  @override
  int get hashCode {
    return LeaderboardUserMapper.ensureInitialized()
        .hashValue(this as LeaderboardUser);
  }
}

extension LeaderboardUserValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LeaderboardUser, $Out> {
  LeaderboardUserCopyWith<$R, LeaderboardUser, $Out> get $asLeaderboardUser =>
      $base.as((v, t, t2) => _LeaderboardUserCopyWithImpl(v, t, t2));
}

abstract class LeaderboardUserCopyWith<$R, $In extends LeaderboardUser, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? username, int? score});
  LeaderboardUserCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _LeaderboardUserCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LeaderboardUser, $Out>
    implements LeaderboardUserCopyWith<$R, LeaderboardUser, $Out> {
  _LeaderboardUserCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LeaderboardUser> $mapper =
      LeaderboardUserMapper.ensureInitialized();
  @override
  $R call({String? id, String? username, int? score}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (username != null) #username: username,
        if (score != null) #score: score
      }));
  @override
  LeaderboardUser $make(CopyWithData data) => LeaderboardUser(
      id: data.get(#id, or: $value.id),
      username: data.get(#username, or: $value.username),
      score: data.get(#score, or: $value.score));

  @override
  LeaderboardUserCopyWith<$R2, LeaderboardUser, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _LeaderboardUserCopyWithImpl($value, $cast, t);
}
