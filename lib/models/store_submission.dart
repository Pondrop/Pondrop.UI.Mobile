import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:pondrop/api/submissions/models/models.dart';
import 'package:tuple/tuple.dart';

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
                started: DateTime.now(),
                instructions: step.instructions,
                instructionsContinueButton: step.instructionsContinueButton,
                instructionsSkipButton: step.instructionsSkipButton,
                instructionsIconCodePoint: step.instructionsIconCodePoint,
                instructionsIconFontFamily: step.instructionsIconFontFamily,
                isSummary: step.isSummary,
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
                        itemType: field.itemType,
                        results: [ StoreSubmissionFieldResult() ]))
                    .toList(),
              ))
          .toList(),
    );
  }
}

extension StoreSubmissionResultMapping on StoreSubmission {
  SubmissionResultDto toSubmissionResultDto(String storeVisitId) {
    return SubmissionResultDto(
      submissionTemplateId: templateId,
      storeVisitId: storeVisitId,
      latitude: latitude,
      longitude: longitude,
      steps: steps
          .map((step) => SubmissionStepResultDto(
                templateStepId: step.stepId,
                latitude: step.latitude,
                longitude: step.longitude,
                startedUtc: step.started.toUtc(),
                fields: step.fields
                    .map((field) => SubmissionFieldResultDto(
                        templateFieldId: field.fieldId,
                        values: field.results
                            .where((e) => !e.isEmpty)
                            .map((e) => SubmissionFieldResultValueDto(
                                  stringValue: e.stringValue,
                                  intValue: e.intValue,
                                  doubleValue: e.doubleValue,
                                  photoPathValue: e.photoPathValue,
                                  itemValue:
                                      field.itemType != null && e.item != null
                                          ? SubmissionFieldResultValueItemDto(
                                              itemId: e.item!.item1,
                                              itemName: e.item!.item2,
                                              itemType: field.itemType!)
                                          : null,
                                ))
                            .toList()))
                    .toList(),
              ))
          .toList(),
    );
  }
}

class StoreSubmission extends Equatable {
  StoreSubmission({
    required this.templateId,
    required this.title,
    required this.description,
    this.latitude = 0,
    this.longitude = 0,
    required this.steps,
    this.submittedDate,
  });

  final String templateId;
  final String title;
  final String description;

  double latitude;
  double longitude;

  final List<StoreSubmissionStep> steps;

  final DateTime? submittedDate;

  StoreSubmission copy({LatLng? location, DateTime? submittedDate}) {
    return StoreSubmission(
      templateId: templateId,
      title: title,
      latitude: location?.latitude ?? latitude,
      longitude: location?.longitude ?? longitude,
      description: description,
      steps: steps.map((e) => e.copy()).toList(),
      submittedDate: submittedDate ?? this.submittedDate,
    );
  }

  @override
  List<Object?> get props => [templateId, title, description, steps];
}

class StoreSubmissionStep extends Equatable {
  StoreSubmissionStep({
    required this.templateId,
    required this.stepId,
    required this.title,
    this.latitude = 0,
    this.longitude = 0,
    required this.started,
    required this.instructions,
    required this.instructionsContinueButton,
    required this.instructionsSkipButton,
    required this.instructionsIconCodePoint,
    required this.instructionsIconFontFamily,
    required this.fields,
    required this.isSummary,
  });

  final String templateId;
  final String stepId;

  final String title;

  double latitude;
  double longitude;

  DateTime started;

  final String instructions;
  final String instructionsContinueButton;
  final String instructionsSkipButton;
  final int instructionsIconCodePoint;
  final String instructionsIconFontFamily;

  final bool isSummary;

  final List<StoreSubmissionField> fields;

  bool get isComplete =>
      fields.isEmpty ||
      fields.every((e) => !e.mandatory || e.results.every((e) => !e.isEmpty));

  bool get isFocus =>
      fields.length == 1 && fields[0].fieldType == SubmissionFieldType.focus;

  StoreSubmissionStep copy() {
    return StoreSubmissionStep(
        templateId: templateId,
        stepId: stepId,
        title: title,
        latitude: latitude,
        longitude: longitude,
        started: started,
        instructions: instructions,
        instructionsContinueButton: instructionsContinueButton,
        instructionsSkipButton: instructionsSkipButton,
        instructionsIconCodePoint: instructionsIconCodePoint,
        instructionsIconFontFamily: instructionsIconFontFamily,
        isSummary: isSummary,
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
        isSummary,
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
      this.itemType,
      this.results = const []});

  final String templateId;
  final String stepId;
  final String fieldId;
  final String label;
  final bool mandatory;
  final SubmissionFieldType fieldType;

  final int? maxValue;
  final List<String>? pickerValues;
  final SubmissionFieldItemType? itemType;

  final List<StoreSubmissionFieldResult> results;

  String toResultString([String separator = ', ']) {
    return results.map((e) {
      switch (fieldType) {
        case SubmissionFieldType.photo:
          return e.photoPathValue ?? '';
        case SubmissionFieldType.text:
        case SubmissionFieldType.multilineText:
        case SubmissionFieldType.picker:
          return e.stringValue ?? '';
        case SubmissionFieldType.currency:
          return NumberFormat.simpleCurrency().format(e.doubleValue ?? 0);
        case SubmissionFieldType.integer:
          return e.intValue?.toString() ?? '';
        case SubmissionFieldType.search:
        case SubmissionFieldType.focus:
          return e.item?.item2 ?? e.item?.item1 ?? '';
        default:
          return '';
      }
    }).join(separator);
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
        itemType: itemType,
        results: results.map((e) => e.copy()).toList());
  }

  @override
  List<Object?> get props => [
        fieldId,
        label,
        mandatory,
        fieldType,
        maxValue,
        pickerValues,
        itemType,
        results,
      ];
}

class StoreSubmissionFieldResult extends Equatable {
  StoreSubmissionFieldResult({
    this.stringValue,
    this.intValue,
    this.doubleValue,
    this.photoPathValue,
    this.item,
  });

  String? stringValue;
  int? intValue;
  double? doubleValue;
  String? photoPathValue;

  Tuple2<String, String>? item;

  bool get isEmpty =>
      stringValue == null &&
      intValue == null &&
      doubleValue == null &&
      photoPathValue == null &&
      item == null;

  StoreSubmissionFieldResult copy() {
    return StoreSubmissionFieldResult(
      stringValue: stringValue,
      intValue: intValue,
      doubleValue: doubleValue,
      photoPathValue: photoPathValue,
      item: item,
    );
  }

  @override
  List<Object?> get props => [
        stringValue,
        intValue,
        doubleValue,
        photoPathValue,
        item,
      ];
}
