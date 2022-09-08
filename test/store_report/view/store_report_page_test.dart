import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/store_report/view/store_report_page.dart';

import '../../helpers/helpers.dart';

class MockStoreRepository extends Mock implements StoreRepository {}

class MockSubmissionRepository extends Mock implements SubmissionRepository {}

class MockLocationRepository extends Mock implements LocationRepository {}

void main() {
  late StoreRepository storeRepository;
  late SubmissionRepository submissionRepository;
  late LocationRepository locationRepository;

  late Store store;

  setUp(() {
    storeRepository = MockStoreRepository();
    submissionRepository = MockSubmissionRepository();
    locationRepository = MockLocationRepository();

    store = const Store(
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
      expect(StoreReportPage.route(store), isA<MaterialPageRoute>());
    });

    testWidgets('renders a Store Report page', (tester) async {
      when(() => submissionRepository.submissions)
          .thenAnswer((invocation) => Stream.fromIterable([]));
      when(() => submissionRepository.startStoreVisit(any(), any()))
          .thenAnswer((invocation) => Future.value(null));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((invocation) => Future.value(null));

      await tester.pumpAppWithRoute((settings) {
        return MaterialPageRoute(
            settings: RouteSettings(arguments: store),
            builder: (context) {
              return MultiRepositoryProvider(providers: [
                RepositoryProvider.value(value: storeRepository),
                RepositoryProvider.value(value: submissionRepository),
                RepositoryProvider.value(value: locationRepository),                
              ], child: const StoreReportPage());
            });
      });

      expect(find.text(store.displayName), findsOneWidget);
    });
  });
}
