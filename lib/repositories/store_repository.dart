import 'package:geolocator/geolocator.dart';
import 'package:pondrop/api/stores/store_api.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:tuple/tuple.dart';

class StoreRepository {
  StoreRepository({required UserRepository userRepository, StoreApi? storeApi})
      : _userRepository = userRepository,
        _storeApi = storeApi ?? StoreApi();

  final UserRepository _userRepository;
  final StoreApi _storeApi;

  Future<Tuple2<List<Store>, bool>> fetchStores(
    String keyword,
    int skipIdx,
    Position? sortByPosition,
  ) async {
    final user = await _userRepository.getUser();

    if (user?.accessToken.isNotEmpty == true) {
      final searchResult = await _storeApi.searchStores(user!.accessToken,
          keyword: keyword, skipIdx: skipIdx, sortByPosition: sortByPosition);

      final stores = searchResult.value
          .map((e) => Store(
              id: e.id,
              provider: e.name,
              name: e.name,
              displayName: e.retailer?.name?.isNotEmpty == true
                  ? '${e.retailer!.name} ${e.name}'
                  : e.name,
              address: '${e.addressLine1}, ${e.suburb}, ${e.state}, ${e.postcode}',
              latitude: e.latitude,
              longitude: e.longitude,
              lastKnowDistanceMetres: e.distanceInMeters(sortByPosition)))
          .toList();

      return Tuple2(stores, searchResult.odataNextLink.isNotEmpty);
    }

    return const Tuple2([], false);
  }
}
