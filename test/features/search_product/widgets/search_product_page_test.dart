import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/features/search_products/search_product.dart';
import 'package:pondrop/features/search_products/widgets/search_product_list.dart';
import 'package:pondrop/features/search_products/widgets/search_product_list_item.dart';
import 'package:tuple/tuple.dart';

import '../../../fake_data/fake_data.dart';
import '../../../helpers/helpers.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late ProductRepository productRepository;

  setUp(() {
    productRepository = MockProductRepository();
  });

  group('Search Product', () {
    test('is routable', () {
      expect(SearchProductPage.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders a SearchProductList', (tester) async {
      await tester.pumpApp(MultiRepositoryProvider(providers: [
        RepositoryProvider.value(value: productRepository),
      ], child: const SearchProductPage()));
      expect(find.byType(SearchProductList), findsOneWidget);
    });

    testWidgets('renders a SearchProductListItem', (tester) async {
      const query = 'Flutter';

      when(() => productRepository.fetchProducts(query, 0))
          .thenAnswer((_) => Future.value(Tuple2([FakeProduct.fakeProduct()], true)));
      
      await tester.pumpApp(MultiRepositoryProvider(providers: [
        RepositoryProvider.value(value: productRepository),
      ], child: const SearchProductPage()));

      await tester.enterText(find.byKey(SearchProductPage.searchTextFieldKey), query);
      await tester.pump(const Duration(milliseconds: 350));

      verify(() => productRepository.fetchProducts(query, 0)).called(1);

      expect(find.byType(SearchProductList), findsOneWidget);
      expect(find.byType(SearchProductListItem), findsOneWidget);
    });

    testWidgets('renders a Empty list', (tester) async {
      const query = 'Flutter';

      when(() => productRepository.fetchProducts(query, 0))
          .thenAnswer((_) => Future.value(const Tuple2([], false)));
      
      await tester.pumpApp(MultiRepositoryProvider(providers: [
        RepositoryProvider.value(value: productRepository),
      ], child: const SearchProductPage()));

      await tester.enterText(find.byKey(SearchProductPage.searchTextFieldKey), query);
      await tester.pump(const Duration(milliseconds: 350));

      verify(() => productRepository.fetchProducts(query, 0)).called(1);

      expect(find.byType(SearchProductList), findsOneWidget);
      expect(find.byType(NoResultsFound), findsOneWidget);
    });
  });
}
