import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:pondrop/api/stores/models/store_dto.dart';

class StoreApi {
  StoreApi({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const String _baseUrl =
      'https://pondropsearchstandard.search.windows.net/';
  static const Map<String, String> _requestHeaders = {
    'Content-type': 'application/json',
    'api-key': 't9qQq8k9bXhsR4VoCbJAIHYwkBrSTpE03KMKR3Kp6MAzSeAyv0pe'
  };

  final http.Client _httpClient;

  Future<StoreSearchResultDto> searchStores({
    String keyword = '',
    int skipIdx = 0,
    Position? sortByPosition,
  }) async {
    var url =
        '${_baseUrl}indexes/azuresql-index-stores/docs?api-version=2021-04-30-Preview&search=$keyword*&\$top=20&\$skip=$skipIdx&';

    if (sortByPosition != null) {
      url +=
          '\$orderby=geo.distance(locationsort, geography\'POINT(${sortByPosition.longitude} ${sortByPosition.latitude})\') asc&';
    } else {
      url += '\$orderby=Provider,Name asc&';
    }

    final response =
        await _httpClient.get(Uri.parse(url), headers: _requestHeaders);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return StoreSearchResultDto.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load stores');
    }
  }
}
