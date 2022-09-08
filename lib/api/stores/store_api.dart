import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:pondrop/api/stores/models/store_dto.dart';

class StoreApi {
  StoreApi({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const String _baseUrl =
      'store-service.ashyocean-bde16918.australiaeast.azurecontainerapps.io';

  final http.Client _httpClient;

  Future<StoreSearchResultDto> searchStores(
    String accessToken, {
    String keyword = '',
    int skipIdx = 0,
    Position? sortByPosition,
  }) async {
    final queryParams = { 
      'search' : '$keyword*',
      '\$top' : '20',
      '\$skip' : '$skipIdx',
      '\$orderby' : sortByPosition != null
        ? 'geo.distance(locationsort, geography\'POINT(${sortByPosition.longitude} ${sortByPosition.latitude})\') asc'
        : '\$orderby=Provider,Name asc&'
    };

    final uri = Uri.https(_baseUrl, "/Store/search", queryParams);  
    final headers = _getCommonHeaders(accessToken);

    final response =
        await _httpClient.get(uri, headers: headers);

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

  Map<String, String> _getCommonHeaders(String accessToken) {
    return {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
  }
}
