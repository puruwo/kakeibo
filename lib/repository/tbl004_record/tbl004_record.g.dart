// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tbl004_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TBL004RecordImpl _$$TBL004RecordImplFromJson(Map<String, dynamic> json) =>
    _$TBL004RecordImpl(
      id: json['_id'] as int,
      colorCode: json['color_code'] as String,
      bigCategoryName: json['big_category_name'] as String,
      resourcePath: json['resource_path'] as String,
      displayOrder: json['display_order'] as int,
      isDisplayed: json['is_displayed'] as int,
    );

Map<String, dynamic> _$$TBL004RecordImplToJson(_$TBL004RecordImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'color_code': instance.colorCode,
      'big_category_name': instance.bigCategoryName,
      'resource_path': instance.resourcePath,
      'display_order': instance.displayOrder,
      'is_displayed': instance.isDisplayed,
    };
