// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_field_result_value_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmissionFieldResultValueDto _$SubmissionFieldResultValueDtoFromJson(
        Map<String, dynamic> json) =>
    SubmissionFieldResultValueDto(
      stringValue: json['stringValue'] as String?,
      intValue: json['intValue'] as int?,
      doubleValue: (json['doubleValue'] as num?)?.toDouble(),
      itemId: json['selectedItemId'] as String?,
      itemName: json['selectedItemName'] as String?,
      itemType: $enumDecodeNullable(
          _$SubmissionFieldItemTypeEnumMap, json['SubmissionFieldSearchType']),
    )
      ..photoFileName = json['photoFileName'] as String?
      ..photoBase64 = json['photoBase64'] as String?;

Map<String, dynamic> _$SubmissionFieldResultValueDtoToJson(
        SubmissionFieldResultValueDto instance) =>
    <String, dynamic>{
      'stringValue': instance.stringValue,
      'intValue': instance.intValue,
      'doubleValue': instance.doubleValue,
      'selectedItemId': instance.itemId,
      'selectedItemName': instance.itemName,
      'SubmissionFieldSearchType':
          _$SubmissionFieldItemTypeEnumMap[instance.itemType],
      'photoFileName': instance.photoFileName,
      'photoBase64': instance.photoBase64,
    };

const _$SubmissionFieldItemTypeEnumMap = {
  SubmissionFieldItemType.products: 'products',
};
