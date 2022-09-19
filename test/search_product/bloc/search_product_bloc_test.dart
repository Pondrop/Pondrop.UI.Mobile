import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/search_products/bloc/search_product_bloc.dart';
import 'package:tuple/tuple.dart';

import '../../fake_data/fake_data.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late ProductRepository productRepository;

  setUp(() {
    productRepository = MockProductRepository();
  });

  group('SearchProductBloc', () {
    test('initial state is Initial', () {
      expect(
          SearchProductBloc(
            productRepository: productRepository,
          ).state,
          equals(const SearchProductState()));
    });

    test('emit products when Fetched', () async {
      final products = [FakeProduct.fakeProduct()];

      when(() => productRepository.fetchProducts(any(), any()))
          .thenAnswer((invocation) => Future.value(Tuple2(products, true)));

      final bloc = SearchProductBloc(
        productRepository: productRepository,
      );

      bloc.add(const SearchProductFetched());

      await bloc.stream.firstWhere((e) => e.status != SearchProductStatus.loading);

      expect(bloc.state.query, '');
      expect(bloc.state.status, SearchProductStatus.success);
      expect(bloc.state.products, products);
    });

    test('emit products when Refreshed', () async {
      final products = [FakeProduct.fakeProduct()];

      when(() => productRepository.fetchProducts(any(), any()))
          .thenAnswer((invocation) => Future.value(Tuple2(products, true)));

      final bloc = SearchProductBloc(
        productRepository: productRepository,
      );

      bloc.add(const SearchProductRefreshed());

      await bloc.stream.firstWhere((e) => e.status != SearchProductStatus.loading);

      expect(bloc.state.query, '');
      expect(bloc.state.status, SearchProductStatus.success);
      expect(bloc.state.products, products);
    });

    test('emit empty when Search Text is empty', () async {
      final bloc = SearchProductBloc(
        productRepository: productRepository,
      );

      bloc.add(const TextChanged(text: ''));

      await bloc.stream.first;

      expect(bloc.state, equals(const SearchProductState()));
    });

    test('emit products when Search Text is changed', () async {
      const query = 'search term';
      final products = [FakeProduct.fakeProduct()];

      when(() => productRepository.fetchProducts(any(), any()))
          .thenAnswer((invocation) => Future.value(Tuple2(products, true)));

      final bloc = SearchProductBloc(
        productRepository: productRepository,
      );

      bloc.add(const TextChanged(text: query));

      await bloc.stream.firstWhere((e) => e.products.isNotEmpty);

      expect(bloc.state.query, query);
      expect(bloc.state.status, SearchProductStatus.success);
      expect(bloc.state.products, products);
    });

    test('emit error when Search Text is throws', () async {
      const query = 'search term';

      when(() => productRepository.fetchProducts(any(), any()))
          .thenThrow(Exception());

      final bloc = SearchProductBloc(
        productRepository: productRepository,
      );

      bloc.add(const TextChanged(text: query));

      await bloc.stream.firstWhere((e) => e.status == SearchProductStatus.failure);

      expect(bloc.state.status, SearchProductStatus.failure);
    });
  });
}
