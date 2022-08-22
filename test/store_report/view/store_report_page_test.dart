import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/search_store/search_store.dart';
import 'package:pondrop/search_store/view/search_store_list.dart';
import 'package:pondrop/store_report/view/store_report_page.dart';

import '../../helpers/helpers.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

class MockStoreRepository extends Mock implements StoreRepository {}

void main() {
  late LocationRepository locationRepository;
  late StoreRepository storeRepository;
  late Store _store;

  setUp(() {
    locationRepository = MockLocationRepository();
    storeRepository = MockStoreRepository();
    _store = const Store(
      id: 'ID',
      provider: 'Superfoods',
      name: 'Seaford',
      displayName: 'Superfoods Seaford',
      address: '123 St, City',
      latitude: 0,
      longitude: 0,
      lastKnowDistanceMetres: -1);
  });

  group('Store Report', () {
    test('is routable', () {
      expect(StoreReportPage.route(_store), isA<MaterialPageRoute>());
    });

    testWidgets('renders a Store Report page', (tester) async {
      await tester.pumpAppWithRoute((settings) {
        return MaterialPageRoute(
          settings: RouteSettings(arguments: _store),
          builder: (context) {
            return MultiRepositoryProvider(providers: [
              RepositoryProvider.value(value: storeRepository),
            ], child: const StoreReportPage());
          });
      });

      expect(find.text(_store.displayName), findsOneWidget);
    });
  });
}
