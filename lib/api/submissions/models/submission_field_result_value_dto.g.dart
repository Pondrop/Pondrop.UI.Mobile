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
    )
      ..photoFileName = json['photoFileName'] as String?
      ..photoDataBase64 = json['photoDataBase64'] as String?;

Map<String, dynamic> _$SubmissionFieldResultValueDtoToJson(
        SubmissionFieldResultValueDto instance) =>
    <String, dynamic>{
      'stringValue': instance.stringValue,
      'intValue': instance.intValue,
      'doubleValue': instance.doubleValue,
      'photoFileName': instance.photoFileName,
      'photoDataBase64': instance.photoDataBase64,
    };
