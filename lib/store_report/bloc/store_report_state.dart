part of 'store_report_bloc.dart';

enum StoreReportVisitStatus { starting, failed, started }

class StoreReportState extends Equatable {
  const StoreReportState({
    required this.store,    
    this.visitStatus = StoreReportVisitStatus.starting,
    this.visit,
    this.templates = const [],
    this.submissions = const [],
  });

  final Store store;
  final StoreReportVisitStatus visitStatus;
  final StoreVisitDto? visit;

  final List<SubmissionTemplateDto> templates;
  final List<StoreSubmission> submissions;

  StoreReportState copyWith({
    StoreReportVisitStatus? visitStatus,
    StoreVisitDto? visit,
    List<SubmissionTemplateDto>? templates,
    List<StoreSubmission>? submissions,
  }) {
    return StoreReportState(
      store: store,
      visitStatus : visitStatus ?? this.visitStatus,
      visit : visit ?? this.visit,
      templates: templates ?? this.templates,
      submissions: submissions ?? this.submissions,
    );
  }

  @override
  List<Object?> get props => [store, visit, templates, submissions];
}
