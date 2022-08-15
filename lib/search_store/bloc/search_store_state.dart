part of 'search_store_bloc.dart';

enum SearchStoreStatus { initial, success, failure }

class SearchStoreState extends Equatable {
  const SearchStoreState({
    this.status = SearchStoreStatus.initial,
    this.stores = const <Store>[],
    this.hasReachedMax = false,
  });

  final SearchStoreStatus status;
  final List<Store> stores;
  final bool hasReachedMax;

  SearchStoreState copyWith({
    SearchStoreStatus? status,
    List<Store>? stores,
    bool? hasReachedMax,
  }) {
    return SearchStoreState(
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
