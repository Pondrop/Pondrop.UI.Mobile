import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/location/repositories/location_repository.dart';
import 'package:pondrop/stores/view/store_list.dart';
import 'package:pondrop/stores/view/store_page.dart';
import 'package:store_service/store_service.dart';

import '../../helpers/helpers.dart';

class MockLocationRepository extends Mock implements LocationRepository {}
class MockStoreService extends Mock implements StoreService {}

void main() {
  late LocationRepository locationRepository;
  late StoreService storeService;

  setUp(() {
    locationRepository = MockLocationRepository();
    storeService = MockStoreService();
  });

  group('Store', () {
    test('is routable', () {
      expect(StorePage.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders a Store List', (tester) async {
      await tester.pumpApp(MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: storeService),
          RepositoryProvider.value(value: locationRepository),
        ],
        child: const StorePage()
      ));

      await tester.pumpAndSettle();

      expect(find.byType(StoresList), findsOneWidget);
    });
    
  });
}
