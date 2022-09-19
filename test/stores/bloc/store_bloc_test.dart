import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/stores/bloc/store_bloc.dart';
import 'package:tuple/tuple.dart';

import '../../fake_data/fake_data.dart';

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

    test('emit stores when StoreFetched', () async {
      final stores = [ FakeStore.fakeStore() ];

      when(() => locationRepository.getLastKnownOrCurrentPosition(any()))
          .thenAnswer((invocation) => Future<Position?>.value(null));
      when(() => storeRepository.fetchStores(any(), any(), any()))
          .thenAnswer((invocation) => Future.value(Tuple2(stores, true)));      

      final bloc = StoreBloc(
        storeRepository: storeRepository,
        locationRepository: locationRepository,
      );

      bloc.add(const StoreFetched());

      await bloc.stream.firstWhere((e) => e.status != StoreStatus.loading);

      expect(bloc.state.status, StoreStatus.success);
      expect(bloc.state.stores, stores);
      expect(bloc.state.hasReachedMax, false);
    });

    test('emit stores when StoreFetched set hasReachedMax', () async {
      final stores = [ FakeStore.fakeStore() ];

      when(() => locationRepository.getLastKnownOrCurrentPosition(any()))
          .thenAnswer((invocation) => Future<Position?>.value(null));
      when(() => storeRepository.fetchStores(any(), any(), any()))
          .thenAnswer((invocation) => Future.value(Tuple2(stores, true)));      

      final bloc = StoreBloc(
        storeRepository: storeRepository,
        locationRepository: locationRepository,
      );

      bloc.add(const StoreFetched());
      await bloc.stream.firstWhere((e) => e.status != StoreStatus.loading);

      when(() => storeRepository.fetchStores(any(), any(), any()))
          .thenAnswer((invocation) => Future.value(const Tuple2([], false)));

      bloc.add(const StoreFetched());
      await bloc.stream.firstWhere((e) => e.status != StoreStatus.loading);

      verify(() => storeRepository.fetchStores(any(), any(), any())).called(2);

      expect(bloc.state.status, StoreStatus.success);
      expect(bloc.state.stores, stores);
      expect(bloc.state.hasReachedMax, true);
    });

    test('emit failure when StoreFetched throws', () async {
      final stores = [ FakeStore.fakeStore() ];

      when(() => locationRepository.getLastKnownOrCurrentPosition(any()))
          .thenAnswer((invocation) => Future<Position?>.value(null));
      when(() => storeRepository.fetchStores(any(), any(), any()))
          .thenThrow(Exception());      

      final bloc = StoreBloc(
        storeRepository: storeRepository,
        locationRepository: locationRepository,
      );

      bloc.add(const StoreFetched());
      await bloc.stream.firstWhere((e) => e.status != StoreStatus.loading);

      expect(bloc.state.status, StoreStatus.failure);
    });

    test('emit stores when StoreRefreshed', () async {
      final stores = [ FakeStore.fakeStore() ];

      when(() => locationRepository.getLastKnownOrCurrentPosition(any()))
          .thenAnswer((invocation) => Future<Position?>.value(null));
      when(() => storeRepository.fetchStores(any(), any(), any()))
          .thenAnswer((invocation) => Future.value(Tuple2(stores, true)));      

      final bloc = StoreBloc(
        storeRepository: storeRepository,
        locationRepository: locationRepository,
      );

      bloc.add(const StoreRefreshed());
      await bloc.stream.firstWhere((e) => e.status != StoreStatus.loading);

      expect(bloc.state.status, StoreStatus.success);
      expect(bloc.state.stores, stores);
      expect(bloc.state.hasReachedMax, false);
    });

    test('emit failure when StoreRefreshed throws', () async {
      final stores = [ FakeStore.fakeStore() ];

      when(() => locationRepository.getLastKnownOrCurrentPosition(any()))
          .thenAnswer((invocation) => Future<Position?>.value(null));
      when(() => storeRepository.fetchStores(any(), any(), any()))
          .thenThrow(Exception());

      final bloc = StoreBloc(
        storeRepository: storeRepository,
        locationRepository: locationRepository,
      );

      bloc.add(const StoreRefreshed());
      await bloc.stream.firstWhere((e) => e.status != StoreStatus.loading);

      expect(bloc.state.status, StoreStatus.failure);
    });
  });  
}
