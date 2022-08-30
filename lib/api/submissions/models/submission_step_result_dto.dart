import 'package:json_annotation/json_annotation.dart';

import 'models.dart';

part 'submission_step_result_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class SubmissionStepResultDto {
  SubmissionStepResultDto({
    required this.stepId,
    required this.results,
    required this.startedUtc,
  });

  @JsonKey(name: 'stepId')
  final String stepId;
  @JsonKey(name: 'fieldType')
  final List<SubmissionFieldResultDto> results;
  @JsonKey(name: 'startedUtc')
  final DateTime startedUtc;

  static SubmissionStepResultDto fromJson(Map<String, dynamic> json) =>
    _$SubmissionStepResultDtoFromJson(json);

  Map<String, dynamic> toJson() =>
    _$SubmissionStepResultDtoToJson(this);
}
