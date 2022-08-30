import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/models/models.dart';

import '../../bloc/store_submission_bloc.dart';

class TextFieldControl extends StatelessWidget {
  const TextFieldControl({super.key, required this.field});

  final StoreSubmissionField field;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    var keyboardType = TextInputType.text;
    final inputFormatters = <TextInputFormatter>[];

    switch (field.fieldType) {
      case SubmissionFieldType.multilineText:
        keyboardType = TextInputType.multiline;
        break;
      case SubmissionFieldType.integer:
        keyboardType = TextInputType.number;
        inputFormatters.add(FilteringTextInputFormatter.digitsOnly);
        break;
      case SubmissionFieldType.currency:
        keyboardType = TextInputType.number;
        inputFormatters.add(CurrencyInputFormatter(
          thousandSeparator: ThousandSeparator.Comma,
          leadingSymbol: MoneySymbols.DOLLAR_SIGN,
        ));
        break;
      case SubmissionFieldType.photo:
      case SubmissionFieldType.text:
      case SubmissionFieldType.picker:
        break;
    }

    return TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: field.label,
          suffixIcon: field.mandatory
              ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                      child: Text(l10n.fieldRequired,
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontStyle: FontStyle.italic)),
                    ),
                ],
              )
              : null,
        ),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: field.fieldType == SubmissionFieldType.multilineText ? 4 : 1,
        maxLength: field.maxValue,
        onChanged: (value) {
          final bloc = context.read<StoreSubmissionBloc>();

          StoreSubmissionFieldResult result;
          switch (field.fieldType) {
            case SubmissionFieldType.integer:
              final intValue = int.tryParse(value);
              result = StoreSubmissionFieldResult(intValue: intValue);
              break;
            case SubmissionFieldType.currency:
              final cleanedValue =
                  value.replaceAll('\$', '').replaceAll(',', '');
              final doubleValue = double.tryParse(cleanedValue);
              result = StoreSubmissionFieldResult(doubleValue: doubleValue);
              break;
            default:
              result = StoreSubmissionFieldResult(
                  stringValue: value.isEmpty ? null : value);
              break;
          }

          bloc.add(StoreSubmissionFieldResultEvent(
              stepId: field.stepId, fieldId: field.fieldId, result: result));
        });
  }
}
