import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/location/location.dart';
import 'package:pondrop/search_store/view/search_store_page.dart';
import 'package:pondrop/stores/bloc/store_bloc.dart';
import 'package:pondrop/stores/models/store.dart';
import 'package:pondrop/stores/view/store_list.dart';
import 'package:store_service/store_service.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

    static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const StorePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Select a store', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            leading: GestureDetector(
              onTap: () {/* Write listener code here */},
              child: const Icon(Icons.menu),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () { Navigator.push(context, SearchStorePage.route()); },
                  child: const Icon(Icons.search),
                ),
              )
            ]),
        body: BlocProvider(
          create: (_) => StoreBloc(
            storeService: 
              RepositoryProvider.of<StoreService>(context),
            locationRepository:
              RepositoryProvider.of<LocationRepository>(context),
          )..add(StoreFetched()),
          child: const StoresList(null, 'STORES NEARBY'),
        ));
  }
}
