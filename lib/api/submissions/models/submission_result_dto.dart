import 'package:json_annotation/json_annotation.dart';

import 'models.dart';

part 'submission_result_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class SubmissionResultDto {
  SubmissionResultDto({
    required this.submissionTemplateId,
    required this.storeVisitId,
    required this.steps,    
  });

  @JsonKey(name: 'submissionTemplateId')
  final String submissionTemplateId;

  @JsonKey(name: 'storeVisitId')
  final String storeVisitId;

  @JsonKey(name: 'steps')
  final List<SubmissionStepResultDto> steps;

  static SubmissionResultDto fromJson(Map<String, dynamic> json) =>
    _$SubmissionResultDtoFromJson(json);

  Map<String, dynamic> toJson() =>
    _$SubmissionResultDtoToJson(this);
}
