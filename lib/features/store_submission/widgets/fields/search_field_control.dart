import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/features/search_products/screens/search_product_page.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:tuple/tuple.dart';

import '../../bloc/store_submission_bloc.dart';

class SearchFieldControl extends StatefulWidget {
  const SearchFieldControl(
      {super.key, required this.field, this.readOnly = false});

  static Key getSearchButtonKey(String fieldId) {
    return Key('SearchFieldControl_SearchBtn_$fieldId');
  }

  static Key getClearButtonKey(String fieldId) {
    return Key('SearchFieldControl_ClearBtn_$fieldId');
  }

  final StoreSubmissionField field;
  final bool readOnly;

  @override
  State<SearchFieldControl> createState() => _SearchFieldControlState();
}

class _SearchFieldControlState extends State<SearchFieldControl> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (widget.field.result.isEmpty) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
            key: SearchFieldControl.getSearchButtonKey(widget.field.fieldId),
            icon: const Icon(Icons.add),
            label: Text(l10n.addItem(l10n.product.toLowerCase())),
            onPressed: !widget.readOnly && widget.field.itemType != null
                ? () async {
                    final bloc = context.read<StoreSubmissionBloc>();

                    switch (widget.field.itemType!) {
                      case SubmissionFieldItemType.products:
                        final result = await Navigator.of(context).push(
                            SearchProductPage.route(
                                productRepository:
                                    RepositoryProvider.of<ProductRepository>(
                                        context)));

                        if (result?.isNotEmpty == true) {
                          bloc.add(StoreSubmissionFieldResultEvent(
                              stepId: widget.field.stepId,
                              fieldId: widget.field.fieldId,
                              result: StoreSubmissionFieldResult(
                                item:
                                    Tuple2(result!.first.id, result.first.name),
                              )));
                          textController.text = result.first.name;
                        }
                        break;
                    }
                  }
                : null),
      );
    }

    return TextField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: widget.field.label,
        suffixIcon: !widget.readOnly
            ? IconButton(
                key: SearchFieldControl.getClearButtonKey(widget.field.fieldId),
                icon: const Icon(Icons.cancel_outlined),
                onPressed: () {
                  context.read<StoreSubmissionBloc>().add(
                      StoreSubmissionFieldResultEvent(
                          stepId: widget.field.stepId,
                          fieldId: widget.field.fieldId,
                          result: StoreSubmissionFieldResult()));
                  textController.text = '';
                },
              )
            : null,
      ),
      controller: textController,
      focusNode: _AlwaysDisabledFocusNode(),
      readOnly: true,
    );
  }
}

class _AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
