import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pondrop/stores/models/store.dart';
import 'package:store_service/store_service.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../location/repositories/location_repository.dart';

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

    if (searchTerm.isEmpty) return;

    try {
      if (state.status == SearchStoreStatus.initial) {
        _position = await _locationRepository.getCurrentPosition();
        final stores = await _fetchstores(searchTerm, state.stores.length);

        return emit(
          state.copyWith(
            status: SearchStoreStatus.success,
            stores: stores,
            hasReachedMax: false,
          ),
        );
      } else {
        _position = await _locationRepository.getCurrentPosition();
        final stores = await _fetchstores(searchTerm, state.stores.length);
        stores!.isEmpty
            ? emit(state.copyWith(hasReachedMax: true))
            : emit(
                state.copyWith(
                  status: SearchStoreStatus.success,
                  stores: List.of(state.stores)..addAll(stores),
                  hasReachedMax: false,
                ),
              );
      }
    } catch (_) {
      emit(state.copyWith(status: SearchStoreStatus.failure));
    }
  }

  Future<List<Store>?> _fetchstores(
      [String keyword = '', int startIndex = 0]) async {
    final result = await _storeService.searchStore(
        keyword: keyword, geolocation: _position, index: startIndex);

    final storeList = result.value?.map((Value store) {
      try {
        return Store(
            id: store.id!,
            name: store.name!,
            address: store.address!,
            latitude: store.latitude!,
            longitude: store.longitude!,
            distanceFromLocation: store.distanceInMeters(_position!));
      } on Exception catch (_, ex) {
        throw Exception(ex);
      }
    }).toList();

    return storeList;
  }
}
