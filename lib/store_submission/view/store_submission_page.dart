import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/app/app.dart';
import 'package:pondrop/dialogs/dialogs.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/store_submission/view/camera_access_view.dart';
import 'package:pondrop/store_submission/view/submission_field_view.dart';
import 'package:pondrop/store_submission/view/submission_success_view.dart';
import 'package:pondrop/styles/styles.dart';

import '../bloc/store_submission_bloc.dart';
import 'fields/fields.dart';
import 'submission_summary_list_view.dart';

class StoreSubmissionPage extends StatelessWidget {
  const StoreSubmissionPage(
      {Key? key, required this.visit, required this.submission})
      : super(key: key);

  static const nextButtonKey = Key('StoreSubmissionPage_Next_Button');

  static Route route(StoreVisitDto visit, StoreSubmission submission) {
    return MaterialPageRoute<void>(
        builder: (_) =>
            StoreSubmissionPage(visit: visit, submission: submission));
  }

  final StoreVisitDto visit;
  final StoreSubmission submission;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (context) => StoreSubmissionBloc(
        visit: visit,
        submission: submission,
        submissionRepository:
            RepositoryProvider.of<SubmissionRepository>(context),
        cameraRepository: RepositoryProvider.of<CameraRepository>(context),
        locationRepository: RepositoryProvider.of<LocationRepository>(context),
      )..add(const StoreSubmissionNextEvent()),
      child: BlocListener<StoreSubmissionBloc, StoreSubmissionState>(
        listener: (context, state) async {
          final cameraRepository = RepositoryProvider.of<CameraRepository>(context);
          final bloc = context.read<StoreSubmissionBloc>();
          final navigator = Navigator.of(context);

          if (state.status == SubmissionStatus.submitting) {
            LoadingOverlay.of(context).show(l10n.itemEllipsis(l10n.submitting));
            bloc.add(const StoreSubmissionNextEvent());
            return;
          }

          LoadingOverlay.of(context).hide();

          if (state.status == SubmissionStatus.submitFailed) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(l10n.itemFailedPleaseTryAgain(l10n.submitting))));
            return;
          } else if (state.status == SubmissionStatus.submitSuccess) {
            await navigator.push(SubmissionSuccessView.route());
            navigator.pop();
            return;
          }

          if (state.status == SubmissionStatus.cameraRejected) {
            await showDialog(
              context: context,
              builder: (_) => _cameraAccessPrompt(context),
            );
          } else if (state.status == SubmissionStatus.stepInstructions) {
            final okay =
                await navigator.push<bool?>(DialogPage.route(DialogConfig(
              title: l10n.itemOfItem(
                  state.currentStepIdx + 1,
                  state.submission.steps.length -
                      (state.lastStepHasMandatoryFields ? 0 : 1)),
              iconData: IconData(state.currentStep.instructionsIconCodePoint,
                  fontFamily: state.currentStep.instructionsIconFontFamily),
              header: state.currentStep.title,
              body: state.currentStep.instructions,
              okayButtonText: state.currentStep.instructionsContinueButton,
              cancelButtonText: state.currentStep.instructionsSkipButton,
            )));

            bloc.add(const StoreSubmissionNextEvent());
            if (okay == null) {
              navigator.pop();
            } else if (okay == true) {
              await PhotoFieldControl.takePhoto(
                  cameraRepository, bloc, state.currentStep.fields.first);
            }
          }
        },
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: Dims.smallEdgeInsets,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        child: Text(
                          l10n.cancel,
                          style: PondropStyles.linkTextStyle,
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
                              state.currentStep.title.isNotEmpty
                                  ? state.currentStep.title
                                  : state.submission.title,
                              style: PondropStyles.popupTitleTextStyle,
                            );
                          },
                        ),
                      )),
                      BlocBuilder<StoreSubmissionBloc, StoreSubmissionState>(
                        builder: (context, state) {
                          return TextButton(
                              key: nextButtonKey,
                              onPressed: state.currentStep.isComplete
                                  ? () {
                                      context.read<StoreSubmissionBloc>().add(
                                          const StoreSubmissionNextEvent());
                                    }
                                  : null,
                              child: Text(
                                state.isLastStep ? l10n.send : l10n.next,
                                style: PondropStyles.linkTextStyle.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: state.currentStep.isComplete
                                        ? null
                                        : Colors.grey),
                              ));
                        },
                      ),
                    ]),
              ),
              Expanded(
                  child: BlocBuilder<StoreSubmissionBloc, StoreSubmissionState>(
                buildWhen: (previous, current) =>
                    current.status != SubmissionStatus.cameraRejected &&
                    current.status != SubmissionStatus.submitFailed &&
                    current.status != SubmissionStatus.submitSuccess,
                builder: (context, state) {
                  if (state.status == SubmissionStatus.cameraRequest) {
                    return const CameraAccessView();
                  }

                  if (state.currentStep.isSummary) {
                    return SubmissionSummaryListView(
                      submission: state.submission,
                      stepIdx: state.currentStepIdx,
                    );
                  }

                  final children = <Widget>[];

                  for (final i in state.currentStep.fields) {
                    children.add(Padding(
                      padding: Dims.largeBottomEdgeInsets,
                      child: SubmissionFieldView(
                        field: i,
                      ),
                    ));
                  }

                  return SingleChildScrollView(
                      controller: ModalScrollController.of(context),
                      child: Padding(
                          padding: Dims.smallEdgeInsets,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: children,
                          )));
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  AlertDialog _cameraAccessPrompt(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.cameraAccessRequired),
      content: Text(l10n.pleaseEnableCameraAccess),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () {
            context
                .read<StoreSubmissionBloc>()
                .add(const StoreSubmissionNextEvent());
            Navigator.pop(context);
            AppSettings.openAppSettings();
          },
          child: Text(l10n.openSettings),
        ),
      ],
    );
  }
}
