// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_template_step_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmissionTemplateStepDto _$SubmissionTemplateStepDtoFromJson(
        Map<String, dynamic> json) =>
    SubmissionTemplateStepDto(
      id: json['id'] as String,
      title: json['title'] as String,
      instructions: json['instructions'] as String,
      instructionsContinueButton: json['instructionsContinueButton'] as String,
      instructionsSkipButton: json['instructionsSkipButton'] as String? ?? '',
      instructionsIconCodePoint: json['instructionsIconCodePoint'] as int,
      instructionsIconFontFamily: json['instructionsIconFontFamily'] as String,
      fields: (json['fields'] as List<dynamic>)
          .map((e) =>
              SubmissionTemplateFieldDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubmissionTemplateStepDtoToJson(
        SubmissionTemplateStepDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'instructions': instance.instructions,
      'instructionsContinueButton': instance.instructionsContinueButton,
      'instructionsSkipButton': instance.instructionsSkipButton,
      'instructionsIconCodePoint': instance.instructionsIconCodePoint,
      'instructionsIconFontFamily': instance.instructionsIconFontFamily,
      'fields': instance.fields.map((e) => e.toJson()).toList(),
    };
