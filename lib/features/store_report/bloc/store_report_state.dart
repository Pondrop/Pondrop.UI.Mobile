part of 'store_report_bloc.dart';

enum StoreReportStatus { unknown, loading, loaded, failed }

class StoreReportState extends Equatable {
  const StoreReportState({
    required this.store,
    this.status = StoreReportStatus.unknown,
    this.visit,
    this.campaigns = const [],
    this.templates = const [],
    this.submissions = const [],
  });

  final Store store;
  final StoreReportStatus status;
  final StoreVisitDto? visit;

  final List<CampaignDto> campaigns;
  final List<SubmissionTemplateDto> templates;

  final List<StoreSubmission> submissions;

  StoreReportState copyWith({
    StoreReportStatus? status,
    StoreVisitDto? visit,
    List<CampaignDto>? campaigns,
    List<SubmissionTemplateDto>? templates,
    List<StoreSubmission>? submissions,
  }) {
    return StoreReportState(
      store: store,
      status: status ?? this.status,
      visit: visit ?? this.visit,
      campaigns: campaigns ?? this.campaigns,
      templates: templates ?? this.templates,
      submissions: submissions ?? this.submissions,
    );
  }

  @override
  List<Object?> get props =>
      [store, status, visit, campaigns, templates, submissions];
}
