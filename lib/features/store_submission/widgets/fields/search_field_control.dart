import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/features/search_items/search_items.dart';
import 'package:pondrop/features/styles/styles.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:tuple/tuple.dart';

import '../../bloc/store_submission_bloc.dart';

class SearchFieldControl extends StatelessWidget {
  const SearchFieldControl(
      {super.key, required this.field, this.readOnly = false});

  static Key getSearchButtonKey(String fieldId) {
    return Key('SearchFieldControl_SearchBtn_$fieldId');
  }

  static Key getClearButtonKey(String fieldId, String itemId) {
    return Key('SearchFieldControl_ClearBtn_${fieldId}_${itemId}');
  }

  final StoreSubmissionField field;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final children = <Widget>[];

    for (final i in field.results.where((e) => !e.isEmpty)) {
      children.add(TextFormField(
        key: Key('SearchFieldControl_Txt_${field.fieldId}_${i.item!.item1}'),
        initialValue: i.item?.item2 ?? '',
        maxLines: 3,
        minLines: 1,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: field.label,
          suffixIcon: !readOnly
              ? IconButton(
                  key: SearchFieldControl.getClearButtonKey(
                      field.fieldId, i.item!.item1),
                  icon: const Icon(Icons.cancel_outlined),
                  onPressed: () {
                    context.read<StoreSubmissionBloc>().add(
                        StoreSubmissionFieldResultEvent(
                            stepId: field.stepId,
                            fieldId: field.fieldId,
                            result: StoreSubmissionFieldResult(),
                            resultIdx: field.results.indexOf(i)));
                  },
                )
              : null,
        ),
        focusNode: _AlwaysDisabledFocusNode(),
        readOnly: true,
      ));

      children.add(const SizedBox(
        height: Dims.medium,
      ));
    }

    if (children.isNotEmpty) {
      children.removeLast();
    }

    if (field.results.where((e) => !e.isEmpty).length < (field.maxValue ?? 1)) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(
          height: Dims.small,
        ));
      }

      children.add(SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
            key: SearchFieldControl.getSearchButtonKey(field.fieldId),
            icon: const Icon(Icons.add),
            label: Text(l10n.addItem(l10n.product.toLowerCase())),
            onPressed: !readOnly && field.itemType != null
                ? () async {
                    final bloc = context.read<StoreSubmissionBloc>();

                    final result = await Navigator.of(context).push(
                        SearchItemPage.route(
                            type: field.itemType!.toSearchItemType(),
                            excludeIds: field.results
                                .where((e) => e.item != null)
                                .map((e) => e.item!.item1)
                                .toList(),
                            categoryRepository:
                                RepositoryProvider.of<CategoryRepository>(
                                    context),
                            productRepository:
                                RepositoryProvider.of<ProductRepository>(
                                    context)));

                    if (result?.isNotEmpty == true) {
                      bloc.add(StoreSubmissionFieldResultEvent(
                          stepId: field.stepId,
                          fieldId: field.fieldId,
                          result: StoreSubmissionFieldResult(
                            item: Tuple2(result!.first.id, result.first.title),
                          ),
                          resultIdx: field.results.length == 1 && field.results.first.isEmpty ? 0 : (field.maxValue ?? 0) + 1));
                    }
                  }
                : null),
      ));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

class _AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
