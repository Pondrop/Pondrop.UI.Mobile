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
  late SearchStoreBloc _searchStoreBloc;

  @override
  void initState() {
    super.initState();
    _searchStoreBloc = context.read<SearchStoreBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back)),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            title: Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                    child: TextField(
                  controller: _searchTextController,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchTextController.clear();
                      _searchStoreBloc.add(
                        TextChanged(text: ''),
                      );
                        },
                      ),
                      hintText: 'Search...',
                      border: InputBorder.none), 
                      onChanged: (text) {
                      _searchStoreBloc.add(
                        TextChanged(text: text),
                      );
      },
                )))),
        body: BlocProvider(
          create: (_) => SearchStoreBloc(
            storeService: StoreService(),
            locationRepository:
                RepositoryProvider.of<LocationRepository>(context),
          )..add(TextChanged(text: _searchTextController.text)),
          child: const SearchStoresList(null, 'SUGGESTED STORES'),
        ));
  }
}
