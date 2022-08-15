import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/stores/view/store_list_item.dart';

import '../../shared/view/bottom_loader.dart';
import '../bloc/store_bloc.dart';

class StoresList extends StatefulWidget {
  final String _header;

  const StoresList(Key? key, this._header) : super(key: key);

  @override
  State<StoresList> createState() => _StoresListState();
}

class _StoresListState extends State<StoresList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, storeState>(
      builder: (context, state) {
        switch (state.status) {
          case storeStatus.failure:
            return const Center(child: Text('No stores found'));
          case storeStatus.success:
            if (state.stores.isEmpty) {
              return const Center(child: Text('No stores found'));
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
                        : StoreListItem(store: state.stores[index])
                  ]);
                }
                return index >= state.stores.length
                    ? const BottomLoader()
                    : StoreListItem(store: state.stores[index]);
              },
              itemCount: state.hasReachedMax
                  ? state.stores.length
                  : state.stores.length + 1,
              controller: _scrollController,
            );
          case storeStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
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
    if (_isBottom) context.read<StoreBloc>().add(storeFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
