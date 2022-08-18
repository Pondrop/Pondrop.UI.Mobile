import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/location/repositories/location_repository.dart';
import 'package:pondrop/login/login.dart';
import 'package:pondrop/stores/bloc/store_bloc.dart';
import 'package:store_service/store_service.dart';
import 'package:user_repository/user_repository.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

class MockStoreService extends Mock implements StoreService {}

void main() {
  late LocationRepository locationRepository;
  late StoreService storeService;

  setUp(() {
    locationRepository = MockLocationRepository();
    storeService = MockStoreService();
  });

  group('StoreBloc', () {
    test('initial state is Initial', () {
      expect(
        StoreBloc(
          storeService: storeService,
          locationRepository: locationRepository,).state,
        equals(const StoreState()));
    });

    blocTest<StoreBloc, StoreState>(
      'state is Failure',
  
      build: () => StoreBloc(
          storeService: storeService,
          locationRepository: locationRepository,),
      act: (bloc) => bloc.add(const StoreFetched()),
      expect: () => [const StoreState(status: StoreStatus.failure)],
    );
  });
}
