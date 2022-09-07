// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_field_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmissionFieldResultDto _$SubmissionFieldResultDtoFromJson(
        Map<String, dynamic> json) =>
    SubmissionFieldResultDto(
      templateFieldId: json['templateFieldId'] as String,
      stringValue: json['stringValue'] as String?,
      intValue: json['intValue'] as int?,
      doubleValue: (json['doubleValue'] as num?)?.toDouble(),
    )
      ..photoFileName = json['photoFileName'] as String?
      ..photoDataBase64 = json['photoDataBase64'] as String?;

Map<String, dynamic> _$SubmissionFieldResultDtoToJson(
        SubmissionFieldResultDto instance) =>
    <String, dynamic>{
      'templateFieldId': instance.templateFieldId,
      'stringValue': instance.stringValue,
      'intValue': instance.intValue,
      'doubleValue': instance.doubleValue,
      'photoFileName': instance.photoFileName,
      'photoDataBase64': instance.photoDataBase64,
    };
