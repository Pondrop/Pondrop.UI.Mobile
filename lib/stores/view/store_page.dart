import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pondrop/app/view/loading_overlay.dart';
import 'package:pondrop/authentication/bloc/authentication_bloc.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/search_products/search_product.dart';
import 'package:pondrop/search_store/view/search_store_page.dart';
import 'package:pondrop/stores/bloc/store_bloc.dart';
import 'package:pondrop/stores/view/store_list.dart';
import 'package:pondrop/styles/styles.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const StorePage());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final email = context.read<AuthenticationBloc>().state.user.email;

    return Scaffold(
        appBar: AppBar(
            title: Text(l10n.selectAItem(l10n.store.toLowerCase()),
                style: PondropStyles.appBarTitleTextStyle),
            actions: <Widget>[
              Padding(
                padding: Dims.mediumRightEdgeInsets,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, SearchStorePage.route());
                  },
                  child: const Icon(Icons.search),
                ),
              )
            ],
            centerTitle: true),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                leading: SvgPicture.asset(
                  'assets/pondrop.svg',
                  height: 24,
                ),
                dense: true,
              ),
              ListTile(
                leading: const Icon(Icons.account_circle_outlined),
                minLeadingWidth: 0,
                title: Text(email,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 12, fontWeight: FontWeight.w400)),
                dense: true,
              ),
              ListTile(
                leading: const Icon(Icons.storefront),
                title: Text(l10n.shopping),
                selected: true,
                selectedColor: Colors.black,
                selectedTileColor: PondropColors.selectedListItemColor,
              ),
              ListTile(
                leading: const Icon(Icons.local_offer_outlined),
                title: Text(l10n.products),
                selectedColor: Colors.black,
                iconColor: Colors.black,
                selectedTileColor: PondropColors.selectedListItemColor,
                onTap: () {
                  Navigator.of(context).push(SearchProductPage.route());
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart_checkout),
                title: Text(l10n.barcodeScan),
                selectedColor: Colors.black,
                iconColor: Colors.black,
                selectedTileColor: PondropColors.selectedListItemColor,
                onTap: () {
                  Navigator.of(context).push(BarcodeScannerPage.route(false));
                },
              ),
              BlocListener<AuthenticationBloc, AuthenticationState>(
                listenWhen: (previous, current) =>
                    previous.isLoggingOut != current.isLoggingOut,
                listener: (context, state) {
                  if (state.isLoggingOut) {
                    LoadingOverlay.of(context)
                        .show(l10n.itemEllipsis(l10n.loggingOut));
                  } else {
                    LoadingOverlay.of(context).hide();
                  }
                },
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Theme.of(context).errorColor,
                  ),
                  title: Text(
                    l10n.logOut,
                    style: TextStyle(color: Theme.of(context).errorColor),
                  ),
                  onTap: () => context
                      .read<AuthenticationBloc>()
                      .add(AuthenticationLogoutRequested()),
                ),
              ),
            ],
          ),
        ),
        body: BlocProvider(
          create: (_) => StoreBloc(
            storeRepository: RepositoryProvider.of<StoreRepository>(context),
            locationRepository:
                RepositoryProvider.of<LocationRepository>(context),
          )..add(const StoreFetched()),
          child: StoresList(null, l10n.storesNearby.toUpperCase()),
        ));
  }
}
