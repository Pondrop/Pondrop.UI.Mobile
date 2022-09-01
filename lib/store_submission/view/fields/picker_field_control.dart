import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/models/models.dart';

import '../../bloc/store_submission_bloc.dart';
import 'required_view.dart';

class PickerFieldControl extends StatefulWidget {
  const PickerFieldControl({super.key, required this.field});

  final StoreSubmissionField field;

  @override
  State<PickerFieldControl> createState() => _PickerFieldControlState();
}

class _PickerFieldControlState extends State<PickerFieldControl> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: widget.field.label,
        suffixIcon: widget.field.mandatory
            ? const RequiredView()
            : null,
      ),
      controller: textController,
      focusNode: _AlwaysDisabledFocusNode(),
      readOnly: true,
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }

        if (widget.field.pickerValues != null) {
          final items = [const Center(child: Text(' - '))];
          items.addAll(widget.field.pickerValues!.map((e) => Center(
                  child: Text(
                e,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ))));
          final currentIdx = widget.field.result.stringValue?.isNotEmpty == true
              ? widget.field.pickerValues!.indexOf(widget.field.result.stringValue!) + 1
              : 0;

          showCupertinoModalPopup(
            context: context,
            builder: (BuildContext builder) {
              return Container(
                  height: MediaQuery.of(context).copyWith().size.height * 0.25,
                  color: Colors.white,
                  child: CupertinoPicker(
                    onSelectedItemChanged: (value) {
                      final stringValue =
                          value == 0 ? null : widget.field.pickerValues![value - 1];
                      final bloc = context.read<StoreSubmissionBloc>();
                      bloc.add(StoreSubmissionFieldResultEvent(
                          stepId: widget.field.stepId,
                          fieldId: widget.field.fieldId,
                          result: StoreSubmissionFieldResult(
                              stringValue: stringValue)));
                      textController.text = stringValue ?? '';
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
