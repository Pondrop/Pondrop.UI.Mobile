import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pondrop/api/extensions/extensions.dart';
import 'package:pondrop/api/products/models/models.dart';

class ProductApi {
  ProductApi({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const String _baseUrl =
      'pondropsearchstandard.search.windows.net';

  final http.Client _httpClient;

  Future<ProductSearchResultDto> searchProducts(
    String accessToken, {
    String keyword = '',
    int skipIdx = 0,
  }) async {
    final queryParams = {
      'api-version' : '2021-04-30-Preview',
      'search' : '$keyword*',
      '\$top' : '20',
      '\$skip' : '$skipIdx',
    };

    final uri = Uri.https(_baseUrl, "/indexes/azuresql-index-allproducts/docs", queryParams);  
    final headers = _getCommonHeaders(accessToken);

    final response =
        await _httpClient.get(uri, headers: headers);

    response.ensureSuccessStatusCode();

    return ProductSearchResultDto.fromJson(jsonDecode(response.body));
  }

  Map<String, String> _getCommonHeaders(String accessToken) {
    return {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $accessToken',
      'api-key': 't9qQq8k9bXhsR4VoCbJAIHYwkBrSTpE03KMKR3Kp6MAzSeAyv0pe'
    };
  }
}
