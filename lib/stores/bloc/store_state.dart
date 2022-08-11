part of 'store_bloc.dart';

enum storeStatus { initial, success, failure }

class storeState extends Equatable {
  const storeState({
    this.status = storeStatus.initial,
    this.stores = const <Store>[],
    this.hasReachedMax = false,
  });

  final storeStatus status;
  final List<Store> stores;
  final bool hasReachedMax;

  storeState copyWith({
    storeStatus? status,
    List<Store>? stores,
    bool? hasReachedMax,
  }) {
    return storeState(
      status: status ?? this.status,
      stores: stores ?? this.stores,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''storeState { status: $status, hasReachedMax: $hasReachedMax, stores: ${stores.length} }''';
  }

  @override
  List<Object> get props => [status, stores, hasReachedMax];
}