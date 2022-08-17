import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pondrop/location/repositories/location_repository.dart';
import 'package:pondrop/stores/models/store.dart';
import 'package:store_service/store_service.dart';
import 'package:stream_transform/stream_transform.dart';

part 'search_store_event.dart';
part 'search_store_state.dart';

const throttleDuration = Duration(milliseconds: 300);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class SearchStoreBloc extends Bloc<SearchStoreEvent, SearchStoreState> {
  SearchStoreBloc(
      {required StoreService storeService,
      required LocationRepository locationRepository})
      : _storeService = storeService,
        _locationRepository = locationRepository,
        super(const SearchStoreState()) {
    on<TextChanged>(_onSearchStore, transformer: debounce(throttleDuration));
  }

  final StoreService _storeService;
  final LocationRepository _locationRepository;
  Position? _position;

  Future<void> _onSearchStore(
      TextChanged event, Emitter<SearchStoreState> emit) async {
    final searchTerm = event.text;

    if (searchTerm.isEmpty) {
      emit(
          state.copyWith(
            status: SearchStoreStatus.initial,
            stores: <Store>[],
          ),
        );

        return;
    }

    try {
      _position = await _locationRepository.getLastKnownOrCurrentPosition(const Duration(minutes: 1));
      final stores = await _fetchstores(searchTerm);

      if (stores == null || stores.isEmpty) {
        emit(state.copyWith(
            status: SearchStoreStatus.success,
            stores: <Store>[],
          ));
      } else {
        emit(
          state.copyWith(
            status: SearchStoreStatus.success,
            stores: stores,
          ),
        );
      }
    } catch (ex) {
      emit(state.copyWith(status: SearchStoreStatus.failure));
    }
  }

  Future<List<Store>?> _fetchstores(
      [String keyword = '', int startIndex = 0]) async {
    final result = await _storeService.searchStore(
        keyword: keyword, geolocation: _position, index: startIndex);

    final storeList = result.value.map((StoreDto store) {
      return Store(
          id: store.id,
          name: store.name,
          address: store.address,
          latitude: store.latitude,
          longitude: store.longitude,
          lastKnowDistanceMetres: store.distanceInMeters(_position));
    }).toList();

    return storeList;
  }
}
