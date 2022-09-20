part of 'search_product_bloc.dart';

abstract class SearchProductEvent extends Equatable {
  @override
  List<Object> get props => [];
  
  const SearchProductEvent();
}

class SearchProductFetched extends SearchProductEvent {
  const SearchProductFetched();
}

class SearchProductRefreshed extends SearchProductEvent {
  const SearchProductRefreshed();
}

class TextChanged extends SearchProductEvent {
  const TextChanged({required this.text});

  final String text;

  @override
  List<Object> get props => [text];
}