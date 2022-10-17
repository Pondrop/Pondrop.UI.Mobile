// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_field_result_value_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmissionFieldResultValueItemDto _$SubmissionFieldResultValueItemDtoFromJson(
        Map<String, dynamic> json) =>
    SubmissionFieldResultValueItemDto(
      itemId: json['itemId'] as String,
      itemName: json['itemName'] as String,
      itemType: $enumDecode(_$SubmissionFieldItemTypeEnumMap, json['itemType']),
      extras: (json['extras'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
    );

Map<String, dynamic> _$SubmissionFieldResultValueItemDtoToJson(
        SubmissionFieldResultValueItemDto instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemType': _$SubmissionFieldItemTypeEnumMap[instance.itemType]!,
      'extras': instance.extras,
    };

const _$SubmissionFieldItemTypeEnumMap = {
  SubmissionFieldItemType.unknown: 'unknown',
  SubmissionFieldItemType.products: 'products',
  SubmissionFieldItemType.categories: 'categories',
};
