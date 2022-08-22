part of 'store_report_bloc.dart';

class StoreReportState extends Equatable {
  const StoreReportState({
    required this.store,
  });

  final Store store;

  StoreReportState copyWith() {
    return StoreReportState(
      store: store,
    );
  }

  @override
  String toString() {
    return '''StoreReportState { store: ${store.displayName} }''';
  }

  @override
  List<Object> get props => [store];
}
