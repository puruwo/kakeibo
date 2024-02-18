// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tbl003_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TBL003Record _$TBL003RecordFromJson(Map<String, dynamic> json) {
  return _TBL003Record.fromJson(json);
}

/// @nodoc
mixin _$TBL003Record {
  int get id => throw _privateConstructorUsedError;
  int get smallCategoryKey => throw _privateConstructorUsedError;
  int get bigCategoryKey => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;
  int get defaultDisplayed => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TBL003RecordCopyWith<TBL003Record> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TBL003RecordCopyWith<$Res> {
  factory $TBL003RecordCopyWith(
          TBL003Record value, $Res Function(TBL003Record) then) =
      _$TBL003RecordCopyWithImpl<$Res, TBL003Record>;
  @useResult
  $Res call(
      {int id,
      int smallCategoryKey,
      int bigCategoryKey,
      String categoryName,
      int defaultDisplayed});
}

/// @nodoc
class _$TBL003RecordCopyWithImpl<$Res, $Val extends TBL003Record>
    implements $TBL003RecordCopyWith<$Res> {
  _$TBL003RecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? smallCategoryKey = null,
    Object? bigCategoryKey = null,
    Object? categoryName = null,
    Object? defaultDisplayed = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      smallCategoryKey: null == smallCategoryKey
          ? _value.smallCategoryKey
          : smallCategoryKey // ignore: cast_nullable_to_non_nullable
              as int,
      bigCategoryKey: null == bigCategoryKey
          ? _value.bigCategoryKey
          : bigCategoryKey // ignore: cast_nullable_to_non_nullable
              as int,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      defaultDisplayed: null == defaultDisplayed
          ? _value.defaultDisplayed
          : defaultDisplayed // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TBL003RecordImplCopyWith<$Res>
    implements $TBL003RecordCopyWith<$Res> {
  factory _$$TBL003RecordImplCopyWith(
          _$TBL003RecordImpl value, $Res Function(_$TBL003RecordImpl) then) =
      __$$TBL003RecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int smallCategoryKey,
      int bigCategoryKey,
      String categoryName,
      int defaultDisplayed});
}

/// @nodoc
class __$$TBL003RecordImplCopyWithImpl<$Res>
    extends _$TBL003RecordCopyWithImpl<$Res, _$TBL003RecordImpl>
    implements _$$TBL003RecordImplCopyWith<$Res> {
  __$$TBL003RecordImplCopyWithImpl(
      _$TBL003RecordImpl _value, $Res Function(_$TBL003RecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? smallCategoryKey = null,
    Object? bigCategoryKey = null,
    Object? categoryName = null,
    Object? defaultDisplayed = null,
  }) {
    return _then(_$TBL003RecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      smallCategoryKey: null == smallCategoryKey
          ? _value.smallCategoryKey
          : smallCategoryKey // ignore: cast_nullable_to_non_nullable
              as int,
      bigCategoryKey: null == bigCategoryKey
          ? _value.bigCategoryKey
          : bigCategoryKey // ignore: cast_nullable_to_non_nullable
              as int,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      defaultDisplayed: null == defaultDisplayed
          ? _value.defaultDisplayed
          : defaultDisplayed // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TBL003RecordImpl extends _TBL003Record {
  const _$TBL003RecordImpl(
      {required this.id,
      required this.smallCategoryKey,
      required this.bigCategoryKey,
      required this.categoryName,
      required this.defaultDisplayed})
      : super._();

  factory _$TBL003RecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$TBL003RecordImplFromJson(json);

  @override
  final int id;
  @override
  final int smallCategoryKey;
  @override
  final int bigCategoryKey;
  @override
  final String categoryName;
  @override
  final int defaultDisplayed;

  @override
  String toString() {
    return 'TBL003Record(id: $id, smallCategoryKey: $smallCategoryKey, bigCategoryKey: $bigCategoryKey, categoryName: $categoryName, defaultDisplayed: $defaultDisplayed)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TBL003RecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.smallCategoryKey, smallCategoryKey) ||
                other.smallCategoryKey == smallCategoryKey) &&
            (identical(other.bigCategoryKey, bigCategoryKey) ||
                other.bigCategoryKey == bigCategoryKey) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.defaultDisplayed, defaultDisplayed) ||
                other.defaultDisplayed == defaultDisplayed));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, smallCategoryKey,
      bigCategoryKey, categoryName, defaultDisplayed);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TBL003RecordImplCopyWith<_$TBL003RecordImpl> get copyWith =>
      __$$TBL003RecordImplCopyWithImpl<_$TBL003RecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TBL003RecordImplToJson(
      this,
    );
  }
}

abstract class _TBL003Record extends TBL003Record {
  const factory _TBL003Record(
      {required final int id,
      required final int smallCategoryKey,
      required final int bigCategoryKey,
      required final String categoryName,
      required final int defaultDisplayed}) = _$TBL003RecordImpl;
  const _TBL003Record._() : super._();

  factory _TBL003Record.fromJson(Map<String, dynamic> json) =
      _$TBL003RecordImpl.fromJson;

  @override
  int get id;
  @override
  int get smallCategoryKey;
  @override
  int get bigCategoryKey;
  @override
  String get categoryName;
  @override
  int get defaultDisplayed;
  @override
  @JsonKey(ignore: true)
  _$$TBL003RecordImplCopyWith<_$TBL003RecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
