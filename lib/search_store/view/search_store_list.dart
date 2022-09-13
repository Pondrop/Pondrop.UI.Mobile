import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/search_store/bloc/search_store_bloc.dart';
import 'package:pondrop/search_store/view/search_store_list_item.dart';
import 'package:pondrop/shared/view/bottom_loader.dart';
import 'package:pondrop/styles/styles.dart';

class SearchStoresList extends StatefulWidget {
  final String header;

  const SearchStoresList(Key? key, this.header) : super(key: key);

  @override
  State<SearchStoresList> createState() => _StoresListState();
}

class _StoresListState extends State<SearchStoresList> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<SearchStoreBloc, SearchStoreState>(
      builder: (context, state) {
        switch (state.status) {
          case SearchStoreStatus.failure:
            return Padding(
                padding: Dims.mediumTopEdgeInsets,
                child: Column(
                  children: [
                    SearchHeader(header: l10n.searchResults.toUpperCase()),
                    const Expanded(child: Center(child: NoResultsFound())),
                  ],
                ));
          case SearchStoreStatus.success:
            if (state.stores.isEmpty) {
              return Padding(
                padding: Dims.mediumTopEdgeInsets,
                child: Column(
                  children: [
                    SearchHeader(header: l10n.searchResults.toUpperCase()),
                    const Padding(
                        padding: Dims.xxLargeTopEdgeInsets,
                        child: Center(child: NoResultsFound())),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                  0, Dims.large, Dims.xSmall, Dims.medium),
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Column(children: [
                    // The header
                    SearchHeader(header: l10n.searchResults.toUpperCase()),
                    index >= state.stores.length
                        ? const BottomLoader()
                        : SearchStoreListItem(store: state.stores[index])
                  ]);
                }
                return index >= state.stores.length
                    ? const BottomLoader()
                    : SearchStoreListItem(store: state.stores[index]);
              },
              itemCount: state.stores.length,
              controller: _scrollController,
            );
          case SearchStoreStatus.initial:
            return const SizedBox.shrink();
        }
      },
    );
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

class SearchHeader extends StatelessWidget {
  const SearchHeader({
    Key? key,
    required this.header,
  }) : super(key: key);

  final String header;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(
          horizontal: Dims.large, vertical: Dims.medium),
      child: Text(header,
          style: TextStyle(
              color: Colors.grey[800],
              fontSize: 12.0,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w800)),
    );
  }
}
