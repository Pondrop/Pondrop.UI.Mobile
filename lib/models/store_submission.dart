import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:pondrop/api/submissions/models/models.dart';

extension SubmissionTemplateDtoMapping on SubmissionTemplateDto {
  StoreSubmission toStoreSubmission() {
    return StoreSubmission(
        templateId: id,
        title: title,
        description: description,
        steps: steps
            .map((step) => StoreSubmissionStep(
                  templateId: id,
                  stepId: step.id,
                  title: step.title,
                  instructions: step.instructions,
                  instructionsContinueButton: step.instructionsContinueButton,
                  instructionsSkipButton: step.instructionsSkipButton,
                  instructionsIconCodePoint: step.instructionsIconCodePoint,
                  instructionsIconFontFamily: step.instructionsIconFontFamily,
                  fields: step.fields
                      .map((field) => StoreSubmissionField(
                          templateId: id,
                          stepId: step.id,
                          fieldId: field.id,
                          label: field.label,
                          mandatory: field.mandatory,
                          fieldType: field.fieldType,
                          maxValue: field.maxValue,
                          pickerValues: field.pickerValues,
                          result: StoreSubmissionFieldResult()))
                      .toList(),
                ))
            .toList());
  }
}

class StoreSubmission extends Equatable {
  const StoreSubmission({
    required this.templateId,
    required this.title,
    required this.description,
    required this.steps,
  });

  final String templateId;
  final String title;
  final String description;

  final List<StoreSubmissionStep> steps;

  StoreSubmission copy() {
    return StoreSubmission(
        templateId: templateId,
        title: title,
        description: description,
        steps: steps.map((e) => e.copy()).toList());
  }

  @override
  List<Object?> get props => [templateId, title, description, steps];
}

class StoreSubmissionStep extends Equatable {
  const StoreSubmissionStep({
    required this.templateId,
    required this.stepId,
    required this.title,
    required this.instructions,
    required this.instructionsContinueButton,
    required this.instructionsSkipButton,
    required this.instructionsIconCodePoint,
    required this.instructionsIconFontFamily,
    required this.fields,
  });

  final String templateId;
  final String stepId;
  final String title;
  final String instructions;
  final String instructionsContinueButton;
  final String instructionsSkipButton;
  final int instructionsIconCodePoint;
  final String instructionsIconFontFamily;

  final List<StoreSubmissionField> fields;

  bool get isComplete => fields.every((e) => !e.mandatory || !e.result.isEmpty);

  StoreSubmissionStep copy() {
    return StoreSubmissionStep(
        templateId: templateId,
        stepId: stepId,
        title: title,
        instructions: instructions,
        instructionsContinueButton: instructionsContinueButton,
        instructionsSkipButton: instructionsSkipButton,
        instructionsIconCodePoint: instructionsIconCodePoint,
        instructionsIconFontFamily: instructionsIconFontFamily,
        fields: fields.map((e) => e.copy()).toList());
  }

  @override
  List<Object?> get props => [
        stepId,
        title,
        instructions,
        instructionsContinueButton,
        instructionsSkipButton,
        instructionsIconCodePoint,
        instructionsIconFontFamily,
        fields
      ];
}

class StoreSubmissionField extends Equatable {
  const StoreSubmissionField(
      {required this.templateId,
      required this.stepId,
      required this.fieldId,
      required this.label,
      required this.mandatory,
      required this.fieldType,
      this.maxValue,
      this.pickerValues,
      required this.result});

  final String templateId;
  final String stepId;
  final String fieldId;
  final String label;
  final bool mandatory;
  final SubmissionFieldType fieldType;

  final int? maxValue;
  final List<String>? pickerValues;

  final StoreSubmissionFieldResult result;

  String get resultString {
    switch (fieldType) {
      case SubmissionFieldType.photo:
        return result.photoPathValue ?? '';
      case SubmissionFieldType.text:
      case SubmissionFieldType.multilineText:
      case SubmissionFieldType.picker:
        return result.stringValue ?? '';
      case SubmissionFieldType.currency:
        return NumberFormat.simpleCurrency().format(result.doubleValue ?? 0);
      case SubmissionFieldType.integer:
        return result.intValue?.toString() ?? '';
    }
  }

  StoreSubmissionField copy() {
    return StoreSubmissionField(
        templateId: templateId,
        stepId: stepId,
        fieldId: fieldId,
        label: label,
        mandatory: mandatory,
        fieldType: fieldType,
        maxValue: maxValue,
        pickerValues: pickerValues,
        result: result.copy());
  }

  @override
  List<Object?> get props => [
        fieldId,
        label,
        mandatory,
        fieldType,
        maxValue,
        pickerValues,
        result,
      ];
}

class StoreSubmissionFieldResult extends Equatable {
  StoreSubmissionFieldResult({
    this.stringValue,
    this.intValue,
    this.doubleValue,
    this.photoPathValue,
  });

  String? stringValue;
  int? intValue;
  double? doubleValue;
  String? photoPathValue;

  bool get isEmpty =>
      stringValue == null &&
      intValue == null &&
      doubleValue == null &&
      photoPathValue == null;

  StoreSubmissionFieldResult copy() {
    return StoreSubmissionFieldResult(
      stringValue: stringValue,
      intValue: intValue,
      doubleValue: doubleValue,
      photoPathValue: photoPathValue,
    );
  }

  @override
  List<Object?> get props => [
        stringValue,
        intValue,
        doubleValue,
        photoPathValue,
      ];
}
