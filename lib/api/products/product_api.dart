import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pondrop/extensions/extensions.dart';
import 'package:pondrop/api/products/models/models.dart';

class ProductApi {
  ProductApi({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const String _baseUrl =
      'product-service.ashyocean-bde16918.australiaeast.azurecontainerapps.io';

  final http.Client _httpClient;

  Future<ProductSearchResultDto> searchProducts(
    String accessToken, {
    String keyword = '',
    int skipIdx = 0,
  }) async {
    final queryParams = {
      'search' : '$keyword*',
      '\$skip' : '$skipIdx',
    };

    final uri = Uri.https(_baseUrl, "/Product/search", queryParams);  
    final headers = _getCommonHeaders(accessToken);

    final response =
        await _httpClient.get(uri, headers: headers);

    response.ensureSuccessStatusCode();

    return ProductSearchResultDto.fromJson(jsonDecode(response.body));
  }

  Future<CategorySearchResultDto> searchCategories(
    String accessToken, {
    String keyword = '',
    int skipIdx = 0,
  }) async {
    final queryParams = {
      'search' : '$keyword*',
      '\$skip' : '$skipIdx',
    };

    if (keyword.isEmpty) {
      queryParams['\$orderby'] = 'name asc';
    }

    final uri = Uri.https(_baseUrl, "/Category/search", queryParams);  
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
    };
  }
}
