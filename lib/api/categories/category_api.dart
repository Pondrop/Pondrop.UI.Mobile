import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pondrop/extensions/extensions.dart';
import 'package:pondrop/api/categories/models/models.dart';

class CategoryApi {
  CategoryApi({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const String _baseUrl =
      'pondropsearchstandard.search.windows.net';

  final http.Client _httpClient;

  Future<CategorySearchResultDto> searchCategories(
    String accessToken, {
    String keyword = '',
    int skipIdx = 0,
  }) async {
    final queryParams = {
      'api-version' : '2021-04-30-Preview',
      'search' : '$keyword*',
      '\$skip' : '$skipIdx',
    };

    if (keyword.isEmpty) {
      queryParams['\$orderby'] = 'name asc';
    }

    final uri = Uri.https(_baseUrl, "/indexes/cosmosdb-index-category/docs", queryParams);  
    final headers = _getCommonHeaders(accessToken);

    final response =
        await _httpClient.get(uri, headers: headers);

    response.ensureSuccessStatusCode();

    return CategorySearchResultDto.fromJson(jsonDecode(response.body));
  }

  Map<String, String> _getCommonHeaders(String accessToken) {
    return {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $accessToken',
      'api-key': 't9qQq8k9bXhsR4VoCbJAIHYwkBrSTpE03KMKR3Kp6MAzSeAyv0pe'
    };
  }
}
