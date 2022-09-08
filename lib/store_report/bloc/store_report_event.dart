part of 'store_report_bloc.dart';

abstract class StoreReportEvent extends Equatable { 
  const StoreReportEvent();

  @override
  List<Object> get props => [];
}

class StoreVisitCreated extends StoreReportEvent {
  const StoreVisitCreated({required this.visit});

  final StoreVisitDto visit;

  @override
  List<Object> get props => [visit];
}

class StoreVisitFailed extends StoreReportEvent {
  const StoreVisitFailed();
}

class StoreReportSubmitted extends StoreReportEvent {
  const StoreReportSubmitted({required this.submission});

  final StoreSubmission submission;

  @override
  List<Object> get props => [submission];
}
