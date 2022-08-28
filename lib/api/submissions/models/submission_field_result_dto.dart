import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

import 'models.dart';

part 'submission_field_result_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class SubmissionFieldResultDto {
  SubmissionFieldResultDto({
    required this.fieldId,
    required this.fieldType,
    this.stringValue,
    this.intValue,
    this.photoValue,
  });

  @JsonKey(name: 'fieldId')
  final String fieldId;
  @JsonKey(name: 'fieldType')
  final SubmissionFieldType fieldType;

  @JsonKey(name: 'stringValue')
  final String? stringValue;
  @JsonKey(name: 'intValue')
  final int? intValue;
  @JsonKey(name: 'photoValue')
  final String? photoValue;
  
  static SubmissionFieldResultDto fromJson(Map<String, dynamic> json) =>
    _$SubmissionFieldResultDtoFromJson(json);

  Map<String, dynamic> toJson() =>
    _$SubmissionFieldResultDtoToJson(this);
}
