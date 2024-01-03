// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poll_vote_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PollVoteData _$PollVoteDataFromJson(Map<String, dynamic> json) {
  return _PollVoteData.fromJson(json);
}

/// @nodoc
mixin _$PollVoteData {
  int get pollId => throw _privateConstructorUsedError;
  String get deviceToken => throw _privateConstructorUsedError;
  List<int> get join => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PollVoteDataCopyWith<PollVoteData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PollVoteDataCopyWith<$Res> {
  factory $PollVoteDataCopyWith(
          PollVoteData value, $Res Function(PollVoteData) then) =
      _$PollVoteDataCopyWithImpl<$Res, PollVoteData>;
  @useResult
  $Res call({int pollId, String deviceToken, List<int> join});
}

/// @nodoc
class _$PollVoteDataCopyWithImpl<$Res, $Val extends PollVoteData>
    implements $PollVoteDataCopyWith<$Res> {
  _$PollVoteDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pollId = null,
    Object? deviceToken = null,
    Object? join = null,
  }) {
    return _then(_value.copyWith(
      pollId: null == pollId
          ? _value.pollId
          : pollId // ignore: cast_nullable_to_non_nullable
              as int,
      deviceToken: null == deviceToken
          ? _value.deviceToken
          : deviceToken // ignore: cast_nullable_to_non_nullable
              as String,
      join: null == join
          ? _value.join
          : join // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PollVoteDataCopyWith<$Res>
    implements $PollVoteDataCopyWith<$Res> {
  factory _$$_PollVoteDataCopyWith(
          _$_PollVoteData value, $Res Function(_$_PollVoteData) then) =
      __$$_PollVoteDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int pollId, String deviceToken, List<int> join});
}

/// @nodoc
class __$$_PollVoteDataCopyWithImpl<$Res>
    extends _$PollVoteDataCopyWithImpl<$Res, _$_PollVoteData>
    implements _$$_PollVoteDataCopyWith<$Res> {
  __$$_PollVoteDataCopyWithImpl(
      _$_PollVoteData _value, $Res Function(_$_PollVoteData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pollId = null,
    Object? deviceToken = null,
    Object? join = null,
  }) {
    return _then(_$_PollVoteData(
      pollId: null == pollId
          ? _value.pollId
          : pollId // ignore: cast_nullable_to_non_nullable
              as int,
      deviceToken: null == deviceToken
          ? _value.deviceToken
          : deviceToken // ignore: cast_nullable_to_non_nullable
              as String,
      join: null == join
          ? _value._join
          : join // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PollVoteData implements _PollVoteData {
  _$_PollVoteData(
      {required this.pollId,
      required this.deviceToken,
      required final List<int> join})
      : _join = join;

  factory _$_PollVoteData.fromJson(Map<String, dynamic> json) =>
      _$$_PollVoteDataFromJson(json);

  @override
  final int pollId;
  @override
  final String deviceToken;
  final List<int> _join;
  @override
  List<int> get join {
    if (_join is EqualUnmodifiableListView) return _join;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_join);
  }

  @override
  String toString() {
    return 'PollVoteData(pollId: $pollId, deviceToken: $deviceToken, join: $join)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PollVoteData &&
            (identical(other.pollId, pollId) || other.pollId == pollId) &&
            (identical(other.deviceToken, deviceToken) ||
                other.deviceToken == deviceToken) &&
            const DeepCollectionEquality().equals(other._join, _join));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, pollId, deviceToken,
      const DeepCollectionEquality().hash(_join));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PollVoteDataCopyWith<_$_PollVoteData> get copyWith =>
      __$$_PollVoteDataCopyWithImpl<_$_PollVoteData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PollVoteDataToJson(
      this,
    );
  }
}

abstract class _PollVoteData implements PollVoteData {
  factory _PollVoteData(
      {required final int pollId,
      required final String deviceToken,
      required final List<int> join}) = _$_PollVoteData;

  factory _PollVoteData.fromJson(Map<String, dynamic> json) =
      _$_PollVoteData.fromJson;

  @override
  int get pollId;
  @override
  String get deviceToken;
  @override
  List<int> get join;
  @override
  @JsonKey(ignore: true)
  _$$_PollVoteDataCopyWith<_$_PollVoteData> get copyWith =>
      throw _privateConstructorUsedError;
}
