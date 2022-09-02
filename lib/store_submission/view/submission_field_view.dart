import 'package:flutter/material.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/models/models.dart';

import 'fields/fields.dart';

class SubmissionFieldView extends StatelessWidget {
  SubmissionFieldView({required this.field})
      : super(key: Key(field.fieldId));

  final StoreSubmissionField field;

  @override
  Widget build(BuildContext context) {
    switch (field.fieldType) {
      case SubmissionFieldType.photo:
        return PhotoFieldControl(field: field);
      case SubmissionFieldType.text:
      case SubmissionFieldType.multilineText:
        return TextFieldControl(field: field);
      case SubmissionFieldType.integer:
        return IntFieldControl(field: field);
      case SubmissionFieldType.currency:
        return CurrencyFieldControl(field: field);
      case SubmissionFieldType.picker:
        return PickerFieldControl(field: field);
    }
  }
}
