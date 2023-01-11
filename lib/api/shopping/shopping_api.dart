import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pondrop/extensions/extensions.dart';
import 'package:pondrop/api/shopping/models/models.dart';
import 'package:tuple/tuple.dart';

class ShoppingApi {
  ShoppingApi({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const String _baseUrl =
      'shopping-list-service.ashyocean-bde16918.australiaeast.azurecontainerapps.io';

  final http.Client _httpClient;

  Future<List<ShoppingListDto>> fetchLists(String accessToken) async {
    final uri = Uri.https(_baseUrl, "/ShoppingList");
    final headers = _getCommonHeaders(accessToken);

    final response = await _httpClient.get(uri, headers: headers);

    response.ensureSuccessStatusCode();

    final List items = jsonDecode(response.body);
    return items.map((e) => ShoppingListDto.fromJson(e)).toList();
  }

  Future<ShoppingListDto> createList(String accessToken, String name,
      {int sortOrder = 0}) async {
    final uri = Uri.https(_baseUrl, "/ShoppingList/create");
    final headers = _getCommonHeaders(accessToken);

    final json = jsonEncode({
      'name': name,
      'shoppingListType': ShoppingListType.grocery.name,
      'sortOrder': sortOrder,
    });

    final response = await _httpClient.post(uri, headers: headers, body: json);

    response.ensureSuccessStatusCode();

    return ShoppingListDto.fromJson(jsonDecode(response.body));
  }

  Future<bool> updateLists(String accessToken,
      Map<String, Tuple2<String, int>> idToNameSortOrder) async {
    final uri = Uri.https(_baseUrl, "/ShoppingList/update");
    final headers = _getCommonHeaders(accessToken);

    final json = jsonEncode({
      "shoppingLists": idToNameSortOrder
        ..entries
            .map((e) => {
                  'id': e.key,
                  'name': e.value.item1,
                  'sortOrder': e.value.item2,
                })
            .toList()
    });

    final response = await _httpClient.put(uri, headers: headers, body: json);

    response.ensureSuccessStatusCode();

    return true;
  }

  Future<bool> deleteList(String accessToken, String id) async {
    if (id.isNotEmpty) {
      final uri = Uri.https(_baseUrl, "/ShoppingList/remove");
      final headers = _getCommonHeaders(accessToken);

      final json = jsonEncode({
        'ids': [id],
      });

      final response =
          await _httpClient.delete(uri, headers: headers, body: json);

      response.ensureSuccessStatusCode();
    }

    return true;
  }

  Future<List<ListItemDto>> fetchItems(String accessToken) async {
    final uri = Uri.https(_baseUrl, "/ListItem");
    final headers = _getCommonHeaders(accessToken);

    final response = await _httpClient.get(uri, headers: headers);

    response.ensureSuccessStatusCode();

    final List items = jsonDecode(response.body);
    return items.map((e) => ListItemDto.fromJson(e)).toList();
  }

  Map<String, String> _getCommonHeaders(String accessToken) {
    return {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
  }
}
