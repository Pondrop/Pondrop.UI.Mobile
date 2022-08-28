// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_field_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmissionFieldResultDto _$SubmissionFieldResultDtoFromJson(
        Map<String, dynamic> json) =>
    SubmissionFieldResultDto(
      fieldId: json['fieldId'] as String,
      fieldType: $enumDecode(_$SubmissionFieldTypeEnumMap, json['fieldType']),
      stringValue: json['stringValue'] as String?,
      intValue: json['intValue'] as int?,
      photoValue: json['photoValue'] as String?,
    );

Map<String, dynamic> _$SubmissionFieldResultDtoToJson(
        SubmissionFieldResultDto instance) =>
    <String, dynamic>{
      'fieldId': instance.fieldId,
      'fieldType': _$SubmissionFieldTypeEnumMap[instance.fieldType]!,
      'stringValue': instance.stringValue,
      'intValue': instance.intValue,
      'photoValue': instance.photoValue,
    };

const _$SubmissionFieldTypeEnumMap = {
  SubmissionFieldType.photo: 'photo',
  SubmissionFieldType.text: 'text',
  SubmissionFieldType.multilineText: 'multilineText',
  SubmissionFieldType.integer: 'integer',
  SubmissionFieldType.picker: 'picker',
};
