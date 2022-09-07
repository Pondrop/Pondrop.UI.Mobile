import 'package:json_annotation/json_annotation.dart';

part 'submission_field_result_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class SubmissionFieldResultDto {
  SubmissionFieldResultDto({
    required this.templateFieldId,
    this.stringValue,
    this.intValue,
    this.doubleValue,
    this.photoPathValue,
  });

  @JsonKey(name: 'templateFieldId')
  final String templateFieldId;

  @JsonKey(name: 'stringValue')
  final String? stringValue;
  @JsonKey(name: 'intValue')
  final int? intValue;
  @JsonKey(name: 'doubleValue')
  final double? doubleValue;

  @JsonKey(ignore: true)
  final String? photoPathValue;
  @JsonKey(name: 'photoFileName')
  String? photoFileName;
  @JsonKey(name: 'photoDataBase64')
  String? photoDataBase64;
  
  static SubmissionFieldResultDto fromJson(Map<String, dynamic> json) =>
    _$SubmissionFieldResultDtoFromJson(json);

  Map<String, dynamic> toJson() =>
    _$SubmissionFieldResultDtoToJson(this);
}
