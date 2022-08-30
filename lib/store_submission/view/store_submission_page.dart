import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/dialogs/dialogs.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/store_submission/view/camera_access_view.dart';
import 'package:pondrop/style/style.dart';

import '../bloc/store_submission_bloc.dart';

class StoreSubmissionPage extends StatelessWidget {
  const StoreSubmissionPage({Key? key, required this.submission})
      : super(key: key);

  final StoreSubmission submission;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (context) => StoreSubmissionBloc(
        submission: submission,
      )..add(const StoreSubmissionNextEvent()),
      child: BlocListener<StoreSubmissionBloc, StoreSubmissionState>(
        listener: (context, state) async {
          if (state.action == SubmissionAction.cameraRejected) {
            Navigator.of(context).pop();
          } else if (state.action == SubmissionAction.stepInstructions) {
            final bloc = context.read<StoreSubmissionBloc>();

            final okay = await Navigator.of(context)
                .push<bool>(DialogPage.route(DialogConfig(
              title:
                  '${state.currentStepIdx + 1} of ${state.submission.steps.length}',
              iconData: IconData(state.currentStep.instructionsIconCodePoint,
                  fontFamily: state.currentStep.instructionsIconFontFamily),
              header: state.currentStep.title,
              body: state.currentStep.instructions,
              okayButtonText: state.currentStep.instructionsContinueButton,
              cancelButtonText: state.currentStep.instructionsSkipButton,
            )));

            bloc.add(const StoreSubmissionNextEvent());
            if (okay == true) {
              await _takePhoto(bloc, state.currentStep.fields.first);
            }            
          }
        },
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        child: Text(
                          l10n.cancel,
                          style: AppStyles.linkTextStyle,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Expanded(
                          child: Align(
                        alignment: Alignment.center,
                        child: BlocBuilder<StoreSubmissionBloc,
                            StoreSubmissionState>(
                          builder: (context, state) {
                            return Text(
                              state.currentStep.title,
                              style: AppStyles.popupTitleTextStyle,
                            );
                          },
                        ),
                      )),
                      BlocBuilder<StoreSubmissionBloc, StoreSubmissionState>(
                        builder: (context, state) {
                          return TextButton(
                            onPressed: state.currentStep.isComplete
                                ? () {
                                    context
                                        .read<StoreSubmissionBloc>()
                                        .add(const StoreSubmissionNextEvent());
                                  }
                                : null,
                            child: Text(
                              l10n.next,
                              style: AppStyles.linkTextStyle.copyWith(
                                  color: state.currentStep.isComplete
                                      ? null
                                      : Colors.grey),
                            ),
                          );
                        },
                      ),
                    ]),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child:
                        BlocBuilder<StoreSubmissionBloc, StoreSubmissionState>(
                      builder: (context, state) {
                        if (state.action == SubmissionAction.cameraRequest) {
                          return const CameraAccessView();
                        }

                        final children = <Widget>[];

                        for (final i in state.currentStep.fields) {
                          switch (i.fieldType) {
                            case SubmissionFieldType.photo:
                              children.add(_photoField(context, i));
                              break;
                            case SubmissionFieldType.text:
                            case SubmissionFieldType.multilineText:
                            case SubmissionFieldType.integer:
                            case SubmissionFieldType.currency:
                              children.add(_textField(context, i));
                              break;
                            case SubmissionFieldType.picker:
                              children.add(_pickerField(context, i));
                              break;
                          }

                          children.add(const SizedBox(
                            height: 16,
                          ));
                        }

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: children,
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _photoField(BuildContext context, StoreSubmissionField field) {
    return SizedBox(
      height: 256,
      width: double.infinity,
      child: Card(
        color: Theme.of(context).cardColor.withOpacity(0.75),
        child: field.result.photoPathValue?.isNotEmpty == true
            ? Image.file(File(field.result.photoPathValue!))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    const Icon(
                      Icons.add_a_photo_outlined,
                      size: 48,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await _takePhoto(context.read<StoreSubmissionBloc>(), field);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black, onPrimary: Colors.white),
                      child: const Text('Take photo'),
                    )
                  ]),
      ),
    );
  }

  Future<void> _takePhoto(
      StoreSubmissionBloc bloc, StoreSubmissionField field) async {
    if (field.fieldType == SubmissionFieldType.photo) {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image != null) {
        bloc.add(StoreSubmissionFieldResultEvent(
            stepId: field.stepId,
            fieldId: field.fieldId,
            result: StoreSubmissionFieldResult(photoPathValue: image.path)));
      }
    }
  }

  Widget _textField(BuildContext context, StoreSubmissionField field) {
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
            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5)),
            errorText:
                field.mandatory && field.result.isEmpty ? '* required' : null),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: field.fieldType == SubmissionFieldType.multilineText ? 4 : 1,
        maxLength: field.maxValue,
        onChanged: (value) {
          final bloc = context.read<StoreSubmissionBloc>();
          bloc.add(StoreSubmissionFieldResultEvent(
              stepId: field.stepId,
              fieldId: field.fieldId,
              result: StoreSubmissionFieldResult(
                  stringValue: value.isEmpty ? null : value)));
        });
  }

  Widget _pickerField(BuildContext context, StoreSubmissionField field) {
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
