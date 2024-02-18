// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tbl003_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TBL003RecordImpl _$$TBL003RecordImplFromJson(Map<String, dynamic> json) =>
    _$TBL003RecordImpl(
      id: json['_id'] as int,
      smallCategoryKey: json['small_category_key'] as int,
      bigCategoryKey: json['big_category_key'] as int,
      categoryName: json['category_name'] as String,
      defaultDisplayed: json['default_displayed'] as int,
    );

Map<String, dynamic> _$$TBL003RecordImplToJson(_$TBL003RecordImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'small_category_key': instance.smallCategoryKey,
      'big_category_key': instance.bigCategoryKey,
      'category_name': instance.categoryName,
      'default_displayed': instance.defaultDisplayed,
    };
