part of 'store_submission_bloc.dart';

enum SubmissionStatus {
  initial,
  cameraRequest,
  cameraRejected,
  stepInstructions,
  stepSubmission,
  summary,
  submitted,
}

class StoreSubmissionState extends Equatable {
  const StoreSubmissionState({
    this.previousAction = SubmissionStatus.initial,
    this.status = SubmissionStatus.initial,
    required this.submission,
    this.currentStepIdx = -1,
  });
  
  final SubmissionStatus previousAction;
  final SubmissionStatus status;
  final StoreSubmission submission;
  final int currentStepIdx;

  int get numOfSteps =>
    submission.steps.length;
  StoreSubmissionStep get currentStep =>
    submission.steps[min(max(0, currentStepIdx), numOfSteps - 1)];
  bool get currentStepComplete =>
    currentStep.isComplete;

  bool get hasAnyResults =>
    submission.steps.any((step) => step.fields.any((field) => !field.result.isEmpty));

  StoreSubmissionState copyWith({
    SubmissionStatus? action,
    StoreSubmission? submission,
    int? currentStepIdx,
  }) {
    return StoreSubmissionState(
      previousAction: this.status,
      status: action ?? this.status,
      submission: submission ?? this.submission,
      currentStepIdx : currentStepIdx ?? this.currentStepIdx,
    );
  }

  @override
  List<Object> get props => [
    status,
    submission,
    currentStepIdx,
  ];
}
