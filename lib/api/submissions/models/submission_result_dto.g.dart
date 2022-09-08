// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmissionResultDto _$SubmissionResultDtoFromJson(Map<String, dynamic> json) =>
    SubmissionResultDto(
      submissionTemplateId: json['submissionTemplateId'] as String,
      storeVisitId: json['storeVisitId'] as String,
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
      'steps': instance.steps.map((e) => e.toJson()).toList(),
    };
