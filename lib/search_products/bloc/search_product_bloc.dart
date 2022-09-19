import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:stream_transform/stream_transform.dart';

part 'search_product_event.dart';
part 'search_product_state.dart';

const throttleDuration = Duration(milliseconds: 300);

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class SearchProductBloc extends Bloc<SearchProductEvent, SearchProductState> {
  SearchProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(const SearchProductState()) {
    on<SearchProductFetched>(_onProductFetched);
    on<SearchProductRefreshed>(_onProductRefresh);
    on<TextChanged>(_onProductSearch, transformer: debounce(throttleDuration));
  }

  final ProductRepository _productRepository;

  Future<void> _onProductFetched(
    SearchProductFetched event,
    Emitter<SearchProductState> emit,
  ) async {
    if (state.hasReachedMax || state.status == SearchProductStatus.loading) {
      return;
    }

    try {
      if (state.status == SearchProductStatus.initial) {
        emit(state.copyWith(status: SearchProductStatus.loading));

        final products = await _productRepository.fetchProducts(
            state.query, state.products.length);

        emit(
          state.copyWith(
            status: SearchProductStatus.success,
            products: List.of(state.products)..addAll(products.item1),
            hasReachedMax: !products.item2,
          ),
        );
      }
    } catch (ex) {
      log(ex.toString());
      emit(state.copyWith(status: SearchProductStatus.failure));
    }
  }

  Future<void> _onProductRefresh(
    SearchProductRefreshed event,
    Emitter<SearchProductState> emit,
  ) async {
    if (state.status == SearchProductStatus.loading) {
      return;
    }

    emit(state.copyWith(status: SearchProductStatus.loading));

    try {
      final products = await _productRepository.fetchProducts(state.query, 0);

      emit(
        state.copyWith(
          status: SearchProductStatus.success,
          products: products.item1,
          hasReachedMax: !products.item2,
        ),
      );
    } catch (ex) {
      log(ex.toString());
      emit(state.copyWith(status: SearchProductStatus.failure));
    }
  }

  Future<void> _onProductSearch(
      TextChanged event, Emitter<SearchProductState> emit) async {
    emit(const SearchProductState().copyWith(query: event.text));

    if (event.text.length <= 3) {
      return;
    }

    add(const SearchProductRefreshed());
  }
}
