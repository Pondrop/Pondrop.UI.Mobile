import 'package:flutter/material.dart';
import 'package:pondrop/features/search_items/widgets/search_bloc_provider.dart';
import 'package:pondrop/features/search_items/widgets/search_item_input.dart';
import 'package:pondrop/features/styles/styles.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/features/search_items/search_items.dart';

class SearchItemPage extends StatelessWidget {
  const SearchItemPage(
      {Key? key,
      required this.type,
      required this.enableBack,
      this.excludedIds = const [],
      this.categoryRepository,
      this.productRepository})
      : super(key: key);

  static const searchTextFieldKey = Key('SearchItemPage_SearchText_Key');

  final SearchItemType type;
  final bool enableBack;

  final List<String> excludedIds;

  final CategoryRepository? categoryRepository;
  final ProductRepository? productRepository;

  static Route<List<SearchItem>> route(
      {required SearchItemType type,
      bool enableBack = true,
      List<String> excludeIds = const [],
      CategoryRepository? categoryRepository,
      ProductRepository? productRepository}) {
    return RouteTransitions.modalSlideRoute<List<SearchItem>>(
        pageBuilder: (_) => SearchItemPage(
              type: type,
              enableBack: enableBack,
              excludedIds: excludeIds,
              categoryRepository: categoryRepository,
              productRepository: productRepository,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SearchBlocProvider(
        type: type,
        categoryRepository: categoryRepository,
        productRepository: productRepository,
        child: WillPopScope(
          onWillPop: () async => enableBack,
          child: Scaffold(
            appBar: AppBar(
                leading: enableBack ? null : const Icon(Icons.search),
                title: SearchItemInput(type: type)),
            body: SearchItemsList(
                header: context.l10n.searchResults.toUpperCase(),
                onTap: (BuildContext context, SearchItem item) async {
                  Navigator.of(context).pop([item]);
                },
                excludedIds: excludedIds),
          ),
        ));
  }
}
