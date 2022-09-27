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
      itemValue: json['itemValue'] == null
          ? null
          : SubmissionFieldResultValueItemDto.fromJson(
              json['itemValue'] as Map<String, dynamic>),
    )
      ..photoFileName = json['photoFileName'] as String?
      ..photoBase64 = json['photoBase64'] as String?;

Map<String, dynamic> _$SubmissionFieldResultValueDtoToJson(
        SubmissionFieldResultValueDto instance) =>
    <String, dynamic>{
      'stringValue': instance.stringValue,
      'intValue': instance.intValue,
      'doubleValue': instance.doubleValue,
      'itemValue': instance.itemValue?.toJson(),
      'photoFileName': instance.photoFileName,
      'photoBase64': instance.photoBase64,
    };
