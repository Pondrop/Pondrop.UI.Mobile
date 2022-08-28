// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_step_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmissionStepResultDto _$SubmissionStepResultDtoFromJson(
        Map<String, dynamic> json) =>
    SubmissionStepResultDto(
      stepId: json['stepId'] as String,
      results: (json['fieldType'] as List<dynamic>)
          .map((e) =>
              SubmissionFieldResultDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      startedUtc: DateTime.parse(json['startedUtc'] as String),
    );

Map<String, dynamic> _$SubmissionStepResultDtoToJson(
        SubmissionStepResultDto instance) =>
    <String, dynamic>{
      'stepId': instance.stepId,
      'fieldType': instance.results.map((e) => e.toJson()).toList(),
      'startedUtc': instance.startedUtc.toIso8601String(),
    };
