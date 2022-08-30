import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/models/models.dart';

import '../../bloc/store_submission_bloc.dart';

class PickerFieldControl extends StatelessWidget {
  const PickerFieldControl({super.key, required this.field});

  final StoreSubmissionField field;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: field.label,
      ),
      controller: TextEditingController(text: field.result.stringValue),
      focusNode: _AlwaysDisabledFocusNode(),
      readOnly: true,
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }

        if (field.pickerValues != null) {
          final items = [const Center(child: Text(' - '))];
          items.addAll(field.pickerValues!.map((e) => Center(
                  child: Text(
                e,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ))));
          final currentIdx = field.result.stringValue?.isNotEmpty == true
              ? field.pickerValues!.indexOf(field.result.stringValue!) + 1
              : 0;

          showCupertinoModalPopup(
            context: context,
            builder: (BuildContext builder) {
              return Container(
                  height: MediaQuery.of(context).copyWith().size.height * 0.25,
                  color: Colors.white,
                  child: CupertinoPicker(
                    onSelectedItemChanged: (value) {
                      final bloc = context.read<StoreSubmissionBloc>();
                      bloc.add(StoreSubmissionFieldResultEvent(
                          stepId: field.stepId,
                          fieldId: field.fieldId,
                          result: StoreSubmissionFieldResult(
                              stringValue: value == 0
                                  ? null
                                  : field.pickerValues![value - 1])));
                    },
                    itemExtent: 36,
                    scrollController:
                        FixedExtentScrollController(initialItem: currentIdx),
                    children: items,
                  ));
            },
          );
        }
      },
    );
  }
}

class _AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
