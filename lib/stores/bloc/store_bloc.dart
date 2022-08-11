import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:pondrop/stores/models/store.dart';
import 'package:store_service/store_service.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../location/repositories/location_repository.dart';

part 'store_event.dart';
part 'store_state.dart';

const _storeLimit = 20;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class StoreBloc extends Bloc<storeEvent, storeState> {
  StoreBloc({required StoreService storeService, required LocationRepository locationRepository}) : _storeService = storeService, _locationRepository = locationRepository, super(const storeState()) {
    on<storeFetched>(
      _onstoreFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

final StoreService _storeService;
final LocationRepository _locationRepository;
  
  Future<void> _onstoreFetched(
    storeFetched event,
    Emitter<storeState> emit,
  ) async {
    // if (state.hasReachedMax) return;
    try {
      if (state.status == storeStatus.initial) {
        final stores = await _fetchstores();
        return emit(
          state.copyWith(
            status: storeStatus.success,
            stores: stores,
            hasReachedMax: false,
          ),
        );
      }
      else  {
      final stores = await _fetchstores(state.stores.length);
      stores!.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: storeStatus.success,
                stores: List.of(state.stores)..addAll(stores),
                hasReachedMax: false,
              ),
            );
            }
    } catch (_) {
      emit(state.copyWith(status: storeStatus.failure));
    }
  }

Future<List<Store>?> _fetchstores([int startIndex = 0]) async {
      final position = await _locationRepository.getCurrentPosition();
      final result = await _storeService.searchStore(keyword: '', geolocation: position, index: startIndex);
    
      final storeList = result.value?.map((Value store) {
        try{
        return Store(
          id: store.id as String,
          name: store.name  as String,
          address: store.address  as String,
          // location: position
        );
        }
        on Exception catch (_, ex){
          throw Exception(ex);
        }
      }).toList();

      return storeList;

    // if (response.statusCode == 200) {
    //   final body = json.decode(response.body) as List;
    //   return body.map((dynamic json) {
    //     final map = json as Map<String, dynamic>;
    //     return Store(
    //       id: map['id'] as int,
    //       title: map['title'] as String,
    //       body: map['body'] as String,
    //     );
    //   }).toList();
    // }
    // throw Exception('error fetching stores');
  }
}