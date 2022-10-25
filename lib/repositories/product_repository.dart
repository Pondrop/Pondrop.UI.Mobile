import 'package:pondrop/api/products/product_api.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:tuple/tuple.dart';

class ProductRepository {
  ProductRepository(
      {required UserRepository userRepository, ProductApi? productApi})
      : _userRepository = userRepository,
        _productApi = productApi ?? ProductApi();

  final UserRepository _userRepository;
  final ProductApi _productApi;

  Future<Tuple2<List<Product>, bool>> fetchProducts(
      String keyword, int skipIdx) async {
    final user = await _userRepository.getUser();

    if (user?.accessToken.isNotEmpty == true) {
      final searchResult = await _productApi.searchProducts(user!.accessToken,
          keyword: keyword, skipIdx: skipIdx);

      final products = searchResult.value
          .map((e) => Product(
                id: e.externalReferenceId,
                barcode: e.uniqueBarcode,
                name: e.product,
              ))
          .toList();

      return Tuple2(products, searchResult.odataNextLink.isNotEmpty);
    }

    return const Tuple2([], false);
  }

  Future<Tuple2<List<Category>, bool>> fetchCategories(
      String keyword, int skipIdx) async {
    final user = await _userRepository.getUser();

    if (user?.accessToken.isNotEmpty == true) {
      final searchResult = await _productApi.searchCategories(
          user!.accessToken,
          keyword: keyword,
          skipIdx: skipIdx);

      final categories = searchResult.value
          .map((e) => Category(
                id: e.id,
                name: e.name,
              ))
          .toList();

      return Tuple2(categories, searchResult.odataNextLink.isNotEmpty);
    }

    return const Tuple2([], false);
  }
}
