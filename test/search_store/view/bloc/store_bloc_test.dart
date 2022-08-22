import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/search_store/bloc/search_store_bloc.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

class MockStoreRepository extends Mock implements StoreRepository {}

void main() {
  late LocationRepository locationRepository;
  late StoreRepository storeRepository;

  setUp(() {
    locationRepository = MockLocationRepository();
    storeRepository = MockStoreRepository();
  });

  group('SearchStoreBloc', () {
    test('initial state is Initial', () {
      expect(
        SearchStoreBloc(
          storeRepository: storeRepository,
          locationRepository: locationRepository,).state,
        equals(const SearchStoreState()));
    });

     blocTest<SearchStoreBloc, SearchStoreState>(
      'emit text when Search Text is changed',
  
      build: () => SearchStoreBloc(
          storeRepository: storeRepository,
          locationRepository: locationRepository,),
      act: (bloc) => bloc.add(const TextChanged(text: '')),
      expect: () => [],
    );
  });
}
