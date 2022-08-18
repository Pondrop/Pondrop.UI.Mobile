part of 'store_bloc.dart';

enum StoreStatus { initial, refreshing, success, failure }

class StoreState extends Equatable {
  const StoreState({
    this.status = StoreStatus.initial,
    this.stores = const <Store>[],
    this.hasReachedMax = false,
  });

  final StoreStatus status;
  final List<Store> stores;
  final bool hasReachedMax;

  StoreState copyWith({
    StoreStatus? status,
    List<Store>? stores,
    bool? hasReachedMax,
  }) {
    return StoreState(
      status: status ?? this.status,
      stores: stores ?? this.stores,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''StoreState { status: $status, hasReachedMax: $hasReachedMax, stores: ${stores.length} }''';
  }

  @override
  List<Object> get props => [status, stores, hasReachedMax];
}