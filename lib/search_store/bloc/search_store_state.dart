part of 'search_store_bloc.dart';

enum SearchStoreStatus { initial, success, failure }

class SearchStoreState extends Equatable {
  const SearchStoreState({
    this.status = SearchStoreStatus.initial,
    this.stores = const <Store>[],
  });

  final SearchStoreStatus status;
  final List<Store> stores;

  SearchStoreState copyWith({
    SearchStoreStatus? status,
    List<Store>? stores,
  }) {
    return SearchStoreState(
      status: status ?? this.status,
      stores: stores ?? this.stores,
    );
  }

  @override
  String toString() {
    return '''StoreState { status: $status, stores: ${stores.length} }''';
  }

  @override
  List<Object> get props => [status, stores];
}
