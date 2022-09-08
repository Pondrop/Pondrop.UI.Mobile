part of 'store_report_bloc.dart';

class StoreReportState extends Equatable {
  const StoreReportState({
    required this.store,
    this.templates = const [],
    this.submissions = const [],
  });

  final Store store;
  final List<SubmissionTemplateDto> templates;
  final List<StoreSubmission> submissions;

  StoreReportState copyWith({
    List<SubmissionTemplateDto>? templates,
    List<StoreSubmission>? submissions,
  }) {
    return StoreReportState(
      store: store,
      templates: templates ?? this.templates,
      submissions: submissions ?? this.submissions,
    );
  }

  @override
  List<Object> get props => [store, templates, submissions];
}
