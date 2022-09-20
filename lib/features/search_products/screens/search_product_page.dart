import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/features/search_products/bloc/search_product_bloc.dart';
import 'package:pondrop/features/search_products/search_product.dart';
import 'package:pondrop/features/search_products/widgets/search_product_list.dart';

class SearchProductPage extends StatefulWidget {
  const SearchProductPage({Key? key}) : super(key: key);

  static const searchTextFieldKey = Key('SearchProductPage_SearchText_Key');

  @override
  State<SearchProductPage> createState() => _SearchProductPageState();

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SearchProductPage());
  }
}

class _SearchProductPageState extends State<SearchProductPage> {
  final _searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => SearchProductBloc(
              productRepository:
                  RepositoryProvider.of<ProductRepository>(context),
            ),
        child: Scaffold(
          appBar: AppBar(title: _searchTextField()),
          body:
              SearchProductList(null, context.l10n.searchResults.toUpperCase()),
        ));
  }

  Builder _searchTextField() {
    return Builder(builder: (context) {
      final l10n = context.l10n;
      return TextField(
        key: SearchProductPage.searchTextFieldKey,
        style: const TextStyle(fontSize: 20, color: Colors.black),
        controller: _searchTextController,
        decoration: InputDecoration(
            suffixIcon: BlocBuilder<SearchProductBloc, SearchProductState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state.query.isNotEmpty)
                      IconButton(
                        tooltip: l10n.clear,
                        focusColor: Colors.black,
                        color: Colors.black,
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchTextController.clear();
                          context
                              .read<SearchProductBloc>()
                              .add(const TextChanged(text: ''));
                        },
                      ),
                    IconButton(
                      tooltip: l10n.barcode,
                      focusColor: Colors.black,
                      color: Colors.black,
                      icon: SvgPicture.asset('assets/barcode_scanner.svg'),
                      onPressed: () async {
                        final bloc = context.read<SearchProductBloc>();
                        final barcode = await Navigator.of(context)
                            .push(BarcodeScannerPage.route());
                        if (barcode?.isNotEmpty == true) {
                          _searchTextController.text = barcode!;
                          bloc.add(TextChanged(text: barcode));
                        }
                      },
                    )
                  ],
                );
              },
            ),
            hintText: l10n.searchProductNameOrBarcode,
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey[500]),
            border: InputBorder.none,
            focusedBorder: InputBorder.none),
        onChanged: (text) {
          context.read<SearchProductBloc>().add(TextChanged(text: text));
        },
      );
    });
  }
}
