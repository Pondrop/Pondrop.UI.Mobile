// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmissionResultDto _$SubmissionResultDtoFromJson(Map<String, dynamic> json) =>
    SubmissionResultDto(
      submissionTemplateId: json['submissionTemplateId'] as String,
      storeVisitId: json['storeVisitId'] as String,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      steps: (json['steps'] as List<dynamic>)
          .map((e) =>
              SubmissionStepResultDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubmissionResultDtoToJson(
        SubmissionResultDto instance) =>
    <String, dynamic>{
      'submissionTemplateId': instance.submissionTemplateId,
      'storeVisitId': instance.storeVisitId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'steps': instance.steps.map((e) => e.toJson()).toList(),
    };
