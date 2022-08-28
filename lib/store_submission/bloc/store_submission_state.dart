part of 'store_submission_bloc.dart';

enum SubmissionAction {
  initial,
  cameraRequest,
  cameraRejected,
  stepInstructions,
  stepSubmission,
  summary
}

class StoreSubmissionState extends Equatable {
  const StoreSubmissionState({
    this.previousAction = SubmissionAction.initial,
    this.action = SubmissionAction.initial,
    required this.submission,
    this.currentStepIdx = -1,
  });
  
  final SubmissionAction previousAction;
  final SubmissionAction action;
  final StoreSubmission submission;
  final int currentStepIdx;

  int get numOfSteps =>
    submission.steps.length;
  StoreSubmissionStep get currentStep =>
    submission.steps[min(max(0, currentStepIdx), numOfSteps - 1)];
  bool get currentStepComplete =>
    currentStep.isComplete;

  StoreSubmissionState copyWith({
    SubmissionAction? action,
    StoreSubmission? submission,
    int? currentStepIdx,
  }) {
    return StoreSubmissionState(
      previousAction: this.action,
      action: action ?? this.action,
      submission: submission ?? this.submission,
      currentStepIdx : currentStepIdx ?? this.currentStepIdx,
    );
  }

  @override
  List<Object> get props => [
    action,
    submission,
    currentStepIdx,
  ];
}
