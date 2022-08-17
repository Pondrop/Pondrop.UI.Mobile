import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/shared/view/bottom_loader.dart';
import 'package:pondrop/stores/bloc/store_bloc.dart';
import 'package:pondrop/stores/view/store_list_item.dart';

class StoresList extends StatefulWidget {
  final String header;

  const StoresList(Key? key, this.header) : super(key: key);

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
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      onRefresh: () {
        final bloc = context.read<StoreBloc>()..add(const StoreRefreshed());
        return bloc.stream.firstWhere((e) => e.status != StoreStatus.refreshing);
      },
      child: BlocBuilder<StoreBloc, StoreState>(
        buildWhen: (previous, current) => current.status != StoreStatus.refreshing,
        builder: (context, state) {
          if (state.status == StoreStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == StoreStatus.failure || state.stores.isEmpty) {
            return const Center(child: Text('No stores found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(0, 15, 5, 10),
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Column(children: [
                  // The header
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(15),
                    child: Text(widget.header,
                        style: TextStyle(
                            color: Colors.grey[800],
                            letterSpacing: 0.5,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold)),
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
    if (_isBottom) context.read<StoreBloc>().add(StoreFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
