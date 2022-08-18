import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/location/repositories/location_repository.dart';
import 'package:pondrop/search_store/bloc/search_store_bloc.dart';
import 'package:store_service/store_service.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

class MockStoreService extends Mock implements StoreService {}

void main() {
  late LocationRepository locationRepository;
  late StoreService storeService;

  setUp(() {
    locationRepository = MockLocationRepository();
    storeService = MockStoreService();
  });

  group('SearchStoreBloc', () {
    test('initial state is Initial', () {
      expect(
        SearchStoreBloc(
          storeService: storeService,
          locationRepository: locationRepository,).state,
        equals(const SearchStoreState()));
    });

    blocTest<SearchStoreBloc, SearchStoreState>(
      'state is Failure',
  
      build: () => SearchStoreBloc(
          storeService: storeService,
          locationRepository: locationRepository,),
      act: (bloc) => bloc.add(SearchStoreFetched()),
      expect: () => [const SearchStoreState(status: SearchStoreStatus.failure)],
    );

     blocTest<SearchStoreBloc, SearchStoreState>(
      'emit text when Search Text is changed',
  
      build: () => SearchStoreBloc(
          storeService: storeService,
          locationRepository: locationRepository,),
      act: (bloc) => bloc.add(const TextChanged(text: '')),
      expect: () => [],
    );
  });
}
