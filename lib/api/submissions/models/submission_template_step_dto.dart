import 'package:json_annotation/json_annotation.dart';

import 'models.dart';

part 'submission_template_step_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class SubmissionTemplateStepDto {
  SubmissionTemplateStepDto({
    required this.id,
    required this.title,
    required this.instructions,
    required this.instructionsContinueButton,
    this.instructionsSkipButton = '',
    required this.instructionsIconCodePoint,
    required this.instructionsIconFontFamily,
    required this.fields,
  });

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'instructions')
  final String instructions;
  @JsonKey(name: 'instructionsContinueButton')
  final String instructionsContinueButton;
  @JsonKey(name: 'instructionsSkipButton')
  final String instructionsSkipButton;
  @JsonKey(name: 'instructionsIconCodePoint')
  final int instructionsIconCodePoint;
  @JsonKey(name: 'instructionsIconFontFamily')
  final String instructionsIconFontFamily;

  @JsonKey(name: 'fields')
  final List<SubmissionTemplateFieldDto> fields;
  
  static SubmissionTemplateStepDto fromJson(Map<String, dynamic> json) =>
    _$SubmissionTemplateStepDtoFromJson(json);

  Map<String, dynamic> toJson() =>
    _$SubmissionTemplateStepDtoToJson(this);
}
