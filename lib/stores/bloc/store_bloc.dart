import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pondrop/stores/models/store.dart';
import 'package:store_service/store_service.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../location/repositories/location_repository.dart';

part 'store_event.dart';
part 'store_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class StoreBloc extends Bloc<storeEvent, storeState> {
  StoreBloc(
      {required StoreService storeService,
      required LocationRepository locationRepository})
      : _storeService = storeService,
        _locationRepository = locationRepository,
        super(const storeState()) {
    on<storeFetched>(
      _onstoreFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final StoreService _storeService;
  final LocationRepository _locationRepository;
  Position? _position;

  Future<void> _onstoreFetched(
    storeFetched event,
    Emitter<storeState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == storeStatus.initial) {
        _position = await _locationRepository.getCurrentPosition();
        final stores = await _fetchstores();

        emit(
          state.copyWith(
            status: storeStatus.success,
            stores: stores,
            hasReachedMax: false,
          ),
        );
      } else {
        final stores = await _fetchstores(state.stores.length);
        
        if (stores == null || stores.isEmpty) {
          emit(state.copyWith(hasReachedMax: true));
        }
        else {
          emit(
            state.copyWith(
              status: storeStatus.success,
              stores: List.of(state.stores)..addAll(stores),
              hasReachedMax: false,
            ),
          );
        }
      }
    } catch (ex) {
      print(ex);
      emit(state.copyWith(status: storeStatus.failure));
    }
  }

  Future<List<Store>?> _fetchstores([int startIndex = 0]) async {
    final result = await _storeService.searchStore(
        keyword: '', geolocation: _position, index: startIndex);

    final storeList = result.value.map((StoreDto store) {
      try {
        return Store(
          id: store.id,
          name: store.name,
          address: store.address,
          latitude: store.latitude,
          longitude: store.longitude,
          distanceFromLocation: store.distanceInMeters(_position)
        );
      } on Exception catch (_, ex) {
        throw Exception(ex);
      }
    }).toList();

    return storeList;
  }

}
