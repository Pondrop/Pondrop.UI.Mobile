import 'dart:developer' as dev;
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';

part 'store_submission_event.dart';
part 'store_submission_state.dart';

class StoreSubmissionBloc
    extends Bloc<StoreSubmissionEvent, StoreSubmissionState> {
  StoreSubmissionBloc({
    required StoreVisitDto visit,
    required StoreSubmission submission,
    required SubmissionRepository submissionRepository,
    required LocationRepository locationRepository,
  }): _submissionRepository = submissionRepository,
      _locationRepository = locationRepository,
      super(StoreSubmissionState(visit: visit, submission: submission)) {
    on<StoreSubmissionNextEvent>(_onNext);
    on<StoreSubmissionFieldResultEvent>(_onResult);
  }

  final SubmissionRepository _submissionRepository;
  final LocationRepository _locationRepository;

  void _onResult(StoreSubmissionFieldResultEvent event,
      Emitter<StoreSubmissionState> emit) {
    final newSubmission = state.submission.copy();
    final step = newSubmission.steps[state.currentStepIdx];
    final field = step.fields.firstWhere((e) => e.fieldId == event.fieldId);

    field.result.stringValue = event.result.stringValue;
    field.result.intValue = event.result.intValue;
    field.result.doubleValue = event.result.doubleValue;
    field.result.photoPathValue = event.result.photoPathValue;

    emit(state.copyWith(submission: newSubmission));
  }

  Future<void> _onNext(StoreSubmissionNextEvent event,
      Emitter<StoreSubmissionState> emit) async {
    switch (state.status) {
      case SubmissionStatus.initial:
        {
          final cameraStatus = await Permission.camera.status;
          if (cameraStatus.isGranted) {
            await _goToNextStep(emit);
          } else {
            emit(state.copyWith(action: SubmissionStatus.cameraRequest));
          }
        }
        break;
      case SubmissionStatus.cameraRequest:
        {
          final cameraStatus = await Permission.camera.request();
          if (cameraStatus.isGranted) {
            await _goToNextStep(emit);
          } else {
            emit(state.copyWith(action: SubmissionStatus.cameraRejected));
          }
        }
        break;
      case SubmissionStatus.cameraRejected:
        if (await Permission.camera.isGranted) {
          await _goToNextStep(emit);
        } else {
          emit(state.copyWith(action: SubmissionStatus.cameraRequest));
        }
        break;
      case SubmissionStatus.stepInstructions:
        emit(state.copyWith(action: SubmissionStatus.stepSubmission));
        break;
      case SubmissionStatus.stepSubmission:
      case SubmissionStatus.submitFailed:
        await _goToNextStep(emit);
        break;
      case SubmissionStatus.submitting:
        if (await _submissionRepository.submitResult(state.visit.id, state.submission)) {
          emit(state.copyWith(action: SubmissionStatus.submitSuccess));
        } else {
          emit(state.copyWith(action: SubmissionStatus.submitFailed));
        }
        break;
      default:
        break;
    }
  }

  Future<void> _goToNextStep(Emitter<StoreSubmissionState> emit) async {
    final nextStepIdx = state.currentStepIdx + 1;

    if (nextStepIdx < state.numOfSteps) {
      Position? lastKnown;

      try {
        lastKnown = await _locationRepository.getLastKnownPosition();
      } on Exception {
        dev.log('Unable to determine last know location');
      }

      final nextStep = state.submission.steps[nextStepIdx];
      
      nextStep.latitude = lastKnown?.latitude ?? 0;
      nextStep.longitude = lastKnown?.longitude ?? 0;
      nextStep.started = DateTime.now();

      if (nextStep.instructionsContinueButton.isNotEmpty) {
        emit(state.copyWith(
          action: SubmissionStatus.stepInstructions,
          currentStepIdx: nextStepIdx,
        ));
      } else {
        emit(state.copyWith(
          action: SubmissionStatus.stepSubmission,
          currentStepIdx: nextStepIdx,
        ));
      }
    } else {
      emit(state.copyWith(
        action: SubmissionStatus.submitting,
      ));
    }
  }
}