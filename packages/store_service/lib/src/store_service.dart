import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:store_service/store_service.dart';

const String azureSearchBaseURL =
    'https://pondropsearchstandard.search.windows.net/';
const Map<String, String> requestHeaders = {
  'Content-type': 'application/json',
  'api-key': 't9qQq8k9bXhsR4VoCbJAIHYwkBrSTpE03KMKR3Kp6MAzSeAyv0pe'
};

class StoreService {
  Future<StoreSearchResult> searchStore({
    required String keyword,
    required Position? geolocation,
    required int index,
  }) async {
    final response = await http.get(
        Uri.parse(
            '${azureSearchBaseURL}indexes/azuresql-index-vwstores/docs?api-version=2021-04-30-Preview&search=$keyword*&\$top=20&\$skip=$index&'),
        headers: requestHeaders);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return StoreSearchResult.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load store');
    }
  }
}
