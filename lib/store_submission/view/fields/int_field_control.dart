import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/models/models.dart';

import '../../bloc/store_submission_bloc.dart';
import 'required_view.dart';

class IntFieldControl extends StatelessWidget {
  const IntFieldControl({super.key, required this.field});

  final StoreSubmissionField field;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: field.label,
        suffixIcon: field.mandatory && field.result.isEmpty
            ? const RequiredView()
            : null,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      maxLines: 1,
      onChanged: (value) {
        final intValue = int.tryParse(value);
        final result = StoreSubmissionFieldResult(intValue: intValue);
        context.read<StoreSubmissionBloc>().add(StoreSubmissionFieldResultEvent(
            stepId: field.stepId, fieldId: field.fieldId, result: result));
      },
    );
  }
}
