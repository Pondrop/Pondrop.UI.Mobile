import 'package:geolocator/geolocator.dart';
import 'package:pondrop/api/stores/store_api.dart';
import 'package:pondrop/models/models.dart';

class StoreRepository {
  StoreRepository({StoreApi? storeApi})
      : _storeApi = storeApi ?? StoreApi();

  final StoreApi _storeApi;

 Future<List<Store>> fetchStores({
    String keyword = '',    
    int skipIdx = 0,
    Position? sortByPosition,
  }) async {
    final searchResult = await _storeApi.searchStores(
      keyword: keyword,
      skipIdx: skipIdx,
      sortByPosition: sortByPosition);

    final stores = searchResult.value.map((e) => Store(
      id: e.id,
      provider: e.provider ?? '',
      name: e.name,
      displayName: e.provider?.isNotEmpty == true 
        ? '${e.provider} ${e.name}'
        : e.name,
      address: e.address,
      latitude: e.latitude,
      longitude: e.longitude,
      lastKnowDistanceMetres: e.distanceInMeters(sortByPosition)
    )).toList();

    return stores;
  }
}