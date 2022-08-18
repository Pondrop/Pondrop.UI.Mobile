import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:store_service/store_service.dart';

class MockStoreService extends Mock implements StoreService {}

void main() {
  late StoreService storeService;
  final position = Position(
      longitude: 1,
      latitude: 1,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1);

  setUp(() {
    storeService = MockStoreService();
  });

  group('Store Service', () {
    void checkSearchStore(
        String keyword, Position? geolocation, int index) async {
      // Given
      List<StoreDto> stores = <StoreDto>[];
      for (var i = index; i >= 1; i--) {
        stores.add(StoreDto(
            address: '',
            banner: '',
            city: '',
            country: '',
            directionUrl: '',
            email: '',
            fax: '',
            id: '',
            keyphrases: [],
            latitude: 1,
            location: '',
            locations: [],
            longitude: 1,
            name: '',
            openHours: '',
            phone: '',
            provider: '',
            searchScore: 1,
            state: '',
            status: '',
            stockTicker: '',
            storeNo: null,
            street: '',
            updatedDate: DateTime.now(),
            url: '',
            zipCode: ''));
      }

      final storeSearchResult = StoreSearchResult(
          odataContext: '1', value: <StoreDto>[], odataNextLink: '1');

      when(() => storeService.searchStore(
          keyword: keyword,
          geolocation: geolocation,
          index: index)).thenAnswer((_) => Future.value(storeSearchResult));

      // When
      final result = await storeService.searchStore(
          keyword: keyword, geolocation: geolocation, index: index);

      // Then
      verify(() => storeService.searchStore(
          keyword: keyword, geolocation: geolocation, index: index)).called(1);

      expect(result, storeSearchResult);
    }

    test(
        "Given store service search store, When keyword and geolocation is empty, Then storeSearchResult is returned",
        () {
      checkSearchStore('', null, 1);
    });

    test(
        "Given store service search store, When geolocation is empty, Then storeSearchResult is returned",
        () {
      checkSearchStore('Test', null, 1);
    });

    test(
        "Given store service search store, When geolocation is empty, Then storeSearchResult is returned",
        () {
      checkSearchStore('', position, 1);
    });
    
  });
}
