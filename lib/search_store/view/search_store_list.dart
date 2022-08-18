import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/search_store/bloc/search_store_bloc.dart';
import 'package:pondrop/search_store/view/search_store_list_item.dart';
import 'package:pondrop/shared/view/bottom_loader.dart';

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
    return BlocBuilder<SearchStoreBloc, SearchStoreState>(
      builder: (context, state) {
        switch (state.status) {
          case SearchStoreStatus.failure:
            return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: const [
                      SearchHeader(header: 'SEARCH RESULTS'),
                      Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: NoResultsFound())
                    ],
                  ));
          case SearchStoreStatus.success:
            if (state.stores.isEmpty) {
              return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: const [
                      SearchHeader(header: 'SEARCH RESULTS'),
                      Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: NoResultsFound())
                    ],
                  ));
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(0, 15, 5, 10),
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Column(children: [
                    // The header
                    const SearchHeader(header: "SEARCH RESULTS"),
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
            return const Center(child: Text(''));
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
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const Center(
          child: Text(
        'No results found',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      )),
      const Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Center(child: Text('Try again using other search terms.'))),
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
      padding: const EdgeInsets.all(15),
      child: Text(header,
          style: TextStyle(
              color: Colors.grey[800],
              fontSize: 12.0,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w800)),
    );
  }
}
