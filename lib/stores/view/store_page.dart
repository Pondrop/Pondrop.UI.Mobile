import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pondrop/location/location.dart';
import 'package:pondrop/stores/bloc/store_bloc.dart';
import 'package:pondrop/stores/view/store_list.dart';
import 'package:store_service/store_service.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select a store'), 
      centerTitle: true, 
      backgroundColor: Colors.white, 
      foregroundColor: Colors.black,
      leading: GestureDetector(
    onTap: () { /* Write listener code here */ },
    child: Icon(
      Icons.menu,  // add custom icons also
    ),
  ),  actions: <Widget>[
    Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: () {},
        child: Icon(
          Icons.search,
          size: 26.0,
        ),
      )
    )]),
      body: BlocProvider(
        create: (_) => StoreBloc(storeService: StoreService(), locationRepository:
                  RepositoryProvider.of<LocationRepository>(context),)..add(storeFetched()),
        child: const StoresList(),
      ),
    );
  }
}