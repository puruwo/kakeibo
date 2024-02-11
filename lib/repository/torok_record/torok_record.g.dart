// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'torok_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TorokRecordImpl _$$TorokRecordImplFromJson(Map<String, dynamic> json) =>
    _$TorokRecordImpl(
      id: json['id'] as int? ?? 0,
      year: json['year'] as int,
      month: json['month'] as int,
      day: json['day'] as int,
      price: json['price'] as int? ?? 0,
      category: json['category'] as int? ?? 0,
      memo: json['memo'] as String? ?? '',
    );

Map<String, dynamic> _$$TorokRecordImplToJson(_$TorokRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'year': instance.year,
      'month': instance.month,
      'day': instance.day,
      'price': instance.price,
      'category': instance.category,
      'memo': instance.memo,
    };
