// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_template_field_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmissionTemplateFieldDto _$SubmissionTemplateFieldDtoFromJson(
        Map<String, dynamic> json) =>
    SubmissionTemplateFieldDto(
      id: json['id'] as String,
      label: json['label'] as String,
      mandatory: json['mandatory'] as bool,
      fieldType: $enumDecode(_$SubmissionFieldTypeEnumMap, json['fieldType']),
      maxValue: json['maxValue'] as int?,
      pickerValues: (json['pickerValues'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$SubmissionTemplateFieldDtoToJson(
        SubmissionTemplateFieldDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'mandatory': instance.mandatory,
      'fieldType': _$SubmissionFieldTypeEnumMap[instance.fieldType]!,
      'maxValue': instance.maxValue,
      'pickerValues': instance.pickerValues,
    };

const _$SubmissionFieldTypeEnumMap = {
  SubmissionFieldType.photo: 'photo',
  SubmissionFieldType.text: 'text',
  SubmissionFieldType.multilineText: 'multilineText',
  SubmissionFieldType.integer: 'integer',
  SubmissionFieldType.currency: 'currency',
  SubmissionFieldType.picker: 'picker',
};