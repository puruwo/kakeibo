// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tbl003_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TBL003RecordImpl _$$TBL003RecordImplFromJson(Map<String, dynamic> json) =>
    _$TBL003RecordImpl(
      id: json['id'] as int,
      smallCategoryKey: json['smallCategoryKey'] as int,
      bigCategoryKey: json['bigCategoryKey'] as int,
      categoryName: json['categoryName'] as String,
      defaultDisplayed: json['defaultDisplayed'] as int,
    );

Map<String, dynamic> _$$TBL003RecordImplToJson(_$TBL003RecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'smallCategoryKey': instance.smallCategoryKey,
      'bigCategoryKey': instance.bigCategoryKey,
      'categoryName': instance.categoryName,
      'defaultDisplayed': instance.defaultDisplayed,
    };
