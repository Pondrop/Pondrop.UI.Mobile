import 'package:json_annotation/json_annotation.dart';

import 'models.dart';

part 'submission_template_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class SubmissionTemplateDto {
  SubmissionTemplateDto({
    required this.id,
    required this.title,
    required this.description,
    required this.iconCodePoint,
    required this.iconFontFamily,
    required this.manualEnabled,
    required this.steps,
  });

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'iconCodePoint')
  final int iconCodePoint;
  @JsonKey(name: 'iconFontFamily')
  final String iconFontFamily;

  @JsonKey(name: 'isForManualSubmissions')
  final bool manualEnabled;

  @JsonKey(name: 'steps')
  final List<SubmissionTemplateStepDto> steps;

  static SubmissionTemplateDto fromJson(Map<String, dynamic> json) =>
      _$SubmissionTemplateDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SubmissionTemplateDtoToJson(this);
}
