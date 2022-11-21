part of 'store_report_bloc.dart';

abstract class StoreReportEvent extends Equatable {
  const StoreReportEvent();

  @override
  List<Object> get props => [];
}

class StoreReportRefreshed extends StoreReportEvent {
  const StoreReportRefreshed({this.position});

  final Position? position;
}

class StoreReportSubmitted extends StoreReportEvent {
  const StoreReportSubmitted({required this.submission});

  final StoreSubmission submission;

  @override
  List<Object> get props => [submission];
}
