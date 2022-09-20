import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:stream_transform/stream_transform.dart';

part 'store_event.dart';
part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc(
      {required StoreRepository storeRepository,
      required LocationRepository locationRepository})
      : _storeRepository = storeRepository,
        _locationRepository = locationRepository,
        super(const StoreState()) {
    on<StoreFetched>(_onStoreFetched);
    on<StoreRefreshed>(_onStoreRefresh);
  }

  final StoreRepository _storeRepository;
  final LocationRepository _locationRepository;

  Future<void> _onStoreFetched(
    StoreFetched event,
    Emitter<StoreState> emit,
  ) async {
    if (state.hasReachedMax || state.status == StoreStatus.loading) {
      return;
    }

    try {
      emit(state.copyWith(status: StoreStatus.loading));

      final position = state.stores.isEmpty
          ? await _locationRepository
              .getLastKnownOrCurrentPosition(const Duration(minutes: 1))
          : state.position;
      final stores =
          await _storeRepository.fetchStores('', state.stores.length, position);

      emit(
        state.copyWith(
          status: StoreStatus.success,
          stores: List.of(state.stores)..addAll(stores.item1),
          position: position,
          hasReachedMax: !stores.item2,
        ),
      );
    } catch (ex) {
      log(ex.toString());
      emit(state.copyWith(status: StoreStatus.failure));
    }
  }

  Future<void> _onStoreRefresh(
    StoreRefreshed event,
    Emitter<StoreState> emit,
  ) async {
    if (state.status == StoreStatus.loading) {
      return;
    }

    emit(state.copyWith(status: StoreStatus.loading));

    try {
      final position = await _locationRepository
          .getLastKnownOrCurrentPosition(const Duration(minutes: 1));
      final stores = await _storeRepository.fetchStores('', 0, position);

      emit(
        state.copyWith(
          status: StoreStatus.success,
          stores: List.of(state.stores)..addAll(stores.item1),
          position: position,
          hasReachedMax: !stores.item2,
        ),
      );
    } catch (ex) {
      log(ex.toString());
      emit(state.copyWith(status: StoreStatus.failure));
    }
  }
}
