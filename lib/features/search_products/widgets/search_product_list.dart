import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/features/search_products/bloc/search_product_bloc.dart';
import 'package:pondrop/features/search_products/widgets/search_product_list_item.dart';
import 'package:pondrop/features/global/widgets/bottom_loader.dart';
import 'package:pondrop/features/styles/styles.dart';

class SearchProductList extends StatefulWidget {
  final String header;

  const SearchProductList(Key? key, this.header) : super(key: key);

  @override
  State<SearchProductList> createState() => _SearchProductListState();
}

class _SearchProductListState extends State<SearchProductList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      onRefresh: () {
        final bloc = context.read<SearchProductBloc>()..add(const SearchProductRefreshed());
        return bloc.stream.firstWhere((e) => e.status != SearchProductStatus.loading);
      },
      child: BlocBuilder<SearchProductBloc, SearchProductState>(
        builder: (context, state) {
          switch (state.status) {
            case SearchProductStatus.failure:
              return const Center(child: NoResultsFound());
            case SearchProductStatus.loading:
            case SearchProductStatus.success:
              if (state.products.isEmpty &&
                  state.status != SearchProductStatus.loading) {
                return const Center(child: NoResultsFound());
              }

              return Scrollbar(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                      0, Dims.large, Dims.xSmall, Dims.medium),
                  itemBuilder: (BuildContext context, int index) {
                    if (index >= state.products.length) {
                      return const BottomLoader();
                    }
              
                    return index >= state.products.length
                        ? const BottomLoader()
                        : SearchProductListItem(product: state.products[index]);
                  },
                  itemCount: state.hasReachedMax
                      ? state.products.length
                      : state.products.length + 1,
                  controller: _scrollController,
                ),
              );
            case SearchProductStatus.initial:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<SearchProductBloc>().add(const SearchProductFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}

class NoResultsFound extends StatelessWidget {
  const NoResultsFound({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.noResultsFound,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          Padding(
              padding: Dims.xSmallTopEdgeInsets,
              child: Center(child: Text(l10n.tryAgainUsingOtherSearchTerms))),
        ]);
  }
}
