import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/models/models.dart';

part 'store_submission_event.dart';
part 'store_submission_state.dart';

class StoreSubmissionBloc
    extends Bloc<StoreSubmissionEvent, StoreSubmissionState> {
  StoreSubmissionBloc({
    required StoreSubmission submission,
  }) : super(StoreSubmissionState(submission: submission)) {
    on<StoreSubmissionNextEvent>(_onNext);
    on<StoreSubmissionFieldResultEvent>(_onResult);
  }

  void _onResult(
      StoreSubmissionFieldResultEvent event, Emitter<StoreSubmissionState> emit) {
    final newSubmission = state.submission.copy();
    final step = newSubmission.steps[state.currentStepIdx];
    final field = step.fields.firstWhere((e) => e.fieldId == event.fieldId);
    
    field.result.stringValue = event.result.stringValue;
    field.result.intValue = event.result.intValue;
    field.result.photoPathValue = event.result.photoPathValue;
    
    emit(state.copyWith(
      submission: newSubmission
    ));
  }

  Future<void> _onNext(
      StoreSubmissionNextEvent event, Emitter<StoreSubmissionState> emit) async {
    switch (state.action) {
      case SubmissionAction.initial:
        {
          final cameraStatus = await Permission.camera.status;
          if (cameraStatus.isGranted) {
            _goToNextStep(emit);
          } else {
            emit(state.copyWith(action: SubmissionAction.cameraRequest));
          }
        }
        break;
      case SubmissionAction.cameraRequest:
        {
          final cameraStatus = await Permission.camera.request();
          if (cameraStatus.isGranted) {
            _goToNextStep(emit);
          } else {
            emit(state.copyWith(action: SubmissionAction.cameraRejected));
          }
        }
        break;
      case SubmissionAction.cameraRejected:
        break;
      case SubmissionAction.stepInstructions:
        emit(state.copyWith(action: SubmissionAction.stepSubmission));
        break;
      case SubmissionAction.stepSubmission:
        _goToNextStep(emit);
        break;
      case SubmissionAction.summary:
        // TODO: Handle this case.
        break;
    }
  }

  void _goToNextStep(Emitter<StoreSubmissionState> emit) {
    final nextStepIdx = state.currentStepIdx + 1;

    if (nextStepIdx < state.numOfSteps) {
      final nextStep = state.submission.steps[nextStepIdx];

      if (nextStep.instructionsContinueButton.isNotEmpty) {
        emit(state.copyWith(
          action: SubmissionAction.stepInstructions,
          currentStepIdx: nextStepIdx,
        ));
      } else {
        emit(state.copyWith(
          action: SubmissionAction.stepSubmission,
          currentStepIdx: nextStepIdx,
        ));
      }
    }
  }
}
