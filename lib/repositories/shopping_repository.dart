import 'package:pondrop/api/shopping_api.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:uuid/uuid.dart';

class ShoppingRepository {
  ShoppingRepository(
      {required UserRepository userRepository, ShoppingApi? shoppingApi})
      : _userRepository = userRepository,
        _shoppingApi = shoppingApi ?? ShoppingApi();

  final UserRepository _userRepository;
  final ShoppingApi _shoppingApi;

  Future<List<ShoppingList>> fetchLists() async {
    await Future.delayed(const Duration(milliseconds: 1250));

    return [
      ShoppingList(
        id: const Uuid().v4().toString(),
        name: "My List 1",
        itemCount: 0,
        sortOrder: 0,
      ),
      ShoppingList(
        id: const Uuid().v4().toString(),
        name: "My List 2",
        itemCount: 0,
        sortOrder: 0,
      )
    ];

    final user = await _userRepository.getUser();

    if (user?.accessToken.isNotEmpty == true) {
      final result = await _shoppingApi.fetchLists(user!.accessToken);

      final lists = result
          .map((e) => ShoppingList(
                id: e.id,
                name: e.name,
                itemCount: e.listItemIds.length,
                sortOrder: e.sortOrder,
              ))
          .toList();

      return lists;
    }

    return const [];
  }

  Future<ShoppingList?> createList(String name, int sortOrder) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return ShoppingList(
      id: const Uuid().v4().toString(),
      name: name,
      itemCount: 0,
      sortOrder: 0,
    );

    final user = await _userRepository.getUser();

    if (user?.accessToken.isNotEmpty == true) {
      final result = await _shoppingApi.createList(user!.accessToken, name,
          sortOrder: sortOrder);

      final list = ShoppingList(
        id: result.id,
        name: result.name,
        itemCount: result.listItemIds.length,
        sortOrder: result.sortOrder,
      );

      return list;
    }

    return null;
  }

  Future<bool> deleteList(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;

    final user = await _userRepository.getUser();

    if (user?.accessToken.isNotEmpty == true) {
      return await _shoppingApi.deleteList(user!.accessToken, id);
    }

    return false;
  }

  Future<bool> updateListSortOrders(Map<String, int> listIdToSortOrder) async {
    await Future.delayed(const Duration(milliseconds: 350));
    return true;
  }

  Future<List<ShoppingListItem>> fetchListItems(String listId) async {
    await Future.delayed(const Duration(milliseconds: 350));
    return const [];
  }

  Future<ShoppingListItem> addItemToList(
      String listId, String categoryId, String name, int sortOrder) async {
    await Future.delayed(const Duration(milliseconds: 350));
    return ShoppingListItem(
        id: const Uuid().v4().toString(),
        listId: listId,
        categoryId: categoryId,
        name: name,
        sortOrder: 0);
  }

  Future<bool> checkItem(String listId, String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;

    final user = await _userRepository.getUser();

    if (listId.isNotEmpty &&
        id.isNotEmpty &&
        user?.accessToken.isNotEmpty == true) {
      //return await _shoppingApi.deleteListItem(user!.accessToken, listId, id);
    }

    return false;
  }

  Future<bool> deleteItemFromList(String listId, String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;

    final user = await _userRepository.getUser();

    if (listId.isNotEmpty &&
        id.isNotEmpty &&
        user?.accessToken.isNotEmpty == true) {
      //return await _shoppingApi.deleteListItem(user!.accessToken, listId, id);
    }

    return false;
  }

  Future<bool> updateItemSortOrders(
      String listId, Map<String, int> itemIdToSortOrder) async {
    await Future.delayed(const Duration(milliseconds: 350));
    return true;
  }
}
