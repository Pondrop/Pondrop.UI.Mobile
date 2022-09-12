import 'package:geolocator/geolocator.dart';
import 'package:pondrop/api/stores/store_api.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';

class StoreRepository {
  StoreRepository({required UserRepository userRepository, StoreApi? storeApi})
      : _userRepository = userRepository,
        _storeApi = storeApi ?? StoreApi();

  final UserRepository _userRepository;
  final StoreApi _storeApi;

  Future<List<Store>> fetchStores({
    String keyword = '',
    int skipIdx = 0,
    Position? sortByPosition,
  }) async {
    final user = await _userRepository.getUser();

    if (user?.accessToken.isNotEmpty == true) {
      final searchResult = await _storeApi.searchStores(user!.accessToken,
          keyword: keyword, skipIdx: skipIdx, sortByPosition: sortByPosition);

      final stores = searchResult.value
          .map((e) => Store(
              id: e.id,
              provider: e.name ?? '',
              name: e.name,
              displayName: e.retailer!.name?.isNotEmpty == true
                  ? '${e.retailer!.name} ${e.name}'
                  : e.name,
              address: e.addresses?[0].addressLine1 ?? '',
              latitude: e.addresses?[0].latitude ?? 0,
              longitude: e.addresses?[0].longitude ?? 0,
              lastKnowDistanceMetres: e.addresses?[0].distanceInMeters(sortByPosition) ?? 0))
          .toList();

      return stores;
    }

    return const [];
  }
}
