// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tbl002_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TBL002RecordImpl _$$TBL002RecordImplFromJson(Map<String, dynamic> json) =>
    _$TBL002RecordImpl(
      id: json['id'] as int? ?? 0,
      year: json['year'] as int,
      month: json['month'] as int,
      day: json['day'] as int,
      price: json['price'] as int? ?? 0,
      category: json['category'] as int? ?? 0,
      memo: json['memo'] as String? ?? '',
    );

Map<String, dynamic> _$$TBL002RecordImplToJson(_$TBL002RecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'year': instance.year,
      'month': instance.month,
      'day': instance.day,
      'price': instance.price,
      'category': instance.category,
      'memo': instance.memo,
    };
