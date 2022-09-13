import 'package:json_annotation/json_annotation.dart';

import 'models.dart';

part 'submission_result_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class SubmissionResultDto {
  SubmissionResultDto({
    required this.submissionTemplateId,
    required this.storeVisitId,
    this.latitude = 0,
    this.longitude = 0,
    required this.steps,    
  });

  @JsonKey(name: 'submissionTemplateId')
  final String submissionTemplateId;

  @JsonKey(name: 'storeVisitId')
  final String storeVisitId;

  @JsonKey(name: 'latitude')
  final double latitude;
  @JsonKey(name: 'longitude')
  final double longitude;

  @JsonKey(name: 'steps')
  final List<SubmissionStepResultDto> steps;

  static SubmissionResultDto fromJson(Map<String, dynamic> json) =>
    _$SubmissionResultDtoFromJson(json);

  Map<String, dynamic> toJson() =>
    _$SubmissionResultDtoToJson(this);
}
