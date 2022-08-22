import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pondrop/authentication/bloc/authentication_bloc.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/search_store/view/search_store_page.dart';
import 'package:pondrop/stores/bloc/store_bloc.dart';
import 'package:pondrop/stores/view/store_list.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

    static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const StorePage());
  }

  @override
  Widget build(BuildContext context) {
    final email = context.read<AuthenticationBloc>().state.user.email;

    return Scaffold(
        appBar: AppBar(
            title: const Text('Select a store', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () { Navigator.push(context, SearchStorePage.route()); },
                  child: const Icon(Icons.search),
                ),
              )
            ]),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                leading: SvgPicture.asset(
                  'assets/pondrop.svg',
                  height: 24,),
                dense: true,
              ),
              ListTile(
                leading: const Icon(Icons.account_circle_outlined),
                minLeadingWidth: 0,
                title: Text(
                  email,
                  style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                fontSize: 12, fontWeight: FontWeight.w400)),
                dense: true,
              ),
              const ListTile(
                leading: Icon(Icons.storefront),
                title: Text('Shopping'),
                selected: true,
                selectedColor: Colors.black,
                selectedTileColor: Color(0x88C9E6FF),
              ),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Theme.of(context).errorColor,),
                title: Text(
                  'Log out',
                  style: TextStyle(color: Theme.of(context).errorColor),),
                onTap: () => context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested()),
              ),
            ],
          ),

        ),
        body: BlocProvider(
          create: (_) => StoreBloc(
            storeRepository: 
              RepositoryProvider.of<StoreRepository>(context),
            locationRepository:
              RepositoryProvider.of<LocationRepository>(context),
          )..add(const StoreFetched()),
          child: const StoresList(null, 'STORES NEARBY'),
        ));
  }
}
