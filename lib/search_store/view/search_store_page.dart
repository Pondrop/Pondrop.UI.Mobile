import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/location/location.dart';
import 'package:pondrop/search_store/view/search_store_list.dart';
import 'package:store_service/store_service.dart';

import '../bloc/search_store_bloc.dart';

class SearchStorePage extends StatefulWidget {
  const SearchStorePage({Key? key}) : super(key: key);

  @override
  State<SearchStorePage> createState() => SearchStoreState();

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SearchStorePage());
  }
}

class SearchStoreState extends State<SearchStorePage> {
  final _searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => SearchStoreBloc(
              storeService:
                RepositoryProvider.of<StoreService>(context),
              locationRepository:
                RepositoryProvider.of<LocationRepository>(context),
            ),
        child: Scaffold(
          appBar: AppBar(
              titleSpacing: 0,
              leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back)),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              title: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Center(child: _searchTextField()))),
          body: const SearchStoresList(null, 'SEARCH RESULTS'),
        ));
  }

  Builder _searchTextField() {
    return Builder(builder: (context) {
      return TextField(
        style: const TextStyle(fontSize: 20, color: Colors.black),
        controller: _searchTextController,
        decoration: InputDecoration(
            suffixIcon: IconButton(
              focusColor: Colors.black,
              color: Colors.black,
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchTextController.clear();
                context
                    .read<SearchStoreBloc>()
                    .add(const TextChanged(text: ''));
              },
            ),
            hintText: 'Search',
            hintStyle: TextStyle(fontSize: 20, color: Colors.grey[500]),
            border: InputBorder.none,
            focusedBorder: InputBorder.none),
        onChanged: (text) {
          context.read<SearchStoreBloc>().add(TextChanged(text: text));
        },
      );
    });
  }
}
