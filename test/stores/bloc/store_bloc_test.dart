import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/stores/bloc/store_bloc.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

class MockStoreRepository extends Mock implements StoreRepository {}

void main() {
  late LocationRepository locationRepository;
  late StoreRepository storeRepository;

  setUp(() {
    locationRepository = MockLocationRepository();
    storeRepository = MockStoreRepository();
  });

  group('StoreBloc', () {
    test('initial state is Initial', () {
      expect(
        StoreBloc(
          storeRepository: storeRepository,
          locationRepository: locationRepository,).state,
        equals(const StoreState()));
    });

    blocTest<StoreBloc, StoreState>(
      'state is Failure',
  
      build: () => StoreBloc(
          storeRepository: storeRepository,
          locationRepository: locationRepository,),
      act: (bloc) => bloc.add(const StoreFetched()),
      expect: () => [const StoreState(status: StoreStatus.failure)],
    );
  });
}
