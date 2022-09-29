import 'package:json_annotation/json_annotation.dart';

import 'submission_template_field_dto.dart';

part 'submission_field_result_value_item_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class SubmissionFieldResultValueItemDto {
  SubmissionFieldResultValueItemDto({
    required this.itemId,
    required this.itemName,
    required this.itemType,
  });

  @JsonKey(name: 'itemId')
  final String itemId;
  @JsonKey(name: 'itemName')
  final String itemName;
  @JsonKey(name: 'itemType')
  final SubmissionFieldItemType itemType;
  
  static SubmissionFieldResultValueItemDto fromJson(Map<String, dynamic> json) =>
    _$SubmissionFieldResultValueItemDtoFromJson(json);

  Map<String, dynamic> toJson() =>
    _$SubmissionFieldResultValueItemDtoToJson(this);
}