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

  Future<List<Store>> fetchStores(
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
              provider: e.provider ?? '',
              name: e.name,
              displayName: e.provider?.isNotEmpty == true
                  ? '${e.provider} ${e.name}'
                  : e.name,
              address: e.address,
              latitude: e.latitude,
              longitude: e.longitude,
              lastKnowDistanceMetres: e.distanceInMeters(sortByPosition)))
          .toList();

      return stores;
    }

    return const [];
  }
}
