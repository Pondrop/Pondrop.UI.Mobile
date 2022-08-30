import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/dialogs/dialogs.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/store_submission/view/camera_access_view.dart';
import 'package:pondrop/style/style.dart';

import '../bloc/store_submission_bloc.dart';
import 'fields/fields.dart';
import 'submission_summary_list.dart';

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
          if (state.status == SubmissionStatus.cameraRejected ||
              state.status == SubmissionStatus.submitted) {
            Navigator.of(context).pop();
          } else if (state.status == SubmissionStatus.stepInstructions) {
            final bloc = context.read<StoreSubmissionBloc>();

            final okay = await Navigator.of(context)
                .push<bool>(DialogPage.route(DialogConfig(
              title: l10n.itemOfItem(
                  state.currentStepIdx + 1, state.submission.steps.length),
              iconData: IconData(state.currentStep.instructionsIconCodePoint,
                  fontFamily: state.currentStep.instructionsIconFontFamily),
              header: state.currentStep.title,
              body: state.currentStep.instructions,
              okayButtonText: state.currentStep.instructionsContinueButton,
              cancelButtonText: state.currentStep.instructionsSkipButton,
            )));

            bloc.add(const StoreSubmissionNextEvent());
            if (okay == true) {
              await PhotoFieldControl.takePhoto(
                  bloc, state.currentStep.fields.first);
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
                              state.status == SubmissionStatus.summary
                                  ? state.submission.title
                                  : state.currentStep.title,
                              style: AppStyles.popupTitleTextStyle,
                            );
                          },
                        ),
                      )),
                      BlocBuilder<StoreSubmissionBloc, StoreSubmissionState>(
                        builder: (context, state) {
                          if (state.status == SubmissionStatus.summary) {
                            return TextButton(
                                onPressed: () {
                                  context
                                      .read<StoreSubmissionBloc>()
                                      .add(const StoreSubmissionNextEvent());
                                },
                                child: Text(
                                  l10n.done,
                                  style: AppStyles.linkTextStyle
                                      .copyWith(fontWeight: FontWeight.w500),
                                ));
                          } else {
                            return TextButton(
                                onPressed: state.currentStep.isComplete
                                    ? () {
                                        context.read<StoreSubmissionBloc>().add(
                                            const StoreSubmissionNextEvent());
                                      }
                                    : null,
                                child: Text(
                                  l10n.next,
                                  style: AppStyles.linkTextStyle.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: state.currentStep.isComplete
                                          ? null
                                          : Colors.grey),
                                ));
                          }
                        },
                      ),
                    ]),
              ),
              Expanded(
                  child: BlocBuilder<StoreSubmissionBloc, StoreSubmissionState>(
                buildWhen: (previous, current) =>
                    current.status != SubmissionStatus.submitted,
                builder: (context, state) {
                  if (state.status == SubmissionStatus.summary) {
                    return const SubmissionSummaryList();
                  }

                  Widget? child;

                  if (state.status == SubmissionStatus.cameraRequest) {
                    child = const CameraAccessView();
                  } else {
                    final children = <Widget>[];

                    for (final i in state.currentStep.fields) {
                      switch (i.fieldType) {
                        case SubmissionFieldType.photo:
                          children.add(PhotoFieldControl(field: i));
                          break;
                        case SubmissionFieldType.text:
                        case SubmissionFieldType.multilineText:
                        case SubmissionFieldType.integer:
                        case SubmissionFieldType.currency:
                          children.add(TextFieldControl(field: i));
                          break;
                        case SubmissionFieldType.picker:
                          children.add(PickerFieldControl(field: i));
                          break;
                      }

                      children.add(const SizedBox(
                        height: 16,
                      ));

                      child = Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: children,
                      );
                    }
                  }

                  return SingleChildScrollView(
                      controller: ModalScrollController.of(context),
                      child: Padding(
                          padding: const EdgeInsets.all(8), child: child!));
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
