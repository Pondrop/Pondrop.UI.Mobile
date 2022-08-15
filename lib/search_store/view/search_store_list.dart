import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/search_store/view/search_store_list_item.dart';

import '../bloc/search_store_bloc.dart';
import '../../shared/view/bottom_loader.dart';

class SearchStoresList extends StatefulWidget {
  final String _header;

  const SearchStoresList(Key? key, this._header) : super(key: key);

  @override
  State<SearchStoresList> createState() => _StoresListState();
}

class _StoresListState extends State<SearchStoresList> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchStoreBloc, SearchStoreState>(
      builder: (context, state) {
        switch (state.status) {
          case SearchStoreStatus.failure:
            return const Center(child: Text('failed to fetch stores'));
          case SearchStoreStatus.success:
            if (state.stores.isEmpty) {
              return const Center(child: Text('no stores'));
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Column(children: [
                    // The header
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(15),
                      child: Text(widget._header,
                          style: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.bold)),
                    ),
                    index >= state.stores.length
                        ? const BottomLoader()
                        : SearchStoreListItem(store: state.stores[index])
                  ]);
                }
                return index >= state.stores.length
                    ? const BottomLoader()
                    : SearchStoreListItem(store: state.stores[index]);
              },
              itemCount: state.hasReachedMax
                  ? state.stores.length
                  : state.stores.length + 1,
              controller: _scrollController,
            );
          case SearchStoreStatus.initial:
              return const Center(child: Text(''));
        }
      },
    );
  }
}
