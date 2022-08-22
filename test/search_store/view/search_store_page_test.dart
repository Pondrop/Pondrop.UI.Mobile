import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/search_store/search_store.dart';
import 'package:pondrop/search_store/view/search_store_list.dart';

import '../../helpers/helpers.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

class MockStoreRepository extends Mock implements StoreRepository {}

void main() {
  late LocationRepository locationRepository;
  late StoreRepository storeRepository;

  setUp(() {
    locationRepository = MockLocationRepository();
    storeRepository = MockStoreRepository();
  });

  group('Search Store', () {
    test('is routable', () {
      expect(SearchStorePage.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders a Search Store List', (tester) async {
      await tester.pumpApp(MultiRepositoryProvider(providers: [
        RepositoryProvider.value(value: storeRepository),
        RepositoryProvider.value(value: locationRepository),
      ], child: const SearchStorePage()));
      expect(find.byType(SearchStoresList), findsOneWidget);
    });
  });
}
