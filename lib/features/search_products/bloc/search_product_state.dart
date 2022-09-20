part of 'search_product_bloc.dart';

enum SearchProductStatus { initial, loading, success, failure }

class SearchProductState extends Equatable {
  const SearchProductState({
    this.status = SearchProductStatus.initial,
    this.query = '',
    this.products = const <Product>[],
    this.hasReachedMax = false,
  });

  final SearchProductStatus status;
  final String query;
  final List<Product> products;
  final bool hasReachedMax;

  SearchProductState copyWith({
    SearchProductStatus? status,
    String? query,
    List<Product>? products,
    bool? hasReachedMax,
  }) {
    return SearchProductState(
      status: status ?? this.status,
      query: query ?? this.query,
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''ProductSearchState { status: $status, stores: ${products.length} }''';
  }

  @override
  List<Object> get props => [status, query, products, hasReachedMax];
}
