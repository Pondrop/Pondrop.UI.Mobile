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

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc(
      {required StoreRepository storeRepository,
      required LocationRepository locationRepository})
      : _storeRepository = storeRepository,
        _locationRepository = locationRepository,
        super(const StoreState()) {
    on<StoreFetched>(
      _onStoreFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<StoreRefreshed>(
      _onStoreRefresh,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final StoreRepository _storeRepository;
  final LocationRepository _locationRepository;

  Future<void> _onStoreFetched(
    StoreFetched event,
    Emitter<StoreState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == StoreStatus.initial) {
        final position = await _locationRepository
            .getLastKnownOrCurrentPosition(const Duration(minutes: 1));
        final stores = await _storeRepository.fetchStores(sortByPosition: position);

        emit(
          state.copyWith(
            status: StoreStatus.success,
            stores: stores,
            position: position,
            hasReachedMax: false,
          ),
        );
      } else {
        final stores = await _storeRepository.fetchStores(sortByPosition: state.position, skipIdx: state.stores.length);

        if (stores.isEmpty) {
          emit(state.copyWith(hasReachedMax: true));
        } else {
          emit(
            state.copyWith(
              status: StoreStatus.success,
              stores: List.of(state.stores)..addAll(stores),
              hasReachedMax: false,
            ),
          );
        }
      }
    } catch (ex) {
      log(ex.toString());
      emit(state.copyWith(status: StoreStatus.failure));
    }
  }

  Future<void> _onStoreRefresh(
    StoreRefreshed event,
    Emitter<StoreState> emit,
  ) async {
    if (state.status == StoreStatus.refreshing) {
      return;
    }

    emit(state.copyWith(status: StoreStatus.refreshing));

    try {
      final position = await _locationRepository
        .getLastKnownOrCurrentPosition(const Duration(minutes: 1));
      final stores = await _storeRepository.fetchStores(sortByPosition: position);

      emit(
        state.copyWith(
          status: StoreStatus.success,
          stores: stores,
          position: position,
          hasReachedMax: false,
        ),
      );
    } catch (ex) {
      log(ex.toString());
      emit(state.copyWith(status: StoreStatus.failure));
    }
  }
}
