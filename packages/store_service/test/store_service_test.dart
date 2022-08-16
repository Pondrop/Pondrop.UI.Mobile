import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:store_service/store_service.dart';

class MockStoreService extends Mock implements StoreService {}

void main() {
  late StoreService storeService;

  setUp(() {
    storeService = MockStoreService();
  });

  group('Store Service', () {
    test(
        "Given store service returns list of StoreData, When searchStore is called, Then storeSearchResult is returned",
        () async {
      // Given
      final storeSearchResult = StoreSearchResult(
          odataContext: '1', value: <StoreDto>[], odataNextLink: '1');

      when(() => storeService.searchStore(
          keyword: '',
          geolocation: null,
          index: 1)).thenAnswer((_) => Future.value(storeSearchResult));

      // When
      final result = await storeService.searchStore(
          keyword: '', geolocation: null, index: 1);

      // Then
      verify(() => storeService.searchStore(
          keyword: '', geolocation: null, index: 1)).called(1);
          
    expect(result, storeSearchResult);
    });

  });
}
