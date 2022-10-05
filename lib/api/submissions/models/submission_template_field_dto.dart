import 'package:json_annotation/json_annotation.dart';

part 'submission_template_field_dto.g.dart';

enum SubmissionFieldType { unknown, photo, text, multilineText, integer, currency, picker, search, focus }
enum SubmissionFieldItemType { unknown, products, categories }

@JsonSerializable(explicitToJson: true)
class SubmissionTemplateFieldDto {
  SubmissionTemplateFieldDto({
    required this.id,
    required this.label,
    required this.mandatory,
    required this.fieldType,
    this.maxValue,
    this.defaultValue,
    this.pickerValues,
    this.itemType,
  });

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'label')
  final String label;
  @JsonKey(name: 'mandatory')
  final bool mandatory;
  @JsonKey(name: 'fieldType')
  final SubmissionFieldType fieldType;

  @JsonKey(name: 'maxValue')
  final int? maxValue;
  @JsonKey(name: 'defaultValue')
  final String? defaultValue;
  @JsonKey(name: 'pickerValues')
  final List<String>? pickerValues;
  @JsonKey(name: 'itemType')
  final SubmissionFieldItemType? itemType;
  
  static SubmissionTemplateFieldDto fromJson(Map<String, dynamic> json) =>
    _$SubmissionTemplateFieldDtoFromJson(json);

  Map<String, dynamic> toJson() =>
    _$SubmissionTemplateFieldDtoToJson(this);
}
