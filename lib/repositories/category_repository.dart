import 'package:pondrop/api/categories/category_api.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:tuple/tuple.dart';

class CategoryRepository {
  CategoryRepository({required UserRepository userRepository, CategoryApi? categoryApi})
      : _userRepository = userRepository,
        _categoryApi = categoryApi ?? CategoryApi();

  final UserRepository _userRepository;
  final CategoryApi _categoryApi;

  Future<Tuple2<List<Category>, bool>> fetchCategories(
    String keyword,
    int skipIdx
  ) async {
    final user = await _userRepository.getUser();

    if (user?.accessToken.isNotEmpty == true) {
      final searchResult = await _categoryApi.searchCategories(user!.accessToken,
          keyword: keyword, skipIdx: skipIdx);

      final categories = searchResult.value
          .map((e) => Category(
              id: e.id,
              name: e.name,
          )).toList();

      return Tuple2(categories, searchResult.odataNextLink.isNotEmpty);
    }

    return const Tuple2([], false);
  }
}
